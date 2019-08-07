import 'package:ml_preprocessing/src/data_frame/data_frame.dart';
import 'package:ml_preprocessing/src/numerical_converter/numerical_converter.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline_step_data.dart';

class NumericalConverterImpl implements Pipeable, NumericalConverter {
  NumericalConverterImpl(this._fallbackValue);

  final num _fallbackValue;

  @override
  PipelineStepData process(PipelineStepData input) =>
      PipelineStepData(
        convertDataFrame(input.data),
        input.expandedColumnIds,
      );

  @override
  DataFrame convertDataFrame(DataFrame data) =>
    DataFrame(convertRawData(data.rows), header: data.header);

  @override
  Iterable<Iterable<double>> convertRawData(Iterable<Iterable> data) =>
    data.map((row) => row.map((value) {
      try {
        return _convertSingle(value);
      } catch (err) {
        return value;
      }
    }));

  double _convertSingle(dynamic value) {
    if (value == null) {
      return _fallbackValue;
    }
    if (value is String) {
      if (value.isEmpty) {
        return _fallbackValue;
      }
      return double.parse(value);
    }
    return value * 1.0;
  }
}

Pipeable toNumber({num fallbackValue}) => NumericalConverterImpl(fallbackValue);
