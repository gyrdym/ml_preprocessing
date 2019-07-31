Iterable<num> encodeAsOneHot(String value, List<String> categoricalValues) {
  final valueIdx = categoricalValues.indexOf(value);
  final encodedCategorySource = List<double>.generate(
      categoricalValues.length,
          (int idx) => idx == valueIdx ? 1.0 : 0.0
  );
  return encodedCategorySource;
}
