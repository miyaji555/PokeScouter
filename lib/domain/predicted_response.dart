import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:poke_scouter/domain/predicted_pokemon.dart';

part 'predicted_response.freezed.dart';
part 'predicted_response.g.dart';

@freezed
class PredictedResponse with _$PredictedResponse {
  const factory PredictedResponse({
    required List<PredictedPokemon> pokemon,
  }) = _PredictedResponse;

  factory PredictedResponse.fromJson(Map<String, dynamic> json) =>
      _$PredictedResponseFromJson(json);
}
