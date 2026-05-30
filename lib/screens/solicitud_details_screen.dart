import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models/solicitud_model.dart';
import '../data/providers/solicitud_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/request_status_badge.dart';

class SolicitudDetailsScreen extends ConsumerStatefulWidget {
  final Solicitud solicitud;

  const SolicitudDetailsScreen({super.key, required this.solicitud});

  @override
  ConsumerState<SolicitudDetailsScreen> createState() => _SolicitudDetailsScreenState();
}

class _SolicitudDetailsScreenState extends ConsumerState<SolicitudDetailsScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final req = widget.solicitud;
    final offer = req.opportunity;

    // Use current updated request from provider if it has refreshed
    final receivedRequestsAsync = ref.watch(receivedRequestsProvider);
    final currentRequest = receivedRequestsAsync.value?.firstWhere(
      (r) => r.id == req.id,
      orElse: () => req,
    ) ?? req;

    final status = currentRequest.status;

    final primaryColor = isDark ? const Color(0xFF10B981) : theme.colorScheme.primary;
    final cardBgColor = theme.colorScheme.surfaceContainer;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.offerApplyFormTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header d'Oportunitat ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            offer.sector.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: primaryColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        RequestStatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      offer.companyDescription,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Dades de l'Usuari Sol·licitant ──
              Text(
                l10n.solicitudApplicantData.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    _buildUserDetailRow(
                      icon: Icons.person_outline_rounded,
                      label: l10n.fullNameLabel,
                      value: req.interestedUser.fullName.isNotEmpty ? req.interestedUser.fullName : l10n.inboxNotAvailable,
                    ),
                    const Divider(height: 24),
                    _buildUserDetailRow(
                      icon: Icons.email_outlined,
                      label: l10n.emailLabel,
                      value: req.interestedUser.email.isNotEmpty ? req.interestedUser.email : l10n.inboxNotAvailable,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Detalls de la sol·licitud (Bio & Background) ──
              _buildSectionTitle(l10n.offerApplyBioLabel),
              _buildContentCard(req.bio ?? l10n.solicitudNoBio),
              const SizedBox(height: 20),

              _buildSectionTitle(l10n.offerApplyBackgroundLabel),
              _buildContentCard(req.professionalBackground ?? l10n.solicitudNoBackground),
              const SizedBox(height: 24),

              // ── Informació Financera i Zones d'Interès ──
              Text(
                l10n.solicitudPreferencesFinance.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    _buildUserDetailRow(
                      icon: Icons.map_outlined,
                      label: l10n.offerApplyRegionsLabel,
                      value: req.preferredRegions?.isNotEmpty == true
                          ? req.preferredRegions!.join(', ')
                          : l10n.solicitudAllRegions,
                    ),
                    const Divider(height: 24),
                    _buildUserDetailRow(
                      icon: Icons.euro_outlined,
                      label: l10n.offerApplyCapitalLabel,
                      value: req.availableCapital != null
                          ? "${req.availableCapital!.toStringAsFixed(0)} €"
                          : l10n.solicitudNotSpecified,
                    ),
                    const Divider(height: 24),
                    _buildUserDetailRow(
                      icon: Icons.account_balance_outlined,
                      label: l10n.offerApplyFinancingLabel,
                      value: req.financingNeeded == true ? l10n.solicitudYes : l10n.solicitudNo,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── NDA i Documentació ──
              Text(
                l10n.solicitudDocSecurity.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.gavel_outlined, color: primaryColor, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.solicitudNdaTitle,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_user_outlined, size: 12, color: Color(0xFF10B981)),
                              const SizedBox(width: 4),
                              Text(
                                l10n.solicitudAccepted,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (req.cvKey != null && req.cvKey!.isNotEmpty) ...[
                      const Divider(height: 24),
                      Row(
                        children: [
                          Icon(Icons.picture_as_pdf_outlined, color: primaryColor, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.solicitudCvTitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  l10n.solicitudCvPdfSubtitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.solicitudCvPreviewComingSoon),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.visibility_outlined, size: 16),
                            label: Text(l10n.solicitudCvView),
                            style: TextButton.styleFrom(
                              foregroundColor: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomNavigationBar: status == 'PENDING'
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isProcessing
                            ? null
                            : () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(context);
                                final navigator = Navigator.of(context);
                                setState(() => _isProcessing = true);
                                try {
                                  await ref.read(receivedRequestsProvider.notifier).rejectRequest(req.id);
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text('${l10n.inboxStatusRejected} ${l10n.inboxStatusUpdatedSuccessfully}'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                  navigator.pop();
                                } catch (err) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${err.toString()}'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                } finally {
                                  if (mounted) setState(() => _isProcessing = false);
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          l10n.inboxActionReject,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isProcessing
                            ? null
                            : () async {
                                final scaffoldMessenger = ScaffoldMessenger.of(context);
                                final navigator = Navigator.of(context);
                                setState(() => _isProcessing = true);
                                try {
                                  await ref.read(receivedRequestsProvider.notifier).acceptRequest(req.id);
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text('${l10n.inboxStatusAccepted} ${l10n.inboxStatusUpdatedSuccessfully}'),
                                      backgroundColor: const Color(0xFF10B981),
                                    ),
                                  );
                                  navigator.pop();
                                } catch (err) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${err.toString()}'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                } finally {
                                  if (mounted) setState(() => _isProcessing = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                l10n.inboxActionAccept,
                                style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildContentCard(String text) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildUserDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
