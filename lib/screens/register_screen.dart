import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_banner.dart';

import '../widgets/glassmorphic_app_bar.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _backendError;

  String _selectedRole = 'INTERESTED';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _hacerLoginGoogle() async {
    setState(() => _backendError = null);
    try {
      await ref.read(authProvider.notifier).loginWithGoogle();
      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.hasValue && authState.value != null) {
          final userLanguage = authState.value!.language;
          if (userLanguage != null) {
            ref
                .read(languageStateProvider.notifier)
                .setLanguageWithoutSync(userLanguage);
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

  Future<void> _hacerRegistro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _backendError = null);

    try {
      await ref
          .read(authProvider.notifier)
          .register(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            role: _selectedRole,
            language: ref.read(languageStateProvider).languageCode,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.registerSuccess,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
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
    if (error.contains('DUPLICATE_FIELD') || error.contains('USER_EXISTS')) {
      return AppLocalizations.of(context)!.errorUserExists;
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassmorphicAppBar(
        title: Text(l10n.registerTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24.0, 100.0, 24.0, 16.0),
          child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_add_outlined,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.registerWelcome,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.registerSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  if (_backendError != null) ...[
                    const SizedBox(height: 24),
                    ErrorBanner(message: _getErrorMessage(_backendError!)),
                  ],
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withValues(
                            alpha: 0.02,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          label: l10n.fullNameLabel,
                          hint: l10n.fullNameHint,
                          icon: Icons.person_outline,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.errorRequiredField;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _emailController,
                          label: l10n.emailLabel,
                          hint: l10n.emailHint,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.errorRequiredField;
                            }
                            if (!value.contains('@')) {
                              return l10n.errorInvalidEmail;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          label: l10n.passwordLabel,
                          hint: l10n.passwordHintRegister,
                          icon: Icons.lock_outline,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _hacerRegistro(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.errorRequiredField;
                            }
                            if (value.length < 6) {
                              return l10n.errorPasswordTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.roleQuestion,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRoleOption(
                          'INTERESTED',
                          l10n.roleInterested,
                          Icons.search,
                        ),
                        const SizedBox(height: 12),
                        _buildRoleOption(
                          'OWNER',
                          l10n.roleOwner,
                          Icons.business,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : _hacerRegistro,
                          style: theme.elevatedButtonTheme.style?.copyWith(
                            elevation: const WidgetStatePropertyAll(0),
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(l10n.registerButton),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                Localizations.localeOf(context).languageCode ==
                                        'ca'
                                    ? 'o'
                                    : Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'es'
                                    ? 'o'
                                    : 'or',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: authState.isLoading
                              ? null
                              : _hacerLoginGoogle,
                          icon: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                            height: 20,
                            width: 20,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.g_mobiledata, size: 20),
                          ),
                          label: Text(
                            Localizations.localeOf(context).languageCode == 'ca'
                                ? 'Registrar-se amb Google'
                                : Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'es'
                                ? 'Registrarse con Google'
                                : 'Sign up with Google',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildRoleOption(String role, String title, IconData icon) {
    bool isSelected = _selectedRole == role;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.secondary
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.secondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
