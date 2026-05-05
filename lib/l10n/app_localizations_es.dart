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
}
