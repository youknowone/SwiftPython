import VioletCore

// cSpell:ignore bytearrayobject

// In CPython:
// Objects -> bytearrayobject.c

// sourcery: pytype = bytearray_iterator, isDefault, hasGC
public struct PyByteArrayIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var bytes: PyByteArray { self.bytesPtr.pointee }

  // sourcery: storedProperty
  internal var index: Int {
    get { self.indexPtr.pointee }
    nonmutating set { self.indexPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, bytes: PyByteArray) {
    self.initializeBase(py, type: type)
    self.bytesPtr.initialize(to: bytes)
    self.indexPtr.initialize(to: 0)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyByteArrayIterator(ptr: ptr)
    return "PyByteArrayIterator(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__iter__")
    }

    return PyResult(zelf)
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal static func __next__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__next__")
    }

    if zelf.index < zelf.bytes.count {
      let byte = zelf.bytes.elements[zelf.index]
      let result = py.newInt(byte)
      zelf.index += 1
      return PyResult(result)
    }

    return .stopIteration(py)
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal static func __length_hint__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__length_hint__")
    }

    let count = zelf.bytes.count
    let result = count - zelf.index
    return PyResult(py, result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    return .typeError(py, message: "cannot create 'bytearray_iterator' instances")
  }
}
