import Bytecode
import Objects

extension Eval {

  // MARK: - Pos

  /// Implements `TOS = +TOS`.
  internal func unaryPositive() -> InstructionResult {
    let value = self.stack.top
    switch Py.pos(value) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - New

  /// Implements `TOS = -TOS`.
  internal func unaryNegative() -> InstructionResult {
    let value = self.stack.top
    switch Py.neg(value) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Not

  /// Implements `TOS = not TOS`.
  internal func unaryNot() -> InstructionResult {
    let top = self.stack.top

    switch Py.not(top) {
    case let .value(not):
      self.stack.top = not
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Invert

  /// Implements `TOS = ~TOS`.
  internal func unaryInvert() -> InstructionResult {
    let value = self.stack.top
    switch Py.invert(value) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }
}