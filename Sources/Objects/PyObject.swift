internal struct PyObjectFlags: OptionSet {
  let rawValue: UInt8

  /// This flag is used to control infinite recursion in `repr`, `str`, `print`
  /// etc.
  ///
  /// Container objects that may recursively contain themselves, e.g. builtin
  /// dictionaries and lists, should use `withReprLock()` to avoid infinite
  /// recursion.
  internal static let reprLock = PyObjectFlags(rawValue: 1 << 0)
}

public class PyObject {

  internal var flags: PyObjectFlags
  internal let type: PyType

  internal init(type: PyType) {
    self.flags = []
    self.type = type
  }

  // MARK: - Repr

  internal var hasReprLock: Bool {
    return self.flags.contains(.reprLock)
  }

  internal func withReprLock<T>(body: () throws -> T) rethrows -> T {
    self.flags.formUnion(.reprLock)
    defer { _ = self.flags.subtracting(.reprLock) }

    return try body()
  }
}