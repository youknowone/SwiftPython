// swiftlint:disable type_name
// swiftlint:disable identifier_name
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable file_length

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// Why do we need so many different signatures?
//
// For example for ternary methods (self + 2 args) we have:
// - (PyObject, PyObject,  PyObject) -> PyFunctionResult
// - (PyObject, PyObject,  PyObject?) -> PyFunctionResult
// - (PyObject, PyObject?, PyObject?) -> PyFunctionResult
//
// So:
// Some ternary (and also binary and quartary) methods can be called with
// smaller number of arguments (in other words: some arguments are optional).
// On the Swift side we represent this with optional arg.
//
// For example:
// `PyString.strip(_ chars: PyObject?) -> String` has single optional argument.
// When called without argument we will pass `nil`.
// When called with single argument we will pass it.
// When called with more than 1 argument we will return error (hopefully).
//
// And of course, there are also different return types to handle…
//
// It is also a nice test to see if Swift can properly bind correct overload of `wrap`.
// Technically 'TernaryFunction' is super-type of 'TernaryFunctionOpt',
// because any function passed to 'TernaryFunction' can also be used in
// 'TernaryFunctionOpt' (functions are contravariant on parameter type).
//
// As for the names go to: https://en.wikipedia.org/wiki/Arity

/// Represents Swift function callable from Python context.
internal struct FunctionWrapper {

  // MARK: - Kind

  // Each kind holds a 'struct' with similar name in its payload.
  internal enum Kind {
  /// Python `__new__` function.
  case new(New)
  /// Python `__init__` function.
  case `init`(Init)
  /// Function with `*args` and `**kwargs`.
  case argsKwargsAsMethod(ArgsKwargsAsMethod)
  /// Function with `*args` and `**kwargs.
  case argsKwargsAsStaticFunction(ArgsKwargsAsStaticFunction)
  /// `() -> PyFunctionResultConvertible`
  case void_to_Result(Void_to_Result)
  /// `() -> Void`
  case void_to_Void(Void_to_Void)
  /// `(Zelf) -> PyFunctionResultConvertible`
  case self_to_Result(Self_to_Result)
  /// `(Zelf) -> Void`
  case self_to_Void(Self_to_Void)
  /// `(PyObject) -> PyFunctionResultConvertible`
  case object_to_Result(Object_to_Result)
  /// `(PyObject) -> Void`
  case object_to_Void(Object_to_Void)
  /// `(PyObject?) -> PyFunctionResultConvertible`
  case objectOpt_to_Result(ObjectOpt_to_Result)
  /// `(PyObject?) -> Void`
  case objectOpt_to_Void(ObjectOpt_to_Void)
  /// `(Zelf, PyObject) -> PyFunctionResultConvertible`
  case self_Object_to_Result(Self_Object_to_Result)
  /// `(Zelf, PyObject) -> Void`
  case self_Object_to_Void(Self_Object_to_Void)
  /// `(Zelf, PyObject?) -> PyFunctionResultConvertible`
  case self_ObjectOpt_to_Result(Self_ObjectOpt_to_Result)
  /// `(Zelf, PyObject?) -> Void`
  case self_ObjectOpt_to_Void(Self_ObjectOpt_to_Void)
  /// `(PyObject?, PyObject?) -> PyFunctionResultConvertible`
  case objectOpt_ObjectOpt_to_Result(ObjectOpt_ObjectOpt_to_Result)
  /// `(PyObject?, PyObject?) -> Void`
  case objectOpt_ObjectOpt_to_Void(ObjectOpt_ObjectOpt_to_Void)
  /// `(Zelf) -> (PyObject) -> PyFunctionResultConvertible`
  case self_then_Object_to_Result(Self_then_Object_to_Result)
  /// `(Zelf) -> (PyObject) -> Void`
  case self_then_Object_to_Void(Self_then_Object_to_Void)
  /// `(Zelf) -> (PyObject?) -> PyFunctionResultConvertible`
  case self_then_ObjectOpt_to_Result(Self_then_ObjectOpt_to_Result)
  /// `(Zelf) -> (PyObject?) -> Void`
  case self_then_ObjectOpt_to_Void(Self_then_ObjectOpt_to_Void)
  /// `(Zelf) -> () -> PyFunctionResultConvertible`
  case self_then_Void_to_Result(Self_then_Void_to_Result)
  /// `(Zelf) -> () -> Void`
  case self_then_Void_to_Void(Self_then_Void_to_Void)
  /// `(PyObject, PyObject) -> PyFunctionResultConvertible`
  case object_Object_to_Result(Object_Object_to_Result)
  /// `(PyObject, PyObject) -> Void`
  case object_Object_to_Void(Object_Object_to_Void)
  /// `(PyObject, PyObject?) -> PyFunctionResultConvertible`
  case object_ObjectOpt_to_Result(Object_ObjectOpt_to_Result)
  /// `(PyObject, PyObject?) -> Void`
  case object_ObjectOpt_to_Void(Object_ObjectOpt_to_Void)
  /// `(PyObject) -> (PyObject) -> PyFunctionResultConvertible`
  case object_then_Object_to_Result(Object_then_Object_to_Result)
  /// `(PyObject) -> (PyObject) -> Void`
  case object_then_Object_to_Void(Object_then_Object_to_Void)
  /// `(PyObject) -> (PyObject?) -> PyFunctionResultConvertible`
  case object_then_ObjectOpt_to_Result(Object_then_ObjectOpt_to_Result)
  /// `(PyObject) -> (PyObject?) -> Void`
  case object_then_ObjectOpt_to_Void(Object_then_ObjectOpt_to_Void)
  /// `(Zelf) -> (PyObject, PyObject) -> PyFunctionResultConvertible`
  case self_then_Object_Object_to_Result(Self_then_Object_Object_to_Result)
  /// `(Zelf) -> (PyObject, PyObject) -> Void`
  case self_then_Object_Object_to_Void(Self_then_Object_Object_to_Void)
  /// `(Zelf) -> (PyObject, PyObject?) -> PyFunctionResultConvertible`
  case self_then_Object_ObjectOpt_to_Result(Self_then_Object_ObjectOpt_to_Result)
  /// `(Zelf) -> (PyObject, PyObject?) -> Void`
  case self_then_Object_ObjectOpt_to_Void(Self_then_Object_ObjectOpt_to_Void)
  /// `(Zelf) -> (PyObject?, PyObject?) -> PyFunctionResultConvertible`
  case self_then_ObjectOpt_ObjectOpt_to_Result(Self_then_ObjectOpt_ObjectOpt_to_Result)
  /// `(Zelf) -> (PyObject?, PyObject?) -> Void`
  case self_then_ObjectOpt_ObjectOpt_to_Void(Self_then_ObjectOpt_ObjectOpt_to_Void)
  /// `(PyObject, PyObject, PyObject) -> PyFunctionResultConvertible`
  case object_Object_Object_to_Result(Object_Object_Object_to_Result)
  /// `(PyObject, PyObject, PyObject) -> Void`
  case object_Object_Object_to_Void(Object_Object_Object_to_Void)
  /// `(PyObject, PyObject, PyObject?) -> PyFunctionResultConvertible`
  case object_Object_ObjectOpt_to_Result(Object_Object_ObjectOpt_to_Result)
  /// `(PyObject, PyObject, PyObject?) -> Void`
  case object_Object_ObjectOpt_to_Void(Object_Object_ObjectOpt_to_Void)
  /// `(PyObject, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  case object_ObjectOpt_ObjectOpt_to_Result(Object_ObjectOpt_ObjectOpt_to_Result)
  /// `(PyObject, PyObject?, PyObject?) -> Void`
  case object_ObjectOpt_ObjectOpt_to_Void(Object_ObjectOpt_ObjectOpt_to_Void)
  /// `(PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  case objectOpt_ObjectOpt_ObjectOpt_to_Result(ObjectOpt_ObjectOpt_ObjectOpt_to_Result)
  /// `(PyObject?, PyObject?, PyObject?) -> Void`
  case objectOpt_ObjectOpt_ObjectOpt_to_Void(ObjectOpt_ObjectOpt_ObjectOpt_to_Void)
  /// `(Zelf) -> (PyObject, PyObject, PyObject) -> PyFunctionResultConvertible`
  case self_then_Object_Object_Object_to_Result(Self_then_Object_Object_Object_to_Result)
  /// `(Zelf) -> (PyObject, PyObject, PyObject) -> Void`
  case self_then_Object_Object_Object_to_Void(Self_then_Object_Object_Object_to_Void)
  /// `(Zelf) -> (PyObject, PyObject, PyObject?) -> PyFunctionResultConvertible`
  case self_then_Object_Object_ObjectOpt_to_Result(Self_then_Object_Object_ObjectOpt_to_Result)
  /// `(Zelf) -> (PyObject, PyObject, PyObject?) -> Void`
  case self_then_Object_Object_ObjectOpt_to_Void(Self_then_Object_Object_ObjectOpt_to_Void)
  /// `(Zelf) -> (PyObject, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  case self_then_Object_ObjectOpt_ObjectOpt_to_Result(Self_then_Object_ObjectOpt_ObjectOpt_to_Result)
  /// `(Zelf) -> (PyObject, PyObject?, PyObject?) -> Void`
  case self_then_Object_ObjectOpt_ObjectOpt_to_Void(Self_then_Object_ObjectOpt_ObjectOpt_to_Void)
  /// `(Zelf) -> (PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  case self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result)
  /// `(Zelf) -> (PyObject?, PyObject?, PyObject?) -> Void`
  case self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void)
  /// `(PyObject, PyObject, PyObject, PyObject) -> PyFunctionResultConvertible`
  case object_Object_Object_Object_to_Result(Object_Object_Object_Object_to_Result)
  /// `(PyObject, PyObject, PyObject, PyObject) -> Void`
  case object_Object_Object_Object_to_Void(Object_Object_Object_Object_to_Void)
  /// `(PyObject, PyObject, PyObject, PyObject?) -> PyFunctionResultConvertible`
  case object_Object_Object_ObjectOpt_to_Result(Object_Object_Object_ObjectOpt_to_Result)
  /// `(PyObject, PyObject, PyObject, PyObject?) -> Void`
  case object_Object_Object_ObjectOpt_to_Void(Object_Object_Object_ObjectOpt_to_Void)
  /// `(PyObject, PyObject, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  case object_Object_ObjectOpt_ObjectOpt_to_Result(Object_Object_ObjectOpt_ObjectOpt_to_Result)
  /// `(PyObject, PyObject, PyObject?, PyObject?) -> Void`
  case object_Object_ObjectOpt_ObjectOpt_to_Void(Object_Object_ObjectOpt_ObjectOpt_to_Void)
  /// `(PyObject, PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  case object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result)
  /// `(PyObject, PyObject?, PyObject?, PyObject?) -> Void`
  case object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void)
  /// `(PyObject?, PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  case objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result)
  /// `(PyObject?, PyObject?, PyObject?, PyObject?) -> Void`
  case objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void)
  }

  // MARK: - Cast self

  /// Cast given object to a specific type, 1st argument is a function name.
  internal typealias CastSelf<Zelf> = (String, PyObject) -> PyResult<Zelf>
  /// Cast given object to a specific type.
  internal typealias CastSelfOptional<Zelf> = (PyObject) -> Zelf?

  // MARK: - Properties

  internal let kind: Kind

  // MARK: - Name

  /// The name of the built-in function/method.
  internal var name: String {
    // Just delegate to specific wrapper.
    switch self.kind {
    case let .new(w): return w.fnName
    case let .`init`(w): return w.fnName
    case let .argsKwargsAsMethod(w): return w.fnName
    case let .argsKwargsAsStaticFunction(w): return w.fnName
    case let .void_to_Result(w): return w.fnName
    case let .void_to_Void(w): return w.fnName
    case let .self_to_Result(w): return w.fnName
    case let .self_to_Void(w): return w.fnName
    case let .object_to_Result(w): return w.fnName
    case let .object_to_Void(w): return w.fnName
    case let .objectOpt_to_Result(w): return w.fnName
    case let .objectOpt_to_Void(w): return w.fnName
    case let .self_Object_to_Result(w): return w.fnName
    case let .self_Object_to_Void(w): return w.fnName
    case let .self_ObjectOpt_to_Result(w): return w.fnName
    case let .self_ObjectOpt_to_Void(w): return w.fnName
    case let .objectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .objectOpt_ObjectOpt_to_Void(w): return w.fnName
    case let .self_then_Object_to_Result(w): return w.fnName
    case let .self_then_Object_to_Void(w): return w.fnName
    case let .self_then_ObjectOpt_to_Result(w): return w.fnName
    case let .self_then_ObjectOpt_to_Void(w): return w.fnName
    case let .self_then_Void_to_Result(w): return w.fnName
    case let .self_then_Void_to_Void(w): return w.fnName
    case let .object_Object_to_Result(w): return w.fnName
    case let .object_Object_to_Void(w): return w.fnName
    case let .object_ObjectOpt_to_Result(w): return w.fnName
    case let .object_ObjectOpt_to_Void(w): return w.fnName
    case let .object_then_Object_to_Result(w): return w.fnName
    case let .object_then_Object_to_Void(w): return w.fnName
    case let .object_then_ObjectOpt_to_Result(w): return w.fnName
    case let .object_then_ObjectOpt_to_Void(w): return w.fnName
    case let .self_then_Object_Object_to_Result(w): return w.fnName
    case let .self_then_Object_Object_to_Void(w): return w.fnName
    case let .self_then_Object_ObjectOpt_to_Result(w): return w.fnName
    case let .self_then_Object_ObjectOpt_to_Void(w): return w.fnName
    case let .self_then_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .self_then_ObjectOpt_ObjectOpt_to_Void(w): return w.fnName
    case let .object_Object_Object_to_Result(w): return w.fnName
    case let .object_Object_Object_to_Void(w): return w.fnName
    case let .object_Object_ObjectOpt_to_Result(w): return w.fnName
    case let .object_Object_ObjectOpt_to_Void(w): return w.fnName
    case let .object_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .object_ObjectOpt_ObjectOpt_to_Void(w): return w.fnName
    case let .objectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .objectOpt_ObjectOpt_ObjectOpt_to_Void(w): return w.fnName
    case let .self_then_Object_Object_Object_to_Result(w): return w.fnName
    case let .self_then_Object_Object_Object_to_Void(w): return w.fnName
    case let .self_then_Object_Object_ObjectOpt_to_Result(w): return w.fnName
    case let .self_then_Object_Object_ObjectOpt_to_Void(w): return w.fnName
    case let .self_then_Object_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .self_then_Object_ObjectOpt_ObjectOpt_to_Void(w): return w.fnName
    case let .self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(w): return w.fnName
    case let .object_Object_Object_Object_to_Result(w): return w.fnName
    case let .object_Object_Object_Object_to_Void(w): return w.fnName
    case let .object_Object_Object_ObjectOpt_to_Result(w): return w.fnName
    case let .object_Object_Object_ObjectOpt_to_Void(w): return w.fnName
    case let .object_Object_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .object_Object_ObjectOpt_ObjectOpt_to_Void(w): return w.fnName
    case let .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(w): return w.fnName
    case let .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(w): return w.fnName
    }
  }

  // MARK: - Call

  /// Call the stored function with provided arguments.
  internal func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
    // Just delegate to specific wrapper.
    switch self.kind {
    case let .new(w): return w.call(args: args, kwargs: kwargs)
    case let .`init`(w): return w.call(args: args, kwargs: kwargs)
    case let .argsKwargsAsMethod(w): return w.call(args: args, kwargs: kwargs)
    case let .argsKwargsAsStaticFunction(w): return w.call(args: args, kwargs: kwargs)
    case let .void_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .void_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .objectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .objectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_Object_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_Object_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .objectOpt_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .objectOpt_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Void_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Void_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_then_Object_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_then_Object_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_then_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_then_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_Object_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_Object_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_ObjectOpt_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_ObjectOpt_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_Object_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_Object_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_ObjectOpt_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_ObjectOpt_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .objectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .objectOpt_ObjectOpt_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_Object_Object_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_Object_Object_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_Object_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_Object_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_ObjectOpt_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_Object_ObjectOpt_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_Object_Object_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_Object_Object_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_Object_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_Object_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_ObjectOpt_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_Object_ObjectOpt_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    case let .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(w): return w.call(args: args, kwargs: kwargs)
    }
  }

  // MARK: - () -> PyFunctionResultConvertible

  /// Positional nullary: no arguments (or an empty tuple of arguments, also known as `Void` argument).
  ///
  /// `() -> PyFunctionResultConvertible`
  internal typealias Void_to_Result_Fn<R: PyFunctionResultConvertible> = () -> R

  internal struct Void_to_Result {
    fileprivate let fnName: String
    private let fn: () -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Void_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { () -> PyFunctionResult in
          // This function returns 'R'
          let result = fn()
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn()
      default:
        return .typeError("'\(self.fnName)' takes no arguments (\(args.count) given)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Void_to_Result_Fn<R>
  ) {
    let wrapper = Void_to_Result(name: name, fn: fn)
    self.kind = .void_to_Result(wrapper)
  }

  // MARK: - () -> Void

  /// Positional nullary: no arguments (or an empty tuple of arguments, also known as `Void` argument).
  ///
  /// `() -> Void`
  internal typealias Void_to_Void_Fn = () -> Void

  internal struct Void_to_Void {
    fileprivate let fnName: String
    private let fn: () -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Void_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { () -> PyFunctionResult in
          // This function returns 'Void'
          fn()
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn()
      default:
        return .typeError("'\(self.fnName)' takes no arguments (\(args.count) given)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Void_to_Void_Fn
  ) {
    let wrapper = Void_to_Void(name: name, fn: fn)
    self.kind = .void_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> PyFunctionResultConvertible

  /// Positional unary: single `self` argument.
  ///
  /// `(Zelf) -> PyFunctionResultConvertible`
  internal typealias Self_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> R

  internal struct Self_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0])
      default:
        return .typeError("'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> Void

  /// Positional unary: single `self` argument.
  ///
  /// `(Zelf) -> Void`
  internal typealias Self_to_Void_Fn<Zelf> = (Zelf) -> Void

  internal struct Self_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0])
      default:
        return .typeError("'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_to_Void(wrapper)
  }

  // MARK: - (PyObject) -> PyFunctionResultConvertible

  /// Positional unary: single `object` argument.
  ///
  /// `(PyObject) -> PyFunctionResultConvertible`
  internal typealias Object_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject) -> R

  internal struct Object_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0])
      default:
        return .typeError("'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_to_Result_Fn<R>
  ) {
    let wrapper = Object_to_Result(name: name, fn: fn)
    self.kind = .object_to_Result(wrapper)
  }

  // MARK: - (PyObject) -> Void

  /// Positional unary: single `object` argument.
  ///
  /// `(PyObject) -> Void`
  internal typealias Object_to_Void_Fn = (PyObject) -> Void

  internal struct Object_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0])
      default:
        return .typeError("'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_to_Void_Fn
  ) {
    let wrapper = Object_to_Void(name: name, fn: fn)
    self.kind = .object_to_Void(wrapper)
  }

  // MARK: - (PyObject?) -> PyFunctionResultConvertible

  /// Positional unary: single optional `object` argument.
  ///
  /// `(PyObject?) -> PyFunctionResultConvertible`
  internal typealias ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject?) -> R

  internal struct ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn(nil)
      case 1:
        return self.fn(args[0])
      default:
        return .typeError("'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .objectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject?) -> Void

  /// Positional unary: single optional `object` argument.
  ///
  /// `(PyObject?) -> Void`
  internal typealias ObjectOpt_to_Void_Fn = (PyObject?) -> Void

  internal struct ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn(nil)
      case 1:
        return self.fn(args[0])
      default:
        return .typeError("'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping ObjectOpt_to_Void_Fn
  ) {
    let wrapper = ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .objectOpt_to_Void(wrapper)
  }

  // MARK: - (Zelf, PyObject) -> PyFunctionResultConvertible

  /// Positional binary: tuple of `self` and `object`.
  ///
  /// `(Zelf, PyObject) -> PyFunctionResultConvertible`
  internal typealias Self_Object_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf, PyObject) -> R

  internal struct Self_Object_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_Object_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf, arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_Object_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_Object_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_Object_to_Result(wrapper)
  }

  // MARK: - (Zelf, PyObject) -> Void

  /// Positional binary: tuple of `self` and `object`.
  ///
  /// `(Zelf, PyObject) -> Void`
  internal typealias Self_Object_to_Void_Fn<Zelf> = (Zelf, PyObject) -> Void

  internal struct Self_Object_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_Object_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf, arg1)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_Object_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_Object_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_Object_to_Void(wrapper)
  }

  // MARK: - (Zelf, PyObject?) -> PyFunctionResultConvertible

  /// Positional binary: tuple of `self` and optional `object`.
  ///
  /// `(Zelf, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Self_ObjectOpt_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf, PyObject?) -> R

  internal struct Self_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_ObjectOpt_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf, arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_ObjectOpt_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_ObjectOpt_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Zelf, PyObject?) -> Void

  /// Positional binary: tuple of `self` and optional `object`.
  ///
  /// `(Zelf, PyObject?) -> Void`
  internal typealias Self_ObjectOpt_to_Void_Fn<Zelf> = (Zelf, PyObject?) -> Void

  internal struct Self_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_ObjectOpt_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf, arg1)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_ObjectOpt_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_ObjectOpt_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (PyObject?, PyObject?) -> PyFunctionResultConvertible

  /// Positional binary: tuple of 2 `objects` (both optional).
  ///
  /// `(PyObject?, PyObject?) -> PyFunctionResultConvertible`
  internal typealias ObjectOpt_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject?, PyObject?) -> R

  internal struct ObjectOpt_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping ObjectOpt_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject?, arg1: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn(nil, nil)
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping ObjectOpt_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .objectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject?, PyObject?) -> Void

  /// Positional binary: tuple of 2 `objects` (both optional).
  ///
  /// `(PyObject?, PyObject?) -> Void`
  internal typealias ObjectOpt_ObjectOpt_to_Void_Fn = (PyObject?, PyObject?) -> Void

  internal struct ObjectOpt_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping ObjectOpt_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject?, arg1: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn(nil, nil)
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping ObjectOpt_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = ObjectOpt_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .objectOpt_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject) -> PyFunctionResultConvertible

  /// Positional binary: `self` and then `object`.
  ///
  /// `(Zelf) -> (PyObject) -> PyFunctionResultConvertible`
  internal typealias Self_then_Object_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject) -> R

  internal struct Self_then_Object_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_Object_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_Object_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject) -> Void

  /// Positional binary: `self` and then `object`.
  ///
  /// `(Zelf) -> (PyObject) -> Void`
  internal typealias Self_then_Object_to_Void_Fn<Zelf> = (Zelf) -> (PyObject) -> Void

  internal struct Self_then_Object_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_Object_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)(arg1)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_Object_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject?) -> PyFunctionResultConvertible

  /// Positional binary: `self` and then optional `object`.
  ///
  /// `(Zelf) -> (PyObject?) -> PyFunctionResultConvertible`
  internal typealias Self_then_ObjectOpt_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject?) -> R

  internal struct Self_then_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_ObjectOpt_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_ObjectOpt_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_ObjectOpt_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject?) -> Void

  /// Positional binary: `self` and then optional `object`.
  ///
  /// `(Zelf) -> (PyObject?) -> Void`
  internal typealias Self_then_ObjectOpt_to_Void_Fn<Zelf> = (Zelf) -> (PyObject?) -> Void

  internal struct Self_then_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_ObjectOpt_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)(arg1)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_ObjectOpt_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_ObjectOpt_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> () -> PyFunctionResultConvertible

  /// Positional binary: property getter disguised as a method.
  ///
  /// `(Zelf) -> () -> PyFunctionResultConvertible`
  internal typealias Self_then_Void_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> () -> R

  internal struct Self_then_Void_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_Void_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)()
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0])
      default:
        return .typeError("'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_Void_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Void_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Void_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> () -> Void

  /// Positional binary: property getter disguised as a method.
  ///
  /// `(Zelf) -> () -> Void`
  internal typealias Self_then_Void_to_Void_Fn<Zelf> = (Zelf) -> () -> Void

  internal struct Self_then_Void_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_Void_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)()
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0])
      default:
        return .typeError("'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_Void_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Void_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Void_to_Void(wrapper)
  }

  // MARK: - (PyObject, PyObject) -> PyFunctionResultConvertible

  /// Positional binary: tuple of 2 `objects`.
  ///
  /// `(PyObject, PyObject) -> PyFunctionResultConvertible`
  internal typealias Object_Object_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject, PyObject) -> R

  internal struct Object_Object_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_Object_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_Object_to_Result_Fn<R>
  ) {
    let wrapper = Object_Object_to_Result(name: name, fn: fn)
    self.kind = .object_Object_to_Result(wrapper)
  }

  // MARK: - (PyObject, PyObject) -> Void

  /// Positional binary: tuple of 2 `objects`.
  ///
  /// `(PyObject, PyObject) -> Void`
  internal typealias Object_Object_to_Void_Fn = (PyObject, PyObject) -> Void

  internal struct Object_Object_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_Object_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_Object_to_Void_Fn
  ) {
    let wrapper = Object_Object_to_Void(name: name, fn: fn)
    self.kind = .object_Object_to_Void(wrapper)
  }

  // MARK: - (PyObject, PyObject?) -> PyFunctionResultConvertible

  /// Positional binary: tuple of 2 `objects` (2nd one is optional).
  ///
  /// `(PyObject, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Object_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject, PyObject?) -> R

  internal struct Object_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = Object_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject, PyObject?) -> Void

  /// Positional binary: tuple of 2 `objects` (2nd one is optional).
  ///
  /// `(PyObject, PyObject?) -> Void`
  internal typealias Object_ObjectOpt_to_Void_Fn = (PyObject, PyObject?) -> Void

  internal struct Object_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = Object_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .object_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (PyObject) -> (PyObject) -> PyFunctionResultConvertible

  /// Positional binary: `object` and then another `object`.
  ///
  /// `(PyObject) -> (PyObject) -> PyFunctionResultConvertible`
  internal typealias Object_then_Object_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject) -> (PyObject) -> R

  internal struct Object_then_Object_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_then_Object_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0)(arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_then_Object_to_Result_Fn<R>
  ) {
    let wrapper = Object_then_Object_to_Result(name: name, fn: fn)
    self.kind = .object_then_Object_to_Result(wrapper)
  }

  // MARK: - (PyObject) -> (PyObject) -> Void

  /// Positional binary: `object` and then another `object`.
  ///
  /// `(PyObject) -> (PyObject) -> Void`
  internal typealias Object_then_Object_to_Void_Fn = (PyObject) -> (PyObject) -> Void

  internal struct Object_then_Object_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_then_Object_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0)(arg1)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_then_Object_to_Void_Fn
  ) {
    let wrapper = Object_then_Object_to_Void(name: name, fn: fn)
    self.kind = .object_then_Object_to_Void(wrapper)
  }

  // MARK: - (PyObject) -> (PyObject?) -> PyFunctionResultConvertible

  /// Positional binary: `object` and then optional `object`.
  ///
  /// `(PyObject) -> (PyObject?) -> PyFunctionResultConvertible`
  internal typealias Object_then_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject) -> (PyObject?) -> R

  internal struct Object_then_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_then_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0)(arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_then_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = Object_then_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_then_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject) -> (PyObject?) -> Void

  /// Positional binary: `object` and then optional `object`.
  ///
  /// `(PyObject) -> (PyObject?) -> Void`
  internal typealias Object_then_ObjectOpt_to_Void_Fn = (PyObject) -> (PyObject?) -> Void

  internal struct Object_then_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_then_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0)(arg1)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_then_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = Object_then_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .object_then_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject) -> PyFunctionResultConvertible

  /// Positional ternary: `self` and then tuple of 2 `objects`.
  ///
  /// `(Zelf) -> (PyObject, PyObject) -> PyFunctionResultConvertible`
  internal typealias Self_then_Object_Object_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject, PyObject) -> R

  internal struct Self_then_Object_Object_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_Object_Object_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1, arg2)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_Object_Object_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_Object_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_Object_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject) -> Void

  /// Positional ternary: `self` and then tuple of 2 `objects`.
  ///
  /// `(Zelf) -> (PyObject, PyObject) -> Void`
  internal typealias Self_then_Object_Object_to_Void_Fn<Zelf> = (Zelf) -> (PyObject, PyObject) -> Void

  internal struct Self_then_Object_Object_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_Object_Object_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)(arg1, arg2)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_Object_Object_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_Object_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_Object_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject?) -> PyFunctionResultConvertible

  /// Positional ternary: `self` and then tuple of 2 `objects` (last one is optional).
  ///
  /// `(Zelf) -> (PyObject, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Self_then_Object_ObjectOpt_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject, PyObject?) -> R

  internal struct Self_then_Object_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_Object_ObjectOpt_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1, arg2)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_Object_ObjectOpt_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_ObjectOpt_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject?) -> Void

  /// Positional ternary: `self` and then tuple of 2 `objects` (last one is optional).
  ///
  /// `(Zelf) -> (PyObject, PyObject?) -> Void`
  internal typealias Self_then_Object_ObjectOpt_to_Void_Fn<Zelf> = (Zelf) -> (PyObject, PyObject?) -> Void

  internal struct Self_then_Object_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_Object_ObjectOpt_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)(arg1, arg2)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_Object_ObjectOpt_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_ObjectOpt_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject?, PyObject?) -> PyFunctionResultConvertible

  /// Positional ternary: `self` and then tuple of 2 `objects` (both optional).
  ///
  /// `(Zelf) -> (PyObject?, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Self_then_ObjectOpt_ObjectOpt_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject?, PyObject?) -> R

  internal struct Self_then_ObjectOpt_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_ObjectOpt_ObjectOpt_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?, arg2: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1, arg2)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_ObjectOpt_ObjectOpt_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject?, PyObject?) -> Void

  /// Positional ternary: `self` and then tuple of 2 `objects` (both optional).
  ///
  /// `(Zelf) -> (PyObject?, PyObject?) -> Void`
  internal typealias Self_then_ObjectOpt_ObjectOpt_to_Void_Fn<Zelf> = (Zelf) -> (PyObject?, PyObject?) -> Void

  internal struct Self_then_ObjectOpt_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_ObjectOpt_ObjectOpt_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?, arg2: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)(arg1, arg2)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_ObjectOpt_ObjectOpt_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_ObjectOpt_ObjectOpt_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_ObjectOpt_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject) -> PyFunctionResultConvertible

  /// Positional ternary: tuple of 3 `objects`.
  ///
  /// `(PyObject, PyObject, PyObject) -> PyFunctionResultConvertible`
  internal typealias Object_Object_Object_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject, PyObject, PyObject) -> R

  internal struct Object_Object_Object_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_Object_Object_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1, arg2)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_Object_Object_to_Result_Fn<R>
  ) {
    let wrapper = Object_Object_Object_to_Result(name: name, fn: fn)
    self.kind = .object_Object_Object_to_Result(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject) -> Void

  /// Positional ternary: tuple of 3 `objects`.
  ///
  /// `(PyObject, PyObject, PyObject) -> Void`
  internal typealias Object_Object_Object_to_Void_Fn = (PyObject, PyObject, PyObject) -> Void

  internal struct Object_Object_Object_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_Object_Object_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1, arg2)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_Object_Object_to_Void_Fn
  ) {
    let wrapper = Object_Object_Object_to_Void(name: name, fn: fn)
    self.kind = .object_Object_Object_to_Void(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject?) -> PyFunctionResultConvertible

  /// Positional ternary: tuple of 3 `objects` (last one is optional).
  ///
  /// `(PyObject, PyObject, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Object_Object_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject, PyObject, PyObject?) -> R

  internal struct Object_Object_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_Object_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1, arg2)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_Object_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = Object_Object_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_Object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject?) -> Void

  /// Positional ternary: tuple of 3 `objects` (last one is optional).
  ///
  /// `(PyObject, PyObject, PyObject?) -> Void`
  internal typealias Object_Object_ObjectOpt_to_Void_Fn = (PyObject, PyObject, PyObject?) -> Void

  internal struct Object_Object_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_Object_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1, arg2)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_Object_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = Object_Object_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .object_Object_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (PyObject, PyObject?, PyObject?) -> PyFunctionResultConvertible

  /// Positional ternary: tuple of 3 `objects` (2nd and 3rd are optional).
  ///
  /// `(PyObject, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Object_ObjectOpt_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject, PyObject?, PyObject?) -> R

  internal struct Object_ObjectOpt_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_ObjectOpt_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?, arg2: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1, arg2)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_ObjectOpt_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = Object_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject, PyObject?, PyObject?) -> Void

  /// Positional ternary: tuple of 3 `objects` (2nd and 3rd are optional).
  ///
  /// `(PyObject, PyObject?, PyObject?) -> Void`
  internal typealias Object_ObjectOpt_ObjectOpt_to_Void_Fn = (PyObject, PyObject?, PyObject?) -> Void

  internal struct Object_ObjectOpt_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_ObjectOpt_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?, arg2: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1, arg2)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_ObjectOpt_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = Object_ObjectOpt_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .object_ObjectOpt_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible

  /// Positional ternary: tuple of 3 `objects` (all optional).
  ///
  /// `(PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  internal typealias ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject?, PyObject?, PyObject?) -> R

  internal struct ObjectOpt_ObjectOpt_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject?, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject?, arg1: PyObject?, arg2: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1, arg2)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn(nil, nil, nil)
      case 1:
        return self.fn(args[0], nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = ObjectOpt_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .objectOpt_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject?, PyObject?, PyObject?) -> Void

  /// Positional ternary: tuple of 3 `objects` (all optional).
  ///
  /// `(PyObject?, PyObject?, PyObject?) -> Void`
  internal typealias ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn = (PyObject?, PyObject?, PyObject?) -> Void

  internal struct ObjectOpt_ObjectOpt_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject?, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject?, arg1: PyObject?, arg2: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1, arg2)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn(nil, nil, nil)
      case 1:
        return self.fn(args[0], nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil)
      case 3:
        return self.fn(args[0], args[1], args[2])
      default:
        return .typeError("expected 3 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = ObjectOpt_ObjectOpt_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .objectOpt_ObjectOpt_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject, PyObject) -> PyFunctionResultConvertible

  /// Positional quartary: `self` and then tuple of 3 `objects`.
  ///
  /// `(Zelf) -> (PyObject, PyObject, PyObject) -> PyFunctionResultConvertible`
  internal typealias Self_then_Object_Object_Object_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject, PyObject, PyObject) -> R

  internal struct Self_then_Object_Object_Object_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject, PyObject) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_Object_Object_Object_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject, arg3: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1, arg2, arg3)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_Object_Object_Object_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_Object_Object_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_Object_Object_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject, PyObject) -> Void

  /// Positional quartary: `self` and then tuple of 3 `objects`.
  ///
  /// `(Zelf) -> (PyObject, PyObject, PyObject) -> Void`
  internal typealias Self_then_Object_Object_Object_to_Void_Fn<Zelf> = (Zelf) -> (PyObject, PyObject, PyObject) -> Void

  internal struct Self_then_Object_Object_Object_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject, PyObject) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_Object_Object_Object_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject, arg3: PyObject) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)(arg1, arg2, arg3)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_Object_Object_Object_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_Object_Object_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_Object_Object_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject, PyObject?) -> PyFunctionResultConvertible

  /// Positional quartary: `self` and then tuple of 3 `objects` (last one is optional).
  ///
  /// `(Zelf) -> (PyObject, PyObject, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Self_then_Object_Object_ObjectOpt_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject, PyObject, PyObject?) -> R

  internal struct Self_then_Object_Object_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_Object_Object_ObjectOpt_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject, arg3: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1, arg2, arg3)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_Object_Object_ObjectOpt_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_Object_ObjectOpt_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_Object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject, PyObject?) -> Void

  /// Positional quartary: `self` and then tuple of 3 `objects` (last one is optional).
  ///
  /// `(Zelf) -> (PyObject, PyObject, PyObject?) -> Void`
  internal typealias Self_then_Object_Object_ObjectOpt_to_Void_Fn<Zelf> = (Zelf) -> (PyObject, PyObject, PyObject?) -> Void

  internal struct Self_then_Object_Object_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_Object_Object_ObjectOpt_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject, arg3: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)(arg1, arg2, arg3)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_Object_Object_ObjectOpt_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_Object_ObjectOpt_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_Object_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject?, PyObject?) -> PyFunctionResultConvertible

  /// Positional quartary: `self` and then tuple of 3 `objects` (2nd and 3rd are optional).
  ///
  /// `(Zelf) -> (PyObject, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Self_then_Object_ObjectOpt_ObjectOpt_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject, PyObject?, PyObject?) -> R

  internal struct Self_then_Object_ObjectOpt_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_Object_ObjectOpt_ObjectOpt_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1, arg2, arg3)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_Object_ObjectOpt_ObjectOpt_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject, PyObject?, PyObject?) -> Void

  /// Positional quartary: `self` and then tuple of 3 `objects` (2nd and 3rd are optional).
  ///
  /// `(Zelf) -> (PyObject, PyObject?, PyObject?) -> Void`
  internal typealias Self_then_Object_ObjectOpt_ObjectOpt_to_Void_Fn<Zelf> = (Zelf) -> (PyObject, PyObject?, PyObject?) -> Void

  internal struct Self_then_Object_ObjectOpt_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_Object_ObjectOpt_ObjectOpt_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)(arg1, arg2, arg3)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_Object_ObjectOpt_ObjectOpt_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_Object_ObjectOpt_ObjectOpt_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_Object_ObjectOpt_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible

  /// Positional quartary: `self` and then tuple of 3 `objects` (all optional).
  ///
  /// `(Zelf) -> (PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject?, PyObject?, PyObject?) -> R

  internal struct Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1, arg2, arg3)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil, nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Zelf) -> (PyObject?, PyObject?, PyObject?) -> Void

  /// Positional quartary: `self` and then tuple of 3 `objects` (all optional).
  ///
  /// `(Zelf) -> (PyObject?, PyObject?, PyObject?) -> Void`
  internal typealias Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn<Zelf> = (Zelf) -> (PyObject?, PyObject?, PyObject?) -> Void

  internal struct Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf>(
      name: String,
      fn: @escaping Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn<Zelf>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'Void'
          fn(zelf)(arg1, arg2, arg3)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil, nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf>(
    name: String,
    fn: @escaping Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn<Zelf>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject, PyObject) -> PyFunctionResultConvertible

  /// Positional quartary: `tuple of 4 `objects`.
  ///
  /// `(PyObject, PyObject, PyObject, PyObject) -> PyFunctionResultConvertible`
  internal typealias Object_Object_Object_Object_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject, PyObject, PyObject, PyObject) -> R

  internal struct Object_Object_Object_Object_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject, PyObject) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_Object_Object_Object_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject, arg3: PyObject) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1, arg2, arg3)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_Object_Object_Object_to_Result_Fn<R>
  ) {
    let wrapper = Object_Object_Object_Object_to_Result(name: name, fn: fn)
    self.kind = .object_Object_Object_Object_to_Result(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject, PyObject) -> Void

  /// Positional quartary: `tuple of 4 `objects`.
  ///
  /// `(PyObject, PyObject, PyObject, PyObject) -> Void`
  internal typealias Object_Object_Object_Object_to_Void_Fn = (PyObject, PyObject, PyObject, PyObject) -> Void

  internal struct Object_Object_Object_Object_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject, PyObject) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_Object_Object_Object_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject, arg3: PyObject) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1, arg2, arg3)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_Object_Object_Object_to_Void_Fn
  ) {
    let wrapper = Object_Object_Object_Object_to_Void(name: name, fn: fn)
    self.kind = .object_Object_Object_Object_to_Void(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject, PyObject?) -> PyFunctionResultConvertible

  /// Positional quartary: `tuple of 4 `objects` (last one is optional).
  ///
  /// `(PyObject, PyObject, PyObject, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Object_Object_Object_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject, PyObject, PyObject, PyObject?) -> R

  internal struct Object_Object_Object_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_Object_Object_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject, arg3: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1, arg2, arg3)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_Object_Object_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = Object_Object_Object_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_Object_Object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject, PyObject?) -> Void

  /// Positional quartary: `tuple of 4 `objects` (last one is optional).
  ///
  /// `(PyObject, PyObject, PyObject, PyObject?) -> Void`
  internal typealias Object_Object_Object_ObjectOpt_to_Void_Fn = (PyObject, PyObject, PyObject, PyObject?) -> Void

  internal struct Object_Object_Object_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_Object_Object_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject, arg3: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1, arg2, arg3)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_Object_Object_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = Object_Object_Object_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .object_Object_Object_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject?, PyObject?) -> PyFunctionResultConvertible

  /// Positional quartary: `tuple of 4 `objects` (3rd and 4th are optional).
  ///
  /// `(PyObject, PyObject, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Object_Object_ObjectOpt_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject, PyObject, PyObject?, PyObject?) -> R

  internal struct Object_Object_ObjectOpt_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_Object_ObjectOpt_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1, arg2, arg3)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_Object_ObjectOpt_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = Object_Object_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_Object_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject, PyObject, PyObject?, PyObject?) -> Void

  /// Positional quartary: `tuple of 4 `objects` (3rd and 4th are optional).
  ///
  /// `(PyObject, PyObject, PyObject?, PyObject?) -> Void`
  internal typealias Object_Object_ObjectOpt_ObjectOpt_to_Void_Fn = (PyObject, PyObject, PyObject?, PyObject?) -> Void

  internal struct Object_Object_ObjectOpt_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_Object_ObjectOpt_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1, arg2, arg3)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_Object_ObjectOpt_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = Object_Object_ObjectOpt_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .object_Object_ObjectOpt_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (PyObject, PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible

  /// Positional quartary: `tuple of 4 `objects` (2nd, 3rd and 4th are optional).
  ///
  /// `(PyObject, PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  internal typealias Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject, PyObject?, PyObject?, PyObject?) -> R

  internal struct Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1, arg2, arg3)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil, nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject, PyObject?, PyObject?, PyObject?) -> Void

  /// Positional quartary: `tuple of 4 `objects` (2nd, 3rd and 4th are optional).
  ///
  /// `(PyObject, PyObject?, PyObject?, PyObject?) -> Void`
  internal typealias Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn = (PyObject, PyObject?, PyObject?, PyObject?) -> Void

  internal struct Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1, arg2, arg3)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil, nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(wrapper)
  }

  // MARK: - (PyObject?, PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible

  /// Positional quartary: `tuple of 4 `objects` (all optional).
  ///
  /// `(PyObject?, PyObject?, PyObject?, PyObject?) -> PyFunctionResultConvertible`
  internal typealias ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R: PyFunctionResultConvertible> = (PyObject?, PyObject?, PyObject?, PyObject?) -> R

  internal struct ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject?, PyObject?, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject?, arg1: PyObject?, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function returns 'R'
          let result = fn(arg0, arg1, arg2, arg3)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn(nil, nil, nil, nil)
      case 1:
        return self.fn(args[0], nil, nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R>
  ) {
    let wrapper = ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (PyObject?, PyObject?, PyObject?, PyObject?) -> Void

  /// Positional quartary: `tuple of 4 `objects` (all optional).
  ///
  /// `(PyObject?, PyObject?, PyObject?, PyObject?) -> Void`
  internal typealias ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn = (PyObject?, PyObject?, PyObject?, PyObject?) -> Void

  internal struct ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void {
    fileprivate let fnName: String
    private let fn: (PyObject?, PyObject?, PyObject?, PyObject?) -> PyFunctionResult

    fileprivate init(
      name: String,
      fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject?, arg1: PyObject?, arg2: PyObject?, arg3: PyObject?) -> PyFunctionResult in
          // This function returns 'Void'
          fn(arg0, arg1, arg2, arg3)
          return .value(Py.none)
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn(nil, nil, nil, nil)
      case 1:
        return self.fn(args[0], nil, nil, nil)
      case 2:
        return self.fn(args[0], args[1], nil, nil)
      case 3:
        return self.fn(args[0], args[1], args[2], nil)
      case 4:
        return self.fn(args[0], args[1], args[2], args[3])
      default:
        return .typeError("expected 4 arguments, got \(args.count)")
      }
    }
  }

  internal init(
    name: String,
    fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn
  ) {
    let wrapper = ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(name: name, fn: fn)
    self.kind = .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Void(wrapper)
  }

}