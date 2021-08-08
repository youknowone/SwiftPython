import Foundation

// swiftlint:disable force_unwrapping
// swiftlint:disable implicitly_unwrapped_optional

/// Syscalls etc.
///
/// Tiny wrapper to make them feel more 'Swift-like'.
internal enum LibC {

  // MARK: - strlen

  /// https://linux.die.net/man/3/strlen
  internal static func strlen(str: UnsafePointer<Int8>) -> Int {
    return Foundation.strlen(str)
  }

  // MARK: - basename

  /// https://linux.die.net/man/3/basename
  internal static func basename(
    path: UnsafeMutablePointer<Int8>!
  ) -> UnsafeMutablePointer<Int8> {
    // Both dirname() and basename() return pointers to null-terminated strings.
    // (Do not pass these pointers to free(3).)

    // 'Foundation.basename' returns 'UnsafeMutablePointer<Int8>!',
    // so it is safe to unwrap.
    return Foundation.basename(path)!
  }

  // MARK: - dirname

  /// https://linux.die.net/man/1/dirname
  internal static func dirname(
    path: UnsafeMutablePointer<Int8>!
  ) -> UnsafeMutablePointer<Int8> {
    // Both dirname() and basename() return pointers to null-terminated strings.
    // (Do not pass these pointers to free(3).)

    // 'Foundation.dirname' returns 'UnsafeMutablePointer<Int8>!',
    // so it is safe to unwrap.
    return Foundation.dirname(path)!
  }

  // MARK: - stat

  internal static func createStat() -> stat {
    return Foundation.stat()
  }

  internal enum StatResult {
    case ok
    case errno(Int32)

    fileprivate init(returnValue: Int32) {
      // On success, zero is returned.
      // On error, -1 is returned, and errno is set appropriately.
      if returnValue == 0 {
        self = .ok
        return
      }

      assert(returnValue == -1)

      let err = Foundation.errno
      Foundation.errno = 0
      self = .errno(err)
    }
  }

  /// https://linux.die.net/man/2/fstat
  internal static func fstat(fd: Int32,
                             buf: UnsafeMutablePointer<stat>!) -> StatResult {
    let returnValue = Foundation.fstat(fd, buf)
    return StatResult(returnValue: returnValue)
  }

  /// https://linux.die.net/man/2/lstat
  internal static func lstat(path: UnsafePointer<Int8>!,
                             buf: UnsafeMutablePointer<stat>!) -> StatResult {
    let returnValue = Foundation.lstat(path, buf)
    return StatResult(returnValue: returnValue)
  }

  // MARK: - opendir

  internal enum OpendirResult {
    case value(UnsafeMutablePointer<DIR>)
    case errno(Int32)

    fileprivate init(returnValue: UnsafeMutablePointer<DIR>!) {
      // The opendir() and fdopendir() functions return a pointer to the directory
      // stream. On error, NULL is returned, and errno is set appropriately.

      if let dirp = returnValue {
        self = .value(dirp)
        return
      }

      let err = Foundation.errno
      Foundation.errno = 0
      self = .errno(err)
    }
  }

  /// https://linux.die.net/man/3/fdopendir
  internal static func fdopendir(fd: Int32) -> OpendirResult {
    let returnValue = Foundation.fdopendir(fd)
    return OpendirResult(returnValue: returnValue)
  }

  /// https://linux.die.net/man/3/opendir
  internal static func opendir(name: UnsafePointer<Int8>!) -> OpendirResult {
    let returnValue = Foundation.opendir(name)
    return OpendirResult(returnValue: returnValue)
  }

  // MARK: - readdir_r

  internal static func createDirent() -> dirent {
    return dirent()
  }

  internal enum ReaddirResult {
    case entryWasUpdated
    case noMoreEntries
    case errno(Int32)
  }

  /// https://linux.die.net/man/3/readdir_r
  internal static func readdir_r(
    dirp: UnsafeMutablePointer<DIR>!,
    entry: UnsafeMutablePointer<dirent>!,
    result: UnsafeMutablePointer<UnsafeMutablePointer<dirent>?>!
  ) -> ReaddirResult {
    // The readdir_r() function returns 0 on success.
    // On error, it returns a positive error number (listed under ERRORS).
    // If the end of the directory stream is reached, readdir_r() returns 0,
    // and returns NULL in *result.

    let errno = Foundation.readdir_r(dirp, entry, result)
    guard errno == 0 else {
      return .errno(errno)
    }

    let isResultNil = result?.pointee == nil
    if isResultNil {
      return .noMoreEntries
    }

    return .entryWasUpdated
  }

  // MARK: - closedir

  internal enum ClosedirResult {
    case ok
    case errno(Int32)
  }

  /// https://linux.die.net/man/3/closedir
  internal static func closedir(dirp: UnsafeMutablePointer<DIR>!) -> ClosedirResult {
    // The closedir() function returns 0 on success. On error, -1 is returned,
    // and errno is set appropriately.

    let returnValue = Foundation.closedir(dirp)
    if returnValue == 0 {
      return .ok
    }

    assert(returnValue == -1)

    // Should not happen, the only possible thing is:
    // EBADF - Invalid directory stream descriptor dirp.
    let err = Foundation.errno
    Foundation.errno = 0
    return .errno(err)
  }
}