// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predicted_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PredictedResponseImpl _$$PredictedResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PredictedResponseImpl(
      pokemon: (json['pokemon'] as List<dynamic>)
          .map((e) => PredictedPokemon.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PredictedResponseImplToJson(
        _$PredictedResponseImpl instance) =>
    <String, dynamic>{
      'pokemon': instance.pokemon,
    };
