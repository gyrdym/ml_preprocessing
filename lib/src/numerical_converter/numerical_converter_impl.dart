import 'package:ml_preprocessing/src/data_frame/data_frame.dart';
import 'package:ml_preprocessing/src/numerical_converter/numerical_converter.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline_step_data.dart';

class NumericalConverterImpl implements Pipeable, NumericalConverter {
  NumericalConverterImpl(this._strictTypeCheck);

  final bool _strictTypeCheck;
  final Exception _exception =
    Exception('Unsuccessful attempt to convert a value to number');

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
    data.map((row) => row.map((value) => _convertSingle(value)));

  double _convertSingle(dynamic value) {
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        if (_strictTypeCheck) {
          throw _exception;
        }
        return null;
      }
    }
    if (value is bool) {
      if (_strictTypeCheck) {
        throw _exception;
      }
      return value ? 1 : 0;
    }
    if (value is! num) {
      if (_strictTypeCheck) {
        throw _exception;
      }
      return null;
    }
    return value * 1.0;
  }
}

Pipeable toNumber({bool strictTypeCheck}) =>
    NumericalConverterImpl(strictTypeCheck);
