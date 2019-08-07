import 'dart:math';

import 'package:ml_preprocessing/src/data_frame/data_frame_helpers.dart';
import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:test/test.dart';

void main() {
  group('DataFrame helpers', () {
    group('convertRowsToSeries', () {
      test('should convert rows of dynamic typed data into columns and combine '
          'them with the given column headers', () {
        final headers = ['col_1', 'col_2', 'col_3'];
        final rows = [
          [1,    null,   true ],
          [100,  '23',   false],
          [230,  '11',   false],
          [null, 'text', false],
          [0,    '00',   true ],
        ];
        final series = convertRowsToSeries(headers, rows).toList();

        expect(series, hasLength(3));

        expect(series[0].header, 'col_1');
        expect(series[0].data, [1, 100, 230, null, 0]);

        expect(series[1].header, 'col_2');
        expect(series[1].data, [null, '23', '11', 'text', '00']);

        expect(series[2].header, 'col_3');
        expect(series[2].data, [true, false, false, false, true]);
      });

      test('should return number of columns that is equal to the number of '
          'headers', () {
        final headers = ['col_1', 'col_2'];
        final rows = [
          [1,    null,   true ],
          [100,  '23',   false],
          [230,  '11',   false],
          [null, 'text', false],
          [0,    '00',   true ],
        ];
        final series = convertRowsToSeries(headers, rows).toList();

        expect(series, hasLength(2));

        expect(series[0].header, 'col_1');
        expect(series[0].data, [1, 100, 230, null, 0]);

        expect(series[1].header, 'col_2');
        expect(series[1].data, [null, '23', '11', 'text', '00']);

        expect(() => series[2], throwsRangeError);
      });

      test('should return number of columns that is equal to the number of '
          'headers', () {
        final headers = ['col_1', 'col_2', 'col_3', 'col_4'];
        final rows = [
          [1,    null,   true ],
          [100,  '23',   false],
          [230,  '11',   false],
          [null, 'text', false],
          [0,    '00',   true ],
        ];
        final series = convertRowsToSeries(headers, rows).toList();

        expect(series, hasLength(4));

        expect(series[0].header, 'col_1');
        expect(series[0].data, [1, 100, 230, null, 0]);

        expect(series[1].header, 'col_2');
        expect(series[1].data, [null, '23', '11', 'text', '00']);

        expect(series[2].header, 'col_3');
        expect(series[2].data, [true, false, false, false, true]);

        expect(series[3].header, 'col_4');
        expect(series[3].data, isEmpty);
      });
    });

    group('convertSeriesToRows', () {
      test('should extract rows (transpose series columns) from the given '
          'series collection', () {
        final series = [
          Series('col_1', [1, 2, 3, null, 33]),
          Series('col_2', [true, false, true, true, null]),
          Series('col_3', ['1', '2', '3', '22', '33']),
        ];

        final rows = convertSeriesToRows(series);

        expect(rows, equals([
          [1,    true,  '1' ],
          [2,    false, '2' ],
          [3,    true,  '3' ],
          [null, true,  '22'],
          [33,   null,  '33'],
        ]));
      });
    });
  });
}
