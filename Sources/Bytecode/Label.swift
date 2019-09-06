/// Index of jump target in `CodeObject.labels`.
/// Basically a wrapper around array index for additional type safety.
/// - Important:
/// Labels can only be used inside a single block!
public struct Label {

  public static let notAssigned = -1

  /// Index in `CodeObject.labels`
  internal let index: Int

  internal init(index: Int) {
    self.index = index
  }
}