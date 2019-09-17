import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileTrivial: XCTestCase, CommonCompiler {

  func test_empty() {
    let expected: [EmittedInstruction] = [
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmts: []) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  func test_pass_doesNothing() {
    let stmt = self.statement(.pass)

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}