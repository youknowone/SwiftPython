import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileAnnAssign: XCTestCase, CommonCompiler {

  /// flounder:Animal = "Friend"
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_CONST               0 ('Friend')
  ///  4 STORE_NAME               0 (flounder)
  ///  6 LOAD_NAME                1 (Animal)
  ///  8 LOAD_NAME                2 (__annotations__)
  /// 10 LOAD_CONST               1 ('flounder')
  /// 12 STORE_SUBSCR
  /// 14 LOAD_CONST               2 (None)
  /// 16 RETURN_VALUE
  func test_simple() {
    let stmt = self.annAssign(
      target: self.identifierExpr("flounder"),
      annotation: self.identifierExpr("Animal"),
      value: self.expression(.string(.literal("Friend"))),
      isSimple: true
    )

    let expected: [EmittedInstruction] = [
      .init(.setupAnnotations),
      .init(.loadConst, "'Friend'"),
      .init(.storeName, "flounder"),
      .init(.loadName, "Animal"),
      .init(.loadName, "__annotations__"),
      .init(.loadConst, "'flounder'"),
      .init(.storeSubscript),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// ariel:Mermaid
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_NAME                0 (Mermaid)
  ///  4 LOAD_NAME                1 (__annotations__)
  ///  6 LOAD_CONST               0 ('ariel')
  ///  8 STORE_SUBSCR
  /// 10 LOAD_CONST               1 (None)
  /// 12 RETURN_VALUE
  func test_withoutValue() {
    let stmt = self.annAssign(
      target: self.identifierExpr("ariel"),
      annotation: self.identifierExpr("Mermaid"),
      value: nil,
      isSimple: true
    )

    let expected: [EmittedInstruction] = [
      .init(.setupAnnotations),
      .init(.loadName, "Mermaid"),
      .init(.loadName, "__annotations__"),
      .init(.loadConst, "'ariel'"),
      .init(.storeSubscript),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// sea.flounder:Animal = "Friend"
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_CONST               0 ('Friend')
  ///  4 LOAD_NAME                0 (sea)
  ///  6 STORE_ATTR               1 (flounder)
  ///  8 LOAD_NAME                2 (Animal)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_toAttribute() {
    let stmt = self.annAssign(
      target: self.expression(.attribute(
        self.identifierExpr("sea"),
        name: "flounder"
      )),
      annotation: self.identifierExpr("Animal"),
      value: self.expression(.string(.literal("Friend"))),
      isSimple: false
    )

    let expected: [EmittedInstruction] = [
      .init(.setupAnnotations),
      .init(.loadConst, "'Friend'"),
      .init(.loadName, "sea"),
      .init(.storeAttribute, "flounder"),
      .init(.loadName, "Animal"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// sea[flounder]:Animal = "Friend"
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_CONST               0 ('Friend')
  ///  4 LOAD_NAME                0 (sea)
  ///  6 LOAD_NAME                1 (flounder)
  ///  8 STORE_SUBSCR
  /// 10 LOAD_NAME                2 (Animal)
  /// 12 POP_TOP
  /// 14 LOAD_CONST               1 (None)
  /// 16 RETURN_VALUE
  func test_toSubscript() {
    let stmt = self.annAssign(
      target: self.expression(.subscript(
        self.identifierExpr("sea"),
        slice: self.slice(.index(
          self.identifierExpr("flounder")
        ))
      )),
      annotation: self.identifierExpr("Animal"),
      value: self.expression(.string(.literal("Friend"))),
      isSimple: false
    )

    let expected: [EmittedInstruction] = [
      .init(.setupAnnotations),
      .init(.loadConst, "'Friend'"),
      .init(.loadName, "sea"),
      .init(.loadName, "flounder"),
      .init(.storeSubscript),
      .init(.loadName, "Animal"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}