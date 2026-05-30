import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models/offer_model.dart';
import '../data/models/solicitud_model.dart';
import '../data/providers/offers_provider.dart';
import '../data/providers/solicitud_provider.dart';
import '../data/services/offer_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/request_status_badge.dart';
import 'offer_details_screen.dart';
import 'solicitud_details_screen.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final receivedRequestsAsync = ref.watch(receivedRequestsProvider);
    final sentRequestsAsync = ref.watch(sentRequestsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.inboxTitle,
            style: GoogleFonts.inter(fontWeight: FontWeight.w800),
          ),
          elevation: 0,
          bottom: TabBar(
            indicatorColor: theme.brightness == Brightness.dark
                ? const Color(0xFF10B981)
                : theme.colorScheme.primary,
            labelColor: theme.brightness == Brightness.dark
                ? const Color(0xFF10B981)
                : theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
            unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
            tabs: [
              Tab(text: l10n.inboxTabReceived),
              Tab(text: l10n.inboxTabSent),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReceivedTab(context, ref, receivedRequestsAsync),
            _buildSentTab(context, ref, sentRequestsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedTab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Solicitud>> receivedRequestsAsync,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return receivedRequestsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                l10n.inboxErrorLoading,
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString().replaceAll('Exception: ', ''),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(receivedRequestsProvider),
                child: Text(l10n.inboxRetry),
              ),
            ],
          ),
        ),
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0x1A10B981) : theme.colorScheme.primary.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 64,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.inboxEmptyReceived,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final offer = request.opportunity;
            final status = request.status;

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SolicitudDetailsScreen(solicitud: request),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(
                      alpha: isDark ? 0.15 : 0.45,
                    ),
                  ),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            offer.sector.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: isDark ? const Color(0xFF10B981) : theme.colorScheme.secondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        RequestStatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            offer.companyDescription,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${l10n.fullNameLabel}: ${request.interestedUser.fullName}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.offerApplyBackgroundLabel.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.professionalBackground ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            height: 1.4,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.offerApplyBioLabel.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.bio ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            height: 1.4,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (status == 'PENDING') ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              try {
                                await ref.read(receivedRequestsProvider.notifier).rejectRequest(request.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${l10n.inboxStatusRejected} ${l10n.inboxStatusUpdatedSuccessfully}'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              } catch (err) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${err.toString().replaceAll('Exception: ', '')}'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              side: const BorderSide(color: Colors.redAccent, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              l10n.inboxActionReject,
                              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await ref.read(receivedRequestsProvider.notifier).acceptRequest(request.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${l10n.inboxStatusAccepted} ${l10n.inboxStatusUpdatedSuccessfully}'),
                                      backgroundColor: isDark ? const Color(0xFF10B981) : theme.colorScheme.secondary,
                                    ),
                                  );
                                }
                              } catch (err) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${err.toString().replaceAll('Exception: ', '')}'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? const Color(0xFF10B981) : theme.colorScheme.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              l10n.inboxActionAccept,
                              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
        );
      },
    );
  }

  Widget _buildSentTab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Solicitud>> sentRequestsAsync,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return sentRequestsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                l10n.inboxErrorLoading,
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString().replaceAll('Exception: ', ''),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(sentRequestsProvider),
                child: Text(l10n.inboxRetry),
              ),
            ],
          ),
        ),
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0x1A10B981) : theme.colorScheme.primary.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      size: 64,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.inboxEmptySent,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final offer = request.opportunity;
            final status = request.status;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(
                    alpha: isDark ? 0.15 : 0.45,
                  ),
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          offer.sector.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF10B981) : theme.colorScheme.secondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      RequestStatusBadge(status: status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _navigateToOffer(context, ref, offer),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            offer.companyDescription,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${l10n.inboxOwnerLabel}: ${request.owner.fullName.isNotEmpty ? request.owner.fullName : l10n.inboxNotAvailable}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.offerApplyBackgroundLabel.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.professionalBackground ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            height: 1.4,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.offerApplyBioLabel.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.bio ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            height: 1.4,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToOffer(BuildContext context, WidgetRef ref, Offer partialOffer) {
    final allOffersAsync = ref.read(offersProvider);
    Offer? fullOffer;
    if (allOffersAsync is AsyncData<OffersState>) {
      final match = allOffersAsync.value.items.where((o) => o.id == partialOffer.id);
      if (match.isNotEmpty) {
        fullOffer = match.first;
      }
    }

    if (fullOffer != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OfferDetailsScreen(offer: fullOffer!),
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
          ),
        ),
      );

      ref.read(offerServiceProvider).getOfferById(partialOffer.id).then((full) {
        if (!context.mounted) return;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferDetailsScreen(offer: full),
          ),
        );
      }).catchError((err) {
        if (!context.mounted) return;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferDetailsScreen(offer: partialOffer),
          ),
        );
      });
    }
  }
}
