import 'package:pokedex/core/constants/poke_enums.dart';

/// Tipagem de formato corporal
enum PokeShapes implements PokeEnum {
  ball('ball', 'Esfera', 0xFFFFDB00),
  squiggle('squiggle', 'Rabisco', 0xFF4F4747),
  fish('fish', 'Peixe', 0xFF2992FF),
  arms('arms', 'Braços', 0xFFFFA202),
  blob('blob', 'Mancha', 0xFF6E4570),
  upright('upright', 'Ereto', 0xFFAB7939),
  legs('legs', 'Pernas', 0xFFAB7939),
  quadruped('quadruped', 'Quadrúpede', 0xFF5462D6),
  wings('wings', 'Alado', 0xFF95C9FF),
  tentacles('tentacles', 'Tentáculos', 0xFFFF637F),
  heads('heads', 'Cabeças', 0xFFBCB889),
  humanoid('humanoid', 'Humanoide', 0xFF999999),
  bugWings('bug-wings', 'Asas de inseto', 0xFF9FA424),
  armor('armor', 'Armadura', 0xFF5462D6);

  @override
  final String keyAPI;
  @override
  final String ptBrName;
  @override
  final int colorValue;

  const PokeShapes(this.keyAPI, this.ptBrName, this.colorValue);
}
