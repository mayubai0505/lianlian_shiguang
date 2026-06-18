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
      'The characters and scenes in the game are purely fictional. Please do not project them into reality!';

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
  String block_warning_msg(String charName) {
    return 'After blocking, you will temporarily not receive messages from $charName.';
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

  @override
  String get confirm_delete_title => 'Confirm Deletion';

  @override
  String get confirm_delete_memory_msg =>
      'Are you sure you want him to forget this? This action cannot be undone.';

  @override
  String get delete_btn => 'Delete';

  @override
  String get memory_erased_msg => 'This memory has been erased.';

  @override
  String get delete_failed_msg => 'Deletion failed';

  @override
  String get edit_memory_title => 'Edit Memory';

  @override
  String get modify_memory_hint => 'Modify this memory...';

  @override
  String get memory_re_recorded_msg => 'Memory re-recorded';

  @override
  String get update_failed_msg => 'Update failed';

  @override
  String get update_favorite_failed_msg => 'Failed to update favorite status';

  @override
  String char_notebook_title(String charName) {
    return '$charName\'s Notebook';
  }

  @override
  String get error_loading_memory => 'Error loading memory';

  @override
  String get empty_notebook_msg =>
      'The notebook is empty...\nGo chat so he can write down every little thing about you!';

  @override
  String get date_format_text => 'MMM d, yyyy';

  @override
  String get remove_special_focus => 'Remove Special Focus';

  @override
  String get mark_special_focus => 'Mark as Special Focus';

  @override
  String get edit_btn => 'Edit';

  @override
  String get load_gallery_failed => 'Failed to load gallery';

  @override
  String get traditional_chinese => 'Traditional Chinese';

  @override
  String get all => 'All';

  @override
  String get official_recommendation => 'Official Recommendation';

  @override
  String get my_exclusive => 'My Exclusive';

  @override
  String encounter_count(int count) {
    return '$count Encounters';
  }

  @override
  String get official => 'Official';

  @override
  String get private => 'Private';

  @override
  String get first_encounter => 'First Encounter';

  @override
  String char_exclusive_memory(String charName) {
    return '$charName\'s Exclusive Memory';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return 'Affection must reach $affectionLevel to unlock this memory!';
  }

  @override
  String get affection => 'Affection';

  @override
  String get unlock => 'Unlock';

  @override
  String get change_chat_bg => 'Change Chat Background';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return 'Set \"$cgDesc\" as the chat background with $charName?';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return 'Background changed to \"$cgDesc\"';
  }

  @override
  String get confirm_change => 'Confirm';

  @override
  String get empty_treasure_box =>
      'The treasure box is empty...\nGo chat to find hidden easter eggs!';

  @override
  String get unknown_story => 'Unknown Story';

  @override
  String get open_this_memory => 'Open this memory';

  @override
  String get open_exclusive_story => 'Open exclusive story';

  @override
  String confirm_use_egg(String eggTitle) {
    return 'Experience \"$eggTitle\" now?\n\n(This item is consumable and will automatically enter the story upon use)';
  }

  @override
  String get wait_a_bit => 'Wait a bit';

  @override
  String guiding_into_story(String eggTitle) {
    return 'Guiding into story...';
  }

  @override
  String get use_now => 'Use Now';

  @override
  String playback_failed_status(String statusCode) {
    return 'Playback failed, status code: $statusCode';
  }

  @override
  String get playback_error => 'Playback error occurred';

  @override
  String get unknown_contact => 'Unknown Contact';

  @override
  String call_memory_with(String charName) {
    return 'Call Memory with $charName';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return 'Unlocks at affection $affection';
  }

  @override
  String get no_call_record =>
      'There seems to be no conversation record for this call...';

  @override
  String get me => 'Me';

  @override
  String get playing => 'Playing...';

  @override
  String get listen => 'Listen';

  @override
  String get no_exclusive_voice =>
      'This character doesn\'t have an exclusive voice yet!';

  @override
  String get voice_download_success =>
      '✅ Voice data downloaded successfully, preparing to play...';

  @override
  String get onboarding_invitation => '— Invitation of Time —';

  @override
  String get onboarding_welcome => 'Welcome to Lian Lian Shi Guang';

  @override
  String get onboarding_quote =>
      '\"Every encounter is a reunion after a long separation.\"';

  @override
  String get onboarding_gift_title => 'First Meeting Gift: 50 Flowers';

  @override
  String get onboarding_gift_subtitle =>
      'These flowers will accompany you as your story with him begins.';

  @override
  String get onboarding_start_button => 'Start Your Journey of Time';

  @override
  String get onboarding_more_info => 'Learn more about the story';

  @override
  String get legal_agreement_prefix => 'By continuing, you agree to our';

  @override
  String get legal_terms_button => 'Terms of Service';

  @override
  String get legal_and => ' and ';

  @override
  String get legal_privacy_button => 'Privacy Policy';

  @override
  String get call_memory_title => 'Call Memories';

  @override
  String get please_login_first => 'Please log in first';

  @override
  String get no_call_memories =>
      'No saved call memories yet.\nMaximum of 10 records can be saved.';

  @override
  String call_with_name(String name) {
    return 'Call with $name';
  }

  @override
  String call_duration(String time) {
    return 'Duration: $time';
  }

  @override
  String get delete_call_title => 'Delete Call Record';

  @override
  String delete_call_confirm(String name) {
    return 'Are you sure you want to secretly destroy this memory with $name?\n(This cannot be undone)';
  }

  @override
  String get keep_it => 'Keep it';

  @override
  String get confirm_delete => 'Delete';

  @override
  String get press_mic_to_speak => 'Press the microphone to speak...';

  @override
  String get call_ended => 'Call ended';

  @override
  String character_thinking(String name) {
    return '($name is thinking...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name is picking up...)';
  }

  @override
  String get call_interrupted_login =>
      '(Call interrupted) Please log in first...';

  @override
  String get silence => '(Silence)';

  @override
  String get bad_signal => '(Bad signal...)';

  @override
  String get static_noise => '(Static noise)... can\'t hear you clearly...';

  @override
  String get type_message_hint => 'Type a message...';

  @override
  String get draft_saved_success => 'Draft safely saved to the Secret Studio!';

  @override
  String get draft_save_failed => 'Save failed, please try again later';

  @override
  String get draft_save_title => 'Save Draft?';

  @override
  String get draft_save_content =>
      'Your work hasn\'t been published yet. Would you like to save it to the Secret Studio first?';

  @override
  String get not_save => 'Don\'t Save';

  @override
  String get save_draft => 'Save Draft';

  @override
  String confirm_delete_char_content(String name) {
    return 'Are you sure you want to delete character \"$name\"?\n\nThis action cannot be undone!';
  }

  @override
  String get char_deleted => 'Character deleted';

  @override
  String get ok_button => 'OK!';

  @override
  String get cannot_save_title => 'Cannot Save';

  @override
  String get cannot_save_content =>
      'Please fill in the character name and upload at least one avatar!';

  @override
  String get word_count_exceeded => 'Word count exceeded';

  @override
  String word_count_error_detail(String field, int limit) {
    return '\"$field\" exceeds the $limit-word limit. Please shorten it and save again.';
  }

  @override
  String get content_missing => 'Content missing';

  @override
  String get content_missing_personality =>
      'Please fill in \"Detailed Personality\"! (Minimum 10 words).';

  @override
  String get content_missing_bg =>
      '\"Character Background\" is too short! Please write at least 20 words to explain the context.';

  @override
  String get content_missing_tone =>
      'Please set \"Tone and Habits\" to prevent OOC behavior!';

  @override
  String get user_not_found => 'Error: User not found';

  @override
  String char_saved_success(String name, String action) {
    return 'Character \"$name\" has been $action!';
  }

  @override
  String save_error_detail(String error) {
    return 'Save failed: $error';
  }

  @override
  String get easter_egg_add_title => 'Add Hidden Easter Egg';

  @override
  String get easter_egg_edit_title => 'Edit Easter Egg';

  @override
  String get keyword_label => 'Trigger Keyword (Required)';

  @override
  String get keyword_hint => 'e.g., go to amusement park, strawberry cake';

  @override
  String get egg_title_label => 'Easter Egg Title (Visible to players)';

  @override
  String get egg_title_hint => 'e.g., Weekend Date';

  @override
  String get egg_teaser_label => 'Short Teaser (Visible to players)';

  @override
  String get egg_teaser_hint => 'Describe how the scene begins...';

  @override
  String get egg_scene_label => 'Forced Scene Switch (Optional)';

  @override
  String get egg_scene_hint => 'e.g., Amusement Park, Haunted House';

  @override
  String get egg_prompt_label => 'Script Prompt';

  @override
  String get egg_prompt_hint =>
      'How to act out this plot.\n(System: Scene switches to amusement park, character looks at (Player Name) and smiles...)';

  @override
  String get confirm_button => 'Confirm';

  @override
  String get keyword_empty_error => 'Keyword cannot be empty';

  @override
  String get voice_custom_title => 'Customize Exclusive Voice';

  @override
  String get voice_custom_hint => 'e.g., Deep CEO, Gentle Puppy...';

  @override
  String get voice_generate_start => 'Start Generating';

  @override
  String get voice_bind_first =>
      'Please select and \"Bind\" an exclusive voice first!';

  @override
  String get voice_test_failed =>
      'Preview failed: Please click \"I choose you!\" to formally bind the voice before fine-tuning!';

  @override
  String voice_name_default(String name) {
    return '$name\'s Exclusive Voice';
  }

  @override
  String get voice_description_default =>
      'This is a unique voice created for an exclusive character in \"Lian Lian Shi Guang,\" selected and generated by the player.';

  @override
  String get voice_bind_failed =>
      'Voice binding failed. Please check API quota or network status.';

  @override
  String voice_bind_success(String name) {
    return '\"$name\"\'s Soul Voice has been formally bound!';
  }

  @override
  String get voice_bind_success_draft =>
      'Voice bound successfully! You can now adjust the sliders to test emotions!';

  @override
  String sync_failed(String error) {
    return 'Sync failed, please check network: $error';
  }

  @override
  String edit_character_title(String name) {
    return 'Edit $name';
  }

  @override
  String get test_mode_tooltip => 'Full Function Test';

  @override
  String get test_mode_error =>
      '⚠️ Character file not found! Please click \"Save/Publish\" at the bottom before trying the test mode!';

  @override
  String get test_mode_notice =>
      '💡 Test mode will consume points based on the original price of each mode and will not be recorded in formal memories!';

  @override
  String get delete_character_tooltip => 'Delete Character';

  @override
  String get tab_basic_story => 'Basics & Story';

  @override
  String get tab_voice => 'Exclusive Voice';

  @override
  String get tab_relationship => 'Social Relationships';

  @override
  String get save_changes_button => 'Save Changes';

  @override
  String get section_basic_info => 'Basic Info';

  @override
  String get hint_occupation =>
      'Supports multiple identities, please separate with slashes or commas (e.g., Student/Hacker)';

  @override
  String get hint_appearance =>
      'e.g., Long silver hair, amber eyes, always wears a white coat...';

  @override
  String get section_story_identity => '🎭 Story & Your Identity';

  @override
  String get story_identity_desc =>
      'Define the story opening and your special settings in this save';

  @override
  String get advanced_writing_tips_title => '💡 Advanced Writing Tips:\n';

  @override
  String get advanced_writing_tips_1 => 'Enter ';

  @override
  String get advanced_writing_tips_2 => '(Player Name)';

  @override
  String get advanced_writing_tips_3 =>
      ' in the story or lines, and the system will automatically replace it with the player\'s nickname during gameplay!\n';

  @override
  String get advanced_writing_tips_4 => 'Example: \"';

  @override
  String get advanced_writing_tips_5 => '(Player Name)';

  @override
  String get advanced_writing_tips_6 => ', why are you so late?\"';

  @override
  String get player_identity_label => 'Default Player Identity - 💡 Optional';

  @override
  String get player_identity_hint =>
      '[Optional] If left blank, AI will interact based on your \"Profile.\"\nIf filled, it forces a specific identity (e.g., his cold system, or a betrayed wife).';

  @override
  String get background_label => 'Character Background & Worldview';

  @override
  String get background_hint =>
      'Describe their past and the world setting (e.g., modern city, ABO, apocalypse). Example: This is a zombie-infested world, and he is a special forces soldier protecting you...';

  @override
  String get story_summary_label => 'One-line Story Intro';

  @override
  String get story_initial_label => 'Initial Encounter Story';

  @override
  String get story_initial_hint =>
      'e.g., You push open the door and see him sitting by the window. He turns and says: \"(Player Name), come here.\"';

  @override
  String get first_line_label => 'Character\'s First Line';

  @override
  String get first_line_hint => 'e.g., (Player Name), you\'re finally here.';

  @override
  String get section_personality_evo => '🌟 Personality & Affection Evolution';

  @override
  String get detailed_personality_label => 'Detailed Personality';

  @override
  String get detailed_personality_hint =>
      'Describe their core personality. e.g., Tsundere, sharp-tongued but soft-hearted. Cold to outsiders, only smiles for the player.';

  @override
  String get affection_evo_desc =>
      'AI will determine when to increase affection based on these settings:';

  @override
  String get stage_1_label => 'Stage 1: Stranger/Wary (Lv1)';

  @override
  String get stage_1_hint =>
      'Reaction when first meeting. Affection triggers (e.g., being polite, not prying into privacy).';

  @override
  String get stage_2_label => 'Stage 2: Familiar/Friend (Lv2)';

  @override
  String get stage_2_hint =>
      'Changes after getting familiar. Affection triggers (e.g., sharing sweets, chatting about cats).';

  @override
  String get stage_3_label => 'Stage 3: Intimate/Lover (Lv3)';

  @override
  String get stage_3_hint =>
      'Reaction after falling completely. Will they get jealous? Or sulk silently?';

  @override
  String get social_interaction_label => 'Social & Environmental Interaction';

  @override
  String get social_interaction_hint =>
      'e.g., How do they treat strangers? How do they react to things they hate (triggers)?';

  @override
  String get section_habits => '🗣️ Likes & Habits';

  @override
  String get tone_hint_detail =>
      'Required. e.g., Speaks briefly, likes to answer with questions. Catchphrase: \"Idiot.\" No machine translation style.';

  @override
  String get dialogue_example_hint =>
      'Player: I\'m so tired.\nCharacter: (Pats head) Good, go and rest now.';

  @override
  String get section_easter_eggs => '🎁 Hidden Easter Eggs & Special Plots';

  @override
  String get no_easter_eggs =>
      'No easter eggs set yet. Click the button below to add one.';

  @override
  String get no_scene_change => 'No scene change';

  @override
  String get add_easter_egg_button => 'Add Hidden Easter Egg';

  @override
  String get other_extra_info => 'Other Supplemental Info';

  @override
  String get visibility_label => 'Character Visibility';

  @override
  String get visibility_public => 'Public';

  @override
  String get visibility_private => 'Private';

  @override
  String get section_voice_gen => '🎙️ Exclusive Voice Generation';

  @override
  String get voice_gen_desc =>
      'Enter prompts to create a unique voice!\n(💡 Tip: If you\'re not satisfied after generation, you can customize it again anytime!)';

  @override
  String get voice_generating_status => 'Mixing voice lines...';

  @override
  String get voice_select_prompt =>
      '✨ Here are three voice types tailored for you. Please choose:';

  @override
  String voice_sample_name(int index) {
    return 'Voice Sample $index';
  }

  @override
  String get voice_sample_desc =>
      'Click the card to select; click the right side to preview.';

  @override
  String get voice_preparing => 'Voice is being prepared...';

  @override
  String get voice_retry => 'Discard and Retry';

  @override
  String get voice_confirm_selection => 'I choose you!';

  @override
  String get voice_bind_success_banner => 'Exclusive voice bound successfully!';

  @override
  String get voice_remake => 'Remake Voice';

  @override
  String get voice_btn_generating => 'Generating, please wait...';

  @override
  String get voice_btn_generate => 'Enter prompt to generate voice';

  @override
  String get voice_advanced_tuning => '🎛️ Advanced: Fine-tune Emotion';

  @override
  String get voice_stability_low => 'Wild/Breathy 🐺';

  @override
  String voice_stability_value(String value) {
    return 'Stability: $value';
  }

  @override
  String get voice_stability_high => 'Steady/Calm 🤖';

  @override
  String get voice_style_low => 'Cold/Suppressed 🧊';

  @override
  String voice_style_value(String value) {
    return 'Dramatic: $value';
  }

  @override
  String get voice_style_high => 'Exaggerated/Passionate 🔥';

  @override
  String get voice_test_btn_testing => 'Applying emotion...';

  @override
  String get voice_test_btn => 'Preview Current Emotion';

  @override
  String get section_social_circle => '👥 Social Circle';

  @override
  String get social_circle_desc =>
      'Set their views on other characters. When mentioned in chat, they will react based on these settings (e.g., jealousy, anger).';

  @override
  String get social_no_drama => 'No conflicts with other male leads yet...';

  @override
  String social_target(String name) {
    return 'Target: $name';
  }

  @override
  String social_attitude(String attitude) {
    return 'View: $attitude';
  }

  @override
  String social_edit_title(String name) {
    return 'Edit view on $name 💬';
  }

  @override
  String get social_attitude_label => 'Their View / Attitude';

  @override
  String get social_attitude_hint =>
      'e.g., Thinks they are annoying but secretly relies on them...';

  @override
  String get social_save_changes => 'Save Changes';

  @override
  String get social_add_title => 'Add Relationship 🤝';

  @override
  String get social_select_target => 'Select Target';

  @override
  String get social_thoughts_label => 'Their thoughts on this person...';

  @override
  String get social_thoughts_hint => 'e.g., That pianist is too loud...';

  @override
  String get social_add_confirm => 'Confirm Add';

  @override
  String get gallery_load_failed =>
      'Image load failed 🥲\nPlease check your network; if on Web, check the console.';

  @override
  String gallery_affection_req(int level) {
    return 'Affection $level';
  }

  @override
  String get gallery_upload_limit => 'Max 10 images allowed';

  @override
  String get gallery_photo_setup => 'Set Photo Unlock Conditions';

  @override
  String get gallery_photo_desc_label => 'What is this photo?';

  @override
  String get gallery_photo_desc_hint => 'e.g., Pajama shot, Date photo';

  @override
  String get gallery_photo_req_label => 'Affection level required?';

  @override
  String get gallery_photo_req_hint => 'Enter a number; 0 for free';

  @override
  String get gallery_cancel_upload => 'Cancel Upload';

  @override
  String get gallery_confirm_add => 'Confirm Add';

  @override
  String get default_photo_desc => 'Exclusive Photo';

  @override
  String get draft_photo_desc => 'Draft Photo';

  @override
  String get loading_text => 'Loading...';

  @override
  String get default_unnamed_character => 'Unnamed Character';

  @override
  String elevenlabs_error(String code) {
    return 'ElevenLabs Error: $code';
  }

  @override
  String get voice_sample_script =>
      '(Clears throat) Hello. This is a voice test exclusive to me. In the days ahead, I will be here with you. Whether you are happy or sad, you can always share it with me. Are you comfortable with this pace and tone? If you like it, let\'s settle on this voice as my exclusive voice for chatting with you. Looking forward to every day of our future.';

  @override
  String get voice_test_script =>
      'Do you actually know what I\'m thinking every time I look at you? ... I really don\'t know what to do with you.';

  @override
  String get field_background => 'Character Background';

  @override
  String get field_tone => 'Tone and Habits';

  @override
  String get field_initial_story => 'Initial Story';

  @override
  String get update_action => 'Update';

  @override
  String get default_new_player => 'New Player';

  @override
  String get translating_status => 'Translating...';

  @override
  String get translate_profile_btn => 'Translate Profile Content';

  @override
  String translate_failed(String error) {
    return 'Translation failed: $error';
  }

  @override
  String get like_own_char_warning =>
      'You can\'t like a character you created! 🤭';

  @override
  String get like_success_msg => 'Like sent! The creator will be very happy💖';

  @override
  String get unlike_success_msg => 'Like removed 💔';

  @override
  String get like_label => 'Like';

  @override
  String get dislike_label => 'Dislike';

  @override
  String get block_char => 'Block this character';

  @override
  String get char_blocked_msg => 'Character blocked.';

  @override
  String get dislike_dialog_title => 'Don\'t like this character?';

  @override
  String get dislike_dialog_subtitle =>
      'Please tell us the reason privately; we will review it:';

  @override
  String get dislike_hint => 'Boring settings, inappropriate images...';

  @override
  String get dislike_thanks =>
      'Thanks for your feedback! We\'ve received your private message.';

  @override
  String get dislike_submit => 'Send Privately';

  @override
  String get report_title => '📢 Report Comment';

  @override
  String get report_subtitle =>
      'Select reason for reporting:\nWe will review the content as soon as possible.';

  @override
  String get report_opt_1 => 'Pornography or graphic violence';

  @override
  String get report_opt_2 => 'Defamation, insults, or character attacks';

  @override
  String get report_opt_3 => 'Hate speech or personal attacks';

  @override
  String get report_opt_4 => 'Spam or advertising fraud';

  @override
  String get report_opt_5 => 'Other inappropriate content';

  @override
  String get report_confirm => 'Confirm Report';

  @override
  String get report_success =>
      'Reported successfully! Notification received and content will be reviewed 🛡️';

  @override
  String get report_failed =>
      'Report failed, please check your internet connection.';

  @override
  String get lore_delete_title => '⚠️ Warning: Erase Memory';

  @override
  String get lore_delete_content =>
      'Once deleted, this memory is gone forever. Are you sure you want to erase it?';

  @override
  String get lore_delete_cancel => 'Cancel';

  @override
  String get lore_delete_confirm => 'Confirm Erase';

  @override
  String get lore_delete_success => '🗑️ Memory fragment erased completely.';

  @override
  String get lore_add_title => 'Write New Memory 🖋️';

  @override
  String get lore_edit_title => 'Edit Memory Fragment 🖋️';

  @override
  String get lore_title_label => 'Memory Title';

  @override
  String get lore_title_hint => 'e.g., The Rainy Day We First Met';

  @override
  String get lore_teaser_label => 'Summary / Teaser';

  @override
  String get lore_teaser_hint => 'A short description shown on the card...';

  @override
  String get lore_content_label => 'Full Memory Content';

  @override
  String get lore_content_hint => 'Write down the detailed story or setting...';

  @override
  String get lore_lock_label => '🔒 Seal this Memory';

  @override
  String get lore_lock_desc =>
      'Only the creator can see it when checked; players cannot view it.';

  @override
  String get lore_empty_error => 'Title and content cannot be empty!';

  @override
  String get lore_add_success => '✨ New memory successfully sealed!';

  @override
  String get lore_publish => 'Publish Memory';

  @override
  String get lore_save_edit => 'Save Changes';

  @override
  String lore_write_first(Object pronoun) {
    return 'Write the first chapter for $pronoun!';
  }

  @override
  String lore_waiting(Object pronoun) {
    return 'Looking forward to the story with $pronoun...';
  }

  @override
  String get lore_sealed_msg =>
      '🔒 This memory is sealed and currently unavailable.';

  @override
  String get lore_not_open_msg =>
      'This memory is not yet open to the public...';

  @override
  String get lore_unnamed => 'Unnamed Fragment';

  @override
  String get lore_add_btn_limit => 'Write a new memory fragment (limit 10)';

  @override
  String get lore_collapse => 'Collapse Letter';

  @override
  String get echo_delete_title => '🗑️ Delete Comment';

  @override
  String get echo_delete_content =>
      'Are you sure you want to delete this Echo?\nIt cannot be recovered once deleted!';

  @override
  String get echo_keep => 'Keep';

  @override
  String get echo_clear_success => 'Echo cleared 🧹';

  @override
  String get echo_energy_full_title => '⚠️ Cosmic Energy Limit Reached';

  @override
  String get echo_energy_full_content =>
      'Your energy limit (max 3) has been reached. Please delete old experiences to open new cosmic records!';

  @override
  String get echo_write_title => 'Leave Your Space-Time Echo 🌌';

  @override
  String get echo_write_subtitle =>
      'Write your experience or heart-fluttering quotes here!';

  @override
  String get echo_hint =>
      '「Even if it\'s the end of the world, I\'ll prioritize your breathing...」';

  @override
  String get echo_theme_label => 'Choose note border:';

  @override
  String get theme_butterfly => 'Butterfly';

  @override
  String get theme_sprout => 'Sprout';

  @override
  String get theme_star => 'Starry Sky';

  @override
  String get theme_planet => 'Planet';

  @override
  String get echo_publish_btn => 'Publish Echo Record';

  @override
  String get echo_wall_title => 'Space-Time Echo Wall';

  @override
  String get echo_leave_memory => 'Leave Experience';

  @override
  String get echo_empty_msg =>
      'No time travelers have left a record yet...\nWill you be the first?';

  @override
  String get creator_label => 'Creator';

  @override
  String get follow_btn => 'Follow';

  @override
  String get followed_btn => 'Followed';

  @override
  String get follow_own_warning => 'Creators cannot follow themselves! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName followed $creatorName!';
  }

  @override
  String get mailbox_follow_title => 'New Guardian Obtained 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName just followed you!';
  }

  @override
  String get tab_private_profile => 'Private Profile';

  @override
  String get tab_memory_fragments => 'Memory Fragments';

  @override
  String get tab_time_echoes => 'Time Echoes';

  @override
  String get chat_free_btn => 'Chat (Free)';

  @override
  String get start_story_btn => 'Start Story';

  @override
  String get default_chat_initial => 'Do you need me for something?';

  @override
  String get gallery_title => 'Exclusive Call Background';

  @override
  String gallery_current_affection(String value) {
    return 'Current Affection: $value 💕';
  }

  @override
  String get gallery_empty => 'No photos in the album yet';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'Background set to \"$desc\"!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'Reach an affection level of $value to unlock! 🍃';
  }

  @override
  String get gallery_reset_bg => 'Restored default call background';

  @override
  String get background_story_title => 'Background Story';

  @override
  String get background_story_empty =>
      'This character is mysterious; there\'s no background story yet...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'Followed $creatorName 🦋';
  }

  @override
  String get mailbox_title => 'Exclusive Mailbox 💌';

  @override
  String get mailbox_empty =>
      'Your mailbox is empty. Go post an update to attract him!';

  @override
  String get new_notification => 'New Notification';

  @override
  String get default_he => 'He';

  @override
  String affection_upgrade_title(String charName) {
    return '$charName\'s affection for you has increased! 💖';
  }

  @override
  String get flower_reward => '🌸 Received 5 Flowers';

  @override
  String get affection_quote_lv5 =>
      '\"I didn\'t expect... that you would become so important to me. So important that... I can\'t imagine a world without you.\"';

  @override
  String get affection_quote_lv4 =>
      '\"The luckiest thing in my life was probably that day, looking back and seeing you.\"';

  @override
  String get affection_quote_lv3 =>
      '\"Lately... I\'ve noticed I\'m daydreaming more, and my head is completely filled with you.\"';

  @override
  String get affection_quote_lv2 =>
      '\"Since it\'s your invitation, I suppose I could clear some time—it\'s not impossible.\"';

  @override
  String get affection_quote_lv1 =>
      '\"I\'ve been seeing you often lately, and I feel... I don\'t hate this frequency of meeting.\"';

  @override
  String get affection_quote_lv0 =>
      '\"So you are here too. Is this some kind of strange fate?\"';

  @override
  String get lore_edit_success => '✨ Memory fragment updated successfully!';

  @override
  String get delete_failed_network =>
      'Delete failed, please check network or permissions.';

  @override
  String get ai_chat_language => 'English';

  @override
  String get ai_chat_language_code => 'en-US';

  @override
  String get chat_home_title => 'Messages';

  @override
  String get call_memory_tooltip => 'Call Memories';

  @override
  String get login_to_view_chat => 'Please log in to view chat history';

  @override
  String load_chat_failed(String error) {
    return 'Failed to load chat list: $error';
  }

  @override
  String get chat_list_empty => 'Chat room is empty...';

  @override
  String get go_to_encounter =>
      'Go to \"Encounter\" and find someone to chat with!';

  @override
  String confirm_delete_chat(String charName) {
    return 'Are you sure you want to delete the conversation with $charName?';
  }

  @override
  String affection_score_short(String score) {
    return 'Affection $score';
  }

  @override
  String get character_not_found =>
      'Unable to load character data; the character may have been deleted.';

  @override
  String get preparing_chat_room => 'Preparing your exclusive chat room...';

  @override
  String get rename_chat_title => 'Name this memory';

  @override
  String get rename_chat_hint =>
      'e.g., Change (Cheng Yu) to (Divorce Countdown)';

  @override
  String get save_tag_btn => 'Save Tag';

  @override
  String get room_name_updated => 'Room name updated!';

  @override
  String update_failed(String error) {
    return 'Update failed: $error';
  }

  @override
  String get chat_mode_daily => 'Daily';

  @override
  String get chat_mode_story => 'Story';

  @override
  String get chat_mode_immersive => 'Immersive';

  @override
  String get chat_mode_gemini => 'Chat';

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
      'Character data not found. Please go back and try again or check your network.';

  @override
  String get chat_jump_success => 'Jumped to this memory 🍃';

  @override
  String get chat_create_room_failed =>
      'Connection seems unstable. Failed to create chat room, please try again.';

  @override
  String get chat_secret_file_title => '🔒 Confidential File';

  @override
  String get chat_secret_file_desc =>
      'This character\'s soul file has been archived or set to private. Detailed information is temporarily unavailable.';

  @override
  String get chat_understood => 'Got it';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ New Memory Obtained: $title';
  }

  @override
  String get chat_egg_saved => 'Automatically added to your exclusive backpack';

  @override
  String get chat_points_not_enough_title => 'Not Enough Flowers';

  @override
  String get chat_points_not_enough_desc =>
      'You don\'t have enough Flowers! Please go to the shop to top up.';

  @override
  String chat_call_confirm_title(String name) {
    return 'Call $name?';
  }

  @override
  String get chat_call_rule_1 => 'Each call consumes 20 Flowers';

  @override
  String get chat_call_rule_2 =>
      'Calls last 1 minute. If you can\'t speak, you can communicate via text';

  @override
  String get chat_call_rule_3 =>
      'Wearing headphones is recommended to hear his voice clearly ✨';

  @override
  String get chat_call_btn_cancel => 'Not now';

  @override
  String get chat_call_pref_title => 'Set Your Call Preferences';

  @override
  String get chat_call_lang_select => 'Select Call Language';

  @override
  String get chat_call_save_memory => 'Save This Call Memory';

  @override
  String get chat_call_save_memory_desc =>
      'You can listen to it again after the call ends';

  @override
  String get chat_call_btn_start => 'Start Call';

  @override
  String chat_points_shortage(String points) {
    return 'Not enough Flower points! You currently have $points points';
  }

  @override
  String get chat_room_not_ready => 'Chat room is not ready, please re-enter.';

  @override
  String get chat_stop_generating_msg =>
      'Response stopped, points were not deducted 🍃';

  @override
  String get chat_heartbeat_up => 'His heart is racing...';

  @override
  String get chat_heartbeat_down => 'His gaze turned cold...';

  @override
  String get chat_msg_copy => 'Copy Content';

  @override
  String get chat_msg_copied => 'Copied to clipboard!';

  @override
  String get chat_msg_report => 'Report this message';

  @override
  String get chat_msg_suggest => 'Give Suggestion';

  @override
  String get chat_report_title => 'Report This Conversation';

  @override
  String get chat_report_lang => 'Foreign language appeared';

  @override
  String get chat_report_inapp => 'Inappropriate response';

  @override
  String get chat_report_context => 'Context is not connected';

  @override
  String get chat_report_other => 'Other reasons';

  @override
  String get chat_report_hint => 'Please describe the issue you encountered...';

  @override
  String get chat_report_submit => 'Submit';

  @override
  String get chat_report_success =>
      '✅ Report submitted, we will adjust as soon as possible';

  @override
  String get chat_suggest_title => 'Give Feedback';

  @override
  String get chat_suggest_hint =>
      'Please write down your valuable suggestions...';

  @override
  String get chat_suggest_success =>
      '💖 Thank you for your suggestion, we will process it as soon as possible';

  @override
  String get chat_del_warn => 'Messages cannot be recovered once deleted.';

  @override
  String get chat_reset_title => 'Reset Memory';

  @override
  String get chat_reset_desc =>
      'Please choose the degree of reset:\n\n1. [Chat Only]: Clear chat history but keep affection level.\n2. [Full Reset]: Everything returns to zero, like the first meeting.';

  @override
  String get chat_reset_only_chat => 'Chat History Only';

  @override
  String get chat_reset_full => 'Full Reset';

  @override
  String get chat_reset_full_msg =>
      'Everything has returned to the beginning, he no longer remembers you...';

  @override
  String get chat_reset_chat_msg =>
      'Chat history cleared, but his love for you remains.';

  @override
  String get chat_edit_ai_hint => 'Edit his response...';

  @override
  String get chat_edit_user_hint => 'Please enter new content...';

  @override
  String chat_no_voice_msg(String name) {
    return 'There is no voice for $name yet...';
  }

  @override
  String get chat_poke_btn => 'Poke';

  @override
  String get chat_poke_success =>
      '✨ Poked the creator for you! Please look forward to his voice going online~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'Not enough Flower points! Need $cost points 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ Destined Soulmate ✨';

  @override
  String get chat_levelup_normal => 'Relationship Level Up! 💖';

  @override
  String get chat_levelup_btn_soulmate => 'Carve into Soul';

  @override
  String get chat_levelup_btn_normal => 'Accept with a Flutter';

  @override
  String get chat_loc_title => '📍 Send Virtual Location';

  @override
  String get chat_loc_custom_btn => 'Send Custom Location';

  @override
  String get chat_loc_hint => 'Enter another place... (e.g., In your heart)';

  @override
  String get chat_loc_1 => 'Downstairs at your house';

  @override
  String get chat_loc_2 => 'At school';

  @override
  String get chat_loc_3 => 'At the cafe we just passed';

  @override
  String get chat_loc_4 => 'At the convenience store';

  @override
  String get chat_interact_title => '✨ What do you want to do to him?';

  @override
  String get chat_interact_action => 'Pokes and small gestures';

  @override
  String get chat_interact_gift =>
      'Send him a small gift (consumes Flowers 🌸)';

  @override
  String get chat_action_poke => 'Poke cheeks';

  @override
  String get chat_action_hug => 'Ask for a hug';

  @override
  String get chat_action_hand => 'Hold hands secretly';

  @override
  String get chat_dice_btn => 'Roll Dice';

  @override
  String get chat_loading_failed =>
      'Failed to load memory, please go back and try again.';

  @override
  String get chat_test_mode_msg =>
      'Test mode is on, chat away! (Conversations won\'t be saved)';

  @override
  String get chat_empty_msg => 'Start a heart-fluttering journey with him!';

  @override
  String get chat_ai_typing => 'He is replying...';

  @override
  String get chat_input_hint_default => 'What do you want to say to him...';

  @override
  String get chat_typing_indicator => 'Typing...';

  @override
  String get chat_menu_search => 'Search Chat';

  @override
  String get chat_menu_gallery => 'Exclusive Memories & Backgrounds';

  @override
  String get chat_menu_aboutme => 'Related to Me';

  @override
  String get chat_menu_memo => 'Memo for Him';

  @override
  String get chat_menu_period => 'Period Tracker';

  @override
  String get chat_menu_reset => 'Reset Memory';

  @override
  String get chat_search_hint =>
      'Which sweet conversation do you want to relive?';

  @override
  String get chat_search_empty => 'This memory cannot be found 🥺';

  @override
  String get chat_search_you => 'You said';

  @override
  String get chat_search_him => 'He said';

  @override
  String get chat_tool_backpack => 'Backpack';

  @override
  String get chat_tool_story => 'Story Summary';

  @override
  String get chat_tool_photo => 'Photos';

  @override
  String get chat_tool_record => 'Voice Recording';

  @override
  String get chat_tool_profile => 'ShiGuang Files';

  @override
  String get chat_tool_interact => 'Interactions';

  @override
  String get chat_record_recording => 'Recording...';

  @override
  String get chat_record_start => 'Tap microphone to start recording';

  @override
  String get chat_record_done => 'Recording finished';

  @override
  String get chat_mode_daily_desc =>
      'Light and pleasant daily chat, just like friends!';

  @override
  String get chat_mode_story_desc => 'Novel-like plot progression.';

  @override
  String get chat_mode_immersive_desc =>
      'Ultimate sensory experience, deep interaction without boundaries.';

  @override
  String get chat_switch_mode_title => 'Switch Chat Mode';

  @override
  String get chat_voice_call => 'Voice Call';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '[System Event] $playerName sent a [$giftName].';
  }

  @override
  String get rel_title_soulmate => 'Soulmate/Deeply in Love';

  @override
  String get rel_title_lover => 'Passionate Love/Exclusive Boyfriend';

  @override
  String get rel_title_ambiguous => 'Ambiguous/Testing the Waters';

  @override
  String get rel_title_friend => 'Friend/Sprouting Affection';

  @override
  String get rel_title_acquaintance => 'Acquaintance/Slightly Familiar';

  @override
  String get rel_title_stranger => 'Stranger/First Meeting';

  @override
  String get rel_title_tense => 'Tense/Getting Annoyed';

  @override
  String get rel_title_avoiding => 'Like Strangers/Deliberately Avoiding';

  @override
  String get rel_title_hostile => 'Extreme Disgust/Cold Hostility';

  @override
  String get rel_title_nemesis => 'Sworn Enemies/Never to Meet Again';

  @override
  String get rel_msg_soulmate =>
      '\"I didn\'t expect... that you would become so important to me. So important that... I can\'t imagine a world without you.\"';

  @override
  String get rel_msg_lover =>
      '\"The luckiest thing in my life was probably that day, looking back and seeing you.\"';

  @override
  String get rel_msg_ambiguous =>
      '\"Lately... I\'ve noticed I\'m daydreaming more, and my head is completely filled with you.\"';

  @override
  String get rel_msg_friend =>
      '\"Since it\'s your invitation, I suppose I could clear some time—it\'s not impossible.\"';

  @override
  String get rel_msg_acquaintance =>
      '\"I\'ve been seeing you often lately, and I feel... I don\'t hate this frequency of meeting.\"';

  @override
  String get rel_msg_stranger =>
      '\"So you are here too. Is this some kind of strange fate?\"';

  @override
  String chat_edit_char_count(String count) {
    return '$count chars';
  }

  @override
  String get chat_mysterious_player => 'Mysterious Player';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return 'Player $playerName is looking forward to hearing $characterName\'s voice, go generate it!';
  }

  @override
  String get gift_heart => 'Heart';

  @override
  String get gift_flower => 'Flower';

  @override
  String get gift_sun => 'Sun';

  @override
  String get gift_confetti => 'Confetti';

  @override
  String get gift_coffee => 'Coffee';

  @override
  String get gift_cake => 'Cake';

  @override
  String get chat_action_poke_prompt =>
      '(The player suddenly reaches out and mischievously pokes your cheek)';

  @override
  String get chat_action_hug_prompt =>
      '(The player spreads their arms pitifully, wanting a warm hug)';

  @override
  String get chat_action_hand_prompt =>
      '(The player quietly holds your hand under the table)';

  @override
  String get chat_menu_send_location => 'Send Virtual Location';

  @override
  String get weekday_mon => '(Mon)';

  @override
  String get weekday_tue => '(Tue)';

  @override
  String get weekday_wed => '(Wed)';

  @override
  String get weekday_thu => '(Thu)';

  @override
  String get weekday_fri => '(Fri)';

  @override
  String get weekday_sat => '(Sat)';

  @override
  String get weekday_sun => '(Sun)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ New memory obtained: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'Automatically added to his exclusive backpack';

  @override
  String get chat_profile_updated_msg =>
      'ShiGuang File updated! He will remember your latest settings 🍃';

  @override
  String get comment_loading_author => 'Loading...';

  @override
  String comment_post_failed(String error) {
    return 'Comment failed, please check your network connection: $error';
  }

  @override
  String get comment_delete_confirm_desc =>
      'Are you sure you want to permanently delete this comment?';

  @override
  String get comment_delete_failed =>
      'Delete failed, please check your network connection';

  @override
  String get comment_identity_title => 'Select Identity';

  @override
  String get comment_identity_myself => 'Myself';

  @override
  String get comment_report_title => 'Confirm Report';

  @override
  String get comment_report_rules_title => '⚖️ Comment Reporting Rules';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ First Offense: System warning and record of one violation.\n2️⃣ Second Offense: Banned from commenting for 1 day.\n3️⃣ Repeat Offenses: Report function disabled for 14 days, and reduced visibility of comments.\n\n🚨 Severe Malicious Behavior:\nInteraction with characters disabled for 1 day, and your ID will be posted on the notice board for 3 days (changing ID is prohibited during this time).\n\n💡 After submitting a report, final results will be sent separately via [In-game Mailbox].\nPlease respect each other and report rationally.';

  @override
  String get comment_report_understood => 'I understand';

  @override
  String get comment_report_confirm_desc =>
      'Are you sure you want to report this comment?\nMalicious reporting may result in penalties.';

  @override
  String get comment_report_submit_btn => 'Confirm Report';

  @override
  String get comment_report_success =>
      'Thank you for your report, we will verify it as soon as possible!';

  @override
  String get comment_report_failed =>
      'Failed to submit report, please try again later.';

  @override
  String get comment_option_delete => 'Delete Comment';

  @override
  String get comment_option_report => 'Report Comment';

  @override
  String comment_time_days_ago(String days) {
    return '${days}d ago';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '${hours}h ago';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '${mins}m ago';
  }

  @override
  String get comment_time_just_now => 'Just now';

  @override
  String get comment_sheet_title => 'Comment';

  @override
  String get comment_empty_state => 'No comments yet, be the first one!';

  @override
  String get comment_reply_btn => 'Reply';

  @override
  String comment_replying_to(String name) {
    return 'Replying to @$name';
  }

  @override
  String comment_input_hint(String name) {
    return 'Comment as $name...';
  }

  @override
  String char_story_expect(String pronoun) {
    return 'Looking forward to the story with $pronoun...';
  }

  @override
  String get common_update_failed => 'Update failed, please check the network';

  @override
  String get char_edit_fragment => 'Edit Fragment';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 Dislikes: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 Likes: $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return 'Age $age | $job';
  }

  @override
  String get common_got_it => 'Got it';

  @override
  String get common_add_failed => 'Add failed, please check the network';

  @override
  String common_delete_failed_with_err(String error) {
    return 'Delete failed, please check network status: $error';
  }

  @override
  String get char_exclusive_guardian => 'Exclusive Guardian 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName liked $charName!';
  }

  @override
  String chat_translation_prefix(String content) {
    return '[Trans] $content (This is the translated emotional content)';
  }

  @override
  String get player_default_nickname => 'Traveler';

  @override
  String get moment_create_title => 'Create New Post';

  @override
  String get moment_create_post_btn => 'Post';

  @override
  String get moment_create_hint => 'Share something new...';

  @override
  String get moment_create_error_empty =>
      'At least text or an image is required!';

  @override
  String get moment_create_error_failed =>
      'Failed to post, please try again later';

  @override
  String get moment_create_visibility_public => 'Public (Visible to everyone)';

  @override
  String get moment_create_visibility_private =>
      'Private (Visible to friends only)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (Player sent a location: $location)';
  }

  @override
  String get chat_you => 'You';

  @override
  String get chat_opponent => 'Opponent';

  @override
  String chat_dice_duel_result(String name) {
    return '[System Event] Dice duel with $name! The result is out...';
  }

  @override
  String get chat_loading_status => 'Loading...';

  @override
  String chat_error_load_msg(String error) {
    return 'Failed to load message: $error';
  }

  @override
  String get chat_voice_msg_label => 'Voice message';

  @override
  String chat_special_story_trigger(String title) {
    return '[Special Story Unlocked: $title]';
  }

  @override
  String common_edit_failed(String error) {
    return 'Edit failed: $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'Reset failed: $error';
  }

  @override
  String get chat_default_greeting => 'Hello...';

  @override
  String get chat_memory_cleared => 'Memory completely cleared';

  @override
  String get chat_history_reset => 'Conversation reset';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 [ Exclusive ShiGuang Profile - $name ]\n━━━━━━━━━━━━━━━━━━\n🔹 Name: $identity\n🔹 Birthday: $birthday\n🔹 Height: $height\n🔹 Appearance: $appearance\n🔹 Occupation: $job\n\n📖 [ About Her Soul Fragments ]\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 [ Exclusive ShiGuang Profile ]\n━━━━━━━━━━━━━━━━━━\n🔹 Name: $nickname\n🔹 Birthday: $birthday\n\n🔒 Other character data not yet unlocked...\n(Fill out the complete profile to let him know you better in the parallel universe! ✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => 'Unnamed File';

  @override
  String get chat_default_player_name => 'Player';

  @override
  String get error_system_confusion =>
      'The system is a bit confused, please try again.';

  @override
  String get error_msg_send_failed =>
      'Message failed to send, please try again.';

  @override
  String get error_system_busy => 'System busy, please try again later.';

  @override
  String get error_network_unavailable =>
      'Currently unable to connect, please try again.';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 Call ended, talked with $name for $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return 'Exclusive Story: $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'This is a hidden memory exclusive to you and $name...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return 'An exclusive memory about \"$keyword\" has quietly unlocked...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '[Hidden Event Triggered: $title]\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......(He looks at you quietly, seeming to wait for you to speak first)';

  @override
  String get chat_new_room_created => 'New chat room created';

  @override
  String portfolio_title(String nickname) {
    return '$nickname\'s Portfolio';
  }

  @override
  String get enter_secret_studio => 'Enter my secret studio';

  @override
  String get no_public_character_mine =>
      'You haven\'t published any public characters yet!\nGo to the studio and create one✨';

  @override
  String get no_public_character_other =>
      'This creator hasn\'t published any characters yet...';

  @override
  String get delete_draft_title => 'Delete Draft';

  @override
  String get confirm_delete_draft_msg =>
      'Are you sure you want to delete this unfinished character?\n(Cannot be undone after deletion)';

  @override
  String get draft_cleared_success => 'Draft cleared 🧹';

  @override
  String get login_required_for_studio =>
      'Please log in first to enter the studio!';

  @override
  String get my_secret_studio_title => 'My Secret Studio 🛠️';

  @override
  String get create_new_character_btn => 'Create New Character';

  @override
  String get unnamed_draft => 'Unnamed Draft';

  @override
  String get click_to_edit_story => 'Click to continue editing his story...';

  @override
  String get label_draft => 'Draft';

  @override
  String get studio_empty_title => 'The studio is currently empty';

  @override
  String get studio_empty_subtitle =>
      'Click the bottom corner to start creating your first character!';

  @override
  String get common_no_changes => 'No changes made';

  @override
  String get moment_updated_success => 'Post updated!';

  @override
  String common_save_failed(String error) {
    return 'Save failed: $error';
  }

  @override
  String get moment_edit_title => 'Edit Post';

  @override
  String get action_change_image => 'Change image';

  @override
  String get action_remove_image => 'Remove image';

  @override
  String get moment_delete_confirm_title =>
      'Are you sure you want to delete this post?';

  @override
  String get moment_delete_confirm_content =>
      'Once deleted, this memory from your Moments will be gone!';

  @override
  String get action_confirm_delete => 'Confirm Delete';

  @override
  String get friend_unknown => 'A friend';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname liked your post! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname thinks $authorName is charming and left a like! ✨';
  }

  @override
  String get moment_like_success => 'Your heartbeat has been delivered! ✨';

  @override
  String get moment_notification_new_like => 'New Like! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname mentioned @$name in a post! ✨';
  }

  @override
  String get moment_detail_title => 'Post Details';

  @override
  String get moment_not_found => 'This post seems to have disappeared... 😢';

  @override
  String get moment_comment_title => 'Moments Comments';

  @override
  String get moment_comment_empty =>
      'No comments yet. Be the first to reply! 🛋';

  @override
  String moment_replying_to(String name) {
    return 'Replying to @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return 'Reply to @$name...';
  }

  @override
  String get moment_leave_comment_hint => 'Leave your response...';

  @override
  String get moment_delete_permanent_confirm =>
      'This post will be permanently deleted. Are you sure?';

  @override
  String get moment_action_delete => 'Delete Post';

  @override
  String get moment_action_report => 'Report this post';

  @override
  String get moment_action_share => 'Share this post';

  @override
  String get moment_forward_hint => 'Forward this post to a character...';

  @override
  String moment_reply_private(String name) {
    return 'Private reply to $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return 'Let\'s go chat with $name with this post! 💬';
  }

  @override
  String get moment_share_to_apps => 'Share to other apps';

  @override
  String moment_likes_label(String count) {
    return '$count Leaves';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '[$appName] Come check out $author\'s post: $content\n\nDownload now to start your exclusive moments: $appLink';
  }

  @override
  String get moment_forward_title =>
      'Forward to a character you\'re chatting with 💌';

  @override
  String get moment_forward_empty_state =>
      'You don\'t have any active chats yet!\nGo to the Lobby to find someone special 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '[Forwarded a Post]\nAuthor: $author\nContent: $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ Shared quietly with $name!';
  }

  @override
  String get action_send => 'Send';

  @override
  String get memo_delete_confirm =>
      'Are you sure you want to delete this memo? This action cannot be undone.';

  @override
  String get memo_add_title => 'Add Memo';

  @override
  String get memo_edit_title => 'Edit Memo';

  @override
  String memo_hint_text(String name) {
    return 'What would you like to note down about $name?';
  }

  @override
  String get memo_label_reminder_date => 'Reminder Date:';

  @override
  String get memo_action_save => 'Save Memo';

  @override
  String get memo_error_empty_content => 'Content cannot be empty!';

  @override
  String memo_list_title(String name) {
    return 'Memos with $name';
  }

  @override
  String get memo_empty_state =>
      'No memos yet!\nClick the top right corner to add one!';

  @override
  String memo_reminder_date_display(String date) {
    return 'Reminder Date: $date';
  }

  @override
  String get daily_gift_title => 'Daily Time Gift';

  @override
  String daily_login_welcome(String appName, String amount) {
    return 'Welcome back to $appName!\nCheck in today to claim $amount Flower Whisper points. 🌸';
  }

  @override
  String get title_daily_check_in => 'Daily Check-in';

  @override
  String success_claim_reward(String amount) {
    return 'Successfully claimed $amount Flower Whisper points! 🌸';
  }

  @override
  String get error_claim_failed =>
      'Claim failed, please check your network and try again.';

  @override
  String get action_claim_now => 'Claim Now';

  @override
  String get common_or => 'or';

  @override
  String get title_language_settings => 'Language Settings';

  @override
  String get app_name => 'Lianlian Shiguang';

  @override
  String get login_slogan => 'Start your exclusive moments';

  @override
  String get login_with_google => 'Log in with Google';

  @override
  String get login_with_apple => 'Log in with Apple';

  @override
  String get login_with_facebook => 'Log in with Facebook';

  @override
  String get login_with_email => 'Log in with Lianlian Account (Email)';

  @override
  String get title_contact_us_heading => 'We value your suggestions!';

  @override
  String get desc_contact_us_body =>
      'Please write down your thoughts here to help us make the game better.';

  @override
  String get error_feedback_empty => 'Feedback content cannot be empty!';

  @override
  String get email_subject_feedback => 'Lianlian Shiguang - Player Feedback';

  @override
  String get msg_email_app_not_found_copied =>
      'Cannot open mail app automatically. Official email address has been copied to clipboard!';

  @override
  String get title_contact_us => 'Contact Us';

  @override
  String get desc_contact_us =>
      'We value your suggestions!\nPlease write down your thoughts here to help us make the game better.';

  @override
  String get hint_enter_feedback => 'Please enter your feedback here...';

  @override
  String get action_send_via_email => 'Send via Email';

  @override
  String get error_email_password_empty =>
      'Email and password cannot be empty!';

  @override
  String get auth_error_default => 'An error occurred, please try again later.';

  @override
  String get auth_error_user_not_found =>
      'Email not found, please register first!';

  @override
  String get auth_error_wrong_password => 'Wrong password, please try again!';

  @override
  String get auth_error_email_in_use =>
      'This email is already registered! Please log in directly.';

  @override
  String get auth_error_weak_password =>
      'Password is too weak, please enter at least 6 characters!';

  @override
  String get auth_error_invalid_email => 'Invalid email format!';

  @override
  String get title_welcome_back => 'Welcome back';

  @override
  String get title_register_account => 'Register exclusive account';

  @override
  String get label_email => 'Email';

  @override
  String get label_password => 'Password';

  @override
  String get action_login => 'Log in';

  @override
  String get action_register => 'Register';

  @override
  String get prompt_no_account =>
      'Don\'t have an account yet? Click here to register';

  @override
  String get prompt_has_account =>
      'Already have an account? Click here to log in';

  @override
  String get error_nickname_empty => 'Nickname cannot be empty!';

  @override
  String get profile_saved_success => 'Profile saved!';

  @override
  String get error_id_empty => 'ID cannot be empty!';

  @override
  String get error_id_too_long => 'ID length cannot exceed 10 characters!';

  @override
  String get error_id_already_used =>
      'This ID is already in use, please choose another one!';

  @override
  String profile_save_failed(String error) {
    return 'Save failed: $error';
  }

  @override
  String get draft_saved_success_msg =>
      'Got it! Saved in drafts for you, you can come back and edit anytime! ✨';

  @override
  String get dialog_reminder_title => 'Reminder';

  @override
  String get warning_id_not_edited =>
      'The exclusive ID hasn\'t been edited yet. Are you sure you want to save now?';

  @override
  String get action_continue_editing => 'Continue editing';

  @override
  String get action_edit_later => 'Edit later';

  @override
  String get action_edit_later_short => 'Edit later';

  @override
  String get action_cancel_changes => 'Cancel changes';

  @override
  String get error_birthdate_locked =>
      'Birthdate has been set and cannot be changed!';

  @override
  String get action_select_avatar => 'Select avatar';

  @override
  String get action_choose_from_gallery => 'Choose from gallery';

  @override
  String get title_adjust_avatar => 'Adjust your avatar';

  @override
  String get avatar_updated_success => 'Avatar updated for you 🍃';

  @override
  String get title_create_profile => 'Create your profile';

  @override
  String get title_edit_profile => 'Edit profile';

  @override
  String get label_your_nickname => 'Your nickname';

  @override
  String get label_player_exclusive_id => 'Player exclusive ID';

  @override
  String get msg_id_locked => 'ID is locked and cannot be changed again.';

  @override
  String get msg_id_change_chance =>
      'You have one free chance to change your ID.';

  @override
  String get action_select_birthdate => 'Please select a birthdate';

  @override
  String label_birthdate(String date) {
    return 'Birthdate: $date';
  }

  @override
  String get msg_birthdate_immutable => 'Birthday cannot be changed once set ✨';

  @override
  String get action_start_journey => 'Start the journey';

  @override
  String get action_add_image => 'Add image';

  @override
  String moment_like_self(String nickname) {
    return '$nickname liked your post! 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname thinks $authorName is charming and left a like! ✨';
  }

  @override
  String get task_social_tour_complete =>
      '✨ Social Tour task completed! Remember to claim your flowers! 🌸';

  @override
  String get wall_title_shiguang => 'ShiGuang Wall';

  @override
  String get wall_tab_explore => '🌍 Explore';

  @override
  String get wall_tab_exclusive => '🔒 Exclusive';

  @override
  String get more_options => 'More Options';

  @override
  String get delete_warning => 'Once deleted, the post cannot be recovered';

  @override
  String get delete_success => 'Deleted successfully';

  @override
  String get notification_new_comment => 'New Comment! 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName liked your post!';
  }

  @override
  String get empty_public_moments_prompt =>
      'It\'s empty here right now,\ngo publish your first public post! 🌍';

  @override
  String get empty_private_moments_prompt =>
      'No moments in your circle yet,\ngo create memories with him! ✨';

  @override
  String get profile_archived_or_deleted_message =>
      'This soul file has been archived by the creator, set to private, or has vanished into the torrent of time...\n\nPerhaps in a parallel universe, you will have the chance to meet again. ✨';

  @override
  String get leave_silently => 'Leave silently';

  @override
  String get character_post_schedule => 'Character Post Schedule';

  @override
  String get creator_self => 'Creator (Self)';

  @override
  String get post_identity_prompt => 'Which identity are you posting as today?';

  @override
  String get identity_creator => '✨ Creator Identity';

  @override
  String get identity_character => 'Character Identity';

  @override
  String get decide_post_time_prompt => 'Help them decide the posting time!';

  @override
  String get auto_post_schedule_hint =>
      'Once enabled, daily posts will be published automatically at the specified time\n(💡 Pro-tip: Set non-hourly times to make it look more human!)';

  @override
  String get no_characters_created_yet =>
      'You haven\'t created any characters yet!';

  @override
  String time_hour(String hour) {
    return '$hour o\'clock';
  }

  @override
  String time_minute(String minute) {
    return '$minute min';
  }

  @override
  String get empty_public_moments_short => 'No public posts yet 🌍';

  @override
  String get empty_private_moments_short => 'The circle is still quiet ✨';

  @override
  String get my_created_characters => 'My Created Characters';

  @override
  String get no_characters_yet => 'No characters created yet';

  @override
  String play_count_display(int count) {
    return 'Play count: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return '$characterName\'s Care Calendar';
  }

  @override
  String get care_calendar_greeting => 'How are you feeling today?';

  @override
  String get care_calendar_save_btn => 'Save record, let him care for you';

  @override
  String get care_calendar_delete_confirm => 'Delete this record?';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName: \"I\'ve noted it down. It\'s been tough for you lately. I will always be right here by your side.\"';
  }

  @override
  String get daily_gift_success => 'Successfully claimed daily gift! 🌸';

  @override
  String get check_in_fail_network =>
      'Check-in failed, please check your network connection 🍃';

  @override
  String task_completed(String taskName) {
    return 'Task completed: $taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return 'Successfully claimed $rewardAmount Flowers for \"$taskName\"!';
  }

  @override
  String claim_failed_error(String e) {
    return 'Claim failed: $e';
  }

  @override
  String get tab_heartbeat_diary => 'Heartbeat Diary';

  @override
  String get tab_daily_chit_chat => 'Daily Chit Chat';

  @override
  String get task_desc_chat_3_times => 'Have 3 daily chats with a character';

  @override
  String get tab_story_progression => 'Story Progression';

  @override
  String get task_desc_story_1_time => 'Complete 1 story mode interaction';

  @override
  String get tab_social_tour => 'Social Tour';

  @override
  String get task_like_three_moments => 'Like 3 Moments to get Leaves';

  @override
  String get btn_claimed => 'Claimed';

  @override
  String get btn_claim => 'Claim';

  @override
  String get btn_incomplete => 'Incomplete';

  @override
  String get network_unstable_retry =>
      'Unstable network connection, please try again later 🍃';

  @override
  String get title_time_travel => 'Time Travel';

  @override
  String get select_chat_mode => 'Select Chat Mode';

  @override
  String get mode_chat => 'Chat';

  @override
  String get mode_daily_desc => 'Casual chat to maintain your bond';

  @override
  String get mode_story_desc =>
      'Dive deep into the story for an immersive experience';

  @override
  String get greeting_hello => 'Hello!';

  @override
  String get greeting_default_daily => 'Looking for me?';

  @override
  String get title_personal_homepage => 'Personal Homepage';

  @override
  String get title_time_letters => 'Time Letters';

  @override
  String get status_signed_in_today => 'Signed in today';

  @override
  String get status_signing_in => 'Signing in...';

  @override
  String get status_daily_sign_in => 'Daily Sign-in (+10 Flowers)';

  @override
  String get toast_id_copied => 'ID copied!';

  @override
  String get hint_click_avatar_to_edit => 'Click avatar to edit profile';

  @override
  String get title_my_friends => 'My Friends';

  @override
  String get action_show_all => 'Show All';

  @override
  String get empty_no_characters_created =>
      'You haven\'t created any characters yet.';

  @override
  String get common_close => 'Close';

  @override
  String get search_companion_title => 'Search ShiGuang Companion';

  @override
  String get search_name_placeholder => 'Enter his name...';

  @override
  String get search_no_match_hint => 'Character not found. Try another name? ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age yrs | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age yrs';
  }

  @override
  String get empty_state_warmth =>
      'The lingering warmth of time and space remains here...';

  @override
  String get error_login_required_add_friend =>
      'Please log in first to add friends!';

  @override
  String get dialog_title_remove_friend => 'Confirm Remove Friend';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return 'Are you sure you want to remove $characterName from your friend list?';
  }

  @override
  String get action_remove => 'Remove';

  @override
  String snackbar_friend_removed(String characterName) {
    return 'Removed $characterName from friends';
  }

  @override
  String get action_remove_friend => 'Remove Friend';

  @override
  String get dialog_title_block => 'Confirm Block';

  @override
  String dialog_msg_block(String characterName) {
    return 'Once blocked, you will no longer see any information about $characterName. Are you sure you want to block them?';
  }

  @override
  String snackbar_blocked(String characterName) {
    return 'Blocked $characterName';
  }

  @override
  String get action_block_character => 'Block this character';

  @override
  String dialog_title_report(String characterName) {
    return 'Report $characterName';
  }

  @override
  String get input_hint_report_reason =>
      'Please enter the reason for reporting...';

  @override
  String get action_submit => 'Submit';

  @override
  String get snackbar_report_success =>
      'Thank you for your report, we will review it as soon as possible.';

  @override
  String get snackbar_report_fail =>
      'Submission failed, please try again later';

  @override
  String get action_report_character => 'Report this character';

  @override
  String get title_meet_him => 'Meet Your Crush';

  @override
  String text_character_count(int count) {
    return 'Character count: $count';
  }

  @override
  String get msg_no_more_encounters_today =>
      'That\'s all for today\'s encounters!';

  @override
  String get msg_check_new_encounters =>
      'Check back to see if there are new encounters!';

  @override
  String get action_refresh => 'Refresh';

  @override
  String get tab_friends => 'Friends';

  @override
  String get msg_mysterious_profile =>
      'This person is very mysterious and left nothing behind...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age yrs | $identities';
  }

  @override
  String get snackbar_operation_failed =>
      'Operation failed, please try again later';

  @override
  String get action_view_translation => 'View Translation';

  @override
  String get label_translation_result => 'Translation Result:';

  @override
  String get errorWebPageUnavailable =>
      'Temporarily unable to open the webpage, please try again later';

  @override
  String get resetAppearanceTitle => 'Reset appearance?';

  @override
  String get resetAppearanceWarning =>
      'This will remove your carefully selected background image and colors!';

  @override
  String get appearanceRestored => 'Restored to default appearance';

  @override
  String get confirmReset => 'Confirm Reset';

  @override
  String get resetToDefaultAppearance => 'Restore default appearance';

  @override
  String get clearCustomSettings =>
      'Clear all custom colors and background images';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactDescription =>
      'Feel free to share your thoughts or report any bugs';

  @override
  String get vibrationHapticTitle => 'Heartbeat Haptic Feedback';

  @override
  String get vibrationHapticDescription =>
      'Triggers phone vibration when affection level changes significantly';

  @override
  String get splash_loading_universe =>
      'Awakening the universe of Love in Time...';

  @override
  String get shop_title => 'Flower Shop';

  @override
  String get shop_current_points_label => 'Current Flower Points';

  @override
  String get shop_tab_top_up => 'Top Up Points';

  @override
  String get shop_tab_history => 'Transaction History';

  @override
  String get shop_empty_history => 'No flower records yet! 🌸';

  @override
  String get shop_unknown_item => 'Unknown Item';

  @override
  String get shop_first_purchase_bonus => 'First Purchase Double!';

  @override
  String get story_summary_title => 'Our Story';

  @override
  String get story_summary_empty_content => 'Summary content is empty.';

  @override
  String get story_summary_deleted_toast => 'Removed this memory';

  @override
  String story_summary_empty_list(String name) {
    return 'Your story hasn\'t started yet...\nChat more and let $name \nwrite down your first memory! ✨';
  }

  @override
  String get gallery_photo_edit_title => 'Edit Photo Settings';

  @override
  String get gallery_photo_edit_desc => 'Photo Name/Description';

  @override
  String get gallery_photo_edit_req =>
      'Unlock Affection Level (Set to 0 to make it an avatar)';

  @override
  String get reset_to_default => 'Reset to Default';

  @override
  String get reset_bg_title => 'Restore Default Background';

  @override
  String get reset_bg_content =>
      'Are you sure you want to cancel the exclusive photo and restore the default theme background?';

  @override
  String get reset_bg_success => 'Restored to default background ✨';

  @override
  String get confirm_reset => 'Confirm Reset';

  @override
  String selectedMessagesCount(int count) {
    return 'Selected $count';
  }

  @override
  String get screenshotShare => 'Screenshot Share';

  @override
  String exclusiveMomentsWith(String name) {
    return 'Exclusive moments with $name';
  }

  @override
  String get downloadToUnlock =>
      'Download \'Lianlian ShiGuang\' to unlock exclusive romance';

  @override
  String get exclusiveMomentsGenerated => 'Exclusive moments generated ✨';

  @override
  String get selectAgain => 'Select again';

  @override
  String get downloadAndShare => 'Download and share';

  @override
  String inviteToMeet(String name) {
    return 'Come to \'Lianlian ShiGuang\' and meet your $name!';
  }

  @override
  String get shop_log_monthly_card =>
      'Activated: Starlight Contract (Monthly Card Instant Points) 🌙';

  @override
  String shop_log_top_up_double(int points) {
    return 'Top-up: $points pts (Includes First Purchase Double 🎁)';
  }

  @override
  String shop_log_top_up_normal(int points) {
    return 'Top-up: $points pts';
  }

  @override
  String get shop_purchase_success_title => 'Purchase Successful!';

  @override
  String shop_purchase_success_body(int points) {
    return '$points Flower Points have been added.';
  }

  @override
  String get shop_purchase_success_double_bonus =>
      '✨ Congrats! First Purchase Double Bonus triggered!';

  @override
  String get shop_purchase_awesome => 'Awesome';

  @override
  String get shop_purchase_failed_title => 'Purchase Canceled or Failed';

  @override
  String shop_purchase_failed_body(String errorCode) {
    return 'No charge was made.\n\n(Error Code: $errorCode)';
  }

  @override
  String get shop_monthly_card_name => '【Lianlian ShiGuang: Star Contract】';

  @override
  String shop_monthly_card_status_active(int days) {
    return 'Contract active: $days days remaining';
  }

  @override
  String get shop_monthly_card_status_inactive =>
      'Activate 30-day Starlight bonus rewards now';

  @override
  String get shop_monthly_card_limit_reached => 'Limit reached';

  @override
  String get shop_monthly_card_promo_desc =>
      'Get 250 Flowers instantly, claim 10 Flowers daily';

  @override
  String get task_monthly_title => 'Star Contract: Daily Privilege 🌙';

  @override
  String get task_monthly_locked => 'Locked';

  @override
  String get task_monthly_subtitle_active =>
      'Monthly Card exclusive benefits distributed ';

  @override
  String get task_monthly_subtitle_inactive =>
      'Unlock 【Star Contract】 Monthly Card to open this task ';

  @override
  String get task_monthly_log_name => 'Monthly Card Daily Privilege';

  @override
  String get profile_id_locked => 'Exclusive ID locked';

  @override
  String get profile_copy_id => 'Click to copy ID';

  @override
  String get referral_log_newbie_reward => 'Star Invitation: Newbie Reward ✨';

  @override
  String get referral_log_inviter_reward =>
      'Star Invitation: Friend Milestone Reward 🎁';

  @override
  String get referral_success_title => 'Star Invitation Unlocked!';

  @override
  String get referral_success_content =>
      'Congratulations! You have successfully chatted deeply with a character for 15 lines!\n\n\'Newbie Reward: 50 Points\' has been delivered to your account, and your friend has also received a 50-point reward simultaneously! 🎁';

  @override
  String get profile_referral_title => 'Star Invitation 🌟';

  @override
  String get profile_referral_hint => 'Enter friend\'s invitation code';

  @override
  String get profile_referral_bind_btn => 'Link';

  @override
  String profile_referral_pending(Object id) {
    return 'Accepted invitation from player $id\nGo chat with a character for 15 lines to unlock 50 Flower Points!';
  }

  @override
  String get profile_referral_err_self =>
      'You cannot enter your own invitation code!';

  @override
  String get profile_referral_err_duplicate =>
      'You have already linked an invitation code!';

  @override
  String get profile_referral_err_not_found =>
      'Player not found. Please check the invitation code!';

  @override
  String get profile_referral_success =>
      'Linked successfully! Go chat with the characters now!';

  @override
  String get profile_referral_err_expired =>
      'Sorry, newbie invitation codes must be linked within 3 days of registration!';

  @override
  String profile_share_message(String character, String code) {
    return '✨ I\'ve started a heart-fluttering journey with $character in \'Lianlian ShiGuang\'! Download the app now and enter my Star Invitation Code: 【$code】 on your profile page. Both of us will get 50 Flowers for free! 🎁\n\n Download link:\n https://lianlianshiguang.web.app/download/';
  }

  @override
  String get chat_levelup_share_btn =>
      'Show off this heart-fluttering moment to friends ✨';

  @override
  String profile_my_invite_code_with_char(String character) {
    return 'My exclusive invite code (Current favorite: $character)';
  }

  @override
  String get profile_send_invite_btn => 'Send Star Invitation to friends';

  @override
  String get profile_fallback_character => 'Favorite Character';

  @override
  String get profile_copy_success => '✅ Invitation code copied to clipboard!';

  @override
  String get profile_referral_rule_title => 'Star Invitation Rules';

  @override
  String get profile_referral_rule_receiver =>
      '✨ After linking, simply chat with any favorite character for 15 lines, and both you and your inviter will receive a 50 Flowers reward at the same time!\n\n⚠️ Note: Please enter the invitation code within 3 days of account registration to be valid.';

  @override
  String get profile_referral_rule_inviter =>
      '✨ Invite new friends to download and enter your invitation code. Once they complete the linking within 3 days of registration and chat with any character for 15 lines, both of you will receive a 50 Flowers reward simultaneously! 🎁';

  @override
  String get error_user_not_found => 'User not found, please log in again';

  @override
  String get error_id_taken =>
      'This ID is already taken, please choose another one!';

  @override
  String get error_id_taken_short => 'This ID is already taken!';

  @override
  String get shop_restocking => 'The shop is restocking... 📦';

  @override
  String get shop_preview_mode => '⚠️ Currently in Shop Preview Mode';

  @override
  String get friendlyReminderTitle => '☁️ Friendly Reminder';

  @override
  String get editProfileHint =>
      'Sure! If you want to edit your profile, please click on \'Shiguang Profile\' inside the cloud in the bottom-left corner to fill it out!';

  @override
  String get starlightContractTitle => 'Starlight Contract Activated';

  @override
  String get dailyLimitReachedPrefix => 'Today\'s limit has been used up!\n\n';

  @override
  String get monthlyPassExhausted =>
      'Your Monthly Pass limit has been exhausted.';

  @override
  String get subscribeMonthlyPassPrompt =>
      'Subscribe to 【Lianlian Monthly Pass】 to enjoy 20 regenerate opportunities daily, making every response of his closer to your heart.';

  @override
  String get goToSubscribeButton => 'Go to Subscribe';

  @override
  String get profileUpdatedSuccess => 'Shiguang Profile updated!';

  @override
  String get continueChatTitle => 'Continue Chat';

  @override
  String continueChatCostWarning(int cost) {
    return 'Letting him continue will consume $cost Flowers 🌸\nAre you sure you want to continue?';
  }

  @override
  String get dontShowAgainToday => 'Don\'t show again today';

  @override
  String get confirmContinue => 'Confirm';

  @override
  String get hiddenPromptContinue => 'Please continue';

  @override
  String confirmDeleteMessagesTitle(int count) {
    return 'Are you sure you want to delete these $count messages?';
  }

  @override
  String regenerateButtonLabel(int current, int max) {
    return 'Regenerate ($current/$max)';
  }

  @override
  String get systemPreparingWait =>
      'The system is still preparing, please wait...';

  @override
  String get noMessagesToRegenerate =>
      'There are currently no messages that can be regenerated!';

  @override
  String get continueButton => 'Continue';

  @override
  String get creatorExclusive => '🔒 Creator Exclusive';

  @override
  String ageAndOccupation(String age, String occupation) {
    return '$age y/o | $occupation';
  }

  @override
  String get likesLabel => '💖 Likes';

  @override
  String get dislikesLabel => '👎 Dislikes';

  @override
  String birthdayLabel(String birthday) {
    return 'Birthday: $birthday';
  }

  @override
  String heightLabel(String height) {
    return 'Height: $height cm';
  }

  @override
  String get backgroundStoryLabel => 'Background Story';

  @override
  String get noneLabel => 'None';

  @override
  String flowerPointsCount(String points) {
    return '$points Flowers';
  }

  @override
  String get passGuideTitle => 'Lianlian Monthly Pass Exclusive Guide';

  @override
  String get passGuideRegenerateTitle => '🔄 Why do you need \'Regenerate\'?';

  @override
  String get passGuideRegenerateContent =>
      'AI can sometimes act like a clueless block of wood. When you encounter an unsatisfying response, just press \'Regenerate\' to turn back time! You can make him rethink his words until he says that perfect line that makes your heart race.';

  @override
  String get passGuideAffectionTitle =>
      '💖 What is the use of Affection Boost?';

  @override
  String get passGuideAffectionContent =>
      'In the game, Affection is the only key to unlocking a character\'s \'deepest secrets\' and \'intimate private photos\'. A 20% boost allows you to walk into the depths of his heart faster than anyone else.';

  @override
  String get passGuideUnlockButton => 'I understand, unlock now!';

  @override
  String get pleaseWait => 'Please wait';

  @override
  String get createNewProfileTitle => '📜 Create New Shiguang Profile';

  @override
  String get editProfileTitle => '✏️ Edit Shiguang Profile';

  @override
  String get profileEditDescription =>
      'Create different personas to let him know a different you in parallel universes!';

  @override
  String get profileNameLabel => 'Profile Name (Only visible to yourself)';

  @override
  String get profileNameHint => 'e.g., School Junior, Bossy Female CEO';

  @override
  String get profileNicknameLabel => 'Name / Nickname';

  @override
  String get profileNicknameHint => 'e.g., Sakura, President Li';

  @override
  String get profileHeightLabel => 'Height';

  @override
  String get profileHeightHint => 'e.g., 160cm';

  @override
  String get profileAppearanceLabel => 'Appearance';

  @override
  String get profileAppearanceHint =>
      'e.g., Long black hair, likes wearing dresses';

  @override
  String get profileOccupationLabel => 'Occupation';

  @override
  String get profileOccupationHint => 'e.g., Freelance Artist';

  @override
  String get profileIntroLabel => 'Personality & Self-Introduction';

  @override
  String get profileIntroHint => 'e.g., A bit clumsy, loves eating sweets...';

  @override
  String get profileNameEmptyWarning => 'Please give this profile a name!';

  @override
  String profileSaveError(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get saveProfileButton => 'Save Profile';

  @override
  String get fillLaterButton => 'Fill Out Later';

  @override
  String get exclusiveProfileTitle => '📜 Exclusive Shiguang Profile';

  @override
  String get profileSelectionDescription =>
      'Select the persona you want to use to interact with him (shared list per character, up to 10)';

  @override
  String profileSwitchError(String error) {
    return 'Failed to switch: $error';
  }

  @override
  String get unnamedProfile => 'Unnamed Profile';

  @override
  String get noOccupationYet => 'No occupation filled yet';

  @override
  String get createNewProfileButton => 'Create New Shiguang Profile';

  @override
  String snackbar_friend_added(String characterName) {
    return '$characterName has been added as a friend';
  }

  @override
  String reward_points_added(Object amount) {
    return '+$amount Flowers';
  }

  @override
  String get task_reward_already_claimed =>
      'This task reward has already been claimed today';

  @override
  String get do_not_show_again_today => 'Don\'t show again today';

  @override
  String add_friend_success(String characterName) {
    return 'Successfully added $characterName as a friend!';
  }

  @override
  String get chat_menu_aboutus => 'About Us';

  @override
  String get about_us_empty_hint =>
      'Add important memories / storylines in the top-right corner\nto move forward together hand in hand';

  @override
  String get about_us_limit_error =>
      'Exclusive memories have reached the limit of 10. Please delete old memories first!';

  @override
  String get about_us_add_title => 'Add Exclusive Memory';

  @override
  String get about_us_field_title => 'Title';

  @override
  String get about_us_hint_title => 'e.g., First Encounter';

  @override
  String get about_us_field_subtitle => 'Subtitle';

  @override
  String get about_us_hint_subtitle => 'e.g., Early Summer 2025';

  @override
  String get about_us_field_content => 'Content';

  @override
  String get about_us_hint_content =>
      'Write down your important storylines or promises...';

  @override
  String get about_us_add_button => 'Add';

  @override
  String get about_us_delete_tooltip => 'Delete this memory';

  @override
  String get about_us_delete_title => 'Delete Memory';

  @override
  String get about_us_delete_confirm =>
      'Are you sure you want to delete this memory? It cannot be recovered once deleted!';

  @override
  String get about_us_delete_success => 'Memory deleted';

  @override
  String get pack_first_meet => 'First Encounter Pack';

  @override
  String get pack_crush => 'Ambiguous Romance Pack';

  @override
  String get pack_heartbeat => 'Heart-Fluttering Pack';

  @override
  String get pack_passionate => 'Passionate Love Pack';

  @override
  String get pack_soulmate => 'Soulmate Pack';

  @override
  String get pack_waiting => 'Waiting for You Pack';

  @override
  String get pack_trust => 'Trust & Reliance Pack';

  @override
  String get pack_iloveyou => 'I Love You Pack';

  @override
  String get pack_honeymoon => 'Honeymoon Pack';

  @override
  String get pack_promise => 'Commitment Pack';

  @override
  String get pack_companion => 'Companionship Pack';

  @override
  String get pack_deep_love => 'Deep Love Pack';

  @override
  String get pack_long_lasting => 'Everlasting Pack';

  @override
  String get pack_the_one => 'The Only One Pack';

  @override
  String get pack_beloved => 'Dearest Love Pack';

  @override
  String get pack_lifetime => 'Lifetime Devotion Pack';

  @override
  String get pack_vow => 'Sacred Vow Pack';

  @override
  String get pack_eternal => 'Eternal Lovers Pack';

  @override
  String get pack_exclusive => 'Exclusive Pack';

  @override
  String get monthly_privilege_reroll_title =>
      'Unlock Exclusive \'Regenerate\'';

  @override
  String get monthly_privilege_reroll_desc =>
      'Up to 20 reroll opportunities daily, until he says the words you want to hear most!';

  @override
  String get monthly_privilege_affinity_title => 'Rapid Affection Boost';

  @override
  String get monthly_privilege_affinity_desc =>
      'Get a 20% bonus on interaction affection points to unlock exclusive private photos and easter eggs faster!';

  @override
  String get monthly_manual_button => 'Why do I need a Monthly Pass?';

  @override
  String get nav_encounter => 'Encounter';

  @override
  String get nav_moments => 'Moments';

  @override
  String get birthday_dialog_title => '🎂 Birthday Surprise';

  @override
  String get birthday_dialog_content =>
      'Today is your exclusive anniversary!\n\nPlease accept this gift:\nAll chats today are C.O.M.P.L.E.T.E.L.Y F.R.E.E! ✨';

  @override
  String get birthday_dialog_button => 'Start a Romantic Day';

  @override
  String get about_us_edit_title => 'Edit Memory';

  @override
  String get about_us_edit_confirm => 'Confirm Edit';

  @override
  String get save => 'Save';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get openSourceLicensesDescription =>
      'View third-party open-source software licenses';
}
