import 'dart:async';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
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
  List<ZRange> rows,
  List<ZRange> columns,
  CategoricalDataCodecFactory categoricalDataFactoryMock,
  DataFrameParamsValidator validatorMock,
  void testOutputFn(DataSet dataSet)
}) async {
  categoricalDataFactoryMock ??= createCategoricalDataCodecFactoryMock([]);
  validatorMock ??=
      createDataFrameParamsValidatorMock(validationShouldBeFailed: false);

  final reader = DataReaderMock();

  when(reader.extractData())
      .thenAnswer((_) => Future.value(dataFromReader ?? [[]]));

  final preprocessor = PreprocessorImpl(
    reader,
    labelIdx: labelIdx,
    columns: columns,
    rows: rows,
    codecFactory: categoricalDataFactoryMock,
    argumentsValidator: validatorMock,
  );

  testOutputFn(await preprocessor.data);
}
