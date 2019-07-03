import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:mockito/mockito.dart';

class EncoderMock extends Mock implements
    CategoricalDataEncoder {}

class OneHotEncoderMock extends Mock implements CategoricalDataEncoder {}

class OrdinalEncoderMock extends Mock implements CategoricalDataEncoder {}

class CategoricalDataEncoderFactoryMock extends Mock implements
    CategoricalDataEncoderFactory {}

class DataFrameParamsValidatorMock extends Mock implements
    DataFrameParamsValidator {}

class ToFloatNumberConverterMock extends Mock implements
    ToFloatNumberConverter {
  @override
  double convert(Object value, [double fallbackValue]) => value as double;
}

CategoricalDataEncoderFactory createCategoricalDataEncoderFactoryMock({
  CategoricalDataEncoder oneHotEncoderMock,
  CategoricalDataEncoder ordinalEncoderMock,
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
