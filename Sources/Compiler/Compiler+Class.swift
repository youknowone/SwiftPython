import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_parameter_count
// swiftlint:disable function_body_length

extension Compiler {

  /// compiler_class(struct compiler *c, stmt_ty s)
  ///
  /// Ultimately generate code for:
  /// ```
  /// <name> = __build_class__(<func>, <name>, *<bases>, **<keywords>)
  /// ```
  /// where:
  /// - `<func>` is a function/closure created from the class body;
  ///        it has a single argument (\_\_locals\_\_) where the dict
  ///        (or MutableSequence) representing the locals is passed
  /// - `<name>` is the class name
  /// - `<bases>` is the positional arguments and *varargs argument
  /// - `<keywords>` is the keyword arguments and **kwds argument
  internal func visitClassDef(name: String,
                              bases: [Expression],
                              keywords: [Keyword],
                              body: NonEmptyArray<Statement>,
                              decorators: [Expression],
                              statement:  Statement) throws {

    let location = statement.start
    try self.visitDecorators(decorators: decorators, location: location)

    // 1. compile the class body into a code object
    let codeObject = try self.inNewCodeObject(node: statement, type: .class) {
      // load (global) __name__
      let __name__ = SpecialIdentifiers.__name__
      try self.codeObject.appendString(__name__, at: location)

      // ... and store it as __module__
      let __module__ = SpecialIdentifiers.__module__
      try self.codeObject.appendStoreName(__module__, at: location)

      let __qualname__ = SpecialIdentifiers.__qualname__
      let qualifiedName = self.codeObject.qualifiedName
      try self.codeObject.appendString(qualifiedName, at: location)
      try self.codeObject.appendStoreName(__qualname__, at: location)

      try self.visitStatements(body)

      // Return __class__ cell if it is referenced, otherwise return None
      if self.currentScope.needsClassClosure {
        let __class__ = MangledName(from: SpecialIdentifiers.__class__)
        let __classcell__ = SpecialIdentifiers.__classcell__

        // Store __classcell__ into class namespace & return it
        try self.codeObject.appendLoadClosure(.cell(__class__), at: location)
        try self.codeObject.appendDupTop(at: location)
        try self.codeObject.appendStoreName(__classcell__, at: location)
      } else {
        assert(self.codeObject.cellVars.isEmpty)
        try self.codeObject.appendNone(at: location)
      }

      try self.codeObject.appendReturn(at: location)
    }

    // 2. load the 'build_class' function
    try self.codeObject.appendLoadBuildClass(at: location)
    // 3. load a function (or closure) made from the code object
    try self.makeClosure(codeObject: codeObject, flags: [], location: location)
    // 4. load class name
    try self.codeObject.appendString(name, at: location)
    // 5. generate the rest of the code for the call
    try self.callHelper(args: bases,
                        keywords: keywords,
                        context: .load,
                        alreadyPushedArgs: 2,
                        location: location)
    // 6. apply decorators
    for _ in decorators {
      try self.codeObject.appendCallFunction(argumentCount: 1, at: location)
    }
    // 7. store into <name>
    try self.codeObject.appendStoreName(name, at: location)
  }
}