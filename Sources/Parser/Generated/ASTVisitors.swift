// This file was auto-generated by Elsa from 'ast.letitgo.'
// DO NOT EDIT!

import Core
import Foundation

// swiftlint:disable line_length
// swiftlint:disable trailing_newline

// MARK: - AST

/// Visitor for AST nodes.
public protocol ASTVisitor {
  /// Visit result.
  associatedtype ASTResult

  func visit(_ node: InteractiveAST) throws -> ASTResult
  func visit(_ node: ModuleAST) throws -> ASTResult
  func visit(_ node: ExpressionAST) throws -> ASTResult
}

/// Visitor for AST nodes.
///
/// Each function has additional `payload` argument to pass data between
/// nodes (so that we don't have to use fileds/globals which is always awkard).
public protocol ASTVisitorWithPayload: AnyObject {
  /// Visit result.
  associatedtype ASTResult
  /// Additional value passed to all of the calls.
  associatedtype ASTPayload

  func visit(_ node: InteractiveAST, payload: ASTPayload) throws -> ASTResult
  func visit(_ node: ModuleAST, payload: ASTPayload) throws -> ASTResult
  func visit(_ node: ExpressionAST, payload: ASTPayload) throws -> ASTResult
}

// MARK: - Statement

/// Visitor for AST nodes.
public protocol StatementVisitor {
  /// Visit result.
  associatedtype StatementResult

  func visit(_ node: FunctionDefStmt) throws -> StatementResult
  func visit(_ node: AsyncFunctionDefStmt) throws -> StatementResult
  func visit(_ node: ClassDefStmt) throws -> StatementResult
  func visit(_ node: ReturnStmt) throws -> StatementResult
  func visit(_ node: DeleteStmt) throws -> StatementResult
  func visit(_ node: AssignStmt) throws -> StatementResult
  func visit(_ node: AugAssignStmt) throws -> StatementResult
  func visit(_ node: AnnAssignStmt) throws -> StatementResult
  func visit(_ node: ForStmt) throws -> StatementResult
  func visit(_ node: AsyncForStmt) throws -> StatementResult
  func visit(_ node: WhileStmt) throws -> StatementResult
  func visit(_ node: IfStmt) throws -> StatementResult
  func visit(_ node: WithStmt) throws -> StatementResult
  func visit(_ node: AsyncWithStmt) throws -> StatementResult
  func visit(_ node: RaiseStmt) throws -> StatementResult
  func visit(_ node: TryStmt) throws -> StatementResult
  func visit(_ node: AssertStmt) throws -> StatementResult
  func visit(_ node: ImportStmt) throws -> StatementResult
  func visit(_ node: ImportFromStmt) throws -> StatementResult
  func visit(_ node: ImportFromStarStmt) throws -> StatementResult
  func visit(_ node: GlobalStmt) throws -> StatementResult
  func visit(_ node: NonlocalStmt) throws -> StatementResult
  func visit(_ node: ExprStmt) throws -> StatementResult
  func visit(_ node: PassStmt) throws -> StatementResult
  func visit(_ node: BreakStmt) throws -> StatementResult
  func visit(_ node: ContinueStmt) throws -> StatementResult
}

/// Visitor for AST nodes.
///
/// Each function has additional `payload` argument to pass data between
/// nodes (so that we don't have to use fileds/globals which is always awkard).
public protocol StatementVisitorWithPayload: AnyObject {
  /// Visit result.
  associatedtype StatementResult
  /// Additional value passed to all of the calls.
  associatedtype StatementPayload

  func visit(_ node: FunctionDefStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: AsyncFunctionDefStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: ClassDefStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: ReturnStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: DeleteStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: AssignStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: AugAssignStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: AnnAssignStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: ForStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: AsyncForStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: WhileStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: IfStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: WithStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: AsyncWithStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: RaiseStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: TryStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: AssertStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: ImportStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: ImportFromStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: ImportFromStarStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: GlobalStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: NonlocalStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: ExprStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: PassStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: BreakStmt, payload: StatementPayload) throws -> StatementResult
  func visit(_ node: ContinueStmt, payload: StatementPayload) throws -> StatementResult
}

// MARK: - Expression

/// Visitor for AST nodes.
public protocol ExpressionVisitor {
  /// Visit result.
  associatedtype ExpressionResult

  func visit(_ node: TrueExpr) throws -> ExpressionResult
  func visit(_ node: FalseExpr) throws -> ExpressionResult
  func visit(_ node: NoneExpr) throws -> ExpressionResult
  func visit(_ node: EllipsisExpr) throws -> ExpressionResult
  func visit(_ node: IdentifierExpr) throws -> ExpressionResult
  func visit(_ node: StringExpr) throws -> ExpressionResult
  func visit(_ node: IntExpr) throws -> ExpressionResult
  func visit(_ node: FloatExpr) throws -> ExpressionResult
  func visit(_ node: ComplexExpr) throws -> ExpressionResult
  func visit(_ node: BytesExpr) throws -> ExpressionResult
  func visit(_ node: UnaryOpExpr) throws -> ExpressionResult
  func visit(_ node: BinaryOpExpr) throws -> ExpressionResult
  func visit(_ node: BoolOpExpr) throws -> ExpressionResult
  func visit(_ node: CompareExpr) throws -> ExpressionResult
  func visit(_ node: TupleExpr) throws -> ExpressionResult
  func visit(_ node: ListExpr) throws -> ExpressionResult
  func visit(_ node: DictionaryExpr) throws -> ExpressionResult
  func visit(_ node: SetExpr) throws -> ExpressionResult
  func visit(_ node: ListComprehensionExpr) throws -> ExpressionResult
  func visit(_ node: SetComprehensionExpr) throws -> ExpressionResult
  func visit(_ node: DictionaryComprehensionExpr) throws -> ExpressionResult
  func visit(_ node: GeneratorExpr) throws -> ExpressionResult
  func visit(_ node: AwaitExpr) throws -> ExpressionResult
  func visit(_ node: YieldExpr) throws -> ExpressionResult
  func visit(_ node: YieldFromExpr) throws -> ExpressionResult
  func visit(_ node: LambdaExpr) throws -> ExpressionResult
  func visit(_ node: CallExpr) throws -> ExpressionResult
  func visit(_ node: IfExpr) throws -> ExpressionResult
  func visit(_ node: AttributeExpr) throws -> ExpressionResult
  func visit(_ node: SubscriptExpr) throws -> ExpressionResult
  func visit(_ node: StarredExpr) throws -> ExpressionResult
}

/// Visitor for AST nodes.
///
/// Each function has additional `payload` argument to pass data between
/// nodes (so that we don't have to use fileds/globals which is always awkard).
public protocol ExpressionVisitorWithPayload: AnyObject {
  /// Visit result.
  associatedtype ExpressionResult
  /// Additional value passed to all of the calls.
  associatedtype ExpressionPayload

  func visit(_ node: TrueExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: FalseExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: NoneExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: EllipsisExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: IdentifierExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: StringExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: IntExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: FloatExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: ComplexExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: BytesExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: UnaryOpExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: BinaryOpExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: BoolOpExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: CompareExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: TupleExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: ListExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: DictionaryExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: SetExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: ListComprehensionExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: SetComprehensionExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: DictionaryComprehensionExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: GeneratorExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: AwaitExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: YieldExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: YieldFromExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: LambdaExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: CallExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: IfExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: AttributeExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: SubscriptExpr, payload: ExpressionPayload) throws -> ExpressionResult
  func visit(_ node: StarredExpr, payload: ExpressionPayload) throws -> ExpressionResult
}
