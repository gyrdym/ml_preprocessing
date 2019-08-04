import 'package:ml_preprocessing/src/data_frame/dataframe.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

class NumericalConverter implements Pipeable {
  NumericalConverter(this._fallbackValue);

  final num _fallbackValue;

  @override
  DataFrame process(DataFrame input) {
    return DataFrame(input.rows.map((row) => row.map((value) {
      try {
        return _convert(value);
      } catch (err) {
        return value;
      }
    })));
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
