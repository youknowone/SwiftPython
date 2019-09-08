import Core
import Bytecode
import Parser

// In CPython:
// Include -> symtable.h

public enum ScopeType: Equatable {
  case module
  case `class`
  case function
}

public struct SymbolInfo: Equatable {

  /// Symbol information.
  public let flags: SymbolFlags

  /// Location of the first occurence of given symbol.
  public let location: SourceLocation
}

/// Captures all symbols in the current scope
/// and has a list of subscopes (childrens).
public final class SymbolScope {

  /// Non-unique name of this scope.
  ///
  /// It will be:
  /// - module -> module
  /// - class -> class name
  /// - function -> function name
  /// - lambda -> lambda
  /// - generator -> genexpr
  /// - list comprehension -> listcomp
  /// - set comprehension -> setcomp
  /// - dictionary comprehension -> dictcomp
  public let name: String

  /// Type of the symbol table.
  /// Possible values are: module, class and function.
  public let type: ScopeType

  /// A set of symbols present on this scope level
  public internal(set) var symbols = [MangledName: SymbolInfo]()

  /// A list of subscopes in the order as found in the AST
  public internal(set) var children = [SymbolScope]()

  /// List of function parameters
  public internal(set) var varNames = [MangledName]()

  /// Block is a nested class or function.
  public let isNested: Bool
  /// Namespace is a generator (yield)
  public internal(set) var isGenerator = false
  /// Namespace is a coroutine (async/await)
  public internal(set) var isCoroutine = false
  /// Block has varargs (the ones with '*')
  public internal(set) var hasVarargs = false
  /// Block has varKeywords (the ones with '**')
  public internal(set) var hasVarKeywords = false
  /// Namespace uses return with an argument
  public internal(set) var hasReturnValue = false
  /// For class scopes: true if a closure over `__class__` should be created
  public internal(set) var needsClassClosure = false

  // CPython also contains:
  // - ste_directives - locations of global and nonlocal statements
  //                    we don't need it because we store location of each variable
  // - ste_free       - true if block has free variables - not used
  // - ste_child_free - true if a child block has free vars,
  //                    including free refs to globals - not used

  // `internal` so, that we can't instantiate it outside of this module.
  internal init(name: String, type: ScopeType, isNested: Bool) {
    self.name = name
    self.type = type
    self.isNested = isNested
  }
}