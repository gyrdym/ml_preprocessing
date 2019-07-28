import 'package:ml_preprocessing/src/encoder/numerical_converter/numerical_converter.dart';

class NumericalConverterImpl implements NumericalConverter {
  const NumericalConverterImpl();

  @override
  double convert(Object value, [double fallbackValue = 0.0]) {
    if (value == null) {
      return fallbackValue;
    }
    if (value is String) {
      if (value.isEmpty) {
        return fallbackValue;
      } else {
        return double.parse(value);
      }
    } else {
      return (value as num).toDouble();
    }
  }
}
