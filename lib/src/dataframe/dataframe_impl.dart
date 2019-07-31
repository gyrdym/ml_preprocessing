import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe.dart';
import 'package:quiver/iterables.dart';

class DataFrameImpl implements DataFrame {
  DataFrameImpl(this._data, {
    bool headerExists = true,
    DType dtype,
  }) :
        header = headerExists
            ? _data.first.map((name) => name.toString().trim())
            : [],
        rows = _data.skip(headerExists ? 1 : 0),
        columns = _data.skip(headerExists ? 1 : 0)
            .fold<Iterable<Iterable<dynamic>>>(
              List.filled(_data.first.length, []),
              (columns, row) => zip([columns, row.map((el) => [el])])
                  .map((pair) => [...pair.first, ...pair.last]),
            ),
        _typedData = null,
        _dtype = dtype ?? DType.float32;

  final DType _dtype;
  final Iterable<Iterable<dynamic>> _data;
  final Matrix _typedData;

  @override
  final Iterable<String> header;

  @override
  final Iterable<Iterable<dynamic>> rows;

  @override
  final Iterable<Iterable<dynamic>> columns;

  @override
  Matrix toMatrix() => _typedData;
}
