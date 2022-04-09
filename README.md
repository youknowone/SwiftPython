# Violet

Violet is one of those Swift <-> Python interop thingies, except that this time we implement the whole language from scratch. Name comes from [Violet Evergarden](https://www.netflix.com/pl-en/title/80182123).

[Many](https://www.imdb.com/title/tt7923710) [unwatched](https://www.imdb.com/title/tt12451520) [k-drama](https://www.imdb.com/title/tt10220588) [hours](https://www.imdb.com/title/tt10850932) [were](https://www.imdb.com/title/tt8242904) [put](https://www.imdb.com/title/tt14169770) [into](https://www.imdb.com/title/tt13067118) [this](https://www.imdb.com/title/tt6263222), so any ⭐  would be appreciated.

If something is not working, you have an interesting idea or maybe just a question, then you can start an issue or discussion. You can also contact us on twitter [@itBrokeAgain](https://twitter.com/itBrokeAgain) (optimism, yay!).

- [Violet](#violet)
  - [Requirements](#requirements)
  - [Features](#features)
  - [Future plans](#future-plans)
  - [Sources](#sources)
  - [Tests](#tests)
  - [Code style](#code-style)
  - [License](#license)

## Requirements

- 64 bit - for `BigInt` and (probably, maybe, I think) hash
- Platforms
    - macOS
      - Intel
        - 11.6.2 (BigSur) + Xcode 12.4 (Swift 5.3.2)
        - 11.6.2 (BigSur) + Xcode 13.0 (Swift 5.5)
      - Apple
        - ⚠️ Not tested! I don't have M1. ⚠️
    - Ubuntu
      - 21.04 + Swift 5.4.2 - use `make test` and `make pytest`
    - Docker
      - `swift:latest` (5.6.0) - use `make docker-test` and `make docker-pytest`
      - `swift:5.3.2` - use `make docker-test-old` and `make docker-pytest-old`

The whole Violet was written on 2014 rMBP (lowest spec: 8GB of ram + 128 GB storage), so it is safe to say that there are no other requirements (in other words: if your machine is less than 8 years old then you are probably fine). Although, in terms of raw compilation speed the Ubuntu with Intel Pentium G4560 (4GB of ram + some cheap SSD) was about 2 times faster than MacBook.

## Features

We aim for compatibility with Python 3.7 feature set.

We are only interested in the language itself without additional modules. This means that importing anything except for most basic modules (`sys`, `builtins` and a few others) is not supported (although you can import other Python files).

See `Documentation` directory for a list of known unimplemented features. There is no list of unknown unimplemented features though…

## Future plans

- **Garbage collection** is a nifty feature. Currently we allocate objects, but the only way to deallocate them is to call `py.destroy()` which destroys the whole Python context (and all of the objects that it owns).

    Btw. please remember to use [with statement](https://www.python.org/dev/peps/pep-0343/) to manage resources, do not rely on object lifetime (especially for the file descriptors).

- **Tail allocated `tuples`**. Currently we store `tuple` elements inside Swift array (`elements: [PyObject]`). The better idea would be to allocate more space *after* the tuple and store elements there (this is called [flexible array  member](https://en.wikipedia.org/wiki/Flexible_array_member) in `C`). This saves a pointer indirection and is better for cache, since we can fit a few first elements in the same line as `type`, `__dict__` etc. We can also do this for other immutable container types:
  - `str` - currently native Swift `String`. This would force us to implement our own `String` type - not hard, but takes a lot of time.
  - `int` - currently our own `BigInt` implementation (which does store values in `Int32` range inside the pointer).

## Sources

Core modules
- **VioletCore** — shared module imported by all of the other modules.
    - Contains things like `NonEmptyArray`, `SourceLocation`, [SipHash](https://131002.net/siphash/), `trap` and `unreachable`.
- **BigInt** — our implementation of unlimited integers
    - While it implements all of the operations expected of `BigInt` type, in reality it mostly focuses on performance of small integers — Python has only one `int` type and small numbers are most common.
    - Under the hood it is a union (via [tagged pointer](https://en.wikipedia.org/wiki/Tagged_pointer)) of `Int32` (called `Smi`, after [V8](https://github.com/v8/v8)) and a heap allocation (magnitude + sign representation) with ARC for garbage collection. << That's mouthful 💤
    - While the whole Violet tries to be as easy-to-read/accessible as possible, this does not apply to `BigInt` module. Numbers are hard, and for some reason humanity decided that “division” is a thing.
- **FileSystem** — our version of `Foundation.FileManager`.
    - Code quality varies. Most of the time it was “ehh… I need to implement another IO thing”. Then, later, all of those “ehs…” were put into a single module. In so-called meantime the wild [swift-system 🐯](https://github.com/apple/swift-system) appeared, so maybe it is time to use it?
    - Main reason why we do not support other platforms (Windows etc.).
- **UnicodeData** — apparently we also bundle our own Unicode database, because why not…
  - This is [kind of important](https://hsivonen.fi/string-length/).

Violet
- **VioletLexer** — transforms Python source code into a stream of tokens.
- **VioletParser** — transforms a stream of tokens (from `Lexer`) into an [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) (`AST`).
    - Yet Another [Recursive Descent Parser](https://en.wikipedia.org/wiki/Recursive_descent_parser) with minor hacks for ambiguous grammar.
    - `AST` type definitions are generated by `Elsa` module from `Elsa definitions/ast.letitgo`.
- **VioletBytecode** — instruction set of our VM.
    - 2-bytes per `enum Instruction`. There are a few interesting cases, like `.formatValue(conversion: StringConversion, hasFormat: Bool)` (where `StringConversion` is an `enum` with 4 possible values), but the compiler is expected to deal with it.
    - No relative jumps, only absolute (via additional `labels` array).
    - Instruction set is generated by `Elsa` module from `Elsa definitions/opcodes.letitgo`.
    - Use `CodeObjectBuilder` to create `CodeObjects`  (whoa… what a surprise!).
    - Includes a tiny [peephole optimizer](https://en.wikipedia.org/wiki/Peephole_optimization), because sometimes the semantics depends on it (for example for [short-circuit evaluation](https://en.wikipedia.org/wiki/Short-circuit_evaluation)).
- **VioletCompiler** — responsible for transforming `Parser.AST` into `Bytecode.CodeObject`.
- **VioletObjects** — contains all of the Python objects and modules.
    - `Py` represents a Python context. Common usage: `py.newInt(2)` or `py.add(lhs, rhs)`.
    - Contains `int`, `str`, `list` and 100+ other Python types.
    - Python object is represented as a Swift `struct` with a single `ptr: RawPtr` stored property. The `ptr` points to a heap allocated storage with custom layout. Layout is generated by [Sourcery](https://github.com/krzysztofzablocki/Sourcery) using `sourcery: storedProperty` annotations. Read the docs in the `Documentation` directory!

        ```Swift
        // sourcery: pytype = int
        public struct PyInt: PyObjectMixin {
          // sourcery: storedProperty
          public var value: BigInt { self.valuePtr.pointee }

          public let ptr: RawPtr
        }
        ```

    - Contains modules required to bootstrap Python: `builtins`, `sys`, `_imp`, `_os` and `_warnings`.
    - Does not contain `importlib` and `importlib_external` modules, because those are written in Python. They are a little bit different than CPython versions (we have 80% of the code, but only 20% of the functionality <great-success-meme.gif>).
    - `PyResult<Wrapped> = Wrapped | PyBaseException` is used for error handling.
- **VioletVM** — manipulates Python objects according to the instructions from `Bytecode.CodeObject`, so that the output vaguely resembles what `CPython` does.
    - Mainly a massive `switch` over each possible `Instruction`.
- **Violet** — main executable (duh…).
- **PyTests** — runs tests written in Python from the `PyTests` directory.

Tools/support
- **Elsa** — tiny DSL for code generation.
    - Uses `.letitgo` files from `Elsa definitions` directory.
    - Used for `Parser.AST` and `Bytecode.Instruction` types.
- **Rapunzel** — pretty printer based on “[A prettier printer](http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf)” by Philip Wadler.
    - Used to print `AST` in digestible manner.
- **Ariel** — prints module interface - all of the `open`/`public` declarations.
  - You can see the example output [here](Scripts/ariel_output).

## Tests

There are 2 types of tests in Violet:
- Swift tests — standard Swift unit tests stored inside the `./Tests` directory. You can run them by typing `make test` in repository root.

    You may want to disable unit tests for `BigInt` and `UnicodeData` if you are not touching those modules:
    - `BigInt` — we went with [property based testing](https://en.wikipedia.org/wiki/Property_testing) with means that we test millions of inputs to check if the general rule holds (for example: `a+b=c -> c-a=b` etc.). This takes time, but pays for itself by finding weird overflows in bit operations (we store “sign + magnitude”, so bit operations are a bit difficult to implement).
    - `UnicodeData`
        - In one of our tests we go through all of the Unicode code points and try to access various properties (crash -> fail). There are `0x11_0000` values to test, so… it is not fast.
        - We also have a few thousands of tests generated by Python. Things like: “is the `COMBINING VERTICAL LINE ABOVE (U+030d)` alpha-numeric?” (Answer: no, it is not. But you have to watch out because `HANGUL CHOSEONG THIEUTH (U+1110)` is).

- Python tests — tests written in Python stored inside the `./PyTests` directory.  You can run them by typing `make pytest` in repository root (there is also `make pytest-r` for release mode).
    - Violet - tests written specially for “Violet”.
    - RustPython - tests taken from [github.com/RustPython](https://github.com/RustPython/RustPython).

    Those tests are executed when you run `PyTests` module.

## Code style

- 2-space indents and no tabs at all
- 80 characters per line
    - You will get a [SwiftLint](https://github.com/realm/SwiftLint) warning if you go over 100.
    - Over 120 will result in a compilation error.
    - If 80 doesn't give you enough room to code, your code is too complicated - consider using subroutines (advice from [PEP-7](https://www.python.org/dev/peps/pep-0007/)).
- Required `self` in methods and computed properties
    - All of the other method arguments are named, so we will require it for this one.
    - `Self`/`type name` for static methods is recommended, but not required.
    - I’m sure that they will depreciate the implicit `self` in the next major Swift version 🤞. All of that source breakage is completely justified.
- No whitespace at the end of the line
    - Some editors may remove it as a matter of routine and we don’t want weird git diffs.
- (pet peeve) Try to introduce a named variable for every `if` condition.
    - You can use a single logical operator - something like `if !isPrincess` or `if isDisnepCharacter && isPrincess` is allowed.
    - Do not use `&&` and `||` in the same expression, create a variable for one of them.
    - If you need parens then it is already too complicated.

Anyway, just use [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) with provided presets (see [.swiftlint.yml](.swiftlint.yml) and [.swiftformat](.swiftformat) files).

## License

“Violet” is licensed under the MIT License.
See [LICENSE](LICENSE) file for more information.
