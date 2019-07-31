import 'package:ml_dataframe/data_set.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoder_factory.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

import '../mocks.dart';

void testPreprocessor({
  List<List<dynamic>> rawData,
  int labelIdx,
  String labelName,
  List<ZRange> rows,
  List<ZRange> columns,
  CategoricalDataEncoderFactory categoricalDataFactoryMock,
  Matcher throwErrorMatcher,
  void testOutputFn(DataSet dataSet)
}) {
  categoricalDataFactoryMock ??= createCategoricalDataCodecFactoryMock([]);

  final preprocessor = DataFrameImpl(
    rawData,
    labelIdx: labelIdx,
    labelName: labelName,
    indexedRows: rows,
    columns: columns,
    codecFactory: categoricalDataFactoryMock,
  );

  throwErrorMatcher != null
      ? expect(() => preprocessor.data, throwErrorMatcher)
      : testOutputFn(preprocessor.data);
}
