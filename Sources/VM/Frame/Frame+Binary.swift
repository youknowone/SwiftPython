import Bytecode
import Objects

extension Frame {

  // MARK: - Arithmetic

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() throws {
    let exponent = self.pop()
    let value = self.top
    let result = try self.context.pow(value: value, exponent: exponent)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 * TOS`.
  internal func binaryMultiply() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.mul(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 @ TOS`.
  internal func binaryMatrixMultiply() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.matrixMul(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 // TOS`.
  internal func binaryFloorDivide() throws {
    let divisor = self.pop()
    let dividend = self.top
    let quotient = try self.context.divFloor(left: dividend, right: divisor)
    self.setTop(quotient)
  }

  /// Implements `TOS = TOS1 / TOS`.
  internal func binaryTrueDivide() throws {
    let divisor = self.pop()
    let dividend = self.top
    let quotient = try self.context.div(left: dividend, right: divisor)
    self.setTop(quotient)
  }

  /// Implements `TOS = TOS1 % TOS`.
  internal func binaryModulo() throws {
    let divisor = self.pop()
    let dividend = self.top

    let isStringFormat = self.context.unicode.checkExact(dividend)
      && (self.context.unicode.check(divisor) || self.context.unicode.checkExact(divisor))

    let result = isStringFormat ?
      self.context.unicode.format(dividend: dividend, divisor: divisor) :
      try self.context.remainder(left: dividend, right: divisor)

    self.setTop(result)
  }

  /// Implements `TOS = TOS1 + TOS`.
  internal func binaryAdd() throws {
    let right = self.pop()
    let left = self.top

    let isConcat = self.context.unicode.checkExact(left)
                && self.context.unicode.checkExact(right)

    let result = isConcat ?
      self.context.unicode.unicode_concatenate(left: left, right: right) :
      try self.context.add(left: left, right: right)

    self.setTop(result)
  }

  /// Implements `TOS = TOS1 - TOS`.
  internal func binarySubtract() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.sub(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Shifts

  /// Implements `TOS = TOS1 << TOS`.
  internal func binaryLShift() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.lShift(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 >> TOS`.
  internal func binaryRShift() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.rShift(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Binary

  /// Implements `TOS = TOS1 & TOS`.
  internal func binaryAnd() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.and(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 ^ TOS`.
  internal func binaryXor() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.xor(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 | TOS`.
  internal func binaryOr() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.or(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Compare

  /// Performs a `Boolean` operation.
  internal func compareOp(comparison: ComparisonOpcode) throws {
    let right = self.pop()
    let left = self.top
    let result = try self.compare(left: left, right: right, comparison: comparison)
    self.setTop(result)
  }

  private func compare(left: PyObject,
                       right: PyObject,
                       comparison: ComparisonOpcode) throws -> PyObject {
    switch comparison {
    case .equal:
      return self.context.richCompare(left: left, right: right, mode: .equal)
    case .notEqual:
      return self.context.richCompare(left: left, right: right, mode: .notEqual)
    case .less:
      return self.context.richCompare(left: left, right: right, mode: .less)
    case .lessEqual:
      return self.context.richCompare(left: left, right: right, mode: .lessEqual)
    case .greater:
      return self.context.richCompare(left: left, right: right, mode: .greater)
    case .greaterEqual:
      return self.context.richCompare(left: left, right: right, mode: .greaterEqual)
    case .is:
      return self.context.is(left: left, right: right)
    case .isNot:
      let isReferenceEqual = self.context.is(left: left, right: right)
      return try self.context.not(value: isReferenceEqual)
    case .in:
      return self.context.contains(sequence: left, value: right)
    case .notIn:
      let contains = self.context.contains(sequence: left, value: right)
      return try self.context.not(value: contains)
    case .exceptionMatch:
      // ceval.c -> case PyCmp_EXC_MATCH:
      fatalError()
    }
  }
}
