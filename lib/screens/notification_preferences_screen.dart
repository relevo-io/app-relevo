import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/providers/auth_provider.dart';
import '../data/models/user_model.dart';
import '../l10n/app_localizations.dart';

class NotificationPreferencesScreen extends ConsumerStatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  ConsumerState<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends ConsumerState<NotificationPreferencesScreen> {
  bool _isSaving = false;

  Future<void> _updatePreference(
    String key,
    bool value,
    NotificationPreferences currentPrefs,
  ) async {
    setState(() {
      _isSaving = true;
    });

    final newPrefs = currentPrefs.copyWith(
      newMessages: key == 'newMessages' ? value : currentPrefs.newMessages,
      applicationStatus:
          key == 'applicationStatus' ? value : currentPrefs.applicationStatus,
      newApplications:
          key == 'newApplications' ? value : currentPrefs.newApplications,
      cvAnalysis: key == 'cvAnalysis' ? value : currentPrefs.cvAnalysis,
      offerAlerts: key == 'offerAlerts' ? value : currentPrefs.offerAlerts,
    );

    try {
      await ref
          .read(authProvider.notifier)
          .updateNotificationPreferences(newPrefs.toJson());
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.notificationPrefSaveSuccess),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.notificationPreferencesTitle,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            err.toString(),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No authenticated user'));
          }

          final currentPrefs = user.notificationPreferences ??
              NotificationPreferences(
                newMessages: true,
                applicationStatus: true,
                newApplications: true,
                cvAnalysis: true,
                offerAlerts: true,
              );

          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildPreferenceTile(
                            context: context,
                            icon: Icons.chat_bubble_outline_rounded,
                            title: l10n.notificationPrefNewMessages,
                            subtitle: l10n.notificationPrefNewMessagesDesc,
                            value: currentPrefs.newMessages,
                            onChanged: _isSaving
                                ? null
                                : (val) => _updatePreference(
                                      'newMessages',
                                      val,
                                      currentPrefs,
                                    ),
                          ),
                          const Divider(height: 1, indent: 72, endIndent: 24),
                          _buildPreferenceTile(
                            context: context,
                            icon: Icons.assignment_outlined,
                            title: l10n.notificationPrefApplicationStatus,
                            subtitle: l10n.notificationPrefApplicationStatusDesc,
                            value: currentPrefs.applicationStatus,
                            onChanged: _isSaving
                                ? null
                                : (val) => _updatePreference(
                                      'applicationStatus',
                                      val,
                                      currentPrefs,
                                    ),
                          ),
                          const Divider(height: 1, indent: 72, endIndent: 24),
                          _buildPreferenceTile(
                            context: context,
                            icon: Icons.badge_outlined,
                            title: l10n.notificationPrefNewApplications,
                            subtitle: l10n.notificationPrefNewApplicationsDesc,
                            value: currentPrefs.newApplications,
                            onChanged: _isSaving
                                ? null
                                : (val) => _updatePreference(
                                      'newApplications',
                                      val,
                                      currentPrefs,
                                    ),
                          ),
                          const Divider(height: 1, indent: 72, endIndent: 24),
                          _buildPreferenceTile(
                            context: context,
                            icon: Icons.psychology_outlined,
                            title: l10n.notificationPrefCvAnalysis,
                            subtitle: l10n.notificationPrefCvAnalysisDesc,
                            value: currentPrefs.cvAnalysis,
                            onChanged: _isSaving
                                ? null
                                : (val) => _updatePreference(
                                      'cvAnalysis',
                                      val,
                                      currentPrefs,
                                    ),
                          ),
                          const Divider(height: 1, indent: 72, endIndent: 24),
                          _buildPreferenceTile(
                            context: context,
                            icon: Icons.campaign_outlined,
                            title: l10n.notificationPrefOfferAlerts,
                            subtitle: l10n.notificationPrefOfferAlertsDesc,
                            value: currentPrefs.offerAlerts,
                            onChanged: _isSaving
                                ? null
                                : (val) => _updatePreference(
                                      'offerAlerts',
                                      val,
                                      currentPrefs,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isSaving)
                Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPreferenceTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
            activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            inactiveThumbColor: theme.colorScheme.outline,
            inactiveTrackColor: theme.colorScheme.surface,
          ),
        ],
      ),
    );
  }
}
