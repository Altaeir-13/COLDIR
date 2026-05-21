import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fadir/providers/language_provider.dart';
import 'package:fadir/utils/api_constants.dart'; 
import '../../../widgets/primary_button.dart';
import '../../../widgets/custom_pinput.dart';
import 'package:fadir/screens/core/homePage/home_page.dart'; 

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _pinController = TextEditingController();
  bool isLoading = false;

  // --- LÓGICA DE VALIDAÇÃO REAL ---
  Future<void> _verificarCodigo() async {
    String t(String key) => context.t(key);
    // 1. Validação básica de tamanho
    if (_pinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('enterFullCode')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {

      final response = await http.post(
        Uri.parse(ApiConstants.verificacaoEndpoint), // Usa a URL do ApiConstants
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "codigo": _pinController.text,
        }),
      );

      if (!mounted) return;

      //  VERIFICA SE O JAVA ACEITOU (Status 200)
      if (response.statusCode == 200) {
        
        // SUCESSO!
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t('accountVerified')),
            backgroundColor: Colors.green,
          ),
        );

        // Navega para a Home
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );

      } else {
        // ERRO (Código Errado ou Expirado)
        // O Java mandou erro (400 ou 403), então NÃO muda de tela
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${t('error')}: ${response.body}'), // Mostra a mensagem do Java
            backgroundColor: Colors.red,
          ),
        );
        
        // Limpa o campo para a pessoa tentar de novo
        _pinController.clear();
      }

    } catch (e) {
      // Erro de internet/conexão
      if (kDebugMode) {
        debugPrint('Erro de conexão: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t('serverConnectionError')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => context.t(key);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de Email
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E564D).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 60,
                  color: Color(0xFF0E564D),
                ),
              ),
              
              const SizedBox(height: 30),

              Text(
                t('verifyEmailTitle'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                t('codeSentTo'),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E564D),
                ),
              ),

              const SizedBox(height: 40),

              CustomPinput(
                controller: _pinController,
                onCompleted: (pin) {
                  // Se quiser validar assim que terminar de digitar
                  _verificarCodigo(); 
                },
              ),

              const SizedBox(height: 40),

              PrimaryButton(
                text: t('verificationButton'),
                isLoading: isLoading,
                onPressed: _verificarCodigo,
                backgroundColor: const Color(0xFF0E564D),
                textColor: Colors.white,
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t('resendSoon'))),
                        );
                      },
                child: Text(
                  t('resendCode'),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 150)
            ],
          ),
        ),
      ),
    );
  }
}