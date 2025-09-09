import 'package:flutter/material.dart';

/// Constantes caso nao se tenha nenhum valor definido
class PokeEnumConsts {
  static const int colorNoneValue = 0xFFFFFFFF;
  static const Color colorNone = Color(colorNoneValue);
  static const String stringNone = '?';
}

/// Interface que todos os enums vao implementar
abstract class PokeEnum {
  String get keyAPI;
  String get ptBrName;
  int get colorValue;
  int get index; // permite findByID - ja existe no enum
}

/// Extensao generica sobre Iterable<T> para reusar funcos em qualquer enum que implemente PokeEnum
extension PokeEnumUtils<T extends PokeEnum> on Iterable<T> {
  /// Obtem item pela chave (nome na API)
  T? findByName(String key) {
    try {
      return this.firstWhere(
        (t) => t.keyAPI.toLowerCase() == key.toLowerCase(),
        orElse: () => throw Exception('Não encontrado: $key'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Obtem item pelo nome PT BR
  T? findByNamePTBR(String key) {
    try {
      return this.firstWhere(
        (t) => t.ptBrName.toLowerCase() == key.toLowerCase(),
        orElse: () => throw Exception('Não encontrado: $key'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Obtem item pelo ID
  T? findByID(int id) {
    try {
      return this.firstWhere(
        (t) => t.index == id,
        orElse: () => throw Exception('Não encontrado: $id'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Obtem item pelo nome da API ou pelo ID
  T? findByAny({String? key, String? keyPTBR, int? id}) {
    if (keyPTBR != null) return findByNamePTBR(keyPTBR);
    if (key != null) return findByName(key);
    if (id != null) return findByID(id);
    return null;
  }

  /// Obtem cor equivalente (nao existe na API)
  Color getColor({String? key, String? keyPTBR, int? id, Color? notFound}) {
    try {
      final type = findByAny(key: key, keyPTBR: key, id: id);
      return Color(type!.colorValue);
    } catch (e) {
      return notFound ?? PokeEnumConsts.colorNone;
    }
  }

  /// Obtem o nome em portugues do Brasil (nao existe na API)
  String getPtBrName({String? key, int? id, String? notFound}) {
    try {
      final type = findByAny(key: key, id: id);
      return type?.ptBrName ?? (notFound ?? PokeEnumConsts.stringNone);
    } catch (e) {
      return (notFound ?? PokeEnumConsts.stringNone);
    }
  }

  /// Obtem o nome registrado na API
  String getKeyName({String? keyPTBR, int? id, String? notFound}) {
    try {
      final type = findByAny(keyPTBR: keyPTBR, id: id);
      return type?.ptBrName ?? (notFound ?? PokeEnumConsts.stringNone);
    } catch (e) {
      return (notFound ?? PokeEnumConsts.stringNone);
    }
  }
}
