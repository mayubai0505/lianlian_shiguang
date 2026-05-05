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
  String block_warning_msg(String charName) {
    return 'Après le blocage, vous ne recevrez temporairement plus de messages de $charName.';
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

  @override
  String get confirm_delete_title => 'Confirmer la suppression';

  @override
  String get confirm_delete_memory_msg =>
      'Êtes-vous sûre de vouloir qu\'il oublie cela ? Cette action est irréversible.';

  @override
  String get delete_btn => 'Supprimer';

  @override
  String get memory_erased_msg => 'Cette mémoire a été effacée.';

  @override
  String get delete_failed_msg => 'Échec de la suppression';

  @override
  String get edit_memory_title => 'Modifier le souvenir';

  @override
  String get modify_memory_hint => 'Modifier cette mémoire...';

  @override
  String get memory_re_recorded_msg => 'Mémoire réenregistrée';

  @override
  String get update_failed_msg => 'Échec de la mise à jour';

  @override
  String get update_favorite_failed_msg =>
      'Échec de la mise à jour des favoris';

  @override
  String char_notebook_title(String charName) {
    return 'Carnet de $charName';
  }

  @override
  String get error_loading_memory => 'Erreur lors du chargement de la mémoire';

  @override
  String get empty_notebook_msg =>
      'Le carnet est vide...\nAllez discuter pour qu\'il puisse noter tout ce qui vous concerne !';

  @override
  String get date_format_text => 'd MMM yyyy';

  @override
  String get remove_special_focus => 'Retirer des favoris';

  @override
  String get mark_special_focus => 'Marquer comme favori spécial';

  @override
  String get edit_btn => 'Modifier';

  @override
  String get load_gallery_failed => 'Échec du chargement de la galerie';

  @override
  String get traditional_chinese => 'Chinois traditionnel';

  @override
  String get all => 'Tout';

  @override
  String get official_recommendation => 'Recommandation officielle';

  @override
  String get my_exclusive => 'Mon exclusivité';

  @override
  String encounter_count(int count) {
    return '$count rencontres';
  }

  @override
  String get official => 'Officiel';

  @override
  String get private => 'Privé';

  @override
  String get first_encounter => 'Première rencontre';

  @override
  String char_exclusive_memory(String charName) {
    return 'Souvenir exclusif de $charName';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return 'L\'affection doit atteindre $affectionLevel pour débloquer ce souvenir !';
  }

  @override
  String get affection => 'Affection';

  @override
  String get unlock => 'Débloquer';

  @override
  String get change_chat_bg => 'Changer le fond du chat';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return 'Définir \"$cgDesc\" comme fond de chat avec $charName ?';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return 'Fond changé pour \"$cgDesc\"';
  }

  @override
  String get confirm_change => 'Confirmer';

  @override
  String get empty_treasure_box =>
      'La boîte à trésors est vide...\nAllez discuter pour trouver des secrets cachés !';

  @override
  String get unknown_story => 'Histoire inconnue';

  @override
  String get open_this_memory => 'Ouvrir ce souvenir';

  @override
  String get open_exclusive_story => 'Ouvrir l\'histoire exclusive';

  @override
  String confirm_use_egg(String eggTitle) {
    return 'Expérimenter \"$eggTitle\" maintenant ?\n\n(Cet objet est à usage unique et lancera automatiquement l\'histoire)';
  }

  @override
  String get wait_a_bit => 'Attendre';

  @override
  String guiding_into_story(String eggTitle) {
    return 'Guidage vers l\'histoire...';
  }

  @override
  String get use_now => 'Utiliser maintenant';

  @override
  String playback_failed_status(String statusCode) {
    return 'Échec de lecture, code : $statusCode';
  }

  @override
  String get playback_error => 'Erreur de lecture';

  @override
  String get unknown_contact => 'Contact inconnu';

  @override
  String call_memory_with(String charName) {
    return 'Souvenir d\'appel avec $charName';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return 'Débloqué avec l\'affection $affection';
  }

  @override
  String get no_call_record =>
      'Il ne semble y avoir aucun enregistrement de cette conversation...';

  @override
  String get me => 'Moi';

  @override
  String get playing => 'En cours de lecture...';

  @override
  String get listen => 'Écouter';

  @override
  String get no_exclusive_voice =>
      'Ce personnage n\'a pas encore de voix exclusive !';

  @override
  String get voice_download_success =>
      '✅ Données vocales téléchargées avec succès, préparation de la lecture...';

  @override
  String get onboarding_invitation => '— Invitation du Temps —';

  @override
  String get onboarding_welcome => 'Bienvenue dans Lian Lian Shi Guang';

  @override
  String get onboarding_quote =>
      '« Toute rencontre est de longues retrouvailles. »';

  @override
  String get onboarding_gift_title =>
      'Cadeau de première rencontre : 50 Fleurs';

  @override
  String get onboarding_gift_subtitle =>
      'Ces fleurs vous accompagneront pour commencer votre histoire avec lui.';

  @override
  String get onboarding_start_button => 'Commencez votre voyage dans le temps';

  @override
  String get onboarding_more_info => 'En savoir plus sur l\'histoire';

  @override
  String get legal_agreement_prefix => 'En continuant, vous acceptez nos';

  @override
  String get legal_terms_button => 'Conditions d\'utilisation';

  @override
  String get legal_and => ' et notre ';

  @override
  String get legal_privacy_button => 'Politique de confidentialité';

  @override
  String get call_memory_title => 'Souvenirs d\'Appels';

  @override
  String get please_login_first => 'Veuillez d\'abord vous connecter';

  @override
  String get no_call_memories =>
      'Aucun souvenir d\'appel enregistré pour le moment.\nMaximum de 10 enregistrements possibles.';

  @override
  String call_with_name(String name) {
    return 'Appel avec $name';
  }

  @override
  String call_duration(String time) {
    return 'Durée : $time';
  }

  @override
  String get delete_call_title => 'Supprimer l\'Appel';

  @override
  String delete_call_confirm(String name) {
    return 'Êtes-vous sûre de vouloir supprimer ce souvenir avec $name ?\n(Cette action est irréversible)';
  }

  @override
  String get keep_it => 'Garder';

  @override
  String get confirm_delete => 'Supprimer';

  @override
  String get press_mic_to_speak =>
      'Appuyez sur le micro pour commencer à parler...';

  @override
  String get call_ended => 'Appel terminé';

  @override
  String character_thinking(String name) {
    return '($name réfléchit...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name décroche...)';
  }

  @override
  String get call_interrupted_login =>
      '(Appel interrompu) Veuillez vous connecter d\'abord...';

  @override
  String get silence => '(Silence)';

  @override
  String get bad_signal => '(Signal faible...)';

  @override
  String get static_noise => '(Bruit statique)... on n\'entend pas bien...';

  @override
  String get type_message_hint => 'Tapez un message...';

  @override
  String get draft_saved_success =>
      'Brouillon enregistré en toute sécurité dans le Studio Secret !';

  @override
  String get draft_save_failed =>
      'Échec de l\'enregistrement, veuillez réessayer plus tard';

  @override
  String get draft_save_title => 'Enregistrer le brouillon ?';

  @override
  String get draft_save_content =>
      'Votre travail n\'a pas encore été publié. Voulez-vous d\'abord l\'enregistrer dans le Studio Secret ?';

  @override
  String get not_save => 'Ne pas enregistrer';

  @override
  String get save_draft => 'Enregistrer le brouillon';

  @override
  String confirm_delete_char_content(String name) {
    return 'Êtes-vous sûr de vouloir supprimer le personnage \"$name\" ?\n\nCette action est irréversible !';
  }

  @override
  String get char_deleted => 'Personnage supprimé';

  @override
  String get ok_button => 'D\'accord !';

  @override
  String get cannot_save_title => 'Impossible d\'enregistrer';

  @override
  String get cannot_save_content =>
      'Veuillez remplir le nom du personnage et télécharger au moins un avatar !';

  @override
  String get word_count_exceeded => 'Nombre de mots dépassé';

  @override
  String word_count_error_detail(String field, int limit) {
    return 'Le champ « $field » a dépassé la limite de $limit mots. Veuillez le raccourcir avant d\'enregistrer.';
  }

  @override
  String get content_missing => 'Contenu manquant';

  @override
  String get content_missing_personality =>
      'Veuillez remplir la « Personnalité détaillée » ! Écrivez au moins 10 mots.';

  @override
  String get content_missing_bg =>
      'La « Présentation du personnage » est trop courte ! Écrivez au moins 20 mots pour expliquer le contexte.';

  @override
  String get content_missing_tone =>
      'Veuillez définir le « Ton et habitudes », sinon il sera facile de sortir du personnage (OOC) !';

  @override
  String get user_not_found => 'Erreur : Utilisateur introuvable';

  @override
  String char_saved_success(String name, String action) {
    return 'Le personnage \"$name\" a été $action !';
  }

  @override
  String save_error_detail(String error) {
    return 'Échec de l\'enregistrement : $error';
  }

  @override
  String get easter_egg_add_title => 'Ajouter un Easter Egg caché';

  @override
  String get easter_egg_edit_title => 'Modifier l\'Easter Egg';

  @override
  String get keyword_label => 'Mot-clé de déclenchement (obligatoire)';

  @override
  String get keyword_hint =>
      'Par ex. : aller au parc d\'attractions, gâteau aux fraises';

  @override
  String get egg_title_label =>
      'Titre de l\'Easter Egg (visible par les joueurs)';

  @override
  String get egg_title_hint => 'Par ex. : Rendez-vous du week-end';

  @override
  String get egg_teaser_label => 'Bref aperçu (visible par les joueurs)';

  @override
  String get egg_teaser_hint => 'Décrivez le début de ce qui va se passer...';

  @override
  String get egg_scene_label => 'Changement de scène forcé (optionnel)';

  @override
  String get egg_scene_hint => 'Par ex. : Parc d\'attractions, Maison hantée';

  @override
  String get egg_prompt_label => 'Instruction de scénario';

  @override
  String get egg_prompt_hint =>
      'Comment jouer cette intrigue.\n(Système : La scène passe au parc d\'attractions, le personnage regarde (Nom du joueur) et sourit...)';

  @override
  String get confirm_button => 'Confirmer';

  @override
  String get keyword_empty_error => 'Le mot-clé ne peut pas être vide';

  @override
  String get voice_custom_title => 'Personnaliser une voix exclusive';

  @override
  String get voice_custom_hint => 'Par ex. : PDG autoritaire, chiot doux...';

  @override
  String get voice_generate_start => 'Commencer la génération';

  @override
  String get voice_bind_first =>
      'Veuillez d\'abord choisir et « lier » une voix exclusive !';

  @override
  String get voice_test_failed =>
      'Échec de l\'écoute : Veuillez cliquer sur « Je te choisis ! » pour lier officiellement la voix avant de faire des ajustements !';

  @override
  String voice_name_default(String name) {
    return 'Voix exclusive de $name';
  }

  @override
  String get voice_description_default =>
      'Il s\'agit d\'une voix unique créée pour un personnage exclusif dans « Lian Lian Shi Guang », sélectionnée et générée par le joueur.';

  @override
  String get voice_bind_failed =>
      'Échec de la liaison de la voix, veuillez vérifier le quota API ou l\'état du réseau';

  @override
  String voice_bind_success(String name) {
    return 'La voix de l\'âme de \"$name\" est officiellement liée !';
  }

  @override
  String get voice_bind_success_draft =>
      'Liaison de la voix réussie ! Vous pouvez maintenant déplacer le curseur pour tester les émotions !';

  @override
  String sync_failed(String error) {
    return 'Échec de la synchronisation, veuillez vérifier le réseau : $error';
  }

  @override
  String edit_character_title(String name) {
    return 'Modifier $name';
  }

  @override
  String get test_mode_tooltip => 'Test complet des fonctionnalités';

  @override
  String get test_mode_error =>
      '⚠️ Fichier du personnage introuvable ! Veuillez cliquer sur « Enregistrer/Publier » en bas avant de tester !';

  @override
  String get test_mode_notice =>
      '💡 Le mode test déduira des points selon le prix original de chaque mode et ne sera pas comptabilisé dans les souvenirs officiels !';

  @override
  String get delete_character_tooltip => 'Supprimer le personnage';

  @override
  String get tab_basic_story => 'Base et Intrigue';

  @override
  String get tab_voice => 'Voix exclusive';

  @override
  String get tab_relationship => 'Relations sociales';

  @override
  String get save_changes_button => 'Enregistrer les modifications';

  @override
  String get section_basic_info => 'Informations de base';

  @override
  String get hint_occupation =>
      'Prend en charge plusieurs identités, séparées par des barres ou des virgules (ex : Étudiant/Hacker)';

  @override
  String get hint_appearance =>
      'Par ex. : longs cheveux argentés, yeux ambrés, porte toujours une blouse blanche...';

  @override
  String get section_story_identity => '🎭 Intrigue et votre identité';

  @override
  String get story_identity_desc =>
      'Définissez l\'ouverture de l\'histoire et vos paramètres spéciaux dans cette sauvegarde';

  @override
  String get advanced_writing_tips_title =>
      '💡 Conseils d\'écriture avancés :\n';

  @override
  String get advanced_writing_tips_1 =>
      'Saisissez dans l\'histoire ou les répliques ';

  @override
  String get advanced_writing_tips_2 => '(Nom du joueur)';

  @override
  String get advanced_writing_tips_3 =>
      ', le système le remplacera automatiquement par le vrai pseudo du joueur pendant le jeu !\n';

  @override
  String get advanced_writing_tips_4 => 'Exemple : « ';

  @override
  String get advanced_writing_tips_5 => '(Nom du joueur)';

  @override
  String get advanced_writing_tips_6 => ', pourquoi es-tu arrivé si tard ? »';

  @override
  String get player_identity_label =>
      'Identité par défaut du joueur (Player Identity) - 💡 Optionnel';

  @override
  String get player_identity_hint =>
      '【Optionnel】Si vide, l\'IA lira votre « Profil » pour interagir.\nSi rempli, elle forcera une identité spécifique (ex : son système froid, ou sa femme trahie).';

  @override
  String get background_label => 'Contexte et Univers du personnage';

  @override
  String get background_hint =>
      'Décrivez son passé et l\'univers (ex : ville moderne, ABO, apocalypse). Par ex. : C\'est un monde infesté de zombies, et il est le soldat d\'élite qui vous protège...';

  @override
  String get story_summary_label => 'Résumé de l\'histoire en une phrase';

  @override
  String get story_initial_label => 'Histoire de la rencontre initiale';

  @override
  String get story_initial_hint =>
      'Par ex. : Vous poussez la porte et le voyez assis près de la fenêtre. Il se tourne et dit : « (Nom du joueur), viens ici. »...';

  @override
  String get first_line_label => 'Première réplique du personnage';

  @override
  String get first_line_hint => 'Par ex. : (Nom du joueur), tu es enfin là.';

  @override
  String get section_personality_evo =>
      '🌟 Évolution de la personnalité et de l\'affection';

  @override
  String get detailed_personality_label => 'Personnalité détaillée';

  @override
  String get detailed_personality_hint =>
      'Décrivez son caractère central. Par ex. : Tsundere, dur à l\'extérieur mais tendre à l\'intérieur. Froid avec les étrangers, ne sourit qu\'au joueur.';

  @override
  String get affection_evo_desc =>
      'L\'IA déterminera quand augmenter l\'affection selon ces paramètres :';

  @override
  String get stage_1_label => 'Étape 1 : Étranger/Méfiance (Lv1)';

  @override
  String get stage_1_hint =>
      'Réaction lors de la première rencontre. Conditions d\'affection (ex : politesse, respect de la vie privée).';

  @override
  String get stage_2_label => 'Étape 2 : Connaissance/Ami (Lv2)';

  @override
  String get stage_2_hint =>
      'Changements une fois familiarisés. Conditions d\'affection (ex : partager des bonbons, parler de chats).';

  @override
  String get stage_3_label => 'Étape 3 : Intime/Amant (Lv3)';

  @override
  String get stage_3_hint =>
      'Réaction après avoir succombé. Sera-t-il jaloux ? Ou boudera-t-il en silence ?';

  @override
  String get social_interaction_label =>
      'Interaction sociale et environnementale';

  @override
  String get social_interaction_hint =>
      'Par ex. : Comment traite-t-il les passants ? Comment réagit-il face à ce qu\'il déteste ?';

  @override
  String get section_habits => '🗣️ Goûts et habitudes';

  @override
  String get tone_hint_detail =>
      'Obligatoire. Par ex. : Parle brièvement, aime poser des questions. Son tic de langage est « idiot ». Interdiction d\'utiliser un style de traduction automatique.';

  @override
  String get dialogue_example_hint =>
      'Joueur : Je suis fatigué.\nPersonnage : (Caresse la tête) Sois sage, va te reposer vite.';

  @override
  String get section_easter_eggs => '🎁 Easter Eggs et Intrigues spéciales';

  @override
  String get no_easter_eggs =>
      'Aucun Easter Egg configuré, cliquez sur le bouton ci-dessous pour en ajouter';

  @override
  String get no_scene_change => 'Pas de changement de scène';

  @override
  String get add_easter_egg_button => 'Ajouter un Easter Egg caché';

  @override
  String get other_extra_info => 'Autres informations complémentaires';

  @override
  String get visibility_label => 'Visibilité du personnage';

  @override
  String get visibility_public => 'Public';

  @override
  String get visibility_private => 'Privé';

  @override
  String get section_voice_gen => '🎙️ Génération de sa voix exclusive';

  @override
  String get voice_gen_desc =>
      'Saisissez des mots-clés pour lui donner une voix unique au monde !\n(💡 Rappel : si vous n\'êtes pas satisfait, vous pouvez recommencer à tout moment !)';

  @override
  String get voice_generating_status => 'Préparation de la voix en cours...';

  @override
  String get voice_select_prompt =>
      '✨ J\'ai préparé trois types de voix pour vous, veuillez choisir :';

  @override
  String voice_sample_name(int index) {
    return 'Échantillon de voix $index';
  }

  @override
  String get voice_sample_desc =>
      'Cliquez sur la carte pour choisir, cliquez à droite pour écouter';

  @override
  String get voice_preparing => 'La voix est toujours en préparation...';

  @override
  String get voice_retry => 'Abandonner et réessayer';

  @override
  String get voice_confirm_selection => 'Je te choisis !';

  @override
  String get voice_bind_success_banner => 'Voix exclusive liée avec succès !';

  @override
  String get voice_remake => 'Refaire la voix';

  @override
  String get voice_btn_generating =>
      'Génération en cours, veuillez patienter...';

  @override
  String get voice_btn_generate => 'Saisir mots-clés pour générer la voix';

  @override
  String get voice_advanced_tuning =>
      '🎛️ Avancé : Ajuster l\'émotion de la voix';

  @override
  String get voice_stability_low => 'Sauvage/Souffle 🐺';

  @override
  String voice_stability_value(String value) {
    return 'Rationalité : $value';
  }

  @override
  String get voice_stability_high => 'Stable/Calme 🤖';

  @override
  String get voice_style_low => 'Froid/Réprimé 🧊';

  @override
  String voice_style_value(String value) {
    return 'Expression dramatique : $value';
  }

  @override
  String get voice_style_high => 'Exagéré/Passionné 🔥';

  @override
  String get voice_test_btn_testing => 'Application de l\'émotion...';

  @override
  String get voice_test_btn => 'Écouter l\'émotion actuelle';

  @override
  String get section_social_circle => '👥 Son cercle social';

  @override
  String get social_circle_desc =>
      'Définissez ses vues sur d\'autres personnages. S\'ils sont mentionnés en chat, il réagira selon ces réglages (ex : jalousie, colère).';

  @override
  String get social_no_drama =>
      'Pas de conflit avec d\'autres personnages masculins pour le moment...';

  @override
  String social_target(String name) {
    return 'Cible : $name';
  }

  @override
  String social_attitude(String attitude) {
    return 'Avis : $attitude';
  }

  @override
  String social_edit_title(String name) {
    return 'Modifier l\'avis sur $name 💬';
  }

  @override
  String get social_attitude_label => 'Son avis / Son attitude';

  @override
  String get social_attitude_hint =>
      'Par ex. : Le trouve agaçant, mais compte secrètement sur lui...';

  @override
  String get social_save_changes => 'Enregistrer les modifications';

  @override
  String get social_add_title => 'Ajouter une relation 🤝';

  @override
  String get social_select_target => 'Choisir une cible';

  @override
  String get social_thoughts_label => 'Ce qu\'il pense de cette personne...';

  @override
  String get social_thoughts_hint =>
      'Par ex. : Ce pianiste est trop bruyant...';

  @override
  String get social_add_confirm => 'Confirmer l\'ajout';

  @override
  String get gallery_load_failed =>
      'Échec du chargement de l\'image 🥲\nVérifiez votre réseau, si c\'est sur le Web, consultez la console.';

  @override
  String gallery_affection_req(int level) {
    return 'Affection $level';
  }

  @override
  String get gallery_upload_limit => 'Maximum 10 images autorisées';

  @override
  String get gallery_photo_setup => 'Conditions de déblocage de la photo';

  @override
  String get gallery_photo_desc_label => 'Qu\'est-ce que cette photo ?';

  @override
  String get gallery_photo_desc_hint =>
      'Par ex. : Photo en pyjama, photo de rendez-vous';

  @override
  String get gallery_photo_req_label => 'Niveau d\'affection requis ?';

  @override
  String get gallery_photo_req_hint => 'Saisissez un chiffre, 0 pour gratuit';

  @override
  String get gallery_cancel_upload => 'Annuler l\'envoi';

  @override
  String get gallery_confirm_add => 'Confirmer l\'ajout';

  @override
  String get default_photo_desc => 'Photo exclusive';

  @override
  String get draft_photo_desc => 'Photo de brouillon';

  @override
  String get loading_text => 'Chargement...';

  @override
  String get default_unnamed_character => 'Personnage sans nom';

  @override
  String elevenlabs_error(String code) {
    return 'Erreur ElevenLabs : $code';
  }

  @override
  String get voice_sample_script =>
      '(Se racle la gorge) Bonjour. C\'est un test de voix exclusif pour moi. Dans les jours à venir, je serai ici avec toi. Que tu sois heureux ou triste, tu peux tout partager avec moi. Ce rythme et ce timbre de voix te conviennent-ils ? Si tu aimes, fixons cette voix comme ma voix exclusive pour discuter avec toi. J\'attends avec impatience chacun de nos jours à venir.';

  @override
  String get voice_test_script =>
      'Que penses-tu de mon ton actuel ? Si cela te convient, fixons-le ainsi.';

  @override
  String get field_background => 'Contexte du personnage';

  @override
  String get field_tone => 'Ton et habitudes';

  @override
  String get field_initial_story => 'Histoire initiale';

  @override
  String get update_action => 'Mettre à jour';

  @override
  String get default_new_player => 'Nouveau joueur';

  @override
  String get translating_status => 'Traduction en cours...';

  @override
  String get translate_profile_btn => 'Traduire le contenu du profil';

  @override
  String translate_failed(String error) {
    return 'Échec de la traduction : $error';
  }

  @override
  String get like_own_char_warning =>
      'Vous ne pouvez pas aimer un personnage que vous avez créé ! 🤭';

  @override
  String get like_success_msg =>
      'Mention J\'aime envoyée ! Le créateur sera très heureux 💖';

  @override
  String get unlike_success_msg => 'Mention J\'aime retirée 💔';

  @override
  String get like_label => 'J\'aime';

  @override
  String get dislike_label => 'Je n\'aime pas';

  @override
  String get block_char => 'Bloquer ce personnage';

  @override
  String get char_blocked_msg => 'Ce personnage a été bloqué.';

  @override
  String get dislike_dialog_title => 'Vous n\'aimez pas ce personnage ?';

  @override
  String get dislike_dialog_subtitle =>
      'Dites-nous pourquoi en privé, nous allons examiner cela :';

  @override
  String get dislike_hint => 'Paramètres ennuyeux, images inappropriées...';

  @override
  String get dislike_thanks =>
      'Merci pour votre retour ! Nous avons reçu votre message privé.';

  @override
  String get dislike_submit => 'Envoyer discrètement';

  @override
  String get report_title => '📢 Signaler un commentaire';

  @override
  String get report_subtitle =>
      'Choisissez la raison du signalement :\nNous examinerons le contenu dès que possible.';

  @override
  String get report_opt_1 => 'Contenu pornographique ou violence graphique';

  @override
  String get report_opt_2 =>
      'Diffamation, insultes ou attaques contre le personnage';

  @override
  String get report_opt_3 => 'Discours de haine ou attaques personnelles';

  @override
  String get report_opt_4 => 'Spam ou publicité frauduleuse';

  @override
  String get report_opt_5 => 'Autre contenu inapproprié';

  @override
  String get report_confirm => 'Confirmer le signalement';

  @override
  String get report_success =>
      'Signalement réussi, notification reçue ! Le contenu sera examiné bientôt 🛡️';

  @override
  String get report_failed =>
      'Échec du signalement, veuillez vérifier votre connexion.';

  @override
  String get lore_delete_title => '⚠️ Avertissement : Effacer la mémoire';

  @override
  String get lore_delete_content =>
      'Une fois effacée, cette mémoire disparaîtra complètement. Êtes-vous sûr de vouloir l\'effacer ?';

  @override
  String get lore_delete_cancel => 'Annuler';

  @override
  String get lore_delete_confirm => 'Confirmer l\'effacement';

  @override
  String get lore_delete_success =>
      '🗑️ Fragment de mémoire complètement effacé.';

  @override
  String get lore_add_title => 'Écrire une nouvelle mémoire 🖋️';

  @override
  String get lore_edit_title => 'Modifier le fragment de mémoire 🖋️';

  @override
  String get lore_title_label => 'Titre de la mémoire';

  @override
  String get lore_title_hint =>
      'Ex : Le jour de pluie de notre première rencontre';

  @override
  String get lore_teaser_label => 'Résumé / Introduction';

  @override
  String get lore_teaser_hint => 'Courte description affichée sur la carte...';

  @override
  String get lore_content_label => 'Contenu complet de la mémoire';

  @override
  String get lore_content_hint =>
      'Écrivez ici l\'histoire détaillée ou le paramétrage...';

  @override
  String get lore_lock_label => '🔒 Sceller cette mémoire';

  @override
  String get lore_lock_desc =>
      'Si coché, seul le créateur pourra la voir ; les joueurs ne pourront pas y accéder';

  @override
  String get lore_empty_error =>
      'Le titre et le contenu ne peuvent pas être vides !';

  @override
  String get lore_add_success => '✨ Nouvelle mémoire scellée avec succès !';

  @override
  String get lore_publish => 'Publier la mémoire';

  @override
  String get lore_save_edit => 'Enregistrer les modifications';

  @override
  String lore_write_first(Object pronoun) {
    return 'Écrivez le premier souvenir pour $pronoun !';
  }

  @override
  String lore_waiting(Object pronoun) {
    return 'En attente de l\'histoire avec $pronoun...';
  }

  @override
  String get lore_sealed_msg =>
      '🔒 Cette mémoire est scellée et n\'est pas disponible actuellement.';

  @override
  String get lore_not_open_msg =>
      'Cette mémoire n\'est pas encore ouverte au public...';

  @override
  String get lore_unnamed => 'Fragment sans nom';

  @override
  String get lore_add_btn_limit =>
      'Écrire un nouveau fragment de mémoire (limite 10)';

  @override
  String get lore_collapse => 'Fermer la lettre';

  @override
  String get echo_delete_title => '🗑️ Supprimer le commentaire';

  @override
  String get echo_delete_content =>
      'Voulez-vous vraiment supprimer cet Écho temporel ?\nIl sera impossible de le récupérer !';

  @override
  String get echo_keep => 'Conserver';

  @override
  String get echo_clear_success => 'Écho temporel effacé 🧹';

  @override
  String get echo_energy_full_title => '⚠️ Énergie cosmique au maximum';

  @override
  String get echo_energy_full_content =>
      'Votre énergie temporelle a atteint sa limite (max 3). Supprimez d\'anciennes expériences pour ouvrir de nouveaux registres cosmiques !';

  @override
  String get echo_write_title => 'Laissez votre Écho Temporel 🌌';

  @override
  String get echo_write_subtitle =>
      'Écrivez votre expérience ou des citations inspirantes ici !';

  @override
  String get echo_hint =>
      '「Même si c\'est la fin du monde, je prioriserai ta respiration...」';

  @override
  String get echo_theme_label => 'Choisissez le bord de la note :';

  @override
  String get theme_butterfly => 'Papillon';

  @override
  String get theme_sprout => 'Jeune pousse';

  @override
  String get theme_star => 'Ciel étoilé';

  @override
  String get theme_planet => 'Planète';

  @override
  String get echo_publish_btn => 'Publier le registre temporel';

  @override
  String get echo_wall_title => 'Mur des Échos Temporels';

  @override
  String get echo_leave_memory => 'Laisser une expérience';

  @override
  String get echo_empty_msg =>
      'Aucun voyageur temporel n\'a encore laissé de trace...\nVoulez-vous être le premier ?';

  @override
  String get creator_label => 'Créateur';

  @override
  String get follow_btn => 'Suivre';

  @override
  String get followed_btn => 'Suivi';

  @override
  String get follow_own_warning =>
      'Les créateurs ne peuvent pas se suivre eux-mêmes ! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName a suivi $creatorName !';
  }

  @override
  String get mailbox_follow_title => 'Nouveau gardien obtenu 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName vient de vous suivre !';
  }

  @override
  String get tab_private_profile => 'Profil privé';

  @override
  String get tab_memory_fragments => 'Fragments de mémoire';

  @override
  String get tab_time_echoes => 'Échos temporels';

  @override
  String get chat_free_btn => 'Chat (Gratuit)';

  @override
  String get start_story_btn => 'Démarrer l\'histoire';

  @override
  String get default_chat_initial => 'Tu as besoin de moi ?';

  @override
  String get gallery_title => 'Fond d\'appel exclusif';

  @override
  String gallery_current_affection(String value) {
    return 'Niveau d\'affection actuel : $value 💕';
  }

  @override
  String get gallery_empty => 'Aucune photo dans l\'album pour l\'instant';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'Arrière-plan réglé sur « $desc » !';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'Atteignez un niveau d\'affection de $value pour débloquer ! 🍃';
  }

  @override
  String get gallery_reset_bg => 'Fond d\'appel par défaut restauré';

  @override
  String get background_story_title => 'Histoire de fond';

  @override
  String get background_story_empty =>
      'Ce personnage est mystérieux ; il n\'y a pas encore d\'histoire de fond...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'Vous suivez maintenant $creatorName 🦋';
  }

  @override
  String get mailbox_title => 'Boîte aux lettres exclusive 💌';

  @override
  String get mailbox_empty =>
      'La boîte aux lettres est vide. Allez publier quelque chose pour l\'attirer !';

  @override
  String get new_notification => 'Nouvelle notification';

  @override
  String get default_he => 'Il';

  @override
  String affection_upgrade_title(String charName) {
    return 'L\'affection de $charName pour vous a augmenté ! 💖';
  }

  @override
  String get flower_reward => '🌸 5 points fleurs obtenus';

  @override
  String get affection_quote_lv5 =>
      '« Je ne m\'attendais pas... à ce que tu deviennes si importante pour moi. Si importante que... je ne peux imaginer un monde sans toi. »';

  @override
  String get affection_quote_lv4 =>
      '« La chose la plus chanceuse de ma vie, c\'est probablement ce jour-là, quand je me suis retourné et que je t\'ai vue. »';

  @override
  String get affection_quote_lv3 =>
      '« Récemment... j\'ai remarqué que je rêvassais de plus en plus, et ma tête est entièrement remplie de toi. »';

  @override
  String get affection_quote_lv2 =>
      '« Puisque c\'est ton invitation, je suppose que je pourrais libérer un peu de temps, ce n\'est pas impossible. »';

  @override
  String get affection_quote_lv1 =>
      '« Je te vois souvent ces derniers temps, et je sens... que je ne déteste pas cette fréquence de rencontres. »';

  @override
  String get affection_quote_lv0 =>
      '« Alors tu es là aussi. Serait-ce une sorte de destin curieux ? »';

  @override
  String get lore_edit_success =>
      '✨ Fragment de mémoire mis à jour avec succès !';

  @override
  String get delete_failed_network =>
      'Échec de la suppression, veuillez vérifier le réseau ou les permissions.';

  @override
  String get ai_chat_language => 'Français';

  @override
  String get ai_chat_language_code => 'fr-FR';

  @override
  String get chat_home_title => 'Messages';

  @override
  String get call_memory_tooltip => 'Souvenirs d\'appels';

  @override
  String get login_to_view_chat =>
      'Veuillez vous connecter pour voir l\'historique';

  @override
  String load_chat_failed(String error) {
    return 'Échec du chargement de la liste : $error';
  }

  @override
  String get chat_list_empty => 'La liste est vide...';

  @override
  String get go_to_encounter =>
      'Allez dans \"Rencontre\" pour trouver quelqu\'un à qui parler !';

  @override
  String confirm_delete_chat(String charName) {
    return 'Supprimer la conversation avec $charName ?';
  }

  @override
  String affection_score_short(String score) {
    return 'Affection $score';
  }

  @override
  String get character_not_found =>
      'Données introuvables, le personnage a peut-être été supprimé.';

  @override
  String get preparing_chat_room =>
      'Préparation de votre salon de discussion exclusif...';

  @override
  String get rename_chat_title => 'Nommer ce souvenir';

  @override
  String get rename_chat_hint =>
      'Ex : (Cheng Yu) devient (Compte à rebours divorce)';

  @override
  String get save_tag_btn => 'Enregistrer l\'étiquette';

  @override
  String get room_name_updated => 'Nom de la salle mis à jour !';

  @override
  String update_failed(String error) {
    return 'Échec de la mise à jour : $error';
  }

  @override
  String get chat_mode_daily => 'Quotidien';

  @override
  String get chat_mode_story => 'Histoire';

  @override
  String get chat_mode_immersive => 'Immersif';

  @override
  String get chat_mode_gemini => 'Discussion';

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
      'Données du personnage introuvables. Veuillez revenir en arrière ou vérifier votre connexion.';

  @override
  String get chat_jump_success => 'Passage à ce souvenir 🍃';

  @override
  String get chat_create_room_failed =>
      'La connexion semble instable. Échec de la création du salon, veuillez réessayer.';

  @override
  String get chat_secret_file_title => '🔒 Fichier Confidentiel';

  @override
  String get chat_secret_file_desc =>
      'Le fichier d\'âme de ce personnage a été archivé ou défini comme privé. Les détails sont temporairement indisponibles.';

  @override
  String get chat_understood => 'Compris';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ Nouveau souvenir obtenu : $title';
  }

  @override
  String get chat_egg_saved =>
      'Ajouté automatiquement à votre sac à dos exclusif';

  @override
  String get chat_points_not_enough_title => 'Fleurs insuffisantes';

  @override
  String get chat_points_not_enough_desc =>
      'Vous n\'avez pas assez de Fleurs ! Veuillez passer à la boutique pour recharger.';

  @override
  String chat_call_confirm_title(String name) {
    return 'Appeler $name ?';
  }

  @override
  String get chat_call_rule_1 => 'Chaque appel consomme 20 Fleurs';

  @override
  String get chat_call_rule_2 =>
      'L\'appel dure 1 minute. Si vous ne pouvez pas parler, communiquez par texte';

  @override
  String get chat_call_rule_3 =>
      'Le port d\'un casque est recommandé pour mieux entendre sa voix ✨';

  @override
  String get chat_call_btn_cancel => 'Pas maintenant';

  @override
  String get chat_call_pref_title => 'Réglez vos préférences d\'appel';

  @override
  String get chat_call_lang_select => 'Choisir la langue de l\'appel';

  @override
  String get chat_call_save_memory => 'Sauvegarder ce souvenir d\'appel';

  @override
  String get chat_call_save_memory_desc =>
      'Vous pourrez le réécouter après la fin de l\'appel';

  @override
  String get chat_call_btn_start => 'Démarrer l\'appel';

  @override
  String chat_points_shortage(String points) {
    return 'Points Fleurs insuffisants ! Vous avez $points points';
  }

  @override
  String get chat_room_not_ready =>
      'Le salon n\'est pas prêt, veuillez y entrer à nouveau.';

  @override
  String get chat_stop_generating_msg =>
      'Réponse arrêtée, aucun point n\'a été déduit 🍃';

  @override
  String get chat_heartbeat_up => 'Son cœur s\'emballe...';

  @override
  String get chat_heartbeat_down => 'Son regard est devenu froid...';

  @override
  String get chat_msg_copy => 'Copier le contenu';

  @override
  String get chat_msg_copied => 'Copié dans le presse-papiers !';

  @override
  String get chat_msg_report => 'Signaler ce message';

  @override
  String get chat_msg_suggest => 'Donner un conseil';

  @override
  String get chat_report_title => 'Signaler cette conversation';

  @override
  String get chat_report_lang => 'Langue étrangère apparue';

  @override
  String get chat_report_inapp => 'Réponse inappropriée';

  @override
  String get chat_report_context => 'Le contexte n\'est pas lié';

  @override
  String get chat_report_other => 'Autres raisons';

  @override
  String get chat_report_hint => 'Veuillez décrire le problème rencontré...';

  @override
  String get chat_report_submit => 'Envoyer';

  @override
  String get chat_report_success =>
      '✅ Signalement envoyé, nous ajusterons dès que possible';

  @override
  String get chat_suggest_title => 'Donner des suggestions';

  @override
  String get chat_suggest_hint => 'Veuillez écrire vos précieux conseils...';

  @override
  String get chat_suggest_success =>
      '💖 Merci pour vos suggestions, nous les traiterons dès que possible';

  @override
  String get chat_del_warn =>
      'Les messages ne peuvent pas être récupérés après suppression.';

  @override
  String get chat_reset_title => 'Réinitialiser la mémoire';

  @override
  String get chat_reset_desc =>
      'Veuillez choisir le degré de réinitialisation :\n\n1. [Chat uniquement] : Efface l\'historique mais garde l\'affection.\n2. [Réinitialisation totale] : Tout revient à zéro, comme à la première rencontre.';

  @override
  String get chat_reset_only_chat => 'Historique de discussion uniquement';

  @override
  String get chat_reset_full => 'Réinitialisation totale';

  @override
  String get chat_reset_full_msg =>
      'Tout est revenu au début, il ne se souvient plus de vous...';

  @override
  String get chat_reset_chat_msg =>
      'Discussion effacée, mais son amour pour vous demeure.';

  @override
  String get chat_edit_ai_hint => 'Modifier sa réponse...';

  @override
  String get chat_edit_user_hint => 'Veuillez saisir le nouveau contenu...';

  @override
  String chat_no_voice_msg(String name) {
    return 'Il n\'y a pas encore de voix pour $name...';
  }

  @override
  String get chat_poke_btn => 'Pousser';

  @override
  String get chat_poke_success =>
      '✨ Nous avons poussé le créateur pour vous ! Sa voix sera bientôt disponible~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'Points Fleurs insuffisants ! Besoin de $cost points 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ Âme Sœur ✨';

  @override
  String get chat_levelup_normal => 'Niveau de relation augmenté ! 💖';

  @override
  String get chat_levelup_btn_soulmate => 'Graver dans l\'âme';

  @override
  String get chat_levelup_btn_normal => 'Accepter avec émotion';

  @override
  String get chat_loc_title => '📍 Envoyer une position virtuelle';

  @override
  String get chat_loc_custom_btn => 'Envoyer une position personnalisée';

  @override
  String get chat_loc_hint => 'Saisir un autre lieu... (Ex : Dans ton cœur)';

  @override
  String get chat_loc_1 => 'En bas de chez toi';

  @override
  String get chat_loc_2 => 'À l\'école';

  @override
  String get chat_loc_3 => 'Au café où nous venons de passer';

  @override
  String get chat_loc_4 => 'Au magasin de proximité';

  @override
  String get chat_interact_title => '✨ Que voulez-vous lui faire ?';

  @override
  String get chat_interact_action => 'Petites touches et gestes';

  @override
  String get chat_interact_gift =>
      'Lui envoyer un cadeau (consomme des Fleurs 🌸)';

  @override
  String get chat_action_poke => 'Pincer les joues';

  @override
  String get chat_action_hug => 'Demander un câlin';

  @override
  String get chat_action_hand => 'Prendre la main secrètement';

  @override
  String get chat_dice_btn => 'Lancer le dé';

  @override
  String get chat_loading_failed =>
      'Échec du chargement, veuillez revenir en arrière et réessayer.';

  @override
  String get chat_test_mode_msg =>
      'Mode test activé, discutez librement ! (Les messages ne seront pas sauvés)';

  @override
  String get chat_empty_msg => 'Commencez un voyage passionnant avec lui !';

  @override
  String get chat_ai_typing => 'Il répond...';

  @override
  String get chat_input_hint_default => 'Que voulez-vous lui dire...';

  @override
  String get chat_typing_indicator => 'En train d\'écrire...';

  @override
  String get chat_menu_search => 'Rechercher une discussion';

  @override
  String get chat_menu_gallery => 'Souvenirs et fonds exclusifs';

  @override
  String get chat_menu_aboutme => 'À propos de moi';

  @override
  String get chat_menu_memo => 'Note pour lui';

  @override
  String get chat_menu_period => 'Suivi du cycle';

  @override
  String get chat_menu_reset => 'Réinitialiser la mémoire';

  @override
  String get chat_search_hint =>
      'Quelle discussion douce voulez-vous revivre ?';

  @override
  String get chat_search_empty => 'Souvenir introuvable 🥺';

  @override
  String get chat_search_you => 'Vous avez dit';

  @override
  String get chat_search_him => 'Il a dit';

  @override
  String get chat_tool_backpack => 'Sac à dos';

  @override
  String get chat_tool_story => 'Résumé de l\'intrigue';

  @override
  String get chat_tool_photo => 'Photos';

  @override
  String get chat_tool_record => 'Enregistrement';

  @override
  String get chat_tool_profile => 'Dossiers ShiGuang';

  @override
  String get chat_tool_interact => 'Interactions';

  @override
  String get chat_record_recording => 'Enregistrement...';

  @override
  String get chat_record_start => 'Appuyez sur le micro pour enregistrer';

  @override
  String get chat_record_done => 'Enregistrement terminé';

  @override
  String get chat_mode_daily_desc =>
      'Discussion quotidienne légère, comme entre amis !';

  @override
  String get chat_mode_story_desc =>
      'Progression de l\'intrigue comme dans un roman.';

  @override
  String get chat_mode_immersive_desc =>
      'Expérience sensorielle ultime, interaction profonde sans limite.';

  @override
  String get chat_switch_mode_title => 'Changer le mode de chat';

  @override
  String get chat_voice_call => 'Appel vocal';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '[Événement Système] $playerName a envoyé un [$giftName].';
  }

  @override
  String get rel_title_soulmate => 'Âme sœur/Amour profond';

  @override
  String get rel_title_lover => 'Passion/Petit ami exclusif';

  @override
  String get rel_title_ambiguous => 'Phase ambiguë/Se tester mutuellement';

  @override
  String get rel_title_friend => 'Ami ordinaire/Affection naissante';

  @override
  String get rel_title_acquaintance => 'Connaissance/Visage familier';

  @override
  String get rel_title_stranger => 'Inconnu/Première rencontre';

  @override
  String get rel_title_tense => 'Relation tendue/Agacement';

  @override
  String get rel_title_avoiding => 'Comme des étrangers/Évitement délibéré';

  @override
  String get rel_title_hostile => 'Dégoût extrême/Hostilité froide';

  @override
  String get rel_title_nemesis => 'Ennemis jurés/Ne plus jamais se revoir';

  @override
  String get rel_msg_soulmate =>
      '« Je ne m\'attendais pas... à ce que tu deviennes si importante pour moi. Si importante que... je ne peux imaginer un monde sans toi. »';

  @override
  String get rel_msg_lover =>
      '« La chose la plus chanceuse de ma vie, c\'est probablement ce jour-là, quand je me suis retourné et que je t\'ai vue. »';

  @override
  String get rel_msg_ambiguous =>
      '« Récemment... j\'ai remarqué que je rêvassais de plus en plus, et ma tête est entièrement remplie de toi. »';

  @override
  String get rel_msg_friend =>
      '« Puisque c\'est ton invitation, je suppose que je pourrais libérer un peu de temps, ce n\'est pas impossible. »';

  @override
  String get rel_msg_acquaintance =>
      '« Je te vois souvent ces derniers temps, et je sens... que je ne déteste pas cette fréquence de rencontres. »';

  @override
  String get rel_msg_stranger =>
      '« Alors tu es là aussi. Serait-ce une sorte de destin curieux ? »';

  @override
  String chat_edit_char_count(String count) {
    return '$count car.';
  }

  @override
  String get chat_mysterious_player => 'Joueur mystérieux';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return 'Le joueur $playerName a hâte d\'entendre la voix de $characterName, allez la générer !';
  }

  @override
  String get gift_heart => 'Cœur';

  @override
  String get gift_flower => 'Fleur';

  @override
  String get gift_sun => 'Soleil';

  @override
  String get gift_confetti => 'Confettis';

  @override
  String get gift_coffee => 'Café';

  @override
  String get gift_cake => 'Gâteau';

  @override
  String get chat_action_poke_prompt =>
      '(Le joueur tend soudainement la main et vous pince la joue malicieusement)';

  @override
  String get chat_action_hug_prompt =>
      '(Le joueur écarte les bras d\'un air penaud, demandant un câlin chaleureux)';

  @override
  String get chat_action_hand_prompt =>
      '(Le joueur vous prend discrètement la main sous la table)';

  @override
  String get chat_menu_send_location => 'Envoyer une position virtuelle';

  @override
  String get weekday_mon => '(Lun)';

  @override
  String get weekday_tue => '(Mar)';

  @override
  String get weekday_wed => '(Mer)';

  @override
  String get weekday_thu => '(Jeu)';

  @override
  String get weekday_fri => '(Ven)';

  @override
  String get weekday_sat => '(Sam)';

  @override
  String get weekday_sun => '(Dim)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ Nouveau souvenir obtenu : $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'Ajouté automatiquement à son sac à dos exclusif';

  @override
  String get chat_profile_updated_msg =>
      'Dossier ShiGuang mis à jour ! Il se souviendra de vos derniers réglages 🍃';

  @override
  String get comment_loading_author => 'Chargement...';

  @override
  String comment_post_failed(String error) {
    return 'Échec du commentaire, vérifiez votre connexion : $error';
  }

  @override
  String get comment_delete_confirm_desc =>
      'Voulez-vous vraiment supprimer définitivement ce commentaire ?';

  @override
  String get comment_delete_failed =>
      'Échec de la suppression, vérifiez votre connexion réseau';

  @override
  String get comment_identity_title => 'Choisir l\'identité';

  @override
  String get comment_identity_myself => 'Moi-même';

  @override
  String get comment_report_title => 'Confirmer le signalement';

  @override
  String get comment_report_rules_title =>
      '⚖️ Règles de signalement des commentaires';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ 1ère infraction : Avertissement du système et enregistrement d\'une infraction.\n2️⃣ 2ème infraction : Interdiction de commenter pendant 1 jour.\n3️⃣ Récidive : Fonction de signalement désactivée pendant 14 jours et visibilité réduite.\n\n🚨 Cas de malveillance grave :\nInteraction avec les personnages interdite pendant 1 jour, et l\'ID sera affiché sur le tableau pendant 3 jours (interdiction de changer d\'ID pendant cette période).\n\n💡 Une fois le signalement envoyé, le résultat final vous sera transmis via [Messagerie du jeu].\nMerci de vous respecter et de signaler de manière rationnelle.';

  @override
  String get comment_report_understood => 'J\'ai compris';

  @override
  String get comment_report_confirm_desc =>
      'Voulez-vous vraiment signaler ce commentaire ?\nTout signalement abusif pourra être sanctionné.';

  @override
  String get comment_report_submit_btn => 'Confirmer le signalement';

  @override
  String get comment_report_success =>
      'Merci pour votre signalement, nous allons vérifier dès que possible !';

  @override
  String get comment_report_failed =>
      'Échec de l\'envoi du signalement, veuillez réessayer plus tard.';

  @override
  String get comment_option_delete => 'Supprimer le commentaire';

  @override
  String get comment_option_report => 'Signaler le commentaire';

  @override
  String comment_time_days_ago(String days) {
    return 'Il y a $days jours';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return 'Il y a $hours heures';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return 'Il y a $mins minutes';
  }

  @override
  String get comment_time_just_now => 'À l\'instant';

  @override
  String get comment_sheet_title => 'Commentaires';

  @override
  String get comment_empty_state =>
      'Aucun commentaire pour l\'instant, soyez le premier !';

  @override
  String get comment_reply_btn => 'Répondre';

  @override
  String comment_replying_to(String name) {
    return 'Réponse à @$name';
  }

  @override
  String comment_input_hint(String name) {
    return 'Commenter en tant que $name...';
  }

  @override
  String char_story_expect(String pronoun) {
    return 'Hâte de découvrir l\'histoire avec $pronoun...';
  }

  @override
  String get common_update_failed =>
      'Échec de la mise à jour, veuillez vérifier le réseau';

  @override
  String get char_edit_fragment => 'Modifier le fragment';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 N\'aime pas : $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 Aime : $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age ans | $job';
  }

  @override
  String get common_got_it => 'Compris';

  @override
  String get common_add_failed =>
      'Échec de l\'ajout, veuillez vérifier le réseau';

  @override
  String common_delete_failed_with_err(String error) {
    return 'Échec de la suppression, veuillez vérifier l\'état du réseau : $error';
  }

  @override
  String get char_exclusive_guardian => 'Gardien exclusif 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName a aimé $charName !';
  }

  @override
  String chat_translation_prefix(String content) {
    return '[Trad] $content (Ceci est le contenu émotionnel traduit)';
  }

  @override
  String get player_default_nickname => 'Voyageur';

  @override
  String get moment_create_title => 'Créer une nouvelle publication';

  @override
  String get moment_create_post_btn => 'Publier';

  @override
  String get moment_create_hint => 'Partagez quelque chose de nouveau...';

  @override
  String get moment_create_error_empty =>
      'Au moins du texte ou une image est requis !';

  @override
  String get moment_create_error_failed =>
      'Échec de la publication, veuillez réessayer plus tard';

  @override
  String get moment_create_visibility_public => 'Public (Visible par tous)';

  @override
  String get moment_create_visibility_private =>
      'Privé (Visible uniquement par les amis)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (Le joueur a envoyé une position : $location)';
  }

  @override
  String get chat_you => 'Toi';

  @override
  String get chat_opponent => 'Adversaire';

  @override
  String chat_dice_duel_result(String name) {
    return '[Événement Système] Duel de dés avec $name ! Le résultat est tombé...';
  }

  @override
  String get chat_loading_status => 'Chargement en cours...';

  @override
  String chat_error_load_msg(String error) {
    return 'Échec du chargement du message : $error';
  }

  @override
  String get chat_voice_msg_label => 'Message vocal';

  @override
  String chat_special_story_trigger(String title) {
    return '[Histoire spéciale débloquée : $title]';
  }

  @override
  String common_edit_failed(String error) {
    return 'Échec de la modification : $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'Échec de la réinitialisation : $error';
  }

  @override
  String get chat_default_greeting => 'Bonjour...';

  @override
  String get chat_memory_cleared => 'Mémoire entièrement effacée';

  @override
  String get chat_history_reset => 'Conversation réinitialisée';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 [ Dossier ShiGuang Exclusif - $name ]\n━━━━━━━━━━━━━━━━━━\n🔹 Nom : $identity\n🔹 Anniversaire : $birthday\n🔹 Taille : $height\n🔹 Apparence : $appearance\n🔹 Profession : $job\n\n📖 [ À propos des fragments de son âme ]\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 [ Dossier ShiGuang Exclusif ]\n━━━━━━━━━━━━━━━━━━\n🔹 Nom : $nickname\n🔹 Anniversaire : $birthday\n\n🔒 Les autres données du personnage ne sont pas encore débloquées...\n(Remplissez le profil complet pour qu\'il vous connaisse mieux dans l\'univers parallèle ! ✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => 'Fichier sans nom';

  @override
  String get chat_default_player_name => 'Joueur';

  @override
  String get error_system_confusion =>
      'Le système est un peu confus, veuillez réessayer.';

  @override
  String get error_msg_send_failed =>
      'Échec de l\'envoi du message, veuillez réessayer.';

  @override
  String get error_system_busy =>
      'Système occupé, veuillez réessayer plus tard.';

  @override
  String get error_network_unavailable =>
      'Connexion impossible pour le moment, veuillez réessayer.';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 Appel terminé, vous avez parlé avec $name pendant $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return 'Histoire exclusive : $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'C\'est un souvenir caché exclusif à vous et $name...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return 'Un souvenir exclusif sur « $keyword » s\'est discrètement débloqué...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '[Événement caché déclenché : $title]\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......(Il vous regarde silencieusement, semblant attendre que vous parliez en premier)';

  @override
  String get chat_new_room_created => 'Nouveau salon de discussion créé';

  @override
  String portfolio_title(String nickname) {
    return 'Portfolio de $nickname';
  }

  @override
  String get enter_secret_studio => 'Entrer dans mon studio secret';

  @override
  String get no_public_character_mine =>
      'Vous n\'avez pas encore publié de personnage public !\nAllez au studio pour en créer un ✨';

  @override
  String get no_public_character_other =>
      'Ce créateur n\'a pas encore publié de personnage...';

  @override
  String get delete_draft_title => 'Supprimer le brouillon';

  @override
  String get confirm_delete_draft_msg =>
      'Voulez-vous vraiment supprimer ce personnage inachevé ?\n(Action irréversible après suppression)';

  @override
  String get draft_cleared_success => 'Brouillon effacé avec succès 🧹';

  @override
  String get login_required_for_studio =>
      'Veuillez vous connecter pour entrer dans le studio !';

  @override
  String get my_secret_studio_title => 'Mon studio secret 🛠️';

  @override
  String get create_new_character_btn => 'Créer un nouveau personnage';

  @override
  String get unnamed_draft => 'Brouillon sans nom';

  @override
  String get click_to_edit_story =>
      'Cliquez pour continuer à éditer son histoire...';

  @override
  String get label_draft => 'Brouillon';

  @override
  String get studio_empty_title => 'Le studio est actuellement vide';

  @override
  String get studio_empty_subtitle =>
      'Cliquez dans le coin inférieur pour commencer à créer votre premier personnage !';

  @override
  String get common_no_changes => 'Aucune modification';

  @override
  String get moment_updated_success => 'Publication mise à jour !';

  @override
  String common_save_failed(String error) {
    return 'Échec de l\'enregistrement : $error';
  }

  @override
  String get moment_edit_title => 'Modifier la publication';

  @override
  String get action_change_image => 'Changer l\'image';

  @override
  String get action_remove_image => 'Supprimer l\'image';

  @override
  String get moment_delete_confirm_title =>
      'Voulez-vous vraiment supprimer cette publication ?';

  @override
  String get moment_delete_confirm_content =>
      'Une fois supprimé, ce souvenir de vos Moments disparaîtra !';

  @override
  String get action_confirm_delete => 'Confirmer la suppression';

  @override
  String get friend_unknown => 'Un ami';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname a adoré votre publication ! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname trouve que $authorName est charmant et a laissé un j\'aime ! ✨';
  }

  @override
  String get moment_like_success => 'Votre coup de cœur a été transmis ! ✨';

  @override
  String get moment_notification_new_like => 'Nouveau j\'aime ! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname a mentionné @$name dans une publication ! ✨';
  }

  @override
  String get moment_detail_title => 'Détails de la publication';

  @override
  String get moment_not_found => 'Cette publication semble avoir disparu... 😢';

  @override
  String get moment_comment_title => 'Commentaires des Moments';

  @override
  String get moment_comment_empty =>
      'Personne n\'a encore commenté, soyez la première ! 🛋';

  @override
  String moment_replying_to(String name) {
    return 'En réponse à @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return 'Répondre à @$name...';
  }

  @override
  String get moment_leave_comment_hint => 'Laissez votre réponse...';

  @override
  String get moment_delete_permanent_confirm =>
      'Cette publication sera définitivement supprimée. Êtes-vous sûr ?';

  @override
  String get moment_action_delete => 'Supprimer la publication';

  @override
  String get moment_action_report => 'Signaler cette publication';

  @override
  String get moment_action_share => 'Partager cette publication';

  @override
  String get moment_forward_hint =>
      'Transférer cette publication à un personnage...';

  @override
  String moment_reply_private(String name) {
    return 'Réponse privée à $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return 'Allons discuter avec $name avec cette publication ! 💬';
  }

  @override
  String get moment_share_to_apps => 'Partager vers d\'autres applications';

  @override
  String moment_likes_label(String count) {
    return '$count Feuilles';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】Venez voir la publication de $author : $content\n\nTéléchargez maintenant pour commencer vos moments exclusifs : $appLink';
  }

  @override
  String get moment_forward_title =>
      'Transférer au personnage avec qui vous discutez 💌';

  @override
  String get moment_forward_empty_state =>
      'Vous n\'avez pas encore de discussions actives !\nAllez au Hall pour trouver quelqu\'un de spécial 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【Publication transférée】\nAuteur : $author\nContenu : $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ Partagé discrètement avec $name !';
  }

  @override
  String get action_send => 'Envoyer';

  @override
  String get memo_delete_confirm =>
      'Voulez-vous vraiment supprimer ce mémo ? Cette action est irréversible.';

  @override
  String get memo_add_title => 'Ajouter un mémo';

  @override
  String get memo_edit_title => 'Modifier le mémo';

  @override
  String memo_hint_text(String name) {
    return 'Que voulez-vous noter à propos de $name ?';
  }

  @override
  String get memo_label_reminder_date => 'Date de rappel :';

  @override
  String get memo_action_save => 'Enregistrer le mémo';

  @override
  String get memo_error_empty_content => 'Le contenu ne peut pas être vide !';

  @override
  String memo_list_title(String name) {
    return 'Mémos avec $name';
  }

  @override
  String get memo_empty_state =>
      'Aucun mémo pour l\'instant !\nCliquez en haut à droite pour en ajouter un !';

  @override
  String memo_reminder_date_display(String date) {
    return 'Date de rappel : $date';
  }

  @override
  String get daily_gift_title => 'Cadeau quotidien du temps';

  @override
  String daily_login_welcome(String appName, String amount) {
    return 'Bon retour sur $appName !\nConnectez-vous aujourd\'hui pour obtenir $amount points de Langage des Fleurs. 🌸';
  }

  @override
  String get title_daily_check_in => 'Pointage quotidien';

  @override
  String success_claim_reward(String amount) {
    return 'Vous avez reçu $amount points de Langage des Fleurs ! 🌸';
  }

  @override
  String get error_claim_failed =>
      'Échec de la réception, veuillez vérifier votre connexion et réessayer.';

  @override
  String get action_claim_now => 'Récupérer maintenant';

  @override
  String get common_or => 'ou';

  @override
  String get title_language_settings => 'Paramètres de langue';

  @override
  String get app_name => 'Lianlian Shiguang';

  @override
  String get login_slogan => 'Commencez vos moments exclusifs';

  @override
  String get login_with_google => 'Se connecter avec Google';

  @override
  String get login_with_apple => 'Se connecter avec Apple';

  @override
  String get login_with_facebook => 'Se connecter avec Facebook';

  @override
  String get login_with_email =>
      'Se connecter avec le compte Lianlian (E-mail)';

  @override
  String get title_contact_us_heading =>
      'Nous accordons une grande importance à vos suggestions !';

  @override
  String get desc_contact_us_body =>
      'Veuillez écrire vos idées ici pour nous aider à améliorer le jeu.';

  @override
  String get error_feedback_empty =>
      'Le contenu de la suggestion ne peut pas être vide !';

  @override
  String get email_subject_feedback =>
      'Lianlian Shiguang - Retours des joueurs';

  @override
  String get msg_email_app_not_found_copied =>
      'Impossible d\'ouvrir l\'application de messagerie automatiquement, l\'e-mail officiel a été copié pour vous !';

  @override
  String get title_contact_us => 'Nous contacter';

  @override
  String get desc_contact_us =>
      'Nous accordons une grande importance à vos suggestions !\nVeuillez écrire vos idées ici pour nous aider à améliorer le jeu.';

  @override
  String get hint_enter_feedback => 'Veuillez saisir votre suggestion ici...';

  @override
  String get action_send_via_email => 'Envoyer par e-mail';
}
