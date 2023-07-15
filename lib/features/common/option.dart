typedef ThrowableAsyncFunction<T> = Future<T> Function();

sealed class Option<T> {
  const Option();

  bool get isSome => switch (this) {
        Some(value: _) => true,
        _ => false,
      };

  bool get isNone => switch (this) {
        None() => true,
        _ => false,
      };

  Option<R> map<R>(R Function(T value) mapFunc) => switch (this) {
        Some(:var value) => Some(mapFunc(value)),
        _ => None<R>(),
      };

  R mapOr<R>(R defaultValue, R Function(T value) mapFunc) => switch (this) {
        Some(:var value) => mapFunc(value),
        _ => defaultValue,
      };

  T unwrapOr(T defaultValue) => switch (this) {
        Some(:var value) => value,
        _ => defaultValue,
      };

  Option<R> invert<R>(R value) => switch (this) {
        Some(value: _) => None<R>(),
        None() => Some<R>(value),
      };

  static Future<Option<T>> fromThrowable<T>(
    ThrowableAsyncFunction<T> throwableAsyncFunction,
  ) async {
    try {
      final result = await throwableAsyncFunction();

      return Some(result);
    } catch (e) {
      return const None();
    }
  }

  factory Option.fromNullable(T? nullable) =>
      nullable == null ? None<T>() : Some<T>(nullable);
}

class Some<T> extends Option<T> {
  final T value;

  const Some(this.value);
}

class None<T> extends Option<T> {
  const None();
}
