import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/numerical_converter/numerical_converter.dart';
import 'package:mockito/mockito.dart';

class NumericalConverterMock extends Mock implements
    NumericalConverter {
  @override
  double convert(Object value, [double fallbackValue]) => value as double;
}

class DataReaderMock extends Mock implements DataReader {}
