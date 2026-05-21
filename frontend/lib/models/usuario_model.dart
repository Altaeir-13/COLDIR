class UsuarioModel {
  final int idUsuario;
  final String nome;
  final String email;
  final String? fotoPerfil;
  final String? cargo; 

  UsuarioModel({
    required this.idUsuario,
    required this.nome,
    required this.email,
    this.fotoPerfil,
    this.cargo, 
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      idUsuario: json['idUsuario'] ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      fotoPerfil: json['fotoPerfil'],
      cargo: json['cargo'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nome': nome,
      'email': email,
      'fotoPerfil': fotoPerfil,
      'cargo': cargo,
    };
  }
}