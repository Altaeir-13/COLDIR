import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:fadir/providers/language_provider.dart';
import 'package:fadir/services/auth_service.dart';
import 'package:fadir/services/secure_storage_service.dart';
import 'package:fadir/providers/user_provider.dart';
import 'package:fadir/screens/core/homePage/home_page.dart';
import 'package:fadir/widgets/logo_app.dart';
import 'package:fadir/widgets/login_input_field.dart';
import 'package:fadir/screens/onboarding/registration_page.dart';
import 'package:fadir/widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;
  bool _rememberLogin = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedLogin();
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberedLogin() async {
    final remember = await SecureStorageService.getRememberLogin();
    final savedEmail = await SecureStorageService.getRememberedEmail() ?? '';
    final savedPassword = await SecureStorageService.getRememberedPassword() ?? '';

    if (!mounted) return;

    setState(() {
      _rememberLogin = remember;
      if (remember) {
        emailController.text = savedEmail;
        senhaController.text = savedPassword;
      }
    });
  }

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);
    String t(String key) => context.t(key);

    try {
      final authService = AuthService();
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (emailController.text.isEmpty || senhaController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t('fillRequiredFields'))));
        // Importante: parar a execução aqui se estiver vazio
        setState(() => isLoading = false);
        return;
      }

      if (!emailController.text.endsWith("@acad.ifma.edu.br")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t('needInstitutionalEmail')),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => isLoading = false);
        return;
      }

      // 1. Faz o Login na API
      final result = await authService.login(
        emailController.text.trim(),
        senhaController.text.trim(),
      );

      if (!mounted) return;

      // ==========================================================
      // 👇 MUDANÇA IMPORTANTE AQUI: SALVAR O ID NA MEMÓRIA SEGURA
      // ==========================================================

      // O backend Java geralmente manda o campo como 'id' ou 'idUsuario'.
      // O '0' é um valor de segurança caso venha nulo.
      int idUsuario = result['id'] ?? result['idUsuario'] ?? 0;

      await SecureStorageService.setIdUsuario(idUsuario);
      await SecureStorageService.setEmail(emailController.text.trim());
      await SecureStorageService.setEmailUsuario(emailController.text.trim());

      if (_rememberLogin) {
        await SecureStorageService.setRememberLogin(true);
        await SecureStorageService.setRememberedEmail(emailController.text.trim());
        await SecureStorageService.setRememberedPassword(senhaController.text);
      } else {
        await SecureStorageService.removeRememberLogin();
        await SecureStorageService.removeRememberedEmail();
        await SecureStorageService.removeRememberedPassword();
      }
      if (kDebugMode) {
        debugPrint('✅LOGIN: ID $idUsuario salvo na memória segura do celular!');
      }

      // ==========================================================

      if (!mounted) return;
      userProvider.login(
        name: result['nome'] ?? 'Usuário',
        cargo: result['cargo'] ?? 'USUARIO', 
        email: result['email'] ?? emailController.text.trim(),
        id: result['idUsuario'],
        photoUrl: result['fotoPerfil'],
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception:', '').trim()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    // Usa o mesmo verde escuro do modo claro para manter consistência no fundo do card de login.
    const Color darkGreenColor = Color(0xFF0E564D);
    String t(String key) => context.t(key);

    return Scaffold(
      backgroundColor: colors.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewInsets = MediaQuery.of(context).viewInsets.bottom;

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: viewInsets),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: LoginLogo(),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: darkGreenColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 40.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            LoginInputField(
                              label: t('academicEmail'),
                              icon: Icons.person_outline,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 30),
                            LoginInputField(
                              label: t('password'),
                              icon: Icons.lock_outline,
                              controller: senhaController,
                              isObscure: _obscurePassword,
                              isPassword: true,
                              onSuffixPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberLogin,
                                  activeColor: Colors.white,
                                  checkColor: darkGreenColor,
                                  side: const BorderSide(color: Colors.white70, width: 1.5),
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberLogin = value ?? false;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _rememberLogin = !_rememberLogin;
                                    });
                                  },
                                  child: Text(
                                    t('rememberLogin'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: t('login'),
                              onPressed: _handleLogin,
                              isLoading: isLoading,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  t('noAccount'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const RegistrationPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    t('register'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
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
