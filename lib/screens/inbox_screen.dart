import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../data/models/solicitud_model.dart';
import '../data/models/chat_model.dart';
import '../data/providers/solicitud_provider.dart';
import '../data/providers/navigation_providers.dart';
import '../data/services/chat_service.dart';
import '../data/services/solicitud_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/relevo_theme.dart';
import 'solicitud_details_screen.dart';
import 'chat_room_screen.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final Set<String> _processingRequestIds = {};
  final Set<String> _analyzingRequestIds = {};
  final Set<String> _expandedAiRequestIds = {};
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
    final locale = Localizations.localeOf(context).languageCode;

    final receivedRequestsAsync = ref.watch(receivedRequestsProvider);
    final sentRequestsAsync = ref.watch(sentRequestsProvider);
    final topPadding = MediaQuery.of(context).padding.top + 16.0;



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
              locale == 'ca' ? 'Sol·licituds d\'Interès' : 'Solicitudes de Interés',
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
                            locale == 'ca' ? 'Rebudes' : 'Recibidas',
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
                            locale == 'ca' ? 'Enviades' : 'Enviadas',
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
                  _buildReceivedRequestsList(context, ref, receivedRequestsAsync, locale),
                  _buildSentRequestsList(context, ref, sentRequestsAsync, locale),
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
    String locale,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                locale == 'ca' ? 'Error al carregar' : 'Error al cargar',
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
                    locale == 'ca'
                        ? 'No has rebut cap sol·licitud d\'interès encara.'
                        : 'No has recibido ninguna solicitud de interés todavía.',
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
              return _buildRequestRichCard(context, ref, request, locale, isReceived: true);
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
    String locale,
  ) {
    final theme = Theme.of(context);

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
                locale == 'ca' ? 'Error al carregar' : 'Error al cargar',
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
                    locale == 'ca'
                        ? 'No has enviat cap sol·licitud d\'interès encara.'
                        : 'No has enviado ninguna solicitud de interés todavía.',
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
              return _buildRequestRichCard(context, ref, request, locale, isReceived: false);
            },
          ),
        );
      },
    );
  }

  // Build the rich request card exactly like the 3rd screenshot / Angular template
  Widget _buildRequestRichCard(
    BuildContext context,
    WidgetRef ref,
    Solicitud request,
    String locale, {
    required bool isReceived,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
            : (locale == 'ca' ? 'Sense trajectòria professional especificada.' : 'Sin trayectoria profesional especificada.'));

    final String bioText = (request.bio != null && request.bio!.isNotEmpty)
        ? request.bio!
        : (targetUser.bio != null && targetUser.bio!.isNotEmpty)
            ? targetUser.bio!
            : (locale == 'ca' ? 'Sense biografia especificada.' : 'Sin biografía especificada.');

    // Status mapping & styling
    final status = request.status;
    Color statusBgColor;
    Color statusTextColor;
    String statusLabel;

    if (status == 'APPROVED' || status == 'ACCEPTED') {
      statusBgColor = const Color(0xFF00B286).withOpacity(0.12);
      statusTextColor = const Color(0xFF00B286);
      statusLabel = locale == 'ca' ? 'ACEPTADA' : 'ACEPTADA';
    } else if (status == 'REJECTED') {
      statusBgColor = Colors.redAccent.withOpacity(0.12);
      statusTextColor = Colors.redAccent;
      statusLabel = locale == 'ca' ? 'DECLINADA' : 'DECLINADA';
    } else {
      statusBgColor = Colors.orange.withOpacity(0.12);
      statusTextColor = Colors.orange;
      statusLabel = locale == 'ca' ? 'PENDENT' : 'PENDIENTE';
    }

    // Ratings
    final rating = isReceived ? targetUser.ratingAsInterested : targetUser.ratingAsOwner;
    final bool hasRating = rating != null && rating.count > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SolicitudDetailsScreen(solicitud: request),
            ),
          );
        },
        child: RelevoCard(
          color: theme.colorScheme.surfaceContainer,
          padding: const EdgeInsets.all(20.0),
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
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (request.opportunity.companyDescription.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            request.opportunity.companyDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 12.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          request.createdAt != null
                              ? DateFormat('dd/MM/yyyy').format(request.createdAt!)
                              : '',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
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
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: 16),

              // 2. User Info: Avatar + Label + Name + Ratings + Email
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isReceived
                              ? (locale == 'ca' ? 'Sol·licitud de:' : 'Solicitud de:')
                              : (locale == 'ca' ? 'Enviat a:' : 'Enviado a:'),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (hasRating) ...[
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                '${rating.average.toStringAsFixed(1)} ',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '(${rating.count} ${rating.count == 1 ? (locale == 'ca' ? 'valoració' : 'valoración') : (locale == 'ca' ? 'valoracions' : 'valoraciones')})',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ] else ...[
                              Text(
                                locale == 'ca' ? 'Sense valoracions' : 'Sin valoraciones',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Bio & Professional Background
              if (bioText.isNotEmpty && bioText != 'Sin biografía especificada.' && bioText != 'Sense biografia especificada.') ...[
                Text(
                  locale == 'ca' ? 'Presentació' : 'Presentación',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bioText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              if (position.isNotEmpty && position != 'Sin trayectoria profesional especificada.' && position != 'Sense trajectòria professional especificada.') ...[
                Text(
                  locale == 'ca' ? 'Trajectòria professional' : 'Trayectoria profesional',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  position,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              if (request.preferredRegions != null && request.preferredRegions!.isNotEmpty) ...[
                Text(
                  locale == 'ca' ? 'Zones d\'interès' : 'Zonas de interés',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request.preferredRegions!.join(', '),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: 16),

              // 4. "Solvencia Financiera" Section
              Row(
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    locale == 'ca' ? 'Solvència Financera' : 'Solvencia Financiera',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Capital Liquido card sub-block
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF171F33) : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale == 'ca' ? 'CAPITAL LÍQUID ACREDITAT' : 'CAPITAL LÍQUIDO ACREDITADO',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      request.availableCapital != null
                          ? NumberFormat.currency(locale: 'es_ES', symbol: '€', decimalDigits: 0).format(request.availableCapital)
                          : (locale == 'ca' ? 'No especificat' : 'No especificado'),
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Requires Financing Row
                    Row(
                      children: [
                        Icon(
                          request.financingNeeded == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: request.financingNeeded == true ? const Color(0xFF00B286) : Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${locale == 'ca' ? 'Requereix finançament' : 'Requiere financiación'}: ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          request.financingNeeded != null
                              ? (request.financingNeeded!
                                  ? (locale == 'ca' ? 'Sí' : 'Sí')
                                  : (locale == 'ca' ? 'No' : 'No'))
                              : 'N/A',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // NDA Status Row
                    Row(
                      children: [
                        Icon(
                          request.ndaAccepted == true ? Icons.verified_user_rounded : Icons.lock_rounded,
                          color: request.ndaAccepted == true ? const Color(0xFF00B286) : Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${locale == 'ca' ? 'Estat NDA' : 'Estado NDA'}: ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          request.ndaAccepted == true
                              ? (locale == 'ca' ? 'NDA Signat i Verificat' : 'NDA Firmado y Verificado')
                              : (locale == 'ca' ? 'Sense NDA' : 'Sin NDA'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: request.ndaAccepted == true ? const Color(0xFF00B286) : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. "Análisis de Perfil IA" Section (Only Received & has cvKey)
              if (isReceived && request.cvKey != null && request.cvKey!.isNotEmpty) ...[
                _buildAiAnalysisSection(context, ref, request, locale, theme, isDark),
                const SizedBox(height: 20),
              ],

              // 6. Action Buttons Footer Row
              _buildActionsFooter(context, ref, request, locale, theme, isReceived),
            ],
          ),
        ),
      ),
    );
  }

  // Build the AI Analysis section dynamically matching the Angular states
  Widget _buildAiAnalysisSection(
    BuildContext context,
    WidgetRef ref,
    Solicitud request,
    String locale,
    ThemeData theme,
    bool isDark,
  ) {
    final String estado = request.estadoAnalisis ?? 'PENDIENTE';
    final bool isAnalyzing = _analyzingRequestIds.contains(request.id);

    // 1. Processing State
    if (estado == 'EN_PROCESO' || isAnalyzing) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF00B286).withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF00B286).withOpacity(0.12)),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B286)),
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale == 'ca' ? 'Analitzant currículum amb IA...' : 'Analizando currículum con IA...',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00B286),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    locale == 'ca'
                        ? 'Avaluant perfil i experiència, falta molt poc!'
                        : 'Evaluando perfil y experiencia, ¡falta muy poco!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 2. Error State
    if (estado == 'ERROR') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  locale == 'ca' ? 'Error en l\'anàlisi de IA' : 'Error en el análisis de IA',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              locale == 'ca'
                  ? 'No s\'ha pogut processar el currículum. Intenteu-ho de nou.'
                  : 'No se pudo procesar el currículum. Inténtelo de nuevo.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _triggerAiAnalysis(request, ref, locale),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(
                locale == 'ca' ? 'Reintentar' : 'Reintentar',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    // 3. Completed State
    if (estado == 'COMPLETADO' && request.resultadoIa != null) {
      final res = request.resultadoIa!;
      final isExpanded = _expandedAiRequestIds.contains(request.id);
      final double score = res.nota;
      
      Color scoreColor;
      Color scoreBg;
      if (score >= 8) {
        scoreColor = const Color(0xFF00B286);
        scoreBg = const Color(0xFF00B286).withOpacity(0.12);
      } else if (score >= 5) {
        scoreColor = Colors.orange;
        scoreBg = Colors.orange.withOpacity(0.12);
      } else {
        scoreColor = Colors.redAccent;
        scoreBg = Colors.redAccent.withOpacity(0.12);
      }

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF00B286).withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00B286).withOpacity(0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedAiRequestIds.remove(request.id);
                  } else {
                    _expandedAiRequestIds.add(request.id);
                  }
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome_outlined,
                          color: Color(0xFF00B286),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          locale == 'ca' ? 'Anàlisi de IA completat' : 'Análisis de IA completado',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: scoreBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${score.toStringAsFixed(0)}/10',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: scoreColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (isExpanded) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1, thickness: 0.5),
                    const SizedBox(height: 12),
                    
                    // Resumen Ejecutivo
                    Text(
                      locale == 'ca' ? 'Resum del Candidat' : 'Resumen del Candidato',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      res.resumen,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        height: 1.4,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Puntos Fuertes
                    if (res.puntosFuertes.isNotEmpty) ...[
                      Text(
                        locale == 'ca' ? 'Fortaleses Detectades' : 'Fortalezas Detectadas',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...res.puntosFuertes.map((pf) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_rounded, color: Color(0xFF00B286), size: 14),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                pf,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface.withOpacity(0.75),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: 12),
                    ],

                    // Experiencia Destacada
                    if (res.experienciaDestacada.isNotEmpty) ...[
                      Text(
                        locale == 'ca' ? 'Fites d\'Experiència' : 'Hitos de Experiencia',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...res.experienciaDestacada.map((exp) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.trending_flat_rounded, color: theme.colorScheme.primary, size: 14),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                exp,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface.withOpacity(0.75),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: 12),
                    ],

                    // Justificación / Comentario Nota
                    if (res.comentarioNota.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF171F33) : const Color(0xFFF1F3F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale == 'ca' ? 'Feedback d\'Idoneïtat' : 'Feedback de Idoneidad',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              res.comentarioNota,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11.5,
                                height: 1.3,
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }

    // 4. Pending State
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00B286).withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00B286).withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: Color(0xFF00B286), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  locale == 'ca'
                      ? 'Anàlisi de CV amb IA disponible'
                      : 'Análisis de CV con IA disponible',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00B286),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            locale == 'ca'
                ? 'Analitza el currículum d\'aquest candidat per avaluar la seva compatibilitat i experiència.'
                : 'Analiza el currículum de este candidato para evaluar compatibilidad y experiencia.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _triggerAiAnalysis(request, ref, locale),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006C49),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.psychology_rounded, size: 16),
            label: Text(
              locale == 'ca' ? 'Analitzar amb IA' : 'Analizar con IA',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Trigger CV analysis api
  Future<void> _triggerAiAnalysis(Solicitud request, WidgetRef ref, String locale) async {
    setState(() => _analyzingRequestIds.add(request.id));
    try {
      await ref.read(receivedRequestsProvider.notifier).analizarCv(request.id);
      setState(() {
        _expandedAiRequestIds.add(request.id);
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locale == 'ca'
                ? 'Anàlisi de currículum completat amb èxit'
                : 'Análisis de currículum completado con éxito'),
            backgroundColor: const Color(0xFF00B286),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${locale == 'ca' ? 'Error al analitzar CV' : 'Error al analizar CV'}: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _analyzingRequestIds.remove(request.id));
      }
    }
  }

  // View PDF CV url via url_launcher
  Future<void> _viewCvPdf(Solicitud request, WidgetRef ref, String locale) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B286)),
        ),
      ),
    );

    try {
      final String viewUrl = await ref.read(solicitudServiceProvider).getViewUrl(request.id);
      if (context.mounted) {
        Navigator.pop(context); // Close loader
        final Uri uri = Uri.parse(viewUrl);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (err) {
      if (context.mounted) {
        Navigator.pop(context); // Close loader
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locale == 'ca'
                ? 'No s\'ha pogut obrir el CV: $err'
                : 'No se pudo abrir el CV: $err'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Initiate or open chat room
  Future<void> _initiateChat(Solicitud request, WidgetRef ref, String locale, bool isReceived) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B286)),
        ),
      ),
    );

    try {
      final String? interestedId = isReceived ? request.interestedUser.id : null;
      final chat = await ref.read(chatServiceProvider).getOrCreateChat(
            request.opportunity.id,
            interestedId: interestedId,
          );
      if (context.mounted) {
        Navigator.pop(context); // Close loader
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(chatId: chat.id),
          ),
        );
      }
    } catch (err) {
      if (context.mounted) {
        Navigator.pop(context); // Close loader
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locale == 'ca'
                ? 'Error al obrir el xat: $err'
                : 'Error al abrir el chat: $err'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Render footer actions based on Received/Sent and status
  Widget _buildActionsFooter(
    BuildContext context,
    WidgetRef ref,
    Solicitud request,
    String locale,
    ThemeData theme,
    bool isReceived,
  ) {
    final status = request.status;
    final bool hasCv = request.cvKey != null && request.cvKey!.isNotEmpty;

    if (isReceived) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasCv) ...[
            ElevatedButton.icon(
              onPressed: () => _viewCvPdf(request, ref, locale),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                foregroundColor: theme.colorScheme.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
              label: Text(
                locale == 'ca' ? 'Veure CV' : 'Ver CV',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (status == 'PENDING') ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _processingRequestIds.contains(request.id)
                        ? null
                        : () async {
                            setState(() => _processingRequestIds.add(request.id));
                            try {
                              await ref.read(receivedRequestsProvider.notifier).acceptRequest(request.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(locale == 'ca'
                                        ? 'Contacte iniciat correctament'
                                        : 'Contacto iniciado con éxito'),
                                    backgroundColor: const Color(0xFF00B286),
                                  ),
                                );
                              }
                            } catch (err) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${err.toString()}')),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _processingRequestIds.remove(request.id));
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006C49),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: _processingRequestIds.contains(request.id)
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded, size: 16),
                    label: Text(
                      locale == 'ca' ? 'Acceptar' : 'Aceptar',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _processingRequestIds.contains(request.id)
                        ? null
                        : () async {
                            setState(() => _processingRequestIds.add(request.id));
                            try {
                              await ref.read(receivedRequestsProvider.notifier).rejectRequest(request.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(locale == 'ca'
                                        ? 'Sol·licitud declinada'
                                        : 'Solicitud declinada'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            } catch (err) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${err.toString()}')),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _processingRequestIds.remove(request.id));
                              }
                            }
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.4)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      locale == 'ca' ? 'Declinar' : 'Declinar',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (status == 'APPROVED' || status == 'ACCEPTED') ...[
            ElevatedButton.icon(
              onPressed: () => _initiateChat(request, ref, locale, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006C49),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
              label: Text(
                locale == 'ca' ? 'Contactar interessat' : 'Contactar interesado',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ],
      );
    } else {
      // Sent requests tab actions
      final String resolvedAsStr = locale == 'ca' ? 'Resolta com a' : 'Resuelta como';
      
      String displayStatusText = status;
      if (status == 'PENDING') {
        displayStatusText = locale == 'ca' ? 'Pendent' : 'Pendiente';
      } else if (status == 'REJECTED') {
        displayStatusText = locale == 'ca' ? 'Declinada' : 'Declinada';
      } else if (status == 'ACCEPTED' || status == 'APPROVED') {
        displayStatusText = locale == 'ca' ? 'Acceptada' : 'Aceptada';
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasCv) ...[
            ElevatedButton.icon(
              onPressed: () => _viewCvPdf(request, ref, locale),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                foregroundColor: theme.colorScheme.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
              label: Text(
                locale == 'ca' ? 'El meu CV' : 'Mi CV',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (status == 'ACCEPTED' || status == 'APPROVED') ...[
            ElevatedButton.icon(
              onPressed: () => _initiateChat(request, ref, locale, false),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006C49),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
              label: Text(
                locale == 'ca' ? 'Contactar propietari' : 'Contactar propietario',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Text(
                '$resolvedAsStr: $displayStatusText',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: status == 'PENDING' ? Colors.orange : Colors.redAccent,
                ),
              ),
            ),
          ],
        ],
      );
    }
  }
}
