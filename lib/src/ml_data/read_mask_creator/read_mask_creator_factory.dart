import 'package:logging/logging.dart';
import 'package:ml_preprocessing/src/ml_data/read_mask_creator/read_mask_creator.dart';

abstract class MLDataReadMaskCreatorFactory {
  MLDataReadMaskCreator create(Logger logger);
}