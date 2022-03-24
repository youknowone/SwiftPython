import XCTest
import Foundation
import VioletBytecode
@testable import VioletObjects

extension PyFrame {
  fileprivate var objectStackCapacity: Int {
    return self.objectStackStorage.count
  }
}

class PyFrameObjectStackTests: PyTestCase, PyFrameTestsMixin {

  // MARK: - Empty

  func test_empty() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    let stack = frame.exclusiveObjectStack
    self.assertStack(py, stack, expected: [])
  }

  // MARK: - Push

  func test_push() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    var stack = frame.exclusiveObjectStack
    var expectedStack = [PyObject]()
    self.assertStack(py, stack, expected: expectedStack)

    // === Before resize ===
    let capacityBeforeResize = frame.objectStackCapacity
    for i in 0..<capacityBeforeResize {
      let object = py.newInt(i).asObject
      stack.push(object)
      expectedStack.push(object)
      self.assertStack(py, stack, expected: expectedStack)
    }

    XCTAssertEqual(frame.objectStackCapacity, capacityBeforeResize)

    // === Resize ===
    for i in capacityBeforeResize..<(capacityBeforeResize + 10) {
      let object = py.newInt(i).asObject
      stack.push(object)
      expectedStack.push(object)
      self.assertStack(py, stack, expected: expectedStack)
    }

    XCTAssertNotEqual(frame.objectStackCapacity, capacityBeforeResize)
  }

  func test_push_collection() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    var stack = frame.exclusiveObjectStack
    var expectedStack = [PyObject]()
    self.assertStack(py, stack, expected: expectedStack)

    // === Before resize ===
    let capacityBeforeResize = frame.objectStackCapacity

    let push1Count = capacityBeforeResize / 2
    let push1Objects = (0..<push1Count).map { py.newInt($0).asObject }

    stack.push(contentsOf: push1Objects)
    expectedStack.append(contentsOf: push1Objects)
    self.assertStack(py, stack, expected: expectedStack)
    XCTAssertEqual(frame.objectStackCapacity, capacityBeforeResize)

    let push2Count = capacityBeforeResize - push1Count
    let push2Objects = (0..<push2Count).map { py.newInt(push1Count + $0).asObject }

    stack.push(contentsOf: push2Objects)
    expectedStack.append(contentsOf: push2Objects)
    self.assertStack(py, stack, expected: expectedStack)
    XCTAssertEqual(frame.objectStackCapacity, capacityBeforeResize)

    // === Resize ===
    let resizeCount = 10
    let resizeObjects = (0..<resizeCount).map { py.newInt($0).asObject }

    stack.push(contentsOf: resizeObjects)
    expectedStack.append(contentsOf: resizeObjects)
    self.assertStack(py, stack, expected: expectedStack)
    XCTAssertNotEqual(frame.objectStackCapacity, capacityBeforeResize)
  }

  // MARK: - Set

  func test_set() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    var stack = frame.exclusiveObjectStack
    var expectedStack = [PyObject]()
    self.assertStack(py, stack, expected: expectedStack)

    // Push some objects
    for i in 0..<10 {
      let object = py.newInt(i).asObject
      stack.push(object)
      expectedStack.push(object)
    }

    self.assertStack(py, stack, expected: expectedStack)

    // Actual test starts here
    let top = py.newFloat(4.2).asObject
    stack.set(0, object: top)
    expectedStack[9] = top
    self.assertStack(py, stack, expected: expectedStack)

    let topAgain = py.newFloat(8.4).asObject
    stack.set(0, object: topAgain)
    expectedStack[9] = topAgain
    self.assertStack(py, stack, expected: expectedStack)

    let second = py.newFloat(12.2).asObject
    stack.set(1, object: second)
    expectedStack[8] = second
    self.assertStack(py, stack, expected: expectedStack)

    let third = py.newFloat(16.7).asObject
    stack.set(2, object: third)
    expectedStack[7] = third
    self.assertStack(py, stack, expected: expectedStack)

    let tenth = py.newFloat(21.3).asObject
    stack.set(9, object: tenth)
    expectedStack[0] = tenth
    self.assertStack(py, stack, expected: expectedStack)
  }

  // MARK: - Pop

  func test_pop() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    var stack = frame.exclusiveObjectStack
    var expectedStack = [PyObject]()
    self.assertStack(py, stack, expected: expectedStack)

    // Push some objects
    for i in 0..<10 {
      let object = py.newInt(i).asObject
      stack.push(object)
      expectedStack.push(object)
    }

    self.assertStack(py, stack, expected: expectedStack)

    // Actual test starts here
    for _ in 0..<10 {
      let got = stack.pop()
      let expected = expectedStack.popLast()
      self.assertIsEqual(py, left: expected, right: got)
      self.assertStack(py, stack, expected: expectedStack)
    }

    self.assertStack(py, stack, expected: [])
  }

  func test_pop_in_push_order() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    var stack = frame.exclusiveObjectStack
    var expectedStack = [PyObject]()
    self.assertStack(py, stack, expected: expectedStack)

    // Push some objects
    for i in 0..<10 {
      let object = py.newInt(i).asObject
      stack.push(object)
      expectedStack.push(object)
    }

    self.assertStack(py, stack, expected: expectedStack)
    let all = expectedStack

    // Actual test starts here
    let pop0 = stack.popElementsInPushOrder(count: 0)
    self.assertIsEqual(py, left: pop0, right: [])
    self.assertStack(py, stack, expected: expectedStack)

    let pop1 = stack.popElementsInPushOrder(count: 3)
    self.assertIsEqual(py, left: pop1, right: [all[7], all[8], all[9]])
    expectedStack = Array(expectedStack.dropLast(3))
    self.assertStack(py, stack, expected: expectedStack)

    let pop2 = stack.popElementsInPushOrder(count: 4)
    self.assertIsEqual(py, left: pop2, right: [all[3], all[4], all[5], all[6]])
    expectedStack = Array(expectedStack.dropLast(4))
    self.assertStack(py, stack, expected: expectedStack)

    let pop3 = stack.popElementsInPushOrder(count: 3)
    self.assertIsEqual(py, left: pop3, right: [all[0], all[1], all[2]])
    self.assertStack(py, stack, expected: [])

    let pop4 = stack.popElementsInPushOrder(count: 0)
    self.assertIsEqual(py, left: pop4, right: [])
    self.assertStack(py, stack, expected: [])
  }

  func test_pop_until_count() {
    let py = self.createPy()
    guard let frame = self.createFrame(py) else { return }

    var stack = frame.exclusiveObjectStack
    var expectedStack = [PyObject]()
    self.assertStack(py, stack, expected: expectedStack)

    // Push some objects
    for i in 0..<10 {
      let object = py.newInt(i).asObject
      stack.push(object)
      expectedStack.push(object)
    }

    self.assertStack(py, stack, expected: expectedStack)

    // Actual test starts here
    stack.pop(untilCount: 7)
    expectedStack = Array(expectedStack.dropLast(3))
    self.assertStack(py, stack, expected: expectedStack)

    stack.pop(untilCount: 3)
    expectedStack = Array(expectedStack.dropLast(4))
    self.assertStack(py, stack, expected: expectedStack)

    stack.pop(untilCount: 0)
    self.assertStack(py, stack, expected: [])

    // Empty stack -> pop until 0
    stack.pop(untilCount: 0)
    self.assertStack(py, stack, expected: [])
  }

  // MARK: - Helpers

  /// Expected is in `bottom-to-top` order.
  private func assertStack(_ py: Py,
                           _ stack: PyFrame.ExclusiveObjectStackProxy,
                           expected: [PyObject],
                           file: StaticString = #file,
                           line: UInt = #line) {
    XCTAssertEqual(stack.count, expected.count, "Count", file: file, line: line)

    // Better error message when we have 'if'
    if expected.isEmpty {
      XCTAssertTrue(stack.isEmpty, "isEmpty", file: file, line: line)
    } else {
      XCTAssertFalse(stack.isEmpty, "isEmpty", file: file, line: line)
    }

    func assertIsEqual(left: PyObject, right: PyObject, message: String) {
      self.assertIsEqual(py, left: left, right: right, message: message, file: file, line: line)
    }

    let count = Swift.min(stack.count, expected.count)
    for indexFromTop in 0..<count {
      let indexFromBottom = count - indexFromTop - 1
      let object = expected[indexFromBottom]

      let peek = stack.peek(indexFromTop)
      assertIsEqual(left: peek, right: object, message: "peek \(indexFromTop)")

      switch indexFromTop {
      case 0:
        assertIsEqual(left: stack.top, right: object, message: "top")
      case 1:
        assertIsEqual(left: stack.second, right: object, message: "second")
      case 2:
        assertIsEqual(left: stack.third, right: object, message: "third")
      case 3:
        assertIsEqual(left: stack.fourth, right: object, message: "fourth")
      default:
        break
      }
    }
  }

  private func assertIsEqual(_ py: Py,
                             left: [PyObject],
                             right: [PyObject],
                             file: StaticString = #file,
                             line: UInt = #line) {
    XCTAssertEqual(left.count, right.count, "Count", file: file, line: line)

    for (index, (l, r)) in zip(left, right).enumerated() {
      self.assertIsEqual(py,
                         left: l,
                         right: r,
                         message: "Index: \(index)",
                         file: file,
                         line: line)
    }
  }
}
