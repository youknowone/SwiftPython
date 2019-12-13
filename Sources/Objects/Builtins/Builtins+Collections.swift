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
  public func newTuple(list object: PyObject) -> PyResult<PyTuple> {
    return self.cast(object, as: PyList.self, typeName: "list")
      .map { self.newTuple($0.data) }
  }

  internal func newTuple(_ data: PySequenceData) -> PyTuple {
    return data.isEmpty ?
      self.emptyTuple :
      PyTuple(self.context, data: data)
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
  public func add(list object: PyObject, element: PyObject) -> PyResult<PyNone> {
    return self.cast(object, as: PyList.self, typeName: "list")
      .flatMap { $0.append(element) }
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
  public func add(set object: PyObject, value: PyObject) -> PyResult<PyNone> {
    return self.cast(object, as: PySet.self, typeName: "set")
      .flatMap { $0.add(value) }
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

  public func newDict(keyTuple keyObject: PyObject,
                      elements: [PyObject]) -> PyResult<PyDict> {
    let keyTuple: PyTuple
    switch self.cast(keyObject, as: PyTuple.self, typeName: "tuple") {
    case let .value(r): keyTuple = r
    case let .error(e): return .error(e)
    }

    guard keyTuple.elements.count == elements.count else {
      return .valueError("bad 'dictionary(keyTuple:elements:)' keys argument")
    }

    var data = PyDictData()
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

  public func add(dict object: PyObject,
                  key: PyObject,
                  value: PyObject) -> PyResult<PyNone> {
    return self.cast(object, as: PyDict.self, typeName: "dict")
      .flatMap { $0.setItem(at: key, to: value) }
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

  public func newSlice(start: PyObject?,
                       stop: PyObject?,
                       step: PyObject? = nil) -> PySlice {
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
    if let owner = collection as? __contains__Owner {
      return owner.contains(element)
    }

    // TODO: 1. Try to use 'user contains', 2. _PySequence_IterSearch
    return .value(false)
  }

  public func contains(_ collection: PyObject,
                       allFrom subset: PyObject) -> PyResult<Bool> {
    let iter: PyObject
    switch self.iter(object: subset) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    while true {
      switch self.next(iterator: iter) {
      case .value(let o):
        switch self.contains(collection, element: o) {
        case .value(true): break // check next element
        case .value(false): return .value(false)
        case .error(let e): return .error(e)
        }
      case .error(.stopIteration):
        return .value(true)
      case .error(let e):
        return .error(e)
      }
    }
  }

  // MARK: - Helpers

  private func cast<T>(_ object: PyObject,
                       as type: T.Type,
                       typeName: String) -> PyResult<T> {
    if let v = object as? T {
      return .value(v)
    }

    return .typeError("expected \(typeName), but received a '\(object.typeName)'")
  }
}
