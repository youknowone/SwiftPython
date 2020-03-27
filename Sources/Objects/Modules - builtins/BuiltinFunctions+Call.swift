import Core

// In CPython:
// Objects -> call.c
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable file_length

// MARK: - Call

public enum CallResult {
  case value(PyObject)
  /// Object is not callable.
  case notCallable(PyBaseException)
  case error(PyBaseException)

  public var asResult: PyResult<PyObject> {
    switch self {
    case let .value(o):
      return .value(o)
    case let .error(e),
         let .notCallable(e):
      return .error(e)
    }
  }
}

extension BuiltinFunctions {

  /// Call `callable` with single positional argument.
  public func call(callable: PyObject, arg: PyObject) -> CallResult {
    return self.call(callable: callable, args: [arg], kwargs: nil)
  }

  /// Call with positional arguments and optional keyword arguments.
  ///
  /// - Parameters:
  ///   - callable: object to call
  ///   - args: positional arguments
  ///   - kwargs: keyword argument `dict`
  public func call(callable: PyObject,
                   args: PyObject,
                   kwargs: PyObject?) -> CallResult {
    let argsArray: [PyObject]
    switch ArgumentParser.unpackArgsTuple(args: args) {
    case let .value(o): argsArray = o
    case let .error(e): return .error(e)
    }

    switch ArgumentParser.unpackKwargsDict(kwargs: kwargs) {
    case let .value(kwargsDict):
      return self.call(callable: callable, args: argsArray, kwargs: kwargsDict)
    case let .error(e):
      return .error(e)
    }
  }

  /// Call with positional arguments and optional keyword arguments.
  ///
  /// - Parameters:
  ///   - callable: object to call
  ///   - args: positional arguments
  ///   - kwargs: keyword arguments
  public func call(callable: PyObject,
                   args: [PyObject] = [],
                   kwargs: PyDict? = nil) -> CallResult {
    if let owner = callable as? __call__Owner {
      switch owner.call(args: args, kwargs: kwargs) {
      case .value(let result):
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    let result = self.callMethod(on: callable,
                                 selector: .__call__,
                                 args: args,
                                 kwargs: kwargs)

    switch result {
    case let .value(o):
      return .value(o)
    case .missingMethod:
      let msg = "object of type '\(callable.typeName)' is not callable"
      return .notCallable(self.newTypeError(msg: msg))
    case let .notCallable(e):
      return .notCallable(e)
    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - Is callable

extension BuiltinFunctions {

  // sourcery: pymethod = callable
  /// callable(object)
  /// See [this](https://docs.python.org/3/library/functions.html#callable)
  public func isCallable(_ object: PyObject) -> PyResult<Bool> {
    if object is __call__Owner {
      return .value(true)
    }

    return self.hasAttribute(object, name: .__call__)
  }
}

// MARK: - Get method

public enum GetMethodResult {
  /// Method found (_yay!_), here is its value (_double yay!_).
  case value(PyObject)
  /// Such method does not exist.
  case notFound(PyBaseException)
  /// Raise error in VM.
  case error(PyBaseException)
}

internal protocol HasCustomGetMethod {
  func getMethod(selector: PyString) -> GetMethodResult
}

/// Helper for `getMethod`.
private enum FunctionAttribute {
  case function(PyFunction)
  case builtinFunction(PyBuiltinFunction)
}

/// Helper for `getMethod`.
private enum CallableProperty {
  case value(PyObject)
  case notFound
  case error(PyBaseException)

  fileprivate init(result: PyResult<PyObject>) {
    switch result {
    case let .value(o): self = .value(o)
    case let .error(e): self = .error(e)
    }
  }
}

extension BuiltinFunctions {

  public func hasMethod(object: PyObject,
                        selector: IdString) -> PyResult<Bool> {
    return self.hasMethod(object: object, selector: selector.value)
  }

  public func hasMethod(object: PyObject,
                        selector: PyString) -> PyResult<Bool> {
    let result = self.getMethod(object: object,
                                selector: selector,
                                allowsCallableProperties: false)

    switch result {
    case .value:
      return .value(true)
    case .notFound:
      return .value(false)
    case .error(let e):
      return .error(e)
    }
  }

  public func getMethod(object: PyObject,
                        selector: PyString) -> GetMethodResult {
    return self.getMethod(object: object,
                          selector: selector,
                          allowsCallableProperties: false)
  }

  /// DO NOT USE THIS METHOD!
  /// It is only there for `LOAD_METHOD` instruction.
  /// Use `getMethod` instead.
  ///
  /// (The difference between `loadMethod` and `getMethod` is that `loadMethod`
  /// will also include callable properties from `__dict__`.)
  public func loadMethod(object: PyObject,
                         selector: PyString) -> GetMethodResult {
    return self.getMethod(object: object,
                          selector: selector,
                          allowsCallableProperties: true)
  }

  // swiftlint:disable function_body_length

  /// int
  /// _PyObject_GetMethod(PyObject *obj, PyObject *name, PyObject **method)
  public func getMethod(object: PyObject,
                        selector: PyString,
                        allowsCallableProperties: Bool) -> GetMethodResult {
    // swiftlint:enable function_body_length

    if let obj = object as? HasCustomGetMethod {
      return obj.getMethod(selector: selector)
    }

    let staticProperty: PyObject?
    var descriptor: GetDescriptor?
    var functionAttribute: FunctionAttribute?

    switch object.type.lookup(name: selector) {
    case .value(let attr):
      staticProperty = attr
      if let fn = attr as? PyFunction {
        functionAttribute = .function(fn)
      } else if let fn = attr as? PyBuiltinFunction {
        functionAttribute = .builtinFunction(fn)
      } else {
        descriptor = GetDescriptor(object: object, attribute: attr)
      }
    case .notFound:
      staticProperty = nil
    case .error(let e):
      return .error(e)
    }

    if let descr = descriptor, descr.isData {
      return self.getMethod(descriptor: descr)
    }

    if allowsCallableProperties {
      switch  self.getCallableProperty(object: object, selector: selector) {
      case .value(let attr): return .value(attr)
      case .notFound: break // try other
      case .error(let e): return .error(e)
      }
    }

    switch functionAttribute {
    case .some(.function(let fn)): return .value(fn.bind(to: object))
    case .some(.builtinFunction(let fn)): return .value(fn.bind(to: object))
    case .none: break // try other
    }

    if let descr = descriptor {
      return self.getMethod(descriptor: descr)
    }

    if let p = staticProperty {
      return .value(p)
    }

    let msg = "'\(object.typeName)' object has no attribute '\(selector.value)'"
    return .notFound(Py.newAttributeError(msg: msg))
  }

  private func getMethod(descriptor: GetDescriptor) -> GetMethodResult {
    let result = descriptor.call()
    switch result {
    case let .value(o):
      return .value(o)
    case let .error(e):
      return .error(e)
    }
  }

  private func getCallableProperty(object: PyObject,
                                   selector: PyString) -> CallableProperty {
    guard let dict = Py.get__dict__(object: object) else {
      return .notFound
    }

    switch dict.get(key: selector) {
    case .value(let attr):
      // If we are dealing with classmethod/staticmethod on type then we have
      // to bind it.
      if let type = object as? PyType,
         let classMethod = attr as? PyClassMethod {
        let bound = classMethod.get(object: descriptorStaticMarker, type: type)
        return CallableProperty(result: bound)
      }

      if let type = object as? PyType,
         let classMethod = attr as? PyStaticMethod {
        let bound = classMethod.get(object: descriptorStaticMarker, type: type)
        return CallableProperty(result: bound)
      }

      return .value(attr)

    case .notFound:
      return .notFound
    case .error(let e):
      return .error(e)
    }
  }
}

// MARK: - Call method

public enum CallMethodResult {
  case value(PyObject)
  /// Such method does not exists.
  case missingMethod(PyBaseException)
  /// Method exists, but it is not callable.
  case notCallable(PyBaseException)
  case error(PyBaseException)

  public var asResult: PyResult<PyObject> {
    switch self {
    case let .value(o):
      return .value(o)
    case let .error(e),
         let .notCallable(e),
         let .missingMethod(e):
      return .error(e)
    }
  }
}

extension BuiltinFunctions {

  /// Call method with single positional argument.
  public func callMethod(on object: PyObject,
                         selector: IdString,
                         arg: PyObject) -> CallMethodResult {
    return self.callMethod(on: object, selector: selector.value, arg: arg)
  }

  /// Call method with single positional argument.
  public func callMethod(on object: PyObject,
                         selector: PyString,
                         arg: PyObject) -> CallMethodResult {
    return self.callMethod(on: object, selector: selector, args: [arg])
  }

  /// Call with positional arguments and optional keyword arguments.
  /// - Parameters:
  ///   - object: `self` argument
  ///   - selector: name of the method to call
  ///   - args: positional arguments
  ///   - kwargs: keyword argument `dict`
  public func callMethod(on object: PyObject,
                         selector: IdString,
                         args: PyObject,
                         kwargs: PyObject?) -> CallMethodResult {
    return self.callMethod(on: object,
                           selector: selector.value,
                           args: args,
                           kwargs: kwargs)
  }

  /// Call with positional arguments and optional keyword arguments.
  /// - Parameters:
  ///   - object: `self` argument
  ///   - selector: name of the method to call
  ///   - args: positional arguments
  ///   - kwargs: keyword argument `dict`
  public func callMethod(on object: PyObject,
                         selector: PyString,
                         args: PyObject,
                         kwargs: PyObject?) -> CallMethodResult {
    let argsArray: [PyObject]
    switch ArgumentParser.unpackArgsTuple(args: args) {
    case let .value(o): argsArray = o
    case let .error(e): return .error(e)
    }

    switch ArgumentParser.unpackKwargsDict(kwargs: kwargs) {
    case let .value(kwargsDict):
      return self.callMethod(on: object,
                             selector: selector,
                             args: argsArray,
                             kwargs: kwargsDict)
    case let .error(e):
      return .error(e)
    }
  }

  /// Call with positional arguments and optional keyword arguments.
  /// - Parameters:
  ///   - object: `self` argument
  ///   - selector: name of the method to call
  ///   - args: positional arguments
  ///   - kwargs: keyword arguments
  ///
  /// Based on CPython 'LOAD_METHOD' and 'CALL_METHOD'.
  public func callMethod(on object: PyObject,
                         selector: IdString,
                         args: [PyObject] = [],
                         kwargs: PyDict? = nil) -> CallMethodResult {
    return self.callMethod(on: object,
                           selector: selector.value,
                           args: args,
                           kwargs: kwargs)
  }

  /// Call with positional arguments and optional keyword arguments.
  /// - Parameters:
  ///   - object: `self` argument
  ///   - selector: name of the method to call
  ///   - args: positional arguments
  ///   - kwargs: keyword arguments
  ///
  /// Based on CPython 'LOAD_METHOD' and 'CALL_METHOD'.
  public func callMethod(on object: PyObject,
                         selector: PyString,
                         args: [PyObject] = [],
                         kwargs: PyDict? = nil) -> CallMethodResult {
    var method: PyObject
    switch self.getMethod(object: object, selector: selector) {
    case let .value(o):
      method = o
    case let .notFound(e):
      return .missingMethod(e)
    case let .error(e):
      return .error(e)
    }

    // If 'self' was not bound/captured we will manually do it.
    // We could also prepend 'object' to 'args' but this would do more allocations.
    //
    // In CPython:
    // - slot_tp_call(PyObject *self, PyObject *args, PyObject *kwds)
    // - lookup_maybe_method(PyObject *self, _Py_Identifier *attrid...)
    //
    // Examples:
    // >>> o1 = int.__add__ # type attribute -> unbound function
    // >>> o1(1,2)
    // 3
    // >>> o2 = (1).__add__ # object attribute -> bound method
    // >>> o2(1)
    // 2

    if let fn = method as? PyBuiltinFunction {
      method = fn.bind(to: object)
    }
    if let fn = method as? PyFunction {
      method = fn.bind(to: object)
    }

    switch self.call(callable: method, args: args, kwargs: kwargs) {
    case .value(let result):
      return .value(result)
    case .notCallable:
      let msg = "attribute of type '\(method.typeName)' is not callable"
      return .notCallable(self.newTypeError(msg: msg))
    case .error(let e):
      return .error(e)
    }
  }
}