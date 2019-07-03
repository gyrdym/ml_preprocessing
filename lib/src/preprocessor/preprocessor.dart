import 'dart:async';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/preprocessor/csv_preprocessor.dart';
import 'package:xrange/zrange.dart';

/// A parser for raw data
abstract class Preprocessor {
  /**
   * Creates a csv-data instance from file.
   *
   * [fileName] Target csv-file name
   *
   * [labelIdx] Position of the label column (by default - the last column).
   * Required parameter.
   *
   * [labelName] Name of a column, where label values are contained
   *
   * [eol] End of line symbol of the csv-file
   *
   * [headerExists] Indicates, whether the csv-file header (a sequence of
   * column names) exists or not
   *
   * [categories] A map, that links category name to the encoder
   * type, which will be used to encode this column's values
   *
   * [categoryIndices] A map, that links category's column index to the
   * encoder type, which will be used to encode this column's values. It only
   * makes sense if [headerExists] is true
   *
   * [encoders] A map, that links categorical data encoder type to the sequence
   * of columns, which are supposed to be encoded with this encoder. If one
   * column is going to be processed at least with two different encoders, an
   * exception will be thrown
   *
   * [rows] Ranges of rows to be read from csv-file. Ranges represented as
   * closed interval, that means that, e.g. `const Tuple2<int, int>(1, 1)` is a
   * valid interval that contains only one value - `1`
   *
   * [columns] Ranges of columns to be read from csv-file. Ranges represented
   * as closed interval, that means that, e.g. `const Tuple2<int, int>(1, 1)`
   * is a valid interval that contains only one value - `1`
   */
  factory Preprocessor.csv(
    String fileName, {
    String eol,
    int labelIdx,
    String labelName,
    bool headerExists,
    String fieldDelimiter,
    Map<String, CategoricalDataEncoderType> categories,
    Map<int, CategoricalDataEncoderType> categoryIndices,
    Map<CategoricalDataEncoderType, Iterable<String>> encoders,
    List<ZRange> rows,
    List<ZRange> columns,
    Type dtype,
  }) = CsvPreprocessor.fromFile;

  /// A data structure, containing just dataset column headers (generally, first
  /// row of a dataset).
  ///
  /// It may be omitted (in this case `null` will be returned)
  Future<List<String>> get header;

  /// Processed and ready to use (by machine learning algorithms) dataset
  /// features.
  ///
  /// Keep in mind, that the number of columns of the feature matrix
  /// may differ from the number of elements in [header] because of categorical
  /// data, that might present in the source dataset
  Future<Matrix> get features;

  /// Processed and ready to use (by machine learning algorithms) dataset
  /// labels (Target values, e.g. class labels or regression values)
  Future<Matrix> get labels;

  /// Categorical data columns indices after the data had been processed
  Future<Set<ZRange>> get encodedColumnRanges;

  /// Decodes given categorical encoded column
  ///
  /// [column] - a matrix, where each row is an encoded categorical value, e.g.
  /// with one-hot encoder
  ///
  /// [colName] - a name of encoded column
  ///
  /// [colIdx] - an index of encoded column
  Iterable<String> decode(Matrix column, {String colName, int colIdx});

  /// Changes order of records in dataset and return new [Preprocessor] with
  /// newly ordered records
  Future<Preprocessor> shuffle();
}
