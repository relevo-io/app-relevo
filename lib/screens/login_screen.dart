import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_banner.dart';

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
            ref.read(languageStateProvider.notifier).setLanguageWithoutSync(userLanguage);
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
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  AppLocalizations.of(context)!.loginWelcome,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.loginSubtitle,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6), 
                    fontSize: 16,
                  ),
                ),
                if (_backendError != null) ...[
                  const SizedBox(height: 24),
                  ErrorBanner(message: _getErrorMessage(_backendError!)),
                ],
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  label: AppLocalizations.of(context)!.emailLabel,
                  hint: AppLocalizations.of(context)!.emailHint,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) return AppLocalizations.of(context)!.errorRequiredField;
                    if (!value.contains('@')) return AppLocalizations.of(context)!.errorInvalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _passwordController,
                  label: AppLocalizations.of(context)!.passwordLabel,
                  hint: AppLocalizations.of(context)!.passwordHintLogin,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _hacerLogin(),
                  validator: (value) {
                    if (value == null || value.isEmpty) return AppLocalizations.of(context)!.errorRequiredField;
                    if (value.length < 6) return AppLocalizations.of(context)!.errorPasswordTooShort;
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _hacerLogin,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(AppLocalizations.of(context)!.loginButton),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.forgotPasswordButton,
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
