import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length
// TODO: ^ Remove this

extension Compiler {

  // MARK: - Raise

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visitRaise(exception: Expression?, cause: Expression?) throws {
    var arg = RaiseArg.reRaise
    if let exc = exception {
      try self.visitExpression(exc)
      arg = .exceptionOnly

      if let c = cause {
        try self.visitExpression(c)
        arg = .exceptionAndCause
      }
    }

    self.builder.appendRaiseVarargs(arg: arg)
  }

  // MARK: - Try

  internal func visitTry(body: NonEmptyArray<Statement>,
                         handlers: [ExceptHandler],
                         orElse:   [Statement],
                         finally:  [Statement]) throws {
    if finally.any {
      try self.visitTryFinally(body: body,
                               handlers: handlers,
                               orElse: orElse,
                               finally: finally)
    } else {
      try self.visitTryExcept(body: body, handlers: handlers, orElse: orElse)
    }
  }

  ///compiler_try_finally(struct compiler *c, stmt_ty s)
  ///
  /// Code generated for "try: <body> finally: <finalbody>" is as follows:
  ///
  ///       SETUP_FINALLY           Label
  ///       <code for body>
  ///       POP_BLOCK
  ///       LOAD_CONST              <None>
  ///   Label:   <code for finalbody>
  ///       END_FINALLY
  ///
  /// SETUP_FINALLY:
  ///   Pushes the current value stack level and the label
  ///   onto the block stack.
  /// POP_BLOCK:
  ///   Pops en entry from the block stack, and pops the value
  ///   stack until its level is the same as indicated on the
  ///   block stack.  (The label is ignored.)
  /// END_FINALLY:
  ///   Pops a variable number of entries from the *value* stack
  ///   and re-raises the exception they specify.  The number of
  ///   entries popped depends on the (pseudo) exception type.
  ///
  ///   The block stack is unwound when an exception is raised:
  ///   when a SETUP_FINALLY entry is found, the exception is pushed
  ///   onto the value stack (and the exception condition is cleared),
  ///   and the interpreter jumps to the label gotten from the block
  ///   stack.
  private func visitTryFinally(body: NonEmptyArray<Statement>,
                               handlers: [ExceptHandler],
                               orElse:   [Statement],
                               finally:  [Statement]) throws {
    let finallyStart = self.builder.createLabel()

    // body
    self.builder.appendSetupFinally(finallyStart: finallyStart)
    try self.inBlock(.finallyTry) {
      if handlers.any {
        try self.visitTryExcept(body: body, handlers: handlers, orElse: orElse)
      } else {
        try self.visitStatements(body)
      }

      self.builder.appendPopBlock()
    }

    self.builder.appendNone()

    // finally
    self.builder.setLabel(finallyStart)
    try self.inBlock(.finallyEnd) {
      try self.visitStatements(finally)
      self.builder.appendEndFinally()
    }
  }

  /// compiler_try_except(struct compiler *c, stmt_ty s)
  ///
  /// Code generated for "try: S except E1 as V1: S1 except E2 as V2: S2 ...":
  /// (The contents of the value stack is shown in [], with the top
  /// at the right; 'tb' is trace-back info, 'val' the exception's
  /// associated value, and 'exc' the exception.)
  ///
  /// Value stack          Label   Instruction     Argument
  /// []                           SETUP_EXCEPT    L1
  /// []                           <code for S>
  /// []                           POP_BLOCK
  /// []                           JUMP_FORWARD    L0
  ///
  /// [tb, val, exc]       L1:     DUP                             )
  /// [tb, val, exc, exc]          <evaluate E1>                   )
  /// [tb, val, exc, exc, E1]      COMPARE_OP      EXC_MATCH       ) only if E1
  /// [tb, val, exc, 1-or-0]       POP_JUMP_IF_FALSE       L2      )
  /// [tb, val, exc]               POP
  /// [tb, val]                    <assign to V1>  (or POP if no V1)
  /// [tb]                         POP
  /// []                           <code for S1>
  ///                             JUMP_FORWARD    L0
  ///
  /// [tb, val, exc]       L2:     DUP
  /// .............................etc.......................
  ///
  /// [tb, val, exc]       Ln+1:   END_FINALLY     # re-raise exception
  ///
  /// []                   L0:     <next statement>
  ///
  /// Of course, parts are not generated if Vi or Ei is not present.
  private func visitTryExcept(body: NonEmptyArray<Statement>,
                              handlers: [ExceptHandler],
                              orElse:   [Statement]) throws {
    let firstExcept = self.builder.createLabel()
    let orElseStart = self.builder.createLabel()
    let end = self.builder.createLabel()

    // body
    self.builder.appendSetupExcept(firstExcept: firstExcept)
    try self.inBlock(.except) {
      try self.visitStatements(body)
      self.builder.appendPopBlock()
    }
    // if no exception happened then go to 'orElse'
    self.builder.appendJumpAbsolute(to: orElseStart)

    // except
    self.builder.setLabel(firstExcept)
    for (index, handler) in handlers.enumerated() {
      let isLast = index == handlers.count - 1
      if handler.kind == .default && !isLast {
        throw self.error(.defaultExceptNotLast)
      }

      self.setAppendLocation(handler)
      let nextExcept = self.builder.createLabel()

      if case let .typed(type: type, asName: _) = handler.kind {
        self.builder.appendDupTop()
        try self.visitExpression(type)
        self.builder.appendCompareOp(.exceptionMatch)
        self.builder.appendPopJumpIfFalse(to: nextExcept)
      }
      self.builder.appendPopTop()

      if case let .typed(type: _, asName: asName) = handler.kind, let name = asName {
        self.builder.appendStoreName(name)
        self.builder.appendPopTop()

        // try:
        //     # body
        // except type as name:
        //     try:
        //         # body
        //     finally:
        //         name = None
        //         del name

        // second try:
        let cleanupEnd = self.builder.createLabel()
        self.builder.appendSetupFinally(finallyStart: cleanupEnd)
        try self.inBlock(.finallyTry) {
          try self.visitStatements(handler.body)
          self.builder.appendPopBlock()
        }

        // finally:
        self.builder.appendNone()
        self.builder.setLabel(cleanupEnd)

        self.inBlock(.finallyEnd) {
          // name = None
          self.builder.appendNone()
          self.builder.appendStoreName(name)
          // del name
          self.builder.appendDeleteName(name)
          // cleanup
          self.builder.appendEndFinally()
          self.builder.appendPopExcept()
        }
      } else {
        self.builder.appendPopTop()
        self.builder.appendPopTop()

        try self.inBlock(.finallyTry) {
          try self.visitStatements(handler.body)
          self.builder.appendPopExcept()
        }
      }

      self.builder.appendJumpAbsolute(to: end)
      self.builder.setLabel(nextExcept)
    }

    self.builder.appendEndFinally()
    self.builder.setLabel(orElseStart)
    try self.visitStatements(orElse)
    self.builder.setLabel(end)
  }
}
