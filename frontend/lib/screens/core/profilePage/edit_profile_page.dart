import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fadir/providers/language_provider.dart';
import 'package:fadir/providers/user_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: userProvider.userName);
    _emailController = TextEditingController(text: userProvider.email);
    _phoneController = TextEditingController(text: userProvider.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final colors = Theme.of(context).colorScheme;
      Provider.of<UserProvider>(context, listen: false).updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('profileUpdated')),
          backgroundColor: colors.primary,
        ),
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => context.t(key);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(t('editProfile')),
        centerTitle: true,
        backgroundColor: colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.onSurface),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              t('save'),
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                colors: colors,
                isDark: isDark,
                controller: _nameController,
                label: t('name'),
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t('enterName');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                colors: colors,
                isDark: isDark,
                controller: _emailController,
                label: t('email'),
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t('enterEmail');
                  }
                  if (!value.contains('@')) {
                    return t('invalidEmail');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                colors: colors,
                isDark: isDark,
                controller: _phoneController,
                label: t('phone'),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t('enterPhone');
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required ColorScheme colors,
    required bool isDark,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final fieldColor = isDark ? colors.surfaceContainerHighest : colors.surface;
    return Container(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.7)),
          floatingLabelStyle: TextStyle(color: colors.primary),
          prefixIcon: Icon(icon, color: colors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: fieldColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
}
