import 'dart:async';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/csv_preprocessor.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

import '../mocks.dart';

Future testCsvData(
    {String fileName,
    int labelIdx,
    int expectedColsNum,
    int expectedRowsNum,
    List<ZRange> rows,
    List<ZRange> columns,
    CategoricalDataCodecFactory categoricalDataFactoryMock,
    DataFrameParamsValidator validatorMock,
    void testContentFn(
        Matrix features, Matrix labels)}) async {
  categoricalDataFactoryMock ??= createCategoricalDataCodecFactoryMock([]);
  validatorMock ??=
      createDataFrameParamsValidatorMock(validationShouldBeFailed: false);

  final dataFrame = CsvPreprocessor.fromFile(
    fileName,
    labelIdx: labelIdx,
    columns: columns,
    rows: rows,
    encoderFactory: categoricalDataFactoryMock,
    paramsValidator: validatorMock,
  );
  final dataSet = await dataFrame.data;
  final labels = dataSet.outcome;

  if (columns == null) {
    expect(dataSet.features.columnsNum, equals(expectedColsNum));
  }

  expect(dataSet.features.rowsNum, equals(expectedRowsNum));
  expect(labels.rowsNum, equals(expectedRowsNum));

  testContentFn(dataSet.features, labels);
}
