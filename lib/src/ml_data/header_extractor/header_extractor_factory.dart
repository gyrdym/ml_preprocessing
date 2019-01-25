import 'package:ml_preprocessing/src/ml_data/header_extractor/header_extractor.dart';

abstract class MLDataHeaderExtractorFactory {
  MLDataHeaderExtractor create(List<bool> readMask);
}