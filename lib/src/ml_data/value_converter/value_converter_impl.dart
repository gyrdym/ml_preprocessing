import 'package:ml_preprocessing/src/ml_data/value_converter/value_converter.dart';

class MLDataValueConverterImpl implements MLDataValueConverter {
  const MLDataValueConverterImpl();

  @override
  double convert(Object value, [double fallbackValue = 0.0]) {
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
