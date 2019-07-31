import 'categorical_codec/label_codec_test.dart' as ordinal_encoder_test;
import 'categorical_codec/one_hot_codec_test.dart' as one_hot_encoder_test;
import 'data_frame/data_frame_test.dart' as dataframe_test;
import 'preprocessor/encoding_mapping_processor_impl_test.dart' as encoder_processor_test;
import 'preprocessor/preprocessor_impl_test.dart'
  as csv_preprocessor_integration_test;
import 'preprocessor/preprocessor_impl_with_categories_test.dart'
  as csv_preprocessor_with_categories_integration_test;
import 'preprocessor/records_processor/records_processor_factory_impl_test.dart' as var_extractor_factory_test;
import 'preprocessor/records_processor/records_processor_impl_test.dart' as var_extractor_test;

void main() {
  one_hot_encoder_test.main();
  ordinal_encoder_test.main();
  dataframe_test.main();
  var_extractor_factory_test.main();
  var_extractor_test.main();
  csv_preprocessor_integration_test.main();
  csv_preprocessor_with_categories_integration_test.main();
  encoder_processor_test.main();
}
