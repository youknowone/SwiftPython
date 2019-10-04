import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3/library/stdtypes.html#range

// TODO: Range
// PyObject_GenericGetAttr,  /* tp_getattro */
// range_iter,             /* tp_iter */
// {"__reversed__",    (PyCFunction)range_reverse, METH_NOARGS, reverse_doc},
// {"__reduce__",      (PyCFunction)range_reduce,  METH_VARARGS},
// {"count",           (PyCFunction)range_count,   METH_O,      count_doc},
// {"index",           (PyCFunction)range_index,   METH_O,      index_doc},
// {"start",   T_OBJECT_EX,    offsetof(rangeobject, start),   READONLY},
// {"stop",    T_OBJECT_EX,    offsetof(rangeobject, stop),    READONLY},
// {"step",    T_OBJECT_EX,    offsetof(rangeobject, step),    READONLY},

internal enum PyRangeStep: Equatable {
  case implicit(BigInt)
  case explicit(BigInt)

  internal var value: BigInt {
    switch self {
    case let .implicit(v): return v
    case let .explicit(v): return v
    }
  }

  internal var isGoingUp: Bool {
    return self.value > 0
  }
}

/// A range object represents an integer range.
/// This is an immutable object; a range cannot change its value after creation.
///
/// Range objects behave like the corresponding tuple objects except that
/// they are represented by a start, stop, and step datamembers.
internal final class PyRange: PyObject {

  internal let start: BigInt
  internal let stop:  BigInt
  internal let step:  PyRangeStep
  internal let length: BigInt

  fileprivate init(type:  PyRangeType,
                   start: BigInt,
                   stop:  BigInt,
                   step:  BigInt?) {
    let stepEnum = PyRange.calculateStep(start: start, stop: stop, step: step)

    self.start = start
    self.stop = stop
    self.step = stepEnum
    self.length = PyRange.calculateLength(start: start, stop: stop, step: stepEnum)
    super.init(type: type)
  }

  private static func calculateStep(start: BigInt,
                                    stop:  BigInt,
                                    step:  BigInt?) -> PyRangeStep {
    if let step = step {
      return .explicit(step)
    }

    let isGrowing = start < stop
    return .implicit(isGrowing ? 1 : -1)
  }

  private static func calculateLength(start: BigInt,
                                      stop:  BigInt,
                                      step:  PyRangeStep) -> BigInt {
    let isGoingUp = step.isGoingUp
    let low  = isGoingUp ? start : stop
    let high = isGoingUp ? stop : start
    let step = isGoingUp ? step.value : -step.value

    // len(range(0, 3, -1)) -> 0
    if low >= high {
      return 0
    }

    let diff = (high - low) - 1
    return (diff / step) + 1
  }
}

/// A range object represents an integer range.
/// This is an immutable object; a range cannot change its value after creation.
///
/// Range objects behave like the corresponding tuple objects except that
/// they are represented by a start, stop, and step datamembers.
internal final class PyRangeType: PyType,
  ReprTypeClass,
  HashableTypeClass, ComparableTypeClass,
  PyBoolConvertibleTypeClass,
  LengthTypeClass, ItemTypeClass, ContainsTypeClass,
  SubscriptTypeClass {

  override internal var name: String { return "range" }
  override internal var doc: String? { return """
    range(stop) -> range object
    range(start, stop[, step]) -> range object

    Return an object that produces a sequence of integers from start (inclusive)
    to stop (exclusive) by step.  range(i, j) produces i, i+1, i+2, ..., j-1.
    start defaults to 0, and stop is omitted!  range(4) produces 0, 1, 2, 3.
    These are exactly the valid indices for a list of 4 elements.
    When step is given, it specifies the increment (or decrement).
    """
  }

  // MARK: - Ctor

  internal func new(stop: BigInt) -> PyRange {
    return PyRange(type: self, start: 0, stop: stop, step: nil)
  }

  internal func new(start: BigInt, stop: BigInt, step: BigInt? = nil) -> PyRange {
    return PyRange(type: self, start: start, stop: stop, step: step)
  }

  // MARK: - Equatable, hashable

  internal func hash(value: PyObject) throws -> PyHash {
    let v = try self.matchType(value)

    let none = self.context.none
    let tuple = self.types.tuple.new([self.pyInt(v.length), none, none])

    if v.length == 0 {
      return try self.context.hash(value: tuple)
    }

    tuple.elements[1] = self.pyInt(v.start)
    if v.length != 1 {
      tuple.elements[2] = self.pyInt(v.step.value)
    }

    return try self.context.hash(value: tuple)
  }

  internal func compare(left: PyObject,
                        right: PyObject,
                        mode: CompareMode) throws -> Bool {
    let l = try self.matchType(left)
    let r = try self.matchType(right)

    switch mode {
    case .equal:
      return self.isEqual(left: l, right: r)
    case .notEqual:
      return !self.isEqual(left: l, right: r)
    case .less,
         .lessEqual,
         .greater,
         .greaterEqual:
      throw ComparableNotImplemented(left: left, right: right)
    }
  }

  private func isEqual(left: PyRange, right: PyRange) -> Bool {
    guard left.length == right.length else {
      return false
    }

    if left.length == 0 {
      return true
    }

    guard left.start == right.start else {
      return false
    }

    if left.length == 1 {
      return true
    }

    return left.step == right.step
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let v = try self.matchType(value)
    switch v.step {
    case .implicit:
      return "range(\(v.start), \(v.stop))"
    case let .explicit(step):
      return "range(\(v.start), \(v.stop), \(step))"
    }
  }

  // MARK: - Methods

  internal func bool(value: PyObject) throws -> PyBool {
    let v = try self.matchType(value)
    return self.types.bool.new(v.length)
  }

  internal func length(value: PyObject) throws -> PyInt {
    let v = try self.matchType(value)
    return self.types.int.new(v.length)
  }

  internal func item(owner: PyObject, at index: Int) throws -> PyObject {
    let o = try self.matchType(owner)

    var i = BigInt(index)
    if index < 0 {
      i += o.length
    }

    if i < 0 || i >= o.length {
      // PyErr_SetString(PyExc_IndexError, "range object index out of range");
      fatalError()
    }

    let result = o.start + o.step.value * i
    return self.types.int.new(result)
  }

  internal func contains(owner: PyObject, element: PyObject) throws -> Bool {
    let o = try self.matchType(owner)
    let i = try self.types.int.extractInt(element)

    // Check if the value can possibly be in the range.
    if o.step.isGoingUp {
      // positive steps: start <= ob < stop
      guard o.start <= i && i < o.stop else {
        return false
      }
    } else {
      // negative steps: stop < ob <= start
      guard o.stop < i && i <= o.start else {
        return false
      }
    }

    let tmp1 = i - o.start
    let tmp2 = tmp1 % o.step.value
    return tmp2 == 0
  }

  internal func `subscript`(owner: PyObject, index: PyObject) throws -> PyObject {
    let o = try self.matchType(owner)

    if let index = try extractIndex(value: index) {
      return try self.item(owner: o, at: index)
    }

    if let _ = index as? PySlice {
      fatalError()
    }

    // PyErr_Format(PyExc_TypeError,
    //              "range indices must be integers or slices, not %.200s",
    //              item->ob_type->tp_name);
    fatalError()
  }

  // MARK: - Helpers

  private func pyInt(_ value: BigInt) -> PyInt {
    return self.types.int.new(value)
  }

  internal func matchTypeOrNil(_ object: PyObject) -> PyRange? {
    if let o = object as? PyRange {
      return o
    }

    return nil
  }

  internal func matchType(_ object: PyObject) throws -> PyRange {
    if let o = object as? PyRange {
      return o
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
