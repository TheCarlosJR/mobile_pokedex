
/// Enderecos Pokemon
class ApiConsts {

  /// Identificador obrigatorio
  static Map<String, String> thisHeader = {'User-Agent': 'pokedex_app/1.0'};

  /// URL inicial da API
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  static const String pokeEndpoint = '/pokemon';
  static const String pokeSpeciesEndpoint = '/pokemon-species';
  static const String typeDetailEndPoint = '/type';

  /// URL de dados basicos do Pokemon - pelo nome ou ID
  static String pokeDataUrl(String id) => '$baseUrl$pokeEndpoint/$id';

  /// URL de dados da especie do Pokemon
  static String pokeSpecieDataUrl(int id) => '$baseUrl$pokeSpeciesEndpoint/$id';

  /// URL para obter Pokemons paginados
  static String pokemonListUrl(int limit, int offset) =>
      '$baseUrl$pokeEndpoint?limit=$limit&offset=$offset';
}