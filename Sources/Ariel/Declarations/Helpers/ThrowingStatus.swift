import SwiftSyntax

enum ThrowingStatus {

  case `throws`
  case `rethrows`

  init(_ node: TokenSyntax) {
    let text = node.text.trimmed

    switch text {
    case "throws":
      self = .throws
    case "rethrows":
      self = .rethrows
    default:
      fatalError("Unknown throwing status: '\(text)'")
    }
  }
}