// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String welcomeMessage(String name) {
    return 'Bienvenido/a a Relevo, $name';
  }

  @override
  String get fillAllFieldsError => 'Por favor, rellena todos los campos';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get loginWelcome => '¡Bienvenido de nuevo!';

  @override
  String get loginSubtitle => 'Inicia sesión para gestionar tus oportunidades.';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'Ej. juan@empresa.com';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHintLogin => 'Tu contraseña secreta';

  @override
  String get loginButton => 'Entrar';

  @override
  String get forgotPasswordButton => '¿Has olvidado tu contraseña?';

  @override
  String get registerTitle => 'Únete a Relevo';

  @override
  String get registerWelcome => 'Crea tu cuenta';

  @override
  String get registerSubtitle =>
      'Forma parte de la nueva generación de líderes.';

  @override
  String get fullNameLabel => 'Nombre completo';

  @override
  String get fullNameHint => 'Ej. Juan Pérez';

  @override
  String get passwordHintRegister => 'Mínimo 6 caracteres';

  @override
  String get roleQuestion => '¿Qué buscas en Relevo?';

  @override
  String get roleInterested => 'Busco oportunidades';

  @override
  String get roleOwner => 'Quiero traspasar mi negocio';

  @override
  String get registerButton => 'Crear Cuenta';

  @override
  String get homeMarketplaceBadge => 'Marketplace Líder';

  @override
  String get homeSlogan => 'Asegura el futuro de tu legado.';

  @override
  String get homeSlogan2 => 'Impulsa tu nuevo negocio.';

  @override
  String get profileTitle => 'Mi Perfil';

  @override
  String get profileDefaultUser => 'Usuario';

  @override
  String get profileSettings => 'Configuración';

  @override
  String get profileHelp => 'Ayuda y Soporte';

  @override
  String get profileLogout => 'Cerrar Sesión';

  @override
  String get profileNotRegisteredQuestion => '¿Aún no te has registrado?';

  @override
  String get profileNotRegisteredSubtitle =>
      'Únete a la plataforma y asegura el futuro de tu legado.';

  @override
  String get profileLoginButton => 'Iniciar Sesión';

  @override
  String get profileRegisterButton => 'Regístrate';

  @override
  String get bottomNavHome => 'Inicio';

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
      'Conectamos a fundadores experimentados con la próxima generación de líderes empresariales.';

  @override
  String get homeStatValue1 => '€12M+';

  @override
  String get homeStatLabel1 => 'Valor transaccionado';

  @override
  String get homeStatValue2 => '+500';

  @override
  String get homeStatLabel2 => 'Propietarios activos';

  @override
  String get homeOwnersTitle => 'PARA PROPIETARIOS';

  @override
  String get homeOwnersSubtitle => 'Tu retiro merece un sucesor a la altura.';

  @override
  String get homeOwnersDesc =>
      'Has construido algo valioso. No dejes que se pierda. Te ayudamos a encontrar al comprador ideal.';

  @override
  String get homeOwnersFeature1 => 'Valoración profesional del negocio.';

  @override
  String get homeOwnersFeature2 => 'Filtrado de compradores potenciales.';

  @override
  String get homeOwnersFeature3 => 'Máxima confidencialidad.';

  @override
  String get homeEntrepreneursTitle => 'PARA EMPRENDEDORES';

  @override
  String get homeEntrepreneursSubtitle => 'Emprende sobre una base sólida.';

  @override
  String get homeEntrepreneursDesc =>
      'No empieces de cero. Adquiere una empresa establecida con flujo de caja y clientes.';

  @override
  String get homeEntrepreneursFeatureTitle => 'Rentabilidad Probada';

  @override
  String get homeEntrepreneursFeatureDesc =>
      'Accede a históricos financieros auditados.';

  @override
  String get homeSearchHint => 'Busca en Relevo';

  @override
  String get homeFilters => 'Filtros';

  @override
  String get homeCompanyOffers => 'Ofertas de empresas';

  @override
  String get homeNearbyNews => 'Novedades cerca de ti';

  @override
  String get homeViewAll => 'Ver todo';

  @override
  String get bottomNavSell => 'Vender';

  @override
  String get bottomNavInbox => 'Mensajes';

  @override
  String get bottomNavYou => 'Tú';

  @override
  String get themeDarkMode => 'Modo oscuro';

  @override
  String get themeLightMode => 'Modo claro';

  @override
  String get errorInvalidCredentials => 'Email o contraseña incorrectos';

  @override
  String get errorUserExists => 'El usuario ya existe';

  @override
  String get errorInternal => 'Error interno del servidor';

  @override
  String get errorInvalidEmail => 'Email no válido';

  @override
  String get errorPasswordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get errorRequiredField => 'Este campo es obligatorio';

  @override
  String get registerSuccess => 'Registro completado. Inicia sesión.';

  @override
  String get profileFeatureMarketplaceTitle => 'Acceso al Marketplace';

  @override
  String get profileFeatureMarketplaceDesc =>
      'Explora cientos de oportunidades de traspaso de negocios activos.';

  @override
  String get profileFeatureChatTitle => 'Contacto Directo';

  @override
  String get profileFeatureChatDesc =>
      'Habla con los propietarios de forma segura a través del chat.';

  @override
  String get profileFeaturePublishTitle => 'Publica tu Negocio';

  @override
  String get profileFeaturePublishDesc =>
      'Vende o traspasa tu empresa con total confidencialidad.';

  @override
  String get restrictedAlertTitle => '¿Quieres ver todos los detalles?';

  @override
  String get restrictedAlertDesc =>
      'Inicia sesión o regístrate en Relevo para ver los precios, descripciones completas y contactar con los propietarios.';

  @override
  String get homeAboutTitle => '¿Qué es Relevo?';

  @override
  String get homeAboutDesc =>
      'Relevo es la plataforma líder para traspasar y adquirir empresas en funcionamiento de manera confidencial, directa y transparente. Conectamos a fundadores con la próxima generación de líderes.';

  @override
  String get homeAboutButton => '¿Quiénes somos?';

  @override
  String get profileSectionAbout => 'Sobre mí';

  @override
  String get profileSectionProfessional => 'Perfil Profesional';

  @override
  String get profileLocationLabel => 'Ubicación';

  @override
  String get profileBioLabel => 'Biografía';

  @override
  String get profileBackgroundLabel => 'Experiencia y capacidades';

  @override
  String get profileNoLocation => 'Sin ubicación especificada';

  @override
  String get profileNoBio => 'Sin biografía redactada todavía';

  @override
  String get profileNoBackground => 'Sin experiencia detallada todavía';

  @override
  String get profileEditTitle => 'Editar Perfil';

  @override
  String get profileSaveButton => 'Guardar cambios';

  @override
  String get profileSaveSuccess => 'Perfil actualizado correctamente';

  @override
  String get profileSaving => 'Guardando...';

  @override
  String get profileLocationHint => 'Ej. Barcelona, Cataluña';

  @override
  String get profileBioHint => 'Cuéntanos un poco sobre ti...';

  @override
  String get profileBackgroundHint =>
      'Detalla tu experiencia y habilidades profesionales...';

  @override
  String get sellTitle => 'Mi espacio de venta';

  @override
  String get sellPublishButton => 'Publicar Oferta';

  @override
  String get sellMyOffersSection => 'Tus oportunidades publicadas';

  @override
  String get sellEmptyStateTitle => 'Ningún negocio publicado todavía';

  @override
  String get sellEmptyStateDesc =>
      'Te ayudamos a encontrar al comprador ideal. Comienza publicando tu negocio con total confidencialidad.';

  @override
  String get offerCreateTitle => 'Publicar Negocio';

  @override
  String get offerSectorLabel => 'Sector del negocio';

  @override
  String get offerSectorHint => 'Ej. Hostelería, Automoción, Tecnología...';

  @override
  String get offerRegionLabel => 'Ubicación / Región';

  @override
  String get offerRegionHint => 'Ej. Gironès, Barcelona, Andorra...';

  @override
  String get offerRevenueLabel => 'Rango de Facturación Anual';

  @override
  String get offerEmployeesLabel => 'Número de Empleados';

  @override
  String get offerYearLabel => 'Año de Creación (Opcional)';

  @override
  String get offerYearHint => 'Ej. 2012';

  @override
  String get offerDescLabel => 'Breve Descripción del Negocio';

  @override
  String get offerDescHint =>
      'Resume tu negocio en un par de frases atractivas...';

  @override
  String get offerExtendedLabel => 'Descripción Detallada (Opcional)';

  @override
  String get offerExtendedHint =>
      'Explica más detalles como la clientela, activos, motivo de traspaso...';

  @override
  String get offerPublishButton => 'Publicar Oportunidad';

  @override
  String get offerPublishSuccess => '¡Oferta publicada correctamente!';

  @override
  String get offerPublishError =>
      'Error al publicar la oferta. Inténtalo de nuevo.';

  @override
  String get offerErrorInvalidYear => 'Introduce un año válido';

  @override
  String get offerErrorDescTooShort =>
      'La descripción debe tener al menos 10 caracteres';
}
