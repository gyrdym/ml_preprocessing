import 'package:ml_preprocessing/src/preprocessor/header_extractor/header_extractor.dart';

abstract class DataFrameHeaderExtractorFactory {
  DataFrameHeaderExtractor create(Iterable<int> indices);
}
