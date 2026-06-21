import 'dart:io';
import 'dart:ui';
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
import '../data/providers/offers_provider.dart';
import '../widgets/offer_map_widget.dart';
import 'chat_room_screen.dart';
import 'premium_screen.dart';
import '../data/services/chat_service.dart';
import '../data/providers/notification_provider.dart';

import '../widgets/glassmorphic_app_bar.dart';
import '../theme/relevo_theme.dart';
import '../utils/snackbar_utils.dart';

class OfferDetailsScreen extends ConsumerStatefulWidget {
  final Offer offer;

  const OfferDetailsScreen({super.key, required this.offer});

  @override
  ConsumerState<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends ConsumerState<OfferDetailsScreen>
    with TickerProviderStateMixin {
  AnimationController? _sheetAnimationController;

  @override
  void dispose() {
    _sheetAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationsStateProvider.notifier)
          .markOfferNotificationsAsRead(offer.id);
    });

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
    final existingRequestList = sentRequests.where(
      (r) => r.opportunity.id == offer.id,
    );
    final existingRequest = existingRequestList.isNotEmpty
        ? existingRequestList.first
        : null;

    final isLoggedIn = user != null;
    final favoriteIdsAsync = isLoggedIn
        ? ref.watch(favoriteOfferIdsProvider)
        : null;
    final isFavorite = favoriteIdsAsync?.value?.contains(offer.id) ?? false;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: GlassmorphicAppBar(
        title: Text(l10n.offerDetailsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (!isMyOffer && isLoggedIn)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? theme.colorScheme.primary : null,
              ),
              tooltip: l10n.offerDetailsFavoriteTooltip,
              onPressed: () async {
                try {
                  await ref
                      .read(favoriteOfferIdsProvider.notifier)
                      .toggleFavorite(offer.id);
                  if (context.mounted) {
                    final nowFav =
                        ref
                            .read(favoriteOfferIdsProvider)
                            .value
                            ?.contains(offer.id) ??
                        false;
                    final msg = nowFav
                        ? l10n.offerDetailsFavoriteAdded
                        : l10n.offerDetailsFavoriteRemoved;
                    showRelevoSnackBar(
                      context,
                      message: msg,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    showRelevoSnackBar(
                      context,
                      message: 'Error: $e',
                      isError: true,
                    );
                  }
                }
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
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top + 80.0,
                20,
                24,
              ),
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
                      color: theme.colorScheme.secondary.withValues(
                        alpha: 0.15,
                      ),
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
                          offer.getLocalizedSector(localeCode).toUpperCase(),
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
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
              child: RelevoCard(
                color: theme.colorScheme.surfaceContainer,
                padding: const EdgeInsets.all(16.0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      context: context,
                      icon: Icons.location_on_outlined,
                      label: l10n.offerDetailsLocation,
                      value: offer.region,
                    ),
                    if (user != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: OfferMapWidget(region: offer.region),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: RelevoCard(
                color: theme.colorScheme.surfaceContainer,
                padding: const EdgeInsets.all(16.0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                child: _buildDetailRow(
                  context: context,
                  icon: Icons.euro_outlined,
                  label: l10n.offerDetailsRevenue,
                  value: offer.revenueRange != null
                      ? Offer.formatRevenueRange(offer.revenueRange!)
                      : 'N/A',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: RelevoCard(
                color: theme.colorScheme.surfaceContainer,
                padding: const EdgeInsets.all(16.0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                child: _buildDetailRow(
                  context: context,
                  icon: Icons.people_outline_rounded,
                  label: l10n.offerDetailsEmployees,
                  value: offer.employeeRange != null
                      ? Offer.formatEmployeeRange(offer.employeeRange!)
                      : 'N/A',
                ),
              ),
            ),

            if (offer.creationYear != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: RelevoCard(
                  color: theme.colorScheme.surfaceContainer,
                  padding: const EdgeInsets.all(16.0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  child: _buildDetailRow(
                    context: context,
                    icon: Icons.calendar_today_outlined,
                    label: l10n.offerDetailsYear,
                    value: offer.creationYear.toString(),
                  ),
                ),
              ),

            if (offer.extendedDescription != null &&
                offer.extendedDescription!.trim().isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: RelevoCard(
                  color: theme.colorScheme.surfaceContainer,
                  padding: const EdgeInsets.all(16.0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.offerDetailsExtended,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          offer.extendedDescription!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 140),
          ],
        ),
      ),
      bottomNavigationBar: isMyOffer
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: existingRequest != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusBanner(
                            context,
                            existingRequest.status,
                            localeCode,
                          ),
                          if (existingRequest.status == 'ACCEPTED') ...[
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                try {
                                  final chat = await ref
                                      .read(chatServiceProvider)
                                      .getOrCreateChat(offer.id);
                                  if (context.mounted) {
                                    Navigator.pop(
                                      context,
                                    ); // Close loading dialog
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChatRoomScreen(chatId: chat.id),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    Navigator.pop(
                                      context,
                                    ); // Close loading dialog
                                    showRelevoSnackBar(
                                      context,
                                      message: l10n.offerDetailsChatError(e.toString()),
                                      isError: true,
                                    );
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.chat_bubble_outline_rounded,
                              ),
                              label: Text(
                                l10n.offerDetailsChatWithOwner,
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                backgroundColor: Colors.white,
                                foregroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ],
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: isDark ? 0.45 : 0.85,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: isDark ? 0.75 : 0.95,
                                ),
                                width: 1.5,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                _sheetAnimationController?.dispose();
                                _sheetAnimationController = AnimationController(
                                  vsync: this,
                                  duration: const Duration(milliseconds: 650),
                                  reverseDuration: const Duration(milliseconds: 500),
                                );
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  transitionAnimationController: _sheetAnimationController,
                                  builder: (context) =>
                                      ApplyFormBottomSheet(offer: offer),
                                );
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                height: 56,
                                alignment: Alignment.center,
                                child: Text(
                                  l10n.offerDetailsApplyButton,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
    );
  }

  Widget _buildStatusBanner(
    BuildContext context,
    String status,
    String localeCode,
  ) {
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
        description = l10n.offerDetailsStatusPendingDesc;
        break;
      case 'ACCEPTED':
        bgColor = isDark ? const Color(0x3310B981) : const Color(0xFFD4EDDA);
        textColor = isDark ? const Color(0xFF34D399) : const Color(0xFF155724);
        icon = Icons.check_circle_outline_rounded;
        description = l10n.offerDetailsStatusAcceptedDesc;
        break;
      case 'REJECTED':
      default:
        bgColor = isDark ? const Color(0x33EF5350) : const Color(0xFFF8D7DA);
        textColor = isDark ? const Color(0xFFE57373) : const Color(0xFF721C24);
        icon = Icons.cancel_outlined;
        description = l10n.offerDetailsStatusRejectedDesc;
        break;
    }

    final String label = status == 'PENDING'
        ? l10n.inboxStatusPending
        : status == 'ACCEPTED'
        ? l10n.inboxStatusAccepted
        : l10n.inboxStatusRejected;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: isDark ? 0.25 : 0.45),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: textColor.withValues(alpha: isDark ? 0.35 : 0.55),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 28),
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
        ),
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
    final iconColor = isDark
        ? const Color(0xFF10B981)
        : theme.colorScheme.primary;

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
            child: Icon(icon, size: 22, color: iconColor),
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
}

class ApplyFormBottomSheet extends ConsumerStatefulWidget {
  final Offer offer;

  const ApplyFormBottomSheet({super.key, required this.offer});

  @override
  ConsumerState<ApplyFormBottomSheet> createState() =>
      _ApplyFormBottomSheetState();
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
    final hasCapital =
        capitalStr.isNotEmpty &&
        (double.tryParse(capitalStr) != null &&
            double.tryParse(capitalStr)! >= 0);

    final isValid =
        hasBackground && hasRegions && hasBio && hasCapital && _ndaAccepted;

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
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(
              alpha: isDark ? 0.4 : 0.65,
            ),
            width: 1.5,
          ),
          left: BorderSide(
            color: theme.colorScheme.outline.withValues(
              alpha: isDark ? 0.4 : 0.65,
            ),
            width: 1.5,
          ),
          right: BorderSide(
            color: theme.colorScheme.outline.withValues(
              alpha: isDark ? 0.4 : 0.65,
            ),
            width: 1.5,
          ),
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
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
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? theme.colorScheme.surfaceContainer
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.25,
                            ),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 32,
                              color: isDark
                                  ? const Color(0xFF10B981)
                                  : theme.colorScheme.secondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.offerApplyCvSelect,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0x2210B981)
                              : const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF10B981)
                                : const Color(0xFF81C784),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf_outlined,
                              color: isDark
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF2E7D32),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _cvFileName!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? const Color(0xFF34D399)
                                      : const Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                              ),
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

              Opacity(
                opacity: (!_isFormValid || _isSubmitting) ? 0.5 : 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: isDark ? 0.45 : 0.85,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: isDark ? 0.75 : 0.95,
                          ),
                          width: 1.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: (!_isFormValid || _isSubmitting)
                            ? null
                            : () async {
                                setState(() {
                                  _cvError = null;
                                });

                                final isFormValid = _formKey.currentState!.validate();

                                if (!_ndaAccepted) {
                                  showRelevoSnackBar(
                                    context,
                                    message: l10n.offerApplyNdaError,
                                    isError: true,
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

                                    final capital =
                                        double.tryParse(
                                          _capitalController.text.trim(),
                                        ) ??
                                        0.0;

                                    final solicitudService = ref.read(
                                      solicitudServiceProvider,
                                    );

                                    // Crear la sol·licitud amb totes les dades (sense actualitzar perfil)
                                    final solicitud = await solicitudService
                                        .createSolicitud(
                                          opportunityId: widget.offer.id,
                                          bio: _bioController.text.trim(),
                                          professionalBackground: _backgroundController
                                              .text
                                              .trim(),
                                          preferredRegions: regions,
                                          availableCapital: capital,
                                          financingNeeded: _financingNeeded,
                                          ndaAccepted: _ndaAccepted,
                                        );

                                    if (_cvFileName != null && _pickedCvFile != null) {
                                      // Pujar el CV a S3 (només si l'ha seleccionat)
                                      final presignedData = await solicitudService
                                          .getPresignedUploadUrl(_cvFileName!);
                                      final String uploadUrl =
                                          presignedData['uploadUrl'];
                                      final String s3Key = presignedData['s3Key'];

                                      final List<int> fileBytes =
                                          _pickedCvFile!.bytes ??
                                          File(_pickedCvFile!.path!).readAsBytesSync();
                                      await solicitudService.uploadCvToS3(
                                        uploadUrl,
                                        fileBytes,
                                      );

                                      // Guardar la clau S3 a la sol·licitud
                                      await solicitudService.guardarCvKey(
                                        solicitud.id,
                                        s3Key,
                                      );
                                    }

                                    ref.invalidate(sentRequestsProvider);

                                    if (!context.mounted) return;

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (dialogContext) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(24),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                            child: Material(
                                              color: theme.colorScheme.surfaceContainer.withValues(
                                                alpha: 0.65,
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.all(24),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(24),
                                                  border: Border.all(
                                                    color: theme.colorScheme.outline.withValues(
                                                      alpha: isDark ? 0.25 : 0.45,
                                                    ),
                                                    width: 1.5,
                                                  ),
                                                ),
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
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w800,
                                                        color: theme.colorScheme.onSurface,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      l10n.offerApplySuccessMessage,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: theme.colorScheme.onSurface
                                                            .withValues(alpha: 0.7),
                                                        height: 1.4,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 24),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(dialogContext).pop(); // Close dialog
                                                        Navigator.of(context).pop(); // Close bottom sheet
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize: const Size.fromHeight(
                                                          48,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(
                                                            10,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Text(l10n.offerApplySuccessOk),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } catch (err) {
                                    if (!context.mounted) return;
                                    setState(() {
                                      _isSubmitting = false;
                                    });

                                    final errString = err.toString().toLowerCase();
                                    if (errString.contains('limit') || errString.contains('límit') || errString.contains('limite')) {
                                      _showLimitExceededDialog(context);
                                    } else {
                                      showRelevoSnackBar(
                                        context,
                                        message: l10n.offerApplyErrorPrefix(
                                          err.toString().replaceAll(
                                            'Exception: ',
                                            '',
                                          ),
                                        ),
                                        isError: true,
                                      );
                                    }
                                  }
                                }
                              },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  l10n.offerApplySubmitButton,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLimitExceededDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: (theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.limitRequestsTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.limitRequestsMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.4,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          child: Text(
                            l10n.notificationsCancel,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogCtx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PremiumScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Premium",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
          color: theme.colorScheme.outline.withValues(alpha: 0.45),
          width: 1.5,
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
          Switch(value: value, onChanged: onChanged),
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
                : theme.colorScheme.outline.withValues(alpha: 0.45),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _ndaAccepted
                  ? Icons.lock_outline_rounded
                  : Icons.lock_open_outlined,
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
                      ? (isDark
                            ? const Color(0xFF34D399)
                            : const Color(0xFF2E7D32))
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
              activeColor: isDark
                  ? const Color(0xFF10B981)
                  : theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
