import 'categorical_encoder/one_hot_encoder_test.dart' as one_hot_encoder_test;
import 'categorical_encoder/ordinal_encoder_test.dart' as ordinal_encoder_test;
import 'data_set/data_set_test.dart' as data_set_test;
import 'preprocessor/preprocessor_impl_test.dart'
  as csv_preprocessor_integration_test;
import 'preprocessor/preprocessor_impl_with_categories_test.dart'
  as csv_preprocessor_with_categories_integration_test;
import 'preprocessor/encoders_processor_impl_test.dart' as encoder_processor_test;
import 'preprocessor/index_ranges_combiner_impl_test.dart' as index_ranges_combiner_test;
import 'preprocessor/params_validator_impl_test.dart' as params_validator_test;
import 'preprocessor/records_processor/records_processor_factory_impl_test.dart' as var_extractor_factory_test;
import 'preprocessor/records_processor/records_processor_impl_test.dart' as var_extractor_test;

void main() {
  one_hot_encoder_test.main();
  ordinal_encoder_test.main();
  var_extractor_factory_test.main();
  var_extractor_test.main();
  csv_preprocessor_integration_test.main();
  csv_preprocessor_with_categories_integration_test.main();
  encoder_processor_test.main();
  params_validator_test.main();
  index_ranges_combiner_test.main();
  data_set_test.main();
}
