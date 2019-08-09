import 'package:ml_preprocessing/src/data_frame/series.dart';

typedef ColumnHeaderTemplateFn = String Function(String label);

abstract class SeriesEncoder {
  Iterable<Series> encodeSeries(Series series);
}