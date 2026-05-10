import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/language_provider.dart';
import '../l10n/app_localizations.dart';
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _backendError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _hacerLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _backendError = null);

    try {
      await ref.read(authProvider.notifier).login(
        _emailController.text.trim(), 
        _passwordController.text
      );
      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.hasValue && authState.value != null) {
          final userLanguage = authState.value!.language;
          if (userLanguage != null) {
            context.read<LanguageProvider>().setLanguageWithoutSync(userLanguage);
          }
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _backendError = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('INVALID_CREDENTIALS') || error.contains('AUTH.')) {
      return AppLocalizations.of(context)!.errorInvalidCredentials;
    }
    if (error.contains('INTERNAL_ERROR')) {
      return AppLocalizations.of(context)!.errorInternal;
    }
    // Si no reconeixem la clau, mostrem l'error tal qual o un genèric
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
            Text(
              AppLocalizations.of(context)!.loginWelcome,
              style: GoogleFonts.manrope(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.loginSubtitle,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 16),
              ),
              if (_backendError != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _getErrorMessage(_backendError!),
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 40),
                        _buildTextField(
                controller: _emailController,
                label: AppLocalizations.of(context)!.emailLabel,
                hint: AppLocalizations.of(context)!.emailHint,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.errorRequiredField;
                  if (!value.contains('@')) return AppLocalizations.of(context)!.errorInvalidEmail;
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _passwordController,
                label: AppLocalizations.of(context)!.passwordLabel,
                hint: AppLocalizations.of(context)!.passwordHintLogin,
                icon: Icons.lock_outline,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.errorRequiredField;
                  if (value.length < 6) return AppLocalizations.of(context)!.errorPasswordTooShort;
                  return null;
                },
              ),
              const SizedBox(height: 40),
            
            authState.isLoading
                ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
                : ElevatedButton(
                    onPressed: _hacerLogin,
                    child: Text(AppLocalizations.of(context)!.loginButton),
                  ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.forgotPasswordButton,
                  style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
            prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
