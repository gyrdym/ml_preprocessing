import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

/// A factory function to use `one hot` categorical data encoder in the pipeline
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
///   ]);
///
///   // let's fit a pipeline
///   final pipeline = Pipeline(dataframe, [
///     // 'col_1' column contains categorical data, let's encode it
///     toOneHotLabels(columnNames: ['col_1']),
///   ]);
///   final processed = pipeline.process(dataframe);
///
///   // since there are only two values in the series 'col_1', they will be
///   // converted as follows:
///   //
///   // 'val_1' => 10
///   // 'val_2' => 01
///   print(processed);
///   // DataFrame (3 x 4)
///   // val_1   val_2   col_2   col_3
///   //     1       0       1   false
///   //     0       1     0.4    true
///   //     1       0       5   false
/// }
/// ```
PipeableOperatorFn toOneHotLabels({
  Iterable<int>? columnIndices,
  Iterable<String>? columnNames,
  String headerPrefix = '',
  String headerPostfix = '',
  UnknownValueHandlingType unknownValueHandlingType =
      defaultUnknownValueHandlingType,
}) =>
    (data, {dtype}) => EncoderImpl(
          data,
          EncoderType.oneHot,
          const SeriesEncoderFactoryImpl(),
          columnIndices: columnIndices,
          columnNames: columnNames,
          encodedHeaderPostfix: headerPostfix,
          encodedHeaderPrefix: headerPrefix,
          unknownValueHandlingType: unknownValueHandlingType,
        );
