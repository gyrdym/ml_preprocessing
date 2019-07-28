import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/encoder/numerical_converter/numerical_converter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

class CodecMock extends Mock implements CategoricalDataCodec {}

class CategoricalDataCodecFactoryMock extends Mock implements
    CategoricalDataCodecFactory {}

class NumericalConverterMock extends Mock implements
    NumericalConverter {
  @override
  double convert(Object value, [double fallbackValue]) => value as double;
}

class DataReaderMock extends Mock implements DataReader {}

/// Order of codecs in every map's value is important: the less the codec's
/// position number, the earlier the codec will be called
CategoricalDataCodecFactory createCategoricalDataCodecFactoryMock(
    List<Tuple3<CategoricalDataEncodingType, Iterable<String>, CategoricalDataCodec>> codecData) {
  final factory = CategoricalDataCodecFactoryMock();
  codecData.forEach((data) =>
      when(factory.fromType(data.item1, argThat(equals(data.item2)), any))
          .thenReturn(data.item3));
  return factory;
}
