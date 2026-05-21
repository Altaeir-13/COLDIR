import 'package:flutter/material.dart';

import 'user_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final VoidCallback? onEditImage;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.phone,
    this.imageUrl,
    this.onEditImage,
  });

  @override
  Widget build(BuildContext context) {
    final Color tealColor = const Color(0xFF0E564D);
    final textTheme = Theme.of(context).textTheme;
    final nameLines = _splitName(name);
    final maxTextWidth = MediaQuery.of(context).size.width * 0.8;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: BoxDecoration(
        color: tealColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Foto de Perfil com Opção de Editar
          GestureDetector(
            onTap: onEditImage,
            child: Stack(
              children: [
                // Container Branco Circular
                Container(
                  padding: const EdgeInsets.all(4), // Espessura da borda branca
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: UserAvatar(
                    imageUrl: imageUrl,
                    size: 100,
                    borderColor: Colors.transparent,
                  ),
                ),
                
                // Ícone de Câmera (Badge) se a função de editar existir
                if (onEditImage != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit, // Ou Icons.camera_alt
                        color: tealColor,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 15),
          
          // Nome do Usuário (quebra apenas se ultrapassar 27 caracteres)
          ...nameLines.map(
            (line) => Text(
              line,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 5),
          
          // Email e telefone em bloco centralizado com largura limitada
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxTextWidth),
            child: Column(
              children: [
                Text(
                  email,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                if (phone != null && phone!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '+55 $phone',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _splitName(String fullName) {
    if (fullName.length <= 27) return [fullName];

    final words = fullName.split(' ');
    final List<String> firstLineWords = [];
    int currentLength = 0;

    for (final word in words) {
      final nextLength = currentLength == 0
          ? word.length
          : currentLength + 1 + word.length; // +1 for space

      if (nextLength <= 27) {
        firstLineWords.add(word);
        currentLength = nextLength;
      } else {
        // word would overflow; break and move remaining words to next line
        break;
      }
    }

    if (firstLineWords.isEmpty) {
      // Fallback: force break at 27 if the first word is already too long
      return [fullName.substring(0, 27), fullName.substring(27)];
    }

    final firstLine = firstLineWords.join(' ');
    final remaining = words.skip(firstLineWords.length).join(' ');
    if (remaining.isEmpty) return [firstLine];
    return [firstLine, remaining];
  }
}