import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:quiver/collection.dart';

class CategoricalDataCodecImpl implements CategoricalDataCodec {
  CategoricalDataCodecImpl(Iterable<String> labels, EncodeLabelFn encodeLabel,
      this.dtype) {
    final uniqueLabels = Set<String>.from(labels);
    _originalToEncoded = HashBiMap()
      ..addEntries(
          labels.map((label) =>
              MapEntry(label, encodeLabel(label, uniqueLabels, dtype))),
      );
  }

  final DType dtype;

  HashBiMap<String, Vector> get originalToEncoded => _originalToEncoded;
  HashBiMap<String, Vector> _originalToEncoded;

  @override
  Matrix encode(Iterable<String> values) => Matrix.fromRows(
      values.map((value) => _originalToEncoded[value]).toList(growable: false),
      dtype: dtype);

  @override
  Iterable<String> decode(Matrix encoded) => encoded.rows.map((encodedLabel) {
    if (!_originalToEncoded.inverse.containsKey(encodedLabel)) {
      throw Exception('None of original labels matches the encoded one - '
          '$encodedLabel');
    }
    return _originalToEncoded.inverse[encodedLabel];
  });
}
