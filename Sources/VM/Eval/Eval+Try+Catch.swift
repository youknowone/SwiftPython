import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Setup

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `firstExceptLabel` points to the first except block.
  internal func setupExcept(firstExceptLabelIndex: Int) -> InstructionResult {
    let block = Block(
      kind: .setupExcept(firstExceptLabelIndex: firstExceptLabelIndex),
      stackCount: self.stack.count
    )

    self.blockStack.push(block: block)
    return .ok
  }

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `finallyStartLabel` points to the finally block.
  internal func setupFinally(finallyStartLabelIndex: Int) -> InstructionResult {
    let block = Block(
      kind: .setupFinally(finallyStartLabelIndex: finallyStartLabelIndex),
      stackCount: self.stack.count
    )

    self.blockStack.push(block: block)
    return .ok
  }

  // MARK: - Pop except

  /// Removes one block from the block stack.
  /// The popped block must be an exception handler block,
  /// as implicitly created when entering an except handler.
  /// In addition to popping extraneous values from the frame stack,
  /// the last popped value is used to restore the exception state.
  internal func popExcept() -> InstructionResult {
    guard let block = self.blockStack.pop(), block.isExceptHandler else {
      let msg = "popped block is not an except handler"
      let e = Py.newSystemError(msg: msg)
      return .exception(e)
    }

    self.unwindExceptHandler(exceptHandlerBlock: block)
    return .ok
  }

  // MARK: - End finally

  /// Terminates a finally clause.
  /// The interpreter recalls whether the exception has to be re-raised,
  /// or whether the function returns, and continues with the outer-next block.
  internal func endFinally() -> InstructionResult {
    // See 'PushFinallyReason' type for comment about what this is.
    switch PushFinallyReason.pop(from: &self.frame.stack) {
    case let .return(value):
      return .return(value) // We are still returning value

    case .break:
      return .break // We are still 'breaking'

    case let .continue(loopStartLabelIndex: index, asObject: _):
      return .continue(loopStartLabelIndex: index)

    case let .exception(e):
      // We are still handling the same exception
      // Also, the exception was already filled when we started 'finally',
      // so we don't need to add current line to traceback.
      return .exception(e, fillTracebackAndContext: false)

    case .silenced:
      // An exception was silenced by 'with', we must manually unwind the
      // EXCEPT_HANDLER block which was created when the exception was caught,
      // otherwise the stack will be in an inconsistent state.
      guard let block = self.blockStack.pop() else {
        let e = Py.newSystemError(msg: "XXX block stack underflow")
        return .exception(e)
      }

      assert(block.isExceptHandler)
      self.unwindExceptHandler(exceptHandlerBlock: block)
      return .ok

    case .none:
      return .ok

    case .invalid:
      let e = Py.newSystemError(msg: "'finally' pops bad exception")
      return .exception(e)
    }
  }

  // MARK: - Raise

  /// Raises an exception using one of the 3 forms of the raise statement,
  /// depending on the value of argc:
  /// - 0: raise (re-raise previous exception)
  /// - 1: raise TOS (raise exception instance or type at TOS)
  /// - 2: raise TOS1 from TOS (raise exception instance or type at TOS1
  ///      with Cause set to TOS)
  internal func raiseVarargs(arg: Instruction.RaiseArg) -> InstructionResult {
    var cause: PyObject?
    var value: PyObject?

    switch arg {
    case .exceptionAndCause:
      cause = self.stack.pop()
      fallthrough // swiftlint:disable:this fallthrough
    case .exceptionOnly:
      value = self.stack.pop()
      fallthrough // swiftlint:disable:this fallthrough
    case .reRaise:
      let e = self.createException(value: value, cause: cause)
      return .exception(e)
    }
  }

  /// static int
  /// do_raise(PyObject *exc, PyObject *cause)
  private func createException(value: PyObject?,
                               cause: PyObject?) -> PyBaseException {
    // We support the following forms of raise:
    // - raise
    // - raise <instance>
    // - raise <type>

    guard let value = value else {
      // Reraise
      assert(cause == nil)

      guard let current = self.currentlyHandledException else {
        return Py.newRuntimeError(msg: "No active exception to reraise")
      }

      return current
    }

    var exceptionOrNil: PyBaseException?
    if let error = PyCast.asBaseException(value) {
      exceptionOrNil = error
    } else if let type = PyCast.asType(value), type.isException {
      switch Py.newException(type: type, arg: nil) {
      case let .value(e): exceptionOrNil = e
      case let .error(e): return e
      }
    }

    guard let exception = exceptionOrNil else {
      return Py.newTypeError(msg: "exceptions must derive from BaseException")
    }

    switch self.parseCause(from: cause) {
    case .none: break
    case .object(let o): Py.setCause(exception: exception, cause: o)
    case .error(let e): return e
    }

    return exception
  }

  private enum CauseResult {
    case none
    case object(PyBaseException)
    case error(PyBaseException)
  }

  private func parseCause(from cause: PyObject?) -> CauseResult {
    guard let cause = cause else {
      return .none
    }

    if PyCast.isNone(cause) {
      return .none
    }

    if let type = PyCast.asType(cause), type.isException {
      switch Py.newException(type: type, arg: nil) {
      case let .value(o): return .object(o)
      case let .error(e): return .error(e)
      }
    }

    if let error = PyCast.asBaseException(cause) {
      return .object(error)
    }

    let msg = "exception causes must derive from BaseException"
    return .error(Py.newTypeError(msg: msg))
  }
}
