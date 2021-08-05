import SwiftSyntax

class Protocol: DeclarationWithScope {

  let id: SyntaxIdentifier
  let name: String
  let accessModifiers: GetSetAccessModifiers?
  let modifiers: [Modifier]
  let inheritance: [InheritedType]

  let attributes: [Attribute]
  let genericRequirements: [GenericRequirement]

  let childScope = DeclarationScope()

  init(_ node: ProtocolDeclSyntax) {
    self.id = node.id
    self.name = node.identifier.text.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    let inheritedTypes = node.inheritanceClause?.inheritedTypeCollection
    self.inheritance = inheritedTypes?.map(InheritedType.init) ?? []

    self.attributes = node.attributes?.map(Attribute.init) ?? []

    let requirementList = node.genericWhereClause?.requirementList
    self.genericRequirements = requirementList?.map(GenericRequirement.init) ?? []
  }

  func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}