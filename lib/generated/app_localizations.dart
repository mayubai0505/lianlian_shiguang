import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('pt'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get changeTheme;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @allFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'All Friends'**
  String get allFriendsTitle;

  /// No description provided for @noFriendsMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any friends yet.'**
  String get noFriendsMessage;

  /// No description provided for @unknownCharacter.
  ///
  /// In en, this message translates to:
  /// **'Unknown Character'**
  String get unknownCharacter;

  /// No description provided for @errorLoadingFriends.
  ///
  /// In en, this message translates to:
  /// **'Error loading friends list: {error}'**
  String errorLoadingFriends(String error);

  /// No description provided for @tagGentle.
  ///
  /// In en, this message translates to:
  /// **'Gentle'**
  String get tagGentle;

  /// No description provided for @tagCheerful.
  ///
  /// In en, this message translates to:
  /// **'Cheerful'**
  String get tagCheerful;

  /// No description provided for @tagLively.
  ///
  /// In en, this message translates to:
  /// **'Lively'**
  String get tagLively;

  /// No description provided for @tagMischievous.
  ///
  /// In en, this message translates to:
  /// **'Mischievous'**
  String get tagMischievous;

  /// No description provided for @tagRichYoungLady.
  ///
  /// In en, this message translates to:
  /// **'Heiress'**
  String get tagRichYoungLady;

  /// No description provided for @tagRichYoungMaster.
  ///
  /// In en, this message translates to:
  /// **'Young Master'**
  String get tagRichYoungMaster;

  /// No description provided for @tagWealthyFamily.
  ///
  /// In en, this message translates to:
  /// **'Wealthy Family'**
  String get tagWealthyFamily;

  /// No description provided for @tagScheming.
  ///
  /// In en, this message translates to:
  /// **'Scheming'**
  String get tagScheming;

  /// No description provided for @tagPossessive.
  ///
  /// In en, this message translates to:
  /// **'Possessive'**
  String get tagPossessive;

  /// No description provided for @tagParanoid.
  ///
  /// In en, this message translates to:
  /// **'Paranoid'**
  String get tagParanoid;

  /// No description provided for @tagPersistent.
  ///
  /// In en, this message translates to:
  /// **'Persistent'**
  String get tagPersistent;

  /// No description provided for @tagUncle.
  ///
  /// In en, this message translates to:
  /// **'Uncle'**
  String get tagUncle;

  /// No description provided for @tagAuntie.
  ///
  /// In en, this message translates to:
  /// **'Auntie'**
  String get tagAuntie;

  /// No description provided for @tagSeniorSister.
  ///
  /// In en, this message translates to:
  /// **'Senior (female)'**
  String get tagSeniorSister;

  /// No description provided for @tagJuniorBrother.
  ///
  /// In en, this message translates to:
  /// **'Junior (male)'**
  String get tagJuniorBrother;

  /// No description provided for @tagHandsome.
  ///
  /// In en, this message translates to:
  /// **'Handsome'**
  String get tagHandsome;

  /// No description provided for @tagStunning.
  ///
  /// In en, this message translates to:
  /// **'Stunning'**
  String get tagStunning;

  /// No description provided for @tagContrast.
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get tagContrast;

  /// No description provided for @tagFlirty.
  ///
  /// In en, this message translates to:
  /// **'Flirty'**
  String get tagFlirty;

  /// No description provided for @tagAgeGap.
  ///
  /// In en, this message translates to:
  /// **'Age Gap'**
  String get tagAgeGap;

  /// No description provided for @userNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFoundError;

  /// No description provided for @imageDataMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Image data mismatch, please reselect images.'**
  String get imageDataMismatchError;

  /// No description provided for @createCharacterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Character'**
  String get createCharacterTitle;

  /// No description provided for @charAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Character Album (First is main avatar)'**
  String get charAlbumTitle;

  /// No description provided for @charNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Character Name:*'**
  String get charNameLabel;

  /// No description provided for @charDescSection.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get charDescSection;

  /// No description provided for @charAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get charAgeLabel;

  /// No description provided for @charJobLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupation:*'**
  String get charJobLabel;

  /// No description provided for @charBirthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday (MMDD)'**
  String get charBirthdayLabel;

  /// No description provided for @charGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender *'**
  String get charGenderLabel;

  /// No description provided for @genderNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not Selected'**
  String get genderNotSelected;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @charHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get charHeightLabel;

  /// No description provided for @charAppearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get charAppearanceLabel;

  /// No description provided for @charPersonalityTagsSection.
  ///
  /// In en, this message translates to:
  /// **'Personality Tags'**
  String get charPersonalityTagsSection;

  /// No description provided for @charOtherPersonalityTagsHint.
  ///
  /// In en, this message translates to:
  /// **'Other personality tags...'**
  String get charOtherPersonalityTagsHint;

  /// No description provided for @otherSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherSectionTitle;

  /// No description provided for @charLikesLabel.
  ///
  /// In en, this message translates to:
  /// **'Likes (e.g., strawberry cake, cats, rainy days)'**
  String get charLikesLabel;

  /// No description provided for @charDislikesLabel.
  ///
  /// In en, this message translates to:
  /// **'Dislikes (e.g., bitter melon, noisy places)'**
  String get charDislikesLabel;

  /// No description provided for @charSecretsLabel.
  ///
  /// In en, this message translates to:
  /// **'Little secrets (e.g., actually has no sense of direction)'**
  String get charSecretsLabel;

  /// No description provided for @charMannerismsSection.
  ///
  /// In en, this message translates to:
  /// **'Mannerisms'**
  String get charMannerismsSection;

  /// No description provided for @charToneLabel.
  ///
  /// In en, this message translates to:
  /// **'Tone & Style (e.g., cold to strangers)'**
  String get charToneLabel;

  /// No description provided for @charDialogueExampleLabel.
  ///
  /// In en, this message translates to:
  /// **'Dialogue Example (Player: You\'re so kind! Character: ...Oh.)'**
  String get charDialogueExampleLabel;

  /// No description provided for @charBackgroundSection.
  ///
  /// In en, this message translates to:
  /// **'Background:'**
  String get charBackgroundSection;

  /// No description provided for @charBackgroundHint.
  ///
  /// In en, this message translates to:
  /// **'Enter character\'s background story (max 2500 chars)'**
  String get charBackgroundHint;

  /// No description provided for @charStoryStartSection.
  ///
  /// In en, this message translates to:
  /// **'Story Opening:'**
  String get charStoryStartSection;

  /// No description provided for @charStoryStartHint.
  ///
  /// In en, this message translates to:
  /// **'Enter character\'s story opening (max 2500 chars)'**
  String get charStoryStartHint;

  /// No description provided for @charStorySummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Story Summary (max 50 chars, shown on encounter card)'**
  String get charStorySummaryLabel;

  /// No description provided for @charExtraInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Additional Info:'**
  String get charExtraInfoSection;

  /// No description provided for @charExtraInfoHint.
  ///
  /// In en, this message translates to:
  /// **'Enter additional info...'**
  String get charExtraInfoHint;

  /// No description provided for @charPublicToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'Make public for other players?'**
  String get charPublicToggleLabel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @exitCreationTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Character Creation'**
  String get exitCreationTitle;

  /// No description provided for @saveDraftPrompt.
  ///
  /// In en, this message translates to:
  /// **'Save as draft?'**
  String get saveDraftPrompt;

  /// No description provided for @draftNeeded.
  ///
  /// In en, this message translates to:
  /// **'Yes, save'**
  String get draftNeeded;

  /// No description provided for @draftNotNeeded.
  ///
  /// In en, this message translates to:
  /// **'No, discard'**
  String get draftNotNeeded;

  /// No description provided for @editExtraInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Additional Info'**
  String get editExtraInfoTitle;

  /// No description provided for @nameAndAvatarError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name and upload at least one avatar!'**
  String get nameAndAvatarError;

  /// No description provided for @savingStatus.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingStatus;

  /// No description provided for @uploadingImagesStatus.
  ///
  /// In en, this message translates to:
  /// **'Uploading images...'**
  String get uploadingImagesStatus;

  /// No description provided for @maxImagesError.
  ///
  /// In en, this message translates to:
  /// **'You can upload a maximum of 10 images.'**
  String get maxImagesError;

  /// No description provided for @uploadingImagesStatusShort.
  ///
  /// In en, this message translates to:
  /// **'Processing images...'**
  String get uploadingImagesStatusShort;

  /// No description provided for @savingCharacterData.
  ///
  /// In en, this message translates to:
  /// **'Saving character data...'**
  String get savingCharacterData;

  /// No description provided for @characterCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Character \"{charName}\" created!'**
  String characterCreatedSuccess(String charName);

  /// No description provided for @uploadImageTimeoutError.
  ///
  /// In en, this message translates to:
  /// **'Character creation failed: image upload timed out, please check your internet connection.'**
  String get uploadImageTimeoutError;

  /// No description provided for @createCharacterGenericError.
  ///
  /// In en, this message translates to:
  /// **'Character creation failed: {error}'**
  String createCharacterGenericError(String error);

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance & Content'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account & Content Management'**
  String get settingsSectionAccount;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get settingsSectionAbout;

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'ID:'**
  String get userId;

  /// No description provided for @authMethodGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get authMethodGoogle;

  /// No description provided for @authMethodUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get authMethodUnknown;

  /// No description provided for @userIdCopied.
  ///
  /// In en, this message translates to:
  /// **'User ID copied to clipboard'**
  String get userIdCopied;

  /// No description provided for @characterManagement.
  ///
  /// In en, this message translates to:
  /// **'Character Management'**
  String get characterManagement;

  /// No description provided for @viewBlockedCharacters.
  ///
  /// In en, this message translates to:
  /// **'View blocked characters'**
  String get viewBlockedCharacters;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutButton;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? (´;ω;`)'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Oops, cancel'**
  String get logoutDialogActionCancel;

  /// No description provided for @logoutDialogActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get logoutDialogActionConfirm;

  /// No description provided for @logoutSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Okay! I\'ll be waiting for your return ♥(´∀` )'**
  String get logoutSuccessSnackbar;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this account? இдஇ'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All data will be permanently deleted!'**
  String get deleteAccountDialogContent;

  /// No description provided for @deleteAccountDialogActionCancel.
  ///
  /// In en, this message translates to:
  /// **'No, I don\'t want to delete'**
  String get deleteAccountDialogActionCancel;

  /// No description provided for @deleteAccountDialogActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get deleteAccountDialogActionConfirm;

  /// No description provided for @deleteAccountSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Account successfully deleted.'**
  String get deleteAccountSuccessSnackbar;

  /// No description provided for @appDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'The characters and scenes in the game are fictional. Please do not apply them to reality. Any resemblance is purely coincidental.'**
  String get appDisclaimer;

  /// Displays the app version number
  ///
  /// In en, this message translates to:
  /// **'App Version: {version}'**
  String appVersion(String version);

  /// No description provided for @dialogTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get dialogTitleHint;

  /// No description provided for @completeProfilePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please edit your profile to complete your information!'**
  String get completeProfilePrompt;

  /// No description provided for @goToEdit.
  ///
  /// In en, this message translates to:
  /// **'Go to Edit'**
  String get goToEdit;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @chattingWith.
  ///
  /// In en, this message translates to:
  /// **'Chat with {friendName}'**
  String chattingWith(String friendName);

  /// No description provided for @chatContentWith.
  ///
  /// In en, this message translates to:
  /// **'Chat content with {friendName}'**
  String chatContentWith(String friendName);

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatInputHint;

  /// Error message shown when a character profile could not be found.
  ///
  /// In en, this message translates to:
  /// **'Character not found'**
  String get characterNotFoundError;

  /// Error message shown when failing to load character details from Firestore.
  ///
  /// In en, this message translates to:
  /// **'Failed to load character details: {errorDetails}'**
  String errorLoadingCharacterDetails(String errorDetails);

  /// No description provided for @charInitialRelationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial Relationship'**
  String get charInitialRelationshipLabel;

  /// No description provided for @relationship_childhood_friend.
  ///
  /// In en, this message translates to:
  /// **'Childhood Friends'**
  String get relationship_childhood_friend;

  /// No description provided for @relationship_senior_junior.
  ///
  /// In en, this message translates to:
  /// **'Senior/Junior'**
  String get relationship_senior_junior;

  /// No description provided for @relationship_bickering_couple.
  ///
  /// In en, this message translates to:
  /// **'Bickering Couple'**
  String get relationship_bickering_couple;

  /// No description provided for @relationship_colleagues.
  ///
  /// In en, this message translates to:
  /// **'Colleagues'**
  String get relationship_colleagues;

  /// No description provided for @relationship_other.
  ///
  /// In en, this message translates to:
  /// **'Other (Please enter manually)'**
  String get relationship_other;

  /// No description provided for @chatModeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Mode'**
  String get chatModeDaily;

  /// No description provided for @chatModeStory.
  ///
  /// In en, this message translates to:
  /// **'Story Mode'**
  String get chatModeStory;

  /// No description provided for @chatModeImmersive.
  ///
  /// In en, this message translates to:
  /// **'Immersive Mode'**
  String get chatModeImmersive;

  /// No description provided for @chatModeGemini.
  ///
  /// In en, this message translates to:
  /// **'Life Companion'**
  String get chatModeGemini;

  /// No description provided for @announcement_new.
  ///
  /// In en, this message translates to:
  /// **'New Announcement'**
  String get announcement_new;

  /// No description provided for @mail_notification.
  ///
  /// In en, this message translates to:
  /// **'A new Time Letter has arrived! Go check the Parchment Scroll now!'**
  String get mail_notification;

  /// No description provided for @customer_service_reply.
  ///
  /// In en, this message translates to:
  /// **'Customer Service Reply'**
  String get customer_service_reply;

  /// No description provided for @system_announcement.
  ///
  /// In en, this message translates to:
  /// **'System Announcement'**
  String get system_announcement;

  /// No description provided for @empty_announcement.
  ///
  /// In en, this message translates to:
  /// **'No announcements at the moment.'**
  String get empty_announcement;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @no_content.
  ///
  /// In en, this message translates to:
  /// **'No Content'**
  String get no_content;

  /// No description provided for @privacy_policy_title.
  ///
  /// In en, this message translates to:
  /// **'Lianlian Shiguang Privacy Policy'**
  String get privacy_policy_title;

  /// No description provided for @privacy_policy_date.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: April 10, 2026'**
  String get privacy_policy_date;

  /// No description provided for @privacy_policy_body.
  ///
  /// In en, this message translates to:
  /// **'\"Lianlian Shiguang\" Privacy Policy\nLast Updated: April 10, 2026\n\nWelcome to \"Lianlian Shiguang\" (hereinafter referred to as \"the Service\"). We value your privacy. This policy explains how we collect, use, and protect your personal information.\n\n1. Account Information:\nThird-party Login: When you log in via Google, Facebook, or Apple, we collect your Firebase UID, email, and public nickname.\nEmail Registration: When you choose to register by email, we collect your email address. Your login password is managed and stored using Firebase encryption; the development team cannot access your original password. We commit to adopting industry-standard security measures to safeguard your personal data.\n\nInteraction Data: To enable AI characters to have continuous memory, we collect and store your conversation records with the AI and the content you write for characters within the game.\n\nDevice Information: Including device model, operating system version, and unique device identifier (UDID) for system optimization.\n\n2. Use of Information\nEnhancing AI Experience: Utilizing conversation records to optimize AI response quality and personality consistency.\nService Operations: Used for processing point recharges, consumption records, and user identity verification.\nSecurity Protection: Monitoring malicious behavior to protect the server from attacks.\n\n3. Third-party Technical Cooperation\nThe Service is supported by the following major international technologies:\nGoogle Cloud / Firebase: Data storage and identity verification.\nOpenRouter / xAI / Meta: Providing AI model computational logic.\nNote: We do not sell your original conversation records to any advertisers.\n\n4. Data Storage and Deletion\nYour data will be securely stored on cloud servers.\nYou may contact us at any time to request the permanent deletion of your account and all associated conversation data.'**
  String get privacy_policy_body;

  /// No description provided for @terms_title.
  ///
  /// In en, this message translates to:
  /// **'Lianlian Shiguang Terms of Service'**
  String get terms_title;

  /// No description provided for @terms_date.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: April 10, 2026'**
  String get terms_date;

  /// No description provided for @terms_body.
  ///
  /// In en, this message translates to:
  /// **'\"Lianlian Shiguang\" Terms of Service\nLast Updated: April 10, 2026\n\nPlease read the following terms carefully before using \"Lianlian Shiguang\" (hereinafter referred to as \"the Service\"). Starting to use the Service means you agree to the following:\n\n1. Nature of Service and Disclaimer\nNon-human Interaction: All character responses in the Service are generated by Artificial Intelligence (Generative AI). Character statements do not represent the creator\'s position.\nNarrative Risk: AI may generate fictional, inaccurate, or uncomfortable content. Users should have the ability to distinguish between fiction and reality.\n\n2. Virtual Credits and Payment Models\nNature of Credits: Credits within the Service are virtual goods. Once consumed (e.g., entering a story, immersive mode, sending gifts, voice calls), they cannot be refunded.\nCost Differences: Credit consumption standards for different modes (e.g., Daily, Story, Immersive, Calls) are set based on AI computational costs. The Service reserves the right to adjust these costs.\n\n3. User Conduct Code\nProhibitions: It is prohibited to use AI to generate extreme violence, criminal guidance, or content that violates the law.\nSystem Interference: It is strictly forbidden to illegally obtain data from the Service through any automated tools or reverse engineering.\n\n4. Intellectual Property and Content Ownership\nOriginal Content: Intellectual property rights for character names (such as Cheng An and others created by the official), background settings, plot scripts, dialogue texts, game logic, and exclusive brand names belong to the \"Lianlian Shiguang Development Team.\"\nThird-party Licensed Resources: Icons, fonts, and emojis used in the Service interface belong to their original licensors (such as Google Material Design, Apple Inc., etc.), used legally under their open-source or licensing agreements.\nAI-Generated Content: Some artistic images in the Service are generated using AI tools (such as Niji.journey). The development team guarantees it has obtained commercial use licenses for these tools. Usage and operating rights for related images belong to the team.\nProhibited Acts: Without formal authorization, it is strictly forbidden to use any of the above content for commercial profit, secondary distribution, or malicious model training.\n\n5. Service Termination\nIf a player violates the above regulations, the Service has the right to suspend or permanently disable the account without prior notice.'**
  String get terms_body;

  /// No description provided for @login_required.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get login_required;

  /// No description provided for @cloud_character_mgmt.
  ///
  /// In en, this message translates to:
  /// **'Cloud Character Management'**
  String get cloud_character_mgmt;

  /// No description provided for @connection_error.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connection_error;

  /// No description provided for @no_characters_met.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t met any characters yet!'**
  String get no_characters_met;

  /// No description provided for @status_paused.
  ///
  /// In en, this message translates to:
  /// **'Status: Connection Paused'**
  String get status_paused;

  /// No description provided for @status_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Status: Bonding'**
  String get status_in_progress;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @confirm_block_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Block?'**
  String get confirm_block_title;

  /// No description provided for @confirm_block_msg.
  ///
  /// In en, this message translates to:
  /// **'After blocking, you won\'t receive messages from {charName} for now.'**
  String confirm_block_msg(Object charName);

  /// No description provided for @think_again.
  ///
  /// In en, this message translates to:
  /// **'Think Again'**
  String get think_again;

  /// No description provided for @confirm_block_btn.
  ///
  /// In en, this message translates to:
  /// **'Confirm Block'**
  String get confirm_block_btn;

  /// No description provided for @no_char_info.
  ///
  /// In en, this message translates to:
  /// **'No detailed info for this character yet...'**
  String get no_char_info;

  /// No description provided for @private_mailbox.
  ///
  /// In en, this message translates to:
  /// **'Private Mailbox'**
  String get private_mailbox;

  /// No description provided for @user_info_not_found.
  ///
  /// In en, this message translates to:
  /// **'User info not found'**
  String get user_info_not_found;

  /// No description provided for @load_failed.
  ///
  /// In en, this message translates to:
  /// **'Load failed, please try again later'**
  String get load_failed;

  /// No description provided for @empty_mailbox.
  ///
  /// In en, this message translates to:
  /// **'Mailbox is currently empty~'**
  String get empty_mailbox;

  /// No description provided for @system_notification.
  ///
  /// In en, this message translates to:
  /// **'System Notification'**
  String get system_notification;

  /// No description provided for @interaction_records.
  ///
  /// In en, this message translates to:
  /// **'Interaction History'**
  String get interaction_records;

  /// No description provided for @liked_content.
  ///
  /// In en, this message translates to:
  /// **'Liked Content'**
  String get liked_content;

  /// No description provided for @my_favorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get my_favorites;

  /// No description provided for @login_to_view_records.
  ///
  /// In en, this message translates to:
  /// **'Please login to view history'**
  String get login_to_view_records;

  /// No description provided for @no_likes_yet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t liked any posts yet!'**
  String get no_likes_yet;

  /// No description provided for @empty_favorites.
  ///
  /// In en, this message translates to:
  /// **'Your favorites folder is empty, explore the Lobby!'**
  String get empty_favorites;

  /// No description provided for @theme_sakura_pink.
  ///
  /// In en, this message translates to:
  /// **'Sakura Pink'**
  String get theme_sakura_pink;

  /// No description provided for @theme_ocean_blue.
  ///
  /// In en, this message translates to:
  /// **'Ocean Blue'**
  String get theme_ocean_blue;

  /// No description provided for @theme_sunset_orange.
  ///
  /// In en, this message translates to:
  /// **'Sunset Orange'**
  String get theme_sunset_orange;

  /// No description provided for @theme_mint_forest.
  ///
  /// In en, this message translates to:
  /// **'Mint Forest'**
  String get theme_mint_forest;

  /// No description provided for @theme_midnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight Mode'**
  String get theme_midnight;

  /// No description provided for @change_atmosphere.
  ///
  /// In en, this message translates to:
  /// **'Change Atmosphere'**
  String get change_atmosphere;

  /// No description provided for @custom_color.
  ///
  /// In en, this message translates to:
  /// **'Custom Color'**
  String get custom_color;

  /// No description provided for @custom_color_desc.
  ///
  /// In en, this message translates to:
  /// **'Mix your exclusive atmosphere color'**
  String get custom_color_desc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'ja',
        'ko',
        'ms',
        'pt',
        'th',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'pt':
      return AppLocalizationsPt();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
