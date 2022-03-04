import VioletCore

// In CPython:
// Objects -> object.c

// sourcery: pytype = NotImplementedType, isDefault
/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
public struct PyNotImplemented: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType) {
    self.header.initialize(py, type: type)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyNotImplemented(ptr: ptr)
    return "PyNotImplemented(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard py.cast.isNotImplemented(zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__repr__")
    }

    let result = py.intern(string: "NotImplemented")
    return .value(result.asObject)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let noArgs = args.isEmpty
    let noKwargs = kwargs?.elements.isEmpty ?? true
    guard noArgs && noKwargs else {
      return .typeError(py, message: "NotImplementedType takes no arguments")
    }

    let result = py.notImplemented
    return .value(result.asObject)
  }

  // MARK: - Helpers

  internal static func invalidSelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult<PyObject> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: "NotImplementedType",
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}
