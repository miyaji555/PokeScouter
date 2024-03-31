import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poke_scouter/constants/route_path.dart';
import 'package:poke_scouter/constants/shared_preferences.dart';
import 'package:poke_scouter/presentation/Widget/battle_widget.dart';
import 'package:poke_scouter/presentation/Widget/show_dialog.dart';
import 'package:poke_scouter/presentation/Widget/tutorial_widget.dart';
import 'package:poke_scouter/presentation/top/top_page_state.dart';
import 'package:poke_scouter/providers/tutorial_provider.dart';
import '../../constants/text_style.dart';
import 'package:poke_scouter/scaffold_messenger.dart';
import '../../constants/tutorial_text.dart';
import '../../feature/battle.dart';
import '../../repository/admob_repository.dart';
import '../../repository/shared_preferences.dart';

class BattleSuggestPage extends ConsumerWidget {
  const BattleSuggestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonListNotifier =
        ref.read(pokemonListProvider(kPageNameBattleStart));
    final admobState = ref.watch(admobRepositoryProvider);
    final showTutorial = ref.watch(showBattleSuggestTutorialProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(kPageNameBattleSuggest),
            actions: [
              IconButton(
                onPressed: () {
                  ref.read(showBattleSuggestTutorialProvider.notifier).state =
                      true;
                  ref
                      .read(sharedPreferencesProvider)
                      .setBool(kSharedPrefsShowTutorialBattleSuggest, true);
                },
                icon: const Icon(Icons.help),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ref.watch(battleSuggestFutureProvider).when(
                    data: (battleWithSimilarities) {
                      if (battleWithSimilarities == null ||
                          battleWithSimilarities.isEmpty) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "似たような対戦相手との対戦履歴がありません。\n対戦履歴を登録することで次に似たパーティと対戦する際に表示されます。",
                            style: textStyleGreyPlain,
                          ),
                        ));
                      }
                      return ListView.builder(
                          // itemCount: battleSuggestState.battles.length,
                          itemCount: battleWithSimilarities.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BattleWidget(
                              battle: battleWithSimilarities[index].battle,
                              pokemonNameList: pokemonListNotifier
                                  .map((pokemon) => pokemon.name)
                                  .toList(),
                            );
                          });
                    },
                    error: (e, __) {
                      return const SizedBox(
                        child: Text("error"),
                      );
                    },
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        )),
              ),
              ElevatedButton(
                child: const Text("対戦登録に進む"),
                onPressed: () async {
                  // 動画をすでに見ていた場合は対戦登録画面に遷移
                  if (admobState.hasShown) {
                    context.push(kPagePathBattleMemo);
                    return;
                  }
                  await showConfirmDialog(
                      context: context,
                      title: "動画広告を視聴して対戦登録に進む。",
                      okText: "視聴する。",
                      function: () async {
                        if (admobState.ad == null) {
                          ref
                              .read(scaffoldMessengerHelperProvider)
                              .showSnackBar("広告を取得中です。数秒後に再度お願いします。");
                          return;
                        }
                        await admobState.showAd(() {
                          context.push(kPagePathBattleMemo);
                        });
                      });
                },
              ),
            ],
          ),
        ),
        TutorialWidget(
            onTap: () {
              ref.read(showBattleSuggestTutorialProvider.notifier).state =
                  false;
              ref
                  .read(sharedPreferencesProvider)
                  .setBool(kSharedPrefsShowTutorialBattleSuggest, false);
            },
            show: showTutorial,
            child: Text(
              kBattleSuggestTutorialMessage,
              style: textStylePlain,
            ))
      ],
    );
  }
}
