import Core
import Foundation
import Bytecode
import Objects

// In CPython:
// Python -> ceval.c

// swiftlint:disable file_length

/// Dummy namespace for `eval` function, just so we don't pollute `VM` with all
/// of that nonsense (but don't worry, we use `VM` as a 'catch them all'
/// for all of the code that does not fit anywhere else, so it is still a mess).
internal class Eval {

  // MARK: - Properties

  /// You know the thing that we are evaluating...
  internal let frame: PyFrame

  /// Code to run.
  internal var code: PyCode { return self.frame.code }

  /// Parent frame.
  internal var parent: PyFrame? { return self.frame.parent }

  /// Stack of `PyObjects`.
  internal var stack: ObjectStack {
    get { return self.frame.stack }
    set { self.frame.stack = newValue }
  }

  internal var stackLevel: Int {
    return self.frame.stack.count
  }

  /// Stack of blocks (for loops, exception handlers etc.).
  internal var blocks: BlockStack {
    get { return self.frame.blocks }
    set { self.frame.blocks = newValue }
  }

  /// Local variables.
  internal var localSymbols: PyDict { return self.frame.locals }
  /// Global variables.
  internal var globalSymbols: PyDict { return self.frame.globals }
  /// Builtin symbols (most of the time it would be `Py.builtinsModule.__dict__`).
  internal var builtinSymbols: PyDict { return self.frame.builtins }

  /// Function args and local variables.
  ///
  /// We could use `self.localSymbols` but that would be `O(1)` with
  /// massive constants.
  /// We could also put them at the bottom of our stack (like in other languages),
  /// but as 'the hipster trash that we are' (quote from @bestdressed)
  /// we won't do this.
  /// We use array which is like dictionary, but with lower constants.
  ///
  /// CPython: `f_localsplus`.
  internal var fastLocals: [PyObject?] {
    get { return self.frame.fastLocals }
    set { self.frame.fastLocals = newValue }
  }

  /// Free variables (variables from upper scopes).
  ///
  /// First cells and then free (see `loadClosure` or `deref` instructions).
  ///
  /// Btw. `Cell` = source for `free` variable.
  ///
  /// And yes, just as `self.fastLocals` they could be placed at the bottom
  /// of the stack.
  /// And no, we will not do this (see `self.fastLocals` comment).
  /// \#hipsters
  ///
  /// CPython: `f_lasti`.
  internal var cellsAndFreeVariables: [PyCell] {
    get { return self.frame.cellsAndFreeVariables }
    set { self.frame.cellsAndFreeVariables = newValue }
  }

  /// PC.
  internal var instructionIndex: Int {
    get { return self.frame.instructionIndex ?? 0 }
    set { self.frame.instructionIndex = newValue }
  }

  /// Stack of exceptions.
  internal var exceptions = ExceptionStack()

  // MARK: - Code object getters

  internal func getName(index: Int) -> PyString {
    assert(0 <= index && index < self.code.names.count)
    return self.code.names[index]
  }

  internal func getConstant(index: Int) -> Objects.Constant {
    assert(0 <= index && index < self.code.constants.count)
    return self.code.constants[index]
  }

  internal func getLabel(index: Int) -> Int {
    // In all of the dumps/prints we multiply by 'Instruction.byteSize'.
    // We don't have to it here because 'index' is already instruction index.

    assert(0 <= index && index < self.code.labels.count)
    return self.code.labels[index]
  }

  // MARK: - Init

  internal init(frame: PyFrame) {
    self.frame = frame
  }

  // MARK: - Run

  internal func run() -> PyResult<PyObject> {
    while true {
      switch self.executeInstruction() {
      case .ok:
        break // go to next instruction

      case .unwind(let reason):
        self.addExceptionContextIfNeeded(reason)
        switch self.unwind(reason: reason) {
        case .continueCodeExecution:
          break
        case .return(let value):
          return .value(value)
        }
      }
    }
  }

  /// Context - another exception during whose handling this exception was raised.
  private func addExceptionContextIfNeeded(_ reason: UnwindReason) {
    guard case let UnwindReason.exception(exception) = reason else {
      return
    }

    let hasEmptyContext = exception.getContext()?.isNone ?? true
    guard hasEmptyContext else {
      return
    }

    guard let currentException = self.exceptions.current else {
      return
    }

    exception.setContext(currentException)
  }

  /// Fetch instruction at `self.frame.instructionIndex`.
  /// Will also increment `PC`
  /// (just as the name... does not suggest, but as is customary).
  private func fetchInstruction() -> Instruction {
    let index = self.instructionIndex
    assert(0 <= index && index < self.code.instructions.count)
    let result = self.code.instructions[index]
    self.instructionIndex += 1
    return result
  }

  // swiftlint:disable:next function_body_length
  private func executeInstruction(extendedArg: Int = 0) -> InstructionResult {
    Debug.stack(stack: self.stack)
    Debug.stack(stack: self.blocks)
    Debug.instruction(code: self.code,
                      instructionIndex: self.instructionIndex,
                      extendedArg: extendedArg)

    let instruction = self.fetchInstruction()

    // According to CPython doing single switch will trash our jump prediction
    // (unles you have the same opcode multiple times in a row).
    // It is a valid concern, but we don't care about this (for now).
    switch instruction {
    case .nop:
      return .ok

    case .popTop:
      return self.popTop()
    case .rotTwo:
      return self.rotTwo()
    case .rotThree:
      return self.rotThree()
    case .dupTop:
      return self.dupTop()
    case .dupTopTwo:
      return self.dupTopTwo()

    case .unaryPositive:
      return self.unaryPositive()
    case .unaryNegative:
      return self.unaryNegative()
    case .unaryNot:
      return self.unaryNot()
    case .unaryInvert:
      return self.unaryInvert()

    case .binaryPower:
      return self.binaryPower()
    case .binaryMultiply:
      return self.binaryMultiply()
    case .binaryMatrixMultiply:
      return self.binaryMatrixMultiply()
    case .binaryFloorDivide:
      return self.binaryFloorDivide()
    case .binaryTrueDivide:
      return self.binaryTrueDivide()
    case .binaryModulo:
      return self.binaryModulo()
    case .binaryAdd:
      return self.binaryAdd()
    case .binarySubtract:
      return self.binarySubtract()
    case .binaryLShift:
      return self.binaryLShift()
    case .binaryRShift:
      return self.binaryRShift()
    case .binaryAnd:
      return self.binaryAnd()
    case .binaryXor:
      return self.binaryXor()
    case .binaryOr:
      return self.binaryOr()

    case .inplacePower:
      return self.inplacePower()
    case .inplaceMultiply:
      return self.inplaceMultiply()
    case .inplaceMatrixMultiply:
      return self.inplaceMatrixMultiply()
    case .inplaceFloorDivide:
      return self.inplaceFloorDivide()
    case .inplaceTrueDivide:
      return self.inplaceTrueDivide()
    case .inplaceModulo:
      return self.inplaceModulo()
    case .inplaceAdd:
      return self.inplaceAdd()
    case .inplaceSubtract:
      return self.inplaceSubtract()
    case .inplaceLShift:
      return self.inplaceLShift()
    case .inplaceRShift:
      return self.inplaceRShift()
    case .inplaceAnd:
      return self.inplaceAnd()
    case .inplaceXor:
      return self.inplaceXor()
    case .inplaceOr:
      return self.inplaceOr()

    case let .compareOp(comparison):
      assert(extendedArg == 0)
      return self.compareOp(comparison: comparison)

    case .getAwaitable:
      return self.getAwaitable()
    case .getAIter:
      return self.getAIter()
    case .getANext:
      return self.getANext()
    case .yieldValue:
      return self.yieldValue()
    case .yieldFrom:
      return self.yieldFrom()

    case .printExpr:
      return self.printExpr()

    case let .setupLoop(loopEndLabel):
      let extended = self.extend(base: extendedArg, arg: loopEndLabel)
      return self.setupLoop(loopEndLabelIndex: extended)
    case let .forIter(ifEmptyLabel):
      let extended = self.extend(base: extendedArg, arg: ifEmptyLabel)
      return self.forIter(ifEmptyLabelIndex: extended)
    case .getIter:
      return self.getIter()
    case .getYieldFromIter:
      return self.getYieldFromIter()
    case .`break`:
      return self.doBreak()
    case let .continue(loopStartLabel):
      let extended = self.extend(base: extendedArg, arg: loopStartLabel)
      return self.doContinue(loopStartLabelIndex: extended)

    case let .buildTuple(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildTuple(elementCount: extended)
    case let .buildList(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildList(elementCount: extended)
    case let .buildSet(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildSet(elementCount: extended)
    case let .buildMap(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildMap(elementCount: extended)
    case let .buildConstKeyMap(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildConstKeyMap(elementCount: extended)

    case let .setAdd(value):
      let extended = self.extend(base: extendedArg, arg: value)
      return self.setAdd(value: extended)
    case let .listAppend(value):
      let extended = self.extend(base: extendedArg, arg: value)
      return self.listAdd(value: extended)
    case let .mapAdd(value):
      let extended = self.extend(base: extendedArg, arg: value)
      return self.mapAdd(value: extended)

    case let .buildTupleUnpack(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildTupleUnpack(elementCount: extended)
    case let .buildTupleUnpackWithCall(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildTupleUnpackWithCall(elementCount: extended)
    case let .buildListUnpack(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildListUnpack(elementCount: extended)
    case let .buildSetUnpack(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildSetUnpack(elementCount: extended)
    case let .buildMapUnpack(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildMapUnpack(elementCount: extended)
    case let .buildMapUnpackWithCall(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildMapUnpackWithCall(elementCount: extended)
    case let .unpackSequence(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.unpackSequence(elementCount: extended)
    case let .unpackEx(arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      let decoded = UnpackExArg(value: extended)
      return self.unpackEx(arg: decoded)

    case let .loadConst(index):
      let extended = self.extend(base: extendedArg, arg: index)
      return self.loadConst(index: extended)

    case let .storeName(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.storeName(nameIndex: extended)
    case let .loadName(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadName(nameIndex: extended)
    case let .deleteName(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.deleteName(nameIndex: extended)

    case let .storeAttribute(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.storeAttribute(nameIndex: extended)
    case let .loadAttribute(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadAttribute(nameIndex: extended)
    case let .deleteAttribute(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.deleteAttribute(nameIndex: extended)

    case .binarySubscript:
      return self.binarySubscript()
    case .storeSubscript:
      return self.storeSubscript()
    case .deleteSubscript:
      return self.deleteSubscript()

    case let .storeGlobal(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.storeGlobal(nameIndex: extended)
    case let .loadGlobal(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadGlobal(nameIndex: extended)
    case let .deleteGlobal(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.deleteGlobal(nameIndex: extended)

    case let .loadFast(variableIndex: index):
      let extended = self.extend(base: extendedArg, arg: index)
      return self.loadFast(index: extended)
    case let .storeFast(variableIndex: index):
      let extended = self.extend(base: extendedArg, arg: index)
      return self.storeFast(index: extended)
    case let .deleteFast(variableIndex: index):
      let extended = self.extend(base: extendedArg, arg: index)
      return self.deleteFast(index: extended)

    case let .loadDeref(cellOrFreeIndex: index):
      let extended = self.extend(base: extendedArg, arg: index)
      return self.loadDeref(cellOrFreeIndex: extended)
    case let .storeDeref(cellOrFreeIndex: index):
      let extended = self.extend(base: extendedArg, arg: index)
      return self.storeDeref(cellOrFreeIndex: extended)
    case let .deleteDeref(cellOrFreeIndex: index):
      let extended = self.extend(base: extendedArg, arg: index)
      return self.deleteDeref(cellOrFreeIndex: extended)
    case let .loadClassDeref(cellOrFreeIndex: index):
      let extended = self.extend(base: extendedArg, arg: index)
      return self.loadClassDeref(cellOrFreeIndex: extended)

    case let .makeFunction(flags):
      assert(extendedArg == 0)
      return self.makeFunction(flags: flags)
    case let .callFunction(argumentCount):
      let extended = self.extend(base: extendedArg, arg: argumentCount)
      return self.callFunction(argumentCount: extended)
    case let .callFunctionKw(argumentCount):
      let extended = self.extend(base: extendedArg, arg: argumentCount)
      return self.callFunctionKw(argumentCount: extended)
    case let .callFunctionEx(hasKeywordArguments):
      assert(extendedArg == 0)
      return self.callFunctionEx(hasKeywordArguments: hasKeywordArguments)

    case .`return`:
      return self.doReturn()

    case .loadBuildClass:
      return self.loadBuildClass()

    case let .loadMethod(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadMethod(nameIndex: extended)
    case let .callMethod(argumentCount):
      let extended = self.extend(base: extendedArg, arg: argumentCount)
      return self.callMethod(argumentCount: extended)

    case .importStar:
      return self.importStar()
    case let .importName(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.importName(nameIndex: extended)
    case let .importFrom(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.importFrom(nameIndex: extended)

    case .popExcept:
      return self.popExcept()
    case .endFinally:
      return self.endFinally()
    case let .setupExcept(firstExceptLabel):
      let extended = self.extend(base: extendedArg, arg: firstExceptLabel)
      return self.setupExcept(firstExceptLabelIndex: extended)
    case let .setupFinally(finallyStartLabel):
      let extended = self.extend(base: extendedArg, arg: finallyStartLabel)
      return self.setupFinally(finallyStartLabelIndex: extended)

    case let .raiseVarargs(arg):
      assert(extendedArg == 0)
      return self.raiseVarargs(arg: arg)

    case let .setupWith(afterBodyLabel):
      let extended = self.extend(base: extendedArg, arg: afterBodyLabel)
      return self.setupWith(afterBodyLabelIndex: extended)
    case .withCleanupStart:
      return self.withCleanupStart()
    case .withCleanupFinish:
      return self.withCleanupFinish()
    case .beforeAsyncWith:
      return self.beforeAsyncWith()
    case .setupAsyncWith:
      return self.setupAsyncWith()

    case let .jumpAbsolute(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.jumpAbsolute(labelIndex: extended)

    case let .popJumpIfTrue(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.popJumpIfTrue(labelIndex: extended)
    case let .popJumpIfFalse(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.popJumpIfFalse(labelIndex: extended)
    case let .jumpIfTrueOrPop(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.jumpIfTrueOrPop(labelIndex: extended)
    case let .jumpIfFalseOrPop(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.jumpIfFalseOrPop(labelIndex: extended)

    case let .formatValue(conversion, hasFormat):
      assert(extendedArg == 0)
      return self.formatValue(conversion: conversion, hasFormat: hasFormat)

    case let .buildString(arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      return self.buildString(count: extended)

    case let .extendedArg(value):
      let extended = self.extend(base: extendedArg, arg: value)
      return self.executeInstruction(extendedArg: extended)

    case .setupAnnotations:
      return self.setupAnnotations()
    case .popBlock:
      return self.popBlock()
    case let .loadClosure(cellOrFreeIndex):
      let extended = self.extend(base: extendedArg, arg: cellOrFreeIndex)
      return self.loadClosure(cellOrFreeIndex: extended)
    case let .buildSlice(arg):
      return self.buildSlice(arg: arg)
    }
  }

  private func extend(base: Int, arg: UInt8) -> Int {
    return base << 8 | Int(arg)
  }
}