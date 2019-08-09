import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory.dart';

class SeriesEncoderFactoryImpl implements SeriesEncoderFactory {
  @override
  SeriesEncoder createByType(EncoderType type, Series fittingData, {
    String headerPrefix,
    String headerPostfix,
  }) {
    switch (type) {
      case EncoderType.label:
        return LabelSeriesEncoder(
            fittingData,
            headerPrefix: headerPrefix,
            headerPostfix: headerPostfix
        );
      case EncoderType.oneHot:
        return OneHotSeriesEncoder(
            fittingData,
            headerPrefix: headerPrefix,
            headerPostfix: headerPostfix
        );
      default:
        throw UnsupportedError('Unsupported encoder type - $type');
    }
  }
}
