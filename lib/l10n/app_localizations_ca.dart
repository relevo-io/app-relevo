// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get helloWorld => 'Hola Món!';

  @override
  String welcomeMessage(String name) {
    return 'Benvingut/da a Relevo, $name';
  }

  @override
  String get fillAllFieldsError => 'Si us plau, omple tots els camps';

  @override
  String get loginTitle => 'Iniciar Sessió';

  @override
  String get loginWelcome => 'Benvingut/da de nou!';

  @override
  String get loginSubtitle =>
      'Inicia sessió per gestionar les teves oportunitats.';

  @override
  String get emailLabel => 'Correu electrònic';

  @override
  String get emailHint => 'Ex. joan@empresa.com';

  @override
  String get passwordLabel => 'Contrasenya';

  @override
  String get passwordHintLogin => 'La teva contrasenya secreta';

  @override
  String get loginButton => 'Entrar';

  @override
  String get forgotPasswordButton => 'Has oblidat la teva contrasenya?';

  @override
  String get registerTitle => 'Uneix-te a Relevo';

  @override
  String get registerWelcome => 'Crea el teu compte';

  @override
  String get registerSubtitle => 'Forma part de la nova generació de líders.';

  @override
  String get fullNameLabel => 'Nom complet';

  @override
  String get fullNameHint => 'Ex. Joan Pérez';

  @override
  String get passwordHintRegister => 'Mínim 6 caràcters';

  @override
  String get roleQuestion => 'Què busques a Relevo?';

  @override
  String get roleInterested => 'Busco oportunitats';

  @override
  String get roleOwner => 'Vull traspassar el meu negoci';

  @override
  String get registerButton => 'Crear Compte';

  @override
  String get homeMarketplaceBadge => 'Marketplace Líder';

  @override
  String get homeSlogan => 'Assegura el futur del teu llegat.';

  @override
  String get homeSlogan2 => 'Impulsa el teu nou negoci.';

  @override
  String get profileTitle => 'El Meu Perfil';

  @override
  String get profileDefaultUser => 'Usuari';

  @override
  String get profileSettings => 'Configuració';

  @override
  String get profileHelp => 'Ajuda i Suport';

  @override
  String get profileLogout => 'Tancar Sessió';

  @override
  String get profileNotRegisteredQuestion => 'Encara no t\'has registrat?';

  @override
  String get profileNotRegisteredSubtitle =>
      'Uneix-te a la plataforma i assegura el futur del teu llegat.';

  @override
  String get profileLoginButton => 'Iniciar Sessió';

  @override
  String get profileRegisterButton => 'Registra\'t';

  @override
  String get bottomNavHome => 'Inici';

  @override
  String get bottomNavProfile => 'Perfil';

  @override
  String get languageSelectorES => 'Español (ES)';

  @override
  String get languageSelectorCA => 'Català (CA)';

  @override
  String get languageSelectorEN => 'English (EN)';

  @override
  String get homeIntro =>
      'Connectem fundadors experimentats amb la propera generació de líders empresarials.';

  @override
  String get homeStatValue1 => '€12M+';

  @override
  String get homeStatLabel1 => 'Valor transaccionat';

  @override
  String get homeStatValue2 => '+500';

  @override
  String get homeStatLabel2 => 'Propietaris actius';

  @override
  String get homeOwnersTitle => 'PER A PROPIETARIS';

  @override
  String get homeOwnersSubtitle =>
      'La teva jubilació mereix un successor a l\'alçada.';

  @override
  String get homeOwnersDesc =>
      'Has construït una cosa valuosa. No deixis que es perdi. T\'ajudem a trobar el comprador ideal.';

  @override
  String get homeOwnersFeature1 => 'Valoració professional del negoci.';

  @override
  String get homeOwnersFeature2 => 'Filtratge de compradors potencials.';

  @override
  String get homeOwnersFeature3 => 'Màxima confidencialitat.';

  @override
  String get homeEntrepreneursTitle => 'PER A EMPRENEDORS';

  @override
  String get homeEntrepreneursSubtitle => 'Emprèn sobre una base sòlida.';

  @override
  String get homeEntrepreneursDesc =>
      'No comencis de zero. Adquireix una empresa establerta amb flux de caixa i clients.';

  @override
  String get homeEntrepreneursFeatureTitle => 'Rentabilitat Provada';

  @override
  String get homeEntrepreneursFeatureDesc =>
      'Accedeix a històrics financers auditats.';

  @override
  String get homeSearchHint => 'Busca a Relevo';

  @override
  String get homeFilters => 'Filtres';

  @override
  String get homeCompanyOffers => 'Ofertes d\'empreses';

  @override
  String get homeNearbyNews => 'Novetats prop de tu';

  @override
  String get homeViewAll => 'Veure-ho tot';

  @override
  String get bottomNavSell => 'Vendre';

  @override
  String get bottomNavInbox => 'Missatges';

  @override
  String get bottomNavYou => 'Tu';

  @override
  String get themeDarkMode => 'Mode fosc';

  @override
  String get themeLightMode => 'Mode clar';

  @override
  String get errorInvalidCredentials => 'Email o contrasenya incorrectes';

  @override
  String get errorUserExists => 'L\'usuari ja existeix';

  @override
  String get errorInternal => 'Error intern del servidor';

  @override
  String get errorInvalidEmail => 'Email no vàlid';

  @override
  String get errorPasswordTooShort =>
      'La contrasenya ha de tenir almenys 6 caràcters';

  @override
  String get errorRequiredField => 'Aquest camp és obligatori';
}
