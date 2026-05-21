class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.text,
    required this.createdAt,
  });

  // Converte o JSON vindo da API Java para o objeto Dart
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id']?.toString() ?? '',
      // Mapeamento baseado no DTO do backend
      userId: map['usuarioId']?.toString() ?? '',
      userName: map['nomeUsuario'] ?? 'Usuário',
      userAvatar: map['fotoUsuario'],
      text: map['texto'] ?? '',
      
      // Tratamento de data (PostgreSQL timestamp para DateTime)
      createdAt: map['dataCriacao'] != null 
          ? DateTime.parse(map['dataCriacao']) 
          : DateTime.now(),
    );
  }
}