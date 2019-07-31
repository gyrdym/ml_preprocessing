/// Contains names and values of the categories that supposed to be encoded
/// and provides method for data encoding/decoding
abstract class CategoricalDataEncoder {
  /// Encodes passed categorical values to a numerical representation
  Iterable<Iterable<num>> encode(Iterable<String> values);
}

typedef EncodeLabelFn = Iterable<num> Function(String value,
    List<String> uniqueCategoryLabels);
