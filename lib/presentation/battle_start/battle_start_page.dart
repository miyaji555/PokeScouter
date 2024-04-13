import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as badges;
import 'package:poke_scouter/constants/route_path.dart';
import 'package:poke_scouter/constants/shared_preferences.dart';
import 'package:poke_scouter/constants/text_style.dart';
import 'package:poke_scouter/constants/tutorial_text.dart';
import 'package:poke_scouter/presentation/Widget/pokemon_textfield.dart';
import 'package:poke_scouter/presentation/Widget/pokemon_widget.dart';
import 'package:poke_scouter/presentation/Widget/tutorial_widget.dart';
import 'package:poke_scouter/presentation/top/top_page_state.dart';
import 'package:poke_scouter/providers/tutorial_provider.dart';
import 'package:poke_scouter/repository/shared_preferences.dart';
import 'package:poke_scouter/util/pokemon_suggest.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/pokemon.dart';

class BattleStartPage extends HookConsumerWidget {
  const BattleStartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonListNotifier =
        ref.read(pokemonListProvider(kPageNameBattleStart).notifier);
    List<Pokemon> pokemonListState =
        ref.watch(pokemonListProvider(kPageNameBattleStart));
    final showFirstTutorial = ref.watch(showFirstTutorialProvider);
    final showTutorial = ref.watch(showBattleStartTutorialProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(kPageNameBattleStart),
            actions: [
              IconButton(
                onPressed: () {
                  ref.read(showBattleStartTutorialProvider.notifier).state =
                      true;
                  ref.read(showFirstTutorialProvider.notifier).state = true;
                  ref
                      .read(sharedPreferencesProvider)
                      .setBool(kSharedPrefsShowTutorialFirst, true);
                  ref
                      .read(sharedPreferencesProvider)
                      .setBool(kSharedPrefsShowTutorialBattleStart, true);
                },
                icon: const Icon(Icons.help),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PokemonTextField(
                  enabled: pokemonListState.length < 6,
                  onSelected: (String pokemonName) {
                    pokemonListNotifier.addPokemon(ref
                        .read(pokemonSuggestStateProvider.notifier)
                        .getPokemon(pokemonName));
                  },
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: pokemonListState.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      key: ValueKey(index),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: InkWell(
                          onDoubleTap: () {
                            pokemonListNotifier.removePokemon(index);
                          },
                          child: badges.Badge(
                              position: badges.BadgePosition.topStart(),
                              badgeColor: Theme.of(context).primaryColorDark,
                              badgeContent: Text((index + 1).toString()),
                              child: PokemonWidget(pokemonListState[index]))),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    pokemonListNotifier.reorderList(oldIndex, newIndex);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: pokemonListState.isEmpty
                    ? null
                    : () {
                        callHelloWorld();
                        // context.push(kPagePathBattleSuggest);
                        primaryFocus?.unfocus();
                      },
                child: const Text("過去の対戦"),
              ),
            ],
          ),
        ),
        // 対戦開始画面のチュートリアル
        TutorialWidget(
          onTap: () {
            ref.read(showBattleStartTutorialProvider.notifier).state = false;
            ref
                .read(sharedPreferencesProvider)
                .setBool(kSharedPrefsShowTutorialBattleStart, false);
          },
          show: !showFirstTutorial && showTutorial,
          child: Text(
            kBattleStartTutorialMessage,
            style: textStylePlain,
          ),
        ),
        // 初回起動時のチュートリアル
        TutorialWidget(
          onTap: () {
            ref.read(showFirstTutorialProvider.notifier).state = false;
            ref
                .read(sharedPreferencesProvider)
                .setBool(kSharedPrefsShowTutorialFirst, false);
          },
          show: showFirstTutorial,
          child: Text(
            kFirstTutorialMessage,
            style: textStylePlain,
          ),
        ),
      ],
    );
  }

  Future<void> callHelloWorld() async {
    final FirebaseFunctions functions = FirebaseFunctions.instance;
    try {
      final HttpsCallable callable = functions.httpsCallable('helloWorld');
      final results = await callable();
      print('The function returned: ${results.data}');
    } catch (e) {
      print('Caught Firebase Functions Exception:');
      print(e);
    }
  }
}
