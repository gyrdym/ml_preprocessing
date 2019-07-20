import 'dart:async';

import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
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
   * [categories] A map, that links categorical column name to the encoder
   * type, which will be used to encode this column's values. It only
   * makes sense if [headerExists] is true
   *
   * [categoryIndices] A map, that links categorical column's index to the
   * encoder type, which will be used to encode this column's values.
   *
   * [encoders] A map, that links categorical data encoder type to the sequence
   * of columns, which are supposed to be encoded with this encoder. If one
   * column is going to be processed at least with two different encoders, an
   * exception will be thrown
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
    String fieldDelimiter,
    Map<String, CategoricalDataEncoderType> categories,
    Map<int, CategoricalDataEncoderType> categoryIndices,
    Map<CategoricalDataEncoderType, Iterable<String>> encoders,
    List<ZRange> rows,
    List<ZRange> columns,
    Type dtype,
  }) = CsvPreprocessor.fromFile;

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
