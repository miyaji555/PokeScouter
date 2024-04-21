import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poke_scouter/util/union_timestamp.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants/firestore.dart';

part 'battle.freezed.dart';

part 'battle.g.dart';

@freezed
class Battle with _$Battle {
  const factory Battle({
    required String userId,
    required String battleId,
    required String partyId,
    required List<String> opponentParty,
    required List<String> myParty,
    required List<int> opponentOrder,
    required List<int> myOrder,
    required String memo,
    required Map<String, String> eachMemo,
    required String result,
    @alwaysUseServerTimestampUnionTimestampConverter
    @Default(UnionTimestamp.serverTimestamp())
    UnionTimestamp createdAt,
  }) = _Battle;

  factory Battle.fromJson(Map<String, Object?> json) => _$BattleFromJson(json);

  factory Battle.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Battle.fromJson(<String, dynamic>{...data, kFieldBattleId: ds.id});
  }
}

typedef BattleWithSimilarity = ({Battle battle, int similarity});
