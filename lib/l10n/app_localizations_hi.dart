// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get changeTheme => 'थीम का रंग बदलें';

  @override
  String get feedback => 'प्रतिक्रिया और सुझाव';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String get allFriendsTitle => 'सभी मित्र';

  @override
  String get noFriendsMessage => 'आपके पास अभी तक कोई मित्र नहीं है।';

  @override
  String get unknownCharacter => 'अज्ञात चरित्र';

  @override
  String errorLoadingFriends(String error) {
    return 'मित्र सूची लोड करते समय एक त्रुटि हुई: $error';
  }

  @override
  String get tagGentle => 'सौम्य';

  @override
  String get tagCheerful => 'खुशमिजाज';

  @override
  String get tagLively => 'जीवंत';

  @override
  String get tagMischievous => 'शरारती';

  @override
  String get tagRichYoungLady => 'अमीर युवा महिला';

  @override
  String get tagRichYoungMaster => 'अमीर युवा पुरुष';

  @override
  String get tagWealthyFamily => 'धनी परिवार';

  @override
  String get tagScheming => 'साजिश';

  @override
  String get tagPossessive => 'अधिकारवादी';

  @override
  String get tagParanoid => 'अति-संदेही';

  @override
  String get tagPersistent => 'हठी';

  @override
  String get tagUncle => 'चाचा';

  @override
  String get tagAuntie => 'चाची';

  @override
  String get tagSeniorSister => 'सीनियर बहन';

  @override
  String get tagJuniorBrother => 'जूनियर भाई';

  @override
  String get tagHandsome => 'सुंदर';

  @override
  String get tagStunning => 'आश्चर्यजनक रूप से सुंदर';

  @override
  String get tagContrast => 'विपरीत';

  @override
  String get tagFlirty => 'फ्लर्टी';

  @override
  String get tagAgeGap => 'उम्र का अंतर';

  @override
  String get userNotFoundError => 'उपयोगकर्ता नहीं मिला';

  @override
  String get imageDataMismatchError =>
      'छवि डेटा बेमेल है, कृपया छवि को फिर से चुनें।';

  @override
  String get createCharacterTitle => 'चरित्र बनाएं';

  @override
  String get charAlbumTitle => 'चरित्र एल्बम (पहली तस्वीर मुख्य अवतार है)';

  @override
  String get charNameLabel => 'चरित्र का नाम:*';

  @override
  String get charDescSection => 'चरित्र का विवरण:';

  @override
  String get charAgeLabel => 'आयु:';

  @override
  String get charJobLabel => 'पेशा:*';

  @override
  String get charBirthdayLabel => 'जन्मदिन:(MMDD)';

  @override
  String get charGenderLabel => 'लिंग *';

  @override
  String get genderNotSelected => 'चयनित नहीं';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderFemale => 'महिला';

  @override
  String get genderOther => 'अन्य';

  @override
  String get charHeightLabel => 'ऊंचाई:(cm)';

  @override
  String get charAppearanceLabel => 'रूप का वर्णन:';

  @override
  String get charPersonalityTagsSection => 'व्यक्तित्व टैग';

  @override
  String get charOtherPersonalityTagsHint => 'अन्य व्यक्तित्व टैग...';

  @override
  String get otherSectionTitle => 'अन्य';

  @override
  String get charLikesLabel =>
      'पसंदीदा चीजें:(उदाहरण: स्ट्रॉबेरी केक, बिल्लियाँ, बारिश के दिन)';

  @override
  String get charDislikesLabel =>
      'नापसंद चीजें:(उदाहरण: करेला, शोरगुल वाली जगह)';

  @override
  String get charSecretsLabel =>
      'अज्ञात छोटे रहस्य: (उदाहरण: वास्तव में रास्ता भूलने वाला है)';

  @override
  String get charMannerismsSection => 'आचरण और व्यवहार';

  @override
  String get charToneLabel =>
      'बोलने का लहजा और शैली: (उदाहरण: अजनबियों के प्रति ठंडा)';

  @override
  String get charDialogueExampleLabel =>
      'संवाद का उदाहरण: (खिलाड़ी: आप बहुत अच्छे हैं! चरित्र: ...ओह।)';

  @override
  String get charBackgroundSection => 'चरित्र की पृष्ठभूमि:';

  @override
  String get charBackgroundHint =>
      'चरित्र की पृष्ठभूमि कहानी दर्ज करें (अधिकतम 2500 शब्द)';

  @override
  String get charStoryStartSection => 'कहानी की शुरुआत:';

  @override
  String get charStoryStartHint =>
      'चरित्र की कहानी दर्ज करें (अधिकतम 2500 शब्द)';

  @override
  String get charStorySummaryLabel =>
      'कहानी का सारांश (अधिकतम 50 शब्द, यह मुठभेड़ कार्ड पर प्रदर्शित होगा)';

  @override
  String get charExtraInfoSection => 'चरित्र की अतिरिक्त जानकारी:';

  @override
  String get charExtraInfoHint => 'अतिरिक्त सामग्री दर्ज करें...';

  @override
  String get charPublicToggleLabel =>
      'क्या इसे अन्य खिलाड़ियों के लिए खेलने के लिए सार्वजनिक करना है?';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get createButton => 'बनाएं';

  @override
  String get saveButton => 'सहेजें';

  @override
  String get cancelButton => 'रद्द करें';

  @override
  String get exitCreationTitle =>
      'आप चरित्र निर्माण स्क्रीन से बाहर निकल रहे हैं';

  @override
  String get saveDraftPrompt =>
      'क्या इसे ड्राफ्ट के रूप में सहेजने की आवश्यकता है?';

  @override
  String get draftNeeded => 'हाँ';

  @override
  String get draftNotNeeded => 'नहीं';

  @override
  String get editExtraInfoTitle => 'अतिरिक्त सामग्री संपादित करें';

  @override
  String get nameAndAvatarError =>
      'कृपया चरित्र का नाम भरें और कम से कम एक अवतार अपलोड करें!';

  @override
  String get savingStatus => 'सहेजा जा रहा है...';

  @override
  String get uploadingImagesStatus => 'छवियां अपलोड की जा रही हैं...';

  @override
  String get maxImagesError => 'अधिकतम 10 तस्वीरें ही अपलोड की जा सकती हैं।';

  @override
  String get uploadingImagesStatusShort => 'छवियां प्रोसेस हो रही हैं...';

  @override
  String get savingCharacterData => 'चरित्र डेटा सहेजा जा रहा है...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'चरित्र \"$charName\" बनाया गया!';
  }

  @override
  String get uploadImageTimeoutError =>
      'चरित्र निर्माण विफल: छवि अपलोड का समय समाप्त हो गया है, कृपया अपना इंटरनेट कनेक्शन जांचें।';

  @override
  String createCharacterGenericError(String error) {
    return 'चरित्र निर्माण विफल: $error';
  }

  @override
  String get settingsSectionAppearance => 'रूप और सामग्री';

  @override
  String get settingsSectionAccount => 'खाता और सामग्री प्रबंधन';

  @override
  String get settingsSectionAbout => 'हमारे बारे में';

  @override
  String get accountManagement => 'खाता प्रबंधन';

  @override
  String get userId => 'आईडी:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'अज्ञात';

  @override
  String get userIdCopied => 'उपयोगकर्ता आईडी क्लिपबोर्ड पर कॉपी हो गया है';

  @override
  String get characterManagement => 'चरित्र प्रबंधन';

  @override
  String get viewBlockedCharacters => 'ब्लॉक किए गए चरित्र देखें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get logoutButton => 'लॉग आउट';

  @override
  String get logoutDialogTitle => 'क्या आप लॉग आउट करना चाहते हैं?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'मैंने गलती से दबा दिया';

  @override
  String get logoutDialogActionConfirm => 'पुष्टि करें';

  @override
  String get logoutSuccessSnackbar =>
      'ठीक है! मैं आपके वापस आने का इंतज़ार करूँगा♥(´∀` )';

  @override
  String get deleteAccountButton => 'खाता हटाएँ';

  @override
  String get deleteAccountDialogTitle =>
      'क्या आप वाकई इस खाते को हटाना चाहते हैं?இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'यह कार्रवाई पूर्ववत नहीं की जा सकती है, सभी डेटा स्थायी रूप से हटा दिए जाएंगे!';

  @override
  String get deleteAccountDialogActionCancel =>
      'नहीं, मैं इसे हटाना नहीं चाहता';

  @override
  String get deleteAccountDialogActionConfirm => 'पुष्टि करें';

  @override
  String get deleteAccountSuccessSnackbar =>
      'खाता सफलतापूर्वक हटा दिया गया है।';

  @override
  String get appDisclaimer =>
      'गेम में पात्र और दृश्य सभी काल्पनिक हैं, कृपया उन्हें वास्तविकता में न लें! यदि कोई समानता है, तो यह पूरी तरह से एक संयोग है।';

  @override
  String appVersion(String version) {
    return 'ऐप संस्करण: $version';
  }

  @override
  String get dialogTitleHint => 'संकेत';

  @override
  String get completeProfilePrompt =>
      'कृपया अपनी जानकारी पूरी करने के लिए पहले अपनी प्रोफ़ाइल संपादित करें!';

  @override
  String get goToEdit => 'संपादन पर जाएं';

  @override
  String get later => 'बाद में';

  @override
  String chattingWith(String friendName) {
    return '$friendName के साथ चैट कर रहे हैं';
  }

  @override
  String chatContentWith(String friendName) {
    return '$friendName के साथ चैट की सामग्री';
  }

  @override
  String get chatInputHint => 'संदेश लिखें...';
}
