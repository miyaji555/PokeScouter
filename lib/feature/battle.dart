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
