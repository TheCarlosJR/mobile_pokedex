import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive.dart';

import 'package:pokedex/core/constants/api.dart';
import 'package:pokedex/data/models/poke_evochain_model.dart';

/// Repositorio - Pokemon (detalhes da evolucao)
class PokeEvoChainRepo {
  /// Caixa do hive com lista de evolucoes de cada especie de pokemon
  static const _boxName = 'pokemonEvoChainList';

  /// Obtem a cadeia de evolucao do pokemon
  Future<PokeEvoChainModel> getEvoChain({required String url}) async {
    final response = await http.get(
      Uri.parse(
        url,
      ),
      headers: ApiConsts.thisHeader,
    );

    if (response.statusCode == 200) {
      return PokeEvoChainModel.fromJson(
        url,
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
          'Erro ${response.statusCode} ao carregar cadeia de evolução na URL: $url');
    }
  }

  /// Obtem dados da evolucao da especie de um pokemon pela API (usando a ID do pokemon)
  Future<PokeEvoChainModel> _getFromAPI(String url) async {
    //pede maiores informacoes para a API
    final result = await http.get(
      Uri.parse(url),
      headers: ApiConsts.thisHeader,
    );

    //resposta ok
    if (result.statusCode == 200) {
      return PokeEvoChainModel.fromJson(
        url,
        jsonDecode(result.body),
      );
    } else {
      throw Exception(
          'Erro ${result.statusCode} ao carregar dados da evolucao na URL: $url');
    }
  }

  /// Obtem dados da evolucao da especie de um Pokemon pelo disco / cache (usando o nome do pokemon)
  Future<PokeEvoChainModel?> _getFromCache(String url) async {
    try {
      //se NAO existe caixa
      if (!(await Hive.boxExists(_boxName))) {
        return null;
      }

      //procura na lista
      final pokes = Hive.box<PokeEvoChainModel>(_boxName)
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
      throw Exception('Erro ao carregar dados da evolucao no disco: $url');
    }
  }
}
