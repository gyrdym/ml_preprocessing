// Macbook air mid 2017 approx. 13 sec
import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter_impl.dart';

class VariablesExtractorBenchmark extends BenchmarkBase {
  VariablesExtractorBenchmark() : super('VariablesExtractor benchmark');

  final numOfRows = 10000;
  final numOfColumns = 40;
  final categoricalColumnsRatio = .5;
  final toFloatConverter = ToFloatNumberConverterImpl();
  List<List<Object>> observations;
  List<int> rowIndices;
  List<int> columnIndices;
  Map<int, CategoricalDataEncodingType> encoders;

  List<List<Object>> generateObservations() {
    final list = <List<Object>>[];
    for (int i = 0; i < numOfRows; i++) {
      final row = <Object>[];
      for (int j = 0; j < numOfColumns; j++) {
        row.add(math.Random().nextInt(30).toString());
      }
      list.add(row);
    }
    return list;
  }

  static void main() {
    VariablesExtractorBenchmark().report();
  }

  @override
  void run() {
    RecordsProcessorImpl(
      observations,
      columnIndices,
      rowIndices,
      encoders,
      toFloatConverter,
    ).extractRecords();
  }

  @override
  void setup() {
    observations = generateObservations();
    rowIndices = List.generate(numOfRows, (i) => i);
    columnIndices = List.generate(numOfColumns, (i) => i);
    encoders = Map.fromIterable(
      List.generate((numOfColumns * categoricalColumnsRatio).round(), (i) => i),
      key: (el) => el,
      value: (el) => CategoricalDataEncodingType.oneHot,
    );
  }
}

Future main() async {
  VariablesExtractorBenchmark.main();
}