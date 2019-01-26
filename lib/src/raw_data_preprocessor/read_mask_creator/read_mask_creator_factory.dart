import 'package:logging/logging.dart';
import 'package:ml_preprocessing/src/raw_data_preprocessor/read_mask_creator/read_mask_creator.dart';

abstract class MLDataReadMaskCreatorFactory {
  MLDataReadMaskCreator create(Logger logger);
}