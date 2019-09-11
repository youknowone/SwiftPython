// This file was auto-generated by Elsa from 'opcodes.letitgo'
// using 'code-object-descr' command.
// DO NOT EDIT!

import Foundation
import Core

// swiftlint:disable file_length
// swiftlint:disable trailing_newline

extension VarNum: CustomStringConvertible {
  public var description: String {
    switch self {
    case .notImplemented:
      return "notImplemented"
    }
  }
}

extension Item: CustomStringConvertible {
  public var description: String {
    switch self {
    case .notImplemented:
      return "notImplemented"
    }
  }
}

extension Delta: CustomStringConvertible {
  public var description: String {
    switch self {
    case .notImplemented:
      return "notImplemented"
    }
  }
}

extension Target: CustomStringConvertible {
  public var description: String {
    switch self {
    case .notImplemented:
      return "notImplemented"
    }
  }
}

extension Constant: CustomStringConvertible {
  public var description: String {
    switch self {
    case .`true`:
      return "true"
    case .`false`:
      return "false"
    case .none:
      return "none"
    case .ellipsis:
      return "ellipsis"
    case let .integer(value0):
      return "integer(\(value0))"
    case let .float(value0):
      return "float(\(value0))"
    case let .complex(real: value0, imag: value1):
      return "complex(real: \(value0), imag: \(value1))"
    case let .string(value0):
      return "string(\(value0))"
    case let .bytes(value0):
      return "bytes(\(value0))"
    case let .code(value0):
      return "code(\(value0))"
    case let .tuple(value0):
      return "tuple(\(value0))"
    }
  }
}

extension StringConversion: CustomStringConvertible {
  public var description: String {
    switch self {
    case .none:
      return "none"
    case .str:
      return "str"
    case .repr:
      return "repr"
    case .ascii:
      return "ascii"
    }
  }
}

extension ComparisonOpcode: CustomStringConvertible {
  public var description: String {
    switch self {
    case .equal:
      return "equal"
    case .notEqual:
      return "notEqual"
    case .less:
      return "less"
    case .lessEqual:
      return "lessEqual"
    case .greater:
      return "greater"
    case .greaterEqual:
      return "greaterEqual"
    case .`is`:
      return "is"
    case .isNot:
      return "isNot"
    case .`in`:
      return "in"
    case .notIn:
      return "notIn"
    case .exceptionMatch:
      return "exceptionMatch"
    }
  }
}

extension SliceArg: CustomStringConvertible {
  public var description: String {
    switch self {
    case .lowerUpper:
      return "lowerUpper"
    case .lowerUpperStep:
      return "lowerUpperStep"
    }
  }
}

extension RaiseArg: CustomStringConvertible {
  public var description: String {
    switch self {
    case .reRaise:
      return "reRaise"
    case .exceptionOnly:
      return "exceptionOnly"
    case .exceptionAndCause:
      return "exceptionAndCause"
    }
  }
}

extension Instruction: CustomStringConvertible {
  public var description: String {
    switch self {
    case .nop:
      return "nop"
    case .popTop:
      return "popTop"
    case .rotTwo:
      return "rotTwo"
    case .rotThree:
      return "rotThree"
    case .dupTop:
      return "dupTop"
    case .dupTopTwo:
      return "dupTopTwo"
    case .unaryPositive:
      return "unaryPositive"
    case .unaryNegative:
      return "unaryNegative"
    case .unaryNot:
      return "unaryNot"
    case .unaryInvert:
      return "unaryInvert"
    case .binaryPower:
      return "binaryPower"
    case .binaryMultiply:
      return "binaryMultiply"
    case .binaryMatrixMultiply:
      return "binaryMatrixMultiply"
    case .binaryFloorDivide:
      return "binaryFloorDivide"
    case .binaryTrueDivide:
      return "binaryTrueDivide"
    case .binaryModulo:
      return "binaryModulo"
    case .binaryAdd:
      return "binaryAdd"
    case .binarySubtract:
      return "binarySubtract"
    case .binaryLShift:
      return "binaryLShift"
    case .binaryRShift:
      return "binaryRShift"
    case .binaryAnd:
      return "binaryAnd"
    case .binaryXor:
      return "binaryXor"
    case .binaryOr:
      return "binaryOr"
    case .inplacePower:
      return "inplacePower"
    case .inplaceMultiply:
      return "inplaceMultiply"
    case .inplaceMatrixMultiply:
      return "inplaceMatrixMultiply"
    case .inplaceFloorDivide:
      return "inplaceFloorDivide"
    case .inplaceTrueDivide:
      return "inplaceTrueDivide"
    case .inplaceModulo:
      return "inplaceModulo"
    case .inplaceAdd:
      return "inplaceAdd"
    case .inplaceSubtract:
      return "inplaceSubtract"
    case .inplaceLShift:
      return "inplaceLShift"
    case .inplaceRShift:
      return "inplaceRShift"
    case .inplaceAnd:
      return "inplaceAnd"
    case .inplaceXor:
      return "inplaceXor"
    case .inplaceOr:
      return "inplaceOr"
    case let .compareOp(value0):
      return "compareOp(\(value0))"
    case .getAwaitable:
      return "getAwaitable"
    case .getAIter:
      return "getAIter"
    case .getANext:
      return "getANext"
    case .yieldValue:
      return "yieldValue"
    case .yieldFrom:
      return "yieldFrom"
    case .printExpr:
      return "printExpr"
    case let .setupLoop(loopEndLabel: value0):
      return "setupLoop(loopEndLabel: \(hex(value0)))"
    case let .forIter(ifEmptyLabel: value0):
      return "forIter(ifEmptyLabel: \(hex(value0)))"
    case .getIter:
      return "getIter"
    case .getYieldFromIter:
      return "getYieldFromIter"
    case .`break`:
      return "break"
    case let .buildTuple(elementCount: value0):
      return "buildTuple(elementCount: \(hex(value0)))"
    case let .buildList(elementCount: value0):
      return "buildList(elementCount: \(hex(value0)))"
    case let .buildSet(elementCount: value0):
      return "buildSet(elementCount: \(hex(value0)))"
    case let .buildMap(elementCount: value0):
      return "buildMap(elementCount: \(hex(value0)))"
    case let .buildConstKeyMap(elementCount: value0):
      return "buildConstKeyMap(elementCount: \(hex(value0)))"
    case let .setAdd(value0):
      return "setAdd(\(value0))"
    case let .listAppend(value0):
      return "listAppend(\(value0))"
    case let .mapAdd(value0):
      return "mapAdd(\(value0))"
    case let .buildTupleUnpack(elementCount: value0):
      return "buildTupleUnpack(elementCount: \(hex(value0)))"
    case let .buildTupleUnpackWithCall(elementCount: value0):
      return "buildTupleUnpackWithCall(elementCount: \(hex(value0)))"
    case let .buildListUnpack(elementCount: value0):
      return "buildListUnpack(elementCount: \(hex(value0)))"
    case let .buildSetUnpack(elementCount: value0):
      return "buildSetUnpack(elementCount: \(hex(value0)))"
    case let .buildMapUnpack(elementCount: value0):
      return "buildMapUnpack(elementCount: \(hex(value0)))"
    case let .buildMapUnpackWithCall(elementCount: value0):
      return "buildMapUnpackWithCall(elementCount: \(hex(value0)))"
    case let .unpackSequence(elementCount: value0):
      return "unpackSequence(elementCount: \(hex(value0)))"
    case let .unpackEx(elementCountBefore: value0):
      return "unpackEx(elementCountBefore: \(hex(value0)))"
    case let .loadConst(index: value0):
      return "loadConst(index: \(hex(value0)))"
    case let .storeName(nameIndex: value0):
      return "storeName(nameIndex: \(hex(value0)))"
    case let .loadName(nameIndex: value0):
      return "loadName(nameIndex: \(hex(value0)))"
    case let .deleteName(nameIndex: value0):
      return "deleteName(nameIndex: \(hex(value0)))"
    case let .storeAttribute(nameIndex: value0):
      return "storeAttribute(nameIndex: \(hex(value0)))"
    case let .loadAttribute(nameIndex: value0):
      return "loadAttribute(nameIndex: \(hex(value0)))"
    case let .deleteAttribute(nameIndex: value0):
      return "deleteAttribute(nameIndex: \(hex(value0)))"
    case .binarySubscript:
      return "binarySubscript"
    case .storeSubscript:
      return "storeSubscript"
    case .deleteSubscript:
      return "deleteSubscript"
    case let .storeGlobal(nameIndex: value0):
      return "storeGlobal(nameIndex: \(hex(value0)))"
    case let .loadGlobal(nameIndex: value0):
      return "loadGlobal(nameIndex: \(hex(value0)))"
    case let .deleteGlobal(nameIndex: value0):
      return "deleteGlobal(nameIndex: \(hex(value0)))"
    case let .loadFast(nameIndex: value0):
      return "loadFast(nameIndex: \(hex(value0)))"
    case let .storeFast(nameIndex: value0):
      return "storeFast(nameIndex: \(hex(value0)))"
    case let .deleteFast(nameIndex: value0):
      return "deleteFast(nameIndex: \(hex(value0)))"
    case let .loadDeref(nameIndex: value0):
      return "loadDeref(nameIndex: \(hex(value0)))"
    case let .storeDeref(nameIndex: value0):
      return "storeDeref(nameIndex: \(hex(value0)))"
    case let .deleteDeref(nameIndex: value0):
      return "deleteDeref(nameIndex: \(hex(value0)))"
    case let .loadClassDeref(nameIndex: value0):
      return "loadClassDeref(nameIndex: \(hex(value0)))"
    case let .makeFunction(value0):
      return "makeFunction(\(value0))"
    case let .callFunction(argumentCount: value0):
      return "callFunction(argumentCount: \(hex(value0)))"
    case let .callFunctionKw(argumentCount: value0):
      return "callFunctionKw(argumentCount: \(hex(value0)))"
    case let .callFunctionEx(hasKeywordArguments: value0):
      return "callFunctionEx(hasKeywordArguments: \(value0))"
    case .`return`:
      return "return"
    case .loadBuildClass:
      return "loadBuildClass"
    case let .loadMethod(nameIndex: value0):
      return "loadMethod(nameIndex: \(hex(value0)))"
    case let .callMethod(argumentCount: value0):
      return "callMethod(argumentCount: \(hex(value0)))"
    case .importStar:
      return "importStar"
    case let .importName(nameIndex: value0):
      return "importName(nameIndex: \(hex(value0)))"
    case let .importFrom(nameIndex: value0):
      return "importFrom(nameIndex: \(hex(value0)))"
    case .popExcept:
      return "popExcept"
    case .endFinally:
      return "endFinally"
    case let .setupExcept(firstExceptLabel: value0):
      return "setupExcept(firstExceptLabel: \(hex(value0)))"
    case let .setupFinally(finallyStartLabel: value0):
      return "setupFinally(finallyStartLabel: \(hex(value0)))"
    case let .raiseVarargs(value0):
      return "raiseVarargs(\(value0))"
    case let .setupWith(value0):
      return "setupWith(\(value0))"
    case .withCleanupStart:
      return "withCleanupStart"
    case .withCleanupFinish:
      return "withCleanupFinish"
    case .beforeAsyncWith:
      return "beforeAsyncWith"
    case .setupAsyncWith:
      return "setupAsyncWith"
    case let .jumpAbsolute(labelIndex: value0):
      return "jumpAbsolute(labelIndex: \(hex(value0)))"
    case let .popJumpIfTrue(labelIndex: value0):
      return "popJumpIfTrue(labelIndex: \(hex(value0)))"
    case let .popJumpIfFalse(labelIndex: value0):
      return "popJumpIfFalse(labelIndex: \(hex(value0)))"
    case let .jumpIfTrueOrPop(labelIndex: value0):
      return "jumpIfTrueOrPop(labelIndex: \(hex(value0)))"
    case let .jumpIfFalseOrPop(labelIndex: value0):
      return "jumpIfFalseOrPop(labelIndex: \(hex(value0)))"
    case let .formatValue(conversion: value0, hasFormat: value1):
      return "formatValue(conversion: \(value0), hasFormat: \(value1))"
    case let .buildString(value0):
      return "buildString(\(hex(value0)))"
    case let .extendedArg(value0):
      return "extendedArg(\(hex(value0)))"
    case .setupAnnotations:
      return "setupAnnotations"
    case .popBlock:
      return "popBlock"
    case let .loadClosure(cellOrFreeIndex: value0):
      return "loadClosure(cellOrFreeIndex: \(hex(value0)))"
    case let .buildSlice(value0):
      return "buildSlice(\(value0))"
    }
  }
}

private func hex(_ value: UInt8) -> String {
  let s = String(value, radix: 16, uppercase: false)
  let prefix = s.count < 2 ? "0" : ""
  return "0x" + prefix + s
}
