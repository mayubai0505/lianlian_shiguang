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
}
