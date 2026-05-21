import 'package:flutter/material.dart';

class LoginInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isObscure;       // Estado atual (vem do pai)
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool isPassword;      // Define se é campo de senha (para mostrar o olhinho)
  final VoidCallback? onSuffixPressed; // Função para avisar o pai que clicou

  const LoginInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isObscure = false,
    this.isPassword = false, // Padrão false (não mostra olhinho)
    this.keyboardType = TextInputType.text,
    this.onSuffixPressed,    // Recebe a função do pai
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 15.0),
          child: Icon(icon, color: Colors.white, size: 40),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: controller,
                  obscureText: isObscure,
                  keyboardType: keyboardType,
                  style: const TextStyle(color: Colors.black87),
              
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    suffixIcon: isPassword
                        ? IconButton(
                            icon: Icon(
                              // Se está escondido (true), mostra o olho aberto.
                              !isObscure ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            // Quando clica, chama a função do Pai
                            onPressed: onSuffixPressed, 
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}