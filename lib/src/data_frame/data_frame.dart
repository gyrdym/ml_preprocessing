import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/data_frame/data_frame_impl.dart';
import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/data_selector/data_selector.dart';
import 'package:quiver/iterables.dart';

/// A structure to store and manipulate data
abstract class DataFrame {
  /**
   * Creates a data_frame from non-typed data.
   *
   * [data] Non-typed data, the first element may be a header of dataset (a
   * collection of strings)
   *
   * [headerExists] Indicates, whether the csv-file header (a sequence of
   * column names) exists or not
   */
  factory DataFrame(Iterable<Iterable<dynamic>> data, {
    bool headerExists,
    Iterable<String> header,
    String autoHeaderPrefix = 'col_',
    Iterable<int> columns,
    Iterable<String> columnNames,
  }) {
    final originalHeader = headerExists
        ? data.first.map((name) => name.toString().trim())
        : <String>[];

    final selected = DataSelector(columns, columnNames, originalHeader)
        .select(data);

    final defaultHeader = header ??
        enumerate(selected.first)
            .map((indexed) => '${autoHeaderPrefix}${indexed.index}');

    final processedHeader = headerExists
        ? selected.first.map((name) => name.toString().trim())
        : defaultHeader;

    final headLessData = headerExists
        ? selected.skip(1)
        : selected;

    return DataFrameImpl(headLessData, processedHeader);
  }

  factory DataFrame.fromSeries(Iterable<Series> series) = DataFrameImpl.fromSeries;

  Iterable<String> get header;

  Iterable<Iterable<dynamic>> get rows;

  Iterable<Series> get series;

  /// Converts the data_frame into Matrix
  Matrix toMatrix([DType dtype = DType.float32]);
}
