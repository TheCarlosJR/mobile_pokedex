import 'package:pokedex/core/constants/poke_enums.dart';

/// Enum para habitacoes Pokemon
enum PokeHabitats implements PokeEnum {
  cave('cave', 'Caverna', 0xFF98A068),
  forest('forest', 'Floresta', 0xFF489078),
  grassland('grassland', 'Campina', 0xFF68B020),
  mountain('mountain', 'Montanha', 0xFFC8D0B8),
  rare('rare', 'Raro', 0xFFC878F8),
  roughTerrain('rough-terrain', 'Terreno irregular', 0xFFE0D8A0),
  sea('sea', 'Mar', 0xFF4070E0),
  urban('urban', 'Urbano', 0xFFB0A8C0),
  watersEdge('waters-edge', 'Margem', 0xFF98D8E8);

  @override
  final String keyAPI;
  @override
  final String ptBrName;
  @override
  final int colorValue;

  const PokeHabitats(this.keyAPI, this.ptBrName, this.colorValue);
}
