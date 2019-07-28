import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

Vector encodeAsLabel(String value, List<String> categoricalValues,
    DType dtype) {
  final label = categoricalValues.toList(growable: false).indexOf(value)
      .toDouble();
  return Vector.fromList([label], dtype: dtype);
}
