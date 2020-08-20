import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/label_series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/one_hot_series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';

class SeriesEncoderFactoryImpl implements SeriesEncoderFactory {
  const SeriesEncoderFactoryImpl();

  @override
  SeriesEncoder createByType(EncoderType type, Series fittingData, {
    String headerPrefix = '',
    String headerPostfix = '',
    UnknownValueHandlingType unknownValueHandlingType,
  }) {
    switch (type) {
      case EncoderType.label:
        return LabelSeriesEncoder(
          fittingData,
          headerPrefix: headerPrefix,
          headerPostfix: headerPostfix,
          unknownValueHandlingType: unknownValueHandlingType,
        );

      case EncoderType.oneHot:
        return OneHotSeriesEncoder(
          fittingData,
          headerPrefix: headerPrefix,
          headerPostfix: headerPostfix,
          unknownValueHandlingType: unknownValueHandlingType,
        );

      default:
        throw UnsupportedError('Unsupported encoder type - $type');
    }
  }
}
