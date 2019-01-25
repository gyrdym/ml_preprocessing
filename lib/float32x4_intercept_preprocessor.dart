import 'dart:typed_data';

import 'package:ml_preprocessing/src/intercept_preprocessor/float32x4_intercept_preprocessor.dart';
import 'package:ml_preprocessing/src/intercept_preprocessor/intercept_preprocessor.dart';

abstract class Float32x4InterceptPreprocessor implements InterceptPreprocessor<Float32x4> {
  factory Float32x4InterceptPreprocessor({double interceptScale}) = Float32x4InterceptPreprocessorInternal;
}
