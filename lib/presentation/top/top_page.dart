import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/constants/route_path.dart';
import 'package:flutter_template/presentation/Widget/pokemon_widget.dart';
import 'package:flutter_template/presentation/top/top_page_state.dart';
import 'package:flutter_template/repository/admob_repository.dart';
import 'package:flutter_template/providers/admob_id_provider.dart';
import 'package:flutter_template/util/logger.dart';
import 'package:flutter_template/util/pokemon_suggest.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/pokemon.dart';

class TopPage extends HookConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonListNotifier = ref.read(pokemonListProvider.notifier);
    List<Pokemon> pokemonListState = ref.watch(pokemonListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(kPageNameTop),
        actions: [
          IconButton(
            onPressed: () {
              context.push(kPagePathLogin);
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Autocomplete(
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text == "") {
                  return <String>[];
                }
                return ref
                    .read(pokemonSuggestStateProvider.notifier)
                    .getSuggestPokemonName(textEditingValue.text);
              },
              onSelected: (String pokemonName) {
                pokemonListNotifier.addPokemon(ref
                    .read(pokemonSuggestStateProvider.notifier)
                    .getPokemon(pokemonName));
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: fieldTextEditingController.clear,
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: pokemonListState.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  key: ValueKey(pokemonListState[index]),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: InkWell(
                      onDoubleTap: () {
                        pokemonListNotifier.removePokemon(index);
                      },
                      child: Badge(
                          position: BadgePosition.topStart(),
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
            onPressed: () async {
              await ref.read(admobRepositoryProvider).load();
            },
            child: const Text("Party登録"),
          ),
        ],
      ),
    );
  }
}
