import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/dataframe/numerical_converter/numerical_converter_impl.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_encoder/encoder_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

class CodecMock extends Mock implements CategoricalDataEncoder {}

class CategoricalDataCodecFactoryMock extends Mock implements
    CategoricalDataEncoderFactory {}

class NumericalConverterMock extends Mock implements
    NumericalConverter {
  @override
  double convert(Object value, [double fallbackValue]) => value as double;
}

class DataReaderMock extends Mock implements DataReader {}

/// Order of codecs in every map's value is important: the less the codec's
/// position number, the earlier the codec will be called
CategoricalDataEncoderFactory createCategoricalDataCodecFactoryMock(
    List<Tuple3<CategoricalDataEncodingType, Iterable<String>, CategoricalDataEncoder>> codecData) {
  final factory = CategoricalDataCodecFactoryMock();
  codecData.forEach((data) =>
      when(factory.fromType(data.item1, argThat(equals(data.item2)), any))
          .thenReturn(data.item3));
  return factory;
}
