import VioletCore

// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_valueiterator, default, hasGC
public class PyDictValueIterator: PyObject, OrderedDictionaryBackedIterator {

  internal let object: PyDict
  internal var index: Int
  private var initCount: Int

  internal var dict: PyDict.Data {
    return self.object.data
  }

  override public var description: String {
    return "PyDictValueIterator()"
  }

  // MARK: - Init

  internal init(dict: PyDict) {
    self.object = dict
    self.index = 0
    self.initCount = dict.data.count
    super.init(type: Py.types.dict_valueiterator)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  public func iter() -> PyObject {
    return self.iterShared()
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  public func next() -> PyResult<PyObject> {
    guard self.initCount == self.object.data.count else {
      self.index = -1 // Make this state sticky
      return .runtimeError("dictionary changed size during iteration")
    }

    return self.nextShared().map { $0.value }
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  public func lengthHint() -> PyInt {
    return self.lengthHintShared()
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyDictValueIterator> {
    return .typeError("cannot create 'dict_valueiterator' instances")
  }
}
