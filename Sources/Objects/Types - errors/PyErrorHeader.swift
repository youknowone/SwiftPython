/// Initial section of every Python error object in memory.
///
/// Guaranteed to be word aligned.
public struct PyErrorHeader {

  // MARK: - Properties

  public static let defaultSuppressContext = false
  private static let suppressContextFlag = PyObject.Flags.custom0

  // sourcery: storedProperty
  internal var args: PyTuple {
    get { self.argsPtr.pointee }
    nonmutating set { self.argsPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var traceback: PyTraceback? {
    get { self.tracebackPtr.pointee }
    nonmutating set { self.tracebackPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// `raise from xxx`.
  internal var cause: PyBaseException? {
    get { self.causePtr.pointee }
    nonmutating set { self.causePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// Another exception during whose handling this exception was raised.
  internal var context: PyBaseException? {
    get { self.contextPtr.pointee }
    nonmutating set { self.contextPtr.pointee = newValue }
  }

  /// Should we use `self.cause` or `self.context`?
  ///
  /// If we have `cause` then probably `cause`, otherwise `context`.
  internal var suppressContext: Bool {
    get {
      let object = PyObject(ptr: self.ptr)
      return object.flags.isSet(Self.suppressContextFlag)
    }
    nonmutating set {
      let object = PyObject(ptr: self.ptr)
      object.flags.set(Self.suppressContextFlag, to: newValue)
    }
  }

  // MARK: - Init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback?,
                           cause: PyBaseException?,
                           context: PyBaseException?,
                           suppressContext: Bool) {
//    self.objectHeader.initialize(py, type: type)
    self.argsPtr.initialize(to: args)
    self.tracebackPtr.initialize(to: traceback)
    self.causePtr.initialize(to: cause)
    self.contextPtr.initialize(to: context)
    self.suppressContext = suppressContext
  }

  internal func deinitialize() {
//    self.objectHeader.deinitialize()
    self.argsPtr.deinitialize()
    self.tracebackPtr.deinitialize()
    self.causePtr.deinitialize()
    self.contextPtr.deinitialize()
  }
}
