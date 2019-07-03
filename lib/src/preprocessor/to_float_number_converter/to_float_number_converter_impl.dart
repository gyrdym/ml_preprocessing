import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';

class ToFloatNumberConverterImpl implements ToFloatNumberConverter {
  const ToFloatNumberConverterImpl();

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
