import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../data/models/offer_model.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/solicitud_provider.dart';
import '../data/services/solicitud_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_text_field.dart';

class OfferDetailsScreen extends ConsumerWidget {
  final Offer offer;

  const OfferDetailsScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    final user = ref.watch(authProvider).value;
    final isMyOffer = user != null && offer.owner == user.id;

    final timeAgoStr = offer.publishedAt != null
        ? timeago.format(offer.publishedAt!, locale: localeCode)
        : null;

    final isDark = theme.brightness == Brightness.dark;

    final sentRequestsAsync = ref.watch(sentRequestsProvider);
    final sentRequests = sentRequestsAsync.value ?? [];
    final existingRequestList = sentRequests.where((r) => r.opportunity.id == offer.id);
    final existingRequest = existingRequestList.isNotEmpty ? existingRequestList.first : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.offerDetailsTitle),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Favorit (Decoratiu)',
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funció de favorits pròximament!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainer
                    : theme.colorScheme.primary.withValues(alpha: 0.03),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          offer.sector.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.secondary,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    offer.companyDescription,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                      height: 1.35,
                    ),
                  ),
                  if (timeAgoStr != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${l10n.offerDetailsPublished}: $timeAgoStr',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    context: context,
                    icon: Icons.location_on_outlined,
                    label: l10n.offerDetailsLocation,
                    value: offer.region,
                  ),
                  _buildDetailDivider(theme),
                  _buildDetailRow(
                    context: context,
                    icon: Icons.euro_outlined,
                    label: l10n.offerDetailsRevenue,
                    value: offer.revenueRange != null
                        ? Offer.formatRevenueRange(offer.revenueRange!)
                        : 'N/A',
                  ),
                  _buildDetailDivider(theme),
                  _buildDetailRow(
                    context: context,
                    icon: Icons.people_outline_rounded,
                    label: l10n.offerDetailsEmployees,
                    value: offer.employeeRange != null
                        ? Offer.formatEmployeeRange(offer.employeeRange!)
                        : 'N/A',
                  ),
                  if (offer.creationYear != null) ...[
                    _buildDetailDivider(theme),
                    _buildDetailRow(
                      context: context,
                      icon: Icons.calendar_today_outlined,
                      label: l10n.offerDetailsYear,
                      value: offer.creationYear.toString(),
                    ),
                  ],
                ],
              ),
            ),

            if (offer.extendedDescription != null &&
                offer.extendedDescription!.trim().isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.offerDetailsExtended,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      offer.extendedDescription!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: isMyOffer
          ? null
          : SafeArea(
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
                child: existingRequest != null
                    ? _buildStatusBanner(context, existingRequest.status, localeCode)
                    : ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ApplyFormBottomSheet(offer: offer),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(l10n.offerDetailsApplyButton),
                      ),
              ),
            ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, String status, String localeCode) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bgColor;
    Color textColor;
    IconData icon;
    String description;

    switch (status) {
      case 'PENDING':
        bgColor = isDark ? const Color(0x33FF9800) : const Color(0xFFFFF3CD);
        textColor = isDark ? const Color(0xFFFFB74D) : const Color(0xFF856404);
        icon = Icons.hourglass_empty_rounded;
        if (localeCode == 'ca') {
          description = "Pendent de revisió pel propietari.";
        } else if (localeCode == 'es') {
          description = "Pendiente de revisión por el propietario.";
        } else {
          description = "Pending review by the owner.";
        }
        break;
      case 'ACCEPTED':
        bgColor = isDark ? const Color(0x3310B981) : const Color(0xFFD4EDDA);
        textColor = isDark ? const Color(0xFF34D399) : const Color(0xFF155724);
        icon = Icons.check_circle_outline_rounded;
        if (localeCode == 'ca') {
          description = "Sol·licitud acceptada! Es posaran en contacte.";
        } else if (localeCode == 'es') {
          description = "¡Solicitud aceptada! Se pondrán en contacto.";
        } else {
          description = "Application accepted! They will contact you.";
        }
        break;
      case 'REJECTED':
      default:
        bgColor = isDark ? const Color(0x33EF5350) : const Color(0xFFF8D7DA);
        textColor = isDark ? const Color(0xFFE57373) : const Color(0xFF721C24);
        icon = Icons.cancel_outlined;
        if (localeCode == 'ca') {
          description = "Sol·licitud denegada per a aquesta oportunitat.";
        } else if (localeCode == 'es') {
          description = "Solicitud denegada para esta oportunidad.";
        } else {
          description = "Application denied for this opportunity.";
        }
        break;
    }

    final String label = status == 'PENDING'
        ? l10n.inboxStatusPending
        : status == 'ACCEPTED'
            ? l10n.inboxStatusAccepted
            : l10n.inboxStatusRejected;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: textColor,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? const Color(0xFF10B981) : theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isDark ? 0.15 : 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Divider(
        color: theme.colorScheme.outline.withValues(alpha: 0.1),
        indent: 52,
      ),
    );
  }
}

class ApplyFormBottomSheet extends ConsumerStatefulWidget {
  final Offer offer;

  const ApplyFormBottomSheet({super.key, required this.offer});

  @override
  ConsumerState<ApplyFormBottomSheet> createState() => _ApplyFormBottomSheetState();
}

class _ApplyFormBottomSheetState extends ConsumerState<ApplyFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _backgroundController = TextEditingController();
  final _regionsController = TextEditingController();
  final _bioController = TextEditingController();
  final _capitalController = TextEditingController();
  bool _financingNeeded = false;
  bool _ndaAccepted = false;
  String? _cvFileName;
  PlatformFile? _pickedCvFile;
  String? _cvError;
  bool _isSubmitting = false;
  bool _isFormValid = false;

  void _validateForm() {
    final background = _backgroundController.text.trim();
    final regions = _regionsController.text.trim();
    final bio = _bioController.text.trim();
    final capitalStr = _capitalController.text.trim();

    final hasBackground = background.length >= 10;
    final hasRegions = regions.isNotEmpty;
    final hasBio = bio.length >= 10;
    final hasCapital = capitalStr.isNotEmpty && (double.tryParse(capitalStr) != null && double.tryParse(capitalStr)! >= 0);

    final isValid = hasBackground && hasRegions && hasBio && hasCapital && _ndaAccepted;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _backgroundController.addListener(_validateForm);
    _regionsController.addListener(_validateForm);
    _bioController.addListener(_validateForm);
    _capitalController.addListener(_validateForm);

    // Pre-fill with existing profile data as suggestions (not profile update)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).value;
      if (user != null) {
        _backgroundController.text = user.professionalBackground ?? '';
        _regionsController.text = user.preferredRegions?.join(', ') ?? '';
        _bioController.text = user.bio ?? '';
      }
      _validateForm();
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _regionsController.dispose();
    _bioController.dispose();
    _capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    // Colors for dark/light input area contrast
    final inputFillColor = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surfaceContainerLowest;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.offerApplyFormTitle,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Trajectòria professional ──
              CustomTextField(
                controller: _backgroundController,
                label: l10n.offerApplyBackgroundLabel,
                hint: l10n.offerApplyBackgroundHint,
                icon: Icons.history_edu_outlined,
                maxLines: 3,
                fillColor: inputFillColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.offerApplyRequiredError;
                  }
                  if (value.trim().length < 10) {
                    return l10n.offerApplyMinLengthError('10');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Zones preferides ──
              CustomTextField(
                controller: _regionsController,
                label: l10n.offerApplyRegionsLabel,
                hint: l10n.offerApplyRegionsHint,
                icon: Icons.map_outlined,
                maxLines: 1,
                fillColor: inputFillColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.offerApplyRequiredError;
                  }
                  if (value.trim().length < 2) {
                    return l10n.offerApplyMinLengthError('2');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Bio ──
              CustomTextField(
                controller: _bioController,
                label: l10n.offerApplyBioLabel,
                hint: l10n.offerApplyBioHint,
                icon: Icons.description_outlined,
                maxLines: 3,
                fillColor: inputFillColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.offerApplyRequiredError;
                  }
                  if (value.trim().length < 10) {
                    return l10n.offerApplyMinLengthError('10');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Capital disponible ──
              CustomTextField(
                controller: _capitalController,
                label: l10n.offerApplyCapitalLabel,
                hint: l10n.offerApplyCapitalHint,
                icon: Icons.euro_outlined,
                maxLines: 1,
                fillColor: inputFillColor,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.offerApplyRequiredError;
                  }
                  final num = double.tryParse(value.trim());
                  if (num == null || num < 0) {
                    return l10n.offerApplyCapitalError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Necessites finançament? ──
              _buildToggleRow(
                context: context,
                isDark: isDark,
                label: l10n.offerApplyFinancingLabel,
                value: _financingNeeded,
                onChanged: (v) => setState(() => _financingNeeded = v),
              ),
              const SizedBox(height: 20),

              // ── CV ──
              Text(
                '${l10n.offerApplyCvLabel} (opcional)',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  try {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null && result.files.isNotEmpty) {
                      setState(() {
                        _pickedCvFile = result.files.first;
                        _cvFileName = _pickedCvFile!.name;
                        _cvError = null;
                      });
                    }
                  } catch (e) {
                    setState(() {
                      _cvError = 'Error al seleccionar l\'arxiu: $e';
                    });
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: _cvFileName == null
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isDark ? theme.colorScheme.surfaceContainer : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 32,
                              color: isDark ? const Color(0xFF10B981) : theme.colorScheme.secondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.offerApplyCvSelect,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0x2210B981) : const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF10B981) : const Color(0xFF81C784),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf_outlined,
                              color: isDark ? const Color(0xFF10B981) : const Color(0xFF2E7D32),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _cvFileName!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? const Color(0xFF34D399) : const Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  _pickedCvFile = null;
                                  _cvFileName = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
              ),
              if (_cvError != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    _cvError!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // ── Acceptació NDA ──
              _buildNdaRow(context: context, isDark: isDark),
              const SizedBox(height: 24),

              // ── Botó d'enviament ──
              ElevatedButton(
                onPressed: (!_isFormValid || _isSubmitting)
                    ? null
                    : () async {
                        setState(() {
                          _cvError = null;
                        });

                        final isFormValid = _formKey.currentState!.validate();

                        if (!_ndaAccepted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.offerApplyNdaError),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        if (isFormValid && _ndaAccepted) {
                          setState(() {
                            _isSubmitting = true;
                          });

                          final navigator = Navigator.of(context);

                          try {
                            final regions = _regionsController.text
                                .split(',')
                                .map((v) => v.trim())
                                .where((v) => v.isNotEmpty)
                                .toList();

                            final capital = double.tryParse(_capitalController.text.trim()) ?? 0.0;

                            final solicitudService = ref.read(solicitudServiceProvider);

                            // Crear la sol·licitud amb totes les dades (sense actualitzar perfil)
                            final solicitud = await solicitudService.createSolicitud(
                              opportunityId: widget.offer.id,
                              bio: _bioController.text.trim(),
                              professionalBackground: _backgroundController.text.trim(),
                              preferredRegions: regions,
                              availableCapital: capital,
                              financingNeeded: _financingNeeded,
                              ndaAccepted: _ndaAccepted,
                            );

                            if (_cvFileName != null && _pickedCvFile != null) {
                              // Pujar el CV a S3 (només si l'ha seleccionat)
                              final presignedData = await solicitudService.getPresignedUploadUrl(_cvFileName!);
                              final String uploadUrl = presignedData['uploadUrl'];
                              final String s3Key = presignedData['s3Key'];

                              final List<int> fileBytes = _pickedCvFile!.bytes ?? File(_pickedCvFile!.path!).readAsBytesSync();
                              await solicitudService.uploadCvToS3(uploadUrl, fileBytes);

                              // Guardar la clau S3 a la sol·licitud
                              await solicitudService.guardarCvKey(solicitud.id, s3Key);
                            }

                            ref.invalidate(sentRequestsProvider);

                            if (!context.mounted) return;
                            navigator.pop();

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: theme.colorScheme.surface,
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0x3310B981)
                                              : const Color(0xFFE8F5E9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 60,
                                          color: isDark
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFF2E7D32),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        l10n.offerApplySuccessTitle,
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        l10n.offerApplySuccessMessage,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(48),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(l10n.offerApplySuccessOk),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } catch (err) {
                            if (!context.mounted) return;
                            setState(() {
                              _isSubmitting = false;
                            });
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.offerApplyErrorPrefix(err.toString().replaceAll('Exception: ', ''))),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(l10n.offerApplySubmitButton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required BuildContext context,
    required bool isDark,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 20,
            color: isDark ? const Color(0xFF10B981) : theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNdaRow({required BuildContext context, required bool isDark}) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () {
        setState(() => _ndaAccepted = !_ndaAccepted);
        _validateForm();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _ndaAccepted
              ? (isDark ? const Color(0x2210B981) : const Color(0xFFE8F5E9))
              : (isDark
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surfaceContainerLowest),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _ndaAccepted
                ? (isDark ? const Color(0xFF10B981) : const Color(0xFF81C784))
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _ndaAccepted ? Icons.lock_outline_rounded : Icons.lock_open_outlined,
              size: 20,
              color: _ndaAccepted
                  ? (isDark ? const Color(0xFF10B981) : const Color(0xFF2E7D32))
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.offerApplyNdaLabel,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _ndaAccepted
                      ? (isDark ? const Color(0xFF34D399) : const Color(0xFF2E7D32))
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ),
            Checkbox(
              value: _ndaAccepted,
              onChanged: (v) {
                setState(() => _ndaAccepted = v ?? false);
                _validateForm();
              },
              activeColor: isDark ? const Color(0xFF10B981) : theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
