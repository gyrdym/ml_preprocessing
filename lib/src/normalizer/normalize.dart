import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_preprocessing/src/normalizer/normalizer.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline.dart';

/// Returns a function that can be used in [Pipeline]. The function creates
/// a [Normalizer] instance. Example:
///
/// ```dart
/// import 'package:ml_dataframe/ml_dataframe.dart';
/// import 'package:ml_preprocessing/ml_preprocessing.dart';
///
/// void main() {
///   final data = DataFrame([
///     ['feature_1', 'feature_2', 'label'],
///     [         10,        33.2,       2],
///     [         20,          -1,       4],
///     [         40,         -10,       5],
///     [         55,         100,      10],
///   ]);
///   final pipeline = Pipeline(data, [
///     normalize(),
///   ]);
///   final processed = pipeline.process(data);
///
///   print(processed);
///   // DataFrame (4 x 3)
///   //         feature_1                feature_2                 label
///   // 0.287927508354187       0.9559193253517151   0.05758550018072128
///   // 0.9794042110443115   -0.048970211297273636   0.19588084518909454
///   // 0.9630868434906006    -0.24077171087265015   0.12038585543632507
///   // 0.4800793528556824      0.8728715777397156   0.08728715777397156
/// }
/// ```
PipeableOperatorFn normalize([Norm norm = Norm.euclidean]) =>
    (_, {dtype}) => Normalizer(norm, dtype ?? DType.float32);
