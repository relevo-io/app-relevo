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
  /// **'Mensajes'**
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
