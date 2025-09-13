import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive.dart';

import 'package:pokedex/core/constants/api.dart';
import 'package:pokedex/data/models/poke_specie_model.dart';

/// Repositorio - Pokemon (detalhes da especie)
class PokeSpecieRepo {
  /// Caixa do hive com lista de especies de pokemon
  static const _boxName = 'pokemonSpecieList';

  /// Obtem a especie do pokemon
  Future<PokeSpecieModel> getSpecie({required String url}) async {
    try {
      //tenta obter do cache
      final poke = await _getFromCache(url);

      //se nulo tenta obter da API
      return poke ?? await _getFromAPI(url);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Obtem dados detalhados (especie) de um pokemon pela API (usando a ID do pokemon)
  Future<PokeSpecieModel> _getFromAPI(String url) async {
    //pede maiores informacoes para a API
    final result = await http.get(
      Uri.parse(url),
      headers: ApiConsts.thisHeader,
    );

    //resposta ok
    if (result.statusCode == 200) {
      return PokeSpecieModel.fromJson(
        url,
        jsonDecode(result.body),
      );
    } else {
      throw Exception(
          'Erro ${result.statusCode} ao carregar espécie de Pokémon na URL: $url');
    }
  }

  /// Obtem dados detalhados (especie) de um Pokemon pelo disco / cache (usando o nome do pokemon)
  Future<PokeSpecieModel?> _getFromCache(String url) async {
    try {
      //se NAO existe caixa
      if (!(await Hive.boxExists(_boxName))) {
        return null;
      }

      //procura na lista
      final pokes = Hive.box<PokeSpecieModel>(_boxName)
          .values
          .where((poke) => (poke.url == url))
          .toList();

      //se nada encontrado
      if (pokes.isEmpty) {
        return null;
      }

      //retorna o primeiro
      return pokes[0];
    } catch (e) {
      throw Exception('Erro ao carregar dados da especie no disco: $url');
    }
  }
}
