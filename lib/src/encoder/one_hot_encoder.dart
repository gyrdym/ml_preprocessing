import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:quiver/iterables.dart';

class OneHotEncoder extends EncoderImpl {
  @override
  Iterable<Iterable<num>> encode(Map<String, int> labelToColumnId,
      Iterable<String> labels) {
    return [
      labels.map((label) => labelToColumnId[label]),
    ];
  }
}
