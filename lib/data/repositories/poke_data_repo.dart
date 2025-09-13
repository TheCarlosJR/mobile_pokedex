import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive.dart';

import 'package:pokedex/core/constants/api.dart';
import 'package:pokedex/data/models/poke_url_model.dart';
import 'package:pokedex/data/models/poke_data_model.dart';

/// Repositorio - Pokemon (resumo)
class PokeDataRepo {

  /// Caixa do hive com lista de dados basicos de pokemons
  static const _boxName = 'pokemonBasicList';

  /// Obtem dados basicos de pokemons (com paginacao)
  Future<List<PokeDataModel>> getPokemons({
    required List<dynamic> urlList,
    int limit = 4, //TODO mudar para 20
    int offset = 0,
  }) async {
    //se nao tem conteudo
    if (urlList.isEmpty || urlList.length <= offset) {
      return [];
    }

    //obtem o valor que pode ser entregue
    final total = min(urlList.length, offset + limit);

    //itera todos os selecionados
    final futures = List.generate(
      total - offset,
      (index) async {
        try {
          //obtem url do objeto
          final url = urlList[offset + index].url;

          //tenta obter do cache
          final poke = await _getFromCache(url);

          //se nulo tenta obter da API
          return poke ?? await _getFromAPI(url);
        } catch (e) {
          throw Exception('$e #${offset + index}');
        }
      },
    );

    //aguarda e retorna listas
    return await Future.wait(futures);
  }

  /// Obtem dados basicos de um pokemon pela API (usando a URL do pokemon)
  Future<PokeDataModel> _getFromAPI(String url) async {
    //pede maiores informacoes para a API
    final result = await http.get(
      Uri.parse(url),
      headers: ApiConsts.thisHeader,
    );

    //resposta ok
    if (result.statusCode == 200) {
      return PokeDataModel.fromJson(jsonDecode(result.body));
    } else {
      throw Exception('Erro ${result.statusCode} ao carregar Pokémon');
    }
  }

  /// Obtem dados basicos de um Pokemon pelo disco / cache (usando o nome do pokemon)
  Future<PokeDataModel?> _getFromCache(String name) async {
    try {
      //se NAO existe caixa
      if (!(await Hive.boxExists(_boxName))) {
        return null;
      }

      //procura na lista
      final pokes = Hive.box<PokeDataModel>(_boxName)
          .values
          .where((poke) => (poke.name == name))
          .toList();

      //se nada encontrado
      if (pokes.isEmpty) {
        return null;
      }

      //retorna o primeiro
      return pokes[0];
    } catch (e) {
      throw Exception('Erro ao carregar lista de Pokémons no disco');
    }
  }

  /*
  /// Obtem dados de um pokemon pelo nome ou id
  Future<PokeDataModel> getPokemon(String key) async {
    final response = await http.get(
      Uri.parse(ApiConsts.pokeDataUrl(key)),
      headers: ApiConsts.thisHeader,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PokeDataModel.fromJson(json);
    } else {
      throw Exception('Erro ao carregar Pokémon: $key');
    }
  }
   */
}
