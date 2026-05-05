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
/// import 'l10n/app_localizations.dart';
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
