import 'dart:async';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
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
    CategoricalDataEncoderFactory categoricalDataFactoryMock,
    DataFrameParamsValidator validatorMock,
    void testContentFn(
        Matrix features, Matrix labels, List<String> headers)}) async {
  categoricalDataFactoryMock ??= createCategoricalDataEncoderFactoryMock();
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
  final header = await dataFrame.header;
  final features = await dataFrame.features;
  final labels = await dataFrame.labels;

  if (columns == null) {
    expect(header.length, equals(expectedColsNum + 1));
    expect(features.columnsNum, equals(expectedColsNum));
  }

  expect(features.rowsNum, equals(expectedRowsNum));
  expect(labels.rowsNum, equals(expectedRowsNum));

  testContentFn(features, labels, header);
}
