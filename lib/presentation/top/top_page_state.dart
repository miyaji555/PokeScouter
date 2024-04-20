import 'package:poke_scouter/constants/firestore.dart';
import 'package:poke_scouter/constants/shared_preferences.dart';
import 'package:poke_scouter/domain/pokemon.dart';
import 'package:poke_scouter/providers/auth_controller.dart';
import 'package:poke_scouter/repository/firestore/firebase.dart';
import 'package:poke_scouter/repository/shared_preferences.dart';
import 'package:poke_scouter/scaffold_messenger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trotter/trotter.dart';

final pokemonListProvider =
    StateNotifierProvider.family<PokemonListState, List<Pokemon>, String>(
        (ref, id) => PokemonListState(
              ref.read(firebaseRepositoryProvider),
              ref.read(authControllerProvider.notifier),
              ref.read(scaffoldMessengerHelperProvider),
              ref.read(sharedPreferencesProvider),
            ));

class PokemonListState extends StateNotifier<List<Pokemon>> {
  PokemonListState(this.firebaseRepository, this._authController,
      this.scaffoldMessengerHelper, this.sharedPreferences)
      : super([]);
  final FirebaseRepository firebaseRepository;
  final AuthController _authController;
  final ScaffoldMessengerHelper scaffoldMessengerHelper;
  final SharedPreferences sharedPreferences;

  void addPokemon(Pokemon? pokemon) {
    if (pokemon == null) return;
    state = [...state, pokemon];
  }

  void removePokemon(int index) {
    final length = state.length;
    state = [
      for (var i = 0; i < length; i++)
        if (i != index) state[i],
    ];
  }

  void reorderList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Pokemon item = state.removeAt(oldIndex);
    state = [...state..insert(newIndex, item)];
  }

  List<String> _getPokemonNameList() {
    return state.map((pokemon) => pokemon.name).toList();
  }

  List<int> _getPokemonIdList() {
    return state.map((pokemon) => int.parse(pokemon.number)).toList();
  }

  List<List<String>> getPokemonDivisorList() {
    final primeNumbers =
        state.map((pokemon) => BigInt.parse(pokemon.primeNumber)).toList();

    final primeNumbersComplemented = [
      ...primeNumbers,
      ...List.filled(6 - primeNumbers.length, BigInt.one)
    ];

    final List<List<String>> divisorList = [];
    for (int i = 6; i >= 1; i--) {
      final combinationIndexes = Combinations(i, List.generate(6, (j) => j));
      final List<String> divisor = [];
      for (final indexes in combinationIndexes()) {
        final result = indexes
            .map((index) => primeNumbersComplemented[index])
            .toList()
            .fold(
                BigInt.one, (previousValue, element) => previousValue * element)
            .toString();

        if (!divisor.contains(result) && result != "1") {
          divisor.add(result);
        }
      }
      divisorList.add(divisor);
    }
    return divisorList;
  }

  Future setParty(
      {required String title, required Function showLoginDialog}) async {
    final user = _authController.state;
    if (user == null) {
      await showLoginDialog();
      return;
    }
    final partyId = await firebaseRepository.setParty(
        userId: user.uid,
        name: title,
        partyNameList: _getPokemonNameList(),
        divisorList: getPokemonDivisorList(),
        memo: 'パーティめも',
        eachMemo: {});
    sharedPreferences.setString(kSharedPrefsPartyId, partyId);
    state = [];
    scaffoldMessengerHelper.showSnackBar('登録できました！');
  }

  setBattle(
      {required String memo,
      required List<String> myPartyNameList,
      required List<int> opponentOrder,
      required List<int> myOrder,
      required BattleResult result,
      required Function showLoginDialog,
      required Function onComplete}) async {
    final user = _authController.state;
    if (user == null) {
      await showLoginDialog();
      return;
    }
    final partyId = sharedPreferences.get(kSharedPrefsPartyId) as String?;
    if (partyId == null) {
      scaffoldMessengerHelper.showSnackBar('パーティを選択してください',
          isWarningMessage: true);
      return;
    }
    await firebaseRepository.setBattle(
        userId: user.uid,
        partyId: partyId,
        opponentParty: _getPokemonNameList(),
        myParty: myPartyNameList,
        divisorList: getPokemonDivisorList(),
        opponentOrder: opponentOrder,
        myOrder: myOrder,
        memo: memo,
        eachMemo: {},
        result: result.toString(),
        opponentPartyIds: _getPokemonIdList());

    // 登録成功した場合の処理
    state = [];
    scaffoldMessengerHelper.showSnackBar('登録しました。');
    onComplete();
  }
}
