// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Battle _$BattleFromJson(Map<String, dynamic> json) {
  return _Battle.fromJson(json);
}

/// @nodoc
mixin _$Battle {
  String get userId => throw _privateConstructorUsedError;
  String get battleId => throw _privateConstructorUsedError;
  String get partyId => throw _privateConstructorUsedError;
  List<String> get opponentParty => throw _privateConstructorUsedError;
  List<String> get myParty => throw _privateConstructorUsedError;
  List<int> get opponentOrder => throw _privateConstructorUsedError;
  List<int> get myOrder => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  Map<String, String> get eachMemo => throw _privateConstructorUsedError;
  String get result => throw _privateConstructorUsedError;
  @alwaysUseServerTimestampUnionTimestampConverter
  UnionTimestamp get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BattleCopyWith<Battle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BattleCopyWith<$Res> {
  factory $BattleCopyWith(Battle value, $Res Function(Battle) then) =
      _$BattleCopyWithImpl<$Res, Battle>;
  @useResult
  $Res call(
      {String userId,
      String battleId,
      String partyId,
      List<String> opponentParty,
      List<String> myParty,
      List<int> opponentOrder,
      List<int> myOrder,
      String memo,
      Map<String, String> eachMemo,
      String result,
      @alwaysUseServerTimestampUnionTimestampConverter
      UnionTimestamp createdAt});

  $UnionTimestampCopyWith<$Res> get createdAt;
}

/// @nodoc
class _$BattleCopyWithImpl<$Res, $Val extends Battle>
    implements $BattleCopyWith<$Res> {
  _$BattleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? battleId = null,
    Object? partyId = null,
    Object? opponentParty = null,
    Object? myParty = null,
    Object? opponentOrder = null,
    Object? myOrder = null,
    Object? memo = null,
    Object? eachMemo = null,
    Object? result = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      battleId: null == battleId
          ? _value.battleId
          : battleId // ignore: cast_nullable_to_non_nullable
              as String,
      partyId: null == partyId
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String,
      opponentParty: null == opponentParty
          ? _value.opponentParty
          : opponentParty // ignore: cast_nullable_to_non_nullable
              as List<String>,
      myParty: null == myParty
          ? _value.myParty
          : myParty // ignore: cast_nullable_to_non_nullable
              as List<String>,
      opponentOrder: null == opponentOrder
          ? _value.opponentOrder
          : opponentOrder // ignore: cast_nullable_to_non_nullable
              as List<int>,
      myOrder: null == myOrder
          ? _value.myOrder
          : myOrder // ignore: cast_nullable_to_non_nullable
              as List<int>,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      eachMemo: null == eachMemo
          ? _value.eachMemo
          : eachMemo // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get createdAt {
    return $UnionTimestampCopyWith<$Res>(_value.createdAt, (value) {
      return _then(_value.copyWith(createdAt: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BattleImplCopyWith<$Res> implements $BattleCopyWith<$Res> {
  factory _$$BattleImplCopyWith(
          _$BattleImpl value, $Res Function(_$BattleImpl) then) =
      __$$BattleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String battleId,
      String partyId,
      List<String> opponentParty,
      List<String> myParty,
      List<int> opponentOrder,
      List<int> myOrder,
      String memo,
      Map<String, String> eachMemo,
      String result,
      @alwaysUseServerTimestampUnionTimestampConverter
      UnionTimestamp createdAt});

  @override
  $UnionTimestampCopyWith<$Res> get createdAt;
}

/// @nodoc
class __$$BattleImplCopyWithImpl<$Res>
    extends _$BattleCopyWithImpl<$Res, _$BattleImpl>
    implements _$$BattleImplCopyWith<$Res> {
  __$$BattleImplCopyWithImpl(
      _$BattleImpl _value, $Res Function(_$BattleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? battleId = null,
    Object? partyId = null,
    Object? opponentParty = null,
    Object? myParty = null,
    Object? opponentOrder = null,
    Object? myOrder = null,
    Object? memo = null,
    Object? eachMemo = null,
    Object? result = null,
    Object? createdAt = null,
  }) {
    return _then(_$BattleImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      battleId: null == battleId
          ? _value.battleId
          : battleId // ignore: cast_nullable_to_non_nullable
              as String,
      partyId: null == partyId
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String,
      opponentParty: null == opponentParty
          ? _value._opponentParty
          : opponentParty // ignore: cast_nullable_to_non_nullable
              as List<String>,
      myParty: null == myParty
          ? _value._myParty
          : myParty // ignore: cast_nullable_to_non_nullable
              as List<String>,
      opponentOrder: null == opponentOrder
          ? _value._opponentOrder
          : opponentOrder // ignore: cast_nullable_to_non_nullable
              as List<int>,
      myOrder: null == myOrder
          ? _value._myOrder
          : myOrder // ignore: cast_nullable_to_non_nullable
              as List<int>,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      eachMemo: null == eachMemo
          ? _value._eachMemo
          : eachMemo // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BattleImpl with DiagnosticableTreeMixin implements _Battle {
  const _$BattleImpl(
      {required this.userId,
      required this.battleId,
      required this.partyId,
      required final List<String> opponentParty,
      required final List<String> myParty,
      required final List<int> opponentOrder,
      required final List<int> myOrder,
      required this.memo,
      required final Map<String, String> eachMemo,
      required this.result,
      @alwaysUseServerTimestampUnionTimestampConverter
      this.createdAt = const UnionTimestamp.serverTimestamp()})
      : _opponentParty = opponentParty,
        _myParty = myParty,
        _opponentOrder = opponentOrder,
        _myOrder = myOrder,
        _eachMemo = eachMemo;

  factory _$BattleImpl.fromJson(Map<String, dynamic> json) =>
      _$$BattleImplFromJson(json);

  @override
  final String userId;
  @override
  final String battleId;
  @override
  final String partyId;
  final List<String> _opponentParty;
  @override
  List<String> get opponentParty {
    if (_opponentParty is EqualUnmodifiableListView) return _opponentParty;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_opponentParty);
  }

  final List<String> _myParty;
  @override
  List<String> get myParty {
    if (_myParty is EqualUnmodifiableListView) return _myParty;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myParty);
  }

  final List<int> _opponentOrder;
  @override
  List<int> get opponentOrder {
    if (_opponentOrder is EqualUnmodifiableListView) return _opponentOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_opponentOrder);
  }

  final List<int> _myOrder;
  @override
  List<int> get myOrder {
    if (_myOrder is EqualUnmodifiableListView) return _myOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myOrder);
  }

  @override
  final String memo;
  final Map<String, String> _eachMemo;
  @override
  Map<String, String> get eachMemo {
    if (_eachMemo is EqualUnmodifiableMapView) return _eachMemo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_eachMemo);
  }

  @override
  final String result;
  @override
  @JsonKey()
  @alwaysUseServerTimestampUnionTimestampConverter
  final UnionTimestamp createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Battle(userId: $userId, battleId: $battleId, partyId: $partyId, opponentParty: $opponentParty, myParty: $myParty, opponentOrder: $opponentOrder, myOrder: $myOrder, memo: $memo, eachMemo: $eachMemo, result: $result, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Battle'))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('battleId', battleId))
      ..add(DiagnosticsProperty('partyId', partyId))
      ..add(DiagnosticsProperty('opponentParty', opponentParty))
      ..add(DiagnosticsProperty('myParty', myParty))
      ..add(DiagnosticsProperty('opponentOrder', opponentOrder))
      ..add(DiagnosticsProperty('myOrder', myOrder))
      ..add(DiagnosticsProperty('memo', memo))
      ..add(DiagnosticsProperty('eachMemo', eachMemo))
      ..add(DiagnosticsProperty('result', result))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattleImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.battleId, battleId) ||
                other.battleId == battleId) &&
            (identical(other.partyId, partyId) || other.partyId == partyId) &&
            const DeepCollectionEquality()
                .equals(other._opponentParty, _opponentParty) &&
            const DeepCollectionEquality().equals(other._myParty, _myParty) &&
            const DeepCollectionEquality()
                .equals(other._opponentOrder, _opponentOrder) &&
            const DeepCollectionEquality().equals(other._myOrder, _myOrder) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            const DeepCollectionEquality().equals(other._eachMemo, _eachMemo) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      battleId,
      partyId,
      const DeepCollectionEquality().hash(_opponentParty),
      const DeepCollectionEquality().hash(_myParty),
      const DeepCollectionEquality().hash(_opponentOrder),
      const DeepCollectionEquality().hash(_myOrder),
      memo,
      const DeepCollectionEquality().hash(_eachMemo),
      result,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BattleImplCopyWith<_$BattleImpl> get copyWith =>
      __$$BattleImplCopyWithImpl<_$BattleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BattleImplToJson(
      this,
    );
  }
}

abstract class _Battle implements Battle {
  const factory _Battle(
      {required final String userId,
      required final String battleId,
      required final String partyId,
      required final List<String> opponentParty,
      required final List<String> myParty,
      required final List<int> opponentOrder,
      required final List<int> myOrder,
      required final String memo,
      required final Map<String, String> eachMemo,
      required final String result,
      @alwaysUseServerTimestampUnionTimestampConverter
      final UnionTimestamp createdAt}) = _$BattleImpl;

  factory _Battle.fromJson(Map<String, dynamic> json) = _$BattleImpl.fromJson;

  @override
  String get userId;
  @override
  String get battleId;
  @override
  String get partyId;
  @override
  List<String> get opponentParty;
  @override
  List<String> get myParty;
  @override
  List<int> get opponentOrder;
  @override
  List<int> get myOrder;
  @override
  String get memo;
  @override
  Map<String, String> get eachMemo;
  @override
  String get result;
  @override
  @alwaysUseServerTimestampUnionTimestampConverter
  UnionTimestamp get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BattleImplCopyWith<_$BattleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
