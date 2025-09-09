import '../../core/constants/limits.dart';

/// Funcoes de utilidade publica
class Utils {
  /// Obtem primeira letra maiuscula e restante minuscula de uma string
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Obtem string de ID formatada
  static String formatPokeID(int id) {
    return id.toString().padLeft(Limits.idWidth, '0');
  }
}