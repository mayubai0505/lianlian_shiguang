// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get changeTheme => 'Change Theme';

  @override
  String get feedback => 'Feedback';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get allFriendsTitle => 'All Friends';

  @override
  String get noFriendsMessage => 'You don\'t have any friends yet.';

  @override
  String get unknownCharacter => 'Unknown Character';

  @override
  String errorLoadingFriends(String error) {
    return 'Error loading friends list: $error';
  }

  @override
  String get tagGentle => 'Gentle';

  @override
  String get tagCheerful => 'Cheerful';

  @override
  String get tagLively => 'Lively';

  @override
  String get tagMischievous => 'Mischievous';

  @override
  String get tagRichYoungLady => 'Heiress';

  @override
  String get tagRichYoungMaster => 'Young Master';

  @override
  String get tagWealthyFamily => 'Wealthy Family';

  @override
  String get tagScheming => 'Scheming';

  @override
  String get tagPossessive => 'Possessive';

  @override
  String get tagParanoid => 'Paranoid';

  @override
  String get tagPersistent => 'Persistent';

  @override
  String get tagUncle => 'Uncle';

  @override
  String get tagAuntie => 'Auntie';

  @override
  String get tagSeniorSister => 'Senior (female)';

  @override
  String get tagJuniorBrother => 'Junior (male)';

  @override
  String get tagHandsome => 'Handsome';

  @override
  String get tagStunning => 'Stunning';

  @override
  String get tagContrast => 'Contrast';

  @override
  String get tagFlirty => 'Flirty';

  @override
  String get tagAgeGap => 'Age Gap';

  @override
  String get userNotFoundError => 'User not found';

  @override
  String get imageDataMismatchError =>
      'Image data mismatch, please reselect images.';

  @override
  String get createCharacterTitle => 'Create Character';

  @override
  String get charAlbumTitle => 'Character Album (First is main avatar)';

  @override
  String get charNameLabel => 'Character Name:*';

  @override
  String get charDescSection => 'Description';

  @override
  String get charAgeLabel => 'Age';

  @override
  String get charJobLabel => 'Occupation:*';

  @override
  String get charBirthdayLabel => 'Birthday (MMDD)';

  @override
  String get charGenderLabel => 'Gender *';

  @override
  String get genderNotSelected => 'Not Selected';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get charHeightLabel => 'Height (cm)';

  @override
  String get charAppearanceLabel => 'Appearance';

  @override
  String get charPersonalityTagsSection => 'Personality Tags';

  @override
  String get charOtherPersonalityTagsHint => 'Other personality tags...';

  @override
  String get otherSectionTitle => 'Other';

  @override
  String get charLikesLabel =>
      'Likes (e.g., strawberry cake, cats, rainy days)';

  @override
  String get charDislikesLabel => 'Dislikes (e.g., bitter melon, noisy places)';

  @override
  String get charSecretsLabel =>
      'Little secrets (e.g., actually has no sense of direction)';

  @override
  String get charMannerismsSection => 'Mannerisms';

  @override
  String get charToneLabel => 'Tone & Style (e.g., cold to strangers)';

  @override
  String get charDialogueExampleLabel =>
      'Dialogue Example (Player: You\'re so kind! Character: ...Oh.)';

  @override
  String get charBackgroundSection => 'Background:';

  @override
  String get charBackgroundHint =>
      'Enter character\'s background story (max 2500 chars)';

  @override
  String get charStoryStartSection => 'Story Opening:';

  @override
  String get charStoryStartHint =>
      'Enter character\'s story opening (max 2500 chars)';

  @override
  String get charStorySummaryLabel =>
      'Story Summary (max 50 chars, shown on encounter card)';

  @override
  String get charExtraInfoSection => 'Additional Info:';

  @override
  String get charExtraInfoHint => 'Enter additional info...';

  @override
  String get charPublicToggleLabel => 'Make public for other players?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get createButton => 'Create';

  @override
  String get saveButton => 'Save';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get exitCreationTitle => 'Exit Character Creation';

  @override
  String get saveDraftPrompt => 'Save as draft?';

  @override
  String get draftNeeded => 'Yes, save';

  @override
  String get draftNotNeeded => 'No, discard';

  @override
  String get editExtraInfoTitle => 'Edit Additional Info';

  @override
  String get nameAndAvatarError =>
      'Please enter a name and upload at least one avatar!';

  @override
  String get savingStatus => 'Saving...';

  @override
  String get uploadingImagesStatus => 'Uploading images...';

  @override
  String get maxImagesError => 'You can upload a maximum of 10 images.';

  @override
  String get uploadingImagesStatusShort => 'Processing images...';

  @override
  String get savingCharacterData => 'Saving character data...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'Character \"$charName\" created!';
  }

  @override
  String get uploadImageTimeoutError =>
      'Character creation failed: image upload timed out, please check your internet connection.';

  @override
  String createCharacterGenericError(String error) {
    return 'Character creation failed: $error';
  }

  @override
  String get settingsSectionAppearance => 'Appearance & Content';

  @override
  String get settingsSectionAccount => 'Account & Content Management';

  @override
  String get settingsSectionAbout => 'About Us';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'Unknown';

  @override
  String get userIdCopied => 'User ID copied to clipboard';

  @override
  String get characterManagement => 'Character Management';

  @override
  String get viewBlockedCharacters => 'View blocked characters';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get logoutButton => 'Log Out';

  @override
  String get logoutDialogTitle => 'Are you sure you want to log out? (´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'Oops, cancel';

  @override
  String get logoutDialogActionConfirm => 'Confirm';

  @override
  String get logoutSuccessSnackbar =>
      'Okay! I\'ll be waiting for your return ♥(´∀` )';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get deleteAccountDialogTitle =>
      'Are you sure you want to delete this account? இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'This action cannot be undone. All data will be permanently deleted!';

  @override
  String get deleteAccountDialogActionCancel => 'No, I don\'t want to delete';

  @override
  String get deleteAccountDialogActionConfirm => 'Confirm';

  @override
  String get deleteAccountSuccessSnackbar => 'Account successfully deleted.';

  @override
  String get appDisclaimer =>
      'The characters and scenes in the game are fictional. Please do not apply them to reality. Any resemblance is purely coincidental.';

  @override
  String appVersion(String version) {
    return 'App Version: $version';
  }

  @override
  String get dialogTitleHint => 'Hint';

  @override
  String get completeProfilePrompt =>
      'Please edit your profile to complete your information!';

  @override
  String get goToEdit => 'Go to Edit';

  @override
  String get later => 'Later';

  @override
  String chattingWith(String friendName) {
    return 'Chat with $friendName';
  }

  @override
  String chatContentWith(String friendName) {
    return 'Chat content with $friendName';
  }

  @override
  String get chatInputHint => 'Type a message...';

  @override
  String get characterNotFoundError => 'Character not found';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'Failed to load character details: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'Initial Relationship';

  @override
  String get relationship_childhood_friend => 'Childhood Friends';

  @override
  String get relationship_senior_junior => 'Senior/Junior';

  @override
  String get relationship_bickering_couple => 'Bickering Couple';

  @override
  String get relationship_colleagues => 'Colleagues';

  @override
  String get relationship_other => 'Other (Please enter manually)';

  @override
  String get chatModeDaily => 'Daily Mode';

  @override
  String get chatModeStory => 'Story Mode';

  @override
  String get chatModeImmersive => 'Immersive Mode';

  @override
  String get chatModeGemini => 'Life Companion';

  @override
  String get announcement_new => 'New Announcement';

  @override
  String get mail_notification =>
      'A new Time Letter has arrived! Go check the Parchment Scroll now!';

  @override
  String get customer_service_reply => 'Customer Service Reply';

  @override
  String get system_announcement => 'System Announcement';

  @override
  String get empty_announcement => 'No announcements at the moment.';

  @override
  String get untitled => 'Untitled';

  @override
  String get no_content => 'No Content';

  @override
  String get privacy_policy_title => 'Lianlian Shiguang Privacy Policy';

  @override
  String get privacy_policy_date => 'Last Updated: April 10, 2026';

  @override
  String get privacy_policy_body =>
      '\"Lianlian Shiguang\" Privacy Policy\nLast Updated: April 10, 2026\n\nWelcome to \"Lianlian Shiguang\" (hereinafter referred to as \"the Service\"). We value your privacy. This policy explains how we collect, use, and protect your personal information.\n\n1. Account Information:\nThird-party Login: When you log in via Google, Facebook, or Apple, we collect your Firebase UID, email, and public nickname.\nEmail Registration: When you choose to register by email, we collect your email address. Your login password is managed and stored using Firebase encryption; the development team cannot access your original password. We commit to adopting industry-standard security measures to safeguard your personal data.\n\nInteraction Data: To enable AI characters to have continuous memory, we collect and store your conversation records with the AI and the content you write for characters within the game.\n\nDevice Information: Including device model, operating system version, and unique device identifier (UDID) for system optimization.\n\n2. Use of Information\nEnhancing AI Experience: Utilizing conversation records to optimize AI response quality and personality consistency.\nService Operations: Used for processing point recharges, consumption records, and user identity verification.\nSecurity Protection: Monitoring malicious behavior to protect the server from attacks.\n\n3. Third-party Technical Cooperation\nThe Service is supported by the following major international technologies:\nGoogle Cloud / Firebase: Data storage and identity verification.\nOpenRouter / xAI / Meta: Providing AI model computational logic.\nNote: We do not sell your original conversation records to any advertisers.\n\n4. Data Storage and Deletion\nYour data will be securely stored on cloud servers.\nYou may contact us at any time to request the permanent deletion of your account and all associated conversation data.';

  @override
  String get terms_title => 'Lianlian Shiguang Terms of Service';

  @override
  String get terms_date => 'Last Updated: April 10, 2026';

  @override
  String get terms_body =>
      '\"Lianlian Shiguang\" Terms of Service\nLast Updated: April 10, 2026\n\nPlease read the following terms carefully before using \"Lianlian Shiguang\" (hereinafter referred to as \"the Service\"). Starting to use the Service means you agree to the following:\n\n1. Nature of Service and Disclaimer\nNon-human Interaction: All character responses in the Service are generated by Artificial Intelligence (Generative AI). Character statements do not represent the creator\'s position.\nNarrative Risk: AI may generate fictional, inaccurate, or uncomfortable content. Users should have the ability to distinguish between fiction and reality.\n\n2. Virtual Credits and Payment Models\nNature of Credits: Credits within the Service are virtual goods. Once consumed (e.g., entering a story, immersive mode, sending gifts, voice calls), they cannot be refunded.\nCost Differences: Credit consumption standards for different modes (e.g., Daily, Story, Immersive, Calls) are set based on AI computational costs. The Service reserves the right to adjust these costs.\n\n3. User Conduct Code\nProhibitions: It is prohibited to use AI to generate extreme violence, criminal guidance, or content that violates the law.\nSystem Interference: It is strictly forbidden to illegally obtain data from the Service through any automated tools or reverse engineering.\n\n4. Intellectual Property and Content Ownership\nOriginal Content: Intellectual property rights for character names (such as Cheng An and others created by the official), background settings, plot scripts, dialogue texts, game logic, and exclusive brand names belong to the \"Lianlian Shiguang Development Team.\"\nThird-party Licensed Resources: Icons, fonts, and emojis used in the Service interface belong to their original licensors (such as Google Material Design, Apple Inc., etc.), used legally under their open-source or licensing agreements.\nAI-Generated Content: Some artistic images in the Service are generated using AI tools (such as Niji.journey). The development team guarantees it has obtained commercial use licenses for these tools. Usage and operating rights for related images belong to the team.\nProhibited Acts: Without formal authorization, it is strictly forbidden to use any of the above content for commercial profit, secondary distribution, or malicious model training.\n\n5. Service Termination\nIf a player violates the above regulations, the Service has the right to suspend or permanently disable the account without prior notice.';

  @override
  String get login_required => 'Please login first';

  @override
  String get cloud_character_mgmt => 'Cloud Character Management';

  @override
  String get connection_error => 'Connection Error';

  @override
  String get no_characters_met => 'You haven\'t met any characters yet!';

  @override
  String get status_paused => 'Status: Connection Paused';

  @override
  String get status_in_progress => 'Status: Bonding';

  @override
  String get unblock => 'Unblock';

  @override
  String get block => 'Block';

  @override
  String get confirm_block_title => 'Confirm Block?';

  @override
  String confirm_block_msg(Object charName) {
    return 'After blocking, you won\'t receive messages from $charName for now.';
  }

  @override
  String get think_again => 'Think Again';

  @override
  String get confirm_block_btn => 'Confirm Block';

  @override
  String get no_char_info => 'No detailed info for this character yet...';

  @override
  String get private_mailbox => 'Private Mailbox';

  @override
  String get user_info_not_found => 'User info not found';

  @override
  String get load_failed => 'Load failed, please try again later';

  @override
  String get empty_mailbox => 'Mailbox is currently empty~';

  @override
  String get system_notification => 'System Notification';

  @override
  String get interaction_records => 'Interaction History';

  @override
  String get liked_content => 'Liked Content';

  @override
  String get my_favorites => 'My Favorites';

  @override
  String get login_to_view_records => 'Please login to view history';

  @override
  String get no_likes_yet => 'You haven\'t liked any posts yet!';

  @override
  String get empty_favorites =>
      'Your favorites folder is empty, explore the Lobby!';

  @override
  String get theme_sakura_pink => 'Sakura Pink';

  @override
  String get theme_ocean_blue => 'Ocean Blue';

  @override
  String get theme_sunset_orange => 'Sunset Orange';

  @override
  String get theme_mint_forest => 'Mint Forest';

  @override
  String get theme_midnight => 'Midnight Mode';

  @override
  String get change_atmosphere => 'Change Atmosphere';

  @override
  String get custom_color => 'Custom Color';

  @override
  String get custom_color_desc => 'Mix your exclusive atmosphere color';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';
}
