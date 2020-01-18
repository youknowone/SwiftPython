import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// sourcery: pymodule = builtins
public final class Builtins: BuiltinFunctions {

  internal static let doc = """
    Built-in functions, exceptions, and other objects.

    Noteworthy: None is the `nil' object; Ellipsis represents `...' in slices.
    """

  public var `true`: PyBool { return Py.`true` }
  public var `false`: PyBool { return Py.`false` }
  public var none: PyNone { return Py.none }
  public var ellipsis: PyEllipsis { return Py.ellipsis }
  public var notImplemented: PyNotImplemented { return Py.notImplemented }
}
