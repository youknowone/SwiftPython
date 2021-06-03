import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable file_length
// cSpell:ignore dictbytype ssize fblock fblocktype basicblock

public final class Compiler {

  private let impl: CompilerImpl

  public init(filename: String,
              ast: AST,
              options: CompilerOptions,
              delegate: CompilerDelegate?) {
    self.impl = CompilerImpl(filename: filename,
                             ast: ast,
                             options: options,
                             delegate: delegate)
  }

  public func run() throws -> CodeObject {
    return try self.impl.run()
  }
}

/// Compiler implementation.
/// See module documentation for details.
internal final class CompilerImpl: ASTVisitor, StatementVisitor, ExpressionVisitor {

  internal typealias ASTResult = Void
  internal typealias StatementResult = Void
  internal typealias ExpressionResult = Void

  /// Program that we are compiling.
  private let ast: AST
  /// Name of the file that this code object was loaded from.
  internal let filename: String
  /// Compilation options.
  internal let options: CompilerOptions

  internal weak var delegate: CompilerDelegate?

  /// We have to scan `__future__` (as weird as it sounds), to block any
  /// potential `__future__` imports that occur later in file.
  internal private(set) var future: FutureFeatures!
  // swiftlint:disable:previous implicitly_unwrapped_optional

  /// Symbol table associated with `self.ast`.
  internal private(set) var symbolTable: SymbolTable!
  // swiftlint:disable:previous implicitly_unwrapped_optional

  /// Compiler unit stack.
  /// Current unit (the one that we are emitting to) is at the top,
  /// module unit is at the bottom.
  ///
  /// For example:
  /// ```c
  /// class Frozen:
  ///   def elsa():
  ///     pass <- we are emitting here
  /// ```
  /// Generates following stack:
  /// module -> class -> elsa
  private var unitStack = [CompilerUnit]()

  /// Code object builder for `self.codeObject`.
  internal var builder: CodeObjectBuilder {
    if let last = self.unitStack.last { return last.builder }
    trap("[BUG] Compiler: Using `builder` with empty `unitStack`.")
  }

  /// Scope that we are currently filling.
  internal var currentScope: SymbolScope {
    if let last = self.unitStack.last { return last.scope }
    trap("[BUG] Compiler: Using `currentScope` with empty `unitStack`.")
  }

  /// How far are we inside module/class/function scopes.
  internal var nestLevel: Int {
    return self.unitStack.count
  }

  /// True if in interactive mode (REPL)
  internal var isInteractive: Bool {
    return self.ast is InteractiveAST
  }

  /// Stack of blocks (loop, except, finallyTry, finallyEnd)
  /// that current statement is surrounded with.
  internal var blockStack = [BlockType]()
  /// Does the current statement is inside of the loop?
  internal var isInLoop: Bool {
    return self.blockStack.contains { $0.isLoop }
  }

  fileprivate init(filename: String,
                   ast: AST,
                   options: CompilerOptions,
                   delegate: CompilerDelegate?) {
    self.ast = ast
    self.filename = filename
    self.options = options
    self.delegate = delegate
  }

  // MARK: - Run

  /// PyAST_CompileObject(mod_ty mod, PyObject *filename, PyCompilerFlags ...)
  /// compiler_mod(struct compiler *c, mod_ty mod)
  internal func run() throws -> CodeObject {
    // Collect all symbols from AST
    let symbolTableBuilder = SymbolTableBuilder(delegate: self.delegate)
    self.symbolTable = try symbolTableBuilder.visit(ast: self.ast)

    // Get all of the future flags that can affect compilation
    self.future = try FutureFeatures.parse(ast: self.ast)

    // Compile (duh…)
    let codeObject = try self.inNewCodeObject(node: self.ast, kind: .module) {
      try self.visit(self.ast)

      // Epilog (because we may be a jump target).
      let isExpression = self.ast is ExpressionAST
      try self.appendReturn(addNone: !isExpression)
    }

    assert(self.unitStack.isEmpty)
    return codeObject
  }

  // MARK: - Visit

  internal func visit(_ node: AST) throws {
    self.setAppendLocation(node)
    try node.accept(self)
  }

  internal func visit(_ node: InteractiveAST) throws {
    // We cannot use 'visitBody' because we do not want '__doc__'.
    self.setupAnnotationsIfNeeded(statements: node.statements)
    try self.visit(node.statements)
  }

  internal func visit(_ node: ModuleAST) throws {
    try self.visitBody(body: node.statements, onDoc: .storeAs__doc__)
  }

  internal func visit(_ node: ExpressionAST) throws {
    try self.visit(node.expression)
  }

  // MARK: - Visit body

  /// What to do when we have doc?
  internal enum DocHandling {
    /// Emit `appendString` and then `appendStoreName(__doc__)`.
    case storeAs__doc__
    /// Simply add new constant, without emitting any instruction.
    case appendToConstants
  }

  /// Compile a sequence of statements, checking for a docstring
  /// and for annotations.
  ///
  /// compiler_body(struct compiler *c, asdl_seq *stmts)
  internal func visitBody<C: Collection>(
    body: C,
    onDoc: DocHandling
  ) throws where C.Element == Statement {
    guard let first = body.first else {
      return
    }

    self.setupAnnotationsIfNeeded(statements: body)

    if let doc = first.getDocString(), self.options.optimizationLevel < .OO {
      switch onDoc {
      case .storeAs__doc__:
        self.builder.appendString(doc)
        self.builder.appendStoreName(SpecialIdentifiers.__doc__)
      case .appendToConstants:
        self.builder.addConstant(string: doc)
      }

      try self.visit(body.dropFirst())
    } else {
      try self.visit(body)
    }
  }

  // MARK: - Annotations

  private func setupAnnotationsIfNeeded<C: Collection>(
    statements: C
  ) where C.Element == Statement {
    if self.hasAnnotations(statements: statements) {
      self.builder.appendSetupAnnotations()
    }
  }

  /// Search if variable annotations are present statically in a block.
  ///
  /// find_ann(asdl_seq *stmts)
  private func hasAnnotations<S: Sequence>(statements: S) -> Bool
    where S.Element == Statement {

    return statements.contains(where: self.hasAnnotations(statement:))
  }

  /// Search if variable annotations are present statically in a block.
  ///
  /// find_ann(asdl_seq *stmts)
  private func hasAnnotations(statement: Statement) -> Bool {
    if statement is AnnAssignStmt {
      return true
    }

    if let loop = statement as? ForStmt {
      return self.hasAnnotations(statements: loop.body)
          || self.hasAnnotations(statements: loop.orElse)
    }

    if let loop = statement as? AsyncForStmt {
      return self.hasAnnotations(statements: loop.body)
          || self.hasAnnotations(statements: loop.orElse)
    }

    if let loop = statement as? WhileStmt {
      return self.hasAnnotations(statements: loop.body)
          || self.hasAnnotations(statements: loop.orElse)
    }

    if let if_ = statement as? IfStmt {
      return self.hasAnnotations(statements: if_.body)
          || self.hasAnnotations(statements: if_.orElse)
    }

    if let with = statement as? WithStmt {
      return self.hasAnnotations(statements: with.body)
    }

    if let with = statement as? AsyncWithStmt {
      return self.hasAnnotations(statements: with.body)
    }

    if let try_ = statement as? TryStmt {
      return self.hasAnnotations(statements: try_.body)
          || self.hasAnnotations(statements: try_.finally)
          || self.hasAnnotations(statements: try_.orElse)
          || try_.handlers.contains { self.hasAnnotations(statements: $0.body) }
    }

    return false
  }

  // MARK: - Creating code objects

  /// Helper for creation of new code objects.
  /// It surrounds given `block` with `enterScope` and `leaveScope`
  /// (1 scope = 1 code object).
  /// Use `self.codeObject` to emit instructions.
  internal func inNewCodeObject<N: ASTNode>(
    node: N,
    kind: CodeObject.Kind,
    emitInstructions block: () throws -> Void
  ) throws -> CodeObject {
    return try self.inNewCodeObject(
      node: node,
      kind: kind,
      argCount: 0,
      kwOnlyArgCount: 0,
      emitInstructions: block
    )
  }

  /// Helper for creation of new code objects.
  /// It surrounds given `block` with `enterScope` and `leaveScope`
  /// (1 scope = 1 code object).
  /// Use `self.codeObject` to emit instructions.
  internal func inNewCodeObject<N: ASTNode>(
    node: N,
    kind: CodeObject.Kind,
    argCount: Int,
    kwOnlyArgCount: Int,
    emitInstructions block: () throws -> Void
  ) throws -> CodeObject {
    self.enterScope(node: node,
                    kind: kind,
                    argCount: argCount,
                    kwOnlyArgCount: kwOnlyArgCount)

    try block()
    let code = self.builder.finalize()
    try self.leaveScope()

    return code
  }

  // swiftlint:disable function_body_length

  /// Push new scope (and generate a new code object to emit to).
  ///
  /// compiler_enter_scope(struct compiler *c, identifier name, ...)
  private func enterScope<N: ASTNode>(node: N,
                                      kind: CodeObject.Kind,
                                      argCount: Int,
                                      kwOnlyArgCount: Int) {
    // swiftlint:enable function_body_length

    guard let scope = self.symbolTable.scopeByNode[node] else {
      trap("[BUG] Compiler: Entering scope that is not present in symbol table.")
    }

    assert(self.hasKind(scope: scope, kind: kind))

    let name = self.createName(scope: scope, kind: kind)
    let qualifiedName = self.createQualifiedName(name: name, kind: kind)
    let flags = self.createFlags(scope: scope, kind: kind)

    // In 'variableNames' we have to put parameters before locals.
    let paramNames = self.filterSymbols(scope, accepting: .defParam)
    let localNames = self.filterSymbols(scope,
                                        accepting: .srcLocal,
                                        skipping: .defParam,
                                        sorted: true)
    let variableNames = paramNames + localNames
    assert(paramNames == scope.parameterNames)

    let freeFlags: SymbolFlags = [.srcFree, .defFreeClass]
    let freeVars = self.filterSymbols(scope, accepting: freeFlags, sorted: true)
    var cellVars = self.filterSymbols(scope, accepting: .cell, sorted: true)

    // Append implicit `__class__` cell.
    if scope.needsClassClosure {
      assert(scope.type == .class) // needsClassClosure can only be set on class
      cellVars.append(MangledName(withoutClass: SpecialIdentifiers.__class__))
    }

    let builder = CodeObjectBuilder(name: name,
                                    qualifiedName: qualifiedName,
                                    filename: self.filename,
                                    kind: kind,
                                    flags: flags,
                                    variableNames: variableNames,
                                    freeVariableNames: freeVars,
                                    cellVariableNames: cellVars,
                                    argCount: argCount,
                                    kwOnlyArgCount: kwOnlyArgCount,
                                    firstLine: node.start.line)

    let className = kind == .class ? name : nil
    let unit = CompilerUnit(className: className, scope: scope, builder: builder)
    self.unitStack.append(unit)
  }

  /// Pop scope (along with corresponding code object).
  ///
  /// compiler_exit_scope(struct compiler *c)
  private func leaveScope() throws {
    let unit = self.unitStack.popLast()
    if unit == nil {
      trap("[BUG] Compiler: Attempting to pop non-existing unit.")
    }
  }

  // MARK: - Scope/builder helpers

  private func hasKind(scope: SymbolScope, kind: CodeObject.Kind) -> Bool {
    switch scope.type {
    case .module:
      return kind == .module
    case .class:
      return kind == .class
    case .function:
      return kind == .function
        || kind == .asyncFunction
        || kind == .lambda
        || kind == .comprehension
    }
  }

  /// Crate CodeObject name
  private func createName(scope: SymbolScope, kind: CodeObject.Kind) -> String {
    switch kind {
    case .module:
      return CodeObject.moduleName
    case .lambda:
      return CodeObject.lambdaName
    case .comprehension:
      return scope.name
    case .class,
         .function,
         .asyncFunction:
      return scope.name
    }
  }

  /// compiler_set_qualname(struct compiler *c)
  ///
  /// Special case:
  /// ```
  /// def elsa(): print('elsa')
  ///
  /// def redefine_elsa():
  ///   global elsa
  ///   def elsa(): print('anna') <- qualified name: elsa
  ///
  /// elsa() # prints 'elsa'
  /// redefine_elsa()
  /// elsa() # prints 'anna'
  /// ```
  /// - Note:
  /// It has to be called BEFORE code object is pushed on stack!
  /// (which is different than CPython)
  private func createQualifiedName(name: String, kind: CodeObject.Kind) -> String {
    // Top scope has "" as qualified name.
    guard let parentUnit = self.unitStack.last else {
      return ""
    }

    let isTopLevel = self.unitStack.count == 1
    if isTopLevel {
      return name
    }

    /// Is this a special case? (see docstring)
    let isGlobalNestedInOtherScope: Bool = {
      guard kind == .function || kind == .asyncFunction || kind == .class else {
        return false
      }

      let mangled = MangledName(className: parentUnit.className, name: name)
      let info = parentUnit.scope.symbols[mangled]
      return info?.flags.contains(.srcGlobalExplicit) ?? false
    }()

    if isGlobalNestedInOtherScope {
      return name
    }

    /// Otherwise just concat to parent
    let parentKind = parentUnit.builder.kind
    let isParentFunction = parentKind == .function
                        || parentKind == .asyncFunction
                        || parentKind == .lambda

    let locals = isParentFunction ? ".<locals>" : ""
    let parentQualifiedName = parentUnit.builder.qualifiedName
    return parentQualifiedName + locals + "." + name
  }

  /// dictbytype(PyObject *src, int scope_type, int flag, Py_ssize_t offset)
  ///
  /// If the symbol contains any of the given flags add it to result.
  ///
  /// Sort the keys so that we have a deterministic order on the indexes
  /// saved in the returned dictionary.
  private func filterSymbols(
    _ scope: SymbolScope,
    accepting: SymbolFlags,
    skipping: SymbolFlags = [],
    sorted: Bool = false
  ) -> [MangledName] {
    let symbols: [SymbolByNameDictionary.Element] = {
      guard sorted else {
        return Array(scope.symbols)
      }

      return scope.symbols.sorted { lhs, rhs in
        let lhsName = lhs.key
        let rhsName = rhs.key
        return lhsName.value < rhsName.value
      }
    }()

    var result = [MangledName]()
    for (name, info) in symbols {
      let isAccepted = info.flags.contains(anyOf: accepting)
      let isSkipped = info.flags.contains(anyOf: skipping)

      if isAccepted && !isSkipped {
        result.append(name)
      }
    }

    return result
  }

  /// static int
  /// compute_code_flags(struct compiler *c)
  private func createFlags(scope: SymbolScope,
                           kind: CodeObject.Kind) -> CodeObject.Flags {
    var result = CodeObject.Flags()

    if scope.type == .function {
      result.formUnion(.newLocals)
      result.formUnion(.optimized)

      if scope.isNested {
        result.formUnion(.nested)
      }

      switch (scope.isGenerator, scope.isCoroutine) {
      case (true, true): result.formUnion(.asyncGenerator)
      case (true, false): result.formUnion(.generator)
      case (false, true): result.formUnion(.coroutine)
      case (false, false): break
      }

      if scope.hasVarargs {
        result.formUnion(.varArgs)
      }

      if scope.hasVarKeywords {
        result.formUnion(.varKeywords)
      }
    }

    // CPython will also copy 'self.future' flags, we don't need them (for now).
    return result
  }

  // MARK: - Block

  /// Push block, execute `body` and then pop block.
  internal func inBlock(_ type: BlockType, body: () throws -> Void) rethrows {
    self.pushBlock(type)
    defer { popBlock() }

    try body()
  }

  /// compiler_push_fblock(struct compiler *c, enum fblocktype t, basicblock *b)
  private func pushBlock(_ type: BlockType) {
    self.blockStack.push(type)
  }

  /// compiler_pop_fblock(struct compiler *c, enum fblocktype t, basicblock *b)
  private func popBlock() {
    assert(self.blockStack.any)
    _ = self.blockStack.popLast()
  }

  // MARK: - Return

  /// Append return at the end of the scope.
  internal func appendReturn(addNone: Bool) throws {
    // If we already have 'return' and no jumps then we do not need
    // to add another 'return'.
    // We will not check all of the instructions for 'return' (because that
    // would be slow), we will just take 10 last.
    let hasReturn = self.builder.instructions
      .takeLast(10)
      .contains(where: self.isReturn(instruction:))
    let hasNoJumps = self.builder.labels.isEmpty

    if hasReturn && hasNoJumps {
      return
    }

    if addNone {
      self.builder.appendNone()
    }
    self.builder.appendReturn()
  }

  private func isReturn(instruction: Instruction) -> Bool {
    switch instruction {
    case .return:
      return true
    default:
      return false
    }
  }

  // MARK: - Mangle

  internal func mangle(name: String) -> MangledName {
    let unit = self.unitStack.last { $0.className != nil }
    return MangledName(className: unit?.className, name: name)
  }

  // MARK: - Append location

  private var appendLocation = SourceLocation.start

  /// Set location on which next `append` occurs.
  ///
  /// Called before entering:
  /// - AST
  /// - Expression
  /// - Statement
  /// - Alias
  /// - ExceptHandler
  internal func setAppendLocation<N: ASTNode>(_ node: N) {
    self.appendLocation = node.start
    for unit in self.unitStack {
      unit.builder.setAppendLocation(self.appendLocation)
    }
  }

  // MARK: - Error/warning

  /// Report compiler warning
  internal func warn(_ kind: CompilerWarningKind) {
    let warning = CompilerWarning(kind, location: self.appendLocation)
    self.delegate?.warn(warning: warning)
  }

  /// Create compiler error
  internal func error(_ kind: CompilerErrorKind) -> CompilerError {
    return CompilerError(kind, location: self.appendLocation)
  }
}
