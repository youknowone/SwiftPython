import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `setupLoop` instruction to code object.
  public func emitSetupLoop(value: Delta, location: SourceLocation) throws {
    // try self.emit(.setupLoop, location: location)
    throw self.unimplemented()
  }

  /// Append a `forIter` instruction to code object.
  public func emitForIter(value: Delta, location: SourceLocation) throws {
    // try self.emit(.forIter, location: location)
    throw self.unimplemented()
  }

  /// Append a `getIter` instruction to code object.
  public func emitGetIter(location: SourceLocation) throws {
    try self.emit(.getIter, location: location)
  }

  /// Append a `getYieldFromIter` instruction to code object.
  public func emitGetYieldFromIter(location: SourceLocation) throws {
    try self.emit(.getYieldFromIter, location: location)
  }

  /// Append a `breakLoop` instruction to code object.
  public func emitBreak(location: SourceLocation) throws {
    try self.emit(.break, location: location)
  }

  /// Append a `continueLoop` instruction to code object.
  public func emitContinue(value: Target, location: SourceLocation) throws {
    // try self.emit(.continueLoop, location: location)
    throw self.unimplemented()
  }
}