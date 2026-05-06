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
  String block_warning_msg(String charName) {
    return 'Después de bloquear, temporalmente no recibirás mensajes de $charName.';
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

  @override
  String get confirm_delete_title => 'Confirmar eliminación';

  @override
  String get confirm_delete_memory_msg =>
      '¿Estás segura de que quieres que olvide esto? Esta acción no se puede deshacer.';

  @override
  String get delete_btn => 'Eliminar';

  @override
  String get memory_erased_msg => 'Esta memoria ha sido borrada.';

  @override
  String get delete_failed_msg => 'Error al eliminar';

  @override
  String get edit_memory_title => 'Editar recuerdo';

  @override
  String get modify_memory_hint => 'Modificar esta memoria...';

  @override
  String get memory_re_recorded_msg => 'Memoria registrada de nuevo';

  @override
  String get update_failed_msg => 'Error al actualizar';

  @override
  String get update_favorite_failed_msg =>
      'Error al actualizar el estado de favoritos';

  @override
  String char_notebook_title(String charName) {
    return 'Cuaderno de $charName';
  }

  @override
  String get error_loading_memory => 'Error al cargar la memoria';

  @override
  String get empty_notebook_msg =>
      'El cuaderno está vacío...\n¡Ve a chatear para que pueda escribir todo sobre ti!';

  @override
  String get date_format_text => 'd MMM yyyy';

  @override
  String get remove_special_focus => 'Quitar enfoque especial';

  @override
  String get mark_special_focus => 'Marcar como enfoque especial';

  @override
  String get edit_btn => 'Editar';

  @override
  String get load_gallery_failed => 'Error al cargar la galería';

  @override
  String get traditional_chinese => 'Chino tradicional';

  @override
  String get all => 'Todo';

  @override
  String get official_recommendation => 'Recomendación oficial';

  @override
  String get my_exclusive => 'Mi exclusivo';

  @override
  String encounter_count(int count) {
    return '$count encuentros';
  }

  @override
  String get official => 'Oficial';

  @override
  String get private => 'Privado';

  @override
  String get first_encounter => 'Primer encuentro';

  @override
  String char_exclusive_memory(String charName) {
    return 'Recuerdo exclusivo de $charName';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return '¡El afecto debe llegar a $affectionLevel para desbloquear este recuerdo!';
  }

  @override
  String get affection => 'Afecto';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get change_chat_bg => 'Cambiar fondo del chat';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return '¿Establecer \"$cgDesc\" como fondo del chat con $charName?';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return 'Fondo cambiado a \"$cgDesc\"';
  }

  @override
  String get confirm_change => 'Confirmar cambio';

  @override
  String get empty_treasure_box =>
      'La caja del tesoro está vacía...\n¡Ve a chatear para encontrar huevos de pascua ocultos!';

  @override
  String get unknown_story => 'Historia desconocida';

  @override
  String get open_this_memory => 'Abrir este recuerdo';

  @override
  String get open_exclusive_story => 'Abrir historia exclusiva';

  @override
  String confirm_use_egg(String eggTitle) {
    return '¿Experimentar \"$eggTitle\" ahora?\n\n(Este artículo es de un solo uso e ingresará automáticamente a la historia después de usarlo)';
  }

  @override
  String get wait_a_bit => 'Espera un poco';

  @override
  String guiding_into_story(String eggTitle) {
    return 'Guiando a la historia...';
  }

  @override
  String get use_now => 'Usar ahora';

  @override
  String playback_failed_status(String statusCode) {
    return 'Error de reproducción, código: $statusCode';
  }

  @override
  String get playback_error => 'Ocurrió un error de reproducción';

  @override
  String get unknown_contact => 'Contacto desconocido';

  @override
  String call_memory_with(String charName) {
    return 'Recuerdo de llamada con $charName';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return 'Se desbloquea con afecto $affection';
  }

  @override
  String get no_call_record =>
      'Parece que no hay registro de conversación para esta llamada...';

  @override
  String get me => 'Yo';

  @override
  String get playing => 'Reproduciendo...';

  @override
  String get listen => 'Escuchar';

  @override
  String get no_exclusive_voice =>
      '¡Este personaje aún no tiene una voz exclusiva!';

  @override
  String get voice_download_success =>
      '✅ Datos de voz descargados con éxito, preparándose para reproducir...';

  @override
  String get onboarding_invitation => '— Invitación del Tiempo —';

  @override
  String get onboarding_welcome => 'Bienvenida a Lian Lian Shi Guang';

  @override
  String get onboarding_quote =>
      '\"Todo encuentro es un reencuentro después de una larga separación.\"';

  @override
  String get onboarding_gift_title => 'Regalo de primer encuentro: 50 Flores';

  @override
  String get onboarding_gift_subtitle =>
      'Estas flores te acompañarán al iniciar tu historia con él.';

  @override
  String get onboarding_start_button => 'Comienza tu viaje en el tiempo';

  @override
  String get onboarding_more_info => 'Descubre más sobre la historia';

  @override
  String get legal_agreement_prefix => 'Al continuar, aceptas nuestros';

  @override
  String get legal_terms_button => 'Términos de servicio';

  @override
  String get legal_and => ' y la ';

  @override
  String get legal_privacy_button => 'Política de privacidad';

  @override
  String get call_memory_title => 'Recuerdos de Llamadas';

  @override
  String get please_login_first => 'Por favor, inicia sesión primero';

  @override
  String get no_call_memories =>
      'Aún no hay recuerdos de llamadas guardados.\nSe pueden guardar un máximo de 10 registros.';

  @override
  String call_with_name(String name) {
    return 'Llamada con $name';
  }

  @override
  String call_duration(String time) {
    return 'Duración: $time';
  }

  @override
  String get delete_call_title => 'Eliminar Registro';

  @override
  String delete_call_confirm(String name) {
    return '¿Estás segura de que quieres eliminar este recuerdo con $name?\n(No se puede deshacer)';
  }

  @override
  String get keep_it => 'Mantener';

  @override
  String get confirm_delete => 'Eliminar';

  @override
  String get press_mic_to_speak =>
      'Presiona el micrófono para empezar a hablar...';

  @override
  String get call_ended => 'Llamada finalizada';

  @override
  String character_thinking(String name) {
    return '($name está pensando...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name está contestando...)';
  }

  @override
  String get call_interrupted_login =>
      '(Llamada interrumpida) Por favor, inicia sesión primero...';

  @override
  String get silence => '(Silencio)';

  @override
  String get bad_signal => '(Mala señal...)';

  @override
  String get static_noise => '(Estática)... no se oye bien...';

  @override
  String get type_message_hint => 'Escribe un mensaje...';

  @override
  String get draft_saved_success =>
      '¡Borrador guardado con éxito en el Estudio Secreto!';

  @override
  String get draft_save_failed =>
      'Error al guardar, inténtalo de nuevo más tarde';

  @override
  String get draft_save_title => '¿Quieres guardar el borrador?';

  @override
  String get draft_save_content =>
      'Tu trabajo aún no se ha publicado, ¿quieres guardarlo en el Estudio Secreto primero?';

  @override
  String get not_save => 'No guardar';

  @override
  String get save_draft => 'Guardar borrador';

  @override
  String confirm_delete_char_content(String name) {
    return '¿Estás seguro de que quieres eliminar al personaje \"$name\"?\n\n¡Esta acción no se puede deshacer!';
  }

  @override
  String get char_deleted => 'Personaje eliminado';

  @override
  String get ok_button => '¡Vale!';

  @override
  String get cannot_save_title => 'No se puede guardar';

  @override
  String get cannot_save_content =>
      '¡Por favor, escribe el nombre del personaje y sube al menos un avatar!';

  @override
  String get word_count_exceeded => 'Demasiadas palabras';

  @override
  String word_count_error_detail(String field, int limit) {
    return 'El campo \"$field\" supera el límite de $limit palabras, por favor redúcelo antes de guardar.';
  }

  @override
  String get content_missing => 'Falta contenido';

  @override
  String get content_missing_personality =>
      '¡Por favor, completa la \"Personalidad detallada\"! Escribe al menos 10 palabras.';

  @override
  String get content_missing_bg =>
      '¡La \"Introducción del personaje\" es demasiado corta! Escribe al menos 20 palabras para explicar el contexto.';

  @override
  String get content_missing_tone =>
      '¡Configura el \"Tono y hábitos\" para evitar que el personaje se comporte de forma inconsistente (OOC)!';

  @override
  String get user_not_found => 'Error: Usuario no encontrado';

  @override
  String char_saved_success(String name, String action) {
    return '¡El personaje \"$name\" ha sido $action!';
  }

  @override
  String save_error_detail(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get easter_egg_add_title => 'Añadir huevo de pascua oculto';

  @override
  String get easter_egg_edit_title => 'Editar huevo de pascua';

  @override
  String get keyword_label => 'Palabra clave de activación (obligatorio)';

  @override
  String get keyword_hint =>
      'Ej.: ir al parque de atracciones, pastel de fresa';

  @override
  String get egg_title_label => 'Título del huevo de pascua (para jugadores)';

  @override
  String get egg_title_hint => 'Ej.: Cita de fin de semana';

  @override
  String get egg_teaser_label => 'Breve adelanto (para jugadores)';

  @override
  String get egg_teaser_hint => 'Describe cómo comienza la escena...';

  @override
  String get egg_scene_label => 'Cambio de escena forzado (opcional)';

  @override
  String get egg_scene_hint => 'Ej.: Parque de atracciones, Casa del terror';

  @override
  String get egg_prompt_label => 'Instrucción de guion';

  @override
  String get egg_prompt_hint =>
      'Cómo actuar en esta trama.\n(Sistema: La escena cambia al parque de atracciones, el personaje mira a (Nombre del jugador) y sonríe...)';

  @override
  String get confirm_button => 'Confirmar';

  @override
  String get keyword_empty_error => 'La palabra clave no puede estar vacía';

  @override
  String get voice_custom_title => 'Personalizar voz exclusiva';

  @override
  String get voice_custom_hint => 'Ej.: CEO autoritario, perrito tierno...';

  @override
  String get voice_generate_start => 'Empezar a generar';

  @override
  String get voice_bind_first =>
      '¡Por favor, selecciona y \"vincula\" una voz exclusiva primero!';

  @override
  String get voice_test_failed =>
      'Error en la prueba: ¡Haz clic en \"¡Te elijo a ti!\" para vincular la voz formalmente antes de ajustarla!';

  @override
  String voice_name_default(String name) {
    return 'Voz exclusiva de $name';
  }

  @override
  String get voice_description_default =>
      'Esta es una voz única creada para un personaje exclusivo en \"Lian Lian Shi Guang\", seleccionada y generada por el jugador.';

  @override
  String get voice_bind_failed =>
      'Error al vincular la voz, comprueba la cuota de la API o el estado de la red';

  @override
  String voice_bind_success(String name) {
    return '¡La voz del alma de \"$name\" ha sido vinculada formalmente!';
  }

  @override
  String get voice_bind_success_draft =>
      '¡Voz vinculada con éxito! ¡Ahora puedes mover la barra para probar las emociones!';

  @override
  String sync_failed(String error) {
    return 'Error de sincronización, comprueba la red: $error';
  }

  @override
  String edit_character_title(String name) {
    return 'Editar $name';
  }

  @override
  String get test_mode_tooltip => 'Prueba de funciones completa';

  @override
  String get test_mode_error =>
      '⚠️ ¡No se encuentra el archivo del personaje! Haz clic en \"Guardar/Publicar\" al final antes de probarlo.';

  @override
  String get test_mode_notice =>
      '💡 El modo de prueba consumirá puntos según el precio original de cada modo y no contará para los recuerdos formales.';

  @override
  String get delete_character_tooltip => 'Eliminar personaje';

  @override
  String get tab_basic_story => 'Básico y trama';

  @override
  String get tab_voice => 'Voz exclusiva';

  @override
  String get tab_relationship => 'Relaciones sociales';

  @override
  String get save_changes_button => 'Guardar cambios';

  @override
  String get section_basic_info => 'Información básica';

  @override
  String get hint_occupation =>
      'Soporta múltiples identidades, usa barras o comas (ej.: Estudiante/Hacker)';

  @override
  String get hint_appearance =>
      'Ej.: Pelo largo plateado, ojos ambarinos, siempre lleva bata blanca...';

  @override
  String get section_story_identity => '🎭 Trama y tu identidad';

  @override
  String get story_identity_desc =>
      'Define el inicio de la historia y tu configuración especial en este archivo';

  @override
  String get advanced_writing_tips_title =>
      '💡 Consejos de escritura avanzada:\n';

  @override
  String get advanced_writing_tips_1 => 'En la historia o diálogos escribe ';

  @override
  String get advanced_writing_tips_2 => '(Nombre del jugador)';

  @override
  String get advanced_writing_tips_3 =>
      ', ¡el sistema lo reemplazará automáticamente por tu apodo real al jugar!\n';

  @override
  String get advanced_writing_tips_4 => 'Ejemplo: \"';

  @override
  String get advanced_writing_tips_5 => '(Nombre del jugador)';

  @override
  String get advanced_writing_tips_6 => ', ¿por qué llegas tan tarde?\"';

  @override
  String get player_identity_label =>
      'Identidad predeterminada del jugador (Player Identity) - 💡 Opcional';

  @override
  String get player_identity_hint =>
      '【Opcional】Si se deja vacío, la IA leerá tu \"Perfil\" para interactuar.\nSi se rellena, forzará una identidad específica (ej.: su sistema frío, o una esposa traicionada).';

  @override
  String get background_label => 'Trasfondo y mundo del personaje';

  @override
  String get background_hint =>
      'Describe su pasado y el mundo (ej.: ciudad moderna, ABO, apocalipsis). Ej.: Es un mundo infestado de zombis y él es un soldado de élite que te protege...';

  @override
  String get story_summary_label => 'Resumen de la historia en una frase';

  @override
  String get story_initial_label => 'Historia del encuentro inicial';

  @override
  String get story_initial_hint =>
      'Ej.: Abres la puerta y lo ves sentado junto a la ventana. Se gira y dice: \"(Nombre del jugador), ven aquí.\"';

  @override
  String get first_line_label => 'Primera frase del personaje';

  @override
  String get first_line_hint =>
      'Ej.: (Nombre del jugador), por fin has llegado.';

  @override
  String get section_personality_evo => '🌟 Evolución de personalidad y afecto';

  @override
  String get detailed_personality_label => 'Personalidad detallada';

  @override
  String get detailed_personality_hint =>
      'Describe su personalidad central. Ej.: Tsundere, duro por fuera y tierno por dentro. Frío con extraños, solo sonríe para el jugador.';

  @override
  String get affection_evo_desc =>
      'La IA determinará cuándo aumenta el afecto según esta configuración:';

  @override
  String get stage_1_label => 'Etapa 1: Desconocido/Alerta (Lv1)';

  @override
  String get stage_1_hint =>
      'Reacción al conocerse. Condiciones de afecto (ej.: cortesía, no husmear en su privacidad).';

  @override
  String get stage_2_label => 'Etapa 2: Conocido/Amigo (Lv2)';

  @override
  String get stage_2_hint =>
      'Cambios tras conocerse mejor. Condiciones de afecto (ej.: compartir dulces, hablar de gatos).';

  @override
  String get stage_3_label => 'Etapa 3: Íntimo/Amante (Lv3)';

  @override
  String get stage_3_hint =>
      'Reacción tras enamorarse por completo. ¿Tendrá celos? ¿Se enfadará en silencio?';

  @override
  String get social_interaction_label => 'Interacción social y ambiental';

  @override
  String get social_interaction_hint =>
      'Ej.: ¿Cómo trata a los extraños? ¿Cómo reacciona ante lo que detesta?';

  @override
  String get section_habits => '🗣️ Gustos y hábitos';

  @override
  String get tone_hint_detail =>
      'Obligatorio. Ej.: Habla poco, le gusta preguntar. Su coletilla es \"tonto\". No usar lenguaje de traducción automática.';

  @override
  String get dialogue_example_hint =>
      'Jugador: Estoy muy cansado.\nPersonaje: (Acaricia la cabeza) Sé bueno, ve a descansar pronto.';

  @override
  String get section_easter_eggs => '🎁 Huevos de pascua y tramas especiales';

  @override
  String get no_easter_eggs =>
      'No hay huevos de pascua configurados, haz clic abajo para añadir uno';

  @override
  String get no_scene_change => 'Sin cambio de escena';

  @override
  String get add_easter_egg_button => 'Añadir huevo de pascua oculto';

  @override
  String get other_extra_info => 'Otra información complementaria';

  @override
  String get visibility_label => 'Visibilidad del personaje';

  @override
  String get visibility_public => 'Público';

  @override
  String get visibility_private => 'Privado';

  @override
  String get section_voice_gen => '🎙️ Generación de voz exclusiva';

  @override
  String get voice_gen_desc =>
      '¡Escribe palabras clave para que tenga una voz única en el mundo!\n(💡 Recordatorio: si no te gusta el resultado, ¡puedes personalizarla de nuevo cuando quieras!)';

  @override
  String get voice_generating_status => 'Ajustando la voz...';

  @override
  String get voice_select_prompt =>
      '✨ He preparado tres tipos de voz, elige una:';

  @override
  String voice_sample_name(int index) {
    return 'Muestra de voz $index';
  }

  @override
  String get voice_sample_desc =>
      'Haz clic en la tarjeta para elegir, haz clic a la derecha para probar';

  @override
  String get voice_preparing => 'La voz aún se está preparando...';

  @override
  String get voice_retry => 'Descartar y reintentar';

  @override
  String get voice_confirm_selection => '¡Te elijo a ti!';

  @override
  String get voice_bind_success_banner => '¡Voz exclusiva vinculada con éxito!';

  @override
  String get voice_remake => 'Rehacer voz';

  @override
  String get voice_btn_generating => 'Generando, espera por favor...';

  @override
  String get voice_btn_generate => 'Escribe palabras clave para generar voz';

  @override
  String get voice_advanced_tuning =>
      '🎛️ Avanzado: Ajustar emociones al hablar';

  @override
  String get voice_stability_low => 'Salvaje/Susurro 🐺';

  @override
  String voice_stability_value(String value) {
    return 'Racionalidad: $value';
  }

  @override
  String get voice_stability_high => 'Estable/Calma 🤖';

  @override
  String get voice_style_low => 'Distante/Reprimido 🧊';

  @override
  String voice_style_value(String value) {
    return 'Expresión dramática: $value';
  }

  @override
  String get voice_style_high => 'Exagerado/Apasionado 🔥';

  @override
  String get voice_test_btn_testing => 'Aplicando emoción...';

  @override
  String get voice_test_btn => 'Probar emoción actual';

  @override
  String get section_social_circle => '👥 Su círculo social';

  @override
  String get social_circle_desc =>
      'Configura su opinión sobre otros personajes. Cuando el jugador mencione a alguien en el chat, reaccionará según esto (ej.: celos, enfado).';

  @override
  String get social_no_drama =>
      'De momento no hay conflictos con otros galanes...';

  @override
  String social_target(String name) {
    return 'Objetivo: $name';
  }

  @override
  String social_attitude(String attitude) {
    return 'Opinión: $attitude';
  }

  @override
  String social_edit_title(String name) {
    return 'Editar opinión sobre $name 💬';
  }

  @override
  String get social_attitude_label => 'Su opinión / Actitud';

  @override
  String get social_attitude_hint =>
      'Ej.: Cree que es un pesado, pero en el fondo confía en él...';

  @override
  String get social_save_changes => 'Guardar cambios';

  @override
  String get social_add_title => 'Añadir relación entre personajes 🤝';

  @override
  String get social_select_target => 'Elegir objetivo';

  @override
  String get social_thoughts_label => 'Lo que piensa de esta persona...';

  @override
  String get social_thoughts_hint =>
      'Ej.: Ese pianista hace demasiado ruido...';

  @override
  String get social_add_confirm => 'Confirmar';

  @override
  String get gallery_load_failed =>
      'Error al cargar imágenes 🥲\nComprueba la red; si es Web, mira la consola.';

  @override
  String gallery_affection_req(int level) {
    return 'Afecto $level';
  }

  @override
  String get gallery_upload_limit => 'Máximo 10 imágenes';

  @override
  String get gallery_photo_setup => 'Condiciones para desbloquear foto';

  @override
  String get gallery_photo_desc_label => '¿Qué es esta foto?';

  @override
  String get gallery_photo_desc_hint => 'Ej.: Foto en pijama, foto de cita';

  @override
  String get gallery_photo_req_label => '¿Cuánto afecto requiere?';

  @override
  String get gallery_photo_req_hint => 'Escribe un número, 0 es gratis';

  @override
  String get gallery_cancel_upload => 'Cancelar';

  @override
  String get gallery_confirm_add => 'Confirmar';

  @override
  String get default_photo_desc => 'Foto exclusiva';

  @override
  String get draft_photo_desc => 'Foto borrador';

  @override
  String get loading_text => 'Cargando...';

  @override
  String get default_unnamed_character => 'Personaje sin nombre';

  @override
  String elevenlabs_error(String code) {
    return 'Error de ElevenLabs: $code';
  }

  @override
  String get voice_sample_script =>
      '(Se aclara la garganta) Hola. Esta es una prueba de voz exclusiva para mí. En los días venideros, estaré aquí contigo. Ya sea que estés feliz o triste, puedes compartirlo conmigo. ¿Te resulta cómodo este ritmo y tono? Si te gusta, fijemos esta voz como mi voz exclusiva para chatear contigo. Espero con ansias cada uno de nuestros días futuros.';

  @override
  String get voice_test_script =>
      '¿Qué te parece mi tono de voz ahora? Si te gusta, fijémoslo así.';

  @override
  String get field_background => 'Trasfondo del personaje';

  @override
  String get field_tone => 'Tono y hábitos';

  @override
  String get field_initial_story => 'Historia inicial';

  @override
  String get update_action => 'Actualizar';

  @override
  String get default_new_player => 'Nuevo jugador';

  @override
  String get translating_status => 'Traduciendo...';

  @override
  String get translate_profile_btn => 'Traducir contenido del perfil';

  @override
  String translate_failed(String error) {
    return 'Error en la traducción: $error';
  }

  @override
  String get like_own_char_warning =>
      '¡No puedes darle me gusta a un personaje que tú mismo creaste! 🤭';

  @override
  String get like_success_msg =>
      '¡Me gusta enviado! El creador se alegrará mucho 💖';

  @override
  String get unlike_success_msg => 'Me gusta retirado 💔';

  @override
  String get like_label => 'Me gusta';

  @override
  String get dislike_label => 'No me gusta';

  @override
  String get block_char => 'Bloquear este personaje';

  @override
  String get char_blocked_msg => 'Este personaje ha sido bloqueado.';

  @override
  String get dislike_dialog_title => '¿No te gusta este personaje?';

  @override
  String get dislike_dialog_subtitle =>
      'Cuéntanos el motivo en privado; lo revisaremos:';

  @override
  String get dislike_hint => 'Configuración aburrida, imágenes inapropiadas...';

  @override
  String get dislike_thanks =>
      '¡Gracias por tus comentarios! Hemos recibido tu mensaje privado.';

  @override
  String get dislike_submit => 'Enviar en secreto';

  @override
  String get report_title => '📢 Reportar comentario';

  @override
  String get report_subtitle =>
      'Elige el motivo del reporte:\nRevisaremos el contenido lo antes posible.';

  @override
  String get report_opt_1 => 'Contenido pornográfico o de violencia gráfica';

  @override
  String get report_opt_2 => 'Difamación, insultos o ataques al personaje';

  @override
  String get report_opt_3 => 'Discurso de odio o ataques personales';

  @override
  String get report_opt_4 => 'Spam o fraude publicitario';

  @override
  String get report_opt_5 => 'Otro contenido inapropiado';

  @override
  String get report_confirm => 'Confirmar reporte';

  @override
  String get report_success =>
      '¡Reportado con éxito, notificación recibida! Revisaremos el contenido pronto 🛡️';

  @override
  String get report_failed =>
      'Error al reportar, por favor comprueba tu conexión.';

  @override
  String get lore_delete_title => '⚠️ Advertencia: Borrar memoria';

  @override
  String get lore_delete_content =>
      'Una vez borrada, esta memoria desaparecerá por completo. ¿Estás seguro de borrarla?';

  @override
  String get lore_delete_cancel => 'Me equivoqué';

  @override
  String get lore_delete_confirm => 'Confirmar borrado';

  @override
  String get lore_delete_success =>
      '🗑️ Fragmento de memoria borrado por completo.';

  @override
  String get lore_add_title => 'Escribir nueva memoria 🖋️';

  @override
  String get lore_edit_title => 'Editar fragmento de memoria 🖋️';

  @override
  String get lore_title_label => 'Título de la memoria';

  @override
  String get lore_title_hint => 'Ej.: El día lluvioso del primer encuentro';

  @override
  String get lore_teaser_label => 'Resumen / Introducción';

  @override
  String get lore_teaser_hint =>
      'Breve descripción que aparece en la tarjeta...';

  @override
  String get lore_content_label => 'Contenido completo de la memoria';

  @override
  String get lore_content_hint =>
      'Escribe aquí la historia detallada o configuración...';

  @override
  String get lore_lock_label => '🔒 Sellar esta memoria';

  @override
  String get lore_lock_desc =>
      'Si se marca, solo el creador podrá verla; los jugadores no tendrán acceso';

  @override
  String get lore_empty_error =>
      '¡El título y el contenido no pueden estar vacíos!';

  @override
  String get lore_add_success => '✨ ¡Nueva memoria sellada con éxito!';

  @override
  String get lore_publish => 'Publicar memoria';

  @override
  String get lore_save_edit => 'Guardar cambios';

  @override
  String lore_write_first(Object pronoun) {
    return '¡Escribe el primer recuerdo de $pronoun!';
  }

  @override
  String lore_waiting(Object pronoun) {
    return 'Esperando la historia con $pronoun...';
  }

  @override
  String get lore_sealed_msg =>
      '🔒 Esta memoria está sellada y no está disponible actualmente.';

  @override
  String get lore_not_open_msg =>
      'Esta memoria aún no está abierta al público...';

  @override
  String get lore_unnamed => 'Fragmento sin nombre';

  @override
  String get lore_add_btn_limit =>
      'Escribir nuevo fragmento de memoria (límite de 10)';

  @override
  String get lore_collapse => 'Cerrar carta';

  @override
  String get echo_delete_title => '🗑️ Eliminar comentario';

  @override
  String get echo_delete_content =>
      '¿Seguro que quieres borrar este Eco Temporal?\n¡No se podrá recuperar!';

  @override
  String get echo_keep => 'Mantener';

  @override
  String get echo_clear_success => 'Eco temporal eliminado 🧹';

  @override
  String get echo_energy_full_title => '⚠️ Energía cósmica al límite';

  @override
  String get echo_energy_full_content =>
      'Tu energía temporal ha llegado al límite (máx. 3). ¡Borra experiencias antiguas para abrir nuevos registros cósmicos!';

  @override
  String get echo_write_title => 'Deja tu Eco Temporal 🌌';

  @override
  String get echo_write_subtitle =>
      '¡Escribe tu experiencia o frases memorables aquí!';

  @override
  String get echo_hint =>
      '「Incluso si es el fin del mundo, priorizaré tu respiración...」';

  @override
  String get echo_theme_label => 'Elige el borde de la nota:';

  @override
  String get theme_butterfly => 'Mariposa';

  @override
  String get theme_sprout => 'Brote';

  @override
  String get theme_star => 'Cielo estrellado';

  @override
  String get theme_planet => 'Planeta';

  @override
  String get echo_publish_btn => 'Publicar registro temporal';

  @override
  String get echo_wall_title => 'Muro de Ecos Temporales';

  @override
  String get echo_leave_memory => 'Dejar experiencia';

  @override
  String get echo_empty_msg =>
      'Ningún viajero temporal ha dejado su registro aún...\n¿Quieres ser el primero?';

  @override
  String get creator_label => 'Creador';

  @override
  String get follow_btn => 'Seguir';

  @override
  String get followed_btn => 'Siguiendo';

  @override
  String get follow_own_warning =>
      '¡Los creadores no pueden seguirse a sí mismos! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ ¡$playerName ha seguido a $creatorName!';
  }

  @override
  String get mailbox_follow_title => 'Nuevo guardián obtenido 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '¡$playerName acaba de seguirte!';
  }

  @override
  String get tab_private_profile => 'Perfil privado';

  @override
  String get tab_memory_fragments => 'Fragmentos de memoria';

  @override
  String get tab_time_echoes => 'Ecos temporales';

  @override
  String get chat_free_btn => 'Chat (Gratis)';

  @override
  String get start_story_btn => 'Empezar historia';

  @override
  String get default_chat_initial => '¿Necesitas algo de mí?';

  @override
  String get gallery_title => 'Fondo de llamada exclusivo';

  @override
  String gallery_current_affection(String value) {
    return 'Nivel de afecto actual: $value 💕';
  }

  @override
  String get gallery_empty => 'Aún no hay fotos en la galería';

  @override
  String gallery_unlocked_msg(String desc) {
    return '¡Fondo establecido en «$desc»!';
  }

  @override
  String gallery_lock_msg(String value) {
    return '¡Alcanza el nivel de afecto $value para desbloquear! 🍃';
  }

  @override
  String get gallery_reset_bg => 'Fondo de llamada predeterminado restaurado';

  @override
  String get background_story_title => 'Historia de trasfondo';

  @override
  String get background_story_empty =>
      'Este personaje es misterioso; no hay historia de trasfondo aún...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'Has seguido a $creatorName 🦋';
  }

  @override
  String get mailbox_title => 'Buzón exclusivo 💌';

  @override
  String get mailbox_empty =>
      'El buzón está vacío. ¡Ve a publicar algo para atraerlo!';

  @override
  String get new_notification => 'Nueva notificación';

  @override
  String get default_he => 'Él';

  @override
  String affection_upgrade_title(String charName) {
    return '¡El afecto de $charName por ti ha aumentado! 💖';
  }

  @override
  String get flower_reward => '🌸 Has obtenido 5 puntos de flores';

  @override
  String get affection_quote_lv5 =>
      '«No esperaba... que te volvieras tan importante para mí. Tan importante que... no puedo imaginar un mundo sin ti».';

  @override
  String get affection_quote_lv4 =>
      '«Lo más afortunado de mi vida fue, probablemente, ese día en que miré atrás y te vi».';

  @override
  String get affection_quote_lv3 =>
      '«Últimamente... me he dado cuenta de que me quedo distraído más a menudo, y mi cabeza está llena de ti».';

  @override
  String get affection_quote_lv2 =>
      '«Ya que es tu invitación, supongo que podría sacar algo de tiempo, no es imposible».';

  @override
  String get affection_quote_lv1 =>
      '«Te he visto mucho últimamente, y siento que... no me molesta que nos veamos tan seguido».';

  @override
  String get affection_quote_lv0 =>
      '«Así que tú también estás aquí. ¿Es esto algún tipo de destino curioso?».';

  @override
  String get lore_edit_success =>
      '✨ ¡Fragmento de memoria actualizado con éxito!';

  @override
  String get delete_failed_network =>
      'Error al eliminar, por favor comprueba la red o los permisos.';

  @override
  String get ai_chat_language => 'Español';

  @override
  String get ai_chat_language_code => 'es-ES';

  @override
  String get chat_home_title => 'Mensajes';

  @override
  String get call_memory_tooltip => 'Recuerdos de llamadas';

  @override
  String get login_to_view_chat =>
      'Inicia sesión para ver el historial de chat';

  @override
  String load_chat_failed(String error) {
    return 'Error al cargar la lista de chats: $error';
  }

  @override
  String get chat_list_empty => 'La sala de chat está vacía...';

  @override
  String get go_to_encounter =>
      '¡Ve a \"Encuentro\" y busca a alguien con quien hablar!';

  @override
  String confirm_delete_chat(String charName) {
    return '¿Estás seguro de que quieres borrar la conversación con $charName?';
  }

  @override
  String affection_score_short(String score) {
    return 'Afecto $score';
  }

  @override
  String get character_not_found =>
      'No se pudo cargar la información del personaje; puede que haya sido eliminado.';

  @override
  String get preparing_chat_room => 'Preparando tu sala de chat exclusiva...';

  @override
  String get rename_chat_title => 'Nombra este recuerdo';

  @override
  String get rename_chat_hint =>
      'Ej.: Cambiar (Cheng Yu) por (Cuenta atrás del divorcio)';

  @override
  String get save_tag_btn => 'Guardar etiqueta';

  @override
  String get room_name_updated => '¡Nombre de la sala actualizado!';

  @override
  String update_failed(String error) {
    return 'Error en la actualización: $error';
  }

  @override
  String get chat_mode_daily => 'Diario';

  @override
  String get chat_mode_story => 'Historia';

  @override
  String get chat_mode_immersive => 'Inmersivo';

  @override
  String get chat_mode_gemini => 'Charla';

  @override
  String get lang_zh => '繁體中文';

  @override
  String get lang_ja => '日本語';

  @override
  String get lang_ko => '한국어';

  @override
  String get lang_en => 'English';

  @override
  String get lang_vi => 'Tiếng Việt';

  @override
  String get chat_load_char_failed =>
      'No se encontraron los datos del personaje. Regresa e inténtalo de nuevo o comprueba tu conexión.';

  @override
  String get chat_jump_success => 'Saltó a este recuerdo 🍃';

  @override
  String get chat_create_room_failed =>
      'La conexión parece inestable. Error al crear la sala de chat, inténtalo de nuevo.';

  @override
  String get chat_secret_file_title => '🔒 Archivo confidencial';

  @override
  String get chat_secret_file_desc =>
      'El archivo del alma de este personaje ha sido archivado o configurado como privado. La información detallada no está disponible temporalmente.';

  @override
  String get chat_understood => 'Entendido';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ Nuevo recuerdo obtenido: $title';
  }

  @override
  String get chat_egg_saved =>
      'Se ha añadido automáticamente a tu mochila exclusiva';

  @override
  String get chat_points_not_enough_title => 'Flores insuficientes';

  @override
  String get chat_points_not_enough_desc =>
      '¡No tienes suficientes Flores! Por favor, ve a la tienda para recargar.';

  @override
  String chat_call_confirm_title(String name) {
    return '¿Llamar a $name?';
  }

  @override
  String get chat_call_rule_1 => 'Cada llamada consume 20 Flores';

  @override
  String get chat_call_rule_2 =>
      'La llamada dura 1 minuto. Si no puedes hablar, puedes comunicarte por texto';

  @override
  String get chat_call_rule_3 =>
      'Se recomienda usar auriculares para escuchar su voz con claridad ✨';

  @override
  String get chat_call_btn_cancel => 'Ahora no';

  @override
  String get chat_call_pref_title => 'Configura tus preferencias de llamada';

  @override
  String get chat_call_lang_select => 'Seleccionar idioma de llamada';

  @override
  String get chat_call_save_memory => 'Guardar recuerdo de esta llamada';

  @override
  String get chat_call_save_memory_desc =>
      'Podrás volver a escucharla cuando termine la llamada';

  @override
  String get chat_call_btn_start => 'Iniciar llamada';

  @override
  String chat_points_shortage(String points) {
    return '¡No hay suficientes puntos de Flores! Tienes $points puntos';
  }

  @override
  String get chat_room_not_ready =>
      'La sala de chat no está lista, vuelve a entrar.';

  @override
  String get chat_stop_generating_msg =>
      'Respuesta detenida, no se descontaron puntos 🍃';

  @override
  String get chat_heartbeat_up => 'Su corazón se acelera...';

  @override
  String get chat_heartbeat_down => 'Su mirada se volvió fría...';

  @override
  String get chat_msg_copy => 'Copiar contenido';

  @override
  String get chat_msg_copied => '¡Copiado al portapapeles!';

  @override
  String get chat_msg_report => 'Reportar este mensaje';

  @override
  String get chat_msg_suggest => 'Sugerir';

  @override
  String get chat_report_title => 'Reportar esta conversación';

  @override
  String get chat_report_lang => 'Apareció un idioma extranjero';

  @override
  String get chat_report_inapp => 'Respuesta inapropiada';

  @override
  String get chat_report_context => 'El contexto no está conectado';

  @override
  String get chat_report_other => 'Otras razones';

  @override
  String get chat_report_hint => 'Describe el problema que has encontrado...';

  @override
  String get chat_report_submit => 'Enviar';

  @override
  String get chat_report_success =>
      '✅ Reporte enviado, lo ajustaremos lo antes posible';

  @override
  String get chat_suggest_title => 'Dar sugerencias';

  @override
  String get chat_suggest_hint => 'Escribe tus valiosas sugerencias...';

  @override
  String get chat_suggest_success =>
      '💖 Gracias por tu sugerencia, la procesaremos lo antes posible';

  @override
  String get chat_del_warn =>
      'Los mensajes no se pueden recuperar una vez eliminados.';

  @override
  String get chat_reset_title => 'Restablecer memoria';

  @override
  String get chat_reset_desc =>
      'Elige el grado de restablecimiento:\n\n1. [Solo chat]: Borra el historial de chat pero mantiene el nivel de afecto.\n2. [Restablecimiento completo]: Todo vuelve a cero, como en el primer encuentro.';

  @override
  String get chat_reset_only_chat => 'Solo historial de chat';

  @override
  String get chat_reset_full => 'Restablecimiento completo';

  @override
  String get chat_reset_full_msg =>
      'Todo ha vuelto al principio, él ya no te recuerda...';

  @override
  String get chat_reset_chat_msg =>
      'Historial de chat borrado, pero su amor por ti permanece.';

  @override
  String get chat_edit_ai_hint => 'Editar su respuesta...';

  @override
  String get chat_edit_user_hint => 'Introduce el nuevo contenido...';

  @override
  String chat_no_voice_msg(String name) {
    return 'Todavía no hay voz para $name...';
  }

  @override
  String get chat_poke_btn => 'Tocar';

  @override
  String get chat_poke_success =>
      '✨ ¡Le dimos un toque al creador por ti! Espera con ansias a que su voz esté disponible~';

  @override
  String chat_gift_points_needed(String cost) {
    return '¡No hay suficientes puntos de Flores! Necesitas $cost puntos 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ Alma gemela destinada ✨';

  @override
  String get chat_levelup_normal => '¡Subida de nivel de relación! 💖';

  @override
  String get chat_levelup_btn_soulmate => 'Grabar en el alma';

  @override
  String get chat_levelup_btn_normal => 'Aceptar con emoción';

  @override
  String get chat_loc_title => '📍 Enviar ubicación virtual';

  @override
  String get chat_loc_custom_btn => 'Enviar ubicación personalizada';

  @override
  String get chat_loc_hint => 'Introduce otro lugar... (Ej.: En tu corazón)';

  @override
  String get chat_loc_1 => 'Debajo de tu casa';

  @override
  String get chat_loc_2 => 'En la escuela';

  @override
  String get chat_loc_3 => 'En la cafetería por la que acabamos de pasar';

  @override
  String get chat_loc_4 => 'En la tienda de conveniencia';

  @override
  String get chat_interact_title => '✨ ¿Qué quieres hacer con él?';

  @override
  String get chat_interact_action => 'Toques y pequeños gestos';

  @override
  String get chat_interact_gift =>
      'Enviarle un pequeño regalo (consume Flores 🌸)';

  @override
  String get chat_action_poke => 'Tocar mejillas';

  @override
  String get chat_action_hug => 'Pedir un abrazo';

  @override
  String get chat_action_hand => 'Tomarse de la mano en secreto';

  @override
  String get chat_dice_btn => 'Lanzar dados';

  @override
  String get chat_loading_failed =>
      'Error al cargar la memoria, regresa e inténtalo de nuevo.';

  @override
  String get chat_test_mode_msg =>
      'El modo de prueba está activado, ¡chatea libremente! (Las conversaciones no se guardarán)';

  @override
  String get chat_empty_msg => '¡Comienza un viaje emocionante con él!';

  @override
  String get chat_ai_typing => 'Él está respondiendo...';

  @override
  String get chat_input_hint_default => 'Qué quieres decirle...';

  @override
  String get chat_typing_indicator => 'Escribiendo...';

  @override
  String get chat_menu_search => 'Buscar chat';

  @override
  String get chat_menu_gallery => 'Recuerdos y fondos exclusivos';

  @override
  String get chat_menu_aboutme => 'Relacionado conmigo';

  @override
  String get chat_menu_memo => 'Nota para él';

  @override
  String get chat_menu_period => 'Seguimiento del periodo';

  @override
  String get chat_menu_reset => 'Restablecer memoria';

  @override
  String get chat_search_hint => '¿Qué dulce conversación quieres revivir?';

  @override
  String get chat_search_empty => 'No se puede encontrar este recuerdo 🥺';

  @override
  String get chat_search_you => 'Tú dijiste';

  @override
  String get chat_search_him => 'Él dijo';

  @override
  String get chat_tool_backpack => 'Mochila';

  @override
  String get chat_tool_story => 'Resumen de la historia';

  @override
  String get chat_tool_photo => 'Fotos';

  @override
  String get chat_tool_record => 'Grabación de voz';

  @override
  String get chat_tool_profile => 'Archivos ShiGuang';

  @override
  String get chat_tool_interact => 'Interacciones';

  @override
  String get chat_record_recording => 'Grabando...';

  @override
  String get chat_record_start => 'Toca el micrófono para grabar';

  @override
  String get chat_record_done => 'Grabación terminada';

  @override
  String get chat_mode_daily_desc =>
      'Chat diario ligero y agradable, ¡como amigos!';

  @override
  String get chat_mode_story_desc => 'Progresión de la trama tipo novela.';

  @override
  String get chat_mode_immersive_desc =>
      'Experiencia sensorial definitiva, interacción profunda sin límites.';

  @override
  String get chat_switch_mode_title => 'Cambiar modo de chat';

  @override
  String get chat_voice_call => 'Llamada de voz';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '[Evento del sistema] $playerName envió un [$giftName].';
  }

  @override
  String get rel_title_soulmate => 'Alma gemela/Amor profundo';

  @override
  String get rel_title_lover => 'Amor apasionado/Novio exclusivo';

  @override
  String get rel_title_ambiguous => 'Fase ambigua/Tanteando el terreno';

  @override
  String get rel_title_friend => 'Amigo normal/Cariño incipiente';

  @override
  String get rel_title_acquaintance => 'Conocido/Un poco familiar';

  @override
  String get rel_title_stranger => 'Desconocido/Primer encuentro';

  @override
  String get rel_title_tense => 'Relación tensa/Cansancio';

  @override
  String get rel_title_avoiding => 'Como extraños/Evitación deliberada';

  @override
  String get rel_title_hostile => 'Disgusto extremo/Hostilidad fría';

  @override
  String get rel_title_nemesis => 'Enemigos mortales/Nunca volver a verse';

  @override
  String get rel_msg_soulmate =>
      '«No esperaba... que te volvieras tan importante para mí. Tan importante que... no puedo imaginar un mundo sin ti».';

  @override
  String get rel_msg_lover =>
      '«Lo más afortunado de mi vida fue, probablemente, ese día en que miré atrás y te vi».';

  @override
  String get rel_msg_ambiguous =>
      '«Últimamente... me he dado cuenta de que me quedo distraído más a menudo, y mi cabeza está llena de ti».';

  @override
  String get rel_msg_friend =>
      '«Ya que es tu invitación, supongo que podría sacar algo de tiempo, no es imposible».';

  @override
  String get rel_msg_acquaintance =>
      '«Te he visto mucho últimamente, y siento que... no me molesta que nos veamos tan seguido».';

  @override
  String get rel_msg_stranger =>
      '«Así que tú también estás aquí. ¿Es esto algún tipo de destino curioso?».';

  @override
  String chat_edit_char_count(String count) {
    return '$count caracteres';
  }

  @override
  String get chat_mysterious_player => 'Jugador misterioso';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return '¡El jugador $playerName está deseando escuchar la voz de $characterName, ve a generarla!';
  }

  @override
  String get gift_heart => 'Corazón';

  @override
  String get gift_flower => 'Flor';

  @override
  String get gift_sun => 'Sol';

  @override
  String get gift_confetti => 'Confeti';

  @override
  String get gift_coffee => 'Café';

  @override
  String get gift_cake => 'Pastel';

  @override
  String get chat_action_poke_prompt =>
      '(El jugador extiende la mano de repente y te toca la mejilla con picardía)';

  @override
  String get chat_action_hug_prompt =>
      '(El jugador abre los brazos con tristeza, pidiendo un abrazo cálido)';

  @override
  String get chat_action_hand_prompt =>
      '(El jugador te toma la mano en secreto debajo de la mesa)';

  @override
  String get chat_menu_send_location => 'Enviar ubicación virtual';

  @override
  String get weekday_mon => '(Lun)';

  @override
  String get weekday_tue => '(Mar)';

  @override
  String get weekday_wed => '(Mié)';

  @override
  String get weekday_thu => '(Jue)';

  @override
  String get weekday_fri => '(Vie)';

  @override
  String get weekday_sat => '(Sáb)';

  @override
  String get weekday_sun => '(Dom)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ Nuevo recuerdo obtenido: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'Se ha añadido automáticamente a su mochila exclusiva';

  @override
  String get chat_profile_updated_msg =>
      '¡Archivo ShiGuang actualizado! Él recordará tus últimos ajustes 🍃';

  @override
  String get comment_loading_author => 'Cargando...';

  @override
  String comment_post_failed(String error) {
    return 'Error al comentar, comprueba la conexión: $error';
  }

  @override
  String get comment_delete_confirm_desc =>
      '¿Estás seguro de que quieres eliminar permanentemente este comentario?';

  @override
  String get comment_delete_failed =>
      'Error al eliminar, comprueba tu conexión de red';

  @override
  String get comment_identity_title => 'Seleccionar identidad';

  @override
  String get comment_identity_myself => 'Yo mismo';

  @override
  String get comment_report_title => 'Confirmar denuncia';

  @override
  String get comment_report_rules_title =>
      '⚖️ Normas de denuncia de comentarios';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ 1ª infracción: Advertencia del sistema y un registro de infracción.\n2️⃣ 2ª infracción: Prohibición de comentar por 1 día.\n3️⃣ Reincidencia: Función de denuncia desactivada por 14 días y visibilidad reducida.\n\n🚨 Para casos graves de malicia:\nProhibición de interactuar con personajes por 1 día e ID publicado en el tablón por 3 días (prohibido cambiar el ID durante este tiempo).\n\n💡 Una vez enviada la denuncia, el resultado final se te notificará por [Correo del juego].\nPor favor, respeta a los demás y denuncia con sensatez.';

  @override
  String get comment_report_understood => 'Lo he entendido';

  @override
  String get comment_report_confirm_desc =>
      '¿Estás seguro de que quieres denunciar este comentario?\nLas denuncias malintencionadas pueden ser sancionadas.';

  @override
  String get comment_report_submit_btn => 'Confirmar denuncia';

  @override
  String get comment_report_success =>
      '¡Gracias por tu denuncia, lo verificaremos pronto!';

  @override
  String get comment_report_failed =>
      'Error al enviar la denuncia, inténtalo de nuevo más tarde.';

  @override
  String get comment_option_delete => 'Eliminar comentario';

  @override
  String get comment_option_report => 'Denunciar comentario';

  @override
  String comment_time_days_ago(String days) {
    return 'Hace $days días';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return 'Hace $hours horas';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return 'Hace $mins minutos';
  }

  @override
  String get comment_time_just_now => 'Recién';

  @override
  String get comment_sheet_title => 'Comentarios';

  @override
  String get comment_empty_state => 'Aún no hay comentarios, ¡sé el primero!';

  @override
  String get comment_reply_btn => 'Responder';

  @override
  String comment_replying_to(String name) {
    return 'Respondiendo a @$name';
  }

  @override
  String comment_input_hint(String name) {
    return 'Comentar como $name...';
  }

  @override
  String char_story_expect(String pronoun) {
    return 'Esperando la historia con $pronoun...';
  }

  @override
  String get common_update_failed => 'Error al actualizar, comprueba la red';

  @override
  String get char_edit_fragment => 'Editar fragmento';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 No le gusta: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 Le gusta: $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age años | $job';
  }

  @override
  String get common_got_it => 'Entendido';

  @override
  String get common_add_failed => 'Error al añadir, comprueba la red';

  @override
  String common_delete_failed_with_err(String error) {
    return 'Error al eliminar, comprueba el estado de la red: $error';
  }

  @override
  String get char_exclusive_guardian => 'Guardián exclusivo 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '¡A $playerName le ha gustado $charName!';
  }

  @override
  String chat_translation_prefix(String content) {
    return '[Trad] $content (Este es el contenido emocional traducido)';
  }

  @override
  String get player_default_nickname => 'Viajero';

  @override
  String get moment_create_title => 'Crear nueva publicación';

  @override
  String get moment_create_post_btn => 'Publicar';

  @override
  String get moment_create_hint => 'Comparte algo nuevo...';

  @override
  String get moment_create_error_empty =>
      '¡Se requiere al menos texto o una imagen!';

  @override
  String get moment_create_error_failed =>
      'Error al publicar, inténtalo de nuevo más tarde';

  @override
  String get moment_create_visibility_public => 'Público (Visible para todos)';

  @override
  String get moment_create_visibility_private =>
      'Privado (Solo visible para amigos)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (El jugador envió una ubicación: $location)';
  }

  @override
  String get chat_you => 'Tú';

  @override
  String get chat_opponent => 'Oponente';

  @override
  String chat_dice_duel_result(String name) {
    return '[Evento del sistema] ¡Duelo de dados con $name! El resultado es...';
  }

  @override
  String get chat_loading_status => 'Cargando...';

  @override
  String chat_error_load_msg(String error) {
    return 'Error al cargar el mensaje: $error';
  }

  @override
  String get chat_voice_msg_label => 'Mensaje de voz';

  @override
  String chat_special_story_trigger(String title) {
    return '[Historia especial desbloqueada: $title]';
  }

  @override
  String common_edit_failed(String error) {
    return 'Error al editar: $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'Error al restablecer: $error';
  }

  @override
  String get chat_default_greeting => 'Hola...';

  @override
  String get chat_memory_cleared => 'Memoria borrada por completo';

  @override
  String get chat_history_reset => 'Conversación restablecida';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 [ Archivo ShiGuang Exclusivo - $name ]\n━━━━━━━━━━━━━━━━━━\n🔹 Nombre: $identity\n🔹 Cumpleaños: $birthday\n🔹 Altura: $height\n🔹 Apariencia: $appearance\n🔹 Ocupación: $job\n\n📖 [ Sobre los fragmentos de su alma ]\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 [ Archivo ShiGuang Exclusivo ]\n━━━━━━━━━━━━━━━━━━\n🔹 Nombre: $nickname\n🔹 Cumpleaños: $birthday\n\n🔒 Otros datos del personaje aún no están desbloqueados...\n(¡Rellena el perfil completo para que te conozca mejor en el universo paralelo! ✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => 'Archivo sin nombre';

  @override
  String get chat_default_player_name => 'Jugador';

  @override
  String get error_system_confusion =>
      'El sistema está un poco confundido, inténtalo de nuevo.';

  @override
  String get error_msg_send_failed =>
      'Error al enviar el mensaje, inténtalo de nuevo.';

  @override
  String get error_system_busy =>
      'Sistema ocupado, inténtalo de nuevo más tarde.';

  @override
  String get error_network_unavailable =>
      'No se puede conectar en este momento, inténtalo de nuevo.';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 Llamada terminada, hablaste con $name durante $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return 'Historia exclusiva: $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'Este es un recuerdo oculto exclusivo para ti y $name...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return 'Un recuerdo exclusivo sobre «$keyword» se ha desbloqueado en silencio...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '[Evento oculto activado: $title]\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......(Te mira en silencio, como si esperara a que hablaras primero)';

  @override
  String get chat_new_room_created => 'Nueva sala de chat creada';

  @override
  String portfolio_title(String nickname) {
    return 'Portafolio de $nickname';
  }

  @override
  String get enter_secret_studio => 'Entrar a mi estudio secreto';

  @override
  String get no_public_character_mine =>
      '¡Aún no has publicado ningún personaje público!\nVe al estudio a crear uno ✨';

  @override
  String get no_public_character_other =>
      'Este creador aún no ha publicado ningún personaje...';

  @override
  String get delete_draft_title => 'Eliminar borrador';

  @override
  String get confirm_delete_draft_msg =>
      '¿Estás seguro de que quieres eliminar este personaje sin terminar?\n(No se puede deshacer una vez eliminado)';

  @override
  String get draft_cleared_success => 'Borrador eliminado con éxito 🧹';

  @override
  String get login_required_for_studio =>
      '¡Inicia sesión primero para entrar al estudio!';

  @override
  String get my_secret_studio_title => 'Mi estudio secreto 🛠️';

  @override
  String get create_new_character_btn => 'Crear nuevo personaje';

  @override
  String get unnamed_draft => 'Borrador sin nombre';

  @override
  String get click_to_edit_story =>
      'Haz clic para seguir editando su historia...';

  @override
  String get label_draft => 'Borrador';

  @override
  String get studio_empty_title => 'El estudio está vacío por ahora';

  @override
  String get studio_empty_subtitle =>
      '¡Haz clic en la esquina inferior para empezar a crear tu primer personaje!';

  @override
  String get common_no_changes => 'No hay cambios';

  @override
  String get moment_updated_success => '¡Publicación actualizada!';

  @override
  String common_save_failed(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get moment_edit_title => 'Editar publicación';

  @override
  String get action_change_image => 'Cambiar imagen';

  @override
  String get action_remove_image => 'Eliminar imagen';

  @override
  String get moment_delete_confirm_title =>
      '¿Estás segura de que quieres eliminar esta publicación?';

  @override
  String get moment_delete_confirm_content =>
      '¡Después de eliminarla, este recuerdo de tus Momentos desaparecerá!';

  @override
  String get action_confirm_delete => 'Confirmar eliminación';

  @override
  String get friend_unknown => 'Un amigo';

  @override
  String moment_like_yours(String nickname) {
    return '¡A $nickname le encanta tu publicación! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname piensa que $authorName es encantador y le dio un me gusta. ✨';
  }

  @override
  String get moment_like_success => '¡Tu latido ha sido enviado! ✨';

  @override
  String get moment_notification_new_like => '¡Nuevo me gusta! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '¡$nickname mencionó a @$name en una publicación! ✨';
  }

  @override
  String get moment_detail_title => 'Detalles de la publicación';

  @override
  String get moment_not_found =>
      'Parece que esta publicación ha desaparecido... 😢';

  @override
  String get moment_comment_title => 'Comentarios de Momentos';

  @override
  String get moment_comment_empty =>
      'Nadie ha comentado aún, ¡sé la primera! 🛋';

  @override
  String moment_replying_to(String name) {
    return 'Respondiendo a @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return 'Responder a @$name...';
  }

  @override
  String get moment_leave_comment_hint => 'Deja tu respuesta...';

  @override
  String get moment_delete_permanent_confirm =>
      'Esta publicación se eliminará permanentemente. ¿Estás seguro?';

  @override
  String get moment_action_delete => 'Eliminar publicación';

  @override
  String get moment_action_report => 'Denunciar esta publicación';

  @override
  String get moment_action_share => 'Compartir esta publicación';

  @override
  String get moment_forward_hint =>
      'Reenviar esta publicación a un personaje...';

  @override
  String moment_reply_private(String name) {
    return 'Responder por mensaje privado a $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return '¡Vamos a chatear con $name con esta publicación! 💬';
  }

  @override
  String get moment_share_to_apps => 'Compartir en otras aplicaciones';

  @override
  String moment_likes_label(String count) {
    return '$count Hojas';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】Ven a ver la publicación de $author: $content\n\nDescárgala ahora y comienza tus momentos exclusivos: $appLink';
  }

  @override
  String get moment_forward_title =>
      'Reenviar al personaje con el que estás chateando 💌';

  @override
  String get moment_forward_empty_state =>
      '¡Aún no tienes chats activos!\nVe al vestíbulo a buscar a alguien especial 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【Reenviado una publicación】\nAutor: $author\nContenido: $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ ¡Compartido discretamente con $name!';
  }

  @override
  String get action_send => 'Enviar';

  @override
  String get memo_delete_confirm =>
      '¿Estás seguro de que quieres eliminar esta nota? Esta acción no se puede deshacer.';

  @override
  String get memo_add_title => 'Añadir nota';

  @override
  String get memo_edit_title => 'Editar nota';

  @override
  String memo_hint_text(String name) {
    return '¿Qué te gustaría anotar sobre $name?';
  }

  @override
  String get memo_label_reminder_date => 'Fecha de recordatorio:';

  @override
  String get memo_action_save => 'Guardar nota';

  @override
  String get memo_error_empty_content => '¡El contenido no puede estar vacío!';

  @override
  String memo_list_title(String name) {
    return 'Notas con $name';
  }

  @override
  String get memo_empty_state =>
      '¡Aún no hay notas!\n¡Haz clic en la esquina superior derecha para añadir una!';

  @override
  String memo_reminder_date_display(String date) {
    return 'Fecha de aviso: $date';
  }

  @override
  String get daily_gift_title => 'Regalo diario del tiempo';

  @override
  String daily_login_welcome(String appName, String amount) {
    return '¡Bienvenido/a de nuevo a $appName!\nInicia sesión hoy para recibir $amount puntos de Lenguaje de las Flores. 🌸';
  }

  @override
  String get title_daily_check_in => 'Registro diario';

  @override
  String success_claim_reward(String amount) {
    return '¡Has recibido $amount puntos de Lenguaje de las Flores! 🌸';
  }

  @override
  String get error_claim_failed =>
      'Error al recibir, por favor comprueba la red e inténtalo de nuevo.';

  @override
  String get action_claim_now => 'Recibir ahora';

  @override
  String get common_or => 'o';

  @override
  String get title_language_settings => 'Ajustes de idioma';

  @override
  String get app_name => 'Lianlian Shiguang';

  @override
  String get login_slogan => 'Comienza tus momentos exclusivos';

  @override
  String get login_with_google => 'Iniciar sesión con Google';

  @override
  String get login_with_apple => 'Iniciar sesión con Apple';

  @override
  String get login_with_facebook => 'Iniciar sesión con Facebook';

  @override
  String get login_with_email => 'Iniciar sesión con cuenta Lianlian (Correo)';

  @override
  String get title_contact_us_heading => '¡Valoramos mucho tus sugerencias!';

  @override
  String get desc_contact_us_body =>
      'Por favor, escribe tus ideas aquí para ayudarnos a mejorar el juego.';

  @override
  String get error_feedback_empty =>
      '¡El contenido de la sugerencia no puede estar vacío!';

  @override
  String get email_subject_feedback =>
      'Lianlian Shiguang - Comentarios de los jugadores';

  @override
  String get msg_email_app_not_found_copied =>
      'No se puede abrir el correo automáticamente, ¡se ha copiado el correo oficial para ti!';

  @override
  String get title_contact_us => 'Contáctanos';

  @override
  String get desc_contact_us =>
      '¡Valoramos mucho tus sugerencias!\nPor favor, escribe tus ideas aquí para ayudarnos a mejorar el juego.';

  @override
  String get hint_enter_feedback =>
      'Por favor, introduce tu sugerencia aquí...';

  @override
  String get action_send_via_email => 'Enviar por correo electrónico';

  @override
  String get error_email_password_empty =>
      '¡El correo y la contraseña no pueden estar vacíos!';

  @override
  String get auth_error_default =>
      'Ocurrió un error, inténtalo de nuevo más tarde.';

  @override
  String get auth_error_user_not_found =>
      'No se encuentra este correo, ¡por favor regístrate primero!';

  @override
  String get auth_error_wrong_password =>
      '¡Contraseña incorrecta, inténtalo de nuevo!';

  @override
  String get auth_error_email_in_use =>
      '¡Este correo ya está registrado! Por favor, inicia sesión directamente.';

  @override
  String get auth_error_weak_password =>
      'La contraseña es muy débil, ¡ingresa al menos 6 caracteres!';

  @override
  String get auth_error_invalid_email => '¡Formato de correo inválido!';

  @override
  String get title_welcome_back => 'Bienvenido/a de nuevo';

  @override
  String get title_register_account => 'Registrar cuenta exclusiva';

  @override
  String get label_email => 'Correo electrónico';

  @override
  String get label_password => 'Contraseña';

  @override
  String get action_login => 'Iniciar sesión';

  @override
  String get action_register => 'Registrarse';

  @override
  String get prompt_no_account =>
      '¿Aún no tienes cuenta? Haz clic aquí para registrarte';

  @override
  String get prompt_has_account =>
      '¿Ya tienes cuenta? Haz clic aquí para iniciar sesión';

  @override
  String get error_nickname_empty => '¡El apodo no puede estar vacío!';

  @override
  String get profile_saved_success => '¡Perfil guardado!';

  @override
  String get error_id_empty => '¡El ID no puede estar vacío!';

  @override
  String get error_id_too_long =>
      '¡La longitud del ID no puede exceder los 10 caracteres!';

  @override
  String get error_id_already_used =>
      'Este ID ya está en uso, ¡por favor elige otro!';

  @override
  String profile_save_failed(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get draft_saved_success_msg =>
      '¡Entendido! Lo hemos guardado en borradores, ¡puedes volver a editarlo en cualquier momento! ✨';

  @override
  String get dialog_reminder_title => 'Recordatorio';

  @override
  String get warning_id_not_edited =>
      'El ID exclusivo aún no ha sido editado, ¿seguro que quieres guardar ahora?';

  @override
  String get action_continue_editing => 'Continuar editando';

  @override
  String get action_edit_later => 'Editar más tarde';

  @override
  String get action_edit_later_short => 'Editar luego';

  @override
  String get action_cancel_changes => 'Cancelar cambios';

  @override
  String get error_birthdate_locked =>
      '¡La fecha de nacimiento ya está configurada y no se puede cambiar!';

  @override
  String get action_select_avatar => 'Seleccionar avatar';

  @override
  String get action_choose_from_gallery => 'Elegir de la galería';

  @override
  String get title_adjust_avatar => 'Ajustar tu avatar';

  @override
  String get avatar_updated_success => 'Avatar actualizado para ti 🍃';

  @override
  String get title_create_profile => 'Crear tu perfil';

  @override
  String get title_edit_profile => 'Editar perfil';

  @override
  String get label_your_nickname => 'Tu apodo';

  @override
  String get label_player_exclusive_id => 'ID exclusivo de jugador';

  @override
  String get msg_id_locked =>
      'El ID está bloqueado y no se puede volver a cambiar.';

  @override
  String get msg_id_change_chance =>
      'Tienes una oportunidad gratuita para cambiar tu ID.';

  @override
  String get action_select_birthdate =>
      'Por favor, selecciona tu fecha de nacimiento';

  @override
  String label_birthdate(String date) {
    return 'Fecha de nacimiento: $date';
  }

  @override
  String get msg_birthdate_immutable =>
      'El cumpleaños no se puede cambiar una vez configurado ✨';

  @override
  String get action_start_journey => 'Comenzar el viaje';

  @override
  String get action_add_image => 'Añadir imagen';

  @override
  String moment_like_self(String nickname) {
    return '¡A $nickname le encanta tu publicación! 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname piensa que $authorName es encantador y le dio un me gusta. ✨';
  }

  @override
  String get task_social_tour_complete =>
      '✨ ¡Misión de Tour Social completada! ¡No olvides reclamar tus flores! 🌸';

  @override
  String get wall_title_shiguang => 'Muro ShiGuang';

  @override
  String get wall_tab_explore => '🌍 Explorar';

  @override
  String get wall_tab_exclusive => '🔒 Exclusivo';

  @override
  String get more_options => 'Más opciones';

  @override
  String get delete_warning =>
      'Tras eliminarla, la publicación no se podrá recuperar';

  @override
  String get delete_success => 'Eliminado con éxito';

  @override
  String get notification_new_comment => '¡Nuevo comentario! 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '¡A $senderName le ha gustado tu publicación!';
  }

  @override
  String get empty_public_moments_prompt =>
      'Actualmente está vacío,\n¡ve a publicar tu primera publicación pública! 🌍';

  @override
  String get empty_private_moments_prompt =>
      'Aún no hay momentos en el círculo,\n¡ve a crear recuerdos con él! ✨';

  @override
  String get profile_archived_or_deleted_message =>
      'Este archivo del alma ha sido archivado por el creador, marcado como privado o se ha desvanecido en el torrente del tiempo...\n\nQuizás en un universo paralelo, tengáis la oportunidad de encontraros de nuevo. ✨';

  @override
  String get leave_silently => 'Irse en silencio';

  @override
  String get character_post_schedule =>
      'Programación de publicaciones de personajes';

  @override
  String get creator_self => 'Creador (Tú)';

  @override
  String get post_identity_prompt => '¿Con qué identidad vas a publicar hoy?';

  @override
  String get identity_creator => '✨ Identidad de Creador';

  @override
  String get identity_character => 'Identidad de Personaje';

  @override
  String get decide_post_time_prompt =>
      '¡Ayúdales a decidir la hora de publicación!';

  @override
  String get auto_post_schedule_hint =>
      'Si se activa, las publicaciones se publicarán automáticamente a la hora especificada\n(💡 Consejo: ¡Usa horas no exactas para que parezca más humano!)';

  @override
  String get no_characters_created_yet =>
      '¡Aún no has creado ningún personaje!';

  @override
  String time_hour(String hour) {
    return 'A las $hour';
  }

  @override
  String time_minute(String minute) {
    return '$minute min';
  }

  @override
  String get empty_public_moments_short =>
      'No hay publicaciones públicas aún 🌍';

  @override
  String get empty_private_moments_short => 'El círculo está muy tranquilo ✨';

  @override
  String get my_created_characters => 'Mis personajes creados';

  @override
  String get no_characters_yet => 'Aún no se han creado personajes';

  @override
  String play_count_display(int count) {
    return 'Veces jugado: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return 'Calendario de cuidados de $characterName';
  }

  @override
  String get care_calendar_greeting => '¿Cómo te sientes hoy?';

  @override
  String get care_calendar_save_btn =>
      'Guarda el registro, deja que él te cuide';

  @override
  String get care_calendar_delete_confirm => '¿Quieres eliminar este registro?';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName: \"Lo he anotado todo. Han sido días difíciles para ti, pero siempre estaré a tu lado.\"';
  }

  @override
  String get daily_gift_success => '¡Regalo diario reclamado con éxito! 🌸';

  @override
  String get check_in_fail_network =>
      'Fallo al registrar, comprueba tu conexión de red 🍃';

  @override
  String task_completed(String taskName) {
    return 'Misión completada: $taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return '¡Reclamaste con éxito $rewardAmount flores de \"$taskName\"!';
  }

  @override
  String claim_failed_error(String e) {
    return 'Error al reclamar: $e';
  }

  @override
  String get tab_heartbeat_diary => 'Diario de latidos';

  @override
  String get tab_daily_chit_chat => 'Charla diaria';

  @override
  String get task_desc_chat_3_times => 'Chatea 3 veces con un personaje';

  @override
  String get tab_story_progression => 'Progreso de la historia';

  @override
  String get task_desc_story_1_time =>
      'Completa 1 interacción en el modo historia';

  @override
  String get tab_social_tour => 'Tour social';

  @override
  String get task_desc_like_3_moments =>
      'Dale me gusta a 3 publicaciones de Momentos';

  @override
  String get btn_claimed => 'Reclamado';

  @override
  String get btn_claim => 'Reclamar';

  @override
  String get btn_incomplete => 'Incompleto';

  @override
  String get network_unstable_retry =>
      'Conexión inestable, inténtalo de nuevo más tarde 🍃';

  @override
  String get title_time_travel => 'Viaje en el tiempo';

  @override
  String get select_chat_mode => 'Seleccionar modo de chat';

  @override
  String get mode_chat => 'Chat';

  @override
  String get mode_daily_desc => 'Charla informal para mantener el vínculo';

  @override
  String get mode_story_desc =>
      'Sumérgete en la historia para una experiencia inmersiva';

  @override
  String get greeting_hello => '¡Hola!';

  @override
  String get greeting_default_daily => '¿Me buscabas?';

  @override
  String get title_personal_homepage => 'Página personal';

  @override
  String get title_time_letters => 'Cartas del tiempo';

  @override
  String get status_signed_in_today => 'Registrado hoy';

  @override
  String get status_signing_in => 'Registrando...';

  @override
  String get status_daily_sign_in => 'Registro diario (+10 flores)';

  @override
  String get toast_id_copied => '¡ID copiado!';

  @override
  String get hint_click_avatar_to_edit =>
      'Haz clic en el avatar para editar el perfil';

  @override
  String get title_my_friends => 'Mis amigos';

  @override
  String get action_show_all => 'Mostrar todo';

  @override
  String get empty_no_characters_created =>
      'Aún no has creado ningún personaje.';

  @override
  String get common_close => 'Cerrar';

  @override
  String get search_companion_title => 'Buscar compañero ShiGuang';

  @override
  String get search_name_placeholder => 'Introduce su nombre...';

  @override
  String get search_no_match_hint =>
      '¿No se encuentra el personaje, pruebas con otro nombre? ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age años | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age años';
  }

  @override
  String get empty_state_warmth =>
      'El calor residual del tiempo y el espacio aún permanece aquí...';
}
