import 'package:ml_linalg/norm.dart';
import 'package:ml_preprocessing/src/normalizer/normalizer.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

PipeableOperatorFn normalize([Norm norm = Norm.euclidean]) =>
        (_) => Normalizer(norm);
