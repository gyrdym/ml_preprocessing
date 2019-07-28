import 'package:csv/csv.dart';
import 'package:ml_preprocessing/src/data_reader/csv_data_reader.dart';

abstract class DataReader {
  factory DataReader.csv(String fileName, {
    String columnDelimiter,
    String eol
  }) =>
      CsvDataReader(
        fileName,
        CsvCodec(fieldDelimiter: columnDelimiter, eol: eol),
      );

  Future<List<List<dynamic>>> read();
}
