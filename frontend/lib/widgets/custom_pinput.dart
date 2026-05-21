import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CustomPinput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onCompleted;

  const CustomPinput({
    super.key, 
    required this.controller, 
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Fundo cinza claro
        borderRadius: BorderRadius.circular(10), // Borda arredondada
        border: Border.all(color: Colors.grey.shade300), // Borda cinza
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: const Color(0xFF0E564D), // Sua cor Verde Escuro
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: const Color(0xFF0E564D).withValues(alpha: 0.1), // Fundo verde bem clarinho
      border: Border.all(color: const Color(0xFF0E564D)),
    );

    return Pinput(
      length: 6, 
      controller: controller,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      
      // Validações e Comportamento
      showCursor: true,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      
      // Callback quando termina de digitar
      onCompleted: onCompleted,
    );
  }
}