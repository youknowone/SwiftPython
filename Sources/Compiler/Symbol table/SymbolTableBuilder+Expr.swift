import Core
import Parser

// In CPython:
// Python -> symtable.c

// swiftlint:disable file_length

extension SymbolTableBuilderImpl {

  internal func visit(_ node: Expression) throws {
    try node.accept(self)
  }

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  internal func visit(_ node: Expression?) throws {
    if let n = node {
      try self.visit(n)
    }
  }

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  internal func visit<S: Sequence>(_ nodes: S) throws
    where S.Element == Expression {

    for n in nodes {
      try self.visit(n)
    }
  }

  // MARK: - General

  internal func visit(_ node: NoneExpr) throws { }
  internal func visit(_ node: EllipsisExpr) throws { }

  // MARK: - Bool

  internal func visit(_ node: TrueExpr) throws { }
  internal func visit(_ node: FalseExpr) throws { }

  // MARK: - Identifier

  internal func visit(_ node: IdentifierExpr) throws {
    let flags = node.context == .store ?
      SymbolFlags.defLocal :
      SymbolFlags.use

    try self.addSymbol(node.value, flags: flags, location: node.start)

    let isSuper = self.currentScope.type == .function && node.value == "super"
    if node.context == .load && isSuper {
      let name = SpecialIdentifiers.__class__
      try self.addSymbol(name, flags: .use, location: node.start)
    }
  }

  // MARK: - Numbers

  internal func visit(_ node: IntExpr) throws { }
  internal func visit(_ node: FloatExpr) throws { }
  internal func visit(_ node: ComplexExpr) throws { }

  // MARK: - String

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  internal func visit(_ node: StringExpr) throws {
    try self.visit(node.value)
  }

  private func visit(_ group: StringGroup) throws {
    switch group {
    case .literal:
      break
    case let .formattedValue(expr, _, _):
      try self.visit(expr)
    case let .joined(groups):
      for g in groups {
        try self.visit(g)
      }
    }
  }

  internal func visit(_ node: BytesExpr) throws { }

  // MARK: - Operators

  internal func visit(_ node: UnaryOpExpr) throws {
    try self.visit(node.right)
  }

  internal func visit(_ node: BinaryOpExpr) throws {
    try self.visit(node.left)
    try self.visit(node.right)
  }

  internal func visit(_ node: BoolOpExpr) throws {
    try self.visit(node.left)
    try self.visit(node.right)
  }

  // MARK: - Compare

  internal func visit(_ node: CompareExpr) throws {
    try self.visit(node.left)
    try self.visit(node.elements)
  }

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  private func visit(_ elements: NonEmptyArray<ComparisonElement>) throws {
    for e in elements {
      try self.visit(e.right)
    }
  }

  // MARK: - Collections

  internal func visit(_ node: TupleExpr) throws {
    try self.visit(node.elements)
  }

  internal func visit(_ node: ListExpr) throws {
    try self.visit(node.elements)
  }

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  internal func visit(_ node: DictionaryExpr) throws {
    for e in node.elements {
      switch e {
      case let .unpacking(expr):
        try self.visit(expr)
      case let .keyValue(key, value):
        try self.visit(key)
        try self.visit(value)
      }
    }
  }

  internal func visit(_ node: SetExpr) throws {
    try self.visit(node.elements)
  }

  // MARK: - Comprehension

  internal func visit(_ node: ListComprehensionExpr) throws {
    try self.visitComprehension(elt: node.element,
                                value: nil,
                                generators: node.generators,
                                expr: node,
                                kind: .list)
  }

  internal func visit(_ node: SetComprehensionExpr) throws {
    try self.visitComprehension(elt: node.element,
                                value: nil,
                                generators: node.generators,
                                expr: node,
                                kind: .set)
  }

  internal func visit(_ node: DictionaryComprehensionExpr) throws {
    try self.visitComprehension(elt: node.key,
                                value: node.value,
                                generators: node.generators,
                                expr: node,
                                kind: .dictionary)
  }

  internal func visit(_ node: GeneratorExpr) throws {
    try self.visitComprehension(elt: node.element,
                                value: nil,
                                generators: node.generators,
                                expr: node,
                                kind: .generator)
  }

  /// symtable_handle_comprehension(struct symtable *st, expr_ty e, ...)
  ///
  /// - Parameters:
  ///   - elt: element (key in dictionary)
  ///   - value: value in dictionary, nil otherwise
  private func visitComprehension(elt:   Expression,
                                  value: Expression?,
                                  generators: NonEmptyArray<Comprehension>,
                                  expr: Expression,
                                  kind: ComprehensionKind) throws {
    // iterator (source) is evaluated in parent scope
    let first = generators.first
    try self.visit(first.iterable)

    // new scope for comprehensions
    let scopeKind = self.getIdentifier(for: kind)
    self.enterScope(name: scopeKind, type: .function, node: expr)

    if first.isAsync {
      self.currentScope.isCoroutine = true
    }

    // Outermost iter is received as an argument
    try self.implicitArg(pos: 0, location: generators.first.start)
    try self.visit(first.target)
    try self.visit(first.ifs)

    for c in generators.dropFirst() {
      try self.visitComprehension(c)
    }

    try self.visit(value)
    try self.visit(elt)

    if currentScope.isGenerator {
      // we don't have a better location, we just know it happened
      self.warn(.yieldInsideComprehension(kind), location: elt.start)
    }

    if kind == .generator {
      self.currentScope.isGenerator = true
    }
    self.leaveScope()
  }

  private func getIdentifier(for kind: ComprehensionKind) -> String {
    switch kind {
    case .list:       return SymbolScopeNames.listcomp
    case .set:        return SymbolScopeNames.setcomp
    case .dictionary: return SymbolScopeNames.dictcomp
    case .generator:  return SymbolScopeNames.genexpr
    }
  }

  /// Add implicit `.pos` argument for outermost iter.
  /// symtable_implicit_arg(struct symtable *st, int pos)
  private func implicitArg(pos: Int, location: SourceLocation) throws {
    let id = ".\(pos)"
    try self.addSymbol(id, flags: .defParam, location: location)
  }

  /// symtable_visit_comprehension(struct symtable *st, comprehension_ty lc)
  private func visitComprehension(_ comprehension: Comprehension) throws {
    try self.visit(comprehension.target)
    try self.visit(comprehension.iterable)
    try self.visit(comprehension.ifs)

    if comprehension.isAsync {
      self.currentScope.isCoroutine = true
    }
  }

  // MARK: - Await

  internal func visit(_ node: AwaitExpr) throws {
    try self.visit(node.value)
    self.currentScope.isCoroutine = true
  }

  // MARK: - Yield

  internal func visit(_ node: YieldExpr) throws {
    try self.visit(node.value)
    self.currentScope.isGenerator = true
  }

  internal func visit(_ node: YieldFromExpr) throws {
    try self.visit(node.value)
    self.currentScope.isGenerator = true
  }

  // MARK: - Lambda

  internal func visit(_ node: LambdaExpr) throws {
    try self.visitDefaults(node.args)

    self.enterScope(name: SymbolScopeNames.lambda,
                    type: .function,
                    node: node)
    try self.visitArguments(node.args)
    try self.visit(node.body)
    self.leaveScope()
  }

  // MARK: - Call

  internal func visit(_ node: CallExpr) throws {
    try self.visit(node.function)
    try self.visit(node.args)
    try self.visitKeywords(node.keywords)
  }

  // MARK: - If

  internal func visit(_ node: IfExpr) throws {
    try self.visit(node.test)
    try self.visit(node.body)
    try self.visit(node.orElse)
  }

  // MARK: - Attribute

  internal func visit(_ node: AttributeExpr) throws {
    try self.visit(node.object)
  }

  // MARK: - Subscript

  internal func visit(_ node: SubscriptExpr) throws {
    try self.visit(node.object)
    try self.visit(node.slice)
  }

  /// symtable_visit_slice(struct symtable *st, slice_ty s)
  private func visit(_ slice: Slice) throws {
    switch slice.kind {
    case let .slice(lower, upper, step):
      try self.visit(lower)
      try self.visit(upper)
      try self.visit(step)
    case let .extSlice(slices):
      for s in slices {
        try self.visit(s)
      }
    case let .index(expr):
      try self.visit(expr)
    }
  }

  // MARK: - Starred

  internal func visit(_ node: StarredExpr) throws {
    try self.visit(node.expression)
  }
}
