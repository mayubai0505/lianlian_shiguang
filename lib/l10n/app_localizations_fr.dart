// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get changeTheme => 'Changer la couleur du thème';

  @override
  String get feedback => 'Commentaires et suggestions';

  @override
  String get changeLanguage => 'Changer la langue';

  @override
  String get allFriendsTitle => 'Tous les amis';

  @override
  String get noFriendsMessage => 'Vous n\'avez pas encore d\'amis.';

  @override
  String get unknownCharacter => 'Personnage inconnu';

  @override
  String errorLoadingFriends(String error) {
    return 'Une erreur s\'est produite lors du chargement de la liste d\'amis : $error';
  }

  @override
  String get tagGentle => 'Doux';

  @override
  String get tagCheerful => 'Joyeux';

  @override
  String get tagLively => 'Vif';

  @override
  String get tagMischievous => 'Esprit malicieux';

  @override
  String get tagRichYoungLady => 'Jeune fille riche';

  @override
  String get tagRichYoungMaster => 'Jeune homme riche';

  @override
  String get tagWealthyFamily => 'Famille riche';

  @override
  String get tagScheming => 'Intrigant';

  @override
  String get tagPossessive => 'Possessif';

  @override
  String get tagParanoid => 'Paranoïaque';

  @override
  String get tagPersistent => 'Persistant';

  @override
  String get tagUncle => 'Oncle';

  @override
  String get tagAuntie => 'Tante';

  @override
  String get tagSeniorSister => 'Sœur aînée';

  @override
  String get tagJuniorBrother => 'Frère cadet';

  @override
  String get tagHandsome => 'Beau';

  @override
  String get tagStunning => 'Éblouissant';

  @override
  String get tagContrast => 'Contraste';

  @override
  String get tagFlirty => 'Flirt';

  @override
  String get tagAgeGap => 'Différence d\'âge';

  @override
  String get userNotFoundError => 'Utilisateur introuvable';

  @override
  String get imageDataMismatchError =>
      'Les données de l\'image sont incohérentes, veuillez sélectionner l\'image à nouveau.';

  @override
  String get createCharacterTitle => 'Créer un personnage';

  @override
  String get charAlbumTitle =>
      'Album du personnage (la première image est l\'avatar principal)';

  @override
  String get charNameLabel => 'Nom du personnage:*';

  @override
  String get charDescSection => 'Description du personnage:';

  @override
  String get charAgeLabel => 'Âge:';

  @override
  String get charJobLabel => 'Profession:*';

  @override
  String get charBirthdayLabel => 'Anniversaire:(MMDD)';

  @override
  String get charGenderLabel => 'Genre *';

  @override
  String get genderNotSelected => 'Non sélectionné';

  @override
  String get genderMale => 'Homme';

  @override
  String get genderFemale => 'Femme';

  @override
  String get genderOther => 'Autre';

  @override
  String get charHeightLabel => 'Taille:(cm)';

  @override
  String get charAppearanceLabel => 'Description de l\'apparence:';

  @override
  String get charPersonalityTagsSection => 'Tags de personnalité';

  @override
  String get charOtherPersonalityTagsHint => 'Autres tags de personnalité...';

  @override
  String get otherSectionTitle => 'Autre';

  @override
  String get charLikesLabel =>
      'Ce qui est aimé:(par exemple : gâteau aux fraises, chats, jours de pluie)';

  @override
  String get charDislikesLabel =>
      'Ce qui est détesté:(par exemple : la courge amère, les endroits bruyants)';

  @override
  String get charSecretsLabel =>
      'Petits secrets inconnus: (par exemple : est en fait un as de la boussole)';

  @override
  String get charMannerismsSection => 'Manières et gestes';

  @override
  String get charToneLabel =>
      'Ton et style de parole: (par exemple : froid avec les étrangers)';

  @override
  String get charDialogueExampleLabel =>
      'Exemple de dialogue: (Joueur : Tu es vraiment gentil ! Personnage : ...Oh.)';

  @override
  String get charBackgroundSection => 'Contexte du personnage:';

  @override
  String get charBackgroundHint =>
      'Entrez l\'histoire de fond du personnage (max 2500 mots)';

  @override
  String get charStoryStartSection => 'Début de l\'histoire:';

  @override
  String get charStoryStartHint =>
      'Entrez l\'intrigue du personnage (max 2500 mots)';

  @override
  String get charStorySummaryLabel =>
      'Résumé de l\'histoire (max 50 mots, sera affiché sur la carte de rencontre)';

  @override
  String get charExtraInfoSection =>
      'Informations supplémentaires sur le personnage:';

  @override
  String get charExtraInfoHint => 'Entrez le contenu supplémentaire...';

  @override
  String get charPublicToggleLabel =>
      'Rendre public pour que d\'autres joueurs puissent y jouer ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get createButton => 'Créer';

  @override
  String get saveButton => 'Sauvegarder';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get exitCreationTitle =>
      'Vous allez quitter l\'écran de création de personnage';

  @override
  String get saveDraftPrompt => 'Faut-il sauvegarder comme brouillon ?';

  @override
  String get draftNeeded => 'Oui';

  @override
  String get draftNotNeeded => 'Non';

  @override
  String get editExtraInfoTitle => 'Modifier le contenu supplémentaire';

  @override
  String get nameAndAvatarError =>
      'Veuillez remplir le nom du personnage et télécharger au moins un avatar !';

  @override
  String get savingStatus => 'Sauvegarde en cours...';

  @override
  String get uploadingImagesStatus => 'Téléchargement des images...';

  @override
  String get maxImagesError =>
      'Vous pouvez télécharger un maximum de 10 images.';

  @override
  String get uploadingImagesStatusShort => 'Traitement des images en cours...';

  @override
  String get savingCharacterData => 'Sauvegarde des données du personnage...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'Personnage \"$charName\" créé !';
  }

  @override
  String get uploadImageTimeoutError =>
      'Échec de la création du personnage : le téléchargement de l\'image a expiré, veuillez vérifier votre connexion Internet.';

  @override
  String createCharacterGenericError(String error) {
    return 'Échec de la création du personnage : $error';
  }

  @override
  String get settingsSectionAppearance => 'Apparence et Contenu';

  @override
  String get settingsSectionAccount => 'Gestion du Compte et du Contenu';

  @override
  String get settingsSectionAbout => 'À Propos de Nous';

  @override
  String get accountManagement => 'Gestion du compte';

  @override
  String get userId => 'ID :';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'Inconnu';

  @override
  String get userIdCopied =>
      'L\'ID utilisateur a été copié dans le presse-papiers';

  @override
  String get characterManagement => 'Gestion des personnages';

  @override
  String get viewBlockedCharacters => 'Afficher les personnages bloqués';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get logoutButton => 'Déconnexion';

  @override
  String get logoutDialogTitle => 'Voulez-vous vous déconnecter ?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'J\'ai fait une erreur';

  @override
  String get logoutDialogActionConfirm => 'Confirmer';

  @override
  String get logoutSuccessSnackbar =>
      'D\'accord ! Je vous attends de retour♥(´∀` )';

  @override
  String get deleteAccountButton => 'Supprimer le compte';

  @override
  String get deleteAccountDialogTitle =>
      'Êtes-vous sûr de vouloir supprimer ce compte ?இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'Cette action est irréversible, toutes les données seront définitivement supprimées !';

  @override
  String get deleteAccountDialogActionCancel =>
      'Non, je ne veux pas le supprimer';

  @override
  String get deleteAccountDialogActionConfirm => 'Confirmer';

  @override
  String get deleteAccountSuccessSnackbar =>
      'Le compte a été supprimé avec succès.';

  @override
  String get appDisclaimer =>
      'Les personnages et les scènes du jeu sont fictifs, ne les appliquez pas à la réalité ! S\'il y a des similitudes, c\'est purement une coïncidence.';

  @override
  String appVersion(String version) {
    return 'Version de l\'application: $version';
  }

  @override
  String get dialogTitleHint => 'Astuce';

  @override
  String get completeProfilePrompt =>
      'Veuillez d\'abord modifier votre profil pour compléter vos informations !';

  @override
  String get goToEdit => 'Aller à la modification';

  @override
  String get later => 'Plus tard';

  @override
  String chattingWith(String friendName) {
    return 'Discuter avec $friendName';
  }

  @override
  String chatContentWith(String friendName) {
    return 'Contenu du chat avec $friendName';
  }

  @override
  String get chatInputHint => 'Entrez un message...';
}
