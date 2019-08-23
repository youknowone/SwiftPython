public enum NotImplemented: Error, Equatable {

  /// Violet supports only UTF-8 encoding.
  /// Trying to set it to other value (for example by using
  /// `'# -*- coding: xxx -*-'` or `'# vim:fileencoding=xxx'`) will throw.
  case encodingOtherThanUTF8(String)

  /// Since we dont have BigInts in Swift integers outside of
  /// `<BigInt.min, BigInt.max>` range are not currently supported.
  case unlimitedInteger

  /// Escapes in form of `\N{UNICODE_NAME}` (for example: `\N{Em Dash}`)
  /// are not currently supported.
  case stringNamedEscape

  /// Expressions in format specifiers are not currently supported.
  ///
  /// For example:
  /// ```c
  /// width = 10
  /// s = f"Let it {'go':>{width}}!"
  /// ```
  case expressionInFormatSpecifierInsideFString

  /// This will never be implemented, because of Swift limitations.
  /// https://www.python.org/dev/peps/pep-0401/
  case pep401
}

extension NotImplemented: CustomStringConvertible {
  public var description: String {
    switch self {
    case .encodingOtherThanUTF8(let encoding):
      return "Encoding '\(encoding)' is not currently supported (only UTF-8 is)."

    case.unlimitedInteger:
      return "Integers outside of <\(BigInt.min), \(BigInt.max)> range " +
             "are not currently supported."

    case .stringNamedEscape:
      return "Escapes in form of '\\N{UNICODE_NAME}' " +
             "(for example: '\\N{Em Dash}') " +
             "are not currently supported."

    case .expressionInFormatSpecifierInsideFString:
      return "Expressions in format specifiers " +
             "(for example: 'f\"Let it {'go':>{width}}!\"')" +
             "are not currently supported."

    case .pep401:
      return "Uh... Oh... that means that we have to implement '<>' now."
    }
  }
}
