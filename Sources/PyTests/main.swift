import Foundation
import VioletCore
import VioletObjects

let rootDir = FileSystem.getRepositoryRoot()
let testDir = FileSystem.join(path: rootDir, element: "PyTests")

// If we call 'open' we want to start at repository root.
FileSystem.setCurrentWorkingDirectoryOrTrap(path: rootDir)

let arguments = Arguments()
let environment = Environment()

var runner = TestRunner(
  defaultArguments: arguments,
  defaultEnvironment: environment,
  stopAtFirstFailedTest: false
)

// ========================
// === RustPython tests ===
// ========================

let rustTestDir = FileSystem.join(path: testDir, element: "RustPython")
runner.runAllTests(
  from: rustTestDir,
  skipping: [
    "code.py", // We do not support all properties
    "extra_bool_eval.py" // Requires peephole optimizer
  ]
)

// ====================
// === Violet tests ===
// ====================

let violetTestDir = FileSystem.join(path: testDir, element: "Violet")
runner.runAllTests(from: violetTestDir)

// ==============
// === Result ===
// ==============

print("=== Summary ===")
let result = runner.getResult()

if result.failedTests.any {
  // swiftlint:disable:next force_unwrapping
  let emoji = ["😬", "🤒", "😵", "😕", "😟", "☹️", "😭", "😞", "😓"].randomElement()!
  print("\(emoji) Failed tests:")

  for test in result.failedTests {
    print("  \(test.name) (\(test.path))")
  }

  if result.passedTests.isEmpty {
    print("🦄 Ooo… Ooo?")
  }
} else {
  // swiftlint:disable:next force_unwrapping
  let emoji = ["😄", "😁", "😉", "😘", "🥰", "😍", "😇", "😋", "🥳"].randomElement()!
  print("\(emoji) All tests passed")
}

let durationInSeconds = String(format: "%.2f", result.durationInSeconds)
print("⏱️ Running time: \(durationInSeconds)s")

let returnValue: Int32 = result.failedTests.isEmpty ? 0 : 1
exit(returnValue)
