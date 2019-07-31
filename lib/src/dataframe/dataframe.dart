import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/data_selector/data_selector.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe_impl.dart';

/// A structure to store and manipulate data
abstract class DataFrame {
  /**
   * Creates a dataframe from non-typed data.
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

  Iterable<String> get header;
  Iterable<Iterable<dynamic>> get rows;
  Iterable<Iterable<dynamic>> get columns;

  /// Converts the dataframe into Matrix
  Matrix toMatrix();
}
