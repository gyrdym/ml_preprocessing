import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:quiver/collection.dart';

/// A categorical data encoder. Contains names and values of the categories
/// that supposed to be encoded and provides method for data encoding
abstract class CategoricalDataEncoder {
  DType get dtype;

  HashBiMap<String, Vector> get originalToEncoded;

  /// Encodes passed categorical values to a numerical representation
  Matrix encode(Iterable<String> values);

  /// Decodes passed categorical encoded data to a source string representation
  Iterable<String> decode(Matrix values);

  /// Encodes a single categorical label
  Vector encodeSingle(String label);

  /// Decodes a single encoded categorical label
  String decodeSingle(Vector encoded);
}
