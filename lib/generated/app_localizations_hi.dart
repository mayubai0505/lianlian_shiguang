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

  @override
  String get characterNotFoundError => 'चरित्र डेटा नहीं मिला';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'चरित्र विवरण लोड करने में विफल रहा: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'प्रारंभिक संबंध';

  @override
  String get relationship_childhood_friend => 'बचपन के दोस्त';

  @override
  String get relationship_senior_junior => 'सीनियर/जूनियर स्कूली दोस्त';

  @override
  String get relationship_bickering_couple => 'झगड़ालू युगल';

  @override
  String get relationship_colleagues => 'सहकर्मी';

  @override
  String get relationship_other => 'अन्य (कृपया मैन्युअल रूप से दर्ज करें)';

  @override
  String get chatModeDaily => 'दैनिक मोड';

  @override
  String get chatModeStory => 'कहानी मोड';

  @override
  String get chatModeImmersive => 'इमर्सिव मोड';

  @override
  String get chatModeGemini => 'जीवन साथी';

  @override
  String get announcement_new => 'नई घोषणा';

  @override
  String get mail_notification =>
      'एक नया समय पत्र आया है! अभी चर्मपत्र स्क्रॉल देखें!';

  @override
  String get customer_service_reply => 'ग्राहक सेवा प्रतिक्रिया';

  @override
  String get system_announcement => 'सिस्टम घोषणा';

  @override
  String get empty_announcement => 'फिलहाल कोई घोषणा नहीं है';

  @override
  String get untitled => 'बिना शीर्षक';

  @override
  String get no_content => 'कोई सामग्री नहीं';

  @override
  String get privacy_policy_title => 'Lianlian Shiguang गोपनीयता नीति';

  @override
  String get privacy_policy_date => 'अंतिम अपडेट: 10 अप्रैल, 2026';

  @override
  String get privacy_policy_body =>
      '\"Lianlian Shiguang\" गोपनीयता नीति\nअंतिम अपडेट: 10 अप्रैल, 2026\n\n\"Lianlian Shiguang\" (इसके बाद \"सेवा\") में आपका स्वागत है। हम आपकी गोपनीयता को महत्व देते हैं।\n\n1. खाता जानकारी:\nतृतीय-पक्ष लॉगिन: Google, Facebook, Apple के माध्यम से UID, ईमेल और उपनाम। पासवर्ड Firebase द्वारा एन्क्रिप्ट किया गया है।\nबातचीत डेटा: AI पात्रों की याददाश्त के लिए हम आपके संवादों को सहेजते हैं।\nडिवाइस जानकारी: सिस्टम अनुकूलन के लिए डिवाइस मॉडल और OS संस्करण।\n\n2. उपयोग:\nAI अनुभव को बेहतर बनाना, भुगतान प्रक्रिया (पॉइंट्स), और सुरक्षा।\n\n3. भागीदार:\nGoogle Cloud, Firebase, OpenRouter, xAI, Meta। हम आपका डेटा विज्ञापनदाताओं को नहीं बेचते।\n\n4. हटाना:\nआप किसी भी समय खाता और डेटा स्थायी रूप से हटाने का अनुरोध कर सकते हैं।';

  @override
  String get terms_title => 'Lianlian Shiguang सेवा की शर्तें';

  @override
  String get terms_date => 'अंतिम अपडेट: 10 अप्रैल, 2026';

  @override
  String get terms_body =>
      '\"Lianlian Shiguang\" सेवा की शर्तें\nअंतिम अपडेट: 10 अप्रैल, 2026\n\nसेवा का उपयोग करने से पहले कृपया इन शर्तों को पढ़ें:\n\n1. सेवा की प्रकृति:\nAI द्वारा उत्पन्न उत्तर। यह निर्माता के विचारों का प्रतिनिधित्व नहीं करता। सामग्री काल्पनिक हो सकती है।\n\n2. वर्चुअल पॉइंट्स:\nपॉइंट्स वर्चुअल सामान हैं। उपयोग के बाद रिफंड संभव नहीं है।\n\n3. आचरण नियम:\nअवैध सामग्री बनाना या सिस्टम में हस्तक्षेप करना प्रतिबंधित है।\n\n4. बौद्धिक संपदा:\nपात्र (जैसे: Cheng An) और गेम लॉजिक विकास टीम के स्वामित्व में हैं। आइकन लाइसेंस के तहत उपयोग किए जाते हैं।\n\n5. समाप्ति:\nनियमों के उल्लंघन पर खाते को निलंबित किया जा सकता है।';

  @override
  String get login_required => 'कृपया पहले लॉगिन करें';

  @override
  String get cloud_character_mgmt => 'क्लाउड कैरेक्टर प्रबंधन';

  @override
  String get connection_error => 'कनेक्शन त्रुटि';

  @override
  String get no_characters_met => 'आप अभी तक किसी पात्र से नहीं मिले हैं!';

  @override
  String get status_paused => 'स्थिति: संपर्क रुका हुआ';

  @override
  String get status_in_progress => 'स्थिति: प्रगति पर';

  @override
  String get unblock => 'अनब्लॉक करें';

  @override
  String get block => 'ब्लॉक करें';

  @override
  String get confirm_block_title => 'ब्लॉक करने की पुष्टि करें?';

  @override
  String confirm_block_msg(Object charName) {
    return 'ब्लॉक करने के बाद, आपको फिलहाल $charName के संदेश नहीं मिलेंगे।';
  }

  @override
  String get think_again => 'फिर से सोचें';

  @override
  String get confirm_block_btn => 'ब्लॉक की पुष्टि करें';

  @override
  String get no_char_info =>
      'इस पात्र के लिए अभी तक कोई विस्तृत जानकारी नहीं है...';

  @override
  String get private_mailbox => 'निजी मेलबॉक्स';

  @override
  String get user_info_not_found => 'उपयोगकर्ता जानकारी नहीं मिली';

  @override
  String get load_failed => 'लोड विफल, बाद में पुन: प्रयास करें';

  @override
  String get empty_mailbox => 'मेलबॉक्स फिलहाल खाली है~';

  @override
  String get system_notification => 'सिस्टम अधिसूचना';

  @override
  String get interaction_records => 'बातचीत रिकॉर्ड';

  @override
  String get liked_content => 'पसंद की गई सामग्री';

  @override
  String get my_favorites => 'मेरे पसंदीदा';

  @override
  String get login_to_view_records => 'रिकॉर्ड देखने के लिए लॉगिन करें';

  @override
  String get no_likes_yet => 'आपने अभी तक कोई पोस्ट पसंद नहीं की है!';

  @override
  String get empty_favorites => 'पसंदीदा फ़ोल्डर खाली है, लॉबी में घूमें!';

  @override
  String get theme_sakura_pink => 'साकुरा पिंक';

  @override
  String get theme_ocean_blue => 'समुद्री नीला';

  @override
  String get theme_sunset_orange => 'सूर्यास्त संतरा';

  @override
  String get theme_mint_forest => 'पुदीना वन';

  @override
  String get theme_midnight => 'मिडनाइट मोड';

  @override
  String get change_atmosphere => 'माहौल बदलें';

  @override
  String get custom_color => 'कस्टम रंग';

  @override
  String get custom_color_desc => 'अपना विशिष्ट माहौल रंग बनाएं';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पुष्टि करें';
}
