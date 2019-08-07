import 'package:ml_preprocessing/src/data_frame/data_frame.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline_step_data.dart';

class NumericalConverter implements Pipeable {
  NumericalConverter(this._fallbackValue);

  final num _fallbackValue;

  @override
  PipelineStepData process(PipelineStepData input) {
    return PipelineStepData(
        DataFrame(input.data.rows.map((row) => row.map((value) {
          try {
            return _convert(value);
          } catch (err) {
            return value;
          }
        }))),
        input.expandedColumnIds,
    );
  }

  num _convert(dynamic value) {
    if (value == null) {
      return _fallbackValue;
    }
    if (value is String) {
      if (value.isEmpty) {
        return _fallbackValue;
      }
      return num.parse(value);
    }
    return value;
  }
}

Pipeable toNumber({num fallbackValue}) => NumericalConverter(fallbackValue);
