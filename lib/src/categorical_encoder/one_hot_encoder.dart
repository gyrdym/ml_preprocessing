import 'dart:typed_data';

import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_mixin.dart';

class OneHotEncoder with EncoderMixin implements CategoricalDataEncoder {
  OneHotEncoder([Type dtype = Float32x4]) : dtype = dtype;

  @override
  final Type dtype;

  @override
  Vector encodeLabel(String value, Iterable<String> categoryLabels) {
    final valueIdx = categoryLabels.toList(growable: false).indexOf(value);
    final encodedCategorySource = List<double>.generate(
        categoryLabels.length,
            (int idx) => idx == valueIdx ? 1.0 : 0.0
    );
    return Vector.from(encodedCategorySource, dtype: dtype);
  }
}
