from Exception_hierarchy import data
from Common.strings import generated_warning, where_to_find_errors_in_cpython
from Common.builtin_types import get_property_name_escaped as get_builtin_type_property_name


def is_final(name):
    'If there exists any exception with us as base then we are not final'

    for e in data:
        if e.base_class == name:
            return False

    return True


def create_doc_property_name(swift_class_name: str) -> str:
    result = swift_class_name.replace('Py', '', 1)
    result = result[0].lower() + result[1:]
    return result + 'Doc'


if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

// swiftlint:disable line_length
// swiftlint:disable trailing_newline
// swiftlint:disable file_length

{where_to_find_errors_in_cpython}
''')

    # For some of the exceptions we manyally wrote Swift class.
    manually_implemented = [
        'BaseException',
        'KeyError',  # Custom '__str__' method
        'StopIteration',  # 'value' property
        'SystemExit',  # 'code' property
        'ImportError',  # tons of customization (msg, name, path)
        'SyntaxError',  # another ton of customization (msg, filename, lineno, offset, text, print_file_and_line)
    ]

    for t in data:
        name = t.class_name
        base = t.base_class
        doc = t.doc

        if name in manually_implemented:
            continue

        class_name = 'Py' + name
        doc = doc.replace('\n', ' " +\n"')
        final = 'final ' if is_final(name) else ''
        builtins_type_variable = get_builtin_type_property_name(name)
        doc_property_name = create_doc_property_name(class_name)

        print(f'''\
// MARK: - {name}

// sourcery: pyerrortype = {name}, default, baseType, hasGC, baseExceptionSubclass
public {final}class {class_name}: Py{base} {{

  // sourcery: pytypedoc
  internal static let {doc_property_name} = "{doc}"

  /// Type to set in `init`.
  override internal class var pythonType: PyType {{
    return Py.errorTypes.{builtins_type_variable}
  }}

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {{
    return self.type
  }}

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {{
    return self.__dict__
  }}

  // sourcery: pystaticmethod = __new__
  internal static func py{name}New(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<{class_name}> {{
    let argsTuple = Py.newTuple(elements: args)
    let result = {class_name}(args: argsTuple, type: type)
    return .value(result)
  }}

  // sourcery: pymethod = __init__
  internal func py{name}Init(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {{
    return super.py{base}Init(args: args, kwargs: kwargs)
  }}
}}
''')
