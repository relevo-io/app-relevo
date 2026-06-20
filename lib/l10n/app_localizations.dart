import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
  ];

  /// El saludo tradicional del programador
  ///
  /// In es, this message translates to:
  /// **'¡Hola Mundo!'**
  String get helloWorld;

  /// Mensaje de bienvenida con parámetro
  ///
  /// In es, this message translates to:
  /// **'Bienvenido/a a Relevo, {name}'**
  String welcomeMessage(String name);

  /// No description provided for @fillAllFieldsError.
  ///
  /// In es, this message translates to:
  /// **'Por favor, rellena todos los campos'**
  String get fillAllFieldsError;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get loginTitle;

  /// No description provided for @loginWelcome.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido de nuevo!'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para gestionar tus oportunidades.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. juan@empresa.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordLabel;

  /// No description provided for @passwordHintLogin.
  ///
  /// In es, this message translates to:
  /// **'Tu contraseña secreta'**
  String get passwordHintLogin;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In es, this message translates to:
  /// **'¿Has olvidado tu contraseña?'**
  String get forgotPasswordButton;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Únete a Relevo'**
  String get registerTitle;

  /// No description provided for @registerWelcome.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get registerWelcome;

  /// No description provided for @registerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Forma parte de la nueva generación de líderes.'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Juan Pérez'**
  String get fullNameHint;

  /// No description provided for @passwordHintRegister.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get passwordHintRegister;

  /// No description provided for @roleQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué buscas en Relevo?'**
  String get roleQuestion;

  /// No description provided for @roleInterested.
  ///
  /// In es, this message translates to:
  /// **'Busco oportunidades'**
  String get roleInterested;

  /// No description provided for @roleOwner.
  ///
  /// In es, this message translates to:
  /// **'Quiero traspasar mi negocio'**
  String get roleOwner;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get registerButton;

  /// No description provided for @homeMarketplaceBadge.
  ///
  /// In es, this message translates to:
  /// **'Marketplace Líder'**
  String get homeMarketplaceBadge;

  /// No description provided for @homeSlogan.
  ///
  /// In es, this message translates to:
  /// **'Asegura el futuro de tu legado.'**
  String get homeSlogan;

  /// No description provided for @homeSlogan2.
  ///
  /// In es, this message translates to:
  /// **'Impulsa tu nuevo negocio.'**
  String get homeSlogan2;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get profileTitle;

  /// No description provided for @profileDefaultUser.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get profileDefaultUser;

  /// No description provided for @profileSettings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get profileSettings;

  /// No description provided for @profileHelp.
  ///
  /// In es, this message translates to:
  /// **'Ayuda y Soporte'**
  String get profileHelp;

  /// No description provided for @profileLogout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get profileLogout;

  /// No description provided for @profileNotRegisteredQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Aún no te has registrado?'**
  String get profileNotRegisteredQuestion;

  /// No description provided for @profileNotRegisteredSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Únete a la plataforma y asegura el futuro de tu legado.'**
  String get profileNotRegisteredSubtitle;

  /// No description provided for @profileLoginButton.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get profileLoginButton;

  /// No description provided for @profileRegisterButton.
  ///
  /// In es, this message translates to:
  /// **'Regístrate'**
  String get profileRegisterButton;

  /// No description provided for @bottomNavHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get bottomNavHome;

  /// No description provided for @bottomNavProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get bottomNavProfile;

  /// No description provided for @languageSelectorES.
  ///
  /// In es, this message translates to:
  /// **'Español (ES)'**
  String get languageSelectorES;

  /// No description provided for @languageSelectorCA.
  ///
  /// In es, this message translates to:
  /// **'Català (CA)'**
  String get languageSelectorCA;

  /// No description provided for @languageSelectorEN.
  ///
  /// In es, this message translates to:
  /// **'English (EN)'**
  String get languageSelectorEN;

  /// No description provided for @homeIntro.
  ///
  /// In es, this message translates to:
  /// **'Conectamos a fundadores experimentados con la próxima generación de líderes empresariales.'**
  String get homeIntro;

  /// No description provided for @homeStatValue1.
  ///
  /// In es, this message translates to:
  /// **'€12M+'**
  String get homeStatValue1;

  /// No description provided for @homeStatLabel1.
  ///
  /// In es, this message translates to:
  /// **'Valor transaccionado'**
  String get homeStatLabel1;

  /// No description provided for @homeStatValue2.
  ///
  /// In es, this message translates to:
  /// **'+500'**
  String get homeStatValue2;

  /// No description provided for @homeStatLabel2.
  ///
  /// In es, this message translates to:
  /// **'Propietarios activos'**
  String get homeStatLabel2;

  /// No description provided for @homeOwnersTitle.
  ///
  /// In es, this message translates to:
  /// **'PARA PROPIETARIOS'**
  String get homeOwnersTitle;

  /// No description provided for @homeOwnersSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu retiro merece un sucesor a la altura.'**
  String get homeOwnersSubtitle;

  /// No description provided for @homeOwnersDesc.
  ///
  /// In es, this message translates to:
  /// **'Has construido algo valioso. No dejes que se pierda. Te ayudamos a encontrar al comprador ideal.'**
  String get homeOwnersDesc;

  /// No description provided for @homeOwnersFeature1.
  ///
  /// In es, this message translates to:
  /// **'Valoración profesional del negocio.'**
  String get homeOwnersFeature1;

  /// No description provided for @homeOwnersFeature2.
  ///
  /// In es, this message translates to:
  /// **'Filtrado de compradores potenciales.'**
  String get homeOwnersFeature2;

  /// No description provided for @homeOwnersFeature3.
  ///
  /// In es, this message translates to:
  /// **'Máxima confidencialidad.'**
  String get homeOwnersFeature3;

  /// No description provided for @homeEntrepreneursTitle.
  ///
  /// In es, this message translates to:
  /// **'PARA EMPRENDEDORES'**
  String get homeEntrepreneursTitle;

  /// No description provided for @homeEntrepreneursSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Emprende sobre una base sólida.'**
  String get homeEntrepreneursSubtitle;

  /// No description provided for @homeEntrepreneursDesc.
  ///
  /// In es, this message translates to:
  /// **'No empieces de cero. Adquiere una empresa establecida con flujo de caja y clientes.'**
  String get homeEntrepreneursDesc;

  /// No description provided for @homeEntrepreneursFeatureTitle.
  ///
  /// In es, this message translates to:
  /// **'Rentabilidad Probada'**
  String get homeEntrepreneursFeatureTitle;

  /// No description provided for @homeEntrepreneursFeatureDesc.
  ///
  /// In es, this message translates to:
  /// **'Accede a históricos financieros auditados.'**
  String get homeEntrepreneursFeatureDesc;

  /// No description provided for @homeSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Busca en Relevo'**
  String get homeSearchHint;

  /// No description provided for @homeFilters.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get homeFilters;

  /// No description provided for @homeCompanyOffers.
  ///
  /// In es, this message translates to:
  /// **'Ofertas de empresas'**
  String get homeCompanyOffers;

  /// No description provided for @homeNearbyNews.
  ///
  /// In es, this message translates to:
  /// **'Novedades cerca de ti'**
  String get homeNearbyNews;

  /// No description provided for @homeViewAll.
  ///
  /// In es, this message translates to:
  /// **'Ver todo'**
  String get homeViewAll;

  /// No description provided for @bottomNavSell.
  ///
  /// In es, this message translates to:
  /// **'Vender'**
  String get bottomNavSell;

  /// No description provided for @bottomNavInbox.
  ///
  /// In es, this message translates to:
  /// **'Solicitudes'**
  String get bottomNavInbox;

  /// No description provided for @bottomNavYou.
  ///
  /// In es, this message translates to:
  /// **'Tú'**
  String get bottomNavYou;

  /// No description provided for @themeDarkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get themeDarkMode;

  /// No description provided for @themeLightMode.
  ///
  /// In es, this message translates to:
  /// **'Modo claro'**
  String get themeLightMode;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Email o contraseña incorrectos'**
  String get errorInvalidCredentials;

  /// No description provided for @errorUserExists.
  ///
  /// In es, this message translates to:
  /// **'El usuario ya existe'**
  String get errorUserExists;

  /// No description provided for @errorInternal.
  ///
  /// In es, this message translates to:
  /// **'Error interno del servidor'**
  String get errorInternal;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Email no válido'**
  String get errorInvalidEmail;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres'**
  String get errorPasswordTooShort;

  /// No description provided for @errorRequiredField.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get errorRequiredField;

  /// No description provided for @registerSuccess.
  ///
  /// In es, this message translates to:
  /// **'Registro completado. Inicia sesión.'**
  String get registerSuccess;

  /// No description provided for @profileFeatureMarketplaceTitle.
  ///
  /// In es, this message translates to:
  /// **'Acceso al Marketplace'**
  String get profileFeatureMarketplaceTitle;

  /// No description provided for @profileFeatureMarketplaceDesc.
  ///
  /// In es, this message translates to:
  /// **'Explora cientos de oportunidades de traspaso de negocios activos.'**
  String get profileFeatureMarketplaceDesc;

  /// No description provided for @profileFeatureChatTitle.
  ///
  /// In es, this message translates to:
  /// **'Contacto Directo'**
  String get profileFeatureChatTitle;

  /// No description provided for @profileFeatureChatDesc.
  ///
  /// In es, this message translates to:
  /// **'Habla con los propietarios de forma segura a través del chat.'**
  String get profileFeatureChatDesc;

  /// No description provided for @profileFeaturePublishTitle.
  ///
  /// In es, this message translates to:
  /// **'Publica tu Negocio'**
  String get profileFeaturePublishTitle;

  /// No description provided for @profileFeaturePublishDesc.
  ///
  /// In es, this message translates to:
  /// **'Vende o traspasa tu empresa con total confidencialidad.'**
  String get profileFeaturePublishDesc;

  /// No description provided for @restrictedAlertTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Quieres ver todos los detalles?'**
  String get restrictedAlertTitle;

  /// No description provided for @restrictedAlertDesc.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión o regístrate en Relevo para ver los precios, descripciones completas y contactar con los propietarios.'**
  String get restrictedAlertDesc;

  /// No description provided for @homeAboutTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Qué es Relevo?'**
  String get homeAboutTitle;

  /// No description provided for @homeAboutDesc.
  ///
  /// In es, this message translates to:
  /// **'Relevo es la plataforma líder para traspasar y adquirir empresas en funcionamiento de manera confidencial, directa y transparente. Conectamos a fundadores con la próxima generación de líderes.'**
  String get homeAboutDesc;

  /// No description provided for @homeAboutButton.
  ///
  /// In es, this message translates to:
  /// **'¿Quiénes somos?'**
  String get homeAboutButton;

  /// No description provided for @profileSectionAbout.
  ///
  /// In es, this message translates to:
  /// **'Sobre mí'**
  String get profileSectionAbout;

  /// No description provided for @profileSectionProfessional.
  ///
  /// In es, this message translates to:
  /// **'Perfil Profesional'**
  String get profileSectionProfessional;

  /// No description provided for @profileLocationLabel.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get profileLocationLabel;

  /// No description provided for @profileBioLabel.
  ///
  /// In es, this message translates to:
  /// **'Biografía'**
  String get profileBioLabel;

  /// No description provided for @profileBackgroundLabel.
  ///
  /// In es, this message translates to:
  /// **'Experiencia y capacidades'**
  String get profileBackgroundLabel;

  /// No description provided for @profileNoLocation.
  ///
  /// In es, this message translates to:
  /// **'Sin ubicación especificada'**
  String get profileNoLocation;

  /// No description provided for @profileNoBio.
  ///
  /// In es, this message translates to:
  /// **'Sin biografía redactada todavía'**
  String get profileNoBio;

  /// No description provided for @profileNoBackground.
  ///
  /// In es, this message translates to:
  /// **'Sin experiencia detallada todavía'**
  String get profileNoBackground;

  /// No description provided for @profileEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Perfil'**
  String get profileEditTitle;

  /// No description provided for @profileSaveButton.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get profileSaveButton;

  /// No description provided for @profileSaveSuccess.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado correctamente'**
  String get profileSaveSuccess;

  /// No description provided for @profileSaving.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get profileSaving;

  /// No description provided for @profileLocationHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Barcelona, Cataluña'**
  String get profileLocationHint;

  /// No description provided for @profileBioHint.
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos un poco sobre ti...'**
  String get profileBioHint;

  /// No description provided for @profileBackgroundHint.
  ///
  /// In es, this message translates to:
  /// **'Detalla tu experiencia y habilidades profesionales...'**
  String get profileBackgroundHint;

  /// No description provided for @sellTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi espacio de venta'**
  String get sellTitle;

  /// No description provided for @sellPublishButton.
  ///
  /// In es, this message translates to:
  /// **'Publicar Oferta'**
  String get sellPublishButton;

  /// No description provided for @sellMyOffersSection.
  ///
  /// In es, this message translates to:
  /// **'Tus oportunidades publicadas'**
  String get sellMyOffersSection;

  /// No description provided for @sellEmptyStateTitle.
  ///
  /// In es, this message translates to:
  /// **'Ningún negocio publicado todavía'**
  String get sellEmptyStateTitle;

  /// No description provided for @sellEmptyStateDesc.
  ///
  /// In es, this message translates to:
  /// **'Te ayudamos a encontrar al comprador ideal. Comienza publicando tu negocio con total confidencialidad.'**
  String get sellEmptyStateDesc;

  /// No description provided for @offerCreateTitle.
  ///
  /// In es, this message translates to:
  /// **'Publicar Negocio'**
  String get offerCreateTitle;

  /// No description provided for @offerSectorLabel.
  ///
  /// In es, this message translates to:
  /// **'Sector del negocio'**
  String get offerSectorLabel;

  /// No description provided for @offerSectorHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Hostelería, Automoción, Tecnología...'**
  String get offerSectorHint;

  /// No description provided for @offerRegionLabel.
  ///
  /// In es, this message translates to:
  /// **'Ubicación / Región'**
  String get offerRegionLabel;

  /// No description provided for @offerRegionHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Gironès, Barcelona, Andorra...'**
  String get offerRegionHint;

  /// No description provided for @offerRevenueLabel.
  ///
  /// In es, this message translates to:
  /// **'Rango de Facturación Anual'**
  String get offerRevenueLabel;

  /// No description provided for @offerEmployeesLabel.
  ///
  /// In es, this message translates to:
  /// **'Número de Empleados'**
  String get offerEmployeesLabel;

  /// No description provided for @offerYearLabel.
  ///
  /// In es, this message translates to:
  /// **'Año de Creación (Opcional)'**
  String get offerYearLabel;

  /// No description provided for @offerYearHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. 2012'**
  String get offerYearHint;

  /// No description provided for @offerDescLabel.
  ///
  /// In es, this message translates to:
  /// **'Breve Descripción del Negocio'**
  String get offerDescLabel;

  /// No description provided for @offerDescHint.
  ///
  /// In es, this message translates to:
  /// **'Resume tu negocio en un par de frases atractivas...'**
  String get offerDescHint;

  /// No description provided for @offerExtendedLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción Detallada (Opcional)'**
  String get offerExtendedLabel;

  /// No description provided for @offerExtendedHint.
  ///
  /// In es, this message translates to:
  /// **'Explica más detalles como la clientela, activos, motivo de traspaso...'**
  String get offerExtendedHint;

  /// No description provided for @offerPublishButton.
  ///
  /// In es, this message translates to:
  /// **'Publicar Oportunidad'**
  String get offerPublishButton;

  /// No description provided for @offerPublishSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Oferta publicada correctamente!'**
  String get offerPublishSuccess;

  /// No description provided for @offerPublishError.
  ///
  /// In es, this message translates to:
  /// **'Error al publicar la oferta. Inténtalo de nuevo.'**
  String get offerPublishError;

  /// No description provided for @offerErrorInvalidYear.
  ///
  /// In es, this message translates to:
  /// **'Introduce un año válido'**
  String get offerErrorInvalidYear;

  /// No description provided for @offerErrorDescTooShort.
  ///
  /// In es, this message translates to:
  /// **'La descripción debe tener al menos 10 caracteres'**
  String get offerErrorDescTooShort;

  /// No description provided for @offerDetailsTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle de la oferta'**
  String get offerDetailsTitle;

  /// No description provided for @offerDetailsLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get offerDetailsLocation;

  /// No description provided for @offerDetailsRevenue.
  ///
  /// In es, this message translates to:
  /// **'Facturación anual'**
  String get offerDetailsRevenue;

  /// No description provided for @offerDetailsEmployees.
  ///
  /// In es, this message translates to:
  /// **'Empleados'**
  String get offerDetailsEmployees;

  /// No description provided for @offerDetailsYear.
  ///
  /// In es, this message translates to:
  /// **'Año de fundación'**
  String get offerDetailsYear;

  /// No description provided for @offerDetailsDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción del negocio'**
  String get offerDetailsDescription;

  /// No description provided for @offerDetailsExtended.
  ///
  /// In es, this message translates to:
  /// **'Información detallada'**
  String get offerDetailsExtended;

  /// No description provided for @offerDetailsApplyButton.
  ///
  /// In es, this message translates to:
  /// **'Solicitar información'**
  String get offerDetailsApplyButton;

  /// No description provided for @offerDetailsPublished.
  ///
  /// In es, this message translates to:
  /// **'Publicado'**
  String get offerDetailsPublished;

  /// No description provided for @offerDetailsFavoriteAdded.
  ///
  /// In es, this message translates to:
  /// **'Oferta agregada a favoritos'**
  String get offerDetailsFavoriteAdded;

  /// No description provided for @offerDetailsFavoriteRemoved.
  ///
  /// In es, this message translates to:
  /// **'Oferta eliminada de favoritos'**
  String get offerDetailsFavoriteRemoved;

  /// No description provided for @offerDetailsFavoriteTooltip.
  ///
  /// In es, this message translates to:
  /// **'Favorito'**
  String get offerDetailsFavoriteTooltip;

  /// No description provided for @offerDetailsStatusPendingDesc.
  ///
  /// In es, this message translates to:
  /// **'Pendiente de revisión por el propietario.'**
  String get offerDetailsStatusPendingDesc;

  /// No description provided for @offerDetailsStatusAcceptedDesc.
  ///
  /// In es, this message translates to:
  /// **'¡Solicitud aceptada! Se pondrán en contacto.'**
  String get offerDetailsStatusAcceptedDesc;

  /// No description provided for @offerDetailsStatusRejectedDesc.
  ///
  /// In es, this message translates to:
  /// **'Solicitud denegada para esta oportunidad.'**
  String get offerDetailsStatusRejectedDesc;

  /// No description provided for @offerDetailsChatWithOwner.
  ///
  /// In es, this message translates to:
  /// **'Chatear con el propietario'**
  String get offerDetailsChatWithOwner;

  /// No description provided for @offerDetailsChatError.
  ///
  /// In es, this message translates to:
  /// **'Error al abrir el chat: {error}'**
  String offerDetailsChatError(Object error);

  /// No description provided for @inboxTitle.
  ///
  /// In es, this message translates to:
  /// **'Buzón de solicitudes'**
  String get inboxTitle;

  /// No description provided for @inboxTabReceived.
  ///
  /// In es, this message translates to:
  /// **'Recibidas'**
  String get inboxTabReceived;

  /// No description provided for @inboxTabSent.
  ///
  /// In es, this message translates to:
  /// **'Enviadas'**
  String get inboxTabSent;

  /// No description provided for @inboxEmptyReceived.
  ///
  /// In es, this message translates to:
  /// **'No has recibido ninguna solicitud de acceso todavía'**
  String get inboxEmptyReceived;

  /// No description provided for @inboxEmptySent.
  ///
  /// In es, this message translates to:
  /// **'No has enviado ninguna solicitud de acceso todavía'**
  String get inboxEmptySent;

  /// No description provided for @inboxStatusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get inboxStatusPending;

  /// No description provided for @inboxStatusAccepted.
  ///
  /// In es, this message translates to:
  /// **'Aceptada'**
  String get inboxStatusAccepted;

  /// No description provided for @inboxStatusRejected.
  ///
  /// In es, this message translates to:
  /// **'Denegada'**
  String get inboxStatusRejected;

  /// No description provided for @inboxActionAccept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get inboxActionAccept;

  /// No description provided for @inboxActionReject.
  ///
  /// In es, this message translates to:
  /// **'Denegar'**
  String get inboxActionReject;

  /// No description provided for @inboxMessageLabel.
  ///
  /// In es, this message translates to:
  /// **'Mensaje'**
  String get inboxMessageLabel;

  /// No description provided for @offerApplyFormTitle.
  ///
  /// In es, this message translates to:
  /// **'Solicitud de acceso'**
  String get offerApplyFormTitle;

  /// No description provided for @offerApplyBackgroundLabel.
  ///
  /// In es, this message translates to:
  /// **'Experiencia y capacidades (Background)'**
  String get offerApplyBackgroundLabel;

  /// No description provided for @offerApplyBackgroundHint.
  ///
  /// In es, this message translates to:
  /// **'Explica tu trayectoria o experiencia en el sector...'**
  String get offerApplyBackgroundHint;

  /// No description provided for @offerApplyRegionsLabel.
  ///
  /// In es, this message translates to:
  /// **'Zonas preferidas de traspaso'**
  String get offerApplyRegionsLabel;

  /// No description provided for @offerApplyRegionsHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Gironès, Osona, Andorra (separadas por comas)...'**
  String get offerApplyRegionsHint;

  /// No description provided for @offerApplyBioLabel.
  ///
  /// In es, this message translates to:
  /// **'Biografía'**
  String get offerApplyBioLabel;

  /// No description provided for @offerApplyBioHint.
  ///
  /// In es, this message translates to:
  /// **'Haz una breve descripción sobre quién eres y tus valores...'**
  String get offerApplyBioHint;

  /// No description provided for @offerApplyCvLabel.
  ///
  /// In es, this message translates to:
  /// **'Currículum Vitae (PDF)'**
  String get offerApplyCvLabel;

  /// No description provided for @offerApplyCvSelect.
  ///
  /// In es, this message translates to:
  /// **'Adjuntar currículum en formato PDF'**
  String get offerApplyCvSelect;

  /// No description provided for @offerApplyCvSelected.
  ///
  /// In es, this message translates to:
  /// **'CV adjuntado: {filename}'**
  String offerApplyCvSelected(Object filename);

  /// No description provided for @offerApplySubmitButton.
  ///
  /// In es, this message translates to:
  /// **'Enviar solicitud al propietario'**
  String get offerApplySubmitButton;

  /// No description provided for @offerApplyRequiredError.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get offerApplyRequiredError;

  /// No description provided for @offerApplyMinLengthError.
  ///
  /// In es, this message translates to:
  /// **'Debe tener al menos {min} caracteres'**
  String offerApplyMinLengthError(Object min);

  /// No description provided for @offerApplyCvError.
  ///
  /// In es, this message translates to:
  /// **'Por favor, adjunta tu currículum PDF'**
  String get offerApplyCvError;

  /// No description provided for @offerApplyCapitalLabel.
  ///
  /// In es, this message translates to:
  /// **'Capital disponible (€)'**
  String get offerApplyCapitalLabel;

  /// No description provided for @offerApplyCapitalHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 50000'**
  String get offerApplyCapitalHint;

  /// No description provided for @offerApplyCapitalError.
  ///
  /// In es, this message translates to:
  /// **'Introduce un importe válido (>= 0)'**
  String get offerApplyCapitalError;

  /// No description provided for @offerApplyFinancingLabel.
  ///
  /// In es, this message translates to:
  /// **'¿Necesitas financiación?'**
  String get offerApplyFinancingLabel;

  /// No description provided for @offerApplyNdaLabel.
  ///
  /// In es, this message translates to:
  /// **'Acepto el acuerdo de confidencialidad (NDA) y me comprometo a mantener reservados los detalles de la oferta.'**
  String get offerApplyNdaLabel;

  /// No description provided for @offerApplyNdaError.
  ///
  /// In es, this message translates to:
  /// **'Debes aceptar el acuerdo de confidencialidad para continuar.'**
  String get offerApplyNdaError;

  /// No description provided for @offerApplySuccessTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Solicitud enviada!'**
  String get offerApplySuccessTitle;

  /// No description provided for @offerApplySuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'Tu solicitud se ha enviado correctamente al propietario de la oferta.'**
  String get offerApplySuccessMessage;

  /// No description provided for @offerApplySuccessOk.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get offerApplySuccessOk;

  /// No description provided for @offerApplyErrorPrefix.
  ///
  /// In es, this message translates to:
  /// **'Error al enviar la solicitud: {error}'**
  String offerApplyErrorPrefix(Object error);

  /// No description provided for @inboxErrorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar las solicitudes'**
  String get inboxErrorLoading;

  /// No description provided for @inboxRetry.
  ///
  /// In es, this message translates to:
  /// **'Volver a intentar'**
  String get inboxRetry;

  /// No description provided for @inboxStatusUpdatedSuccessfully.
  ///
  /// In es, this message translates to:
  /// **'correctamente.'**
  String get inboxStatusUpdatedSuccessfully;

  /// No description provided for @inboxOwnerLabel.
  ///
  /// In es, this message translates to:
  /// **'Propietario'**
  String get inboxOwnerLabel;

  /// No description provided for @inboxNotAvailable.
  ///
  /// In es, this message translates to:
  /// **'N/A'**
  String get inboxNotAvailable;

  /// No description provided for @solicitudApplicantData.
  ///
  /// In es, this message translates to:
  /// **'Datos del solicitante'**
  String get solicitudApplicantData;

  /// No description provided for @solicitudNoBio.
  ///
  /// In es, this message translates to:
  /// **'Sin biografía especificada.'**
  String get solicitudNoBio;

  /// No description provided for @solicitudNoBackground.
  ///
  /// In es, this message translates to:
  /// **'Sin trayectoria profesional especificada.'**
  String get solicitudNoBackground;

  /// No description provided for @solicitudPreferencesFinance.
  ///
  /// In es, this message translates to:
  /// **'Preferencias y Financieros'**
  String get solicitudPreferencesFinance;

  /// No description provided for @solicitudAllRegions.
  ///
  /// In es, this message translates to:
  /// **'Todas las regiones'**
  String get solicitudAllRegions;

  /// No description provided for @solicitudNotSpecified.
  ///
  /// In es, this message translates to:
  /// **'No especificado'**
  String get solicitudNotSpecified;

  /// No description provided for @solicitudYes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get solicitudYes;

  /// No description provided for @solicitudNo.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get solicitudNo;

  /// No description provided for @solicitudDocSecurity.
  ///
  /// In es, this message translates to:
  /// **'Documentación y Seguridad'**
  String get solicitudDocSecurity;

  /// No description provided for @solicitudNdaTitle.
  ///
  /// In es, this message translates to:
  /// **'NDA de acuerdo de confidencialidad'**
  String get solicitudNdaTitle;

  /// No description provided for @solicitudAccepted.
  ///
  /// In es, this message translates to:
  /// **'Aceptado'**
  String get solicitudAccepted;

  /// No description provided for @solicitudCvTitle.
  ///
  /// In es, this message translates to:
  /// **'Currículum Vitae'**
  String get solicitudCvTitle;

  /// No description provided for @solicitudCvPdfSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Archivo adjunto en PDF'**
  String get solicitudCvPdfSubtitle;

  /// No description provided for @solicitudCvView.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get solicitudCvView;

  /// No description provided for @solicitudCvPreviewComingSoon.
  ///
  /// In es, this message translates to:
  /// **'¡Visualización de CV próximamente!'**
  String get solicitudCvPreviewComingSoon;

  /// No description provided for @profileMentoring.
  ///
  /// In es, this message translates to:
  /// **'Programa de Mentoring'**
  String get profileMentoring;

  /// No description provided for @mentoringTitle.
  ///
  /// In es, this message translates to:
  /// **'Mentoring'**
  String get mentoringTitle;

  /// No description provided for @mentoringProgressLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu progreso'**
  String get mentoringProgressLabel;

  /// No description provided for @mentoringDurationMinutes.
  ///
  /// In es, this message translates to:
  /// **'{duration} min'**
  String mentoringDurationMinutes(Object duration);

  /// No description provided for @mentoringModuleCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get mentoringModuleCompleted;

  /// No description provided for @mentoringModulePending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get mentoringModulePending;

  /// No description provided for @mentoringCompletedAlert.
  ///
  /// In es, this message translates to:
  /// **'¡Enhorabuena! Has completado este módulo de mentoring.'**
  String get mentoringCompletedAlert;

  /// No description provided for @mentoringMarkAsCompleted.
  ///
  /// In es, this message translates to:
  /// **'Marcar como completado'**
  String get mentoringMarkAsCompleted;

  /// No description provided for @mentoringItemTip.
  ///
  /// In es, this message translates to:
  /// **'Consejo'**
  String get mentoringItemTip;

  /// No description provided for @mentoringItemQuestion.
  ///
  /// In es, this message translates to:
  /// **'Pregunta'**
  String get mentoringItemQuestion;

  /// No description provided for @mentoringItemTask.
  ///
  /// In es, this message translates to:
  /// **'Tarea'**
  String get mentoringItemTask;

  /// No description provided for @mentoringDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalles del Módulo'**
  String get mentoringDetailTitle;

  /// No description provided for @mentoringLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando mentoring...'**
  String get mentoringLoading;

  /// No description provided for @mentoringError.
  ///
  /// In es, this message translates to:
  /// **'Error cargando mentoring: {error}'**
  String mentoringError(Object error);

  /// No description provided for @profileAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas de búsqueda'**
  String get profileAlerts;

  /// No description provided for @profileNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get profileNotifications;

  /// No description provided for @alertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Alertas'**
  String get alertsTitle;

  /// No description provided for @alertsEmpty.
  ///
  /// In es, this message translates to:
  /// **'No tienes ninguna alerta configurada.'**
  String get alertsEmpty;

  /// No description provided for @alertsCreateButton.
  ///
  /// In es, this message translates to:
  /// **'Activar Alerta'**
  String get alertsCreateButton;

  /// No description provided for @alertsDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Alerta eliminada correctamente'**
  String get alertsDeleteSuccess;

  /// No description provided for @alertsCreateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Alerta creada correctamente'**
  String get alertsCreateSuccess;

  /// No description provided for @alertsSelectRevenue.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el rango de facturación de interés:'**
  String get alertsSelectRevenue;

  /// No description provided for @notificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Buzón de Notificaciones'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In es, this message translates to:
  /// **'No tienes ninguna notificación.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsNewOffer.
  ///
  /// In es, this message translates to:
  /// **'Se ha publicado una nueva oferta en el sector {sector} que se ajusta a tus preferencias.'**
  String notificationsNewOffer(Object sector);

  /// No description provided for @revenueRangeUNDER_100K.
  ///
  /// In es, this message translates to:
  /// **'Menos de 100K €'**
  String get revenueRangeUNDER_100K;

  /// No description provided for @revenueRangeBETWEEN_100K_500K.
  ///
  /// In es, this message translates to:
  /// **'Entre 100K € y 500K €'**
  String get revenueRangeBETWEEN_100K_500K;

  /// No description provided for @revenueRangeBETWEEN_500K_1M.
  ///
  /// In es, this message translates to:
  /// **'Entre 500K € y 1M €'**
  String get revenueRangeBETWEEN_500K_1M;

  /// No description provided for @revenueRangeBETWEEN_1M_5M.
  ///
  /// In es, this message translates to:
  /// **'Entre 1M € y 5M €'**
  String get revenueRangeBETWEEN_1M_5M;

  /// No description provided for @revenueRangeOVER_5M.
  ///
  /// In es, this message translates to:
  /// **'Más de 5M €'**
  String get revenueRangeOVER_5M;

  /// No description provided for @mentoringTabBuy.
  ///
  /// In es, this message translates to:
  /// **'Quiero comprar'**
  String get mentoringTabBuy;

  /// No description provided for @mentoringTabSell.
  ///
  /// In es, this message translates to:
  /// **'Quiero vender'**
  String get mentoringTabSell;

  /// No description provided for @mentoringNoModules.
  ///
  /// In es, this message translates to:
  /// **'No hay módulos en esta ruta'**
  String get mentoringNoModules;

  /// No description provided for @mentoringErrorLoadingContent.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar el contenido: {error}'**
  String mentoringErrorLoadingContent(Object error);

  /// No description provided for @mentoring_seller_m1_title.
  ///
  /// In es, this message translates to:
  /// **'Preparar la empresa para la venta'**
  String get mentoring_seller_m1_title;

  /// No description provided for @mentoring_seller_m1_description.
  ///
  /// In es, this message translates to:
  /// **'Aprender a identificar el mejor momento para vender, entender los motivos habituales de venta y evitar errores frecuentes antes de publicar la oferta.'**
  String get mentoring_seller_m1_description;

  /// No description provided for @mentoring_seller_m1_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Preparar la venta'**
  String get mentoring_seller_m1_i1_title;

  /// No description provided for @mentoring_seller_m2_title.
  ///
  /// In es, this message translates to:
  /// **'Organizar la documentación'**
  String get mentoring_seller_m2_title;

  /// No description provided for @mentoring_seller_m2_description.
  ///
  /// In es, this message translates to:
  /// **'Preparar la documentación financiera, legal y operativa necesaria para transmitir confianza a los posibles compradores.'**
  String get mentoring_seller_m2_description;

  /// No description provided for @mentoring_seller_m2_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Documentación clave'**
  String get mentoring_seller_m2_i1_title;

  /// No description provided for @mentoring_seller_m3_title.
  ///
  /// In es, this message translates to:
  /// **'Valorar la empresa'**
  String get mentoring_seller_m3_title;

  /// No description provided for @mentoring_seller_m3_description.
  ///
  /// In es, this message translates to:
  /// **'Comprender qué factores determinan el valor de una empresa, como la rentabilidad, los activos y el potencial de crecimiento.'**
  String get mentoring_seller_m3_description;

  /// No description provided for @mentoring_seller_m3_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Valoración del negocio'**
  String get mentoring_seller_m3_i1_title;

  /// No description provided for @mentoring_seller_m4_title.
  ///
  /// In es, this message translates to:
  /// **'Crear una oferta atractiva'**
  String get mentoring_seller_m4_title;

  /// No description provided for @mentoring_seller_m4_description.
  ///
  /// In es, this message translates to:
  /// **'Aprender a presentar el negocio de manera profesional, destacando los puntos fuertes y protegiendo la información confidencial.'**
  String get mentoring_seller_m4_description;

  /// No description provided for @mentoring_seller_m4_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Presentación profesional'**
  String get mentoring_seller_m4_i1_title;

  /// No description provided for @mentoring_seller_m5_title.
  ///
  /// In es, this message translates to:
  /// **'Gestionar contactos y negociaciones'**
  String get mentoring_seller_m5_title;

  /// No description provided for @mentoring_seller_m5_description.
  ///
  /// In es, this message translates to:
  /// **'Filtrar posibles compradores, compartir información de manera progresiva y gestionar las negociaciones con profesionalidad.'**
  String get mentoring_seller_m5_description;

  /// No description provided for @mentoring_seller_m5_i1_title.
  ///
  /// In es, this message translates to:
  /// **'El proceso de negociación'**
  String get mentoring_seller_m5_i1_title;

  /// No description provided for @mentoring_seller_m6_title.
  ///
  /// In es, this message translates to:
  /// **'Cerrar la venta'**
  String get mentoring_seller_m6_title;

  /// No description provided for @mentoring_seller_m6_description.
  ///
  /// In es, this message translates to:
  /// **'Completar las fases finales del proceso, incluyendo la Due Diligence, la firma de los contratos y la preparación de la transición.'**
  String get mentoring_seller_m6_description;

  /// No description provided for @mentoring_seller_m6_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Cierre de la venta'**
  String get mentoring_seller_m6_i1_title;

  /// No description provided for @mentoring_buyer_m1_title.
  ///
  /// In es, this message translates to:
  /// **'Definir los objetivos de compra'**
  String get mentoring_buyer_m1_title;

  /// No description provided for @mentoring_buyer_m1_description.
  ///
  /// In es, this message translates to:
  /// **'Determinar el presupuesto disponible, los sectores de interés y las características que debería tener la empresa ideal.'**
  String get mentoring_buyer_m1_description;

  /// No description provided for @mentoring_buyer_m1_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Definir criterios'**
  String get mentoring_buyer_m1_i1_title;

  /// No description provided for @mentoring_buyer_m2_title.
  ///
  /// In es, this message translates to:
  /// **'Buscar oportunidades'**
  String get mentoring_buyer_m2_title;

  /// No description provided for @mentoring_buyer_m2_description.
  ///
  /// In es, this message translates to:
  /// **'Aprender dónde encontrar empresas en venta y cómo realizar un primer filtrado de oportunidades potenciales.'**
  String get mentoring_buyer_m2_description;

  /// No description provided for @mentoring_buyer_m2_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Búsqueda de oportunidades'**
  String get mentoring_buyer_m2_i1_title;

  /// No description provided for @mentoring_buyer_m3_title.
  ///
  /// In es, this message translates to:
  /// **'Analizar la situación financiera'**
  String get mentoring_buyer_m3_title;

  /// No description provided for @mentoring_buyer_m3_description.
  ///
  /// In es, this message translates to:
  /// **'Interpretar la información financiera de la empresa, incluyendo facturación, beneficios, endeudamiento y liquidez.'**
  String get mentoring_buyer_m3_description;

  /// No description provided for @mentoring_buyer_m3_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Análisis financiero'**
  String get mentoring_buyer_m3_i1_title;

  /// No description provided for @mentoring_buyer_m4_title.
  ///
  /// In es, this message translates to:
  /// **'Valorar si el precio es correcto'**
  String get mentoring_buyer_m4_title;

  /// No description provided for @mentoring_buyer_m4_description.
  ///
  /// In es, this message translates to:
  /// **'Analizar si la valoración propuesta por el vendedor es coherente con la realidad y el potencial del negocio.'**
  String get mentoring_buyer_m4_description;

  /// No description provided for @mentoring_buyer_m4_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Evaluar la valoración'**
  String get mentoring_buyer_m4_i1_title;

  /// No description provided for @mentoring_buyer_m5_title.
  ///
  /// In es, this message translates to:
  /// **'Negociar la compra'**
  String get mentoring_buyer_m5_title;

  /// No description provided for @mentoring_buyer_m5_description.
  ///
  /// In es, this message translates to:
  /// **'Prepararse para negociar el precio y las condiciones de la operación, identificando riesgos y oportunidades.'**
  String get mentoring_buyer_m5_description;

  /// No description provided for @mentoring_buyer_m5_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Estrategias de negociación'**
  String get mentoring_buyer_m5_i1_title;

  /// No description provided for @mentoring_buyer_m6_title.
  ///
  /// In es, this message translates to:
  /// **'Formalizar la adquisición'**
  String get mentoring_buyer_m6_title;

  /// No description provided for @mentoring_buyer_m6_description.
  ///
  /// In es, this message translates to:
  /// **'Revisar la documentación legal, completar la Due Diligence y formalizar la compra mediante los contratos correspondientes.'**
  String get mentoring_buyer_m6_description;

  /// No description provided for @mentoring_buyer_m6_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Contratos y cierre'**
  String get mentoring_buyer_m6_i1_title;

  /// No description provided for @mentoring_buyer_m7_title.
  ///
  /// In es, this message translates to:
  /// **'Gestionar la empresa después de la compra'**
  String get mentoring_buyer_m7_title;

  /// No description provided for @mentoring_buyer_m7_description.
  ///
  /// In es, this message translates to:
  /// **'Planificar la transición, mantener la confianza del equipo y de los clientes, y establecer las bases para el futuro crecimiento del negocio.'**
  String get mentoring_buyer_m7_description;

  /// No description provided for @mentoring_buyer_m7_i1_title.
  ///
  /// In es, this message translates to:
  /// **'Traspaso de poderes'**
  String get mentoring_buyer_m7_i1_title;

  /// No description provided for @solicitudAiCvAvailableTitle.
  ///
  /// In es, this message translates to:
  /// **'Análisis de CV con Inteligencia Artificial disponible'**
  String get solicitudAiCvAvailableTitle;

  /// No description provided for @solicitudAiCvAvailableSub.
  ///
  /// In es, this message translates to:
  /// **'Analiza el currículum de este candidato para evaluar compatibilidad y experiencia.'**
  String get solicitudAiCvAvailableSub;

  /// No description provided for @solicitudAnalyzeAi.
  ///
  /// In es, this message translates to:
  /// **'Analizar con IA'**
  String get solicitudAnalyzeAi;

  /// No description provided for @solicitudAnalyzingAiTitle.
  ///
  /// In es, this message translates to:
  /// **'Analizando currículum con IA...'**
  String get solicitudAnalyzingAiTitle;

  /// No description provided for @solicitudAnalyzingAiSub.
  ///
  /// In es, this message translates to:
  /// **'Evaluando perfil y experiencia, ¡falta muy poco!'**
  String get solicitudAnalyzingAiSub;

  /// No description provided for @solicitudAiErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'Error en el análisis de IA'**
  String get solicitudAiErrorTitle;

  /// No description provided for @solicitudAiErrorSub.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar el análisis automático del documento PDF.'**
  String get solicitudAiErrorSub;

  /// No description provided for @solicitudRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get solicitudRetry;

  /// No description provided for @solicitudAiCompleted.
  ///
  /// In es, this message translates to:
  /// **'Análisis de CV con IA Completado'**
  String get solicitudAiCompleted;

  /// No description provided for @solicitudSuitability.
  ///
  /// In es, this message translates to:
  /// **'Idoneidad:'**
  String get solicitudSuitability;

  /// No description provided for @solicitudCandidateSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen del Candidato'**
  String get solicitudCandidateSummary;

  /// No description provided for @solicitudDetectedStrengths.
  ///
  /// In es, this message translates to:
  /// **'Fortalezas Detectadas'**
  String get solicitudDetectedStrengths;

  /// No description provided for @solicitudExperienceMilestones.
  ///
  /// In es, this message translates to:
  /// **'Hitos de Experiencia'**
  String get solicitudExperienceMilestones;

  /// No description provided for @solicitudSuitabilityFeedback.
  ///
  /// In es, this message translates to:
  /// **'Feedback de Idoneidad'**
  String get solicitudSuitabilityFeedback;

  /// No description provided for @notificationPreferencesTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración de notificaciones'**
  String get notificationPreferencesTitle;

  /// No description provided for @notificationPrefNewMessages.
  ///
  /// In es, this message translates to:
  /// **'Nuevos mensajes'**
  String get notificationPrefNewMessages;

  /// No description provided for @notificationPrefNewMessagesDesc.
  ///
  /// In es, this message translates to:
  /// **'Recibir alertas cuando tengas nuevos mensajes de chat.'**
  String get notificationPrefNewMessagesDesc;

  /// No description provided for @notificationPrefApplicationStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado de solicitudes'**
  String get notificationPrefApplicationStatus;

  /// No description provided for @notificationPrefApplicationStatusDesc.
  ///
  /// In es, this message translates to:
  /// **'Alertas sobre actualizaciones en tus solicitudes enviadas.'**
  String get notificationPrefApplicationStatusDesc;

  /// No description provided for @notificationPrefNewApplications.
  ///
  /// In es, this message translates to:
  /// **'Nuevas solicitudes recibidas'**
  String get notificationPrefNewApplications;

  /// No description provided for @notificationPrefNewApplicationsDesc.
  ///
  /// In es, this message translates to:
  /// **'Notificar cuando un candidato solicite información de tu negocio.'**
  String get notificationPrefNewApplicationsDesc;

  /// No description provided for @notificationPrefCvAnalysis.
  ///
  /// In es, this message translates to:
  /// **'Análisis de CV por IA'**
  String get notificationPrefCvAnalysis;

  /// No description provided for @notificationPrefCvAnalysisDesc.
  ///
  /// In es, this message translates to:
  /// **'Avisar cuando termine el análisis de CV inteligente de un candidato.'**
  String get notificationPrefCvAnalysisDesc;

  /// No description provided for @notificationPrefOfferAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas de nuevas ofertas'**
  String get notificationPrefOfferAlerts;

  /// No description provided for @notificationPrefOfferAlertsDesc.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones de ofertas que coincidan con tus facturaciones de interés.'**
  String get notificationPrefOfferAlertsDesc;

  /// No description provided for @notificationPrefSaveSuccess.
  ///
  /// In es, this message translates to:
  /// **'Preferencias de notificación guardadas correctamente'**
  String get notificationPrefSaveSuccess;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In es, this message translates to:
  /// **'Marcar todo como leído'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsClearAll.
  ///
  /// In es, this message translates to:
  /// **'Vaciar historial'**
  String get notificationsClearAll;

  /// No description provided for @notificationsDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Quieres eliminar esta notificación?'**
  String get notificationsDeleteConfirm;

  /// No description provided for @notificationsClearConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres vaciar el historial de notificaciones?'**
  String get notificationsClearConfirm;

  /// No description provided for @notificationsDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get notificationsDelete;

  /// No description provided for @notificationsCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get notificationsCancel;

  /// No description provided for @categoryAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get categoryAll;

  /// No description provided for @categoryHospitality.
  ///
  /// In es, this message translates to:
  /// **'Hostelería'**
  String get categoryHospitality;

  /// No description provided for @categoryRetail.
  ///
  /// In es, this message translates to:
  /// **'Comercio'**
  String get categoryRetail;

  /// No description provided for @categoryIndustrial.
  ///
  /// In es, this message translates to:
  /// **'Industria'**
  String get categoryIndustrial;

  /// No description provided for @categoryHealth.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get categoryHealth;

  /// No description provided for @categoryServices.
  ///
  /// In es, this message translates to:
  /// **'Servicios'**
  String get categoryServices;

  /// No description provided for @categoryTechnology.
  ///
  /// In es, this message translates to:
  /// **'Tecnología'**
  String get categoryTechnology;

  /// No description provided for @noOffersFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron ofertas'**
  String get noOffersFound;

  /// No description provided for @offerPaymentContinueButton.
  ///
  /// In es, this message translates to:
  /// **'Seguir con el pago'**
  String get offerPaymentContinueButton;

  /// No description provided for @offerPaymentConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'Confirmar pago y publicar'**
  String get offerPaymentConfirmTitle;

  /// No description provided for @offerPaymentConfirmDesc.
  ///
  /// In es, this message translates to:
  /// **'Para publicar esta oferta, te redirigiremos a Stripe para completar el pago en modo prueba.'**
  String get offerPaymentConfirmDesc;

  /// No description provided for @offerPaymentSummaryHeader.
  ///
  /// In es, this message translates to:
  /// **'Resumen de la oferta:'**
  String get offerPaymentSummaryHeader;

  /// No description provided for @offerPaymentConfirmButton.
  ///
  /// In es, this message translates to:
  /// **'Confirmar y publicar'**
  String get offerPaymentConfirmButton;

  /// No description provided for @profileBecomePremium.
  ///
  /// In es, this message translates to:
  /// **'Hazte Premium'**
  String get profileBecomePremium;

  /// No description provided for @profileYouArePremiumActive.
  ///
  /// In es, this message translates to:
  /// **'Eres Premium (Activo)'**
  String get profileYouArePremiumActive;

  /// No description provided for @premiumScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Relevo Premium'**
  String get premiumScreenTitle;

  /// No description provided for @premiumHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'La herramienta definitiva para profesionales de la compraventa de negocios'**
  String get premiumHeroSubtitle;

  /// No description provided for @premiumStatusActive.
  ///
  /// In es, this message translates to:
  /// **'SUSCRIPCIÓN ACTIVA'**
  String get premiumStatusActive;

  /// No description provided for @premiumStatusActiveDesc.
  ///
  /// In es, this message translates to:
  /// **'Ya eres miembro Premium. Disfruta de todas las ventajas.'**
  String get premiumStatusActiveDesc;

  /// No description provided for @premiumPriceLabel.
  ///
  /// In es, this message translates to:
  /// **'Solo €19.90 / 30 días'**
  String get premiumPriceLabel;

  /// No description provided for @premiumSimulateIndicator.
  ///
  /// In es, this message translates to:
  /// **'* Pago seguro con Stripe en modo prueba'**
  String get premiumSimulateIndicator;

  /// No description provided for @premiumCtaText.
  ///
  /// In es, this message translates to:
  /// **'Hazte Premium'**
  String get premiumCtaText;

  /// No description provided for @premiumIncludesTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Qué incluye Relevo Premium?'**
  String get premiumIncludesTitle;

  /// No description provided for @premiumBenefit1Title.
  ///
  /// In es, this message translates to:
  /// **'Detalles Ilimitados'**
  String get premiumBenefit1Title;

  /// No description provided for @premiumBenefit1Desc.
  ///
  /// In es, this message translates to:
  /// **'Acceso completo a toda la información confidencial, datos financieros y documentos de las ofertas publicadas.'**
  String get premiumBenefit1Desc;

  /// No description provided for @premiumBenefit2Title.
  ///
  /// In es, this message translates to:
  /// **'Filtros Avanzados'**
  String get premiumBenefit2Title;

  /// No description provided for @premiumBenefit2Desc.
  ///
  /// In es, this message translates to:
  /// **'Filtra oportunidades por sector, facturación, volumen de empleados, región exacta y edad del negocio.'**
  String get premiumBenefit2Desc;

  /// No description provided for @premiumBenefit3Title.
  ///
  /// In es, this message translates to:
  /// **'Chat Prioritario Directo'**
  String get premiumBenefit3Title;

  /// No description provided for @premiumBenefit3Desc.
  ///
  /// In es, this message translates to:
  /// **'Contacta directamente con los propietarios y vendedores de negocios con prioridad de respuesta sin esperas.'**
  String get premiumBenefit3Desc;

  /// No description provided for @premiumBenefit4Title.
  ///
  /// In es, this message translates to:
  /// **'Soporte Personalizado'**
  String get premiumBenefit4Title;

  /// No description provided for @premiumBenefit4Desc.
  ///
  /// In es, this message translates to:
  /// **'Asistencia personalizada y asesoramiento especializado durante el proceso de compraventa.'**
  String get premiumBenefit4Desc;

  /// No description provided for @premiumPaymentDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Confirmar pago'**
  String get premiumPaymentDialogTitle;

  /// No description provided for @premiumPaymentDialogMessage.
  ///
  /// In es, this message translates to:
  /// **'Estás a punto de activar el plan Premium. Abriremos Stripe Checkout en modo prueba para completar el pago.\n\nSuscripción: Relevo Pro\nDuración: 30 días\nPrecio: €19.90'**
  String get premiumPaymentDialogMessage;

  /// No description provided for @premiumPaymentDialogCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get premiumPaymentDialogCancel;

  /// No description provided for @premiumPaymentDialogConfirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar y Activar'**
  String get premiumPaymentDialogConfirm;

  /// No description provided for @premiumSuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'¡Plan Premium activado correctamente!'**
  String get premiumSuccessMessage;

  /// No description provided for @premiumErrorMessage.
  ///
  /// In es, this message translates to:
  /// **'Error al activar el plan Premium. Por favor, inténtalo de nuevo.'**
  String get premiumErrorMessage;

  /// No description provided for @profileOptionEditProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get profileOptionEditProfile;

  /// No description provided for @profileOptionMyFavorites.
  ///
  /// In es, this message translates to:
  /// **'Mis favoritos'**
  String get profileOptionMyFavorites;

  /// No description provided for @profileOptionSearchAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas de búsqueda'**
  String get profileOptionSearchAlerts;

  /// No description provided for @profileOptionNotificationSettings.
  ///
  /// In es, this message translates to:
  /// **'Configuración de notificaciones'**
  String get profileOptionNotificationSettings;

  /// No description provided for @profileOptionMentoringProgram.
  ///
  /// In es, this message translates to:
  /// **'Programa de mentoring'**
  String get profileOptionMentoringProgram;

  /// No description provided for @profileOptionLogout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get profileOptionLogout;

  /// No description provided for @drawerNavigationMenu.
  ///
  /// In es, this message translates to:
  /// **'Menú de navegación'**
  String get drawerNavigationMenu;

  /// No description provided for @bottomNavChats.
  ///
  /// In es, this message translates to:
  /// **'Chats'**
  String get bottomNavChats;

  /// No description provided for @drawerLanguageSelector.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get drawerLanguageSelector;

  /// No description provided for @drawerFavorites.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get drawerFavorites;

  /// No description provided for @guestAccessRestricted.
  ///
  /// In es, this message translates to:
  /// **'Acceso Restringido'**
  String get guestAccessRestricted;

  /// No description provided for @guestAccessDesc.
  ///
  /// In es, this message translates to:
  /// **'Necesitas iniciar sesión o registrarte para gestionar tus {tabName}, conversaciones y conectar con los fundadores directamente.'**
  String guestAccessDesc(String tabName);

  /// No description provided for @guestLoginButton.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get guestLoginButton;

  /// No description provided for @guestRegisterButton.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get guestRegisterButton;

  /// No description provided for @paymentCheckoutTitle.
  ///
  /// In es, this message translates to:
  /// **'Pago seguro'**
  String get paymentCheckoutTitle;

  /// No description provided for @paymentCheckoutOpening.
  ///
  /// In es, this message translates to:
  /// **'Abriendo Stripe Checkout...'**
  String get paymentCheckoutOpening;

  /// No description provided for @paymentCheckoutChecking.
  ///
  /// In es, this message translates to:
  /// **'Comprobando el estado del pago...'**
  String get paymentCheckoutChecking;

  /// No description provided for @paymentCheckoutExternalTitle.
  ///
  /// In es, this message translates to:
  /// **'Continúa el pago en Stripe'**
  String get paymentCheckoutExternalTitle;

  /// No description provided for @paymentCheckoutExternalDescription.
  ///
  /// In es, this message translates to:
  /// **'Hemos abierto Stripe en tu navegador. Cuando completes el pago, volveremos a comprobar el resultado automáticamente.'**
  String get paymentCheckoutExternalDescription;

  /// No description provided for @paymentCheckoutOpen.
  ///
  /// In es, this message translates to:
  /// **'Abrir Stripe'**
  String get paymentCheckoutOpen;

  /// No description provided for @paymentCheckoutCheckNow.
  ///
  /// In es, this message translates to:
  /// **'Comprobar ahora'**
  String get paymentCheckoutCheckNow;

  /// No description provided for @paymentCheckoutOpenError.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido abrir Stripe. Inténtalo de nuevo.'**
  String get paymentCheckoutOpenError;

  /// No description provided for @paymentCheckoutStatusError.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido confirmar el estado del pago todavía.'**
  String get paymentCheckoutStatusError;

  /// No description provided for @paymentCheckoutCanceled.
  ///
  /// In es, this message translates to:
  /// **'Has cancelado el proceso de pago.'**
  String get paymentCheckoutCanceled;

  /// No description provided for @loadMoreOffers.
  ///
  /// In es, this message translates to:
  /// **'Cargar más ofertas'**
  String get loadMoreOffers;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
