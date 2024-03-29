import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../util/pokemon_suggest.dart';

class PokemonTextField extends ConsumerWidget {
  const PokemonTextField(
      {super.key, required this.onSelected, required this.enabled});

  final Function(String title) onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Autocomplete(
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text == "") {
          return <String>[];
        }
        return ref
            .read(pokemonSuggestStateProvider.notifier)
            .getSuggestPokemonName(textEditingValue.text);
      },
      onSelected: onSelected,
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          enabled: enabled,
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: fieldTextEditingController.clear,
              icon: const Icon(Icons.clear),
            ),
          ),
        );
      },
    );
  }
}
