import 'package:freezed_annotation/freezed_annotation.dart';

part 'option.freezed.dart';

@freezed
class Option<T> with _$Option<T> {
  const factory Option.some(T value) = Some<T>;
  const factory Option.none() = None<T>;

  factory Option.fromNullable(T? value) =>
      value == null ? None<T>() : Some<T>(value);
}
