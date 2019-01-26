import 'package:ml_preprocessing/src/raw_data_preprocessor/header_extractor/header_extractor.dart';

abstract class MLDataHeaderExtractorFactory {
  MLDataHeaderExtractor create(List<bool> readMask);
}