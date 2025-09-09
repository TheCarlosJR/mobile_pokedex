/// Modelo - Pokemon item de lista
class PokeUrlModel {
  final String name;
  final String url;

  PokeUrlModel({
    required this.name,
    required this.url,
  });

  factory PokeUrlModel.fromJson(Map<String, dynamic> json) {
    try {
      return PokeUrlModel(
          name: json['name'],
          url: json['url']);
    } catch(e, stack) {
      throw FormatException(
          "Erro ao converter JSON para PokeListItemModel:\n\n$e\n$stack");
    }
  }
}