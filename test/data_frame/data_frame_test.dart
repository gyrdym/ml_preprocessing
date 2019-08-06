import 'package:ml_preprocessing/src/data_frame/dataframe.dart';
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

      expect(frame.header, equals([]));
      expect(frame.rows, equals([
        [  1,   2,    3,  true,   '32'],
        [ 10,  12,  323, false, '1132'],
        [-10, 202, null,  true,  'abs'],
      ]));
      expect(frame.columns, equals([
        [1, 10, -10],
        [2, 12, 202],
        [3, 323, null],
        [true, false, true],
        ['32', '1132', 'abs'],
      ]));
    });

    test('should initialize from dynamic-typed data with header row', () {
      final data = [
        ['col_1', 'col_2', 'col_3', 'col_4', 'col_5'],
        [   1,       2,        3,     true,     '32'],
        [  10,      12,      323,    false,   '1132'],
        [ -10,     202,     null,     true,    'abs'],
      ];
      final frame = DataFrame(data, headerExists: true);

      expect(frame.header,
          equals(['col_1', 'col_2', 'col_3', 'col_4', 'col_5']));
      expect(frame.rows, equals([
        [  1,   2,    3,  true,   '32'],
        [ 10,  12,  323, false, '1132'],
        [-10, 202, null,  true,  'abs'],
      ]));
      expect(frame.columns, equals([
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
      expect(frame.columns, equals([
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
      expect(frame.columns, equals([
        [1, 10, -10],
        [3, 323, null],
        ['32', '1132', 'abs'],
      ]));
    });
  });
}
