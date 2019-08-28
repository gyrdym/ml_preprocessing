import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/helpers/create_encoder_to_series_mapping.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

class EncoderImpl implements Pipeable, Encoder {
  EncoderImpl(
      DataFrame fittingData,
      EncoderType encoderType,
      SeriesEncoderFactory seriesEncoderFactory, {
        Iterable<int> featureIds,
        Iterable<String> featureNames,
        String encodedHeaderPrefix,
        String encodedHeaderPostfix,
      }) :
        _encoderBySeries = createEncoderToSeriesMapping(
            fittingData, featureNames, featureIds,
            (series) => seriesEncoderFactory.createByType(
              encoderType,
              series,
              headerPostfix: encodedHeaderPostfix,
              headerPrefix: encodedHeaderPrefix,
            ));

  final Map<String, SeriesEncoder> _encoderBySeries;

  @override
  DataFrame process(DataFrame dataFrame) {
    final encoded = dataFrame.series.expand((series) =>
      _encoderBySeries.containsKey(series.name)
          ? _encoderBySeries[series.name].encodeSeries(series)
          : [series]);
    return DataFrame.fromSeries(encoded);
  }

  @override
  DataFrame encode(DataFrame data) => process(data);
}
