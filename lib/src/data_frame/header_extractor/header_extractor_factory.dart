import 'package:ml_preprocessing/src/data_frame/header_extractor/header_extractor.dart';

abstract class DataFrameHeaderExtractorFactory {
  DataFrameHeaderExtractor create(List<bool> readMask);
}
