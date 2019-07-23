import 'dart:async';

import 'package:ml_dataframe/data_frame.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/preprocessor.dart';
import 'package:ml_preprocessing/src/preprocessor/preprocessor_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

import '../mocks.dart';

void main() {
  final dataFromReader = <List<dynamic>>[
    ['feature_1', 'feature_2', 'feature_3', 'score'],
    ['value_1_1', 'value_2_7', 'value_3_3', 1],
    ['value_1_2', 'value_2_2', 'value_3_2', 10],
    ['value_1_3', 'value_2_3', 'value_3_1', 200],
    ['value_1_2', 'value_2_4', 'value_3_3', 300],
    ['value_1_2', 'value_2_5', 'value_3_1', 400],
    ['value_1_1', 'value_2_6', 'value_3_2', 500],
    ['value_1_3', 'value_2_7', 'value_3_1', 700],
  ];

  group('PreprocessorImpl', () {
    test('should encode categorical data using column name to encoding type '
        'mapping', () async {
      await testCsvWithCategories(
          dataFromReader: dataFromReader,
          labelIdx: 3,
          rowsNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          columnToEncoding: {
            'feature_1': CategoricalDataEncodingType.oneHot,
            'feature_2': CategoricalDataEncodingType.ordinal,
            'feature_3': CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (dataset, preprocessor) {
            expect(
                dataset.toMatrix(),
                equals([
                  //  feature 1     feature 2      feature 3
                  [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0, 1],
                  [0.0, 1.0, 0.0, /**/ 1.0, /**/ 0.0, 1.0, 0.0, 10],
                  [0.0, 0.0, 1.0, /**/ 2.0, /**/ 0.0, 0.0, 1.0, 200],
                  [0.0, 1.0, 0.0, /**/ 3.0, /**/ 1.0, 0.0, 0.0, 300],
                  [0.0, 1.0, 0.0, /**/ 4.0, /**/ 0.0, 0.0, 1.0, 400],
                  [1.0, 0.0, 0.0, /**/ 5.0, /**/ 0.0, 1.0, 0.0, 500],
                  [0.0, 0.0, 1.0, /**/ 0.0, /**/ 0.0, 0.0, 1.0, 700],
                ]));
          });
    });

    test('should encode categorical data using column name to encoding type '
        'mapping, number of rows to read is less than category values '
        'number', () async {
      // feature_1 - category values: value_1_1, value_1_2, value_1_3 -
      // in total - 3 values, needed to read just 1 row
      await testCsvWithCategories(
          dataFromReader: dataFromReader,
          labelIdx: 3,
          rowsNum: 1,
          columns: [
            ZRange.closed(0, 3),
          ],
          rows: [
            ZRange.closed(0, 0),
          ],
          columnToEncoding: {
            'feature_1': CategoricalDataEncodingType.oneHot,
            'feature_2': CategoricalDataEncodingType.ordinal,
            'feature_3': CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (dataset, preprocessor) {
            expect(
                dataset.toMatrix(),
                equals([
                  //  feature 1     feature 2      feature 3
                  [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0, 1],
                ]));
          });
    });

    test('should encode categorical data using column index to encoding type '
        'mapping', () async {
      await testCsvWithCategories(
          dataFromReader: dataFromReader,
          labelIdx: 3,
          rowsNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          indexToEncoding: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (dataset, preprocessor) {
            expect(
                dataset.toMatrix(),
                equals([
                  [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0, 1],
                  [0.0, 1.0, 0.0, /**/ 1.0, /**/ 0.0, 1.0, 0.0, 10],
                  [0.0, 0.0, 1.0, /**/ 2.0, /**/ 0.0, 0.0, 1.0, 200],
                  [0.0, 1.0, 0.0, /**/ 3.0, /**/ 1.0, 0.0, 0.0, 300],
                  [0.0, 1.0, 0.0, /**/ 4.0, /**/ 0.0, 0.0, 1.0, 400],
                  [1.0, 0.0, 0.0, /**/ 5.0, /**/ 0.0, 1.0, 0.0, 500],
                  [0.0, 0.0, 1.0, /**/ 0.0, /**/ 0.0, 0.0, 1.0, 700],
                ]));
          });
    });

    test('should encode categorical data using encoding type to column names '
        'mapping', () async {
          await testCsvWithCategories(
              dataFromReader: dataFromReader,
              labelIdx: 3,
              rowsNum: 7,
              columns: [
                ZRange.closed(0, 3),
              ],
              encodingToColumns: {
                CategoricalDataEncodingType.oneHot: ['feature_1', 'feature_3'],
                CategoricalDataEncodingType.ordinal: ['feature_2'],
              },
              testContentFn: (dataset, preprocessor) {
                expect(
                    dataset.toMatrix(),
                    equals([
                      [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0, 1],
                      [0.0, 1.0, 0.0, /**/ 1.0, /**/ 0.0, 1.0, 0.0, 10],
                      [0.0, 0.0, 1.0, /**/ 2.0, /**/ 0.0, 0.0, 1.0, 200],
                      [0.0, 1.0, 0.0, /**/ 3.0, /**/ 1.0, 0.0, 0.0, 300],
                      [0.0, 1.0, 0.0, /**/ 4.0, /**/ 0.0, 0.0, 1.0, 400],
                      [1.0, 0.0, 0.0, /**/ 5.0, /**/ 0.0, 1.0, 0.0, 500],
                      [0.0, 0.0, 1.0, /**/ 0.0, /**/ 0.0, 0.0, 1.0, 700],
                    ]));
              });
        });

    test('should encode categorical data in headless dataset', () async {
      await testCsvWithCategories(
          dataFromReader: dataFromReader.skip(1).toList(),
          headerExist: false,
          labelIdx: 3,
          rowsNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          indexToEncoding: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (dataset, preprocessor) {
            expect(
                dataset.toMatrix(),
                equals([
                  [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0, 1],
                  [0.0, 1.0, 0.0, /**/ 1.0, /**/ 0.0, 1.0, 0.0, 10],
                  [0.0, 0.0, 1.0, /**/ 2.0, /**/ 0.0, 0.0, 1.0, 200],
                  [0.0, 1.0, 0.0, /**/ 3.0, /**/ 1.0, 0.0, 0.0, 300],
                  [0.0, 1.0, 0.0, /**/ 4.0, /**/ 0.0, 0.0, 1.0, 400],
                  [1.0, 0.0, 0.0, /**/ 5.0, /**/ 0.0, 1.0, 0.0, 500],
                  [0.0, 0.0, 1.0, /**/ 0.0, /**/ 0.0, 0.0, 1.0, 700],
                ]));
          });
    });

    test('should provide codec for categorical data', () async {
      await testCsvWithCategories(
          dataFromReader: dataFromReader,
          labelIdx: 3,
          rowsNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          indexToEncoding: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (dataset, preprocessor) async {
            final columnRangeToCodec = await preprocessor.columnRangeToCodec;
            final decoded = columnRangeToCodec[ZRange.closed(0, 2)]
                .decode(Matrix.fromList([
              [1.0, 0.0, 0.0],
              [0.0, 1.0, 0.0],
              [0.0, 0.0, 1.0],
              [0.0, 1.0, 0.0],
              [0.0, 1.0, 0.0],
              [1.0, 0.0, 0.0],
              [0.0, 0.0, 1.0],
            ]));
            expect(decoded, equals(['value_1_1', 'value_1_2', 'value_1_3',
            'value_1_2', 'value_1_2', 'value_1_1', 'value_1_3']));
          });
    });

    test('should return null instead of categorical codec if improper column '
        'range is provided', () async {
      await testCsvWithCategories(
          dataFromReader: dataFromReader,
          labelIdx: 3,
          rowsNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          indexToEncoding: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (dataset, preprocessor) async {
            final columnRangeToCodec = await preprocessor.columnRangeToCodec;
            expect(columnRangeToCodec[ZRange.singleton(45)], isNull);
          });
    });

    test('should throw an exception if one tries to decode a data providing '
        'index of non-categorical column', () async {
      await testCsvWithCategories(
          dataFromReader: dataFromReader,
          labelIdx: 3,
          rowsNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          indexToEncoding: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (dataset, preprocessor) async {
            final columnRangeToCodec = await preprocessor.columnRangeToCodec;
            expect(() => columnRangeToCodec[ZRange.singleton(3)].decode(
                Matrix.fromList([
                  [1.0, 0.0, 0.0],
                  [0.0, 1.0, 0.0],
                ])
            ), throwsException);
          });
    });
  });
}

Future testCsvWithCategories({
  List<List<dynamic>> dataFromReader,
  bool headerExist = true,
  int labelIdx,
  int rowsNum,
  List<ZRange> columns,
  List<ZRange> rows,
  Map<CategoricalDataEncodingType, Iterable<String>> encodingToColumns,
  Map<String, CategoricalDataEncodingType> columnToEncoding,
  Map<int, CategoricalDataEncodingType> indexToEncoding,
  void testContentFn(DataFrame dataset, Preprocessor preprocessor)
}) async {
  final dataReader = DataReaderMock();

  when(dataReader.extractData())
      .thenAnswer((_) => Future.value(dataFromReader));

  final preprocessor = PreprocessorImpl(
    dataReader,
    labelIdx: labelIdx,
    columns: columns,
    rows: rows,
    headerExists: headerExist,
    encodingTypeToColumnNames: encodingToColumns,
    columnNameToEncodingType: columnToEncoding,
    columnIndexToEncodingType: indexToEncoding,
  );

  final dataset = await preprocessor.data;

  expect(dataset.toMatrix().rowsNum, rowsNum);

  testContentFn(dataset, preprocessor);
}
