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
}
