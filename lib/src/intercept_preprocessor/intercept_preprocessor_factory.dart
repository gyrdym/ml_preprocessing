import 'package:ml_preprocessing/src/intercept_preprocessor/intercept_preprocessor.dart';

@deprecated
abstract class InterceptPreprocessorFactory {
  InterceptPreprocessor create(Type dtype, {double scale});
}
