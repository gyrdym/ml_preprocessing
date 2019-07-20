import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:quiver/collection.dart';

abstract class CategoricalDataEncoderImpl implements CategoricalDataEncoder {
  CategoricalDataEncoderImpl(Iterable<String> labels, this.dtype) {
    _originalToEncoded = HashBiMap()
      ..addEntries(
          labels.map((label) => MapEntry(label, encodeSingle(label))),
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
  Iterable<String> decode(Matrix encoded) => encoded.rows
      .map((encodedLabel) => _originalToEncoded.inverse[encodedLabel]);

  @override
  String decodeSingle(Vector encoded) => originalToEncoded.inverse[encoded];
}
