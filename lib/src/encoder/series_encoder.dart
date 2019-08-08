import 'package:ml_preprocessing/src/data_frame/series.dart';

abstract class SeriesEncoder {
  Iterable<Series> encodeSeries(Series series);
}