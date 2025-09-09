import 'package:pokedex/core/constants/poke_enums.dart';

/// Enum para tipagem Pokemon
enum PokeTypes implements PokeEnum {
  normal('normal', 'Normal', 0xFF999999),
  fighting('fighting', 'Lutador', 0xFFFFA202),
  flying('flying', 'Voador', 0xFF95C9FF),
  poison('poison', 'Venenoso', 0xFF994DCF),
  ground('ground', 'Terra', 0xFFAB7939),
  rock('rock', 'Pedra', 0xFFBCB889),
  bug('bug', 'Inseto', 0xFF9FA424),
  ghost('ghost', 'Fantasma', 0xFF6E4570),
  steel('steel', 'Aço', 0xFF1F1F1F),
  fire('fire', 'Fogo', 0xFFFF612C),
  water('water', 'Água', 0xFF2992FF),
  grass('grass', 'Grama', 0xFF42BF24),
  electric('electric', 'Elétrico', 0xFFFFDB00),
  psychic('psychic', 'Psíquico', 0xFFFF637F),
  ice('ice', 'Gelo', 0xFF42BFFF),
  dragon('dragon', 'Dragão', 0xFF5462D6),
  dark('dark', 'Sombrio', 0xFF4F4747),
  fairy('fairy', 'Fada', 0xFFFFB1FF);

  @override
  final String keyAPI;
  @override
  final String ptBrName;
  @override
  final int colorValue;

  const PokeTypes(this.keyAPI, this.ptBrName, this.colorValue);
}

//final abc = PokeTypes.values.findByName('Dragon');

