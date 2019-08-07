import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/data_frame/data_frame.dart';
import 'package:test/test.dart';

void main() {
  group('DataFrame', () {
    test('should initialize from dynamic-typed data without header row', () {
      final data = [
        [  1,   2,    3,  true,   '32'],
        [ 10,  12,  323, false, '1132'],
        [-10, 202, null,  true,  'abs'],
      ];
      final frame = DataFrame(data, headerExists: false);

      expect(frame.header,
          equals(['col_0', 'col_1', 'col_2', 'col_3', 'col_4']));
      expect(frame.rows, equals([
        [  1,   2,    3,  true,   '32'],
        [ 10,  12,  323, false, '1132'],
        [-10, 202, null,  true,  'abs'],
      ]));
      expect(frame.series.map((series) => series.header),
          equals(['col_0', 'col_1', 'col_2', 'col_3', 'col_4']));
      expect(frame.series.map((series) => series.data), equals([
        [1, 10, -10],
        [2, 12, 202],
        [3, 323, null],
        [true, false, true],
        ['32', '1132', 'abs'],
      ]));
    });

    test('should initialize from dynamic-typed data with header row', () {
      final data = [
        ['header_1', 'header_2', 'header_3', 'header_4', 'header_5'],
        [   1,       2,        3,     true,     '32'],
        [  10,      12,      323,    false,   '1132'],
        [ -10,     202,     null,     true,    'abs'],
      ];
      final frame = DataFrame(data, headerExists: true);

      expect(frame.header,
          equals(['header_1', 'header_2', 'header_3', 'header_4', 'header_5']));
      expect(frame.rows, equals([
        [  1,   2,    3,  true,   '32'],
        [ 10,  12,  323, false, '1132'],
        [-10, 202, null,  true,  'abs'],
      ]));
      expect(frame.series.map((series) => series.header),
          equals(['header_1', 'header_2', 'header_3', 'header_4', 'header_5']));
      expect(frame.series.map((series) => series.data), equals([
        [1, 10, -10],
        [2, 12, 202],
        [3, 323, null],
        [true, false, true],
        ['32', '1132', 'abs'],
      ]));
    });

    test('should select columns from source data by their indices', () {
      final data = [
        ['col_1', 'col_2', 'col_3', 'col_4', 'col_5'],
        [   1,       2,        3,     true,     '32'],
        [  10,      12,      323,    false,   '1132'],
        [ -10,     202,     null,     true,    'abs'],
      ];
      final frame = DataFrame(data, headerExists: true, columns: [0, 2, 4]);

      expect(frame.header,
          equals(['col_1', 'col_3', 'col_5']));
      expect(frame.rows, equals([
        [  1,    3,   '32'],
        [ 10,  323, '1132'],
        [-10, null,  'abs'],
      ]));
      expect(frame.series.map((series) => series.header),
          equals(['col_1', 'col_3', 'col_5']));
      expect(frame.series.map((series) => series.data), equals([
        [1, 10, -10],
        [3, 323, null],
        ['32', '1132', 'abs'],
      ]));
    });

    test('should select columns from source data by their names', () {
      final data = [
        ['col_1', 'col_2', 'col_3', 'col_4', 'col_5'],
        [   1,       2,        3,     true,     '32'],
        [  10,      12,      323,    false,   '1132'],
        [ -10,     202,     null,     true,    'abs'],
      ];
      final frame = DataFrame(data, headerExists: true,
          columnNames: ['col_1', 'col_3', 'col_5']);

      expect(frame.header,
          equals(['col_1', 'col_3', 'col_5']));
      expect(frame.rows, equals([
        [  1,    3,   '32'],
        [ 10,  323, '1132'],
        [-10, null,  'abs'],
      ]));
      expect(frame.series.map((series) => series.header),
          equals(['col_1', 'col_3', 'col_5']));
      expect(frame.series.map((series) => series.data), equals([
        [1, 10, -10],
        [3, 323, null],
        ['32', '1132', 'abs'],
      ]));
    });

    test('should convert stored data into matrix', () {
      final data = [
        ['col_1',  'col_2', 'col_3',  'col_4',   'col_5'],
        [  '1',       2,        3,        0,         32 ],
        [   10,      12,      323,      1.5,       1132 ],
        [  -10,     202,     1000,     '1.7',     0.005 ],
      ];
      final frame = DataFrame(data, headerExists: true,
          columnNames: ['col_1', 'col_3', 'col_5']);

      expect(frame.toMatrix(), isA<Matrix>());
    });
  });
}
