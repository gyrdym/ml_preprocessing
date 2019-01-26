import 'package:logging/logging.dart';
import 'package:ml_preprocessing/src/raw_data_preprocessor/labels_extractor/labels_extractor.dart';
import 'package:ml_preprocessing/src/raw_data_preprocessor/labels_extractor/labels_extractor_factory.dart';
import 'package:ml_preprocessing/src/raw_data_preprocessor/labels_extractor/labels_extractor_impl.dart';
import 'package:ml_preprocessing/src/raw_data_preprocessor/value_converter/value_converter.dart';

class MLDataLabelsExtractorFactoryImpl implements MLDataLabelsExtractorFactory {
  const MLDataLabelsExtractorFactoryImpl();

  @override
  MLDataLabelsExtractor create(List<List<Object>> records, List<bool> readMask, int labelIdx,
      MLDataValueConverter valueConverter, Logger logger) =>
      MLDataLabelsExtractorImpl(records, readMask, labelIdx, valueConverter, logger);
}
