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
  String confirm_block_msg(Object charName) {
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
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

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
  String confirm_block_msg(Object charName) {
    return '封锁后，将暂时无法收到 $charName 的讯息喔。';
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
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

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
  String confirm_block_msg(Object charName) {
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
}
