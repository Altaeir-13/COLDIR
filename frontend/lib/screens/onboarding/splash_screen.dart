import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Configuração do controlador da animação (2 segundos de duração)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animação de Opacidade (Fade In)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Animação de Escala (Zoom suave)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Inicia a animação
    _controller.forward();

    // Configura o timer para mudar de tela após 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      // CORREÇÃO: Verifica se o widget ainda está montado na tela
      // antes de tentar usar o contexto para navegar.
      if (!mounted) return;

      // pushReplacement remove a Splash da pilha (botão voltar não volta pra ela)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Importante limpar o controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco limpo
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Seu Logo
                    Image.asset(
                      'assets/logo.png',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.school, size: 100, color: Color(0xFF0E564D));
                      },
                    ),
                    const SizedBox(height: 50),
                    
                    // Indicador de carregamento discreto
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0E564D)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}