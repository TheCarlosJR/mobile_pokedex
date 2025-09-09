import 'package:pokedex/core/constants/poke_enums.dart';

/// Enum para tipagem Pokemon
enum PokeStats implements PokeEnum {
  hp('hp', 'Vida', 0xFFFD5A58),
  attack('attack', 'Ataque', 0xFFF5AB79),
  defense('defense', 'Defesa', 0xFFF7E179),
  spAttack('special-attack', 'Ataque Especial', 0xFF9DB8F5),
  spDefense('special-defense', 'Defesa Especial', 0xFFA6DB8E),
  speed('speed', 'Velocidade', 0xFFFC93AE);

  @override
  final String keyAPI;
  @override
  final String ptBrName;
  @override
  final int colorValue;

  const PokeStats(this.keyAPI, this.ptBrName, this.colorValue);
}
