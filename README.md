# 📱 Relevo — App Móvil Flutter

Aplicación móvil multiplataforma de **Relevo**, un marketplace de adquisición y sucesión empresarial. Construida con **Flutter** y **Riverpod**, ofrece una experiencia nativa premium con chat en tiempo real, notificaciones push, pagos con Stripe, análisis de CVs por IA y un sistema de mentoring.

---

## 🚀 Stack Tecnológico

| Tecnología | Uso |
|:---|:---|
| **Flutter** (Dart SDK ^3.11.5) | Framework multiplataforma |
| **Riverpod** | State management (flutter_riverpod + riverpod_annotation) |
| **Dio** | Cliente HTTP |
| **Socket.io Client** | WebSockets bidireccionales |
| **Firebase Core** | Inicialización Firebase |
| **Firebase Messaging** | Push Notifications (FCM) |
| **Firebase Auth** | OAuth (Google Sign-In) |
| **Google Sign-In** | Login nativo con Google |
| **WebView Flutter** | Pagos Stripe (checkout embebido) |
| **Flutter Secure Storage** | Almacenamiento seguro de tokens |
| **Google Fonts** | Tipografía premium (Inter/Outfit) |
| **Shimmer** | Placeholders animados de carga |
| **Flutter Markdown** | Renderizado de contenido Markdown |
| **Record + Audioplayers** | Notas de voz en el chat |
| **File Picker** | Adjuntar archivos |
| **Flutter Local Notifications** | Notificaciones locales |
| **URL Launcher** | Apertura de enlaces externos |

---

## 📂 Estructura del Proyecto

```
app-relevo/lib/
├── main.dart                    # Punto de entrada + Firebase init
├── l10n/                        # Internacionalización
│   ├── app_ca.arb                     # Catalán (~26KB)
│   ├── app_es.arb                     # Español (~27KB)
│   ├── app_en.arb                     # Inglés (~25KB)
│   └── app_localizations.dart         # Generadas automáticamente
├── data/                        # Capa de datos
│   ├── models/                        # Modelos de datos
│   │   ├── user_model.dart                  # Usuario + Pro plan + créditos
│   │   ├── offer_model.dart                 # Oferta del marketplace
│   │   ├── solicitud_model.dart             # Solicitud con análisis IA
│   │   ├── chat_model.dart                  # Conversación
│   │   ├── message_model.dart               # Mensaje (texto/audio/archivo)
│   │   ├── payment_model.dart               # ← NUEVO: Sesión de pago Stripe
│   │   ├── notification_model.dart          # Notificación
│   │   ├── alert_model.dart                 # Alerta de búsqueda
│   │   ├── rating_model.dart                # Valoración post-trato
│   │   ├── mentoring_module_model.dart      # Módulo formativo
│   │   ├── mentoring_progress_model.dart    # Progreso del usuario
│   │   ├── auth_response_model.dart         # Respuesta de login
│   │   └── pagination_model.dart            # Paginación genérica
│   ├── services/                      # Comunicación con el backend
│   │   ├── auth_service.dart                # Login, registro, OAuth, JWT
│   │   ├── offer_service.dart               # CRUD ofertas + recomendaciones
│   │   ├── solicitud_service.dart           # Solicitudes + análisis IA
│   │   ├── chat_service.dart                # REST para chats y mensajes
│   │   ├── socket_service.dart              # WebSockets (Socket.io)
│   │   ├── payment_service.dart             # ← NUEVO: Stripe checkout
│   │   ├── push_notification_service.dart   # Firebase Messaging
│   │   ├── notification_service.dart        # Historial de notificaciones
│   │   ├── alert_service.dart               # Alertas de búsqueda
│   │   └── mentoring_service.dart           # Módulos formativos
│   └── providers/                     # Riverpod providers (code-gen)
│       ├── auth_provider.dart               # Estado de autenticación
│       ├── offers_provider.dart             # Marketplace, mis ofertas, favoritos
│       ├── solicitud_provider.dart          # Estado de solicitudes
│       ├── chat_providers.dart              # Chats, mensajes, estado online
│       ├── notification_provider.dart       # Badge de notificaciones
│       ├── language_provider.dart           # Idioma activo
│       ├── theme_provider.dart              # Dark/Light mode
│       ├── alert_provider.dart              # Alertas de búsqueda
│       ├── mentoring_provider.dart          # Módulos + progreso
│       └── navigation_providers.dart        # Índice de tab actual
├── screens/                     # Pantallas (24 screens)
│   ├── splash_screen.dart                   # Pantalla de carga inicial
│   ├── login_screen.dart                    # Login (email + Google OAuth)
│   ├── register_screen.dart                 # Registro con selección de roles
│   ├── main_screen.dart                     # Shell con bottom navigation
│   ├── inicio_screen.dart                   # Home / Landing con estadísticas
│   ├── home_screen.dart                     # Marketplace con filtros
│   ├── offer_details_screen.dart            # Detalle de oferta (62KB de UI)
│   ├── create_offer_screen.dart             # Formulario de nueva oferta
│   ├── sell_screen.dart                     # Portal del vendedor
│   ├── inbox_screen.dart                    # Solicitudes recibidas/enviadas
│   ├── solicitud_details_screen.dart        # Detalle con análisis IA
│   ├── chat_list_screen.dart                # Lista de conversaciones
│   ├── chat_room_screen.dart                # Sala de chat (60KB — audio, archivos)
│   ├── profile_screen.dart                  # Perfil del usuario
│   ├── edit_profile_screen.dart             # Edición de perfil
│   ├── user_ratings_screen.dart             # Valoraciones recibidas
│   ├── favorites_screen.dart                # Ofertas favoritas
│   ├── mentoring_screen.dart                # Módulos de formación
│   ├── module_detail_screen.dart            # Detalle de módulo Markdown
│   ├── manage_alerts_screen.dart            # CRUD de alertas de búsqueda
│   ├── notifications_inbox_screen.dart      # Historial de notificaciones
│   ├── notification_preferences_screen.dart # Preferencias por categoría
│   ├── premium_screen.dart                  # ← NUEVO: Plan Pro + ventajas
│   └── payment_checkout_screen.dart         # ← NUEVO: WebView Stripe
├── widgets/                     # Componentes reutilizables
│   ├── offer_card_grid.dart                 # Card de oferta (grid 2 cols)
│   ├── offer_card_horizontal.dart           # Card de oferta (lista)
│   ├── offer_map_widget.dart                # Mapa de ubicación
│   ├── offers_shimmer.dart                  # Skeleton loading animado
│   ├── glassmorphic_app_bar.dart            # AppBar con efecto cristal
│   ├── custom_search_bar.dart               # Barra de búsqueda
│   ├── custom_text_field.dart               # Input personalizado
│   ├── error_banner.dart                    # Banner de error
│   ├── request_status_badge.dart            # Badge de estado de solicitud
│   ├── premium_invite_dialog.dart           # ← NUEVO: Diálogo de invitación Pro
│   └── restricted_dialog.dart               # ← NUEVO: Diálogo de acceso restringido
└── utils/                       # Utilidades
    ├── mentoring_localizations.dart         # i18n para mentoring
    └── snackbar_utils.dart                  # Helpers para snackbars
```

---

## 📱 Pantallas Principales

### Flujo de Navegación

```
SplashScreen
├── LoginScreen / RegisterScreen
└── MainScreen (Bottom Navigation)
    ├── Tab 0: InicioScreen (Home + Landing)
    ├── Tab 1: HomeScreen (Marketplace)
    ├── Tab 2: InboxScreen (Solicitudes)
    ├── Tab 3: ChatListScreen
    └── Tab 4: ProfileScreen
        ├── EditProfileScreen
        ├── FavoritesScreen
        ├── ManageAlertsScreen
        ├── MentoringScreen → ModuleDetailScreen
        ├── NotificationsInboxScreen
        ├── NotificationPreferencesScreen
        ├── UserRatingsScreen
        └── PremiumScreen → PaymentCheckoutScreen
```

---

## 🔐 Autenticación

### Métodos Soportados

| Método | Implementación |
|:---|:---|
| **Email + Password** | `AuthService.login()` → JWT |
| **Google** | `firebase_auth` + `google_sign_in` → Firebase idToken → Backend |

### Almacenamiento de Tokens

- **Access Token**: `flutter_secure_storage` (cifrado nativo iOS/Android)
- **Refresh Token**: Cookie httpOnly gestionada por Dio
- **Silent Refresh**: Automático al recibir 401

---

## 💳 Monetización (Stripe)

### Pantallas

| Pantalla | Descripción |
|:---|:---|
| `PremiumScreen` | Ventajas de Relevo Pro, comparación Free vs Pro |
| `PaymentCheckoutScreen` | WebView con Stripe Checkout Session embebido |

### Flujo

```
1. PremiumScreen → Selecciona plan Pro
2. App → POST /api/payments/checkout { kind: 'pro_activation' }
3. Backend → Devuelve checkoutUrl de Stripe
4. PaymentCheckoutScreen → Abre WebView con Stripe
5. Stripe → Redirige a URL de éxito/cancelación
6. App → Detecta redirección, navega al resultado
```

---

## 🔔 Notificaciones Push

### Firebase Cloud Messaging

- **Background**: `FirebaseMessaging.onBackgroundMessage` → `flutter_local_notifications`
- **Foreground**: `FirebaseMessaging.onMessage` → notificación local con canal personalizado
- **Tap**: `onMessageOpenedApp` → navega a la pantalla relevante
- **Token management**: Sincronización automática con el backend (`PATCH /api/usuarios`)
- **Preferencias**: Control granular por categoría (chat, solicitudes, IA, alertas)

---

## ⚡ WebSockets (Socket.io)

El `SocketService` gestiona la conexión WebSocket:

- **Reconexión automática** con backoff exponencial
- **JWT en handshake**: `auth: { token: accessToken }`
- **Eventos escuchados**: `new_message`, `typing_start/stop`, `chat_updated`, `solicitud_updated`, `new_notification`, `user_online`
- **Salas**: `user:{userId}` (personal) + `chat:{chatId}` (conversación)

---

## 🌐 Internacionalización (i18n)

| Idioma | Archivo ARB | Strings |
|:---|:---|:---|
| Catalán | `l10n/app_ca.arb` | ~26KB |
| Español | `l10n/app_es.arb` | ~27KB |
| Inglés | `l10n/app_en.arb` | ~25KB |

- Sistema oficial Flutter: `flutter_localizations` + generación automática
- Sincronización con backend: idioma persiste en DB del usuario
- Plurales, géneros y parámetros interpolados soportados

---

## 🎨 Diseño Premium

| Aspecto | Detalle |
|:---|:---|
| **Paleta** | Esmeralda (#10B981), slate oscuro, backgrounds neutros |
| **Tipografía** | Google Fonts (Inter/Outfit) |
| **Tema** | Dark/Light mode con detección automática del sistema |
| **Animaciones** | Shimmer loading, micro-interacciones, transiciones suaves |
| **Componentes** | Glassmorphic AppBar, tarjetas premium, badges de estado |

---

## 🛠️ Desarrollo Local

### Requisitos Previos

- Flutter SDK (Dart ^3.11.5)
- Android Studio / Xcode
- Backend corriendo en `localhost:4000`

### Instalación

```bash
# Clonar el repositorio
git clone <repo-url>
cd app-relevo

# Instalar dependencias
flutter pub get

# Generar código (Riverpod, i18n)
dart run build_runner build --delete-conflicting-outputs

# Ejecutar en desarrollo
flutter run
```

### Comandos

| Comando | Descripción |
|:---|:---|
| `flutter run` | Ejecutar en dispositivo/emulador |
| `flutter run -d chrome` | Ejecutar en navegador web |
| `flutter pub get` | Instalar dependencias |
| `dart run build_runner build` | Generar providers y i18n |
| `dart run build_runner watch` | Generación en modo watch |
| `flutter build apk` | Build Android (APK) |
| `flutter build ios` | Build iOS |
| `flutter test` | Tests unitarios |

---

## 🏗️ Arquitectura

### Capas

```
┌────────────────────────┐
│       Screens (UI)      │  ← Widgets Flutter, consume providers
├────────────────────────┤
│   Providers (Riverpod)  │  ← State management, lógica reactiva
├────────────────────────┤
│     Services (Data)     │  ← HTTP (Dio), WebSockets, Firebase
├────────────────────────┤
│      Models (Domain)    │  ← Serialización JSON, tipado
└────────────────────────┘
```

### Generación de Código

Los providers de Riverpod usan **code generation** con `riverpod_annotation`:

```dart
@riverpod
class OffersNotifier extends _$OffersNotifier {
  @override
  Future<List<Offer>> build() async {
    return ref.read(offerServiceProvider).getOffers();
  }
}
```

Genera automáticamente `*.g.dart` con `build_runner`.

---

## 📦 Plataformas Soportadas

| Plataforma | Estado |
|:---|:---|
| 🤖 Android | ✅ Principal |
| 🍎 iOS | ✅ Principal |
| 🌐 Web | ✅ Soporte |
| 🖥️ macOS | ⚠️ Experimental |
| 🐧 Linux | ⚠️ Experimental |
| 🪟 Windows | ⚠️ Experimental |
