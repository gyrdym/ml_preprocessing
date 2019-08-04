Iterable<num> encodeAsLabel(String value, List<String> categoricalValues) {
  return [categoricalValues.indexOf(value)];
}
