class Place {
  final String id;
  final String categoryId;
  final String name;
  final String address;
  final double rating;
  final double distance;
  final String imageUrl;
  // Novos campos opcionais (pois locais antigos podem não ter)
  final String? description;
  final String? linkOriginal;

  Place({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.address,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    this.description,
    this.linkOriginal,
  });

  // Fábrica para criar um Place a partir do JSON do Java
  factory Place.fromJson(Map<String, dynamic> json, String defaultCategoryId) {
    return Place(
      // O Java pode retornar 'id' como número, convertemos para String
      id: json['id']?.toString() ?? '', 
      categoryId: defaultCategoryId, // O Java não sabe a categoria, passamos a da tela atual
      name: json['nome'] ?? 'Sem Nome', // No Java é 'nome', no Dart era 'name'
      address: json['endereco'] ?? 'Endereço não detectado',
      rating: 4.5, // Valor padrão para novos locais
      distance: 0.0, // Valor padrão
      imageUrl: json['imagemUrl'] ?? '', // No Java configuramos 'imagemUrl'
      description: json['descricao'],
      linkOriginal: json['linkOriginal'],
    );
  }
}