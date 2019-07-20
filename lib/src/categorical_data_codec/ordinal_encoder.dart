import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

Vector encodeOrdinalLabel(String value, Iterable<String> categoryLabels,
    DType dtype) {
  final ordinalNum = categoryLabels.toList(growable: false).indexOf(value)
      .toDouble();
  return Vector.fromList([ordinalNum], dtype: dtype);
}
