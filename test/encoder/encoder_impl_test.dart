import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:test/test.dart';

void main() {
  group('EncoderImpl', () {
    final data = [
      ['first', 'second',     'third',      'fourth'],
      [  1,        'F',   'category_val_1',    10   ],
      [  10,       'F',   'category_val_2',    20   ],
      [  11,       'M',   'category_val_1',    10   ],
      [  21,       'F',   'category_val_2',    30   ],
      [  44,       'M',   'category_val_1',    10   ],
      [  43,       'M',   'category_val_1',    30   ],
      [  55,       'F',   'category_val_3',    10   ],
    ];

    final unseenData = [
      ['first', 'second',     'third',      'fourth'],
      [  1,        'F',   'category_val_5',    10   ],
      [  10,       'F',   'category_val_2',    20   ],
      [  11,       'M',   'category_val_1',    10   ],
    ];

    group('Encoder.oneHot', () {
      test('should encode multiple columns', () {
        final dataFrame = DataFrame(data);
        final encoder = Encoder.oneHot(dataFrame,
            featureNames: ['second', 'third', 'fourth']);
        final encoded = encoder.process(dataFrame);

        encoded.toMatrix();

        expect(encoded.toMatrix(), equals([
          [  1,   1, 0,  1, 0, 0,  1, 0, 0,  ],
          [  10,  1, 0,  0, 1, 0,  0, 1, 0,  ],
          [  11,  0, 1,  1, 0, 0,  1, 0, 0,  ],
          [  21,  1, 0,  0, 1, 0,  0, 0, 1,  ],
          [  44,  0, 1,  1, 0, 0,  1, 0, 0,  ],
          [  43,  0, 1,  1, 0, 0,  0, 0, 1,  ],
          [  55,  1, 0,  0, 0, 1,  1, 0, 0,  ],
        ]));
      });

      test('should use indices to access the needed series while encoding', () {
        final dataFrame = DataFrame(data);
        final encoder = Encoder.oneHot(dataFrame,
            featureIds: [1, 2, 3]);
        final encoded = encoder.process(dataFrame);

        encoded.toMatrix();

        expect(encoded.toMatrix(), equals([
          [  1,   1, 0,  1, 0, 0,  1, 0, 0,  ],
          [  10,  1, 0,  0, 1, 0,  0, 1, 0,  ],
          [  11,  0, 1,  1, 0, 0,  1, 0, 0,  ],
          [  21,  1, 0,  0, 1, 0,  0, 0, 1,  ],
          [  44,  0, 1,  1, 0, 0,  1, 0, 0,  ],
          [  43,  0, 1,  1, 0, 0,  0, 0, 1,  ],
          [  55,  1, 0,  0, 0, 1,  1, 0, 0,  ],
        ]));
      });

      test('should throw error if unknown value handling type is error', () {
        final trainingDataFrame = DataFrame(data);
        final unseenDataDataframe = DataFrame(unseenData);
        final encoder = Encoder.oneHot(
          trainingDataFrame,
          featureNames: ['second', 'third', 'fourth'],
          unknownValueHandlingType: UnknownValueHandlingType.error,
        );
        final actual = () => encoder
            .process(unseenDataDataframe)
            .toMatrix();
        final expected = throwsException;

        expect(actual, expected);
      });

      test('should ignore unknown value if unknown value handling type is ignpre', () {
        final trainingDataFrame = DataFrame(data);
        final unseenDataDataframe = DataFrame(unseenData);
        final encoder = Encoder.oneHot(
          trainingDataFrame,
          featureNames: ['second', 'third', 'fourth'],
          unknownValueHandlingType: UnknownValueHandlingType.ignore,
        );
        final actual = encoder
            .process(unseenDataDataframe)
            .toMatrix();
        final expected = [
          [  1,   1, 0,  0, 0, 0,  1, 0, 0,  ],
          [  10,  1, 0,  0, 1, 0,  0, 1, 0,  ],
          [  11,  0, 1,  1, 0, 0,  1, 0, 0,  ],
        ];

        expect(actual, expected);
      });
    });

    group('Encoder.label', () {
      test('should encode multiple columns', () {
        final dataFrame = DataFrame(data);
        final encoder = Encoder.label(dataFrame,
            featureNames: ['second', 'third', 'fourth']);
        final encoded = encoder.process(dataFrame);

        encoded.toMatrix();

        expect(encoded.toMatrix(), equals([
          [  1,   0,  0,  0,  ],
          [  10,  0,  1,  1,  ],
          [  11,  1,  0,  0,  ],
          [  21,  0,  1,  2,  ],
          [  44,  1,  0,  0,  ],
          [  43,  1,  0,  2,  ],
          [  55,  0,  2,  0,  ],
        ]));
      });

      test('should use indices to access the needed series while encoding', () {
        final dataFrame = DataFrame(data);
        final encoder = Encoder.label(dataFrame, featureIds: [1, 2, 3]);
        final encoded = encoder.process(dataFrame);

        encoded.toMatrix();

        expect(encoded.toMatrix(), equals([
          [  1,   0,  0,  0,  ],
          [  10,  0,  1,  1,  ],
          [  11,  1,  0,  0,  ],
          [  21,  0,  1,  2,  ],
          [  44,  1,  0,  0,  ],
          [  43,  1,  0,  2,  ],
          [  55,  0,  2,  0,  ],
        ]));
      });
    });
  });
}
