// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Pokemon _$$_PokemonFromJson(Map<String, dynamic> json) => _$_Pokemon(
      name: json['name'] as String,
      number: json['number'] as String,
      h: json['h'] as String,
      a: json['a'] as String,
      b: json['b'] as String,
      c: json['c'] as String,
      d: json['d'] as String,
      s: json['s'] as String,
      sum: json['sum'] as String,
      type1: json['type1'] as String?,
      type2: json['type2'] as String?,
      ability1: json['ability1'] as String?,
      ability2: json['ability2'] as String?,
      hiddenAbility: json['hiddenAbility'] as String?,
    );

Map<String, dynamic> _$$_PokemonToJson(_$_Pokemon instance) =>
    <String, dynamic>{
      'name': instance.name,
      'number': instance.number,
      'h': instance.h,
      'a': instance.a,
      'b': instance.b,
      'c': instance.c,
      'd': instance.d,
      's': instance.s,
      'sum': instance.sum,
      'type1': instance.type1,
      'type2': instance.type2,
      'ability1': instance.ability1,
      'ability2': instance.ability2,
      'hiddenAbility': instance.hiddenAbility,
    };
