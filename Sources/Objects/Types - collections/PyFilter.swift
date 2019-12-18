import Core

// In CPython:
// Python -> builtinmodule.c

// sourcery: pytype = filter, default, hasGC, baseType
public class PyFilter: PyObject {

  internal static let doc: String = """
    filter(function or None, iterable) --> filter object

    Return an iterator yielding those items of iterable for which function(item)
    is true. If function is None, return the items that are true.
    """

  internal let fn: PyObject
  internal let iterator: PyObject

  internal init(fn: PyObject, iterator: PyObject) {
    self.fn = fn
    self.iterator = iterator
    super.init(type: fn.builtins.types.filter)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, fn: PyObject, iterator: PyObject) {
    self.fn = fn
    self.iterator = iterator
    super.init(type: type)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return self
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal func next() -> PyResult<PyObject> {
    loop: while true {
      switch self.builtins.next(iterator: self.iterator) {
      case let .value(item):
        if self.fn is PyNone {
          return .value(item)
        }

        if self.iterator === self.builtins.bool {
          switch self.builtins.isTrueBool(item) {
          case .value(true): return .value(item)
          case .value(false): continue loop // try next item
          case .error(let e): return .error(e)
          }
        }

        switch self.builtins.call2(self.fn, args: [item]) {
        case .value(let r):
          switch self.builtins.isTrueBool(r) {
          case .value(true): return .value(item)
          case .value(false): continue loop // try next item
          case .error(let e): return .error(e)
          }
        case .notImplemented:
          // 'self.builtins.notImplemented' is True
          return .value(item)
        case .error(let e),
             .methodIsNotCallable(let e):
          return .error(e)
        }

      case let .error(e): // that includes 'stopIteration'
        return .error(e)
      }
    }
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    if type === type.builtins.filter {
      if let e = ArgumentParser.noKwargsOrError(fnName: "filter", kwargs: kwargs) {
        return .error(e)
      }
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "filter",
                                                        args: args,
                                                        min: 2,
                                                        max: 2) {
      return .error(e)
    }

    let fn = args[0]
    let seq = args[1]

    let iter: PyObject
    switch seq.builtins.iter(from: seq) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    let result = PyFilter(type: type, fn: fn, iterator: iter)
    return .value(result)
  }
}