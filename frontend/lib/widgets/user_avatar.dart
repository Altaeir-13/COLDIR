import 'package:flutter/material.dart';
import 'dart:io'; // Necessário para verificar arquivos locais

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color? borderColor;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    this.size = 45.0,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? Colors.grey.shade200, 
          width: 1
        ),
        image: _buildDecorationImage(),
      ),
      // Se não tiver imagem, mostra o ícone no centro
      child: _buildPlaceholder(),
    );
  }

  // Lógica para decidir qual imagem mostrar
  DecorationImage? _buildDecorationImage() {
    if (imageUrl == null || imageUrl!.isEmpty) return null;

    ImageProvider? provider;

    if (imageUrl!.startsWith('http')) {
      // 1. Imagem da Internet (URL)
      provider = NetworkImage(imageUrl!);
    } else if (imageUrl!.startsWith('assets/')) {
      // 2. Imagem dos Assets
      provider = AssetImage(imageUrl!);
    } else {
      // 3. Imagem do Arquivo Local
      try {
        final file = File(imageUrl!);
        if (file.existsSync()) {
          provider = FileImage(file);
        }
      } catch (_) {
        // Se der erro ao ler arquivo, ignora
      }
    }

    if (provider != null) {
      return DecorationImage(
        image: provider,
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  // O que mostrar se não houver imagem
  Widget? _buildPlaceholder() {
    // Se a função acima retornou uma imagem, não precisamos de placeholder
    if (_buildDecorationImage() != null) return null;

    // Retorna o ícone padrão
    return Icon(
      Icons.person,
      color: Colors.grey.shade500,
      size: size * 0.6, // Ícone proporcional ao tamanho do container
    );
  }
}