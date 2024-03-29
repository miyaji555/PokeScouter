import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poke_scouter/constants/firestore.dart';
import 'package:poke_scouter/constants/route_path.dart';
import 'package:poke_scouter/constants/shared_preferences.dart';
import 'package:poke_scouter/constants/text_style.dart';
import 'package:poke_scouter/constants/tutorial_text.dart';
import 'package:poke_scouter/providers/tutorial_provider.dart';
import 'package:poke_scouter/repository/admob_repository.dart';

import '../../domain/pokemon.dart';
import '../../feature/party.dart';
import '../../repository/shared_preferences.dart';
import '../../util/pokemon_suggest.dart';
import '../Widget/pokemon_widget.dart';
import '../Widget/show_dialog.dart';
import '../Widget/tutorial_widget.dart';
import '../top/top_page_state.dart';

class BattleMemoPage extends HookConsumerWidget {
  const BattleMemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Pokemon> pokemonListState =
        ref.watch(pokemonListProvider(kPageNameBattleStart));
    final opponentOrder = useState<List<int>>([]);
    final myOrder = useState<List<int>>([]);
    final myOrderNameList = useState<List<String>>([]);
    final memoController = useTextEditingController();
    final result = useState<BattleResult>(BattleResult.win);
    final isLoading = useState<bool>(false);
    final showTutorial = ref.watch(showBattleMemoTutorialProvider);
    List<int> getOrderForView(List<int> order, int partySize) {
      List<int> list = List.filled(partySize, 0);
      for (var i = 0; i < order.length; i++) {
        list[order[i]] = i + 1;
      }
      return list;
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text(kPageNameBattleMemo), actions: [
            IconButton(
                onPressed: () {
                  ref.read(showBattleMemoTutorialProvider.notifier).state =
                      true;
                  ref
                      .read(sharedPreferencesProvider)
                      .setBool(kSharedPrefsShowTutorialBattleMemo, true);
                },
                icon: const Icon(Icons.help))
          ]),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Text(
                    '対戦相手のパーティ',
                    style: textStyleBold,
                  )
                ])),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: InkWell(
                          onDoubleTap: () {
                            if (!opponentOrder.value.contains(index)) {
                              // 選出登録
                              opponentOrder.value = [
                                ...opponentOrder.value,
                                index
                              ];
                            } else {
                              // 選出解除
                              opponentOrder.value = [
                                for (final i in opponentOrder.value)
                                  if (i != index) i,
                              ];
                            }
                          },
                          child: badges.Badge(
                              position: badges.BadgePosition.topStart(),
                              badgeColor: Theme.of(context).primaryColorDark,
                              badgeContent: Text((index + 1).toString()),
                              child: badges.Badge(
                                position: badges.BadgePosition.topEnd(),
                                badgeColor:
                                    Theme.of(context).colorScheme.secondary,
                                showBadge: getOrderForView(opponentOrder.value,
                                        pokemonListState.length)[index] !=
                                    0,
                                badgeContent: Text(getOrderForView(
                                        opponentOrder.value,
                                        pokemonListState.length)[index]
                                    .toString()),
                                child: PokemonWidget(
                                  pokemonListState[index],
                                  initialFolded: true,
                                ),
                              ))),
                    );
                  },
                  childCount: pokemonListState.length,
                )),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Text(
                    '自分のパーティ',
                    style: textStyleBold,
                  ),
                ])),
                SliverList(
                  delegate: ref.watch(partyFutureProvider).when(
                      data: (party) {
                        if (party == null) {
                          return SliverChildListDelegate(
                              [const Text("パーティが選択されていません")]);
                        }
                        return SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final pokemon = ref
                                .read(pokemonSuggestStateProvider.notifier)
                                .getPokemon(party.partyNameList[index]);
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              child: InkWell(
                                  onDoubleTap: () {
                                    // 選出登録
                                    if (!myOrder.value.contains(index)) {
                                      myOrder.value = [...myOrder.value, index];
                                      myOrderNameList.value = [
                                        ...myOrderNameList.value,
                                        party.partyNameList[index]
                                      ];
                                    } else {
                                      // 選出解除
                                      myOrder.value = [
                                        for (final i in myOrder.value)
                                          if (i != index) i,
                                      ];
                                      myOrderNameList.value = [
                                        for (final j in myOrderNameList.value)
                                          if (j != myOrderNameList.value[index])
                                            j
                                      ];
                                    }
                                  },
                                  child: badges.Badge(
                                      position: badges.BadgePosition.topStart(),
                                      badgeColor:
                                          Theme.of(context).primaryColorDark,
                                      badgeContent:
                                          Text((index + 1).toString()),
                                      child: badges.Badge(
                                        position: badges.BadgePosition.topEnd(),
                                        badgeColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        showBadge: getOrderForView(
                                                myOrder.value,
                                                party.partyNameList
                                                    .length)[index] !=
                                            0,
                                        badgeContent: Text(getOrderForView(
                                                myOrder.value,
                                                party.partyNameList
                                                    .length)[index]
                                            .toString()),
                                        child: PokemonWidget(
                                          pokemon!,
                                          initialFolded: true,
                                        ),
                                      ))),
                            );
                          },
                          childCount: party.partyNameList.length,
                        );
                      },
                      error: (e, __) {
                        return SliverChildListDelegate([
                          const SizedBox(
                            child: Text("error"),
                          )
                        ]);
                      },
                      loading: () => SliverChildListDelegate(
                          [const Center(child: CircularProgressIndicator())])),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Text(
                    '対戦メモ',
                    style: textStyleBold,
                  ),
                  TextField(
                    controller: memoController,
                    minLines: 5,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      _ChoiceChip(
                        isSelected: result.value == BattleResult.win,
                        label: "勝利",
                        onSelected: (_) {
                          result.value = BattleResult.win;
                        },
                      ),
                      _ChoiceChip(
                        isSelected: result.value == BattleResult.draw,
                        label: "引き分け",
                        onSelected: (_) {
                          result.value = BattleResult.draw;
                        },
                      ),
                      _ChoiceChip(
                        isSelected: result.value == BattleResult.lose,
                        label: "負け",
                        onSelected: (_) {
                          result.value = BattleResult.lose;
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      isLoading.value = true;
                      await ref
                          .read(pokemonListProvider(kPageNameBattleStart)
                              .notifier)
                          .setBattle(
                              memo: memoController.text,
                              myPartyNameList: myOrderNameList.value,
                              opponentOrder: opponentOrder.value,
                              myOrder: myOrder.value,
                              result: result.value,
                              showLoginDialog: () async {
                                isLoading.value = false;
                                await showConfirmDialog(
                                    context: context,
                                    title: 'ログインしてください。',
                                    okText: 'ログインページを開く。',
                                    message: '過去の対戦を表示するにはログインが必要です。',
                                    function: () {
                                      context.push(kPagePathLogin);
                                    });
                              },
                              onComplete: () {
                                isLoading.value = false;
                                ref.invalidate(admobRepositoryProvider);
                                context.go(kPagePathBattleStart);
                              });
                    },
                    child: const Text("対戦を登録する"),
                  )
                ])),
              ], //子にSliverたちを並べていく
            ),
          ),
        ),
        TutorialWidget(
            onTap: () {
              ref.read(showBattleMemoTutorialProvider.notifier).state = false;
              ref
                  .read(sharedPreferencesProvider)
                  .setBool(kSharedPrefsShowTutorialBattleMemo, false);
            },
            show: showTutorial,
            child: Text(
              kBattleMemoTutorialMessage,
              style: textStylePlain,
            )),
        Visibility(
            visible: isLoading.value,
            child: const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()))),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.isSelected,
    required this.label,
    required this.onSelected,
  });
  final bool isSelected;
  final String label;
  final void Function(bool) onSelected;
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        backgroundColor: Colors.grey[600],
        // darkmode
        selectedColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        onSelected: onSelected);
  }
}
