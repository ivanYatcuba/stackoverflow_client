abstract class BasePageState<T> {
  List<T> get data;
  bool get hasReachedMax;

  BasePageState<T> copyWith({
    List<T> data,
    bool hasReachedMax,
  });
}
