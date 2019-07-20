import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:mockito/mockito.dart';

class EncoderMock extends Mock implements
    CategoricalDataCodec {}

class OneHotEncoderMock extends Mock implements CategoricalDataCodec {}

class OrdinalEncoderMock extends Mock implements CategoricalDataCodec {}

class CategoricalDataEncoderFactoryMock extends Mock implements
    CategoricalDataCodecFactory {}

class DataFrameParamsValidatorMock extends Mock implements
    DataFrameParamsValidator {}

class ToFloatNumberConverterMock extends Mock implements
    ToFloatNumberConverter {
  @override
  double convert(Object value, [double fallbackValue]) => value as double;
}

CategoricalDataCodecFactory createCategoricalDataEncoderFactoryMock({
  CategoricalDataCodec oneHotEncoderMock,
  CategoricalDataCodec ordinalEncoderMock,
}) {
  oneHotEncoderMock ??= OneHotEncoderMock();
  ordinalEncoderMock ??= OrdinalEncoderMock();

  final factory = CategoricalDataEncoderFactoryMock();
  when(factory.oneHot(any)).thenReturn(oneHotEncoderMock);
  when(factory.ordinal(any)).thenReturn(ordinalEncoderMock);
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
