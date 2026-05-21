import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            // Tratamento de erro caso a imagem não exista
            errorBuilder: (context, error, stackTrace) {
              return Column(
                children: [
                  const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  Text(context.t('logoNotFound'), style: const TextStyle(color: Colors.grey)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}