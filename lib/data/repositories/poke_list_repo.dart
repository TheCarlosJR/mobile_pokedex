import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pokedex/core/constants/api.dart';
import 'package:pokedex/data/models/poke_list_model.dart';

/// Repositorio - Pokemon (resumo)
class PokeRepo {
  /// Obtem lista de pokemons com paginacao
  Future<List<PokeListModel>> getPokemons({int offset = 0, int limit = 10}) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConsts.baseUrl}${ApiConsts.pokeEndpoint}?offset=$offset&limit=$limit'),
      headers: ApiConsts.thisHeader,
    );

    //resposta ok
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      //converte resultado em lista de urls
      final results = (data['results'] as List)
          .map((poke) => poke['url'] as String)
          .toList();

      //para cada item da lista pega objeto com json (depois todos em uma lista)
      final pokeObjs = await Future.wait(
        results.map((pokeUrl) async {
          final pokeRes = await http.get(
            Uri.parse(pokeUrl),
            headers: ApiConsts.thisHeader,
          );

          //resposta ok
          if (pokeRes.statusCode == 200) {
            return PokeListModel.fromJson(jsonDecode(pokeRes.body));
          } else {
            throw Exception(
                'Erro ${pokeRes.statusCode} ao carregar Pokémon na URL: $pokeUrl');
          }
        }),
      );

      return pokeObjs;
    } else {
      throw Exception('Erro ao carregar lista de Pokémons no offset $offset com $limit entradas');
    }
  }

  /// Obtem dados de um pokemon pelo nome ou id
  Future<PokeListModel> getPokemon(String key) async {
    final response = await http.get(
      Uri.parse(ApiConsts.pokeDataUrl(key)),
      headers: ApiConsts.thisHeader,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PokeListModel.fromJson(json);
    } else {
      throw Exception('Erro ao carregar Pokémon: $key');
    }
  }
}
