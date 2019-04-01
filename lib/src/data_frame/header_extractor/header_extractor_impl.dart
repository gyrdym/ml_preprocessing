import 'package:ml_preprocessing/src/data_frame/header_extractor/header_extractor.dart';

class DataFrameHeaderExtractorImpl implements DataFrameHeaderExtractor {
  DataFrameHeaderExtractorImpl(this.indices);

  final Iterable<int> indices;

  @override
  List<String> extract(Iterable<Iterable<dynamic>> data) {
    final headerRow = data.first.toList(growable: false);
    return indices.map((idx) => headerRow[idx].toString())
        .toList(growable: false);
  }
}
