import 'package:ml_dataframe/ml_dataframe.dart';

typedef ColumnHeaderTemplateFn = String Function(String label);

abstract class SeriesEncoder {
  Iterable<Series> encodeSeries(Series series);
}
