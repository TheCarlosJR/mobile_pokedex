import 'package:pokedex/core/constants/poke_enums.dart';
import 'package:pokedex/core/constants/poke_shapes.dart';
import 'package:pokedex/core/constants/poke_habitats.dart';
import 'package:pokedex/core/constants/poke_growth_rate.dart';
import 'package:pokedex/core/constants/poke_generations.dart';

/// Modelo - Especie Pokemon (detalhes)
class PokeSpecieModel {
  final String url;
  final Map<String, String> details;
  final String evoChainUrl;

  PokeSpecieModel({
    required this.url,
    required this.details,
    required this.evoChainUrl,
  });

  factory PokeSpecieModel.fromJson(String url, Map<String, dynamic> json) {
    try {
      final getDetails = Map.fromEntries({
        MapEntry(
            'Corpo',
            PokeShapes.values.findByName(json['shape']['name'])?.ptBrName ??
                '${json['shape']['name']}'),
        MapEntry(
            'Habitat',
            PokeHabitats.values.findByName(json['habitat']['name'])?.ptBrName ??
                '${json['habitat']['name']}'),
        MapEntry(
            'Evolução',
            PokeGrowthRate.values
                    .findByName(json['growth_rate']['name'])
                    ?.ptBrName ??
                '${json['growth_rate']['name']}'),
        MapEntry(
            'Geração',
            PokeGenerations.values
                    .findByName(json['generation']['name'])
                    ?.ptBrName ??
                '${json['generation']['name']}'),
      });

      final getEvoUrl = json['evolution_chain']['url'];

      return PokeSpecieModel(
        url: url,
        details: getDetails,
        evoChainUrl: getEvoUrl,
      );
    } catch (e, stack) {
      throw FormatException(
          "Erro ao converter JSON para PokeSpecieModel:\n\n$e\n$stack");
    }
  }
}
