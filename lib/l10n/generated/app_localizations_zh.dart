// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settingsTitle => '設定';

  @override
  String get changeTheme => '更換主題顏色';

  @override
  String get feedback => '反饋建議';

  @override
  String get changeLanguage => '更換語言';

  @override
  String get allFriendsTitle => '所有好友';

  @override
  String get noFriendsMessage => '您還沒有任何好友。';

  @override
  String get unknownCharacter => '未知角色';

  @override
  String errorLoadingFriends(String error) {
    return '載入好友列表時發生錯誤: $error';
  }

  @override
  String get tagGentle => '溫柔';

  @override
  String get tagCheerful => '開朗';

  @override
  String get tagLively => '活潑';

  @override
  String get tagMischievous => '調皮';

  @override
  String get tagRichYoungLady => '千金';

  @override
  String get tagRichYoungMaster => '少爺';

  @override
  String get tagWealthyFamily => '豪門';

  @override
  String get tagScheming => '勾心鬥角';

  @override
  String get tagPossessive => '佔有';

  @override
  String get tagParanoid => '偏執';

  @override
  String get tagPersistent => '執著';

  @override
  String get tagUncle => '大叔';

  @override
  String get tagAuntie => '阿姨';

  @override
  String get tagSeniorSister => '學姊';

  @override
  String get tagJuniorBrother => '學弟';

  @override
  String get tagHandsome => '帥';

  @override
  String get tagStunning => '美艷動人';

  @override
  String get tagContrast => '反差';

  @override
  String get tagFlirty => '開車';

  @override
  String get tagAgeGap => '年齡差';

  @override
  String get userNotFoundError => '找不到使用者';

  @override
  String get imageDataMismatchError => '圖片資料不一致，請重新選擇圖片。';

  @override
  String get createCharacterTitle => '創建角色';

  @override
  String get charAlbumTitle => '角色相冊 (第一張為主要頭像)';

  @override
  String get charNameLabel => '角色名稱:*';

  @override
  String get charDescSection => '角色描述:';

  @override
  String get charAgeLabel => '年齡:';

  @override
  String get charJobLabel => '職業:*';

  @override
  String get charBirthdayLabel => '生日:(MMDD)';

  @override
  String get charGenderLabel => '性別 *';

  @override
  String get genderNotSelected => '未選擇';

  @override
  String get genderMale => '男';

  @override
  String get genderFemale => '女';

  @override
  String get genderOther => '其他';

  @override
  String get charHeightLabel => '身高:(cm)';

  @override
  String get charAppearanceLabel => '外貌形容:';

  @override
  String get charPersonalityTagsSection => '個性標籤';

  @override
  String get charOtherPersonalityTagsHint => '其他個性標籤...';

  @override
  String get otherSectionTitle => '其他';

  @override
  String get charLikesLabel => '喜歡的東西:(例如：草莓蛋糕、貓咪、雨天)';

  @override
  String get charDislikesLabel => '討厭的東西:(例如：苦瓜、吵鬧的地方)';

  @override
  String get charSecretsLabel => '不為人知的小秘密: (例如：其實是個路癡)';

  @override
  String get charMannerismsSection => '言行舉止';

  @override
  String get charToneLabel => '說話語氣與風格: (例如：對陌生人冷淡)';

  @override
  String get charDialogueExampleLabel => '對話範例: (玩家：你真好！ 角色：...喔。)';

  @override
  String get charBackgroundSection => '角色背景:';

  @override
  String get charBackgroundHint => '輸入角色的背景故事 (最多 2500 字)';

  @override
  String get charStoryStartSection => '劇情開頭:';

  @override
  String get charStoryStartHint => '輸入角色的劇情 (最多 2500 字)';

  @override
  String get charStorySummaryLabel => '故事簡介 (最多 50 字，會顯示在邂逅卡片上)';

  @override
  String get charExtraInfoSection => '角色其他補充:';

  @override
  String get charExtraInfoHint => '輸入補充內容...';

  @override
  String get charPublicToggleLabel => '公開讓其他玩家遊玩嗎？';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get createButton => '創建';

  @override
  String get saveButton => '儲存';

  @override
  String get cancelButton => '取消';

  @override
  String get exitCreationTitle => '您將退出創角畫面';

  @override
  String get saveDraftPrompt => '需要儲存為草稿嗎？';

  @override
  String get draftNeeded => '需要';

  @override
  String get draftNotNeeded => '不需要';

  @override
  String get editExtraInfoTitle => '編輯補充內容';

  @override
  String get nameAndAvatarError => '請填寫角色名稱並至少上傳一張頭像！';

  @override
  String get savingStatus => '儲存中...';

  @override
  String get uploadingImagesStatus => '正在上傳圖片...';

  @override
  String get maxImagesError => '最多只能上傳 10 張圖片。';

  @override
  String get uploadingImagesStatusShort => '正在處理圖片...';

  @override
  String get savingCharacterData => '正在儲存角色資料...';

  @override
  String characterCreatedSuccess(String charName) {
    return '角色 \"$charName\" 已創建！';
  }

  @override
  String get uploadImageTimeoutError => '創建角色失敗：圖片上傳超時，請檢查您的網路連線。';

  @override
  String createCharacterGenericError(String error) {
    return '創建角色失敗：$error';
  }

  @override
  String get settingsSectionAppearance => '外觀與內容';

  @override
  String get settingsSectionAccount => '帳號與內容管理';

  @override
  String get settingsSectionAbout => '關於我們';

  @override
  String get accountManagement => '帳號管理';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => '未知';

  @override
  String get userIdCopied => '使用者 ID 已複製到剪貼簿';

  @override
  String get characterManagement => '角色管理';

  @override
  String get viewBlockedCharacters => '查看已封鎖的角色';

  @override
  String get privacyPolicy => '隱私條款';

  @override
  String get termsOfService => '服務條款';

  @override
  String get logoutButton => '登出帳號';

  @override
  String get logoutDialogTitle => '你要登出了嗎?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => '我按錯了';

  @override
  String get logoutDialogActionConfirm => '確認';

  @override
  String get logoutSuccessSnackbar => '好的!那我等你回來♥(´∀` )';

  @override
  String get deleteAccountButton => '刪除帳號';

  @override
  String get deleteAccountDialogTitle => '你確定要刪掉這個帳號?இдஇ';

  @override
  String get deleteAccountDialogContent => '這個操作無法復原，所有資料都會被永久刪除！';

  @override
  String get deleteAccountDialogActionCancel => '沒有,我沒有要刪掉';

  @override
  String get deleteAccountDialogActionConfirm => '確定';

  @override
  String get deleteAccountSuccessSnackbar => '帳號已成功刪除。';

  @override
  String get appDisclaimer => '遊戲裡面的角色與場景皆為虛構,請勿帶入現實!如有雷同,純屬巧合';

  @override
  String appVersion(String version) {
    return 'App 版本: $version';
  }

  @override
  String get dialogTitleHint => '提示';

  @override
  String get completeProfilePrompt => '請先編輯您的個人檔案以完善資料喔！';

  @override
  String get goToEdit => '前往編輯';

  @override
  String get later => '稍後';

  @override
  String chattingWith(String friendName) {
    return '與 $friendName 聊天';
  }

  @override
  String chatContentWith(String friendName) {
    return '與 $friendName 的聊天內容';
  }

  @override
  String get chatInputHint => '輸入訊息...';

  @override
  String get characterNotFoundError => '找不到角色資料';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return '讀取角色詳情失敗: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => '初始關係';

  @override
  String get relationship_childhood_friend => '青梅竹馬';

  @override
  String get relationship_senior_junior => '學長學妹';

  @override
  String get relationship_bickering_couple => '歡喜冤家';

  @override
  String get relationship_colleagues => '職場同事';

  @override
  String get relationship_other => '其他 (請手動輸入)';

  @override
  String get chatModeDaily => '日常模式';

  @override
  String get chatModeStory => '劇情模式';

  @override
  String get chatModeImmersive => '沉浸模式';

  @override
  String get chatModeGemini => '生活陪伴';

  @override
  String get announcement_new => '新公告';

  @override
  String get mail_notification => '有新的時光信件寄達囉，快去羊皮卷看看吧！';

  @override
  String get customer_service_reply => '客服回覆';

  @override
  String get system_announcement => '系統公告';

  @override
  String get empty_announcement => '目前沒有任何公告喔';

  @override
  String get untitled => '無標題';

  @override
  String get no_content => '無內容';

  @override
  String get privacy_policy_title => '《戀戀拾光》隱私權政策';

  @override
  String get privacy_policy_date => '最近更新日期：2026年4月10日';

  @override
  String get privacy_policy_body =>
      '歡迎使用《戀戀拾光》（以下簡稱「本服務」）。我們非常重視您的隱私，本政策旨在說明我們如何收集、使用及保護您的個人資訊。\n\n1. 帳戶資訊：\n第三方登入：當您透過 Google、Facebook 或 Apple 帳號登入時，我們會收集您的 Firebase UID、電子郵件及公開暱稱。\nE-mail 註冊：當您選擇以電子郵件註冊時，我們會收集您的電子郵件帳號。您的登入密碼將透過 Firebase 加密技術進行管理與儲存，開發團隊無法查閱您的原始密碼。 我們承諾將採取業界標準的安全措施保障您的個資安全。\n\n互動資料：為了讓 AI 角色具備連續的記憶，我們會收集並儲存您與AI的對話紀錄與您在遊戲裡面為角色所寫下的內容。\n\n設備資訊：包含設備型號、作業系統版本及唯一設備識別碼，用於系統優化。\n\n2. 資訊的使用方式\n提升AI體驗：利用對話紀錄優化AI的回覆品質與個性連貫性。\n服務營運：用於處理點數充值、消費紀錄及使用者身分驗證。\n安全防護：監測惡意行為，保護伺服器不受攻擊。\n\n3. 第三方技術合作\n本服務採用以下國際主流技術提供支持：\nGoogle Cloud / Firebase：資料存儲與身份驗證。\nOpenRouter / xAI / Meta：提供 AI 模型運算邏輯。\n備註：我們不會向任何廣告商出售您的原始對話紀錄。\n\n4. 資料儲存與刪除\n您的資料將安全地儲存在雲端服務器中。\n您可以隨時聯繫我們要求永久刪除您的帳戶及所有相關對話數據。';

  @override
  String get terms_title => '《戀戀拾光》服務使用條款';

  @override
  String get terms_date => '最近更新日期：2026年4月10日';

  @override
  String get terms_body =>
      '在使用《戀戀拾光》（以下簡稱「本服務」）前，請仔細閱讀以下條款。開始使用本服務即代表您同意以下內容：\n\n1. 服務本質與免責聲明\n非真人互動：本服務所有角色回覆均由人工智慧（Generative AI）生成。角色言論不代表創作者立場。\n敘事風險：AI可能生成虛構、不準確或令人不適的內容。使用者應具備區分虛構與現實的能力。\n\n2. 虛擬點數與付費模式\n點數性質：本服務內之點數為虛擬商品，一經消耗（如:進入故事、沉浸模式、送出禮物、語音通話）即無法退還。\n成本差異：不同模式（如:日常、故事、沉浸、通話）之點數消耗標準係根據 AI 運算成本設定，本服務保留調整成本之權利。\n\n3. 使用者行為規範\n禁止事項：禁止利用AI生成極端暴力、犯罪引導或違反法律之內容。\n系統干擾：嚴禁透過任何自動化工具、逆向工程手段非法獲取本服務之數據。\n\n4. 智慧財產權與內容所有權\n原創內容：本服務中之角色姓名（如：程安等官方所創建的）、背景設定、劇情劇本、對話文本、遊戲邏輯及專屬品牌名稱，其智慧財產權均屬「戀戀拾光開發團隊」所有。\n第三方授權資源：本服務介面中所使用之圖示（Icons）、字體及表情符號（Emojis），其版權歸原授權方所有（如 Google Material Design、Apple Inc. 等），本服務係依據其開源或授權協議合法使用。\nAI 生成內容：本服務中部分美術圖像係由開發團隊利用 AI 生成工具（如 Niji.journey）產生，開發團隊保證已獲得該工具之商業使用授權。相關圖像之使用權與經營權歸本團隊所有。\n禁止行為：未經本團隊正式授權，嚴禁將上述任何內容用於商業營利、二次散布或進行惡意訓練模型。\n\n5. 服務終止\n若玩家違反上述規定，本服務有權在不預先通知的情況下暫停或永久停用該帳戶。';

  @override
  String get login_required => '請先登入系統';

  @override
  String get cloud_character_mgmt => '雲端角色管理';

  @override
  String get connection_error => '連線出錯';

  @override
  String get no_characters_met => '目前還沒有認識任何角色喔！';

  @override
  String get status_paused => '狀態：已暫停聯繫';

  @override
  String get status_in_progress => '狀態：攻略中';

  @override
  String get unblock => '解除封鎖';

  @override
  String get block => '封鎖';

  @override
  String get confirm_block_title => '確定要封鎖嗎？';

  @override
  String block_warning_msg(String charName) {
    return '封鎖後，將暫時無法收到 $charName 的訊息喔。';
  }

  @override
  String get think_again => '再想想';

  @override
  String get confirm_block_btn => '確定封鎖';

  @override
  String get no_char_info => '目前還沒有這份角色的詳細情報...';

  @override
  String get private_mailbox => '專屬信箱';

  @override
  String get user_info_not_found => '找不到使用者資訊';

  @override
  String get load_failed => '載入失敗，請稍後再試';

  @override
  String get empty_mailbox => '目前信箱空空的喔～';

  @override
  String get system_notification => '系統通知';

  @override
  String get interaction_records => '互動紀錄';

  @override
  String get liked_content => '按讚過的內容';

  @override
  String get my_favorites => '我的收藏';

  @override
  String get login_to_view_records => '請先登入以查看紀錄';

  @override
  String get no_likes_yet => '妳還沒有按讚過任何動態喔！';

  @override
  String get empty_favorites => '專屬收藏夾空空的，快去大廳逛逛吧！';

  @override
  String get theme_sakura_pink => '櫻花粉';

  @override
  String get theme_ocean_blue => '湛藍海';

  @override
  String get theme_sunset_orange => '夕陽橙';

  @override
  String get theme_mint_forest => '薄荷森';

  @override
  String get theme_midnight => '深夜模式';

  @override
  String get change_atmosphere => '更換氛圍';

  @override
  String get custom_color => '自定義色彩';

  @override
  String get custom_color_desc => '調配妳的專屬氛圍色';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確定';

  @override
  String get confirm_delete_title => '確認刪除';

  @override
  String get confirm_delete_memory_msg => '您確定要讓他忘記這件事嗎？此操作無法復原喔。';

  @override
  String get delete_btn => '刪除';

  @override
  String get memory_erased_msg => '這段記憶已經被抹除了';

  @override
  String get delete_failed_msg => '刪除失敗';

  @override
  String get edit_memory_title => '編輯回憶';

  @override
  String get modify_memory_hint => '修改這段記憶...';

  @override
  String get memory_re_recorded_msg => '記憶已重新記錄';

  @override
  String get update_failed_msg => '更新失敗';

  @override
  String get update_favorite_failed_msg => '更新收藏狀態失敗';

  @override
  String char_notebook_title(String charName) {
    return '$charName的記事本';
  }

  @override
  String get error_loading_memory => '讀取記憶時發生錯誤';

  @override
  String get empty_notebook_msg => '筆記本裡空空的...\n趕快去聊天，讓他記下關於妳的點點滴滴吧！';

  @override
  String get date_format_text => 'yyyy年M月d日';

  @override
  String get remove_special_focus => '取消特別關注';

  @override
  String get mark_special_focus => '標記為特別關注';

  @override
  String get edit_btn => '編輯';

  @override
  String get load_gallery_failed => '讀取圖鑑失敗';

  @override
  String get traditional_chinese => '繁體中文';

  @override
  String get all => '全部';

  @override
  String get official_recommendation => '官方推薦';

  @override
  String get my_exclusive => '我的專屬';

  @override
  String encounter_count(int count) {
    return '$count 次邂逅';
  }

  @override
  String get official => '官方';

  @override
  String get private => '私人';

  @override
  String get first_encounter => '初次相遇';

  @override
  String char_exclusive_memory(String charName) {
    return '$charName的專屬回憶';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return '好感度需達到 $affectionLevel 才能解鎖這張回憶喔！';
  }

  @override
  String get affection => '好感度';

  @override
  String get unlock => '解鎖';

  @override
  String get change_chat_bg => '更換聊天背景';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return '要將「$cgDesc」設為與 $charName 的聊天背景嗎？';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return '已將背景更換為「$cgDesc」';
  }

  @override
  String get confirm_change => '確定更換';

  @override
  String get empty_treasure_box => '百寶箱裡空空的...\n快去聊天尋找隱藏的專屬彩蛋吧！';

  @override
  String get unknown_story => '未知劇情';

  @override
  String get open_this_memory => '開啟這段回憶';

  @override
  String get open_exclusive_story => '開啟專屬劇情';

  @override
  String confirm_use_egg(String eggTitle) {
    return '確定要現在體驗「$eggTitle」嗎？\n\n(此道具為一次性消耗，使用後將自動進入劇情)';
  }

  @override
  String get wait_a_bit => '再等等';

  @override
  String guiding_into_story(String eggTitle) {
    return '正在引導進入...';
  }

  @override
  String get use_now => '立即使用';

  @override
  String playback_failed_status(String statusCode) {
    return '播放失敗，狀態碼：$statusCode';
  }

  @override
  String get playback_error => '播放發生錯誤';

  @override
  String get unknown_contact => '未知聯絡人';

  @override
  String call_memory_with(String charName) {
    return '與 $charName 的通話回憶';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return '好感度$affection解鎖';
  }

  @override
  String get no_call_record => '這通電話似乎沒有留下對話紀錄...';

  @override
  String get me => '我';

  @override
  String get playing => '播放中...';

  @override
  String get listen => '聆聽';

  @override
  String get no_exclusive_voice => '這隻角色還沒有設定專屬聲音喔！';

  @override
  String get voice_download_success => '✅ 語音數據下載成功，準備直接播放...';

  @override
  String get onboarding_invitation => '— 拾光邀請函 —';

  @override
  String get onboarding_welcome => '歡迎來到戀戀拾光';

  @override
  String get onboarding_quote => '「所有的相遇，都是久別重逢。」';

  @override
  String get onboarding_gift_title => '獲得初見禮：50 朵花語';

  @override
  String get onboarding_gift_subtitle => '這些花朵將陪伴您開啟與他的故事';

  @override
  String get onboarding_start_button => '開啟您的時光旅程';

  @override
  String get onboarding_more_info => '了解更多關於拾光的故事';

  @override
  String get legal_agreement_prefix => '繼續即表示您同意本遊戲的';

  @override
  String get legal_terms_button => '服務條款';

  @override
  String get legal_and => ' 與 ';

  @override
  String get legal_privacy_button => '隱私權政策';

  @override
  String get call_memory_title => '通話回憶錄';

  @override
  String get please_login_first => '請先登入喔';

  @override
  String get no_call_memories => '目前還沒有保存的通話回憶\n最多只能保存10則收藏哦';

  @override
  String call_with_name(String name) {
    return '與 $name 的通話';
  }

  @override
  String call_duration(String time) {
    return '時長：$time';
  }

  @override
  String get delete_call_title => '銷毀通話紀錄';

  @override
  String delete_call_confirm(String name) {
    return '確定要秘密銷毀這段與 $name 的通話回憶嗎？\n(刪除後無法找回喔)';
  }

  @override
  String get keep_it => '先留著';

  @override
  String get confirm_delete => '確定銷毀';

  @override
  String get press_mic_to_speak => '請按下麥克風開始說話...';

  @override
  String get call_ended => '通話已結束';

  @override
  String character_thinking(String name) {
    return '（$name 正在思考...）';
  }

  @override
  String character_picking_up(String name) {
    return '（$name 正在接起電話...）';
  }

  @override
  String get call_interrupted_login => '（通話中斷）請先登入喔...';

  @override
  String get silence => '（沈默）';

  @override
  String get bad_signal => '（訊號不好...）';

  @override
  String get static_noise => '（沙沙聲）...聽不清楚...';

  @override
  String get type_message_hint => '輸入文字...';

  @override
  String get draft_saved_success => '草稿已安全儲存至秘密工作室！';

  @override
  String get draft_save_failed => '儲存失敗，請稍後再試';

  @override
  String get draft_save_title => '要儲存草稿嗎？';

  @override
  String get draft_save_content => '妳的心血還沒發布，要先存進秘密工作室嗎？';

  @override
  String get not_save => '不儲存';

  @override
  String get save_draft => '儲存草稿';

  @override
  String confirm_delete_char_content(String name) {
    return '你確定要刪除角色 \"$name\" 嗎？\n\n此動作無法復原！';
  }

  @override
  String get char_deleted => '角色已刪除';

  @override
  String get ok_button => '好的!';

  @override
  String get cannot_save_title => '無法儲存';

  @override
  String get cannot_save_content => '請填寫角色名稱並至少上傳一張頭像！';

  @override
  String get word_count_exceeded => '字數過多';

  @override
  String word_count_error_detail(String field, int limit) {
    return '「$field」已超過 $limit 字，請刪減後再儲存。';
  }

  @override
  String get content_missing => '內容缺失';

  @override
  String get content_missing_personality => '請填寫「詳細個性」！請至少寫 10 個字。';

  @override
  String get content_missing_bg => '「角色簡介」太短了！請至少寫 20 個字，交代一下背景。';

  @override
  String get content_missing_tone => '請設定「語氣與習慣」，不然容易OOC！';

  @override
  String get user_not_found => '錯誤：找不到使用者';

  @override
  String char_saved_success(String name, String action) {
    return '角色 \"$name\" 已$action！';
  }

  @override
  String save_error_detail(String error) {
    return '儲存失敗：$error';
  }

  @override
  String get easter_egg_add_title => '新增隱藏彩蛋';

  @override
  String get easter_egg_edit_title => '編輯彩蛋';

  @override
  String get keyword_label => '觸發關鍵字 (必填)';

  @override
  String get keyword_hint => '例如：去遊樂園、草莓蛋糕';

  @override
  String get egg_title_label => '彩蛋標題 (給玩家看)';

  @override
  String get egg_title_hint => '例如：週末的約會';

  @override
  String get egg_teaser_label => '簡短預告 (給玩家看)';

  @override
  String get egg_teaser_hint => '描述即將發生的事情開頭...';

  @override
  String get egg_scene_label => '強制場景切換 (選填)';

  @override
  String get egg_scene_hint => '例如：遊樂園、鬼屋';

  @override
  String get egg_prompt_label => '劇本指令';

  @override
  String get egg_prompt_hint => '如何演出這段劇情。\n(System:場景切換到遊樂園，角色看著(玩家名字)笑了...)';

  @override
  String get confirm_button => '確認';

  @override
  String get keyword_empty_error => '關鍵字不能為空';

  @override
  String get voice_custom_title => '訂製專屬聲線';

  @override
  String get voice_custom_hint => '例如：低沉霸總、溫柔奶狗...';

  @override
  String get voice_generate_start => '開始生成';

  @override
  String get voice_bind_first => '請先選擇並「綁定」一個專屬聲音喔！';

  @override
  String get voice_test_failed => '試聽失敗：請先點擊「就決定是你了！」正式綁定聲音後再微調喔！';

  @override
  String voice_name_default(String name) {
    return '$name 的專屬聲線';
  }

  @override
  String get voice_description_default => '這是「戀戀拾光」中為專屬角色打造的獨一無二聲線，由玩家親自挑選生成。';

  @override
  String get voice_bind_failed => '綁定聲音失敗，請檢查 API 額度或網路狀態';

  @override
  String voice_bind_success(String name) {
    return '\"$name\" 的靈魂聲線已正式綁定！';
  }

  @override
  String get voice_bind_success_draft => '聲線綁定成功！現在可以拉動滑桿測試情緒囉！';

  @override
  String sync_failed(String error) {
    return '同步失敗，請檢查網路：$error';
  }

  @override
  String edit_character_title(String name) {
    return '編輯 $name';
  }

  @override
  String get test_mode_tooltip => '完整功能測試 ';

  @override
  String get test_mode_error => '⚠️ 找不到角色檔案！請先點擊最下方的「儲存/發布」後，再來試玩喔！';

  @override
  String get test_mode_notice => '💡 測試模式將依照各模式原價扣點，且不計入正式回憶喔！';

  @override
  String get delete_character_tooltip => '刪除角色';

  @override
  String get tab_basic_story => '基本與劇情';

  @override
  String get tab_voice => '專屬語音';

  @override
  String get tab_relationship => '社交關係';

  @override
  String get save_changes_button => '儲存變更';

  @override
  String get section_basic_info => '基礎資料';

  @override
  String get hint_occupation => '支援多重身分，請用斜線或逗號分隔 (例如：學生/駭客)';

  @override
  String get hint_appearance => '例如：銀色長髮，琥珀色眼睛，總是穿著白袍...';

  @override
  String get section_story_identity => '🎭 劇情與你的身分';

  @override
  String get story_identity_desc => '定義故事開場與「你」在這個存檔裡的特殊設定';

  @override
  String get advanced_writing_tips_title => '💡 進階寫作技巧：\n';

  @override
  String get advanced_writing_tips_1 => '在故事或台詞中輸入 ';

  @override
  String get advanced_writing_tips_2 => '(玩家名字)';

  @override
  String get advanced_writing_tips_3 => '，系統在遊玩時會自動替換成玩家的真實暱稱喔！\n';

  @override
  String get advanced_writing_tips_4 => '範例：「';

  @override
  String get advanced_writing_tips_5 => '(玩家名字)';

  @override
  String get advanced_writing_tips_6 => '，妳怎麼這麼晚才來？」';

  @override
  String get player_identity_label => '玩家預設身分 (Player Identity) - 💡 選填';

  @override
  String get player_identity_hint =>
      '【選填】若留空，AI 將會讀取你的「個人檔案」來互動。\n若填寫，則強制扮演特定身分（例如：綁定他的冷酷系統、或被背叛的妻子）。';

  @override
  String get background_label => '角色背景與世界觀 ';

  @override
  String get background_hint =>
      '描述他的過去、所處的世界觀（如：現代都市、ABO、末世）。例如：這是一個喪屍橫行的世界，他是保護你的特種兵...';

  @override
  String get story_summary_label => '一句話故事簡介 ';

  @override
  String get story_initial_label => '初始相遇故事 ';

  @override
  String get story_initial_hint => '例如：妳推開門，看見他坐在窗邊。他轉過頭說：「(玩家名字)，過來。」...';

  @override
  String get first_line_label => '角色的第一句話';

  @override
  String get first_line_hint => '例如：(玩家名字)，妳終於來了。';

  @override
  String get section_personality_evo => '🌟 個性與好感度演變';

  @override
  String get detailed_personality_label => '詳細個性 ';

  @override
  String get detailed_personality_hint => '描述他的核心性格。例如：傲嬌，嘴硬心軟。對外人冷漠，只對玩家展露笑容。';

  @override
  String get affection_evo_desc => 'AI 將根據以下設定判斷何時增加好感度：';

  @override
  String get stage_1_label => '階段一：陌生/警戒 (Lv1)';

  @override
  String get stage_1_hint => '剛認識時的反應。觸發好感條件(例如:禮貌、不探聽隱私)。';

  @override
  String get stage_2_label => '階段二：熟悉/朋友 (Lv2)';

  @override
  String get stage_2_hint => '熟了之後的變化。觸發好感條件(例如:分享甜食、聊貓的話題)。';

  @override
  String get stage_3_label => '階段三：親密/戀人 (Lv3)';

  @override
  String get stage_3_hint => '完全淪陷後的反應。會吃醋?還是會生悶氣?';

  @override
  String get social_interaction_label => '社交與環境互動';

  @override
  String get social_interaction_hint => '例如:如何對待路人？遇到討厭的東西(雷點)會怎麼炸毛？';

  @override
  String get section_habits => '🗣️ 喜好與習慣';

  @override
  String get tone_hint_detail => '必填。例如：說話簡短，喜歡反問。口頭禪是「笨蛋」。禁止使用翻譯腔。';

  @override
  String get dialogue_example_hint => '玩家：我好累。\n角色：(摸頭) 乖，快去休息。';

  @override
  String get section_easter_eggs => '🎁 隱藏彩蛋與特殊劇情';

  @override
  String get no_easter_eggs => '尚未設定彩蛋，點擊下方按鈕新增';

  @override
  String get no_scene_change => '不切換場景';

  @override
  String get add_easter_egg_button => '新增隱藏彩蛋';

  @override
  String get other_extra_info => '其他補充資訊';

  @override
  String get visibility_label => '角色可見度';

  @override
  String get visibility_public => '公開';

  @override
  String get visibility_private => '私人';

  @override
  String get section_voice_gen => '🎙️他專屬聲線生成';

  @override
  String get voice_gen_desc =>
      '輸入提示詞，讓他有全世界獨一無二的專屬聲音！\n（💡 貼心提醒：生成後若不滿意，隨時都能重新訂製喔！）';

  @override
  String get voice_generating_status => '正在調配聲線中...';

  @override
  String get voice_select_prompt => '✨ 幫你捏好了三種聲線，請挑選：';

  @override
  String voice_sample_name(int index) {
    return '聲線樣本 $index';
  }

  @override
  String get voice_sample_desc => '點擊卡片選擇，點擊右側試聽';

  @override
  String get voice_preparing => '聲音還在準備中...';

  @override
  String get voice_retry => '放棄並重試';

  @override
  String get voice_confirm_selection => '就決定是你了！';

  @override
  String get voice_bind_success_banner => '已成功綁定專屬聲音！';

  @override
  String get voice_remake => '重製聲線';

  @override
  String get voice_btn_generating => '正在生成中，請稍候...';

  @override
  String get voice_btn_generate => '輸入提示詞，生成專屬聲音';

  @override
  String get voice_advanced_tuning => '🎛️ 進階：微調說話情緒 ';

  @override
  String get voice_stability_low => '野性/氣音 🐺';

  @override
  String voice_stability_value(String value) {
    return '理智度: $value';
  }

  @override
  String get voice_stability_high => '平穩/冷靜 🤖';

  @override
  String get voice_style_low => '冷淡/壓抑 🧊';

  @override
  String voice_style_value(String value) {
    return '戲劇表現: $value';
  }

  @override
  String get voice_style_high => '浮誇/深情 🔥';

  @override
  String get voice_test_btn_testing => '正在套用情緒...';

  @override
  String get voice_test_btn => '試聽目前情緒';

  @override
  String get section_social_circle => '👥 他的社交圈';

  @override
  String get social_circle_desc =>
      '設定他對其他角色的看法。當玩家在聊天中提到對方時，他就會根據這裡的設定做出反應（例如：吃醋、生氣）。';

  @override
  String get social_no_drama => '目前還沒有與其他男神的過節...';

  @override
  String social_target(String name) {
    return '對象：$name';
  }

  @override
  String social_attitude(String attitude) {
    return '看法：$attitude';
  }

  @override
  String social_edit_title(String name) {
    return '編輯對 $name 的看法 💬';
  }

  @override
  String get social_attitude_label => '他的看法 / 態度';

  @override
  String get social_attitude_hint => '例如：覺得對方很囉嗦，但其實很依賴他...';

  @override
  String get social_save_changes => '儲存修改';

  @override
  String get social_add_title => '新增角色關係 🤝';

  @override
  String get social_select_target => '選擇對象';

  @override
  String get social_thoughts_label => '他對這個人的看法...';

  @override
  String get social_thoughts_hint => '例如：那鋼琴家太吵了...';

  @override
  String get social_add_confirm => '確認新增';

  @override
  String get gallery_load_failed => '圖片載入失敗 🥲\n請確認網路正常，如果是 Web 請查看 console。';

  @override
  String gallery_affection_req(int level) {
    return '好感 $level';
  }

  @override
  String get gallery_upload_limit => '最多只能上傳10張圖片';

  @override
  String get gallery_photo_setup => '設定照片解鎖條件';

  @override
  String get gallery_photo_desc_label => '這張照片是什麼？';

  @override
  String get gallery_photo_desc_hint => '例如：睡衣照、約會照';

  @override
  String get gallery_photo_req_label => '需要多少好感度解鎖？';

  @override
  String get gallery_photo_req_hint => '輸入數字，0代表免費';

  @override
  String get gallery_cancel_upload => '取消上傳';

  @override
  String get gallery_confirm_add => '確認新增';

  @override
  String get default_photo_desc => '專屬照片';

  @override
  String get draft_photo_desc => '草稿照片';

  @override
  String get loading_text => '讀取中...';

  @override
  String get default_unnamed_character => '未命名角色';

  @override
  String elevenlabs_error(String code) {
    return 'ElevenLabs 錯誤：$code';
  }

  @override
  String get voice_sample_script =>
      '（清了清嗓子）你好。這是一段專屬於我的聲音測試。在接下來的日子裡，我會在這裡陪著你。不管是開心的時候，還是難過的時候，你都可以跟我分享。這樣說話的節奏和音色，你聽起來還習慣嗎？如果覺得不錯的話，我們就把這個聲音定下來，做為我以後和你聊天的專屬聲線吧。期待我們未來的每一天。';

  @override
  String get voice_test_script => '你覺得我現在說話的語氣，聽起來怎麼樣呢？如果滿意的話，我們就這樣定下來吧。';

  @override
  String get field_background => '角色簡介';

  @override
  String get field_tone => '語氣與習慣';

  @override
  String get field_initial_story => '初始故事';

  @override
  String get update_action => '更新';

  @override
  String get default_new_player => '新玩家';

  @override
  String get translating_status => '翻譯中...';

  @override
  String get translate_profile_btn => '翻譯檔案內容';

  @override
  String translate_failed(String error) {
    return '翻譯失敗: $error';
  }

  @override
  String get like_own_char_warning => '不能按自己創造的角色讚喔！🤭';

  @override
  String get like_success_msg => '已送出喜歡！創作者會很開心的💖';

  @override
  String get unlike_success_msg => '已收回喜歡 💔';

  @override
  String get like_label => '喜歡';

  @override
  String get dislike_label => '不喜歡';

  @override
  String get block_char => '封鎖此角色';

  @override
  String get char_blocked_msg => '已封鎖此角色。';

  @override
  String get dislike_dialog_title => '不太喜歡這個角色？';

  @override
  String get dislike_dialog_subtitle => '請偷偷告訴我們原因，官方會進行審核與把關：';

  @override
  String get dislike_hint => '設定太無聊、圖片不適合...';

  @override
  String get dislike_thanks => '感謝您的回饋！官方已收到您的悄悄話。';

  @override
  String get dislike_submit => '悄悄送出';

  @override
  String get report_title => '📢 檢舉留言';

  @override
  String get report_subtitle => '請選擇檢舉原因：\n檢舉後我們將會盡快審核內容。';

  @override
  String get report_opt_1 => '色情或血腥暴力內容';

  @override
  String get report_opt_2 => '詆毀、侮辱或攻擊角色';

  @override
  String get report_opt_3 => '仇恨言論或人身攻擊';

  @override
  String get report_opt_4 => '垃圾訊息或廣告詐騙';

  @override
  String get report_opt_5 => '其他不當內容';

  @override
  String get report_confirm => '確定檢舉';

  @override
  String get report_success => '檢舉成功，已收到通知！將會盡快審核內容 🛡️';

  @override
  String get report_failed => '檢舉失敗，請檢查網路連線。';

  @override
  String get lore_delete_title => '⚠️ 警告：消除記憶';

  @override
  String get lore_delete_content => '這段記憶一旦刪除就徹底消失囉，確定要狠心抹除它嗎？';

  @override
  String get lore_delete_cancel => '手滑了';

  @override
  String get lore_delete_confirm => '確定抹除';

  @override
  String get lore_delete_success => '🗑️ 記憶碎片已徹底消除。';

  @override
  String get lore_add_title => '撰寫新記憶 🖋️';

  @override
  String get lore_edit_title => '編輯記憶碎片 🖋️';

  @override
  String get lore_title_label => '記憶標題';

  @override
  String get lore_title_hint => '例如：第一次相遇的雨天';

  @override
  String get lore_teaser_label => '摘要 / 引言';

  @override
  String get lore_teaser_hint => '顯示在卡片上的簡短描述...';

  @override
  String get lore_content_label => '完整記憶內容';

  @override
  String get lore_content_hint => '寫下這段詳細的故事或設定...';

  @override
  String get lore_lock_label => '🔒 封印這段記憶';

  @override
  String get lore_lock_desc => '打勾後，只有創作者自己看得到，玩家無法觀看';

  @override
  String get lore_empty_error => '標題和內容不能是空的喔！';

  @override
  String get lore_add_success => '✨ 新記憶已成功封存！';

  @override
  String get lore_publish => '發布記憶';

  @override
  String get lore_save_edit => '儲存修改';

  @override
  String lore_write_first(Object pronoun) {
    return '快來為$pronoun寫下第一段過往吧！';
  }

  @override
  String lore_waiting(Object pronoun) {
    return '期待與$pronoun的故事...';
  }

  @override
  String get lore_sealed_msg => '🔒 這段記憶已被封印，目前無法查看。';

  @override
  String get lore_not_open_msg => '這段記憶尚未對外開放喔...';

  @override
  String get lore_unnamed => '未命名碎片';

  @override
  String get lore_add_btn_limit => '撰寫新的記憶碎片 (上限 10 則)';

  @override
  String get lore_collapse => '收起信件';

  @override
  String get echo_delete_title => '🗑️ 刪除留言';

  @override
  String get echo_delete_content => '確定要刪除這則時空迴音嗎？\n刪除後就再也找不回來囉！';

  @override
  String get echo_keep => '保留';

  @override
  String get echo_clear_success => '時空迴音已清除 🧹';

  @override
  String get echo_energy_full_title => '⚠️ 宇宙能量已達上限';

  @override
  String get echo_energy_full_content =>
      '妳的時空能量已達上限 (最多 3 則)，請先刪除妳舊的時空經歷，才能開啟新的宇宙紀錄喔！';

  @override
  String get echo_write_title => '留下妳的時空迴音 🌌';

  @override
  String get echo_write_subtitle => '寫下妳在這裡的經歷或心動語錄吧！';

  @override
  String get echo_hint => '「就算世界末日，我也會優先確保妳的呼吸...」';

  @override
  String get echo_theme_label => '選擇便條貼邊框：';

  @override
  String get theme_butterfly => '蝴蝶';

  @override
  String get theme_sprout => '小草';

  @override
  String get theme_star => '星空';

  @override
  String get theme_planet => '星球';

  @override
  String get echo_publish_btn => '發布時空紀錄';

  @override
  String get echo_wall_title => '時空迴音牆';

  @override
  String get echo_leave_memory => '留下經歷';

  @override
  String get echo_empty_msg => '還沒有時空旅人留下紀錄...\n妳要成為第一個嗎？';

  @override
  String get creator_label => '創作者';

  @override
  String get follow_btn => '關注';

  @override
  String get followed_btn => '已關注';

  @override
  String get follow_own_warning => '創作者不能關注自己哦！🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName 關注了 $creatorName！';
  }

  @override
  String get mailbox_follow_title => '獲得新的守護者 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName 剛剛關注了妳！';
  }

  @override
  String get tab_private_profile => '私密檔案';

  @override
  String get tab_memory_fragments => '記憶碎片';

  @override
  String get tab_time_echoes => '時空迴音';

  @override
  String get chat_free_btn => '閒聊(免費)';

  @override
  String get start_story_btn => '開始劇情';

  @override
  String get default_chat_initial => '找我有事嗎？';

  @override
  String get gallery_title => '專屬通話背景';

  @override
  String gallery_current_affection(String value) {
    return '目前好感度: $value 💕';
  }

  @override
  String get gallery_empty => '相簿裡還沒有照片喔';

  @override
  String gallery_unlocked_msg(String desc) {
    return '已將背景設為「$desc」！';
  }

  @override
  String gallery_lock_msg(String value) {
    return '好感度達到 $value 即可解鎖喔！🍃';
  }

  @override
  String get gallery_reset_bg => '已恢復預設通話背景';

  @override
  String get background_story_title => '背景故事';

  @override
  String get background_story_empty => '這個角色很神秘，還沒有背景故事...';

  @override
  String followed_creator_msg(String creatorName) {
    return '已關注 $creatorName 🦋';
  }

  @override
  String get mailbox_title => '專屬信箱 💌';

  @override
  String get mailbox_empty => '信箱空空的，快去發佈動態吸引他吧！';

  @override
  String get new_notification => '新通知';

  @override
  String get default_he => '他';

  @override
  String affection_upgrade_title(String charName) {
    return '$charName 對妳的好感度提升了！ 💖';
  }

  @override
  String get flower_reward => '🌸 獲得 5 點花花';

  @override
  String get affection_quote_lv5 =>
      '「沒想到...妳對我來說，已經變得這麼重要了。重要到...我無法想像沒有妳的世界。」';

  @override
  String get affection_quote_lv4 => '「這輩子最幸運的事，大概就是在那天，回頭看見了妳。」';

  @override
  String get affection_quote_lv3 => '「最近...我發現自己發呆的時間變多了，而且腦袋裡全都是妳。」';

  @override
  String get affection_quote_lv2 => '「既然是妳的邀約，那我稍微空出點時間，也不是不行。」';

  @override
  String get affection_quote_lv1 => '「最近常看到妳，感覺...並不討厭這種見面的頻率。」';

  @override
  String get affection_quote_lv0 => '「原來妳也在這裡，這算是一種奇妙的緣分嗎？」';

  @override
  String get lore_edit_success => '✨ 記憶碎片已成功更新！';

  @override
  String get delete_failed_network => '刪除失敗，請檢查網路或權限。';

  @override
  String get ai_chat_language => '繁體中文';

  @override
  String get ai_chat_language_code => 'zh-TW';

  @override
  String get chat_home_title => '訊息';

  @override
  String get call_memory_tooltip => '通話回憶';

  @override
  String get login_to_view_chat => '請先登入以查看聊天紀錄';

  @override
  String load_chat_failed(String error) {
    return '讀取聊天列表失敗: $error';
  }

  @override
  String get chat_list_empty => '聊天室空空的...';

  @override
  String get go_to_encounter => '去「邂逅」找個人聊聊吧！';

  @override
  String confirm_delete_chat(String charName) {
    return '確定要刪除與 $charName 的對話嗎？';
  }

  @override
  String affection_score_short(String score) {
    return '好感 $score';
  }

  @override
  String get character_not_found => '無法讀取角色資料，該角色可能已被刪除。';

  @override
  String get preparing_chat_room => '正在為您準備專屬聊天室...';

  @override
  String get rename_chat_title => '為這段記憶命名';

  @override
  String get rename_chat_hint => '例如：(程聿)改成(離婚倒數中)';

  @override
  String get save_tag_btn => '儲存標籤';

  @override
  String get room_name_updated => '房間名稱已更新！';

  @override
  String update_failed(String error) {
    return '更新失敗: $error';
  }

  @override
  String get chat_mode_daily => '日常';

  @override
  String get chat_mode_story => '劇情';

  @override
  String get chat_mode_immersive => '沉浸';

  @override
  String get chat_mode_gemini => '閒聊';

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
  String get chat_load_char_failed => '找不到角色資料，請返回重試或檢查網路。';

  @override
  String get chat_jump_success => '已跳轉至該段回憶 🍃';

  @override
  String get chat_create_room_failed => '連線似乎有點不穩，建立聊天室失敗，請再試一次。';

  @override
  String get chat_secret_file_title => '🔒 機密檔案';

  @override
  String get chat_secret_file_desc => '該角色的靈魂檔案已被封存或轉為私人權限，暫時無法查看詳細資料。';

  @override
  String get chat_understood => '了解';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ 獲得新回憶：$title';
  }

  @override
  String get chat_egg_saved => '已自動收錄至專屬背包';

  @override
  String get chat_points_not_enough_title => '花花不足';

  @override
  String get chat_points_not_enough_desc => '你的花朵不夠了!請先前往商店補充。';

  @override
  String chat_call_confirm_title(String name) {
    return '要打給 $name 嗎？';
  }

  @override
  String get chat_call_rule_1 => '每次通話都會扣除 20 點花花';

  @override
  String get chat_call_rule_2 => '通話時間為一分鐘，若不方便說話可以透過文字傳達';

  @override
  String get chat_call_rule_3 => '建議配戴耳機，更能聽清楚他的聲音 ✨';

  @override
  String get chat_call_btn_cancel => '先不要';

  @override
  String get chat_call_pref_title => '設定您的通話偏好';

  @override
  String get chat_call_lang_select => '選擇通話語言';

  @override
  String get chat_call_save_memory => '保存本次通話回憶';

  @override
  String get chat_call_save_memory_desc => '通話結束後可重複回聽';

  @override
  String get chat_call_btn_start => '開始通話';

  @override
  String chat_points_shortage(String points) {
    return '花花點數不夠喔！目前有 $points 點';
  }

  @override
  String get chat_room_not_ready => '聊天室尚未準備好，請重新進入。';

  @override
  String get chat_stop_generating_msg => '已停止回覆，點數並沒有扣除 🍃';

  @override
  String get chat_heartbeat_up => '他心跳加速了...';

  @override
  String get chat_heartbeat_down => '他眼神變冷了...';

  @override
  String get chat_msg_copy => '複製內容';

  @override
  String get chat_msg_copied => '已複製到剪貼簿！';

  @override
  String get chat_msg_report => '舉報該對話框';

  @override
  String get chat_msg_suggest => '給建議';

  @override
  String get chat_report_title => '舉報此對話';

  @override
  String get chat_report_lang => '出現外文';

  @override
  String get chat_report_inapp => '回覆不恰當';

  @override
  String get chat_report_context => '上下文沒有連接';

  @override
  String get chat_report_other => '其他原因';

  @override
  String get chat_report_hint => '請描述您遇到的問題...';

  @override
  String get chat_report_submit => '送出';

  @override
  String get chat_report_success => '✅ 舉報已送出，我們會盡快調整';

  @override
  String get chat_suggest_title => '給予建議';

  @override
  String get chat_suggest_hint => '請寫下您的寶貴意見...';

  @override
  String get chat_suggest_success => '💖 感謝您的建議，我們會盡快處理';

  @override
  String get chat_del_warn => '訊息刪除後將無法復原。';

  @override
  String get chat_reset_title => '重置記憶';

  @override
  String get chat_reset_desc =>
      '請選擇重置的程度：\n\n1. 【僅對話】：清除對話紀錄，但保留好感度。\n2. 【完全重置】：一切歸零，像初次見面一樣。';

  @override
  String get chat_reset_only_chat => '僅對話紀錄';

  @override
  String get chat_reset_full => '完全重置';

  @override
  String get chat_reset_full_msg => '一切已回歸最初，他不再記得妳了...';

  @override
  String get chat_reset_chat_msg => '對話已清空，但他對妳的愛意依然存在。';

  @override
  String get chat_edit_ai_hint => '編輯他的回覆...';

  @override
  String get chat_edit_user_hint => '請輸入新的內容...';

  @override
  String chat_no_voice_msg(String name) {
    return '目前還沒有 $name 的聲音...';
  }

  @override
  String get chat_poke_btn => '戳一下';

  @override
  String get chat_poke_success => '✨ 已幫妳戳戳創作者囉！請期待他的聲音上線～';

  @override
  String chat_gift_points_needed(String cost) {
    return '花花點數不夠喔！需要 $cost 點 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ 命定之人 ✨';

  @override
  String get chat_levelup_normal => '關係晉升！💖';

  @override
  String get chat_levelup_btn_soulmate => '刻入靈魂';

  @override
  String get chat_levelup_btn_normal => '心動收下';

  @override
  String get chat_loc_title => '📍 傳送虛擬定位';

  @override
  String get chat_loc_custom_btn => '發送自訂定位';

  @override
  String get chat_loc_hint => '輸入其他地點... (例如：在你心裡)';

  @override
  String get chat_loc_1 => '在你家樓下';

  @override
  String get chat_loc_2 => '在學校';

  @override
  String get chat_loc_3 => '在剛才路過的咖啡廳';

  @override
  String get chat_loc_4 => '在便利商店';

  @override
  String get chat_interact_title => '✨ 想對他做什麼呢？';

  @override
  String get chat_interact_action => '戳一戳與小動作';

  @override
  String get chat_interact_gift => '送他小禮物 (消耗花花 🌸)';

  @override
  String get chat_action_poke => '戳戳臉頰';

  @override
  String get chat_action_hug => '討抱抱';

  @override
  String get chat_action_hand => '偷偷牽手';

  @override
  String get chat_dice_btn => '擲骰子';

  @override
  String get chat_loading_failed => '讀取回憶失敗，請返回重試。';

  @override
  String get chat_test_mode_msg => '測試模式已開啟，隨便聊聊吧！(對話不會存檔喔)';

  @override
  String get chat_empty_msg => '與他開始一段心動的旅程吧!';

  @override
  String get chat_ai_typing => '對方正在回覆...';

  @override
  String get chat_input_hint_default => '想對他說什麼...';

  @override
  String get chat_typing_indicator => '正在輸入中...';

  @override
  String get chat_menu_search => '搜尋對話';

  @override
  String get chat_menu_gallery => '專屬回憶與背景';

  @override
  String get chat_menu_aboutme => '與我相關';

  @override
  String get chat_menu_memo => '給他的備忘錄';

  @override
  String get chat_menu_period => '生理期追蹤';

  @override
  String get chat_menu_reset => '重置記憶';

  @override
  String get chat_search_hint => '想回味哪一段甜蜜對話呢？';

  @override
  String get chat_search_empty => '找不到這段回憶喔 🥺';

  @override
  String get chat_search_you => '妳說的';

  @override
  String get chat_search_him => '他說的';

  @override
  String get chat_tool_backpack => '背包';

  @override
  String get chat_tool_story => '劇情摘要';

  @override
  String get chat_tool_photo => '照片';

  @override
  String get chat_tool_record => '錄音';

  @override
  String get chat_tool_profile => '拾光檔案';

  @override
  String get chat_tool_interact => '互動玩法';

  @override
  String get chat_record_recording => '錄音中...';

  @override
  String get chat_record_start => '點擊麥克風開始錄音';

  @override
  String get chat_record_done => '錄音完成';

  @override
  String get chat_mode_daily_desc => '輕鬆愉快的日常閒聊，就像朋友一樣!。';

  @override
  String get chat_mode_story_desc => '小說般的劇情推進。';

  @override
  String get chat_mode_immersive_desc => '極致的感官體驗，無拘無束的深層互動。';

  @override
  String get chat_switch_mode_title => '切換聊天模式';

  @override
  String get chat_voice_call => '語音通話';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【系統事件】$playerName送出了一個【$giftName】。';
  }

  @override
  String get rel_title_soulmate => '靈魂伴侶/深愛';

  @override
  String get rel_title_lover => '熱戀期/專屬男友';

  @override
  String get rel_title_ambiguous => '曖昧期/互相試探';

  @override
  String get rel_title_friend => '普通朋友/好感萌芽';

  @override
  String get rel_title_acquaintance => '點頭之交/稍微眼熟';

  @override
  String get rel_title_stranger => '陌生/初識';

  @override
  String get rel_title_tense => '關係緊張/心生厭煩';

  @override
  String get rel_title_avoiding => '形同陌路/刻意躲避';

  @override
  String get rel_title_hostile => '極度厭惡/冰冷敵意';

  @override
  String get rel_title_nemesis => '不共戴天/永不相見';

  @override
  String get rel_msg_soulmate => '「沒想到...妳對我來說，已經變得這麼重要了。重要到...我無法想像沒有妳的世界。」';

  @override
  String get rel_msg_lover => '「這輩子最幸運的事，大概就是在那天，回頭看見了妳。」';

  @override
  String get rel_msg_ambiguous => '「最近...我發現自己發呆的時間變多了，而且腦袋裡全都是妳。」';

  @override
  String get rel_msg_friend => '「既然是妳的邀約，那我稍微空出點時間，也不是不行。」';

  @override
  String get rel_msg_acquaintance => '「最近常看到妳，感覺...並不討厭這種見面的頻率。」';

  @override
  String get rel_msg_stranger => '「原來妳也在這裡，這算是一種奇妙的緣分嗎？」';

  @override
  String chat_edit_char_count(String count) {
    return '$count 字';
  }

  @override
  String get chat_mysterious_player => '神秘玩家';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return '玩家 $playerName 期待著聽見 $characterName 的聲音，快去生成吧！';
  }

  @override
  String get gift_heart => '愛心';

  @override
  String get gift_flower => '花花';

  @override
  String get gift_sun => '太陽';

  @override
  String get gift_confetti => '拉炮';

  @override
  String get gift_coffee => '咖啡';

  @override
  String get gift_cake => '蛋糕';

  @override
  String get chat_action_poke_prompt => '（玩家突然伸出手，調皮地戳了戳你的臉頰）';

  @override
  String get chat_action_hug_prompt => '（玩家委屈巴巴地張開雙手，想要一個溫暖的抱抱）';

  @override
  String get chat_action_hand_prompt => '（玩家在桌子底下，悄悄握住了你的手）';

  @override
  String get chat_menu_send_location => '發送虛擬定位';

  @override
  String get weekday_mon => '(一)';

  @override
  String get weekday_tue => '(二)';

  @override
  String get weekday_wed => '(三)';

  @override
  String get weekday_thu => '(四)';

  @override
  String get weekday_fri => '(五)';

  @override
  String get weekday_sat => '(六)';

  @override
  String get weekday_sun => '(日)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ 獲得新回憶：$memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack => '已自動收錄至他的專屬背包';

  @override
  String get chat_profile_updated_msg => '拾光檔案已更新！他會記住妳的最新設定喔 🍃';

  @override
  String get comment_loading_author => '讀取中...';

  @override
  String comment_post_failed(String error) {
    return '留言失敗，請檢查網路連線：$error';
  }

  @override
  String get comment_delete_confirm_desc => '您確定要永久刪除這則留言嗎？';

  @override
  String get comment_delete_failed => '刪除失敗，請檢查網路連線';

  @override
  String get comment_identity_title => '選擇留言身分';

  @override
  String get comment_identity_myself => '我本人';

  @override
  String get comment_report_title => '確認檢舉';

  @override
  String get comment_report_rules_title => '⚖️ 留言檢舉規範';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ 初犯：系統警告並記錄一次違規。\n2️⃣ 二犯：禁止留言 1 天。\n3️⃣ 累犯：禁用檢舉功能 14 天，並降低留言能見度。\n\n🚨 嚴重惡意者：\n禁止與角色互動 1 天，ID 將公告於公佈欄 3 天（期間禁止更改 ID）。\n\n💡 檢舉送出後，最終審核結果將透過【遊戲內信箱】單獨發送給您。\n請互相尊重，理性檢舉。';

  @override
  String get comment_report_understood => '我已了解';

  @override
  String get comment_report_confirm_desc => '您確定要檢舉這則留言嗎？\n惡意檢舉可能會受到懲罰。';

  @override
  String get comment_report_submit_btn => '確定檢舉';

  @override
  String get comment_report_success => '感謝您的檢舉，我們會盡快核實！';

  @override
  String get comment_report_failed => '檢舉送出失敗，請稍後再試。';

  @override
  String get comment_option_delete => '刪除留言';

  @override
  String get comment_option_report => '檢舉留言';

  @override
  String comment_time_days_ago(String days) {
    return '$days天前';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '$hours小時前';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '$mins分鐘前';
  }

  @override
  String get comment_time_just_now => '剛剛';

  @override
  String get comment_sheet_title => '留言';

  @override
  String get comment_empty_state => '還沒有人留言，快來搶頭香！';

  @override
  String get comment_reply_btn => '回覆';

  @override
  String comment_replying_to(String name) {
    return '正在回覆 @$name';
  }

  @override
  String comment_input_hint(String name) {
    return '以 $name 的身分留言...';
  }

  @override
  String char_story_expect(String pronoun) {
    return '期待與$pronoun的故事...';
  }

  @override
  String get common_update_failed => '更新失敗，請檢查網路';

  @override
  String get char_edit_fragment => '編輯碎片';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 討厭：$dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 喜歡：$likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age歲 | $job';
  }

  @override
  String get common_got_it => '我知道了';

  @override
  String get common_add_failed => '新增失敗，請檢查網路';

  @override
  String common_delete_failed_with_err(String error) {
    return '刪除失敗，請檢查網路狀態：$error';
  }

  @override
  String get char_exclusive_guardian => '專屬守護 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName 喜歡了 $charName！';
  }

  @override
  String chat_translation_prefix(String content) {
    return '【譯】$content (這是翻譯後的感性內容)';
  }

  @override
  String get player_default_nickname => '旅人';

  @override
  String get moment_create_title => '發布新動態';

  @override
  String get moment_create_post_btn => '發布';

  @override
  String get moment_create_hint => '分享新鮮事...';

  @override
  String get moment_create_error_empty => '文字和圖片至少需要一項喔！';

  @override
  String get moment_create_error_failed => '發布失敗，請稍後再試';

  @override
  String get moment_create_visibility_public => '公開 (所有人可見)';

  @override
  String get moment_create_visibility_private => '私密 (僅好友可見)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (玩家發送了定位：$location)';
  }

  @override
  String get chat_you => '妳';

  @override
  String get chat_opponent => '對手';

  @override
  String chat_dice_duel_result(String name) {
    return '【系統事件】與$name擲骰子對決！結果出來了...';
  }

  @override
  String get chat_loading_status => '正在讀取中...';

  @override
  String chat_error_load_msg(String error) {
    return '讀取訊息失敗: $error';
  }

  @override
  String get chat_voice_msg_label => '語音訊息';

  @override
  String chat_special_story_trigger(String title) {
    return '【開啟特殊劇情：$title】';
  }

  @override
  String common_edit_failed(String error) {
    return '編輯失敗: $error';
  }

  @override
  String common_reset_failed(String error) {
    return '重置失敗: $error';
  }

  @override
  String get chat_default_greeting => '你好...';

  @override
  String get chat_memory_cleared => '記憶已徹底清空';

  @override
  String get chat_history_reset => '對話已重置';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 【 專屬拾光檔案 - $name 】\n━━━━━━━━━━━━━━━━━━\n🔹 姓名：$identity\n🔹 生日：$birthday\n🔹 身高：$height\n🔹 外貌：$appearance\n🔹 職業：$job\n\n📖 【 關於她的靈魂碎片 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 【 專屬拾光檔案 】\n━━━━━━━━━━━━━━━━━━\n🔹 姓名：$nickname\n🔹 生日：$birthday\n\n🔒 其他人設資料尚未解鎖...\n(填寫完整檔案，讓他在平行時空更了解妳吧！✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => '未命名檔案';

  @override
  String get chat_default_player_name => '玩家';

  @override
  String get error_system_confusion => '系統出現小混亂，請再試一次。';

  @override
  String get error_msg_send_failed => '訊息傳送失敗，請再試一次。';

  @override
  String get error_system_busy => '系統繁忙，請稍後再試。';

  @override
  String get error_network_unavailable => '目前暫時無法連線，請重試。';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 通話結束，與 $name 通話了 $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return '專屬劇情：$title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return '這是一段專屬於妳和 $name 的隱藏回憶...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return '一段關於「$keyword」的專屬回憶已悄悄解鎖...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '【隱藏事件觸發：$title】\n$scene';
  }

  @override
  String get chat_first_line_fallback => '……（他靜靜地看著妳，似乎在等妳先開口）';

  @override
  String get chat_new_room_created => '新的聊天室已建立';

  @override
  String portfolio_title(String nickname) {
    return '$nickname的作品集';
  }

  @override
  String get enter_secret_studio => '進入我的秘密工作室';

  @override
  String get no_public_character_mine => '妳還沒有發布任何公開角色喔！\n快去工作室創作吧✨';

  @override
  String get no_public_character_other => '這位創作者還沒有發布角色喔...';

  @override
  String get delete_draft_title => '刪除草稿';

  @override
  String get confirm_delete_draft_msg => '確定要刪除這個未完成的角色嗎？\n(刪除後無法復原喔)';

  @override
  String get draft_cleared_success => '草稿已清理完畢 🧹';

  @override
  String get login_required_for_studio => '請先登入才能進入工作室喔！';

  @override
  String get my_secret_studio_title => '我的秘密工作室 🛠️';

  @override
  String get create_new_character_btn => '創造新角色';

  @override
  String get unnamed_draft => '未命名草稿';

  @override
  String get click_to_edit_story => '點擊繼續編輯他的故事...';

  @override
  String get label_draft => '草稿';

  @override
  String get studio_empty_title => '工作室目前空空如也';

  @override
  String get studio_empty_subtitle => '點擊右下角，開始創造妳的第一個角色吧！';

  @override
  String get common_no_changes => '沒有任何變更';

  @override
  String get moment_updated_success => '動態已更新！';

  @override
  String common_save_failed(String error) {
    return '儲存失敗: $error';
  }

  @override
  String get moment_edit_title => '編輯動態';

  @override
  String get action_change_image => '更換圖片';

  @override
  String get action_remove_image => '移除圖片';

  @override
  String get moment_delete_confirm_title => '確定要刪除這則動態嗎？';

  @override
  String get moment_delete_confirm_content => '刪除後，這段朋友圈的回憶就會消失喔！';

  @override
  String get action_confirm_delete => '確定刪除';

  @override
  String get friend_unknown => '某位朋友';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname覺得妳的動態很讚喔！💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname覺得$authorName很有魅力，點了個讚！✨';
  }

  @override
  String get moment_like_success => '已傳遞妳的心動！✨';

  @override
  String get moment_notification_new_like => '新點讚！💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname 在動態中提到了 @$name 喔！✨';
  }

  @override
  String get moment_detail_title => '動態詳情';

  @override
  String get moment_not_found => '這篇動態好像不見了... 😢';

  @override
  String get moment_comment_title => '朋友圈留言';

  @override
  String get moment_comment_empty => '還沒有人留言，快來搶沙發！🛋';

  @override
  String moment_replying_to(String name) {
    return '正在回覆 @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return '回覆 @$name...';
  }

  @override
  String get moment_leave_comment_hint => '留下妳的回應...';

  @override
  String get moment_delete_permanent_confirm => '這則動態將被永久刪除，確定嗎？';

  @override
  String get moment_action_delete => '刪除動態';

  @override
  String get moment_action_report => '檢舉此動態';

  @override
  String get moment_action_share => '分享這則動態';

  @override
  String get moment_forward_hint => '轉發這篇動態給角色...';

  @override
  String moment_reply_private(String name) {
    return '私訊回覆 $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return '帶著動態去找 $name 聊天囉！ 💬';
  }

  @override
  String get moment_share_to_apps => '分享到其他應用程式';

  @override
  String moment_likes_label(String count) {
    return '$count 片葉子';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】快來看 $author 的動態：$content\n\n立即下載，開啟妳的專屬時光：$appLink';
  }

  @override
  String get moment_forward_title => '轉發給正在聊天的角色 💌';

  @override
  String get moment_forward_empty_state => '妳目前還沒有開始聊天的角色喔！\n先去大廳找找心儀的他吧 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【轉發了一則動態】\n作者：$author\n內容：$content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ 已悄悄分享給 $name 囉！';
  }

  @override
  String get action_send => '發送';

  @override
  String get memo_delete_confirm => '您確定要刪除這則備忘錄嗎？此操作無法復原。';

  @override
  String get memo_add_title => '新增備忘錄';

  @override
  String get memo_edit_title => '編輯備忘錄';

  @override
  String memo_hint_text(String name) {
    return '想記下關於 $name 的什麼呢？';
  }

  @override
  String get memo_label_reminder_date => '提醒日期:';

  @override
  String get memo_action_save => '儲存備忘';

  @override
  String get memo_error_empty_content => '內容不能空白喔！';

  @override
  String memo_list_title(String name) {
    return '與 $name 的備忘錄';
  }

  @override
  String get memo_empty_state => '還沒有任何備忘錄喔！\n點擊右上角新增一個吧！';

  @override
  String memo_reminder_date_display(String date) {
    return '提醒日：$date';
  }

  @override
  String get daily_gift_title => '時光每日贈禮';

  @override
  String daily_login_welcome(String appName, String amount) {
    return '歡迎回到《$appName》！\n今日簽到可領取 $amount 點花語點數。🌸';
  }

  @override
  String get title_daily_check_in => '每日簽到';

  @override
  String success_claim_reward(String amount) {
    return '成功領取 $amount 點花語！🌸';
  }

  @override
  String get error_claim_failed => '領取失敗，請檢查網路後重試。';

  @override
  String get action_claim_now => '立即領取';

  @override
  String get common_or => '或';

  @override
  String get title_language_settings => '語言設定';

  @override
  String get app_name => '戀戀拾光';

  @override
  String get login_slogan => '開啟妳的專屬時光';

  @override
  String get login_with_google => '使用 Google 登入';

  @override
  String get login_with_apple => '透過 Apple 登入';

  @override
  String get login_with_facebook => '使用 Facebook 登入';

  @override
  String get login_with_email => '使用戀戀帳號登入 (Email)';

  @override
  String get title_contact_us_heading => '我們非常重視您的建議！';

  @override
  String get desc_contact_us_body => '請在這裡寫下您的想法，幫助我們把遊戲變得更好。';

  @override
  String get error_feedback_empty => '建議內容不能為空喔！';

  @override
  String get email_subject_feedback => '戀戀拾光 - 玩家反饋建議';

  @override
  String get msg_email_app_not_found_copied => '無法自動開啟郵件，已為您複製官方信箱！';

  @override
  String get title_contact_us => '聯絡我們';

  @override
  String get desc_contact_us => '我們非常重視您的建議！\n請在這裡寫下您的想法，幫助我們把遊戲變得更好。';

  @override
  String get hint_enter_feedback => '請在此輸入您的建議...';

  @override
  String get action_send_via_email => '透過 Email 傳送';

  @override
  String get error_email_password_empty => '信箱和密碼不能為空喔！';

  @override
  String get auth_error_default => '發生錯誤，請稍後再試。';

  @override
  String get auth_error_user_not_found => '找不到此信箱，請先註冊喔！';

  @override
  String get auth_error_wrong_password => '密碼錯誤，請再試一次！';

  @override
  String get auth_error_email_in_use => '這個信箱已經被註冊過囉！請直接登入。';

  @override
  String get auth_error_weak_password => '密碼太弱了，請至少輸入 6 個字元！';

  @override
  String get auth_error_invalid_email => '信箱格式不正確！';

  @override
  String get title_welcome_back => '歡迎回來';

  @override
  String get title_register_account => '註冊專屬帳號';

  @override
  String get label_email => '電子郵件';

  @override
  String get label_password => '密碼';

  @override
  String get action_login => '登入';

  @override
  String get action_register => '註冊';

  @override
  String get prompt_no_account => '還沒有帳號？點我註冊';

  @override
  String get prompt_has_account => '已經有帳號了？點我登入';

  @override
  String get error_nickname_empty => '暱稱不能為空！';

  @override
  String get profile_saved_success => '個人檔案儲存！';

  @override
  String get error_id_empty => 'ID不能為空！';

  @override
  String get error_id_too_long => 'ID長度不能超過10個字元！';

  @override
  String get error_id_already_used => '此ID已被使用，請換一個！';

  @override
  String profile_save_failed(String error) {
    return '儲存失敗: $error';
  }

  @override
  String get draft_saved_success_msg => '好的！先幫你保存在草稿裡，隨時可以回來編輯喔！✨';

  @override
  String get dialog_reminder_title => '提醒';

  @override
  String get warning_id_not_edited => '專屬ID尚未編輯，您確定要現在儲存嗎？';

  @override
  String get action_continue_editing => '繼續編輯';

  @override
  String get action_edit_later => '之後再編輯';

  @override
  String get action_edit_later_short => '稍後再編輯';

  @override
  String get action_cancel_changes => '取消變更';

  @override
  String get error_birthdate_locked => '出生日期已設定，不可更改！';

  @override
  String get action_select_avatar => '選擇頭像';

  @override
  String get action_choose_from_gallery => '從相冊選擇';

  @override
  String get title_adjust_avatar => '調整您的時光頭像';

  @override
  String get avatar_updated_success => '已為您換上頭像 🍃';

  @override
  String get title_create_profile => '建立你的檔案';

  @override
  String get title_edit_profile => '編輯個人檔案';

  @override
  String get label_your_nickname => '您的暱稱';

  @override
  String get label_player_exclusive_id => '玩家專屬 ID';

  @override
  String get msg_id_locked => 'ID 已鎖定，無法再次更改。';

  @override
  String get msg_id_change_chance => '您有一次免費更改 ID 的機會。';

  @override
  String get action_select_birthdate => '請選擇出生日期';

  @override
  String label_birthdate(String date) {
    return '出生日期: $date';
  }

  @override
  String get msg_birthdate_immutable => '生日設定後不可更改 ✨';

  @override
  String get action_start_journey => '開啟時光旅程';

  @override
  String get action_add_image => '新增圖片';

  @override
  String moment_like_self(String nickname) {
    return '$nickname覺得妳的動態很讚喔！💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname覺得$authorName很有魅力，點了個讚！✨';
  }

  @override
  String get task_social_tour_complete => '✨ 達成社群巡禮任務！記得領取花花喔！🌸';

  @override
  String get wall_title_shiguang => '拾光牆';

  @override
  String get wall_tab_explore => '🌍 探索';

  @override
  String get wall_tab_exclusive => '🔒 專屬';

  @override
  String get more_options => '更多選項';

  @override
  String get delete_warning => '刪除後，貼文將無法找回';

  @override
  String get delete_success => '刪除成功';

  @override
  String get notification_new_comment => '新留言！💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName 對妳的動態點了個讚！';
  }

  @override
  String get empty_public_moments_prompt => '目前空空如也，\n快去發布第一篇公開動態吧！🌍';

  @override
  String get empty_private_moments_prompt => '朋友圈還沒有留下的瞬間，\n快去與他創造回憶吧！✨';

  @override
  String get profile_archived_or_deleted_message =>
      '這份靈魂檔案已被創作者封存、設為私人，或是已經消散在時空的洪流中...\n\n或許在某個平行宇宙，你們還有再次相遇的機會。✨';

  @override
  String get leave_silently => '默默離開';

  @override
  String get character_post_schedule => '角色發文排程';

  @override
  String get creator_self => '創作者本人';

  @override
  String get post_identity_prompt => '今天要用誰的身分發文？';

  @override
  String get identity_creator => '✨ 創作者身分';

  @override
  String get identity_character => '角色身分';

  @override
  String get decide_post_time_prompt => '幫他們決定發文時間吧！';

  @override
  String get auto_post_schedule_hint =>
      '開啟後，將會在指定時間自動發布日常動態\n(💡 建議設定非整點，看起來更像真人喔！)';

  @override
  String get no_characters_created_yet => '妳還沒有創建任何角色喔！';

  @override
  String time_hour(String hour) {
    return '$hour 點';
  }

  @override
  String time_minute(String minute) {
    return '$minute 分';
  }

  @override
  String get empty_public_moments_short => '目前還沒有公開動態 🌍';

  @override
  String get empty_private_moments_short => '朋友圈還靜悄悄的 ✨';

  @override
  String get my_created_characters => '我創建的角色';

  @override
  String get no_characters_yet => '尚未創建角色';

  @override
  String play_count_display(int count) {
    return '遊玩次數: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return '$characterName 的關心日曆';
  }

  @override
  String get care_calendar_greeting => '今天的心情如何？';

  @override
  String get care_calendar_save_btn => '儲存紀錄，讓他照顧妳';

  @override
  String get care_calendar_delete_confirm => '要刪除這筆紀錄嗎？';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName：「我都記下來了，這幾天辛苦妳了，我會一直在妳身邊的。」';
  }

  @override
  String get daily_gift_success => '成功領取每日贈禮！🌸';

  @override
  String get check_in_fail_network => '簽到失敗，請檢查網路連線 🍃';

  @override
  String task_completed(String taskName) {
    return '完成任務：$taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return '成功領取「$taskName」的 $rewardAmount 點花花！';
  }

  @override
  String claim_failed_error(String e) {
    return '領取失敗: $e';
  }

  @override
  String get tab_heartbeat_diary => '心動日記';

  @override
  String get tab_daily_chit_chat => '閒話家常';

  @override
  String get task_desc_chat_3_times => '與角色進行 3 次日常聊天';

  @override
  String get tab_story_progression => '劇情推進';

  @override
  String get task_desc_story_1_time => '完成 1 次劇情模式互動';

  @override
  String get tab_social_tour => '社群巡禮';

  @override
  String get task_desc_like_3_moments => '為 3 則朋友圈動態按讚';

  @override
  String get btn_claimed => '已領取';

  @override
  String get btn_claim => '領取';

  @override
  String get btn_incomplete => '未完成';

  @override
  String get network_unstable_retry => '網路連線不穩，請稍後再試🍃';

  @override
  String get title_time_travel => '時光旅行';

  @override
  String get select_chat_mode => '選擇聊天模式';

  @override
  String get mode_chat => '聊天';

  @override
  String get mode_daily_desc => '輕鬆閒聊，維持羈絆';

  @override
  String get mode_story_desc => '深入故事，體驗沉浸感';

  @override
  String get greeting_hello => '你好！';

  @override
  String get greeting_default_daily => '找我有事嗎？';

  @override
  String get title_personal_homepage => '個人主頁';

  @override
  String get title_time_letters => '時光信件';

  @override
  String get status_signed_in_today => '今日已簽到';

  @override
  String get status_signing_in => '簽到中...';

  @override
  String get status_daily_sign_in => '每日簽到 (+10 花花)';

  @override
  String get toast_id_copied => 'ID 已複製！';

  @override
  String get hint_click_avatar_to_edit => '點擊頭像進行個人檔案編輯';

  @override
  String get title_my_friends => '我的好友';

  @override
  String get action_show_all => '顯示全部';

  @override
  String get empty_no_characters_created => '您尚未創建任何角色。';

  @override
  String get common_close => '關閉';

  @override
  String get search_companion_title => '搜尋拾光伴侶';

  @override
  String get search_name_placeholder => '輸入他的名字...';

  @override
  String get search_no_match_hint => '找不到角色，試試其他名字？ ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age歲 | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age歲';
  }

  @override
  String get empty_state_warmth => '這裡還留存著時空的餘溫...';

  @override
  String get error_login_required_add_friend => '請先登入才能添加好友！';

  @override
  String get dialog_title_remove_friend => '確認移除好友';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return '您確定要將 $characterName 從好友列表中移除嗎？';
  }

  @override
  String get action_remove => '移除';

  @override
  String snackbar_friend_removed(String characterName) {
    return '已將 $characterName 移除好友';
  }

  @override
  String get action_remove_friend => '移除好友';

  @override
  String get dialog_title_block => '確認封鎖';

  @override
  String dialog_msg_block(String characterName) {
    return '封鎖後，您將不會再看到 $characterName 的任何資訊。確定要封鎖嗎？';
  }

  @override
  String snackbar_blocked(String characterName) {
    return '已封鎖 $characterName';
  }

  @override
  String get action_block_character => '封鎖此角色';

  @override
  String dialog_title_report(String characterName) {
    return '檢舉 $characterName';
  }

  @override
  String get input_hint_report_reason => '請輸入檢舉原因...';

  @override
  String get action_submit => '提交';

  @override
  String get snackbar_report_success => '感謝您的回報，我們將會盡快審核。';

  @override
  String get snackbar_report_fail => '提交失敗，請稍後再試';

  @override
  String get action_report_character => '檢舉此角色';

  @override
  String get title_meet_him => '遇見心儀的他';

  @override
  String text_character_count(int count) {
    return '角色數量: $count';
  }

  @override
  String get msg_no_more_encounters_today => '今天的邂逅就到這裡囉！';

  @override
  String get msg_check_new_encounters => '再來看看有沒有新的相遇吧！';

  @override
  String get action_refresh => '重新整理';

  @override
  String get tab_friends => '好友';

  @override
  String get msg_mysterious_profile => '這個人很神秘，什麼都沒留下...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age歲 | $identities';
  }

  @override
  String get snackbar_operation_failed => '操作失敗，請稍後再試';

  @override
  String get action_view_translation => '查看翻譯';

  @override
  String get label_translation_result => '翻譯結果:';

  @override
  String get errorWebPageUnavailable => '暫時無法開啟網頁，請稍後再試';

  @override
  String get resetAppearanceTitle => '要重置外觀嗎？';

  @override
  String get resetAppearanceWarning => '這將會移除您精心挑選的背景圖與顏色喔！';

  @override
  String get appearanceRestored => '已恢復預設外觀';

  @override
  String get confirmReset => '確定重置';

  @override
  String get resetToDefaultAppearance => '恢復預設外觀';

  @override
  String get clearCustomSettings => '清除所有自定義顏色與背景圖';

  @override
  String get contactUs => '聯絡我們';

  @override
  String get contactDescription => '有任何心裡話或 Bug 都能告訴我們';

  @override
  String get vibrationHapticTitle => '心動震動感應';

  @override
  String get vibrationHapticDescription => '好感度大幅變動時觸發手機震動';

  @override
  String get splash_loading_universe => '正在喚醒《戀戀拾光》的宇宙...';

  @override
  String get shop_title => '花花小舖';

  @override
  String get shop_current_points_label => '目前持有的花花點數';

  @override
  String get shop_tab_top_up => '點數儲值';

  @override
  String get shop_tab_history => '收支明細';

  @override
  String get shop_empty_history => '目前還沒有花花紀錄喔！🌸';

  @override
  String get shop_unknown_item => '未知項目';

  @override
  String get shop_first_purchase_bonus => '首購雙倍！';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get settingsTitle => '设定';

  @override
  String get changeTheme => '更换主题颜色';

  @override
  String get feedback => '反馈建议';

  @override
  String get changeLanguage => '更换语言';

  @override
  String get allFriendsTitle => '所有好友';

  @override
  String get noFriendsMessage => '您还没有任何好友。';

  @override
  String get unknownCharacter => '未知角色';

  @override
  String errorLoadingFriends(String error) {
    return '加载好友列表时发生错误: $error';
  }

  @override
  String get tagGentle => '温柔';

  @override
  String get tagCheerful => '开朗';

  @override
  String get tagLively => '活泼';

  @override
  String get tagMischievous => '调皮';

  @override
  String get tagRichYoungLady => '千金';

  @override
  String get tagRichYoungMaster => '少爷';

  @override
  String get tagWealthyFamily => '豪门';

  @override
  String get tagScheming => '勾心斗角';

  @override
  String get tagPossessive => '占有';

  @override
  String get tagParanoid => '偏执';

  @override
  String get tagPersistent => '执着';

  @override
  String get tagUncle => '大叔';

  @override
  String get tagAuntie => '阿姨';

  @override
  String get tagSeniorSister => '学姐';

  @override
  String get tagJuniorBrother => '学弟';

  @override
  String get tagHandsome => '帅';

  @override
  String get tagStunning => '美艳动人';

  @override
  String get tagContrast => '反差';

  @override
  String get tagFlirty => '开车';

  @override
  String get tagAgeGap => '年龄差';

  @override
  String get userNotFoundError => '找不到使用者';

  @override
  String get imageDataMismatchError => '图片资料不一致，请重新选择图片。';

  @override
  String get createCharacterTitle => '创建角色';

  @override
  String get charAlbumTitle => '角色相册 (第一张为主要头像)';

  @override
  String get charNameLabel => '角色名称:*';

  @override
  String get charDescSection => '角色描述:';

  @override
  String get charAgeLabel => '年龄:';

  @override
  String get charJobLabel => '职业:*';

  @override
  String get charBirthdayLabel => '生日:(MMDD)';

  @override
  String get charGenderLabel => '性别 *';

  @override
  String get genderNotSelected => '未选择';

  @override
  String get genderMale => '男';

  @override
  String get genderFemale => '女';

  @override
  String get genderOther => '其他';

  @override
  String get charHeightLabel => '身高:(cm)';

  @override
  String get charAppearanceLabel => '外貌形容:';

  @override
  String get charPersonalityTagsSection => '个性标签';

  @override
  String get charOtherPersonalityTagsHint => '其他个性标签...';

  @override
  String get otherSectionTitle => '其他';

  @override
  String get charLikesLabel => '喜欢的东西:(例如：草莓蛋糕、猫咪、雨天)';

  @override
  String get charDislikesLabel => '讨厌的东西:(例如：苦瓜、吵闹的地方)';

  @override
  String get charSecretsLabel => '不为人知的小秘密: (例如：其实是个路痴)';

  @override
  String get charMannerismsSection => '言行举止';

  @override
  String get charToneLabel => '说话语气与风格: (例如：对陌生人冷淡)';

  @override
  String get charDialogueExampleLabel => '对话范例: (玩家：你真好！ 角色：...喔。)';

  @override
  String get charBackgroundSection => '角色背景:';

  @override
  String get charBackgroundHint => '输入角色的背景故事 (最多 2500 字)';

  @override
  String get charStoryStartSection => '剧情开头:';

  @override
  String get charStoryStartHint => '输入角色的剧情 (最多 2500 字)';

  @override
  String get charStorySummaryLabel => '故事简介 (最多 50 字，会显示在邂逅卡片上)';

  @override
  String get charExtraInfoSection => '角色其他补充:';

  @override
  String get charExtraInfoHint => '输入补充内容...';

  @override
  String get charPublicToggleLabel => '公开让其他玩家游玩吗？';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get createButton => '创建';

  @override
  String get saveButton => '储存';

  @override
  String get cancelButton => '取消';

  @override
  String get exitCreationTitle => '您将退出创角画面';

  @override
  String get saveDraftPrompt => '需要储存为草稿吗？';

  @override
  String get draftNeeded => '需要';

  @override
  String get draftNotNeeded => '不需要';

  @override
  String get editExtraInfoTitle => '编辑补充内容';

  @override
  String get nameAndAvatarError => '请填写角色名称并至少上传一张头像！';

  @override
  String get savingStatus => '储存中...';

  @override
  String get uploadingImagesStatus => '正在上传图片...';

  @override
  String get maxImagesError => '最多只能上传 10 张图片。';

  @override
  String get uploadingImagesStatusShort => '正在处理图片...';

  @override
  String get savingCharacterData => '正在储存角色数据...';

  @override
  String characterCreatedSuccess(String charName) {
    return '角色 \"$charName\" 已创建！';
  }

  @override
  String get uploadImageTimeoutError => '创建角色失败：图片上传超时，请检查您的网络连接。';

  @override
  String createCharacterGenericError(String error) {
    return '创建角色失败：$error';
  }

  @override
  String get settingsSectionAppearance => '外观与内容';

  @override
  String get settingsSectionAccount => '帐号与内容管理';

  @override
  String get settingsSectionAbout => '关于我们';

  @override
  String get accountManagement => '帐号管理';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => '未知';

  @override
  String get userIdCopied => '使用者 ID 已复制到剪贴簿';

  @override
  String get characterManagement => '角色管理';

  @override
  String get viewBlockedCharacters => '查看已封锁的角色';

  @override
  String get privacyPolicy => '隐私条款';

  @override
  String get termsOfService => '服务条款';

  @override
  String get logoutButton => '登出帐号';

  @override
  String get logoutDialogTitle => '你要登出了吗?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => '我按错了';

  @override
  String get logoutDialogActionConfirm => '确认';

  @override
  String get logoutSuccessSnackbar => '好的!那我等你回来♥(´∀` )';

  @override
  String get deleteAccountButton => '删除帐号';

  @override
  String get deleteAccountDialogTitle => '你确定要删掉这个帐号?இдஇ';

  @override
  String get deleteAccountDialogContent => '这个操作无法复原，所有资料都会被永久删除！';

  @override
  String get deleteAccountDialogActionCancel => '没有,我没有要删掉';

  @override
  String get deleteAccountDialogActionConfirm => '确定';

  @override
  String get deleteAccountSuccessSnackbar => '帐号已成功删除。';

  @override
  String get appDisclaimer => '游戏里面的角色与场景皆为虚构,请勿带入现实!如有雷同,纯属巧合';

  @override
  String appVersion(String version) {
    return 'App 版本: $version';
  }

  @override
  String get dialogTitleHint => '提示';

  @override
  String get completeProfilePrompt => '请先编辑您的个人档案以完善资料喔！';

  @override
  String get goToEdit => '前往编辑';

  @override
  String get later => '稍后';

  @override
  String chattingWith(String friendName) {
    return '与 $friendName 聊天';
  }

  @override
  String chatContentWith(String friendName) {
    return '与 $friendName 的聊天内容';
  }

  @override
  String get chatInputHint => '输入讯息...';

  @override
  String get characterNotFoundError => '找不到角色资料';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return '读取角色详情失败: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => '初始关系';

  @override
  String get relationship_childhood_friend => '青梅竹马';

  @override
  String get relationship_senior_junior => '学长学妹';

  @override
  String get relationship_bickering_couple => '欢喜冤家';

  @override
  String get relationship_colleagues => '职场同事';

  @override
  String get relationship_other => '其他 (请手动输入)';

  @override
  String get chatModeDaily => '日常模式';

  @override
  String get chatModeStory => '剧情模式';

  @override
  String get chatModeImmersive => '沉浸模式';

  @override
  String get chatModeGemini => '生活陪伴';

  @override
  String get announcement_new => '新公告';

  @override
  String get mail_notification => '有新的时光信件寄达囉，快去羊皮卷看看吧！';

  @override
  String get customer_service_reply => '客服回复';

  @override
  String get system_announcement => '系统公告';

  @override
  String get empty_announcement => '目前没有任何公告喔';

  @override
  String get untitled => '无标题';

  @override
  String get no_content => '无内容';

  @override
  String get privacy_policy_title => '《恋恋拾光》隐私权政策';

  @override
  String get privacy_policy_date => '最近更新日期：2026年4月10日';

  @override
  String get privacy_policy_body =>
      '《恋恋拾光》隐私权政策\n最近更新日期：2026年4月10日\n\n欢迎使用《恋恋拾光》（以下简称“本服务”）。我们非常重视您的隐私，本政策旨在说明我们如何收集、使用及保护您的个人信息。\n\n1. 帐户信息：\n第三方登录：当您通过 Google、Facebook 或 Apple 帐号登录时，我们会收集您的 Firebase UID、电子邮件及公开昵称。\nE-mail 注册：您的登录密码将通过 Firebase 加密技术进行管理与存储，开发团队无法查阅您的原始密码。\n\n互动资料：为了让 AI 角色具备连续的记忆，我们会收集并存储您与 AI 的对话记录与您在游戏里面为角色所写下的内容。\n\n设备信息：包含设备型号、操作系统版本及唯一设备识别码。\n\n2. 信息的使用方式\n提升 AI 体验：优化 AI 的回复质量与个性连贯性。\n服务运营：用于处理点数充值、消费记录及身份验证。\n安全防护：监测恶意行为，保护服务器。\n\n3. 第三方技术合作\n本服务采用 Google Cloud / Firebase 以及 OpenRouter / xAI / Meta 提供技术支持。我们承诺不会向任何广告商出售您的原始对话记录。\n\n4. 数据存储与删除\n您的数据将安全地存储在云端服务器中。您可以随时联系我们要求永久删除您的帐户及所有相关对话数据。';

  @override
  String get terms_title => '《恋恋拾光》服务使用条款';

  @override
  String get terms_date => '最近更新日期：2026年4月10日';

  @override
  String get terms_body =>
      '《恋恋拾光》服务使用条款\n最近更新日期：2026年4月10日\n\n在使用《恋恋拾光》前，请仔细阅读以下条款：\n\n1. 服务本质与免责声明\n非真人互动：所有角色回复均由人工智能（Generative AI）生成。AI 可能生成虚构或不准确的内容。\n\n2. 虚拟点数与付费模式\n点数性质：点数一经消耗（如：故事模式、通话、礼物）即无法退还。消耗标准系根据 AI 运算成本设定。\n\n3. 使用者行为规范\n禁止事项：禁止利用 AI 生成极端暴力、犯罪或违反法律之内容。\n\n4. 知识产权\n原创内容：角色姓名（如：程安等）、背景设定、剧情剧本及游戏逻辑，其知识产权均属“恋恋拾光开发团队”所有。\n\n5. 服务终止\n若违反上述规定，本服务有权在不预先通知的情况下暂停或永久停用该帐户。';

  @override
  String get login_required => '请先登录系统';

  @override
  String get cloud_character_mgmt => '云端角色管理';

  @override
  String get connection_error => '连线出错';

  @override
  String get no_characters_met => '目前还没有认识任何角色喔！';

  @override
  String get status_paused => '状态：已暂停联系';

  @override
  String get status_in_progress => '状态：攻略中';

  @override
  String get unblock => '解除封锁';

  @override
  String get block => '封锁';

  @override
  String get confirm_block_title => '确定要封锁吗？';

  @override
  String block_warning_msg(String charName) {
    return '屏蔽后，将暂时无法收到 $charName 的消息哦。';
  }

  @override
  String get think_again => '再想想';

  @override
  String get confirm_block_btn => '确定封锁';

  @override
  String get no_char_info => '目前还没有这份角色的详细情报...';

  @override
  String get private_mailbox => '专属信箱';

  @override
  String get user_info_not_found => '找不到使用者资讯';

  @override
  String get load_failed => '载入失败，请稍后再试';

  @override
  String get empty_mailbox => '目前信箱空空的喔～';

  @override
  String get system_notification => '系统通知';

  @override
  String get interaction_records => '互动纪录';

  @override
  String get liked_content => '按赞过的内容';

  @override
  String get my_favorites => '我的收藏';

  @override
  String get login_to_view_records => '请先登录以查看纪录';

  @override
  String get no_likes_yet => '妳还没有按赞过任何动态喔！';

  @override
  String get empty_favorites => '专属收藏夹空空的，快去大厅逛逛吧！';

  @override
  String get theme_sakura_pink => '樱花粉';

  @override
  String get theme_ocean_blue => '湛蓝海';

  @override
  String get theme_sunset_orange => '夕阳橙';

  @override
  String get theme_mint_forest => '薄荷森';

  @override
  String get theme_midnight => '深夜模式';

  @override
  String get change_atmosphere => '更换氛围';

  @override
  String get custom_color => '自定义色彩';

  @override
  String get custom_color_desc => '调配妳的专属氛围色';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get confirm_delete_title => '确认删除';

  @override
  String get confirm_delete_memory_msg => '您确定要让他忘记这件事吗？此操作无法复原哦。';

  @override
  String get delete_btn => '删除';

  @override
  String get memory_erased_msg => '这段记忆已经被抹除了';

  @override
  String get delete_failed_msg => '删除失败';

  @override
  String get edit_memory_title => '编辑回忆';

  @override
  String get modify_memory_hint => '修改这段记忆...';

  @override
  String get memory_re_recorded_msg => '记忆已重新记录';

  @override
  String get update_failed_msg => '更新失败';

  @override
  String get update_favorite_failed_msg => '更新收藏状态失败';

  @override
  String char_notebook_title(String charName) {
    return '$charName的记事本';
  }

  @override
  String get error_loading_memory => '读取记忆时发生错误';

  @override
  String get empty_notebook_msg => '笔记本里空空的...\n赶快去聊天，让他记下关于你的点点滴滴吧！';

  @override
  String get date_format_text => 'yyyy年M月d日';

  @override
  String get remove_special_focus => '取消特别关注';

  @override
  String get mark_special_focus => '标记为特别关注';

  @override
  String get edit_btn => '编辑';

  @override
  String get load_gallery_failed => '读取图鉴失败';

  @override
  String get traditional_chinese => '繁体中文';

  @override
  String get all => '全部';

  @override
  String get official_recommendation => '官方推荐';

  @override
  String get my_exclusive => '我的专属';

  @override
  String encounter_count(int count) {
    return '$count 次邂逅';
  }

  @override
  String get official => '官方';

  @override
  String get private => '私人';

  @override
  String get first_encounter => '初次相遇';

  @override
  String char_exclusive_memory(String charName) {
    return '$charName的专属回忆';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return '好感度需达到 $affectionLevel 才能解锁这张回忆哦！';
  }

  @override
  String get affection => '好感度';

  @override
  String get unlock => '解锁';

  @override
  String get change_chat_bg => '更换聊天背景';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return '要将“$cgDesc”设为与 $charName 的聊天背景吗？';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return '已将背景更换为“$cgDesc”';
  }

  @override
  String get confirm_change => '确定更换';

  @override
  String get empty_treasure_box => '百宝箱里空空的...\n快去聊天寻找隐藏的专属彩蛋吧！';

  @override
  String get unknown_story => '未知剧情';

  @override
  String get open_this_memory => '开启这段回忆';

  @override
  String get open_exclusive_story => '开启专属剧情';

  @override
  String confirm_use_egg(String eggTitle) {
    return '确定要现在体验“$eggTitle”吗？\n\n(此道具为一次性消耗，使用后将自动进入剧情)';
  }

  @override
  String get wait_a_bit => '再等等';

  @override
  String guiding_into_story(String eggTitle) {
    return '正在引导进入...';
  }

  @override
  String get use_now => '立即使用';

  @override
  String playback_failed_status(String statusCode) {
    return '播放失败，状态码：$statusCode';
  }

  @override
  String get playback_error => '播放发生错误';

  @override
  String get unknown_contact => '未知联系人';

  @override
  String call_memory_with(String charName) {
    return '与 $charName 的通话回忆';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return '好感度 $affection 解锁';
  }

  @override
  String get no_call_record => '这通电话似乎没有留下对话纪录...';

  @override
  String get me => '我';

  @override
  String get playing => '播放中...';

  @override
  String get listen => '聆听';

  @override
  String get no_exclusive_voice => '这只角色还没有设定专属声音哦！';

  @override
  String get voice_download_success => '✅ 语音数据下载成功，准备直接播放...';

  @override
  String get onboarding_invitation => '— 拾光邀请函 —';

  @override
  String get onboarding_welcome => '欢迎来到恋恋拾光';

  @override
  String get onboarding_quote => '「所有的相遇，都是久别重逢。」';

  @override
  String get onboarding_gift_title => '获得初见礼：50 朵花语';

  @override
  String get onboarding_gift_subtitle => '这些花朵将陪伴您开启与他的故事';

  @override
  String get onboarding_start_button => '开启您的时光旅程';

  @override
  String get onboarding_more_info => '了解更多关于拾光的故事';

  @override
  String get legal_agreement_prefix => '继续即表示您同意本游戏的';

  @override
  String get legal_terms_button => '服务条款';

  @override
  String get legal_and => ' 与 ';

  @override
  String get legal_privacy_button => '隐私权政策';

  @override
  String get call_memory_title => '通话回忆录';

  @override
  String get please_login_first => '请先登录哦';

  @override
  String get no_call_memories => '目前还没有保存的通话回忆\n最多只能保存10则收藏哦';

  @override
  String call_with_name(String name) {
    return '与 $name 的通话';
  }

  @override
  String call_duration(String time) {
    return '时长：$time';
  }

  @override
  String get delete_call_title => '销毁通话记录';

  @override
  String delete_call_confirm(String name) {
    return '确定要秘密销毁这段与 $name 的通话回忆吗？\n(删除后无法找回哦)';
  }

  @override
  String get keep_it => '先留着';

  @override
  String get confirm_delete => '确定销毁';

  @override
  String get press_mic_to_speak => '请按下麦克风开始说话...';

  @override
  String get call_ended => '通话已结束';

  @override
  String character_thinking(String name) {
    return '（$name 正在思考...）';
  }

  @override
  String character_picking_up(String name) {
    return '（$name 正在接起电话...）';
  }

  @override
  String get call_interrupted_login => '（通话中断）请先登录喔...';

  @override
  String get silence => '（沈默）';

  @override
  String get bad_signal => '（信号不好...）';

  @override
  String get static_noise => '（沙沙声）...听不清楚...';

  @override
  String get type_message_hint => '输入文字...';

  @override
  String get draft_saved_success => '草稿已安全储存至秘密工作室！';

  @override
  String get draft_save_failed => '储存失败，请稍后再试';

  @override
  String get draft_save_title => '要储存草稿吗？';

  @override
  String get draft_save_content => '你的心血还没发布，要先存进秘密工作室吗？';

  @override
  String get not_save => '不储存';

  @override
  String get save_draft => '储存草稿';

  @override
  String confirm_delete_char_content(String name) {
    return '你确定要删除角色 \"$name\" 吗？\n\n此动作无法复原！';
  }

  @override
  String get char_deleted => '角色已删除';

  @override
  String get ok_button => '好的!';

  @override
  String get cannot_save_title => '无法储存';

  @override
  String get cannot_save_content => '请填写角色名称并至少上传一张头像！';

  @override
  String get word_count_exceeded => '字数过多';

  @override
  String word_count_error_detail(String field, int limit) {
    return '「$field」已超过 $limit 字，请删减后再储存。';
  }

  @override
  String get content_missing => '内容缺失';

  @override
  String get content_missing_personality => '请填写「详细个性」！请至少写 10 个字。';

  @override
  String get content_missing_bg => '「角色简介」太短了！请至少写 20 个字，交代一下背景。';

  @override
  String get content_missing_tone => '请设定「语气与习惯」，不然容易OOC！';

  @override
  String get user_not_found => '错误：找不到使用者';

  @override
  String char_saved_success(String name, String action) {
    return '角色 \"$name\" 已$action！';
  }

  @override
  String save_error_detail(String error) {
    return '储存失败：$error';
  }

  @override
  String get easter_egg_add_title => '新增隐藏彩蛋';

  @override
  String get easter_egg_edit_title => '编辑彩蛋';

  @override
  String get keyword_label => '触发关键字 (必填)';

  @override
  String get keyword_hint => '例如：去游乐园、草莓蛋糕';

  @override
  String get egg_title_label => '彩蛋标题 (给玩家看)';

  @override
  String get egg_title_hint => '例如：周末的约会';

  @override
  String get egg_teaser_label => '简短预告 (给玩家看)';

  @override
  String get egg_teaser_hint => '描述即将发生的事情开头...';

  @override
  String get egg_scene_label => '强制场景切换 (选填)';

  @override
  String get egg_scene_hint => '例如：游乐园、鬼屋';

  @override
  String get egg_prompt_label => '剧本指令';

  @override
  String get egg_prompt_hint => '如何演出这段剧情。\n(System:场景切换到游乐园，角色看着(玩家名字)笑了...)';

  @override
  String get confirm_button => '确认';

  @override
  String get keyword_empty_error => '关键字不能为空';

  @override
  String get voice_custom_title => '订制专属声线';

  @override
  String get voice_custom_hint => '例如：低沉霸总、温柔奶狗...';

  @override
  String get voice_generate_start => '开始生成';

  @override
  String get voice_bind_first => '请先选择并「绑定」一个专属声音喔！';

  @override
  String get voice_test_failed => '试听失败：请先点击「就决定是你了！」正式绑定声音后再微调喔！';

  @override
  String voice_name_default(String name) {
    return '$name 的专属声线';
  }

  @override
  String get voice_description_default => '这是「恋恋拾光」中为专属角色打造的独一无二声线，由玩家亲自挑选生成。';

  @override
  String get voice_bind_failed => '绑定声音失败，请检查 API 额度或网络状态';

  @override
  String voice_bind_success(String name) {
    return '\"$name\" 的灵魂声线已正式绑定！';
  }

  @override
  String get voice_bind_success_draft => '声线绑定成功！现在可以拉动滑杆测试情绪啰！';

  @override
  String sync_failed(String error) {
    return '同步失败，请检查网络：$error';
  }

  @override
  String edit_character_title(String name) {
    return '编辑 $name';
  }

  @override
  String get test_mode_tooltip => '完整功能测试 ';

  @override
  String get test_mode_error => '⚠️ 找不到角色档案！请先点击最下方的「储存/发布」后，再来试玩喔！';

  @override
  String get test_mode_notice => '💡 测试模式将依照各模式原价扣点，且不计入正式回忆喔！';

  @override
  String get delete_character_tooltip => '删除角色';

  @override
  String get tab_basic_story => '基本与剧情';

  @override
  String get tab_voice => '专属语音';

  @override
  String get tab_relationship => '社交关系';

  @override
  String get save_changes_button => '储存变更';

  @override
  String get section_basic_info => '基础资料';

  @override
  String get hint_occupation => '支援多重身分，请用斜线或逗号分隔 (例如：学生/骇客)';

  @override
  String get hint_appearance => '例如：银色长发，琥珀色眼睛，总是穿着白袍...';

  @override
  String get section_story_identity => '🎭 剧情与你的身分';

  @override
  String get story_identity_desc => '定义故事开场与「你」在这个存档里的特殊设定';

  @override
  String get advanced_writing_tips_title => '💡 进阶写作技巧：\n';

  @override
  String get advanced_writing_tips_1 => '在故事或台词中输入 ';

  @override
  String get advanced_writing_tips_2 => '(玩家名字)';

  @override
  String get advanced_writing_tips_3 => '，系统在游玩时会自动替换成玩家的真实昵称喔！\n';

  @override
  String get advanced_writing_tips_4 => '范例：「';

  @override
  String get advanced_writing_tips_5 => '(玩家名字)';

  @override
  String get advanced_writing_tips_6 => '，妳怎么这么晚才来？」';

  @override
  String get player_identity_label => '玩家预设身分 (Player Identity) - 💡 选填';

  @override
  String get player_identity_hint =>
      '【选填】若留空，AI 将会读取你的「个人档案」来互动。\n若填写，则强制扮演特定身分（例如：绑定他的冷酷系统、或被背叛的妻子）。';

  @override
  String get background_label => '角色背景与世界观 ';

  @override
  String get background_hint =>
      '描述他的过去、所处的世界观（如：现代都市、ABO、末世）。例如：这是一个丧尸横行的世界，他是保护你的特种兵...';

  @override
  String get story_summary_label => '一句话故事简介 ';

  @override
  String get story_initial_label => '初始相遇故事 ';

  @override
  String get story_initial_hint => '例如：妳推开门，看见他坐在窗边。他转过头说：「(玩家名字)，过来。」...';

  @override
  String get first_line_label => '角色的第一句话';

  @override
  String get first_line_hint => '例如：(玩家名字)，妳终于来了。';

  @override
  String get section_personality_evo => '🌟 个性与好感度演变';

  @override
  String get detailed_personality_label => '详细个性 ';

  @override
  String get detailed_personality_hint => '描述他的核心性格。例如：傲娇，嘴硬心软。对外人冷漠，只对玩家展露笑容。';

  @override
  String get affection_evo_desc => 'AI 将根据以下设定判断何时增加好感度：';

  @override
  String get stage_1_label => '阶段一：陌生/警戒 (Lv1)';

  @override
  String get stage_1_hint => '刚认识时的反应。触发好感条件(例如:礼貌、不探听隐私)。';

  @override
  String get stage_2_label => '阶段二：熟悉/朋友 (Lv2)';

  @override
  String get stage_2_hint => '熟了之后的变化。触发好感条件(例如:分享甜食、聊猫的话题)。';

  @override
  String get stage_3_label => '阶段三：亲密/恋人 (Lv3)';

  @override
  String get stage_3_hint => '完全沦陷后的反应。会吃醋?还是会生闷气?';

  @override
  String get social_interaction_label => '社交与环境互动';

  @override
  String get social_interaction_hint => '例如:如何对待路人？遇到讨厌的东西(雷点)会怎么炸毛？';

  @override
  String get section_habits => '🗣️ 喜好与习惯';

  @override
  String get tone_hint_detail => '必填。例如：说话简短，喜欢反问。口头禅是「笨蛋」。禁止使用翻译腔。';

  @override
  String get dialogue_example_hint => '玩家：我好累。\n角色：(摸头) 乖，快去休息。';

  @override
  String get section_easter_eggs => '🎁 隐藏彩蛋与特殊剧情';

  @override
  String get no_easter_eggs => '尚未设定彩蛋，点击下方按钮新增';

  @override
  String get no_scene_change => '不切换场景';

  @override
  String get add_easter_egg_button => '新增隐藏彩蛋';

  @override
  String get other_extra_info => '其他补充资讯';

  @override
  String get visibility_label => '角色可见度';

  @override
  String get visibility_public => '公开';

  @override
  String get visibility_private => '私人';

  @override
  String get section_voice_gen => '🎙️他专属声线生成';

  @override
  String get voice_gen_desc =>
      '输入提示词，让他有全世界独一无二的专属声音！\n（💡 贴心提醒：生成后若不满意，随时都能重新订制喔！）';

  @override
  String get voice_generating_status => '正在调配声线中...';

  @override
  String get voice_select_prompt => '✨ 帮你捏好了三种声线，请挑选：';

  @override
  String voice_sample_name(int index) {
    return '声线样本 $index';
  }

  @override
  String get voice_sample_desc => '点击卡片选择，点击右侧试听';

  @override
  String get voice_preparing => '声音还在准备中...';

  @override
  String get voice_retry => '放弃并重试';

  @override
  String get voice_confirm_selection => '就决定是你了！';

  @override
  String get voice_bind_success_banner => '已成功绑定专属声音！';

  @override
  String get voice_remake => '重制声線';

  @override
  String get voice_btn_generating => '正在生成中，请稍候...';

  @override
  String get voice_btn_generate => '输入提示词，生成专属声音';

  @override
  String get voice_advanced_tuning => '🎛️ 进阶：微调说话情绪 ';

  @override
  String get voice_stability_low => '野性/气音 🐺';

  @override
  String voice_stability_value(String value) {
    return '理智度: $value';
  }

  @override
  String get voice_stability_high => '平稳/冷静 🤖';

  @override
  String get voice_style_low => '冷淡/压抑 🧊';

  @override
  String voice_style_value(String value) {
    return '戏剧表现: $value';
  }

  @override
  String get voice_style_high => '浮夸/深情 🔥';

  @override
  String get voice_test_btn_testing => '正在套用情绪...';

  @override
  String get voice_test_btn => '试听目前情绪';

  @override
  String get section_social_circle => '👥 他的社交圈';

  @override
  String get social_circle_desc =>
      '设定他对其他角色的看法。当玩家在聊天中提到对方时，他就会根据这里的设定做出反应（例如：吃醋、生气）。';

  @override
  String get social_no_drama => '目前还没有与其他男神的过节...';

  @override
  String social_target(String name) {
    return '对象：$name';
  }

  @override
  String social_attitude(String attitude) {
    return '看法：$attitude';
  }

  @override
  String social_edit_title(String name) {
    return '编辑对 $name 的看法 💬';
  }

  @override
  String get social_attitude_label => '他的看法 / 态度';

  @override
  String get social_attitude_hint => '例如：觉得对方很啰嗦，但其实很依赖他...';

  @override
  String get social_save_changes => '储存修改';

  @override
  String get social_add_title => '新增角色关系 🤝';

  @override
  String get social_select_target => '选择对象';

  @override
  String get social_thoughts_label => '他对这个人的看法...';

  @override
  String get social_thoughts_hint => '例如：那钢琴家太吵了...';

  @override
  String get social_add_confirm => '确认新增';

  @override
  String get gallery_load_failed => '图片载入失败 🥲\n请确认网络正常，如果是 Web 请查看 console。';

  @override
  String gallery_affection_req(int level) {
    return '好感 $level';
  }

  @override
  String get gallery_upload_limit => '最多只能上传10张图片';

  @override
  String get gallery_photo_setup => '设定照片解锁条件';

  @override
  String get gallery_photo_desc_label => '这张照片是什么？';

  @override
  String get gallery_photo_desc_hint => '例如：睡衣照、约会照';

  @override
  String get gallery_photo_req_label => '需要多少好感度解锁？';

  @override
  String get gallery_photo_req_hint => '输入数字，0代表免费';

  @override
  String get gallery_cancel_upload => '取消上传';

  @override
  String get gallery_confirm_add => '确认新增';

  @override
  String get default_photo_desc => '专属照片';

  @override
  String get draft_photo_desc => '草稿照片';

  @override
  String get loading_text => '读取中...';

  @override
  String get default_unnamed_character => '未命名角色';

  @override
  String elevenlabs_error(String code) {
    return 'ElevenLabs 错误：$code';
  }

  @override
  String get voice_sample_script =>
      '（清了清嗓子）你好。这是一段专属于我的声音测试。在接下来的日子里，我会在这里陪着你。不管是开心的时候，还是难过的时候，你都可以跟我分享。这样说话的节奏和音色，你听起来还习惯吗？如果觉得不错的话，我们就把这个声音定下来，做为我以后和你聊天的专属声线吧。期待我们未来的每一天。';

  @override
  String get voice_test_script => '你觉得我现在说话的语气，听起来怎么样呢？如果满意的话，我们就这样定下来吧。';

  @override
  String get field_background => '角色简介';

  @override
  String get field_tone => '语气与习惯';

  @override
  String get field_initial_story => '初始故事';

  @override
  String get update_action => '更新';

  @override
  String get default_new_player => '新玩家';

  @override
  String get translating_status => '翻译中...';

  @override
  String get translate_profile_btn => '翻译档案内容';

  @override
  String translate_failed(String error) {
    return '翻译失败: $error';
  }

  @override
  String get like_own_char_warning => '不能给自创的角色点赞哦！🤭';

  @override
  String get like_success_msg => '已送出喜欢！创作者会很开心的💖';

  @override
  String get unlike_success_msg => '已收回喜欢 💔';

  @override
  String get like_label => '喜欢';

  @override
  String get dislike_label => '不喜欢';

  @override
  String get block_char => '封锁此角色';

  @override
  String get char_blocked_msg => '已封锁此角色。';

  @override
  String get dislike_dialog_title => '不太喜欢这个角色？';

  @override
  String get dislike_dialog_subtitle => '请偷偷告诉我们原因，官方会进行审核与把关：';

  @override
  String get dislike_hint => '设定太无聊、图片不适合...';

  @override
  String get dislike_thanks => '感谢您的反馈！官方已收到您的悄悄话。';

  @override
  String get dislike_submit => '悄悄送出';

  @override
  String get report_title => '📢 检举留言';

  @override
  String get report_subtitle => '请选择检举原因：\n检举后我们将尽快审核内容。';

  @override
  String get report_opt_1 => '色情或血腥暴力内容';

  @override
  String get report_opt_2 => '诋毁、侮辱或攻击角色';

  @override
  String get report_opt_3 => '仇恨言论或人身攻击';

  @override
  String get report_opt_4 => '垃圾讯息或广告诈骗';

  @override
  String get report_opt_5 => '其他不当内容';

  @override
  String get report_confirm => '确定检举';

  @override
  String get report_success => '检举成功，已收到通知！将尽快审核内容 🛡️';

  @override
  String get report_failed => '检举失败，请检查网络连接。';

  @override
  String get lore_delete_title => '⚠️ 警告：消除记忆';

  @override
  String get lore_delete_content => '这段记忆一旦删除就彻底消失啰，确定要狠心抹除它吗？';

  @override
  String get lore_delete_cancel => '手滑了';

  @override
  String get lore_delete_confirm => '确定抹除';

  @override
  String get lore_delete_success => '🗑️ 记忆碎片已彻底消除。';

  @override
  String get lore_add_title => '撰写新记忆 🖋️';

  @override
  String get lore_edit_title => '编辑记忆碎片 🖋️';

  @override
  String get lore_title_label => '记忆标题';

  @override
  String get lore_title_hint => '例如：第一次相遇的雨天';

  @override
  String get lore_teaser_label => '摘要 / 引言';

  @override
  String get lore_teaser_hint => '显示在卡片上的简短描述...';

  @override
  String get lore_content_label => '完整记忆内容';

  @override
  String get lore_content_hint => '写下这段详细的故事或设定...';

  @override
  String get lore_lock_label => '🔒 封印这段记忆';

  @override
  String get lore_lock_desc => '勾选后，只有创作者自己看得到，玩家无法观看';

  @override
  String get lore_empty_error => '标题和内容不能是空的喔！';

  @override
  String get lore_add_success => '✨ 新记忆已成功封存！';

  @override
  String get lore_publish => '发布记忆';

  @override
  String get lore_save_edit => '储存修改';

  @override
  String lore_write_first(Object pronoun) {
    return '快来为$pronoun写下第一段过往吧！';
  }

  @override
  String lore_waiting(Object pronoun) {
    return '期待与$pronoun的故事...';
  }

  @override
  String get lore_sealed_msg => '🔒 这段记忆已被封印，目前无法查看。';

  @override
  String get lore_not_open_msg => '这段记忆尚未对外开放喔...';

  @override
  String get lore_unnamed => '未命名碎片';

  @override
  String get lore_add_btn_limit => '撰写新的记忆碎片 (上限 10 则)';

  @override
  String get lore_collapse => '收起信件';

  @override
  String get echo_delete_title => '🗑️ 删除留言';

  @override
  String get echo_delete_content => '确定要删除这条时空回音吗？\n删除后就再也找不回来啰！';

  @override
  String get echo_keep => '保留';

  @override
  String get echo_clear_success => '时空回音已清除 🧹';

  @override
  String get echo_energy_full_title => '⚠️ 宇宙能量已达上限';

  @override
  String get echo_energy_full_content =>
      '妳的时空能量已达上限 (最多 3 条)，请先删除妳旧的时空经历，才能开启新的宇宙记录喔！';

  @override
  String get echo_write_title => '留下妳的时空回音 🌌';

  @override
  String get echo_write_subtitle => '写下妳在这里的经历或心动语录吧！';

  @override
  String get echo_hint => '「就算世界末日，我也回优先确保妳的呼吸...」';

  @override
  String get echo_theme_label => '选择便签贴边框：';

  @override
  String get theme_butterfly => '蝴蝶';

  @override
  String get theme_sprout => '小草';

  @override
  String get theme_star => '星空';

  @override
  String get theme_planet => '星球';

  @override
  String get echo_publish_btn => '发布时空记录';

  @override
  String get echo_wall_title => '时空回音墙';

  @override
  String get echo_leave_memory => '留下经历';

  @override
  String get echo_empty_msg => '还没有时空旅人留下记录...\n妳要成为第一个吗？';

  @override
  String get creator_label => '创作者';

  @override
  String get follow_btn => '关注';

  @override
  String get followed_btn => '已关注';

  @override
  String get follow_own_warning => '创作者不能关注自己哦！🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName 关注了 $creatorName！';
  }

  @override
  String get mailbox_follow_title => '获得新的守护者 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName 刚刚关注了妳！';
  }

  @override
  String get tab_private_profile => '私密档案';

  @override
  String get tab_memory_fragments => '记忆碎片';

  @override
  String get tab_time_echoes => '时空回音';

  @override
  String get chat_free_btn => '闲聊(免费)';

  @override
  String get start_story_btn => '开始剧情';

  @override
  String get default_chat_initial => '找我有事吗？';

  @override
  String get gallery_title => '专属通话背景';

  @override
  String gallery_current_affection(String value) {
    return '目前好感度: $value 💕';
  }

  @override
  String get gallery_empty => '相册里还没有照片喔';

  @override
  String gallery_unlocked_msg(String desc) {
    return '已将背景设为「$desc」！';
  }

  @override
  String gallery_lock_msg(String value) {
    return '好感度达到 $value 即可解锁喔！🍃';
  }

  @override
  String get gallery_reset_bg => '已恢复默认通话背景';

  @override
  String get background_story_title => '背景故事';

  @override
  String get background_story_empty => '这个角色很神秘，还没有背景故事...';

  @override
  String followed_creator_msg(String creatorName) {
    return '已关注 $creatorName 🦋';
  }

  @override
  String get mailbox_title => '专属信箱 💌';

  @override
  String get mailbox_empty => '信箱空空的，快去发布动态吸引他吧！';

  @override
  String get new_notification => '新通知';

  @override
  String get default_he => '他';

  @override
  String affection_upgrade_title(String charName) {
    return '$charName 对妳的好感度提升了！ 💖';
  }

  @override
  String get flower_reward => '🌸 获得 5 点花花';

  @override
  String get affection_quote_lv5 =>
      '「没想到...妳对我来说，已经变得这么重要了。重要到...我无法想象没有妳的世界。」';

  @override
  String get affection_quote_lv4 => '「这辈子最幸运的事，大概就是在那天，回头看见了妳。」';

  @override
  String get affection_quote_lv3 => '「最近...我发现自己发呆的时间变多了，而且脑袋里全都是妳。」';

  @override
  String get affection_quote_lv2 => '「既然是妳的邀约，那我稍微空出点时间，也不是不行。」';

  @override
  String get affection_quote_lv1 => '「最近常看到妳，感觉...并不讨厌这种见面的频率。」';

  @override
  String get affection_quote_lv0 => '「原来妳也在这里，這算是一种奇妙的缘分吗？」';

  @override
  String get lore_edit_success => '✨ 记忆碎片已成功更新！';

  @override
  String get delete_failed_network => '删除失败，请检查网络或权限。';

  @override
  String get ai_chat_language => '简体中文';

  @override
  String get ai_chat_language_code => 'zh-CN';

  @override
  String get chat_home_title => '消息';

  @override
  String get call_memory_tooltip => '通话回忆';

  @override
  String get login_to_view_chat => '请先登录以查看聊天记录';

  @override
  String load_chat_failed(String error) {
    return '读取聊天列表失败: $error';
  }

  @override
  String get chat_list_empty => '聊天室空空的...';

  @override
  String get go_to_encounter => '去“邂逅”找个人聊聊吧！';

  @override
  String confirm_delete_chat(String charName) {
    return '确定要删除与 $charName 的对话吗？';
  }

  @override
  String affection_score_short(String score) {
    return '好感 $score';
  }

  @override
  String get character_not_found => '无法读取角色资料，该角色可能已被删除。';

  @override
  String get preparing_chat_room => '正在为您准备专属聊天室...';

  @override
  String get rename_chat_title => '为这段记忆命名';

  @override
  String get rename_chat_hint => '例如：(程聿)改成(离婚倒数中)';

  @override
  String get save_tag_btn => '储存标签';

  @override
  String get room_name_updated => '房间名称已更新！';

  @override
  String update_failed(String error) {
    return '更新失败: $error';
  }

  @override
  String get chat_mode_daily => '日常';

  @override
  String get chat_mode_story => '剧情';

  @override
  String get chat_mode_immersive => '沉浸';

  @override
  String get chat_mode_gemini => '闲聊';

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
  String get chat_load_char_failed => '找不到角色资料，请返回重试或检查网络。';

  @override
  String get chat_jump_success => '已跳转至该段回忆 🍃';

  @override
  String get chat_create_room_failed => '连线似乎有点不稳，建立聊天室失败，请再试一次。';

  @override
  String get chat_secret_file_title => '🔒 机密档案';

  @override
  String get chat_secret_file_desc => '该角色的灵魂档案已被封存或转为私人权限，暂时无法查看详细资料。';

  @override
  String get chat_understood => '了解';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ 获得新回忆：$title';
  }

  @override
  String get chat_egg_saved => '已自动收录至专属背包';

  @override
  String get chat_points_not_enough_title => '花花不足';

  @override
  String get chat_points_not_enough_desc => '你的花朵不够了！请先前往商店补充。';

  @override
  String chat_call_confirm_title(String name) {
    return '要打给 $name 吗？';
  }

  @override
  String get chat_call_rule_1 => '每次通话都会扣除 20 点花花';

  @override
  String get chat_call_rule_2 => '通话时间为一分钟，若不方便说话可以透过文字传达';

  @override
  String get chat_call_rule_3 => '建议佩戴耳机，更能听清楚他的声音 ✨';

  @override
  String get chat_call_btn_cancel => '先不要';

  @override
  String get chat_call_pref_title => '设定您的通话偏好';

  @override
  String get chat_call_lang_select => '选择通话语言';

  @override
  String get chat_call_save_memory => '保存本次通话回忆';

  @override
  String get chat_call_save_memory_desc => '通话结束后可重复回听';

  @override
  String get chat_call_btn_start => '开始通话';

  @override
  String chat_points_shortage(String points) {
    return '花花点数不够喔！目前有 $points 点';
  }

  @override
  String get chat_room_not_ready => '聊天室尚未准备好，请重新进入。';

  @override
  String get chat_stop_generating_msg => '已停止回复，点数并没有扣除 🍃';

  @override
  String get chat_heartbeat_up => '他心跳加速了...';

  @override
  String get chat_heartbeat_down => '他眼神变冷了...';

  @override
  String get chat_msg_copy => '复制内容';

  @override
  String get chat_msg_copied => '已复制到剪贴板！';

  @override
  String get chat_msg_report => '举报该对话框';

  @override
  String get chat_msg_suggest => '给建议';

  @override
  String get chat_report_title => '举报此对话';

  @override
  String get chat_report_lang => '出现外文';

  @override
  String get chat_report_inapp => '回复不恰当';

  @override
  String get chat_report_context => '上下文没有连接';

  @override
  String get chat_report_other => '其他原因';

  @override
  String get chat_report_hint => '请描述您遇到的问题...';

  @override
  String get chat_report_submit => '送出';

  @override
  String get chat_report_success => '✅ 举报已送出，我们会尽快调整';

  @override
  String get chat_suggest_title => '给予建议';

  @override
  String get chat_suggest_hint => '请写下您的宝贵意见...';

  @override
  String get chat_suggest_success => '💖 感谢您的建议，我们会尽快处理';

  @override
  String get chat_del_warn => '讯息删除后将无法复原。';

  @override
  String get chat_reset_title => '重置记忆';

  @override
  String get chat_reset_desc =>
      '请选择重置的程度：\n\n1. 【仅对话】：清除对话纪录，但保留好感度。\n2. 【完全重置】：一切归零，像初次见面一样。';

  @override
  String get chat_reset_only_chat => '仅对话纪录';

  @override
  String get chat_reset_full => '完全重置';

  @override
  String get chat_reset_full_msg => '一切已回归最初，他不再记得妳了...';

  @override
  String get chat_reset_chat_msg => '对话已清空，但他对妳的爱意依然存在。';

  @override
  String get chat_edit_ai_hint => '编辑他的回复...';

  @override
  String get chat_edit_user_hint => '请输入新的内容...';

  @override
  String chat_no_voice_msg(String name) {
    return '目前还没有 $name 的声音...';
  }

  @override
  String get chat_poke_btn => '戳一下';

  @override
  String get chat_poke_success => '✨ 已帮妳戳戳创作者啰！请期待他的声音上线～';

  @override
  String chat_gift_points_needed(String cost) {
    return '花花点数不够喔！需要 $cost 点 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ 命定之人 ✨';

  @override
  String get chat_levelup_normal => '关系晋升！💖';

  @override
  String get chat_levelup_btn_soulmate => '刻入灵魂';

  @override
  String get chat_levelup_btn_normal => '心动收下';

  @override
  String get chat_loc_title => '📍 传送虚拟定位';

  @override
  String get chat_loc_custom_btn => '发送自订定位';

  @override
  String get chat_loc_hint => '输入其他地点... (例如：在你心里)';

  @override
  String get chat_loc_1 => '在你家楼下';

  @override
  String get chat_loc_2 => '在学校';

  @override
  String get chat_loc_3 => '在刚才路过的咖啡厅';

  @override
  String get chat_loc_4 => '在便利商店';

  @override
  String get chat_interact_title => '✨ 想对他做什么呢？';

  @override
  String get chat_interact_action => '戳一戳与小动作';

  @override
  String get chat_interact_gift => '送他小礼物 (消耗花花 🌸)';

  @override
  String get chat_action_poke => '戳戳脸颊';

  @override
  String get chat_action_hug => '讨抱抱';

  @override
  String get chat_action_hand => '偷偷牵手';

  @override
  String get chat_dice_btn => '掷骰子';

  @override
  String get chat_loading_failed => '读取回忆失败，请返回重试。';

  @override
  String get chat_test_mode_msg => '测试模式已开启，随便聊聊吧！(对话不会存档喔)';

  @override
  String get chat_empty_msg => '与他开始一段心动的旅程吧!';

  @override
  String get chat_ai_typing => '对方正在回复...';

  @override
  String get chat_input_hint_default => '想对他说什么...';

  @override
  String get chat_typing_indicator => '正在输入中...';

  @override
  String get chat_menu_search => '搜索对话';

  @override
  String get chat_menu_gallery => '专属回忆与背景';

  @override
  String get chat_menu_aboutme => '与我相关';

  @override
  String get chat_menu_memo => '给他的备忘录';

  @override
  String get chat_menu_period => '生理期追踪';

  @override
  String get chat_menu_reset => '重置记忆';

  @override
  String get chat_search_hint => '想回味哪一段甜蜜对话呢？';

  @override
  String get chat_search_empty => '找不到这段回忆喔 🥺';

  @override
  String get chat_search_you => '妳说的';

  @override
  String get chat_search_him => '他说的';

  @override
  String get chat_tool_backpack => '背包';

  @override
  String get chat_tool_story => '剧情摘要';

  @override
  String get chat_tool_photo => '照片';

  @override
  String get chat_tool_record => '录音';

  @override
  String get chat_tool_profile => '拾光档案';

  @override
  String get chat_tool_interact => '互动玩法';

  @override
  String get chat_record_recording => '录音中...';

  @override
  String get chat_record_start => '点击麦克风开始录音';

  @override
  String get chat_record_done => '录音完成';

  @override
  String get chat_mode_daily_desc => '轻松愉快的日常闲聊，就像朋友一样！';

  @override
  String get chat_mode_story_desc => '小说般的剧情推进。';

  @override
  String get chat_mode_immersive_desc => '极致的感官体验，无拘无束的深层互动。';

  @override
  String get chat_switch_mode_title => '切换聊天模式';

  @override
  String get chat_voice_call => '语音通话';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【系统事件】$playerName送出了一个【$giftName】。';
  }

  @override
  String get rel_title_soulmate => '灵魂伴侣/深爱';

  @override
  String get rel_title_lover => '热恋期/专属男友';

  @override
  String get rel_title_ambiguous => '暧昧期/互相试探';

  @override
  String get rel_title_friend => '普通朋友/好感萌芽';

  @override
  String get rel_title_acquaintance => '点头之交/稍微眼熟';

  @override
  String get rel_title_stranger => '陌生/初识';

  @override
  String get rel_title_tense => '关系紧张/心生厌烦';

  @override
  String get rel_title_avoiding => '形同陌路/刻意躲避';

  @override
  String get rel_title_hostile => '极度厌恶/冰冷敌意';

  @override
  String get rel_title_nemesis => '不共戴天/永不相见';

  @override
  String get rel_msg_soulmate => '「没想到...妳对我来说，已经变得这么重要了。重要到...我无法想象没有妳的世界。」';

  @override
  String get rel_msg_lover => '「这辈子最幸运的事，大概就是在那天，回头看见了妳。」';

  @override
  String get rel_msg_ambiguous => '「最近...我发现自己发呆的时间变多了，而且脑袋里全都是妳。」';

  @override
  String get rel_msg_friend => '「既然是妳的邀约，那我稍微空出点时间，也不是不行。」';

  @override
  String get rel_msg_acquaintance => '「最近常看到妳，感觉...并不讨厌这种见面的频率。」';

  @override
  String get rel_msg_stranger => '「原来妳也在这里，這算是一种奇妙的缘分吗？」';

  @override
  String chat_edit_char_count(String count) {
    return '$count 字';
  }

  @override
  String get chat_mysterious_player => '神秘玩家';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return '玩家 $playerName 期待着听见 $characterName 的声音，快去生成吧！';
  }

  @override
  String get gift_heart => '爱心';

  @override
  String get gift_flower => '花花';

  @override
  String get gift_sun => '太阳';

  @override
  String get gift_confetti => '拉炮';

  @override
  String get gift_coffee => '咖啡';

  @override
  String get gift_cake => '蛋糕';

  @override
  String get chat_action_poke_prompt => '（玩家突然伸出手，调皮地戳了戳你的脸颊）';

  @override
  String get chat_action_hug_prompt => '（玩家委屈巴巴地张开双手，想要一个温暖的抱抱）';

  @override
  String get chat_action_hand_prompt => '（玩家在桌子底下，悄悄握住了你的手）';

  @override
  String get chat_menu_send_location => '发送虚拟定位';

  @override
  String get weekday_mon => '(一)';

  @override
  String get weekday_tue => '(二)';

  @override
  String get weekday_wed => '(三)';

  @override
  String get weekday_thu => '(四)';

  @override
  String get weekday_fri => '(五)';

  @override
  String get weekday_sat => '(六)';

  @override
  String get weekday_sun => '(日)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ 获得新回忆：$memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack => '已自动收录至他的专属背包';

  @override
  String get chat_profile_updated_msg => '拾光档案已更新！他会记住妳的最新设定喔 🍃';

  @override
  String get comment_loading_author => '读取中...';

  @override
  String comment_post_failed(String error) {
    return '留言失败，请检查网络连接：$error';
  }

  @override
  String get comment_delete_confirm_desc => '您确定要永久删除这则留言吗？';

  @override
  String get comment_delete_failed => '删除失败，请检查网络连接';

  @override
  String get comment_identity_title => '选择留言身份';

  @override
  String get comment_identity_myself => '我本人';

  @override
  String get comment_report_title => '确认检举';

  @override
  String get comment_report_rules_title => '⚖️ 留言检举规范';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ 初犯：系统警告并记录一次违规。\n2️⃣ 二犯：禁止留言 1 天。\n3️⃣ 累犯：禁用检舉功能 14 天，并降低留言能见度。\n\n🚨 严重恶意者：\n禁止与角色互动 1 天，ID 将公告于公布栏 3 天（期间禁止更改 ID）。\n\n💡 检举送出后，最终审核结果将通过【游戏内信箱】单独发送给您。\n请互相尊重，理性检举。';

  @override
  String get comment_report_understood => '我已了解';

  @override
  String get comment_report_confirm_desc => '您确定要检举这则留言吗？\n恶意检举可能会受到惩罚。';

  @override
  String get comment_report_submit_btn => '确定检举';

  @override
  String get comment_report_success => '感谢您的检举，我们会尽快核实！';

  @override
  String get comment_report_failed => '检举送出失败，请稍后再试。';

  @override
  String get comment_option_delete => '删除留言';

  @override
  String get comment_option_report => '检举留言';

  @override
  String comment_time_days_ago(String days) {
    return '$days天前';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '$hours小时前';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '$mins分钟前';
  }

  @override
  String get comment_time_just_now => '刚刚';

  @override
  String get comment_sheet_title => '留言';

  @override
  String get comment_empty_state => '还没有人留言，快来抢头香！';

  @override
  String get comment_reply_btn => '回复';

  @override
  String comment_replying_to(String name) {
    return '正在回复 @$name';
  }

  @override
  String comment_input_hint(String name) {
    return '以 $name 的身份留言...';
  }

  @override
  String char_story_expect(String pronoun) {
    return '期待与$pronoun的故事...';
  }

  @override
  String get common_update_failed => '更新失败，请检查网络';

  @override
  String get char_edit_fragment => '编辑碎片';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 讨厌：$dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 喜欢：$likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age岁 | $job';
  }

  @override
  String get common_got_it => '我知道了';

  @override
  String get common_add_failed => '添加失败，请检查网络';

  @override
  String common_delete_failed_with_err(String error) {
    return '删除失败，请检查网络状态：$error';
  }

  @override
  String get char_exclusive_guardian => '专属守护 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName 喜欢了 $charName！';
  }

  @override
  String chat_translation_prefix(String content) {
    return '【译】$content (这是翻译后的感性内容)';
  }

  @override
  String get player_default_nickname => '旅人';

  @override
  String get moment_create_title => '发布新动态';

  @override
  String get moment_create_post_btn => '发布';

  @override
  String get moment_create_hint => '分享新鲜事...';

  @override
  String get moment_create_error_empty => '文字和图片至少需要一项喔！';

  @override
  String get moment_create_error_failed => '发布失败，请稍后再试';

  @override
  String get moment_create_visibility_public => '公开 (所有人可见)';

  @override
  String get moment_create_visibility_private => '私密 (仅好友可见)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (玩家发送了定位：$location)';
  }

  @override
  String get chat_you => '妳';

  @override
  String get chat_opponent => '对手';

  @override
  String chat_dice_duel_result(String name) {
    return '【系统事件】与$name掷骰子对决！结果出来了...';
  }

  @override
  String get chat_loading_status => '正在读取中...';

  @override
  String chat_error_load_msg(String error) {
    return '读取消息失败: $error';
  }

  @override
  String get chat_voice_msg_label => '语音消息';

  @override
  String chat_special_story_trigger(String title) {
    return '【开启特殊剧情：$title】';
  }

  @override
  String common_edit_failed(String error) {
    return '编辑失败: $error';
  }

  @override
  String common_reset_failed(String error) {
    return '重置失败: $error';
  }

  @override
  String get chat_default_greeting => '你好...';

  @override
  String get chat_memory_cleared => '记忆已彻底清空';

  @override
  String get chat_history_reset => '对话已重置';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 【 专属拾光档案 - $name 】\n━━━━━━━━━━━━━━━━━━\n🔹 姓名：$identity\n🔹 生日：$birthday\n🔹 身高：$height\n🔹 外貌：$appearance\n🔹 职业：$job\n\n📖 【 关于她的灵魂碎片 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 【 专属拾光档案 】\n━━━━━━━━━━━━━━━━━━\n🔹 姓名：$nickname\n🔹 生日：$birthday\n\n🔒 其他人设资料尚未解锁...\n(填写完整档案，让他在平行时空更了解妳吧！✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => '未命名档案';

  @override
  String get chat_default_player_name => '玩家';

  @override
  String get error_system_confusion => '系统出现小混乱，请再试一次。';

  @override
  String get error_msg_send_failed => '消息发送失败，请再试一次。';

  @override
  String get error_system_busy => '系统繁忙，请稍后再试。';

  @override
  String get error_network_unavailable => '目前暂时无法连线，请重试。';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 通话结束，与 $name 通话了 $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return '专属剧情：$title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return '这是一段专属于妳和 $name 的隐藏回忆...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return '一段关于「$keyword」的专属回忆已悄悄解锁...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '【隐藏事件触发：$title】\n$scene';
  }

  @override
  String get chat_first_line_fallback => '……（他静静地看着妳，似乎在等妳先开口）';

  @override
  String get chat_new_room_created => '新的聊天室已建立';

  @override
  String portfolio_title(String nickname) {
    return '$nickname的作品集';
  }

  @override
  String get enter_secret_studio => '进入我的秘密工作室';

  @override
  String get no_public_character_mine => '你还没有发布任何公开角色喔！\n快去工作室创作吧✨';

  @override
  String get no_public_character_other => '这位创作者还没有发布角色喔...';

  @override
  String get delete_draft_title => '删除草稿';

  @override
  String get confirm_delete_draft_msg => '确定要删除这个未完成的角色吗？\n(删除后无法复原喔)';

  @override
  String get draft_cleared_success => '草稿已清理完毕 🧹';

  @override
  String get login_required_for_studio => '请先登录才能进入工作室喔！';

  @override
  String get my_secret_studio_title => '我的秘密工作室 🛠️';

  @override
  String get create_new_character_btn => '创造新角色';

  @override
  String get unnamed_draft => '未命名草稿';

  @override
  String get click_to_edit_story => '点击继续编辑他的故事...';

  @override
  String get label_draft => '草稿';

  @override
  String get studio_empty_title => '工作室目前空空如也';

  @override
  String get studio_empty_subtitle => '点击右下角，开始创造妳的第一个角色吧！';

  @override
  String get common_no_changes => '没有任何变更';

  @override
  String get moment_updated_success => '动态已更新！';

  @override
  String common_save_failed(String error) {
    return '保存失败: $error';
  }

  @override
  String get moment_edit_title => '编辑动态';

  @override
  String get action_change_image => '更换图片';

  @override
  String get action_remove_image => '移除图片';

  @override
  String get moment_delete_confirm_title => '确定要删除这则动态吗？';

  @override
  String get moment_delete_confirm_content => '删除后，这段朋友圈的回忆就会消失喔！';

  @override
  String get action_confirm_delete => '确定删除';

  @override
  String get friend_unknown => '某位朋友';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname觉得妳的动态很赞喔！💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname觉得$authorName很有魅力，点了个赞！✨';
  }

  @override
  String get moment_like_success => '已传递妳的心动！✨';

  @override
  String get moment_notification_new_like => '新点赞！💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname 在动态中提到了 @$name 喔！✨';
  }

  @override
  String get moment_detail_title => '动态详情';

  @override
  String get moment_not_found => '这篇动态好像不见了... 😢';

  @override
  String get moment_comment_title => '朋友圈留言';

  @override
  String get moment_comment_empty => '还没有人留言，快来抢沙发！🛋';

  @override
  String moment_replying_to(String name) {
    return '正在回复 @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return '回复 @$name...';
  }

  @override
  String get moment_leave_comment_hint => '留下妳的回应...';

  @override
  String get moment_delete_permanent_confirm => '这则动态将被永久删除，确定吗？';

  @override
  String get moment_action_delete => '删除动态';

  @override
  String get moment_action_report => '举报此动态';

  @override
  String get moment_action_share => '分享这则动态';

  @override
  String get moment_forward_hint => '转发这篇动态给角色...';

  @override
  String moment_reply_private(String name) {
    return '私信回复 $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return '带着动态去找 $name 聊天囉！ 💬';
  }

  @override
  String get moment_share_to_apps => '分享到其他应用程序';

  @override
  String moment_likes_label(String count) {
    return '$count 片叶子';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】快来看 $author 的动态：$content\n\n立即下载，开启妳的专属时光：$appLink';
  }

  @override
  String get moment_forward_title => '转发给正在聊天的角色 💌';

  @override
  String get moment_forward_empty_state => '你目前还没有开始聊天的角色喔！\n先去大厅找找心仪的他吧 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【转发了一则动态】\n作者：$author\n内容：$content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ 已悄悄分享给 $name 啰！';
  }

  @override
  String get action_send => '发送';

  @override
  String get memo_delete_confirm => '您确定要删除这則备忘录吗？此操作无法复原。';

  @override
  String get memo_add_title => '新增备忘录';

  @override
  String get memo_edit_title => '编辑备忘录';

  @override
  String memo_hint_text(String name) {
    return '想记下关于 $name 的什么呢？';
  }

  @override
  String get memo_label_reminder_date => '提醒日期:';

  @override
  String get memo_action_save => '储存备忘';

  @override
  String get memo_error_empty_content => '内容不能空白喔！';

  @override
  String memo_list_title(String name) {
    return '与 $name 的备忘录';
  }

  @override
  String get memo_empty_state => '还没有任何备忘录喔！\n点击右上角新增一个吧！';

  @override
  String memo_reminder_date_display(String date) {
    return '提醒日：$date';
  }

  @override
  String get daily_gift_title => '时光每日赠礼';

  @override
  String daily_login_welcome(String appName, String amount) {
    return '欢迎回到《$appName》！\n今日签到可领取 $amount 点花语点数。🌸';
  }

  @override
  String get title_daily_check_in => '每日签到';

  @override
  String success_claim_reward(String amount) {
    return '成功领取 $amount 点花语！🌸';
  }

  @override
  String get error_claim_failed => '领取失败，请检查网络后重试。';

  @override
  String get action_claim_now => '立即领取';

  @override
  String get common_or => '或';

  @override
  String get title_language_settings => '语言设置';

  @override
  String get app_name => '恋恋拾光';

  @override
  String get login_slogan => '开启妳的专属时光';

  @override
  String get login_with_google => '使用 Google 登录';

  @override
  String get login_with_apple => '通过 Apple 登录';

  @override
  String get login_with_facebook => '使用 Facebook 登录';

  @override
  String get login_with_email => '使用恋恋账号登录 (Email)';

  @override
  String get title_contact_us_heading => '我们非常重视您的建议！';

  @override
  String get desc_contact_us_body => '请在这里写下您的想法，帮助我们把游戏变得更好。';

  @override
  String get error_feedback_empty => '建议内容不能为空喔！';

  @override
  String get email_subject_feedback => '恋恋拾光 - 玩家反馈建议';

  @override
  String get msg_email_app_not_found_copied => '无法自动开启邮件，已为您复制官方邮箱！';

  @override
  String get title_contact_us => '联络我们';

  @override
  String get desc_contact_us => '我们非常重视您的建议！\n请在这里写下您的想法，帮助我们把游戏变得更好。';

  @override
  String get hint_enter_feedback => '请在此输入您的建议...';

  @override
  String get action_send_via_email => '通过 Email 传送';

  @override
  String get error_email_password_empty => '邮箱和密码不能为空喔！';

  @override
  String get auth_error_default => '发生错误，请稍后再试。';

  @override
  String get auth_error_user_not_found => '找不到此邮箱，请先注册喔！';

  @override
  String get auth_error_wrong_password => '密码错误，请再试一次！';

  @override
  String get auth_error_email_in_use => '这个邮箱已经被注册过啰！请直接登录。';

  @override
  String get auth_error_weak_password => '密码太弱了，请至少输入 6 个字符！';

  @override
  String get auth_error_invalid_email => '邮箱格式不正确！';

  @override
  String get title_welcome_back => '欢迎回来';

  @override
  String get title_register_account => '注册专属账号';

  @override
  String get label_email => '电子邮件';

  @override
  String get label_password => '密码';

  @override
  String get action_login => '登录';

  @override
  String get action_register => '注册';

  @override
  String get prompt_no_account => '还没有账号？点我注册';

  @override
  String get prompt_has_account => '已经有账号了？点我登录';

  @override
  String get error_nickname_empty => '昵称不能为空！';

  @override
  String get profile_saved_success => '个人档案保存！';

  @override
  String get error_id_empty => 'ID不能为空！';

  @override
  String get error_id_too_long => 'ID长度不能超过10个字符！';

  @override
  String get error_id_already_used => '此ID已被使用，请换一个！';

  @override
  String profile_save_failed(String error) {
    return '保存失败: $error';
  }

  @override
  String get draft_saved_success_msg => '好的！先帮你保存在草稿里，随时可以回来编辑喔！✨';

  @override
  String get dialog_reminder_title => '提醒';

  @override
  String get warning_id_not_edited => '专属ID尚未编辑，您确定要现在保存吗？';

  @override
  String get action_continue_editing => '继续编辑';

  @override
  String get action_edit_later => '之后再编辑';

  @override
  String get action_edit_later_short => '稍后再编辑';

  @override
  String get action_cancel_changes => '取消更改';

  @override
  String get error_birthdate_locked => '出生日期已设定，不可更改！';

  @override
  String get action_select_avatar => '选择头像';

  @override
  String get action_choose_from_gallery => '从相册选择';

  @override
  String get title_adjust_avatar => '调整您的时光头像';

  @override
  String get avatar_updated_success => '已为您换上头像 🍃';

  @override
  String get title_create_profile => '建立你的档案';

  @override
  String get title_edit_profile => '编辑个人档案';

  @override
  String get label_your_nickname => '您的昵称';

  @override
  String get label_player_exclusive_id => '玩家专属 ID';

  @override
  String get msg_id_locked => 'ID 已锁定，无法再次更改。';

  @override
  String get msg_id_change_chance => '您有一次免费更改 ID 的机会。';

  @override
  String get action_select_birthdate => '请选择出生日期';

  @override
  String label_birthdate(String date) {
    return '出生日期: $date';
  }

  @override
  String get msg_birthdate_immutable => '生日设定后不可更改 ✨';

  @override
  String get action_start_journey => '开启时光旅程';

  @override
  String get action_add_image => '新增图片';

  @override
  String moment_like_self(String nickname) {
    return '$nickname觉得妳的动态很赞喔！💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname觉得$authorName很有魅力，点了个赞！✨';
  }

  @override
  String get task_social_tour_complete => '✨ 达成社群巡礼任务！记得领取花花喔！🌸';

  @override
  String get wall_title_shiguang => '拾光墙';

  @override
  String get wall_tab_explore => '🌍 探索';

  @override
  String get wall_tab_exclusive => '🔒 专属';

  @override
  String get more_options => '更多选项';

  @override
  String get delete_warning => '删除后，贴文将无法找回';

  @override
  String get delete_success => '删除成功';

  @override
  String get notification_new_comment => '新留言！💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName 对妳的动态点了个赞！';
  }

  @override
  String get empty_public_moments_prompt => '目前空空如也，\n快去发布第一篇公开动态吧！🌍';

  @override
  String get empty_private_moments_prompt => '朋友圈还没有留下的瞬间，\n快去与他创造回忆吧！✨';

  @override
  String get profile_archived_or_deleted_message =>
      '这份灵魂档案已被创作者封存、设为私人，或是已经消散在时空的洪流中...\n\n或许在某个平行宇宙，你们还有再次相遇的机会。✨';

  @override
  String get leave_silently => '默默离开';

  @override
  String get character_post_schedule => '角色发文排程';

  @override
  String get creator_self => '创作者本人';

  @override
  String get post_identity_prompt => '今天要用谁的身分发文？';

  @override
  String get identity_creator => '✨ 创作者身分';

  @override
  String get identity_character => '角色身分';

  @override
  String get decide_post_time_prompt => '帮他们决定发文时间吧！';

  @override
  String get auto_post_schedule_hint =>
      '开启后，将会在指定時間自动发布日常动态\n(💡 建议设定非整点，看起来更像真人喔！)';

  @override
  String get no_characters_created_yet => '妳还没有创建任何角色喔！';

  @override
  String time_hour(String hour) {
    return '$hour 点';
  }

  @override
  String time_minute(String minute) {
    return '$minute 分';
  }

  @override
  String get empty_public_moments_short => '目前还没有公开动态 🌍';

  @override
  String get empty_private_moments_short => '朋友圈还静悄悄的 ✨';

  @override
  String get my_created_characters => '我创建的角色';

  @override
  String get no_characters_yet => '尚未创建角色';

  @override
  String play_count_display(int count) {
    return '游玩次数: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return '$characterName 的关心日历';
  }

  @override
  String get care_calendar_greeting => '今天的心情如何？';

  @override
  String get care_calendar_save_btn => '保存记录，让他照顾妳';

  @override
  String get care_calendar_delete_confirm => '要删除这笔记录吗？';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName：「我都记下来了，这几天辛苦妳了，我会一直在妳身边的。」';
  }

  @override
  String get daily_gift_success => '成功领取每日赠礼！🌸';

  @override
  String get check_in_fail_network => '签到失败，请检查网络连线 🍃';

  @override
  String task_completed(String taskName) {
    return '完成任务：$taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return '成功领取「$taskName」的 $rewardAmount 点花花！';
  }

  @override
  String claim_failed_error(String e) {
    return '领取失败: $e';
  }

  @override
  String get tab_heartbeat_diary => '心动日记';

  @override
  String get tab_daily_chit_chat => '闲话家常';

  @override
  String get task_desc_chat_3_times => '与角色进行 3 次日常聊天';

  @override
  String get tab_story_progression => '剧情推进';

  @override
  String get task_desc_story_1_time => '完成 1 次剧情模式互动';

  @override
  String get tab_social_tour => '社群巡礼';

  @override
  String get task_desc_like_3_moments => '为 3 则朋友圈动态按赞';

  @override
  String get btn_claimed => '已领取';

  @override
  String get btn_claim => '领取';

  @override
  String get btn_incomplete => '未完成';

  @override
  String get network_unstable_retry => '网络连线不稳，请稍后再试🍃';

  @override
  String get title_time_travel => '时光旅行';

  @override
  String get select_chat_mode => '选择聊天模式';

  @override
  String get mode_chat => '聊天';

  @override
  String get mode_daily_desc => '轻松闲聊，维持羁绊';

  @override
  String get mode_story_desc => '深入故事，体验沉浸感';

  @override
  String get greeting_hello => '你好！';

  @override
  String get greeting_default_daily => '找我有事吗？';

  @override
  String get title_personal_homepage => '个人主页';

  @override
  String get title_time_letters => '时光信件';

  @override
  String get status_signed_in_today => '今日已签到';

  @override
  String get status_signing_in => '签到中...';

  @override
  String get status_daily_sign_in => '每日签到 (+10 花花)';

  @override
  String get toast_id_copied => 'ID 已复制！';

  @override
  String get hint_click_avatar_to_edit => '点击头像进行个人档案编辑';

  @override
  String get title_my_friends => '我的好友';

  @override
  String get action_show_all => '显示全部';

  @override
  String get empty_no_characters_created => '您尚未创建任何角色。';

  @override
  String get common_close => '关闭';

  @override
  String get search_companion_title => '搜寻拾光伴侣';

  @override
  String get search_name_placeholder => '输入他的名字...';

  @override
  String get search_no_match_hint => '找不到角色，试试其他名字？ ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age岁 | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age岁';
  }

  @override
  String get empty_state_warmth => '这里还留存着时空的余温...';

  @override
  String get error_login_required_add_friend => '请先登录才能添加好友！';

  @override
  String get dialog_title_remove_friend => '确认移除好友';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return '您确定要将 $characterName 从好友列表中移除吗？';
  }

  @override
  String get action_remove => '移除';

  @override
  String snackbar_friend_removed(String characterName) {
    return '已将 $characterName 移除好友';
  }

  @override
  String get action_remove_friend => '移除好友';

  @override
  String get dialog_title_block => '确认封锁';

  @override
  String dialog_msg_block(String characterName) {
    return '封锁后，您将不会再看到 $characterName 的任何信息。确定要封锁吗？';
  }

  @override
  String snackbar_blocked(String characterName) {
    return '已封锁 $characterName';
  }

  @override
  String get action_block_character => '封锁此角色';

  @override
  String dialog_title_report(String characterName) {
    return '举报 $characterName';
  }

  @override
  String get input_hint_report_reason => '请输入举报原因...';

  @override
  String get action_submit => '提交';

  @override
  String get snackbar_report_success => '感谢您的回报，我们将会尽快审核。';

  @override
  String get snackbar_report_fail => '提交失败，请稍后再试';

  @override
  String get action_report_character => '举报此角色';

  @override
  String get title_meet_him => '遇见心仪的他';

  @override
  String text_character_count(int count) {
    return '角色数量: $count';
  }

  @override
  String get msg_no_more_encounters_today => '今天的邂逅就到这里啰！';

  @override
  String get msg_check_new_encounters => '再来看看有没有新的相遇吧！';

  @override
  String get action_refresh => '刷新';

  @override
  String get tab_friends => '好友';

  @override
  String get msg_mysterious_profile => '这个人很神秘，什么都没留下...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age岁 | $identities';
  }

  @override
  String get snackbar_operation_failed => '操作失败，请稍后再试';

  @override
  String get action_view_translation => '查看翻译';

  @override
  String get label_translation_result => '翻译结果:';

  @override
  String get errorWebPageUnavailable => '暂时无法打开网页，请稍后再试';

  @override
  String get resetAppearanceTitle => '要重置外观吗？';

  @override
  String get resetAppearanceWarning => '这将会移除您精心挑选的背景图与颜色喔！';

  @override
  String get appearanceRestored => '已恢复默认外观';

  @override
  String get confirmReset => '确定重置';

  @override
  String get resetToDefaultAppearance => '恢复默认外观';

  @override
  String get clearCustomSettings => '清除所有自定义颜色与背景图';

  @override
  String get contactUs => '联系我们';

  @override
  String get contactDescription => '有任何心里话或 Bug 都能告诉我们';

  @override
  String get vibrationHapticTitle => '心动震动感应';

  @override
  String get vibrationHapticDescription => '好感度大幅变动时触发手机震动';

  @override
  String get splash_loading_universe => '正在唤醒《恋恋拾光》的宇宙...';

  @override
  String get shop_title => '花花小铺';

  @override
  String get shop_current_points_label => '目前持有的花花点数';

  @override
  String get shop_tab_top_up => '点数充值';

  @override
  String get shop_tab_history => '收支明细';

  @override
  String get shop_empty_history => '目前还没有花花纪录喔！🌸';

  @override
  String get shop_unknown_item => '未知项目';

  @override
  String get shop_first_purchase_bonus => '首购双倍！';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get settingsTitle => '設定';

  @override
  String get changeTheme => '更換主題顏色';

  @override
  String get feedback => '反饋建議';

  @override
  String get changeLanguage => '更換語言';

  @override
  String get allFriendsTitle => '所有好友';

  @override
  String get noFriendsMessage => '您還沒有任何好友。';

  @override
  String get unknownCharacter => '未知角色';

  @override
  String errorLoadingFriends(String error) {
    return '載入好友列表時發生錯誤: $error';
  }

  @override
  String get tagGentle => '溫柔';

  @override
  String get tagCheerful => '開朗';

  @override
  String get tagLively => '活潑';

  @override
  String get tagMischievous => '調皮';

  @override
  String get tagRichYoungLady => '千金';

  @override
  String get tagRichYoungMaster => '少爺';

  @override
  String get tagWealthyFamily => '豪門';

  @override
  String get tagScheming => '勾心鬥角';

  @override
  String get tagPossessive => '佔有';

  @override
  String get tagParanoid => '偏執';

  @override
  String get tagPersistent => '執著';

  @override
  String get tagUncle => '大叔';

  @override
  String get tagAuntie => '阿姨';

  @override
  String get tagSeniorSister => '學姊';

  @override
  String get tagJuniorBrother => '學弟';

  @override
  String get tagHandsome => '帥';

  @override
  String get tagStunning => '美艷動人';

  @override
  String get tagContrast => '反差';

  @override
  String get tagFlirty => '開車';

  @override
  String get tagAgeGap => '年齡差';

  @override
  String get userNotFoundError => '找不到使用者';

  @override
  String get imageDataMismatchError => '圖片資料不一致，請重新選擇圖片。';

  @override
  String get createCharacterTitle => '創建角色';

  @override
  String get charAlbumTitle => '角色相冊 (第一張為主要頭像)';

  @override
  String get charNameLabel => '角色名稱:*';

  @override
  String get charDescSection => '角色描述:';

  @override
  String get charAgeLabel => '年齡:';

  @override
  String get charJobLabel => '職業:*';

  @override
  String get charBirthdayLabel => '生日:(MMDD)';

  @override
  String get charGenderLabel => '性別 *';

  @override
  String get genderNotSelected => '未選擇';

  @override
  String get genderMale => '男';

  @override
  String get genderFemale => '女';

  @override
  String get genderOther => '其他';

  @override
  String get charHeightLabel => '身高:(cm)';

  @override
  String get charAppearanceLabel => '外貌形容:';

  @override
  String get charPersonalityTagsSection => '個性標籤';

  @override
  String get charOtherPersonalityTagsHint => '其他個性標籤...';

  @override
  String get otherSectionTitle => '其他';

  @override
  String get charLikesLabel => '喜歡的東西:(例如：草莓蛋糕、貓咪、雨天)';

  @override
  String get charDislikesLabel => '討厭的東西:(例如：苦瓜、吵鬧的地方)';

  @override
  String get charSecretsLabel => '不為人知的小秘密: (例如：其實是個路癡)';

  @override
  String get charMannerismsSection => '言行舉止';

  @override
  String get charToneLabel => '說話語氣與風格: (例如：對陌生人冷淡)';

  @override
  String get charDialogueExampleLabel => '對話範例: (玩家：你真好！ 角色：...喔。)';

  @override
  String get charBackgroundSection => '角色背景:';

  @override
  String get charBackgroundHint => '輸入角色的背景故事 (最多 2500 字)';

  @override
  String get charStoryStartSection => '劇情開頭:';

  @override
  String get charStoryStartHint => '輸入角色的劇情 (最多 2500 字)';

  @override
  String get charStorySummaryLabel => '故事簡介 (最多 50 字，會顯示在邂逅卡片上)';

  @override
  String get charExtraInfoSection => '角色其他補充:';

  @override
  String get charExtraInfoHint => '輸入補充內容...';

  @override
  String get charPublicToggleLabel => '公開讓其他玩家遊玩嗎？';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get createButton => '創建';

  @override
  String get saveButton => '儲存';

  @override
  String get cancelButton => '取消';

  @override
  String get exitCreationTitle => '您將退出創角畫面';

  @override
  String get saveDraftPrompt => '需要儲存為草稿嗎？';

  @override
  String get draftNeeded => '需要';

  @override
  String get draftNotNeeded => '不需要';

  @override
  String get editExtraInfoTitle => '編輯補充內容';

  @override
  String get nameAndAvatarError => '請填寫角色名稱並至少上傳一張頭像！';

  @override
  String get savingStatus => '儲存中...';

  @override
  String get uploadingImagesStatus => '正在上傳圖片...';

  @override
  String get maxImagesError => '最多只能上傳 10 張圖片。';

  @override
  String get uploadingImagesStatusShort => '正在處理圖片...';

  @override
  String get savingCharacterData => '正在儲存角色資料...';

  @override
  String characterCreatedSuccess(String charName) {
    return '角色 \"$charName\" 已創建！';
  }

  @override
  String get uploadImageTimeoutError => '創建角色失敗：圖片上傳超時，請檢查您的網路連線。';

  @override
  String createCharacterGenericError(String error) {
    return '創建角色失敗：$error';
  }

  @override
  String get settingsSectionAppearance => '外觀與內容';

  @override
  String get settingsSectionAccount => '帳號與內容管理';

  @override
  String get settingsSectionAbout => '關於我們';

  @override
  String get accountManagement => '帳號管理';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => '未知';

  @override
  String get userIdCopied => '使用者 ID 已複製到剪貼簿';

  @override
  String get characterManagement => '角色管理';

  @override
  String get viewBlockedCharacters => '查看已封鎖的角色';

  @override
  String get privacyPolicy => '隱私條款';

  @override
  String get termsOfService => '服務條款';

  @override
  String get logoutButton => '登出帳號';

  @override
  String get logoutDialogTitle => '你要登出了嗎?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => '我按錯了';

  @override
  String get logoutDialogActionConfirm => '確認';

  @override
  String get logoutSuccessSnackbar => '好的!那我等你回來♥(´∀` )';

  @override
  String get deleteAccountButton => '刪除帳號';

  @override
  String get deleteAccountDialogTitle => '你確定要刪掉這個帳號?இдஇ';

  @override
  String get deleteAccountDialogContent => '這個操作無法復原，所有資料都會被永久刪除！';

  @override
  String get deleteAccountDialogActionCancel => '沒有,我沒有要刪掉';

  @override
  String get deleteAccountDialogActionConfirm => '確定';

  @override
  String get deleteAccountSuccessSnackbar => '帳號已成功刪除。';

  @override
  String get appDisclaimer => '遊戲裡面的角色與場景皆為虛構,請勿帶入現實!如有雷同,純屬巧合';

  @override
  String appVersion(String version) {
    return 'App 版本: $version';
  }

  @override
  String get dialogTitleHint => '提示';

  @override
  String get completeProfilePrompt => '請先編輯您的個人檔案以完善資料喔！';

  @override
  String get goToEdit => '前往編輯';

  @override
  String get later => '稍後';

  @override
  String chattingWith(String friendName) {
    return '與 $friendName 聊天';
  }

  @override
  String chatContentWith(String friendName) {
    return '與 $friendName 的聊天內容';
  }

  @override
  String get chatInputHint => '輸入訊息...';

  @override
  String get characterNotFoundError => '找不到角色資料';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return '讀取角色詳情失敗: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => '初始關係';

  @override
  String get relationship_childhood_friend => '青梅竹馬';

  @override
  String get relationship_senior_junior => '學長學妹';

  @override
  String get relationship_bickering_couple => '歡喜冤家';

  @override
  String get relationship_colleagues => '職場同事';

  @override
  String get relationship_other => '其他 (請手動輸入)';

  @override
  String get chatModeDaily => '日常模式';

  @override
  String get chatModeStory => '劇情模式';

  @override
  String get chatModeImmersive => '沉浸模式';

  @override
  String get chatModeGemini => '生活陪伴';

  @override
  String get announcement_new => '新公告';

  @override
  String get mail_notification => '有新的時光信件寄達囉，快去羊皮卷看看吧！';

  @override
  String get customer_service_reply => '客服回覆';

  @override
  String get system_announcement => '系統公告';

  @override
  String get empty_announcement => '目前沒有任何公告喔';

  @override
  String get untitled => '無標題';

  @override
  String get no_content => '無內容';

  @override
  String get privacy_policy_title => '《戀戀拾光》隱私權政策';

  @override
  String get privacy_policy_date => '最近更新日期：2026年4月10日';

  @override
  String get privacy_policy_body =>
      '歡迎使用《戀戀拾光》（以下簡稱「本服務」）。我們非常重視您的隱私，本政策旨在說明我們如何收集、使用及保護您的個人資訊。\n\n1. 帳戶資訊：\n第三方登入：當您透過 Google、Facebook 或 Apple 帳號登入時，我們會收集您的 Firebase UID、電子郵件及公開暱稱。\nE-mail 註冊：當您選擇以電子郵件註冊時，我們會收集您的電子郵件帳號。您的登入密碼將透過 Firebase 加密技術進行管理與儲存，開發團隊無法查閱您的原始密碼。 我們承諾將採取業界標準的安全措施保障您的個資安全。\n\n互動資料：為了讓 AI 角色具備連續的記憶，我們會收集並儲存您與AI的對話紀錄與您在遊戲裡面為角色所寫下的內容。\n\n設備資訊：包含設備型號、作業系統版本及唯一設備識別碼，用於系統優化。\n\n2. 資訊的使用方式\n提升AI體驗：利用對話紀錄優化AI的回覆品質與個性連貫性。\n服務營運：用於處理點數充值、消費紀錄及使用者身分驗證。\n安全防護：監測惡意行為，保護伺服器不受攻擊。\n\n3. 第三方技術合作\n本服務採用以下國際主流技術提供支持：\nGoogle Cloud / Firebase：資料存儲與身份驗證。\nOpenRouter / xAI / Meta：提供 AI 模型運算邏輯。\n備註：我們不會向任何廣告商出售您的原始對話紀錄。\n\n4. 資料儲存與刪除\n您的資料將安全地儲存在雲端服務器中。\n您可以隨時聯繫我們要求永久刪除您的帳戶及所有相關對話數據。';

  @override
  String get terms_title => '《戀戀拾光》服務使用條款';

  @override
  String get terms_date => '最近更新日期：2026年4月10日';

  @override
  String get terms_body =>
      '在使用《戀戀拾光》（以下簡稱「本服務」）前，請仔細閱讀以下條款。開始使用本服務即代表您同意以下內容：\n\n1. 服務本質與免責聲明\n非真人互動：本服務所有角色回覆均由人工智慧（Generative AI）生成。角色言論不代表創作者立場。\n敘事風險：AI可能生成虛構、不準確或令人不適的內容。使用者應具備區分虛構與現實的能力。\n\n2. 虛擬點數與付費模式\n點數性質：本服務內之點數為虛擬商品，一經消耗（如:進入故事、沉浸模式、送出禮物、語音通話）即無法退還。\n成本差異：不同模式（如:日常、故事、沉浸、通話）之點數消耗標準係根據 AI 運算成本設定，本服務保留調整成本之權利。\n\n3. 使用者行為規範\n禁止事項：禁止利用AI生成極端暴力、犯罪引導或違反法律之內容。\n系統干擾：嚴禁透過任何自動化工具、逆向工程手段非法獲取本服務之數據。\n\n4. 智慧財產權與內容所有權\n原創內容：本服務中之角色姓名（如：程安等官方所創建的）、背景設定、劇情劇本、對話文本、遊戲邏輯及專屬品牌名稱，其智慧財產權均屬「戀戀拾光開發團隊」所有。\n第三方授權資源：本服務介面中所使用之圖示（Icons）、字體及表情符號（Emojis），其版權歸原授權方所有（如 Google Material Design、Apple Inc. 等），本服務係依據其開源或授權協議合法使用。\nAI 生成內容：本服務中部分美術圖像係由開發團隊利用 AI 生成工具（如 Niji.journey）產生，開發團隊保證已獲得該工具之商業使用授權。相關圖像之使用權與經營權歸本團隊所有。\n禁止行為：未經本團隊正式授權，嚴禁將上述任何內容用於商業營利、二次散布或進行惡意訓練模型。\n\n5. 服務終止\n若玩家違反上述規定，本服務有權在不預先通知的情況下暫停或永久停用該帳戶。';

  @override
  String get login_required => '請先登入系統';

  @override
  String get cloud_character_mgmt => '雲端角色管理';

  @override
  String get connection_error => '連線出錯';

  @override
  String get no_characters_met => '目前還沒有認識任何角色喔！';

  @override
  String get status_paused => '狀態：已暫停聯繫';

  @override
  String get status_in_progress => '狀態：攻略中';

  @override
  String get unblock => '解除封鎖';

  @override
  String get block => '封鎖';

  @override
  String get confirm_block_title => '確定要封鎖嗎？';

  @override
  String block_warning_msg(String charName) {
    return '封鎖後，將暫時無法收到 $charName 的訊息喔。';
  }

  @override
  String get think_again => '再想想';

  @override
  String get confirm_block_btn => '確定封鎖';

  @override
  String get no_char_info => '目前還沒有這份角色的詳細情報...';

  @override
  String get private_mailbox => '專屬信箱';

  @override
  String get user_info_not_found => '找不到使用者資訊';

  @override
  String get load_failed => '載入失敗，請稍後再試';

  @override
  String get empty_mailbox => '目前信箱空空的喔～';

  @override
  String get system_notification => '系統通知';

  @override
  String get interaction_records => '互動紀錄';

  @override
  String get liked_content => '按讚過的內容';

  @override
  String get my_favorites => '我的收藏';

  @override
  String get login_to_view_records => '請先登入以查看紀錄';

  @override
  String get no_likes_yet => '妳還沒有按讚過任何動態喔！';

  @override
  String get empty_favorites => '專屬收藏夾空空的，快去大廳逛逛吧！';

  @override
  String get theme_sakura_pink => '櫻花粉';

  @override
  String get theme_ocean_blue => '湛藍海';

  @override
  String get theme_sunset_orange => '夕陽橙';

  @override
  String get theme_mint_forest => '薄荷森';

  @override
  String get theme_midnight => '深夜模式';

  @override
  String get change_atmosphere => '更換氛圍';

  @override
  String get custom_color => '自定義色彩';

  @override
  String get custom_color_desc => '調配妳的專屬氛圍色';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確定';

  @override
  String get confirm_delete_title => '確認刪除';

  @override
  String get confirm_delete_memory_msg => '您確定要讓他忘記這件事嗎？此操作無法復原喔。';

  @override
  String get delete_btn => '刪除';

  @override
  String get memory_erased_msg => '這段記憶已經被抹除了';

  @override
  String get delete_failed_msg => '刪除失敗';

  @override
  String get edit_memory_title => '編輯回憶';

  @override
  String get modify_memory_hint => '修改這段記憶...';

  @override
  String get memory_re_recorded_msg => '記憶已重新記錄';

  @override
  String get update_failed_msg => '更新失敗';

  @override
  String get update_favorite_failed_msg => '更新收藏狀態失敗';

  @override
  String char_notebook_title(String charName) {
    return '$charName的記事本';
  }

  @override
  String get error_loading_memory => '讀取記憶時發生錯誤';

  @override
  String get empty_notebook_msg => '筆記本裡空空的...\n趕快去聊天，讓他記下關於妳的點點滴滴吧！';

  @override
  String get date_format_text => 'yyyy年M月d日';

  @override
  String get remove_special_focus => '取消特別關注';

  @override
  String get mark_special_focus => '標記為特別關注';

  @override
  String get edit_btn => '編輯';

  @override
  String get load_gallery_failed => '讀取圖鑑失敗';

  @override
  String get traditional_chinese => '繁體中文';

  @override
  String get all => '全部';

  @override
  String get official_recommendation => '官方推薦';

  @override
  String get my_exclusive => '我的專屬';

  @override
  String encounter_count(int count) {
    return '$count 次邂逅';
  }

  @override
  String get official => '官方';

  @override
  String get private => '私人';

  @override
  String get first_encounter => '初次相遇';

  @override
  String char_exclusive_memory(String charName) {
    return '$charName的專屬回憶';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return '好感度需達到 $affectionLevel 才能解鎖這張回憶喔！';
  }

  @override
  String get affection => '好感度';

  @override
  String get unlock => '解鎖';

  @override
  String get change_chat_bg => '更換聊天背景';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return '要將「$cgDesc」設為與 $charName 的聊天背景嗎？';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return '已將背景更換為「$cgDesc」';
  }

  @override
  String get confirm_change => '確定更換';

  @override
  String get empty_treasure_box => '百寶箱裡空空的...\n快去聊天尋找隱藏的專屬彩蛋吧！';

  @override
  String get unknown_story => '未知劇情';

  @override
  String get open_this_memory => '開啟這段回憶';

  @override
  String get open_exclusive_story => '開啟專屬劇情';

  @override
  String confirm_use_egg(String eggTitle) {
    return '確定要現在體驗「$eggTitle」嗎？\n\n(此道具為一次性消耗，使用後將自動進入劇情)';
  }

  @override
  String get wait_a_bit => '再等等';

  @override
  String guiding_into_story(String eggTitle) {
    return '正在引導進入「$eggTitle」...';
  }

  @override
  String get use_now => '立即使用';

  @override
  String playback_failed_status(String statusCode) {
    return '播放失敗，狀態碼：$statusCode';
  }

  @override
  String get playback_error => '播放發生錯誤';

  @override
  String get unknown_contact => '未知聯絡人';

  @override
  String call_memory_with(String charName) {
    return '與 $charName 的通話回憶';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return '好感度$affection解鎖';
  }

  @override
  String get no_call_record => '這通電話似乎沒有留下對話紀錄...';

  @override
  String get me => '我';

  @override
  String get playing => '播放中...';

  @override
  String get listen => '聆聽';

  @override
  String get no_exclusive_voice => '這隻角色還沒有設定專屬聲音喔！';

  @override
  String get voice_download_success => '✅ 語音數據下載成功，準備直接播放...';

  @override
  String get onboarding_invitation => '— 拾光邀請函 —';

  @override
  String get onboarding_welcome => '歡迎來到戀戀拾光';

  @override
  String get onboarding_quote => '「所有的相遇，都是久別重逢。」';

  @override
  String get onboarding_gift_title => '獲得初見禮：50 朵花語';

  @override
  String get onboarding_gift_subtitle => '這些花朵將陪伴您開啟與他的故事';

  @override
  String get onboarding_start_button => '開啟您的時光旅程';

  @override
  String get onboarding_more_info => '了解更多關於拾光的故事';

  @override
  String get legal_agreement_prefix => '繼續即表示您同意本遊戲的';

  @override
  String get legal_terms_button => '服務條款';

  @override
  String get legal_and => ' 與 ';

  @override
  String get legal_privacy_button => '隱私權政策';

  @override
  String get call_memory_title => '通話回憶錄';

  @override
  String get please_login_first => '請先登入喔';

  @override
  String get no_call_memories => '目前還沒有保存的通話回憶\n最多只能保存10則收藏哦';

  @override
  String call_with_name(String name) {
    return '與 $name 的通話';
  }

  @override
  String call_duration(String time) {
    return '時長：$time';
  }

  @override
  String get delete_call_title => '銷毀通話紀錄';

  @override
  String delete_call_confirm(String name) {
    return '確定要秘密銷毀這段與 $name 的通話回憶嗎？\n(刪除後無法找回喔)';
  }

  @override
  String get keep_it => '先留著';

  @override
  String get confirm_delete => '確定銷毀';

  @override
  String get press_mic_to_speak => '請按下麥克風開始說話...';

  @override
  String get call_ended => '通話已結束';

  @override
  String character_thinking(String name) {
    return '（$name 正在思考...）';
  }

  @override
  String character_picking_up(String name) {
    return '（$name 正在接起電話...）';
  }

  @override
  String get call_interrupted_login => '（通話中斷）請先登入喔...';

  @override
  String get silence => '（沈默）';

  @override
  String get bad_signal => '（訊號不好...）';

  @override
  String get static_noise => '（沙沙聲）...聽不清楚...';

  @override
  String get type_message_hint => '輸入文字...';

  @override
  String get draft_saved_success => '草稿已安全儲存至秘密工作室！';

  @override
  String get draft_save_failed => '儲存失敗，請稍後再試';

  @override
  String get draft_save_title => '要儲存草稿嗎？';

  @override
  String get draft_save_content => '妳的心血還沒發布，要先存進秘密工作室嗎？';

  @override
  String get not_save => '不儲存';

  @override
  String get save_draft => '儲存草稿';

  @override
  String confirm_delete_char_content(String name) {
    return '你確定要刪除角色 \"$name\" 嗎？\n\n此動作無法復原！';
  }

  @override
  String get char_deleted => '角色已刪除';

  @override
  String get ok_button => '好的!';

  @override
  String get cannot_save_title => '無法儲存';

  @override
  String get cannot_save_content => '請填寫角色名稱並至少上傳一張頭像！';

  @override
  String get word_count_exceeded => '字數過多';

  @override
  String word_count_error_detail(String field, int limit) {
    return '「$field」已超過 $limit 字，請刪減後再儲存。';
  }

  @override
  String get content_missing => '內容缺失';

  @override
  String get content_missing_personality => '請填寫「詳細個性」！請至少寫 10 個字。';

  @override
  String get content_missing_bg => '「角色簡介」太短了！請至少寫 20 個字，交代一下背景。';

  @override
  String get content_missing_tone => '請設定「語氣與習慣」，不然容易OOC！';

  @override
  String get user_not_found => '錯誤：找不到使用者';

  @override
  String char_saved_success(String name, String action) {
    return '角色 \"$name\" 已$action！';
  }

  @override
  String save_error_detail(String error) {
    return '儲存失敗：$error';
  }

  @override
  String get easter_egg_add_title => '新增隱藏彩蛋';

  @override
  String get easter_egg_edit_title => '編輯彩蛋';

  @override
  String get keyword_label => '觸發關鍵字 (必填)';

  @override
  String get keyword_hint => '例如：去遊樂園、草莓蛋糕';

  @override
  String get egg_title_label => '彩蛋標題 (給玩家看)';

  @override
  String get egg_title_hint => '例如：週末的約會';

  @override
  String get egg_teaser_label => '簡短預告 (給玩家看)';

  @override
  String get egg_teaser_hint => '描述即將發生的事情開頭...';

  @override
  String get egg_scene_label => '強制場景切換 (選填)';

  @override
  String get egg_scene_hint => '例如：遊樂園、鬼屋';

  @override
  String get egg_prompt_label => '劇本指令';

  @override
  String get egg_prompt_hint => '如何演出這段劇情。\n(System:場景切換到遊樂園，角色看著(玩家名字)笑了...)';

  @override
  String get confirm_button => '確認';

  @override
  String get keyword_empty_error => '關鍵字不能為空';

  @override
  String get voice_custom_title => '訂製專屬聲線';

  @override
  String get voice_custom_hint => '例如：低沉霸總、溫柔奶狗...';

  @override
  String get voice_generate_start => '開始生成';

  @override
  String get voice_bind_first => '請先選擇並「綁定」一個專屬聲音喔！';

  @override
  String get voice_test_failed => '試聽失敗：請先點擊「就決定是你了！」正式綁定聲音後再微調喔！';

  @override
  String voice_name_default(String name) {
    return '$name 的專屬聲線';
  }

  @override
  String get voice_description_default => '這是「戀戀拾光」中為專屬角色打造的獨一無二聲線，由玩家親自挑選生成。';

  @override
  String get voice_bind_failed => '綁定聲音失敗，請檢查 API 額度或網路狀態';

  @override
  String voice_bind_success(String name) {
    return '\"$name\" 的靈魂聲線已正式綁定！';
  }

  @override
  String get voice_bind_success_draft => '聲線綁定成功！現在可以拉動滑桿測試情緒囉！';

  @override
  String sync_failed(String error) {
    return '同步失敗，請檢查網路：$error';
  }

  @override
  String edit_character_title(String name) {
    return '編輯 $name';
  }

  @override
  String get test_mode_tooltip => '完整功能測試 ';

  @override
  String get test_mode_error => '⚠️ 找不到角色檔案！請先點擊最下方的「儲存/發布」後，再來試玩喔！';

  @override
  String get test_mode_notice => '💡 測試模式將依照各模式原價扣點，且不計入正式回憶喔！';

  @override
  String get delete_character_tooltip => '刪除角色';

  @override
  String get tab_basic_story => '基本與劇情';

  @override
  String get tab_voice => '專屬語音';

  @override
  String get tab_relationship => '社交關係';

  @override
  String get save_changes_button => '儲存變更';

  @override
  String get section_basic_info => '基礎資料';

  @override
  String get hint_occupation => '支援多重身分，請用斜線或逗號分隔 (例如：學生/駭客)';

  @override
  String get hint_appearance => '例如：銀色長髮，琥珀色眼睛，總是穿著白袍...';

  @override
  String get section_story_identity => '🎭 劇情與你的身分';

  @override
  String get story_identity_desc => '定義故事開場與「你」在這個存檔裡的特殊設定';

  @override
  String get advanced_writing_tips_title => '💡 進階寫作技巧：\n';

  @override
  String get advanced_writing_tips_1 => '在故事或台詞中輸入 ';

  @override
  String get advanced_writing_tips_2 => '(玩家名字)';

  @override
  String get advanced_writing_tips_3 => '，系統在遊玩時會自動替換成玩家的真實暱稱喔！\n';

  @override
  String get advanced_writing_tips_4 => '範例：「';

  @override
  String get advanced_writing_tips_5 => '(玩家名字)';

  @override
  String get advanced_writing_tips_6 => '，妳怎麼這麼晚才來？」';

  @override
  String get player_identity_label => '玩家預設身分 (Player Identity) - 💡 選填';

  @override
  String get player_identity_hint =>
      '【選填】若留空，AI 將會讀取你的「個人檔案」來互動。\n若填寫，則強制扮演特定身分（例如：綁定他的冷酷系統、或被背叛的妻子）。';

  @override
  String get background_label => '角色背景與世界觀 ';

  @override
  String get background_hint =>
      '描述他的過去、所處的世界觀（如：現代都市、ABO、末世）。例如：這是一個喪屍橫行的世界，他是保護你的特種兵...';

  @override
  String get story_summary_label => '一句話故事簡介 ';

  @override
  String get story_initial_label => '初始相遇故事 ';

  @override
  String get story_initial_hint => '例如：妳推開門，看見他坐在窗邊。他轉過頭說：「(玩家名字)，過來。」...';

  @override
  String get first_line_label => '角色的第一句話';

  @override
  String get first_line_hint => '例如：(玩家名字)，妳終於來了。';

  @override
  String get section_personality_evo => '🌟 個性與好感度演變';

  @override
  String get detailed_personality_label => '詳細個性 ';

  @override
  String get detailed_personality_hint => '描述他的核心性格。例如：傲嬌，嘴硬心軟。對外人冷漠，只對玩家展露笑容。';

  @override
  String get affection_evo_desc => 'AI 將根據以下設定判斷何時增加好感度：';

  @override
  String get stage_1_label => '階段一：陌生/警戒 (Lv1)';

  @override
  String get stage_1_hint => '剛認識時的反應。觸發好感條件(例如:禮貌、不探聽隱私)。';

  @override
  String get stage_2_label => '階段二：熟悉/朋友 (Lv2)';

  @override
  String get stage_2_hint => '熟了之後的變化。觸發好感條件(例如:分享甜食、聊貓的話題)。';

  @override
  String get stage_3_label => '階段三：親密/戀人 (Lv3)';

  @override
  String get stage_3_hint => '完全淪陷後的反應。會吃醋?還是會生悶氣?';

  @override
  String get social_interaction_label => '社交與環境互動';

  @override
  String get social_interaction_hint => '例如:如何對待路人？遇到討厭的東西(雷點)會怎麼炸毛？';

  @override
  String get section_habits => '🗣️ 喜好與習慣';

  @override
  String get tone_hint_detail => '必填。例如：說話簡短，喜歡反問。口頭禪是「笨蛋」。禁止使用翻譯腔。';

  @override
  String get dialogue_example_hint => '玩家：我好累。\n角色：(摸頭) 乖，快去休息。';

  @override
  String get section_easter_eggs => '🎁 隱藏彩蛋與特殊劇情';

  @override
  String get no_easter_eggs => '尚未設定彩蛋，點擊下方按鈕新增';

  @override
  String get no_scene_change => '不切換場景';

  @override
  String get add_easter_egg_button => '新增隱藏彩蛋';

  @override
  String get other_extra_info => '其他補充資訊';

  @override
  String get visibility_label => '角色可見度';

  @override
  String get visibility_public => '公開';

  @override
  String get visibility_private => '私人';

  @override
  String get section_voice_gen => '🎙️他專屬聲線生成';

  @override
  String get voice_gen_desc =>
      '輸入提示詞，讓他有全世界獨一無二的專屬聲音！\n（💡 貼心提醒：生成後若不滿意，隨時都能重新訂製喔！）';

  @override
  String get voice_generating_status => '正在調配聲線中...';

  @override
  String get voice_select_prompt => '✨ 幫你捏好了三種聲線，請挑選：';

  @override
  String voice_sample_name(int index) {
    return '聲線樣本 $index';
  }

  @override
  String get voice_sample_desc => '點擊卡片選擇，點擊右側試聽';

  @override
  String get voice_preparing => '聲音還在準備中...';

  @override
  String get voice_retry => '放棄並重試';

  @override
  String get voice_confirm_selection => '就決定是你了！';

  @override
  String get voice_bind_success_banner => '已成功綁定專屬聲音！';

  @override
  String get voice_remake => '重製聲線';

  @override
  String get voice_btn_generating => '正在生成中，請稍候...';

  @override
  String get voice_btn_generate => '輸入提示詞，生成專屬聲音';

  @override
  String get voice_advanced_tuning => '🎛️ 進階：微調說話情緒 ';

  @override
  String get voice_stability_low => '野性/氣音 🐺';

  @override
  String voice_stability_value(String value) {
    return '理智度: $value';
  }

  @override
  String get voice_stability_high => '平穩/冷靜 🤖';

  @override
  String get voice_style_low => '冷淡/壓抑 🧊';

  @override
  String voice_style_value(String value) {
    return '戲劇表現: $value';
  }

  @override
  String get voice_style_high => '浮誇/深情 🔥';

  @override
  String get voice_test_btn_testing => '正在套用情緒...';

  @override
  String get voice_test_btn => '試聽目前情緒';

  @override
  String get section_social_circle => '👥 他的社交圈';

  @override
  String get social_circle_desc =>
      '設定他對其他角色的看法。當玩家在聊天中提到對方時，他就會根據這裡的設定做出反應（例如：吃醋、生氣）。';

  @override
  String get social_no_drama => '目前還沒有與其他男神的過節...';

  @override
  String social_target(String name) {
    return '對象：$name';
  }

  @override
  String social_attitude(String attitude) {
    return '看法：$attitude';
  }

  @override
  String social_edit_title(String name) {
    return '編輯對 $name 的看法 💬';
  }

  @override
  String get social_attitude_label => '他的看法 / 態度';

  @override
  String get social_attitude_hint => '例如：覺得對方很囉嗦，但其實很依賴他...';

  @override
  String get social_save_changes => '儲存修改';

  @override
  String get social_add_title => '新增角色關係 🤝';

  @override
  String get social_select_target => '選擇對象';

  @override
  String get social_thoughts_label => '他對這個人的看法...';

  @override
  String get social_thoughts_hint => '例如：那鋼琴家太吵了...';

  @override
  String get social_add_confirm => '確認新增';

  @override
  String get gallery_load_failed => '圖片載入失敗 🥲\n請確認網路正常，如果是 Web 請查看 console。';

  @override
  String gallery_affection_req(int level) {
    return '好感 $level';
  }

  @override
  String get gallery_upload_limit => '最多只能上傳10張圖片';

  @override
  String get gallery_photo_setup => '設定照片解鎖條件';

  @override
  String get gallery_photo_desc_label => '這張照片是什麼？';

  @override
  String get gallery_photo_desc_hint => '例如：睡衣照、約會照';

  @override
  String get gallery_photo_req_label => '需要多少好感度解鎖？';

  @override
  String get gallery_photo_req_hint => '輸入數字，0代表免費';

  @override
  String get gallery_cancel_upload => '取消上傳';

  @override
  String get gallery_confirm_add => '確認新增';

  @override
  String get default_photo_desc => '專屬照片';

  @override
  String get draft_photo_desc => '草稿照片';

  @override
  String get loading_text => '讀取中...';

  @override
  String get default_unnamed_character => '未命名角色';

  @override
  String elevenlabs_error(String code) {
    return 'ElevenLabs 錯誤：$code';
  }

  @override
  String get voice_sample_script =>
      '（清了清嗓子）你好。這是一段專屬於我的聲音測試。在接下來的日子裡，我會在這裡陪著你。不管是開心的時候，還是難過的時候，你都可以跟我分享。這樣說話的節奏和音色，你聽起來還習慣嗎？如果覺得不錯的話，我們就把這個聲音定下來，做為我以後和你聊天的專屬聲線吧。期待我們未來的每一天。';

  @override
  String get voice_test_script => '你覺得我現在說話的語氣，聽起來怎麼樣呢？如果滿意的話，我們就這樣定下來吧。';

  @override
  String get field_background => '角色簡介';

  @override
  String get field_tone => '語氣與習慣';

  @override
  String get field_initial_story => '初始故事';

  @override
  String get update_action => '更新';

  @override
  String get default_new_player => '新玩家';

  @override
  String get translating_status => '翻譯中...';

  @override
  String get translate_profile_btn => '翻譯檔案內容';

  @override
  String translate_failed(String error) {
    return '翻譯失敗: $error';
  }

  @override
  String get like_own_char_warning => '不能按自己創造的角色讚喔！🤭';

  @override
  String get like_success_msg => '已送出喜歡！創作者會很開心的💖';

  @override
  String get unlike_success_msg => '已收回喜歡 💔';

  @override
  String get like_label => '喜歡';

  @override
  String get dislike_label => '不喜歡';

  @override
  String get block_char => '封鎖此角色';

  @override
  String get char_blocked_msg => '已封鎖此角色。';

  @override
  String get dislike_dialog_title => '不太喜歡這個角色？';

  @override
  String get dislike_dialog_subtitle => '請偷偷告訴我們原因，官方會進行審核與把關：';

  @override
  String get dislike_hint => '設定太無聊、圖片不適合...';

  @override
  String get dislike_thanks => '感謝您的回饋！官方已收到您的悄悄話。';

  @override
  String get dislike_submit => '悄悄送出';

  @override
  String get report_title => '📢 檢舉留言';

  @override
  String get report_subtitle => '請選擇檢舉原因：\n檢舉後我們將會盡快審核內容。';

  @override
  String get report_opt_1 => '色情或血腥暴力內容';

  @override
  String get report_opt_2 => '詆毀、侮辱或攻擊角色';

  @override
  String get report_opt_3 => '仇恨言論或人身攻擊';

  @override
  String get report_opt_4 => '垃圾訊息或廣告詐騙';

  @override
  String get report_opt_5 => '其他不當內容';

  @override
  String get report_confirm => '確定檢舉';

  @override
  String get report_success => '檢舉成功，已收到通知！將會盡快審核內容 🛡️';

  @override
  String get report_failed => '檢舉失敗，請檢查網路連線。';

  @override
  String get lore_delete_title => '⚠️ 警告：消除記憶';

  @override
  String get lore_delete_content => '這段記憶一旦刪除就徹底消失囉，確定要狠心抹除它嗎？';

  @override
  String get lore_delete_cancel => '手滑了';

  @override
  String get lore_delete_confirm => '確定抹除';

  @override
  String get lore_delete_success => '🗑️ 記憶碎片已徹底消除。';

  @override
  String get lore_add_title => '撰寫新記憶 🖋️';

  @override
  String get lore_edit_title => '編輯記憶碎片 🖋️';

  @override
  String get lore_title_label => '記憶標題';

  @override
  String get lore_title_hint => '例如：第一次相遇的雨天';

  @override
  String get lore_teaser_label => '摘要 / 引言';

  @override
  String get lore_teaser_hint => '顯示在卡片上的簡短描述...';

  @override
  String get lore_content_label => '完整記憶內容';

  @override
  String get lore_content_hint => '寫下這段詳細的故事或設定...';

  @override
  String get lore_lock_label => '🔒 封印這段記憶';

  @override
  String get lore_lock_desc => '打勾後，只有創作者自己看得到，玩家無法觀看';

  @override
  String get lore_empty_error => '標題和內容不能是空的喔！';

  @override
  String get lore_add_success => '✨ 新記憶已成功封存！';

  @override
  String get lore_publish => '發布記憶';

  @override
  String get lore_save_edit => '儲存修改';

  @override
  String lore_write_first(Object pronoun) {
    return '快來為$pronoun寫下第一段過往吧！';
  }

  @override
  String lore_waiting(Object pronoun) {
    return '期待與$pronoun的故事...';
  }

  @override
  String get lore_sealed_msg => '🔒 這段記憶已被封印，目前無法查看。';

  @override
  String get lore_not_open_msg => '這段記憶尚未對外開放喔...';

  @override
  String get lore_unnamed => '未命名碎片';

  @override
  String get lore_add_btn_limit => '撰寫新的記憶碎片 (上限 10 則)';

  @override
  String get lore_collapse => '收起信件';

  @override
  String get echo_delete_title => '🗑️ 刪除留言';

  @override
  String get echo_delete_content => '確定要刪除這則時空迴音嗎？\n刪除後就再也找不回來囉！';

  @override
  String get echo_keep => '保留';

  @override
  String get echo_clear_success => '時空迴音已清除 🧹';

  @override
  String get echo_energy_full_title => '⚠️ 宇宙能量已達上限';

  @override
  String get echo_energy_full_content =>
      '妳的時空能量已達上限 (最多 3 則)，請先刪除妳舊的時空經歷，才能開啟新的宇宙紀錄喔！';

  @override
  String get echo_write_title => '留下妳的時空迴音 🌌';

  @override
  String get echo_write_subtitle => '寫下妳在這裡的經歷或心動語錄吧！';

  @override
  String get echo_hint => '「就算世界末日，我也會優先確保妳的呼吸...」';

  @override
  String get echo_theme_label => '選擇便條貼邊框：';

  @override
  String get theme_butterfly => '蝴蝶';

  @override
  String get theme_sprout => '小草';

  @override
  String get theme_star => '星空';

  @override
  String get theme_planet => '星球';

  @override
  String get echo_publish_btn => '發布時空紀錄';

  @override
  String get echo_wall_title => '時空迴音牆';

  @override
  String get echo_leave_memory => '留下經歷';

  @override
  String get echo_empty_msg => '還沒有時空旅人留下紀錄...\n妳要成為第一個嗎？';

  @override
  String get creator_label => '創作者';

  @override
  String get follow_btn => '關注';

  @override
  String get followed_btn => '已關注';

  @override
  String get follow_own_warning => '創作者不能關注自己哦！🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName 關注了 $creatorName！';
  }

  @override
  String get mailbox_follow_title => '獲得新的守護者 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName 剛剛關注了妳！';
  }

  @override
  String get tab_private_profile => '私密檔案';

  @override
  String get tab_memory_fragments => '記憶碎片';

  @override
  String get tab_time_echoes => '時空迴音';

  @override
  String get chat_free_btn => '閒聊(免費)';

  @override
  String get start_story_btn => '開始劇情';

  @override
  String get default_chat_initial => '找我有事嗎？';

  @override
  String get gallery_title => '專屬通話背景';

  @override
  String gallery_current_affection(String value) {
    return '目前好感度: $value 💕';
  }

  @override
  String get gallery_empty => '相簿裡還沒有照片喔';

  @override
  String gallery_unlocked_msg(String desc) {
    return '已將背景設為「$desc」！';
  }

  @override
  String gallery_lock_msg(String value) {
    return '好感度達到 $value 即可解鎖喔！🍃';
  }

  @override
  String get gallery_reset_bg => '已恢復預設通話背景';

  @override
  String get background_story_title => '背景故事';

  @override
  String get background_story_empty => '這個角色很神秘，還沒有背景故事...';

  @override
  String followed_creator_msg(String creatorName) {
    return '已關注 $creatorName 🦋';
  }

  @override
  String get mailbox_title => '專屬信箱 💌';

  @override
  String get mailbox_empty => '信箱空空的，快去發佈動態吸引他吧！';

  @override
  String get new_notification => '新通知';

  @override
  String get default_he => '他';

  @override
  String affection_upgrade_title(String charName) {
    return '$charName 對妳的好感度提升了！ 💖';
  }

  @override
  String get flower_reward => '🌸 獲得 5 點花花';

  @override
  String get affection_quote_lv5 =>
      '「沒想到...妳對我來說，已經變得這麼重要了。重要到...我無法想像沒有妳的世界。」';

  @override
  String get affection_quote_lv4 => '「這輩子最幸運的事，大概就是在那天，回頭看見了妳。」';

  @override
  String get affection_quote_lv3 => '「最近...我發現自己發呆的時間變多了，而且腦袋裡全都是妳。」';

  @override
  String get affection_quote_lv2 => '「既然是妳的邀約，那我稍微空出點時間，也不是不行。」';

  @override
  String get affection_quote_lv1 => '「最近常看到妳，感覺...並不討厭這種見面的頻率。」';

  @override
  String get affection_quote_lv0 => '「原來妳也在這裡，這算是一種奇妙的緣分嗎？」';

  @override
  String get lore_edit_success => '✨ 記憶碎片已成功更新！';

  @override
  String get delete_failed_network => '刪除失敗，請檢查網路或權限。';

  @override
  String get ai_chat_language => '繁體中文';

  @override
  String get ai_chat_language_code => 'zh-TW';

  @override
  String get chat_home_title => '訊息';

  @override
  String get call_memory_tooltip => '通話回憶';

  @override
  String get login_to_view_chat => '請先登入以查看聊天紀錄';

  @override
  String load_chat_failed(String error) {
    return '讀取聊天列表失敗: $error';
  }

  @override
  String get chat_list_empty => '聊天室空空的...';

  @override
  String get go_to_encounter => '去「邂逅」找個人聊聊吧！';

  @override
  String confirm_delete_chat(String charName) {
    return '確定要刪除與 $charName 的對話嗎？';
  }

  @override
  String affection_score_short(String score) {
    return '好感 $score';
  }

  @override
  String get character_not_found => '無法讀取角色資料，該角色可能已被刪除。';

  @override
  String get preparing_chat_room => '正在為您準備專屬聊天室...';

  @override
  String get rename_chat_title => '為這段記憶命名';

  @override
  String get rename_chat_hint => '例如：(程聿)改成(離婚倒數中)';

  @override
  String get save_tag_btn => '儲存標籤';

  @override
  String get room_name_updated => '房間名稱已更新！';

  @override
  String update_failed(String error) {
    return '更新失敗: $error';
  }

  @override
  String get chat_mode_daily => '日常';

  @override
  String get chat_mode_story => '劇情';

  @override
  String get chat_mode_immersive => '沉浸';

  @override
  String get chat_mode_gemini => '閒聊';

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
  String get chat_load_char_failed => '找不到角色資料，請返回重試或檢查網路。';

  @override
  String get chat_jump_success => '已跳轉至該段回憶 🍃';

  @override
  String get chat_create_room_failed => '連線似乎有點不穩，建立聊天室失敗，請再試一次。';

  @override
  String get chat_secret_file_title => '🔒 機密檔案';

  @override
  String get chat_secret_file_desc => '該角色的靈魂檔案已被封存或轉為私人權限，暫時無法查看詳細資料。';

  @override
  String get chat_understood => '了解';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ 獲得新回憶：$title';
  }

  @override
  String get chat_egg_saved => '已自動收錄至專屬背包';

  @override
  String get chat_points_not_enough_title => '花花不足';

  @override
  String get chat_points_not_enough_desc => '你的花朵不夠了!請先前往商店補充。';

  @override
  String chat_call_confirm_title(String name) {
    return '要打給 $name 嗎？';
  }

  @override
  String get chat_call_rule_1 => '每次通話都會扣除 20 點花花';

  @override
  String get chat_call_rule_2 => '通話時間為一分鐘，若不方便說話可以透過文字傳達';

  @override
  String get chat_call_rule_3 => '建議配戴耳機，更能聽清楚他的聲音 ✨';

  @override
  String get chat_call_btn_cancel => '先不要';

  @override
  String get chat_call_pref_title => '設定您的通話偏好';

  @override
  String get chat_call_lang_select => '選擇通話語言';

  @override
  String get chat_call_save_memory => '保存本次通話回憶';

  @override
  String get chat_call_save_memory_desc => '通話結束後可重複回聽';

  @override
  String get chat_call_btn_start => '開始通話';

  @override
  String chat_points_shortage(String points) {
    return '花花點數不夠喔！目前有 $points 點';
  }

  @override
  String get chat_room_not_ready => '聊天室尚未準備好，請重新進入。';

  @override
  String get chat_stop_generating_msg => '已停止回覆，點數並沒有扣除 🍃';

  @override
  String get chat_heartbeat_up => '他心跳加速了...';

  @override
  String get chat_heartbeat_down => '他眼神變冷了...';

  @override
  String get chat_msg_copy => '複製內容';

  @override
  String get chat_msg_copied => '已複製到剪貼簿！';

  @override
  String get chat_msg_report => '舉報該對話框';

  @override
  String get chat_msg_suggest => '給建議';

  @override
  String get chat_report_title => '舉報此對話';

  @override
  String get chat_report_lang => '出現外文';

  @override
  String get chat_report_inapp => '回覆不恰當';

  @override
  String get chat_report_context => '上下文沒有連接';

  @override
  String get chat_report_other => '其他原因';

  @override
  String get chat_report_hint => '請描述您遇到的問題...';

  @override
  String get chat_report_submit => '送出';

  @override
  String get chat_report_success => '✅ 舉報已送出，我們會盡快調整';

  @override
  String get chat_suggest_title => '給予建議';

  @override
  String get chat_suggest_hint => '請寫下您的寶貴意見...';

  @override
  String get chat_suggest_success => '💖 感謝您的建議，我們會盡快處理';

  @override
  String get chat_del_warn => '訊息刪除後將無法復原。';

  @override
  String get chat_reset_title => '重置記憶';

  @override
  String get chat_reset_desc =>
      '請選擇重置的程度：\n\n1. 【僅對話】：清除對話紀錄，但保留好感度。\n2. 【完全重置】：一切歸零，像初次見面一樣。';

  @override
  String get chat_reset_only_chat => '僅對話紀錄';

  @override
  String get chat_reset_full => '完全重置';

  @override
  String get chat_reset_full_msg => '一切已回歸最初，他不再記得妳了...';

  @override
  String get chat_reset_chat_msg => '對話已清空，但他對妳的愛意依然存在。';

  @override
  String get chat_edit_ai_hint => '編輯他的回覆...';

  @override
  String get chat_edit_user_hint => '請輸入新的內容...';

  @override
  String chat_no_voice_msg(String name) {
    return '目前還沒有 $name 的聲音...';
  }

  @override
  String get chat_poke_btn => '戳一下';

  @override
  String get chat_poke_success => '✨ 已幫妳戳戳創作者囉！請期待他的聲音上線～';

  @override
  String chat_gift_points_needed(String cost) {
    return '花花點數不夠喔！需要 $cost 點 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ 命定之人 ✨';

  @override
  String get chat_levelup_normal => '關係晉升！💖';

  @override
  String get chat_levelup_btn_soulmate => '刻入靈魂';

  @override
  String get chat_levelup_btn_normal => '心動收下';

  @override
  String get chat_loc_title => '📍 傳送虛擬定位';

  @override
  String get chat_loc_custom_btn => '發送自訂定位';

  @override
  String get chat_loc_hint => '輸入其他地點... (例如：在你心裡)';

  @override
  String get chat_loc_1 => '在你家樓下';

  @override
  String get chat_loc_2 => '在學校';

  @override
  String get chat_loc_3 => '在剛才路過的咖啡廳';

  @override
  String get chat_loc_4 => '在便利商店';

  @override
  String get chat_interact_title => '✨ 想對他做什麼呢？';

  @override
  String get chat_interact_action => '戳一戳與小動作';

  @override
  String get chat_interact_gift => '送他小禮物 (消耗花花 🌸)';

  @override
  String get chat_action_poke => '戳戳臉頰';

  @override
  String get chat_action_hug => '討抱抱';

  @override
  String get chat_action_hand => '偷偷牽手';

  @override
  String get chat_dice_btn => '擲骰子';

  @override
  String get chat_loading_failed => '讀取回憶失敗，請返回重試。';

  @override
  String get chat_test_mode_msg => '測試模式已開啟，隨便聊聊吧！(對話不會存檔喔)';

  @override
  String get chat_empty_msg => '與他開始一段心動的旅程吧!';

  @override
  String get chat_ai_typing => '對方正在回覆...';

  @override
  String get chat_input_hint_default => '想對他說什麼...';

  @override
  String get chat_typing_indicator => '正在輸入中...';

  @override
  String get chat_menu_search => '搜尋對話';

  @override
  String get chat_menu_gallery => '專屬回憶與背景';

  @override
  String get chat_menu_aboutme => '與我相關';

  @override
  String get chat_menu_memo => '給他的備忘錄';

  @override
  String get chat_menu_period => '生理期追蹤';

  @override
  String get chat_menu_reset => '重置記憶';

  @override
  String get chat_search_hint => '想回味哪一段甜蜜對話呢？';

  @override
  String get chat_search_empty => '找不到這段回憶喔 🥺';

  @override
  String get chat_search_you => '妳說的';

  @override
  String get chat_search_him => '他說的';

  @override
  String get chat_tool_backpack => '背包';

  @override
  String get chat_tool_story => '劇情摘要';

  @override
  String get chat_tool_photo => '照片';

  @override
  String get chat_tool_record => '錄音';

  @override
  String get chat_tool_profile => '拾光檔案';

  @override
  String get chat_tool_interact => '互動玩法';

  @override
  String get chat_record_recording => '錄音中...';

  @override
  String get chat_record_start => '點擊麥克風開始錄音';

  @override
  String get chat_record_done => '錄音完成';

  @override
  String get chat_mode_daily_desc => '輕鬆愉快的日常閒聊，就像朋友一樣!。';

  @override
  String get chat_mode_story_desc => '小說般的劇情推進。';

  @override
  String get chat_mode_immersive_desc => '極致的感官體驗，無拘無束的深層互動。';

  @override
  String get chat_switch_mode_title => '切換聊天模式';

  @override
  String get chat_voice_call => '語音通話';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【系統事件】$playerName送出了一個【$giftName】。';
  }

  @override
  String get rel_title_soulmate => '靈魂伴侶/深愛';

  @override
  String get rel_title_lover => '熱戀期/專屬男友';

  @override
  String get rel_title_ambiguous => '曖昧期/互相試探';

  @override
  String get rel_title_friend => '普通朋友/好感萌芽';

  @override
  String get rel_title_acquaintance => '點頭之交/稍微眼熟';

  @override
  String get rel_title_stranger => '陌生/初識';

  @override
  String get rel_title_tense => '關係緊張/心生厭煩';

  @override
  String get rel_title_avoiding => '形同陌路/刻意躲避';

  @override
  String get rel_title_hostile => '極度厭惡/冰冷敵意';

  @override
  String get rel_title_nemesis => '不共戴天/永不相見';

  @override
  String get rel_msg_soulmate => '「沒想到...妳對我來說，已經變得這麼重要了。重要到...我無法想像沒有妳的世界。」';

  @override
  String get rel_msg_lover => '「這輩子最幸運的事，大概就是在那天，回頭看見了妳。」';

  @override
  String get rel_msg_ambiguous => '「最近...我發現自己發呆的時間變多了，而且腦袋裡全都是妳。」';

  @override
  String get rel_msg_friend => '「既然是妳的邀約，那我稍微空出點時間，也不是不行。」';

  @override
  String get rel_msg_acquaintance => '「最近常看到妳，感覺...並不討厭這種見面的頻率。」';

  @override
  String get rel_msg_stranger => '「原來妳也在這裡，這算是一種奇妙的緣分嗎？」';

  @override
  String chat_edit_char_count(String count) {
    return '$count 字';
  }

  @override
  String get chat_mysterious_player => '神秘玩家';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return '玩家 $playerName 期待著聽見 $characterName 的聲音，快去生成吧！';
  }

  @override
  String get gift_heart => '愛心';

  @override
  String get gift_flower => '花花';

  @override
  String get gift_sun => '太陽';

  @override
  String get gift_confetti => '拉炮';

  @override
  String get gift_coffee => '咖啡';

  @override
  String get gift_cake => '蛋糕';

  @override
  String get chat_action_poke_prompt => '（玩家突然伸出手，調皮地戳了戳你的臉頰）';

  @override
  String get chat_action_hug_prompt => '（玩家委屈巴巴地張開雙手，想要一個溫暖的抱抱）';

  @override
  String get chat_action_hand_prompt => '（玩家在桌子底下，悄悄握住了你的手）';

  @override
  String get chat_menu_send_location => '發送虛擬定位';

  @override
  String get weekday_mon => '(一)';

  @override
  String get weekday_tue => '(二)';

  @override
  String get weekday_wed => '(三)';

  @override
  String get weekday_thu => '(四)';

  @override
  String get weekday_fri => '(五)';

  @override
  String get weekday_sat => '(六)';

  @override
  String get weekday_sun => '(日)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ 獲得新回憶：$memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack => '已自動收錄至他的專屬背包';

  @override
  String get chat_profile_updated_msg => '拾光檔案已更新！他會記住妳的最新設定喔 🍃';

  @override
  String get comment_loading_author => '讀取中...';

  @override
  String comment_post_failed(String error) {
    return '留言失敗，請檢查網路連線：$error';
  }

  @override
  String get comment_delete_confirm_desc => '您確定要永久刪除這則留言嗎？';

  @override
  String get comment_delete_failed => '刪除失敗，請檢查網路連線';

  @override
  String get comment_identity_title => '選擇留言身分';

  @override
  String get comment_identity_myself => '我本人';

  @override
  String get comment_report_title => '確認檢舉';

  @override
  String get comment_report_rules_title => '⚖️ 留言檢舉規範';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ 初犯：系統警告並記錄一次違規。\n2️⃣ 二犯：禁止留言 1 天。\n3️⃣ 累犯：禁用檢舉功能 14 天，並降低留言能見度。\n\n🚨 嚴重惡意者：\n禁止與角色互動 1 天，ID 將公告於公佈欄 3 天（期間禁止更改 ID）。\n\n💡 檢舉送出後，最終審核結果將透過【遊戲內信箱】單獨發送給您。\n請互相尊重，理性檢舉。';

  @override
  String get comment_report_understood => '我已了解';

  @override
  String get comment_report_confirm_desc => '您確定要檢舉這則留言嗎？\n惡意檢舉可能會受到懲罰。';

  @override
  String get comment_report_submit_btn => '確定檢舉';

  @override
  String get comment_report_success => '感謝您的檢舉，我們會盡快核實！';

  @override
  String get comment_report_failed => '檢舉送出失敗，請稍後再試。';

  @override
  String get comment_option_delete => '刪除留言';

  @override
  String get comment_option_report => '檢舉留言';

  @override
  String comment_time_days_ago(String days) {
    return '$days天前';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '$hours小時前';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '$mins分鐘前';
  }

  @override
  String get comment_time_just_now => '剛剛';

  @override
  String get comment_sheet_title => '留言';

  @override
  String get comment_empty_state => '還沒有人留言，快來搶頭香！';

  @override
  String get comment_reply_btn => '回覆';

  @override
  String comment_replying_to(String name) {
    return '正在回覆 @$name';
  }

  @override
  String comment_input_hint(String name) {
    return '以 $name 的身分留言...';
  }

  @override
  String char_story_expect(String pronoun) {
    return '期待與$pronoun的故事...';
  }

  @override
  String get common_update_failed => '更新失敗，請檢查網路';

  @override
  String get char_edit_fragment => '編輯碎片';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 討厭：$dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 喜歡：$likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age歲 | $job';
  }

  @override
  String get common_got_it => '我知道了';

  @override
  String get common_add_failed => '新增失敗，請檢查網路';

  @override
  String common_delete_failed_with_err(String error) {
    return '刪除失敗，請檢查網路狀態：$error';
  }

  @override
  String get char_exclusive_guardian => '專屬守護 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName 喜歡了 $charName！';
  }

  @override
  String chat_translation_prefix(String content) {
    return '【譯】$content (這是翻譯後的感性內容)';
  }

  @override
  String get player_default_nickname => '旅人';

  @override
  String get moment_create_title => '發布新動態';

  @override
  String get moment_create_post_btn => '發布';

  @override
  String get moment_create_hint => '分享新鮮事...';

  @override
  String get moment_create_error_empty => '文字和圖片至少需要一項喔！';

  @override
  String get moment_create_error_failed => '發布失敗，請稍後再試';

  @override
  String get moment_create_visibility_public => '公開 (所有人可見)';

  @override
  String get moment_create_visibility_private => '私密 (僅好友可見)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (玩家發送了定位：$location)';
  }

  @override
  String get chat_you => '妳';

  @override
  String get chat_opponent => '對手';

  @override
  String chat_dice_duel_result(String name) {
    return '【系統事件】與$name擲骰子對決！結果出來了...';
  }

  @override
  String get chat_loading_status => '正在讀取中...';

  @override
  String chat_error_load_msg(String error) {
    return '讀取訊息失敗: $error';
  }

  @override
  String get chat_voice_msg_label => '語音訊息';

  @override
  String chat_special_story_trigger(String title) {
    return '【開啟特殊劇情：$title】';
  }

  @override
  String common_edit_failed(String error) {
    return '編輯失敗: $error';
  }

  @override
  String common_reset_failed(String error) {
    return '重置失敗: $error';
  }

  @override
  String get chat_default_greeting => '你好...';

  @override
  String get chat_memory_cleared => '記憶已徹底清空';

  @override
  String get chat_history_reset => '對話已重置';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 【 專屬拾光檔案 - $name 】\n━━━━━━━━━━━━━━━━━━\n🔹 姓名：$identity\n🔹 生日：$birthday\n🔹 身高：$height\n🔹 外貌：$appearance\n🔹 職業：$job\n\n📖 【 關於她的靈魂碎片 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 【 專屬拾光檔案 】\n━━━━━━━━━━━━━━━━━━\n🔹 姓名：$nickname\n🔹 生日：$birthday\n\n🔒 其他人設資料尚未解鎖...\n(填寫完整檔案，讓他在平行時空更了解妳吧！✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => '未命名檔案';

  @override
  String get chat_default_player_name => '玩家';

  @override
  String get error_system_confusion => '系統出現小混亂，請再試一次。';

  @override
  String get error_msg_send_failed => '訊息傳送失敗，請再試一次。';

  @override
  String get error_system_busy => '系統繁忙，請稍後再試。';

  @override
  String get error_network_unavailable => '目前暫時無法連線，請重試。';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 通話結束，與 $name 通話了 $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return '專屬劇情：$title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return '這是一段專屬於妳和 $name 的隱藏回憶...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return '一段關於「$keyword」的專屬回憶已悄悄解鎖...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '【隱藏事件觸發：$title】\n$scene';
  }

  @override
  String get chat_first_line_fallback => '……（他靜靜地看著妳，似乎在等妳先開口）';

  @override
  String get chat_new_room_created => '新的聊天室已建立';

  @override
  String portfolio_title(String nickname) {
    return '$nickname的作品集';
  }

  @override
  String get enter_secret_studio => '進入我的秘密工作室';

  @override
  String get no_public_character_mine => '妳還沒有發布任何公開角色喔！\n快去工作室創作吧✨';

  @override
  String get no_public_character_other => '這位創作者還沒有發布角色喔...';

  @override
  String get delete_draft_title => '刪除草稿';

  @override
  String get confirm_delete_draft_msg => '確定要刪除這個未完成的角色嗎？\n(刪除後無法復原喔)';

  @override
  String get draft_cleared_success => '草稿已清理完畢 🧹';

  @override
  String get login_required_for_studio => '請先登入才能進入工作室喔！';

  @override
  String get my_secret_studio_title => '我的秘密工作室 🛠️';

  @override
  String get create_new_character_btn => '創造新角色';

  @override
  String get unnamed_draft => '未命名草稿';

  @override
  String get click_to_edit_story => '點擊繼續編輯他的故事...';

  @override
  String get label_draft => '草稿';

  @override
  String get studio_empty_title => '工作室目前空空如也';

  @override
  String get studio_empty_subtitle => '點擊右下角，開始創造妳的第一個角色吧！';

  @override
  String get common_no_changes => '沒有任何變更';

  @override
  String get moment_updated_success => '動態已更新！';

  @override
  String common_save_failed(String error) {
    return '儲存失敗: $error';
  }

  @override
  String get moment_edit_title => '編輯動態';

  @override
  String get action_change_image => '更換圖片';

  @override
  String get action_remove_image => '移除圖片';

  @override
  String get moment_delete_confirm_title => '確定要刪除這則動態嗎？';

  @override
  String get moment_delete_confirm_content => '刪除後，這段朋友圈的回憶就會消失喔！';

  @override
  String get action_confirm_delete => '確定刪除';

  @override
  String get friend_unknown => '某位朋友';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname覺得妳的動態很讚喔！💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname覺得$authorName很有魅力，點了個讚！✨';
  }

  @override
  String get moment_like_success => '已傳遞妳的心動！✨';

  @override
  String get moment_notification_new_like => '新點讚！💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname 在動態中提到了 @$name 喔！✨';
  }

  @override
  String get moment_detail_title => '動態詳情';

  @override
  String get moment_not_found => '這篇動態好像不見了... 😢';

  @override
  String get moment_comment_title => '朋友圈留言';

  @override
  String get moment_comment_empty => '還沒有人留言，快來搶沙發！🛋';

  @override
  String moment_replying_to(String name) {
    return '正在回覆 @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return '回覆 @$name...';
  }

  @override
  String get moment_leave_comment_hint => '留下妳的回應...';

  @override
  String get moment_delete_permanent_confirm => '這則動態將被永久刪除，確定嗎？';

  @override
  String get moment_action_delete => '刪除動態';

  @override
  String get moment_action_report => '檢舉此動態';

  @override
  String get moment_action_share => '分享這則動態';

  @override
  String get moment_forward_hint => '轉發這篇動態給角色...';

  @override
  String moment_reply_private(String name) {
    return '私訊回覆 $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return '帶著動態去找 $name 聊天囉！ 💬';
  }

  @override
  String get moment_share_to_apps => '分享到其他應用程式';

  @override
  String moment_likes_label(String count) {
    return '$count 片葉子';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】快來看 $author 的動態：$content\n\n立即下載，開啟妳的專屬時光：$appLink';
  }

  @override
  String get moment_forward_title => '轉發給正在聊天的角色 💌';

  @override
  String get moment_forward_empty_state => '妳目前還沒有開始聊天的角色喔！\n先去大廳找找心儀的他吧 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【轉發了一則動態】\n作者：$author\n內容：$content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ 已悄悄分享給 $name 囉！';
  }

  @override
  String get action_send => '發送';

  @override
  String get memo_delete_confirm => '您確定要刪除這則備忘錄嗎？此操作無法復原。';

  @override
  String get memo_add_title => '新增備忘錄';

  @override
  String get memo_edit_title => '編輯備忘錄';

  @override
  String memo_hint_text(String name) {
    return '想記下關於 $name 的什麼呢？';
  }

  @override
  String get memo_label_reminder_date => '提醒日期:';

  @override
  String get memo_action_save => '儲存備忘';

  @override
  String get memo_error_empty_content => '內容不能空白喔！';

  @override
  String memo_list_title(String name) {
    return '與 $name 的備忘錄';
  }

  @override
  String get memo_empty_state => '還沒有任何備忘錄喔！\n點擊右上角新增一個吧！';

  @override
  String memo_reminder_date_display(String date) {
    return '提醒日：$date';
  }

  @override
  String get daily_gift_title => '時光每日贈禮';

  @override
  String daily_login_welcome(String appName, String amount) {
    return '歡迎回到《$appName》！\n今日簽到可領取 $amount 點花語點數。🌸';
  }

  @override
  String get title_daily_check_in => '每日簽到';

  @override
  String success_claim_reward(String amount) {
    return '成功領取 $amount 點花語！🌸';
  }

  @override
  String get error_claim_failed => '領取失敗，請檢查網路後重試。';

  @override
  String get action_claim_now => '立即領取';

  @override
  String get common_or => '或';

  @override
  String get title_language_settings => '語言設定';

  @override
  String get app_name => '戀戀拾光';

  @override
  String get login_slogan => '開啟妳的專屬時光';

  @override
  String get login_with_google => '使用 Google 登入';

  @override
  String get login_with_apple => '透過 Apple 登入';

  @override
  String get login_with_facebook => '使用 Facebook 登入';

  @override
  String get login_with_email => '使用戀戀帳號登入 (Email)';

  @override
  String get title_contact_us_heading => '我們非常重視您的建議！';

  @override
  String get desc_contact_us_body => '請在這裡寫下您的想法，幫助我們把遊戲變得更好。';

  @override
  String get error_feedback_empty => '建議內容不能為空喔！';

  @override
  String get email_subject_feedback => '戀戀拾光 - 玩家反饋建議';

  @override
  String get msg_email_app_not_found_copied => '無法自動開啟郵件，已為您複製官方信箱！';

  @override
  String get title_contact_us => '聯絡我們';

  @override
  String get desc_contact_us => '我們非常重視您的建議！\n請在這裡寫下您的想法，幫助我們把遊戲變得更好。';

  @override
  String get hint_enter_feedback => '請在此輸入您的建議...';

  @override
  String get action_send_via_email => '透過 Email 傳送';

  @override
  String get error_email_password_empty => '信箱和密碼不能為空喔！';

  @override
  String get auth_error_default => '發生錯誤，請稍後再試。';

  @override
  String get auth_error_user_not_found => '找不到此信箱，請先註冊喔！';

  @override
  String get auth_error_wrong_password => '密碼錯誤，請再試一次！';

  @override
  String get auth_error_email_in_use => '這個信箱已經被註冊過囉！請直接登入。';

  @override
  String get auth_error_weak_password => '密碼太弱了，請至少輸入 6 個字元！';

  @override
  String get auth_error_invalid_email => '信箱格式不正確！';

  @override
  String get title_welcome_back => '歡迎回來';

  @override
  String get title_register_account => '註冊專屬帳號';

  @override
  String get label_email => '電子郵件';

  @override
  String get label_password => '密碼';

  @override
  String get action_login => '登入';

  @override
  String get action_register => '註冊';

  @override
  String get prompt_no_account => '還沒有帳號？點我註冊';

  @override
  String get prompt_has_account => '已經有帳號了？點我登入';

  @override
  String get error_nickname_empty => '暱稱不能為空！';

  @override
  String get profile_saved_success => '個人檔案儲存！';

  @override
  String get error_id_empty => 'ID不能為空！';

  @override
  String get error_id_too_long => 'ID長度不能超過10個字元！';

  @override
  String get error_id_already_used => '此ID已被使用，請換一個！';

  @override
  String profile_save_failed(String error) {
    return '儲存失敗: $error';
  }

  @override
  String get draft_saved_success_msg => '好的！先幫你保存在草稿裡，隨時可以回來編輯喔！✨';

  @override
  String get dialog_reminder_title => '提醒';

  @override
  String get warning_id_not_edited => '專屬ID尚未編輯，您確定要現在儲存嗎？';

  @override
  String get action_continue_editing => '繼續編輯';

  @override
  String get action_edit_later => '之後再編輯';

  @override
  String get action_edit_later_short => '稍後再編輯';

  @override
  String get action_cancel_changes => '取消變更';

  @override
  String get error_birthdate_locked => '出生日期已設定，不可更改！';

  @override
  String get action_select_avatar => '選擇頭像';

  @override
  String get action_choose_from_gallery => '從相冊選擇';

  @override
  String get title_adjust_avatar => '調整您的時光頭像';

  @override
  String get avatar_updated_success => '已為您換上頭像 🍃';

  @override
  String get title_create_profile => '建立你的檔案';

  @override
  String get title_edit_profile => '編輯個人檔案';

  @override
  String get label_your_nickname => '您的暱稱';

  @override
  String get label_player_exclusive_id => '玩家專屬 ID';

  @override
  String get msg_id_locked => 'ID 已鎖定，無法再次更改。';

  @override
  String get msg_id_change_chance => '您有一次免費更改 ID 的機會。';

  @override
  String get action_select_birthdate => '請選擇出生日期';

  @override
  String label_birthdate(String date) {
    return '出生日期: $date';
  }

  @override
  String get msg_birthdate_immutable => '生日設定後不可更改 ✨';

  @override
  String get action_start_journey => '開啟時光旅程';

  @override
  String get action_add_image => '新增圖片';

  @override
  String moment_like_self(String nickname) {
    return '$nickname覺得妳的動態很讚喔！💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname覺得$authorName很有魅力，點了個讚！✨';
  }

  @override
  String get task_social_tour_complete => '✨ 達成社群巡禮任務！記得領取花花喔！🌸';

  @override
  String get wall_title_shiguang => '拾光牆';

  @override
  String get wall_tab_explore => '🌍 探索';

  @override
  String get wall_tab_exclusive => '🔒 專屬';

  @override
  String get more_options => '更多選項';

  @override
  String get delete_warning => '刪除後，貼文將無法找回';

  @override
  String get delete_success => '刪除成功';

  @override
  String get notification_new_comment => '新留言！💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName 對妳的動態點了個讚！';
  }

  @override
  String get empty_public_moments_prompt => '目前空空如也，\n快去發布第一篇公開動態吧！🌍';

  @override
  String get empty_private_moments_prompt => '朋友圈還沒有留下的瞬間，\n快去與他創造回憶吧！✨';

  @override
  String get profile_archived_or_deleted_message =>
      '這份靈魂檔案已被創作者封存、設為私人，或是已經消散在時空的洪流中...\n\n或許在某個平行宇宙，你們還有再次相遇的機會。✨';

  @override
  String get leave_silently => '默默離開';

  @override
  String get character_post_schedule => '角色發文排程';

  @override
  String get creator_self => '創作者本人';

  @override
  String get post_identity_prompt => '今天要用誰的身分發文？';

  @override
  String get identity_creator => '✨ 創作者身分';

  @override
  String get identity_character => '角色身分';

  @override
  String get decide_post_time_prompt => '幫他們決定發文時間吧！';

  @override
  String get auto_post_schedule_hint =>
      '開啟後，將會在指定時間自動發布日常動態\n(💡 建議設定非整點，看起來更像真人喔！)';

  @override
  String get no_characters_created_yet => '妳還沒有創建任何角色喔！';

  @override
  String time_hour(String hour) {
    return '$hour 點';
  }

  @override
  String time_minute(String minute) {
    return '$minute 分';
  }

  @override
  String get empty_public_moments_short => '目前還沒有公開動態 🌍';

  @override
  String get empty_private_moments_short => '朋友圈還靜悄悄的 ✨';

  @override
  String get my_created_characters => '我創建的角色';

  @override
  String get no_characters_yet => '尚未創建角色';

  @override
  String play_count_display(int count) {
    return '遊玩次數: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return '$characterName 的關心日曆';
  }

  @override
  String get care_calendar_greeting => '今天的心情如何？';

  @override
  String get care_calendar_save_btn => '儲存紀錄，讓他照顧妳';

  @override
  String get care_calendar_delete_confirm => '要刪除這筆紀錄嗎？';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName：「我都記下來了，這幾天辛苦妳了，我會一直在妳身邊的。」';
  }

  @override
  String get daily_gift_success => '成功領取每日贈禮！🌸';

  @override
  String get check_in_fail_network => '簽到失敗，請檢查網路連線 🍃';

  @override
  String task_completed(String taskName) {
    return '完成任務：$taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return '成功領取「$taskName」的 $rewardAmount 點花花！';
  }

  @override
  String claim_failed_error(String e) {
    return '領取失敗: $e';
  }

  @override
  String get tab_heartbeat_diary => '心動日記';

  @override
  String get tab_daily_chit_chat => '閒話家常';

  @override
  String get task_desc_chat_3_times => '與角色進行 3 次日常聊天';

  @override
  String get tab_story_progression => '劇情推進';

  @override
  String get task_desc_story_1_time => '完成 1 次劇情模式互動';

  @override
  String get tab_social_tour => '社群巡禮';

  @override
  String get task_desc_like_3_moments => '為 3 則朋友圈動態按讚';

  @override
  String get btn_claimed => '已領取';

  @override
  String get btn_claim => '領取';

  @override
  String get btn_incomplete => '未完成';

  @override
  String get network_unstable_retry => '網路連線不穩，請稍後再試🍃';

  @override
  String get title_time_travel => '時光旅行';

  @override
  String get select_chat_mode => '選擇聊天模式';

  @override
  String get mode_chat => '聊天';

  @override
  String get mode_daily_desc => '輕鬆閒聊，維持羈絆';

  @override
  String get mode_story_desc => '深入故事，體驗沉浸感';

  @override
  String get greeting_hello => '你好！';

  @override
  String get greeting_default_daily => '找我有事嗎？';

  @override
  String get title_personal_homepage => '個人主頁';

  @override
  String get title_time_letters => '時光信件';

  @override
  String get status_signed_in_today => '今日已簽到';

  @override
  String get status_signing_in => '簽到中...';

  @override
  String get status_daily_sign_in => '每日簽到 (+10 花花)';

  @override
  String get toast_id_copied => 'ID 已複製！';

  @override
  String get hint_click_avatar_to_edit => '點擊頭像進行個人檔案編輯';

  @override
  String get title_my_friends => '我的好友';

  @override
  String get action_show_all => '顯示全部';

  @override
  String get empty_no_characters_created => '您尚未創建任何角色。';

  @override
  String get common_close => '關閉';

  @override
  String get search_companion_title => '搜尋拾光伴侶';

  @override
  String get search_name_placeholder => '輸入他的名字...';

  @override
  String get search_no_match_hint => '找不到角色，試試其他名字？ ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age歲 | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age歲';
  }

  @override
  String get empty_state_warmth => '這裡還留存著時空的餘溫...';

  @override
  String get error_login_required_add_friend => '請先登入才能添加好友！';

  @override
  String get dialog_title_remove_friend => '確認移除好友';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return '您確定要將 $characterName 從好友列表中移除嗎？';
  }

  @override
  String get action_remove => '移除';

  @override
  String snackbar_friend_removed(String characterName) {
    return '已將 $characterName 移除好友';
  }

  @override
  String get action_remove_friend => '移除好友';

  @override
  String get dialog_title_block => '確認封鎖';

  @override
  String dialog_msg_block(String characterName) {
    return '封鎖後，您將不會再看到 $characterName 的任何資訊。確定要封鎖嗎？';
  }

  @override
  String snackbar_blocked(String characterName) {
    return '已封鎖 $characterName';
  }

  @override
  String get action_block_character => '封鎖此角色';

  @override
  String dialog_title_report(String characterName) {
    return '檢舉 $characterName';
  }

  @override
  String get input_hint_report_reason => '請輸入檢舉原因...';

  @override
  String get action_submit => '提交';

  @override
  String get snackbar_report_success => '感謝您的回報，我們將會盡快審核。';

  @override
  String get snackbar_report_fail => '提交失敗，請稍後再試';

  @override
  String get action_report_character => '檢舉此角色';

  @override
  String get title_meet_him => '遇見心儀的他';

  @override
  String text_character_count(int count) {
    return '角色數量: $count';
  }

  @override
  String get msg_no_more_encounters_today => '今天的邂逅就到這裡囉！';

  @override
  String get msg_check_new_encounters => '再來看看有沒有新的相遇吧！';

  @override
  String get action_refresh => '重新整理';

  @override
  String get tab_friends => '好友';

  @override
  String get msg_mysterious_profile => '這個人很神秘，什麼都沒留下...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age歲 | $identities';
  }

  @override
  String get snackbar_operation_failed => '操作失敗，請稍後再試';

  @override
  String get action_view_translation => '查看翻譯';

  @override
  String get label_translation_result => '翻譯結果:';

  @override
  String get errorWebPageUnavailable => '暫時無法開啟網頁，請稍後再試';

  @override
  String get resetAppearanceTitle => '要重置外觀嗎？';

  @override
  String get resetAppearanceWarning => '這將會移除您精心挑選的背景圖與顏色喔！';

  @override
  String get appearanceRestored => '已恢復預設外觀';

  @override
  String get confirmReset => '確定重置';

  @override
  String get resetToDefaultAppearance => '恢復預設外觀';

  @override
  String get clearCustomSettings => '清除所有自定義顏色與背景圖';

  @override
  String get contactUs => '聯絡我們';

  @override
  String get contactDescription => '有任何心裡話或 Bug 都能告訴我們';

  @override
  String get vibrationHapticTitle => '心動震動感應';

  @override
  String get vibrationHapticDescription => '好感度大幅變動時觸發手機震動';

  @override
  String get splash_loading_universe => '正在喚醒《戀戀拾光》的宇宙...';

  @override
  String get shop_title => '花花小舖';

  @override
  String get shop_current_points_label => '目前持有的花花點數';

  @override
  String get shop_tab_top_up => '點數儲值';

  @override
  String get shop_tab_history => '收支明細';

  @override
  String get shop_empty_history => '目前還沒有花花紀錄喔！🌸';

  @override
  String get shop_unknown_item => '未知項目';

  @override
  String get shop_first_purchase_bonus => '首購雙倍！';
}
