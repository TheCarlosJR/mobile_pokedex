import 'package:pokedex/core/utils/utils.dart';

import 'package:pokedex/core/constants/poke_enums.dart';
import 'package:pokedex/core/constants/poke_types.dart';
import 'package:pokedex/core/constants/poke_stats.dart';

/// Modelo - Pokemon (resumo)
class PokeDataModel {
  final int id;
  final String name;
  //final List<String> typeKeys;
  final List<String> typeNames;
  final Map<String, String> stats;
  final Map<String, String> moves;
  final Map<String, String> about;
  final String? imageVectorUrl;
  final String imageUrl;
  final String specieUrl;
  final bool fav;

  PokeDataModel({
    required this.id,
    required this.name,
    //required this.typeKeys,
    required this.typeNames,
    required this.stats,
    required this.moves,
    required this.about,
    required this.imageVectorUrl,
    required this.imageUrl,
    required this.specieUrl,
    this.fav = false,
  });

  factory PokeDataModel.fromJson(Map<String, dynamic> json) {
    try {
      //obtem o basico
      final int id = json['id'];
      final String name = Utils.capitalizeFirstLetter(json['name']);
      final String? imageVectorUrl =
          json['sprites']['other']?['dream_world']?['front_default'];
      final String imageUrl = json['sprites']['front_default'];
      final String specieUrl = json['species']['url'];

      /*
      //obtem todos os nomes (id ou chave) dos tipos
      final List<String> getTypeKeys = (json['types'] as List)
          .map((type) =>
            '${type['type']['name']}')
          .toList();
      */

      //obtem todos os nomes (amigavel) dos tipos
      final getTypeNames = (json['types'] as List)
          .map((type) =>
              PokeTypes.values.findByName(type['type']['name'])?.ptBrName ??
                  '${type['type']['name']}')
          .toList();

      //obtem todos as habilidades
      final getAbilities = (json['abilities'] as List)
          .map((ability) =>
              Utils.capitalizeFirstLetter(ability['ability']['name'] as String))
          .toList();

      //obtem todos os estados
      final getStats = Map.fromEntries(
        (json['stats'] as List).map(
          (move) => MapEntry(
            PokeStats.values.findByName(move['stat']['name'])?.ptBrName ?? '${move['stat']['name']}',
            //Utils.capitalizeFirstLetter(move['stat']['name'],),
            '${move['base_stat']}',
          ),
        ),
      );

      //obtem todos os golpes
      final getMovesRaw = (json['moves'] as List)
          .map(
            (move) => MapEntry(
              Utils.capitalizeFirstLetter(move['move']['name']),
              move['version_group_details']
                      [move['version_group_details'].length - 1]
                  ['level_learned_at'] as int,
            ),
          )
          .toList();

      //ordena os entries pelo valor (level_learned_at)
      getMovesRaw.sort((a, b) {
        //se 'a' = zero e 'b' nao - 'a' vai pro final
        if (a.value == 0 && b.value != 0) return 1;

        //se 'b' = zero e 'a' nao - 'b' vai pro final
        if (b.value == 0 && a.value != 0) return -1;

        //se ambos sao iguais - compara a chave
        if (a.value == b.value) return a.key.compareTo(b.key);

        //compara os dois valores - numeros
        return a.value.compareTo(b.value);
      });

      //recria o mapa mas convertendo para String no final
      final getMoves = Map.fromEntries(
        getMovesRaw.map(
          (e) {
            if (e.value == 0) {
              return MapEntry(e.key, '-');
            }
            return MapEntry(e.key, 'Level ${e.value}');
          },
        ),
      );

      //obtem outros dados
      final getAbout = Map.fromEntries({
        MapEntry('Habilidades', getAbilities.join(', ')),
        MapEntry('XP base', '${json['base_experience']}'),
        MapEntry('Altura', '${json['height'] / 10} m'),
        MapEntry('Peso', '${json['weight'] / 10} kg'),
      });

      //cria objeto
      return PokeDataModel(
        id: id,
        name: name,
        //typeKeys: getTypeKeys,
        typeNames: getTypeNames,
        stats: getStats,
        moves: getMoves,
        about: getAbout,
        imageVectorUrl: imageVectorUrl,
        imageUrl: imageUrl,
        specieUrl: specieUrl,
      );
    } catch (e, stack) {
      throw FormatException(
          "Erro ao converter JSON para PokeModel:\n\n$e\n$stack");
    }
  }
}
