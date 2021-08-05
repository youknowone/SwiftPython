// ================================================================================
// Automatically generated from: ./Sources/Objects/Generated/PyType+MemoryLayout.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ================================================================================

// swiftlint:disable file_length

extension PyType {

  /// Layout of a given type in memory.
  /// If types share the same layout then it means that they look exactly
  /// the same in memory.
  ///
  /// When creating new class we will check if all of the base classes have
  /// the same layout (it is also allowed for one layout to extend the other one).
  ///
  /// For example we will allow this:
  /// ```py
  /// >>> class C(int, object): pass
  /// ```
  ///
  /// But we will not allow this:
  /// ```py
  /// >>> class C(int, str): pass
  /// TypeError: multiple bases have instance lay-out conflict
  /// ```
  ///
  /// We don't actually need a list of fields etc.
  /// We will just use identity.
  ///
  /// Q: Do I need to create new layout for my type?
  /// A: Well, do you add new fields?
  ///    Yes - you need new layout (with base set to parent layout)
  ///    No - use parent layout
  public class MemoryLayout {

    /// Layout of the parent type.
    private let base: MemoryLayout?

    private init() {
      self.base = nil
    }

    public init(base: MemoryLayout) {
      self.base = base
    }

    internal func isEqual(to other: MemoryLayout) -> Bool {
      return self === other
    }

    /// Is the current layout based on given layout?
    /// 'Based' means that that is uses the given layout, but has more properties.
    internal func isAddingNewProperties(to other: MemoryLayout) -> Bool {
      // Same layout -> not adding new properties
      if self.isEqual(to: other) {
        return false
      }

      // Traverse 'self' hierarchy looking for 'other'
      var currentBaseOrNil: MemoryLayout? = self.base

      while let current = currentBaseOrNil {
        if current.isEqual(to: other) {
          return true
        }

        currentBaseOrNil = current.base
      }

      return false
    }

    /// Fields:
    /// - `_type: PyType!`
    /// - `___dict__: PyDict?`
    /// - `flags: Flags`
    public static let PyObject = MemoryLayout()
    /// `PyBool` uses the same layout as it s base type (`PyInt`).
    public static let PyBool = MemoryLayout.PyInt
    /// Fields:
    /// - `function: FunctionWrapper`
    /// - `module: PyObject?`
    /// - `doc: String?`
    public static let PyBuiltinFunction = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `function: FunctionWrapper`
    /// - `object: PyObject`
    /// - `module: PyObject?`
    /// - `doc: String?`
    public static let PyBuiltinMethod = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `elements: Data`
    public static let PyByteArray = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `bytes: PyByteArray`
    /// - `index: Int`
    public static let PyByteArrayIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `elements: Data`
    public static let PyBytes = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `bytes: PyBytes`
    /// - `index: Int`
    public static let PyBytesIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `callable: PyObject`
    /// - `sentinel: PyObject`
    public static let PyCallableIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `content: PyObject?`
    public static let PyCell = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `callable: PyObject?`
    public static let PyClassMethod = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `codeObject: CodeObject`
    /// - `name: PyString`
    /// - `qualifiedName: PyString`
    /// - `filename: PyString`
    /// - `codeFlags: CodeObject.Flags`
    /// - `instructions: [Instruction]`
    /// - `firstLine: SourceLine`
    /// - `instructionLines: [SourceLine]`
    /// - `constants: [PyObject]`
    /// - `labels: [CodeObject.Label]`
    /// - `names: [PyString]`
    /// - `variableNames: [MangledName]`
    /// - `cellVariableNames: [MangledName]`
    /// - `freeVariableNames: [MangledName]`
    /// - `argCount: Int`
    /// - `kwOnlyArgCount: Int`
    public static let PyCode = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `real: Double`
    /// - `imag: Double`
    public static let PyComplex = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `elements: OrderedDictionary`
    public static let PyDict = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `dict: PyDict`
    /// - `index: Int`
    /// - `initialCount: Int`
    public static let PyDictItemIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `dict: PyDict`
    public static let PyDictItems = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `dict: PyDict`
    /// - `index: Int`
    /// - `initialCount: Int`
    public static let PyDictKeyIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `dict: PyDict`
    public static let PyDictKeys = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `dict: PyDict`
    /// - `index: Int`
    /// - `initialCount: Int`
    public static let PyDictValueIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `dict: PyDict`
    public static let PyDictValues = MemoryLayout(base: MemoryLayout.PyObject)
    /// `PyEllipsis` uses the same layout as it s base type (`PyObject`).
    public static let PyEllipsis = MemoryLayout.PyObject
    /// Fields:
    /// - `iterator: PyObject`
    /// - `nextIndex: BigInt`
    public static let PyEnumerate = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `fn: PyObject`
    /// - `iterator: PyObject`
    public static let PyFilter = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `value: Double`
    public static let PyFloat = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `code: PyCode`
    /// - `parent: PyFrame?`
    /// - `stack: ObjectStack`
    /// - `blocks: BlockStack`
    /// - `locals: PyDict`
    /// - `globals: PyDict`
    /// - `builtins: PyDict`
    /// - `fastLocals: [PyObject?]`
    /// - `cellsAndFreeVariables: [PyCell]`
    /// - `currentInstructionIndex: Int?`
    /// - `nextInstructionIndex: Int`
    public static let PyFrame = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `elements: OrderedSet`
    public static let PyFrozenSet = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `name: PyString`
    /// - `qualname: PyString`
    /// - `doc: PyString?`
    /// - `module: PyObject`
    /// - `code: PyCode`
    /// - `globals: PyDict`
    /// - `defaults: PyTuple?`
    /// - `kwDefaults: PyDict?`
    /// - `closure: PyTuple?`
    /// - `annotations: PyDict?`
    public static let PyFunction = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `value: BigInt`
    public static let PyInt = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `sequence: PyObject`
    /// - `index: Int`
    public static let PyIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `elements: [PyObject]`
    public static let PyList = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `list: PyList`
    /// - `index: Int`
    public static let PyListIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `list: PyList`
    /// - `index: Int`
    public static let PyListReverseIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `fn: PyObject`
    /// - `iterators: [PyObject]`
    public static let PyMap = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `function: PyFunction`
    /// - `object: PyObject`
    public static let PyMethod = MemoryLayout(base: MemoryLayout.PyObject)
    /// `PyModule` uses the same layout as it s base type (`PyObject`).
    public static let PyModule = MemoryLayout.PyObject
    /// `PyNamespace` uses the same layout as it s base type (`PyObject`).
    public static let PyNamespace = MemoryLayout.PyObject
    /// `PyNone` uses the same layout as it s base type (`PyObject`).
    public static let PyNone = MemoryLayout.PyObject
    /// `PyNotImplemented` uses the same layout as it s base type (`PyObject`).
    public static let PyNotImplemented = MemoryLayout.PyObject
    /// Fields:
    /// - `_get: PyObject?`
    /// - `_set: PyObject?`
    /// - `_del: PyObject?`
    /// - `doc: PyObject?`
    public static let PyProperty = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `start: PyInt`
    /// - `stop: PyInt`
    /// - `step: PyInt`
    /// - `length: PyInt`
    public static let PyRange = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `start: BigInt`
    /// - `step: BigInt`
    /// - `length: BigInt`
    /// - `index: BigInt`
    public static let PyRangeIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `sequence: PyObject`
    /// - `index: Int`
    public static let PyReversed = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `elements: OrderedSet`
    public static let PySet = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `set: PyAnySet`
    /// - `index: Int`
    /// - `initialCount: Int`
    public static let PySetIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `start: PyObject`
    /// - `stop: PyObject`
    /// - `step: PyObject`
    public static let PySlice = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `callable: PyObject?`
    public static let PyStaticMethod = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `value: String`
    /// - `cachedCount: PyString`
    /// - `cachedHash: PyString`
    public static let PyString = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `string: PyString`
    /// - `index: Int`
    public static let PyStringIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `thisClass: PyType?`
    /// - `object: PyObject?`
    /// - `objectType: PyType?`
    public static let PySuper = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `name: String?`
    /// - `fd: FileDescriptorType`
    /// - `mode: FileMode`
    /// - `encoding: PyString.Encoding`
    /// - `errorHandling: PyString.ErrorHandling`
    public static let PyTextFile = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `next: PyTraceback?`
    /// - `frame: PyFrame`
    /// - `lastInstruction: PyInt`
    /// - `lineNo: PyInt`
    public static let PyTraceback = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `elements: [PyObject]`
    public static let PyTuple = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `tuple: PyTuple`
    /// - `index: Int`
    public static let PyTupleIterator = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `name: String`
    /// - `qualname: String`
    /// - `base: PyType?`
    /// - `bases: [PyType]`
    /// - `mro: [PyType]`
    /// - `subclasses: [WeakRef]`
    /// - `layout: MemoryLayout`
    /// - `staticMethods: StaticallyKnownNotOverriddenMethods`
    public static let PyType = MemoryLayout(base: MemoryLayout.PyObject)
    /// Fields:
    /// - `iterators: [PyObject]`
    public static let PyZip = MemoryLayout(base: MemoryLayout.PyObject)
    /// `PyArithmeticError` uses the same layout as it s base type (`PyException`).
    public static let PyArithmeticError = MemoryLayout.PyException
    /// `PyAssertionError` uses the same layout as it s base type (`PyException`).
    public static let PyAssertionError = MemoryLayout.PyException
    /// `PyAttributeError` uses the same layout as it s base type (`PyException`).
    public static let PyAttributeError = MemoryLayout.PyException
    /// Fields:
    /// - `args: PyTuple`
    /// - `traceback: PyTraceback?`
    /// - `cause: PyBaseException?`
    /// - `context: PyBaseException?`
    public static let PyBaseException = MemoryLayout(base: MemoryLayout.PyObject)
    /// `PyBlockingIOError` uses the same layout as it s base type (`PyOSError`).
    public static let PyBlockingIOError = MemoryLayout.PyOSError
    /// `PyBrokenPipeError` uses the same layout as it s base type (`PyConnectionError`).
    public static let PyBrokenPipeError = MemoryLayout.PyConnectionError
    /// `PyBufferError` uses the same layout as it s base type (`PyException`).
    public static let PyBufferError = MemoryLayout.PyException
    /// `PyBytesWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PyBytesWarning = MemoryLayout.PyWarning
    /// `PyChildProcessError` uses the same layout as it s base type (`PyOSError`).
    public static let PyChildProcessError = MemoryLayout.PyOSError
    /// `PyConnectionAbortedError` uses the same layout as it s base type (`PyConnectionError`).
    public static let PyConnectionAbortedError = MemoryLayout.PyConnectionError
    /// `PyConnectionError` uses the same layout as it s base type (`PyOSError`).
    public static let PyConnectionError = MemoryLayout.PyOSError
    /// `PyConnectionRefusedError` uses the same layout as it s base type (`PyConnectionError`).
    public static let PyConnectionRefusedError = MemoryLayout.PyConnectionError
    /// `PyConnectionResetError` uses the same layout as it s base type (`PyConnectionError`).
    public static let PyConnectionResetError = MemoryLayout.PyConnectionError
    /// `PyDeprecationWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PyDeprecationWarning = MemoryLayout.PyWarning
    /// `PyEOFError` uses the same layout as it s base type (`PyException`).
    public static let PyEOFError = MemoryLayout.PyException
    /// `PyException` uses the same layout as it s base type (`PyBaseException`).
    public static let PyException = MemoryLayout.PyBaseException
    /// `PyFileExistsError` uses the same layout as it s base type (`PyOSError`).
    public static let PyFileExistsError = MemoryLayout.PyOSError
    /// `PyFileNotFoundError` uses the same layout as it s base type (`PyOSError`).
    public static let PyFileNotFoundError = MemoryLayout.PyOSError
    /// `PyFloatingPointError` uses the same layout as it s base type (`PyArithmeticError`).
    public static let PyFloatingPointError = MemoryLayout.PyArithmeticError
    /// `PyFutureWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PyFutureWarning = MemoryLayout.PyWarning
    /// `PyGeneratorExit` uses the same layout as it s base type (`PyBaseException`).
    public static let PyGeneratorExit = MemoryLayout.PyBaseException
    /// Fields:
    /// - `msg: PyObject?`
    /// - `moduleName: PyObject?`
    /// - `modulePath: PyObject?`
    public static let PyImportError = MemoryLayout(base: MemoryLayout.PyException)
    /// `PyImportWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PyImportWarning = MemoryLayout.PyWarning
    /// `PyIndentationError` uses the same layout as it s base type (`PySyntaxError`).
    public static let PyIndentationError = MemoryLayout.PySyntaxError
    /// `PyIndexError` uses the same layout as it s base type (`PyLookupError`).
    public static let PyIndexError = MemoryLayout.PyLookupError
    /// `PyInterruptedError` uses the same layout as it s base type (`PyOSError`).
    public static let PyInterruptedError = MemoryLayout.PyOSError
    /// `PyIsADirectoryError` uses the same layout as it s base type (`PyOSError`).
    public static let PyIsADirectoryError = MemoryLayout.PyOSError
    /// `PyKeyError` uses the same layout as it s base type (`PyLookupError`).
    public static let PyKeyError = MemoryLayout.PyLookupError
    /// `PyKeyboardInterrupt` uses the same layout as it s base type (`PyBaseException`).
    public static let PyKeyboardInterrupt = MemoryLayout.PyBaseException
    /// `PyLookupError` uses the same layout as it s base type (`PyException`).
    public static let PyLookupError = MemoryLayout.PyException
    /// `PyMemoryError` uses the same layout as it s base type (`PyException`).
    public static let PyMemoryError = MemoryLayout.PyException
    /// `PyModuleNotFoundError` uses the same layout as it s base type (`PyImportError`).
    public static let PyModuleNotFoundError = MemoryLayout.PyImportError
    /// `PyNameError` uses the same layout as it s base type (`PyException`).
    public static let PyNameError = MemoryLayout.PyException
    /// `PyNotADirectoryError` uses the same layout as it s base type (`PyOSError`).
    public static let PyNotADirectoryError = MemoryLayout.PyOSError
    /// `PyNotImplementedError` uses the same layout as it s base type (`PyRuntimeError`).
    public static let PyNotImplementedError = MemoryLayout.PyRuntimeError
    /// `PyOSError` uses the same layout as it s base type (`PyException`).
    public static let PyOSError = MemoryLayout.PyException
    /// `PyOverflowError` uses the same layout as it s base type (`PyArithmeticError`).
    public static let PyOverflowError = MemoryLayout.PyArithmeticError
    /// `PyPendingDeprecationWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PyPendingDeprecationWarning = MemoryLayout.PyWarning
    /// `PyPermissionError` uses the same layout as it s base type (`PyOSError`).
    public static let PyPermissionError = MemoryLayout.PyOSError
    /// `PyProcessLookupError` uses the same layout as it s base type (`PyOSError`).
    public static let PyProcessLookupError = MemoryLayout.PyOSError
    /// `PyRecursionError` uses the same layout as it s base type (`PyRuntimeError`).
    public static let PyRecursionError = MemoryLayout.PyRuntimeError
    /// `PyReferenceError` uses the same layout as it s base type (`PyException`).
    public static let PyReferenceError = MemoryLayout.PyException
    /// `PyResourceWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PyResourceWarning = MemoryLayout.PyWarning
    /// `PyRuntimeError` uses the same layout as it s base type (`PyException`).
    public static let PyRuntimeError = MemoryLayout.PyException
    /// `PyRuntimeWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PyRuntimeWarning = MemoryLayout.PyWarning
    /// `PyStopAsyncIteration` uses the same layout as it s base type (`PyException`).
    public static let PyStopAsyncIteration = MemoryLayout.PyException
    /// Fields:
    /// - `value: PyObject`
    public static let PyStopIteration = MemoryLayout(base: MemoryLayout.PyException)
    /// Fields:
    /// - `msg: PyObject?`
    /// - `filename: PyObject?`
    /// - `lineno: PyObject?`
    /// - `offset: PyObject?`
    /// - `text: PyObject?`
    /// - `printFileAndLine: PyObject?`
    public static let PySyntaxError = MemoryLayout(base: MemoryLayout.PyException)
    /// `PySyntaxWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PySyntaxWarning = MemoryLayout.PyWarning
    /// `PySystemError` uses the same layout as it s base type (`PyException`).
    public static let PySystemError = MemoryLayout.PyException
    /// Fields:
    /// - `code: PyObject?`
    public static let PySystemExit = MemoryLayout(base: MemoryLayout.PyBaseException)
    /// `PyTabError` uses the same layout as it s base type (`PyIndentationError`).
    public static let PyTabError = MemoryLayout.PyIndentationError
    /// `PyTimeoutError` uses the same layout as it s base type (`PyOSError`).
    public static let PyTimeoutError = MemoryLayout.PyOSError
    /// `PyTypeError` uses the same layout as it s base type (`PyException`).
    public static let PyTypeError = MemoryLayout.PyException
    /// `PyUnboundLocalError` uses the same layout as it s base type (`PyNameError`).
    public static let PyUnboundLocalError = MemoryLayout.PyNameError
    /// `PyUnicodeDecodeError` uses the same layout as it s base type (`PyUnicodeError`).
    public static let PyUnicodeDecodeError = MemoryLayout.PyUnicodeError
    /// `PyUnicodeEncodeError` uses the same layout as it s base type (`PyUnicodeError`).
    public static let PyUnicodeEncodeError = MemoryLayout.PyUnicodeError
    /// `PyUnicodeError` uses the same layout as it s base type (`PyValueError`).
    public static let PyUnicodeError = MemoryLayout.PyValueError
    /// `PyUnicodeTranslateError` uses the same layout as it s base type (`PyUnicodeError`).
    public static let PyUnicodeTranslateError = MemoryLayout.PyUnicodeError
    /// `PyUnicodeWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PyUnicodeWarning = MemoryLayout.PyWarning
    /// `PyUserWarning` uses the same layout as it s base type (`PyWarning`).
    public static let PyUserWarning = MemoryLayout.PyWarning
    /// `PyValueError` uses the same layout as it s base type (`PyException`).
    public static let PyValueError = MemoryLayout.PyException
    /// `PyWarning` uses the same layout as it s base type (`PyException`).
    public static let PyWarning = MemoryLayout.PyException
    /// `PyZeroDivisionError` uses the same layout as it s base type (`PyArithmeticError`).
    public static let PyZeroDivisionError = MemoryLayout.PyArithmeticError
  }
}