import 'dart:convert';

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:ml_preprocessing/src/preprocessor/data_reader/data_reader.dart';

class CsvDataReader implements DataReader {
  CsvDataReader(String fileName, this._csvCodec) : _file = File(fileName);

  final CsvCodec _csvCodec;
  final File _file;

  @override
  Future<List<List<dynamic>>> extractData() =>
      _file.openRead()
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(_csvCodec.decoder)
          .toList();
}
