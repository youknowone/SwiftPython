// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// This file was auto-generated by Elsa from 'ast.letitgo' using 'ast' command.
// DO NOT EDIT!

import Foundation
import Core
import Lexer

// swiftlint:disable line_length
// swiftlint:disable trailing_newline

/// https://docs.python.org/3/reference/expressions.html
public struct Expression: Equatable {

  /// Type of the expression.
  public let kind: ExpressionKind
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(kind: ExpressionKind, start: SourceLocation, end: SourceLocation) {
    self.kind = kind
    self.start = start
    self.end = end
  }
}

/// https://docs.python.org/3/reference/expressions.html
public indirect enum ExpressionKind: Equatable {
  case `true`
  case `false`
  case none
  case ellipsis
  case identifier(String)
  case int(PyInt)
  case float(Double)
  case complex(real: Double, imag: Double)
  case bytes(Data)
  /// Operation with single operand.
  case unaryOp(UnaryOperator, right: Expression)
  /// Operation with 2 operands.
  case binaryOp(BinaryOperator, left: Expression, right: Expression)
  /// Operation with logical values as operands.
  /// Returns last evaluated argument (even if it's not True or False).
  /// - Note:
  /// Following values are interpreted as false:
  /// - False
  /// - None
  /// - numeric zero
  /// - empty strings
  /// - empty containers
  case boolOp(BooleanOperator, left: Expression, right: Expression)
  case compare(left: Expression, elements: [ComparisonElement])
  /// Values separated by commas (sometimes between parentheses): (a,b).
  case tuple([Expression])
  /// List of comma-separated values between square brackets: [a,b].
  case list([Expression])
  /// List of comma-separated values between braces: {a}. Unordered with no duplicates.
  case set([Expression])
  case await(Expression)
  case yield(Expression?)
  case yieldFrom(Expression)
  case lambda(args: Arguments, body: Expression)
  case namedExpr(target: Expression, value: Expression)
  case ifExpression(test: Expression, body: Expression, orElse: Expression)
  case starred(Expression)
}

public enum UnaryOperator: Equatable {
  /// Bitwise inversion of its integer argument.
  /// Only applies to integral numbers.
  case invert
  /// True if its argument is false, False otherwise.
  case not
  /// Unchanged argument. CPython: UAdd (unary add).
  case plus
  /// Negation of its numeric argument. CPython: USub (unary sub).
  case minus
}

public enum BooleanOperator: Equatable {
  /// Logical `and` with short-circuit.
  case and
  /// Logical `or` with short-circuit.
  case or
}

public enum BinaryOperator: Equatable {
  /// Sum of its arguments.
  /// - Numbers added together.
  /// - Sequences are concatenated.
  case add
  /// Difference of its arguments.
  case sub
  /// Product of its arguments.
  /// - Numbers multiplied together.
  /// - For integer and sequence repetition is performed.
  case mul
  /// Intended to be used for matrix multiplication.
  /// No builtin Python types implement this operator.
  case matMul
  /// Quotient of their arguments.
  /// Division of integers yields a float.
  case div
  /// Remainder from the division of the first argument by the second.
  case modulo
  /// Left argument raised to the power of its right argument.
  case pow
  /// Shift the first argument to the left by the number of bits
  /// given by the second argument.
  case leftShift
  /// Shift the first argument to the right by the number of bits
  /// given by the second argument.
  case rightShift
  /// Bitwise (inclusive) OR of its arguments, which must be integers.
  case bitOr
  /// Bitwise XOR (exclusive OR) of its arguments, which must be integers.
  case bitXor
  /// Bitwise AND of its arguments, which must be integers.
  case bitAnd
  /// Quotient of their arguments.
  /// Floor division of integers results in an integer.
  case floorDiv
}

public struct ComparisonElement: Equatable {

  public let op: ComparisonOperator
  public let right: Expression

  public init(op: ComparisonOperator, right: Expression) {
    self.op = op
    self.right = right
  }
}

public enum ComparisonOperator: Equatable {
  /// True when two operands are equal.
  case equal
  /// True when two operands are not equal.
  case notEqual
  /// True when left operand is less than the value of right operand.
  case less
  /// True when left operand is less than or equal to the value of right operand.
  case lessEqual
  /// True when left operand is greater than the value of right operand.
  case greater
  /// True when left operand is greater than or equal to the value of right operand.
  case greaterEqual
  /// True when x and y are the same object.
  case `is`
  /// Negation of `x is y`.
  case isNot
  /// True when x is a member of s.
  case `in`
  /// Negation of `x in s`
  case notIn
}

public enum StringGroup: Equatable {
  case string(String)
  case formattedValue(value: Expression, conversion: ConversionFlag?, spec: String)
  /// Transforms a value prior to formatting it.
  case joinedString([StringGroup])
}

public enum ConversionFlag: Equatable {
  /// Converts by calling `str(<value>)`.
  case str
  /// Converts by calling `ascii(<value>)`.
  case ascii
  /// Converts by calling `repr(<value>)`.
  case repr
}

/// The arguments for a function passed by value
/// (where the value is always an object reference, not the value of the object).
/// https://docs.python.org/3/tutorial/controlflow.html#more-on-defining-functions
public struct Arguments: Equatable {

  /// Function positional arguments.
  /// When a function is called, positional arguments are mapped
  /// to these parameters based solely on their position.
  public let args: [Arg]
  /// Default values for positional arguments.
  /// If there are fewer defaults, they correspond to the last *n* arguments.
  /// - Important: The default value is evaluated only **once**.
  public let defaults: [Expression]
  /// Non-keyworded variable length arguments.
  /// By convention called `*args`.
  public let vararg: Vararg
  /// Parameters which occur after the '*args'.
  /// Can only be used as keywords rather than positional arguments.
  /// CPython `kwonlyargs`.
  public let kwOnlyArgs: [Arg]
  /// Default values for keyword-only arguments.
  /// If no default value is specified then implicit `None` is assumed.
  /// CPython `kw_defaults`.
  /// - Important: The default value is evaluated only **once**.
  public let kwOnlyDefaults: [Expression]
  /// Keyworded (named) variable length arguments.
  /// By convention called `**kwargs`.
  public let kwarg: Arg?
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(args: [Arg], defaults: [Expression], vararg: Vararg, kwOnlyArgs: [Arg], kwOnlyDefaults: [Expression], kwarg: Arg?, start: SourceLocation, end: SourceLocation) {
    self.args = args
    self.defaults = defaults
    self.vararg = vararg
    self.kwOnlyArgs = kwOnlyArgs
    self.kwOnlyDefaults = kwOnlyDefaults
    self.kwarg = kwarg
    self.start = start
    self.end = end
  }
}

public struct Arg: Equatable {

  /// Argument name.
  public let name: String
  /// Python expression evaluated at compile time.
  /// Not used during runtime, can be used by third party libraries.
  /// Introduced in PEP 3107.
  public let annotation: Expression?
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(name: String, annotation: Expression?, start: SourceLocation, end: SourceLocation) {
    self.name = name
    self.annotation = annotation
    self.start = start
    self.end = end
  }
}

public enum Vararg: Equatable {
  case none
  /// Separator for keyword arguments. Represented by just `*`.
  case unnamed
  case named(Arg)
}

