import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

// MARK: - Create

func createBuilder(
  name: String = "name",
  qualifiedName: String = "qualifiedName",
  filename: String = "filename",
  kind: CodeObject.Kind = .module,
  flags: CodeObject.Flags = CodeObject.Flags(),
  variableNames: [MangledName] = [],
  freeVariableNames: [MangledName] = [],
  cellVariableNames: [MangledName] = [],
  argCount: Int = 0,
  kwOnlyArgCount: Int = 0,
  firstLine: SourceLine = SourceLocation.start.line
) -> CodeObjectBuilder {
  return CodeObjectBuilder(name: name,
                           qualifiedName: qualifiedName,
                           filename: filename,
                           kind: kind,
                           flags: flags,
                           variableNames: variableNames,
                           freeVariableNames: freeVariableNames,
                           cellVariableNames: cellVariableNames,
                           argCount: argCount,
                           kwOnlyArgCount: kwOnlyArgCount,
                           firstLine: firstLine)
}

// MARK: - Instructions

func XCTAssertNoInstructions(_ code: CodeObject,
                             file: StaticString = #file,
                             line: UInt = #line) {
  let count = code.instructions.count
  XCTAssertEqual(count, 0, "Instuction count: \(count)", file: file, line: line)
}

func XCTAssertInstructions(_ code: CodeObject,
                           _ expected: Instruction...,
                           file: StaticString = #file,
                           line: UInt = #line) {
  XCTAssertInstructions(code, expected, file: file, line: line)
}

func XCTAssertInstructions(_ code: CodeObject,
                           _ expected: [Instruction],
                           file: StaticString = #file,
                           line: UInt = #line) {
  let count = code.instructions.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)

  for (index, (i, e)) in zip(code.instructions, expected).enumerated() {
    XCTAssertEqual(i, e, "Intruction: \(index)", file: file, line: line)
  }
}

func XCTAssertFilledInstructions(_ code: CodeObject,
                                 _ expected: Instruction.Filled...,
                                 file: StaticString = #file,
                                 line: UInt = #line) {
  var expectedIndex = 0
  var instructionIndex: Int? = 0

  while let index = instructionIndex {
    let filled = code.getFilledInstruction(index: index)
    let instruction = filled.instruction

    // We may have more 'instructions' than 'expected'
    if expectedIndex < expected.count {
      let expectedInstruction = expected[expectedIndex]
      XCTAssertEqual(instruction, expectedInstruction, file: file, line: line)
    }

    expectedIndex += 1
    instructionIndex = filled.nextInstructionIndex
  }

  let instructionCount = expectedIndex
  XCTAssertEqual(instructionCount, expected.count, "Count", file: file, line: line)
}

// MARK: - Lines

func XCTAssertInstructionLines(_ code: CodeObject,
                               _ expected: SourceLocation...,
                               file: StaticString = #file,
                               line: UInt = #line) {
  let count = code.instructionLines.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)
  guard count == expectedCount else {
    return
  }

  for (l, e) in zip(code.instructionLines, expected) {
    XCTAssertEqual(l, e.line, file: file, line: line)
  }
}

// MARK: - Constants

let trueConstants: [CodeObject.Constant] = [
  .true,
  .ellipsis,
  .integer(BigInt(5)),
  .float(5.0),
  .complex(real: 0.0, imag: 1.0),
  .complex(real: 1.0, imag: 1.0),
  .complex(real: 1.0, imag: 1.0),
  .string("Elsa"),
  .bytes(Data([69, 108, 115, 97])),
  // .code(CodeObject),
  .tuple([.true, .false])
]

let falseConstants: [CodeObject.Constant] = [
  .false,
  .none,
  .integer(BigInt.zero),
  .float(0.0),
  .complex(real: 0.0, imag: 0.0),
  .string(""),
  .bytes(Data()),
  .tuple([])
]

/// Add 255 constants, so that the next one will require `extendedArg`
func add255IntegerConstants(builder: CodeObjectBuilder) {
  for i in 0..<256 {
    builder.appendInteger(BigInt(i))
  }
}

func getInstructionsWith255IntegerConstants() -> [Instruction] {
  var result = [Instruction]()
  for i in 0..<256 {
    result.append(.loadConst(index: UInt8(i)))
  }

  return result
}
/// Assert `code.labels[256]`
func XCTAssertConstantAtIndex256(_ code: CodeObject,
                                 _ expected: CodeObject.Constant,
                                 file: StaticString = #file,
                                 line: UInt = #line) {
  let count = code.constants.count
  let index = 256

  XCTAssertGreaterThanOrEqual(count, index, "Constant count", file: file, line: line)
  guard count >= index else {
    return
  }

  let constant = code.constants[index]
  XCTAssertEqual(constant, expected, file: file, line: line)
}

func XCTAssertNoConstants(_ code: CodeObject,
                          file: StaticString = #file,
                          line: UInt = #line) {
  XCTAssertEqual(code.constants.count, 0, file: file, line: line)
}

func XCTAssertConstants(_ code: CodeObject,
                        _ expected: CodeObject.Constant...,
                        file: StaticString = #file,
                        line: UInt = #line) {
  XCTAssertConstants(code, expected, file: file, line: line)
}

func XCTAssertConstants(_ code: CodeObject,
                        _ expected: [CodeObject.Constant],
                        file: StaticString = #file,
                        line: UInt = #line) {
  let count = code.constants.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)

  for (index, (c, e)) in zip(code.constants, expected).enumerated() {
    XCTAssertEqual(c, e, "Constant \(index)", file: file, line: line)
  }
}

func XCTAssertEqual(_ lhs: CodeObject.Constant,
                    _ rhs: CodeObject.Constant,
                    file: StaticString = #file,
                    line: UInt = #line) {
  switch (lhs, rhs) {
  case (.true, .true),
       (.false, .false),
       (.none, .none),
       (.ellipsis, .ellipsis):
    break

  case let (.integer(l), .integer(r)):
    XCTAssertEqual(l, r, file: file, line: line)
  case let (.float(l), .float(r)):
    XCTAssertEqual(l, r, file: file, line: line)
  case let (.string(l), .string(r)):
    XCTAssertEqual(l, r, file: file, line: line)
  case let (.bytes(l), .bytes(r)):
    XCTAssertEqual(l, r, file: file, line: line)

  case let (.complex(real: lr, imag: li), .complex(real: rr, imag: ri)):
    XCTAssertEqual(lr, rr, file: file, line: line)
    XCTAssertEqual(li, ri, file: file, line: line)

  case let (.code(l), .code(r)):
    XCTAssert(l === r, file: file, line: line)

  case let (.tuple(ls), .tuple(rs)):
    XCTAssertEqual(ls.count,
                   rs.count,
                   "Tuple count: \(ls.count) vs \(rs.count)",
                   file: file,
                   line: line)

    for (l, r) in zip(ls, rs) {
      XCTAssertEqual(l, r, file: file, line: line)
    }

  default:
    let msg = "Constants '\(lhs)' and '\(rhs)' are not equal."
    XCTAssert(false, msg, file: file, line: line)
  }
}

// MARK: - Labels

func XCTAssertNoLabels(_ code: CodeObject,
                       file: StaticString = #file,
                       line: UInt = #line) {
  XCTAssertEqual(code.labels.count, 0, file: file, line: line)
}

func XCTAssertLabelTargets(_ code: CodeObject,
                           _ expected: Int...,
                           file: StaticString = #file,
                           line: UInt = #line) {
  let count = code.labels.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)
  guard count == expectedCount else {
    return
  }

  for (l, e) in zip(code.labels, expected) {
    let eLabel = CodeObject.Label(instructionIndex: e)
    XCTAssertEqual(l, eLabel, file: file, line: line)
  }
}

/// Add 255 labels, so that the next one will require `extendedArg`
func add255Labels(builder: CodeObjectBuilder) {
  for _ in 0..<256 {
    let label = builder.createLabel()
    builder.setLabel(label)
  }
}

/// Assert `code.labels[256]`
func XCTAssertLabelAtIndex256(_ code: CodeObject,
                              instructionIndex: Int,
                              file: StaticString = #file,
                              line: UInt = #line) {
  let count = code.labels.count
  let index = 256

  XCTAssertGreaterThanOrEqual(count, index, "Label count", file: file, line: line)
  guard count >= index else {
    return
  }

  let label = code.labels[index]
  let expectedLabel = CodeObject.Label(instructionIndex: instructionIndex)
  XCTAssertEqual(label, expectedLabel, file: file, line: line)
}

// MARK: - Names

func XCTAssertNames(_ code: CodeObject,
                    _ expected: String...,
                    file: StaticString = #file,
                    line: UInt = #line) {
  let count = code.names.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)
  guard count == expectedCount else {
    return
  }

  for (n, e) in zip(code.names, expected) {
    XCTAssertEqual(n, e, file: file, line: line)
  }
}
