import VioletCore

// In CPython:
// Objects -> object.c

// sourcery: pytype = NotImplementedType, isDefault
/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
public struct PyNotImplemented: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal enum Layout {
    internal static let size = SizeOf.objectHeader
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType) {
    self.header.initialize(type: type)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyNotImplemented(ptr: ptr)
    zelf.header.deinitialize()
  }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyNotImplemented(ptr: ptr)
    return "PyNotImplemented(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    return "NotImplemented"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyNotImplemented> {
    let noArgs = args.isEmpty
    let noKwargs = kwargs?.elements.isEmpty ?? true
    guard noArgs && noKwargs else {
      return .typeError("NotImplementedType takes no arguments")
    }

    return .value(Py.notImplemented)
  }
}

*/
