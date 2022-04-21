import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

/// Categorical data encoder factory.
///
/// Algorithms that process data to create prediction models can't handle
/// categorical data, since they are based on mathematical equations and work
/// only with bare numbers. That means that the categorical data should be
/// converted to numbers.
///
/// The factory exposes different ways to convert categorical data into numbers.
abstract class Encoder implements Pipeable {
  /// Gets columns by [columnIndices] or [columnNames] ([columnIndices] has a
  /// precedence over [columnNames]) from [fittingData], collects all unique
  /// values from the columns and builds a map `raw value` => `encoded value`.
  /// Once one calls the [process] method, the mapping will be applied.
  ///
  /// The mapping is built according to the following rules:
  ///
  /// Let's say, one has a list of values denoting a level of education:
  ///
  /// ```
  /// ['BSc', 'BSc', 'PhD', 'High School', 'PhD']
  /// ```
  ///
  /// After applying the encoder, the source sequence will be looking
  /// like this:
  ///
  /// ```
  /// [[1, 0, 0], [1, 0, 0], [0, 1, 0], [0, 0, 1], [0, 1, 0]]
  /// ```
  ///
  /// In other words, the `one-hot` encoder created the following mapping:
  ///
  /// `BSc` => [1, 0, 0]
  ///
  /// `PhD` => [0, 1, 0]
  ///
  /// `High School` => [0, 0, 1]
  factory Encoder.oneHot(
    DataFrame fittingData, {
    Iterable<int>? columnIndices,
    Iterable<String>? columnNames,
    UnknownValueHandlingType unknownValueHandlingType =
        defaultUnknownValueHandlingType,
  }) =>
      EncoderImpl(
        fittingData,
        EncoderType.oneHot,
        const SeriesEncoderFactoryImpl(),
        columnNames: columnNames,
        columnIndices: columnIndices,
        unknownValueHandlingType: unknownValueHandlingType,
      );

  /// Gets columns by [columnIndices] or [columnNames] ([columnIndices] has a
  /// precedence over [columnNames]) from [fittingData], collects all unique
  /// values from the columns and builds a map `raw value` => `encoded value`.
  /// Once one calls the [process] method, the mapping will be applied.
  ///
  /// The mapping is built according to the following rules:
  ///
  /// Let's say, one has a list of values denoting a level of education:
  ///
  /// ```
  /// ['BSc', 'BSc', 'PhD', 'High School', 'PhD']
  /// ```
  ///
  /// After applying the encoder, the source list will be looking
  /// like this:
  ///
  /// ```
  /// [0, 0, 1, 2, 1]
  /// ```
  ///
  /// In other words, the `label` encoder created the following mapping:
  ///
  /// `BSc` => 0
  ///
  /// `PhD` => 1
  ///
  /// `High School` => 2
  factory Encoder.label(
    DataFrame fittingData, {
    Iterable<int>? columnIndices,
    Iterable<String>? columnNames,
    UnknownValueHandlingType unknownValueHandlingType =
        defaultUnknownValueHandlingType,
  }) =>
      EncoderImpl(
        fittingData,
        EncoderType.label,
        const SeriesEncoderFactoryImpl(),
        columnNames: columnNames,
        columnIndices: columnIndices,
        unknownValueHandlingType: unknownValueHandlingType,
      );
}
