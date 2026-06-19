import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models/solicitud_model.dart';
import '../data/models/user_model.dart';
import '../data/providers/solicitud_provider.dart';
import '../data/providers/auth_provider.dart';
import '../data/services/solicitud_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/request_status_badge.dart';
import 'chat_room_screen.dart';
import '../data/services/chat_service.dart';

class SolicitudDetailsScreen extends ConsumerStatefulWidget {
  final Solicitud solicitud;

  const SolicitudDetailsScreen({super.key, required this.solicitud});

  @override
  ConsumerState<SolicitudDetailsScreen> createState() => _SolicitudDetailsScreenState();
}

class _SolicitudDetailsScreenState extends ConsumerState<SolicitudDetailsScreen> {
  bool _isProcessing = false;
  bool _isViewingCv = false;
  bool _isAnalyzingCv = false;
  bool _isAiExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final req = widget.solicitud;
    final offer = req.opportunity;

    // Retrieve current logged in user to check ownership
    final currentUser = ref.watch(authProvider).value;

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
                          _isViewingCv
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : TextButton.icon(
                                  onPressed: () async {
                                    setState(() => _isViewingCv = true);
                                    try {
                                      final service = ref.read(solicitudServiceProvider);
                                      final viewUrl = await service.getViewUrl(req.id);
                                      final uri = Uri.parse(viewUrl);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                                      } else {
                                        throw 'Could not launch URL';
                                      }
                                    } catch (err) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Error: ${err.toString()}'),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isViewingCv = false);
                                      }
                                    }
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
              _buildAiAnalysisPanel(context, currentRequest, currentUser),
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
          : (status == 'ACCEPTED'
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
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        try {
                          final chat = await ref.read(chatServiceProvider).getOrCreateChat(
                                offer.id,
                                interestedId: req.interestedUser.id,
                              );
                          if (context.mounted) {
                            Navigator.pop(context); // Close loading dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoomScreen(chatId: chat.id),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context); // Close loading dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  Localizations.localeOf(context).languageCode == 'ca'
                                      ? 'Error al obrir el xat: $e'
                                      : Localizations.localeOf(context).languageCode == 'es'
                                          ? 'Error al abrir el chat: $e'
                                          : 'Error opening chat: $e',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      label: Text(
                        Localizations.localeOf(context).languageCode == 'ca'
                            ? 'Xatejar amb el candidat'
                            : Localizations.localeOf(context).languageCode == 'es'
                                ? 'Chatear con el candidato'
                                : 'Chat with candidate',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                )
              : null),
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

  // AI Analysis Helper Widgets and Methods
  Widget _buildAiAnalysisPanel(BuildContext context, Solicitud request, User? currentUser) {
    if (currentUser?.id != request.owner.id) {
      return const SizedBox.shrink();
    }
    if (request.cvKey == null || request.cvKey!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final estado = _isAnalyzingCv ? 'EN_PROCESO' : (request.estadoAnalisis ?? 'PENDIENTE');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "ANÁLISIS POR IA",
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            child: _buildAiPanelContent(context, estado, request),
          ),
        ),
      ],
    );
  }

  Widget _buildAiPanelContent(BuildContext context, String estado, Solicitud request) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    switch (estado) {
      case 'EN_PROCESO':
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.solicitudAnalyzingAiTitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.solicitudAnalyzingAiSub,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 'ERROR':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.solicitudAiErrorTitle,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.solicitudAiErrorSub,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => _triggerAiAnalysis(request.id),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(l10n.solicitudRetry),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case 'COMPLETADO':
        final iaResult = request.resultadoIa;
        if (iaResult == null) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "No se encontraron resultados del análisis.",
              style: GoogleFonts.inter(color: theme.colorScheme.onSurface),
            ),
          );
        }

        final double score = iaResult.nota;
        Color scoreColor;
        if (score >= 8.0) {
          scoreColor = const Color(0xFF10B981);
        } else if (score >= 5.0) {
          scoreColor = const Color(0xFFF59E0B);
        } else {
          scoreColor = const Color(0xFFEF4444);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() => _isAiExpanded = !_isAiExpanded),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.solicitudAiCompleted,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: scoreColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: scoreColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.solicitudSuitability,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: scoreColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${score.toStringAsFixed(0)}/10",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: scoreColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _isAiExpanded ? Icons.expand_less : Icons.expand_more,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
            if (_isAiExpanded) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAiSectionHeader(
                      context,
                      icon: Icons.summarize_outlined,
                      title: l10n.solicitudCandidateSummary,
                      iconColor: Colors.deepPurple,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      iaResult.resumen,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAiSectionHeader(
                      context,
                      icon: Icons.check_circle_outline_rounded,
                      title: l10n.solicitudDetectedStrengths,
                      iconColor: const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 8),
                    ...iaResult.puntosFuertes.map((punto) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check, size: 16, color: Color(0xFF10B981)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  punto,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 20),
                    _buildAiSectionHeader(
                      context,
                      icon: Icons.work_outline_rounded,
                      title: l10n.solicitudExperienceMilestones,
                      iconColor: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    ...iaResult.experienciaDestacada.map((exp) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.trending_flat_rounded, size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  exp,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAiSectionHeader(
                            context,
                            icon: Icons.lightbulb_outline_rounded,
                            title: l10n.solicitudSuitabilityFeedback,
                            iconColor: Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            iaResult.comentarioNota,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              height: 1.45,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );

      case 'PENDIENTE':
      default:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.solicitudAiCvAvailableTitle,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.solicitudAiCvAvailableSub,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => _triggerAiAnalysis(request.id),
                  icon: const Icon(Icons.psychology, size: 18),
                  label: Text(l10n.solicitudAnalyzeAi),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildAiSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Future<void> _triggerAiAnalysis(String id) async {
    setState(() => _isAnalyzingCv = true);
    try {
      await ref.read(receivedRequestsProvider.notifier).analizarCv(id);
      setState(() {
        _isAiExpanded = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Análisis completado con éxito'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al analizar currículum: ${err.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzingCv = false);
      }
    }
  }
}
