import Core

public enum ClosureVariable {
  /// Captured variable
  case cell(MangledName)
  /// Closure over 'name'
  case free(MangledName)
}

extension CodeObjectBuilder {

  /// Append a `nop` instruction to this code object.
  public func appendNop() {
    self.append(.nop)
  }

  /// Append a `popTop` instruction to this code object.
  public func appendPopTop() {
    self.append(.popTop)
  }

  /// Append a `rotTwo` instruction to this code object.
  public func appendRotTwo() {
    self.append(.rotTwo)
  }

  /// Append a `rotThree` instruction to this code object.
  public func appendRotThree() {
    self.append(.rotThree)
  }

  /// Append a `dupTop` instruction to this code object.
  public func appendDupTop() {
    self.append(.dupTop)
  }

  /// Append a `dupTopTwo` instruction to this code object.
  public func appendDupTopTwo() {
    self.append(.dupTopTwo)
  }

  /// Append a `printExpr` instruction to this code object.
  public func appendPrintExpr() {
    self.append(.printExpr)
  }

  /// Append an `extendedArg` instruction to this code object.
  public func appendExtendedArg(value: UInt8) {
    // self.append(.extendedArg)
    self.unimplemented()
  }

  /// Append a `setupAnnotations` instruction to this code object.
  public func appendSetupAnnotations() {
    self.append(.setupAnnotations)
  }

  /// Append a `popBlock` instruction to this code object.
  public func appendPopBlock() {
    self.append(.popBlock)
  }

  /// Append a `loadClosure` instruction to this code object.
  public func appendLoadClosure(_ variable: ClosureVariable) {
    // self.append(.loadClosure)
    //    if let i = codeObject.cellVars.firstIndex(of: name) {
    //      index = .cell(name)
    //    } else {
    //      assert(false)
    //    }
    //    switch index {
    //    case let .cell(i):
    //      // index = i
    //      break
    //    case let .free(i):
    //      let offset = self.cellVars.count
    //      // index = offset + i
    //      break
    //    }

    self.unimplemented()
  }

  /// Append a `buildSlice` instruction to this code object.
  public func appendBuildSlice(_ arg: SliceArg) {
    self.append(.buildSlice(arg))
  }
}