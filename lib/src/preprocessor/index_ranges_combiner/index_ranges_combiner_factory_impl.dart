import 'package:ml_preprocessing/src/preprocessor/index_ranges_combiner/index_ranges_combiner.dart';
import 'package:ml_preprocessing/src/preprocessor/index_ranges_combiner/index_ranges_combiner_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/index_ranges_combiner/index_ranges_combiner_impl.dart';

class IndexRangesCombinerFactoryImpl implements
    IndexRangesCombinerFactory {

  const IndexRangesCombinerFactoryImpl();

  @override
  IndexRangesCombiner create() => IndexRangesCombinerImpl();
}
