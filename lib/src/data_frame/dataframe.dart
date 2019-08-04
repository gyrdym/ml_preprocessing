import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/data_frame/dataframe_impl.dart';
import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/data_selector/data_selector.dart';
import 'package:tuple/tuple.dart';

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
    Iterable<int> columns,
    Iterable<String> columnNames,
    DType dtype,
  }) {
    final originalHeader = headerExists
        ? data.first.map((name) => name.toString().trim())
        : <String>[];
    final selected = DataSelector(columns, columnNames, originalHeader)
        .select(data);
    return DataFrameImpl(selected, headerExists: headerExists, dtype: dtype);
  }

  factory DataFrame.fromSeries(Iterable<Series> series, {DType dtype}) {
    return null;
  }

  Iterable<String> get header;
  Iterable<Iterable<dynamic>> get rows;
  Iterable<Series> get series;

  /// Converts the data_frame into Matrix
  Matrix toMatrix();
}