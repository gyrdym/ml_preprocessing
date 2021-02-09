import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:ml_preprocessing/src/standardizer/standardizer.dart';

PipeableOperatorFn standardize() =>
        (DataFrame fittingData, {dtype = DType.float32}) =>
            Standardizer(fittingData, dtype: dtype!);
