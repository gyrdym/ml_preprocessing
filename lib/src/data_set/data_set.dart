import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:xrange/zrange.dart';

class DataSet {
  DataSet(this._samples, this._outcomeRange, [this._idxToRange,
      this._rangeToEncoded]);

  final Matrix _samples;
  final ZRange _outcomeRange;
  final Map<int, ZRange> _idxToRange;
  final Map<ZRange, List<Vector>> _rangeToEncoded;

  Matrix get features => _samples
      .submatrix(columns: ZRange.closedOpen(0, _outcomeRange.firstValue));

  Matrix get outcome => _samples.submatrix(columns: _outcomeRange);

  Iterable<ZRange> get columnRanges => Set.from(_idxToRange.values);

  bool isColumnNominal(ZRange range)  => _rangeToEncoded.containsKey(range);

  Matrix toMatrix() => _samples;
}
