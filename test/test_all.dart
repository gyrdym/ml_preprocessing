import 'data_frame/data_frame_test.dart' as dataframe_test;
import 'encoder/label_codec_test.dart' as ordinal_encoder_test;
import 'encoder/one_hot_codec_test.dart' as one_hot_encoder_test;

void main() {
  dataframe_test.main();
  one_hot_encoder_test.main();
  ordinal_encoder_test.main();
}
