import Bytecode

internal final class PyModule: PyObject { }

// sourcery: pytype = function
internal final class PyFunction: PyObject, ReprTypeClass, CallTypeClass {

  internal static let doc: String = """
    function(code, globals, name=None, argdefs=None, closure=None)
    --

    Create a function object.

    code
    a code object
    globals
    the globals dictionary
    name
    a string that overrides the name from the code object
    argdefs
    a tuple that specifies the default argument values
    closure
    a tuple that supplies the bindings for free variables
    """

  /// The __doc__ attribute, can be anything
  private let _doc: String?
  /// The __name__ attribute, a string object
  private let _name: String
  /// The qualified name
  private let _qualname: String
  /// The __dict__ attribute, a dict or NULL
  private let _dict: PyObject?
  /// The __module__ attribute, can be anything
  private let _module: PyModule?

  /// A code object, the __code__ attribute
  private let _code: PyCode

  private let _globals: PyDict
  private let _defaults: PyTuple?
  private let _kwdefaults: PyDict?
  private let _closure: PyTuple?

  internal init(_ context: PyContext,
                qualname: String?,
                code: PyCode,
                globals: PyDict) {
    self._name = code._code.name
    self._qualname = qualname ?? code._code.name
    // TODO: Add module
    self._module = nil // globals.elements["__name__"] as? PyModule
    self._dict = nil

    self._code = code

    self._globals = globals
    self._defaults = nil
    self._kwdefaults = nil
    self._closure = nil

    switch code._code.constants.first {
    case let .some(.string(s)): self._doc = s
    default: self._doc = nil
    }

    #warning("Add to PyContext")
    super.init()
  }

  // MARK: - String

  internal func repr() -> String {
    return "<function \(self._qualname) at \(self.ptrString)>"
  }

  // MARK: - Call

  internal func call() -> PyResult<PyObject> {
    fatalError()
  }
}
