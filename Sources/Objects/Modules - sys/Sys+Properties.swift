import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - PS1

  // sourcery: pyproperty = ps1, setter = setPS1
  /// sys.ps1
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the primary and secondary prompt of the interpreter.
  /// These are only defined if the interpreter is in interactive mode.
  internal var ps1Object: PyObject {
    return self.get(key: .ps1) ?? Py.getInterned(">>> ")
  }

  internal func setPS1(to value: PyObject) -> PyResult<()> {
    self.set(key: .ps1, value: value)
    return .value()
  }

  /// String that should be printed in interactive mode.
  public var ps1: String {
    switch Py.strValue(self.ps1Object) {
    case .value(let s): return s
    case .error: return ""
    }
  }

  // MARK: - PS2

  // sourcery: pyproperty = ps2, setter = setPS2
  /// sys.ps2
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the primary and secondary prompt of the interpreter.
  /// These are only defined if the interpreter is in interactive mode.
  internal var ps2Object: PyObject {
    return self.get(key: .ps2) ?? Py.getInterned("... ")
  }

  internal func setPS2(to value: PyObject) -> PyResult<()> {
    self.set(key: .ps2, value: value)
    return .value()
  }

  /// String that should be printed in interactive mode.
  public var ps2: String {
    switch Py.strValue(self.ps2Object) {
    case .value(let s): return s
    case .error: return ""
    }
  }

  // MARK: - Stdin

  // sourcery: pyproperty = stdin, setter = setStdin
  /// sys.stdin
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal var stdin: PyObject {
    return self.get(key: .stdin) ?? self.__stdin__
  }

  internal func setStdin(to value: PyObject) -> PyResult<()> {
    self.set(key: .stdin, value: value)
    return .value()
  }

  // MARK: - Stdout

  // sourcery: pyproperty = stdout, setter = setStdout
  /// sys.stdout
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal var stdout: PyObject {
    return self.get(key: .stdout) ?? self.__stdout__
  }

  internal func setStdout(to value: PyObject) -> PyResult<()> {
    self.set(key: .stdout, value: value)
    return .value()
  }

  // MARK: - Stderr

  // sourcery: pyproperty = stderr, setter = setStderr
  /// sys.stderr
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal var stderr: PyObject {
    return self.get(key: .stderr) ?? self.__stderr__
  }

  internal func setStderr(to value: PyObject) -> PyResult<()> {
    self.set(key: .stderr, value: value)
    return .value()
  }

  // MARK: - Argv

  // sourcery: pyproperty = argv, setter = setArgv
  /// sys.argv
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.argv).
  ///
  /// The list of command line arguments passed to a Python script.
  /// `argv[0]` is the script name.
  /// If the command was executed using the `-c` command line option,
  /// `argv[0]` is set to the string `'-c'`.
  /// If no script name was passed to the Python interpreter,
  /// `argv[0]` is the empty string.
  internal var argv: PyObject {
    if let value = self.get(key: .argv) {
      return value
    }

    let strings = self.createDefaultArgv()
    let objects = strings.map(Py.newString(_:))
    return Py.newList(objects)
  }

  internal func setArgv(to value: PyObject) -> PyResult<()> {
    self.set(key: .argv, value: value)
    return .value()
  }

  /// pymain_init_core_argv(_PyMain *pymain, _PyCoreConfig *config, ...)
  /// And then modified using:
  /// https://docs.python.org/3.8/using/cmdline.html
  private func createDefaultArgv() -> [String] {
    let arguments = Py.config.arguments
    let argumentsWithoutProgramName = arguments.raw.dropFirst()

    var result = Array(argumentsWithoutProgramName)

    if result.isEmpty {
      result = [""]
    }

    assert(result.any)

    if arguments.command != nil {
      result[0] = "-c"
    } else if let module = arguments.module {
      // Technically we should put here the full path, but whatever...
      result[0] = module
    } else if let script = arguments.script {
      result[0] = script
    }

    return result
  }

  // MARK: - Executable

  // sourcery: pyproperty = executable
  /// sys.executable
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.executable).
  ///
  /// A string giving the absolute path of the executable binary for
  /// the Python interpreter, on systems where this makes sense.
  /// If Python is unable to retrieve the real path to its executable,
  /// `sys.executable` will be an empty string or `None`.
  internal var executable: PyObject {
    if let value = self.get(key: .executable) {
      return value
    }

    let result = Py.config.executablePath
    return Py.newString(result)
  }

  // MARK: - Platform

  public var platform: String {
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    return "darwin"
    #elseif os(Linux) || os(Android)
    return "linux"
    #elseif os(Cygwin) // Is this even a thing?
    return "cygwin"
    #elseif os(Windows)
    return "win32"
    #else
    return "unknown"
    #endif
  }

  // sourcery: pyproperty = platform
  /// sys.platform
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.platform).
  ///
  /// This string contains a platform identifier that can be used to append
  /// platform-specific components to `sys.path`, for instance.
  internal var platformObject: PyString {
    return Py.getInterned(self.platform)
  }

  // MARK: - Copyright

  public var copyright: String {
    return Lyrics.letItGo
  }

  // sourcery: pyproperty = copyright
  /// sys.copyright
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.copyright).
  ///
  /// A string containing the copyright pertaining to the Python interpreter.
  internal var copyrightObject: PyString {
    return Py.getInterned(self.copyright)
  }

  // MARK: - Hash

  // sourcery: pyproperty = hash_info
  /// sys.hash_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.hash_info).
  internal var hashInfoObject: PyObject {
    return self.hashInfo.object
  }
}
