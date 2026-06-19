import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/offer_model.dart';
import '../data/providers/offers_provider.dart';
import '../data/services/offer_service.dart';
import '../l10n/app_localizations.dart';
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
    if (!_formKey.currentState!.validate()) return;

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

      await ref
          .read(offerServiceProvider)
          .createOffer(
            region: region,
            sector: sector,
            revenueRange: _selectedRevenueRange,
            creationYear: year,
            employeeRange: _selectedEmployeeRange,
            companyDescription: companyDesc,
            extendedDescription: extendedDesc.isEmpty ? null : extendedDesc,
          );

      ref.invalidate(offersProvider);

      if (mounted) {
        Navigator.pop(context);
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
                    AppLocalizations.of(context)!.offerPublishSuccess,
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
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
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
      final String locale = Localizations.localeOf(context).languageCode;
      switch (sectorKey) {
        case 'tecnologia':
          return locale == 'ca' ? 'Tecnologia' : locale == 'en' ? 'Technology' : 'Tecnología';
        case 'hostaleria':
          return locale == 'ca' ? 'Hostaleria' : locale == 'en' ? 'Hospitality' : 'Hostelería';
        case 'servicios':
          return locale == 'ca' ? 'Serveis' : locale == 'en' ? 'Services' : 'Servicios';
        case 'industria':
          return locale == 'ca' ? 'Indústria' : locale == 'en' ? 'Industry' : 'Industria';
        case 'comercio':
          return locale == 'ca' ? 'Comerç' : locale == 'en' ? 'Commerce' : 'Comercio';
        default:
          return sectorKey;
      }
    }
    final List<String> sectorOptions = ['tecnologia', 'hostaleria', 'servicios', 'industria', 'comercio'];

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
                        onPressed: _isLoading ? null : _submit,
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
                            : Text(l10n.offerPublishButton),
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
          value: value,
          isExpanded: true,
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
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
          ),
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
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
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
