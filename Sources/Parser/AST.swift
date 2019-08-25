// This file was auto-generated by Elsa from 'ast.letitgo'
// using 'code' command.
// DO NOT EDIT!

import Foundation
import Core
import Lexer

// swiftlint:disable superfluous_disable_command
// swiftlint:disable type_body_length
// swiftlint:disable line_length
// swiftlint:disable file_length
// swiftlint:disable trailing_newline
// swiftlint:disable vertical_whitespace_closing_braces

/// Top (root) node in AST.
/// Represents the whole program.
public enum AST: Equatable {
  /// Used for input in interactive mode.
  /// `interactive_input ::= [stmt_list] NEWLINE | compound_stmt NEWLINE`
  case single([Statement])
  /// Used for all input read from non-interactive files.
  /// For example:
  /// - when parsing a complete Python program (from a file or from a string);
  /// - when parsing a module;
  /// - when parsing a string passed to the `exec()` function;
  /// 
  /// `file_input ::=  (NEWLINE | statement)*`
  case fileInput([Statement])
  /// Used for `eval()`.
  /// It ignores leading whitespace.
  /// `eval_input ::= expression_list NEWLINE*`
  case expression(Expression)

  public var isSingle: Bool {
    if case .single = self { return true }
    return false
  }

  public var isFileInput: Bool {
    if case .fileInput = self { return true }
    return false
  }

  public var isExpression: Bool {
    if case .expression = self { return true }
    return false
  }

}

/// https://docs.python.org/3/reference/simple_stmts.html
/// https://docs.python.org/3/reference/compound_stmts.html
public struct Statement: Equatable {

  /// Type of the statement.
  public let kind: StatementKind
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(_ kind: StatementKind, start: SourceLocation, end: SourceLocation) {
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
  /// - `decoratorList` is the list of decorators to be applied,
  ///    stored outermost first (i.e. the first in the list will be applied last).
  /// - `returns` is the return annotation (the thing after '->').
  case functionDef(name: String, args: Arguments, body: NonEmptyArray<Statement>, decoratorList: [Expression], returns: Expression?)
  /// An async def function definition.
  /// Has the same fields as `FunctionDef`.
  case asyncFunctionDef(name: String, args: Arguments, body: NonEmptyArray<Statement>, decoratorList: [Expression], returns: Expression?)
  /// A class definition.
  /// - `name` is a raw string for the class name
  /// - `bases` is a list of nodes for explicitly specified base classes.
  /// - `keywords` is a list of keyword nodes, principally for ‘metaclass’.
  ///    Other keywords will be passed to the metaclass, as per PEP-3115.
  /// - `starargs` and kwargs are each a single node, as in a function call.
  ///    starargs will be expanded to join the list of base classes, and kwargs will be passed to the metaclass.
  /// - `body` is a list of nodes representing the code within the class definition.
  /// - `decoratorList` is a list of nodes, as in `FunctionDef`.
  case classDef(name: String, bases: [Expression], keywords: [Keyword], body: NonEmptyArray<Statement>, decoratorList: [Expression])
  /// A `return` statement.
  case `return`(Expression?)
  /// Represents a `del` statement.
  /// Contains a list of nodes, such as Name, Attribute or Subscript nodes.
  case delete(NonEmptyArray<Expression>)
  /// An assignment.
  /// - `targets` is a list of nodes
  /// - `value` is a single node
  /// 
  /// Multiple nodes in targets represents assigning the same value to each.
  /// Unpacking is represented by putting a Tuple or List within targets.
  case assign(targets: NonEmptyArray<Expression>, value: Expression)
  /// Augmented assignment, such as `a += 1`.
  /// - `target` is a Name node for `a`. Target can be Name, Subscript
  /// or Attribute, but not a Tuple or List (unlike the targets of `Assign`).
  /// - `op` is an operation (for example `Add`)
  /// - `value` is the operand (for example Num node for 1)
  case augAssign(target: Expression, op: BinaryOperator, value: Expression)
  /// An assignment with a type annotation.
  /// - `target` is a single node and can be a Name, a Attribute or a Subscript
  /// - `annotation` is the annotation, such as a Str or Name node
  /// - `value` is a single optional node
  /// - `simple` indicates that `target` does not appear
  /// in between parenthesis and is pure name and not expression.
  case annAssign(target: Expression, annotation: Expression, value: Expression?, isSimple: Bool)
  /// A `for` loop.
  /// - `target` holds the variable(s) the loop assigns to, as a single Name, Tuple or List node.
  /// - `iter` holds the item to be looped over, again as a single node.
  /// - `body` and `orElse` contain lists of nodes to execute. Those in orElse
  /// are executed if the loop finishes normally, rather than via a break statement.
  case `for`(target: Expression, iter: Expression, body: NonEmptyArray<Statement>, orElse: [Statement])
  /// An `async for` definition.
  /// Has the same fields as `For`.
  case asyncFor(target: Expression, iter: Expression, body: NonEmptyArray<Statement>, orElse: [Statement])
  /// A `while` loop.
  /// - `test` holds the condition, such as a Compare node.
  case `while`(test: Expression, body: NonEmptyArray<Statement>, orElse: [Statement])
  /// An if statement.
  /// - `test` holds a single node, such as a Compare node.
  /// - `body` and `orElse` each hold a list of nodes.
  /// - `elif` clauses don’t have a special representation in the AST,
  /// but rather appear as extra `If` nodes within the `orElse` section
  /// of the previous one.
  case `if`(test: Expression, body: NonEmptyArray<Statement>, orElse: [Statement])
  /// A `with` block.
  /// - `items` is a list of withitem nodes representing the context managers.
  /// - `body` is the indented block inside the context.
  case with(items: NonEmptyArray<WithItem>, body: NonEmptyArray<Statement>)
  /// An `async with` definition.
  /// Has the same fields as `With`.
  case asyncWith(items: NonEmptyArray<WithItem>, body: NonEmptyArray<Statement>)
  /// Raising an exception.
  /// - `exc` is the exception object to be raised, normally a Call or Name
  /// or None for a standalone raise.
  /// - `cause` is the optional part for y in raise x from y.
  case raise(exc: Expression?, cause: Expression?)
  /// `try` block.
  /// All attributes are list of nodes to execute, except for handlers,
  /// which is a list of ExceptHandler nodes.
  case `try`(body: NonEmptyArray<Statement>, handlers: [ExceptHandler], orElse: [Statement], finalBody: [Statement])
  /// An assertion.
  /// - `test` holds the condition, such as a Compare node.
  /// - `msg` holds the failure message, normally a Str node.
  case assert(test: Expression, msg: Expression?)
  /// An import statement.
  /// Contains a list of alias nodes.
  case `import`(NonEmptyArray<Alias>)
  /// Represents `from x import y`.
  /// - `moduleName` is a raw string of the ‘from’ name, without any leading dots
  /// or None for statements such as `from . import foo`.
  /// - `level` is an integer holding the level of the relative import
  /// (0 means absolute import).
  case importFrom(moduleName: String?, names: NonEmptyArray<Alias>, level: UInt8)
  /// `global` statement.
  case global(NonEmptyArray<String>)
  /// `nonlocal` statement.
  case nonlocal(NonEmptyArray<String>)
  /// `Expression` statement.
  case expr(Expression)
  /// A `pass` statement.
  case pass
  /// `break` statement.
  case `break`
  /// `continue` statement.
  case `continue`

  public var isFunctionDef: Bool {
    if case .functionDef = self { return true }
    return false
  }

  public var isAsyncFunctionDef: Bool {
    if case .asyncFunctionDef = self { return true }
    return false
  }

  public var isClassDef: Bool {
    if case .classDef = self { return true }
    return false
  }

  public var isReturn: Bool {
    if case .return = self { return true }
    return false
  }

  public var isDelete: Bool {
    if case .delete = self { return true }
    return false
  }

  public var isAssign: Bool {
    if case .assign = self { return true }
    return false
  }

  public var isAugAssign: Bool {
    if case .augAssign = self { return true }
    return false
  }

  public var isAnnAssign: Bool {
    if case .annAssign = self { return true }
    return false
  }

  public var isFor: Bool {
    if case .for = self { return true }
    return false
  }

  public var isAsyncFor: Bool {
    if case .asyncFor = self { return true }
    return false
  }

  public var isWhile: Bool {
    if case .while = self { return true }
    return false
  }

  public var isIf: Bool {
    if case .if = self { return true }
    return false
  }

  public var isWith: Bool {
    if case .with = self { return true }
    return false
  }

  public var isAsyncWith: Bool {
    if case .asyncWith = self { return true }
    return false
  }

  public var isRaise: Bool {
    if case .raise = self { return true }
    return false
  }

  public var isTry: Bool {
    if case .try = self { return true }
    return false
  }

  public var isAssert: Bool {
    if case .assert = self { return true }
    return false
  }

  public var isImport: Bool {
    if case .import = self { return true }
    return false
  }

  public var isImportFrom: Bool {
    if case .importFrom = self { return true }
    return false
  }

  public var isGlobal: Bool {
    if case .global = self { return true }
    return false
  }

  public var isNonlocal: Bool {
    if case .nonlocal = self { return true }
    return false
  }

  public var isExpr: Bool {
    if case .expr = self { return true }
    return false
  }

}

/// Import name with optional 'as' alias.
/// Both parameters are raw strings of the names.
/// `asname` can be None if the regular name is to be used.
public struct Alias: Equatable {

  public let name: String
  public let asName: String?
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(name: String, asName: String?, start: SourceLocation, end: SourceLocation) {
    self.name = name
    self.asName = asName
    self.start = start
    self.end = end
  }
}

/// A single context manager in a `with` block.
public struct WithItem: Equatable {

  /// Context manager (often a Call node).
  public let contextExpr: Expression
  /// Name, Tuple or List for the `as foo` part, or `nil` if that isn’t used.
  public let optionalVars: Expression?
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(contextExpr: Expression, optionalVars: Expression?, start: SourceLocation, end: SourceLocation) {
    self.contextExpr = contextExpr
    self.optionalVars = optionalVars
    self.start = start
    self.end = end
  }
}

/// A single except clause.
public struct ExceptHandler: Equatable {

  /// Exception type it will match, typically a Name node
  /// (or `nil` for a catch-all except: clause).
  public let type: Expression?
  /// Raw string for the name to hold the exception,
  /// or `nil` if the clause doesn’t have as foo.
  public let name: String?
  /// List of handler nodes.
  public let body: NonEmptyArray<Statement>
  /// Location of the first character in the source code.
  public let start: SourceLocation
  /// Location just after the last character in the source code.
  public let end: SourceLocation

  public init(type: Expression?, name: String?, body: NonEmptyArray<Statement>, start: SourceLocation, end: SourceLocation) {
    self.type = type
    self.name = name
    self.body = body
    self.start = start
    self.end = end
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

  public init(_ kind: ExpressionKind, start: SourceLocation, end: SourceLocation) {
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
  case int(BigInt)
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
  case compare(left: Expression, elements: NonEmptyArray<ComparisonElement>)
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
  case listComprehension(elt: Expression, generators: NonEmptyArray<Comprehension>)
  /// Brackets containing an expression followed by a for clause and then
  /// zero or more for or if clauses.
  /// `elt` - expression that will be evaluated for each item
  case setComprehension(elt: Expression, generators: NonEmptyArray<Comprehension>)
  /// Brackets containing an expression followed by a for clause and then
  /// zero or more for or if clauses.
  /// `key` and `value` - expressions that will be evaluated for each item
  case dictionaryComprehension(key: Expression, value: Expression, generators: NonEmptyArray<Comprehension>)
  /// Expression followed by a for clause and then
  /// zero or more for or if clauses.
  /// `elt` - expression that will be evaluated for each item
  case generatorExp(elt: Expression, generators: NonEmptyArray<Comprehension>)
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
  case call(f: Expression, args: [Expression], keywords: [Keyword])
  /// For example: `1 if True else 2`
  case ifExpression(test: Expression, body: Expression, orElse: Expression)
  /// For example `apple.juice = poison`.
  case attribute(Expression, name: String)
  /// For example `apple[juice] = poison`.
  case `subscript`(Expression, slice: Slice)
  /// For example:
  /// `dwarfs = ["Doc", "Grumpy", "Happy", "Sleepy", "Bashful", "Sneezy", "Dopey"]`
  /// `singSong(*dwarfs)`
  case starred(Expression)

  public var isIdentifier: Bool {
    if case .identifier = self { return true }
    return false
  }

  public var isString: Bool {
    if case .string = self { return true }
    return false
  }

  public var isInt: Bool {
    if case .int = self { return true }
    return false
  }

  public var isFloat: Bool {
    if case .float = self { return true }
    return false
  }

  public var isComplex: Bool {
    if case .complex = self { return true }
    return false
  }

  public var isBytes: Bool {
    if case .bytes = self { return true }
    return false
  }

  public var isUnaryOp: Bool {
    if case .unaryOp = self { return true }
    return false
  }

  public var isBinaryOp: Bool {
    if case .binaryOp = self { return true }
    return false
  }

  public var isBoolOp: Bool {
    if case .boolOp = self { return true }
    return false
  }

  public var isCompare: Bool {
    if case .compare = self { return true }
    return false
  }

  public var isTuple: Bool {
    if case .tuple = self { return true }
    return false
  }

  public var isList: Bool {
    if case .list = self { return true }
    return false
  }

  public var isDictionary: Bool {
    if case .dictionary = self { return true }
    return false
  }

  public var isSet: Bool {
    if case .set = self { return true }
    return false
  }

  public var isListComprehension: Bool {
    if case .listComprehension = self { return true }
    return false
  }

  public var isSetComprehension: Bool {
    if case .setComprehension = self { return true }
    return false
  }

  public var isDictionaryComprehension: Bool {
    if case .dictionaryComprehension = self { return true }
    return false
  }

  public var isGeneratorExp: Bool {
    if case .generatorExp = self { return true }
    return false
  }

  public var isAwait: Bool {
    if case .await = self { return true }
    return false
  }

  public var isYield: Bool {
    if case .yield = self { return true }
    return false
  }

  public var isYieldFrom: Bool {
    if case .yieldFrom = self { return true }
    return false
  }

  public var isLambda: Bool {
    if case .lambda = self { return true }
    return false
  }

  public var isCall: Bool {
    if case .call = self { return true }
    return false
  }

  public var isIfExpression: Bool {
    if case .ifExpression = self { return true }
    return false
  }

  public var isAttribute: Bool {
    if case .attribute = self { return true }
    return false
  }

  public var isSubscript: Bool {
    if case .subscript = self { return true }
    return false
  }

  public var isStarred: Bool {
    if case .starred = self { return true }
    return false
  }

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

  public var isUnpacking: Bool {
    if case .unpacking = self { return true }
    return false
  }

  public var isKeyValue: Bool {
    if case .keyValue = self { return true }
    return false
  }

}

/// For normal strings and f-strings, concatenate them together.
public enum StringGroup: Equatable {
  /// String - no f-strings.
  case string(String)
  /// FormattedValue - just an f-string (with no leading or trailing literals).
  case formattedValue(Expression, conversion: ConversionFlag?, spec: String?)
  /// JoinedStr - if there are multiple f-strings or any literals involved.
  case joinedString([StringGroup])

  public var isString: Bool {
    if case .string = self { return true }
    return false
  }

  public var isFormattedValue: Bool {
    if case .formattedValue = self { return true }
    return false
  }

  public var isJoinedString: Bool {
    if case .joinedString = self { return true }
    return false
  }

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

  public init(_ kind: SliceKind, start: SourceLocation, end: SourceLocation) {
    self.kind = kind
    self.start = start
    self.end = end
  }
}

public enum SliceKind: Equatable {
  /// Regular slicing: `movies[pinocchio:frozen2]`.
  case slice(lower: Expression?, upper: Expression?, step: Expression?)
  /// Advanced slicing: `frozen[kristoff:ana, olaf]`.
  /// `value` holds a list of `Slice` and `Index` nodes.
  case extSlice(NonEmptyArray<Slice>)
  /// Subscripting with a single value: `frozen[elsa]`.
  case index(Expression)

  public var isSlice: Bool {
    if case .slice = self { return true }
    return false
  }

  public var isExtSlice: Bool {
    if case .extSlice = self { return true }
    return false
  }

  public var isIndex: Bool {
    if case .index = self { return true }
    return false
  }

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

  public init(_ name: String, annotation: Expression?, start: SourceLocation, end: SourceLocation) {
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

  public var isNamed: Bool {
    if case .named = self { return true }
    return false
  }

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

