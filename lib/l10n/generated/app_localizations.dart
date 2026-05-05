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
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'設定'**
  String get settingsTitle;

  /// No description provided for @changeTheme.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更換主題顏色'**
  String get changeTheme;

  /// No description provided for @feedback.
  ///
  /// In zh_Hant, this message translates to:
  /// **'反饋建議'**
  String get feedback;

  /// No description provided for @changeLanguage.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更換語言'**
  String get changeLanguage;

  /// No description provided for @allFriendsTitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'所有好友'**
  String get allFriendsTitle;

  /// No description provided for @noFriendsMessage.
  ///
  /// In zh_Hant, this message translates to:
  /// **'您還沒有任何好友。'**
  String get noFriendsMessage;

  /// No description provided for @unknownCharacter.
  ///
  /// In zh_Hant, this message translates to:
  /// **'未知角色'**
  String get unknownCharacter;

  /// No description provided for @errorLoadingFriends.
  ///
  /// In zh_Hant, this message translates to:
  /// **'載入好友列表時發生錯誤: {error}'**
  String errorLoadingFriends(String error);

  /// No description provided for @tagGentle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'溫柔'**
  String get tagGentle;

  /// No description provided for @tagCheerful.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開朗'**
  String get tagCheerful;

  /// No description provided for @tagLively.
  ///
  /// In zh_Hant, this message translates to:
  /// **'活潑'**
  String get tagLively;

  /// No description provided for @tagMischievous.
  ///
  /// In zh_Hant, this message translates to:
  /// **'調皮'**
  String get tagMischievous;

  /// No description provided for @tagRichYoungLady.
  ///
  /// In zh_Hant, this message translates to:
  /// **'千金'**
  String get tagRichYoungLady;

  /// No description provided for @tagRichYoungMaster.
  ///
  /// In zh_Hant, this message translates to:
  /// **'少爺'**
  String get tagRichYoungMaster;

  /// No description provided for @tagWealthyFamily.
  ///
  /// In zh_Hant, this message translates to:
  /// **'豪門'**
  String get tagWealthyFamily;

  /// No description provided for @tagScheming.
  ///
  /// In zh_Hant, this message translates to:
  /// **'勾心鬥角'**
  String get tagScheming;

  /// No description provided for @tagPossessive.
  ///
  /// In zh_Hant, this message translates to:
  /// **'佔有'**
  String get tagPossessive;

  /// No description provided for @tagParanoid.
  ///
  /// In zh_Hant, this message translates to:
  /// **'偏執'**
  String get tagParanoid;

  /// No description provided for @tagPersistent.
  ///
  /// In zh_Hant, this message translates to:
  /// **'執著'**
  String get tagPersistent;

  /// No description provided for @tagUncle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'大叔'**
  String get tagUncle;

  /// No description provided for @tagAuntie.
  ///
  /// In zh_Hant, this message translates to:
  /// **'阿姨'**
  String get tagAuntie;

  /// No description provided for @tagSeniorSister.
  ///
  /// In zh_Hant, this message translates to:
  /// **'學姊'**
  String get tagSeniorSister;

  /// No description provided for @tagJuniorBrother.
  ///
  /// In zh_Hant, this message translates to:
  /// **'學弟'**
  String get tagJuniorBrother;

  /// No description provided for @tagHandsome.
  ///
  /// In zh_Hant, this message translates to:
  /// **'帥'**
  String get tagHandsome;

  /// No description provided for @tagStunning.
  ///
  /// In zh_Hant, this message translates to:
  /// **'美艷動人'**
  String get tagStunning;

  /// No description provided for @tagContrast.
  ///
  /// In zh_Hant, this message translates to:
  /// **'反差'**
  String get tagContrast;

  /// No description provided for @tagFlirty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開車'**
  String get tagFlirty;

  /// No description provided for @tagAgeGap.
  ///
  /// In zh_Hant, this message translates to:
  /// **'年齡差'**
  String get tagAgeGap;

  /// No description provided for @userNotFoundError.
  ///
  /// In zh_Hant, this message translates to:
  /// **'找不到使用者'**
  String get userNotFoundError;

  /// No description provided for @imageDataMismatchError.
  ///
  /// In zh_Hant, this message translates to:
  /// **'圖片資料不一致，請重新選擇圖片。'**
  String get imageDataMismatchError;

  /// No description provided for @createCharacterTitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'創建角色'**
  String get createCharacterTitle;

  /// No description provided for @charAlbumTitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色相冊 (第一張為主要頭像)'**
  String get charAlbumTitle;

  /// No description provided for @charNameLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色名稱:*'**
  String get charNameLabel;

  /// No description provided for @charDescSection.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色描述:'**
  String get charDescSection;

  /// No description provided for @charAgeLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'年齡:'**
  String get charAgeLabel;

  /// No description provided for @charJobLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'職業:*'**
  String get charJobLabel;

  /// No description provided for @charBirthdayLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'生日:(MMDD)'**
  String get charBirthdayLabel;

  /// No description provided for @charGenderLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'性別 *'**
  String get charGenderLabel;

  /// No description provided for @genderNotSelected.
  ///
  /// In zh_Hant, this message translates to:
  /// **'未選擇'**
  String get genderNotSelected;

  /// No description provided for @genderMale.
  ///
  /// In zh_Hant, this message translates to:
  /// **'男'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In zh_Hant, this message translates to:
  /// **'女'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In zh_Hant, this message translates to:
  /// **'其他'**
  String get genderOther;

  /// No description provided for @charHeightLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'身高:(cm)'**
  String get charHeightLabel;

  /// No description provided for @charAppearanceLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'外貌形容:'**
  String get charAppearanceLabel;

  /// No description provided for @charPersonalityTagsSection.
  ///
  /// In zh_Hant, this message translates to:
  /// **'個性標籤'**
  String get charPersonalityTagsSection;

  /// No description provided for @charOtherPersonalityTagsHint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'其他個性標籤...'**
  String get charOtherPersonalityTagsHint;

  /// No description provided for @otherSectionTitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'其他'**
  String get otherSectionTitle;

  /// No description provided for @charLikesLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'喜歡的東西:(例如：草莓蛋糕、貓咪、雨天)'**
  String get charLikesLabel;

  /// No description provided for @charDislikesLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'討厭的東西:(例如：苦瓜、吵鬧的地方)'**
  String get charDislikesLabel;

  /// No description provided for @charSecretsLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'不為人知的小秘密: (例如：其實是個路癡)'**
  String get charSecretsLabel;

  /// No description provided for @charMannerismsSection.
  ///
  /// In zh_Hant, this message translates to:
  /// **'言行舉止'**
  String get charMannerismsSection;

  /// No description provided for @charToneLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'說話語氣與風格: (例如：對陌生人冷淡)'**
  String get charToneLabel;

  /// No description provided for @charDialogueExampleLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'對話範例: (玩家：你真好！ 角色：...喔。)'**
  String get charDialogueExampleLabel;

  /// No description provided for @charBackgroundSection.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色背景:'**
  String get charBackgroundSection;

  /// No description provided for @charBackgroundHint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輸入角色的背景故事 (最多 2500 字)'**
  String get charBackgroundHint;

  /// No description provided for @charStoryStartSection.
  ///
  /// In zh_Hant, this message translates to:
  /// **'劇情開頭:'**
  String get charStoryStartSection;

  /// No description provided for @charStoryStartHint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輸入角色的劇情 (最多 2500 字)'**
  String get charStoryStartHint;

  /// No description provided for @charStorySummaryLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'故事簡介 (最多 50 字，會顯示在邂逅卡片上)'**
  String get charStorySummaryLabel;

  /// No description provided for @charExtraInfoSection.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色其他補充:'**
  String get charExtraInfoSection;

  /// No description provided for @charExtraInfoHint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輸入補充內容...'**
  String get charExtraInfoHint;

  /// No description provided for @charPublicToggleLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'公開讓其他玩家遊玩嗎？'**
  String get charPublicToggleLabel;

  /// No description provided for @yes.
  ///
  /// In zh_Hant, this message translates to:
  /// **'是'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In zh_Hant, this message translates to:
  /// **'否'**
  String get no;

  /// No description provided for @createButton.
  ///
  /// In zh_Hant, this message translates to:
  /// **'創建'**
  String get createButton;

  /// No description provided for @saveButton.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存'**
  String get saveButton;

  /// No description provided for @cancelButton.
  ///
  /// In zh_Hant, this message translates to:
  /// **'取消'**
  String get cancelButton;

  /// No description provided for @exitCreationTitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'您將退出創角畫面'**
  String get exitCreationTitle;

  /// No description provided for @saveDraftPrompt.
  ///
  /// In zh_Hant, this message translates to:
  /// **'需要儲存為草稿嗎？'**
  String get saveDraftPrompt;

  /// No description provided for @draftNeeded.
  ///
  /// In zh_Hant, this message translates to:
  /// **'需要'**
  String get draftNeeded;

  /// No description provided for @draftNotNeeded.
  ///
  /// In zh_Hant, this message translates to:
  /// **'不需要'**
  String get draftNotNeeded;

  /// No description provided for @editExtraInfoTitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯補充內容'**
  String get editExtraInfoTitle;

  /// No description provided for @nameAndAvatarError.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請填寫角色名稱並至少上傳一張頭像！'**
  String get nameAndAvatarError;

  /// No description provided for @savingStatus.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存中...'**
  String get savingStatus;

  /// No description provided for @uploadingImagesStatus.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在上傳圖片...'**
  String get uploadingImagesStatus;

  /// No description provided for @maxImagesError.
  ///
  /// In zh_Hant, this message translates to:
  /// **'最多只能上傳 10 張圖片。'**
  String get maxImagesError;

  /// No description provided for @uploadingImagesStatusShort.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在處理圖片...'**
  String get uploadingImagesStatusShort;

  /// No description provided for @savingCharacterData.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在儲存角色資料...'**
  String get savingCharacterData;

  /// No description provided for @characterCreatedSuccess.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色 \"{charName}\" 已創建！'**
  String characterCreatedSuccess(String charName);

  /// No description provided for @uploadImageTimeoutError.
  ///
  /// In zh_Hant, this message translates to:
  /// **'創建角色失敗：圖片上傳超時，請檢查您的網路連線。'**
  String get uploadImageTimeoutError;

  /// No description provided for @createCharacterGenericError.
  ///
  /// In zh_Hant, this message translates to:
  /// **'創建角色失敗：{error}'**
  String createCharacterGenericError(String error);

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In zh_Hant, this message translates to:
  /// **'外觀與內容'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In zh_Hant, this message translates to:
  /// **'帳號與內容管理'**
  String get settingsSectionAccount;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In zh_Hant, this message translates to:
  /// **'關於我們'**
  String get settingsSectionAbout;

  /// No description provided for @accountManagement.
  ///
  /// In zh_Hant, this message translates to:
  /// **'帳號管理'**
  String get accountManagement;

  /// No description provided for @userId.
  ///
  /// In zh_Hant, this message translates to:
  /// **'ID:'**
  String get userId;

  /// No description provided for @authMethodGoogle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'Google'**
  String get authMethodGoogle;

  /// No description provided for @authMethodUnknown.
  ///
  /// In zh_Hant, this message translates to:
  /// **'未知'**
  String get authMethodUnknown;

  /// No description provided for @userIdCopied.
  ///
  /// In zh_Hant, this message translates to:
  /// **'使用者 ID 已複製到剪貼簿'**
  String get userIdCopied;

  /// No description provided for @characterManagement.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色管理'**
  String get characterManagement;

  /// No description provided for @viewBlockedCharacters.
  ///
  /// In zh_Hant, this message translates to:
  /// **'查看已封鎖的角色'**
  String get viewBlockedCharacters;

  /// No description provided for @privacyPolicy.
  ///
  /// In zh_Hant, this message translates to:
  /// **'隱私條款'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In zh_Hant, this message translates to:
  /// **'服務條款'**
  String get termsOfService;

  /// No description provided for @logoutButton.
  ///
  /// In zh_Hant, this message translates to:
  /// **'登出帳號'**
  String get logoutButton;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'你要登出了嗎?(´;ω;`)'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogActionCancel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我按錯了'**
  String get logoutDialogActionCancel;

  /// No description provided for @logoutDialogActionConfirm.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確認'**
  String get logoutDialogActionConfirm;

  /// No description provided for @logoutSuccessSnackbar.
  ///
  /// In zh_Hant, this message translates to:
  /// **'好的!那我等你回來♥(´∀` )'**
  String get logoutSuccessSnackbar;

  /// No description provided for @deleteAccountButton.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除帳號'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'你確定要刪掉這個帳號?இдஇ'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogContent.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這個操作無法復原，所有資料都會被永久刪除！'**
  String get deleteAccountDialogContent;

  /// No description provided for @deleteAccountDialogActionCancel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'沒有,我沒有要刪掉'**
  String get deleteAccountDialogActionCancel;

  /// No description provided for @deleteAccountDialogActionConfirm.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定'**
  String get deleteAccountDialogActionConfirm;

  /// No description provided for @deleteAccountSuccessSnackbar.
  ///
  /// In zh_Hant, this message translates to:
  /// **'帳號已成功刪除。'**
  String get deleteAccountSuccessSnackbar;

  /// No description provided for @appDisclaimer.
  ///
  /// In zh_Hant, this message translates to:
  /// **'遊戲裡面的角色與場景皆為虛構,請勿帶入現實!如有雷同,純屬巧合'**
  String get appDisclaimer;

  /// 顯示 App 版本號
  ///
  /// In zh_Hant, this message translates to:
  /// **'App 版本: {version}'**
  String appVersion(String version);

  /// No description provided for @dialogTitleHint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'提示'**
  String get dialogTitleHint;

  /// No description provided for @completeProfilePrompt.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請先編輯您的個人檔案以完善資料喔！'**
  String get completeProfilePrompt;

  /// No description provided for @goToEdit.
  ///
  /// In zh_Hant, this message translates to:
  /// **'前往編輯'**
  String get goToEdit;

  /// No description provided for @later.
  ///
  /// In zh_Hant, this message translates to:
  /// **'稍後'**
  String get later;

  /// No description provided for @chattingWith.
  ///
  /// In zh_Hant, this message translates to:
  /// **'與 {friendName} 聊天'**
  String chattingWith(String friendName);

  /// No description provided for @chatContentWith.
  ///
  /// In zh_Hant, this message translates to:
  /// **'與 {friendName} 的聊天內容'**
  String chatContentWith(String friendName);

  /// No description provided for @chatInputHint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輸入訊息...'**
  String get chatInputHint;

  /// 當找不到角色個人檔案時顯示的錯誤訊息
  ///
  /// In zh_Hant, this message translates to:
  /// **'找不到角色資料'**
  String get characterNotFoundError;

  /// 從 Firestore 讀取角色詳細資料失敗時顯示的錯誤訊息
  ///
  /// In zh_Hant, this message translates to:
  /// **'讀取角色詳情失敗: {errorDetails}'**
  String errorLoadingCharacterDetails(String errorDetails);

  /// No description provided for @charInitialRelationshipLabel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'初始關係'**
  String get charInitialRelationshipLabel;

  /// No description provided for @relationship_childhood_friend.
  ///
  /// In zh_Hant, this message translates to:
  /// **'青梅竹馬'**
  String get relationship_childhood_friend;

  /// No description provided for @relationship_senior_junior.
  ///
  /// In zh_Hant, this message translates to:
  /// **'學長學妹'**
  String get relationship_senior_junior;

  /// No description provided for @relationship_bickering_couple.
  ///
  /// In zh_Hant, this message translates to:
  /// **'歡喜冤家'**
  String get relationship_bickering_couple;

  /// No description provided for @relationship_colleagues.
  ///
  /// In zh_Hant, this message translates to:
  /// **'職場同事'**
  String get relationship_colleagues;

  /// No description provided for @relationship_other.
  ///
  /// In zh_Hant, this message translates to:
  /// **'其他 (請手動輸入)'**
  String get relationship_other;

  /// No description provided for @chatModeDaily.
  ///
  /// In zh_Hant, this message translates to:
  /// **'日常模式'**
  String get chatModeDaily;

  /// No description provided for @chatModeStory.
  ///
  /// In zh_Hant, this message translates to:
  /// **'劇情模式'**
  String get chatModeStory;

  /// No description provided for @chatModeImmersive.
  ///
  /// In zh_Hant, this message translates to:
  /// **'沉浸模式'**
  String get chatModeImmersive;

  /// No description provided for @chatModeGemini.
  ///
  /// In zh_Hant, this message translates to:
  /// **'生活陪伴'**
  String get chatModeGemini;

  /// No description provided for @announcement_new.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新公告'**
  String get announcement_new;

  /// No description provided for @mail_notification.
  ///
  /// In zh_Hant, this message translates to:
  /// **'有新的時光信件寄達囉，快去羊皮卷看看吧！'**
  String get mail_notification;

  /// No description provided for @customer_service_reply.
  ///
  /// In zh_Hant, this message translates to:
  /// **'客服回覆'**
  String get customer_service_reply;

  /// No description provided for @system_announcement.
  ///
  /// In zh_Hant, this message translates to:
  /// **'系統公告'**
  String get system_announcement;

  /// No description provided for @empty_announcement.
  ///
  /// In zh_Hant, this message translates to:
  /// **'目前沒有任何公告喔'**
  String get empty_announcement;

  /// No description provided for @untitled.
  ///
  /// In zh_Hant, this message translates to:
  /// **'無標題'**
  String get untitled;

  /// No description provided for @no_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'無內容'**
  String get no_content;

  /// No description provided for @privacy_policy_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'《戀戀拾光》隱私權政策'**
  String get privacy_policy_title;

  /// No description provided for @privacy_policy_date.
  ///
  /// In zh_Hant, this message translates to:
  /// **'最近更新日期：2026年4月10日'**
  String get privacy_policy_date;

  /// No description provided for @privacy_policy_body.
  ///
  /// In zh_Hant, this message translates to:
  /// **'歡迎使用《戀戀拾光》（以下簡稱「本服務」）。我們非常重視您的隱私，本政策旨在說明我們如何收集、使用及保護您的個人資訊。\n\n1. 帳戶資訊：\n第三方登入：當您透過 Google、Facebook 或 Apple 帳號登入時，我們會收集您的 Firebase UID、電子郵件及公開暱稱。\nE-mail 註冊：當您選擇以電子郵件註冊時，我們會收集您的電子郵件帳號。您的登入密碼將透過 Firebase 加密技術進行管理與儲存，開發團隊無法查閱您的原始密碼。 我們承諾將採取業界標準的安全措施保障您的個資安全。\n\n互動資料：為了讓 AI 角色具備連續的記憶，我們會收集並儲存您與AI的對話紀錄與您在遊戲裡面為角色所寫下的內容。\n\n設備資訊：包含設備型號、作業系統版本及唯一設備識別碼，用於系統優化。\n\n2. 資訊的使用方式\n提升AI體驗：利用對話紀錄優化AI的回覆品質與個性連貫性。\n服務營運：用於處理點數充值、消費紀錄及使用者身分驗證。\n安全防護：監測惡意行為，保護伺服器不受攻擊。\n\n3. 第三方技術合作\n本服務採用以下國際主流技術提供支持：\nGoogle Cloud / Firebase：資料存儲與身份驗證。\nOpenRouter / xAI / Meta：提供 AI 模型運算邏輯。\n備註：我們不會向任何廣告商出售您的原始對話紀錄。\n\n4. 資料儲存與刪除\n您的資料將安全地儲存在雲端服務器中。\n您可以隨時聯繫我們要求永久刪除您的帳戶及所有相關對話數據。'**
  String get privacy_policy_body;

  /// No description provided for @terms_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'《戀戀拾光》服務使用條款'**
  String get terms_title;

  /// No description provided for @terms_date.
  ///
  /// In zh_Hant, this message translates to:
  /// **'最近更新日期：2026年4月10日'**
  String get terms_date;

  /// No description provided for @terms_body.
  ///
  /// In zh_Hant, this message translates to:
  /// **'在使用《戀戀拾光》（以下簡稱「本服務」）前，請仔細閱讀以下條款。開始使用本服務即代表您同意以下內容：\n\n1. 服務本質與免責聲明\n非真人互動：本服務所有角色回覆均由人工智慧（Generative AI）生成。角色言論不代表創作者立場。\n敘事風險：AI可能生成虛構、不準確或令人不適的內容。使用者應具備區分虛構與現實的能力。\n\n2. 虛擬點數與付費模式\n點數性質：本服務內之點數為虛擬商品，一經消耗（如:進入故事、沉浸模式、送出禮物、語音通話）即無法退還。\n成本差異：不同模式（如:日常、故事、沉浸、通話）之點數消耗標準係根據 AI 運算成本設定，本服務保留調整成本之權利。\n\n3. 使用者行為規範\n禁止事項：禁止利用AI生成極端暴力、犯罪引導或違反法律之內容。\n系統干擾：嚴禁透過任何自動化工具、逆向工程手段非法獲取本服務之數據。\n\n4. 智慧財產權與內容所有權\n原創內容：本服務中之角色姓名（如：程安等官方所創建的）、背景設定、劇情劇本、對話文本、遊戲邏輯及專屬品牌名稱，其智慧財產權均屬「戀戀拾光開發團隊」所有。\n第三方授權資源：本服務介面中所使用之圖示（Icons）、字體及表情符號（Emojis），其版權歸原授權方所有（如 Google Material Design、Apple Inc. 等），本服務係依據其開源或授權協議合法使用。\nAI 生成內容：本服務中部分美術圖像係由開發團隊利用 AI 生成工具（如 Niji.journey）產生，開發團隊保證已獲得該工具之商業使用授權。相關圖像之使用權與經營權歸本團隊所有。\n禁止行為：未經本團隊正式授權，嚴禁將上述任何內容用於商業營利、二次散布或進行惡意訓練模型。\n\n5. 服務終止\n若玩家違反上述規定，本服務有權在不預先通知的情況下暫停或永久停用該帳戶。'**
  String get terms_body;

  /// No description provided for @login_required.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請先登入系統'**
  String get login_required;

  /// No description provided for @cloud_character_mgmt.
  ///
  /// In zh_Hant, this message translates to:
  /// **'雲端角色管理'**
  String get cloud_character_mgmt;

  /// No description provided for @connection_error.
  ///
  /// In zh_Hant, this message translates to:
  /// **'連線出錯'**
  String get connection_error;

  /// No description provided for @no_characters_met.
  ///
  /// In zh_Hant, this message translates to:
  /// **'目前還沒有認識任何角色喔！'**
  String get no_characters_met;

  /// No description provided for @status_paused.
  ///
  /// In zh_Hant, this message translates to:
  /// **'狀態：已暫停聯繫'**
  String get status_paused;

  /// No description provided for @status_in_progress.
  ///
  /// In zh_Hant, this message translates to:
  /// **'狀態：攻略中'**
  String get status_in_progress;

  /// No description provided for @unblock.
  ///
  /// In zh_Hant, this message translates to:
  /// **'解除封鎖'**
  String get unblock;

  /// No description provided for @block.
  ///
  /// In zh_Hant, this message translates to:
  /// **'封鎖'**
  String get block;

  /// No description provided for @confirm_block_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定要封鎖嗎？'**
  String get confirm_block_title;

  /// 封鎖確認彈窗的警示文字
  ///
  /// In zh_Hant, this message translates to:
  /// **'封鎖後，將暫時無法收到 {charName} 的訊息喔。'**
  String block_warning_msg(String charName);

  /// No description provided for @think_again.
  ///
  /// In zh_Hant, this message translates to:
  /// **'再想想'**
  String get think_again;

  /// No description provided for @confirm_block_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定封鎖'**
  String get confirm_block_btn;

  /// No description provided for @no_char_info.
  ///
  /// In zh_Hant, this message translates to:
  /// **'目前還沒有這份角色的詳細情報...'**
  String get no_char_info;

  /// No description provided for @private_mailbox.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬信箱'**
  String get private_mailbox;

  /// No description provided for @user_info_not_found.
  ///
  /// In zh_Hant, this message translates to:
  /// **'找不到使用者資訊'**
  String get user_info_not_found;

  /// No description provided for @load_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'載入失敗，請稍後再試'**
  String get load_failed;

  /// No description provided for @empty_mailbox.
  ///
  /// In zh_Hant, this message translates to:
  /// **'目前信箱空空的喔～'**
  String get empty_mailbox;

  /// No description provided for @system_notification.
  ///
  /// In zh_Hant, this message translates to:
  /// **'系統通知'**
  String get system_notification;

  /// No description provided for @interaction_records.
  ///
  /// In zh_Hant, this message translates to:
  /// **'互動紀錄'**
  String get interaction_records;

  /// No description provided for @liked_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'按讚過的內容'**
  String get liked_content;

  /// No description provided for @my_favorites.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我的收藏'**
  String get my_favorites;

  /// No description provided for @login_to_view_records.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請先登入以查看紀錄'**
  String get login_to_view_records;

  /// No description provided for @no_likes_yet.
  ///
  /// In zh_Hant, this message translates to:
  /// **'妳還沒有按讚過任何動態喔！'**
  String get no_likes_yet;

  /// No description provided for @empty_favorites.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬收藏夾空空的，快去大廳逛逛吧！'**
  String get empty_favorites;

  /// No description provided for @theme_sakura_pink.
  ///
  /// In zh_Hant, this message translates to:
  /// **'櫻花粉'**
  String get theme_sakura_pink;

  /// No description provided for @theme_ocean_blue.
  ///
  /// In zh_Hant, this message translates to:
  /// **'湛藍海'**
  String get theme_ocean_blue;

  /// No description provided for @theme_sunset_orange.
  ///
  /// In zh_Hant, this message translates to:
  /// **'夕陽橙'**
  String get theme_sunset_orange;

  /// No description provided for @theme_mint_forest.
  ///
  /// In zh_Hant, this message translates to:
  /// **'薄荷森'**
  String get theme_mint_forest;

  /// No description provided for @theme_midnight.
  ///
  /// In zh_Hant, this message translates to:
  /// **'深夜模式'**
  String get theme_midnight;

  /// No description provided for @change_atmosphere.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更換氛圍'**
  String get change_atmosphere;

  /// No description provided for @custom_color.
  ///
  /// In zh_Hant, this message translates to:
  /// **'自定義色彩'**
  String get custom_color;

  /// No description provided for @custom_color_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'調配妳的專屬氛圍色'**
  String get custom_color_desc;

  /// No description provided for @cancel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定'**
  String get confirm;

  /// No description provided for @confirm_delete_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確認刪除'**
  String get confirm_delete_title;

  /// No description provided for @confirm_delete_memory_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'您確定要讓他忘記這件事嗎？此操作無法復原喔。'**
  String get confirm_delete_memory_msg;

  /// No description provided for @delete_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除'**
  String get delete_btn;

  /// No description provided for @memory_erased_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這段記憶已經被抹除了'**
  String get memory_erased_msg;

  /// No description provided for @delete_failed_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除失敗'**
  String get delete_failed_msg;

  /// No description provided for @edit_memory_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯回憶'**
  String get edit_memory_title;

  /// No description provided for @modify_memory_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'修改這段記憶...'**
  String get modify_memory_hint;

  /// No description provided for @memory_re_recorded_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'記憶已重新記錄'**
  String get memory_re_recorded_msg;

  /// No description provided for @update_failed_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更新失敗'**
  String get update_failed_msg;

  /// No description provided for @update_favorite_failed_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更新收藏狀態失敗'**
  String get update_favorite_failed_msg;

  /// 記事本的標題
  ///
  /// In zh_Hant, this message translates to:
  /// **'{charName}的記事本'**
  String char_notebook_title(String charName);

  /// No description provided for @error_loading_memory.
  ///
  /// In zh_Hant, this message translates to:
  /// **'讀取記憶時發生錯誤'**
  String get error_loading_memory;

  /// No description provided for @empty_notebook_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'筆記本裡空空的...\n趕快去聊天，讓他記下關於妳的點點滴滴吧！'**
  String get empty_notebook_msg;

  /// No description provided for @date_format_text.
  ///
  /// In zh_Hant, this message translates to:
  /// **'yyyy年M月d日'**
  String get date_format_text;

  /// No description provided for @remove_special_focus.
  ///
  /// In zh_Hant, this message translates to:
  /// **'取消特別關注'**
  String get remove_special_focus;

  /// No description provided for @mark_special_focus.
  ///
  /// In zh_Hant, this message translates to:
  /// **'標記為特別關注'**
  String get mark_special_focus;

  /// No description provided for @edit_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯'**
  String get edit_btn;

  /// No description provided for @load_gallery_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'讀取圖鑑失敗'**
  String get load_gallery_failed;

  /// No description provided for @traditional_chinese.
  ///
  /// In zh_Hant, this message translates to:
  /// **'繁體中文'**
  String get traditional_chinese;

  /// No description provided for @all.
  ///
  /// In zh_Hant, this message translates to:
  /// **'全部'**
  String get all;

  /// No description provided for @official_recommendation.
  ///
  /// In zh_Hant, this message translates to:
  /// **'官方推薦'**
  String get official_recommendation;

  /// No description provided for @my_exclusive.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我的專屬'**
  String get my_exclusive;

  /// No description provided for @encounter_count.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{count} 次邂逅'**
  String encounter_count(int count);

  /// No description provided for @official.
  ///
  /// In zh_Hant, this message translates to:
  /// **'官方'**
  String get official;

  /// No description provided for @private.
  ///
  /// In zh_Hant, this message translates to:
  /// **'私人'**
  String get private;

  /// No description provided for @first_encounter.
  ///
  /// In zh_Hant, this message translates to:
  /// **'初次相遇'**
  String get first_encounter;

  /// No description provided for @char_exclusive_memory.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{charName}的專屬回憶'**
  String char_exclusive_memory(String charName);

  /// No description provided for @affection_required_to_unlock.
  ///
  /// In zh_Hant, this message translates to:
  /// **'好感度需達到 {affectionLevel} 才能解鎖這張回憶喔！'**
  String affection_required_to_unlock(int affectionLevel);

  /// No description provided for @affection.
  ///
  /// In zh_Hant, this message translates to:
  /// **'好感度'**
  String get affection;

  /// No description provided for @unlock.
  ///
  /// In zh_Hant, this message translates to:
  /// **'解鎖'**
  String get unlock;

  /// No description provided for @change_chat_bg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更換聊天背景'**
  String get change_chat_bg;

  /// No description provided for @confirm_change_chat_bg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'要將「{cgDesc}」設為與 {charName} 的聊天背景嗎？'**
  String confirm_change_chat_bg(String cgDesc, String charName);

  /// No description provided for @bg_changed_to.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已將背景更換為「{cgDesc}」'**
  String bg_changed_to(String cgDesc);

  /// No description provided for @confirm_change.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定更換'**
  String get confirm_change;

  /// No description provided for @empty_treasure_box.
  ///
  /// In zh_Hant, this message translates to:
  /// **'百寶箱裡空空的...\n快去聊天尋找隱藏的專屬彩蛋吧！'**
  String get empty_treasure_box;

  /// No description provided for @unknown_story.
  ///
  /// In zh_Hant, this message translates to:
  /// **'未知劇情'**
  String get unknown_story;

  /// No description provided for @open_this_memory.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開啟這段回憶'**
  String get open_this_memory;

  /// No description provided for @open_exclusive_story.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開啟專屬劇情'**
  String get open_exclusive_story;

  /// No description provided for @confirm_use_egg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定要現在體驗「{eggTitle}」嗎？\n\n(此道具為一次性消耗，使用後將自動進入劇情)'**
  String confirm_use_egg(String eggTitle);

  /// No description provided for @wait_a_bit.
  ///
  /// In zh_Hant, this message translates to:
  /// **'再等等'**
  String get wait_a_bit;

  /// No description provided for @guiding_into_story.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在引導進入「{eggTitle}」...'**
  String guiding_into_story(String eggTitle);

  /// No description provided for @use_now.
  ///
  /// In zh_Hant, this message translates to:
  /// **'立即使用'**
  String get use_now;

  /// No description provided for @playback_failed_status.
  ///
  /// In zh_Hant, this message translates to:
  /// **'播放失敗，狀態碼：{statusCode}'**
  String playback_failed_status(String statusCode);

  /// No description provided for @playback_error.
  ///
  /// In zh_Hant, this message translates to:
  /// **'播放發生錯誤'**
  String get playback_error;

  /// No description provided for @unknown_contact.
  ///
  /// In zh_Hant, this message translates to:
  /// **'未知聯絡人'**
  String get unknown_contact;

  /// No description provided for @call_memory_with.
  ///
  /// In zh_Hant, this message translates to:
  /// **'與 {charName} 的通話回憶'**
  String call_memory_with(String charName);

  /// No description provided for @unlock_affection_requirement.
  ///
  /// In zh_Hant, this message translates to:
  /// **'好感度{affection}解鎖'**
  String unlock_affection_requirement(int affection);

  /// No description provided for @no_call_record.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這通電話似乎沒有留下對話紀錄...'**
  String get no_call_record;

  /// No description provided for @me.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我'**
  String get me;

  /// No description provided for @playing.
  ///
  /// In zh_Hant, this message translates to:
  /// **'播放中...'**
  String get playing;

  /// No description provided for @listen.
  ///
  /// In zh_Hant, this message translates to:
  /// **'聆聽'**
  String get listen;

  /// No description provided for @no_exclusive_voice.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這隻角色還沒有設定專屬聲音喔！'**
  String get no_exclusive_voice;

  /// No description provided for @voice_download_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✅ 語音數據下載成功，準備直接播放...'**
  String get voice_download_success;

  /// No description provided for @onboarding_invitation.
  ///
  /// In zh_Hant, this message translates to:
  /// **'— 拾光邀請函 —'**
  String get onboarding_invitation;

  /// No description provided for @onboarding_welcome.
  ///
  /// In zh_Hant, this message translates to:
  /// **'歡迎來到戀戀拾光'**
  String get onboarding_welcome;

  /// No description provided for @onboarding_quote.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「所有的相遇，都是久別重逢。」'**
  String get onboarding_quote;

  /// No description provided for @onboarding_gift_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'獲得初見禮：50 朵花語'**
  String get onboarding_gift_title;

  /// No description provided for @onboarding_gift_subtitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這些花朵將陪伴您開啟與他的故事'**
  String get onboarding_gift_subtitle;

  /// No description provided for @onboarding_start_button.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開啟您的時光旅程'**
  String get onboarding_start_button;

  /// No description provided for @onboarding_more_info.
  ///
  /// In zh_Hant, this message translates to:
  /// **'了解更多關於拾光的故事'**
  String get onboarding_more_info;

  /// No description provided for @legal_agreement_prefix.
  ///
  /// In zh_Hant, this message translates to:
  /// **'繼續即表示您同意本遊戲的'**
  String get legal_agreement_prefix;

  /// No description provided for @legal_terms_button.
  ///
  /// In zh_Hant, this message translates to:
  /// **'服務條款'**
  String get legal_terms_button;

  /// No description provided for @legal_and.
  ///
  /// In zh_Hant, this message translates to:
  /// **' 與 '**
  String get legal_and;

  /// No description provided for @legal_privacy_button.
  ///
  /// In zh_Hant, this message translates to:
  /// **'隱私權政策'**
  String get legal_privacy_button;

  /// No description provided for @call_memory_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'通話回憶錄'**
  String get call_memory_title;

  /// No description provided for @please_login_first.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請先登入喔'**
  String get please_login_first;

  /// No description provided for @no_call_memories.
  ///
  /// In zh_Hant, this message translates to:
  /// **'目前還沒有保存的通話回憶\n最多只能保存10則收藏哦'**
  String get no_call_memories;

  /// No description provided for @call_with_name.
  ///
  /// In zh_Hant, this message translates to:
  /// **'與 {name} 的通話'**
  String call_with_name(String name);

  /// No description provided for @call_duration.
  ///
  /// In zh_Hant, this message translates to:
  /// **'時長：{time}'**
  String call_duration(String time);

  /// No description provided for @delete_call_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'銷毀通話紀錄'**
  String get delete_call_title;

  /// No description provided for @delete_call_confirm.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定要秘密銷毀這段與 {name} 的通話回憶嗎？\n(刪除後無法找回喔)'**
  String delete_call_confirm(String name);

  /// No description provided for @keep_it.
  ///
  /// In zh_Hant, this message translates to:
  /// **'先留著'**
  String get keep_it;

  /// No description provided for @confirm_delete.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定銷毀'**
  String get confirm_delete;

  /// No description provided for @press_mic_to_speak.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請按下麥克風開始說話...'**
  String get press_mic_to_speak;

  /// No description provided for @call_ended.
  ///
  /// In zh_Hant, this message translates to:
  /// **'通話已結束'**
  String get call_ended;

  /// No description provided for @character_thinking.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（{name} 正在思考...）'**
  String character_thinking(String name);

  /// No description provided for @character_picking_up.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（{name} 正在接起電話...）'**
  String character_picking_up(String name);

  /// No description provided for @call_interrupted_login.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（通話中斷）請先登入喔...'**
  String get call_interrupted_login;

  /// No description provided for @silence.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（沈默）'**
  String get silence;

  /// No description provided for @bad_signal.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（訊號不好...）'**
  String get bad_signal;

  /// No description provided for @static_noise.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（沙沙聲）...聽不清楚...'**
  String get static_noise;

  /// No description provided for @type_message_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輸入文字...'**
  String get type_message_hint;

  /// No description provided for @draft_saved_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'草稿已安全儲存至秘密工作室！'**
  String get draft_saved_success;

  /// No description provided for @draft_save_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存失敗，請稍後再試'**
  String get draft_save_failed;

  /// No description provided for @draft_save_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'要儲存草稿嗎？'**
  String get draft_save_title;

  /// No description provided for @draft_save_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'妳的心血還沒發布，要先存進秘密工作室嗎？'**
  String get draft_save_content;

  /// No description provided for @not_save.
  ///
  /// In zh_Hant, this message translates to:
  /// **'不儲存'**
  String get not_save;

  /// No description provided for @save_draft.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存草稿'**
  String get save_draft;

  /// No description provided for @confirm_delete_char_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'你確定要刪除角色 \"{name}\" 嗎？\n\n此動作無法復原！'**
  String confirm_delete_char_content(String name);

  /// No description provided for @char_deleted.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色已刪除'**
  String get char_deleted;

  /// No description provided for @ok_button.
  ///
  /// In zh_Hant, this message translates to:
  /// **'好的!'**
  String get ok_button;

  /// No description provided for @cannot_save_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'無法儲存'**
  String get cannot_save_title;

  /// No description provided for @cannot_save_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請填寫角色名稱並至少上傳一張頭像！'**
  String get cannot_save_content;

  /// No description provided for @word_count_exceeded.
  ///
  /// In zh_Hant, this message translates to:
  /// **'字數過多'**
  String get word_count_exceeded;

  /// No description provided for @word_count_error_detail.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「{field}」已超過 {limit} 字，請刪減後再儲存。'**
  String word_count_error_detail(String field, int limit);

  /// No description provided for @content_missing.
  ///
  /// In zh_Hant, this message translates to:
  /// **'內容缺失'**
  String get content_missing;

  /// No description provided for @content_missing_personality.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請填寫「詳細個性」！請至少寫 10 個字。'**
  String get content_missing_personality;

  /// No description provided for @content_missing_bg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「角色簡介」太短了！請至少寫 20 個字，交代一下背景。'**
  String get content_missing_bg;

  /// No description provided for @content_missing_tone.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請設定「語氣與習慣」，不然容易OOC！'**
  String get content_missing_tone;

  /// No description provided for @user_not_found.
  ///
  /// In zh_Hant, this message translates to:
  /// **'錯誤：找不到使用者'**
  String get user_not_found;

  /// No description provided for @char_saved_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色 \"{name}\" 已{action}！'**
  String char_saved_success(String name, String action);

  /// No description provided for @save_error_detail.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存失敗：{error}'**
  String save_error_detail(String error);

  /// No description provided for @easter_egg_add_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新增隱藏彩蛋'**
  String get easter_egg_add_title;

  /// No description provided for @easter_egg_edit_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯彩蛋'**
  String get easter_egg_edit_title;

  /// No description provided for @keyword_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'觸發關鍵字 (必填)'**
  String get keyword_label;

  /// No description provided for @keyword_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：去遊樂園、草莓蛋糕'**
  String get keyword_hint;

  /// No description provided for @egg_title_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'彩蛋標題 (給玩家看)'**
  String get egg_title_label;

  /// No description provided for @egg_title_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：週末的約會'**
  String get egg_title_hint;

  /// No description provided for @egg_teaser_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'簡短預告 (給玩家看)'**
  String get egg_teaser_label;

  /// No description provided for @egg_teaser_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'描述即將發生的事情開頭...'**
  String get egg_teaser_hint;

  /// No description provided for @egg_scene_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'強制場景切換 (選填)'**
  String get egg_scene_label;

  /// No description provided for @egg_scene_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：遊樂園、鬼屋'**
  String get egg_scene_hint;

  /// No description provided for @egg_prompt_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'劇本指令'**
  String get egg_prompt_label;

  /// No description provided for @egg_prompt_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'如何演出這段劇情。\n(System:場景切換到遊樂園，角色看著(玩家名字)笑了...)'**
  String get egg_prompt_hint;

  /// No description provided for @confirm_button.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確認'**
  String get confirm_button;

  /// No description provided for @keyword_empty_error.
  ///
  /// In zh_Hant, this message translates to:
  /// **'關鍵字不能為空'**
  String get keyword_empty_error;

  /// No description provided for @voice_custom_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'訂製專屬聲線'**
  String get voice_custom_title;

  /// No description provided for @voice_custom_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：低沉霸總、溫柔奶狗...'**
  String get voice_custom_hint;

  /// No description provided for @voice_generate_start.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開始生成'**
  String get voice_generate_start;

  /// No description provided for @voice_bind_first.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請先選擇並「綁定」一個專屬聲音喔！'**
  String get voice_bind_first;

  /// No description provided for @voice_test_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'試聽失敗：請先點擊「就決定是你了！」正式綁定聲音後再微調喔！'**
  String get voice_test_failed;

  /// No description provided for @voice_name_default.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{name} 的專屬聲線'**
  String voice_name_default(String name);

  /// No description provided for @voice_description_default.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這是「戀戀拾光」中為專屬角色打造的獨一無二聲線，由玩家親自挑選生成。'**
  String get voice_description_default;

  /// No description provided for @voice_bind_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'綁定聲音失敗，請檢查 API 額度或網路狀態'**
  String get voice_bind_failed;

  /// No description provided for @voice_bind_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'\"{name}\" 的靈魂聲線已正式綁定！'**
  String voice_bind_success(String name);

  /// No description provided for @voice_bind_success_draft.
  ///
  /// In zh_Hant, this message translates to:
  /// **'聲線綁定成功！現在可以拉動滑桿測試情緒囉！'**
  String get voice_bind_success_draft;

  /// No description provided for @sync_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'同步失敗，請檢查網路：{error}'**
  String sync_failed(String error);

  /// No description provided for @edit_character_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯 {name}'**
  String edit_character_title(String name);

  /// No description provided for @test_mode_tooltip.
  ///
  /// In zh_Hant, this message translates to:
  /// **'完整功能測試 '**
  String get test_mode_tooltip;

  /// No description provided for @test_mode_error.
  ///
  /// In zh_Hant, this message translates to:
  /// **'⚠️ 找不到角色檔案！請先點擊最下方的「儲存/發布」後，再來試玩喔！'**
  String get test_mode_error;

  /// No description provided for @test_mode_notice.
  ///
  /// In zh_Hant, this message translates to:
  /// **'💡 測試模式將依照各模式原價扣點，且不計入正式回憶喔！'**
  String get test_mode_notice;

  /// No description provided for @delete_character_tooltip.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除角色'**
  String get delete_character_tooltip;

  /// No description provided for @tab_basic_story.
  ///
  /// In zh_Hant, this message translates to:
  /// **'基本與劇情'**
  String get tab_basic_story;

  /// No description provided for @tab_voice.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬語音'**
  String get tab_voice;

  /// No description provided for @tab_relationship.
  ///
  /// In zh_Hant, this message translates to:
  /// **'社交關係'**
  String get tab_relationship;

  /// No description provided for @save_changes_button.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存變更'**
  String get save_changes_button;

  /// No description provided for @section_basic_info.
  ///
  /// In zh_Hant, this message translates to:
  /// **'基礎資料'**
  String get section_basic_info;

  /// No description provided for @hint_occupation.
  ///
  /// In zh_Hant, this message translates to:
  /// **'支援多重身分，請用斜線或逗號分隔 (例如：學生/駭客)'**
  String get hint_occupation;

  /// No description provided for @hint_appearance.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：銀色長髮，琥珀色眼睛，總是穿著白袍...'**
  String get hint_appearance;

  /// No description provided for @section_story_identity.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🎭 劇情與你的身分'**
  String get section_story_identity;

  /// No description provided for @story_identity_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'定義故事開場與「你」在這個存檔裡的特殊設定'**
  String get story_identity_desc;

  /// No description provided for @advanced_writing_tips_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'💡 進階寫作技巧：\n'**
  String get advanced_writing_tips_title;

  /// No description provided for @advanced_writing_tips_1.
  ///
  /// In zh_Hant, this message translates to:
  /// **'在故事或台詞中輸入 '**
  String get advanced_writing_tips_1;

  /// No description provided for @advanced_writing_tips_2.
  ///
  /// In zh_Hant, this message translates to:
  /// **'(玩家名字)'**
  String get advanced_writing_tips_2;

  /// No description provided for @advanced_writing_tips_3.
  ///
  /// In zh_Hant, this message translates to:
  /// **'，系統在遊玩時會自動替換成玩家的真實暱稱喔！\n'**
  String get advanced_writing_tips_3;

  /// No description provided for @advanced_writing_tips_4.
  ///
  /// In zh_Hant, this message translates to:
  /// **'範例：「'**
  String get advanced_writing_tips_4;

  /// No description provided for @advanced_writing_tips_5.
  ///
  /// In zh_Hant, this message translates to:
  /// **'(玩家名字)'**
  String get advanced_writing_tips_5;

  /// No description provided for @advanced_writing_tips_6.
  ///
  /// In zh_Hant, this message translates to:
  /// **'，妳怎麼這麼晚才來？」'**
  String get advanced_writing_tips_6;

  /// No description provided for @player_identity_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'玩家預設身分 (Player Identity) - 💡 選填'**
  String get player_identity_label;

  /// No description provided for @player_identity_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'【選填】若留空，AI 將會讀取你的「個人檔案」來互動。\n若填寫，則強制扮演特定身分（例如：綁定他的冷酷系統、或被背叛的妻子）。'**
  String get player_identity_hint;

  /// No description provided for @background_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色背景與世界觀 '**
  String get background_label;

  /// No description provided for @background_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'描述他的過去、所處的世界觀（如：現代都市、ABO、末世）。例如：這是一個喪屍橫行的世界，他是保護你的特種兵...'**
  String get background_hint;

  /// No description provided for @story_summary_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'一句話故事簡介 '**
  String get story_summary_label;

  /// No description provided for @story_initial_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'初始相遇故事 '**
  String get story_initial_label;

  /// No description provided for @story_initial_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：妳推開門，看見他坐在窗邊。他轉過頭說：「(玩家名字)，過來。」...'**
  String get story_initial_hint;

  /// No description provided for @first_line_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色的第一句話'**
  String get first_line_label;

  /// No description provided for @first_line_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：(玩家名字)，妳終於來了。'**
  String get first_line_hint;

  /// No description provided for @section_personality_evo.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🌟 個性與好感度演變'**
  String get section_personality_evo;

  /// No description provided for @detailed_personality_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'詳細個性 '**
  String get detailed_personality_label;

  /// No description provided for @detailed_personality_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'描述他的核心性格。例如：傲嬌，嘴硬心軟。對外人冷漠，只對玩家展露笑容。'**
  String get detailed_personality_hint;

  /// No description provided for @affection_evo_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'AI 將根據以下設定判斷何時增加好感度：'**
  String get affection_evo_desc;

  /// No description provided for @stage_1_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'階段一：陌生/警戒 (Lv1)'**
  String get stage_1_label;

  /// No description provided for @stage_1_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'剛認識時的反應。觸發好感條件(例如:禮貌、不探聽隱私)。'**
  String get stage_1_hint;

  /// No description provided for @stage_2_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'階段二：熟悉/朋友 (Lv2)'**
  String get stage_2_label;

  /// No description provided for @stage_2_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'熟了之後的變化。觸發好感條件(例如:分享甜食、聊貓的話題)。'**
  String get stage_2_hint;

  /// No description provided for @stage_3_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'階段三：親密/戀人 (Lv3)'**
  String get stage_3_label;

  /// No description provided for @stage_3_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'完全淪陷後的反應。會吃醋?還是會生悶氣?'**
  String get stage_3_hint;

  /// No description provided for @social_interaction_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'社交與環境互動'**
  String get social_interaction_label;

  /// No description provided for @social_interaction_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如:如何對待路人？遇到討厭的東西(雷點)會怎麼炸毛？'**
  String get social_interaction_hint;

  /// No description provided for @section_habits.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🗣️ 喜好與習慣'**
  String get section_habits;

  /// No description provided for @tone_hint_detail.
  ///
  /// In zh_Hant, this message translates to:
  /// **'必填。例如：說話簡短，喜歡反問。口頭禪是「笨蛋」。禁止使用翻譯腔。'**
  String get tone_hint_detail;

  /// No description provided for @dialogue_example_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'玩家：我好累。\n角色：(摸頭) 乖，快去休息。'**
  String get dialogue_example_hint;

  /// No description provided for @section_easter_eggs.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🎁 隱藏彩蛋與特殊劇情'**
  String get section_easter_eggs;

  /// No description provided for @no_easter_eggs.
  ///
  /// In zh_Hant, this message translates to:
  /// **'尚未設定彩蛋，點擊下方按鈕新增'**
  String get no_easter_eggs;

  /// No description provided for @no_scene_change.
  ///
  /// In zh_Hant, this message translates to:
  /// **'不切換場景'**
  String get no_scene_change;

  /// No description provided for @add_easter_egg_button.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新增隱藏彩蛋'**
  String get add_easter_egg_button;

  /// No description provided for @other_extra_info.
  ///
  /// In zh_Hant, this message translates to:
  /// **'其他補充資訊'**
  String get other_extra_info;

  /// No description provided for @visibility_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色可見度'**
  String get visibility_label;

  /// No description provided for @visibility_public.
  ///
  /// In zh_Hant, this message translates to:
  /// **'公開'**
  String get visibility_public;

  /// No description provided for @visibility_private.
  ///
  /// In zh_Hant, this message translates to:
  /// **'私人'**
  String get visibility_private;

  /// No description provided for @section_voice_gen.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🎙️他專屬聲線生成'**
  String get section_voice_gen;

  /// No description provided for @voice_gen_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輸入提示詞，讓他有全世界獨一無二的專屬聲音！\n（💡 貼心提醒：生成後若不滿意，隨時都能重新訂製喔！）'**
  String get voice_gen_desc;

  /// No description provided for @voice_generating_status.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在調配聲線中...'**
  String get voice_generating_status;

  /// No description provided for @voice_select_prompt.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✨ 幫你捏好了三種聲線，請挑選：'**
  String get voice_select_prompt;

  /// No description provided for @voice_sample_name.
  ///
  /// In zh_Hant, this message translates to:
  /// **'聲線樣本 {index}'**
  String voice_sample_name(int index);

  /// No description provided for @voice_sample_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'點擊卡片選擇，點擊右側試聽'**
  String get voice_sample_desc;

  /// No description provided for @voice_preparing.
  ///
  /// In zh_Hant, this message translates to:
  /// **'聲音還在準備中...'**
  String get voice_preparing;

  /// No description provided for @voice_retry.
  ///
  /// In zh_Hant, this message translates to:
  /// **'放棄並重試'**
  String get voice_retry;

  /// No description provided for @voice_confirm_selection.
  ///
  /// In zh_Hant, this message translates to:
  /// **'就決定是你了！'**
  String get voice_confirm_selection;

  /// No description provided for @voice_bind_success_banner.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已成功綁定專屬聲音！'**
  String get voice_bind_success_banner;

  /// No description provided for @voice_remake.
  ///
  /// In zh_Hant, this message translates to:
  /// **'重製聲線'**
  String get voice_remake;

  /// No description provided for @voice_btn_generating.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在生成中，請稍候...'**
  String get voice_btn_generating;

  /// No description provided for @voice_btn_generate.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輸入提示詞，生成專屬聲音'**
  String get voice_btn_generate;

  /// No description provided for @voice_advanced_tuning.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🎛️ 進階：微調說話情緒 '**
  String get voice_advanced_tuning;

  /// No description provided for @voice_stability_low.
  ///
  /// In zh_Hant, this message translates to:
  /// **'野性/氣音 🐺'**
  String get voice_stability_low;

  /// No description provided for @voice_stability_value.
  ///
  /// In zh_Hant, this message translates to:
  /// **'理智度: {value}'**
  String voice_stability_value(String value);

  /// No description provided for @voice_stability_high.
  ///
  /// In zh_Hant, this message translates to:
  /// **'平穩/冷靜 🤖'**
  String get voice_stability_high;

  /// No description provided for @voice_style_low.
  ///
  /// In zh_Hant, this message translates to:
  /// **'冷淡/壓抑 🧊'**
  String get voice_style_low;

  /// No description provided for @voice_style_value.
  ///
  /// In zh_Hant, this message translates to:
  /// **'戲劇表現: {value}'**
  String voice_style_value(String value);

  /// No description provided for @voice_style_high.
  ///
  /// In zh_Hant, this message translates to:
  /// **'浮誇/深情 🔥'**
  String get voice_style_high;

  /// No description provided for @voice_test_btn_testing.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在套用情緒...'**
  String get voice_test_btn_testing;

  /// No description provided for @voice_test_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'試聽目前情緒'**
  String get voice_test_btn;

  /// No description provided for @section_social_circle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'👥 他的社交圈'**
  String get section_social_circle;

  /// No description provided for @social_circle_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'設定他對其他角色的看法。當玩家在聊天中提到對方時，他就會根據這裡的設定做出反應（例如：吃醋、生氣）。'**
  String get social_circle_desc;

  /// No description provided for @social_no_drama.
  ///
  /// In zh_Hant, this message translates to:
  /// **'目前還沒有與其他男神的過節...'**
  String get social_no_drama;

  /// No description provided for @social_target.
  ///
  /// In zh_Hant, this message translates to:
  /// **'對象：{name}'**
  String social_target(String name);

  /// No description provided for @social_attitude.
  ///
  /// In zh_Hant, this message translates to:
  /// **'看法：{attitude}'**
  String social_attitude(String attitude);

  /// No description provided for @social_edit_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯對 {name} 的看法 💬'**
  String social_edit_title(String name);

  /// No description provided for @social_attitude_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'他的看法 / 態度'**
  String get social_attitude_label;

  /// No description provided for @social_attitude_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：覺得對方很囉嗦，但其實很依賴他...'**
  String get social_attitude_hint;

  /// No description provided for @social_save_changes.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存修改'**
  String get social_save_changes;

  /// No description provided for @social_add_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新增角色關係 🤝'**
  String get social_add_title;

  /// No description provided for @social_select_target.
  ///
  /// In zh_Hant, this message translates to:
  /// **'選擇對象'**
  String get social_select_target;

  /// No description provided for @social_thoughts_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'他對這個人的看法...'**
  String get social_thoughts_label;

  /// No description provided for @social_thoughts_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：那鋼琴家太吵了...'**
  String get social_thoughts_hint;

  /// No description provided for @social_add_confirm.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確認新增'**
  String get social_add_confirm;

  /// No description provided for @gallery_load_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'圖片載入失敗 🥲\n請確認網路正常，如果是 Web 請查看 console。'**
  String get gallery_load_failed;

  /// No description provided for @gallery_affection_req.
  ///
  /// In zh_Hant, this message translates to:
  /// **'好感 {level}'**
  String gallery_affection_req(int level);

  /// No description provided for @gallery_upload_limit.
  ///
  /// In zh_Hant, this message translates to:
  /// **'最多只能上傳10張圖片'**
  String get gallery_upload_limit;

  /// No description provided for @gallery_photo_setup.
  ///
  /// In zh_Hant, this message translates to:
  /// **'設定照片解鎖條件'**
  String get gallery_photo_setup;

  /// No description provided for @gallery_photo_desc_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這張照片是什麼？'**
  String get gallery_photo_desc_label;

  /// No description provided for @gallery_photo_desc_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：睡衣照、約會照'**
  String get gallery_photo_desc_hint;

  /// No description provided for @gallery_photo_req_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'需要多少好感度解鎖？'**
  String get gallery_photo_req_label;

  /// No description provided for @gallery_photo_req_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輸入數字，0代表免費'**
  String get gallery_photo_req_hint;

  /// No description provided for @gallery_cancel_upload.
  ///
  /// In zh_Hant, this message translates to:
  /// **'取消上傳'**
  String get gallery_cancel_upload;

  /// No description provided for @gallery_confirm_add.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確認新增'**
  String get gallery_confirm_add;

  /// No description provided for @default_photo_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬照片'**
  String get default_photo_desc;

  /// No description provided for @draft_photo_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'草稿照片'**
  String get draft_photo_desc;

  /// No description provided for @loading_text.
  ///
  /// In zh_Hant, this message translates to:
  /// **'讀取中...'**
  String get loading_text;

  /// No description provided for @default_unnamed_character.
  ///
  /// In zh_Hant, this message translates to:
  /// **'未命名角色'**
  String get default_unnamed_character;

  /// No description provided for @elevenlabs_error.
  ///
  /// In zh_Hant, this message translates to:
  /// **'ElevenLabs 錯誤：{code}'**
  String elevenlabs_error(String code);

  /// No description provided for @voice_sample_script.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（清了清嗓子）你好。這是一段專屬於我的聲音測試。在接下來的日子裡，我會在這裡陪著你。不管是開心的時候，還是難過的時候，你都可以跟我分享。這樣說話的節奏和音色，你聽起來還習慣嗎？如果覺得不錯的話，我們就把這個聲音定下來，做為我以後和你聊天的專屬聲線吧。期待我們未來的每一天。'**
  String get voice_sample_script;

  /// No description provided for @voice_test_script.
  ///
  /// In zh_Hant, this message translates to:
  /// **'你覺得我現在說話的語氣，聽起來怎麼樣呢？如果滿意的話，我們就這樣定下來吧。'**
  String get voice_test_script;

  /// No description provided for @field_background.
  ///
  /// In zh_Hant, this message translates to:
  /// **'角色簡介'**
  String get field_background;

  /// No description provided for @field_tone.
  ///
  /// In zh_Hant, this message translates to:
  /// **'語氣與習慣'**
  String get field_tone;

  /// No description provided for @field_initial_story.
  ///
  /// In zh_Hant, this message translates to:
  /// **'初始故事'**
  String get field_initial_story;

  /// No description provided for @update_action.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更新'**
  String get update_action;

  /// No description provided for @default_new_player.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新玩家'**
  String get default_new_player;

  /// No description provided for @translating_status.
  ///
  /// In zh_Hant, this message translates to:
  /// **'翻譯中...'**
  String get translating_status;

  /// No description provided for @translate_profile_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'翻譯檔案內容'**
  String get translate_profile_btn;

  /// No description provided for @translate_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'翻譯失敗: {error}'**
  String translate_failed(String error);

  /// No description provided for @like_own_char_warning.
  ///
  /// In zh_Hant, this message translates to:
  /// **'不能按自己創造的角色讚喔！🤭'**
  String get like_own_char_warning;

  /// No description provided for @like_success_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已送出喜歡！創作者會很開心的💖'**
  String get like_success_msg;

  /// No description provided for @unlike_success_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已收回喜歡 💔'**
  String get unlike_success_msg;

  /// No description provided for @like_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'喜歡'**
  String get like_label;

  /// No description provided for @dislike_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'不喜歡'**
  String get dislike_label;

  /// No description provided for @block_char.
  ///
  /// In zh_Hant, this message translates to:
  /// **'封鎖此角色'**
  String get block_char;

  /// No description provided for @char_blocked_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已封鎖此角色。'**
  String get char_blocked_msg;

  /// No description provided for @dislike_dialog_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'不太喜歡這個角色？'**
  String get dislike_dialog_title;

  /// No description provided for @dislike_dialog_subtitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請偷偷告訴我們原因，官方會進行審核與把關：'**
  String get dislike_dialog_subtitle;

  /// No description provided for @dislike_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'設定太無聊、圖片不適合...'**
  String get dislike_hint;

  /// No description provided for @dislike_thanks.
  ///
  /// In zh_Hant, this message translates to:
  /// **'感謝您的回饋！官方已收到您的悄悄話。'**
  String get dislike_thanks;

  /// No description provided for @dislike_submit.
  ///
  /// In zh_Hant, this message translates to:
  /// **'悄悄送出'**
  String get dislike_submit;

  /// No description provided for @report_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'📢 檢舉留言'**
  String get report_title;

  /// No description provided for @report_subtitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請選擇檢舉原因：\n檢舉後我們將會盡快審核內容。'**
  String get report_subtitle;

  /// No description provided for @report_opt_1.
  ///
  /// In zh_Hant, this message translates to:
  /// **'色情或血腥暴力內容'**
  String get report_opt_1;

  /// No description provided for @report_opt_2.
  ///
  /// In zh_Hant, this message translates to:
  /// **'詆毀、侮辱或攻擊角色'**
  String get report_opt_2;

  /// No description provided for @report_opt_3.
  ///
  /// In zh_Hant, this message translates to:
  /// **'仇恨言論或人身攻擊'**
  String get report_opt_3;

  /// No description provided for @report_opt_4.
  ///
  /// In zh_Hant, this message translates to:
  /// **'垃圾訊息或廣告詐騙'**
  String get report_opt_4;

  /// No description provided for @report_opt_5.
  ///
  /// In zh_Hant, this message translates to:
  /// **'其他不當內容'**
  String get report_opt_5;

  /// No description provided for @report_confirm.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定檢舉'**
  String get report_confirm;

  /// No description provided for @report_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'檢舉成功，已收到通知！將會盡快審核內容 🛡️'**
  String get report_success;

  /// No description provided for @report_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'檢舉失敗，請檢查網路連線。'**
  String get report_failed;

  /// No description provided for @lore_delete_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'⚠️ 警告：消除記憶'**
  String get lore_delete_title;

  /// No description provided for @lore_delete_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這段記憶一旦刪除就徹底消失囉，確定要狠心抹除它嗎？'**
  String get lore_delete_content;

  /// No description provided for @lore_delete_cancel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'手滑了'**
  String get lore_delete_cancel;

  /// No description provided for @lore_delete_confirm.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定抹除'**
  String get lore_delete_confirm;

  /// No description provided for @lore_delete_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🗑️ 記憶碎片已徹底消除。'**
  String get lore_delete_success;

  /// No description provided for @lore_add_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'撰寫新記憶 🖋️'**
  String get lore_add_title;

  /// No description provided for @lore_edit_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯記憶碎片 🖋️'**
  String get lore_edit_title;

  /// No description provided for @lore_title_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'記憶標題'**
  String get lore_title_label;

  /// No description provided for @lore_title_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：第一次相遇的雨天'**
  String get lore_title_hint;

  /// No description provided for @lore_teaser_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'摘要 / 引言'**
  String get lore_teaser_label;

  /// No description provided for @lore_teaser_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'顯示在卡片上的簡短描述...'**
  String get lore_teaser_hint;

  /// No description provided for @lore_content_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'完整記憶內容'**
  String get lore_content_label;

  /// No description provided for @lore_content_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'寫下這段詳細的故事或設定...'**
  String get lore_content_hint;

  /// No description provided for @lore_lock_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🔒 封印這段記憶'**
  String get lore_lock_label;

  /// No description provided for @lore_lock_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'打勾後，只有創作者自己看得到，玩家無法觀看'**
  String get lore_lock_desc;

  /// No description provided for @lore_empty_error.
  ///
  /// In zh_Hant, this message translates to:
  /// **'標題和內容不能是空的喔！'**
  String get lore_empty_error;

  /// No description provided for @lore_add_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✨ 新記憶已成功封存！'**
  String get lore_add_success;

  /// No description provided for @lore_publish.
  ///
  /// In zh_Hant, this message translates to:
  /// **'發布記憶'**
  String get lore_publish;

  /// No description provided for @lore_save_edit.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存修改'**
  String get lore_save_edit;

  /// No description provided for @lore_write_first.
  ///
  /// In zh_Hant, this message translates to:
  /// **'快來為{pronoun}寫下第一段過往吧！'**
  String lore_write_first(Object pronoun);

  /// No description provided for @lore_waiting.
  ///
  /// In zh_Hant, this message translates to:
  /// **'期待與{pronoun}的故事...'**
  String lore_waiting(Object pronoun);

  /// No description provided for @lore_sealed_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🔒 這段記憶已被封印，目前無法查看。'**
  String get lore_sealed_msg;

  /// No description provided for @lore_not_open_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這段記憶尚未對外開放喔...'**
  String get lore_not_open_msg;

  /// No description provided for @lore_unnamed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'未命名碎片'**
  String get lore_unnamed;

  /// No description provided for @lore_add_btn_limit.
  ///
  /// In zh_Hant, this message translates to:
  /// **'撰寫新的記憶碎片 (上限 10 則)'**
  String get lore_add_btn_limit;

  /// No description provided for @lore_collapse.
  ///
  /// In zh_Hant, this message translates to:
  /// **'收起信件'**
  String get lore_collapse;

  /// No description provided for @echo_delete_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🗑️ 刪除留言'**
  String get echo_delete_title;

  /// No description provided for @echo_delete_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定要刪除這則時空迴音嗎？\n刪除後就再也找不回來囉！'**
  String get echo_delete_content;

  /// No description provided for @echo_keep.
  ///
  /// In zh_Hant, this message translates to:
  /// **'保留'**
  String get echo_keep;

  /// No description provided for @echo_clear_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'時空迴音已清除 🧹'**
  String get echo_clear_success;

  /// No description provided for @echo_energy_full_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'⚠️ 宇宙能量已達上限'**
  String get echo_energy_full_title;

  /// No description provided for @echo_energy_full_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'妳的時空能量已達上限 (最多 3 則)，請先刪除妳舊的時空經歷，才能開啟新的宇宙紀錄喔！'**
  String get echo_energy_full_content;

  /// No description provided for @echo_write_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'留下妳的時空迴音 🌌'**
  String get echo_write_title;

  /// No description provided for @echo_write_subtitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'寫下妳在這裡的經歷或心動語錄吧！'**
  String get echo_write_subtitle;

  /// No description provided for @echo_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「就算世界末日，我也會優先確保妳的呼吸...」'**
  String get echo_hint;

  /// No description provided for @echo_theme_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'選擇便條貼邊框：'**
  String get echo_theme_label;

  /// No description provided for @theme_butterfly.
  ///
  /// In zh_Hant, this message translates to:
  /// **'蝴蝶'**
  String get theme_butterfly;

  /// No description provided for @theme_sprout.
  ///
  /// In zh_Hant, this message translates to:
  /// **'小草'**
  String get theme_sprout;

  /// No description provided for @theme_star.
  ///
  /// In zh_Hant, this message translates to:
  /// **'星空'**
  String get theme_star;

  /// No description provided for @theme_planet.
  ///
  /// In zh_Hant, this message translates to:
  /// **'星球'**
  String get theme_planet;

  /// No description provided for @echo_publish_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'發布時空紀錄'**
  String get echo_publish_btn;

  /// No description provided for @echo_wall_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'時空迴音牆'**
  String get echo_wall_title;

  /// No description provided for @echo_leave_memory.
  ///
  /// In zh_Hant, this message translates to:
  /// **'留下經歷'**
  String get echo_leave_memory;

  /// No description provided for @echo_empty_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'還沒有時空旅人留下紀錄...\n妳要成為第一個嗎？'**
  String get echo_empty_msg;

  /// No description provided for @creator_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'創作者'**
  String get creator_label;

  /// No description provided for @follow_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'關注'**
  String get follow_btn;

  /// No description provided for @followed_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已關注'**
  String get followed_btn;

  /// No description provided for @follow_own_warning.
  ///
  /// In zh_Hant, this message translates to:
  /// **'創作者不能關注自己哦！🤭'**
  String get follow_own_warning;

  /// No description provided for @follow_success_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✨ {playerName} 關注了 {creatorName}！'**
  String follow_success_msg(String playerName, String creatorName);

  /// No description provided for @mailbox_follow_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'獲得新的守護者 🦋'**
  String get mailbox_follow_title;

  /// No description provided for @mailbox_follow_body.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{playerName} 剛剛關注了妳！'**
  String mailbox_follow_body(String playerName);

  /// No description provided for @tab_private_profile.
  ///
  /// In zh_Hant, this message translates to:
  /// **'私密檔案'**
  String get tab_private_profile;

  /// No description provided for @tab_memory_fragments.
  ///
  /// In zh_Hant, this message translates to:
  /// **'記憶碎片'**
  String get tab_memory_fragments;

  /// No description provided for @tab_time_echoes.
  ///
  /// In zh_Hant, this message translates to:
  /// **'時空迴音'**
  String get tab_time_echoes;

  /// No description provided for @chat_free_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'閒聊(免費)'**
  String get chat_free_btn;

  /// No description provided for @start_story_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開始劇情'**
  String get start_story_btn;

  /// No description provided for @default_chat_initial.
  ///
  /// In zh_Hant, this message translates to:
  /// **'找我有事嗎？'**
  String get default_chat_initial;

  /// No description provided for @gallery_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬通話背景'**
  String get gallery_title;

  /// No description provided for @gallery_current_affection.
  ///
  /// In zh_Hant, this message translates to:
  /// **'目前好感度: {value} 💕'**
  String gallery_current_affection(String value);

  /// No description provided for @gallery_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'相簿裡還沒有照片喔'**
  String get gallery_empty;

  /// No description provided for @gallery_unlocked_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已將背景設為「{desc}」！'**
  String gallery_unlocked_msg(String desc);

  /// No description provided for @gallery_lock_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'好感度達到 {value} 即可解鎖喔！🍃'**
  String gallery_lock_msg(String value);

  /// No description provided for @gallery_reset_bg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已恢復預設通話背景'**
  String get gallery_reset_bg;

  /// No description provided for @background_story_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'背景故事'**
  String get background_story_title;

  /// No description provided for @background_story_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這個角色很神秘，還沒有背景故事...'**
  String get background_story_empty;

  /// No description provided for @followed_creator_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已關注 {creatorName} 🦋'**
  String followed_creator_msg(String creatorName);

  /// No description provided for @mailbox_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬信箱 💌'**
  String get mailbox_title;

  /// No description provided for @mailbox_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'信箱空空的，快去發佈動態吸引他吧！'**
  String get mailbox_empty;

  /// No description provided for @new_notification.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新通知'**
  String get new_notification;

  /// No description provided for @default_he.
  ///
  /// In zh_Hant, this message translates to:
  /// **'他'**
  String get default_he;

  /// No description provided for @affection_upgrade_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{charName} 對妳的好感度提升了！ 💖'**
  String affection_upgrade_title(String charName);

  /// No description provided for @flower_reward.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🌸 獲得 5 點花花'**
  String get flower_reward;

  /// No description provided for @affection_quote_lv5.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「沒想到...妳對我來說，已經變得這麼重要了。重要到...我無法想像沒有妳的世界。」'**
  String get affection_quote_lv5;

  /// No description provided for @affection_quote_lv4.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「這輩子最幸運的事，大概就是在那天，回頭看見了妳。」'**
  String get affection_quote_lv4;

  /// No description provided for @affection_quote_lv3.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「最近...我發現自己發呆的時間變多了，而且腦袋裡全都是妳。」'**
  String get affection_quote_lv3;

  /// No description provided for @affection_quote_lv2.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「既然是妳的邀約，那我稍微空出點時間，也不是不行。」'**
  String get affection_quote_lv2;

  /// No description provided for @affection_quote_lv1.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「最近常看到妳，感覺...並不討厭這種見面的頻率。」'**
  String get affection_quote_lv1;

  /// No description provided for @affection_quote_lv0.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「原來妳也在這裡，這算是一種奇妙的緣分嗎？」'**
  String get affection_quote_lv0;

  /// No description provided for @lore_edit_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✨ 記憶碎片已成功更新！'**
  String get lore_edit_success;

  /// No description provided for @delete_failed_network.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除失敗，請檢查網路或權限。'**
  String get delete_failed_network;

  /// No description provided for @ai_chat_language.
  ///
  /// In zh_Hant, this message translates to:
  /// **'繁體中文'**
  String get ai_chat_language;

  /// No description provided for @ai_chat_language_code.
  ///
  /// In zh_Hant, this message translates to:
  /// **'zh-TW'**
  String get ai_chat_language_code;

  /// No description provided for @chat_home_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'訊息'**
  String get chat_home_title;

  /// No description provided for @call_memory_tooltip.
  ///
  /// In zh_Hant, this message translates to:
  /// **'通話回憶'**
  String get call_memory_tooltip;

  /// No description provided for @login_to_view_chat.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請先登入以查看聊天紀錄'**
  String get login_to_view_chat;

  /// No description provided for @load_chat_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'讀取聊天列表失敗: {error}'**
  String load_chat_failed(String error);

  /// No description provided for @chat_list_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'聊天室空空的...'**
  String get chat_list_empty;

  /// No description provided for @go_to_encounter.
  ///
  /// In zh_Hant, this message translates to:
  /// **'去「邂逅」找個人聊聊吧！'**
  String get go_to_encounter;

  /// No description provided for @confirm_delete_chat.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定要刪除與 {charName} 的對話嗎？'**
  String confirm_delete_chat(String charName);

  /// No description provided for @affection_score_short.
  ///
  /// In zh_Hant, this message translates to:
  /// **'好感 {score}'**
  String affection_score_short(String score);

  /// No description provided for @character_not_found.
  ///
  /// In zh_Hant, this message translates to:
  /// **'無法讀取角色資料，該角色可能已被刪除。'**
  String get character_not_found;

  /// No description provided for @preparing_chat_room.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在為您準備專屬聊天室...'**
  String get preparing_chat_room;

  /// No description provided for @rename_chat_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'為這段記憶命名'**
  String get rename_chat_title;

  /// No description provided for @rename_chat_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'例如：(程聿)改成(離婚倒數中)'**
  String get rename_chat_hint;

  /// No description provided for @save_tag_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存標籤'**
  String get save_tag_btn;

  /// No description provided for @room_name_updated.
  ///
  /// In zh_Hant, this message translates to:
  /// **'房間名稱已更新！'**
  String get room_name_updated;

  /// No description provided for @update_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更新失敗: {error}'**
  String update_failed(String error);

  /// No description provided for @chat_mode_daily.
  ///
  /// In zh_Hant, this message translates to:
  /// **'日常'**
  String get chat_mode_daily;

  /// No description provided for @chat_mode_story.
  ///
  /// In zh_Hant, this message translates to:
  /// **'劇情'**
  String get chat_mode_story;

  /// No description provided for @chat_mode_immersive.
  ///
  /// In zh_Hant, this message translates to:
  /// **'沉浸'**
  String get chat_mode_immersive;

  /// No description provided for @chat_mode_gemini.
  ///
  /// In zh_Hant, this message translates to:
  /// **'閒聊'**
  String get chat_mode_gemini;

  /// No description provided for @lang_zh.
  ///
  /// In zh_Hant, this message translates to:
  /// **'繁體中文'**
  String get lang_zh;

  /// No description provided for @lang_ja.
  ///
  /// In zh_Hant, this message translates to:
  /// **'日本語'**
  String get lang_ja;

  /// No description provided for @lang_ko.
  ///
  /// In zh_Hant, this message translates to:
  /// **'한국어'**
  String get lang_ko;

  /// No description provided for @lang_en.
  ///
  /// In zh_Hant, this message translates to:
  /// **'English'**
  String get lang_en;

  /// No description provided for @lang_vi.
  ///
  /// In zh_Hant, this message translates to:
  /// **'Tiếng Việt'**
  String get lang_vi;

  /// No description provided for @chat_load_char_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'找不到角色資料，請返回重試或檢查網路。'**
  String get chat_load_char_failed;

  /// No description provided for @chat_jump_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已跳轉至該段回憶 🍃'**
  String get chat_jump_success;

  /// No description provided for @chat_create_room_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'連線似乎有點不穩，建立聊天室失敗，請再試一次。'**
  String get chat_create_room_failed;

  /// No description provided for @chat_secret_file_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🔒 機密檔案'**
  String get chat_secret_file_title;

  /// No description provided for @chat_secret_file_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'該角色的靈魂檔案已被封存或轉為私人權限，暫時無法查看詳細資料。'**
  String get chat_secret_file_desc;

  /// No description provided for @chat_understood.
  ///
  /// In zh_Hant, this message translates to:
  /// **'了解'**
  String get chat_understood;

  /// No description provided for @chat_egg_unlocked.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✨ 獲得新回憶：{title}'**
  String chat_egg_unlocked(String title);

  /// No description provided for @chat_egg_saved.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已自動收錄至專屬背包'**
  String get chat_egg_saved;

  /// No description provided for @chat_points_not_enough_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'花花不足'**
  String get chat_points_not_enough_title;

  /// No description provided for @chat_points_not_enough_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'你的花朵不夠了!請先前往商店補充。'**
  String get chat_points_not_enough_desc;

  /// No description provided for @chat_call_confirm_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'要打給 {name} 嗎？'**
  String chat_call_confirm_title(String name);

  /// No description provided for @chat_call_rule_1.
  ///
  /// In zh_Hant, this message translates to:
  /// **'每次通話都會扣除 20 點花花'**
  String get chat_call_rule_1;

  /// No description provided for @chat_call_rule_2.
  ///
  /// In zh_Hant, this message translates to:
  /// **'通話時間為一分鐘，若不方便說話可以透過文字傳達'**
  String get chat_call_rule_2;

  /// No description provided for @chat_call_rule_3.
  ///
  /// In zh_Hant, this message translates to:
  /// **'建議配戴耳機，更能聽清楚他的聲音 ✨'**
  String get chat_call_rule_3;

  /// No description provided for @chat_call_btn_cancel.
  ///
  /// In zh_Hant, this message translates to:
  /// **'先不要'**
  String get chat_call_btn_cancel;

  /// No description provided for @chat_call_pref_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'設定您的通話偏好'**
  String get chat_call_pref_title;

  /// No description provided for @chat_call_lang_select.
  ///
  /// In zh_Hant, this message translates to:
  /// **'選擇通話語言'**
  String get chat_call_lang_select;

  /// No description provided for @chat_call_save_memory.
  ///
  /// In zh_Hant, this message translates to:
  /// **'保存本次通話回憶'**
  String get chat_call_save_memory;

  /// No description provided for @chat_call_save_memory_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'通話結束後可重複回聽'**
  String get chat_call_save_memory_desc;

  /// No description provided for @chat_call_btn_start.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開始通話'**
  String get chat_call_btn_start;

  /// No description provided for @chat_points_shortage.
  ///
  /// In zh_Hant, this message translates to:
  /// **'花花點數不夠喔！目前有 {points} 點'**
  String chat_points_shortage(String points);

  /// No description provided for @chat_room_not_ready.
  ///
  /// In zh_Hant, this message translates to:
  /// **'聊天室尚未準備好，請重新進入。'**
  String get chat_room_not_ready;

  /// No description provided for @chat_stop_generating_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已停止回覆，點數並沒有扣除 🍃'**
  String get chat_stop_generating_msg;

  /// No description provided for @chat_heartbeat_up.
  ///
  /// In zh_Hant, this message translates to:
  /// **'他心跳加速了...'**
  String get chat_heartbeat_up;

  /// No description provided for @chat_heartbeat_down.
  ///
  /// In zh_Hant, this message translates to:
  /// **'他眼神變冷了...'**
  String get chat_heartbeat_down;

  /// No description provided for @chat_msg_copy.
  ///
  /// In zh_Hant, this message translates to:
  /// **'複製內容'**
  String get chat_msg_copy;

  /// No description provided for @chat_msg_copied.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已複製到剪貼簿！'**
  String get chat_msg_copied;

  /// No description provided for @chat_msg_report.
  ///
  /// In zh_Hant, this message translates to:
  /// **'舉報該對話框'**
  String get chat_msg_report;

  /// No description provided for @chat_msg_suggest.
  ///
  /// In zh_Hant, this message translates to:
  /// **'給建議'**
  String get chat_msg_suggest;

  /// No description provided for @chat_report_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'舉報此對話'**
  String get chat_report_title;

  /// No description provided for @chat_report_lang.
  ///
  /// In zh_Hant, this message translates to:
  /// **'出現外文'**
  String get chat_report_lang;

  /// No description provided for @chat_report_inapp.
  ///
  /// In zh_Hant, this message translates to:
  /// **'回覆不恰當'**
  String get chat_report_inapp;

  /// No description provided for @chat_report_context.
  ///
  /// In zh_Hant, this message translates to:
  /// **'上下文沒有連接'**
  String get chat_report_context;

  /// No description provided for @chat_report_other.
  ///
  /// In zh_Hant, this message translates to:
  /// **'其他原因'**
  String get chat_report_other;

  /// No description provided for @chat_report_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請描述您遇到的問題...'**
  String get chat_report_hint;

  /// No description provided for @chat_report_submit.
  ///
  /// In zh_Hant, this message translates to:
  /// **'送出'**
  String get chat_report_submit;

  /// No description provided for @chat_report_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✅ 舉報已送出，我們會盡快調整'**
  String get chat_report_success;

  /// No description provided for @chat_suggest_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'給予建議'**
  String get chat_suggest_title;

  /// No description provided for @chat_suggest_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請寫下您的寶貴意見...'**
  String get chat_suggest_hint;

  /// No description provided for @chat_suggest_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'💖 感謝您的建議，我們會盡快處理'**
  String get chat_suggest_success;

  /// No description provided for @chat_del_warn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'訊息刪除後將無法復原。'**
  String get chat_del_warn;

  /// No description provided for @chat_reset_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'重置記憶'**
  String get chat_reset_title;

  /// No description provided for @chat_reset_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請選擇重置的程度：\n\n1. 【僅對話】：清除對話紀錄，但保留好感度。\n2. 【完全重置】：一切歸零，像初次見面一樣。'**
  String get chat_reset_desc;

  /// No description provided for @chat_reset_only_chat.
  ///
  /// In zh_Hant, this message translates to:
  /// **'僅對話紀錄'**
  String get chat_reset_only_chat;

  /// No description provided for @chat_reset_full.
  ///
  /// In zh_Hant, this message translates to:
  /// **'完全重置'**
  String get chat_reset_full;

  /// No description provided for @chat_reset_full_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'一切已回歸最初，他不再記得妳了...'**
  String get chat_reset_full_msg;

  /// No description provided for @chat_reset_chat_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'對話已清空，但他對妳的愛意依然存在。'**
  String get chat_reset_chat_msg;

  /// No description provided for @chat_edit_ai_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯他的回覆...'**
  String get chat_edit_ai_hint;

  /// No description provided for @chat_edit_user_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請輸入新的內容...'**
  String get chat_edit_user_hint;

  /// No description provided for @chat_no_voice_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'目前還沒有 {name} 的聲音...'**
  String chat_no_voice_msg(String name);

  /// No description provided for @chat_poke_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'戳一下'**
  String get chat_poke_btn;

  /// No description provided for @chat_poke_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✨ 已幫妳戳戳創作者囉！請期待他的聲音上線～'**
  String get chat_poke_success;

  /// No description provided for @chat_gift_points_needed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'花花點數不夠喔！需要 {cost} 點 🌸'**
  String chat_gift_points_needed(String cost);

  /// No description provided for @chat_levelup_soulmate.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✨ 命定之人 ✨'**
  String get chat_levelup_soulmate;

  /// No description provided for @chat_levelup_normal.
  ///
  /// In zh_Hant, this message translates to:
  /// **'關係晉升！💖'**
  String get chat_levelup_normal;

  /// No description provided for @chat_levelup_btn_soulmate.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刻入靈魂'**
  String get chat_levelup_btn_soulmate;

  /// No description provided for @chat_levelup_btn_normal.
  ///
  /// In zh_Hant, this message translates to:
  /// **'心動收下'**
  String get chat_levelup_btn_normal;

  /// No description provided for @chat_loc_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'📍 傳送虛擬定位'**
  String get chat_loc_title;

  /// No description provided for @chat_loc_custom_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'發送自訂定位'**
  String get chat_loc_custom_btn;

  /// No description provided for @chat_loc_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輸入其他地點... (例如：在你心裡)'**
  String get chat_loc_hint;

  /// No description provided for @chat_loc_1.
  ///
  /// In zh_Hant, this message translates to:
  /// **'在你家樓下'**
  String get chat_loc_1;

  /// No description provided for @chat_loc_2.
  ///
  /// In zh_Hant, this message translates to:
  /// **'在學校'**
  String get chat_loc_2;

  /// No description provided for @chat_loc_3.
  ///
  /// In zh_Hant, this message translates to:
  /// **'在剛才路過的咖啡廳'**
  String get chat_loc_3;

  /// No description provided for @chat_loc_4.
  ///
  /// In zh_Hant, this message translates to:
  /// **'在便利商店'**
  String get chat_loc_4;

  /// No description provided for @chat_interact_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✨ 想對他做什麼呢？'**
  String get chat_interact_title;

  /// No description provided for @chat_interact_action.
  ///
  /// In zh_Hant, this message translates to:
  /// **'戳一戳與小動作'**
  String get chat_interact_action;

  /// No description provided for @chat_interact_gift.
  ///
  /// In zh_Hant, this message translates to:
  /// **'送他小禮物 (消耗花花 🌸)'**
  String get chat_interact_gift;

  /// No description provided for @chat_action_poke.
  ///
  /// In zh_Hant, this message translates to:
  /// **'戳戳臉頰'**
  String get chat_action_poke;

  /// No description provided for @chat_action_hug.
  ///
  /// In zh_Hant, this message translates to:
  /// **'討抱抱'**
  String get chat_action_hug;

  /// No description provided for @chat_action_hand.
  ///
  /// In zh_Hant, this message translates to:
  /// **'偷偷牽手'**
  String get chat_action_hand;

  /// No description provided for @chat_dice_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'擲骰子'**
  String get chat_dice_btn;

  /// No description provided for @chat_loading_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'讀取回憶失敗，請返回重試。'**
  String get chat_loading_failed;

  /// No description provided for @chat_test_mode_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'測試模式已開啟，隨便聊聊吧！(對話不會存檔喔)'**
  String get chat_test_mode_msg;

  /// No description provided for @chat_empty_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'與他開始一段心動的旅程吧!'**
  String get chat_empty_msg;

  /// No description provided for @chat_ai_typing.
  ///
  /// In zh_Hant, this message translates to:
  /// **'對方正在回覆...'**
  String get chat_ai_typing;

  /// No description provided for @chat_input_hint_default.
  ///
  /// In zh_Hant, this message translates to:
  /// **'想對他說什麼...'**
  String get chat_input_hint_default;

  /// No description provided for @chat_typing_indicator.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在輸入中...'**
  String get chat_typing_indicator;

  /// No description provided for @chat_menu_search.
  ///
  /// In zh_Hant, this message translates to:
  /// **'搜尋對話'**
  String get chat_menu_search;

  /// No description provided for @chat_menu_gallery.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬回憶與背景'**
  String get chat_menu_gallery;

  /// No description provided for @chat_menu_aboutme.
  ///
  /// In zh_Hant, this message translates to:
  /// **'與我相關'**
  String get chat_menu_aboutme;

  /// No description provided for @chat_menu_memo.
  ///
  /// In zh_Hant, this message translates to:
  /// **'給他的備忘錄'**
  String get chat_menu_memo;

  /// No description provided for @chat_menu_period.
  ///
  /// In zh_Hant, this message translates to:
  /// **'生理期追蹤'**
  String get chat_menu_period;

  /// No description provided for @chat_menu_reset.
  ///
  /// In zh_Hant, this message translates to:
  /// **'重置記憶'**
  String get chat_menu_reset;

  /// No description provided for @chat_search_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'想回味哪一段甜蜜對話呢？'**
  String get chat_search_hint;

  /// No description provided for @chat_search_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'找不到這段回憶喔 🥺'**
  String get chat_search_empty;

  /// No description provided for @chat_search_you.
  ///
  /// In zh_Hant, this message translates to:
  /// **'妳說的'**
  String get chat_search_you;

  /// No description provided for @chat_search_him.
  ///
  /// In zh_Hant, this message translates to:
  /// **'他說的'**
  String get chat_search_him;

  /// No description provided for @chat_tool_backpack.
  ///
  /// In zh_Hant, this message translates to:
  /// **'背包'**
  String get chat_tool_backpack;

  /// No description provided for @chat_tool_story.
  ///
  /// In zh_Hant, this message translates to:
  /// **'劇情摘要'**
  String get chat_tool_story;

  /// No description provided for @chat_tool_photo.
  ///
  /// In zh_Hant, this message translates to:
  /// **'照片'**
  String get chat_tool_photo;

  /// No description provided for @chat_tool_record.
  ///
  /// In zh_Hant, this message translates to:
  /// **'錄音'**
  String get chat_tool_record;

  /// No description provided for @chat_tool_profile.
  ///
  /// In zh_Hant, this message translates to:
  /// **'拾光檔案'**
  String get chat_tool_profile;

  /// No description provided for @chat_tool_interact.
  ///
  /// In zh_Hant, this message translates to:
  /// **'互動玩法'**
  String get chat_tool_interact;

  /// No description provided for @chat_record_recording.
  ///
  /// In zh_Hant, this message translates to:
  /// **'錄音中...'**
  String get chat_record_recording;

  /// No description provided for @chat_record_start.
  ///
  /// In zh_Hant, this message translates to:
  /// **'點擊麥克風開始錄音'**
  String get chat_record_start;

  /// No description provided for @chat_record_done.
  ///
  /// In zh_Hant, this message translates to:
  /// **'錄音完成'**
  String get chat_record_done;

  /// No description provided for @chat_mode_daily_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'輕鬆愉快的日常閒聊，就像朋友一樣!。'**
  String get chat_mode_daily_desc;

  /// No description provided for @chat_mode_story_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'小說般的劇情推進。'**
  String get chat_mode_story_desc;

  /// No description provided for @chat_mode_immersive_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'極致的感官體驗，無拘無束的深層互動。'**
  String get chat_mode_immersive_desc;

  /// No description provided for @chat_switch_mode_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'切換聊天模式'**
  String get chat_switch_mode_title;

  /// No description provided for @chat_voice_call.
  ///
  /// In zh_Hant, this message translates to:
  /// **'語音通話'**
  String get chat_voice_call;

  /// No description provided for @chat_sys_gift.
  ///
  /// In zh_Hant, this message translates to:
  /// **'【系統事件】{playerName}送出了一個【{giftName}】。'**
  String chat_sys_gift(String playerName, String giftName);

  /// No description provided for @rel_title_soulmate.
  ///
  /// In zh_Hant, this message translates to:
  /// **'靈魂伴侶/深愛'**
  String get rel_title_soulmate;

  /// No description provided for @rel_title_lover.
  ///
  /// In zh_Hant, this message translates to:
  /// **'熱戀期/專屬男友'**
  String get rel_title_lover;

  /// No description provided for @rel_title_ambiguous.
  ///
  /// In zh_Hant, this message translates to:
  /// **'曖昧期/互相試探'**
  String get rel_title_ambiguous;

  /// No description provided for @rel_title_friend.
  ///
  /// In zh_Hant, this message translates to:
  /// **'普通朋友/好感萌芽'**
  String get rel_title_friend;

  /// No description provided for @rel_title_acquaintance.
  ///
  /// In zh_Hant, this message translates to:
  /// **'點頭之交/稍微眼熟'**
  String get rel_title_acquaintance;

  /// No description provided for @rel_title_stranger.
  ///
  /// In zh_Hant, this message translates to:
  /// **'陌生/初識'**
  String get rel_title_stranger;

  /// No description provided for @rel_title_tense.
  ///
  /// In zh_Hant, this message translates to:
  /// **'關係緊張/心生厭煩'**
  String get rel_title_tense;

  /// No description provided for @rel_title_avoiding.
  ///
  /// In zh_Hant, this message translates to:
  /// **'形同陌路/刻意躲避'**
  String get rel_title_avoiding;

  /// No description provided for @rel_title_hostile.
  ///
  /// In zh_Hant, this message translates to:
  /// **'極度厭惡/冰冷敵意'**
  String get rel_title_hostile;

  /// No description provided for @rel_title_nemesis.
  ///
  /// In zh_Hant, this message translates to:
  /// **'不共戴天/永不相見'**
  String get rel_title_nemesis;

  /// No description provided for @rel_msg_soulmate.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「沒想到...妳對我來說，已經變得這麼重要了。重要到...我無法想像沒有妳的世界。」'**
  String get rel_msg_soulmate;

  /// No description provided for @rel_msg_lover.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「這輩子最幸運的事，大概就是在那天，回頭看見了妳。」'**
  String get rel_msg_lover;

  /// No description provided for @rel_msg_ambiguous.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「最近...我發現自己發呆的時間變多了，而且腦袋裡全都是妳。」'**
  String get rel_msg_ambiguous;

  /// No description provided for @rel_msg_friend.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「既然是妳的邀約，那我稍微空出點時間，也不是不行。」'**
  String get rel_msg_friend;

  /// No description provided for @rel_msg_acquaintance.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「最近常看到妳，感覺...並不討厭這種見面的頻率。」'**
  String get rel_msg_acquaintance;

  /// No description provided for @rel_msg_stranger.
  ///
  /// In zh_Hant, this message translates to:
  /// **'「原來妳也在這裡，這算是一種奇妙的緣分嗎？」'**
  String get rel_msg_stranger;

  /// No description provided for @chat_edit_char_count.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{count} 字'**
  String chat_edit_char_count(String count);

  /// No description provided for @chat_mysterious_player.
  ///
  /// In zh_Hant, this message translates to:
  /// **'神秘玩家'**
  String get chat_mysterious_player;

  /// No description provided for @chat_poke_message.
  ///
  /// In zh_Hant, this message translates to:
  /// **'玩家 {playerName} 期待著聽見 {characterName} 的聲音，快去生成吧！'**
  String chat_poke_message(String playerName, String characterName);

  /// No description provided for @gift_heart.
  ///
  /// In zh_Hant, this message translates to:
  /// **'愛心'**
  String get gift_heart;

  /// No description provided for @gift_flower.
  ///
  /// In zh_Hant, this message translates to:
  /// **'花花'**
  String get gift_flower;

  /// No description provided for @gift_sun.
  ///
  /// In zh_Hant, this message translates to:
  /// **'太陽'**
  String get gift_sun;

  /// No description provided for @gift_confetti.
  ///
  /// In zh_Hant, this message translates to:
  /// **'拉炮'**
  String get gift_confetti;

  /// No description provided for @gift_coffee.
  ///
  /// In zh_Hant, this message translates to:
  /// **'咖啡'**
  String get gift_coffee;

  /// No description provided for @gift_cake.
  ///
  /// In zh_Hant, this message translates to:
  /// **'蛋糕'**
  String get gift_cake;

  /// No description provided for @chat_action_poke_prompt.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（玩家突然伸出手，調皮地戳了戳你的臉頰）'**
  String get chat_action_poke_prompt;

  /// No description provided for @chat_action_hug_prompt.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（玩家委屈巴巴地張開雙手，想要一個溫暖的抱抱）'**
  String get chat_action_hug_prompt;

  /// No description provided for @chat_action_hand_prompt.
  ///
  /// In zh_Hant, this message translates to:
  /// **'（玩家在桌子底下，悄悄握住了你的手）'**
  String get chat_action_hand_prompt;

  /// No description provided for @chat_menu_send_location.
  ///
  /// In zh_Hant, this message translates to:
  /// **'發送虛擬定位'**
  String get chat_menu_send_location;

  /// No description provided for @weekday_mon.
  ///
  /// In zh_Hant, this message translates to:
  /// **'(一)'**
  String get weekday_mon;

  /// No description provided for @weekday_tue.
  ///
  /// In zh_Hant, this message translates to:
  /// **'(二)'**
  String get weekday_tue;

  /// No description provided for @weekday_wed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'(三)'**
  String get weekday_wed;

  /// No description provided for @weekday_thu.
  ///
  /// In zh_Hant, this message translates to:
  /// **'(四)'**
  String get weekday_thu;

  /// No description provided for @weekday_fri.
  ///
  /// In zh_Hant, this message translates to:
  /// **'(五)'**
  String get weekday_fri;

  /// No description provided for @weekday_sat.
  ///
  /// In zh_Hant, this message translates to:
  /// **'(六)'**
  String get weekday_sat;

  /// No description provided for @weekday_sun.
  ///
  /// In zh_Hant, this message translates to:
  /// **'(日)'**
  String get weekday_sun;

  /// No description provided for @chat_egg_unlocked_dynamic.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✨ 獲得新回憶：{memoryName}'**
  String chat_egg_unlocked_dynamic(String memoryName);

  /// No description provided for @chat_egg_saved_his_backpack.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已自動收錄至他的專屬背包'**
  String get chat_egg_saved_his_backpack;

  /// No description provided for @chat_profile_updated_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'拾光檔案已更新！他會記住妳的最新設定喔 🍃'**
  String get chat_profile_updated_msg;

  /// No description provided for @comment_loading_author.
  ///
  /// In zh_Hant, this message translates to:
  /// **'讀取中...'**
  String get comment_loading_author;

  /// No description provided for @comment_post_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'留言失敗，請檢查網路連線：{error}'**
  String comment_post_failed(String error);

  /// No description provided for @comment_delete_confirm_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'您確定要永久刪除這則留言嗎？'**
  String get comment_delete_confirm_desc;

  /// No description provided for @comment_delete_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除失敗，請檢查網路連線'**
  String get comment_delete_failed;

  /// No description provided for @comment_identity_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'選擇留言身分'**
  String get comment_identity_title;

  /// No description provided for @comment_identity_myself.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我本人'**
  String get comment_identity_myself;

  /// No description provided for @comment_report_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確認檢舉'**
  String get comment_report_title;

  /// No description provided for @comment_report_rules_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'⚖️ 留言檢舉規範'**
  String get comment_report_rules_title;

  /// No description provided for @comment_report_rules_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'1️⃣ 初犯：系統警告並記錄一次違規。\n2️⃣ 二犯：禁止留言 1 天。\n3️⃣ 累犯：禁用檢舉功能 14 天，並降低留言能見度。\n\n🚨 嚴重惡意者：\n禁止與角色互動 1 天，ID 將公告於公佈欄 3 天（期間禁止更改 ID）。\n\n💡 檢舉送出後，最終審核結果將透過【遊戲內信箱】單獨發送給您。\n請互相尊重，理性檢舉。'**
  String get comment_report_rules_desc;

  /// No description provided for @comment_report_understood.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我已了解'**
  String get comment_report_understood;

  /// No description provided for @comment_report_confirm_desc.
  ///
  /// In zh_Hant, this message translates to:
  /// **'您確定要檢舉這則留言嗎？\n惡意檢舉可能會受到懲罰。'**
  String get comment_report_confirm_desc;

  /// No description provided for @comment_report_submit_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定檢舉'**
  String get comment_report_submit_btn;

  /// No description provided for @comment_report_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'感謝您的檢舉，我們會盡快核實！'**
  String get comment_report_success;

  /// No description provided for @comment_report_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'檢舉送出失敗，請稍後再試。'**
  String get comment_report_failed;

  /// No description provided for @comment_option_delete.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除留言'**
  String get comment_option_delete;

  /// No description provided for @comment_option_report.
  ///
  /// In zh_Hant, this message translates to:
  /// **'檢舉留言'**
  String get comment_option_report;

  /// No description provided for @comment_time_days_ago.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{days}天前'**
  String comment_time_days_ago(String days);

  /// No description provided for @comment_time_hours_ago.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{hours}小時前'**
  String comment_time_hours_ago(String hours);

  /// No description provided for @comment_time_mins_ago.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{mins}分鐘前'**
  String comment_time_mins_ago(String mins);

  /// No description provided for @comment_time_just_now.
  ///
  /// In zh_Hant, this message translates to:
  /// **'剛剛'**
  String get comment_time_just_now;

  /// No description provided for @comment_sheet_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'留言'**
  String get comment_sheet_title;

  /// No description provided for @comment_empty_state.
  ///
  /// In zh_Hant, this message translates to:
  /// **'還沒有人留言，快來搶頭香！'**
  String get comment_empty_state;

  /// No description provided for @comment_reply_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'回覆'**
  String get comment_reply_btn;

  /// No description provided for @comment_replying_to.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在回覆 @{name}'**
  String comment_replying_to(String name);

  /// No description provided for @comment_input_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'以 {name} 的身分留言...'**
  String comment_input_hint(String name);

  /// No description provided for @char_story_expect.
  ///
  /// In zh_Hant, this message translates to:
  /// **'期待與{pronoun}的故事...'**
  String char_story_expect(String pronoun);

  /// No description provided for @common_update_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更新失敗，請檢查網路'**
  String get common_update_failed;

  /// No description provided for @char_edit_fragment.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯碎片'**
  String get char_edit_fragment;

  /// No description provided for @char_dislikes.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🖤 討厭：{dislikes}'**
  String char_dislikes(String dislikes);

  /// No description provided for @char_likes.
  ///
  /// In zh_Hant, this message translates to:
  /// **'🤍 喜歡：{likes}'**
  String char_likes(String likes);

  /// No description provided for @char_age_occupation.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{age}歲 | {job}'**
  String char_age_occupation(String age, String job);

  /// No description provided for @common_got_it.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我知道了'**
  String get common_got_it;

  /// No description provided for @common_add_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新增失敗，請檢查網路'**
  String get common_add_failed;

  /// No description provided for @common_delete_failed_with_err.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除失敗，請檢查網路狀態：{error}'**
  String common_delete_failed_with_err(String error);

  /// No description provided for @char_exclusive_guardian.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬守護 💖'**
  String get char_exclusive_guardian;

  /// No description provided for @mailbox_like_body.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{playerName} 喜歡了 {charName}！'**
  String mailbox_like_body(String playerName, String charName);

  /// No description provided for @chat_translation_prefix.
  ///
  /// In zh_Hant, this message translates to:
  /// **'【譯】{content} (這是翻譯後的感性內容)'**
  String chat_translation_prefix(String content);

  /// No description provided for @player_default_nickname.
  ///
  /// In zh_Hant, this message translates to:
  /// **'旅人'**
  String get player_default_nickname;

  /// No description provided for @moment_create_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'發布新動態'**
  String get moment_create_title;

  /// No description provided for @moment_create_post_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'發布'**
  String get moment_create_post_btn;

  /// No description provided for @moment_create_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'分享新鮮事...'**
  String get moment_create_hint;

  /// No description provided for @moment_create_error_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'文字和圖片至少需要一項喔！'**
  String get moment_create_error_empty;

  /// No description provided for @moment_create_error_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'發布失敗，請稍後再試'**
  String get moment_create_error_failed;

  /// No description provided for @moment_create_visibility_public.
  ///
  /// In zh_Hant, this message translates to:
  /// **'公開 (所有人可見)'**
  String get moment_create_visibility_public;

  /// No description provided for @moment_create_visibility_private.
  ///
  /// In zh_Hant, this message translates to:
  /// **'私密 (僅好友可見)'**
  String get moment_create_visibility_private;

  /// No description provided for @chat_player_sent_location.
  ///
  /// In zh_Hant, this message translates to:
  /// **'📍 (玩家發送了定位：{location})'**
  String chat_player_sent_location(String location);

  /// No description provided for @chat_you.
  ///
  /// In zh_Hant, this message translates to:
  /// **'妳'**
  String get chat_you;

  /// No description provided for @chat_opponent.
  ///
  /// In zh_Hant, this message translates to:
  /// **'對手'**
  String get chat_opponent;

  /// No description provided for @chat_dice_duel_result.
  ///
  /// In zh_Hant, this message translates to:
  /// **'【系統事件】與{name}擲骰子對決！結果出來了...'**
  String chat_dice_duel_result(String name);

  /// No description provided for @chat_loading_status.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在讀取中...'**
  String get chat_loading_status;

  /// No description provided for @chat_error_load_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'讀取訊息失敗: {error}'**
  String chat_error_load_msg(String error);

  /// No description provided for @chat_voice_msg_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'語音訊息'**
  String get chat_voice_msg_label;

  /// No description provided for @chat_special_story_trigger.
  ///
  /// In zh_Hant, this message translates to:
  /// **'【開啟特殊劇情：{title}】'**
  String chat_special_story_trigger(String title);

  /// No description provided for @common_edit_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯失敗: {error}'**
  String common_edit_failed(String error);

  /// No description provided for @common_reset_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'重置失敗: {error}'**
  String common_reset_failed(String error);

  /// No description provided for @chat_default_greeting.
  ///
  /// In zh_Hant, this message translates to:
  /// **'你好...'**
  String get chat_default_greeting;

  /// No description provided for @chat_memory_cleared.
  ///
  /// In zh_Hant, this message translates to:
  /// **'記憶已徹底清空'**
  String get chat_memory_cleared;

  /// No description provided for @chat_history_reset.
  ///
  /// In zh_Hant, this message translates to:
  /// **'對話已重置'**
  String get chat_history_reset;

  /// No description provided for @chat_profile_full.
  ///
  /// In zh_Hant, this message translates to:
  /// **'📜 【 專屬拾光檔案 - {name} 】\n━━━━━━━━━━━━━━━━━━\n🔹 姓名：{identity}\n🔹 生日：{birthday}\n🔹 身高：{height}\n🔹 外貌：{appearance}\n🔹 職業：{job}\n\n📖 【 關於她的靈魂碎片 】\n{intro}\n━━━━━━━━━━━━━━━━━━'**
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro);

  /// No description provided for @chat_profile_locked.
  ///
  /// In zh_Hant, this message translates to:
  /// **'📜 【 專屬拾光檔案 】\n━━━━━━━━━━━━━━━━━━\n🔹 姓名：{nickname}\n🔹 生日：{birthday}\n\n🔒 其他人設資料尚未解鎖...\n(填寫完整檔案，讓他在平行時空更了解妳吧！✨)\n━━━━━━━━━━━━━━━━━━'**
  String chat_profile_locked(String nickname, String birthday);

  /// No description provided for @profile_unnamed_file.
  ///
  /// In zh_Hant, this message translates to:
  /// **'未命名檔案'**
  String get profile_unnamed_file;

  /// No description provided for @chat_default_player_name.
  ///
  /// In zh_Hant, this message translates to:
  /// **'玩家'**
  String get chat_default_player_name;

  /// No description provided for @error_system_confusion.
  ///
  /// In zh_Hant, this message translates to:
  /// **'系統出現小混亂，請再試一次。'**
  String get error_system_confusion;

  /// No description provided for @error_msg_send_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'訊息傳送失敗，請再試一次。'**
  String get error_msg_send_failed;

  /// No description provided for @error_system_busy.
  ///
  /// In zh_Hant, this message translates to:
  /// **'系統繁忙，請稍後再試。'**
  String get error_system_busy;

  /// No description provided for @error_network_unavailable.
  ///
  /// In zh_Hant, this message translates to:
  /// **'目前暫時無法連線，請重試。'**
  String get error_network_unavailable;

  /// No description provided for @chat_call_ended.
  ///
  /// In zh_Hant, this message translates to:
  /// **'📞 通話結束，與 {name} 通話了 {time}'**
  String chat_call_ended(String name, String time);

  /// No description provided for @chat_exclusive_story.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬劇情：{title}'**
  String chat_exclusive_story(String title);

  /// No description provided for @chat_teaser_exclusive.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這是一段專屬於妳和 {name} 的隱藏回憶...'**
  String chat_teaser_exclusive(String name);

  /// No description provided for @chat_teaser_keyword.
  ///
  /// In zh_Hant, this message translates to:
  /// **'一段關於「{keyword}」的專屬回憶已悄悄解鎖...'**
  String chat_teaser_keyword(String keyword);

  /// No description provided for @chat_hidden_event_trigger.
  ///
  /// In zh_Hant, this message translates to:
  /// **'【隱藏事件觸發：{title}】\n{scene}'**
  String chat_hidden_event_trigger(String title, String scene);

  /// No description provided for @chat_first_line_fallback.
  ///
  /// In zh_Hant, this message translates to:
  /// **'……（他靜靜地看著妳，似乎在等妳先開口）'**
  String get chat_first_line_fallback;

  /// No description provided for @chat_new_room_created.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新的聊天室已建立'**
  String get chat_new_room_created;

  /// No description provided for @portfolio_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{nickname}的作品集'**
  String portfolio_title(String nickname);

  /// No description provided for @enter_secret_studio.
  ///
  /// In zh_Hant, this message translates to:
  /// **'進入我的秘密工作室'**
  String get enter_secret_studio;

  /// No description provided for @no_public_character_mine.
  ///
  /// In zh_Hant, this message translates to:
  /// **'妳還沒有發布任何公開角色喔！\n快去工作室創作吧✨'**
  String get no_public_character_mine;

  /// No description provided for @no_public_character_other.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這位創作者還沒有發布角色喔...'**
  String get no_public_character_other;

  /// No description provided for @delete_draft_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除草稿'**
  String get delete_draft_title;

  /// No description provided for @confirm_delete_draft_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定要刪除這個未完成的角色嗎？\n(刪除後無法復原喔)'**
  String get confirm_delete_draft_msg;

  /// No description provided for @draft_cleared_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'草稿已清理完畢 🧹'**
  String get draft_cleared_success;

  /// No description provided for @login_required_for_studio.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請先登入才能進入工作室喔！'**
  String get login_required_for_studio;

  /// No description provided for @my_secret_studio_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我的秘密工作室 🛠️'**
  String get my_secret_studio_title;

  /// No description provided for @create_new_character_btn.
  ///
  /// In zh_Hant, this message translates to:
  /// **'創造新角色'**
  String get create_new_character_btn;

  /// No description provided for @unnamed_draft.
  ///
  /// In zh_Hant, this message translates to:
  /// **'未命名草稿'**
  String get unnamed_draft;

  /// No description provided for @click_to_edit_story.
  ///
  /// In zh_Hant, this message translates to:
  /// **'點擊繼續編輯他的故事...'**
  String get click_to_edit_story;

  /// No description provided for @label_draft.
  ///
  /// In zh_Hant, this message translates to:
  /// **'草稿'**
  String get label_draft;

  /// No description provided for @studio_empty_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'工作室目前空空如也'**
  String get studio_empty_title;

  /// No description provided for @studio_empty_subtitle.
  ///
  /// In zh_Hant, this message translates to:
  /// **'點擊右下角，開始創造妳的第一個角色吧！'**
  String get studio_empty_subtitle;

  /// No description provided for @common_no_changes.
  ///
  /// In zh_Hant, this message translates to:
  /// **'沒有任何變更'**
  String get common_no_changes;

  /// No description provided for @moment_updated_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'動態已更新！'**
  String get moment_updated_success;

  /// No description provided for @common_save_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存失敗: {error}'**
  String common_save_failed(String error);

  /// No description provided for @moment_edit_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯動態'**
  String get moment_edit_title;

  /// No description provided for @action_change_image.
  ///
  /// In zh_Hant, this message translates to:
  /// **'更換圖片'**
  String get action_change_image;

  /// No description provided for @action_remove_image.
  ///
  /// In zh_Hant, this message translates to:
  /// **'移除圖片'**
  String get action_remove_image;

  /// No description provided for @moment_delete_confirm_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定要刪除這則動態嗎？'**
  String get moment_delete_confirm_title;

  /// No description provided for @moment_delete_confirm_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除後，這段朋友圈的回憶就會消失喔！'**
  String get moment_delete_confirm_content;

  /// No description provided for @action_confirm_delete.
  ///
  /// In zh_Hant, this message translates to:
  /// **'確定刪除'**
  String get action_confirm_delete;

  /// No description provided for @friend_unknown.
  ///
  /// In zh_Hant, this message translates to:
  /// **'某位朋友'**
  String get friend_unknown;

  /// No description provided for @moment_like_yours.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{nickname}覺得妳的動態很讚喔！💖'**
  String moment_like_yours(String nickname);

  /// No description provided for @moment_like_others.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{nickname}覺得{authorName}很有魅力，點了個讚！✨'**
  String moment_like_others(String nickname, String authorName);

  /// No description provided for @moment_like_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已傳遞妳的心動！✨'**
  String get moment_like_success;

  /// No description provided for @moment_notification_new_like.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新點讚！💖'**
  String get moment_notification_new_like;

  /// No description provided for @moment_mention_mail_body.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{nickname} 在動態中提到了 @{name} 喔！✨'**
  String moment_mention_mail_body(String nickname, String name);

  /// No description provided for @moment_detail_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'動態詳情'**
  String get moment_detail_title;

  /// No description provided for @moment_not_found.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這篇動態好像不見了... 😢'**
  String get moment_not_found;

  /// No description provided for @moment_comment_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'朋友圈留言'**
  String get moment_comment_title;

  /// No description provided for @moment_comment_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'還沒有人留言，快來搶沙發！🛋'**
  String get moment_comment_empty;

  /// No description provided for @moment_replying_to.
  ///
  /// In zh_Hant, this message translates to:
  /// **'正在回覆 @{name}'**
  String moment_replying_to(String name);

  /// No description provided for @moment_reply_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'回覆 @{name}...'**
  String moment_reply_hint(String name);

  /// No description provided for @moment_leave_comment_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'留下妳的回應...'**
  String get moment_leave_comment_hint;

  /// No description provided for @moment_delete_permanent_confirm.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這則動態將被永久刪除，確定嗎？'**
  String get moment_delete_permanent_confirm;

  /// No description provided for @moment_action_delete.
  ///
  /// In zh_Hant, this message translates to:
  /// **'刪除動態'**
  String get moment_action_delete;

  /// No description provided for @moment_action_report.
  ///
  /// In zh_Hant, this message translates to:
  /// **'檢舉此動態'**
  String get moment_action_report;

  /// No description provided for @moment_action_share.
  ///
  /// In zh_Hant, this message translates to:
  /// **'分享這則動態'**
  String get moment_action_share;

  /// No description provided for @moment_forward_hint.
  ///
  /// In zh_Hant, this message translates to:
  /// **'轉發這篇動態給角色...'**
  String get moment_forward_hint;

  /// No description provided for @moment_reply_private.
  ///
  /// In zh_Hant, this message translates to:
  /// **'私訊回覆 {name}'**
  String moment_reply_private(String name);

  /// No description provided for @moment_go_to_chat_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'帶著動態去找 {name} 聊天囉！ 💬'**
  String moment_go_to_chat_msg(String name);

  /// No description provided for @moment_share_to_apps.
  ///
  /// In zh_Hant, this message translates to:
  /// **'分享到其他應用程式'**
  String get moment_share_to_apps;

  /// No description provided for @moment_likes_label.
  ///
  /// In zh_Hant, this message translates to:
  /// **'{count} 片葉子'**
  String moment_likes_label(String count);

  /// No description provided for @moment_external_share_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'【{appName}】快來看 {author} 的動態：{content}\n\n立即下載，開啟妳的專屬時光：{appLink}'**
  String moment_external_share_content(
      String appName, String author, String content, String appLink);

  /// No description provided for @moment_forward_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'轉發給正在聊天的角色 💌'**
  String get moment_forward_title;

  /// No description provided for @moment_forward_empty_state.
  ///
  /// In zh_Hant, this message translates to:
  /// **'妳目前還沒有開始聊天的角色喔！\n先去大廳找找心儀的他吧 🌿'**
  String get moment_forward_empty_state;

  /// No description provided for @moment_forward_template.
  ///
  /// In zh_Hant, this message translates to:
  /// **'【轉發了一則動態】\n作者：{author}\n內容：{content}'**
  String moment_forward_template(String author, String content);

  /// No description provided for @moment_forward_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'✅ 已悄悄分享給 {name} 囉！'**
  String moment_forward_success(String name);

  /// No description provided for @action_send.
  ///
  /// In zh_Hant, this message translates to:
  /// **'發送'**
  String get action_send;

  /// No description provided for @memo_delete_confirm.
  ///
  /// In zh_Hant, this message translates to:
  /// **'您確定要刪除這則備忘錄嗎？此操作無法復原。'**
  String get memo_delete_confirm;

  /// No description provided for @memo_add_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新增備忘錄'**
  String get memo_add_title;

  /// No description provided for @memo_edit_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯備忘錄'**
  String get memo_edit_title;

  /// No description provided for @memo_hint_text.
  ///
  /// In zh_Hant, this message translates to:
  /// **'想記下關於 {name} 的什麼呢？'**
  String memo_hint_text(String name);

  /// No description provided for @memo_label_reminder_date.
  ///
  /// In zh_Hant, this message translates to:
  /// **'提醒日期:'**
  String get memo_label_reminder_date;

  /// No description provided for @memo_action_save.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存備忘'**
  String get memo_action_save;

  /// No description provided for @memo_error_empty_content.
  ///
  /// In zh_Hant, this message translates to:
  /// **'內容不能空白喔！'**
  String get memo_error_empty_content;

  /// No description provided for @memo_list_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'與 {name} 的備忘錄'**
  String memo_list_title(String name);

  /// No description provided for @memo_empty_state.
  ///
  /// In zh_Hant, this message translates to:
  /// **'還沒有任何備忘錄喔！\n點擊右上角新增一個吧！'**
  String get memo_empty_state;

  /// No description provided for @memo_reminder_date_display.
  ///
  /// In zh_Hant, this message translates to:
  /// **'提醒日：{date}'**
  String memo_reminder_date_display(String date);

  /// No description provided for @daily_gift_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'時光每日贈禮'**
  String get daily_gift_title;

  /// No description provided for @daily_login_welcome.
  ///
  /// In zh_Hant, this message translates to:
  /// **'歡迎回到《{appName}》！\n今日簽到可領取 {amount} 點花語點數。🌸'**
  String daily_login_welcome(String appName, String amount);

  /// No description provided for @title_daily_check_in.
  ///
  /// In zh_Hant, this message translates to:
  /// **'每日簽到'**
  String get title_daily_check_in;

  /// No description provided for @success_claim_reward.
  ///
  /// In zh_Hant, this message translates to:
  /// **'成功領取 {amount} 點花語！🌸'**
  String success_claim_reward(String amount);

  /// No description provided for @error_claim_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'領取失敗，請檢查網路後重試。'**
  String get error_claim_failed;

  /// No description provided for @action_claim_now.
  ///
  /// In zh_Hant, this message translates to:
  /// **'立即領取'**
  String get action_claim_now;

  /// No description provided for @common_or.
  ///
  /// In zh_Hant, this message translates to:
  /// **'或'**
  String get common_or;

  /// No description provided for @title_language_settings.
  ///
  /// In zh_Hant, this message translates to:
  /// **'語言設定'**
  String get title_language_settings;

  /// No description provided for @app_name.
  ///
  /// In zh_Hant, this message translates to:
  /// **'戀戀拾光'**
  String get app_name;

  /// No description provided for @login_slogan.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開啟妳的專屬時光'**
  String get login_slogan;

  /// No description provided for @login_with_google.
  ///
  /// In zh_Hant, this message translates to:
  /// **'使用 Google 登入'**
  String get login_with_google;

  /// No description provided for @login_with_apple.
  ///
  /// In zh_Hant, this message translates to:
  /// **'透過 Apple 登入'**
  String get login_with_apple;

  /// No description provided for @login_with_facebook.
  ///
  /// In zh_Hant, this message translates to:
  /// **'使用 Facebook 登入'**
  String get login_with_facebook;

  /// No description provided for @login_with_email.
  ///
  /// In zh_Hant, this message translates to:
  /// **'使用戀戀帳號登入 (Email)'**
  String get login_with_email;

  /// No description provided for @title_contact_us_heading.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我們非常重視您的建議！'**
  String get title_contact_us_heading;

  /// No description provided for @desc_contact_us_body.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請在這裡寫下您的想法，幫助我們把遊戲變得更好。'**
  String get desc_contact_us_body;

  /// No description provided for @error_feedback_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'建議內容不能為空喔！'**
  String get error_feedback_empty;

  /// No description provided for @email_subject_feedback.
  ///
  /// In zh_Hant, this message translates to:
  /// **'戀戀拾光 - 玩家反饋建議'**
  String get email_subject_feedback;

  /// No description provided for @msg_email_app_not_found_copied.
  ///
  /// In zh_Hant, this message translates to:
  /// **'無法自動開啟郵件，已為您複製官方信箱！'**
  String get msg_email_app_not_found_copied;

  /// No description provided for @title_contact_us.
  ///
  /// In zh_Hant, this message translates to:
  /// **'聯絡我們'**
  String get title_contact_us;

  /// No description provided for @desc_contact_us.
  ///
  /// In zh_Hant, this message translates to:
  /// **'我們非常重視您的建議！\n請在這裡寫下您的想法，幫助我們把遊戲變得更好。'**
  String get desc_contact_us;

  /// No description provided for @hint_enter_feedback.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請在此輸入您的建議...'**
  String get hint_enter_feedback;

  /// No description provided for @action_send_via_email.
  ///
  /// In zh_Hant, this message translates to:
  /// **'透過 Email 傳送'**
  String get action_send_via_email;

  /// No description provided for @error_email_password_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'信箱和密碼不能為空喔！'**
  String get error_email_password_empty;

  /// No description provided for @auth_error_default.
  ///
  /// In zh_Hant, this message translates to:
  /// **'發生錯誤，請稍後再試。'**
  String get auth_error_default;

  /// No description provided for @auth_error_user_not_found.
  ///
  /// In zh_Hant, this message translates to:
  /// **'找不到此信箱，請先註冊喔！'**
  String get auth_error_user_not_found;

  /// No description provided for @auth_error_wrong_password.
  ///
  /// In zh_Hant, this message translates to:
  /// **'密碼錯誤，請再試一次！'**
  String get auth_error_wrong_password;

  /// No description provided for @auth_error_email_in_use.
  ///
  /// In zh_Hant, this message translates to:
  /// **'這個信箱已經被註冊過囉！請直接登入。'**
  String get auth_error_email_in_use;

  /// No description provided for @auth_error_weak_password.
  ///
  /// In zh_Hant, this message translates to:
  /// **'密碼太弱了，請至少輸入 6 個字元！'**
  String get auth_error_weak_password;

  /// No description provided for @auth_error_invalid_email.
  ///
  /// In zh_Hant, this message translates to:
  /// **'信箱格式不正確！'**
  String get auth_error_invalid_email;

  /// No description provided for @title_welcome_back.
  ///
  /// In zh_Hant, this message translates to:
  /// **'歡迎回來'**
  String get title_welcome_back;

  /// No description provided for @title_register_account.
  ///
  /// In zh_Hant, this message translates to:
  /// **'註冊專屬帳號'**
  String get title_register_account;

  /// No description provided for @label_email.
  ///
  /// In zh_Hant, this message translates to:
  /// **'電子郵件'**
  String get label_email;

  /// No description provided for @label_password.
  ///
  /// In zh_Hant, this message translates to:
  /// **'密碼'**
  String get label_password;

  /// No description provided for @action_login.
  ///
  /// In zh_Hant, this message translates to:
  /// **'登入'**
  String get action_login;

  /// No description provided for @action_register.
  ///
  /// In zh_Hant, this message translates to:
  /// **'註冊'**
  String get action_register;

  /// No description provided for @prompt_no_account.
  ///
  /// In zh_Hant, this message translates to:
  /// **'還沒有帳號？點我註冊'**
  String get prompt_no_account;

  /// No description provided for @prompt_has_account.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已經有帳號了？點我登入'**
  String get prompt_has_account;

  /// No description provided for @error_nickname_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'暱稱不能為空！'**
  String get error_nickname_empty;

  /// No description provided for @profile_saved_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'個人檔案儲存！'**
  String get profile_saved_success;

  /// No description provided for @error_id_empty.
  ///
  /// In zh_Hant, this message translates to:
  /// **'ID不能為空！'**
  String get error_id_empty;

  /// No description provided for @error_id_too_long.
  ///
  /// In zh_Hant, this message translates to:
  /// **'ID長度不能超過10個字元！'**
  String get error_id_too_long;

  /// No description provided for @error_id_already_used.
  ///
  /// In zh_Hant, this message translates to:
  /// **'此ID已被使用，請換一個！'**
  String get error_id_already_used;

  /// No description provided for @profile_save_failed.
  ///
  /// In zh_Hant, this message translates to:
  /// **'儲存失敗: {error}'**
  String profile_save_failed(String error);

  /// No description provided for @draft_saved_success_msg.
  ///
  /// In zh_Hant, this message translates to:
  /// **'好的！先幫你保存在草稿裡，隨時可以回來編輯喔！✨'**
  String get draft_saved_success_msg;

  /// No description provided for @dialog_reminder_title.
  ///
  /// In zh_Hant, this message translates to:
  /// **'提醒'**
  String get dialog_reminder_title;

  /// No description provided for @warning_id_not_edited.
  ///
  /// In zh_Hant, this message translates to:
  /// **'專屬ID尚未編輯，您確定要現在儲存嗎？'**
  String get warning_id_not_edited;

  /// No description provided for @action_continue_editing.
  ///
  /// In zh_Hant, this message translates to:
  /// **'繼續編輯'**
  String get action_continue_editing;

  /// No description provided for @action_edit_later.
  ///
  /// In zh_Hant, this message translates to:
  /// **'之後再編輯'**
  String get action_edit_later;

  /// No description provided for @action_edit_later_short.
  ///
  /// In zh_Hant, this message translates to:
  /// **'稍後再編輯'**
  String get action_edit_later_short;

  /// No description provided for @action_cancel_changes.
  ///
  /// In zh_Hant, this message translates to:
  /// **'取消變更'**
  String get action_cancel_changes;

  /// No description provided for @error_birthdate_locked.
  ///
  /// In zh_Hant, this message translates to:
  /// **'出生日期已設定，不可更改！'**
  String get error_birthdate_locked;

  /// No description provided for @action_select_avatar.
  ///
  /// In zh_Hant, this message translates to:
  /// **'選擇頭像'**
  String get action_select_avatar;

  /// No description provided for @action_choose_from_gallery.
  ///
  /// In zh_Hant, this message translates to:
  /// **'從相冊選擇'**
  String get action_choose_from_gallery;

  /// No description provided for @title_adjust_avatar.
  ///
  /// In zh_Hant, this message translates to:
  /// **'調整您的時光頭像'**
  String get title_adjust_avatar;

  /// No description provided for @avatar_updated_success.
  ///
  /// In zh_Hant, this message translates to:
  /// **'已為您換上頭像 🍃'**
  String get avatar_updated_success;

  /// No description provided for @title_create_profile.
  ///
  /// In zh_Hant, this message translates to:
  /// **'建立你的檔案'**
  String get title_create_profile;

  /// No description provided for @title_edit_profile.
  ///
  /// In zh_Hant, this message translates to:
  /// **'編輯個人檔案'**
  String get title_edit_profile;

  /// No description provided for @label_your_nickname.
  ///
  /// In zh_Hant, this message translates to:
  /// **'您的暱稱'**
  String get label_your_nickname;

  /// No description provided for @label_player_exclusive_id.
  ///
  /// In zh_Hant, this message translates to:
  /// **'玩家專屬 ID'**
  String get label_player_exclusive_id;

  /// No description provided for @msg_id_locked.
  ///
  /// In zh_Hant, this message translates to:
  /// **'ID 已鎖定，無法再次更改。'**
  String get msg_id_locked;

  /// No description provided for @msg_id_change_chance.
  ///
  /// In zh_Hant, this message translates to:
  /// **'您有一次免費更改 ID 的機會。'**
  String get msg_id_change_chance;

  /// No description provided for @action_select_birthdate.
  ///
  /// In zh_Hant, this message translates to:
  /// **'請選擇出生日期'**
  String get action_select_birthdate;

  /// No description provided for @label_birthdate.
  ///
  /// In zh_Hant, this message translates to:
  /// **'出生日期: {date}'**
  String label_birthdate(String date);

  /// No description provided for @msg_birthdate_immutable.
  ///
  /// In zh_Hant, this message translates to:
  /// **'生日設定後不可更改 ✨'**
  String get msg_birthdate_immutable;

  /// No description provided for @action_start_journey.
  ///
  /// In zh_Hant, this message translates to:
  /// **'開啟時光旅程'**
  String get action_start_journey;

  /// No description provided for @action_add_image.
  ///
  /// In zh_Hant, this message translates to:
  /// **'新增圖片'**
  String get action_add_image;
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
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
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
