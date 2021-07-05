import UnicodeData

extension PyString {

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _asUnicodeScalar(element: UnicodeScalar) -> UnicodeScalar {
    return element
  }

  // MARK: - Whitespace

  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isWhitespace(element: UnicodeScalar) -> Bool {
    return UnicodeData.isWhitespace(element)
  }

  // MARK: - Line break

  /// This is not exposed to Python, but it is used in various methods
  /// (for example `splitlines`).
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isLineBreak(element: UnicodeScalar) -> Bool {
    return UnicodeData.isLineBreak(element)
  }

  // MARK: - AlphaNumeric

  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isAlphaNumeric(element: UnicodeScalar) -> Bool {
    return UnicodeData.isAlphaNumeric(element)
  }

  // MARK: - Alpha

  /// Alphabetic characters are those characters defined in the Unicode character
  /// database as “Letter”, i.e., those with general category property
  /// being one of “Lm”, “Lt”, “Lu”, “Ll”, or “Lo”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isalpha
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isAlpha(element: UnicodeScalar) -> Bool {
    return UnicodeData.isAlpha(element)
  }

  // MARK: - ASCII

  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isAscii(element: UnicodeScalar) -> Bool {
    return ASCIIData.isASCII(element)
  }

  // MARK: - Decimal

  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isDecimal(element: UnicodeScalar) -> Bool {
    return UnicodeData.isDecimalDigit(element)
  }

  // MARK: - Digit

  /// Formally, a digit is a character that has the property value
  /// Numeric_Type=Digit or Numeric_Type=Decimal.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdigit
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isDigit(element: UnicodeScalar) -> Bool {
    return UnicodeData.isDigit(element)
  }

  // MARK: - Lower

  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isLower(element: UnicodeScalar) -> Bool {
    // If a character does not have case then True, for example:
    // "a\u02B0b".islower() -> True
    return !UnicodeData.isCased(element) || UnicodeData.isLowercase(element)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _lowercaseMapping(
    element: UnicodeScalar
  ) -> UnicodeData.CaseMapping {
    return UnicodeData.toLowercase(element)
  }

  // MARK: - Upper

  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isUpper(element: UnicodeScalar) -> Bool {
    // If a character does not have case then True, for example:
    // "a\u02B0b".isupper() -> True
    return !UnicodeData.isCased(element) || UnicodeData.isUppercase(element)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _uppercaseMapping(
    element: UnicodeScalar
  ) -> UnicodeData.CaseMapping {
    return UnicodeData.toUppercase(element)
  }

  // MARK: - Numeric

  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isNumeric(element: UnicodeScalar) -> Bool {
    return UnicodeData.isNumeric(element)
  }

  // MARK: - Title

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isTitle(element: UnicodeScalar) -> Bool {
    return UnicodeData.isTitlecase(element)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _titlecaseMapping(
    element: UnicodeScalar
  ) -> UnicodeData.CaseMapping {
    return UnicodeData.toTitlecase(element)
  }

  // MARK: - Is cased

  internal static func _isCased(element: UnicodeScalar) -> Bool {
    return UnicodeData.isCased(element)
  }

  // MARK: - Printable

  /// Return true if all characters in the string are printable
  /// or the string is empty.
  ///
  /// Nonprintable characters are those characters defined in the Unicode
  /// character database as “Other” or “Separator”,
  /// excepting the ASCII space (0x20) which is considered printable.
  ///
  /// All characters except those characters defined in the Unicode character
  /// database as following categories are considered printable.
  ///    * Cc (Other, Control)
  ///    * Cf (Other, Format)
  ///    * Cs (Other, Surrogate)
  ///    * Co (Other, Private Use)
  ///    * Cn (Other, Not Assigned)
  ///    * Zl Separator, Line ('\u2028', LINE SEPARATOR)
  ///    * Zp Separator, Paragraph ('\u2029', PARAGRAPH SEPARATOR)
  ///    * Zs (Separator, Space) other than ASCII space('\x20').
  /// https://docs.python.org/3/library/stdtypes.html#str.isprintable
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isPrintable(element: UnicodeScalar) -> Bool {
    return UnicodeData.isPrintable(element)
  }
}