import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:mockito/mockito.dart';

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

CategoricalDataCodecFactory createCategoricalDataEncoderFactoryMock({
  Map<CategoricalDataEncodingType, CategoricalDataCodec> encodingTypeToCodec,
}) {
  final factory = CategoricalDataCodecFactoryMock();
  encodingTypeToCodec.forEach((type, codec) =>
      when(factory.fromType(type, any)).thenReturn(codec));
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
