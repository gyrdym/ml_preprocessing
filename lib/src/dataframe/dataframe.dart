import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/data_selector/data_selector.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe_impl.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec_factory_impl.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/encoding_mapping_processor/mapping_processor_factory_impl.dart';
import 'package:ml_preprocessing/src/encoder/numerical_converter/numerical_converter_impl.dart';
import 'package:ml_preprocessing/src/encoder/records_processor/records_processor_factory_impl.dart';

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
   */
  factory DataFrame(List<List<dynamic>> data, {
    bool headerExists,
    Iterable<int> columns,
    Iterable<String> columnNames,
    Map<String, CategoricalDataEncodingType> columnNameToEncodingType,
    Map<int, CategoricalDataEncodingType> columnIndexToEncodingType,
    Map<CategoricalDataEncodingType, Iterable<String>> encodingTypeToColumnNames,
    DType dtype,
  }) {
    final header = headerExists
        ? data.first.map((name) => name.toString().trim())
        : [];
    final selected = DataSelector(columns, columnNames, header).select(data);
    final encoded = Encoder(
      header,
      columnNameToEncodingType,
      columnIndexToEncodingType,
      encodingTypeToColumnNames,
      CategoricalDataCodecFactoryImpl(),
      NumericalConverterImpl(),
      RecordsProcessorFactoryImpl(),
      EncodingMappingProcessorFactoryImpl(),
      dtype,
    ).encode(selected);

    return DataFrameImpl.fromMatrix(encoded.records, header);
  }

  Iterable<String> get header;

  /// Converts the dataframe into Matrix
  Matrix toMatrix();

  /// Returns a table of match between encoded and original value
  Map<Vector, String> getEncodingTableByColumnId(int id);

  /// Returns a table of match between encoded and original value
  Map<Vector, String> getEncodingTableByColumnName(String name);
}
