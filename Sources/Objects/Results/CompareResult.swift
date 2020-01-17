public enum CompareResult {
  case value(Bool)
  case error(PyBaseException)
  case notImplemented

  // swiftlint:disable:next discouraged_optional_boolean
  internal init(_ value: Bool?) {
    switch value {
    case .some(let b):
      self = .value(b)
    case .none:
      self = .notImplemented
    }
  }

  /// Method used when implementing `__ne__`.
  ///
  ///We don't want to override `!` operator, because it is tiny and easy to miss.
  public var not: CompareResult {
    switch self {
    case .value(let bool):
      return .value(!bool)
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .notImplemented
    }
  }
}

extension CompareResult: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    switch self {
    case .value(let bool):
      return bool.toFunctionResult(in: context)
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .value(context.builtins.notImplemented)
    }
  }
}

extension PyResult where Wrapped == Bool {
  public var asCompareResult: CompareResult {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(e)
    }
  }
}
