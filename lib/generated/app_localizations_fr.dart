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

  @override
  String get characterNotFoundError => 'Données du personnage introuvables';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'Échec du chargement des détails du personnage : $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'Relation initiale';

  @override
  String get relationship_childhood_friend => 'Amis d\'enfance';

  @override
  String get relationship_senior_junior => 'Élèves plus âgés/plus jeunes';

  @override
  String get relationship_bickering_couple => 'Couple qui se taquine';

  @override
  String get relationship_colleagues => 'Collègues de travail';

  @override
  String get relationship_other => 'Autre (veuillez saisir manuellement)';

  @override
  String get chatModeDaily => 'Mode Quotidien';

  @override
  String get chatModeStory => 'Mode Histoire';

  @override
  String get chatModeImmersive => 'Mode Immersif';

  @override
  String get chatModeGemini => 'Compagnon de Vie';

  @override
  String get announcement_new => 'Nouvelle Annonce';

  @override
  String get mail_notification =>
      'Une nouvelle Lettre du Temps est arrivée ! Allez consulter le Parchemin maintenant !';

  @override
  String get customer_service_reply => 'Réponse du Service Client';

  @override
  String get system_announcement => 'Annonce Système';

  @override
  String get empty_announcement => 'Aucune annonce pour le moment.';

  @override
  String get untitled => 'Sans titre';

  @override
  String get no_content => 'Aucun contenu';

  @override
  String get privacy_policy_title =>
      'Politique de Confidentialité de Lianlian Shiguang';

  @override
  String get privacy_policy_date => 'Dernière mise à jour : 10 avril 2026';

  @override
  String get privacy_policy_body =>
      'Politique de Confidentialité de \"Lianlian Shiguang\"\nDernière mise à jour : 10 avril 2026\n\nBienvenue sur \"Lianlian Shiguang\" (ci-après \"le Service\"). Nous accordons une grande importance à votre vie privée. Cette politique détaille la collecte et l\'utilisation de vos données.\n\n1. Informations de compte :\nConnexion tierce : Via Google, Facebook ou Apple, nous collectons votre Firebase UID, e-mail et pseudonyme.\nE-mail : Votre mot de passe est crypté via Firebase, inaccessible à l\'équipe de développement.\n\nInteraction : Nous stockons vos dialogues avec l\'IA pour assurer une mémoire continue aux personnages.\nAppareil : Modèle, version du système et identifiant unique pour l\'optimisation.\n\n2. Utilisation :\nOptimisation de l\'IA, gestion des transactions (points) et protection contre les cyberattaques.\n\n3. Partenaires :\nGoogle Cloud / Firebase, OpenRouter, xAI, Meta. Nous ne vendons pas vos dialogues à des annonceurs.\n\n4. Suppression :\nDonnées stockées sur le cloud. Demande de suppression définitive de compte possible à tout moment.';

  @override
  String get terms_title => 'Conditions d\'Utilisation de Lianlian Shiguang';

  @override
  String get terms_date => 'Dernière mise à jour : 10 avril 2026';

  @override
  String get terms_body =>
      'Conditions d\'Utilisation de \"Lianlian Shiguang\"\nDernière mise à jour : 10 avril 2026\n\nL\'utilisation du Service implique l\'acceptation des termes suivants :\n\n1. Nature du Service :\nRéponses générées par IA. Les propos ne reflètent pas l\'opinion des développeurs. Risque de contenu fictionnel ou inexact.\n\n2. Points Virtuels :\nBiens virtuels non remboursables après consommation (histoires, appels, cadeaux).\n\n3. Comportement :\nInterdiction de générer du contenu violent ou illégal. Interdiction de détourner les données du système.\n\n4. Propriété Intellectuelle :\nLes personnages (ex: Cheng An) et scripts appartiennent à l\'équipe. Les ressources tierces (Google, Apple) sont utilisées sous licence.\n\n5. Résiliation :\nSuspension de compte possible en cas de violation des règles.';

  @override
  String get login_required => 'Veuillez vous connecter d\'abord';

  @override
  String get cloud_character_mgmt => 'Gestion des personnages cloud';

  @override
  String get connection_error => 'Erreur de connexion';

  @override
  String get no_characters_met =>
      'Vous n\'avez encore rencontré aucun personnage !';

  @override
  String get status_paused => 'État : Contact suspendu';

  @override
  String get status_in_progress => 'État : En cours';

  @override
  String get unblock => 'Débloquer';

  @override
  String get block => 'Bloquer';

  @override
  String get confirm_block_title => 'Confirmer le blocage ?';

  @override
  String confirm_block_msg(Object charName) {
    return 'Après le blocage, vous ne recevrez plus de messages de $charName.';
  }

  @override
  String get think_again => 'Réfléchir encore';

  @override
  String get confirm_block_btn => 'Confirmer le blocage';

  @override
  String get no_char_info =>
      'Pas encore d\'infos détaillées pour ce personnage...';

  @override
  String get private_mailbox => 'Boîte aux lettres privée';

  @override
  String get user_info_not_found => 'Infos utilisateur introuvables';

  @override
  String get load_failed => 'Échec du chargement, réessayez plus tard';

  @override
  String get empty_mailbox => 'La boîte aux lettres est vide~';

  @override
  String get system_notification => 'Notification système';

  @override
  String get interaction_records => 'Historique d\'interaction';

  @override
  String get liked_content => 'Contenus aimés';

  @override
  String get my_favorites => 'Mes favoris';

  @override
  String get login_to_view_records => 'Connectez-vous pour voir l\'historique';

  @override
  String get no_likes_yet => 'Vous n\'avez encore aimé aucun post !';

  @override
  String get empty_favorites => 'Favoris vides, allez explorer le hall !';

  @override
  String get theme_sakura_pink => 'Rose Sakura';

  @override
  String get theme_ocean_blue => 'Bleu Océan';

  @override
  String get theme_sunset_orange => 'Orange Crépuscule';

  @override
  String get theme_mint_forest => 'Forêt Menthe';

  @override
  String get theme_midnight => 'Mode Minuit';

  @override
  String get change_atmosphere => 'Changer d\'ambiance';

  @override
  String get custom_color => 'Couleur personnalisée';

  @override
  String get custom_color_desc => 'Créez votre propre ambiance';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';
}
