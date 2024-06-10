// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predicted_pokemon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PredictedPokemon _$PredictedPokemonFromJson(Map<String, dynamic> json) {
  return _PredictedPokemon.fromJson(json);
}

/// @nodoc
mixin _$PredictedPokemon {
  String get className => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PredictedPokemonCopyWith<PredictedPokemon> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictedPokemonCopyWith<$Res> {
  factory $PredictedPokemonCopyWith(
          PredictedPokemon value, $Res Function(PredictedPokemon) then) =
      _$PredictedPokemonCopyWithImpl<$Res, PredictedPokemon>;
  @useResult
  $Res call({String className, int number});
}

/// @nodoc
class _$PredictedPokemonCopyWithImpl<$Res, $Val extends PredictedPokemon>
    implements $PredictedPokemonCopyWith<$Res> {
  _$PredictedPokemonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? className = null,
    Object? number = null,
  }) {
    return _then(_value.copyWith(
      className: null == className
          ? _value.className
          : className // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PredictedPokemonImplCopyWith<$Res>
    implements $PredictedPokemonCopyWith<$Res> {
  factory _$$PredictedPokemonImplCopyWith(_$PredictedPokemonImpl value,
          $Res Function(_$PredictedPokemonImpl) then) =
      __$$PredictedPokemonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String className, int number});
}

/// @nodoc
class __$$PredictedPokemonImplCopyWithImpl<$Res>
    extends _$PredictedPokemonCopyWithImpl<$Res, _$PredictedPokemonImpl>
    implements _$$PredictedPokemonImplCopyWith<$Res> {
  __$$PredictedPokemonImplCopyWithImpl(_$PredictedPokemonImpl _value,
      $Res Function(_$PredictedPokemonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? className = null,
    Object? number = null,
  }) {
    return _then(_$PredictedPokemonImpl(
      className: null == className
          ? _value.className
          : className // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictedPokemonImpl implements _PredictedPokemon {
  const _$PredictedPokemonImpl({required this.className, required this.number});

  factory _$PredictedPokemonImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictedPokemonImplFromJson(json);

  @override
  final String className;
  @override
  final int number;

  @override
  String toString() {
    return 'PredictedPokemon(className: $className, number: $number)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictedPokemonImpl &&
            (identical(other.className, className) ||
                other.className == className) &&
            (identical(other.number, number) || other.number == number));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, className, number);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictedPokemonImplCopyWith<_$PredictedPokemonImpl> get copyWith =>
      __$$PredictedPokemonImplCopyWithImpl<_$PredictedPokemonImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictedPokemonImplToJson(
      this,
    );
  }
}

abstract class _PredictedPokemon implements PredictedPokemon {
  const factory _PredictedPokemon(
      {required final String className,
      required final int number}) = _$PredictedPokemonImpl;

  factory _PredictedPokemon.fromJson(Map<String, dynamic> json) =
      _$PredictedPokemonImpl.fromJson;

  @override
  String get className;
  @override
  int get number;
  @override
  @JsonKey(ignore: true)
  _$$PredictedPokemonImplCopyWith<_$PredictedPokemonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
