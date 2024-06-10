// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predicted_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PredictedResponse _$PredictedResponseFromJson(Map<String, dynamic> json) {
  return _PredictedResponse.fromJson(json);
}

/// @nodoc
mixin _$PredictedResponse {
  List<PredictedPokemon> get pokemon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PredictedResponseCopyWith<PredictedResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictedResponseCopyWith<$Res> {
  factory $PredictedResponseCopyWith(
          PredictedResponse value, $Res Function(PredictedResponse) then) =
      _$PredictedResponseCopyWithImpl<$Res, PredictedResponse>;
  @useResult
  $Res call({List<PredictedPokemon> pokemon});
}

/// @nodoc
class _$PredictedResponseCopyWithImpl<$Res, $Val extends PredictedResponse>
    implements $PredictedResponseCopyWith<$Res> {
  _$PredictedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pokemon = null,
  }) {
    return _then(_value.copyWith(
      pokemon: null == pokemon
          ? _value.pokemon
          : pokemon // ignore: cast_nullable_to_non_nullable
              as List<PredictedPokemon>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PredictedResponseImplCopyWith<$Res>
    implements $PredictedResponseCopyWith<$Res> {
  factory _$$PredictedResponseImplCopyWith(_$PredictedResponseImpl value,
          $Res Function(_$PredictedResponseImpl) then) =
      __$$PredictedResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PredictedPokemon> pokemon});
}

/// @nodoc
class __$$PredictedResponseImplCopyWithImpl<$Res>
    extends _$PredictedResponseCopyWithImpl<$Res, _$PredictedResponseImpl>
    implements _$$PredictedResponseImplCopyWith<$Res> {
  __$$PredictedResponseImplCopyWithImpl(_$PredictedResponseImpl _value,
      $Res Function(_$PredictedResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pokemon = null,
  }) {
    return _then(_$PredictedResponseImpl(
      pokemon: null == pokemon
          ? _value._pokemon
          : pokemon // ignore: cast_nullable_to_non_nullable
              as List<PredictedPokemon>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictedResponseImpl implements _PredictedResponse {
  const _$PredictedResponseImpl({required final List<PredictedPokemon> pokemon})
      : _pokemon = pokemon;

  factory _$PredictedResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictedResponseImplFromJson(json);

  final List<PredictedPokemon> _pokemon;
  @override
  List<PredictedPokemon> get pokemon {
    if (_pokemon is EqualUnmodifiableListView) return _pokemon;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pokemon);
  }

  @override
  String toString() {
    return 'PredictedResponse(pokemon: $pokemon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictedResponseImpl &&
            const DeepCollectionEquality().equals(other._pokemon, _pokemon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_pokemon));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictedResponseImplCopyWith<_$PredictedResponseImpl> get copyWith =>
      __$$PredictedResponseImplCopyWithImpl<_$PredictedResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictedResponseImplToJson(
      this,
    );
  }
}

abstract class _PredictedResponse implements PredictedResponse {
  const factory _PredictedResponse(
          {required final List<PredictedPokemon> pokemon}) =
      _$PredictedResponseImpl;

  factory _PredictedResponse.fromJson(Map<String, dynamic> json) =
      _$PredictedResponseImpl.fromJson;

  @override
  List<PredictedPokemon> get pokemon;
  @override
  @JsonKey(ignore: true)
  _$$PredictedResponseImplCopyWith<_$PredictedResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
