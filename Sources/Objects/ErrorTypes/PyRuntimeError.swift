// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

internal class PyRuntimeErrorType: PyExceptionType {
  override internal var name: String { return "RuntimeError" }
  override internal var base: PyType? { return self.exceptionType }
  override internal var doc: String? { return "Unspecified run-time error." }

  fileprivate var runtimeErrorType: PyType {
    return self.context.errors.runtimeError
  }
}

internal final class PyRecursionErrorType: PyRuntimeErrorType {
  override internal var name: String { return "RecursionError" }
  override internal var base: PyType? { return self.runtimeErrorType }
  override internal var doc: String? { return "Recursion limit exceeded." }
}

internal final class PyNotImplementedErrorType: PyRuntimeErrorType {
  override internal var name: String { return "NotImplementedError" }
  override internal var base: PyType? { return self.runtimeErrorType }
  override internal var doc: String? {
    return "Method or function hasn't been implemented yet."
  }
}
