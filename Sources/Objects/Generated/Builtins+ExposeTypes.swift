// swiftlint:disable file_length

// This file will add type properties to 'Builtins', so that they are exposed
// to Python runtime.
// Later 'ModuleFactory' script will pick those properties and add them to module
// '__dict__' as 'PyProperty'.
//
// Btw. Not all of those types should be exposed from builtins module.
// Some should require 'import types', but sice we don't have 'types' module,
// we will expose them from builtins.

extension Builtins {

  // MARK: - Types

  // sourcery: pyproperty = bool
  internal var type_bool: PyType {
    return Py.types.bool
  }

  // sourcery: pyproperty = builtinFunction
  internal var type_builtinFunction: PyType {
    return Py.types.builtinFunction
  }

  // sourcery: pyproperty = builtinMethod
  internal var type_builtinMethod: PyType {
    return Py.types.builtinMethod
  }

  // sourcery: pyproperty = bytearray
  internal var type_bytearray: PyType {
    return Py.types.bytearray
  }

  // sourcery: pyproperty = bytearray_iterator
  internal var type_bytearray_iterator: PyType {
    return Py.types.bytearray_iterator
  }

  // sourcery: pyproperty = bytes
  internal var type_bytes: PyType {
    return Py.types.bytes
  }

  // sourcery: pyproperty = bytes_iterator
  internal var type_bytes_iterator: PyType {
    return Py.types.bytes_iterator
  }

  // sourcery: pyproperty = callable_iterator
  internal var type_callable_iterator: PyType {
    return Py.types.callable_iterator
  }

  // sourcery: pyproperty = code
  internal var type_code: PyType {
    return Py.types.code
  }

  // sourcery: pyproperty = complex
  internal var type_complex: PyType {
    return Py.types.complex
  }

  // sourcery: pyproperty = dict
  internal var type_dict: PyType {
    return Py.types.dict
  }

  // sourcery: pyproperty = dict_itemiterator
  internal var type_dict_itemiterator: PyType {
    return Py.types.dict_itemiterator
  }

  // sourcery: pyproperty = dict_items
  internal var type_dict_items: PyType {
    return Py.types.dict_items
  }

  // sourcery: pyproperty = dict_keyiterator
  internal var type_dict_keyiterator: PyType {
    return Py.types.dict_keyiterator
  }

  // sourcery: pyproperty = dict_keys
  internal var type_dict_keys: PyType {
    return Py.types.dict_keys
  }

  // sourcery: pyproperty = dict_valueiterator
  internal var type_dict_valueiterator: PyType {
    return Py.types.dict_valueiterator
  }

  // sourcery: pyproperty = dict_values
  internal var type_dict_values: PyType {
    return Py.types.dict_values
  }

  // sourcery: pyproperty = ellipsis
  internal var type_ellipsis: PyType {
    return Py.types.ellipsis
  }

  // sourcery: pyproperty = enumerate
  internal var type_enumerate: PyType {
    return Py.types.enumerate
  }

  // sourcery: pyproperty = filter
  internal var type_filter: PyType {
    return Py.types.filter
  }

  // sourcery: pyproperty = float
  internal var type_float: PyType {
    return Py.types.float
  }

  // sourcery: pyproperty = frozenset
  internal var type_frozenset: PyType {
    return Py.types.frozenset
  }

  // sourcery: pyproperty = function
  internal var type_function: PyType {
    return Py.types.function
  }

  // sourcery: pyproperty = int
  internal var type_int: PyType {
    return Py.types.int
  }

  // sourcery: pyproperty = iterator
  internal var type_iterator: PyType {
    return Py.types.iterator
  }

  // sourcery: pyproperty = list
  internal var type_list: PyType {
    return Py.types.list
  }

  // sourcery: pyproperty = list_iterator
  internal var type_list_iterator: PyType {
    return Py.types.list_iterator
  }

  // sourcery: pyproperty = list_reverseiterator
  internal var type_list_reverseiterator: PyType {
    return Py.types.list_reverseiterator
  }

  // sourcery: pyproperty = map
  internal var type_map: PyType {
    return Py.types.map
  }

  // sourcery: pyproperty = method
  internal var type_method: PyType {
    return Py.types.method
  }

  // sourcery: pyproperty = module
  internal var type_module: PyType {
    return Py.types.module
  }

  // sourcery: pyproperty = SimpleNamespace
  internal var type_simpleNamespace: PyType {
    return Py.types.simpleNamespace
  }

  // sourcery: pyproperty = None
  internal var type_none: PyType {
    return Py.types.none
  }

  // sourcery: pyproperty = NotImplemented
  internal var type_notImplemented: PyType {
    return Py.types.notImplemented
  }

  // sourcery: pyproperty = property
  internal var type_property: PyType {
    return Py.types.property
  }

  // sourcery: pyproperty = range
  internal var type_range: PyType {
    return Py.types.range
  }

  // sourcery: pyproperty = range_iterator
  internal var type_range_iterator: PyType {
    return Py.types.range_iterator
  }

  // sourcery: pyproperty = reversed
  internal var type_reversed: PyType {
    return Py.types.reversed
  }

  // sourcery: pyproperty = set
  internal var type_set: PyType {
    return Py.types.set
  }

  // sourcery: pyproperty = set_iterator
  internal var type_set_iterator: PyType {
    return Py.types.set_iterator
  }

  // sourcery: pyproperty = slice
  internal var type_slice: PyType {
    return Py.types.slice
  }

  // sourcery: pyproperty = str
  internal var type_str: PyType {
    return Py.types.str
  }

  // sourcery: pyproperty = str_iterator
  internal var type_str_iterator: PyType {
    return Py.types.str_iterator
  }

  // sourcery: pyproperty = TextFile
  internal var type_textFile: PyType {
    return Py.types.textFile
  }

  // sourcery: pyproperty = tuple
  internal var type_tuple: PyType {
    return Py.types.tuple
  }

  // sourcery: pyproperty = tuple_iterator
  internal var type_tuple_iterator: PyType {
    return Py.types.tuple_iterator
  }

  // sourcery: pyproperty = zip
  internal var type_zip: PyType {
    return Py.types.zip
  }

  // MARK: - Error types

  // sourcery: pyproperty = ArithmeticError
  internal var type_arithmeticError: PyType {
    return Py.errorTypes.arithmeticError
  }

  // sourcery: pyproperty = AssertionError
  internal var type_assertionError: PyType {
    return Py.errorTypes.assertionError
  }

  // sourcery: pyproperty = AttributeError
  internal var type_attributeError: PyType {
    return Py.errorTypes.attributeError
  }

  // sourcery: pyproperty = BaseException
  internal var type_baseException: PyType {
    return Py.errorTypes.baseException
  }

  // sourcery: pyproperty = BlockingIOError
  internal var type_blockingIOError: PyType {
    return Py.errorTypes.blockingIOError
  }

  // sourcery: pyproperty = BrokenPipeError
  internal var type_brokenPipeError: PyType {
    return Py.errorTypes.brokenPipeError
  }

  // sourcery: pyproperty = BufferError
  internal var type_bufferError: PyType {
    return Py.errorTypes.bufferError
  }

  // sourcery: pyproperty = BytesWarning
  internal var type_bytesWarning: PyType {
    return Py.errorTypes.bytesWarning
  }

  // sourcery: pyproperty = ChildProcessError
  internal var type_childProcessError: PyType {
    return Py.errorTypes.childProcessError
  }

  // sourcery: pyproperty = ConnectionAbortedError
  internal var type_connectionAbortedError: PyType {
    return Py.errorTypes.connectionAbortedError
  }

  // sourcery: pyproperty = ConnectionError
  internal var type_connectionError: PyType {
    return Py.errorTypes.connectionError
  }

  // sourcery: pyproperty = ConnectionRefusedError
  internal var type_connectionRefusedError: PyType {
    return Py.errorTypes.connectionRefusedError
  }

  // sourcery: pyproperty = ConnectionResetError
  internal var type_connectionResetError: PyType {
    return Py.errorTypes.connectionResetError
  }

  // sourcery: pyproperty = DeprecationWarning
  internal var type_deprecationWarning: PyType {
    return Py.errorTypes.deprecationWarning
  }

  // sourcery: pyproperty = EOFError
  internal var type_eofError: PyType {
    return Py.errorTypes.eofError
  }

  // sourcery: pyproperty = Exception
  internal var type_exception: PyType {
    return Py.errorTypes.exception
  }

  // sourcery: pyproperty = FileExistsError
  internal var type_fileExistsError: PyType {
    return Py.errorTypes.fileExistsError
  }

  // sourcery: pyproperty = FileNotFoundError
  internal var type_fileNotFoundError: PyType {
    return Py.errorTypes.fileNotFoundError
  }

  // sourcery: pyproperty = FloatingPointError
  internal var type_floatingPointError: PyType {
    return Py.errorTypes.floatingPointError
  }

  // sourcery: pyproperty = FutureWarning
  internal var type_futureWarning: PyType {
    return Py.errorTypes.futureWarning
  }

  // sourcery: pyproperty = GeneratorExit
  internal var type_generatorExit: PyType {
    return Py.errorTypes.generatorExit
  }

  // sourcery: pyproperty = ImportError
  internal var type_importError: PyType {
    return Py.errorTypes.importError
  }

  // sourcery: pyproperty = ImportWarning
  internal var type_importWarning: PyType {
    return Py.errorTypes.importWarning
  }

  // sourcery: pyproperty = IndentationError
  internal var type_indentationError: PyType {
    return Py.errorTypes.indentationError
  }

  // sourcery: pyproperty = IndexError
  internal var type_indexError: PyType {
    return Py.errorTypes.indexError
  }

  // sourcery: pyproperty = InterruptedError
  internal var type_interruptedError: PyType {
    return Py.errorTypes.interruptedError
  }

  // sourcery: pyproperty = IsADirectoryError
  internal var type_isADirectoryError: PyType {
    return Py.errorTypes.isADirectoryError
  }

  // sourcery: pyproperty = KeyError
  internal var type_keyError: PyType {
    return Py.errorTypes.keyError
  }

  // sourcery: pyproperty = KeyboardInterrupt
  internal var type_keyboardInterrupt: PyType {
    return Py.errorTypes.keyboardInterrupt
  }

  // sourcery: pyproperty = LookupError
  internal var type_lookupError: PyType {
    return Py.errorTypes.lookupError
  }

  // sourcery: pyproperty = MemoryError
  internal var type_memoryError: PyType {
    return Py.errorTypes.memoryError
  }

  // sourcery: pyproperty = ModuleNotFoundError
  internal var type_moduleNotFoundError: PyType {
    return Py.errorTypes.moduleNotFoundError
  }

  // sourcery: pyproperty = NameError
  internal var type_nameError: PyType {
    return Py.errorTypes.nameError
  }

  // sourcery: pyproperty = NotADirectoryError
  internal var type_notADirectoryError: PyType {
    return Py.errorTypes.notADirectoryError
  }

  // sourcery: pyproperty = NotImplementedError
  internal var type_notImplementedError: PyType {
    return Py.errorTypes.notImplementedError
  }

  // sourcery: pyproperty = OSError
  internal var type_osError: PyType {
    return Py.errorTypes.osError
  }

  // sourcery: pyproperty = OverflowError
  internal var type_overflowError: PyType {
    return Py.errorTypes.overflowError
  }

  // sourcery: pyproperty = PendingDeprecationWarning
  internal var type_pendingDeprecationWarning: PyType {
    return Py.errorTypes.pendingDeprecationWarning
  }

  // sourcery: pyproperty = PermissionError
  internal var type_permissionError: PyType {
    return Py.errorTypes.permissionError
  }

  // sourcery: pyproperty = ProcessLookupError
  internal var type_processLookupError: PyType {
    return Py.errorTypes.processLookupError
  }

  // sourcery: pyproperty = RecursionError
  internal var type_recursionError: PyType {
    return Py.errorTypes.recursionError
  }

  // sourcery: pyproperty = ReferenceError
  internal var type_referenceError: PyType {
    return Py.errorTypes.referenceError
  }

  // sourcery: pyproperty = ResourceWarning
  internal var type_resourceWarning: PyType {
    return Py.errorTypes.resourceWarning
  }

  // sourcery: pyproperty = RuntimeError
  internal var type_runtimeError: PyType {
    return Py.errorTypes.runtimeError
  }

  // sourcery: pyproperty = RuntimeWarning
  internal var type_runtimeWarning: PyType {
    return Py.errorTypes.runtimeWarning
  }

  // sourcery: pyproperty = StopAsyncIteration
  internal var type_stopAsyncIteration: PyType {
    return Py.errorTypes.stopAsyncIteration
  }

  // sourcery: pyproperty = StopIteration
  internal var type_stopIteration: PyType {
    return Py.errorTypes.stopIteration
  }

  // sourcery: pyproperty = SyntaxError
  internal var type_syntaxError: PyType {
    return Py.errorTypes.syntaxError
  }

  // sourcery: pyproperty = SyntaxWarning
  internal var type_syntaxWarning: PyType {
    return Py.errorTypes.syntaxWarning
  }

  // sourcery: pyproperty = SystemError
  internal var type_systemError: PyType {
    return Py.errorTypes.systemError
  }

  // sourcery: pyproperty = SystemExit
  internal var type_systemExit: PyType {
    return Py.errorTypes.systemExit
  }

  // sourcery: pyproperty = TabError
  internal var type_tabError: PyType {
    return Py.errorTypes.tabError
  }

  // sourcery: pyproperty = TimeoutError
  internal var type_timeoutError: PyType {
    return Py.errorTypes.timeoutError
  }

  // sourcery: pyproperty = TypeError
  internal var type_typeError: PyType {
    return Py.errorTypes.typeError
  }

  // sourcery: pyproperty = UnboundLocalError
  internal var type_unboundLocalError: PyType {
    return Py.errorTypes.unboundLocalError
  }

  // sourcery: pyproperty = UnicodeDecodeError
  internal var type_unicodeDecodeError: PyType {
    return Py.errorTypes.unicodeDecodeError
  }

  // sourcery: pyproperty = UnicodeEncodeError
  internal var type_unicodeEncodeError: PyType {
    return Py.errorTypes.unicodeEncodeError
  }

  // sourcery: pyproperty = UnicodeError
  internal var type_unicodeError: PyType {
    return Py.errorTypes.unicodeError
  }

  // sourcery: pyproperty = UnicodeTranslateError
  internal var type_unicodeTranslateError: PyType {
    return Py.errorTypes.unicodeTranslateError
  }

  // sourcery: pyproperty = UnicodeWarning
  internal var type_unicodeWarning: PyType {
    return Py.errorTypes.unicodeWarning
  }

  // sourcery: pyproperty = UserWarning
  internal var type_userWarning: PyType {
    return Py.errorTypes.userWarning
  }

  // sourcery: pyproperty = ValueError
  internal var type_valueError: PyType {
    return Py.errorTypes.valueError
  }

  // sourcery: pyproperty = Warning
  internal var type_warning: PyType {
    return Py.errorTypes.warning
  }

  // sourcery: pyproperty = ZeroDivisionError
  internal var type_zeroDivisionError: PyType {
    return Py.errorTypes.zeroDivisionError
  }
}
