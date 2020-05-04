// swiftlint:disable function_body_length

// MARK: - Types

internal func runOldTypes() {
  let dir = testDir.appendingPathComponent("Types")
  runTest(file: dir.appendingPathComponent("test_assignment.py"))
  runTest(file: dir.appendingPathComponent("test_basic_types.py"))
  runTest(file: dir.appendingPathComponent("test_bool.py"))
  runTest(file: dir.appendingPathComponent("test_bytes.py"))
  runTest(file: dir.appendingPathComponent("bytearray.py"))
  runTest(file: dir.appendingPathComponent("test_class.py"))
  runTest(file: dir.appendingPathComponent("test_commas.py"))
  runTest(file: dir.appendingPathComponent("test_comparisons.py"))
  runTest(file: dir.appendingPathComponent("test_dict.py"))
  runTest(file: dir.appendingPathComponent("test_ellipsis.py"))
  runTest(file: dir.appendingPathComponent("test_floats.py"))
  runTest(file: dir.appendingPathComponent("test_for.py"))
  runTest(file: dir.appendingPathComponent("test_hash.py"))
  runTest(file: dir.appendingPathComponent("test_if_expressions.py"))
  runTest(file: dir.appendingPathComponent("test_if.py"))
  runTest(file: dir.appendingPathComponent("test_int_float_comparisons.py"))
  runTest(file: dir.appendingPathComponent("test_int.py"))
  runTest(file: dir.appendingPathComponent("test_iterations.py"))
  runTest(file: dir.appendingPathComponent("test_list.py"))
  runTest(file: dir.appendingPathComponent("test_literals.py"))
  runTest(file: dir.appendingPathComponent("test_loop.py"))
  runTest(file: dir.appendingPathComponent("test_math_basics.py"))
  runTest(file: dir.appendingPathComponent("test_none.py"))
  runTest(file: dir.appendingPathComponent("test_numbers.py"))
  runTest(file: dir.appendingPathComponent("test_set.py"))
  runTest(file: dir.appendingPathComponent("test_short_circuit_evaluations.py"))
  runTest(file: dir.appendingPathComponent("test_slice.py"))
  runTest(file: dir.appendingPathComponent("test_statements.py"))
  runTest(file: dir.appendingPathComponent("test_strings.py"))
  runTest(file: dir.appendingPathComponent("test_try_exceptions.py"))
  runTest(file: dir.appendingPathComponent("test_tuple.py"))
  runTest(file: dir.appendingPathComponent("test_with.py"))
  runTest(file: dir.appendingPathComponent("type_hints.py"))
  runTest(file: dir.appendingPathComponent("indentation.py"))
  runTest(file: dir.appendingPathComponent("mro.py"))
  runTest(file: dir.appendingPathComponent("inplace_ops.py"))
  runTest(file: dir.appendingPathComponent("object.py"))
  runTest(file: dir.appendingPathComponent("3.1.2.13.py"))
  runTest(file: dir.appendingPathComponent("3.1.2.16.py"))
  runTest(file: dir.appendingPathComponent("3.1.2.18.py"))
  runTest(file: dir.appendingPathComponent("3.1.2.19.py"))
  runTest(file: dir.appendingPathComponent("3.1.3.2.py"))
  runTest(file: dir.appendingPathComponent("3.1.3.4.py"))
  runTest(file: dir.appendingPathComponent("3.1.3.5.py"))
  runTest(file: dir.appendingPathComponent("cast.py"))
  runTest(file: dir.appendingPathComponent("unicode_slicing.py"))
  runTest(file: dir.appendingPathComponent("variables.py"))
}

// MARK: - Builtins

internal func runOldBuiltins() {
  let dir = testDir.appendingPathComponent("Builtins")
  runTest(file: dir.appendingPathComponent("builtin_abs.py"))
  runTest(file: dir.appendingPathComponent("builtin_all.py"))
  runTest(file: dir.appendingPathComponent("builtin_any.py"))
  runTest(file: dir.appendingPathComponent("builtin_ascii.py"))
  runTest(file: dir.appendingPathComponent("builtin_bin.py"))
  runTest(file: dir.appendingPathComponent("builtin_callable.py"))
  runTest(file: dir.appendingPathComponent("builtin_chr.py"))
  runTest(file: dir.appendingPathComponent("builtin_complex.py"))
  runTest(file: dir.appendingPathComponent("builtin_dict.py"))
  runTest(file: dir.appendingPathComponent("builtin_dir.py"))
  runTest(file: dir.appendingPathComponent("builtin_divmod.py"))
  runTest(file: dir.appendingPathComponent("builtin_enumerate.py"))
  runTest(file: dir.appendingPathComponent("builtin_filter.py"))
  runTest(file: dir.appendingPathComponent("builtin_hex.py"))
  runTest(file: dir.appendingPathComponent("builtin_len.py"))
  runTest(file: dir.appendingPathComponent("builtin_map.py"))
  runTest(file: dir.appendingPathComponent("builtin_max.py"))
  runTest(file: dir.appendingPathComponent("builtin_min.py"))
  runTest(file: dir.appendingPathComponent("builtin_ord.py"))
  runTest(file: dir.appendingPathComponent("builtin_pow.py"))
  runTest(file: dir.appendingPathComponent("builtin_range.py"))
  runTest(file: dir.appendingPathComponent("builtin_reversed.py"))
  runTest(file: dir.appendingPathComponent("builtin_round.py"))
  runTest(file: dir.appendingPathComponent("builtin_slice.py"))
  runTest(file: dir.appendingPathComponent("builtin_zip.py"))
  runTest(file: dir.appendingPathComponent("builtins.py"))
  runTest(file: dir.appendingPathComponent("printing.py"))
  runTest(file: dir.appendingPathComponent("builtin_open.py"))
  runTest(file: dir.appendingPathComponent("builtin_locals.py"))
  runTest(file: dir.appendingPathComponent("builtin_file.py"))
  runTest(file: dir.appendingPathComponent("builtin_exec.py"))
  runTest(file: dir.appendingPathComponent("builtins_module.py"))
}
