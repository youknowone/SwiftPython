import VioletCore

internal var loc0 = create(0)
internal var loc1 = create(1)
internal var loc2 = create(2)
internal var loc3 = create(3)
internal var loc4 = create(4)
internal var loc5 = create(5)
internal var loc6 = create(6)
internal var loc7 = create(7)
internal var loc8 = create(8)
internal var loc9 = create(9)
internal var loc10 = create(10)
internal var loc11 = create(11)
internal var loc12 = create(12)
internal var loc13 = create(13)
internal var loc14 = create(14)
internal var loc15 = create(15)
internal var loc16 = create(16)
internal var loc17 = create(17)
internal var loc18 = create(18)
internal var loc19 = create(19)
internal var loc20 = create(20)
internal var loc21 = create(21)
internal var loc22 = create(22)
internal var loc23 = create(23)
internal var loc24 = create(24)
internal var loc25 = create(25)
internal var loc26 = create(26)
internal var loc27 = create(27)
internal var loc28 = create(28)
internal var loc29 = create(29)
internal var loc30 = create(30)
internal var loc31 = create(31)

private func create(_ n: UInt32) -> SourceLocation {
  let line = SourceLine(n)
  let column = SourceColumn((n % 2) * 5 + line) // some random
  return SourceLocation(line: line, column: column)
}