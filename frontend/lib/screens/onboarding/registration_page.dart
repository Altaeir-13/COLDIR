import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';
import '/services/auth_service.dart'; 
import 'package:fadir/widgets/primary_button.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:fadir/screens/onboarding/verification_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Instância do Serviço (O "Carteiro" que leva os dados)
  final AuthService _authService = AuthService();

  // Seus Controladores
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController(); 
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Controle de estados
  bool isLoading = false;
  bool _obscurePassword = true;       
  bool _obscureConfirmPassword = true;

  // // Mascara para o telefone
  // var phoneMask = MaskTextInputFormatter(
  //   mask: '(##) ####-####',
  //   filter: { "#": RegExp(r'[0-9]') },
  //   type: MaskAutoCompletionType.lazy,
  // );

  // --- LÓGICA DO BOTÃO ---
  Future<void> _handleCadastro() async {
    String t(String key) => context.t(key);
    // Validação para o Email (Email Academico)
    final email = emailController.text.trim().toLowerCase();

    // Validação de campos vazios (Opcional, mas recomendado)
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('fillRequiredFields'))),
      );
      return;
    }

    if (!email.endsWith("@acad.ifma.edu.br")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('needInstitutionalEmail')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validação Visual (Senhas iguais?)
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('passwordsDontMatch')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Inicia o loading visual
    setState(() {
      isLoading = true;
    });

    try {
      //  Chama o Serviço
      await _authService.cadastrar(
        nameController.text,
        emailController.text,
        passwordController.text,
        telephoneController.text,
      );

      if (!mounted) return;
      
      // Quando quando o codigo ser enviado com sucesso:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationPage(email: emailController.text),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      final errorMessage = e.toString().replaceAll("Exception: ", "");
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // --- LAYOUT VISUAL ---
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(title: Text(context.t('createAccount'))),
      // SingleChildScrollView é vital para o teclado não cobrir os campos
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add_alt_1, size: 80, color: Color(0xFF0E564D)),
              const SizedBox(height: 30),

              // Campo Nome
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: context.t('name'),
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: context.t('academicEmail'),
                  prefixIcon: const Icon(Icons.school), // Ícone de escola
                  border: const OutlineInputBorder(),
                  helperText: context.t('emailHelper'), 
                  helperStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Campo Telefone
              // TextField(
              //   controller: telephoneController,
              //   keyboardType: TextInputType.phone, // Importante para abrir teclado numérico
              //   inputFormatters: [phoneMask],
                
              //   decoration: const InputDecoration(
              //     labelText: "Telefone",
              //     hintText: "(99) 99999-9999",
              //     prefixIcon: Icon(Icons.phone),
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              // const SizedBox(height: 16),

              // Campo Senha
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: context.t('password'),
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  
                  suffixIcon: IconButton(
                    icon: Icon(
                      !_obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo Confirmar Senha
              TextField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: context.t('confirmPassword'),
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),

                  suffixIcon: IconButton(
                    icon: Icon(
                      !_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  )
                ),
              ),
              const SizedBox(height: 30),

              PrimaryButton(
                text: context.t('registerAction'),
                onPressed: _handleCadastro,
                isLoading: isLoading,
                backgroundColor: const Color(0xFF0E564D),
                textColor: Colors.white,
              ),
              const SizedBox(height: 150), 
            ],
            
          ),
        ),
      ),
    );
  }
}