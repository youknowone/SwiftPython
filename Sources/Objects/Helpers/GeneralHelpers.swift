import Core
// TODO: Remove everything from here

// swiftlint:disable unavailable_function
// swiftlint:disable fatal_error_message

internal struct AdjustedIndices {
  internal var start:  Int
  internal var stop:   Int
  internal var step:   Int
  internal let length: Int
}

internal enum GeneralHelpers {

  /// PySlice_AdjustIndices
  internal static func adjustIndices(value: PySlice,
                                     to length: Int) -> AdjustedIndices {
    //    var start = value.start ?? 0
    //    var stop = value.stop ?? Int.max
    //    let step = value.step ?? 1
    //    let goingDown = step < 0
    //
    //    if start < 0 {
    //      start += length
    //      if start < 0 {
    //        start = goingDown ? -1 : 0
    //      }
    //    } else if start >= length {
    //      start = goingDown ? length - 1 : length
    //    }
    //
    //    if stop < 0 {
    //      stop += length
    //      if stop < 0 {
    //        stop = goingDown ? -1 : 0
    //      }
    //    } else if stop >= length {
    //      stop = goingDown ? length - 1 : length
    //    }
    //
    //    var length = length
    //    if goingDown {
    //      if stop < start {
    //        length = (start - stop - 1) / (-step) + 1
    //      }
    //    } else {
    //      if start < stop {
    //        length = (stop - start - 1) / step + 1
    //      }
    //    }
    //
    //    return AdjustedIndices(start: start, stop: stop, step: step, length: length)
    fatalError()
  }
}