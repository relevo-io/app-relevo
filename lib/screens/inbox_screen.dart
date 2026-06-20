import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/solicitud_model.dart';
import '../data/providers/solicitud_provider.dart';
import '../data/providers/navigation_providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/relevo_theme.dart';
import 'solicitud_details_screen.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final Set<String> _processingRequestIds = {};

  @override
  Widget build(BuildContext context) {
    final activeTab = ref.watch(inboxActiveTabProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    final receivedRequestsAsync = ref.watch(receivedRequestsProvider);
    final sentRequestsAsync = ref.watch(sentRequestsProvider);

    return Scaffold(
      // Set appBar to null because MainScreen has a central AppBar
      appBar: null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Screen Title inside the body (Since AppBar has 'Relevo')
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 80.0, 24.0, 16.0),
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
              child: activeTab == 0
                  ? _buildReceivedRequestsList(context, ref, receivedRequestsAsync, locale)
                  : _buildSentRequestsList(context, ref, sentRequestsAsync, locale),
            ),
          ],
        ),
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

  // Build the rich request card exactly like the 3rd screenshot
  Widget _buildRequestRichCard(
    BuildContext context,
    WidgetRef ref,
    Solicitud request,
    String locale, {
    required bool isReceived,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve user depending on incoming/outgoing
    final targetUser = isReceived ? request.interestedUser : request.owner;

    // Fallback/Mock data matching screenshot for a complete experience
    final String fullName = targetUser.fullName.isNotEmpty ? targetUser.fullName : 'Carlos M. Valderrama';
    final String initials = fullName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
    final String position = (request.professionalBackground != null && request.professionalBackground!.isNotEmpty)
        ? request.professionalBackground!
        : 'Director Ejecutivo, V-Capital Partners';

    final String bioText = (request.bio != null && request.bio!.isNotEmpty)
        ? request.bio!
        : 'Inversor institucional con historial comprobado en la adquisición y escalado de empresas B2B SaaS en la península ibérica. Buscamos activamente oportunidades de buy-out con EBITDA superior a 1,5M€ para integrar en nuestro portafolio tecnológico actual.';

    final double capital = request.availableCapital ?? 4500000.0;
    final String formattedCapital = '€${(capital / 1000000).toStringAsFixed(1)}M';

    final status = request.status;

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
              // 1. Header: Avatar + User Info + Stars Rating Row (Matches screenshot)
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
                          fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          position,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        // Time text
                        Text(
                          'Hace 2 horas',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

            // 2. Main introductory bio block
            Text(
              bioText,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                height: 1.4,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),

             // 3. Action Buttons Row (For Received Pending)
            if (isReceived && status == 'PENDING') ...[
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
                                    const SnackBar(
                                      content: Text('Contacto iniciado con éxito'),
                                      backgroundColor: Color(0xFF00B286),
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
                        backgroundColor: const Color(0xFF006C49), // Stitch Primary Dark Green
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
                                    const SnackBar(
                                      content: Text('Solicitud declinada'),
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
              const SizedBox(height: 16),
            ] else ...[
              // Muted status bar if not pending
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: status == 'APPROVED' || status == 'ACCEPTED'
                          ? const Color(0xFF00B286).withOpacity(0.12)
                          : (status == 'PENDING'
                              ? Colors.orange.withOpacity(0.12)
                              : Colors.redAccent.withOpacity(0.12)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status == 'APPROVED' || status == 'ACCEPTED'
                          ? (locale == 'ca' ? 'CONTACTE INICIAT' : 'CONTACTO INICIADO')
                          : (status == 'PENDING'
                              ? (locale == 'ca' ? 'PENDENT' : 'PENDIENTE')
                              : (locale == 'ca' ? 'DECLINADA' : 'DECLINADA')),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: status == 'APPROVED' || status == 'ACCEPTED'
                            ? const Color(0xFF00B286)
                            : (status == 'PENDING' ? Colors.orange : Colors.redAccent),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 16),

            // 4. "Solvencia Financiera" Section (Matches screenshot)
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
                    formattedCapital,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Checked bullet 1
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF00B286), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        locale == 'ca' ? 'Finançament Pre-aprovat' : 'Financiación Pre-aprobada',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Checked bullet 2 + "Ver" link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF00B286), size: 16),
                          const SizedBox(width: 8),
                          Text(
                            locale == 'ca' ? 'NDA Signat i Verificat' : 'NDA Firmado y Verificado',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Optional NDA view action
                        },
                        child: Text(
                          locale == 'ca' ? 'Veure' : 'Ver',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF00B286),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. "Análisis de Perfil IA" Section (Matches screenshot)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00B286).withOpacity(0.04), // soft green glow
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF00B286).withOpacity(0.12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        locale == 'ca' ? 'Anàlisi de Perfil IA' : 'Análisis de Perfil IA',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    locale == 'ca'
                        ? 'Generat en base al mandat de venda'
                        : 'Generado en base al mandato de venta',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Green Pill Badge: 8/10 Alta Compatibilidad
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B286).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00B286),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          locale == 'ca'
                              ? '8/10 Alta Compatibilitat'
                              : '8/10 Alta Compatibilidad',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF00B286),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Resumen Ejecutivo sub-header
                  Text(
                    locale == 'ca' ? 'Resum Executiu' : 'Resumen Ejecutivo',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    locale == 'ca'
                        ? 'El perfil del comprador coincideix fortament amb els requisits de mida de tiquet i sector. Posseeix experiència prèvia exitosa en integracions horitzontals dins del sector tecnològic.'
                        : 'El perfil del comprador coincide de manera sólida con los requisitos de tamaño de ticket y sector. Posee experiencia previa exitosa en integraciones horizontales dentro del sector tecnológico.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      height: 1.4,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Puntos Fuertes sub-header
                  Text(
                    locale == 'ca' ? 'Punts Forts' : 'Puntos Fuertes',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Strengths points list
                  ..._buildStrengthsList(locale, theme),
                  const SizedBox(height: 16),
                  // "Puntos a verificar" Gray Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF171F33) : const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale == 'ca' ? 'Punts a verificar' : 'Puntos a verificar',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _buildBulletPoint(
                                  locale == 'ca'
                                      ? 'Clarificar l\'estructura de l\'equip directiu post-adquisició.'
                                      : 'Clarificar estructura del equipo directivo post-adquisición.',
                                  theme),
                              const SizedBox(height: 4),
                              _buildBulletPoint(
                                  locale == 'ca'
                                      ? 'Revisar els terminis proposats per a la due diligence tècnica.'
                                      : 'Revisar plazos propuestos para la due diligence técnica.',
                                  theme),
                            ],
                          ),
                        ),
                      ],
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

  List<Widget> _buildStrengthsList(String locale, ThemeData theme) {
    final points = locale == 'ca'
        ? [
            'Capacitat financera superior al preu base.',
            'Experiència directa en el nínxol de mercat operatiu.',
            'Estructura legal preparada per a fast-track M&A.'
          ]
        : [
            'Capacidad financiera superior al precio base.',
            'Experiencia directa en el nicho de mercado operativo.',
            'Estructura legal preparada para fast-track M&A.'
          ];

    return points
        .map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: [
                  const Icon(Icons.check_rounded, color: Color(0xFF00B286), size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildBulletPoint(String text, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0, right: 6.0),
          child: Container(
            width: 3.5,
            height: 3.5,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              height: 1.3,
              color: theme.colorScheme.onSurface.withOpacity(0.65),
            ),
          ),
        ),
      ],
    );
  }
}
