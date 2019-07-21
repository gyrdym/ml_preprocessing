import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

class CodecMock extends Mock implements CategoricalDataCodec {}

class CategoricalDataCodecFactoryMock extends Mock implements
    CategoricalDataCodecFactory {}

class DataFrameParamsValidatorMock extends Mock implements
    DataFrameParamsValidator {}

class ToFloatNumberConverterMock extends Mock implements
    ToFloatNumberConverter {
  @override
  double convert(Object value, [double fallbackValue]) => value as double;
}

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
  final validator = DataFrameParamsValidatorMock();
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
