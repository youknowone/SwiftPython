import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_stmt(struct compiling *c, const node *n)

extension Parser {

  /// `suite: simple_stmt | NEWLINE INDENT stmt+ DEDENT`
  internal mutating func suite(closingTokens: [TokenKind])
    throws -> NonEmptyArray<Statement> {

    // TODO: suite - finish
    if self.peek.kind == .newLine {
      throw self.unimplemented()
    }

    let stmt = try self.smallStmt(closingTokens: closingTokens)
    return NonEmptyArray(first: stmt)
  }

  /// ```c
  /// compound_stmt: if_stmt   | while_stmt | for_stmt |
  ///                try_stmt  | with_stmt  | async_stmt
  ///                funcdef   | classdef   |
  ///                decorated
  /// ```
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal mutating func compoundStmtOrNop(closingTokens: [TokenKind])
    throws -> Statement? {

    switch self.peek.kind {
    case .if:
      return try self.ifStmt(closingTokens: closingTokens)
    case .while:
      break
    case .for:
      break

    // MARK: - try, with, async

    case .try:
      break
    case .with:
      break
    case .async:
      break

    // MARK: - Func | Class
    // MARK: - Decorated

    default:
      break
    }
    return nil
  }

  // MARK: if

  /// Intermediate representation for if/elif.
  private struct IfIR {
    fileprivate let start: SourceLocation
    fileprivate let test:  Expression
    fileprivate let body:  NonEmptyArray<Statement>
  }

  /// ```c
  /// if_stmt:
  ///   'if' test ':' suite
  ///   ('elif' test ':' suite)*
  ///   ['else' ':' suite]
  /// ```
  internal mutating func ifStmt(closingTokens: [TokenKind]) throws -> Statement {
    assert(self.peek.kind == .if)

    var bodyClosing = closingTokens
    bodyClosing.append(contentsOf: [.elif, .else])

    let start = self.peek.start
    try self.advance() // if
    let test = try self.test()
    try self.consumeOrThrow(.colon)
    let body = try self.suite(closingTokens: bodyClosing)

    let first = IfIR(start: start, test: test, body: body)
    var irs = NonEmptyArray<IfIR>(first: first)

    while self.peek.kind == .elif {
      let start = self.peek.start
      try self.advance() // elif
      let test = try self.test()
      try self.consumeOrThrow(.colon)
      let body = try self.suite(closingTokens: bodyClosing)
      irs.append(IfIR(start: start, test: test, body: body))
    }

    var orElse: NonEmptyArray<Statement>?
    if self.peek.kind == .else {
      try self.advance() // else
      try self.consumeOrThrow(.colon)
      orElse = try self.suite(closingTokens: closingTokens)
    }

    return self.compile(irs: irs, orElse: orElse)
  }

  private func compile(irs: NonEmptyArray<IfIR>,
                       orElse: NonEmptyArray<Statement>?) -> Statement {

    var result: Statement?
    var pendingElse = orElse.map { Array($0) } ?? []

    for ir in irs.reversed() {
      let kind = StatementKind.if(test: ir.test,
                                  body: Array(ir.body),
                                  orElse: pendingElse)

      let end = pendingElse.last?.end ?? ir.body.last.end
      let statement = self.statement(kind, start: ir.start, end: end)
      result = statement
      pendingElse = [statement]
    }

    // We know that result is not nil beacuse of NonEmptyArray
    assert(result != nil)
    return result! // swiftlint:disable:this force_unwrapping
  }

  /// `while_stmt: 'while' test ':' suite ['else' ':' suite]`
  /// `for_stmt: 'for' exprlist 'in' testlist ':' suite ['else' ':' suite]`
}
