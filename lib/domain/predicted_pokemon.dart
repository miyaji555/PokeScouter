import 'package:freezed_annotation/freezed_annotation.dart';

part 'predicted_pokemon.freezed.dart';
part 'predicted_pokemon.g.dart';

@freezed
class PredictedPokemon with _$PredictedPokemon {
  const factory PredictedPokemon({
    required String className,
    required int number,
  }) = _PredictedPokemon;

  factory PredictedPokemon.fromJson(Map<String, dynamic> json) =>
      _$PredictedPokemonFromJson(json);
}
