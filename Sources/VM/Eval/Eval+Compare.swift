import Objects
import Bytecode

extension Eval {

  /// Performs a `Boolean` operation.
  internal func compareOp(comparison: ComparisonOpcode) -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    let result = self.compare(left: left, right: right, comparison: comparison)
    Debug.compare(a: left, b: right, op: comparison, result: result)

    switch result {
    case let .value(o):
      self.stack.top = o
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  private func compare(left: PyObject,
                       right: PyObject,
                       comparison: ComparisonOpcode) -> PyResult<PyObject> {
    switch comparison {
    case .equal:
      return Py.isEqual(left: left, right: right)
    case .notEqual:
      return Py.isNotEqual(left: left, right: right)
    case .less:
      return Py.isLess(left: left, right: right)
    case .lessEqual:
      return Py.isLessEqual(left: left, right: right)
    case .greater:
      return Py.isGreater(left: left, right: right)
    case .greaterEqual:
      return Py.isGreaterEqual(left: left, right: right)
    case .is:
      let result = Py.is(left: left, right: right)
      return .value(Py.newBool(result))
    case .isNot:
      let result = Py.is(left: left, right: right)
      return .value(Py.newBool(!result))
    case .in:
      // Iterable is on the right! For example: '1 in { 1, 2, 3 }'
      let result = Py.contains(iterable: right, element: left)
      return result.map(Py.newBool)
    case .notIn:
      // Iterable is on the right! For example: '1 in { 1, 2, 3 }'
      let result = Py.contains(iterable: right, element: left)
      return result.map { !$0 }.map(Py.newBool)
    case .exceptionMatch:
      return self.exceptionMatch(left: left, right: right)
    }
  }

  private func exceptionMatch(left: PyObject,
                              right: PyObject) -> PyResult<PyObject> {
    if let rightTuple = right as? PyTuple {
      for element in rightTuple.elements {
        if let e = self.guaranteeExceptionType(element) {
          return .error(e)
        }
      }
    } else {
      if let e = self.guaranteeExceptionType(right) {
        return .error(e)
      }
    }

    let result = Py.exceptionMatches(error: left, exceptionType: right)
    return .value(Py.newBool(result))
  }

  private func guaranteeExceptionType(_ object: PyObject) -> PyBaseException? {
    if let type = object as? PyType, type.isException {
      return nil
    }

    let msg  = "catching classes that do not inherit from BaseException is not allowed"
    return Py.newTypeError(msg: msg)
  }
}