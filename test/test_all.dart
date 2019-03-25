import 'categorical_encoder/encoder_factory_test.dart' as encoder_factory_test;
import 'categorical_encoder/one_hot_encoder_test.dart' as one_hot_encoder_test;
import 'categorical_encoder/ordinal_encoder_test.dart' as ordinal_encoder_test;
import 'data_frame/variables_extractor/variables_extractor_factory_impl_test.dart' as var_extractor_factory_test;
import 'data_frame/variables_extractor/variables_extractor_impl_test.dart' as var_extractor_test;
import 'data_frame/csv_data_frame_integration_test.dart' as csv_df_integration_test;
import 'data_frame/csv_data_frame_with_categories_integration_test.dart' as csv_df_with_categories_integration_test;
import 'data_frame/encoders_processor_impl_test.dart' as encoder_processor_test;
import 'data_frame/params_validator_impl_test.dart' as params_validator_test;
import 'data_frame/read_mask_creator_impl_test.dart' as read_mask_creator_test;

void main() {
  encoder_factory_test.main();
  one_hot_encoder_test.main();
  ordinal_encoder_test.main();
  var_extractor_factory_test.main();
  var_extractor_test.main();
  csv_df_integration_test.main();
  csv_df_with_categories_integration_test.main();
  encoder_processor_test.main();
  params_validator_test.main();
  read_mask_creator_test.main();
}
