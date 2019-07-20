import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_mixin.dart';

class OneHotEncoder extends CategoricalDataEncoderImpl {
  OneHotEncoder(Iterable<String> values, [DType dtype = DType.float32])
      : super(values, dtype);

  @override
  Vector encodeSingle(String value) {
    final categoryLabels = originalToEncoded.keys;
    final valueIdx = categoryLabels.toList(growable: false).indexOf(value);
    final encodedCategorySource = List<double>.generate(
        categoryLabels.length,
            (int idx) => idx == valueIdx ? 1.0 : 0.0
    );
    return Vector.fromList(encodedCategorySource, dtype: dtype);
  }
}
