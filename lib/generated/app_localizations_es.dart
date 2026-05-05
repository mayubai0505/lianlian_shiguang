// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get changeTheme => 'Cambiar color del tema';

  @override
  String get feedback => 'Comentarios y sugerencias';

  @override
  String get changeLanguage => 'Cambiar idioma';

  @override
  String get allFriendsTitle => 'Todos los amigos';

  @override
  String get noFriendsMessage => 'Todavía no tienes ningún amigo.';

  @override
  String get unknownCharacter => 'Personaje desconocido';

  @override
  String errorLoadingFriends(String error) {
    return 'Se produjo un error al cargar la lista de amigos: $error';
  }

  @override
  String get tagGentle => 'Amable';

  @override
  String get tagCheerful => 'Alegre';

  @override
  String get tagLively => 'Animado';

  @override
  String get tagMischievous => 'Travieso';

  @override
  String get tagRichYoungLady => 'Joven Dama Rica';

  @override
  String get tagRichYoungMaster => 'Joven Señor Rico';

  @override
  String get tagWealthyFamily => 'Familia Rica';

  @override
  String get tagScheming => 'Intrigante';

  @override
  String get tagPossessive => 'Posesivo';

  @override
  String get tagParanoid => 'Paranoico';

  @override
  String get tagPersistent => 'Persistente';

  @override
  String get tagUncle => 'Tío';

  @override
  String get tagAuntie => 'Tía';

  @override
  String get tagSeniorSister => 'Hermana Mayor';

  @override
  String get tagJuniorBrother => 'Hermano Menor';

  @override
  String get tagHandsome => 'Guapo';

  @override
  String get tagStunning => 'Impresionante';

  @override
  String get tagContrast => 'Contraste';

  @override
  String get tagFlirty => 'Coqueto';

  @override
  String get tagAgeGap => 'Brecha de Edad';

  @override
  String get userNotFoundError => 'Usuario no encontrado';

  @override
  String get imageDataMismatchError =>
      'Los datos de la imagen no coinciden, por favor, vuelva a seleccionar la imagen.';

  @override
  String get createCharacterTitle => 'Crear personaje';

  @override
  String get charAlbumTitle =>
      'Álbum del personaje (La primera imagen es el avatar principal)';

  @override
  String get charNameLabel => 'Nombre del personaje:*';

  @override
  String get charDescSection => 'Descripción del personaje:';

  @override
  String get charAgeLabel => 'Edad:';

  @override
  String get charJobLabel => 'Profesión:*';

  @override
  String get charBirthdayLabel => 'Cumpleaños:(MMDD)';

  @override
  String get charGenderLabel => 'Género *';

  @override
  String get genderNotSelected => 'No seleccionado';

  @override
  String get genderMale => 'Hombre';

  @override
  String get genderFemale => 'Mujer';

  @override
  String get genderOther => 'Otro';

  @override
  String get charHeightLabel => 'Altura:(cm)';

  @override
  String get charAppearanceLabel => 'Descripción de la apariencia:';

  @override
  String get charPersonalityTagsSection => 'Etiquetas de personalidad';

  @override
  String get charOtherPersonalityTagsHint =>
      'Otras etiquetas de personalidad...';

  @override
  String get otherSectionTitle => 'Otro';

  @override
  String get charLikesLabel =>
      'Cosas que le gustan:(ejemplo: pastel de fresa, gatos, días lluviosos)';

  @override
  String get charDislikesLabel =>
      'Cosas que le disgustan:(ejemplo: melón amargo, lugares ruidosos)';

  @override
  String get charSecretsLabel =>
      'Pequeños secretos desconocidos: (ejemplo: en realidad está perdido en el camino)';

  @override
  String get charMannerismsSection => 'Modales y gestos';

  @override
  String get charToneLabel =>
      'Tono y estilo de habla: (ejemplo: distante con extraños)';

  @override
  String get charDialogueExampleLabel =>
      'Ejemplo de diálogo: (Jugador: Eres muy amable! Personaje: ...Oh.)';

  @override
  String get charBackgroundSection => 'Trasfondo del personaje:';

  @override
  String get charBackgroundHint =>
      'Escriba la historia de fondo del personaje (máximo 2500 caracteres)';

  @override
  String get charStoryStartSection => 'Inicio de la historia:';

  @override
  String get charStoryStartHint =>
      'Escriba la trama del personaje (máximo 2500 caracteres)';

  @override
  String get charStorySummaryLabel =>
      'Resumen de la historia (máximo 50 caracteres, se mostrará en la tarjeta de encuentro)';

  @override
  String get charExtraInfoSection => 'Información adicional del personaje:';

  @override
  String get charExtraInfoHint => 'Escriba contenido adicional...';

  @override
  String get charPublicToggleLabel =>
      'Hacer público para que otros jugadores puedan jugar con él?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get createButton => 'Crear';

  @override
  String get saveButton => 'Guardar';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get exitCreationTitle =>
      'Va a salir de la pantalla de creación de personaje';

  @override
  String get saveDraftPrompt => '¿Necesita guardar como borrador?';

  @override
  String get draftNeeded => 'Sí';

  @override
  String get draftNotNeeded => 'No';

  @override
  String get editExtraInfoTitle => 'Editar contenido adicional';

  @override
  String get nameAndAvatarError =>
      '¡Por favor, escriba el nombre del personaje y suba al menos un avatar!';

  @override
  String get savingStatus => 'Guardando...';

  @override
  String get uploadingImagesStatus => 'Subiendo imágenes...';

  @override
  String get maxImagesError => 'Solo se puede subir un máximo de 10 imágenes.';

  @override
  String get uploadingImagesStatusShort => 'Procesando imágenes...';

  @override
  String get savingCharacterData => 'Guardando datos del personaje...';

  @override
  String characterCreatedSuccess(String charName) {
    return '¡Personaje \"$charName\" creado!';
  }

  @override
  String get uploadImageTimeoutError =>
      'Error al crear el personaje: el tiempo de carga de la imagen ha expirado, por favor, compruebe su conexión a internet.';

  @override
  String createCharacterGenericError(String error) {
    return 'Error al crear el personaje: $error';
  }

  @override
  String get settingsSectionAppearance => 'Apariencia y contenido';

  @override
  String get settingsSectionAccount => 'Gestión de cuenta y contenido';

  @override
  String get settingsSectionAbout => 'Acerca de nosotros';

  @override
  String get accountManagement => 'Gestión de la cuenta';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'Desconocido';

  @override
  String get userIdCopied =>
      'El ID de usuario se ha copiado en el portapapeles';

  @override
  String get characterManagement => 'Gestión de personajes';

  @override
  String get viewBlockedCharacters => 'Ver personajes bloqueados';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get logoutButton => 'Cerrar sesión';

  @override
  String get logoutDialogTitle => '¿Quiere cerrar sesión?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'Me equivoqué';

  @override
  String get logoutDialogActionConfirm => 'Confirmar';

  @override
  String get logoutSuccessSnackbar => '¡Ok! Te esperaré de vuelta♥(´∀` )';

  @override
  String get deleteAccountButton => 'Eliminar cuenta';

  @override
  String get deleteAccountDialogTitle =>
      '¿Está seguro de que desea eliminar esta cuenta?இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'Esta acción no se puede deshacer, ¡todos los datos se eliminarán de forma permanente!';

  @override
  String get deleteAccountDialogActionCancel => 'No, no quiero eliminarla';

  @override
  String get deleteAccountDialogActionConfirm => 'Confirmar';

  @override
  String get deleteAccountSuccessSnackbar =>
      'La cuenta ha sido eliminada con éxito.';

  @override
  String get appDisclaimer =>
      'Los personajes y escenas del juego son ficticios, ¡por favor no los aplique a la realidad! Si hay alguna similitud, es pura coincidencia.';

  @override
  String appVersion(String version) {
    return 'Versión de la aplicación: $version';
  }

  @override
  String get dialogTitleHint => 'Sugerencia';

  @override
  String get completeProfilePrompt =>
      '¡Por favor, edite su perfil para completar su información primero!';

  @override
  String get goToEdit => 'Ir a Editar';

  @override
  String get later => 'Más tarde';

  @override
  String chattingWith(String friendName) {
    return 'Chateando con $friendName';
  }

  @override
  String chatContentWith(String friendName) {
    return 'Contenido del chat con $friendName';
  }

  @override
  String get chatInputHint => 'Escribe un mensaje...';

  @override
  String get characterNotFoundError => 'Datos del personaje no encontrados';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'Error al cargar los detalles del personaje: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'Relación inicial';

  @override
  String get relationship_childhood_friend => 'Amigos de la infancia';

  @override
  String get relationship_senior_junior => 'Compañeros de clase mayor/menor';

  @override
  String get relationship_bickering_couple => 'Pareja de riñas';

  @override
  String get relationship_colleagues => 'Colegas de trabajo';

  @override
  String get relationship_other => 'Otro (por favor, ingrese manualmente)';

  @override
  String get chatModeDaily => 'Modo Diario';

  @override
  String get chatModeStory => 'Modo Historia';

  @override
  String get chatModeImmersive => 'Modo Inmersivo';

  @override
  String get chatModeGemini => 'Compañero de Vida';

  @override
  String get announcement_new => 'Nuevo Anuncio';

  @override
  String get mail_notification =>
      '¡Ha llegado una nueva Carta del Tiempo! ¡Ve a revisar el Pergamino ahora!';

  @override
  String get customer_service_reply => 'Respuesta de Atención al Cliente';

  @override
  String get system_announcement => 'Anuncio del Sistema';

  @override
  String get empty_announcement => 'No hay anuncios en este momento.';

  @override
  String get untitled => 'Sin título';

  @override
  String get no_content => 'Sin contenido';

  @override
  String get privacy_policy_title =>
      'Política de Privacidad de Lianlian Shiguang';

  @override
  String get privacy_policy_date => 'Última actualización: 10 de abril de 2026';

  @override
  String get privacy_policy_body =>
      'Política de Privacidad de \"Lianlian Shiguang\"\nÚltima actualización: 10 de abril de 2026\n\nBienvenido a \"Lianlian Shiguang\" (en adelante, \"el Servicio\"). Valoramos profundamente su privacidad. Esta política explica cómo recopilamos, usamos y protegemos su información personal.\n\n1. Información de la cuenta:\nInicio de sesión de terceros: Al iniciar sesión a través de Google, Facebook o Apple, recopilamos su Firebase UID, correo electrónico y apodo público.\nRegistro por correo electrónico: Recopilamos su dirección de correo electrónico. Su contraseña se gestiona mediante el cifrado de Firebase; el equipo de desarrollo no puede acceder a su contraseña original.\n\nDatos de interacción: Para que los personajes de IA tengan memoria continua, almacenamos sus registros de conversación y el contenido que escribe para los personajes.\n\nInformación del dispositivo: Incluye el modelo del dispositivo, versión del SO e identificador único para la optimización del sistema.\n\n2. Uso de la información:\nMejora de la IA: Optimizamos la calidad de las respuestas y la coherencia de la personalidad.\nOperaciones del servicio: Procesamiento de recargas de puntos y verificación de identidad.\nSeguridad: Monitoreo de comportamientos maliciosos.\n\n3. Cooperación técnica:\nEl servicio utiliza Google Cloud / Firebase para almacenamiento y OpenRouter / xAI / Meta para lógica de IA.\nNota: No vendemos sus registros de conversación a anunciantes.\n\n4. Almacenamiento y eliminación:\nSus datos se almacenan de forma segura en la nube. Puede solicitar la eliminación permanente de su cuenta en cualquier momento.';

  @override
  String get terms_title => 'Términos de Servicio de Lianlian Shiguang';

  @override
  String get terms_date => 'Última actualización: 10 de abril de 2026';

  @override
  String get terms_body =>
      'Términos de Servicio de \"Lianlian Shiguang\"\nÚltima actualización: 10 de abril de 2026\n\nLea atentamente estos términos antes de usar el Servicio. El uso del mismo implica su aceptación:\n\n1. Naturaleza del servicio:\nInteracción no humana: Todas las respuestas son generadas por IA y no representan la opinión de los creadores.\nRiesgos narrativos: La IA puede generar contenido ficticio o inexacto.\n\n2. Puntos virtuales:\nNaturaleza: Los puntos son bienes virtuales y no son reembolsables una vez consumidos.\nCostos: Los estándares de consumo varían según los costos operativos de la IA.\n\n3. Conducta del usuario:\nProhibiciones: No generar contenido violento o ilegal. No realizar ingeniería inversa al sistema.\n\n4. Propiedad intelectual:\nContenido original: Los nombres de personajes (como Cheng An), tramas y lógica pertenecen al equipo de desarrollo.\nIA y Terceros: Las imágenes de IA tienen licencia comercial. Los iconos pertenecen a sus respectivos proveedores (Google, Apple).\n\n5. Terminación:\nEl incumplimiento de estas normas puede resultar en la suspensión de la cuenta sin previo aviso.';

  @override
  String get login_required => 'Por favor, inicia sesión primero';

  @override
  String get cloud_character_mgmt => 'Gestión de personajes en la nube';

  @override
  String get connection_error => 'Error de conexión';

  @override
  String get no_characters_met => '¡Aún no has conocido a ningún personaje!';

  @override
  String get status_paused => 'Estado: Contacto pausado';

  @override
  String get status_in_progress => 'Estado: En progreso';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get block => 'Bloquear';

  @override
  String get confirm_block_title => '¿Confirmar bloqueo?';

  @override
  String confirm_block_msg(Object charName) {
    return 'Tras el bloqueo, no recibirás mensajes de $charName por ahora.';
  }

  @override
  String get think_again => 'Pensarlo mejor';

  @override
  String get confirm_block_btn => 'Confirmar bloqueo';

  @override
  String get no_char_info =>
      'Sin información detallada de este personaje aún...';

  @override
  String get private_mailbox => 'Buzón privado';

  @override
  String get user_info_not_found => 'Información de usuario no encontrada';

  @override
  String get load_failed => 'Error al cargar, inténtalo de nuevo';

  @override
  String get empty_mailbox => 'El buzón está vacío~';

  @override
  String get system_notification => 'Notificación del sistema';

  @override
  String get interaction_records => 'Historial de interacción';

  @override
  String get liked_content => 'Contenido que te gusta';

  @override
  String get my_favorites => 'Mis favoritos';

  @override
  String get login_to_view_records => 'Inicia sesión para ver el historial';

  @override
  String get no_likes_yet => '¡Aún no te ha gustado ninguna publicación!';

  @override
  String get empty_favorites =>
      'Tu carpeta de favoritos está vacía, ¡ve al vestíbulo!';

  @override
  String get theme_sakura_pink => 'Rosa Sakura';

  @override
  String get theme_ocean_blue => 'Azul Océano';

  @override
  String get theme_sunset_orange => 'Naranja Atardecer';

  @override
  String get theme_mint_forest => 'Bosque de Menta';

  @override
  String get theme_midnight => 'Modo Medianoche';

  @override
  String get change_atmosphere => 'Cambiar ambiente';

  @override
  String get custom_color => 'Color personalizado';

  @override
  String get custom_color_desc => 'Crea tu propio color de ambiente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';
}
