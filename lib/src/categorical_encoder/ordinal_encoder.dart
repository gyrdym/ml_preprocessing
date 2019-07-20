import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_mixin.dart';

class OrdinalEncoder extends CategoricalDataEncoderImpl {
  OrdinalEncoder(Iterable<String> values, [DType dtype = DType.float32])
      : super(values, dtype);

  @override
  Vector encodeSingle(String value) {
    final categoryLabels = originalToEncoded.keys;
    final ordinalNum = categoryLabels.toList(growable: false).indexOf(value)
        .toDouble();
    return Vector.fromList([ordinalNum], dtype: dtype);
  }
}
