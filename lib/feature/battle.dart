import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/route_path.dart';
import '../domain/firebase/battle.dart';
import '../presentation/top/top_page_state.dart';
import '../providers/auth_controller.dart';
import '../repository/firestore/firebase.dart';

final battleSuggestFutureProvider =
    FutureProvider.autoDispose<List<BattleWithSimilarity>?>((ref) {
  final userId = ref.watch(authControllerProvider)?.uid;
  final pokemonIdList = ref
      .read(pokemonListProvider(kPageNameBattleStart).notifier)
      .getPokemonIdList();
  if (userId == null) {
    // 空のリストを返す
    return Future.value(<BattleWithSimilarity>[]);
  }
  return ref
      .read(firebaseRepositoryProvider)
      .fetchBattles(userId, pokemonIdList)
      .then((battles) {
    return battles.map((e) => (battle: e, similarity: 0)).toList();
  });
});

List<BattleWithSimilarity> _generateBattleWithSimilarity(
    List<Battle> battles, List<List<String>> divisorList) {
  return battles.map((battle) {
    final List<List<String>> battleDivisorList = [
      battle.divisorList6,
      battle.divisorList5,
      battle.divisorList4,
      battle.divisorList3,
      battle.divisorList2,
      battle.divisorList1
    ];
    var similarity = 0;

    for (var i = 0; i < 6; i++) {
      final List<String> targetDivisor = divisorList[i];
      final List<String> battleDivisor = battleDivisorList[i];
      if (targetDivisor.any((divisor) => battleDivisor.contains(divisor))) {
        similarity = 6 - i;
        break;
      }
    }

    return (battle: battle, similarity: similarity);
  }).toList();
}

List<BattleWithSimilarity> _filterBattleWithSimilarity(
    List<BattleWithSimilarity> battleWithSimilarity) {
  return battleWithSimilarity.where((battle) => battle.similarity > 3).toList();
}

List<BattleWithSimilarity> _sortBattleWithSimilarity(
    List<BattleWithSimilarity> battleWithSimilarity) {
  battleWithSimilarity.sort((a, b) {
    if (a.similarity == b.similarity) {
      final aDateTime = a.battle.createdAt.dateTime;
      final bDateTime = b.battle.createdAt.dateTime;
      if (aDateTime != null && bDateTime != null) {
        return bDateTime.compareTo(aDateTime);
      }
    }
    return b.similarity.compareTo(a.similarity);
  });
  return battleWithSimilarity;
}
