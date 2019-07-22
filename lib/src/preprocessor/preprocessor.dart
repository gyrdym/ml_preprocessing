import 'dart:async';

import 'package:csv/csv.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/data_reader/csv_data_reader.dart';
import 'package:ml_preprocessing/src/preprocessor/preprocessor_impl.dart';
import 'package:xrange/zrange.dart';

/// A parser for raw data
abstract class Preprocessor {
  /**
   * Creates a csv-data instance from file.
   *
   * [fileName] Target csv-file name
   *
   * [labelIdx] Position of the label (outcome) column (by default - the last
   * column)
   *
   * [labelName] Name of a column, where label values (outcomes) are contained
   *
   * [eol] End of line symbol of the csv-file
   *
   * [headerExists] Indicates, whether the csv-file header (a sequence of
   * column names) exists or not
   *
   * [columnNameToEncodingType] A map, that links categorical column name to
   * the encoder type, which will be used to encode this column's values. It
   * only makes sense if [headerExists] is true
   *
   * [columnIndexToEncodingType] A map, that links categorical column's index
   * to the encoder type, which will be used to encode this column's values.
   *
   * [encodingTypeToColumnNames] A map, that links categorical data encoder
   * type to the sequence of columns, which are supposed to be encoded with
   * this encoder. If one column is going to be processed at least with two
   * different encoders, an exception will be thrown
   *
   * [rows] Ranges of rows to be read from csv-file.
   *
   * [columns] Ranges of columns to be read from csv-file
   */
  factory Preprocessor.csv(
    String fileName, {
    String eol,
    int labelIdx,
    String labelName,
    bool headerExists,
    String columnDelimiter,
    Map<String, CategoricalDataEncodingType> columnNameToEncodingType,
    Map<int, CategoricalDataEncodingType> columnIndexToEncodingType,
    Map<CategoricalDataEncodingType, Iterable<String>> encodingTypeToColumnNames,
    List<ZRange> rows,
    List<ZRange> columns,
    DType dtype,
  }) => PreprocessorImpl(
    CsvDataReader(
      fileName,
      CsvCodec(fieldDelimiter: columnDelimiter, eol: eol),
    ),
    labelIdx: labelIdx,
    labelName: labelName,
    headerExists: headerExists,
    columnNameToEncodingType: columnNameToEncodingType,
    columnIndexToEncodingType: columnIndexToEncodingType,
    encodingTypeToColumnName: encodingTypeToColumnNames,
    rows: rows,
    columns: columns,
    dtype: dtype,
  );

  /// Processed and ready to use (by machine learning algorithms) dataset
  ///
  /// Keep in mind, that the number of columns of the feature matrix
  /// may differ from the number of elements in [header] because of categorical
  /// data, that might present in the source dataset
  Future<DataSet> get data;

  /// If categorical data presents in the processed dataset, the field contains
  /// categorical encoders per appropriate categorical column range (range is
  /// used instead of column index because encoded categorical value may
  /// consist of more than one element, therefore one categorical column in
  /// original data may consist of several columns in processed dataset)
  Future<Map<ZRange, CategoricalDataCodec>> get columnRangeToEncoder;
}
