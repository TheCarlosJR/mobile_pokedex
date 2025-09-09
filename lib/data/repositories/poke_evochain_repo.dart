import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pokedex/core/constants/api.dart';
import 'package:pokedex/data/models/poke_evochain_model.dart';

/// Repositorio - Pokemon (detalhes da evolucao)
class PokeEvoChainRepo {
  /// Obtem a cadeia de evolucao do pokemon
  Future<PokeEvoChainModel> getEvoChain({required String url}) async {
    final response = await http.get(
      Uri.parse(
        url,
      ),
      headers: ApiConsts.thisHeader,
    );

    if (response.statusCode == 200) {
      return PokeEvoChainModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ${response.statusCode} ao carregar cadeia de evolução na URL: $url');
    }
  }
}