/// A type of categorical data encoding
///
/// Algorithms that process data to create prediction models can't handle
/// categorical data, since they are based on mathematical equations and work
/// only with bare numbers. That means that the categorical data should be
/// converted to numbers.
///
/// [EncoderType.label] converts categorical values into integer numbers. Let's
/// say, one has a list of values denoting a level of education:
///
/// ```
/// ['BSc', 'BSc', 'PhD', 'High School', 'PhD']
/// ```
///
/// After applying [EncoderType.label], the source list will be looking
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
///
/// [EncoderType.oneHot] converts categorical values into binary sequences.
/// Let's say, one has a list of values denoting a level of education:
///
/// ```
/// ['BSc', 'BSc', 'PhD', 'High School', 'PhD']
/// ```
///
/// After applying [EncoderType.oneHot], the source sequence will be looking
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
enum EncoderType {
  oneHot,
  label,
}
