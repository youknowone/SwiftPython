// This file was auto-generated by Elsa from 'opcodes.letitgo'
// using 'code-object-test' command.
// DO NOT EDIT!

import Foundation
import Core
import Bytecode

// swiftlint:disable trailing_newline

/// Expected emitted instruction.
struct EmittedInstruction {
  let kind: EmittedInstructionKind
  let arg:  String?

  init(_ kind: EmittedInstructionKind, _ arg:  String? = nil) {
    self.kind = kind
    self.arg  = arg
  }
}

/// Basically `Instruction`, but without associated values.
enum EmittedInstructionKind {
  case nop
  case popTop
  case rotTwo
  case rotThree
  case dupTop
  case dupTopTwo
  case unaryPositive
  case unaryNegative
  case unaryNot
  case unaryInvert
  case binaryPower
  case binaryMultiply
  case binaryMatrixMultiply
  case binaryFloorDivide
  case binaryTrueDivide
  case binaryModulo
  case binaryAdd
  case binarySubtract
  case binaryLShift
  case binaryRShift
  case binaryAnd
  case binaryXor
  case binaryOr
  case inplacePower
  case inplaceMultiply
  case inplaceMatrixMultiply
  case inplaceFloorDivide
  case inplaceTrueDivide
  case inplaceModulo
  case inplaceAdd
  case inplaceSubtract
  case inplaceLShift
  case inplaceRShift
  case inplaceAnd
  case inplaceXor
  case inplaceOr
  case compareOp
  case getAwaitable
  case getAIter
  case getANext
  case yieldValue
  case yieldFrom
  case printExpr
  case setupLoop
  case forIter
  case getIter
  case getYieldFromIter
  case `break`
  case `continue`
  case buildTuple
  case buildList
  case buildSet
  case buildMap
  case buildConstKeyMap
  case setAdd
  case listAppend
  case mapAdd
  case buildTupleUnpack
  case buildTupleUnpackWithCall
  case buildListUnpack
  case buildSetUnpack
  case buildMapUnpack
  case buildMapUnpackWithCall
  case unpackSequence
  case unpackEx
  case loadConst
  case storeName
  case loadName
  case deleteName
  case storeAttribute
  case loadAttribute
  case deleteAttribute
  case binarySubscript
  case storeSubscript
  case deleteSubscript
  case storeGlobal
  case loadGlobal
  case deleteGlobal
  case loadFast
  case storeFast
  case deleteFast
  case loadDeref
  case storeDeref
  case deleteDeref
  case loadClassDeref
  case makeFunction
  case callFunction
  case callFunctionKw
  case callFunctionEx
  case `return`
  case loadBuildClass
  case loadMethod
  case callMethod
  case importStar
  case importName
  case importFrom
  case popExcept
  case endFinally
  case setupExcept
  case setupFinally
  case raiseVarargs
  case setupWith
  case withCleanupStart
  case withCleanupFinish
  case beforeAsyncWith
  case setupAsyncWith
  case jumpAbsolute
  case popJumpIfTrue
  case popJumpIfFalse
  case jumpIfTrueOrPop
  case jumpIfFalseOrPop
  case formatValue
  case buildString
  case extendedArg
  case setupAnnotations
  case popBlock
  case loadClosure
  case buildSlice
}
