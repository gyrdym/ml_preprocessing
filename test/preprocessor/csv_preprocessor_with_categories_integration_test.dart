import 'dart:async';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/csv_preprocessor.dart';
import 'package:ml_preprocessing/src/preprocessor/preprocessor.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

Future testCsvWithCategories(
    {String fileName,
    bool headerExist = true,
    int labelIdx,
    int rowNum,
    List<ZRange> columns,
    List<ZRange> rows,
    Map<CategoricalDataEncodingType, Iterable<String>> encoders,
    Map<String, CategoricalDataEncodingType> categories,
    Map<int, CategoricalDataEncodingType> categoryIndices,
    void testContentFn(Matrix features, Matrix labels, List<String> headers,
        Preprocessor dataFrame)}) async {
  final dataFrame = CsvPreprocessor.fromFile(fileName,
      labelIdx: labelIdx,
      columns: columns,
      rows: rows,
      headerExists: headerExist,
      encoders: encoders,
      categories: categories,
      categoryIndices: categoryIndices,
  );
  final header = await dataFrame.header;
  final features = await dataFrame.data;
  final labels = await dataFrame.labels;

  expect(features.rowsNum, equals(rowNum));
  expect(labels.rowsNum, equals(rowNum));

  testContentFn(features, labels, header, dataFrame);
}

void main() {
  group('CsvDataFrame', () {
    test('should encode categorical data (`categories` parameter)',
        () async {
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data.csv',
          labelIdx: 3,
          rowNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          categories: {
            'feature_1': CategoricalDataEncodingType.oneHot,
            'feature_2': CategoricalDataEncodingType.ordinal,
            'feature_3': CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            expect(header,
                equals(['feature_1', 'feature_2', 'feature_3', 'score']));
            expect(
                features,
                equals([
                  //  feature 1     feature 2      feature 3
                  [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0],
                  [0.0, 1.0, 0.0, /**/ 1.0, /**/ 0.0, 1.0, 0.0],
                  [0.0, 0.0, 1.0, /**/ 2.0, /**/ 0.0, 0.0, 1.0],
                  [0.0, 1.0, 0.0, /**/ 3.0, /**/ 1.0, 0.0, 0.0],
                  [0.0, 1.0, 0.0, /**/ 4.0, /**/ 0.0, 0.0, 1.0],
                  [1.0, 0.0, 0.0, /**/ 5.0, /**/ 0.0, 1.0, 0.0],
                  [0.0, 0.0, 1.0, /**/ 0.0, /**/ 0.0, 0.0, 1.0],
                ]));
            expect(labels, equals([
              [1],
              [10],
              [200],
              [300],
              [400],
              [500],
              [700]
            ]));
          });
    });

    test('should encode categorical data (`categories` parameter),'
        'rows to read number is less than category values number',
        () async {
      // feature_1 - category values: value_1_1, value_1_2, value_1_3 -
      // in total - 3 values, needed to read just 1 row
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data.csv',
          labelIdx: 3,
          rowNum: 1,
          columns: [
            ZRange.closed(0, 3),
          ],
          rows: [
            ZRange.closed(0, 0),
          ],
          categories: {
            'feature_1': CategoricalDataEncodingType.oneHot,
            'feature_2': CategoricalDataEncodingType.ordinal,
            'feature_3': CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            expect(header,
                equals(['feature_1', 'feature_2', 'feature_3', 'score']));
            expect(
                features,
                equals([
                  //  feature 1     feature 2      feature 3
                  [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0],
                ]));
            expect(labels, equals([
              [1],
            ]));
          });
    });

    test('should encode categorical data (`categorIndices` parameter)',
            () async {
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data.csv',
          labelIdx: 3,
          rowNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          categoryIndices: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            expect(header,
                equals(['feature_1', 'feature_2', 'feature_3', 'score']));
            expect(
                features,
                equals([
                  [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0],
                  [0.0, 1.0, 0.0, /**/ 1.0, /**/ 0.0, 1.0, 0.0],
                  [0.0, 0.0, 1.0, /**/ 2.0, /**/ 0.0, 0.0, 1.0],
                  [0.0, 1.0, 0.0, /**/ 3.0, /**/ 1.0, 0.0, 0.0],
                  [0.0, 1.0, 0.0, /**/ 4.0, /**/ 0.0, 0.0, 1.0],
                  [1.0, 0.0, 0.0, /**/ 5.0, /**/ 0.0, 1.0, 0.0],
                  [0.0, 0.0, 1.0, /**/ 0.0, /**/ 0.0, 0.0, 1.0],
                ]));
            expect(labels, equals([
              [1],
              [10],
              [200],
              [300],
              [400],
              [500],
              [700]
            ]));
          });
    });

    test('should encode categorical data (`encoders` parameter)', () async {
          await testCsvWithCategories(
              fileName: 'test/test_data/fake_data.csv',
              labelIdx: 3,
              rowNum: 7,
              columns: [
                ZRange.closed(0, 3),
              ],
              encoders: {
                CategoricalDataEncodingType.oneHot: ['feature_1', 'feature_3'],
                CategoricalDataEncodingType.ordinal: ['feature_2'],
              },
              testContentFn: (features, labels, header, dataFrame) {
                expect(header,
                    equals(['feature_1', 'feature_2', 'feature_3', 'score']));
                expect(
                    features,
                    equals([
                      [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0],
                      [0.0, 1.0, 0.0, /**/ 1.0, /**/ 0.0, 1.0, 0.0],
                      [0.0, 0.0, 1.0, /**/ 2.0, /**/ 0.0, 0.0, 1.0],
                      [0.0, 1.0, 0.0, /**/ 3.0, /**/ 1.0, 0.0, 0.0],
                      [0.0, 1.0, 0.0, /**/ 4.0, /**/ 0.0, 0.0, 1.0],
                      [1.0, 0.0, 0.0, /**/ 5.0, /**/ 0.0, 1.0, 0.0],
                      [0.0, 0.0, 1.0, /**/ 0.0, /**/ 0.0, 0.0, 1.0],
                    ]));
                expect(labels, equals([
                  [1],
                  [10],
                  [200],
                  [300],
                  [400],
                  [500],
                  [700]
                ]));
              });
        });

    test('should encode categorical data in headless dataset', () async {
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data_headless.csv',
          headerExist: false,
          labelIdx: 3,
          rowNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          categoryIndices: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            expect(header, isNull);
            expect(
                features,
                equals([
                  [1.0, 0.0, 0.0, /**/ 0.0, /**/ 1.0, 0.0, 0.0],
                  [0.0, 1.0, 0.0, /**/ 1.0, /**/ 0.0, 1.0, 0.0],
                  [0.0, 0.0, 1.0, /**/ 2.0, /**/ 0.0, 0.0, 1.0],
                  [0.0, 1.0, 0.0, /**/ 3.0, /**/ 1.0, 0.0, 0.0],
                  [0.0, 1.0, 0.0, /**/ 4.0, /**/ 0.0, 0.0, 1.0],
                  [1.0, 0.0, 0.0, /**/ 5.0, /**/ 0.0, 1.0, 0.0],
                  [0.0, 0.0, 1.0, /**/ 0.0, /**/ 0.0, 0.0, 1.0],
                ]));
            expect(labels, equals([
              [1],
              [10],
              [200],
              [300],
              [400],
              [500],
              [700]
            ]));
          });
    });

    test('should decode categorical data', () async {
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data.csv',
          labelIdx: 3,
          rowNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          categoryIndices: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            final decoded = dataFrame.decode(Matrix.fromList([
              [1.0, 0.0, 0.0],
              [0.0, 1.0, 0.0],
              [0.0, 0.0, 1.0],
              [0.0, 1.0, 0.0],
              [0.0, 1.0, 0.0],
              [1.0, 0.0, 0.0],
              [0.0, 0.0, 1.0],
            ]), colName: 'feature_1');
            expect(decoded, equals(['value_1_1', 'value_1_2', 'value_1_3',
            'value_1_2', 'value_1_2', 'value_1_1', 'value_1_3']));
          });
    });

    test('should throw an exception if one tries to decode a data without '
        'providing column name or column index', () async {
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data.csv',
          labelIdx: 3,
          rowNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          categoryIndices: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            expect(() => dataFrame.decode(Matrix.fromList([
              [1.0, 0.0, 0.0],
              [0.0, 1.0, 0.0],
            ])), throwsException);
          });
    });

    test('should throw an exception if one tries to decode a data from headless'
        'dataset providing just a column name', () async {
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data_headless.csv',
          headerExist: false,
          labelIdx: 3,
          rowNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          categoryIndices: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            expect(() => dataFrame.decode(Matrix.fromList([
              [1.0, 0.0, 0.0],
              [0.0, 1.0, 0.0],
            ]), colName: 'feature_1'), throwsException);
          });
    });

    test('should throw an exception if one tries to decode a data providing '
        'unexistent column name', () async {
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data.csv',
          labelIdx: 3,
          rowNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          categoryIndices: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            expect(() => dataFrame.decode(Matrix.fromList([
              [1.0, 0.0, 0.0],
              [0.0, 1.0, 0.0],
            ]), colName: 'country'), throwsException);
          });
    });

    test('should throw a range error if one tries to decode a data providing '
        'improper column index', () async {
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data.csv',
          labelIdx: 3,
          rowNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          categoryIndices: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            expect(() => dataFrame.decode(Matrix.fromList([
              [1.0, 0.0, 0.0],
              [0.0, 1.0, 0.0],
            ]), colIdx: 45), throwsRangeError);
          });
    });

    test('should throw an exception if one tries to decode a data providing '
        'index of non-categorical column', () async {
      await testCsvWithCategories(
          fileName: 'test/test_data/fake_data.csv',
          labelIdx: 3,
          rowNum: 7,
          columns: [
            ZRange.closed(0, 3),
          ],
          categoryIndices: {
            0: CategoricalDataEncodingType.oneHot,
            1: CategoricalDataEncodingType.ordinal,
            2: CategoricalDataEncodingType.oneHot,
          },
          testContentFn: (features, labels, header, dataFrame) {
            expect(() => dataFrame.decode(Matrix.fromList([
              [1.0, 0.0, 0.0],
              [0.0, 1.0, 0.0],
            ]), colIdx: 3), throwsException);
          });
    });
  });
}
