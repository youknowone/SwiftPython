import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileIfExpr: CompileTestCase {

  /// 'genie' if 'touched' else 'lamp'
  /// additional_block <-- so that we don't get returns at the end
  ///
  /// Note that currently we do not have fast path for constants,
  /// so our bytecode will be different.
  ///
  ///  0 LOAD_CONST               0 (touched)
  ///  2 POP_JUMP_IF_FALSE        8
  ///  4 LOAD_CONST               1 (genie)
  ///  6 JUMP_FORWARD             2 (to 10)
  ///  8 LOAD_CONST               2 (lamp)
  /// 10 POP_TOP <-- unused result
  ///
  /// 12 LOAD_NAME                3 (additional_block)
  /// 14 POP_TOP
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  func test_constants() {
    let expr = self.ifExpr(
      test: self.stringExpr(value: .literal("touched")),
      body: self.stringExpr(value: .literal("genie")),
      orElse: self.stringExpr(value: .literal("lamp"))
    )

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(string: "touched"),
        .popJumpIfFalse(target: 8),
        .loadConst(string: "genie"),
        .jumpAbsolute(target: 10),
        .loadConst(string: "lamp"),
        .return
      ]
    )
  }

  /// genie if touched else lamp
  /// additional_block <-- so that we don't get returns at the end
  ///
  ///  0 LOAD_NAME                0 (touched)
  ///  2 POP_JUMP_IF_FALSE        8
  ///  4 LOAD_NAME                1 (genie)
  ///  6 JUMP_FORWARD             2 (to 10)
  ///  8 LOAD_NAME                2 (lamp)
  /// 10 POP_TOP
  ///
  /// 12 LOAD_NAME                3 (additional_block)
  /// 14 POP_TOP
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  func test_withIdentifier() {
    let expr = self.ifExpr(
      test: self.identifierExpr(value: "touched"),
      body: self.identifierExpr(value: "genie"),
      orElse: self.identifierExpr(value: "lamp")
    )

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadName(name: "touched"),
        .popJumpIfFalse(target: 8),
        .loadName(name: "genie"),
        .jumpAbsolute(target: 10),
        .loadName(name: "lamp"),
        .return
      ]
    )
  }

  /// aladdin if jasmine else (ali if prince else thief)
  ///
  ///  0 LOAD_NAME                0 (jasmine)
  ///  2 POP_JUMP_IF_FALSE        8
  ///  4 LOAD_NAME                1 (aladdin)
  ///  6 JUMP_FORWARD            10 (to 18)
  ///  8 LOAD_NAME                2 (prince)
  /// 10 POP_JUMP_IF_FALSE       16
  /// 12 LOAD_NAME                3 (ali)
  /// 14 JUMP_FORWARD             2 (to 18)
  /// 16 LOAD_NAME                4 (thief)
  /// 18 POP_TOP
  ///
  /// 20 LOAD_NAME                5 (additional_block)
  /// 22 POP_TOP
  /// 24 LOAD_CONST               0 (None)
  /// 26 RETURN_VALUE
  func test_nested() {
    let expr = self.ifExpr(
      test: self.identifierExpr(value: "jasmine"),
      body: self.identifierExpr(value: "aladdin"),
      orElse: self.ifExpr(
        test: self.identifierExpr(value: "prince"),
        body: self.identifierExpr(value: "ali"),
        orElse: self.identifierExpr(value: "thief")
      )
    )

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadName(name: "jasmine"), // 0
        .popJumpIfFalse(target: 8), // 2
        .loadName(name: "aladdin"), // 4
        .jumpAbsolute(target: 18), // 6

        .loadName(name: "prince"), // 8
        .popJumpIfFalse(target: 16), // 10
        .loadName(name: "ali"), // 12
        .jumpAbsolute(target: 18), // 14

        .loadName(name: "thief"), // 16
        .return // 18
      ]
    )
  }
}
