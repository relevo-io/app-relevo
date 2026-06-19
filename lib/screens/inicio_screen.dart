import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/providers/auth_provider.dart';
import '../data/providers/chat_providers.dart';
import '../data/providers/solicitud_provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/relevo_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'offer_details_screen.dart';
import '../data/models/offer_model.dart';

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final isLoggedIn = user != null;
    final theme = Theme.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (isLoggedIn) {
            ref.invalidate(receivedRequestsProvider);
            ref.invalidate(sentRequestsProvider);
            ref.invalidate(chatsListProvider);
          }
        },
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (isLoggedIn)
              _buildLoggedInHeader(context, user)
            else
              _buildGuestHero(context, localeCode),

            // Metrics Bento Grid (Shared for both!)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localeCode == 'ca'
                          ? 'Estat del Mercat M&A'
                          : localeCode == 'es'
                              ? 'Estado del Mercado M&A'
                              : 'M&A Market Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RelevoCard(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localeCode == 'ca'
                                      ? 'VALOR TRANSACCIONAT'
                                      : localeCode == 'en'
                                          ? 'TRANSACTION VALUE'
                                          : 'VALOR TRANSACCIONADO',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '€4.2M',
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  localeCode == 'ca'
                                      ? 'Capital mobilitzat aquest trimestre.'
                                      : localeCode == 'en'
                                          ? 'Capital mobilized this quarter.'
                                          : 'Capital movilizado este trimestre.',
                                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RelevoCard(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localeCode == 'ca'
                                      ? 'EMPRESES ACTIVES'
                                      : localeCode == 'en'
                                          ? 'ACTIVE BUSINESSES'
                                          : 'EMPRESAS ACTIVAS',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '128',
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  localeCode == 'ca'
                                      ? 'Oportunitats de negoci.'
                                      : localeCode == 'en'
                                          ? 'Business opportunities.'
                                          : 'Oportunidades de negocio.',
                                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RelevoCard(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localeCode == 'ca'
                                      ? 'TAXA D\'ÈXIT'
                                      : localeCode == 'en'
                                          ? 'SUCCESS RATE'
                                          : 'TASA DE ÉXITO',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '94%',
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  localeCode == 'ca'
                                      ? 'Continuïtat operativa.'
                                      : localeCode == 'en'
                                          ? 'Operating continuity.'
                                          : 'Continuidad operativa.',
                                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Activity Summary dashboard for logged in users
            if (isLoggedIn)
              _buildActivityDashboard(context, ref, localeCode)
            else
              const SliverToBoxAdapter(child: SizedBox.shrink()),

            // Featured Opportunity Section (Shared!)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localeCode == 'ca'
                          ? 'Destacat de la Setmana'
                          : localeCode == 'es'
                              ? 'Destacado de la Semana'
                              : 'Featured Weekly Deal',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RelevoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 180,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=700&auto=format&fit=crop&q=60'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.4),
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: theme.colorScheme.primary.withOpacity(0.4)),
                                    ),
                                    child: Text(
                                      localeCode == 'ca'
                                          ? 'OPORTUNITAT DESTACADA'
                                          : localeCode == 'en'
                                              ? 'FEATURED OPPORTUNITY'
                                              : 'OPORTUNIDAD DESTACADA',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Text(
                                    'Manufactura Logística S.A.',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('EBITDA', style: theme.textTheme.labelSmall),
                                          const SizedBox(height: 4),
                                          Text('€450k',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              localeCode == 'ca'
                                                  ? 'Ubicació'
                                                  : localeCode == 'en'
                                                      ? 'Location'
                                                      : 'Ubicación',
                                              style: theme.textTheme.labelSmall),
                                          const SizedBox(height: 4),
                                          Text('Madrid',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Sector', style: theme.textTheme.labelSmall),
                                          const SizedBox(height: 4),
                                          Text('Industrial',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    final dummyOffer = Offer(
                                      id: 'featured_dummy_1',
                                      sector: 'Industrial',
                                      region: 'Madrid',
                                      owner: 'owner_dummy_featured',
                                      companyDescription: 'Manufactura Logística S.A. es una empresa líder en inyección y moldeado de plásticos de alta precisión con presencia nacional.',
                                      revenueRange: 'BETWEEN_1M_5M',
                                      employeeRange: '11_25',
                                      creationYear: 15,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OfferDetailsScreen(offer: dummyOffer),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(48),
                                  ),
                                  child: Text(localeCode == 'ca'
                                      ? 'Veure Detalls'
                                      : localeCode == 'en'
                                          ? 'View Details'
                                          : 'Ver Detalles'),
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

            // Timeline / Guest guide
            if (!isLoggedIn) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 32.0),
                  child: Column(
                    children: [
                      Text(
                        localeCode == 'ca'
                            ? 'El Camí cap al Relleu'
                            : localeCode == 'en'
                                ? 'The Path to Succession'
                                : 'El Camino hacia el Relevo',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localeCode == 'ca'
                            ? 'Un procés estructurat per garantir la seguretat.'
                            : localeCode == 'en'
                                ? 'A structured process to ensure maximum security.'
                                : 'Un proceso estructurado para garantizar la máxima seguridad en cada fase.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      _buildTimelineStep(
                          context,
                          '1',
                          localeCode == 'ca'
                              ? 'Valoració'
                              : localeCode == 'en'
                                  ? 'Valuation'
                                  : 'Valoración',
                          localeCode == 'ca'
                              ? 'Anàlisi algorísmic i financer de l\'actiu.'
                              : localeCode == 'en'
                                  ? 'Algorithmic and financial analysis of the asset.'
                                  : 'Análisis algorítmico y financiero del activo.'),
                      _buildTimelineStep(
                          context,
                          '2',
                          'Matchmaking',
                          localeCode == 'ca'
                              ? 'Connexió amb inversors qualificats.'
                              : localeCode == 'en'
                                  ? 'Connection with qualified investors.'
                                  : 'Conexión con inversores cualificados.'),
                      _buildTimelineStep(
                          context,
                          '3',
                          'Due Diligence',
                          localeCode == 'ca'
                              ? 'Auditoria profunda tècnica i legal.'
                              : localeCode == 'en'
                                  ? 'Deep technical and legal audit.'
                                  : 'Auditoría profunda técnica y legal.'),
                      _buildTimelineStep(
                          context,
                          '4',
                          localeCode == 'ca'
                              ? 'Transmissió'
                              : localeCode == 'en'
                                  ? 'Transmission'
                                  : 'Transmisión',
                          localeCode == 'ca'
                              ? 'Tancament i transferència de propietat.'
                              : localeCode == 'en'
                                  ? 'Closing and transfer of ownership.'
                                  : 'Cierre y transferencia de propiedad.'),
                    ],
                  ),
                ),
              ),

              // CTA Card for Guests
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: RelevoCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: theme.colorScheme.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localeCode == 'ca'
                              ? 'Accedeix al dealflow complet'
                              : localeCode == 'en'
                                  ? 'Access the complete dealflow'
                                  : 'Accede al dealflow completo',
                          textAlign: TextAlign.center,
                          style:
                              theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localeCode == 'ca'
                              ? 'Registra\'t com a inversor verificat per veure detalls financers, noms i contactar amb els fundadors directament.'
                              : localeCode == 'en'
                                  ? 'Register as a verified investor to see financial details, names, and contact founders directly.'
                                  : 'Regístrate como inversor verificado para ver detalles financieros, nombres y contactar con los fundadores directamente.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const RegisterScreen()));
                                },
                                child: Text(l10n.profileRegisterButton),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const LoginScreen()));
                                },
                                child: Text(l10n.profileLoginButton),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestHero(BuildContext context, String localeCode) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localeCode == 'ca'
                  ? 'Assegura el futur del teu llegat'
                  : localeCode == 'en'
                      ? 'Secure the future of your legacy'
                      : 'Asegura el futuro de tu legado',
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localeCode == 'ca'
                  ? "La plataforma institucional per a la compra i venda d'empreses amb un enfocament en la continuïtat i la precisió tècnica."
                  : localeCode == 'en'
                      ? "The institutional platform for buying and selling businesses with a focus on continuity and technical precision."
                      : "La plataforma institucional para la compra y venta de empresas con un enfoque en la continuidad y la precisión técnica.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()));
                  },
                  child: Text(
                    localeCode == 'ca' ? 'Registra\'t' : localeCode == 'en' ? 'Register' : 'Regístrate',
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                  child: Text(
                    localeCode == 'ca'
                        ? 'Iniciar sessió'
                        : localeCode == 'en'
                            ? 'Log in'
                            : 'Iniciar sesión',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedInHeader(BuildContext context, dynamic user) {
    final theme = Theme.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;
    final String greeting = localeCode == 'ca'
        ? 'Hola de nou,'
        : localeCode == 'es'
            ? 'Hola de nuevo,'
            : 'Welcome back,';

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.fullName,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 2,
              width: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityDashboard(BuildContext context, WidgetRef ref, String localeCode) {
    final theme = Theme.of(context);
    final receivedRequests = ref.watch(receivedRequestsProvider).value ?? [];
    final sentRequests = ref.watch(sentRequestsProvider).value ?? [];
    final chats = ref.watch(chatsListProvider).value ?? [];

    final activeRequestsCount = receivedRequests.length + sentRequests.length;
    final activeChatsCount = chats.length;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localeCode == 'ca'
                  ? 'El teu Resum d\'Activitat'
                  : localeCode == 'es'
                      ? 'Tu Resumen de Actividad'
                      : 'Your Activity Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: RelevoCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.description_outlined,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$activeRequestsCount',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                localeCode == 'ca'
                                    ? 'Sol·licituds de negoci'
                                    : localeCode == 'es'
                                        ? 'Solicitudes de negocio'
                                        : 'Business requests',
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RelevoCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$activeChatsCount',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                localeCode == 'ca'
                                    ? 'Converses actives'
                                    : localeCode == 'es'
                                        ? 'Conversaciones activas'
                                        : 'Active chats',
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(BuildContext context, String num, String title, String desc) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            ),
            child: Center(
              child: Text(
                num,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
