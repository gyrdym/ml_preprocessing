import 'package:ml_preprocessing/src/data_frame/series.dart';

typedef ColumnHeaderTemplateFn = String Function(String label);

abstract class Encoder {
  Iterable<Series> encode(Iterable<String> labels,
      {ColumnHeaderTemplateFn columnHeaderTpl});
}
