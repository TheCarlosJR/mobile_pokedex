import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pokedex/core/constants/api.dart';
import 'package:pokedex/data/models/poke_url_model.dart';

/// Repositorio - Pokemon item de lista
class PokeUrlRepo {

  /// Obtem lista de pokemons com paginacao - obtem todos disponiveis
  Future<List<PokeUrlModel>> getPokemons({int offset = 0, int limit = 3000}) async {
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
      throw Exception('Erro ao carregar lista de Pokémons com ${limit-offset} entradas');
    }
  }
}