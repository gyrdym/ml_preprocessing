import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

Vector encodeOneHotLabel(String value, Iterable<String> categoryLabels,
    DType dtype) {
  final valueIdx = categoryLabels.toList(growable: false).indexOf(value);
  final encodedCategorySource = List<double>.generate(
      categoryLabels.length,
          (int idx) => idx == valueIdx ? 1.0 : 0.0
  );
  return Vector.fromList(encodedCategorySource, dtype: dtype);
}
