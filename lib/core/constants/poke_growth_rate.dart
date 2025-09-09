import 'package:pokedex/core/constants/poke_enums.dart';

/// Tipagem de crescimento e evolucao
enum PokeGrowthRate implements PokeEnum {
  slow('slow', 'Lento', 0xFF999999),
  medium('medium', 'Médio', 0xFFFFDB00),
  fast('fast', 'Rápido', 0xFFFF612C),
  mediumSlow('medium-slow', 'Médio/Lento', 0xFFFFFFFF),
  slowThenVeryFast(
      'slow-then-very-fast', 'Lento e depois muito rápido', 0xFF1F1F1F),
  fastThenVerySlow(
      'fast-then-very-slow', 'Rápido e epois muito lento', 0xFF42BFFF);

  @override
  final String keyAPI;
  @override
  final String ptBrName;
  @override
  final int colorValue;

  const PokeGrowthRate(this.keyAPI, this.ptBrName, this.colorValue);
}
