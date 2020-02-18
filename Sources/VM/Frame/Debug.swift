import Parser
import Objects
import Bytecode

private let isEnabled = true

internal enum Debug {

  // MARK: - Parser, compiler

  internal static func ast(_ ast: AST) {
    guard isEnabled else { return }
    print("=== AST ===")
    print(ast)
    print()
  }

  internal static func code(_ code: CodeObject) {
    guard isEnabled else { return }
    print("=== Bytecode ===")
    print(code.dump())
    print()
  }

  // MARK: - Frame

  internal static func instruction(code: CodeObject,
                                   instruction: Instruction,
                                   extendedArg: Int) {
    guard isEnabled else { return }
    print(code.dumpInstruction(instruction, extendedArg: extendedArg))
  }

  internal static func stack(stack: ObjectStack) {
    guard isEnabled else { return }
    print("  \(stack)")
  }

  internal static func stack(stack: BlockStack) {
    guard isEnabled else { return }
    print("  \(stack)")
  }

  // MARK: - Compare

  internal static func compare(a: PyObject,
                               b: PyObject,
                               op: ComparisonOpcode,
                               result: PyResult<PyObject>) {
    guard isEnabled else { return }
    print("  a:", a)
    print("  b:", b)
    print("  op:", op)
    print("  result:", result)
  }

  // MARK: - Function/method

  internal static func callFunction(fn: PyObject,
                                    args: [PyObject],
                                    kwargs: PyDictData?,
                                    result: CallResult) {
    guard isEnabled else { return }
    print("  fn:", fn)
    print("  args:", args)
    print("  result:", result)
  }

  internal static func loadMethod(method: GetMethodResult) {
    guard isEnabled else { return }
    print("  method:", method)
  }

  internal static func callMethod(method: PyObject,
                                  args: [PyObject],
                                  result: CallResult) {
    guard isEnabled else { return }
    print("  method:", method)
    print("  args:", args)
    print("  result:", result)
  }

  // MARK: - Block

  internal static func push(block: Block) {
    guard isEnabled else { return }
    print("  push block:", block)
  }

  internal static func pop(block: Block?) {
    guard isEnabled else { return }
    let s = block.map(String.init(describing:)) ?? "nil"
    print("  pop block:", s)
  }
}
