// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

public class CreateDictionaryArg {
  public let key: PyObject
  public let value: PyObject

  public init(key: PyObject, value: PyObject) {
    self.key = key
    self.value = value
  }
}

extension Builtins {

  // MARK: - Tuple

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(_ elements: PyObject...) -> PyTuple {
    return self.newTuple(elements)
  }

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(_ elements: [PyObject]) -> PyTuple {
    return elements.isEmpty ?
      self.emptyTuple :
      PyTuple(self.context, elements: elements)
  }

  /// PyObject * PyList_AsTuple(PyObject *v)
  public func newTuple(list: PyObject) -> PyTuple {
    let list = TypeFactory.selfAsPyList(list)
    return list.isEmpty ?
      self.emptyTuple :
      PyTuple(self.context, data: list.data)
  }

  internal func newTuple(_ data: PySequenceData) -> PyTuple {
    return PyTuple(self.context, data: data)
  }

  // MARK: - List

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(_ elements: PyObject...) -> PyList {
    return self.newList(elements)
  }

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(_ elements: [PyObject]) -> PyList {
    return PyList(self.context, elements: elements)
  }

  internal func newList(_ data: PySequenceData) -> PyList {
    return PyList(self.context, data: data)
  }

  /// int PyList_Append(PyObject *op, PyObject *newitem)
  public func add(list: PyObject, element: PyObject) -> PyResult<()> {
    let list = TypeFactory.selfAsPyList(list)
    return list.append(element).map { _ in () }
  }

  /// PyObject * _PyList_Extend(PyListObject *self, PyObject *iterable)
//  public func extend(list: PyObject, iterable: PyObject) -> PyResult<()> {
//    let list = TypeFactory.selfAsPyList(list)
//    return list.extend(iterable).map { _ in () }
//  }

  // MARK: - Set

  /// PyObject * PySet_New(PyObject *iterable)
  public func newSet(_ elements: [PyObject] = []) -> PyResult<PySet> {
    var data = PySetData()
    for element in elements {
      switch data.insert(value: element) {
      case .ok: break
      case .error(let e): return .error(e)
      }
    }

    return .value(PySet(self.context, data: data))
  }

  /// int PySet_Add(PyObject *anyset, PyObject *key)
  public func add(set: PyObject, value: PyObject) -> PyResult<()> {
    let set = TypeFactory.selfAsPySet(set)
    return set.add(value).map { _ in () }
  }

  /// int _PySet_Update(PyObject *set, PyObject *iterable)
//  public func extend(set: PyObject, iterable: PyObject) {
//    self.unimplemented()
//  }

  // MARK: - Dictionary

  public func newDict(_ args: [CreateDictionaryArg] = []) -> PyResult<PyDict> {
    var data = PyDictData()
    for arg in args {
      switch self.hash(arg.key) {
      case let .value(hash):
        let key = PyDictKey(hash: hash, object: arg.key)
        switch data.insert(key: key, value: arg.value) {
        case .inserted, .updated: break
        case .error(let e): return .error(e)
        }
      case let .error(e):
        return .error(e)
      }
    }

    return .value(PyDict(self.context, data: data))
  }

  internal func newDict(_ context: PyContext, data: PyDictData?) -> PyDict {
    return PyDict(context, data: data ?? PyDictData())
  }

  public func newDict(keyTuple: PyObject,
                      elements: [PyObject]) -> PyResult<PyDict> {
    var data = PyDictData()
    let keyTuple = TypeFactory.selfAsPyTuple(keyTuple)

    guard keyTuple.elements.count == elements.count else {
      return .valueError("bad 'dictionary(keyTuple:elements:)' keys argument")
    }

    for (keyObject, value) in Swift.zip(keyTuple.elements, elements) {
      switch self.hash(keyObject) {
      case let .value(hash):
        let key = PyDictKey(hash: hash, object: keyObject)
        switch data.insert(key: key, value: value) {
        case .inserted, .updated: break
        case .error(let e): return .error(e)
        }
      case let .error(e):
        return .error(e)
      }
    }

    return .value(PyDict(self.context, data: data))
  }

  public func add(dict: PyObject, key: PyObject, value: PyObject) -> PyResult<()> {
    let dict = TypeFactory.selfAsPyDict(dict)
    return dict.setItem(at: key, to: value).map { _ in () }
  }

  // MARK: - Range

  public func newRange(stop: PyInt) -> PyResult<PyRange> {
    let zero = self.newInt(0)
    return self.newRange(start: zero, stop: stop, step: nil)
  }

  public func newRange(start: PyInt, stop: PyInt, step: PyInt?) -> PyResult<PyRange> {
    if let s = step, s.value == 0 {
      return .valueError("range() arg 3 must not be zero")
    }

    return .value(PyRange(self.context, start: start, stop: stop, step: step))
  }

  // MARK: - Enumerate

//  public func _enumerate(iterable: PyObject, startIndex: Int) -> PyResult<PyEnumerate> {
//    guard let source = iterable as? PyEnumerateSource else {
//      let str = self._str(value: iterable)
//      return .typeError("'\(str)' object is not iterable")
//    }
//
//    return .value(PyEnumerate(self, iterable: source, startIndex: startIndex))
//  }

  // MARK: - Slice

  public func newSlice(stop: PyInt?) -> PySlice {
    return PySlice(
      self.context,
      start: self.none,
      stop: stop ?? self.none,
      step: self.none
    )
  }

  public func newSlice(start: PyInt?,
                       stop: PyInt?,
                       step: PyInt? = nil) -> PySlice {
    return PySlice(
      self.context,
      start: start ?? self.none,
      stop: stop ?? self.none,
      step: step ?? self.none
    )
  }

  // MARK: - Contains

  /// int
  /// PySequence_Contains(PyObject *seq, PyObject *ob)
  public func contains(_ collection: PyObject,
                       element: PyObject) -> PyResult<Bool> {

    if let containsOwner = collection as? __contains__Owner {
      return containsOwner.contains(element)
    }

    // TODO: 1. Try to use 'user contains', 2. _PySequence_IterSearch
    return .value(false)
  }
}