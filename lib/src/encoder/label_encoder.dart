import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/encoder_helpers.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';

class LabelEncoder extends EncoderImpl {
  @override
  Iterable<Series> encode(Iterable<String> labels,
      {ColumnHeaderTemplateFn columnHeaderTpl}) {
    final labelToColumnId = getLabelToColumnIdMapping(labels);
    return [
      Series('', labels.map((label) => labelToColumnId[label])),
    ];
  }
}
