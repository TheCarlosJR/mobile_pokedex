import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive.dart';

import 'package:pokedex/core/constants/api.dart';
import 'package:pokedex/data/models/poke_url_model.dart';

/// Repositorio - Pokemon item de lista
class PokeUrlRepo {

  /// Caixa do hive com lista de urls
  static const _boxName = 'pokemonUrlList';

  /// Obtem lista de URLs de pokemons do cache ou da API - obtem todos disponiveis
  Future<List<PokeUrlModel>> getPokemons() async {

    /*
    //obtem urls do disco (cache)
    final listCache = await _getFromCache();

    //ja tem os dados em cache
    if (listCache.isNotEmpty) {
      return listCache;
    }
    */

    //obtem urls da API
    final listAPI = await _getFromAPI();

    //salva urls no disco (cache)
    await _setToCache(listAPI);

    return listAPI;
  }

  /// Obtem lista de pokemons com paginacao - obtem todos disponiveis
  Future<List<PokeUrlModel>> _getFromAPI({int offset = 0, int limit = 3000}) async {

    final response = await http.get(
      Uri.parse(
          '${ApiConsts.baseUrl}${ApiConsts.pokeEndpoint}?offset=$offset&limit=$limit'),
      headers: ApiConsts.thisHeader,
    );

    //resposta ok
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      //converte resultado em lista de mapas de urls
      return (data['results'] as List)
          .map((pokeEntry) => PokeUrlModel(name: '${pokeEntry['name']}', url: '${pokeEntry['url']}',))
          .toList();
    } else {
      throw Exception('Erro ao carregar lista de Pokémons na API com ${limit-offset} entradas');
    }
  }

  /// Salva lista de urls de Pokemons no disco (cache)
  Future<void> _setToCache(List<PokeUrlModel> list) async {
    try {
      final box = await Hive.openBox<PokeUrlModel>(_boxName);

      //salva no Hive para cache
      await box.clear();
      await box.addAll(list);

      return;
    }
    catch (e) {
      throw Exception('Erro ao salvar lista de Pokémons no disco');
    }
  }

  /// Obtem lista de urls de Pokemons do disco (cache)
  Future<List<PokeUrlModel>> _getFromCache() async {
    try {
      //se NAO existe caixa
      if (!(await Hive.boxExists(_boxName))) {
        return [];
      }

      return Hive.box<PokeUrlModel>(_boxName).values.toList(growable: false);
    } catch(e) {
      throw Exception('Erro ao carregar lista de Pokémons no disco');
    }
  }
}
