import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pokedex/core/constants/api.dart';
import 'package:pokedex/data/models/poke_specie_model.dart';

/// Repositorio - Pokemon (detalhes da especie)
class PokeSpecieRepo {
  /// Obtem a especie do pokemon
  Future<PokeSpecieModel> getSpecie({required int id}) async {
    final response = await http.get(
      Uri.parse(
        ApiConsts.pokeSpecieDataUrl(id),
      ),
      headers: ApiConsts.thisHeader,
    );

    if (response.statusCode == 200) {
      return PokeSpecieModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ${response.statusCode} ao carregar espécie de Pokémon na URL: ${ApiConsts.pokeSpecieDataUrl(id)}');
    }
  }
}