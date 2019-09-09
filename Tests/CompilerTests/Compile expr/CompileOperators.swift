import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length

/// Use 'Scripts/dump_dis.py' for reference.
class CompileOperators: XCTestCase, CommonCompiler {

  // MARK: - Unary

  /// + rapunzel
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 UNARY_POSITIVE
  /// 4 RETURN_VALUE
  func test_unary() {
    let operators: [UnaryOperator: EmittedInstructionKind] = [
      .plus: .unaryPositive,
      .minus: .unaryNegative,
      .not: .unaryNot,
      .invert: .unaryInvert
    ]

    for (op, emittedOp) in operators {
      let msg = "for '\(op)'"

      let right = self.expression(.identifier("rapunzel"))
      let expr = self.expression(.unaryOp(op, right: right))

      let expected: [EmittedInstruction] = [
        .init(.loadName, "rapunzel"),
        .init(emittedOp),
        .init(.return)
      ]

      if let code = self.compile(expr: expr) {
        XCTAssertCode(code, name: "<module>", qualified: "", type: .module, msg)
        XCTAssertInstructions(code, expected, msg)
      }
    }
  }

  /// +- rapunzel
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 UNARY_NEGATIVE
  /// 4 UNARY_POSITIVE
  /// 6 RETURN_VALUE
  func test_unary_multiple() {
    let right = self.expression(.identifier("rapunzel"))

    let expr = self.expression(
      .unaryOp(.plus,
               right: self.expression(.unaryOp(.minus, right: right))
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "rapunzel"),
      .init(.unaryNegative),
      .init(.unaryPositive),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Binary

  /// rapunzel + cassandra
  /// (because cassandra > eugene)
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 LOAD_NAME                1 (cassandra)
  /// 4 BINARY_ADD
  /// 6 RETURN_VALUE
  func test_binary() {
    let operators: [BinaryOperator: EmittedInstructionKind] = [
      .add: .binaryAdd,
      .sub: .binarySubtract,
      .mul: .binaryMultiply,
      .matMul: .binaryMatrixMultiply,
      .div: .binaryTrueDivide,
      .modulo: .binaryModulo,
      .pow: .binaryPower,
      .leftShift: .binaryLShift,
      .rightShift: .binaryRShift,
      .bitOr: .binaryOr,
      .bitXor: .binaryXor,
      .bitAnd: .binaryAnd,
      .floorDiv: .binaryFloorDivide
    ]

    for (op, emittedOp) in operators {
      let msg = "for '\(op)'"

      let left = self.expression(.identifier("rapunzel"))
      let right = self.expression(.identifier("cassandra"))
      let expr = self.expression(.binaryOp(op, left: left, right: right))

      let expected: [EmittedInstruction] = [
        .init(.loadName, "rapunzel"),
        .init(.loadName, "cassandra"),
        .init(emittedOp),
        .init(.return)
      ]

      if let code = self.compile(expr: expr) {
        XCTAssertCode(code, name: "<module>", qualified: "", type: .module, msg)
        XCTAssertInstructions(code, expected, msg)
      }
    }
  }

  /// eugene + rapunzel - cassandra
  ///
  ///  0 LOAD_NAME                0 (eugene)
  ///  2 LOAD_NAME                1 (rapunzel)
  ///  4 BINARY_ADD
  ///  6 LOAD_NAME                2 (cassandra)
  ///  8 BINARY_SUBTRACT
  /// 10 RETURN_VALUE
  func test_binary_multiple() {
    let left   = self.expression(.identifier("eugene"))
    let middle = self.expression(.identifier("rapunzel"))
    let right  = self.expression(.identifier("cassandra"))

    let add  = self.expression(.binaryOp(.add, left: left, right: middle))
    let expr = self.expression(.binaryOp(.sub, left: add, right: right))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "eugene"),
      .init(.loadName, "rapunzel"),
      .init(.binaryAdd),
      .init(.loadName, "cassandra"),
      .init(.binarySubtract),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Boolean

  /// rapunzel and cassandra
  /// (because cassandra > eugene)
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 JUMP_IF_FALSE_OR_POP     6
  /// 4 LOAD_NAME                1 (cassandra)
  /// 6 RETURN_VALUE
  func test_boolean_and() {
    let left = self.expression(.identifier("rapunzel"))
    let right = self.expression(.identifier("cassandra"))
    let expr = self.expression(.boolOp(.and, left: left, right: right))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "rapunzel"),
      .init(.jumpIfFalseOrPop, "6"),
      .init(.loadName, "cassandra"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// rapunzel or cassandra
  /// (because cassandra > eugene)
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 JUMP_IF_TRUE_OR_POP      6
  /// 4 LOAD_NAME                1 (cassandra)
  /// 6 RETURN_VALUE
  func test_boolean_or() {
    let left = self.expression(.identifier("rapunzel"))
    let right = self.expression(.identifier("cassandra"))
    let expr = self.expression(.boolOp(.or, left: left, right: right))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "rapunzel"),
      .init(.jumpIfTrueOrPop, "6"),
      .init(.loadName, "cassandra"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// rapunzel and cassandra or eugene
  ///
  /// (This is CPython, we generate different code, but the result is similiar)
  ///  0 LOAD_NAME                0 (rapunzel)
  ///  2 POP_JUMP_IF_FALSE        8
  ///  4 LOAD_NAME                1 (cassandra)
  ///  6 JUMP_IF_TRUE_OR_POP     10
  ///  8 LOAD_NAME                2 (eugene)
  /// 10 RETURN_VALUE
  func test_boolean_multiple() {
    let left   = self.expression(.identifier("rapunzel"))
    let middle = self.expression(.identifier("cassandra"))
    let right  = self.expression(.identifier("eugene"))

    let and  = self.expression(.boolOp(.and, left: left, right: middle))
    let expr = self.expression(.boolOp(.or, left: and, right: right))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "rapunzel"),
      .init(.jumpIfFalseOrPop, "6"),
      .init(.loadName, "cassandra"),
      .init(.jumpIfTrueOrPop, "10"),
      .init(.loadName, "eugene"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Compare

  /// rapunzel < cassandra
  /// (because cassandra > eugene)
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 LOAD_NAME                1 (cassandra)
  /// 4 COMPARE_OP               0 (<)
  /// 6 RETURN_VALUE
  func test_compare() {
    let operators: [ComparisonOperator: String] = [
      .equal: "==",
      .notEqual: "!=",
      .less: "<",
      .lessEqual: "<=",
      .greater: ">",
      .greaterEqual: ">=",
      .`is`:  "is",
      .isNot: "is not",
      .`in`:  "in",
      .notIn: "not in"
    ]

    for (op, emittedOp) in operators {
      let msg = "for '\(op)'"

      let left = self.expression(.identifier("rapunzel"))
      let right = self.expression(.identifier("cassandra"))
      let expr = self.expression(
        .compare(
          left: left,
          elements: NonEmptyArray(first: ComparisonElement(op: op, right: right))
        )
      )

      let expected: [EmittedInstruction] = [
        .init(.loadName, "rapunzel"),
        .init(.loadName, "cassandra"),
        .init(.compareOp, emittedOp),
        .init(.return)
      ]

      if let code = self.compile(expr: expr) {
        XCTAssertCode(code, name: "<module>", qualified: "", type: .module, msg)
        XCTAssertInstructions(code, expected, msg)
      }
    }
  }

  /// eugene < rapunzel < cassandra
  /// additional_block <-- so that we don't get returns at the end
  ///
  ///  0 LOAD_NAME                0 (eugene)
  ///  2 LOAD_NAME                1 (rapunzel)
  ///  4 DUP_TOP
  ///  6 ROT_THREE
  ///  8 COMPARE_OP               0 (<)
  /// 10 JUMP_IF_FALSE_OR_POP    18
  /// 12 LOAD_NAME                2 (cassandra)
  /// 14 COMPARE_OP               0 (<)
  /// 16 JUMP_FORWARD             4 (to 22)
  /// 18 ROT_TWO
  /// 20 POP_TOP
  /// 22 POP_TOP <-- unused result
  ///
  /// 24 LOAD_NAME                3 (additional_block)
  /// 26 POP_TOP
  /// 28 LOAD_CONST               0 (None)
  /// 30 RETURN_VALUE
  func test_compare_triple() {
    let left   = self.expression(.identifier("eugene"))
    let middle = self.expression(.identifier("rapunzel"))
    let right  = self.expression(.identifier("cassandra"))

    let expr = self.expression(
      .compare(
        left: left,
        elements: NonEmptyArray(
          first: ComparisonElement(op: .less, right: middle),
          rest: [ComparisonElement(op: .less, right: right)]
        )
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "eugene"),
      .init(.loadName, "rapunzel"),
      .init(.dupTop),
      .init(.rotThree),
      .init(.compareOp, "<"),
      .init(.jumpIfFalseOrPop, "18"),
      .init(.loadName, "cassandra"),
      .init(.compareOp, "<"),
      .init(.jumpAbsolute, "22"),
      .init(.rotTwo),
      .init(.popTop),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// eugene < pascal < rapunzel < cassandra
  /// additional_block
  ///

  ///  0 LOAD_NAME                0 (eugene)
  ///  2 LOAD_NAME                1 (pascal)
  ///  4 DUP_TOP
  ///  6 ROT_THREE
  ///  8 COMPARE_OP               0 (<)
  /// 10 JUMP_IF_FALSE_OR_POP    28
  /// 12 LOAD_NAME                2 (rapunzel)
  /// 14 DUP_TOP
  /// 16 ROT_THREE
  /// 18 COMPARE_OP               0 (<)
  /// 20 JUMP_IF_FALSE_OR_POP    28
  /// 22 LOAD_NAME                3 (cassandra)
  /// 24 COMPARE_OP               0 (<)
  /// 26 JUMP_FORWARD             4 (to 32)
  /// 28 ROT_TWO
  /// 30 POP_TOP
  /// 32 POP_TOP <-- unused result
  ///
  /// 34 LOAD_NAME                4 (additional_block)
  /// 36 POP_TOP
  /// 38 LOAD_CONST               0 (None)
  /// 40 RETURN_VALUE
  func test_compare_quad() {
    let element1 = self.expression(.identifier("eugene"))
    let element2 = self.expression(.identifier("pascal"))
    let element3 = self.expression(.identifier("rapunzel"))
    let element4 = self.expression(.identifier("cassandra"))

    let expr = self.expression(
      .compare(
        left: element1,
        elements: NonEmptyArray(
          first: ComparisonElement(op: .less, right: element2),
          rest: [
            ComparisonElement(op: .less, right: element3),
            ComparisonElement(op: .less, right: element4)
          ]
        )
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "eugene"),
      .init(.loadName, "pascal"),
      .init(.dupTop),
      .init(.rotThree),
      .init(.compareOp, "<"),
      .init(.jumpIfFalseOrPop, "28"),
      .init(.loadName, "rapunzel"),
      .init(.dupTop),
      .init(.rotThree),
      .init(.compareOp, "<"),
      .init(.jumpIfFalseOrPop, "28"),
      .init(.loadName, "cassandra"),
      .init(.compareOp, "<"),
      .init(.jumpAbsolute, "32"),
      .init(.rotTwo),
      .init(.popTop),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// 1 < 2
  ///
  /// 0 LOAD_CONST               0 (1)
  /// 2 LOAD_CONST               1 (2)
  /// 4 COMPARE_OP               0 (<)
  /// 6 RETURN_VALUE
  func test_compare_const() {
    let left = self.expression(.int(BigInt(1)))
    let right = self.expression(.int(BigInt(2)))
    let expr = self.expression(
      .compare(
        left: left,
        elements: NonEmptyArray(first: ComparisonElement(op: .less, right: right))
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.loadConst, "2"),
      .init(.compareOp, "<"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}