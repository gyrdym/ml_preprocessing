import 'dart:async';

import 'package:ml_dataframe/data_frame.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/preprocessor_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

import '../mocks.dart';

Future testPreprocessor({
  List<List<dynamic>> dataFromReader,
  int labelIdx,
  String labelName,
  List<ZRange> rows,
  List<ZRange> columns,
  CategoricalDataCodecFactory categoricalDataFactoryMock,
  PreprocessorArgumentsValidator validatorMock,
  Matcher throwErrorMatcher,
  void testOutputFn(DataFrame dataSet)
}) async {
  categoricalDataFactoryMock ??= createCategoricalDataCodecFactoryMock([]);
  validatorMock ??=
      createPreprocessorArgumentsValidatorMock(validationShouldBeFailed: false);

  final reader = DataReaderMock();

  when(reader.extractData())
      .thenAnswer((_) => Future.value(dataFromReader ?? [[]]));

  final preprocessor = PreprocessorImpl(
    reader,
    labelIdx: labelIdx,
    labelName: labelName,
    rows: rows,
    columns: columns,
    codecFactory: categoricalDataFactoryMock,
    argumentsValidator: validatorMock,
  );

  throwErrorMatcher != null
      ? expect(() => preprocessor.data, throwErrorMatcher)
      : testOutputFn(await preprocessor.data);
}
