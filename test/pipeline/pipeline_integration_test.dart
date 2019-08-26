import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/pipeable/one_hot_encode.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline.dart';
import 'package:test/test.dart';

void main() {
  group('Pipeline', () {
    test('should create a pipeline, steps of which may return dataframes of '
        'different series length', () {
      final fittingData = DataFrame([
        <dynamic>['first', 'second',     'third',      'fourth'],
        <dynamic>[  1,        'F',   'category_val_1',    10   ],
        <dynamic>[  10,       'F',   'category_val_2',    20   ],
        <dynamic>[  11,       'M',   'category_val_1',    10   ],
        <dynamic>[  21,       'F',   'category_val_2',    30   ],
        <dynamic>[  44,       'M',   'category_val_1',    10   ],
        <dynamic>[  43,       'M',   'category_val_1',    30   ],
        <dynamic>[  55,       'F',   'category_val_3',    10   ],
      ]);

      final pipeline = Pipeline(fittingData, [
        oneHotEncode(columns: [1]),
        oneHotEncode(columns: [2, 3]),
        labelsEncode(columnNames: ['first']),
      ]);

      final result = pipeline.process(fittingData);

      expect(result.rows, equals([
        [  0,  1, 0,  1, 0, 0,  1, 0, 0,  ],
        [  1,  1, 0,  0, 1, 0,  0, 1, 0,  ],
        [  2,  0, 1,  1, 0, 0,  1, 0, 0,  ],
        [  3,  1, 0,  0, 1, 0,  0, 0, 1,  ],
        [  4,  0, 1,  1, 0, 0,  1, 0, 0,  ],
        [  5,  0, 1,  1, 0, 0,  0, 0, 1,  ],
        [  6,  1, 0,  0, 0, 1,  1, 0, 0,  ],
      ]));
    });
  });
}
