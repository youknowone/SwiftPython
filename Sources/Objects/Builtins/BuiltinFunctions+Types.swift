// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension BuiltinFunctions {

  // MARK: - Types

  // sourcery: pytype: bool
  /// class bool([x])
  public var bool: PyType { return Py.types.bool }

  // sourcery: pytype: bytearray
  /// class bytearray([source[, encoding[, errors]]])
  public var bytearray: PyType { return Py.types.bytearray }

  // sourcery: pytype: bytes
  /// class bytes([source[, encoding[, errors]]])
  public var bytes: PyType { return Py.types.bytes }

  // sourcery: pytype: complex
  /// class complex([real[, imag]])
  public var complex: PyType { return Py.types.complex }

  // sourcery: pytype: dict
  /// class dict(**kwarg)
  public var dict: PyType { return Py.types.dict }

  // sourcery: pymethod = enumerate
  /// enumerate(iterable, start=0)
  /// See [this](https://docs.python.org/3/library/functions.html#enumerate)
  public var enumerate: PyType { return Py.types.enumerate }

  // sourcery: pytype: filter
  /// filter(function, iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#filter)
  public var filter: PyType { return Py.types.filter }

  // sourcery: pytype: float
  /// class float([x])
  public var float: PyType { return Py.types.float }

  // sourcery: pytype: frozenset
  /// class frozenset([iterable])
  public var frozenset: PyType { return Py.types.frozenset }

  // sourcery: pytype: int
  /// class int([x])
  public var int: PyType { return Py.types.int }

  // sourcery: pytype: list
  /// class list([iterable])
  public var list: PyType { return Py.types.list }

  // sourcery: pymethod = map
  /// map(function, iterable, ...)
  /// See [this](https://docs.python.org/3/library/functions.html#map)
  public var map: PyType { return Py.types.map }

  // sourcery: pytype: object
  /// class object
  public var object: PyType { return Py.types.object }

  // sourcery: pytype: property
  /// class property(fget=None, fset=None, fdel=None, docne) */
  public var property: PyType { return Py.types.property }

  // sourcery: pymethod = range
  /// range(stop)
  /// See [this](https://docs.python.org/3/library/functions.html)
  public var range: PyType { return Py.types.range }

  // sourcery: pymethod = reversed
  /// reversed(seq)
  /// See [this](https://docs.python.org/3/library/functions.html#reversed)
  public var reversed: PyType { return Py.types.reversed }

  // sourcery: pytype: set
  /// class set([iterable])
  public var set: PyType { return Py.types.set }

  // sourcery: pytype: slice
  /// class slice(stop)
  public var slice: PyType { return Py.types.slice }

  // sourcery: pytype: str
  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  public var str: PyType { return Py.types.str }

  // sourcery: pymethod = tuple
  /// tuple([iterable])
  /// See [this](https://docs.python.org/3/library/functions.html)
  public var tuple: PyType { return Py.types.tuple }

  // sourcery: pytype: type
  /// class type(object)
  /// class type(name, bases, dict)
  public var type: PyType { return Py.types.type }

  // sourcery: pymethod = zip
  /// zip(*iterables)
  /// See [this](https://docs.python.org/3/library/functions.html#zip)
  public var zip: PyType { return Py.types.zip }

  // MARK: - Is instance

  internal static var isInstanceDoc: String {
    return """
    isinstance($module, obj, class_or_tuple, /)
    --

    Return whether an object is an instance of a class or of a subclass thereof.

    A tuple, as in ``isinstance(x, (A, B, ...))``, may be given as the target to
    check against. This is equivalent to ``isinstance(x, A) or isinstance(x, B)
    or ...`` etc.
    """
  }

  // sourcery: pymethod = isinstance, doc = isInstanceDoc
  /// isinstance(object, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#isinstance)
  public func isInstance(object: PyObject,
                         of typeOrTuple: PyObject) -> PyResult<Bool> {
    if object.type === typeOrTuple {
      return .value(true)
    }

    if let tuple = typeOrTuple as? PyTuple {
      for type in tuple.elements {
        switch self.isInstance(object: object, of: type) {
        case .value(true): return .value(true)
        case .value(false): break // try next
        case .error(let e): return .error(e)
        }
      }
    }

    return self.call__instancecheck__(instance: object, type: typeOrTuple)
  }

  private func call__instancecheck__(instance: PyObject,
                                     type: PyObject) -> PyResult<Bool> {
    if let owner = type as? __instancecheck__Owner {
      let result = owner.isType(of: instance)
      return .value(result)
    }

    switch self.callMethod(on: type, selector: "__instancecheck__", arg: instance) {
    case .value(let o):
      return self.isTrueBool(o)
    case .missingMethod:
      return .typeError("isinstance() arg 2 must be a type or tuple of types")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Is subclass

  internal static var isSubclassDoc: String {
    return """
    issubclass($module, cls, class_or_tuple, /)
    --

    Return whether \'cls\' is a derived from another class or is the same class.

    A tuple, as in ``issubclass(x, (A, B, ...))``, may be given as the target to
    check against. This is equivalent to ``issubclass(x, A) or issubclass(x, B)
    or ...`` etc.
    """
  }

  // sourcery: pymethod = issubclass, doc = isSubclassDoc
  /// issubclass(class, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#issubclass)
  public func isSubclass(object: PyObject,
                         of typeOrTuple: PyObject) -> PyResult<Bool> {
    if object.type === typeOrTuple {
      return .value(true)
    }

    if let tuple = typeOrTuple as? PyTuple {
      for type in tuple.elements {
        switch self.isSubclass(object: object, of: type) {
        case .value(true): return .value(true)
        case .value(false): break // try next
        case .error(let e): return .error(e)
        }
      }
    }

    return self.call__subclasscheck__(type: object, super: typeOrTuple)
  }

  private func call__subclasscheck__(type: PyObject,
                                     super: PyObject) -> PyResult<Bool> {
    if let owner = type as? __subclasscheck__Owner {
      return owner.isSubtype(of: `super`)
    }

    switch self.callMethod(on: type, selector: "__subclasscheck__", arg: `super`) {
    case .value(let o):
      return self.isTrueBool(o)
    case .missingMethod:
      return .typeError("issubclass() arg 1 must be a class")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}