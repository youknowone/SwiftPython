# (name, operator)
operations = [
  # PyObject *
  # PyNumber_Add(PyObject *v, PyObject *w)
  # {
  #     PyObject *result = binary_op1(v, w, NB_SLOT(nb_add));
  #     if (result == Py_NotImplemented) {
  #         PySequenceMethods *m = v->ob_type->tp_as_sequence;
  #         Py_DECREF(result);
  #         if (m && m->sq_concat) {
  #             return (*m->sq_concat)(v, w);
  #         }
  #         result = binop_type_error(v, w, "+");
  #     }
  #     return result;
  # }
  ('add', '+'),
  # define BINARY_FUNC(func, op, op_name) \
  # PyObject * \
  # func(PyObject *v, PyObject *w) { \
  #     return binary_op(v, w, NB_SLOT(op), op_name); \
  # }
  # BINARY_FUNC(PyNumber_Subtract, nb_subtract, "-")
  ('sub', '-'),
  # PyObject *
  # PyNumber_Multiply(PyObject *v, PyObject *w)
  # {
  #     PyObject *result = binary_op1(v, w, NB_SLOT(nb_multiply));
  #     if (result == Py_NotImplemented) {
  #         PySequenceMethods *mv = v->ob_type->tp_as_sequence;
  #         PySequenceMethods *mw = w->ob_type->tp_as_sequence;
  #         Py_DECREF(result);
  #         if  (mv && mv->sq_repeat) {
  #             return sequence_repeat(mv->sq_repeat, v, w);
  #         }
  #         else if (mw && mw->sq_repeat) {
  #             return sequence_repeat(mw->sq_repeat, w, v);
  #         }
  #         result = binop_type_error(v, w, "*");
  #     }
  #     return result;
  # }
  ('mul', '*'),
  # PyObject *
  # PyNumber_MatrixMultiply(PyObject *v, PyObject *w) {
  #     return binary_op(v, w, NB_SLOT(nb_matrix_multiply), "@");
  # }
  ('matmul', '@'),
  # PyObject *
  # PyNumber_TrueDivide(PyObject *v, PyObject *w) {
  #     return binary_op(v, w, NB_SLOT(nb_true_divide), "/");
  # }
  ('truediv', '/'),
  # PyObject *
  # PyNumber_FloorDivide(PyObject *v, PyObject *w) {
  #     return binary_op(v, w, NB_SLOT(nb_floor_divide), "//");
  # }
  ('floordiv', '//'),
  # PyObject *
  # PyNumber_Remainder(PyObject *v, PyObject *w) {
  #     return binary_op(v, w, NB_SLOT(nb_remainder), "%");
  # }
  ('mod', '%'),
  # BINARY_FUNC(PyNumber_Divmod, nb_divmod, "divmod()")
  ('divmod', 'divmod()'),
  # BINARY_FUNC(PyNumber_Lshift, nb_lshift, "<<")
  ('lshift', '<<'),
  # BINARY_FUNC(PyNumber_Rshift, nb_rshift, ">>")
  ('rshift', '>>'),
  # BINARY_FUNC(PyNumber_And, nb_and, "&")
  ('and', '&'),
  # BINARY_FUNC(PyNumber_Or, nb_or, "|")
  ('or', '|'),
  # BINARY_FUNC(PyNumber_Xor, nb_xor, "^")
  ('xor', '^'),
]

if __name__ == '__main__':
  for name, operator in operations:
    name_upper_first = name[0].upper() + name[1:]
    struct_name = name_upper_first + 'Op'

    print(f'''\
// MARK: - {name_upper_first}

private struct {struct_name}: BinaryOp {{

  fileprivate static let op = "{operator}"
  fileprivate static let inPlaceOp = "{operator}="
  fileprivate static let selector = "__{name}__"
  fileprivate static let reverseSelector = "__r{name}__"
  fileprivate static let inPlaceSelector = "__i{name}__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> PyResultOrNot<PyObject> {{
    if let owner = left as? __{name}__Owner {{
      return owner.{name}(right)
    }}
    return .notImplemented
  }}

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> PyResultOrNot<PyObject> {{
    if let owner = right as? __r{name}__Owner {{
      return owner.r{name}(left)
    }}
    return .notImplemented
  }}

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> PyResultOrNot<PyObject> {{
    if let owner = left as? __i{name}__Owner {{
      return owner.i{name}(right)
    }}
    return .notImplemented
  }}
}}

public func {name}(left: PyObject, right: PyObject) -> PyResult<PyObject> {{
  return {struct_name}.call(left: left, right: right)
}}
''')

    if name == 'divmod':
      print('// `divmod` in place does not make sense\n')
    else:
      print(f'''\
public func {name}InPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {{
  return {struct_name}.callInPlace(left: left, right: right)
}}
''')