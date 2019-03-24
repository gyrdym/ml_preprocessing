import 'dart:typed_data';

import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_mixin.dart';

class OrdinalEncoder with EncoderMixin implements CategoricalDataEncoder {
  OrdinalEncoder([Type dtype = Float32x4]) : dtype = dtype;

  @override
  final Type dtype;

  @override
  Vector encodeLabel(String value, Iterable<String> categoryLabels) {
    final ordinalNum = categoryLabels.toList(growable: false).indexOf(value)
        .toDouble();
    return Vector.from([ordinalNum], dtype: dtype);
  }
}
