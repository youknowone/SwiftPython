import VioletCore

// swiftlint:disable file_length
// cSpell:ignore uxxxx Uxxxxxxxx

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Repr

  /// repr(object)
  /// See [this](https://docs.python.org/3/library/functions.html#repr)
  public func repr(object: PyObject) -> PyResult<String> {
    if let result = Fast.__repr__(object) {
      return result
    }

    switch self.callMethod(object: object, selector: .__repr__) {
    case .value(let result):
      guard let resultStr = PyCast.asString(result) else {
        return .typeError("__repr__ returned non-string (\(result.typeName))")
      }

      return .value(resultStr.value)

    case .missingMethod:
      return .value(self.genericRepr(object: object))

    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  /// Get object `__repr__` if that fail then use generic representation.
  public func reprOrGeneric(object: PyObject) -> String {
    switch self.repr(object: object) {
    case .value(let s): return s
    case .error: return self.genericRepr(object: object)
    }
  }

  // MARK: - Str

  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  public func str(object: PyObject) -> PyResult<PyString> {
    switch self.strImpl(object: object) {
    case .reprLock:
      return .value(Py.emptyString)
    case .string(let s):
      let py = Py.newString(s)
      return .value(py)
    case .pyString(let s):
      return .value(s)
    case .methodReturnedNonString(let o):
      return .typeError("__str__ returned non-string (\(o.typeName))")
    case .notCallable(let e):
      return .error(e)
    case .error(let e):
      return .error(e)
    }
  }

  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  public func strString(object: PyObject) -> PyResult<String> {
    switch self.strImpl(object: object) {
    case .reprLock:
      return .value("")
    case .string(let s):
      return .value(s)
    case .pyString(let s):
      return .value(s.value)
    case .methodReturnedNonString(let o):
      return .typeError("__str__ returned non-string (\(o.typeName))")
    case .notCallable(let e):
      return .error(e)
    case .error(let e):
      return .error(e)
    }
  }

  private enum StrImplResult {
    case reprLock
    /// Result of the static call
    case string(String)
    /// Result of the dynamic call
    case pyString(PyString)
    /// When the dynamic call returns non-string
    case methodReturnedNonString(PyObject)
    case notCallable(PyBaseException)
    case error(PyBaseException)

    fileprivate init(repr: ReprImplResult) {
      switch repr {
      case let .string(s): self = .string(s)
      case let .pyString(s): self = .pyString(s)
      case let .methodReturnedNonString(o): self = .methodReturnedNonString(o)
      case let .notCallable(e): self = .notCallable(e)
      case let .error(e): self = .error(e)
      }
    }
  }

  private func strImpl(object: PyObject) -> StrImplResult {
    if object.hasReprLock {
      return .reprLock
    }

    // If we do not override '__str__' then we have to use '__repr__'.
    guard self.hasCustom__str__(object: object) else {
      let repr = self.reprImpl(object: object)
      return StrImplResult(repr: repr)
    }

    if let result = Fast.__str__(object) {
      switch result {
      case let .value(s): return .string(s)
      case let .error(e): return .error(e)
      }
    }

    switch self.callMethod(object: object, selector: .__str__) {
    case let .value(result):
      guard let pyString = PyCast.asString(result) else {
        return .methodReturnedNonString(result)
      }

      return .pyString(pyString)

    case .missingMethod:
      // Hmm… we checked that we have custom '__str__', so we should not end up here
      let repr = self.reprImpl(object: object)
      return StrImplResult(repr: repr)

    case let .notCallable(e):
      return .notCallable(e)
    case let .error(e):
      return .error(e)
    }
  }

  private func hasCustom__str__(object: PyObject) -> Bool {
    let type = object.type

    guard let lookup = type.lookupWithType(name: .__str__) else {
      // 'object' has default implementation for '__str__',
      // if we did not find it then something went really wrong.
      let typeName = type.getNameString()
      trap("'\(typeName)' is not a subclass of 'object'")
    }

    let isFromObject = lookup.type === self.types.object
    return !isFromObject
  }

  // MARK: - ASCII

  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  public func ascii(object: PyObject) -> PyResult<String> {
    let repr: String
    switch self.repr(object: object) {
    case let .value(s): repr = s
    case let .error(e): return .error(e)
    }

    let scalars = repr.unicodeScalars

    let allASCII = scalars.allSatisfy { $0.isASCII }
    if allASCII {
      return .value(repr)
    }

    var result = ""
    for scalar in scalars {
      if scalar.isASCII {
        result.append(String(scalar))
      } else if scalar.value < 0x1_0000 {
        // \uxxxx Character with 16-bit hex value xxxx
        let hex = self.hex(value: scalar.value, padTo: 4)
        result.append("\\u\(hex)")
      } else {
        // \Uxxxxxxxx Character with 32-bit hex value xxxxxxxx
        let hex = self.hex(value: scalar.value, padTo: 8)
        result.append("\\U\(hex)")
      }
    }

    return .value(result)
  }

  // MARK: - Join

  /// _PyUnicode_JoinArray
  public func join(strings elements: [PyObject],
                   separator: PyObject) -> PyResult<PyString> {
    if elements.isEmpty {
      return .value(self.emptyString)
    }

    if elements.count == 1 {
      if let s = PyCast.asString(elements[0]) {
        return .value(s)
      }
    }

    guard let sep = PyCast.asString(separator) else {
      return .typeError("separator: expected str instance, \(separator.typeName) found")
    }

    let strings: [PyString]
    switch self.asStringArray(elements: elements) {
    case let .value(r): strings = r
    case let .error(e): return .error(e)
    }

    var result = ""
    for (index, string) in strings.enumerated() {
      result.append(string.value)

      let isLast = index == strings.count - 1
      if !isLast {
        result.append(sep.value)
      }
    }

    return .value(self.newString(result))
  }

  private func asStringArray(elements: [PyObject]) -> PyResult<[PyString]> {
    var result = [PyString]()

    for (index, object) in elements.enumerated() {
      switch PyCast.asString(object) {
      case .some(let s):
        result.append(s)
      case .none:
        let msg = "sequence item \(index): expected str instance, \(object.typeName) found"
        return .typeError(msg)
      }
    }

    return .value(result)
  }

  // MARK: - Helpers

  private func hex(value: UInt32, padTo: Int) -> String {
    let string = String(value, radix: 16, uppercase: false)
    if string.count >= padTo {
      return string
    }

    let paddingCount = padTo - string.count
    assert(paddingCount > 0)
    let padding = String(repeating: "0", count: paddingCount)

    return padding + string
  }

  private func genericRepr(object: PyObject) -> String {
    return "<\(object.typeName) object at \(object.ptr)>"
  }
}
