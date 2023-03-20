// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Option<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) some,
    required TResult Function() none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T value)? some,
    TResult? Function()? none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? some,
    TResult Function()? none,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Some<T> value) some,
    required TResult Function(None<T> value) none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Some<T> value)? some,
    TResult? Function(None<T> value)? none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Some<T> value)? some,
    TResult Function(None<T> value)? none,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptionCopyWith<T, $Res> {
  factory $OptionCopyWith(Option<T> value, $Res Function(Option<T>) then) =
      _$OptionCopyWithImpl<T, $Res, Option<T>>;
}

/// @nodoc
class _$OptionCopyWithImpl<T, $Res, $Val extends Option<T>>
    implements $OptionCopyWith<T, $Res> {
  _$OptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SomeCopyWith<T, $Res> {
  factory _$$SomeCopyWith(_$Some<T> value, $Res Function(_$Some<T>) then) =
      __$$SomeCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T value});
}

/// @nodoc
class __$$SomeCopyWithImpl<T, $Res>
    extends _$OptionCopyWithImpl<T, $Res, _$Some<T>>
    implements _$$SomeCopyWith<T, $Res> {
  __$$SomeCopyWithImpl(_$Some<T> _value, $Res Function(_$Some<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_$Some<T>(
      freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$Some<T> implements Some<T> {
  const _$Some(this.value);

  @override
  final T value;

  @override
  String toString() {
    return 'Option<$T>.some(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Some<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SomeCopyWith<T, _$Some<T>> get copyWith =>
      __$$SomeCopyWithImpl<T, _$Some<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) some,
    required TResult Function() none,
  }) {
    return some(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T value)? some,
    TResult? Function()? none,
  }) {
    return some?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? some,
    TResult Function()? none,
    required TResult orElse(),
  }) {
    if (some != null) {
      return some(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Some<T> value) some,
    required TResult Function(None<T> value) none,
  }) {
    return some(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Some<T> value)? some,
    TResult? Function(None<T> value)? none,
  }) {
    return some?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Some<T> value)? some,
    TResult Function(None<T> value)? none,
    required TResult orElse(),
  }) {
    if (some != null) {
      return some(this);
    }
    return orElse();
  }
}

abstract class Some<T> implements Option<T> {
  const factory Some(final T value) = _$Some<T>;

  T get value;
  @JsonKey(ignore: true)
  _$$SomeCopyWith<T, _$Some<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NoneCopyWith<T, $Res> {
  factory _$$NoneCopyWith(_$None<T> value, $Res Function(_$None<T>) then) =
      __$$NoneCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$NoneCopyWithImpl<T, $Res>
    extends _$OptionCopyWithImpl<T, $Res, _$None<T>>
    implements _$$NoneCopyWith<T, $Res> {
  __$$NoneCopyWithImpl(_$None<T> _value, $Res Function(_$None<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$None<T> implements None<T> {
  const _$None();

  @override
  String toString() {
    return 'Option<$T>.none()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$None<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) some,
    required TResult Function() none,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T value)? some,
    TResult? Function()? none,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? some,
    TResult Function()? none,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Some<T> value) some,
    required TResult Function(None<T> value) none,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Some<T> value)? some,
    TResult? Function(None<T> value)? none,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Some<T> value)? some,
    TResult Function(None<T> value)? none,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class None<T> implements Option<T> {
  const factory None() = _$None<T>;
}
