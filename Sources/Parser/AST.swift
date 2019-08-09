// This file was auto-generated by Elsa from 'ast.letitgo' using 'ast' command.
// DO NOT EDIT!

import Foundation
import Core
import Lexer

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable trailing_newline

/// Top (root) node in AST.
/// Represents the while program.
public enum AST: Equatable {
  case module([Statement])
  case statement([Statement])
  case expression(Expression)
}

public struct Statement: Equatable {

  /// Type of the statement.
  public let kind: StatementKind
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(kind: StatementKind, start: SourceLocation, end: SourceLocation) {
    self.kind = kind
    self.start = start
    self.end = end
  }
}

public enum StatementKind: Equatable {
  /// A function definition.
  /// - `name` is a raw string of the function name.
  /// - `args` is a arguments node.
  /// - `body` is the list of nodes inside the function.
  /// - `decorator_list` is the list of decorators to be applied, stored outermost first (i.e. the first in the list will be applied last).
  /// - `returns` is the return annotation (Python 3 only).
  case functionDef(name: String, args: Arguments, body: [Statement], decorator_list: [Expression], returns: Expression?)
  /// An async def function definition.
  /// Has the same fields as `FunctionDef`.
  case asyncFunctionDef(name: String, args: Arguments, body: [Statement], decorator_list: [Expression], returns: Expression?)
  /// A class definition.
  /// - `name` is a raw string for the class name
  /// - `bases` is a list of nodes for explicitly specified base classes.
  /// - `keywords` is a list of keyword nodes, principally for ‘metaclass’. Other keywords will be passed to the metaclass, as per PEP-3115.
  /// - `starargs` and kwargs are each a single node, as in a function call. starargs will be expanded to join the list of base classes, and kwargs will be passed to the metaclass. These are removed in Python 3.5 - see below for details.
  /// - `body` is a list of nodes representing the code within the class definition.
  /// - `decorator_list` is a list of nodes, as in `FunctionDef`.
  case classDef(name: String, bases: [Expression], keywords: [Keyword], body: [Statement], decorator_list: [Expression])
  /// A `return` statement.
  case `return`(value: Expression?)
  /// Represents a `del` statement.
  /// - `targets` is a list of nodes, such as Name, Attribute or Subscript nodes.
  case delete(targets: [Expression])
  /// An assignment.
  /// - `targets` is a list of nodes
  /// - `value` is a single node
  /// 
  /// Multiple nodes in targets represents assigning the same value to each.
  /// Unpacking is represented by putting a Tuple or List within targets.
  case assign(targets: [Expression], value: Expression)
  /// Augmented assignment, such as `a += 1`.
  /// - `target` is a Name node for `a`. Target can be Name, Subscript
  /// or Attribute, but not a Tuple or List (unlike the targets of `Assign`).
  /// - `op` is `Add`
  /// - `value` is a Num node for 1.
  case augAssign(target: Expression, op: Operator, value: Expression)
  /// An assignment with a type annotation.
  /// - `target` is a single node and can be a Name, a Attribute or a Subscript
  /// - `annotation` is the annotation, such as a Str or Name node
  /// - `value` is a single optional node
  /// - `simple` indicates that `target` does not appear
  /// in between parenthesis and is pure name and not expression.
  case annAssign(target: Expression, annotation: Expression, value: Expression?, simple: PyInt)
  /// A `for` loop.
  /// - `target` holds the variable(s) the loop assigns to, as a single Name, Tuple or List node.
  /// - `iter` holds the item to be looped over, again as a single node.
  /// - `body` and `orelse` contain lists of nodes to execute. Those in orelse
  /// are executed if the loop finishes normally, rather than via a break statement.
  case `for`(target: Expression, iter: Expression, body: [Statement], orelse: [Statement])
  /// An `async for` definition.
  /// Has the same fields as `For`.
  case asyncFor(target: Expression, iter: Expression, body: [Statement], orelse: [Statement])
  /// A `while` loop.
  /// - `test` holds the condition, such as a Compare node.
  case `while`(test: Expression, body: [Statement], orelse: [Statement])
  /// An if statement.
  /// - `test` holds a single node, such as a Compare node.
  /// - `body` and `orelse` each hold a list of nodes.
  /// 
  /// - `elif` clauses don’t have a special representation in the AST,
  /// but rather appear as extra `If` nodes within the `orelse` section
  /// of the previous one.
  case `if`(test: Expression, body: [Statement], orelse: [Statement])
  /// A `with` block.
  /// - `items` is a list of withitem nodes representing the context managers.
  /// - `body` is the indented block inside the context.
  /// Raising an exception.
  /// - `exc` is the exception object to be raised, normally a Call or Name
  /// or None for a standalone raise.
  /// - `cause` is the optional part for y in raise x from y.
  case raise(exc: Expression?, cause: Expression?)
  /// `try` block.
  /// All attributes are list of nodes to execute, except for handlers,
  /// which is a list of ExceptHandler nodes.
  case `try`(body: [Statement], handlers: [Excepthandler], orelse: [Statement], finalbody: [Statement])
  /// An assertion.
  /// - `test` holds the condition, such as a Compare node.
  /// - `msg` holds the failure message, normally a Str node.
  case assert(test: Expression, msg: Expression?)
  /// An import statement.
  /// - `names` is a list of alias nodes.
  case `import`(names: [Alias])
  /// Represents `from x import y`.
  /// - `moduleName` is a raw string of the ‘from’ name, without any leading dots
  /// or None for statements such as `from . import foo`.
  /// - `level` is an integer holding the level of the relative import
  /// (0 means absolute import).
  case importFrom(moduleName: String?, names: [Alias], level: PyInt?)
  /// `global` statement.
  case global(names: [String])
  /// `nonlocal` statement.
  case nonlocal(names: [String])
  /// `Expression` statement.
  case expr(value: Expression)
  /// A `pass` statement.
  case pass
  /// `break` statement.
  case `break`
  /// `continue` statement.
  case `continue`
}

/// Import name with optional 'as' alias.
/// Both parameters are raw strings of the names.
/// `asname` can be None if the regular name is to be used.
public struct Alias: Equatable {

  public let name: String
  public let asname: String?

  public init(name: String, asname: String?) {
    self.name = name
    self.asname = asname
  }
}

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
  case string(StringGroup)
  case int(PyInt)
  case float(Double)
  case complex(real: Double, imag: Double)
  case bytes(Data)
  /// Operation with single operand.
  case unaryOp(UnaryOperator, right: Expression)
  /// Operation with 2 operands.
  case binaryOp(BinaryOperator, left: Expression, right: Expression)
  /// Operation with logical values as operands.
  /// Returns last evaluated argument (even if it's not strictly `True` or `False`).
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
  /// Set of `key: value` pairs between braces: {a: b}. Keys are unique.
  case dictionary([DictionaryElement])
  /// List of comma-separated values between braces: {a}. Unordered with no duplicates.
  case set([Expression])
  /// Brackets containing an expression followed by a for clause and then
  /// zero or more for or if clauses.
  /// `elt` - expression that will be evaluated for each item
  case listComprehension(elt: Expression, generators: [Comprehension])
  /// Brackets containing an expression followed by a for clause and then
  /// zero or more for or if clauses.
  /// `elt` - expression that will be evaluated for each item
  case setComprehension(elt: Expression, generators: [Comprehension])
  /// Brackets containing an expression followed by a for clause and then
  /// zero or more for or if clauses.
  /// `key` and `value` - expressions that will be evaluated for each item
  case dictionaryComprehension(key: Expression, value: Expression, generators: [Comprehension])
  /// Expression followed by a for clause and then
  /// zero or more for or if clauses.
  /// `elt` - expression that will be evaluated for each item
  case generatorExp(elt: Expression, generators: [Comprehension])
  /// An await expression.
  /// `value` is what it waits for.
  /// 
  /// Only valid in the body of an AsyncFunctionDef.
  case await(Expression)
  /// A `yield` or `yield from` expression.
  /// Because these are expressions, they must be wrapped in a `Expr` node
  /// if the value sent back is not used.
  case yield(Expression?)
  /// A `yield` or `yield from` expression.
  /// Because these are expressions, they must be wrapped in a `Expr` node
  /// if the value sent back is not used.
  case yieldFrom(Expression)
  /// Minimal function definition that can be used inside an expression.
  /// Unlike FunctionDef, body holds a single node.
  case lambda(args: Arguments, body: Expression)
  /// A function call.
  /// - `func` - function to call
  /// - `args` - arguments passed by position
  /// - `keywords` - keyword objects representing arguments passed by keyword
  case call(func: Expression, args: [Expression], keywords: [Keyword])
  case namedExpr(target: Expression, value: Expression)
  case ifExpression(test: Expression, body: Expression, orElse: Expression)
  case attribute(Expression, name: String)
  case `subscript`(Expression, slice: Slice)
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

public enum DictionaryElement: Equatable {
  /// `**expr`
  case unpacking(Expression)
  /// `key : value`
  case keyValue(key: Expression, value: Expression)
}

/// For normal strings and f-strings, concatenate them together.
public enum StringGroup: Equatable {
  /// String - no f-strings.
  case string(String)
  /// FormattedValue - just an f-string (with no leading or trailing literals).
  case formattedValue(String, conversion: ConversionFlag?, spec: String?)
  /// JoinedStr - if there are multiple f-strings or any literals involved.
  case joinedString([StringGroup])
}

/// Transforms a value prior to formatting it.
public enum ConversionFlag: Equatable {
  /// Converts by calling `str(<value>)`.
  case str
  /// Converts by calling `ascii(<value>)`.
  case ascii
  /// Converts by calling `repr(<value>)`.
  case repr
}

public struct Slice: Equatable {

  public let kind: SliceKind
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(kind: SliceKind, start: SourceLocation, end: SourceLocation) {
    self.kind = kind
    self.start = start
    self.end = end
  }
}

public enum SliceKind: Equatable {
  /// Regular slicing: `movies[pinocchio:frozen2]`.
  case slice(lower: Expression?, upper: Expression?, step: Expression?)
  /// Advanced slicing: `frozen[kristoff:ana, olaf]`.
  /// `dims` holds a list of `Slice` and `Index` nodes.
  case extSlice(dims: [Slice])
  /// Subscripting with a single value: `frozen[elsa]`.
  case index(Expression)
}

/// One `for` clause in a comprehension.
public struct Comprehension: Equatable {

  /// Reference to use for each element,
  /// typically a `Identifier` or `Tuple` node.
  public let target: Expression
  /// Object to iterate over.
  public let iter: Expression
  /// List of test expressions. We can have multiple `ifs`.
  public let ifs: [Expression]
  /// Indicates that the comprehension is asynchronous.
  public let isAsync: Bool
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(target: Expression, iter: Expression, ifs: [Expression], isAsync: Bool, start: SourceLocation, end: SourceLocation) {
    self.target = target
    self.iter = iter
    self.ifs = ifs
    self.isAsync = isAsync
    self.start = start
    self.end = end
  }
}

/// The arguments for a function passed by value
/// (where the value is always an object reference, not the value of the object).
/// https://docs.python.org/3/tutorial/controlflow.html#more-on-defining-functions"
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

/// A keyword argument to a function call or class definition.
/// `nil` name is used for `**kwargs`.
public struct Keyword: Equatable {

  /// Parameter name.
  public let name: String?
  /// Node to pass in.
  public let value: Expression
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(name: String?, value: Expression, start: SourceLocation, end: SourceLocation) {
    self.name = name
    self.value = value
    self.start = start
    self.end = end
  }
}

