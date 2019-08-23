// This file was auto-generated by Elsa from 'ast.letitgo'
// using 'ast-destruct' command.
// DO NOT EDIT!

import XCTest
import Core
import Lexer
import Parser

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable large_tuple
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable trailing_newline

// MARK: - AST

protocol DestructAST { }

extension DestructAST {

  internal func destructSingle(_ ast: AST,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
  ([Statement])? {

    if case let AST.single(value0) = ast {
      return (value0)
    }

    XCTAssertTrue(false, String(describing: ast), file: file, line: line)
    return nil
  }

  internal func destructFileInput(_ ast: AST,
                                  file: StaticString = #file,
                                  line: UInt         = #line) ->
  ([Statement])? {

    if case let AST.fileInput(value0) = ast {
      return (value0)
    }

    XCTAssertTrue(false, String(describing: ast), file: file, line: line)
    return nil
  }

  internal func destructExpression(_ ast: AST,
                                   file: StaticString = #file,
                                   line: UInt         = #line) ->
  (Expression)? {

    if case let AST.expression(value0) = ast {
      return (value0)
    }

    XCTAssertTrue(false, String(describing: ast), file: file, line: line)
    return nil
  }

}

// MARK: - StatementKind

protocol DestructStatementKind { }

extension DestructStatementKind {

  internal func destructFunctionDef(_ stmt: Statement,
                                    file: StaticString = #file,
                                    line: UInt         = #line) ->
  (name: String, args: Arguments, body: [Statement], decoratorList: [Expression], returns: Expression?)? {

    if case let StatementKind.functionDef(name: value0, args: value1, body: value2, decoratorList: value3, returns: value4) = stmt.kind {
      return (value0, value1, Array(value2), value3, value4)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructAsyncFunctionDef(_ stmt: Statement,
                                         file: StaticString = #file,
                                         line: UInt         = #line) ->
  (name: String, args: Arguments, body: [Statement], decoratorList: [Expression], returns: Expression?)? {

    if case let StatementKind.asyncFunctionDef(name: value0, args: value1, body: value2, decoratorList: value3, returns: value4) = stmt.kind {
      return (value0, value1, Array(value2), value3, value4)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructClassDef(_ stmt: Statement,
                                 file: StaticString = #file,
                                 line: UInt         = #line) ->
  (name: String, bases: [Expression], keywords: [Keyword], body: [Statement], decoratorList: [Expression])? {

    if case let StatementKind.classDef(name: value0, bases: value1, keywords: value2, body: value3, decoratorList: value4) = stmt.kind {
      return (value0, value1, value2, Array(value3), value4)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructReturn(_ stmt: Statement,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
  (Expression?)? {

    if case let StatementKind.return(value0) = stmt.kind {
      return (value0)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructDelete(_ stmt: Statement,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
  ([Expression])? {

    if case let StatementKind.delete(value0) = stmt.kind {
      return (Array(value0))
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructAssign(_ stmt: Statement,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
  (targets: [Expression], value: Expression)? {

    if case let StatementKind.assign(targets: value0, value: value1) = stmt.kind {
      return (Array(value0), value1)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructAugAssign(_ stmt: Statement,
                                  file: StaticString = #file,
                                  line: UInt         = #line) ->
  (target: Expression, op: BinaryOperator, value: Expression)? {

    if case let StatementKind.augAssign(target: value0, op: value1, value: value2) = stmt.kind {
      return (value0, value1, value2)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructAnnAssign(_ stmt: Statement,
                                  file: StaticString = #file,
                                  line: UInt         = #line) ->
  (target: Expression, annotation: Expression, value: Expression?, isSimple: Bool)? {

    if case let StatementKind.annAssign(target: value0, annotation: value1, value: value2, isSimple: value3) = stmt.kind {
      return (value0, value1, value2, value3)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructFor(_ stmt: Statement,
                            file: StaticString = #file,
                            line: UInt         = #line) ->
  (target: Expression, iter: Expression, body: [Statement], orElse: [Statement])? {

    if case let StatementKind.for(target: value0, iter: value1, body: value2, orElse: value3) = stmt.kind {
      return (value0, value1, Array(value2), value3)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructAsyncFor(_ stmt: Statement,
                                 file: StaticString = #file,
                                 line: UInt         = #line) ->
  (target: Expression, iter: Expression, body: [Statement], orElse: [Statement])? {

    if case let StatementKind.asyncFor(target: value0, iter: value1, body: value2, orElse: value3) = stmt.kind {
      return (value0, value1, Array(value2), value3)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructWhile(_ stmt: Statement,
                              file: StaticString = #file,
                              line: UInt         = #line) ->
  (test: Expression, body: [Statement], orElse: [Statement])? {

    if case let StatementKind.while(test: value0, body: value1, orElse: value2) = stmt.kind {
      return (value0, Array(value1), value2)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructIf(_ stmt: Statement,
                           file: StaticString = #file,
                           line: UInt         = #line) ->
  (test: Expression, body: [Statement], orElse: [Statement])? {

    if case let StatementKind.if(test: value0, body: value1, orElse: value2) = stmt.kind {
      return (value0, Array(value1), value2)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructWith(_ stmt: Statement,
                             file: StaticString = #file,
                             line: UInt         = #line) ->
  (items: [WithItem], body: [Statement])? {

    if case let StatementKind.with(items: value0, body: value1) = stmt.kind {
      return (Array(value0), Array(value1))
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructAsyncWith(_ stmt: Statement,
                                  file: StaticString = #file,
                                  line: UInt         = #line) ->
  (items: [WithItem], body: [Statement])? {

    if case let StatementKind.asyncWith(items: value0, body: value1) = stmt.kind {
      return (Array(value0), Array(value1))
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructRaise(_ stmt: Statement,
                              file: StaticString = #file,
                              line: UInt         = #line) ->
  (exc: Expression?, cause: Expression?)? {

    if case let StatementKind.raise(exc: value0, cause: value1) = stmt.kind {
      return (value0, value1)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructTry(_ stmt: Statement,
                            file: StaticString = #file,
                            line: UInt         = #line) ->
  (body: [Statement], handlers: [ExceptHandler], orElse: [Statement], finalBody: [Statement])? {

    if case let StatementKind.try(body: value0, handlers: value1, orElse: value2, finalBody: value3) = stmt.kind {
      return (Array(value0), value1, value2, value3)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructAssert(_ stmt: Statement,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
  (test: Expression, msg: Expression?)? {

    if case let StatementKind.assert(test: value0, msg: value1) = stmt.kind {
      return (value0, value1)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructImport(_ stmt: Statement,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
  ([Alias])? {

    if case let StatementKind.import(value0) = stmt.kind {
      return (Array(value0))
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructImportFrom(_ stmt: Statement,
                                   file: StaticString = #file,
                                   line: UInt         = #line) ->
  (moduleName: String?, names: [Alias], level: UInt8)? {

    if case let StatementKind.importFrom(moduleName: value0, names: value1, level: value2) = stmt.kind {
      return (value0, Array(value1), value2)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructGlobal(_ stmt: Statement,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
  ([String])? {

    if case let StatementKind.global(value0) = stmt.kind {
      return (Array(value0))
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructNonlocal(_ stmt: Statement,
                                 file: StaticString = #file,
                                 line: UInt         = #line) ->
  ([String])? {

    if case let StatementKind.nonlocal(value0) = stmt.kind {
      return (Array(value0))
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

  internal func destructExpr(_ stmt: Statement,
                             file: StaticString = #file,
                             line: UInt         = #line) ->
  (Expression)? {

    if case let StatementKind.expr(value0) = stmt.kind {
      return (value0)
    }

    XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
    return nil
  }

}

// MARK: - ExpressionKind

protocol DestructExpressionKind { }

extension DestructExpressionKind {

  internal func destructIdentifier(_ expr: Expression,
                                   file: StaticString = #file,
                                   line: UInt         = #line) ->
    (String)? {

    if case let ExpressionKind.identifier(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructString(_ expr: Expression,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
    (StringGroup)? {

    if case let ExpressionKind.string(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructInt(_ expr: Expression,
                            file: StaticString = #file,
                            line: UInt         = #line) ->
    (BigInt)? {

    if case let ExpressionKind.int(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructFloat(_ expr: Expression,
                              file: StaticString = #file,
                              line: UInt         = #line) ->
    (Double)? {

    if case let ExpressionKind.float(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructComplex(_ expr: Expression,
                                file: StaticString = #file,
                                line: UInt         = #line) ->
    (real: Double, imag: Double)? {

    if case let ExpressionKind.complex(real: value0, imag: value1) = expr.kind {
      return (value0, value1)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructBytes(_ expr: Expression,
                              file: StaticString = #file,
                              line: UInt         = #line) ->
    (Data)? {

    if case let ExpressionKind.bytes(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructUnaryOp(_ expr: Expression,
                                file: StaticString = #file,
                                line: UInt         = #line) ->
    (UnaryOperator, right: Expression)? {

    if case let ExpressionKind.unaryOp(value0, right: value1) = expr.kind {
      return (value0, value1)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructBinaryOp(_ expr: Expression,
                                 file: StaticString = #file,
                                 line: UInt         = #line) ->
    (BinaryOperator, left: Expression, right: Expression)? {

    if case let ExpressionKind.binaryOp(value0, left: value1, right: value2) = expr.kind {
      return (value0, value1, value2)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructBoolOp(_ expr: Expression,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
    (BooleanOperator, left: Expression, right: Expression)? {

    if case let ExpressionKind.boolOp(value0, left: value1, right: value2) = expr.kind {
      return (value0, value1, value2)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructCompare(_ expr: Expression,
                                file: StaticString = #file,
                                line: UInt         = #line) ->
    (left: Expression, elements: [ComparisonElement])? {

    if case let ExpressionKind.compare(left: value0, elements: value1) = expr.kind {
      return (value0, Array(value1))
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructTuple(_ expr: Expression,
                              file: StaticString = #file,
                              line: UInt         = #line) ->
    ([Expression])? {

    if case let ExpressionKind.tuple(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructList(_ expr: Expression,
                             file: StaticString = #file,
                             line: UInt         = #line) ->
    ([Expression])? {

    if case let ExpressionKind.list(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructDictionary(_ expr: Expression,
                                   file: StaticString = #file,
                                   line: UInt         = #line) ->
    ([DictionaryElement])? {

    if case let ExpressionKind.dictionary(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructSet(_ expr: Expression,
                            file: StaticString = #file,
                            line: UInt         = #line) ->
    ([Expression])? {

    if case let ExpressionKind.set(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructListComprehension(_ expr: Expression,
                                          file: StaticString = #file,
                                          line: UInt         = #line) ->
    (elt: Expression, generators: [Comprehension])? {

    if case let ExpressionKind.listComprehension(elt: value0, generators: value1) = expr.kind {
      return (value0, Array(value1))
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructSetComprehension(_ expr: Expression,
                                         file: StaticString = #file,
                                         line: UInt         = #line) ->
    (elt: Expression, generators: [Comprehension])? {

    if case let ExpressionKind.setComprehension(elt: value0, generators: value1) = expr.kind {
      return (value0, Array(value1))
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructDictionaryComprehension(_ expr: Expression,
                                                file: StaticString = #file,
                                                line: UInt         = #line) ->
    (key: Expression, value: Expression, generators: [Comprehension])? {

    if case let ExpressionKind.dictionaryComprehension(key: value0, value: value1, generators: value2) = expr.kind {
      return (value0, value1, Array(value2))
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructGeneratorExp(_ expr: Expression,
                                     file: StaticString = #file,
                                     line: UInt         = #line) ->
    (elt: Expression, generators: [Comprehension])? {

    if case let ExpressionKind.generatorExp(elt: value0, generators: value1) = expr.kind {
      return (value0, Array(value1))
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructAwait(_ expr: Expression,
                              file: StaticString = #file,
                              line: UInt         = #line) ->
    (Expression)? {

    if case let ExpressionKind.await(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructYield(_ expr: Expression,
                              file: StaticString = #file,
                              line: UInt         = #line) ->
    (Expression?)? {

    if case let ExpressionKind.yield(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructYieldFrom(_ expr: Expression,
                                  file: StaticString = #file,
                                  line: UInt         = #line) ->
    (Expression)? {

    if case let ExpressionKind.yieldFrom(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructLambda(_ expr: Expression,
                               file: StaticString = #file,
                               line: UInt         = #line) ->
    (args: Arguments, body: Expression)? {

    if case let ExpressionKind.lambda(args: value0, body: value1) = expr.kind {
      return (value0, value1)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructCall(_ expr: Expression,
                             file: StaticString = #file,
                             line: UInt         = #line) ->
    (func: Expression, args: [Expression], keywords: [Keyword])? {

    if case let ExpressionKind.call(func: value0, args: value1, keywords: value2) = expr.kind {
      return (value0, value1, value2)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructIfExpression(_ expr: Expression,
                                     file: StaticString = #file,
                                     line: UInt         = #line) ->
    (test: Expression, body: Expression, orElse: Expression)? {

    if case let ExpressionKind.ifExpression(test: value0, body: value1, orElse: value2) = expr.kind {
      return (value0, value1, value2)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructAttribute(_ expr: Expression,
                                  file: StaticString = #file,
                                  line: UInt         = #line) ->
    (Expression, name: String)? {

    if case let ExpressionKind.attribute(value0, name: value1) = expr.kind {
      return (value0, value1)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructSubscript(_ expr: Expression,
                                  file: StaticString = #file,
                                  line: UInt         = #line) ->
    (Expression, slice: Slice)? {

    if case let ExpressionKind.subscript(value0, slice: value1) = expr.kind {
      return (value0, value1)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

  internal func destructStarred(_ expr: Expression,
                                file: StaticString = #file,
                                line: UInt         = #line) ->
    (Expression)? {

    if case let ExpressionKind.starred(value0) = expr.kind {
      return (value0)
    }

    XCTAssertTrue(false, expr.kind.description, file: file, line: line)
    return nil
  }

}

// MARK: - StringGroup

protocol DestructStringGroup { }

extension DestructStringGroup {

  internal func destructStringSimple(_ group: StringGroup,
                                     file: StaticString = #file,
                                     line: UInt         = #line) ->
    (String)? {

    switch group {
    case let .string(value0):
      return (value0)
    default:
      XCTAssertTrue(false, String(describing: group), file: file, line: line)
      return nil
    }
  }

  internal func destructStringFormattedValue(_ group: StringGroup,
                                             file: StaticString = #file,
                                             line: UInt         = #line) ->
    (Expression, conversion: ConversionFlag?, spec: String?)? {

    switch group {
    case let .formattedValue(value0, conversion: value1, spec: value2):
      return (value0, value1, value2)
    default:
      XCTAssertTrue(false, String(describing: group), file: file, line: line)
      return nil
    }
  }

  internal func destructStringJoinedString(_ group: StringGroup,
                                           file: StaticString = #file,
                                           line: UInt         = #line) ->
    ([StringGroup])? {

    switch group {
    case let .joinedString(value0):
      return (value0)
    default:
      XCTAssertTrue(false, String(describing: group), file: file, line: line)
      return nil
    }
  }

}

// MARK: - SliceKind

protocol DestructSliceKind { }

extension DestructSliceKind {

  internal func destructSubscriptSlice(_ expr: Expression,
                                       file: StaticString = #file,
                                       line: UInt         = #line) ->
    (slice: Slice, lower: Expression?, upper: Expression?, step: Expression?)? {

    guard case let ExpressionKind.subscript(_, slice: slice) = expr.kind else {
      XCTAssertTrue(false, expr.kind.description, file: file, line: line)
      return nil
    }

    switch slice.kind {
    case let .slice(lower: value0, upper: value1, step: value2):
      return (slice, value0, value1, value2)
    default:
      XCTAssertTrue(false, slice.kind.description, file: file, line: line)
      return nil
    }
  }

  internal func destructSubscriptExtSlice(_ expr: Expression,
                                          file: StaticString = #file,
                                          line: UInt         = #line) ->
    (slice: Slice, [Slice])? {

    guard case let ExpressionKind.subscript(_, slice: slice) = expr.kind else {
      XCTAssertTrue(false, expr.kind.description, file: file, line: line)
      return nil
    }

    switch slice.kind {
    case let .extSlice(value0):
      return (slice, Array(value0))
    default:
      XCTAssertTrue(false, slice.kind.description, file: file, line: line)
      return nil
    }
  }

  internal func destructSubscriptIndex(_ expr: Expression,
                                       file: StaticString = #file,
                                       line: UInt         = #line) ->
    (slice: Slice, Expression)? {

    guard case let ExpressionKind.subscript(_, slice: slice) = expr.kind else {
      XCTAssertTrue(false, expr.kind.description, file: file, line: line)
      return nil
    }

    switch slice.kind {
    case let .index(value0):
      return (slice, value0)
    default:
      XCTAssertTrue(false, slice.kind.description, file: file, line: line)
      return nil
    }
  }

}

