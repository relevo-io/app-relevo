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
  String get bottomNavInbox => 'Solicitudes';

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

  @override
  String get offerDetailsTitle => 'Detalle de la oferta';

  @override
  String get offerDetailsLocation => 'Ubicación';

  @override
  String get offerDetailsRevenue => 'Facturación anual';

  @override
  String get offerDetailsEmployees => 'Empleados';

  @override
  String get offerDetailsYear => 'Año de fundación';

  @override
  String get offerDetailsDescription => 'Descripción del negocio';

  @override
  String get offerDetailsExtended => 'Información detallada';

  @override
  String get offerDetailsApplyButton => 'Solicitar información';

  @override
  String get offerDetailsPublished => 'Publicado';

  @override
  String get offerDetailsFavoriteAdded => 'Oferta agregada a favoritos';

  @override
  String get offerDetailsFavoriteRemoved => 'Oferta eliminada de favoritos';

  @override
  String get offerDetailsFavoriteTooltip => 'Favorito';

  @override
  String get offerDetailsStatusPendingDesc =>
      'Pendiente de revisión por el propietario.';

  @override
  String get offerDetailsStatusAcceptedDesc =>
      '¡Solicitud aceptada! Se pondrán en contacto.';

  @override
  String get offerDetailsStatusRejectedDesc =>
      'Solicitud denegada para esta oportunidad.';

  @override
  String get offerDetailsChatWithOwner => 'Chatear con el propietario';

  @override
  String offerDetailsChatError(Object error) {
    return 'Error al abrir el chat: $error';
  }

  @override
  String get inboxTitle => 'Buzón de solicitudes';

  @override
  String get inboxTabReceived => 'Recibidas';

  @override
  String get inboxTabSent => 'Enviadas';

  @override
  String get inboxEmptyReceived =>
      'No has recibido ninguna solicitud de acceso todavía';

  @override
  String get inboxEmptySent =>
      'No has enviado ninguna solicitud de acceso todavía';

  @override
  String get inboxStatusPending => 'Pendiente';

  @override
  String get inboxStatusAccepted => 'Aceptada';

  @override
  String get inboxStatusRejected => 'Denegada';

  @override
  String get inboxActionAccept => 'Aceptar';

  @override
  String get inboxActionReject => 'Denegar';

  @override
  String get inboxMessageLabel => 'Mensaje';

  @override
  String get offerApplyFormTitle => 'Solicitud de acceso';

  @override
  String get offerApplyBackgroundLabel =>
      'Experiencia y capacidades (Background)';

  @override
  String get offerApplyBackgroundHint =>
      'Explica tu trayectoria o experiencia en el sector...';

  @override
  String get offerApplyRegionsLabel => 'Zonas preferidas de traspaso';

  @override
  String get offerApplyRegionsHint =>
      'Ej: Gironès, Osona, Andorra (separadas por comas)...';

  @override
  String get offerApplyBioLabel => 'Biografía';

  @override
  String get offerApplyBioHint =>
      'Haz una breve descripción sobre quién eres y tus valores...';

  @override
  String get offerApplyCvLabel => 'Currículum Vitae (PDF)';

  @override
  String get offerApplyCvSelect => 'Adjuntar currículum en formato PDF';

  @override
  String offerApplyCvSelected(Object filename) {
    return 'CV adjuntado: $filename';
  }

  @override
  String get offerApplySubmitButton => 'Enviar solicitud al propietario';

  @override
  String get offerApplyRequiredError => 'Este campo es obligatorio';

  @override
  String offerApplyMinLengthError(Object min) {
    return 'Debe tener al menos $min caracteres';
  }

  @override
  String get offerApplyCvError => 'Por favor, adjunta tu currículum PDF';

  @override
  String get offerApplyCapitalLabel => 'Capital disponible (€)';

  @override
  String get offerApplyCapitalHint => 'Ej: 50000';

  @override
  String get offerApplyCapitalError => 'Introduce un importe válido (>= 0)';

  @override
  String get offerApplyFinancingLabel => '¿Necesitas financiación?';

  @override
  String get offerApplyNdaLabel =>
      'Acepto el acuerdo de confidencialidad (NDA) y me comprometo a mantener reservados los detalles de la oferta.';

  @override
  String get offerApplyNdaError =>
      'Debes aceptar el acuerdo de confidencialidad para continuar.';

  @override
  String get offerApplySuccessTitle => '¡Solicitud enviada!';

  @override
  String get offerApplySuccessMessage =>
      'Tu solicitud se ha enviado correctamente al propietario de la oferta.';

  @override
  String get offerApplySuccessOk => 'Entendido';

  @override
  String offerApplyErrorPrefix(Object error) {
    return 'Error al enviar la solicitud: $error';
  }

  @override
  String get inboxErrorLoading => 'Error al cargar las solicitudes';

  @override
  String get inboxRetry => 'Volver a intentar';

  @override
  String get inboxStatusUpdatedSuccessfully => 'correctamente.';

  @override
  String get inboxOwnerLabel => 'Propietario';

  @override
  String get inboxNotAvailable => 'N/A';

  @override
  String get solicitudApplicantData => 'Datos del solicitante';

  @override
  String get solicitudNoBio => 'Sin biografía especificada.';

  @override
  String get solicitudNoBackground =>
      'Sin trayectoria profesional especificada.';

  @override
  String get solicitudPreferencesFinance => 'Preferencias y Financieros';

  @override
  String get solicitudAllRegions => 'Todas las regiones';

  @override
  String get solicitudNotSpecified => 'No especificado';

  @override
  String get solicitudYes => 'Sí';

  @override
  String get solicitudNo => 'No';

  @override
  String get solicitudDocSecurity => 'Documentación y Seguridad';

  @override
  String get solicitudNdaTitle => 'NDA de acuerdo de confidencialidad';

  @override
  String get solicitudAccepted => 'Aceptado';

  @override
  String get solicitudCvTitle => 'Currículum Vitae';

  @override
  String get solicitudCvPdfSubtitle => 'Archivo adjunto en PDF';

  @override
  String get solicitudCvView => 'Ver';

  @override
  String get solicitudCvPreviewComingSoon =>
      '¡Visualización de CV próximamente!';

  @override
  String get profileMentoring => 'Programa de Mentoring';

  @override
  String get mentoringTitle => 'Mentoring';

  @override
  String get mentoringProgressLabel => 'Tu progreso';

  @override
  String mentoringDurationMinutes(Object duration) {
    return '$duration min';
  }

  @override
  String get mentoringModuleCompleted => 'Completado';

  @override
  String get mentoringModulePending => 'Pendiente';

  @override
  String get mentoringCompletedAlert =>
      '¡Enhorabuena! Has completado este módulo de mentoring.';

  @override
  String get mentoringMarkAsCompleted => 'Marcar como completado';

  @override
  String get mentoringItemTip => 'Consejo';

  @override
  String get mentoringItemQuestion => 'Pregunta';

  @override
  String get mentoringItemTask => 'Tarea';

  @override
  String get mentoringDetailTitle => 'Detalles del Módulo';

  @override
  String get mentoringLoading => 'Cargando mentoring...';

  @override
  String mentoringError(Object error) {
    return 'Error cargando mentoring: $error';
  }

  @override
  String get profileAlerts => 'Alertas de búsqueda';

  @override
  String get profileNotifications => 'Notificaciones';

  @override
  String get alertsTitle => 'Gestionar Alertas';

  @override
  String get alertsEmpty => 'No tienes ninguna alerta configurada.';

  @override
  String get alertsCreateButton => 'Activar Alerta';

  @override
  String get alertsDeleteSuccess => 'Alerta eliminada correctamente';

  @override
  String get alertsCreateSuccess => 'Alerta creada correctamente';

  @override
  String get alertsSelectRevenue =>
      'Selecciona el rango de facturación de interés:';

  @override
  String get notificationsTitle => 'Buzón de Notificaciones';

  @override
  String get notificationsEmpty => 'No tienes ninguna notificación.';

  @override
  String notificationsNewOffer(Object sector) {
    return 'Se ha publicado una nueva oferta en el sector $sector que se ajusta a tus preferencias.';
  }

  @override
  String get revenueRangeUNDER_100K => 'Menos de 100K €';

  @override
  String get revenueRangeBETWEEN_100K_500K => 'Entre 100K € y 500K €';

  @override
  String get revenueRangeBETWEEN_500K_1M => 'Entre 500K € y 1M €';

  @override
  String get revenueRangeBETWEEN_1M_5M => 'Entre 1M € y 5M €';

  @override
  String get revenueRangeOVER_5M => 'Más de 5M €';

  @override
  String get mentoringTabBuy => 'Quiero comprar';

  @override
  String get mentoringTabSell => 'Quiero vender';

  @override
  String get mentoringNoModules => 'No hay módulos en esta ruta';

  @override
  String mentoringErrorLoadingContent(Object error) {
    return 'Error al cargar el contenido: $error';
  }

  @override
  String get mentoring_seller_m1_title => 'Preparar la empresa para la venta';

  @override
  String get mentoring_seller_m1_description =>
      'Aprender a identificar el mejor momento para vender, entender los motivos habituales de venta y evitar errores frecuentes antes de publicar la oferta.';

  @override
  String get mentoring_seller_m1_i1_title => 'Preparar la venta';

  @override
  String get mentoring_seller_m2_title => 'Organizar la documentación';

  @override
  String get mentoring_seller_m2_description =>
      'Preparar la documentación financiera, legal y operativa necesaria para transmitir confianza a los posibles compradores.';

  @override
  String get mentoring_seller_m2_i1_title => 'Documentación clave';

  @override
  String get mentoring_seller_m3_title => 'Valorar la empresa';

  @override
  String get mentoring_seller_m3_description =>
      'Comprender qué factores determinan el valor de una empresa, como la rentabilidad, los activos y el potencial de crecimiento.';

  @override
  String get mentoring_seller_m3_i1_title => 'Valoración del negocio';

  @override
  String get mentoring_seller_m4_title => 'Crear una oferta atractiva';

  @override
  String get mentoring_seller_m4_description =>
      'Aprender a presentar el negocio de manera profesional, destacando los puntos fuertes y protegiendo la información confidencial.';

  @override
  String get mentoring_seller_m4_i1_title => 'Presentación profesional';

  @override
  String get mentoring_seller_m5_title => 'Gestionar contactos y negociaciones';

  @override
  String get mentoring_seller_m5_description =>
      'Filtrar posibles compradores, compartir información de manera progresiva y gestionar las negociaciones con profesionalidad.';

  @override
  String get mentoring_seller_m5_i1_title => 'El proceso de negociación';

  @override
  String get mentoring_seller_m6_title => 'Cerrar la venta';

  @override
  String get mentoring_seller_m6_description =>
      'Completar las fases finales del proceso, incluyendo la Due Diligence, la firma de los contratos y la preparación de la transición.';

  @override
  String get mentoring_seller_m6_i1_title => 'Cierre de la venta';

  @override
  String get mentoring_buyer_m1_title => 'Definir los objetivos de compra';

  @override
  String get mentoring_buyer_m1_description =>
      'Determinar el presupuesto disponible, los sectores de interés y las características que debería tener la empresa ideal.';

  @override
  String get mentoring_buyer_m1_i1_title => 'Definir criterios';

  @override
  String get mentoring_buyer_m2_title => 'Buscar oportunidades';

  @override
  String get mentoring_buyer_m2_description =>
      'Aprender dónde encontrar empresas en venta y cómo realizar un primer filtrado de oportunidades potenciales.';

  @override
  String get mentoring_buyer_m2_i1_title => 'Búsqueda de oportunidades';

  @override
  String get mentoring_buyer_m3_title => 'Analizar la situación financiera';

  @override
  String get mentoring_buyer_m3_description =>
      'Interpretar la información financiera de la empresa, incluyendo facturación, beneficios, endeudamiento y liquidez.';

  @override
  String get mentoring_buyer_m3_i1_title => 'Análisis financiero';

  @override
  String get mentoring_buyer_m4_title => 'Valorar si el precio es correcto';

  @override
  String get mentoring_buyer_m4_description =>
      'Analizar si la valoración propuesta por el vendedor es coherente con la realidad y el potencial del negocio.';

  @override
  String get mentoring_buyer_m4_i1_title => 'Evaluar la valoración';

  @override
  String get mentoring_buyer_m5_title => 'Negociar la compra';

  @override
  String get mentoring_buyer_m5_description =>
      'Prepararse para negociar el precio y las condiciones de la operación, identificando riesgos y oportunidades.';

  @override
  String get mentoring_buyer_m5_i1_title => 'Estrategias de negociación';

  @override
  String get mentoring_buyer_m6_title => 'Formalizar la adquisición';

  @override
  String get mentoring_buyer_m6_description =>
      'Revisar la documentación legal, completar la Due Diligence y formalizar la compra mediante los contratos correspondientes.';

  @override
  String get mentoring_buyer_m6_i1_title => 'Contratos y cierre';

  @override
  String get mentoring_buyer_m7_title =>
      'Gestionar la empresa después de la compra';

  @override
  String get mentoring_buyer_m7_description =>
      'Planificar la transición, mantener la confianza del equipo y de los clientes, y establecer las bases para el futuro crecimiento del negocio.';

  @override
  String get mentoring_buyer_m7_i1_title => 'Traspaso de poderes';

  @override
  String get solicitudAiCvAvailableTitle =>
      'Análisis de CV con Inteligencia Artificial disponible';

  @override
  String get solicitudAiCvAvailableSub =>
      'Analiza el currículum de este candidato para evaluar compatibilidad y experiencia.';

  @override
  String get solicitudAnalyzeAi => 'Analizar con IA';

  @override
  String get solicitudAnalyzingAiTitle => 'Analizando currículum con IA...';

  @override
  String get solicitudAnalyzingAiSub =>
      'Evaluando perfil y experiencia, ¡falta muy poco!';

  @override
  String get solicitudAiErrorTitle => 'Error en el análisis de IA';

  @override
  String get solicitudAiErrorSub =>
      'No se pudo completar el análisis automático del documento PDF.';

  @override
  String get solicitudRetry => 'Reintentar';

  @override
  String get solicitudAiCompleted => 'Análisis de CV con IA Completado';

  @override
  String get solicitudSuitability => 'Idoneidad:';

  @override
  String get solicitudCandidateSummary => 'Resumen del Candidato';

  @override
  String get solicitudDetectedStrengths => 'Fortalezas Detectadas';

  @override
  String get solicitudExperienceMilestones => 'Hitos de Experiencia';

  @override
  String get solicitudSuitabilityFeedback => 'Feedback de Idoneidad';

  @override
  String get notificationPreferencesTitle => 'Configuración de notificaciones';

  @override
  String get notificationPrefNewMessages => 'Nuevos mensajes';

  @override
  String get notificationPrefNewMessagesDesc =>
      'Recibir alertas cuando tengas nuevos mensajes de chat.';

  @override
  String get notificationPrefApplicationStatus => 'Estado de solicitudes';

  @override
  String get notificationPrefApplicationStatusDesc =>
      'Alertas sobre actualizaciones en tus solicitudes enviadas.';

  @override
  String get notificationPrefNewApplications => 'Nuevas solicitudes recibidas';

  @override
  String get notificationPrefNewApplicationsDesc =>
      'Notificar cuando un candidato solicite información de tu negocio.';

  @override
  String get notificationPrefCvAnalysis => 'Análisis de CV por IA';

  @override
  String get notificationPrefCvAnalysisDesc =>
      'Avisar cuando termine el análisis de CV inteligente de un candidato.';

  @override
  String get notificationPrefOfferAlerts => 'Alertas de nuevas ofertas';

  @override
  String get notificationPrefOfferAlertsDesc =>
      'Notificaciones de ofertas que coincidan con tus facturaciones de interés.';

  @override
  String get notificationPrefSaveSuccess =>
      'Preferencias de notificación guardadas correctamente';

  @override
  String get notificationsMarkAllRead => 'Marcar todo como leído';

  @override
  String get notificationsClearAll => 'Vaciar historial';

  @override
  String get notificationsDeleteConfirm =>
      '¿Quieres eliminar esta notificación?';

  @override
  String get notificationsClearConfirm =>
      '¿Seguro que quieres vaciar el historial de notificaciones?';

  @override
  String get notificationsDelete => 'Eliminar';

  @override
  String get notificationsCancel => 'Cancelar';

  @override
  String get categoryAll => 'Todos';

  @override
  String get categoryHospitality => 'Hostelería';

  @override
  String get categoryRetail => 'Comercio';

  @override
  String get categoryIndustrial => 'Industria';

  @override
  String get categoryHealth => 'Salud';

  @override
  String get categoryServices => 'Servicios';

  @override
  String get categoryTechnology => 'Tecnología';

  @override
  String get noOffersFound => 'No se encontraron ofertas';

  @override
  String get offerPaymentContinueButton => 'Seguir con el pago';

  @override
  String get offerPaymentConfirmTitle => 'Confirmar pago y publicar';

  @override
  String get offerPaymentConfirmDesc =>
      'Para publicar esta oferta, debes confirmar el pago (simulado).';

  @override
  String get offerPaymentSummaryHeader => 'Resumen de la oferta:';

  @override
  String get offerPaymentConfirmButton => 'Confirmar y publicar';

  @override
  String get profileBecomePremium => 'Hazte Premium';

  @override
  String get profileYouArePremiumActive => 'Eres Premium (Activo)';

  @override
  String get premiumScreenTitle => 'Relevo Premium';

  @override
  String get premiumHeroSubtitle =>
      'La herramienta definitiva para profesionales de la compraventa de negocios';

  @override
  String get premiumStatusActive => 'SUSCRIPCIÓN ACTIVA';

  @override
  String get premiumStatusActiveDesc =>
      'Ya eres miembro Premium. Disfruta de todas las ventajas.';

  @override
  String get premiumPriceLabel => 'Solo €9.99/mes';

  @override
  String get premiumSimulateIndicator =>
      '* Activación completamente gratuita en modo de pruebas';

  @override
  String get premiumCtaText => 'Hazte Premium (Simulado)';

  @override
  String get premiumIncludesTitle => '¿Qué incluye Relevo Premium?';

  @override
  String get premiumBenefit1Title => 'Detalles Ilimitados';

  @override
  String get premiumBenefit1Desc =>
      'Acceso completo a toda la información confidencial, datos financieros y documentos de las ofertas publicadas.';

  @override
  String get premiumBenefit2Title => 'Filtros Avanzados';

  @override
  String get premiumBenefit2Desc =>
      'Filtra oportunidades por sector, facturación, volumen de empleados, región exacta y edad del negocio.';

  @override
  String get premiumBenefit3Title => 'Chat Prioritario Directo';

  @override
  String get premiumBenefit3Desc =>
      'Contacta directamente con los propietarios y vendedores de negocios con prioridad de respuesta sin esperas.';

  @override
  String get premiumBenefit4Title => 'Soporte Personalizado';

  @override
  String get premiumBenefit4Desc =>
      'Asistencia personalizada y asesoramiento especializado durante el proceso de compraventa.';

  @override
  String get premiumPaymentDialogTitle => 'Confirmar Pago Simulado';

  @override
  String get premiumPaymentDialogMessage =>
      'Estás a punto de activar el plan Premium. Este es un pago simulado para fines de prueba.\n\nSuscripción: Relevo Pro\nDuración: 30 días\nPrecio: €0.00';

  @override
  String get premiumPaymentDialogCancel => 'Cancelar';

  @override
  String get premiumPaymentDialogConfirm => 'Confirmar y Activar';

  @override
  String get premiumSuccessMessage => '¡Plan Premium activado correctamente!';

  @override
  String get premiumErrorMessage =>
      'Error al activar el plan Premium. Por favor, inténtalo de nuevo.';

  @override
  String get profileOptionEditProfile => 'Editar perfil';

  @override
  String get profileOptionMyFavorites => 'Mis favoritos';

  @override
  String get profileOptionSearchAlerts => 'Alertas de búsqueda';

  @override
  String get profileOptionNotificationSettings =>
      'Configuración de notificaciones';

  @override
  String get profileOptionMentoringProgram => 'Programa de mentoring';

  @override
  String get profileOptionLogout => 'Cerrar sesión';

  @override
  String get drawerNavigationMenu => 'Menú de navegación';

  @override
  String get bottomNavChats => 'Chats';

  @override
  String get drawerLanguageSelector => 'Idioma';

  @override
  String get drawerFavorites => 'Favoritos';

  @override
  String get guestAccessRestricted => 'Acceso Restringido';

  @override
  String guestAccessDesc(String tabName) {
    return 'Necesitas iniciar sesión o registrarte para gestionar tus $tabName, conversaciones y conectar con los fundadores directamente.';
  }

  @override
  String get guestLoginButton => 'Iniciar sesión';

  @override
  String get guestRegisterButton => 'Registrarse';
}
