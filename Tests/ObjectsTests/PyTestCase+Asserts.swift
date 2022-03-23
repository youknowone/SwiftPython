import XCTest
import Foundation
import BigInt
import FileSystem
import VioletObjects // Do not add '@testable'! We want to do everything 'by the book'.

extension PyTestCase {

  // MARK: - Repr, str

  func assertRepr<T: PyObjectMixin>(_ py: Py,
                                    object: T,
                                    expected: String,
                                    file: StaticString = #file,
                                    line: UInt = #line) {
    let result = py.repr(object.asObject)
    let expectedObject = py.newString(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  func assertStr<T: PyObjectMixin>(_ py: Py,
                                   object: T,
                                   expected: String,
                                   file: StaticString = #file,
                                   line: UInt = #line) {
    let result = py.str(object.asObject)
    let expectedObject = py.newString(expected)
    self.assertIsEqual(py, left: result, right: expectedObject, file: file, line: line)
  }

  // MARK: - Equal

  func assertIsEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                         left: L?,
                                                         right: R,
                                                         expected: Bool = true,
                                                         file: StaticString = #file,
                                                         line: UInt = #line) {
    guard let left = left else {
      XCTFail("Left is '.none'", file: file, line: line)
      return
    }

    self.assertIsEqual(py, left: left, right: right, expected: expected, file: file, line: line)
  }

  func assertIsEqual<R: PyObjectMixin>(_ py: Py,
                                       left: PyResult,
                                       right: R,
                                       expected: Bool = true,
                                       file: StaticString = #file,
                                       line: UInt = #line) {
    switch left {
    case let .value(o):
      self.assertIsEqual(py, left: o, right: right, expected: expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Left is error: \(reason)", file: file, line: line)
      return
    }
  }

  func assertIsEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                         left: PyResultGen<L>,
                                                         right: R,
                                                         expected: Bool = true,
                                                         file: StaticString = #file,
                                                         line: UInt = #line) {
    switch left {
    case let .value(o):
      self.assertIsEqual(py, left: o, right: right, expected: expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Left is error: \(reason)", file: file, line: line)
      return
    }
  }

  func assertIsEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                         left: L,
                                                         right: R,
                                                         expected: Bool = true,
                                                         file: StaticString = #file,
                                                         line: UInt = #line) {
    switch py.isEqualBool(left: left.asObject, right: right.asObject) {
    case let .value(bool):
      // Doing 'if' gives better error messages than 'XCTAssertEqual'.
      if expected {
        XCTAssertTrue(bool, "\(left) == \(right)", file: file, line: line)
      } else {
        XCTAssertFalse(bool, "\(left) != \(right)", file: file, line: line)
      }
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is equal error: \(reason)", file: file, line: line)
    }
  }

  // MARK: - Not equal

  func assertIsNotEqual<L: PyObjectMixin, R: PyObjectMixin>(_ py: Py,
                                                            left: L,
                                                            right: R,
                                                            expected: Bool = true,
                                                            file: StaticString = #file,
                                                            line: UInt = #line) {
    switch py.isNotEqual(left: left.asObject, right: right.asObject) {
    case let .value(o):
      self.assertIsTrue(py, object: o, expected: expected, file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is not equal error: \(reason)", file: file, line: line)
    }
  }

  // MARK: - Is true

  func assertIsTrue<T: PyObjectMixin>(_ py: Py,
                                      object: T,
                                      expected: Bool = true,
                                      file: StaticString = #file,
                                      line: UInt = #line) {
    switch py.isTrueBool(object: object.asObject) {
    case let .value(bool):
      XCTAssertEqual(bool, expected, "Is true", file: file, line: line)
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Is true error: \(reason)", file: file, line: line)
    }
  }

  // MARK: - Type error

  func assertTypeError(_ py: Py,
                       error: PyResult,
                       message: String?,
                       file: StaticString = #file,
                       line: UInt = #line) {
    if let e = self.unwrapError(result: error, file: file, line: line) {
      self.assertTypeError(py, error: e, message: message, file: file, line: line)
    }
  }

  func assertTypeError<T>(_ py: Py,
                          error: PyResultGen<T>,
                          message: String?,
                          file: StaticString = #file,
                          line: UInt = #line) {
    if let e = self.unwrapError(result: error, file: file, line: line) {
      self.assertTypeError(py, error: e, message: message, file: file, line: line)
    }
  }

  func assertTypeError<T: PyErrorMixin>(_ py: Py,
                                        error: T,
                                        message: String?,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    let isTypeError = py.cast.isTypeError(error.asObject)
    XCTAssert(isTypeError,
              "'\(error.typeName)' is not a type error.",
              file: file,
              line: line)

    if let expectedMessage = message {
      if let message = self.getMessageString(py, error: error) {
        XCTAssertEqual(message, expectedMessage, "Message", file: file, line: line)
      } else {
        XCTFail("No message", file: file, line: line)
      }
    }
  }
}