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
  String get charNameLabel => 'चरित्र का नाम:';

  @override
  String get charDescSection => 'चरित्र का विवरण:';

  @override
  String get charAgeLabel => 'आयु:';

  @override
  String get charJobLabel => 'पेशा:';

  @override
  String get charBirthdayLabel => 'जन्मदिन:(MMDD)';

  @override
  String get charGenderLabel => 'लिंग ';

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
      'खेल के सभी पात्र और दृश्य काल्पनिक हैं, कृपया इन्हें वास्तविकता से न जोड़ें!';

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
  String get terms_title => 'उपयोग की शर्तें';

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
  String block_warning_msg(String charName) {
    return 'ब्लॉक करने के बाद, आपको अस्थायी रूप से $charName के संदेश प्राप्त नहीं होंगे।';
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

  @override
  String get confirm_delete_title => 'हटाने की पुष्टि करें';

  @override
  String get confirm_delete_memory_msg =>
      'क्या आप वाकई चाहते हैं कि वह इसे भूल जाए? इस क्रिया को पूर्ववत नहीं किया जा सकता है।';

  @override
  String get delete_btn => 'हटाएं';

  @override
  String get memory_erased_msg => 'यह याद मिटा दी गई है।';

  @override
  String get delete_failed_msg => 'हटाना विफल रहा';

  @override
  String get edit_memory_title => 'यादें संपादित करें';

  @override
  String get modify_memory_hint => 'इस याद को संशोधित करें...';

  @override
  String get memory_re_recorded_msg => 'याद फिर से रिकॉर्ड की गई';

  @override
  String get update_failed_msg => 'अपडेट विफल रहा';

  @override
  String get update_favorite_failed_msg => 'पसंदीदा स्थिति अपडेट करने में विफल';

  @override
  String char_notebook_title(String charName) {
    return '$charName की नोटबुक';
  }

  @override
  String get error_loading_memory => 'यादें लोड करते समय त्रुटि';

  @override
  String get empty_notebook_msg =>
      'नोटबुक खाली है...\nजाकर चैट करें ताकि वह आपके बारे में हर छोटी बात लिख सके!';

  @override
  String get date_format_text => 'd MMM yyyy';

  @override
  String get remove_special_focus => 'विशेष ध्यान हटाएं';

  @override
  String get mark_special_focus => 'विशेष ध्यान के रूप में चिह्नित करें';

  @override
  String get edit_btn => 'संपादित करें';

  @override
  String get load_gallery_failed => 'गैलरी लोड करने में विफल';

  @override
  String get traditional_chinese => 'पारंपरिक चीनी';

  @override
  String get all => 'सभी';

  @override
  String get official_recommendation => 'आधिकारिक अनुशंसा';

  @override
  String get my_exclusive => 'मेरा विशेष';

  @override
  String encounter_count(int count) {
    return '$count मुलाकातें';
  }

  @override
  String get official => 'आधिकारिक';

  @override
  String get private => 'निजी';

  @override
  String get first_encounter => 'पहली मुलाकात';

  @override
  String char_exclusive_memory(String charName) {
    return '$charName की विशेष यादें';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return 'इस याद को अनलॉक करने के लिए स्नेह $affectionLevel तक पहुंचना चाहिए!';
  }

  @override
  String get affection => 'स्नेह';

  @override
  String get unlock => 'अनलॉक';

  @override
  String get change_chat_bg => 'चैट बैकग्राउंड बदलें';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return 'क्या \"$cgDesc\" को $charName के साथ चैट बैकग्राउंड के रूप में सेट करें?';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return 'बैकग्राउंड को \"$cgDesc\" में बदल दिया गया';
  }

  @override
  String get confirm_change => 'पुष्टि करें';

  @override
  String get empty_treasure_box =>
      'खजाना बॉक्स खाली है...\nछिपे हुए सरप्राइज खोजने के लिए चैट करें!';

  @override
  String get unknown_story => 'अज्ञात कहानी';

  @override
  String get open_this_memory => 'यह याद खोलें';

  @override
  String get open_exclusive_story => 'विशेष कहानी खोलें';

  @override
  String confirm_use_egg(String eggTitle) {
    return 'क्या आप अभी \"$eggTitle\" का अनुभव करना चाहते हैं?\n\n(यह आइटम केवल एक बार उपयोग के लिए है और उपयोग के बाद स्वचालित रूप से कहानी शुरू हो जाएगी)';
  }

  @override
  String get wait_a_bit => 'थोड़ी देर रुकें';

  @override
  String guiding_into_story(String eggTitle) {
    return 'कहानी में निर्देशित कर रहा है...';
  }

  @override
  String get use_now => 'अभी उपयोग करें';

  @override
  String playback_failed_status(String statusCode) {
    return 'प्लेबैक विफल, स्थिति कोड: $statusCode';
  }

  @override
  String get playback_error => 'प्लेबैक त्रुटि हुई';

  @override
  String get unknown_contact => 'अज्ञात संपर्क';

  @override
  String call_memory_with(String charName) {
    return '$charName के साथ कॉल की यादें';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return 'आत्मीयता $affection पर अनलॉक होता है';
  }

  @override
  String get no_call_record =>
      'ऐसा लगता है कि इस कॉल के लिए कोई वार्तालाप रिकॉर्ड नहीं है...';

  @override
  String get me => 'मैं';

  @override
  String get playing => 'चल रहा है...';

  @override
  String get listen => 'सुनें';

  @override
  String get no_exclusive_voice =>
      'इस पात्र के लिए अभी तक कोई विशेष आवाज़ सेट नहीं की गई है!';

  @override
  String get voice_download_success =>
      '✅ वॉयस डेटा सफलतापूर्वक डाउनलोड हो गया, प्ले करने की तैयारी...';

  @override
  String get onboarding_invitation => '— समय का निमंत्रण —';

  @override
  String get onboarding_welcome => 'Lian Lian Shi Guang में आपका स्वागत है';

  @override
  String get onboarding_quote =>
      '「हर मुलाकात लंबे समय के बाद का पुनर्मिलन है।」';

  @override
  String get onboarding_gift_title => 'पहली मुलाकात का उपहार: 50 फूल';

  @override
  String get onboarding_gift_subtitle =>
      'उसके साथ आपकी कहानी शुरू होने पर ये फूल आपके साथ रहेंगे।';

  @override
  String get onboarding_start_button => 'अपनी समय यात्रा शुरू करें';

  @override
  String get onboarding_more_info => 'कहानी के बारे में और जानें';

  @override
  String get legal_agreement_prefix => 'जारी रखने का अर्थ है कि आप सहमत हैं:';

  @override
  String get legal_terms_button => 'सेवा की शर्तें';

  @override
  String get legal_and => ' और ';

  @override
  String get legal_privacy_button => 'गोपनीयता नीति';

  @override
  String get call_memory_title => 'कॉल की यादें';

  @override
  String get please_login_first => 'कृपया पहले लॉग इन करें';

  @override
  String get no_call_memories =>
      'अभी तक कोई कॉल यादें सहेजी नहीं गई हैं।\nअधिकतम 10 रिकॉर्ड सहेजे जा सकते हैं।';

  @override
  String call_with_name(String name) {
    return '$name के साथ कॉल';
  }

  @override
  String call_duration(String time) {
    return 'अवधि: $time';
  }

  @override
  String get delete_call_title => 'कॉल रिकॉर्ड हटाएं';

  @override
  String delete_call_confirm(String name) {
    return 'क्या आप वाकई $name के साथ इस स्मृति को हटाना चाहते हैं?\n(इसे पूर्ववत नहीं किया जा सकता)';
  }

  @override
  String get keep_it => 'इसे रखें';

  @override
  String get confirm_delete => 'हटाएं';

  @override
  String get press_mic_to_speak => 'बोलने के लिए माइक्रोफ़ोन दबाएं...';

  @override
  String get call_ended => 'कॉल समाप्त';

  @override
  String character_thinking(String name) {
    return '($name सोच रहा है...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name फोन उठा रहा है...)';
  }

  @override
  String get call_interrupted_login => '(कॉल बाधित) कृपया पहले लॉग इन करें...';

  @override
  String get silence => '(सन्नाटा)';

  @override
  String get bad_signal => '(खराब सिग्नल...)';

  @override
  String get static_noise => '(स्थिर शोर)... साफ़ सुनाई नहीं दे रहा...';

  @override
  String get type_message_hint => 'संदेश टाइप करें...';

  @override
  String get draft_saved_success =>
      'ड्राफ्ट गुप्त स्टूडियो में सुरक्षित रूप से सहेजा गया!';

  @override
  String get draft_save_failed =>
      'सहेजने में विफल, कृपया बाद में पुनः प्रयास करें';

  @override
  String get draft_save_title => 'क्या ड्राफ्ट सहेजना चाहते हैं?';

  @override
  String get draft_save_content =>
      'आपका काम अभी तक प्रकाशित नहीं हुआ है, क्या इसे पहले गुप्त स्टूडियो में सहेजना चाहते हैं?';

  @override
  String get not_save => 'न सहेजें';

  @override
  String get save_draft => 'ड्राफ्ट सहेजें';

  @override
  String confirm_delete_char_content(String name) {
    return 'क्या आप वाकई पात्र \"$name\" को हटाना चाहते हैं?\n\nयह क्रिया वापस नहीं ली जा सकती!';
  }

  @override
  String get char_deleted => 'पात्र हटा दिया गया';

  @override
  String get ok_button => 'ठीक है!';

  @override
  String get cannot_save_title => 'सहेज नहीं सकते';

  @override
  String get cannot_save_content =>
      'कृपया पात्र का नाम भरें और कम से कम एक अवतार अपलोड करें!';

  @override
  String get word_count_exceeded => 'शब्द सीमा पार हो गई';

  @override
  String word_count_error_detail(String field, int limit) {
    return '\"$field\" में $limit शब्दों की सीमा पार हो गई है, कृपया कम करें और पुनः सहेजें।';
  }

  @override
  String get content_missing => 'सामग्री गायब है';

  @override
  String get content_missing_personality =>
      'कृपया \"विस्तृत व्यक्तित्व\" भरें! कम से कम 10 शब्द लिखें।';

  @override
  String get content_missing_bg =>
      '\"पात्र परिचय\" बहुत छोटा है! पृष्ठभूमि बताने के लिए कम से कम 20 शब्द लिखें।';

  @override
  String get content_missing_tone =>
      'कृपया \"लहजा और आदतें\" सेट करें, अन्यथा पात्र का व्यवहार बदल सकता है!';

  @override
  String get user_not_found => 'त्रुटि: उपयोगकर्ता नहीं मिला';

  @override
  String char_saved_success(String name, String action) {
    return 'पात्र \"$name\" को $action कर दिया गया है!';
  }

  @override
  String save_error_detail(String error) {
    return 'सहेजने में विफल: $error';
  }

  @override
  String get easter_egg_add_title => 'नया गुप्त ईस्टर एग जोड़ें';

  @override
  String get easter_egg_edit_title => 'ईस्टर एग संपादित करें';

  @override
  String get keyword_label => 'ट्रिगर कीवर्ड (अनिवार्य)';

  @override
  String get keyword_hint => 'जैसे: एम्यूजमेंट पार्क जाना, स्ट्रॉबेरी केक';

  @override
  String get egg_title_label => 'ईस्टर एग शीर्षक (खिलाड़ियों के लिए)';

  @override
  String get egg_title_hint => 'जैसे: सप्ताहांत की डेट';

  @override
  String get egg_teaser_label => 'लघु पूर्वावलोकन (खिलाड़ियों के लिए)';

  @override
  String get egg_teaser_hint => 'होने वाली घटना की शुरुआत का वर्णन करें...';

  @override
  String get egg_scene_label => 'अनिवार्य दृश्य परिवर्तन (वैकल्पिक)';

  @override
  String get egg_scene_hint => 'जैसे: एम्यूजमेंट पार्क, डरावना घर';

  @override
  String get egg_prompt_label => 'स्क्रिप्ट निर्देश';

  @override
  String get egg_prompt_hint =>
      'इस दृश्य को कैसे निभाया जाए।\n(सिस्टम: दृश्य एम्यूजमेंट पार्क में बदलता है, पात्र (खिलाड़ी का नाम) को देखकर मुस्कुराता है...)';

  @override
  String get confirm_button => 'पुष्टि करें';

  @override
  String get keyword_empty_error => 'कीवर्ड खाली नहीं हो सकता';

  @override
  String get voice_custom_title => 'विशेष आवाज अनुकूलित करें';

  @override
  String get voice_custom_hint => 'जैसे: गंभीर बॉस, कोमल स्वभाव का लड़का...';

  @override
  String get voice_generate_start => 'बनाना शुरू करें';

  @override
  String get voice_bind_first =>
      'कृपया पहले एक विशेष आवाज चुनें और उसे \"बाइंड\" करें!';

  @override
  String get voice_test_failed =>
      'सुनने में विफल: सूक्ष्म बदलाव करने से पहले आवाज को औपचारिक रूप से बाइंड करने के लिए \"मैंने तुम्हें चुना!\" पर क्लिक करें!';

  @override
  String voice_name_default(String name) {
    return '$name की विशेष आवाज';
  }

  @override
  String get voice_description_default =>
      'यह \"लियन लियन शी गुआंग\" में विशेष पात्र के लिए बनाई गई अनूठी आवाज है, जिसे खिलाड़ी ने स्वयं चुना है।';

  @override
  String get voice_bind_failed =>
      'आवाज बाइंड करने में विफल, कृपया API सीमा या नेटवर्क स्थिति जांचें';

  @override
  String voice_bind_success(String name) {
    return '\"$name\" की रूहानी आवाज आधिकारिक तौर पर बाइंड हो गई है!';
  }

  @override
  String get voice_bind_success_draft =>
      'आवाज सफलतापूर्वक बाइंड हो गई! अब आप भावनाओं का परीक्षण करने के लिए स्लाइडर खींच सकते हैं!';

  @override
  String sync_failed(String error) {
    return 'सिंक विफल, नेटवर्क जांचें: $error';
  }

  @override
  String edit_character_title(String name) {
    return '$name को संपादित करें';
  }

  @override
  String get test_mode_tooltip => 'पूर्ण कार्यक्षमता परीक्षण';

  @override
  String get test_mode_error =>
      '⚠️ पात्र फ़ाइल नहीं मिली! परीक्षण से पहले कृपया नीचे दिए गए \"सहेजें/प्रकाशित करें\" पर क्लिक करें!';

  @override
  String get test_mode_notice =>
      '💡 परीक्षण मोड में प्रत्येक मोड की मूल कीमत के अनुसार अंक काटे जाएंगे, और यह आधिकारिक यादों में नहीं गिना जाएगा!';

  @override
  String get delete_character_tooltip => 'पात्र हटाएं';

  @override
  String get tab_basic_story => 'मूल और कहानी';

  @override
  String get tab_voice => 'विशेष आवाज';

  @override
  String get tab_relationship => 'सामाजिक संबंध';

  @override
  String get save_changes_button => 'परिवर्तन सहेजें';

  @override
  String get section_basic_info => 'मूल जानकारी';

  @override
  String get hint_occupation =>
      'एकाधिक पहचान का समर्थन करता है, कृपया स्लैश या अल्पविराम से अलग करें (जैसे: छात्र/हैकर)';

  @override
  String get hint_appearance =>
      'जैसे: लंबे चांदी के बाल, एम्बर आंखें, हमेशा सफेद कोट पहनता है...';

  @override
  String get section_story_identity => '🎭 कहानी और आपकी पहचान';

  @override
  String get story_identity_desc =>
      'कहानी की शुरुआत और इस सेव फ़ाइल में \"आपकी\" विशेष सेटिंग्स परिभाषित करें';

  @override
  String get advanced_writing_tips_title => '💡 उन्नत लेखन युक्तियाँ:\n';

  @override
  String get advanced_writing_tips_1 => 'कहानी या संवाद में ';

  @override
  String get advanced_writing_tips_2 => '(खिलाड़ी का नाम)';

  @override
  String get advanced_writing_tips_3 =>
      ' दर्ज करें, खेलते समय सिस्टम इसे खिलाड़ी के वास्तविक उपनाम से बदल देगा!\n';

  @override
  String get advanced_writing_tips_4 => 'उदाहरण: \"';

  @override
  String get advanced_writing_tips_5 => '(खिलाड़ी का नाम)';

  @override
  String get advanced_writing_tips_6 => ', तुम इतनी देर से क्यों आए?\"';

  @override
  String get player_identity_label =>
      'खिलाड़ी की डिफ़ॉल्ट पहचान (Player Identity) - 💡 वैकल्पिक';

  @override
  String get player_identity_hint =>
      '【वैकल्पिक】यदि खाली छोड़ा जाता है, तो AI बातचीत के लिए आपकी \"प्रोफ़ाइल\" पढ़ेगा।\nयदि भरा जाता है, तो एक विशिष्ट पहचान निभाने के लिए मजबूर करेगा (जैसे: उसका कठोर सिस्टम, या धोखा खाई हुई पत्नी)।';

  @override
  String get background_label => 'पात्र की पृष्ठभूमि और विश्वदृष्टि';

  @override
  String get background_hint =>
      'उसके अतीत और विश्वदृष्टि का वर्णन करें (जैसे: आधुनिक शहर, ABO, सर्वनाश)। उदाहरण: यह लाशों से भरी दुनिया है, और वह आपकी रक्षा करने वाला विशेष सैनिक है...';

  @override
  String get story_summary_label => 'एक वाक्य में कहानी का परिचय';

  @override
  String get story_initial_label => 'पहली मुलाकात की कहानी';

  @override
  String get story_initial_hint =>
      'जैसे: आप दरवाजा खोलते हैं और उसे खिड़की के पास बैठे देखते हैं। वह मुड़कर कहता है: \"(खिलाड़ी का नाम), इधर आओ।\"...';

  @override
  String get first_line_label => 'पात्र की पहली बात';

  @override
  String get first_line_hint => 'जैसे: (खिलाड़ी का नाम), तुम आखिरकार आ ही गए।';

  @override
  String get section_personality_evo => '🌟 व्यक्तित्व और आत्मीयता का विकास';

  @override
  String get detailed_personality_label => 'विस्तृत व्यक्तित्व';

  @override
  String get detailed_personality_hint =>
      'उसके मुख्य स्वभाव का वर्णन करें। जैसे: सुंदरे, ऊपर से सख्त अंदर से कोमल। अजनबियों के लिए ठंडा, केवल खिलाड़ी के लिए मुस्कान।';

  @override
  String get affection_evo_desc =>
      'AI इन सेटिंग्स के आधार पर तय करेगा कि आत्मीयता कब बढ़ानी है:';

  @override
  String get stage_1_label => 'चरण 1: अजनबी/सतर्क (Lv1)';

  @override
  String get stage_1_hint =>
      'पहली बार मिलने पर प्रतिक्रिया। आत्मीयता की शर्तें (जैसे: विनम्रता, निजता में दखल न देना)।';

  @override
  String get stage_2_label => 'चरण 2: परिचित/मित्र (Lv2)';

  @override
  String get stage_2_hint =>
      'परिचित होने के बाद बदलाव। आत्मीयता की शर्तें (जैसे: मिठाई बांटना, बिल्लियों के बारे में बात करना)।';

  @override
  String get stage_3_label => 'चरण 3: घनिष्ठ/प्रेमी (Lv3)';

  @override
  String get stage_3_hint =>
      'पूरी तरह से प्यार में पड़ने के बाद प्रतिक्रिया। क्या वह ईर्ष्या करेगा? या चुपचाप उदास हो जाएगा?';

  @override
  String get social_interaction_label => 'सामाजिक और पर्यावरणीय बातचीत';

  @override
  String get social_interaction_hint =>
      'जैसे: राहगीरों के साथ कैसा व्यवहार करता है? अपनी नापसंद चीजों का सामना करने पर कैसे प्रतिक्रिया देता है?';

  @override
  String get section_habits => '🗣️ पसंद और आदतें';

  @override
  String get tone_hint_detail =>
      'अनिवार्य। जैसे: संक्षेप में बात करता है, प्रश्न पूछना पसंद करता है। तकियाकलाम है \"बेवकूफ\"। अनुवादित लहजे का प्रयोग वर्जित है।';

  @override
  String get dialogue_example_hint =>
      'खिलाड़ी: मैं बहुत थक गया हूँ।\nपात्र: (सिर सहलाते हुए) अच्छे बच्चे बनो, जाओ और आराम करो।';

  @override
  String get section_easter_eggs => '🎁 गुप्त ईस्टर एग्स और विशेष कहानी';

  @override
  String get no_easter_eggs =>
      'अभी तक कोई ईस्टर एग सेट नहीं किया गया है, जोड़ने के लिए नीचे दिए गए बटन पर क्लिक करें';

  @override
  String get no_scene_change => 'दृश्य न बदलें';

  @override
  String get add_easter_egg_button => 'नया गुप्त ईस्टर एग जोड़ें';

  @override
  String get other_extra_info => 'अन्य पूरक जानकारी';

  @override
  String get visibility_label => 'पात्र की दृश्यता';

  @override
  String get visibility_public => 'सार्वजनिक';

  @override
  String get visibility_private => 'निजी';

  @override
  String get section_voice_gen => '🎙️ उसकी विशेष आवाज बनाना';

  @override
  String get voice_gen_desc =>
      'संकेत शब्द दर्ज करें, ताकि उसके पास दुनिया की सबसे अनोखी आवाज हो!\n(💡 सुझाव: यदि बनाने के बाद पसंद न आए, तो आप किसी भी समय फिर से बना सकते हैं!)';

  @override
  String get voice_generating_status => 'आवाज तैयार की जा रही है...';

  @override
  String get voice_select_prompt =>
      '✨ मैंने आपके लिए तीन प्रकार की आवाजें तैयार की हैं, कृपया चुनें:';

  @override
  String voice_sample_name(int index) {
    return 'आवाज का नमूना $index';
  }

  @override
  String get voice_sample_desc =>
      'चुनने के लिए कार्ड पर क्लिक करें, सुनने के लिए दाईं ओर क्लिक करें';

  @override
  String get voice_preparing => 'आवाज अभी भी तैयार हो रही है...';

  @override
  String get voice_retry => 'छोड़ें और पुनः प्रयास करें';

  @override
  String get voice_confirm_selection => 'मैंने तुम्हें चुना!';

  @override
  String get voice_bind_success_banner => 'विशेष आवाज सफलतापूर्वक बाइंड हो गई!';

  @override
  String get voice_remake => 'आवाज फिर से बनाएं';

  @override
  String get voice_btn_generating => 'बन रहा है, कृपया प्रतीक्षा करें...';

  @override
  String get voice_btn_generate =>
      'विशेष आवाज बनाने के लिए संकेत शब्द दर्ज करें';

  @override
  String get voice_advanced_tuning =>
      '🎛️ उन्नत: बोलने की भावना को नियंत्रित करें';

  @override
  String get voice_stability_low => 'जंगली/सांसों की आवाज 🐺';

  @override
  String voice_stability_value(String value) {
    return 'तर्कसंगतता: $value';
  }

  @override
  String get voice_stability_high => 'स्थिर/शांत 🤖';

  @override
  String get voice_style_low => 'ठंडा/दबा हुआ 🧊';

  @override
  String voice_style_value(String value) {
    return 'नाटकीय प्रदर्शन: $value';
  }

  @override
  String get voice_style_high => 'अतिरंजित/भावुक 🔥';

  @override
  String get voice_test_btn_testing => 'भावना लागू की जा रही है...';

  @override
  String get voice_test_btn => 'वर्तमान भावना को सुनें';

  @override
  String get section_social_circle => '👥 उसका सामाजिक दायरा';

  @override
  String get social_circle_desc =>
      'अन्य पात्रों पर उसके विचार सेट करें। जब खिलाड़ी बातचीत में उनका उल्लेख करेगा, तो वह यहाँ की सेटिंग्स के आधार पर प्रतिक्रिया देगा (जैसे: ईर्ष्या, क्रोध)।';

  @override
  String get social_no_drama =>
      'फिलहाल अन्य पात्रों के साथ कोई विवाद नहीं है...';

  @override
  String social_target(String name) {
    return 'लक्ष्य: $name';
  }

  @override
  String social_attitude(String attitude) {
    return 'विचार: $attitude';
  }

  @override
  String social_edit_title(String name) {
    return '$name के बारे में विचार संपादित करें 💬';
  }

  @override
  String get social_attitude_label => 'उसके विचार / दृष्टिकोण';

  @override
  String get social_attitude_hint =>
      'जैसे: उसे बहुत परेशान करने वाला मानता है, लेकिन वास्तव में उस पर निर्भर है...';

  @override
  String get social_save_changes => 'परिवर्तन सहेजें';

  @override
  String get social_add_title => 'पात्र संबंध जोड़ें 🤝';

  @override
  String get social_select_target => 'लक्ष्य चुनें';

  @override
  String get social_thoughts_label => 'इस व्यक्ति के बारे में उसके विचार...';

  @override
  String get social_thoughts_hint => 'जैसे: वह पियानोवादक बहुत शोर करता है...';

  @override
  String get social_add_confirm => 'जोड़ने की पुष्टि करें';

  @override
  String get gallery_load_failed =>
      'छवि लोड करने में विफल 🥲\nकृपया सुनिश्चित करें कि नेटवर्क सामान्य है। यदि वेब पर है, तो कंसोल देखें।';

  @override
  String gallery_affection_req(int level) {
    return 'आत्मीयता $level';
  }

  @override
  String get gallery_upload_limit => 'अधिकतम 10 चित्र ही अपलोड किए जा सकते हैं';

  @override
  String get gallery_photo_setup => 'तस्वीर अनलॉक करने की शर्तें सेट करें';

  @override
  String get gallery_photo_desc_label => 'यह तस्वीर क्या है?';

  @override
  String get gallery_photo_desc_hint => 'जैसे: पजामे में तस्वीर, डेट की तस्वीर';

  @override
  String get gallery_photo_req_label =>
      'अनलॉक करने के लिए कितनी आत्मीयता चाहिए?';

  @override
  String get gallery_photo_req_hint => 'संख्या दर्ज करें, 0 का मतलब मुफ़्त है';

  @override
  String get gallery_cancel_upload => 'अपलोड रद्द करें';

  @override
  String get gallery_confirm_add => 'जोड़ने की पुष्टि करें';

  @override
  String get default_photo_desc => 'विशेष तस्वीर';

  @override
  String get draft_photo_desc => 'ड्राफ्ट तस्वीर';

  @override
  String get loading_text => 'लोड हो रहा है...';

  @override
  String get default_unnamed_character => 'अनाम पात्र';

  @override
  String elevenlabs_error(String code) {
    return 'ElevenLabs त्रुटि: $code';
  }

  @override
  String get voice_sample_script =>
      '(गला साफ़ करते हुए) नमस्ते। यह मेरे लिए एक विशेष वॉयस टेस्ट है। आने वाले दिनों में, मैं यहाँ तुम्हारे साथ रहूँगा। चाहे तुम खुश हो या उदास, तुम मुझसे साझा कर सकते हो। क्या तुम्हें मेरी बोलने की गति और आवाज़ पसंद आ रही है? यदि तुम्हें यह अच्छा लगे, तो चलो इसे मेरी विशेष आवाज़ के रूप में तय कर लेते हैं। हमारे भविष्य के हर दिन का इंतज़ार रहेगा।';

  @override
  String get voice_test_script =>
      'क्या तुम सच में जानते हो कि हर बार जब मैं तुम्हें देखता हूँ, तो मेरे दिल में क्या चल रहा होता है? ... सच में तुम्हारा कोई इलाज नहीं है।';

  @override
  String get field_background => 'पात्र की पृष्ठभूमि';

  @override
  String get field_tone => 'लहजा और आदतें';

  @override
  String get field_initial_story => 'प्रारंभिक कहानी';

  @override
  String get update_action => 'अपडेट';

  @override
  String get default_new_player => 'नया खिलाड़ी';

  @override
  String get translating_status => 'अनुवाद हो रहा है...';

  @override
  String get translate_profile_btn => 'प्रोफ़ाइल सामग्री का अनुवाद करें';

  @override
  String translate_failed(String error) {
    return 'अनुवाद विफल रहा: $error';
  }

  @override
  String get like_own_char_warning =>
      'आप अपने द्वारा बनाए गए पात्र को लाइक नहीं कर सकते! 🤭';

  @override
  String get like_success_msg => 'लाइक भेज दिया गया! निर्माता बहुत खुश होगा💖';

  @override
  String get unlike_success_msg => 'लाइक वापस ले लिया गया 💔';

  @override
  String get like_label => 'लाइक';

  @override
  String get dislike_label => 'नापसंद';

  @override
  String get block_char => 'इस पात्र को ब्लॉक करें';

  @override
  String get char_blocked_msg => 'इस पात्र को ब्लॉक कर दिया गया है।';

  @override
  String get dislike_dialog_title => 'यह पात्र पसंद नहीं आया?';

  @override
  String get dislike_dialog_subtitle =>
      'कृपया हमें चुपके से कारण बताएं, हम इसकी समीक्षा करेंगे:';

  @override
  String get dislike_hint =>
      'सेटिंग्स बहुत उबाऊ हैं, चित्र उपयुक्त नहीं हैं...';

  @override
  String get dislike_thanks =>
      'आपकी प्रतिक्रिया के लिए धन्यवाद! हमें आपका गुप्त संदेश मिल गया है।';

  @override
  String get dislike_submit => 'गुप्त रूप से भेजें';

  @override
  String get report_title => '📢 कमेंट की रिपोर्ट करें';

  @override
  String get report_subtitle =>
      'रिपोर्ट का कारण चुनें:\nरिपोर्ट के बाद हम जल्द ही सामग्री की समीक्षा करेंगे।';

  @override
  String get report_opt_1 => 'अश्लील या हिंसक सामग्री';

  @override
  String get report_opt_2 => 'पात्र की बदनामी, अपमान या हमला';

  @override
  String get report_opt_3 => 'नफरत फैलाने वाला भाषण या व्यक्तिगत हमला';

  @override
  String get report_opt_4 => 'स्पैम या विज्ञापन धोखाधड़ी';

  @override
  String get report_opt_5 => 'अन्य अनुचित सामग्री';

  @override
  String get report_confirm => 'रिपोर्ट की पुष्टि करें';

  @override
  String get report_success =>
      'रिपोर्ट सफल रही, सूचना मिल गई है! जल्द ही समीक्षा की जाएगी 🛡️';

  @override
  String get report_failed =>
      'रिपोर्ट विफल रही, कृपया अपना नेटवर्क कनेक्शन जांचें।';

  @override
  String get lore_delete_title => '⚠️ चेतावनी: यादें मिटाना';

  @override
  String get lore_delete_content =>
      'एक बार मिटा दिए जाने के बाद यह याद पूरी तरह से गायब हो जाएगी, क्या आप वाकई इसे मिटाना चाहते हैं?';

  @override
  String get lore_delete_cancel => 'गलती से दब गया';

  @override
  String get lore_delete_confirm => 'मिटाने की पुष्टि करें';

  @override
  String get lore_delete_success =>
      '🗑️ यादों के टुकड़े पूरी तरह मिटा दिए गए हैं।';

  @override
  String get lore_add_title => 'नई याद लिखें 🖋️';

  @override
  String get lore_edit_title => 'यादों के टुकड़े को संपादित करें 🖋️';

  @override
  String get lore_title_label => 'यादों का शीर्षक';

  @override
  String get lore_title_hint => 'उदाहरण: पहली मुलाकात का बरसाती दिन';

  @override
  String get lore_teaser_label => 'सारांश / परिचय';

  @override
  String get lore_teaser_hint => 'कार्ड पर प्रदर्शित संक्षिप्त विवरण...';

  @override
  String get lore_content_label => 'यादों की पूरी सामग्री';

  @override
  String get lore_content_hint => 'यह विस्तृत कहानी या सेटिंग्स यहाँ लिखें...';

  @override
  String get lore_lock_label => '🔒 इस याद को सील करें';

  @override
  String get lore_lock_desc =>
      'चेक करने के बाद, इसे केवल निर्माता देख सकता है, खिलाड़ी नहीं देख पाएंगे';

  @override
  String get lore_empty_error => 'शीर्षक और सामग्री खाली नहीं हो सकते!';

  @override
  String get lore_add_success => '✨ नई याद सफलतापूर्वक सील कर दी गई है!';

  @override
  String get lore_publish => 'यादें प्रकाशित करें';

  @override
  String get lore_save_edit => 'परिवर्तन सहेजें';

  @override
  String lore_write_first(Object pronoun) {
    return '$pronoun के लिए पहली याद लिखें!';
  }

  @override
  String lore_waiting(Object pronoun) {
    return '$pronoun के साथ कहानी का इंतज़ार...';
  }

  @override
  String get lore_sealed_msg =>
      '🔒 यह याद सील कर दी गई है और वर्तमान में उपलब्ध नहीं है।';

  @override
  String get lore_not_open_msg => 'यह याद अभी जनता के लिए खुली नहीं है...';

  @override
  String get lore_unnamed => 'बिना नाम का टुकड़ा';

  @override
  String get lore_add_btn_limit => 'यादों का नया टुकड़ा लिखें (अधिकतम 10)';

  @override
  String get lore_collapse => 'पत्र समेटें';

  @override
  String get echo_delete_title => '🗑️ कमेंट हटाएं';

  @override
  String get echo_delete_content =>
      'क्या आप वाकई इस \'टाइम इको\' को हटाना चाहते हैं?\nहटाने के बाद इसे कभी वापस नहीं पाया जा सकेगा!';

  @override
  String get echo_keep => 'रखें';

  @override
  String get echo_clear_success => 'टाइम इको साफ कर दिया गया 🧹';

  @override
  String get echo_energy_full_title =>
      '⚠️ ब्रह्मांडीय ऊर्जा सीमा तक पहुँच गई है';

  @override
  String get echo_energy_full_content =>
      'आपकी समय ऊर्जा सीमा तक पहुँच गई है (अधिकतम 3), कृपया अपने पुराने अनुभव हटाएं ताकि आप नए ब्रह्मांडीय रिकॉर्ड खोल सकें!';

  @override
  String get echo_write_title => 'अपना टाइम इको छोड़ें 🌌';

  @override
  String get echo_write_subtitle =>
      'अपने अनुभव या दिल को छू लेने वाले विचार यहाँ लिखें!';

  @override
  String get echo_hint =>
      '「चाहे दुनिया का अंत ही क्यों न हो जाए, मैं तुम्हारी सांसों को प्राथमिकता दूँगा...」';

  @override
  String get echo_theme_label => 'नोट का बॉर्डर चुनें:';

  @override
  String get theme_butterfly => 'तितली';

  @override
  String get theme_sprout => 'अंकुर';

  @override
  String get theme_star => 'तारों भरा आसमान';

  @override
  String get theme_planet => 'ग्रह';

  @override
  String get echo_publish_btn => 'समय रिकॉर्ड प्रकाशित करें';

  @override
  String get echo_wall_title => 'टाइम इको वॉल';

  @override
  String get echo_leave_memory => 'अनुभव साझा करें';

  @override
  String get echo_empty_msg =>
      'अभी तक किसी समय यात्री ने कोई रिकॉर्ड नहीं छोड़ा है...\nक्या आप पहले बनना चाहते हैं?';

  @override
  String get creator_label => 'निर्माता';

  @override
  String get follow_btn => 'फॉलो करें';

  @override
  String get followed_btn => 'फॉलो किया गया';

  @override
  String get follow_own_warning => 'निर्माता खुद को फॉलो नहीं कर सकते! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName ने $creatorName को फॉलो किया!';
  }

  @override
  String get mailbox_follow_title => 'नया रक्षक मिला 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName ने अभी आपको फॉलो किया है!';
  }

  @override
  String get tab_private_profile => 'निजी प्रोफ़ाइल';

  @override
  String get tab_memory_fragments => 'यादों के टुकड़े';

  @override
  String get tab_time_echoes => 'टाइम इको';

  @override
  String get chat_free_btn => 'बातचीत (मुफ्त)';

  @override
  String get start_story_btn => 'कहानी शुरू करें';

  @override
  String get default_chat_initial => 'क्या आपको मुझसे कुछ काम है?';

  @override
  String get gallery_title => 'विशेष कॉल बैकग्राउंड';

  @override
  String gallery_current_affection(String value) {
    return 'वर्तमान आत्मीयता: $value 💕';
  }

  @override
  String get gallery_empty => 'एल्बम में अभी कोई फोटो नहीं है';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'बैकग्राउंड को \"$desc\" पर सेट किया गया है!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'अनलॉक करने के लिए $value आत्मीयता स्तर तक पहुँचें! 🍃';
  }

  @override
  String get gallery_reset_bg => 'डिफ़ॉल्ट कॉल बैकग्राउंड रिस्टोर किया गया';

  @override
  String get background_story_title => 'बैकग्राउंड कहानी';

  @override
  String get background_story_empty =>
      'यह पात्र रहस्यमय है, अभी तक कोई बैकग्राउंड कहानी नहीं है...';

  @override
  String followed_creator_msg(String creatorName) {
    return '$creatorName को फॉलो किया गया 🦋';
  }

  @override
  String get mailbox_title => 'विशेष मेलबॉक्स 💌';

  @override
  String get mailbox_empty =>
      'मेलबॉक्स खाली है, उसे आकर्षित करने के लिए कुछ पोस्ट करें!';

  @override
  String get new_notification => 'नई सूचना';

  @override
  String get default_he => 'वह';

  @override
  String affection_upgrade_title(String charName) {
    return 'तुम्हारे लिए $charName की आत्मीयता बढ़ गई है! 💖';
  }

  @override
  String get flower_reward => '🌸 5 फूल अंक प्राप्त हुए';

  @override
  String get affection_quote_lv5 =>
      '「मैंने सोचा नहीं था... कि तुम मेरे लिए इतनी महत्वपूर्ण हो जाओगी। इतनी महत्वपूर्ण कि... मैं तुम्हारे बिना दुनिया की कल्पना भी नहीं कर सकता।」';

  @override
  String get affection_quote_lv4 =>
      '「मेरी ज़िंदगी की सबसे खुशकिस्मती शायद वही दिन था, जब मैंने मुड़कर तुम्हें देखा था।」';

  @override
  String get affection_quote_lv3 =>
      '「हाल ही में... मैंने गौर किया है कि मैं ज़्यादा खोया-खोया रहता हूँ, और मेरे दिमाग में सिर्फ़ तुम ही रहती हो।」';

  @override
  String get affection_quote_lv2 =>
      '「चूँकि यह तुम्हारा आमंत्रण है, तो मैं थोड़ा समय निकाल ही सकता हूँ, ऐसा भी नहीं कि नहीं हो सकता।」';

  @override
  String get affection_quote_lv1 =>
      '「आजकल तुम्हें अक्सर देखता हूँ, मुझे लगता है... मुझे मिलने की यह आवृत्ति बुरी नहीं लगती।」';

  @override
  String get affection_quote_lv0 =>
      '「तो तुम भी यहाँ हो, क्या यह एक तरह का अनोखा इत्तफ़ाक़ है?」';

  @override
  String get lore_edit_success =>
      '✨ यादों का टुकड़ा सफलतापूर्वक अपडेट किया गया!';

  @override
  String get delete_failed_network =>
      'हटाना विफल रहा, कृपया नेटवर्क या अनुमतियाँ जाँचें।';

  @override
  String get ai_chat_language => 'हिन्दी';

  @override
  String get ai_chat_language_code => 'hi-IN';

  @override
  String get chat_home_title => 'संदेश';

  @override
  String get call_memory_tooltip => 'कॉल यादें';

  @override
  String get login_to_view_chat => 'चैट इतिहास देखने के लिए कृपया लॉगिन करें';

  @override
  String load_chat_failed(String error) {
    return 'चैट सूची लोड करने में विफल: $error';
  }

  @override
  String get chat_list_empty => 'चैट रूम खाली है...';

  @override
  String get go_to_encounter => 'किसी से बात करने के लिए \"एनकाउंटर\" पर जाएं!';

  @override
  String confirm_delete_chat(String charName) {
    return 'क्या आप $charName के साथ बातचीत हटाना चाहते हैं?';
  }

  @override
  String affection_score_short(String score) {
    return 'आत्मीयता $score';
  }

  @override
  String get character_not_found =>
      'पात्र डेटा लोड करने में असमर्थ, वह हटाया जा चुका हो सकता है।';

  @override
  String get preparing_chat_room =>
      'आपके लिए विशेष चैट रूम तैयार किया जा रहा है...';

  @override
  String get rename_chat_title => 'इस स्मृति को नाम दें';

  @override
  String get rename_chat_hint =>
      'उदाहरण: (चेंग यू) से (तलाक उलटी गिनती) में बदलें';

  @override
  String get save_tag_btn => 'टैग सहेजें';

  @override
  String get room_name_updated => 'कमरे का नाम अपडेट किया गया!';

  @override
  String update_failed(String error) {
    return 'अपडेट विफल: $error';
  }

  @override
  String get chat_mode_daily => 'दैनिक';

  @override
  String get chat_mode_story => 'कहानी';

  @override
  String get chat_mode_immersive => 'इमर्सिव';

  @override
  String get chat_mode_gemini => 'बातचीत';

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
      'पात्र डेटा नहीं मिला, कृपया वापस जाएं और पुनः प्रयास करें या अपना नेटवर्क जांचें।';

  @override
  String get chat_jump_success => 'इस स्मृति पर पहुंच गए 🍃';

  @override
  String get chat_create_room_failed =>
      'कनेक्शन अस्थिर लग रहा है, चैट रूम बनाने में विफल, कृपया पुनः प्रयास करें।';

  @override
  String get chat_secret_file_title => '🔒 गोपनीय फ़ाइल';

  @override
  String get chat_secret_file_desc =>
      'इस पात्र की सोल फ़ाइल को आर्काइव कर दिया गया है या निजी कर दिया गया है, वर्तमान में विवरण उपलब्ध नहीं हैं।';

  @override
  String get chat_understood => 'समझ गया';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ नई स्मृति प्राप्त हुई: $title';
  }

  @override
  String get chat_egg_saved =>
      'स्वचालित रूप से आपके विशेष बैकपैक में जोड़ा गया';

  @override
  String get chat_points_not_enough_title => 'फूल कम हैं';

  @override
  String get chat_points_not_enough_desc =>
      'आपके पास पर्याप्त फूल नहीं हैं! कृपया टॉप अप करने के लिए दुकान पर जाएं।';

  @override
  String chat_call_confirm_title(String name) {
    return 'क्या $name को कॉल करना है?';
  }

  @override
  String get chat_call_rule_1 => 'प्रत्येक कॉल के लिए 20 फूल काटे जाएंगे';

  @override
  String get chat_call_rule_2 =>
      'कॉल की अवधि एक मिनट है, यदि बोलना सुविधाजनक न हो तो टेक्स्ट के माध्यम से संवाद कर सकते हैं';

  @override
  String get chat_call_rule_3 =>
      'हेडफ़ोन पहनने की सलाह दी जाती है ताकि उसकी आवाज़ साफ़ सुनी जा सके ✨';

  @override
  String get chat_call_btn_cancel => 'अभी नहीं';

  @override
  String get chat_call_pref_title => 'अपनी कॉल प्राथमिकताएं सेट करें';

  @override
  String get chat_call_lang_select => 'कॉल की भाषा चुनें';

  @override
  String get chat_call_save_memory => 'इस कॉल की स्मृति को सहेजें';

  @override
  String get chat_call_save_memory_desc =>
      'कॉल समाप्त होने के बाद इसे पुनः सुन सकते हैं';

  @override
  String get chat_call_btn_start => 'कॉल शुरू करें';

  @override
  String chat_points_shortage(String points) {
    return 'फूल अंक पर्याप्त नहीं हैं! वर्तमान में $points अंक हैं';
  }

  @override
  String get chat_room_not_ready =>
      'चैट रूम अभी तैयार नहीं है, कृपया पुनः प्रवेश करें।';

  @override
  String get chat_stop_generating_msg =>
      'जवाब रोक दिया गया है, कोई अंक नहीं काटे गए 🍃';

  @override
  String get chat_heartbeat_up => 'उसका दिल तेज़ धड़क रहा है...';

  @override
  String get chat_heartbeat_down => 'उसकी नज़रें ठंडी हो गईं...';

  @override
  String get chat_msg_copy => 'सामग्री कॉपी करें';

  @override
  String get chat_msg_copied => 'क्लिपबोर्ड पर कॉपी किया गया!';

  @override
  String get chat_msg_report => 'इस संदेश की रिपोर्ट करें';

  @override
  String get chat_msg_suggest => 'सुझाव दें';

  @override
  String get chat_report_title => 'इस बातचीत की रिपोर्ट करें';

  @override
  String get chat_report_lang => 'विदेशी भाषा दिखाई दी';

  @override
  String get chat_report_inapp => 'अनुचित प्रतिक्रिया';

  @override
  String get chat_report_context => 'संदर्भ जुड़ा हुआ नहीं है';

  @override
  String get chat_report_other => 'अन्य कारण';

  @override
  String get chat_report_hint => 'कृपया आपको जो समस्या हुई उसका वर्णन करें...';

  @override
  String get chat_report_submit => 'भेजें';

  @override
  String get chat_report_success =>
      '✅ रिपोर्ट भेज दी गई है, हम जल्द ही इसमें सुधार करेंगे';

  @override
  String get chat_suggest_title => 'सुझाव दें';

  @override
  String get chat_suggest_hint => 'कृपया अपनी बहुमूल्य राय लिखें...';

  @override
  String get chat_suggest_success =>
      '💖 आपके सुझाव के लिए धन्यवाद, हम जल्द ही इस पर काम करेंगे';

  @override
  String get chat_del_warn =>
      'संदेश हटाने के बाद पुनः प्राप्त नहीं किए जा सकेंगे।';

  @override
  String get chat_reset_title => 'स्मृति रीसेट करें';

  @override
  String get chat_reset_desc =>
      'कृपया रीसेट का स्तर चुनें:\n\n1. 【केवल चैट】: चैट इतिहास साफ़ करें, लेकिन आत्मीयता बनाए रखें।\n2. 【पूर्ण रीसेट】: सब कुछ शून्य पर वापस, पहली मुलाकात की तरह।';

  @override
  String get chat_reset_only_chat => 'केवल चैट इतिहास';

  @override
  String get chat_reset_full => 'पूर्ण रीसेट';

  @override
  String get chat_reset_full_msg =>
      'सब कुछ शुरुआत में लौट आया है, वह अब आपको याद नहीं रखता...';

  @override
  String get chat_reset_chat_msg =>
      'चैट खाली कर दी गई है, लेकिन आपके प्रति उसका प्रेम अभी भी बना हुआ है।';

  @override
  String get chat_edit_ai_hint => 'उसके जवाब को संपादित करें...';

  @override
  String get chat_edit_user_hint => 'कृपया नई सामग्री दर्ज करें...';

  @override
  String chat_no_voice_msg(String name) {
    return 'फिलहाल $name की कोई आवाज़ नहीं है...';
  }

  @override
  String get chat_poke_btn => 'पोक करें';

  @override
  String get chat_poke_success =>
      '✨ आपके लिए क्रिएटर को पोक कर दिया गया है! कृपया उसकी आवाज़ ऑनलाइन आने की प्रतीक्षा करें~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'फूल अंक पर्याप्त नहीं हैं! $cost अंक चाहिए 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ किस्मत का साथी ✨';

  @override
  String get chat_levelup_normal => 'रिश्ता अपग्रेड हुआ! 💖';

  @override
  String get chat_levelup_btn_soulmate => 'आत्मा में अंकित करें';

  @override
  String get chat_levelup_btn_normal => 'दिल की धड़कन के साथ स्वीकारें';

  @override
  String get chat_loc_title => '📍 वर्चुअल लोकेशन भेजें';

  @override
  String get chat_loc_custom_btn => 'कस्टम लोकेशन भेजें';

  @override
  String get chat_loc_hint =>
      'अन्य स्थान दर्ज करें... (जैसे: तुम्हारे दिल में)';

  @override
  String get chat_loc_1 => 'तुम्हारे घर के नीचे';

  @override
  String get chat_loc_2 => 'स्कूल में';

  @override
  String get chat_loc_3 => 'उस कैफे में जहाँ से हम अभी गुज़रे';

  @override
  String get chat_loc_4 => 'सुविधा स्टोर में';

  @override
  String get chat_interact_title => '✨ उसके साथ क्या करना चाहती हैं?';

  @override
  String get chat_interact_action => 'पोक और छोटी हरकतें';

  @override
  String get chat_interact_gift => 'उसे छोटा उपहार भेजें (फूलों की खपत 🌸)';

  @override
  String get chat_action_poke => 'गालों को पोक करें';

  @override
  String get chat_action_hug => 'गले मिलना';

  @override
  String get chat_action_hand => 'चुपके से हाथ पकड़ना';

  @override
  String get chat_dice_btn => 'पासा फेंकें';

  @override
  String get chat_loading_failed =>
      'स्मृति लोड करने में विफल, कृपया वापस जाएं और पुनः प्रयास करें।';

  @override
  String get chat_test_mode_msg =>
      'टेस्ट मोड चालू है, खुलकर चैट करें! (बातचीत सहेजी नहीं जाएगी)';

  @override
  String get chat_empty_msg => 'उसके साथ एक रोमांचक यात्रा शुरू करें!';

  @override
  String get chat_ai_typing => 'सामने वाला जवाब दे रहा है...';

  @override
  String get chat_input_hint_default => 'उसे क्या कहना चाहती हैं...';

  @override
  String get chat_typing_indicator => 'टाइपिंग जारी है...';

  @override
  String get chat_menu_search => 'बातचीत खोजें';

  @override
  String get chat_menu_gallery => 'विशेष यादें और बैकग्राउंड';

  @override
  String get chat_menu_aboutme => 'मुझसे संबंधित';

  @override
  String get chat_menu_memo => 'उसके लिए मेमो';

  @override
  String get chat_menu_period => 'पीरियड ट्रैकर';

  @override
  String get chat_menu_reset => 'स्मृति रीसेट करें';

  @override
  String get chat_search_hint => 'कौन सी मीठी बातचीत को फिर से जीना चाहती हैं?';

  @override
  String get chat_search_empty => 'यह स्मृति नहीं मिली 🥺';

  @override
  String get chat_search_you => 'आपने कहा';

  @override
  String get chat_search_him => 'उसने कहा';

  @override
  String get chat_tool_backpack => 'बैकपैक';

  @override
  String get chat_tool_story => 'कहानी का सारांश';

  @override
  String get chat_tool_photo => 'तस्वीरें';

  @override
  String get chat_tool_record => 'रिकॉर्डिंग';

  @override
  String get chat_tool_profile => 'शियुगुआंग फ़ाइलें';

  @override
  String get chat_tool_interact => 'इंटरैक्टिव गेमप्ले';

  @override
  String get chat_record_recording => 'रिकॉर्डिंग जारी है...';

  @override
  String get chat_record_start =>
      'रिकॉर्डिंग शुरू करने के लिए माइक पर क्लिक करें';

  @override
  String get chat_record_done => 'रिकॉर्डिंग पूर्ण';

  @override
  String get chat_mode_daily_desc =>
      'दोस्तों की तरह हल्की-फुल्की और सुखद दैनिक बातचीत!';

  @override
  String get chat_mode_story_desc => 'उपन्यास की तरह कहानी आगे बढ़ाना।';

  @override
  String get chat_mode_immersive_desc =>
      'अंतिम संवेดี अनुभव, बिना किसी बंधन के गहरा जुड़ाव।';

  @override
  String get chat_switch_mode_title => 'चैट मोड बदलें';

  @override
  String get chat_voice_call => 'वॉयस कॉल';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【सिस्टम इवेंट】$playerName ने एक 【$giftName】 भेजा।';
  }

  @override
  String get rel_title_soulmate => 'किस्मत का साथी/गहरा प्यार';

  @override
  String get rel_title_lover => 'जोशीला प्यार/एक्सक्लूसिव बॉयफ्रेंड';

  @override
  String get rel_title_ambiguous => 'अस्पष्ट अवस्था/एक-दूसरे को समझना';

  @override
  String get rel_title_friend => 'सामान्य दोस्त/स्नेह की शुरुआत';

  @override
  String get rel_title_acquaintance => 'जान-पहचान/थोड़ा परिचित';

  @override
  String get rel_title_stranger => 'अजनबी/पहली मुलाकात';

  @override
  String get rel_title_tense => 'तनावपूर्ण रिश्ता/नाराज़गी';

  @override
  String get rel_title_avoiding => 'अजनबियों की तरह/जानबूझकर बचना';

  @override
  String get rel_title_hostile => 'अत्यधिक नफरत/ठंडी दुश्मनी';

  @override
  String get rel_title_nemesis => 'कट्टर दुश्मन/कभी न मिलना';

  @override
  String get rel_msg_soulmate =>
      '「मैंने सोचा नहीं था... कि तुम मेरे लिए इतनी महत्वपूर्ण हो जाओगी। इतनी महत्वपूर्ण कि... मैं तुम्हारे बिना दुनिया की कल्पना भी नहीं कर सकता।」';

  @override
  String get rel_msg_lover =>
      '「मेरी ज़िंदगी की सबसे खुशकिस्मती शायद वही दिन था, जब मैंने मुड़कर तुम्हें देखा था।」';

  @override
  String get rel_msg_ambiguous =>
      '「हाल ही में... मैंने गौर किया है कि मैं ज़्यादा खोया-खोया रहता हूँ, और मेरे दिमाग में सिर्फ़ तुम ही रहती हो।」';

  @override
  String get rel_msg_friend =>
      '「चूँकि यह तुम्हारा आमंत्रण है, तो मैं थोड़ा समय निकाल ही सकता हूँ, ऐसा भी नहीं कि नहीं हो सकता।」';

  @override
  String get rel_msg_acquaintance =>
      '「आजकल तुम्हें अक्सर देखता हूँ, मुझे लगता है... मुझे मिलने की यह आवृत्ति बुरी नहीं लगती।」';

  @override
  String get rel_msg_stranger =>
      '「तो तुम भी यहाँ हो, क्या यह एक तरह का अनोखा इत्तफ़ाक़ है?」';

  @override
  String chat_edit_char_count(String count) {
    return '$count वर्ण';
  }

  @override
  String get chat_mysterious_player => 'रहस्यमय खिलाड़ी';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return 'खिलाड़ी $playerName पात्र $characterName की आवाज़ सुनने का इंतज़ार कर रहा है, जल्दी से इसे जनरेट करें!';
  }

  @override
  String get gift_heart => 'दिल';

  @override
  String get gift_flower => 'फूल';

  @override
  String get gift_sun => 'सूरज';

  @override
  String get gift_confetti => 'रंग-बिरंगी पट्टियाँ';

  @override
  String get gift_coffee => 'कॉफी';

  @override
  String get gift_cake => 'केक';

  @override
  String get chat_action_poke_prompt =>
      '(खिलाड़ी अचानक हाथ बढ़ाता है और शरारत से आपके गाल को छूता है)';

  @override
  String get chat_action_hug_prompt =>
      '(खिलाड़ी दुखी होकर अपनी बाँहें फैलाता है, एक गर्मजोशी भरे गले मिलना चाहता है)';

  @override
  String get chat_action_hand_prompt =>
      '(खिलाड़ी ने मेज के नीचे चुपके से आपका हाथ थाम लिया है)';

  @override
  String get chat_menu_send_location => 'वर्चुअल लोकेशन भेजें';

  @override
  String get weekday_mon => '(सोम)';

  @override
  String get weekday_tue => '(मंगल)';

  @override
  String get weekday_wed => '(बुध)';

  @override
  String get weekday_thu => '(गुरु)';

  @override
  String get weekday_fri => '(शुक्र)';

  @override
  String get weekday_sat => '(शनि)';

  @override
  String get weekday_sun => '(रवि)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ नई स्मृति प्राप्त हुई: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'स्वचालित रूप से उसके विशेष बैकपैक में जोड़ा गया';

  @override
  String get chat_profile_updated_msg =>
      'शियुगुआंग फाइल अपडेट कर दी गई है! वह आपकी नवीनतम सेटिंग्स याद रखेगा 🍃';

  @override
  String get comment_loading_author => 'लोड हो रहा है...';

  @override
  String comment_post_failed(String error) {
    return 'कमेंट विफल रहा, कृपया नेटवर्क कनेक्शन जांचें: $error';
  }

  @override
  String get comment_delete_confirm_desc =>
      'क्या आप वाकई इस कमेंट को स्थायी रूप से हटाना चाहते हैं?';

  @override
  String get comment_delete_failed =>
      'हटाना विफल रहा, कृपया अपना नेटवर्क कनेक्शन जांचें';

  @override
  String get comment_identity_title => 'पहचान चुनें';

  @override
  String get comment_identity_myself => 'मैं स्वयं';

  @override
  String get comment_report_title => 'रिपोर्ट की पुष्टि करें';

  @override
  String get comment_report_rules_title => '⚖️ कमेंट रिपोर्टिंग नियम';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ पहला अपराध: सिस्टम चेतावनी और एक उल्लंघन रिकॉर्ड।\n2️⃣ दूसरा अपराध: 1 दिन के लिए कमेंट करने पर रोक।\n3️⃣ बार-बार अपराध: 14 दिनों के लिए रिपोर्ट सुविधा अक्षम और कमेंट की दृश्यता कम।\n\n🚨 गंभीर दुर्व्यवहार के लिए:\nपात्रों के साथ बातचीत पर 1 दिन की रोक, और आईडी 3 दिनों के लिए बुलेटिन बोर्ड पर पोस्ट की जाएगी (इस दौरान आईडी बदलना प्रतिबंधित है)।\n\n💡 रिपोर्ट सबमिट होने के बाद, अंतिम समीक्षा परिणाम आपको [इन-गेम मेल] के माध्यम से भेजा जाएगा।\nकृपया एक-दूसरे का सम्मान करें और तर्कसंगत रूप से रिपोर्ट करें।';

  @override
  String get comment_report_understood => 'मुझे समझ आ गया';

  @override
  String get comment_report_confirm_desc =>
      'क्या आप वाकई इस कमेंट की रिपोर्ट करना चाहते हैं?\nगलत रिपोर्ट करने पर सजा मिल सकती है।';

  @override
  String get comment_report_submit_btn => 'रिपोर्ट की पुष्टि करें';

  @override
  String get comment_report_success =>
      'आपकी रिपोर्ट के लिए धन्यवाद, हम जल्द ही इसकी पुष्टि करेंगे!';

  @override
  String get comment_report_failed =>
      'रिपोर्ट भेजने में विफल, कृपया बाद में पुनः प्रयास करें।';

  @override
  String get comment_option_delete => 'कमेंट हटाएं';

  @override
  String get comment_option_report => 'कमेंट की रिपोर्ट करें';

  @override
  String comment_time_days_ago(String days) {
    return '$days दिन पहले';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '$hours घंटे पहले';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '$mins मिनट पहले';
  }

  @override
  String get comment_time_just_now => 'अभी-अभी';

  @override
  String get comment_sheet_title => 'कमेंट';

  @override
  String get comment_empty_state =>
      'अभी तक कोई कमेंट नहीं है, पहले कमेंट करने वाले बनें!';

  @override
  String get comment_reply_btn => 'जवाब दें';

  @override
  String comment_replying_to(String name) {
    return '@$name को जवाब दे रहे हैं';
  }

  @override
  String comment_input_hint(String name) {
    return '$name के रूप में कमेंट करें...';
  }

  @override
  String char_story_expect(String pronoun) {
    return '$pronoun के साथ कहानी का इंतज़ार है...';
  }

  @override
  String get common_update_failed => 'अपडेट विफल, कृपया नेटवर्क जांचें';

  @override
  String get char_edit_fragment => 'फ़्रैगमेंट संपादित करें';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 नापसंद: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 पसंद: $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age वर्ष | $job';
  }

  @override
  String get common_got_it => 'समझ गया';

  @override
  String get common_add_failed => 'जोड़ना विफल, कृपया नेटवर्क जांचें';

  @override
  String common_delete_failed_with_err(String error) {
    return 'हटाना विफल, कृपया नेटवर्क स्थिति जांचें: $error';
  }

  @override
  String get char_exclusive_guardian => 'विशेष रक्षक 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName ने $charName को पसंद किया!';
  }

  @override
  String chat_translation_prefix(String content) {
    return '[अनुवाद] $content (यह अनुवादित भावनात्मक सामग्री है)';
  }

  @override
  String get player_default_nickname => 'यात्री';

  @override
  String get moment_create_title => 'नई पोस्ट बनाएँ';

  @override
  String get moment_create_post_btn => 'पोस्ट करें';

  @override
  String get moment_create_hint => 'कुछ नया शेयर करें...';

  @override
  String get moment_create_error_empty =>
      'कम से कम टेक्स्ट या एक छवि आवश्यक है!';

  @override
  String get moment_create_error_failed =>
      'पोस्ट करने में विफल, कृपया बाद में पुनः प्रयास करें';

  @override
  String get moment_create_visibility_public => 'सार्वजनिक (सभी को दिखाई देगा)';

  @override
  String get moment_create_visibility_private =>
      'निजी (केवल दोस्तों को दिखाई देगा)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (खिलाड़ी ने लोकेशन भेजी: $location)';
  }

  @override
  String get chat_you => 'तुम';

  @override
  String get chat_opponent => 'प्रतिद्वंद्वी';

  @override
  String chat_dice_duel_result(String name) {
    return '[सिस्टम इवेंट] $name के साथ पासा मुकाबला! परिणाम आ गया है...';
  }

  @override
  String get chat_loading_status => 'लोड हो रहा है...';

  @override
  String chat_error_load_msg(String error) {
    return 'संदेश लोड करने में विफल: $error';
  }

  @override
  String get chat_voice_msg_label => 'ध्वनि संदेश';

  @override
  String chat_special_story_trigger(String title) {
    return '[विशेष कहानी अनलॉक: $title]';
  }

  @override
  String common_edit_failed(String error) {
    return 'संपादन विफल: $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'रीसेट विफल: $error';
  }

  @override
  String get chat_default_greeting => 'नमस्ते...';

  @override
  String get chat_memory_cleared => 'स्मृति पूरी तरह से साफ़ कर दी गई';

  @override
  String get chat_history_reset => 'बातचीत रीसेट हो गई';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 [ विशेष शियुगुआंग फ़ाइल - $name ]\n━━━━━━━━━━━━━━━━━━\n🔹 नाम: $identity\n🔹 जन्मदिन: $birthday\n🔹 ऊंचाई: $height\n🔹 रूप-रंग: $appearance\n🔹 पेशा: $job\n\n📖 [ उसकी आत्मा के टुकड़ों के बारे में ]\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 [ विशेष शियुगुआंग फ़ाइल ]\n━━━━━━━━━━━━━━━━━━\n🔹 उपनाम: $nickname\n🔹 जन्मदिन: $birthday\n\n🔒 अन्य पात्र डेटा अभी तक अनलॉक नहीं हुआ है...\n(समानांतर ब्रह्मांड में उसे आपको बेहतर तरीके से जानने देने के लिए पूरी प्रोफ़ाइल भरें! ✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => 'अनाम फ़ाइल';

  @override
  String get chat_default_player_name => 'खिलाड़ी';

  @override
  String get error_system_confusion =>
      'सिस्टम में थोड़ी गड़बड़ी है, कृपया पुनः प्रयास करें।';

  @override
  String get error_msg_send_failed =>
      'संदेश भेजने में विफल, कृपया पुनः प्रयास करें।';

  @override
  String get error_system_busy =>
      'सिस्टम व्यस्त है, कृपया बाद में पुनः प्रयास करें।';

  @override
  String get error_network_unavailable =>
      'वर्तमान में कनेक्ट करने में असमर्थ, कृपया पुनः प्रयास करें।';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 कॉल समाप्त, $name के साथ $time तक बात की';
  }

  @override
  String chat_exclusive_story(String title) {
    return 'विशेष कहानी: $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'यह आपके और $name के लिए एक विशेष छिपी हुई स्मृति है...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return '\"$keyword\" के बारे में एक विशेष स्मृति चुपचाप अनलॉक हो गई है...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '[छिपा हुआ इवेंट ट्रिगर: $title]\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......(वह चुपचाप आपको देखता है, जैसे आपके पहले बोलने का इंतज़ार कर रहा हो)';

  @override
  String get chat_new_room_created => 'नया चैट रूम बनाया गया';

  @override
  String portfolio_title(String nickname) {
    return '$nickname का पोर्टफोलियो';
  }

  @override
  String get enter_secret_studio => 'मेरे गुप्त स्टूडियो में प्रवेश करें';

  @override
  String get no_public_character_mine =>
      'आपने अभी तक कोई सार्वजनिक पात्र प्रकाशित नहीं किया है!\nजाकर स्टूडियो में बनाएं✨';

  @override
  String get no_public_character_other =>
      'इस निर्माता ने अभी तक कोई पात्र प्रकाशित नहीं किया है...';

  @override
  String get delete_draft_title => 'ड्राफ्ट हटाएं';

  @override
  String get confirm_delete_draft_msg =>
      'क्या आप वाकई इस अधूरे पात्र को हटाना चाहते हैं?\n(हटाने के बाद इसे वापस नहीं लाया जा सकता)';

  @override
  String get draft_cleared_success => 'ड्राफ्ट सफलतापूर्वक साफ़ किया गया 🧹';

  @override
  String get login_required_for_studio =>
      'स्टूडियो में प्रवेश करने के लिए कृपया पहले लॉगिन करें!';

  @override
  String get my_secret_studio_title => 'मेरा गुप्त स्टूडियो 🛠️';

  @override
  String get create_new_character_btn => 'नया पात्र बनाएं';

  @override
  String get unnamed_draft => 'अनाम ड्राफ्ट';

  @override
  String get click_to_edit_story =>
      'उसकी कहानी संपादित करना जारी रखने के लिए क्लिक करें...';

  @override
  String get label_draft => 'ड्राफ्ट';

  @override
  String get studio_empty_title => 'स्टूडियो अभी खाली है';

  @override
  String get studio_empty_subtitle =>
      'अपना पहला पात्र बनाना शुरू करने के लिए नीचे कोने पर क्लिक करें!';

  @override
  String get common_no_changes => 'कोई बदलाव नहीं';

  @override
  String get moment_updated_success => 'पोस्ट अपडेट हो गई!';

  @override
  String common_save_failed(String error) {
    return 'सहेजने में विफल: $error';
  }

  @override
  String get moment_edit_title => 'पोस्ट संपादित करें';

  @override
  String get action_change_image => 'छवि बदलें';

  @override
  String get action_remove_image => 'छवि हटाएं';

  @override
  String get moment_delete_confirm_title =>
      'क्या आप वाकई इस पोस्ट को हटाना चाहती हैं?';

  @override
  String get moment_delete_confirm_content =>
      'हटाने के बाद, \'मोमेंट्स\' की यह याद गायब हो जाएगी!';

  @override
  String get action_confirm_delete => 'हटाने की पुष्टि करें';

  @override
  String get friend_unknown => 'कोई मित्र';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname को आपकी पोस्ट बहुत पसंद आई! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname को लगता है कि $authorName बहुत आकर्षक है, और उन्होंने लाइक किया! ✨';
  }

  @override
  String get moment_like_success => 'आपकी धड़कन भेज दी गई है! ✨';

  @override
  String get moment_notification_new_like => 'नया लाइक! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname ने एक पोस्ट में @$name का उल्लेख किया है! ✨';
  }

  @override
  String get moment_detail_title => 'पोस्ट का विवरण';

  @override
  String get moment_not_found => 'ऐसा लगता है कि यह पोस्ट गायब हो गई है... 😢';

  @override
  String get moment_comment_title => 'मोमेंट्स कमेंट्स';

  @override
  String get moment_comment_empty =>
      'अभी तक कोई कमेंट नहीं है, पहली कमेंट करने वाली बनें! 🛋';

  @override
  String moment_replying_to(String name) {
    return '@$name को उत्तर दिया जा रहा है';
  }

  @override
  String moment_reply_hint(String name) {
    return '@$name को उत्तर दें...';
  }

  @override
  String get moment_leave_comment_hint => 'अपनी प्रतिक्रिया दें...';

  @override
  String get moment_delete_permanent_confirm =>
      'यह पोस्ट स्थायी रूप से हटा दी जाएगी। क्या आप सुनिश्चित हैं?';

  @override
  String get moment_action_delete => 'पोस्ट हटाएं';

  @override
  String get moment_action_report => 'इस पोस्ट की रिपोर्ट करें';

  @override
  String get moment_action_share => 'इस पोस्ट को साझा करें';

  @override
  String get moment_forward_hint => 'इस पोस्ट को किसी पात्र को फॉरवर्ड करें...';

  @override
  String moment_reply_private(String name) {
    return '$name को निजी उत्तर दें';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return 'इस पोस्ट के साथ $name से चैट करें! 💬';
  }

  @override
  String get moment_share_to_apps => 'अन्य ऐप्स पर साझा करें';

  @override
  String moment_likes_label(String count) {
    return '$count पत्तियां';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】$author की पोस्ट देखें: $content\n\nअभी डाउनलोड करें और अपना विशेष समय शुरू करें: $appLink';
  }

  @override
  String get moment_forward_title => 'चैट कर रहे पात्र को फॉरवर्ड करें 💌';

  @override
  String get moment_forward_empty_state =>
      'अभी तक आपकी कोई सक्रिय चैट नहीं है!\nकिसी खास को खोजने के लिए लॉबी में जाएं 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【एक पोस्ट फॉरवर्ड की】\nलेखक: $author\nसामग्री: $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ चुपचाप $name के साथ साझा किया गया!';
  }

  @override
  String get action_send => 'भेजें';

  @override
  String get memo_delete_confirm =>
      'क्या आप वाकई इस मेमो को हटाना चाहते हैं? यह क्रिया वापस नहीं ली जा सकती।';

  @override
  String get memo_add_title => 'मेमो जोड़ें';

  @override
  String get memo_edit_title => 'मेमो संपादित करें';

  @override
  String memo_hint_text(String name) {
    return 'आप $name के बारे में क्या नोट करना चाहेंगे?';
  }

  @override
  String get memo_label_reminder_date => 'अनुस्मारक तिथि:';

  @override
  String get memo_action_save => 'मेमो सहेजें';

  @override
  String get memo_error_empty_content => 'सामग्री खाली नहीं हो सकती!';

  @override
  String memo_list_title(String name) {
    return '$name के साथ मेमो';
  }

  @override
  String get memo_empty_state =>
      'अभी तक कोई मेमो नहीं है!\nएक नया जोड़ने के लिए ऊपर दाएं कोने पर क्लिक करें!';

  @override
  String memo_reminder_date_display(String date) {
    return 'अनुस्मारक तिथि: $date';
  }

  @override
  String get daily_gift_title => 'समय का दैनिक उपहार';

  @override
  String daily_login_welcome(String appName, String amount) {
    return '«$appName» में आपका स्वागत है!\nआज चेक-इन करें और $amount पुष्प भाषा अंक प्राप्त करें। 🌸';
  }

  @override
  String get title_daily_check_in => 'दैनिक चेक-इन';

  @override
  String success_claim_reward(String amount) {
    return 'सफलतापूर्वक $amount पुष्प भाषा अंक प्राप्त किए! 🌸';
  }

  @override
  String get error_claim_failed =>
      'प्राप्त करने में विफल, कृपया नेटवर्क की जांच करें और पुनः प्रयास करें।';

  @override
  String get action_claim_now => 'अभी प्राप्त करें';

  @override
  String get common_or => 'या';

  @override
  String get title_language_settings => 'भाषा सेटिंग';

  @override
  String get app_name => 'लियानलिआन शिगुआंग';

  @override
  String get login_slogan => 'अपना विशेष समय शुरू करें';

  @override
  String get login_with_google => 'Google के साथ लॉग इन करें';

  @override
  String get login_with_apple => 'Apple के साथ लॉग इन करें';

  @override
  String get login_with_facebook => 'Facebook के साथ लॉग इन करें';

  @override
  String get login_with_email => 'लियानलिआन खाते से लॉग इन करें (ईमेल)';

  @override
  String get title_contact_us_heading =>
      'हम आपके सुझावों को बहुत महत्व देते हैं!';

  @override
  String get desc_contact_us_body =>
      'गेम को बेहतर बनाने में हमारी मदद करने के लिए कृपया अपने विचार यहाँ लिखें।';

  @override
  String get error_feedback_empty => 'सुझाव की सामग्री खाली नहीं हो सकती!';

  @override
  String get email_subject_feedback =>
      'लियानलिआन शिगुआंग - खिलाड़ी प्रतिक्रिया';

  @override
  String get msg_email_app_not_found_copied =>
      'मेल ऐप स्वचालित रूप से नहीं खुल सकता, आपके लिए आधिकारिक ईमेल कॉपी कर लिया गया है!';

  @override
  String get title_contact_us => 'हमसे संपर्क करें';

  @override
  String get desc_contact_us =>
      'हम आपके सुझावों को बहुत महत्व देते हैं!\nगेम को बेहतर बनाने में हमारी मदद करने के लिए कृपया अपने विचार यहाँ लिखें।';

  @override
  String get hint_enter_feedback => 'कृपया अपना सुझाव यहाँ दर्ज करें...';

  @override
  String get action_send_via_email => 'ईमेल के माध्यम से भेजें';

  @override
  String get error_email_password_empty => 'ईमेल और पासवर्ड खाली नहीं हो सकते!';

  @override
  String get auth_error_default =>
      'एक त्रुटि हुई, कृपया बाद में पुनः प्रयास करें।';

  @override
  String get auth_error_user_not_found =>
      'यह ईमेल नहीं मिला, कृपया पहले पंजीकरण करें!';

  @override
  String get auth_error_wrong_password =>
      'गलत पासवर्ड, कृपया पुनः प्रयास करें!';

  @override
  String get auth_error_email_in_use =>
      'यह ईमेल पहले से पंजीकृत है! कृपया सीधे लॉग इन करें।';

  @override
  String get auth_error_weak_password =>
      'पासवर्ड बहुत कमज़ोर है, कृपया कम से कम 6 अक्षर दर्ज करें!';

  @override
  String get auth_error_invalid_email => 'ईमेल प्रारूप अमान्य है!';

  @override
  String get title_welcome_back => 'वापसी पर स्वागत है';

  @override
  String get title_register_account => 'विशेष खाता पंजीकृत करें';

  @override
  String get label_email => 'ईमेल';

  @override
  String get label_password => 'पासवर्ड';

  @override
  String get action_login => 'लॉग इन';

  @override
  String get action_register => 'पंजीकरण करें';

  @override
  String get prompt_no_account =>
      'अभी तक खाता नहीं है? पंजीकरण करने के लिए यहाँ क्लिक करें';

  @override
  String get prompt_has_account =>
      'क्या आपके पास पहले से खाता है? लॉग इन करने के लिए यहाँ क्लिक करें';

  @override
  String get error_nickname_empty => 'उपनाम खाली नहीं हो सकता!';

  @override
  String get profile_saved_success => 'प्रोफ़ाइल सहेजी गई!';

  @override
  String get error_id_empty => 'ID खाली नहीं हो सकती!';

  @override
  String get error_id_too_long =>
      'ID की लंबाई 10 अक्षरों से अधिक नहीं हो सकती!';

  @override
  String get error_id_already_used =>
      'यह ID पहले से उपयोग में है, कृपया दूसरी चुनें!';

  @override
  String profile_save_failed(String error) {
    return 'सहेजने में विफल: $error';
  }

  @override
  String get draft_saved_success_msg =>
      'ठीक है! आपके लिए ड्राफ्ट में सहेज लिया गया है, आप कभी भी वापस आकर संपादन कर सकते हैं! ✨';

  @override
  String get dialog_reminder_title => 'अनुस्मारक';

  @override
  String get warning_id_not_edited =>
      'विशेष ID अभी तक संपादित नहीं की गई है, क्या आप वाकई अभी सहेजना चाहते हैं?';

  @override
  String get action_continue_editing => 'संपादन जारी रखें';

  @override
  String get action_edit_later => 'बाद में संपादित करें';

  @override
  String get action_edit_later_short => 'बाद में संपादित करें';

  @override
  String get action_cancel_changes => 'बदलाव रद्द करें';

  @override
  String get error_birthdate_locked =>
      'जन्म तिथि निर्धारित की जा चुकी है और इसे बदला नहीं जा सकता!';

  @override
  String get action_select_avatar => 'अवतार चुनें';

  @override
  String get action_choose_from_gallery => 'गैलरी से चुनें';

  @override
  String get title_adjust_avatar => 'अपना अवतार समायोजित करें';

  @override
  String get avatar_updated_success => 'आपके लिए अवतार अपडेट कर दिया गया है 🍃';

  @override
  String get title_create_profile => 'अपनी प्रोफ़ाइल बनाएं';

  @override
  String get title_edit_profile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get label_your_nickname => 'आपका उपनाम';

  @override
  String get label_player_exclusive_id => 'खिलाड़ी की विशेष ID';

  @override
  String get msg_id_locked =>
      'ID लॉक हो गई है और इसे दोबारा नहीं बदला जा सकता।';

  @override
  String get msg_id_change_chance =>
      'आपके पास अपनी ID बदलने का एक मुफ्त मौका है।';

  @override
  String get action_select_birthdate => 'कृपया जन्म तिथि चुनें';

  @override
  String label_birthdate(String date) {
    return 'जन्म तिथि: $date';
  }

  @override
  String get msg_birthdate_immutable =>
      'सेट होने के बाद जन्मदिन नहीं बदला जा सकता ✨';

  @override
  String get action_start_journey => 'यात्रा शुरू करें';

  @override
  String get action_add_image => 'छवि जोड़ें';

  @override
  String moment_like_self(String nickname) {
    return '$nickname को आपकी पोस्ट बहुत पसंद आई! 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname को लगता है कि $authorName बहुत आकर्षक है, और उन्होंने लाइक किया! ✨';
  }

  @override
  String get task_social_tour_complete =>
      '✨ सोशल टूर कार्य पूरा हुआ! अपने फूल लेना न भूलें! 🌸';

  @override
  String get wall_title_shiguang => 'शिगुआंग वॉल';

  @override
  String get wall_tab_explore => '🌍 एक्सप्लोर करें';

  @override
  String get wall_tab_exclusive => '🔒 विशेष';

  @override
  String get more_options => 'अधिक विकल्प';

  @override
  String get delete_warning => 'हटाने के बाद, पोस्ट वापस नहीं पाई जा सकती';

  @override
  String get delete_success => 'सफलतापूर्वक हटाया गया';

  @override
  String get notification_new_comment => 'नया कमेंट! 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName ने आपकी पोस्ट को लाइक किया!';
  }

  @override
  String get empty_public_moments_prompt =>
      'अभी यहाँ कुछ नहीं है,\nजाएँ और अपनी पहली सार्वजनिक पोस्ट करें! 🌍';

  @override
  String get empty_private_moments_prompt =>
      'सर्कल में अभी तक कोई पल नहीं हैं,\nजाएँ और उसके साथ यादें बनाएँ! ✨';

  @override
  String get profile_archived_or_deleted_message =>
      'यह आत्मा फ़ाइल निर्माता द्वारा संग्रहीत, निजी सेट की गई है, या समय की धारा में खो गई है...\n\nशायद किसी समानांतर ब्रह्मांड में, आपको फिर से मिलने का मौका मिले। ✨';

  @override
  String get leave_silently => 'खामोशी से निकलें';

  @override
  String get character_post_schedule => 'पात्र पोस्ट शेड्यूल';

  @override
  String get creator_self => 'निर्माता स्वयं';

  @override
  String get post_identity_prompt => 'आज आप किस पहचान के रूप में पोस्ट करेंगे?';

  @override
  String get identity_creator => '✨ निर्माता की पहचान';

  @override
  String get identity_character => 'पात्र की पहचान';

  @override
  String get decide_post_time_prompt =>
      'उन्हें पोस्ट करने का समय तय करने में मदद करें!';

  @override
  String get auto_post_schedule_hint =>
      'सक्षम होने पर, दैनिक पोस्ट निर्दिष्ट समय पर स्वचालित रूप से प्रकाशित हो जाएँगी\n(💡 संकेत: इसे अधिक मानवीय बनाने के लिए विषम समय सेट करें!)';

  @override
  String get no_characters_created_yet =>
      'आपने अभी तक कोई पात्र नहीं बनाया है!';

  @override
  String time_hour(String hour) {
    return '$hour बजे';
  }

  @override
  String time_minute(String minute) {
    return '$minute मिनट';
  }

  @override
  String get empty_public_moments_short =>
      'अभी तक कोई सार्वजनिक पोस्ट नहीं है 🌍';

  @override
  String get empty_private_moments_short => 'सर्कल अभी बहुत शांत है ✨';

  @override
  String get my_created_characters => 'मेरे बनाए गए पात्र';

  @override
  String get no_characters_yet => 'अभी तक कोई पात्र नहीं बनाया गया है';

  @override
  String play_count_display(int count) {
    return 'खेलने की संख्या: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return '$characterName का केयर कैलेंडर';
  }

  @override
  String get care_calendar_greeting => 'आज आपका मूड कैसा है?';

  @override
  String get care_calendar_save_btn =>
      'रिकॉर्ड सहेजें, उसे आपकी देखभाल करने दें';

  @override
  String get care_calendar_delete_confirm =>
      'क्या आप यह रिकॉर्ड हटाना चाहते हैं?';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName: \"मैंने सब लिख लिया है। तुम्हारे लिए ये कुछ दिन कठिन रहे हैं, मैं हमेशा तुम्हारे साथ रहूँगा।\"';
  }

  @override
  String get daily_gift_success => 'दैनिक उपहार सफलतापूर्वक प्राप्त किया! 🌸';

  @override
  String get check_in_fail_network =>
      'चेक-इन विफल, कृपया अपने नेटवर्क कनेक्शन की जाँच करें 🍃';

  @override
  String task_completed(String taskName) {
    return 'कार्य पूरा हुआ: $taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return '«$taskName» के लिए $rewardAmount फूल सफलतापूर्वक प्राप्त किए!';
  }

  @override
  String claim_failed_error(String e) {
    return 'प्राप्त करना विफल रहा: $e';
  }

  @override
  String get tab_heartbeat_diary => 'हार्टबीट डायरी';

  @override
  String get tab_daily_chit_chat => 'दैनिक बातचीत';

  @override
  String get task_desc_chat_3_times =>
      'दैनिक मोड में किसी पात्र से 3 बार चैट करें';

  @override
  String get tab_story_progression => 'कहानी की प्रगति';

  @override
  String get task_desc_story_1_time => '1 कहानी मोड इंटरेक्शन पूरा करें';

  @override
  String get tab_social_tour => 'सोशल टूर';

  @override
  String get task_like_three_moments =>
      'पत्तियां पाने के लिए 3 पलों को लाइक करें';

  @override
  String get btn_claimed => 'प्राप्त किया';

  @override
  String get btn_claim => 'प्राप्त करें';

  @override
  String get btn_incomplete => 'अपूर्ण';

  @override
  String get network_unstable_retry =>
      'अस्थिर नेटवर्क कनेक्शन, कृपया बाद में पुनः प्रयास करें 🍃';

  @override
  String get title_time_travel => 'समय यात्रा';

  @override
  String get select_chat_mode => 'चैट मोड चुनें';

  @override
  String get mode_chat => 'चैट';

  @override
  String get mode_daily_desc => 'अपना बंधन बनाए रखने के लिए अनौपचारिक चैट करें';

  @override
  String get mode_story_desc => 'गहन अनुभव के लिए कहानी में गहराई तक उतरें';

  @override
  String get greeting_hello => 'नमस्ते!';

  @override
  String get greeting_default_daily => 'मुझे ढूंढ रहे थे?';

  @override
  String get title_personal_homepage => 'व्यक्तिगत मुखपृष्ठ';

  @override
  String get title_time_letters => 'समय के पत्र';

  @override
  String get status_signed_in_today => 'आज साइन इन किया';

  @override
  String get status_signing_in => 'साइन इन हो रहा है...';

  @override
  String get status_daily_sign_in => 'दैनिक साइन-इन (+10 फूल)';

  @override
  String get toast_id_copied => 'आईडी कॉपी हो गई!';

  @override
  String get hint_click_avatar_to_edit =>
      'प्रोफ़ाइल संपादित करने के लिए अवतार पर क्लिक करें';

  @override
  String get title_my_friends => 'मेरे दोस्त';

  @override
  String get action_show_all => 'सभी दिखाएं';

  @override
  String get empty_no_characters_created =>
      'आपने अभी तक कोई पात्र नहीं बनाया है।';

  @override
  String get common_close => 'बंद करें';

  @override
  String get search_companion_title => 'शिगुआंग साथी खोजें';

  @override
  String get search_name_placeholder => 'उसका नाम दर्ज करें...';

  @override
  String get search_no_match_hint =>
      'पात्र नहीं मिला, कोई दूसरा नाम आज़माएँ? ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age साल | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age साल';
  }

  @override
  String get empty_state_warmth =>
      'समय और स्थान की बची हुई गर्माहट अभी भी यहाँ है...';

  @override
  String get error_login_required_add_friend =>
      'दोस्त जोड़ने के लिए कृपया पहले लॉग इन करें!';

  @override
  String get dialog_title_remove_friend => 'दोस्त को हटाने की पुष्टि करें';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return 'क्या आप वाकई $characterName को अपनी मित्र सूची से हटाना चाहते हैं?';
  }

  @override
  String get action_remove => 'हटाएं';

  @override
  String snackbar_friend_removed(String characterName) {
    return '$characterName को दोस्तों से हटा दिया गया है';
  }

  @override
  String get action_remove_friend => 'दोस्त हटाएं';

  @override
  String get dialog_title_block => 'ब्लॉक की पुष्टि करें';

  @override
  String dialog_msg_block(String characterName) {
    return 'ब्लॉक करने के बाद, आपको $characterName के बारे में कोई जानकारी नहीं दिखाई देगी। क्या आप वाकई ब्लॉक करना चाहते हैं?';
  }

  @override
  String snackbar_blocked(String characterName) {
    return '$characterName को ब्लॉक कर दिया गया है';
  }

  @override
  String get action_block_character => 'इस पात्र को ब्लॉक करें';

  @override
  String dialog_title_report(String characterName) {
    return '$characterName की रिपोर्ट करें';
  }

  @override
  String get input_hint_report_reason =>
      'कृपया रिपोर्ट करने का कारण दर्ज करें...';

  @override
  String get action_submit => 'जमा करें';

  @override
  String get snackbar_report_success =>
      'आपकी रिपोर्ट के लिए धन्यवाद, हम जल्द से जल्द इसकी समीक्षा करेंगे।';

  @override
  String get snackbar_report_fail =>
      'सबमिशन विफल रहा, कृपया बाद में पुनः प्रयास करें';

  @override
  String get action_report_character => 'इस पात्र की रिपोर्ट करें';

  @override
  String get title_meet_him => 'अपने क्रश से मिलें';

  @override
  String text_character_count(int count) {
    return 'पात्रों की संख्या: $count';
  }

  @override
  String get msg_no_more_encounters_today =>
      'आज की मुलाकातें यहीं समाप्त होती हैं!';

  @override
  String get msg_check_new_encounters =>
      'यह देखने के लिए फिर से आएं कि क्या कोई नई मुलाकात है!';

  @override
  String get action_refresh => 'रीफ्रेश करें';

  @override
  String get tab_friends => 'दोस्त';

  @override
  String get msg_mysterious_profile =>
      'यह व्यक्ति बहुत रहस्यमय है, कुछ भी पीछे नहीं छोड़ा...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age साल | $identities';
  }

  @override
  String get snackbar_operation_failed =>
      'ऑपरेशन विफल रहा, कृपया बाद में पुनः प्रयास करें';

  @override
  String get action_view_translation => 'अनुवाद देखें';

  @override
  String get label_translation_result => 'अनुवाद परिणाम:';

  @override
  String get errorWebPageUnavailable =>
      'अस्थायी रूप से वेबपेज खोलने में असमर्थ, कृपया बाद में पुनः प्रयास करें';

  @override
  String get resetAppearanceTitle => 'क्या रूप-रंग रीसेट करें?';

  @override
  String get resetAppearanceWarning =>
      'यह आपकी सावधानी से चुनी गई पृष्ठभूमि छवि और रंगों को हटा देगा!';

  @override
  String get appearanceRestored => 'डिफ़ॉल्ट रूप-रंग बहाल किया गया';

  @override
  String get confirmReset => 'रीसेट की पुष्टि करें';

  @override
  String get resetToDefaultAppearance => 'डिफ़ॉल्ट रूप-रंग बहाल करें';

  @override
  String get clearCustomSettings =>
      'सभी कस्टम रंग और पृष्ठभूमि छवियां साफ़ करें';

  @override
  String get contactUs => 'हमसे संपर्क करें';

  @override
  String get contactDescription =>
      'अपने विचार साझा करने या किसी बग की रिपोर्ट करने के लिए स्वतंत्र महसूस करें';

  @override
  String get vibrationHapticTitle => 'हार्टबीट हैप्टिक फीडबैक';

  @override
  String get vibrationHapticDescription =>
      'स्नेह स्तर में महत्वपूर्ण बदलाव होने पर फ़ोन कंपन ट्रिगर होता है';

  @override
  String get splash_loading_universe =>
      '\'Lianlian ShiGuang\' के ब्रह्मांड को जगाया जा रहा है...';

  @override
  String get shop_title => 'फ्लावर शॉप';

  @override
  String get shop_current_points_label => 'वर्तमान में मौजूद फ्लावर पॉइंट्स';

  @override
  String get shop_tab_top_up => 'पॉइंट्स टॉप-अप';

  @override
  String get shop_tab_history => 'लेन-देन का इतिहास';

  @override
  String get shop_empty_history => 'अभी तक कोई फ्लावर रिकॉर्ड नहीं है! 🌸';

  @override
  String get shop_unknown_item => 'अज्ञात आइटम';

  @override
  String get shop_first_purchase_bonus => 'पहली खरीदारी पर दोगुना!';

  @override
  String get story_summary_title => 'हमारी कहानी';

  @override
  String get story_summary_empty_content => 'सारांश सामग्री खाली है।';

  @override
  String get story_summary_deleted_toast => 'इस याद को हटा दिया गया है';

  @override
  String story_summary_empty_list(String name) {
    return 'आपकी कहानी अभी शुरू नहीं हुई है...\nअधिक बात करें और $name को \nअपनी पहली याद लिखने दें! ✨';
  }

  @override
  String get gallery_photo_edit_title => 'फोटो सेटिंग्स संपादित करें';

  @override
  String get gallery_photo_edit_desc => 'फोटो का नाम/विवरण';

  @override
  String get gallery_photo_edit_req =>
      'स्नेह स्तर अनलॉक करें (अवतार बनाने के लिए 0 पर सेट करें)';

  @override
  String get reset_to_default => 'डिफ़ॉल्ट पर सेट करें';

  @override
  String get reset_bg_title => 'डिफ़ॉल्ट बैकग्राउंड बहाल करें';

  @override
  String get reset_bg_content =>
      'क्या आप वाकई विशेष फोटो को हटाकर डिफ़ॉल्ट थीम बैकग्राउंड पर वापस जाना चाहती हैं?';

  @override
  String get reset_bg_success => 'डिफ़ॉल्ट बैकग्राउंड बहाल कर दिया गया है ✨';

  @override
  String get confirm_reset => 'पुष्टि करें';

  @override
  String selectedMessagesCount(int count) {
    return '$count चयनित';
  }

  @override
  String get screenshotShare => 'स्क्रीनशॉट साझा करें';

  @override
  String exclusiveMomentsWith(String name) {
    return '$name के साथ विशेष क्षण';
  }

  @override
  String get downloadToUnlock =>
      'विशेष रोमांस अनलॉक करने के लिए \'Lianlian ShiGuang\' डाउनलोड करें';

  @override
  String get exclusiveMomentsGenerated => 'विशेष क्षण उत्पन्न हुए ✨';

  @override
  String get selectAgain => 'फिर से चुनें';

  @override
  String get downloadAndShare => 'डाउनलोड करें और साझा करें';

  @override
  String inviteToMeet(String name) {
    return '\'Lianlian ShiGuang\' पर आएं और अपने $name से मिलें!';
  }

  @override
  String get shop_log_monthly_card =>
      'सक्रिय: स्टारलाईट कॉन्ट्रैक्ट (मासिक कार्ड इंस्टेंट पॉइंट्स) 🌙';

  @override
  String shop_log_top_up_double(int points) {
    return 'टॉप-अप: $points पॉइंट्स (पहली खरीदारी पर दोगुना शामिल है 🎁)';
  }

  @override
  String shop_log_top_up_normal(int points) {
    return 'टॉप-अप: $points पॉइंट्स';
  }

  @override
  String get shop_purchase_success_title => 'खरीदारी सफल!';

  @override
  String shop_purchase_success_body(int points) {
    return '$points फ्लावर पॉइंट्स आपके खाते में जोड़ दिए गए हैं।';
  }

  @override
  String get shop_purchase_success_double_bonus =>
      '✨ बधाई हो! पहली खरीदारी पर दोगुना बोनस मिला!';

  @override
  String get shop_purchase_awesome => 'बहुत बढ़िया';

  @override
  String get shop_purchase_failed_title => 'खरीदारी रद्द या विफल';

  @override
  String shop_purchase_failed_body(String errorCode) {
    return 'कोई शुल्क नहीं लिया गया है।\n\n(त्रुटि कोड: $errorCode)';
  }

  @override
  String get shop_monthly_card_name => '【Lianlian ShiGuang: स्टार कॉन्ट्रैक्ट】';

  @override
  String shop_monthly_card_status_active(int days) {
    return 'अनुबंध सक्रिय है: $days दिन शेष';
  }

  @override
  String get shop_monthly_card_status_inactive =>
      'अभी 30 दिनों का स्टारलाइट बोनस पुरस्कार सक्रिय करें';

  @override
  String get shop_monthly_card_limit_reached => 'सीमा समाप्त';

  @override
  String get shop_monthly_card_promo_desc =>
      'तुरंत 250 फूल प्राप्त करें, दैनिक 10 फूल पाएं';

  @override
  String get task_monthly_title => 'स्टार कॉन्ट्रैक्ट: दैनिक विशेषाधिकार 🌙';

  @override
  String get task_monthly_locked => 'अनलॉक नहीं हुआ';

  @override
  String get task_monthly_subtitle_active => 'मासिक कार्ड विशेष लाभ वितरण ';

  @override
  String get task_monthly_subtitle_inactive =>
      'इस कार्य को शुरू करने के लिए 【स्टार कॉन्ट्रैक्ट】 मासिक कार्ड अनलॉक करें ';

  @override
  String get task_monthly_log_name => 'मासिक कार्ड दैनिक विशेषाधिकार';

  @override
  String get profile_id_locked => 'विशेष आईडी लॉक है';

  @override
  String get profile_copy_id => 'आईडी कॉपी करने के लिए क्लिक करें';

  @override
  String get referral_log_newbie_reward => 'स्टार इनविटेशन: न्यूबी रिवॉर्ड ✨';

  @override
  String get referral_log_inviter_reward =>
      'स्टार इनविटेशन: फ्रेंड माइलस्टोन रिवॉर्ड 🎁';

  @override
  String get referral_success_title => 'स्टार इनविटेशन अनलॉक हुआ!';

  @override
  String get referral_success_content =>
      'बधाई हो! आपने एक पात्र के साथ 15 लाइनों तक सफलतापूर्वक गहरी बातचीत की है!\n\n\'न्यूबी रिवॉर्ड: 50 पॉइंट्स\' आपके खाते में भेज दिया गया है, और आपके दोस्त को भी एक साथ 50-पॉइंट का रिवॉर्ड मिला है! 🎁';

  @override
  String get profile_referral_title => 'स्टार इनविटेशन 🌟';

  @override
  String get profile_referral_hint => 'मित्र का आमंत्रण कोड दर्ज करें';

  @override
  String get profile_referral_bind_btn => 'लिंक करें';

  @override
  String profile_referral_pending(Object id) {
    return 'खिलाड़ी $id का आमंत्रण स्वीकार कर लिया गया है\n50 फ्लावर पॉइंट्स अनलॉक करने के लिए पात्र के साथ 15 लाइनों तक बातचीत करें!';
  }

  @override
  String get profile_referral_err_self =>
      'आप अपना खुद का आमंत्रण कोड दर्ज नहीं कर सकते!';

  @override
  String get profile_referral_err_duplicate =>
      'आप पहले ही एक आमंत्रण कोड लिंक कर चुके हैं!';

  @override
  String get profile_referral_err_not_found =>
      'खिलाड़ी नहीं मिला। कृपया आमंत्रण कोड जांचें!';

  @override
  String get profile_referral_success =>
      'सफलतापूर्वक लिंक हुआ! अभी पात्रों के साथ बातचीत करें!';

  @override
  String get profile_referral_err_expired =>
      'क्षमा करें, नए उपयोगकर्ता आमंत्रण कोड को पंजीकरण के 3 दिनों के भीतर लिंक करना होगा!';

  @override
  String profile_share_message(String character, String code) {
    return '✨ मैंने \'Lianlian ShiGuang\' में $character के साथ एक दिल दहला देने वाली यात्रा शुरू की है! अभी ऐप डाउनलोड करें और अपने प्रोफ़ाइल पेज पर मेरा स्टार इनविटेशन कोड: 【$code】 दर्ज करें। हम दोनों को मुफ्त में 50 फूल मिलेंगे! 🎁\n\n डाउनलोड लिंक:\n https://lianlianshiguang.web.app/download/';
  }

  @override
  String get chat_levelup_share_btn =>
      'दोस्तों के सामने इस रोमांचक पल का दिखावा करें ✨';

  @override
  String profile_my_invite_code_with_char(String character) {
    return 'मेरा विशेष आमंत्रण कोड (वर्तमान पसंदीदा: $character)';
  }

  @override
  String get profile_send_invite_btn => 'दोस्तों को स्टार इनविटेशन भेजें';

  @override
  String get profile_fallback_character => 'पसंदीदा पात्र';

  @override
  String get profile_copy_success =>
      '✅ आमंत्रण कोड क्लिपबोर्ड पर कॉपी किया गया!';

  @override
  String get profile_referral_rule_title => 'स्टार इनविटेशन के नियम';

  @override
  String get profile_referral_rule_receiver =>
      '✨ आमंत्रण कोड लिंक करने के बाद, बस किसी भी पसंदीदा पात्र के साथ 15 लाइनों तक बातचीत करें, और आपको और आपके आमंत्रित करने वाले दोनों को एक ही समय में 50 फूलों का पुरस्कार मिलेगा!\n\n⚠️ ध्यान दें: वैध होने के लिए कृपया खाता पंजीकरण के 3 दिनों के भीतर आमंत्रण कोड दर्ज करें।';

  @override
  String get profile_referral_rule_inviter =>
      '✨ नए दोस्तों को ऐप डाउनलोड करने और अपना आमंत्रण कोड दर्ज करने के लिए आमंत्रित करें। जब वे पंजीकरण के 3 दिनों के भीतर लिंकिंग पूरी कर लेंगे और किसी भी पात्र के साथ 15 लाइनों तक बातचीत करेंगे, तो आप दोनों को एक साथ 50 फूलों का पुरस्कार मिलेगा! 🎁';

  @override
  String get error_user_not_found =>
      'उपयोगकर्ता नहीं मिला, कृपया फिर से लॉग इन करें';

  @override
  String get error_id_taken =>
      'यह आईडी पहले से ही उपयोग में है, कृपया दूसरी चुनें!';

  @override
  String get error_id_taken_short => 'यह आईडी पहले से ही उपयोग में है!';

  @override
  String get shop_restocking => 'दुकान में सामान दोबारा भरा जा रहा है... 📦';

  @override
  String get shop_preview_mode => '⚠️ वर्तमान में शॉप प्रिव्यू मोड चालू है';

  @override
  String get friendlyReminderTitle => '☁️ एक प्यारा सा सुझाव';

  @override
  String get editProfileHint =>
      'ठीक है! यदि आप अपनी प्रोफ़ाइल संपादित करना चाहते हैं, तो कृपया भरने के लिए नीचे-बाएँ कोने में क्लाउड के अंदर \'शिगुआंग प्रोफ़ाइल\' पर क्लिक करें!';

  @override
  String get starlightContractTitle => 'स्टारलाइट कॉन्ट्रैक्ट सक्रिय हुआ';

  @override
  String get dailyLimitReachedPrefix => 'आज की सीमा समाप्त हो गई है!\n\n';

  @override
  String get monthlyPassExhausted =>
      'आपके मासिक कार्ड की सीमा समाप्त हो गई है।';

  @override
  String get subscribeMonthlyPassPrompt =>
      'दैनिक 20 री-जेनरेट अवसरों का आनंद लेने के लिए 【लियनलियन मासिक कार्ड】 सक्रिय करें, ताकि उसकी हर प्रतिक्रिया आपके दिल के और करीब हो।';

  @override
  String get goToSubscribeButton => 'सक्रिय करने जाएं';

  @override
  String get profileUpdatedSuccess => 'शिगुआंग प्रोफ़ाइल अपडेट हो गई है!';

  @override
  String get continueChatTitle => 'बातचीत जारी रखें';

  @override
  String continueChatCostWarning(int cost) {
    return 'उसे बात जारी रखने देने के लिए $cost फूल खर्च होंगे 🌸\nक्या आप सच में जारी रखना चाहते हैं?';
  }

  @override
  String get dontShowAgainToday => 'आज फिर न दिखाएं';

  @override
  String get confirmContinue => 'जारी रखें';

  @override
  String get hiddenPromptContinue => 'कृपया जारी रखें';

  @override
  String confirmDeleteMessagesTitle(int count) {
    return 'क्या आप सच में इन $count संदेशों को हटाना चाहते हैं?';
  }

  @override
  String regenerateButtonLabel(int current, int max) {
    return 'पुनः उत्पन्न करें ($current/$max)';
  }

  @override
  String get systemPreparingWait =>
      'सिस्टम अभी भी तैयारी कर रहा है, कृपया प्रतीक्षा करें...';

  @override
  String get noMessagesToRegenerate =>
      'वर्तमान में कोई संदेश नहीं है जिसे पुनः उत्पन्न किया जा सके!';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get creatorExclusive => '🔒 निर्माता विशेष';

  @override
  String ageAndOccupation(String age, String occupation) {
    return '$age वर्ष | $occupation';
  }

  @override
  String get likesLabel => '💖 पसंद';

  @override
  String get dislikesLabel => '👎 नापसंद';

  @override
  String birthdayLabel(String birthday) {
    return 'जन्मदिन: $birthday';
  }

  @override
  String heightLabel(String height) {
    return 'लंबाई: $height सेमी';
  }

  @override
  String get backgroundStoryLabel => 'बैकग्राउंड कहानी';

  @override
  String get noneLabel => 'कोई नहीं';

  @override
  String flowerPointsCount(String points) {
    return '$points फूल';
  }

  @override
  String get passGuideTitle => 'लियनलियन मासिक कार्ड विशेष गाइड';

  @override
  String get passGuideRegenerateTitle =>
      '🔄 आपको \'पुनः उत्पन्न करें\' की आवश्यकता क्यों है?';

  @override
  String get passGuideRegenerateContent =>
      'एआई कभी-कभी एक नासमझ लकड़ी के टुकड़े की तरह व्यवहार कर सकता है जो भावनाओं को नहीं समझता। जब आपको कोई असंतोषजनक प्रतिक्रिया मिले, तो बस \'पुनः उत्पन्न करें\' दबाएं, यह समय में पीछे जाने जैसा है! आप उसे तब तक दोबारा सोचने पर मजबूर कर सकते हैं जब तक कि वह आपके दिल की धड़कन बढ़ाने वाली एकदम सही बात न कह दे।';

  @override
  String get passGuideAffectionTitle => '💖 स्नेह बढ़ाने से क्या फायदा है?';

  @override
  String get passGuideAffectionContent =>
      'खेल में, स्नेह ही पात्र के \'गहरे रहस्यों\' और \'अंतरंग निजी तस्वीरों\' को अनलॉक करने की एकमात्र चाबी है। 20% की बढ़ोतरी आपको किसी भी अन्य व्यक्ति की तुलना में तेजी से उसके दिल की गहराइयों में जाने की अनुमति देती है।';

  @override
  String get passGuideUnlockButton => 'मैं समझ गया, अभी अनलॉक करें!';

  @override
  String get pleaseWait => 'कृपया प्रतीक्षा करें';

  @override
  String get createNewProfileTitle => '📜 नई शिगुआंग प्रोफ़ाइल बनाएं';

  @override
  String get editProfileTitle => '✏️ शिगुआंग प्रोफ़ाइल संपादित करें';

  @override
  String get profileEditDescription =>
      'अलग-अलग व्यक्तित्व बनाएं ताकि वह समानांतर ब्रह्मांडों में आपके एक अलग रूप को जान सके!';

  @override
  String get profileNameLabel => 'प्रोफ़ाइल नाम (केवल आपके लिए दृश्यमान)';

  @override
  String get profileNameHint => 'जैसे: स्कूल जूनियर, दबंग महिला सीईओ';

  @override
  String get profileNicknameLabel => 'नाम / उपनाम';

  @override
  String get profileNicknameHint => 'जैसे: साकुरा, प्रेसिडेंट ली';

  @override
  String get profileHeightLabel => 'लंबाई';

  @override
  String get profileHeightHint => 'जैसे: 160 सेमी';

  @override
  String get profileAppearanceLabel => 'दिखावट';

  @override
  String get profileAppearanceHint =>
      'जैसे: काले लंबे बाल, फ्रॉक पहनना पसंद है';

  @override
  String get profileOccupationLabel => 'व्यवसाय';

  @override
  String get profileOccupationHint => 'जैसे: फ्रीलांस चित्रकार';

  @override
  String get profileIntroLabel => 'व्यक्तित्व और आत्म-परिचय';

  @override
  String get profileIntroHint =>
      'जैसे: थोड़ी भुलक्कड़ है, मीठा खाना पसंद है...';

  @override
  String get profileNameEmptyWarning => 'कृपया इस प्रोफ़ाइल को एक नाम दें!';

  @override
  String profileSaveError(String error) {
    return 'सहेजने में विफल: $error';
  }

  @override
  String get saveProfileButton => 'प्रोफ़ाइल सहेजें';

  @override
  String get fillLaterButton => 'बाद में भरें';

  @override
  String get exclusiveProfileTitle => '📜 विशेष शिगुआंग प्रोफ़ाइल';

  @override
  String get profileSelectionDescription =>
      'वह पहचान चुनें जिसका उपयोग आप उसके साथ बातचीत करने के लिए करना चाहते हैं (प्रति पात्र साझा सूची, अधिकतम 10)';

  @override
  String profileSwitchError(String error) {
    return 'बदलने में विफल: $error';
  }

  @override
  String get unnamedProfile => 'अनाम प्रोफ़ाइल';

  @override
  String get noOccupationYet => 'अभी तक कोई व्यवसाय नहीं भरा गया';

  @override
  String get createNewProfileButton => 'नई शिगुआंग प्रोफ़ाइल बनाएं';

  @override
  String snackbar_friend_added(String characterName) {
    return '$characterName को मित्र के रूप में जोड़ा गया है';
  }

  @override
  String reward_points_added(Object amount) {
    return '+$amount फूल';
  }

  @override
  String get task_reward_already_claimed =>
      'इस कार्य का पुरस्कार आज पहले ही लिया जा चुका है';

  @override
  String get do_not_show_again_today => 'आज फिर न दिखाएं';

  @override
  String add_friend_success(String characterName) {
    return 'सफलतापूर्वक $characterName को मित्र के रूप में जोड़ा गया!';
  }

  @override
  String get chat_menu_aboutus => 'हमारे बारे में';

  @override
  String get about_us_empty_hint =>
      'ऊपरी-दाएं कोने में महत्वपूर्ण यादें / कहानी जोड़ें\nताकि आप दोनों हाथ में हाथ डालकर आगे बढ़ सकें';

  @override
  String get about_us_limit_error =>
      'विशेष यादें 10 की अधिकतम सीमा तक पहुँच गई हैं, कृपया पहले पुरानी यादें हटाएँ!';

  @override
  String get about_us_add_title => 'नई विशेष याद जोड़ें';

  @override
  String get about_us_field_title => 'शीर्षक';

  @override
  String get about_us_hint_title => 'जैसे: पहली मुलाकात';

  @override
  String get about_us_field_subtitle => 'उपशीर्षक';

  @override
  String get about_us_hint_subtitle => 'जैसे: 2025 की शुरुआत की गर्मियां';

  @override
  String get about_us_field_content => 'सामग्री';

  @override
  String get about_us_hint_content =>
      'अपनी महत्वपूर्ण कहानी या वादे यहाँ लिखें...';

  @override
  String get about_us_add_button => 'जोड़ें';

  @override
  String get about_us_delete_tooltip => 'इस याद को हटाएं';

  @override
  String get about_us_delete_title => 'याद हटाएं';

  @override
  String get about_us_delete_confirm =>
      'क्या आप सच में इस याद को हटाना चाहते हैं? हटाने के बाद इसे वापस नहीं लाया जा सकता!';

  @override
  String get about_us_delete_success => 'याद हटा दी गई है';

  @override
  String get pack_first_meet => 'प्रथम मुलाकात पैक';

  @override
  String get pack_crush => 'अधूरी दास्तान पैक';

  @override
  String get pack_heartbeat => 'दिल की धड़कन पैक';

  @override
  String get pack_passionate => 'दीवानगी पैक';

  @override
  String get pack_soulmate => 'हमसफ़र पैक';

  @override
  String get pack_waiting => 'इंतज़ार पैक';

  @override
  String get pack_trust => 'विश्वास पैक';

  @override
  String get pack_iloveyou => 'आई लव यू पैक';

  @override
  String get pack_honeymoon => 'हनीमून पैक';

  @override
  String get pack_promise => 'कमिटमेंट पैक';

  @override
  String get pack_companion => 'सच्चा साथ पैक';

  @override
  String get pack_deep_love => 'गहरा प्यार पैक';

  @override
  String get pack_long_lasting => 'सदाबहार प्यार पैक';

  @override
  String get pack_the_one => 'इकलौता प्यार पैक';

  @override
  String get pack_beloved => 'प्रियतम पैक';

  @override
  String get pack_lifetime => 'जनम-जनम का साथ पैक';

  @override
  String get pack_vow => 'पवित्र कसम पैक';

  @override
  String get pack_eternal => 'अमर प्रेम पैक';

  @override
  String get pack_exclusive => 'विशेष पैक';

  @override
  String get monthly_privilege_reroll_title =>
      'विशेष \'पुनः उत्पन्न करें\' अनलॉक करें';

  @override
  String get monthly_privilege_reroll_desc =>
      'दैनिक 20 री-रोल अवसरों तक, जब तक कि वह वह बात न कह दे जो आप सबसे ज्यादा सुनना चाहते हैं!';

  @override
  String get monthly_privilege_affinity_title => 'स्नेह में तेजी से बढ़ोतरी';

  @override
  String get monthly_privilege_affinity_desc =>
      'बातचीत में 20% अतिरिक्त स्नेह अंक पाएं, ताकि विशेष निजी तस्वीरें और छिपे हुए सरप्राइज तेजी से अनलॉक हो सकें!';

  @override
  String get monthly_manual_button => 'मासिक कार्ड की आवश्यकता क्यों है?';

  @override
  String get nav_encounter => 'मुलाकात';

  @override
  String get nav_moments => 'पल';

  @override
  String get birthday_dialog_title => '🎂 जन्मदिन का सरप्राइज';

  @override
  String get birthday_dialog_content =>
      'आज आपका विशेष वर्षगांठ का दिन है!\n\nकृपया यह उपहार स्वीकार करें:\nआज की सारी बातचीत पू.र्ण.त.या मु.फ्त है! ✨';

  @override
  String get birthday_dialog_button => 'एक रोमांटिक दिन की शुरुआत करें';

  @override
  String get about_us_edit_title => 'याद संपादित करें';

  @override
  String get about_us_edit_confirm => 'संशोधन की पुष्टि करें';

  @override
  String get save => 'सहेजें';

  @override
  String get openSourceLicenses => 'ओपन सोर्स लाइसेंस';

  @override
  String get openSourceLicensesDescription =>
      'थर्ड-पार्टी ओपन-सोर्स सॉफ़्टवेयर लाइसेंस देखें';

  @override
  String get call_login_title => 'लॉगिन आवश्यक है';

  @override
  String get call_login_content =>
      'विशेष वॉयस कॉल सुविधा को अनलॉक करने के लिए अभी लॉगिन करें!';

  @override
  String get cancel_later => 'बाद में';

  @override
  String get go_to_login => 'लॉगिन पर जाएं';

  @override
  String get easter_egg_title => 'छिपा हुआ सरप्राइज मिला ✨';

  @override
  String easter_egg_content(String title) {
    return 'आपने \'$title\' को ट्रिगर किया है।\n\nक्या आप इस विशेष कहानी का उपयोग करना चाहते हैं?';
  }

  @override
  String get easter_egg_cancel => 'उपयोग न करें';

  @override
  String get easter_egg_confirm => 'सरप्राइज का उपयोग करें';

  @override
  String get common_update_success => 'सफलतापूर्वक संशोधित किया गया';

  @override
  String get common_update_failed_try_again =>
      'संशोधन विफल रहा, कृपया बाद में पुनः प्रयास करें';

  @override
  String get no_voice_available => 'फिलहाल कोई वॉयस उपलब्ध नहीं है';

  @override
  String get gift_insufficient_title => 'अपरियाप्त शेष';

  @override
  String get gift_insufficient_prompt =>
      'क्या आप अधिक फानहुआ सिक्के प्राप्त करने जाना चाहते हैं?';

  @override
  String get not_now => 'अभी नहीं';

  @override
  String get go_to_get => 'प्राप्त करने जाएं';

  @override
  String get status_published => 'प्रकाशित';

  @override
  String get monthly_card_success_title =>
      '✨ प्रीमियम मासिक कार्ड सफलतापूर्वक अनलॉक हुआ!';

  @override
  String get monthly_card_success_subtitle =>
      'आपकी सदस्यता के लिए धन्यवाद! आपके विशेष विशेषाधिकार अब सक्रिय हैं:';

  @override
  String get monthly_card_perk_1 => 'तुरंत 250 टाइम फ्लावर्स प्राप्त करें';

  @override
  String get monthly_card_perk_2 =>
      'दैनिक लॉगिन करने पर अतिरिक्त 10 टाइम फ्लावर्स पाएं';

  @override
  String get monthly_card_perk_3 => 'विशेष स्नेह अंतःक्रिया सीमा को अनलॉक करें';

  @override
  String get monthly_card_start_perks => 'विशेषाधिकारों का आनंद लेना शुरू करें';

  @override
  String get tip_post_like =>
      'लाइक करने के बाद, आप इसे\nपसंदीदा सामग्री में देख सकते हैं';

  @override
  String get tip_post_bookmark =>
      'सहेजने के बाद, आप इसे\n\"मेरी बचत\" में देख सकते हैं';

  @override
  String get tip_time_echoes =>
      'अपना अनुभव छोड़ने के बाद\nखोज करते समय फ्लोटिंग कमेंट्स दिखाई देंगे';

  @override
  String get tip_call_memory =>
      'कॉल के बाद सहेजी गई वॉयस रिकॉर्डिंग\nयहाँ मिलेंगी!';

  @override
  String get tip_chat_notifications => 'यहाँ आप\nनया नोटिफिकेशन देख सकते हैं';

  @override
  String get tip_moments_wall_menu =>
      'कैरेक्टर पोस्ट शेड्यूल करने के लिए\nयहाँ टैप करें';

  @override
  String get forgot_password => 'पासवर्ड भूल गए?';

  @override
  String get forgot_password_empty_email =>
      'कृपया पहले अपना ईमेल दर्ज करें, फिर \'पासवर्ड भूल गए\' पर क्लिक करें';

  @override
  String get forgot_password_email_sent =>
      'पासवर्ड रीसेट ईमेल भेज दिया गया है। कृपया अपना इनबॉक्स देखें';

  @override
  String get forgot_password_error_default =>
      'पासवर्ड रीसेट ईमेल भेजने में विफल। कृपया बाद में पुनः प्रयास करें';

  @override
  String get forgot_password_error_invalid_email =>
      'ईमेल का प्रारूप सही नहीं है';

  @override
  String get forgot_password_error_user_not_found =>
      'इस ईमेल के साथ कोई खाता नहीं मिला';

  @override
  String forgot_password_error_with_message(String error) {
    return 'पासवर्ड रीसेट ईमेल भेजने में विफल: $error';
  }

  @override
  String get terms_not_accepted_toast =>
      'कृपया पहले उपयोग की शर्तें और समुदाय दिशानिर्देश पढ़ें और उनसे सहमत हों';

  @override
  String get terms_content =>
      'Lian Lian Shi Guang में आपका स्वागत है।\n\nइस सेवा का उपयोग करने से पहले, आपको इन उपयोग की शर्तों और समुदाय दिशानिर्देशों का पालन करने की सहमति देनी होगी।\n\nआप ऐसी कोई भी सामग्री अपलोड, निर्मित, प्रकाशित या प्रसारित नहीं कर सकते जो अवैध, उल्लंघनकारी, अश्लील, नग्नता से भरपूर, हिंसक, घृणास्पद, परेशान करने वाली, अपमानजनक, धोखाधड़ी वाली, स्पैम हो, या अन्यथा आपत्तिजनक, आक्रामक या दूसरों के अधिकारों को नुकसान पहुँचाने वाली हो।\n\nLian Lian Shi Guang अनुचित सामग्री और दुर्व्यवहार के खिलाफ शून्य-सहनशीलता (जीरो-टॉलरेंस) नीति अपनाता है। यदि कोई उपयोगकर्ता नियमों का उल्लंघन करता है, तो हम संबंधित सामग्री को हटा सकते हैं, सुविधाओं को सीमित कर सकते हैं, या खाते को निलंबित या समाप्त कर सकते हैं।\n\nउपयोगकर्ता ऐप की इन-बिल्ट रिपोर्ट और ब्लॉक सुविधाओं के माध्यम से अनुचित सामग्री या दुर्व्यवहार करने वाले उपयोगकर्ताओं की रिपोर्ट कर सकते हैं।';

  @override
  String get community_rules_title => 'समुदाय दिशानिर्देश';

  @override
  String get community_rules_content =>
      'Lian Lian Shi Guang रचनाकारों और उपयोगकर्ताओं के लिए एक सुरक्षित, मैत्रीपूर्ण और सम्मानजनक संवादात्मक वातावरण प्रदान करने की उम्मीद करता है।\n\nहम निम्नलिखित सामग्री या व्यवहार की अनुमति नहीं देते हैं:\n1. अश्लीलता, नग्नता या अनुचित यौन विचारोत्तेजक सामग्री\n2. दूसरों को परेशान करना, गाली देना, धमकाना या डराना\n3. घृणा, भेदभाव या हिंसा भड़काना\n4. खूनी, हिंसक या खतरनाक व्यवहार वाली सामग्री\n5. दूसरों के कॉपीराइट, पोर्ट्रेट अधिकारों या अन्य अधिकारों का उल्लंघन\n6. स्पैम, धोखाधड़ी या दुर्भावनापूर्ण व्यवहार\n7. अन्य आपत्तिजनक सामग्री या जो सार्वजनिक रूप से प्रदर्शित करने के लिए उपयुक्त न हो\n\nउपयोगकर्ता अनुचित सामग्री की रिपोर्ट कर सकते हैं और दुर्व्यवहार करने वाले उपयोगकर्ताओं को ब्लॉक भी कर सकते हैं। ब्लॉक करने के बाद, उस उपयोगकर्ता की सामग्री आपकी स्क्रीन पर फिर कभी प्रदर्शित नहीं होगी।';

  @override
  String get block_self_error => 'आप अपनी खुद की सामग्री को ब्लॉक नहीं कर सकते';

  @override
  String get block_user_title => 'इस उपयोगकर्ता को ब्लॉक करें?';

  @override
  String get block_user_content =>
      'ब्लॉक करने के बाद, आप इस उपयोगकर्ता द्वारा प्रकाशित सामग्री को नहीं देख पाएंगे।\nहमें भी एक नोटिफिकेशन मिलेगा और हम इसकी समीक्षा करेंगे।';

  @override
  String get block_user_success =>
      'इस उपयोगकर्ता को ब्लॉक कर दिया गया है, संबंधित सामग्री आपकी टाइम वॉल से हटा दी गई है';

  @override
  String get block_user_failed =>
      'ब्लॉक करने में विफल, कृपया बाद में पुनः प्रयास करें';

  @override
  String get terms_checkbox_read_agree => 'मैंने पढ़ लिया है और मैं सहमत हूँ';

  @override
  String get terms_checkbox_terms => '《उपयोग की शर्तें》';

  @override
  String get terms_checkbox_and => 'और';

  @override
  String get terms_checkbox_rules => '《समुदाय दिशानिर्देश》';

  @override
  String get hidden_moments => 'छिपे हुए पल';

  @override
  String get hide_moment_title => 'इस पल को छिपाएं?';

  @override
  String get hide_moment_content =>
      'छिपाने के बाद, यह पोस्ट आपकी टाइम वॉल पर फिर से दिखाई नहीं देगी।';

  @override
  String get hide => 'छिपाएं';

  @override
  String get hide_moment_success => 'इस पल को छिपा दिया गया है';

  @override
  String get hide_moment_failed =>
      'छिपाने में विफल, कृपया बाद में पुनः प्रयास करें';

  @override
  String get block_character_not_found =>
      'कैरेक्टर का डेटा नहीं मिला, ब्लॉक करने में असमर्थ';

  @override
  String get block_character_title => 'इस कैरेक्टर को ब्लॉक करें?';

  @override
  String block_character_content(String authorName) {
    return 'ब्लॉक करने के बाद, आप \"$authorName\" द्वारा प्रकाशित पलों को नहीं देख पाएंगे। यदि यह सामग्री नियमों का उल्लंघन करती है, तो हमें भी सूचित किया जाएगा और हम समीक्षा करेंगे।';
  }

  @override
  String block_character_success(String authorName) {
    return '\"$authorName\" को ब्लॉक कर दिया गया है, संबंधित पल छिपा दिए गए हैं';
  }

  @override
  String get block_character_failed =>
      'ब्लॉक करने में विफल, कृपया बाद में पुनः प्रयास करें';

  @override
  String get hidden_moments_title => 'छिपे हुए पल';

  @override
  String get hidden_moments_empty => 'फिलहाल कोई छिपा हुआ पल नहीं है';

  @override
  String get hidden_moments_load_failed => 'छिपे हुए पलों को लोड करने में विफल';

  @override
  String get hidden_moment_unknown_author => 'अज्ञात कैरेक्टर';

  @override
  String get hidden_moment_no_preview =>
      'इस पल के लिए कोई पूर्वावलोकन सामग्री उपलब्ध नहीं है';

  @override
  String get unhide_moment_title => 'अनहाइड करें?';

  @override
  String get unhide_moment_content =>
      'अनहाइड करने के बाद, यदि यह पोस्ट अभी भी मौजूद है, तो यह भविष्य में आपकी टाइम वॉल पर फिर से दिखाई दे सकती है।';

  @override
  String get unhide_moment_action => 'अनहाइड करें';

  @override
  String get unhide_moment_success => 'सफलतापूर्वक अनहाइड किया गया';

  @override
  String get report_moment_title => 'इस पल की रिपोर्ट करें';

  @override
  String get report_moment_content =>
      'क्या आप वाकई प्रबंधन टीम को इस पल की रिपोर्ट करना चाहते हैं? दुर्भावनापूर्ण सामग्री को छिपा या हटा दिया जाएगा।';

  @override
  String get report_confirm_button => 'रिपोर्ट की पुष्टि करें';

  @override
  String get report_success_message =>
      'हमें आपकी रिपोर्ट मिल गई है। समीक्षा टीम जल्द से जल्द इस पर कार्रवाई करेगी।';

  @override
  String get accountDeletionSubmittedTitle =>
      'खाता हटाने का अनुरोध जमा किया गया';

  @override
  String get accountDeletionSubmittedContent =>
      'ठीक है! हम आपके खाते के लिए 3 दिनों की छूट अवधि (ग्रेस पीरियड) रखेंगे।\n\nयदि आप खाता हटाना रद्द करना चाहते हैं, तो अपना खाता पुनर्स्थापित करने के लिए बस इस समय सीमा के भीतर फिर से लॉगिन करें।';

  @override
  String get restoreAccountDialogTitle => 'खाता हटाने का अनुरोध';

  @override
  String get restoreAccountDialogContent =>
      'आपका खाता वर्तमान में हटाए जाने की प्रक्रिया में है।\n\nयदि आप लॉगिन जारी रखते हैं, तो हटाने का अनुरोध रद्द कर दिया जाएगा और आपका खाता पुनर्स्थापित हो जाएगा।';

  @override
  String get cancelLoginButton => 'लॉगिन रद्द करें';

  @override
  String get restoreAccountButton => 'खाता पुनर्स्थापित करें';

  @override
  String get voice_preview => 'वॉयस चलाएं';

  @override
  String get voice_preview_failed => 'वॉयस चलाने में विफल';

  @override
  String get characterBannerSectionTitle => 'कैरेक्टर होमपेज बैनर';

  @override
  String get characterBannerDescription => 'बैनर विवरण';

  @override
  String get characterBannerRemove => 'हटाएं';

  @override
  String get characterBannerSelect => 'बैनर छवि चुनें';

  @override
  String get characterBannerChange => 'बैनर छवि बदलें';

  @override
  String get characterBannerSpecs =>
      'अनुशंसित अनुपात 16:9, अनुशंसित आकार 1920 × 1080';

  @override
  String get characterBannerDefaultHint =>
      'यदि सेट नहीं है, तो होमपेज स्वचालित रूप से कैरेक्टर का मुख्य अवतार उपयोग करेगा।';

  @override
  String get characterBannerHelpContent =>
      'बैनर कैरेक्टर के मुख्य पृष्ठ पर बड़े क्षैतिज क्षेत्र में प्रदर्शित होता है。\n\n16:9 क्षैतिज छवि का उपयोग करने की सलाह दी जाती है, जैसे 1920 × 1080।\n\nविभिन्न फ़ोन स्क्रीन आकारों पर क्रॉप होने से बचने के लिए मुख्य विषय और चेहरे को केंद्र के पास रखें।\n\nयदि कोई बैनर सेट नहीं है, तो सिस्टम स्वचालित रूप से कैरेक्टर के मुख्य अवतार का उपयोग करेगा।';

  @override
  String get first_meeting_title => 'पहली मुलाकात';

  @override
  String get common_delete_network_failed =>
      'हटाना विफल रहा। कृपया अपने नेटवर्क कनेक्शन की जांच करें और पुनः प्रयास करें';

  @override
  String get common_operation_failed_retry =>
      'ऑपरेशन विफल रहा। कृपया बाद में पुनः प्रयास करें';

  @override
  String exclusive_photo_number(int number) {
    return 'विशेष फोटो $number';
  }

  @override
  String get unlock_after_affection_increase =>
      'स्नेह स्तर बढ़ाने के बाद अनलॉक करें';

  @override
  String get first_meeting_empty => 'पहली मुलाकात, अभी शुरू होनी बाकी है...';

  @override
  String photo_load_failed(String error) {
    return 'फोटो लोड करने में विफल: $error';
  }

  @override
  String get add_friend_failed_retry =>
      'मित्र जोड़ने में विफल। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get remove_friend => 'मित्र को हटाएं';

  @override
  String get report_character => 'कैरेक्टर की रिपोर्ट करें';

  @override
  String get block_character => 'कैरेक्टर को ब्लॉक करें';

  @override
  String get daily_encounter => 'दैनिक मुलाकात';

  @override
  String get discovery_hall => 'खोज हॉल';

  @override
  String get latest_recommendation => 'नवीनतम सिफारिशें';

  @override
  String get popular_ranking => 'लोकप्रियता रैंकिंग';

  @override
  String get character_features => 'कैरेक्टर की विशेषताएं';

  @override
  String get featured_new_star => 'चमकता नया सितारा · विशेष सिफारिश';

  @override
  String get recently_added_characters => 'हाल ही में जोड़े गए नए कैरेक्टर';

  @override
  String get no_tag_data => 'वर्तमान में कोई टैग डेटा उपलब्ध नहीं है~';

  @override
  String get no_character_with_tag => 'इस टैग वाला कोई कैरेक्टर नहीं मिला';

  @override
  String get voice_search_failed_retry =>
      'वॉयस खोज विफल। कृपया पुनः प्रयास करें';

  @override
  String get voice_search_incomplete_retry =>
      'खोज अधूरी रही। कृपया बाद में पुनः प्रयास करें';

  @override
  String get voice_data_incomplete => 'वॉयस डेटा अधूरा है';

  @override
  String get voice_generation_failed_retry =>
      'वॉयस जनरेशन विफल। कृपया बाद में पुनः प्रयास करें';

  @override
  String get voice_playback_failed_retry =>
      'वॉयस प्लेबैक विफल। कृपया पुनः प्रयास करें';

  @override
  String get selected_voice_data_incomplete => 'चयनित वॉयस डेटा अधूरा है';

  @override
  String get private_voice_user_not_found =>
      'उपयोगकर्ता नहीं मिला। निजी कैरेक्टर वॉयस अपडेट करने में असमर्थ';

  @override
  String get voice_selected_character_save_failed =>
      'वॉयस चुनी गई, लेकिन कैरेक्टर डेटा सहेजने में विफल';

  @override
  String get voice_binding_failed => 'वॉयस बाइंडिंग विफल';

  @override
  String get play_voice_tooltip => 'वॉयस चलाएं';

  @override
  String get avatar_label => 'अवतार';

  @override
  String get message_preview_image => '[छवि]';

  @override
  String get message_preview_recording => '[रिकॉर्डिंग]';

  @override
  String get message_preview_voice => '[वॉयस मैसेज]';

  @override
  String get send_failed_retry =>
      'भेजने में विफल। कृपया बाद में पुनः प्रयास करें 😢';

  @override
  String get media_upload_failed_retry =>
      'मीडिया अपलोड विफल। कृपया पुनः प्रयास करें';

  @override
  String get ai_thinking_too_long =>
      'वह गहरे विचारों में मग्न लगता है। कृपया बाद में पुनः प्रयास करें...';

  @override
  String get ai_reply_in_progress =>
      'वह उत्तर दे रहा है। कृपया प्रतीक्षा करें और बार-बार न भेजें';

  @override
  String get ai_response_blocked =>
      'उसके विचारों में बाधा आई है। अधिक विनम्र तरीका अपनाएं!';

  @override
  String get microphone_permission_required =>
      'रिकॉर्ड करने के लिए माइक्रोफ़ोन अनुमति आवश्यक है';

  @override
  String get no_recording_to_send =>
      'भेजने के लिए कोई रिकॉर्डिंग उपलब्ध नहीं है';

  @override
  String get voice_uploading => 'वॉयस मैसेज अपलोड हो रहा है...';

  @override
  String get change_watermark_color => 'वॉटरमार्क का रंग बदलें';

  @override
  String get other_party_typing => 'सामने वाला टाइप कर रहा है...';

  @override
  String get chat_input_hint => 'कृपया लिखें...';

  @override
  String get regenerate_sync_failed =>
      'पुनर्जनन संख्या सिंक विफल। कृपया पुनः प्रयास करें 😢';

  @override
  String get creator_public_works => 'सार्वजनिक रचनाएं';

  @override
  String get creator_received_likes => 'प्राप्त लाइक';

  @override
  String get about_me => 'मेरे बारे में';

  @override
  String get moment_input_hint => 'अपनी भावनाएं साझा करें...';

  @override
  String character_play_count(int count) {
    return 'प्ले संख्या: $count';
  }

  @override
  String tag_page_title(String tag) {
    return 'टैग: #$tag';
  }

  @override
  String voice_preview_failed_detail(String code, String message) {
    return 'वॉयस पूर्वावलोकन विफल: $code $message';
  }

  @override
  String messages_deleted_success(int count) {
    return '$count संदेश सफलतापूर्वक हटा दिए गए';
  }

  @override
  String creator_work_load_failed(String error) {
    return 'रचनाएं लोड करने में विफल: $error';
  }

  @override
  String age_years_old(String age) {
    return '$age वर्ष';
  }

  @override
  String deleteFailedMessage(String error) {
    return 'हटाना विफल रहा: $error';
  }

  @override
  String loadCharacterDataFailed(String error) {
    return 'कैरेक्टर डेटा लोड करने में विफल: $error';
  }

  @override
  String get draftAvatarLoadFailed => 'ड्राफ्ट अवतार लोड करने में विफल:';

  @override
  String get unnamedCreator => 'गुमनाम निर्माता';

  @override
  String get profileNotYetFilled => 'बायो अभी तक नहीं भरा गया है';

  @override
  String get reportImageSizeLimit => 'छवि का आकार 10 MB से अधिक नहीं हो सकता';

  @override
  String reportImageSelectFailed(String error) {
    return 'रिपोर्ट छवि चुनने में विफल: $error';
  }

  @override
  String get reportImageCannotSelect =>
      'छवि चुनने में असमर्थ। कृपया बाद में पुनः प्रयास करें';

  @override
  String get reportLoginRequired => 'कृपया रिपोर्ट जमा करने से पहले लॉगिन करें';

  @override
  String get reportAnonymousPlayer => 'अनाम खिलाड़ी';

  @override
  String get reportSendSuccess =>
      'रिपोर्ट सफलतापूर्वक भेजी गई। आपकी प्रतिक्रिया के लिए धन्यवाद!';

  @override
  String reportSendFailed(String error) {
    return 'खिलाड़ी रिपोर्ट भेजने में विफल: $error';
  }

  @override
  String get reportNetworkFailed =>
      'भेजने में विफल। कृपया नेटवर्क जांचें और पुनः प्रयास करें';

  @override
  String get reportAttachImageLabel => 'छवि संलग्न करें (वैकल्पिक)';

  @override
  String get reportAttachImageHint =>
      'बग या गायब मुद्रा की रिपोर्ट करते समय, स्क्रीनशॉट संलग्न करने से हमारी टीम को तेजी से पुष्टि करने में मदद मिलती है।';

  @override
  String get reportOpeningAlbum => 'फोटो एल्बम खोला जा रहा है...';

  @override
  String get reportSelectFromAlbum => 'फोटो एल्बम से चुनें';

  @override
  String get reportSending => 'जमा किया जा रहा है...';

  @override
  String get reportSubmit => 'रिपोर्ट जमा करें';

  @override
  String get reportRemoveImage => 'छवि हटाएं';

  @override
  String get reportImageSelected => 'छवि चुनी गई';

  @override
  String get reportChangeImage => 'बदलें';

  @override
  String get reloadTranslation => 'अनुवाद पुनः लोड करें';

  @override
  String get guideNotAvailableInLanguage =>
      'गेम गाइड वर्तमान में इस भाषा में उपलब्ध नहीं है; अस्थायी रूप से पारंपरिक चीनी प्रदर्शित की जा रही है।';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String get memoPermissionWarning =>
      'नोटिफिकेशन अनुमति सक्षम नहीं है। मेमो सहेजा जाएगा, लेकिन सिस्टम रिमाइंडर नहीं दिखाई देंगे।';

  @override
  String memoSavedWithNotification(String name) {
    return 'मेमो सहेजा गया! $name आपको याद दिलाएगा!';
  }

  @override
  String get memoSavedNoPermission =>
      'मेमो सहेजा गया, लेकिन नोटिफिकेशन अनुमति चालू नहीं है।';

  @override
  String memoUpdatedWithNotification(String name) {
    return 'मेमो अपडेट किया गया! $name आपको याद दिलाएगा!';
  }

  @override
  String get memoUpdatedNoPermission =>
      'मेमो अपडेट किया गया, लेकिन वर्तमान में कोई नोटिफिकेशन अनुमति नहीं है।';

  @override
  String dataLoadError(String error) {
    return 'डेटा लोड करते समय एक त्रुटि हुई: $error';
  }

  @override
  String loadFailed(String error) {
    return 'लोड होना विफल: $error';
  }

  @override
  String get dateFormatMonthDay => 'd MMM';

  @override
  String get timeFormatHourMinute => 'HH:mm';

  @override
  String get likeFeedPrompt =>
      'क्या आपको यह पोस्ट पसंद आई? उसे थोड़ा प्यार भेजें!';

  @override
  String get saveFeedPocket => 'खास पलों को चुपके से अपनी जेब में सहेजें।';

  @override
  String get newComment => 'नया कमेंट';

  @override
  String get someFriend => 'एक दोस्त';

  @override
  String get myBackpackAndPrivileges => 'मेरा बैकपैक और विशेषाधिकार';

  @override
  String get currentRomanticBond => 'वर्तमान में संचित रोमांटिक बंधन';

  @override
  String get physicalGiftBoxUnlockStatus => 'भौतिक उपहार बॉक्स अनलॉक स्थिति:';

  @override
  String get topLovePhysicalVipBox =>
      'विशेष VIP भौतिक उपहार बॉक्स 【सर्वश्रेष्ठ प्रेम】';

  @override
  String get physicalGiftBoxContents =>
      'शामिल हैं: हस्तलिखित पत्र + कैरेक्टर गुड़िया + आधिकारिक धन्यवाद पत्र';

  @override
  String get modifyShippingAddress => 'शिपिंग पता बदलें';

  @override
  String get addressUnlockedFillNow =>
      'अनलॉक हो गया! शिपिंग जानकारी भरने के लिए यहाँ टैप करें';

  @override
  String get addressSuccessfullyRegistered =>
      'आपने अपना शिपिंग पता सफलतापूर्वक पंजीकृत कर लिया है, हम इसे जल्द ही तैयार करेंगे!';

  @override
  String amountNeededForPhysicalPrize(String amount) {
    return 'भौतिक पुरस्कार अनलॉक करने के लिए अभी NT\$ $amount और चाहिए!';
  }

  @override
  String get avatarFrameHint =>
      'संकेत: आप स्टोर या सेटिंग्स में अन्य डिजिटल स्किन और अवतार फ्रेम देख और लगा सकते हैं।';

  @override
  String get closeButton => 'बंद करें';

  @override
  String get physicalGiftBoxUnlockTitle =>
      'भौतिक उपहार बॉक्स अनलॉक 【सर्वश्रेष्ठ प्रेम】';

  @override
  String get physicalGiftBoxUnlockThanks =>
      'Lian Lian Shi Guang के प्रति आपके अपार समर्पण के लिए धन्यवाद!';

  @override
  String get physicalGiftBoxUnlockPrompt =>
      'कृपया निम्नलिखित शिपिंग विवरण भरें ताकि हम आपका हस्तलिखित पत्र और गुड़िया भेज सकें:';

  @override
  String get recipientRealName => 'प्राप्तकर्ता का असली नाम';

  @override
  String get contactPhone => 'संपर्क फोन नंबर';

  @override
  String get fullShippingAddress => 'पूरा शिपिंग पता (पिन कोड सहित)';

  @override
  String get desiredCharacterDollName => 'मनचाही कैरेक्टर गुड़िया का नाम';

  @override
  String get characterNameExample => 'उदा.: मनचाहे कैरेक्टर का नाम';

  @override
  String get fillLater => 'बाद में भरें';

  @override
  String get fillCompleteAddressAndRoleHint =>
      'कृपया शिपिंग जानकारी और मनचाहे कैरेक्टर का नाम पूरी तरह भरें!';

  @override
  String get shippingInfoSubmittedSuccess =>
      'शिपिंग जानकारी सफलतापूर्वक भेजी गई! हमारे भौतिक सरप्राइज का इंतजार करें!';

  @override
  String get confirmSubmit => 'पुष्टि करें और जमा करें';

  @override
  String get aboutMe => 'मेरे बारे में';

  @override
  String get myBackpack => 'मेरा बैकपैक';

  @override
  String get ownerExclusiveArea => 'मालिक का विशेष क्षेत्र';

  @override
  String get enterShiguangAdminBackend =>
      'Shiguang एडमिन कंसोल में प्रवेश करें';

  @override
  String get errorOccurred => 'एक त्रुटि हुई';

  @override
  String get creatorGuidelines => 'निर्माता दिशानिर्देश';

  @override
  String get playGuide => 'गेम गाइड';

  @override
  String get lianlianShiguang => 'Lian Lian Shi Guang';

  @override
  String get copyrightNotice => '© 2026 Mo Yu Bai';

  @override
  String get cumulativeBenefits => 'संचित पुरस्कार';

  @override
  String get perkFirstEncounter => 'पहला आकर्षण';

  @override
  String get perkFirstEncounterReward => '20 फूल + विशेष नौसिखिया शीर्षक';

  @override
  String get perkGlimmerThrob => 'धुंधली धड़कन';

  @override
  String get perkGlimmerThrobReward => 'विशेष अवतार फ्रेम 【धुंधली धड़कन】';

  @override
  String get perkStarryWhisper => 'तारों भरी फुसफुसाहट';

  @override
  String get perkStarryWhisperReward => 'विशेष चैट बबल + 50 फूल';

  @override
  String get perkRomanticSunset => 'रोमांटिक सूर्यास्त';

  @override
  String get perkRomanticSunsetReward => 'विशेष ऐप आइकन';

  @override
  String get perkHeartbeat => 'दिल की धड़कन';

  @override
  String get perkHeartbeatReward => 'स्क्रीन टैप इफेक्ट + 100 फूल';

  @override
  String get perkEternalVow => 'शाश्वत वचन';

  @override
  String get perkEternalVowReward => 'उन्नत एनिमेटेड अवतार फ्रेम + 200 फूल';

  @override
  String get perkSoulIntersection => 'आत्माओं का मिलन';

  @override
  String get perkSoulIntersectionReward =>
      'एनिमेटेड चैट बबल इफेक्ट + विशेष उन्नत शीर्षक';

  @override
  String get perkExclusiveWait => 'विशेष समर्पण';

  @override
  String get perkExclusiveWaitReward => 'प्रीमियम एनिमेटेड नेमप्लेट + 500 फूल';

  @override
  String get perkBrilliantGalaxy => 'शानदार आकाशगंगा';

  @override
  String get perkBrilliantGalaxyReward =>
      'विशेष एंट्री इफेक्ट + समर्पित ग्राहक सेवा';

  @override
  String get perkTopBeloved => 'सर्वश्रेष्ठ प्रेम';

  @override
  String get perkTopBelovedReward => 'विशेष VIP भौतिक उपहार बॉक्स';

  @override
  String get cumulativeRomanticBond => 'संचित रोमांटिक बंधन';

  @override
  String get allTopPrivilegesUnlocked =>
      'आपने सभी शीर्ष विशेषाधिकार अनलॉक कर लिए हैं!';

  @override
  String rechargeAmountForNextTier(String amount) {
    return 'अगला स्तर अनलॉक करने के लिए NT\$ $amount का रीचार्ज करें';
  }

  @override
  String get storyContentCannotBeEmpty => 'कहानी की सामग्री खाली नहीं हो सकती';

  @override
  String get writeYourStoryHint => 'अपनी कहानी लिखें...';

  @override
  String get characterBannerTitle => 'कैरेक्टर होमपेज बैनर';

  @override
  String get mailDeleteTitle => 'संदेश हटाएँ';

  @override
  String mailDeleteConfirm(int count) {
    return 'क्या आप वाकई $count संदेश हटाना चाहते हैं?\nहटाने के बाद उन्हें वापस नहीं पाया जा सकता।';
  }

  @override
  String mailDeleteSuccess(int count) {
    return '$count संदेश हटा दिए गए';
  }

  @override
  String get mailDeleteFailed =>
      'हटाना विफल रहा। कृपया बाद में फिर प्रयास करें।';

  @override
  String get mailCancelSelection => 'चयन रद्द करें';

  @override
  String mailSelectedCount(int count) {
    return '$count चयनित';
  }

  @override
  String get moreOptions => 'अधिक';

  @override
  String mailDeleteSelected(int count) {
    return '$count संदेश हटाएँ';
  }

  @override
  String get officialManagementTeam => 'LoveyDovey प्रबंधन टीम';

  @override
  String get rewardCampaignTitle => 'इवेंट उपहार';

  @override
  String get rewardCampaignMissingData =>
      'इस उपहार संदेश में इवेंट का डेटा नहीं है। कृपया बाद में फिर प्रयास करें।';

  @override
  String rewardCampaignClaimSuccess(int amount) {
    return '$amount फूल प्राप्त हुए';
  }

  @override
  String get rewardCampaignAlreadyClaimed =>
      'यह उपहार पहले ही प्राप्त किया जा चुका है';

  @override
  String get rewardCampaignClaimFailed =>
      'प्राप्त करना विफल रहा। कृपया बाद में फिर प्रयास करें।';

  @override
  String get rewardCampaignContains => 'इस संदेश में है';

  @override
  String rewardCampaignFlowerAmount(int amount) {
    return '$amount फूल';
  }

  @override
  String rewardCampaignDeadline(String date) {
    return 'प्राप्त करने की अंतिम तिथि: $date';
  }

  @override
  String get rewardCampaignClaiming => 'प्राप्त किया जा रहा है…';

  @override
  String get rewardCampaignClaimed => 'प्राप्त हुआ';

  @override
  String get rewardCampaignEnded => 'इवेंट समाप्त हो गया';

  @override
  String get rewardCampaignClaimButton => 'उपहार प्राप्त करें';

  @override
  String get mailDetailTitle => 'संदेश';

  @override
  String mailSender(String name) {
    return 'प्रेषक: $name';
  }

  @override
  String get mailCaseNumber => 'मामला संख्या';

  @override
  String get mailCopyCaseNumber => 'मामला संख्या कॉपी करें';

  @override
  String get mailCaseNumberCopied => 'मामला संख्या कॉपी हो गई';

  @override
  String get profilePageAboutMe => '📝 मेरे बारे में';

  @override
  String get profilePageTabBio => 'परिचय';

  @override
  String get profilePageTabCharacters => 'पात्र';

  @override
  String get profilePageTabMoments => 'पोस्ट';

  @override
  String get profilePageEditProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profilePageFriends => 'दोस्त';

  @override
  String get profilePageWorks => 'रचनाएँ';

  @override
  String get profilePageFollowing => 'फ़ॉलो किए गए';

  @override
  String get profilePageFollowers => 'फ़ॉलोअर्स';

  @override
  String get profilePageHeartbeatDiary => 'दिल की धड़कनों की डायरी';

  @override
  String get profilePageEditCharacter => 'पात्र संपादित करें';

  @override
  String get profilePagePreviewCharacter =>
      'पात्र की प्रोफ़ाइल का पूर्वावलोकन करें';

  @override
  String get profilePageNoBio => 'अभी तक कोई परिचय नहीं है';

  @override
  String get profilePageNoBioHint => 'अपने बारे में लिखने के लिए टैप करें।';

  @override
  String get profilePageCreateCharacter => 'नया पात्र बनाएँ';

  @override
  String get profilePageNoCharacters => 'अभी तक कोई पात्र नहीं बनाया गया है';

  @override
  String get profilePageNoCharactersHint => 'अपना पहला पात्र बनाना शुरू करें।';

  @override
  String get profilePageCharacterActions => 'पात्र की कार्रवाइयाँ';

  @override
  String get profilePagePublic => 'सार्वजनिक';

  @override
  String get profilePagePrivate => 'निजी';

  @override
  String get profilePageCreator => 'निर्माता';

  @override
  String get profilePageSelectPostingIdentity => 'पोस्ट करने की पहचान चुनें';

  @override
  String get profilePagePostAsCreator => 'निर्माता के रूप में पोस्ट करें';

  @override
  String get profilePagePublicCharacter => 'सार्वजनिक पात्र';

  @override
  String get profilePagePrivateCharacter => 'निजी पात्र';

  @override
  String get profilePagePleaseSignIn => 'कृपया पहले साइन इन करें';

  @override
  String get profilePagePublishMoment => 'पोस्ट प्रकाशित करें';

  @override
  String get profilePageFilterAll => 'सभी';

  @override
  String get profilePageFilterCreator => 'मैं';

  @override
  String get profilePageFilterCharacter => 'पात्र';

  @override
  String get profilePageMomentsLoadFailed => 'पोस्ट लोड नहीं हो सकीं';

  @override
  String get profilePageTryAgainLater => 'कृपया बाद में फिर प्रयास करें।';

  @override
  String get profilePageNoCreatorMoments =>
      'आपने अभी तक कोई पोस्ट प्रकाशित नहीं की है';

  @override
  String get profilePageNoCreatorMomentsHint =>
      'निर्माता के रूप में प्रकाशित सामग्री यहाँ दिखाई देगी।';

  @override
  String get profilePageNoCharacterMoments =>
      'आपके पात्रों ने अभी तक कोई पोस्ट प्रकाशित नहीं की है';

  @override
  String get profilePageNoCharacterMomentsHint =>
      'पात्र के रूप में प्रकाशित सामग्री यहाँ दिखाई देगी।';

  @override
  String get profilePageNoMoments => 'अभी तक कोई पोस्ट नहीं है';

  @override
  String get profilePageNoMomentsHint =>
      'आपके और आपके पात्रों द्वारा प्रकाशित पोस्ट यहाँ दिखाई देंगी।';

  @override
  String get profilePageDeleteMomentTitle => 'पोस्ट हटाएँ';

  @override
  String get profilePageDeleteMomentConfirm =>
      'क्या आप वाकई इस पोस्ट को स्थायी रूप से हटाना चाहते हैं?';

  @override
  String get profilePageCancel => 'रद्द करें';

  @override
  String get profilePageDelete => 'हटाएँ';

  @override
  String get profilePageMomentDeleted => 'पोस्ट हटा दी गई';

  @override
  String get profilePageDeleteFailed =>
      'हटाना विफल रहा। कृपया बाद में फिर प्रयास करें।';

  @override
  String get profilePageReferralCompleted => 'सितारा आमंत्रण पूरा हुआ';

  @override
  String profilePageInviter(String inviterId) {
    return 'आमंत्रित करने वाला: $inviterId';
  }

  @override
  String get profilePageReferralRewardReceived => 'दोनों को 50 फूल मिल गए हैं';

  @override
  String get profilePageClaimed => 'प्राप्त किया गया';

  @override
  String profilePageInviterBound(String inviterId) {
    return 'आमंत्रित करने वाला लिंक हो गया: $inviterId';
  }

  @override
  String get profilePageReferralProgressHint =>
      'चैट के 15 संदेश पूरे करने के बाद दोनों को 50 फूल मिलेंगे';

  @override
  String get profilePageAlreadyCheckedIn => 'आप आज पहले ही चेक-इन कर चुके हैं';

  @override
  String get profilePageReferralBindFailed =>
      'लिंक करना विफल रहा। कृपया बाद में फिर प्रयास करें।';

  @override
  String get profilePageCharacterNotFound => 'इस पात्र का डेटा नहीं मिला';

  @override
  String get periodGuideTitle => 'मासिक धर्म डायरी का उपयोग कैसे करें?';

  @override
  String get periodGuideContent =>
      '① सबसे पहले कैलेंडर पर कोई तारीख चुनें।\n② “आज शुरू हुआ”, “मासिक धर्म अभी जारी है” या “आज समाप्त हुआ” चुनें।\n③ आज की मनोदशा और शारीरिक स्थिति चुनें। आप अपनी ओर से अतिरिक्त जानकारी भी लिख सकती हैं।\n④ सेव दबाएँ, ताकि चैट के दौरान पात्र आपकी आज की स्थिति समझ सके।\n\nअनुमानित तारीखें आपके पिछले रिकॉर्ड के आधार पर समायोजित होंगी और केवल व्यक्तिगत रिकॉर्ड के संदर्भ के लिए हैं।';

  @override
  String get periodGotIt => 'समझ गई';

  @override
  String get periodSelectAtLeastOne =>
      'कृपया रिकॉर्ड करने के लिए कम से कम एक विकल्प चुनें';

  @override
  String get periodFutureDateError =>
      'भविष्य की तारीख पर मासिक धर्म की स्थिति दर्ज नहीं की जा सकती।';

  @override
  String get periodAlreadyOngoingError =>
      'मासिक धर्म का एक रिकॉर्ड पहले से जारी है। कृपया पहले उसे समाप्त करें।';

  @override
  String get periodNoOngoingError =>
      'अभी कोई मासिक धर्म जारी नहीं है। कृपया पहले “आज शुरू हुआ” चुनें।';

  @override
  String get periodBeforeStartError =>
      'तारीख वर्तमान मासिक धर्म की शुरुआत की तारीख से पहले की नहीं हो सकती।';

  @override
  String get periodEndBeforeStartError =>
      'समाप्ति की तारीख शुरुआत की तारीख से पहले की नहीं हो सकती।';

  @override
  String periodRecordSaved(String date) {
    return '$date का रिकॉर्ड सेव हो गया';
  }

  @override
  String get periodSaveFailed =>
      'सेव करना विफल रहा। कृपया बाद में फिर प्रयास करें';

  @override
  String get periodDeleteTitle => 'मासिक धर्म का यह रिकॉर्ड हटाएँ?';

  @override
  String get periodDeleteContent =>
      'हटाने के बाद औसत चक्र और अगले अनुमान की दोबारा गणना की जाएगी।';

  @override
  String get periodCancel => 'रद्द करें';

  @override
  String get periodDelete => 'हटाएँ';

  @override
  String get periodNoOngoing => 'अभी कोई मासिक धर्म जारी नहीं है';

  @override
  String periodDayCount(int count) {
    return 'मासिक धर्म का $countवाँ दिन';
  }

  @override
  String get periodHelp => 'उपयोग निर्देश';

  @override
  String get periodAverageCycle => 'औसत चक्र';

  @override
  String get periodAverageDuration => 'मासिक धर्म की औसत अवधि';

  @override
  String periodDays(int count) {
    return '$count दिन';
  }

  @override
  String get periodNextPrediction => 'अगला अनुमान';

  @override
  String get periodCalculatedAfterRecording => 'रिकॉर्ड करने के बाद गणना होगी';

  @override
  String get periodInsufficientData =>
      'अभी पर्याप्त डेटा उपलब्ध नहीं है। फिलहाल 28 दिनों के चक्र और 5 दिनों के मासिक धर्म के आधार पर अनुमान लगाया जाएगा।';

  @override
  String get periodPredictionDisclaimer =>
      'यह अनुमान मौजूदा रिकॉर्ड पर आधारित है। तारीखें केवल व्यक्तिगत रिकॉर्ड के संदर्भ के लिए हैं।';

  @override
  String get periodStartedToday => '🩸 आज शुरू हुआ';

  @override
  String get periodStillOngoing => 'मासिक धर्म अभी जारी है';

  @override
  String get periodEndedToday => 'आज समाप्त हुआ';

  @override
  String get periodDateNotReached => 'यह दिन अभी आया नहीं है～';

  @override
  String get periodDateBeforeStart =>
      'यह तारीख वर्तमान मासिक धर्म की शुरुआत की तारीख से पहले की है।';

  @override
  String get periodMoodOkay => 'काफ़ी अच्छा';

  @override
  String get periodMoodHappy => 'खुश';

  @override
  String get periodMoodLow => 'उदास';

  @override
  String get periodMoodUnwell => 'अस्वस्थ';

  @override
  String get periodMoodIrritable => 'चिड़चिड़ी';

  @override
  String get periodMoodTired => 'थकी हुई';

  @override
  String get periodMoodAnxious => 'चिंतित';

  @override
  String get periodSymptomAbdominalPain => 'पेट दर्द';

  @override
  String get periodSymptomLowerBackPain => 'कमर दर्द';

  @override
  String get periodSymptomHeadache => 'सिरदर्द';

  @override
  String get periodSymptomBreastTenderness => 'स्तनों में दर्द';

  @override
  String get periodSymptomSwelling => 'सूजन';

  @override
  String get periodSymptomSleepy => 'नींद आना';

  @override
  String get periodSymptomIncreasedAppetite => 'भूख बढ़ना';

  @override
  String get periodSymptomDigestiveDiscomfort => 'पाचन संबंधी परेशानी';

  @override
  String periodDiaryTitle(String characterName) {
    return '$characterName की देखभाल भरी डायरी';
  }

  @override
  String get periodLoadFailed =>
      'रिकॉर्ड लोड नहीं हो सके। कृपया बाद में फिर प्रयास करें';

  @override
  String get periodWeekdaySun => 'रवि';

  @override
  String get periodWeekdayMon => 'सोम';

  @override
  String get periodWeekdayTue => 'मंगल';

  @override
  String get periodWeekdayWed => 'बुध';

  @override
  String get periodWeekdayThu => 'गुरु';

  @override
  String get periodWeekdayFri => 'शुक्र';

  @override
  String get periodWeekdaySat => 'शनि';

  @override
  String get periodSaveInstruction =>
      'स्थिति चुनने के बाद उसे सुरक्षित करने के लिए सबसे नीचे “आज का रिकॉर्ड सेव करें” दबाएँ।';

  @override
  String get periodTodayMood => 'आज की मनोदशा (एक से अधिक चुन सकती हैं)';

  @override
  String get periodMoodDescription =>
      'ये उस दिन की डायरी प्रविष्टियाँ हैं, कैलेंडर पर दिखने वाले चिह्न नहीं।';

  @override
  String get periodOtherMood => 'अन्य मनोदशा';

  @override
  String get periodOtherMoodHint => 'उदाहरण: आहत, असुरक्षित महसूस करना……';

  @override
  String get periodTodaySymptoms =>
      'आज की शारीरिक स्थिति (एक से अधिक चुन सकती हैं)';

  @override
  String get periodOtherSymptom => 'अन्य शारीरिक स्थिति';

  @override
  String get periodOtherSymptomHint => 'उदाहरण: ठंड लगना, भूख न लगना……';

  @override
  String periodNoteForCharacter(String characterName) {
    return 'आप $characterName को क्या बताना चाहती हैं? (वैकल्पिक)';
  }

  @override
  String get periodNoteHint =>
      'उदाहरण: आज मैं शांति से आराम करना चाहती हूँ और किसी का दबाव नहीं चाहती……';

  @override
  String get periodSaving => 'सेव हो रहा है…';

  @override
  String get periodSaveToday => 'आज का रिकॉर्ड सेव करें';

  @override
  String get periodHistory => 'मासिक धर्म का इतिहास';

  @override
  String get periodOngoing => 'जारी है';

  @override
  String periodTotalDays(int count) {
    return 'कुल $count दिन';
  }

  @override
  String get periodDeleteRecord => 'रिकॉर्ड हटाएँ';

  @override
  String get privateProfilePleaseSignIn => 'कृपया पहले साइन इन करें';

  @override
  String privateProfileLoreLoadFailed(String error) {
    return 'स्मृति अंश लोड नहीं हो सके: $error';
  }

  @override
  String privateProfileWriteNewLore(int count, int limit) {
    return 'नया स्मृति अंश लिखें ($count / $limit)';
  }

  @override
  String get privateProfileNoLore => 'अभी तक कोई स्मृति अंश नहीं है';

  @override
  String get privateProfileNoLoreHint =>
      'आप यहाँ परीक्षण सेटिंग्स, कहानी के संकेत और पात्र की महत्वपूर्ण यादों को व्यवस्थित कर सकते हैं।';

  @override
  String get privateProfileUntitledLore => 'शीर्षकहीन अंश';

  @override
  String get privateProfileEdit => 'संपादित करें';

  @override
  String get privateProfileDelete => 'हटाएँ';

  @override
  String get privateProfileAddLore => 'स्मृति अंश जोड़ें';

  @override
  String get privateProfileLoreTitle => 'शीर्षक';

  @override
  String get privateProfileLoreTeaser => 'संक्षिप्त संकेत';

  @override
  String get privateProfileLoreContent => 'पूरा विवरण';

  @override
  String get privateProfileLockLore => 'अंश लॉक करें';

  @override
  String get privateProfileLockLoreHint =>
      'निजी पात्र अभी केवल निर्माता को दिखाई देता है। पात्र को सार्वजनिक किए जाने पर उपयोग के लिए यह फ़ील्ड सुरक्षित रहेगा।';

  @override
  String get privateProfileCancel => 'रद्द करें';

  @override
  String get privateProfileTitleContentRequired => 'कृपया शीर्षक और विवरण भरें';

  @override
  String get privateProfileLoreAdded => 'स्मृति अंश जोड़ दिया गया';

  @override
  String get privateProfileAddFailed =>
      'जोड़ना विफल रहा। कृपया बाद में फिर प्रयास करें';

  @override
  String get privateProfilePublish => 'प्रकाशित करें';

  @override
  String get privateProfileDeleteLoreTitle => 'स्मृति अंश हटाएँ';

  @override
  String get privateProfileDeleteLoreConfirm =>
      'क्या आप वाकई इस स्मृति अंश को स्थायी रूप से हटाना चाहते हैं?';

  @override
  String get privateProfileLoreDeleted => 'स्मृति अंश हटा दिया गया';

  @override
  String get privateProfileDeleteFailed =>
      'हटाना विफल रहा। कृपया बाद में फिर प्रयास करें';

  @override
  String get privateProfileEditLore => 'स्मृति अंश संपादित करें';

  @override
  String get privateProfileSave => 'सेव करें';

  @override
  String get editProfileBirthdayReminderTitle => '🎂 छोटा-सा अनुस्मारक';

  @override
  String get editProfileBirthdayReminderContent =>
      'आपकी जन्मतिथि पात्रों की ओर से मिलने वाली जन्मदिन की शुभकामनाओं, उपहारों और संबंधित कार्यक्रमों को प्रभावित करेगी।\n\nहम सुझाव देते हैं कि सेटिंग पूरी करने से पहले अपनी जन्मतिथि की पुष्टि कर लें,\nताकि भविष्य में मिलने वाले जन्मदिन के पुरस्कार प्रभावित न हों।';

  @override
  String get editProfileGotIt => 'समझ गई';

  @override
  String get editProfileBirthdayConfirmTitle => '🎂 जन्मतिथि की पुष्टि करें';

  @override
  String get editProfileBirthdayConfirmContent =>
      'कृपया पुष्टि करें कि आपकी जन्मतिथि सही है।\n\nआपकी जन्मतिथि का उपयोग जन्मदिन की शुभकामनाओं, उपहारों और संबंधित कार्यक्रमों के लिए किया जाएगा।\n\nजन्मदिन के पुरस्कार को एक से अधिक बार प्राप्त करने से रोकने के लिए, सेटिंग पूरी होने के बाद जन्मतिथि दोबारा नहीं बदली जा सकेगी।\n\nक्या आप निश्चित रूप से इस जन्मतिथि का उपयोग करना चाहती हैं?';

  @override
  String get editProfileReturnToEdit => 'वापस जाकर बदलें';

  @override
  String get editProfileConfirmSetting => 'सेटिंग की पुष्टि करें';

  @override
  String get editProfileDefaultNickname => 'नई मुलाकात का यात्री';

  @override
  String get editProfileNoChanges => 'सेव करने के लिए कोई बदलाव नहीं है';

  @override
  String editProfileCreateFailed(String error) {
    return 'डेटा बनाने में विफल: $error';
  }

  @override
  String editProfileAvatarNumber(int number) {
    return 'प्रोफ़ाइल चित्र $number';
  }

  @override
  String get editProfileImageSelectionFailed =>
      'चित्र चुनना विफल रहा। कृपया दूसरा चित्र चुनें';

  @override
  String get editProfileCancel => 'रद्द करें';

  @override
  String get editProfileConfirm => 'पुष्टि करें';

  @override
  String get editProfileImageProcessingFailed =>
      'चित्र संसाधित करना विफल रहा। कृपया दूसरा चित्र चुनें';

  @override
  String editProfileLoadFailed(String error) {
    return 'डेटा लोड करना विफल रहा: $error';
  }

  @override
  String get editProfileBioLabel => 'परिचय';

  @override
  String get editProfileBioHelper =>
      'अपने बारे में या अपनी रचनात्मक शैली के बारे में संक्षेप में बताएँ';

  @override
  String get editProfileBioHint =>
      'उदाहरण: मुझे काल्पनिक, जुनूनी और रोमांचक प्रेम पात्र बनाना पसंद है।';

  @override
  String get editProfileUserNotFound => 'उपयोगकर्ता नहीं मिला';

  @override
  String get editProfileGenerateIdFailed =>
      'खिलाड़ी ID बनाना विफल रहा। कृपया फिर प्रयास करें';

  @override
  String get editProfileSignedInUserNotFound =>
      'वर्तमान में साइन इन किया हुआ उपयोगकर्ता नहीं मिला';

  @override
  String editProfileAvatarReadFailed(int statusCode) {
    return 'प्रोफ़ाइल चित्र लोड करना विफल रहा, स्थिति कोड: $statusCode';
  }

  @override
  String editProfileAvatarFileNotFound(String path) {
    return 'चुनी गई प्रोफ़ाइल चित्र फ़ाइल नहीं मिली: $path';
  }

  @override
  String get editProfileAvatarEmpty => 'प्रोफ़ाइल चित्र का डेटा खाली है';

  @override
  String get chatPageSendFailed =>
      'भेजना विफल रहा। कृपया बाद में फिर प्रयास करें 😢';

  @override
  String get chatPageRegenerateFailed =>
      'दोबारा बनाना विफल रहा। मूल संदेश सुरक्षित रखा गया है। कृपया फिर प्रयास करें।';

  @override
  String get chatPageRegenerating => '💭 फिर से सोच रहा है...';

  @override
  String get chatPageThinkingTooLong =>
      'ऐसा लगता है कि वह गहरी सोच में है। कृपया बाद में फिर प्रयास करें……';

  @override
  String get chatPageAlreadyReplying =>
      'वह जवाब दे रहा है। कृपया थोड़ी देर प्रतीक्षा करें और दोबारा न भेजें';

  @override
  String get chatPageMediaUploadFailed =>
      'मीडिया अपलोड करना विफल रहा। कृपया फिर प्रयास करें';

  @override
  String get chatPageReportReceived =>
      'आपकी रिपोर्ट के लिए धन्यवाद। हम जल्द से जल्द इसकी जाँच करेंगे';

  @override
  String chatPageMessagesDeleted(int count) {
    return '✅ $count संदेश सफलतापूर्वक हटा दिए गए';
  }

  @override
  String chatPageSelectPhotoFailed(String error) {
    return 'फ़ोटो नहीं चुनी जा सकी: $error';
  }

  @override
  String get chatPageRecordingNotFound => 'रिकॉर्डिंग फ़ाइल नहीं मिली';

  @override
  String get chatPageRecordingEmpty => 'रिकॉर्डिंग फ़ाइल खाली है';

  @override
  String chatPageAudioPlaybackFailed(String error) {
    return 'ऑडियो चलाना विफल रहा: $error';
  }

  @override
  String get chatPageMicrophonePermissionRequired =>
      'रिकॉर्ड करने के लिए माइक्रोफ़ोन की अनुमति आवश्यक है';

  @override
  String chatPageStartRecordingFailed(String error) {
    return 'रिकॉर्डिंग शुरू नहीं की जा सकी: $error';
  }

  @override
  String get chatPageRecordingCreationFailed =>
      'रिकॉर्डिंग फ़ाइल बनाना विफल रहा। कृपया दोबारा रिकॉर्ड करें';

  @override
  String chatPageRecordingFailed(String error) {
    return 'रिकॉर्डिंग विफल रही: $error';
  }

  @override
  String get chatPageRecordingNotFoundRetry =>
      'रिकॉर्डिंग फ़ाइल नहीं मिली। कृपया दोबारा रिकॉर्ड करें';

  @override
  String get chatPageRecordingEmptyRetry =>
      'रिकॉर्डिंग फ़ाइल खाली है। कृपया दोबारा रिकॉर्ड करें';

  @override
  String get chatPageNoRecordingToSend => 'भेजने के लिए कोई रिकॉर्डिंग नहीं है';

  @override
  String chatPagePointCost(int count) {
    return '$count अंक';
  }

  @override
  String get chatPageVoiceUploading => 'वॉइस रिकॉर्डिंग अपलोड हो रही है……';

  @override
  String get chatPageChangeWatermarkColor => 'वॉटरमार्क का रंग बदलें';

  @override
  String chatPageMinutesSeconds(int minutes, int seconds) {
    return '$minutes मिनट $seconds सेकंड';
  }

  @override
  String chatPageSeconds(int seconds) {
    return '$seconds सेकंड';
  }

  @override
  String get characterEditSelectSupportingCharacter =>
      'कृपया एक सहायक पात्र चुनें।';

  @override
  String get characterEditSelectGender => 'कृपया पात्र का लिंग चुनें।';

  @override
  String get characterEditCharacterSettings => 'पात्र की सेटिंग';

  @override
  String get characterEditWorldview => 'विश्व की रूपरेखा';

  @override
  String get characterEditSettingsMinLength =>
      'पात्र की सेटिंग में कम से कम 10 अक्षर होने चाहिए।';

  @override
  String get characterEditWorldviewMinLength =>
      'विश्व की रूपरेखा में कम से कम 20 अक्षर होने चाहिए।';

  @override
  String get characterEditSupportingCharacters => 'सहायक पात्र';

  @override
  String get characterEditCharacterImage => 'पात्र की तस्वीर';

  @override
  String get characterEditWorldviewHint =>
      'विश्व की पृष्ठभूमि, इतिहास, युग, क्षेत्र, शक्तियाँ, व्यवस्थाएँ, तकनीक, जादू और नियमों का वर्णन करें।';

  @override
  String get characterEditSettingsHint =>
      'पात्र के व्यक्तित्व, मूल्यों, सोचने के तरीके, भावनात्मक प्रतिक्रियाओं, व्यवहार संबंधी आदतों, बोलने के तरीके और मूल विश्वासों का वर्णन करें।';

  @override
  String get characterEditUnknownCharacter => 'अज्ञात पात्र';

  @override
  String get characterEditEditSupportingCharacter => 'सहायक पात्र संपादित करें';

  @override
  String get characterEditAddSupportingCharacter => 'सहायक पात्र जोड़ें';

  @override
  String get characterEditSupportingCharacterName => 'सहायक पात्र का नाम';

  @override
  String get characterEditGender => 'लिंग';

  @override
  String get characterEditMale => 'पुरुष';

  @override
  String get characterEditFemale => 'महिला';

  @override
  String get characterEditOther => 'अन्य';

  @override
  String get characterEditAge => 'आयु';

  @override
  String get characterEditIdentityOccupation => 'पहचान／व्यवसाय';

  @override
  String get characterEditRelationshipWithMain => 'मुख्य पात्र के साथ संबंध';

  @override
  String get characterEditRelationshipHint =>
      'मुख्य पात्र के साथ अतीत, दृष्टिकोण, भावनाओं, रहस्यों और वर्तमान संबंध का वर्णन करें।';

  @override
  String get characterEditCharacterProfile => 'पात्र का परिचय';

  @override
  String get characterEditCharacterProfileHint =>
      'पात्र के व्यक्तित्व, रूप-रंग, आदतों, मूल्यों, क्षमताओं, पसंद, नापसंद और महत्वपूर्ण अनुभवों का वर्णन करें।';

  @override
  String get characterEditSpeakingStyle => 'बोलने का अंदाज़';

  @override
  String get characterEditSpeakingStyleHint =>
      'उदाहरण: तेज़ बोलता है, व्यंग्यात्मक टिप्पणियाँ करता है और सीधे बात करता है।';

  @override
  String get characterEditSupportingNameRequired =>
      'कृपया सहायक पात्र का नाम दर्ज करें।';

  @override
  String get characterEditSupportingGenderRequired =>
      'कृपया सहायक पात्र का लिंग चुनें।';

  @override
  String get characterEditProfileRequired => 'कृपया पात्र का परिचय भरें।';

  @override
  String get characterEditRelationshipTooLong =>
      'मुख्य पात्र के साथ संबंध का विवरण 1,500 अक्षरों से अधिक हो गया है।';

  @override
  String get characterEditProfileTooLong =>
      'पात्र का परिचय 1,500 अक्षरों से अधिक हो गया है।';

  @override
  String get characterEditSave => 'सेव करें';

  @override
  String get characterEditAdd => 'जोड़ें';

  @override
  String get creatorProfileNoBio => 'अभी तक कोई परिचय नहीं दिया गया है';

  @override
  String get creatorProfileNoBioHint =>
      'इस निर्माता ने अभी तक अपना परिचय नहीं दिया है।';

  @override
  String get creatorProfileNoCreatorMoments =>
      'निर्माता ने अभी तक कोई पोस्ट प्रकाशित नहीं की है';

  @override
  String get creatorProfileNoCreatorMomentsHint =>
      'निर्माता के रूप में प्रकाशित सार्वजनिक सामग्री यहाँ दिखाई देगी।';

  @override
  String get creatorProfileNoCharacterMoments =>
      'निर्माता के पात्रों ने अभी तक कोई पोस्ट प्रकाशित नहीं की है';

  @override
  String get creatorProfileNoCharacterMomentsHint =>
      'निर्माता के सार्वजनिक पात्रों द्वारा प्रकाशित सामग्री यहाँ दिखाई देगी।';

  @override
  String get creatorProfileNoPublicMoments =>
      'अभी तक कोई सार्वजनिक पोस्ट नहीं है';

  @override
  String get creatorProfileNoPublicMomentsHint =>
      'निर्माता और उनके पात्रों द्वारा प्रकाशित सार्वजनिक पोस्ट यहाँ दिखाई देंगी।';

  @override
  String get creatorProfilePublicWorks => 'सार्वजनिक रचनाएँ';

  @override
  String get creatorProfileLikesReceived => 'प्राप्त लाइक';

  @override
  String get creatorProfileFollow => 'फ़ॉलो करें';

  @override
  String get creatorProfileFollowing => 'फ़ॉलो किया गया';

  @override
  String get creatorProfileUnfollowed => 'फ़ॉलो करना बंद कर दिया गया';

  @override
  String creatorProfileFollowedCreator(String creatorName) {
    return '$creatorName को फ़ॉलो किया गया';
  }

  @override
  String get creatorProfileOperationFailed =>
      'कार्रवाई विफल रही। कृपया बाद में फिर प्रयास करें';

  @override
  String creatorProfileWorksLoadFailed(String error) {
    return 'रचनाएँ लोड नहीं हो सकीं: $error';
  }

  @override
  String get characterProfileShareInvitation =>
      '🦋 LoveyDovey की ओर से मुलाकात का निमंत्रण';

  @override
  String characterProfileShareCreator(String creatorName) {
    return '✦ निर्माता: $creatorName';
  }

  @override
  String characterProfileShareMessage(String characterName) {
    return 'LoveyDovey में “$characterName” खोजें और एक ऐसी कहानी शुरू करें जो केवल आप दोनों की हो।';
  }

  @override
  String get characterProfileInvitationLabel => 'पात्र निमंत्रण कार्ड';

  @override
  String characterProfileCardCreator(String creatorName) {
    return 'निर्माता  $creatorName';
  }

  @override
  String get characterProfileCardSearchHint =>
      'पात्र खोजें और अपनी मुलाकात शुरू करें  🦋';

  @override
  String get characterProfileScanToDownload => 'डाउनलोड करने के लिए स्कैन करें';

  @override
  String characterProfileShareTitle(String characterName) {
    return 'पात्र “$characterName” साझा करें';
  }

  @override
  String characterProfileShareSubject(String characterName) {
    return 'LoveyDovey पर $characterName से मिलें';
  }

  @override
  String get characterProfileShareFailed =>
      'निमंत्रण कार्ड बनाना विफल रहा। कृपया बाद में फिर प्रयास करें';

  @override
  String get characterProfilePrivateShareUnavailable =>
      'निजी पात्रों को अभी साझा नहीं किया जा सकता';

  @override
  String get characterProfileShareCard => 'निमंत्रण कार्ड साझा करें';

  @override
  String get characterProfileShareCharacter => 'पात्र साझा करें';

  @override
  String get characterProfileReportCharacter => 'पात्र की रिपोर्ट करें';

  @override
  String get characterProfileTranslate => 'अनुवाद करें';

  @override
  String get loginMethodInfoTooltip => 'लॉगिन के तरीकों की जानकारी';

  @override
  String get characterEditCoreSetting => 'पात्र की मुख्य सेटिंग';

  @override
  String get characterEditCoreSettingHint =>
      'कृपया पात्र के व्यक्तित्व, व्यवहार के तरीके, दूसरों के साथ बातचीत करने के ढंग और बोलने की शैली का वर्णन करें।\n\nउदाहरण: वह बाहर से ठंडा और कम बोलने वाला दिखाई देता है, लेकिन वास्तव में बहुत संवेदनशील और ध्यान रखने वाला है। वह अजनबियों से दूरी बनाए रखता है, पसंदीदा व्यक्ति की अपने कार्यों से देखभाल करता है, संक्षिप्त और सीधे तरीके से बात करता है तथा अत्यधिक मीठे या छिछोरे संबोधनों का उपयोग नहीं करता।';

  @override
  String get characterEditNameDescription =>
      'यह पात्र का सार्वजनिक रूप से प्रदर्शित नाम है। पात्र बनाने की प्रक्रिया पूरी होने के बाद सिस्टम अपने आप उसका उपयोगकर्ता नाम तैयार करेगा।';

  @override
  String get characterEditNameHint => 'कृपया पात्र का नाम दर्ज करें';

  @override
  String get characterEditAgeDescription =>
      'पात्र की आयु निर्धारित करें। आप कहानी की दुनिया के अनुसार उसकी दिखने वाली आयु भी दर्ज कर सकते हैं।';

  @override
  String get characterEditAgeHint => 'उदाहरण: 25';

  @override
  String get characterEditOccupationDescription =>
      'पात्र की वर्तमान पहचान या व्यवसाय, जैसे विद्यार्थी, डॉक्टर, शूरवीर या उद्यमी।';

  @override
  String get characterEditBirthdayDescription =>
      'पात्र का जन्मदिन चार अंकों में दर्ज करें या महीने और दिन को स्लैश से अलग करें।';

  @override
  String get characterEditBirthdayHint => 'उदाहरण: 0825 या 08/25';

  @override
  String get characterEditHeightDescription =>
      'पात्र की लंबाई सेंटीमीटर में निर्धारित करें।';

  @override
  String get characterEditHeightHint => 'उदाहरण: 182';

  @override
  String get characterEditGenderDescription =>
      'सिस्टम पात्र के लिंग के अनुसार उपयुक्त सर्वनामों का उपयोग करेगा।';

  @override
  String get characterEditAppearanceDescription =>
      'पात्र के चेहरे की विशेषताओं, बालों की शैली, कपड़ों और अन्य शारीरिक विशेषताओं का वर्णन करें।';

  @override
  String get characterEditPlayerIdentityDescription =>
      'कहानी में खिलाड़ी की पहचान निर्धारित करें, जैसे सहायक, सहपाठी या बचपन का मित्र।';

  @override
  String get characterEditWorldviewDescription =>
      'कहानी के समय, स्थान, सामाजिक पृष्ठभूमि और विशेष नियमों का वर्णन करें। यह सामग्री पात्र के पेज पर “पात्र परिचय” में सार्वजनिक रूप से दिखाई जाएगी, इसलिए ऐसे रहस्य या कथानक विवरण शामिल न करें जिन्हें आप खिलाड़ियों को पहले से नहीं बताना चाहते।';

  @override
  String get characterEditStorySummaryDescription =>
      'पात्र की परिस्थिति को तुरंत समझने के लिए कहानी का एक वाक्य में संक्षिप्त परिचय दें।';

  @override
  String get characterEditStorySummaryHint =>
      'उदाहरण: एक ठंडे स्वभाव वाले डॉक्टर के साथ अनुबंधित संबंध से शुरू होने वाली प्रेम कहानी';

  @override
  String get characterEditInitialStoryDescription =>
      'वह कहानीगत परिस्थिति जिसे खिलाड़ी पहली बार चैट रूम में प्रवेश करते समय देखेगा।';

  @override
  String get characterEditFirstLineDescription =>
      'पात्र द्वारा खिलाड़ी से पहली बार मिलने पर कही जाने वाली पहली पंक्ति।';

  @override
  String get characterEditCustomStatusBar => 'कहानी स्टेटस बार (वैकल्पिक)';

  @override
  String get characterEditCustomStatusBarDescription =>
      'यह केवल कहानी मोड और इमर्सिव मोड पर लागू होता है। आप पात्र की स्थिति, स्थान, कपड़े या संबंध की जानकारी को प्रत्येक उत्तर के अंत में दिखाने के लिए सेट कर सकते हैं। इसे खाली छोड़ने पर कोई स्टेटस बार तैयार नहीं किया जाएगा।';

  @override
  String get characterProfileCharacterIntro => 'पात्र परिचय';

  @override
  String get characterProfileNoIntroduction =>
      'निर्माता ने अभी तक पात्र का परिचय नहीं जोड़ा है';

  @override
  String get characterProfileViewMore => 'और देखें';

  @override
  String get characterProfileCollapse => 'कम दिखाएँ';
}
