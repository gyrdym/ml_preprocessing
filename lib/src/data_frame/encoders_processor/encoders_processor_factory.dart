import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/data_frame/encoders_processor/encoders_processor.dart';

abstract class EncodersProcessorFactory {
  EncodersProcessor create(
      List<String> header,
      CategoricalDataEncoderFactory encoderFactory,
      [DType dtype]
  );
}
