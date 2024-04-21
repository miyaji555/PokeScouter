// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BattleImpl _$$BattleImplFromJson(Map<String, dynamic> json) => _$BattleImpl(
      userId: json['userId'] as String,
      battleId: json['battleId'] as String,
      partyId: json['partyId'] as String,
      opponentParty: (json['opponentParty'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      myParty:
          (json['myParty'] as List<dynamic>).map((e) => e as String).toList(),
      opponentOrder: (json['opponentOrder'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      myOrder: (json['myOrder'] as List<dynamic>).map((e) => e as int).toList(),
      memo: json['memo'] as String,
      eachMemo: Map<String, String>.from(json['eachMemo'] as Map),
      result: json['result'] as String,
      createdAt: json['createdAt'] == null
          ? const UnionTimestamp.serverTimestamp()
          : alwaysUseServerTimestampUnionTimestampConverter
              .fromJson(json['createdAt'] as Object),
    );

Map<String, dynamic> _$$BattleImplToJson(_$BattleImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'battleId': instance.battleId,
      'partyId': instance.partyId,
      'opponentParty': instance.opponentParty,
      'myParty': instance.myParty,
      'opponentOrder': instance.opponentOrder,
      'myOrder': instance.myOrder,
      'memo': instance.memo,
      'eachMemo': instance.eachMemo,
      'result': instance.result,
      'createdAt': alwaysUseServerTimestampUnionTimestampConverter
          .toJson(instance.createdAt),
    };
