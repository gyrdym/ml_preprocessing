import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/data_reader/data_reader.dart';
import 'package:ml_preprocessing/src/preprocessor/numerical_converter/numerical_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

class CodecMock extends Mock implements CategoricalDataCodec {}

class CategoricalDataCodecFactoryMock extends Mock implements
    CategoricalDataCodecFactory {}

class PreprocessorArgumentsValidatorMock extends Mock implements
    DataFrameParamsValidator {}

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

DataFrameParamsValidator createDataFrameParamsValidatorMock({
  bool validationShouldBeFailed}) {
  final validator = PreprocessorArgumentsValidatorMock();
  if (validationShouldBeFailed != null) {
    when(validator.validate(
      labelIdx: anyNamed('labelIdx'),
      rows: anyNamed('rows'),
      columns: anyNamed('columns'),
      headerExists: anyNamed('headerExists'),
      namesToEncoders: anyNamed('namesToEncoders'),
      indexToEncoder: anyNamed('indexToEncoder'),
    )).thenReturn(validationShouldBeFailed ? 'error' : '');
  }
  return validator;
}
