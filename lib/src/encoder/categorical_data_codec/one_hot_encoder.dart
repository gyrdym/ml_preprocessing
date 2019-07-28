import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

Vector encodeAsOneHot(String value, List<String> categoricalValues,
    DType dtype) {
  final valueIdx = categoricalValues.indexOf(value);
  final encodedCategorySource = List<double>.generate(
      categoricalValues.length,
          (int idx) => idx == valueIdx ? 1.0 : 0.0
  );
  return Vector.fromList(encodedCategorySource, dtype: dtype);
}
