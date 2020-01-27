import XCTest
import Core
import Lexer
@testable import Parser

class ParseContinueBreak: XCTestCase, Common {

  /// break
  func test_break() {
    let parser = self.createStmtParser(
      self.token(.break, start: loc0, end: loc1)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      BreakStmt(start: 0:0, end: 1:6)
    """)
  }

  /// continue
  func test_continue() {
    let parser = self.createStmtParser(
      self.token(.continue, start: loc0, end: loc1)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      ContinueStmt(start: 0:0, end: 1:6)
    """)
  }
}
