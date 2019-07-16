import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:xrange/zrange.dart';
import 'package:quiver/iterables.dart';

class DataSet {
  DataSet(this._samples, this.outcomeRange, [this.rangeToEncoded]) {
    final indices = count().take(_samples.columnsNum);
    final nominalRanges = rangeToEncoded != null
        ? rangeToEncoded.keys
        : <ZRange>[];
    final allRanges = indices.map(
            (idx) => nominalRanges.firstWhere((range) => range.contains(idx),
                orElse: () => ZRange.singleton(idx)))
        .where((range) => range != outcomeRange);

    _featureRanges = Set.from(allRanges);

    _features = _samples
        .submatrix(columns: ZRange.closedOpen(0, outcomeRange.firstValue));

    _outcome = _samples.submatrix(columns: outcomeRange);
  }

  final ZRange outcomeRange;
  final Map<ZRange, List<Vector>> rangeToEncoded;
  final Matrix _samples;

  Iterable<ZRange> get featureRanges => _featureRanges;
  Iterable<ZRange> _featureRanges;

  Matrix get features => _features;
  Matrix _features;

  Matrix get outcome => _outcome;
  Matrix _outcome;

  bool isColumnNominal(ZRange range)  => rangeToEncoded
      ?.containsKey(range) == true;

  Matrix toMatrix() => _samples;
}
