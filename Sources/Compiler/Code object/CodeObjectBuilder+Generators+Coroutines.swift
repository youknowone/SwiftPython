import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  // MARK: - Generators

  /// Append a `yieldValue` instruction to currently filled code object.
  public func emitYieldValue(location: SourceLocation) throws {
    try self.emit(.yieldValue, location: location)
  }

  /// Append a `yieldFrom` instruction to currently filled code object.
  public func emitYieldFrom(location: SourceLocation) throws {
    try self.emit(.yieldFrom, location: location)
  }

  // MARK: - Coroutine

  /// Append a `getAwaitable` instruction to currently filled code object.
  public func emitGetAwaitable(location: SourceLocation) throws {
    try self.emit(.getAwaitable, location: location)
  }

  /// Append a `getAIter` instruction to currently filled code object.
  public func emitGetAIter(location: SourceLocation) throws {
    try self.emit(.getAIter, location: location)
  }

  /// Append a `getANext` instruction to currently filled code object.
  public func emitGetANext(location: SourceLocation) throws {
    try self.emit(.getANext, location: location)
  }
}
