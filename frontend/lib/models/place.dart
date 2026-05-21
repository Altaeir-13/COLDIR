class Place {
  final String id;
  final String categoryId;
  final String name;
  final String address;
  final double rating;
  final double distance;
  
  // Variáveis seguras
  final String imageUrl; 
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

  factory Place.fromJson(Map<String, dynamic> json, String defaultCategoryId) {
    // Tenta pegar o endereço de texto, se não tiver, usa o genérico
    String end = json['enderecoTexto'] ?? 'Endereço não informado';
    // Se veio a cidade, concatena
    if (json['cidadeTexto'] != null && json['cidadeTexto'].toString().isNotEmpty) {
      end += " - ${json['cidadeTexto']}";
    }

    return Place(
      id: json['id']?.toString() ?? DateTime.now().toString(),
      categoryId: defaultCategoryId,
      name: json['nome'] ?? 'Novo Local',
      address: end,
      rating: 4.5,
      distance: 0.0,
      
      // O Java manda 'imagemUrl' (camelCase ou snake_case dependendo da config)
      // Testamos os dois para garantir
      imageUrl: json['imagemUrl'] ?? json['imagem_url'] ?? '', 
      
      description: json['descricao'],
      linkOriginal: json['linkOriginal'],
    );
  }
}