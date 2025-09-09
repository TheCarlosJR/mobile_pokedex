import 'package:pokedex/core/constants/poke_enums.dart';

/// Tipagem de geracao
enum PokeGenerations implements PokeEnum {
  gen1('generation-i', 'Geração 1', 0xFF999999),
  gen2('generation-ii', 'Geração 2', 0xFF42BF24),
  gen3('generation-iii', 'Geração 3', 0xFFFFDB00),
  gen4('generation-iv', 'Geração 4', 0xFFAB7939),
  gen5('generation-v', 'Geração 5', 0xFF95C9FF),
  gen6('generation-vi', 'Geração 6', 0xFF6E4570),
  gen7('generation-vii', 'Geração 7', 0xFF1F1F1F),
  gen8('generation-viii', 'Geração 8', 0xFF5462D6),
  gen9('generation-ix', 'Geração 9', 0xFFFFB1FF);

  @override
  final String keyAPI;
  @override
  final String ptBrName;
  @override
  final int colorValue;

  const PokeGenerations(this.keyAPI, this.ptBrName, this.colorValue);
}
