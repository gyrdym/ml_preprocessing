import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:quiver/iterables.dart';
import 'package:xrange/zrange.dart';

class DataSet {
  DataSet(this._records, {
    ZRange outcomeColumnRange,
    this.rangeToEncoded,
  }) : outcomeColumnRange =
      outcomeColumnRange ?? ZRange.singleton(_records.columnsNum - 1)
  {
    final indices = count().take(_records.columnsNum);
    final nominalRanges = rangeToEncoded != null
        ? rangeToEncoded.keys
        : <ZRange>[];
    final allRanges = indices.map(
            (idx) => nominalRanges.firstWhere((range) => range.contains(idx),
                orElse: () => ZRange.singleton(idx)))
        .where((range) => range != outcomeColumnRange);

    _featureRanges = Set.from(allRanges);

    _features = _records
        .submatrix(columns: ZRange.closedOpen(0, outcomeColumnRange
        .firstValue));

    _outcome = _records.submatrix(columns: outcomeColumnRange);
  }

  final ZRange outcomeColumnRange;
  final Map<ZRange, List<Vector>> rangeToEncoded;
  final Matrix _records;

  Iterable<ZRange> get featureRanges => _featureRanges;
  Iterable<ZRange> _featureRanges;

  Matrix get features => _features;
  Matrix _features;

  Matrix get outcome => _outcome;
  Matrix _outcome;

  bool isColumnNominal(ZRange range)  => rangeToEncoded
      ?.containsKey(range) == true;

  Matrix toMatrix() => _records;
}
