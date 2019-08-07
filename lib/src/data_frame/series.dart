class Series<T> {
  Series(this.header, this.data);

  final String header;
  final Iterable<T> data;
}
