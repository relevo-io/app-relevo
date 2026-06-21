import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/solicitud_model.dart';
import '../data/providers/solicitud_provider.dart';
import '../data/providers/navigation_providers.dart';
import 'solicitud_details_screen.dart';
import '../l10n/app_localizations.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(inboxActiveTabProvider);
    _pageController = PageController(initialPage: initialTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = ref.watch(inboxActiveTabProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final receivedRequestsAsync = ref.watch(receivedRequestsProvider);
    final sentRequestsAsync = ref.watch(sentRequestsProvider);
    final topPadding = MediaQuery.of(context).padding.top + 20.0;



    ref.listen<int>(inboxActiveTabProvider, (previous, next) {
      if (_pageController.hasClients && _pageController.page?.round() != next) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      // Set appBar to null because MainScreen has a central AppBar
      appBar: null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Screen Title inside the body (Since AppBar has 'Relevo')
          Padding(
            padding: EdgeInsets.fromLTRB(24.0, topPadding, 24.0, 16.0),
            child: Text(
              l10n.inboxTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ),

            // Custom Segmented Tab Controller (Matches 3rd screenshot)
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF171F33) : const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => ref.read(inboxActiveTabProvider.notifier).setTab(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: activeTab == 0
                                ? (isDark ? const Color(0xFF0B1326) : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: activeTab == 0
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            l10n.inboxReceived,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: activeTab == 0
                                  ? (isDark ? const Color(0xFF4EDE83) : const Color(0xFF006C49))
                                  : theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => ref.read(inboxActiveTabProvider.notifier).setTab(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: activeTab == 1
                                ? (isDark ? const Color(0xFF0B1326) : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: activeTab == 1
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            l10n.inboxSent,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: activeTab == 1
                                  ? (isDark ? const Color(0xFF4EDE83) : const Color(0xFF006C49))
                                  : theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab View Body
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  ref.read(inboxActiveTabProvider.notifier).setTab(index);
                },
                children: [
                  _buildReceivedRequestsList(context, ref, receivedRequestsAsync),
                  _buildSentRequestsList(context, ref, sentRequestsAsync),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildReceivedRequestsList(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Solicitud>> requestsAsync,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return requestsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B286)),
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
                l10n.errorLoading,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString().replaceAll('Exception: ', ''),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(receivedRequestsProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 64,
                      color: Color(0xFF00B286),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.inboxNoReceivedRequests,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(receivedRequestsProvider);
            try {
              await ref.read(receivedRequestsProvider.future);
            } catch (_) {}
          },
          color: const Color(0xFF00B286),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return _buildRequestRichCard(context, ref, request, isReceived: true);
            },
          ),
        );
      },
    );
  }

  Widget _buildSentRequestsList(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Solicitud>> requestsAsync,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return requestsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B286)),
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
                l10n.errorLoading,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString().replaceAll('Exception: ', ''),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(sentRequestsProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.outbox_rounded,
                      size: 64,
                      color: Color(0xFF00B286),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.inboxNoSentRequests,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(sentRequestsProvider);
            try {
              await ref.read(sentRequestsProvider.future);
            } catch (_) {}
          },
          color: const Color(0xFF00B286),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return _buildRequestRichCard(context, ref, request, isReceived: false);
            },
          ),
        );
      },
    );
  }

  // Build the compact request card
  Widget _buildRequestRichCard(
    BuildContext context,
    WidgetRef ref,
    Solicitud request, {
    required bool isReceived,
  }) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Resolve target user depending on incoming/outgoing
    final targetUser = isReceived ? request.interestedUser : request.owner;
    final String fullName = targetUser.fullName.isNotEmpty ? targetUser.fullName : 'Usuario';
    final String initials = fullName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
    final String email = targetUser.email;

    // Resolving position/background
    final String position = (request.professionalBackground != null && request.professionalBackground!.isNotEmpty)
        ? request.professionalBackground!
        : (targetUser.professionalBackground != null && targetUser.professionalBackground!.isNotEmpty
            ? targetUser.professionalBackground!
            : l10n.inboxNoProfessionalBackground);

    // Status mapping & styling
    final status = request.status;
    Color statusBgColor;
    Color statusTextColor;
    String statusLabel;

    if (status == 'APPROVED' || status == 'ACCEPTED') {
      statusBgColor = const Color(0xFF00B286).withValues(alpha: 0.12);
      statusTextColor = const Color(0xFF00B286);
      statusLabel = l10n.statusAcceptedLabel;
    } else if (status == 'REJECTED') {
      statusBgColor = Colors.redAccent.withValues(alpha: 0.12);
      statusTextColor = Colors.redAccent;
      statusLabel = l10n.statusDeclinedLabel;
    } else {
      statusBgColor = Colors.orange.withValues(alpha: 0.12);
      statusTextColor = Colors.orange;
      statusLabel = l10n.statusPendingLabel;
    }

    // Ratings
    final rating = isReceived ? targetUser.ratingAsInterested : targetUser.ratingAsOwner;
    final bool hasRating = rating != null && rating.count > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SolicitudDetailsScreen(solicitud: request),
            ),
          ).then((_) {
            ref.invalidate(receivedRequestsProvider);
            ref.invalidate(sentRequestsProvider);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header: Opportunity Sector + Region + Status Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${request.opportunity.sector} - ${request.opportunity.region}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          request.createdAt != null
                              ? (isReceived
                                  ? l10n.inboxReceivedOn(DateFormat('dd/MM/yyyy').format(request.createdAt!))
                                  : l10n.inboxSentOn(DateFormat('dd/MM/yyyy').format(request.createdAt!)))
                              : '',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: 12),

              // 2. User Info: Avatar + Label + Name + Ratings + Email
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isReceived
                              ? l10n.inboxRequestFrom(fullName)
                              : l10n.inboxRequestSentTo(fullName),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (hasRating) ...[
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                '${rating.average.toStringAsFixed(1)} ',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 11,
                                ),
                              ),
                            ] else ...[
                              Text(
                                l10n.inboxNoRatings,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                email,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 3. Trajectory preview or business description preview
              const SizedBox(height: 12),
              if (isReceived) ...[
                if (position.isNotEmpty && position != 'Sin trayectoria profesional especificada.' && position != 'Sense trajectòria professional especificada.') ...[
                  Text(
                    position,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      height: 1.3,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                // Solvency Tags row
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.euro_symbol_rounded, size: 12, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            request.availableCapital != null
                                ? NumberFormat.currency(locale: 'es_ES', symbol: '€', decimalDigits: 0).format(request.availableCapital)
                                : l10n.inboxNotSpecified,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l10n.inboxFinancingLabel(request.financingNeeded == true ? l10n.yesLabel : l10n.noLabel),
                        style: TextStyle(
                          fontSize: 10.5,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: request.ndaAccepted == true
                            ? const Color(0xFF00B286).withValues(alpha: 0.08)
                            : Colors.orange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        request.ndaAccepted == true
                            ? l10n.inboxNdaSigned
                            : l10n.inboxNoNda,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: request.ndaAccepted == true ? const Color(0xFF00B286) : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                if (request.opportunity.companyDescription.isNotEmpty) ...[
                  Text(
                    request.opportunity.companyDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      height: 1.3,
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
