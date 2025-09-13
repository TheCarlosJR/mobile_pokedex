import 'package:pokedex/core/utils/utils.dart';

/// Modelo - Evolucao Pokemon
class PokeEvoChainModel {
  final String url;
  final Map<String, String> evoList;

  PokeEvoChainModel({
    required this.url,
    required this.evoList,
  });

  factory PokeEvoChainModel.fromJson(String url, Map<String, dynamic> json) {
    const voidString = '-';
    const yesString = 'Sim';

    //ignora o resto
    json = json['chain'];

    try {
      final getEvoChain = Map<String, String>.fromEntries(
        () sync* {
          //especie base
          yield MapEntry('Evoluiu de',
              Utils.capitalizeFirstLetter('${json['species']['name']}'));

          //itera sobre cada evolucao
          for (var i = 0; i < json['evolves_to'].length; i++) {
            final chain = json['evolves_to'][i];
            final specieTarget =
                Utils.capitalizeFirstLetter('${chain['species']['name']}');

            //itera sobre cada detalhe de evolucao
            for (var j = 0; j < chain['evolution_details'].length; j++) {
              final detail = chain['evolution_details'][j];
              final timeDay = (detail['time_of_day']?.isEmpty
                      ? voidString
                      : '${detail['time_of_day']}') ??
                  voidString;
              final needsRain =
                  (detail['needs_overworld_rain'] ? yesString : voidString) ??
                      voidString;

              yield MapEntry('Evolui para', specieTarget);
              yield MapEntry(
                  'Gatilho',
                  Utils.capitalizeFirstLetter(
                      '${detail['trigger']['name'] ?? voidString}'));

              yield MapEntry('Level', '${detail['min_level'] ?? voidString}');
              yield MapEntry('Gênero', '${detail['gender'] ?? voidString}');
              yield MapEntry(
                  'Segurando', '${detail['held_item'] ?? voidString}');
              yield MapEntry('Item', '${detail['item'] ?? voidString}');
              yield MapEntry('Golpe', '${detail['known_move'] ?? voidString}');
              yield MapEntry('Tipo de golpe',
                  '${detail['known_move_type'] ?? voidString}');

              yield MapEntry('Dados físicos',
                  '${detail['relative_physical_stats'] ?? voidString}');
              yield MapEntry(
                  'Beleza mínima', '${detail['min_beauty'] ?? voidString}');
              yield MapEntry(
                  'Afeição mínima', '${detail['min_affection'] ?? voidString}');
              yield MapEntry('Felicidade mínima',
                  '${detail['min_happiness'] ?? voidString}');

              yield MapEntry('Local', '${detail['location'] ?? voidString}');
              yield MapEntry('Hora', timeDay);
              yield MapEntry('Chuva', needsRain);

              yield MapEntry('Troca de Pokemon',
                  '${detail['trade_species'] ?? voidString}');
              yield MapEntry('Pokemon na equipe',
                  '${detail['party_species'] ?? voidString}');
              yield MapEntry('Tipo de Pokemon na equipe',
                  '${detail['party_type'] ?? voidString}');
            }
          }
        }(),
      );

      return PokeEvoChainModel(
        url: url,
        evoList: getEvoChain,
      );
    } catch (e, stack) {
      throw FormatException(
          "Erro ao converter JSON para PokeSpecieModel:\n\n$e\n$stack");
    }
    //bom exemplo em: https://pokeapi.co/api/v2/evolution-chain/67/
  }
}
