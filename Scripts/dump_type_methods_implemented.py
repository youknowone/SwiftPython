# types = {
# {% for type in types.classes|annotated:"pytype" %}
#   {% if type.annotations.pytype == "NoneType" %}
#   type(None): [
#   {% elif type.annotations.pytype == "NotImplementedType" %}
#   type(NotImplemented): [
#   {% elif type.annotations.pytype == "ellipsis" %}
#   type(...): [
#   {% elif type.annotations.pytype == "function" %}
#   type(f): [
#   {% else %}
#   {{ type.annotations.pytype }}: [
#   {% endif %}
#   {% for method in type.allMethods|annotated:"pymethod" %}
#     '{{ method.annotations.pymethod }}',
#   {% endfor %}
#   ],
# {% endfor %}
# }

def f(): pass
code = type(f.__code__)

types = {
  object: [
    '__format__',
    '__dir__',
    '__subclasshook__',
    '__init_subclass__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__str__',
  ],
  bool: [
    '__repr__',
    '__str__',
    '__and__',
    '__rand__',
    '__or__',
    '__ror__',
    '__xor__',
    '__rxor__',
    'numerator',
    'denominator',
    '__abs__',
    '__add__',
    '__and__',
    '__or__',
    '__xor__',
    '__bool__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    'conjugate',
    '__divmod__',
    '__float__',
    '__floordiv__',
    '__hash__',
    'imag',
    '__index__',
    '__int__',
    '__invert__',
    '__mod__',
    '__mul__',
    '__pow__',
    '__radd__',
    '__rand__',
    '__ror__',
    '__rxor__',
    '__rdivmod__',
    '__rfloordiv__',
    '__rmod__',
    '__rmul__',
    '__rpow__',
    '__rlshift__',
    '__rrshift__',
    '__rsub__',
    '__rtruediv__',
    'real',
    '__repr__',
    '__round__',
    '__lshift__',
    '__rshift__',
    '__pos__',
    '__neg__',
    '__str__',
    '__sub__',
    '__truediv__',
  ],
  code: [
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
  ],
  complex: [
    '__abs__',
    '__add__',
    '__bool__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    'conjugate',
    '__divmod__',
    '__float__',
    '__floordiv__',
    '__hash__',
    'imag',
    '__int__',
    '__mod__',
    '__mul__',
    '__pow__',
    '__radd__',
    '__rdivmod__',
    '__rfloordiv__',
    '__rmod__',
    '__rmul__',
    '__rpow__',
    '__rsub__',
    '__rtruediv__',
    'real',
    '__repr__',
    '__pos__',
    '__neg__',
    '__str__',
    '__sub__',
    '__truediv__',
  ],
  type(...): [
    '__repr__',
  ],
  enumerate: [
  ],
  float: [
    '__abs__',
    '__add__',
    '__bool__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    'conjugate',
    '__divmod__',
    '__float__',
    '__floordiv__',
    '__hash__',
    'imag',
    '__int__',
    '__mod__',
    '__mul__',
    '__pow__',
    '__radd__',
    '__rdivmod__',
    '__rfloordiv__',
    '__rmod__',
    '__rmul__',
    '__rpow__',
    '__rsub__',
    '__rtruediv__',
    'real',
    '__repr__',
    '__round__',
    '__pos__',
    '__neg__',
    '__str__',
    '__sub__',
    '__truediv__',
  ],
  int: [
    'numerator',
    'denominator',
    '__abs__',
    '__add__',
    '__and__',
    '__or__',
    '__xor__',
    '__bool__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    'conjugate',
    '__divmod__',
    '__float__',
    '__floordiv__',
    '__hash__',
    'imag',
    '__index__',
    '__int__',
    '__invert__',
    '__mod__',
    '__mul__',
    '__pow__',
    '__radd__',
    '__rand__',
    '__ror__',
    '__rxor__',
    '__rdivmod__',
    '__rfloordiv__',
    '__rmod__',
    '__rmul__',
    '__rpow__',
    '__rlshift__',
    '__rrshift__',
    '__rsub__',
    '__rtruediv__',
    'real',
    '__repr__',
    '__round__',
    '__lshift__',
    '__rshift__',
    '__pos__',
    '__neg__',
    '__str__',
    '__sub__',
    '__truediv__',
  ],
  list: [
    'append',
    'extend',
    'clear',
    'copy',
    '__iadd__',
    '__add__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__contains__',
    'count',
    'index',
    '__getitem__',
    '__len__',
    '__imul__',
    '__mul__',
    '__rmul__',
    '__repr__',
  ],
  type(None): [
    '__bool__',
    '__repr__',
  ],
  type(NotImplemented): [
    '__repr__',
  ],
  range: [
    '__bool__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__contains__',
    'count',
    'index',
    '__getitem__',
    '__hash__',
    '__len__',
    '__repr__',
  ],
  slice: [
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__repr__',
  ],
  tuple: [
    '__add__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__contains__',
    'count',
    'index',
    '__getitem__',
    '__hash__',
    '__len__',
    '__mul__',
    '__rmul__',
    '__repr__',
  ],
  type: [
  ],
  type(f): [
  ],
}