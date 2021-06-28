import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore unicodeobject

// In CPython:
// Objects -> unicodeobject.c
// https://docs.python.org/3/library/stdtypes.html

private typealias UnicodeScalarView = String.UnicodeScalarView
private typealias UnicodeScalarViewSub = UnicodeScalarView.SubSequence

// sourcery: pytype = str, default, baseType, unicodeSubclass
/// Textual data in Python is handled with str objects, or strings.
/// Strings are immutable sequences of Unicode code points.
public class PyString: PyObject {

  // Alias for out implementation type, so we don't have to type that much.
  private typealias Implementation = StringImplementation

  internal static let doc = """
    str(object='') -> str
    str(bytes_or_buffer[, encoding[, errors]]) -> str

    Create a new string object from the given object. If encoding or
    errors is specified, then the object must expose a data buffer
    that will be decoded using the given encoding and error handler.
    Otherwise, returns the result of object.__str__() (if defined)
    or repr(object).
    encoding defaults to sys.getdefaultencoding().
    errors defaults to 'strict'.
    """

  internal let data: PyStringData

  public var value: String {
    return self.data.value
  }

  internal var scalars: String.UnicodeScalarView {
    return self.data.scalars
  }

  override public var description: String {
    let shortCount = 50

    var short = self.value.prefix(shortCount)
    if self.value.count > shortCount {
      short += "..."
    }

    return "PyString('\(short)')"
  }

  // MARK: - Init

  internal init(value: String) {
    self.data = PyStringData(value)
    super.init(type: Py.types.str)
  }

  /// Use only in  `__new__`!
  internal init(type: PyType, value: String) {
    self.data = PyStringData(value)
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    if self === other {
      return .value(true)
    }

    let result = self.compare(other: other)
    return CompareResult(result?.isEqual)
  }

  internal func isEqual(_ other: PyString) -> Bool {
    let result = self.compare(other: other.data.value)
    return result.isEqual
  }

  internal func isEqual(_ other: String) -> Bool {
    let result = self.compare(other: other)
    return result.isEqual
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    let result = self.compare(other: other)
    return CompareResult(result?.isLess)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    let result = self.compare(other: other)
    return CompareResult(result?.isLessEqual)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    let result = self.compare(other: other)
    return CompareResult(result?.isGreater)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    let result = self.compare(other: other)
    return CompareResult(result?.isGreaterEqual)
  }

  private func compare(other: PyObject) -> Implementation.CompareResult? {
    guard let other = PyCast.asString(other) else {
      return nil
    }

    return self.compare(other: other.data.value)
  }

  private func compare(other: String) -> Implementation.CompareResult {
    return Implementation.compare(lhs: self.scalars, rhs: other.unicodeScalars)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return .value(self.hashRaw())
  }

  internal func hashRaw() -> PyHash {
    return Py.hasher.hash(self.value)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value(self.reprRaw())
  }

  internal func reprRaw() -> String {
    return self.data.createRepr()
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    return .value(self.data.value)
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

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.data.count)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(element: PyObject) -> PyResult<Bool> {
    return Implementation.contains(scalars: self.scalars, element: element)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    switch Implementation.getItem(scalars: self.scalars, index: index) {
    case let .item(scalar):
      let result = Py.newString(String(scalar))
      return .value(result)
    case let .slice(string):
      let result = Py.newString(string)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Properties

  internal static let isalnumDoc = """
    Return True if the string is an alpha-numeric string, False otherwise.

    A string is alpha-numeric if all characters in the string are alpha-numeric and
    there is at least one character in the string.
    """

  // sourcery: pymethod = isalnum, doc = isalnumDoc
  internal func isAlphaNumeric() -> Bool {
    return Implementation.isAlphaNumeric(scalars: self.scalars)
  }

  internal static let isalphaDoc = """
    Return True if the string is an alphabetic string, False otherwise.

    A string is alphabetic if all characters in the string are alphabetic and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isalpha, doc = isalphaDoc
  internal func isAlpha() -> Bool {
    return Implementation.isAlpha(scalars: self.scalars)
  }

  internal static let isasciiDoc = """
    Return True if all characters in the string are ASCII, False otherwise.

    ASCII characters have code points in the range U+0000-U+007F.
    Empty string is ASCII too.
    """

  // sourcery: pymethod = isascii, doc = isasciiDoc
  internal func isAscii() -> Bool {
    return Implementation.isAscii(scalars: self.scalars)
  }

  internal static let isdecimalDoc = """
    Return True if the string is a decimal string, False otherwise.

    A string is a decimal string if all characters in the string are decimal and
    there is at least one character in the string.
    """

  // sourcery: pymethod = isdecimal, doc = isdecimalDoc
  internal func isDecimal() -> Bool {
    return Implementation.isDecimal(scalars: self.scalars)
  }

  internal static let isdigitDoc = """
    Return True if the string is a digit string, False otherwise.

    A string is a digit string if all characters in the string are digits and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isdigit, doc = isdigitDoc
  internal func isDigit() -> Bool {
    return Implementation.isDigit(scalars: self.scalars)
  }

  internal static let isidentifierDoc = """
    Return True if the string is a valid Python identifier, False otherwise.

    Use keyword.iskeyword() to test for reserved identifiers such as "def" and
    "class".
    """

  // sourcery: pymethod = isidentifier, doc = isidentifierDoc
  internal func isIdentifier() -> Bool {
    return self.data.isIdentifier
  }

  internal static let islowerDoc = """
    Return True if the string is a lowercase string, False otherwise.

    A string is lowercase if all cased characters in the string are lowercase and
    there is at least one cased character in the string.
    """

  // sourcery: pymethod = islower, doc = islowerDoc
  internal func isLower() -> Bool {
    return Implementation.isLower(scalars: self.scalars)
  }

  internal static let isnumericDoc = """
    Return True if the string is a numeric string, False otherwise.

    A string is numeric if all characters in the string are numeric and there is at
    least one character in the string.
    """

  // sourcery: pymethod = isnumeric, doc = isnumericDoc
  internal func isNumeric() -> Bool {
    return Implementation.isNumeric(scalars: self.scalars)
  }

  internal static let isprintableDoc = """
    Return True if the string is printable, False otherwise.

    A string is printable if all of its characters are considered printable in
    repr() or if it is empty.
    """

  // sourcery: pymethod = isprintable, doc = isprintableDoc
  internal func isPrintable() -> Bool {
    return Implementation.isPrintable(scalars: self.scalars)
  }

  internal static let isspaceDoc = """
    Return True if the string is a whitespace string, False otherwise.

    A string is whitespace if all characters in the string are whitespace and there
    is at least one character in the string.
    """

  // sourcery: pymethod = isspace, doc = isspaceDoc
  internal func isSpace() -> Bool {
    return Implementation.isSpace(scalars: self.scalars)
  }

  internal static let istitleDoc = """
    Return True if the string is a title-cased string, False otherwise.

    In a title-cased string, upper- and title-case characters may only
    follow uncased characters and lowercase characters only cased ones.
    """

  // sourcery: pymethod = istitle, doc = istitleDoc
  internal func isTitle() -> Bool {
    return Implementation.isTitle(scalars: self.scalars)
  }

  internal static let isupperDoc = """
    Return True if the string is an uppercase string, False otherwise.

    A string is uppercase if all cased characters in the string are uppercase and
    there is at least one cased character in the string.
    """

  // sourcery: pymethod = isupper, doc = isupperDoc
  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  internal func isUpper() -> Bool {
    return Implementation.isUpper(scalars: self.scalars)
  }

  // MARK: - Starts/ends with

  internal static let startswithDoc = """
    S.startswith(prefix[, start[, end]]) -> bool

    Return True if S starts with the specified prefix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    prefix can also be a tuple of strings to try.
    """

  internal func startsWith(_ element: PyObject) -> PyResult<Bool> {
    return self.startsWith(element, start: nil, end: nil)
  }

  // sourcery: pymethod = startswith, doc = startswithDoc
  internal func startsWith(_ element: PyObject,
                           start: PyObject?,
                           end: PyObject?) -> PyResult<Bool> {
    return Implementation.startsWith(scalars: self.scalars,
                                     element: element,
                                     start: start,
                                     end: end)
  }

  internal static let endswithDoc = """
    S.endswith(suffix[, start[, end]]) -> bool

    Return True if S ends with the specified suffix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    suffix can also be a tuple of strings to try.
    """

  internal func endsWith(_ element: PyObject) -> PyResult<Bool> {
    return self.endsWith(element, start: nil, end: nil)
  }

  // sourcery: pymethod = endswith, doc = endswithDoc
  internal func endsWith(_ element: PyObject,
                         start: PyObject?,
                         end: PyObject?) -> PyResult<Bool> {
    return Implementation.endsWith(scalars: self.scalars,
                                   element: element,
                                   start: start,
                                   end: end)
  }

  // MARK: - Strip

  internal static let stripDoc = """
    Return a copy of the string with leading and trailing whitespace remove.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = strip, doc = stripDoc
  internal func strip(_ chars: PyObject?) -> PyResult<String> {
    let result = Implementation.strip(scalars: self.scalars, chars: chars)
    return result.map(String.init)
  }

  internal static let lstripDoc = """
    Return a copy of the string with leading whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = lstrip, doc = lstripDoc
  internal func lstrip(_ chars: PyObject?) -> PyResult<String> {
    let result = Implementation.lstrip(scalars: self.scalars, chars: chars)
    return result.map(String.init)
  }

  internal static let rstripDoc = """
    Return a copy of the string with trailing whitespace removed.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = rstrip, doc = rstripDoc
  internal func rstrip(_ chars: PyObject?) -> PyResult<String> {
    let result = Implementation.rstrip(scalars: self.scalars, chars: chars)
    return result.map(String.init)
  }

  // MARK: - Find

  internal static let findDoc = """
    S.find(sub[, start[, end]]) -> int

    Return the lowest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  internal func find(_ element: PyObject) -> PyResult<BigInt> {
    return self.find(element, start: nil, end: nil)
  }

  // sourcery: pymethod = find, doc = findDoc
  internal func find(_ element: PyObject,
                     start: PyObject?,
                     end: PyObject?) -> PyResult<BigInt> {
    return self.data.find(element, start: start, end: end)
  }

  internal static let rfindDoc = """
    S.rfind(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Return -1 on failure.
    """

  internal func rfind(_ element: PyObject) -> PyResult<BigInt> {
    return self.rfind(element, start: nil, end: nil)
  }

  // sourcery: pymethod = rfind, doc = rfindDoc
  internal func rfind(_ element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self.data.rfind(element, start: start, end: end)
  }

  // MARK: - Index

  internal static let indexDoc = """
    S.index(sub[, start[, end]]) -> int

    Return the lowest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  // Special overload for `IndexOwner` protocol
  internal func index(of element: PyObject) -> PyResult<BigInt> {
    return self.index(of: element, start: nil, end: nil)
  }

  // sourcery: pymethod = index, doc = indexDoc
  internal func index(of element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return Implementation.indexOf(scalars: self.scalars,
                                  element: element,
                                  start: start,
                                  end: end)
  }

  internal static let rindexDoc = """
    S.rindex(sub[, start[, end]]) -> int

    Return the highest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.

    Raises ValueError when the substring is not found.
    """

  internal func rindex(_ element: PyObject) -> PyResult<BigInt> {
    return self.rindex(element, start: nil, end: nil)
  }

  // sourcery: pymethod = rindex, doc = rindexDoc
  internal func rindex(_ element: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<BigInt> {
    return Implementation.rindexOf(scalars: self.scalars,
                                   element: element,
                                   start: start,
                                   end: end)
  }

  // MARK: - Case

  // sourcery: pymethod = lower
  internal func lower() -> String {
    return self.data.lowerCased()
  }

  // sourcery: pymethod = upper
  internal func upper() -> String {
    return self.data.upperCased()
  }

  // sourcery: pymethod = title
  internal func title() -> String {
    return self.data.titleCased()
  }

  // sourcery: pymethod = swapcase
  internal func swapcase() -> String {
    return self.data.swapCase()
  }

  // sourcery: pymethod = casefold
  internal func casefold() -> String {
    return self.data.caseFold()
  }

  // sourcery: pymethod = capitalize
  internal func capitalize() -> String {
    return self.data.capitalize()
  }

  // MARK: - Center, just

  // sourcery: pymethod = center
  internal func center(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    return Implementation.center(scalars: self.scalars,
                                 width: width,
                                 fillChar: fillChar)
  }

  // sourcery: pymethod = ljust
  internal func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    return Implementation.ljust(scalars: self.scalars,
                                width: width,
                                fillChar: fillChar)
  }

  // sourcery: pymethod = rjust
  internal func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<String> {
    return Implementation.rjust(scalars: self.scalars,
                                width: width,
                                fillChar: fillChar)
  }

  // MARK: - Split

  // sourcery: pymethod = split
  internal func split(args: [PyObject], kwargs: PyDict?) -> PyResult<[String]> {
    return self.data.split(args: args, kwargs: kwargs)
      .map(self.toStringArray(_:))
  }

  // sourcery: pymethod = rsplit
  internal func rsplit(args: [PyObject],
                       kwargs: PyDict?) -> PyResult<[String]> {
    return self.data.rsplit(args: args, kwargs: kwargs)
      .map(self.toStringArray(_:))
  }

  // sourcery: pymethod = splitlines
  internal func splitLines(args: [PyObject],
                           kwargs: PyDict?) -> PyResult<[String]> {
    let result = Implementation.splitLines(scalars: self.scalars,
                                           args: args,
                                           kwargs: kwargs)

    return result.map(self.toStringArray(_:))
  }

  private func toStringArray(_ values: [UnicodeScalarViewSub]) -> [String] {
    return values.map(String.init)
  }

  // MARK: - Partition

  // sourcery: pymethod = partition
  internal func partition(separator: PyObject) -> PyResult<PyTuple> {
    switch Implementation.partition(scalars: self.scalars, separator: separator) {
    case .separatorNotFound:
      let empty = Py.emptyString
      return .value(Py.newTuple(elements: self, empty, empty))
    case let .separatorFound(before, _, after):
      let b = Py.newString(String(before))
      let a = Py.newString(String(after))
      return .value(Py.newTuple(elements: b, separator, a))
    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = rpartition
  internal func rpartition(separator: PyObject) -> PyResult<PyTuple> {
    switch Implementation.rpartition(scalars: self.scalars, separator: separator) {
    case .separatorNotFound:
      let empty = Py.emptyString
      return .value(Py.newTuple(elements: empty, empty, self))
    case let .separatorFound(before, _, after):
      let b = Py.newString(String(before))
      let a = Py.newString(String(after))
      return .value(Py.newTuple(elements: b, separator, a))
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Expand tabs

  // sourcery: pymethod = expandtabs
  internal func expandTabs(tabSize: PyObject?) -> PyResult<String> {
    return Implementation.expandTabs(scalars: self.scalars, tabSize: tabSize)
  }

  // MARK: - Count

  internal static let countDoc = """
    S.count(sub[, start[, end]]) -> int

    Return the number of non-overlapping occurrences of substring sub in
    string S[start:end].  Optional arguments start and end are
    interpreted as in slice notation.
    """

  // Special overload for `CountOwner` protocol.
  internal func count(_ element: PyObject) -> PyResult<BigInt> {
    return self.count(element, start: nil, end: nil)
  }

  // sourcery: pymethod = count, doc = countDoc
  internal func count(_ element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return Implementation.count(scalars: self.scalars,
                                element: element,
                                start: start,
                                end: end)
  }

  // MARK: - Join

  // sourcery: pymethod = join
  internal func join(iterable: PyObject) -> PyResult<String> {
    return Implementation.join(scalars: self.scalars, iterable: iterable)
  }

  // MARK: - Replace

  // sourcery: pymethod = replace
  internal func replace(old: PyObject,
                        new: PyObject,
                        count: PyObject?) -> PyResult<String> {
    return Implementation.replace(scalars: self.scalars,
                                  old: old,
                                  new: new,
                                  count: count)
  }

  // MARK: - ZFill

  // sourcery: pymethod = zfill
  internal func zfill(width: PyObject) -> PyResult<String> {
    return Implementation.zFill(scalars: self.scalars, width: width)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    let result = Implementation.add(lhs: self.scalars, rhs: other)
    return result.map(Py.newString(_:))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    let result = Implementation.mul(scalars: self.scalars, count: other)
    return result.map(Py.newString(_:))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    let result = Implementation.rmul(scalars: self.scalars, count: other)
    return result.map(Py.newString(_:))
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyStringIterator(string: self)
  }

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["object", "encoding", "errors"],
    format: "|Oss:str"
  )

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyString> {
    switch self.newArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 3, "Invalid optional argument count.")

      let object = binding.optional(at: 0)
      let encoding = binding.optional(at: 1)
      let errors = binding.optional(at: 2)
      return PyString.pyNew(type: type,
                            object: object,
                            encoding: encoding,
                            errors: errors)
    case let .error(e):
      return .error(e)
    }
  }

  private static func pyNew(type: PyType,
                            object: PyObject?,
                            encoding encodingObj: PyObject?,
                            errors errorObj: PyObject?) -> PyResult<PyString> {
    let isBuiltin = type === Py.types.str
    let alloca = isBuiltin ?
      self.newString(type:value:) :
      PyStringHeap.init(type:value:)

    guard let object = object else {
      return .value(alloca(type, ""))
    }

    // Fast path when we don't have encoding and kwargs
    if encodingObj == nil && errorObj == nil {
      // Is this object already a 'str'?
      if let str = PyCast.asString(object) {
        // If we are builtin 'str' (not a subclass) -> return itself
        if PyCast.isExactlyString(str) {
          return .value(str)
        }

        let result = Py.newString(str.value)
        return .value(result)
      }

      // 'str' of a str-subtype should be a 'str', not this subtype
      return Py.strValue(object: object).map { alloca(type, $0) }
    }

    let encoding: PyStringEncoding
    switch PyStringEncoding.from(encodingObj) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errors: PyStringErrorHandler
    switch PyStringErrorHandler.from(errorObj) {
    case let .value(e): errors = e
    case let .error(e): return .error(e)
    }

    if let bytes = object as? PyBytesType {
      let data = bytes.data.values
      return encoding.decode(data: data, errors: errors).map { alloca(type, $0) }
    }

    if object is PyString {
      return .typeError("decoding str is not supported")
    }

    let t = object.typeName
    return .typeError("decoding to str: need a bytes-like object, \(t) found")
  }

  /// Allocate new PyString (it will use 'builtins' cache if possible).
  private static func newString(type: PyType, value: String) -> PyString {
    return Py.newString(value)
  }
}
