import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

/// A factory function to use label categorical data encoder in the pipeline
///
/// A usage example:
///
/// ```dart
/// import 'package:ml_dataframe/ml_dataframe.dart';
/// import 'package:ml_preprocessing/ml_preprocessing.dart';
///
/// void main() {
///   final dataframe = DataFrame([
///     ['col_1', 'col_2', 'col_3'],
///     ['val_1',       1,   false],
///     ['val_2',     0.4,    true],
///     ['val_1',       5,   false],
///     ['val_3',       6,   false],
///   ]);
///
///   // let's fit a pipeline
///   final pipeline = Pipeline(dataframe, [
///     // 'col_1' column contains categorical data, let's encode it
///     toIntegerLabels(columnNames: ['col_1']),
///   ]);
///   final processed = pipeline.process(dataframe);
///
///   // since there are only 3 values in the series 'col_1', they will be
///   // converted as follows:
///   //
///   // 'val_1' => 0
///   // 'val_2' => 1
///   // 'val_3' => 2
///   print(processed);
///   // DataFrame (4 x 3)
///   // col_1   col_2   col_3
///   //     0       1   false
///   //     1     0.4    true
///   //     0       5   false
///   //     2       6   false
/// }
/// ```
PipeableOperatorFn toIntegerLabels({
  Iterable<int>? columnIndices,
  Iterable<String>? columnNames,
  String headerPrefix = '',
  String headerPostfix = '',
  UnknownValueHandlingType unknownValueHandlingType =
      defaultUnknownValueHandlingType,
}) =>
    (data, {dtype}) => EncoderImpl(
          data,
          EncoderType.label,
          const SeriesEncoderFactoryImpl(),
          columnIndices: columnIndices,
          columnNames: columnNames,
          encodedHeaderPostfix: headerPostfix,
          encodedHeaderPrefix: headerPrefix,
          unknownValueHandlingType: unknownValueHandlingType,
        );
