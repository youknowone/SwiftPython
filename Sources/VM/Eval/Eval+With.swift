import VioletObjects

extension Eval {

  // MARK: - Setup

  /// This opcode performs several operations before a `with` block starts.
  ///
  /// It does following operations:
  /// 1.loads `Exit()` from the context manager and pushes it onto the stack
  /// for later use by `WithCleanup`.
  /// 2. calls `Enter()`
  /// 3. block staring at to `afterBodyLabel` is pushed.
  /// 4. the result of calling the enter method is pushed onto the stack.
  ///
  /// The next opcode will either ignore it (`PopTop`),
  /// or store it in variable (StoreFast, StoreName, or UnpackSequence).
  internal func setupWith(afterBodyLabelIndex: Int) -> InstructionResult {
    let manager = self.stack.top

    let __enter__: PyObject
    switch Py.getFromType(object: manager, name: .__enter__) {
    case .value(let o): __enter__ = o
    case .notFound: return self.notFound(manager: manager, attribute: "__enter__")
    case .error(let e): return .exception(e)
    }

    let __exit__: PyObject
    switch Py.getFromType(object: manager, name: .__exit__) {
    case .value(let o): __exit__ = o
    case .notFound: return self.notFound(manager: manager, attribute: "__exit__")
    case .error(let e): return .exception(e)
    }

    self.stack.top = __exit__

    switch Py.call(callable: __enter__) {
    case let .value(res):
      // Setup the finally block before pushing the result of __enter__ on the stack.
      let block = Block(
        kind: .setupFinally(finallyStartLabelIndex: afterBodyLabelIndex),
        stackCount: self.stack.count
      )
      self.blockStack.push(block: block)

      self.stack.push(res)
      return .ok
    case let .notCallable(e),
         let .error(e):
      return .exception(e)
    }
  }

  private func notFound(manager: PyObject,
                        attribute: String) -> InstructionResult {
    let e = Py.newAttributeError(object: manager, hasNoAttribute: attribute)
    return .exception(e)
  }

  // MARK: - Cleanup start

  // swiftlint:disable function_body_length

  /// Cleans up the stack when a `with` statement block exits.
  ///
  /// TOS is the context manager’s `__exit__()` bound method.
  /// At the top of the stack are 1–2 values indicating how/why the finally
  /// clause was entered:
  /// - `(None)` - nothing unusual happened
  /// - `(Int, Value)` where Int is either `PushFinallyReason.return` or
  ///    `PushFinallyReason.continue` - we were returning/continuing
  /// - `(Int)` where Int is other `PushFinallyReason` marker; no retval below it
  /// - `(PyBaseException, PyBaseException or None)`
  ///    where 1st exception is the exception that we are currently handling
  ///    and the 2nd exception is optional previous exception.
  ///
  /// And then there is an `__exit__` bound method.
  ///
  /// Normally we will call `__exit__(None, None, None)`, but in the last case
  /// (the one with exception) we will call `__exit__(e.type, e, e.traceback)`.
  ///
  /// Pushes `SECOND` and result of the call to the stack.
  internal func withCleanupStart() -> InstructionResult {
    // swiftlint:enable function_body_length

    let __exit__: PyObject
    var exceptionType: PyObject = Py.none
    var exception: PyObject = Py.none
    var traceback: PyObject = Py.none

    let marker = self.stack.top

    // In general: Pop as many objects as needed to get to '__exit__'
    // and then push them back again.
    switch PushFinallyReason.pop(from: &self.frame.stack) {
    case .none:
      // nothing unusual happened
      __exit__ = self.stack.top
      self.stack.top = marker

    case let .return(value):
      // we were returning
      __exit__ = self.stack.pop()
      PushFinallyReason.push(.return(value), on: &self.frame.stack)

    case let .continue(loopStartLabelIndex: _, asObject: index):
      // we were continuing
      __exit__ = self.stack.pop()
      PushFinallyReason.push(.continuePy(loopStartLabelIndex: index), on: &self.frame.stack)

    case .break:
      __exit__ = self.stack.pop()
      PushFinallyReason.push(.break, on: &self.frame.stack)

    case let .exception(e):
      exceptionType = e.type
      exception = e
      traceback = e.getTraceback() ?? Py.none

      let previousException = self.stack.pop() // may also be 'None'
      __exit__ = self.stack.pop()
      self.stack.push(previousException)
      self.stack.push(exception)

      guard let block = self.blockStack.pop() else {
        let e = Py.newSystemError(msg: "XXX block stack underflow")
        return .exception(e)
      }

      assert(block.isExceptHandler)
      let levelWithoutExit = block.stackCount - 1
      let blockWithoutExit = Block(kind: .exceptHandler, stackCount: levelWithoutExit)
      self.blockStack.push(block: blockWithoutExit)

    case .silenced:
      __exit__ = self.stack.pop()
      PushFinallyReason.push(.silenced, on: &self.frame.stack)

    case .invalid:
      let e = Py.newSystemError(msg: "'finally' pops bad exception")
      return .exception(e)
    }

    let args = [exceptionType, exception, traceback]
    switch Py.call(callable: __exit__, args: args, kwargs: nil) {
    case let .value(result):
      self.stack.push(exception) // Duplicating the exception on the stack
      self.stack.push(result)
      return .ok
    case let .notCallable(e),
         let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Cleanup finish

  /// Pops exception type and result of ‘exit’ function call from the stack.
  ///
  /// If the stack represents an exception, and the function call returns a ‘true’ value,
  /// this information is “zapped” and replaced with a single WhySilenced
  /// to prevent EndFinally from re-raising the exception.
  /// (But non-local goto will still be resumed.)
  internal func withCleanupFinish() -> InstructionResult {
    // Most of the time 'result' is the result of calling '__exit__'.
    let result = self.stack.pop()
    let exception = self.stack.pop()

    // From https://docs.python.org/3/reference/datamodel.html#object.__exit__:
    // If an exception is supplied, and the method wishes to suppress the exception
    // (i.e., prevent it from being propagated), it should return a true value.
    // Otherwise, the exception will be processed normally upon exit from this method.

    var isExceptionSuppressed = false
    if !exception.isNone {
      switch Py.isTrueBool(object: result) {
      case let .value(value):
        isExceptionSuppressed = value
      case let .error(e):
        return .exception(e)
      }
    }

    if isExceptionSuppressed {
      // There was an exception and a True return
      PushFinallyReason.push(.silenced, on: &self.frame.stack)
    }

    return .ok
  }
}
