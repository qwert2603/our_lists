extension ListX<T> on List<T> {
  List<T> toUnmodifiable() => List.unmodifiable(this);

  List<T> sortedBy<K extends Comparable<K>>(K Function(T) key) {
    return List.of(this)
      ..sort((t1, t2) {
        return key(t1).compareTo(key(t2));
      });
  }

  List<T> sortedByDescending<K extends Comparable<K>>(K Function(T) key) {
    return List.of(this)
      ..sort((t1, t2) {
        return -1 * key(t1).compareTo(key(t2));
      });
  }

  List<T> sortedByQ(List<Comparable Function(T)> keys) {
    return List.of(this)
      ..sort((t1, t2) {
        for (final key in keys) {
          final compareTo = key(t1).compareTo(key(t2));
          if (compareTo != 0) return compareTo;
        }
        return 0;
      });
  }
}
