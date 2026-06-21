import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/offer_model.dart';
import '../data/models/payment_model.dart';
import '../data/providers/offers_provider.dart';
import '../data/services/offer_service.dart';
import '../data/services/payment_service.dart';
import '../l10n/app_localizations.dart';
import 'offer_details_screen.dart';
import 'payment_checkout_screen.dart';
import 'premium_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_banner.dart';

class CreateOfferScreen extends ConsumerStatefulWidget {
  const CreateOfferScreen({super.key});

  @override
  ConsumerState<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends ConsumerState<CreateOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _regionController = TextEditingController();
  final _yearController = TextEditingController();
  final _companyDescController = TextEditingController();
  final _extendedDescController = TextEditingController();

  String? _selectedSector;
  String? _selectedRevenueRange;
  String? _selectedEmployeeRange;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _regionController.dispose();
    _yearController.dispose();
    _companyDescController.dispose();
    _extendedDescController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sector = _selectedSector ?? '';
      final region = _regionController.text.trim();
      final companyDesc = _companyDescController.text.trim();
      final extendedDesc = _extendedDescController.text.trim();
      final yearStr = _yearController.text.trim();
      final year = yearStr.isEmpty ? null : int.tryParse(yearStr);

      final checkoutSession = await ref
          .read(paymentServiceProvider)
          .createCheckoutSession(
            CreateCheckoutSessionPayload(
              kind: PaymentKind.offerPublication,
              returnUrlBase: kIsWeb ? Uri.base.origin : null,
              offerDraft: {
                'region': region,
                'sector': sector,
                'revenueRange': _selectedRevenueRange,
                'creationYear': year,
                'employeeRange': _selectedEmployeeRange,
                'companyDescription': companyDesc,
                'extendedDescription': extendedDesc.isEmpty
                    ? null
                    : extendedDesc,
              },
            ),
          );

      if (!mounted) return;

      final status = await Navigator.of(context).push<CheckoutSessionStatus>(
        MaterialPageRoute(
          builder: (_) => PaymentCheckoutScreen(
            checkoutUrl: checkoutSession.checkoutUrl,
            paymentSessionId: checkoutSession.paymentSessionId,
            kind: PaymentKind.offerPublication,
          ),
        ),
      );

      if (!mounted || status == null) return;

      if (status.status == PaymentStatus.completed) {
        ref.invalidate(offersProvider);
        ref.invalidate(myOffersProvider);

        final l10n = AppLocalizations.of(context)!;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF10B981),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.offerPublishSuccess,
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

        if (status.createdOfferId != null &&
            status.createdOfferId!.isNotEmpty) {
          final createdOffer = await ref
              .read(offerServiceProvider)
              .getOfferById(status.createdOfferId!);

          if (!mounted) return;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => OfferDetailsScreen(offer: createdOffer),
            ),
          );
          return;
        }

        if (!mounted) return;
        Navigator.pop(context);
        return;
      }

      if (status.status == PaymentStatus.canceled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.paymentCheckoutCanceled,
            ),
          ),
        );
        return;
      }

      throw Exception(AppLocalizations.of(context)!.paymentCheckoutStatusError);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });

        final errString = e.toString().toLowerCase();
        if (errString.contains('limit') || errString.contains('límit') || errString.contains('limite')) {
          _showLimitExceededDialog(context);
        }
      }
    }
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
                    l10n.limitOffersTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.limitOffersMessage,
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

  void _onContinueToPayment() {
    if (!_formKey.currentState!.validate()) return;
    _showPaymentConfirmationDialog();
  }

  void _showPaymentConfirmationDialog() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final String title = l10n.offerPaymentConfirmTitle;
    final String message = l10n.offerPaymentConfirmDesc;
    final String summaryHeader = l10n.offerPaymentSummaryHeader;
    final String cancelText = l10n.notificationsCancel;
    final String confirmText = l10n.offerPaymentConfirmButton;

    final String labelSector = l10n.offerSectorLabel;
    final String labelRegion = l10n.offerRegionLabel;
    final String labelRevenue = l10n.offerRevenueLabel;
    final String labelEmployees = l10n.offerEmployeesLabel;
    final String labelYear = l10n.offerYearLabel;
    final String labelDescription = l10n.offerDescLabel;

    String getLocalizedSectorName(String sectorKey) {
      switch (sectorKey.toLowerCase()) {
        case 'technology':
        case 'tecnologia':
          return l10n.categoryTechnology;
        case 'hospitality':
        case 'hostaleria':
          return l10n.categoryHospitality;
        case 'services':
        case 'servicios':
          return l10n.categoryServices;
        case 'industrial':
        case 'industria':
          return l10n.categoryIndustrial;
        case 'retail':
        case 'comercio':
          return l10n.categoryRetail;
        case 'healthcare':
        case 'health':
        case 'salud':
          return l10n.categoryHealth;
        case 'logistics':
        case 'logistica':
          return l10n.categoryLogistics;
        case 'education':
        case 'educacion':
          return l10n.categoryEducation;
        default:
          return sectorKey;
      }
    }

    final sectorFormatted = _selectedSector != null
        ? getLocalizedSectorName(_selectedSector!)
        : '-';
    final regionFormatted = _regionController.text.trim();
    final revenueFormatted = _selectedRevenueRange != null
        ? Offer.formatRevenueRange(_selectedRevenueRange!)
        : '-';
    final employeesFormatted = _selectedEmployeeRange != null
        ? Offer.formatEmployeeRange(_selectedEmployeeRange!)
        : '-';
    final yearFormatted = _yearController.text.trim().isEmpty
        ? '-'
        : _yearController.text.trim();
    final descFormatted = _companyDescController.text.trim();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = theme.brightness == Brightness.dark;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.payment_rounded,
                            color: theme.colorScheme.primary,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                summaryHeader,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: theme.colorScheme.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSummaryBox(
                                      labelSector,
                                      sectorFormatted,
                                      Icons.category_outlined,
                                      theme,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildSummaryBox(
                                      labelRegion,
                                      regionFormatted,
                                      Icons.location_on_outlined,
                                      theme,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSummaryBox(
                                      labelRevenue,
                                      revenueFormatted,
                                      Icons.monetization_on_outlined,
                                      theme,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildSummaryBox(
                                      labelEmployees,
                                      employeesFormatted,
                                      Icons.people_outline,
                                      theme,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildSummaryBox(
                                labelYear,
                                yearFormatted,
                                Icons.calendar_today_outlined,
                                theme,
                                isFullWidth: true,
                              ),
                              const SizedBox(height: 8),
                              _buildDescriptionBox(labelDescription, descFormatted, theme),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              cancelText,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _submit();
                            },
                            icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                            label: Text(confirmText),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
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
      },
    );
  }

  Widget _buildSummaryBox(
    String label,
    String value,
    IconData icon,
    ThemeData theme, {
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.65,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 12,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionBox(String label, String value, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.65,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 9,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              height: 1.35,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark
        ? theme.colorScheme.surface
        : theme.colorScheme.onSurface.withValues(alpha: 0.05);

    String getLocalizedSectorName(String sectorKey) {
      switch (sectorKey.toLowerCase()) {
        case 'technology':
        case 'tecnologia':
          return l10n.categoryTechnology;
        case 'hospitality':
        case 'hostaleria':
          return l10n.categoryHospitality;
        case 'services':
        case 'servicios':
          return l10n.categoryServices;
        case 'industrial':
        case 'industria':
          return l10n.categoryIndustrial;
        case 'retail':
        case 'comercio':
          return l10n.categoryRetail;
        case 'healthcare':
        case 'health':
        case 'salud':
          return l10n.categoryHealth;
        case 'logistics':
        case 'logistica':
          return l10n.categoryLogistics;
        case 'education':
        case 'educacion':
          return l10n.categoryEducation;
        default:
          return sectorKey;
      }
    }

    final List<String> sectorOptions = [
      'TECHNOLOGY',
      'HOSPITALITY',
      'SERVICES',
      'INDUSTRIAL',
      'RETAIL',
      'HEALTHCARE',
      'LOGISTICS',
      'EDUCATION',
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.offerCreateTitle), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errorMessage != null) ...[
                  ErrorBanner(message: _errorMessage!),
                  const SizedBox(height: 20),
                ],
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
                        color: theme.colorScheme.shadow.withValues(alpha: 0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDropdown(
                        label: l10n.offerSectorLabel,
                        hint: l10n.offerSectorHint,
                        value: _selectedSector,
                        items: sectorOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Text(
                              getLocalizedSectorName(opt),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: _isLoading
                            ? null
                            : (val) => setState(() => _selectedSector = val),
                        theme: theme,
                        fillColor: fillColor,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.errorRequiredField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _regionController,
                        label: l10n.offerRegionLabel,
                        hint: l10n.offerRegionHint,
                        icon: Icons.location_on_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.errorRequiredField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildDropdown(
                        label: l10n.offerRevenueLabel,
                        hint: l10n.homeFilters,
                        value: _selectedRevenueRange,
                        items: Offer.revenueOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Text(
                              Offer.formatRevenueRange(opt),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: _isLoading
                            ? null
                            : (val) =>
                                  setState(() => _selectedRevenueRange = val),
                        theme: theme,
                        fillColor: fillColor,
                      ),
                      const SizedBox(height: 20),
                      _buildDropdown(
                        label: l10n.offerEmployeesLabel,
                        hint: l10n.homeFilters,
                        value: _selectedEmployeeRange,
                        items: Offer.employeeOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Text(
                              Offer.formatEmployeeRange(opt),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: _isLoading
                            ? null
                            : (val) =>
                                  setState(() => _selectedEmployeeRange = val),
                        theme: theme,
                        fillColor: fillColor,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _yearController,
                        label: l10n.offerYearLabel,
                        hint: l10n.offerYearHint,
                        icon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final val = int.tryParse(value.trim());
                            if (val == null ||
                                val < 1800 ||
                                val > DateTime.now().year + 1) {
                              return l10n.offerErrorInvalidYear;
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _companyDescController,
                        label: l10n.offerDescLabel,
                        hint: l10n.offerDescHint,
                        icon: Icons.description_outlined,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.errorRequiredField;
                          }
                          if (value.trim().length < 10) {
                            return l10n.offerErrorDescTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _extendedDescController,
                        label: l10n.offerExtendedLabel,
                        hint: l10n.offerExtendedHint,
                        icon: Icons.notes_outlined,
                        maxLines: 5,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _onContinueToPayment,
                        style: theme.elevatedButtonTheme.style?.copyWith(
                          elevation: const WidgetStatePropertyAll(0),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.offerPaymentContinueButton),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?>? onChanged,
    required ThemeData theme,
    required Color fillColor,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(20),
          hint: Text(
            hint,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 16,
            ),
          ),
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
          dropdownColor: theme.colorScheme.surfaceContainerHigh,
          icon: Icon(
            Icons.arrow_drop_down,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.list_outlined,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: theme.colorScheme.secondary,
                width: 1.5,
              ),
            ),
          ),
          items: items,
        ),
      ],
    );
  }
}
