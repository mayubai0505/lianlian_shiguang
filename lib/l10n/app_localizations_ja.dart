// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get settingsTitle => '設定';

  @override
  String get changeTheme => 'テーマカラーを変更';

  @override
  String get feedback => 'フィードバック';

  @override
  String get changeLanguage => '言語を変更';

  @override
  String get allFriendsTitle => 'すべての友達';

  @override
  String get noFriendsMessage => 'まだ友達がいません。';

  @override
  String get unknownCharacter => '不明なキャラクター';

  @override
  String errorLoadingFriends(String error) {
    return '友達リストの読み込み中にエラーが発生しました: $error';
  }

  @override
  String get tagGentle => '優しい';

  @override
  String get tagCheerful => '明るい';

  @override
  String get tagLively => '活発';

  @override
  String get tagMischievous => 'おてんば';

  @override
  String get tagRichYoungLady => 'お嬢様';

  @override
  String get tagRichYoungMaster => 'お坊ちゃま';

  @override
  String get tagWealthyFamily => '裕福な家庭';

  @override
  String get tagScheming => '腹黒';

  @override
  String get tagPossessive => '独占欲';

  @override
  String get tagParanoid => '偏執的';

  @override
  String get tagPersistent => '一途';

  @override
  String get tagUncle => 'おじさん';

  @override
  String get tagAuntie => 'おばさん';

  @override
  String get tagSeniorSister => '先輩(女性)';

  @override
  String get tagJuniorBrother => '後輩(男性)';

  @override
  String get tagHandsome => 'イケメン';

  @override
  String get tagStunning => '美しく魅力的';

  @override
  String get tagContrast => 'ギャップ';

  @override
  String get tagFlirty => '挑発的';

  @override
  String get tagAgeGap => '年の差';

  @override
  String get userNotFoundError => 'ユーザーが見つかりません';

  @override
  String get imageDataMismatchError => '画像データが一致しません。画像を再選択してください。';

  @override
  String get createCharacterTitle => 'キャラクター作成';

  @override
  String get charAlbumTitle => 'キャラクターアルバム (最初の画像がメインアバター)';

  @override
  String get charNameLabel => 'キャラクター名:*';

  @override
  String get charDescSection => 'キャラクター説明:';

  @override
  String get charAgeLabel => '年齢:';

  @override
  String get charJobLabel => '職業:*';

  @override
  String get charBirthdayLabel => '誕生日:(MMDD)';

  @override
  String get charGenderLabel => '性別 *';

  @override
  String get genderNotSelected => '未選択';

  @override
  String get genderMale => '男';

  @override
  String get genderFemale => '女';

  @override
  String get genderOther => 'その他';

  @override
  String get charHeightLabel => '身長:(cm)';

  @override
  String get charAppearanceLabel => '外見の形容:';

  @override
  String get charPersonalityTagsSection => '性格タグ';

  @override
  String get charOtherPersonalityTagsHint => 'その他の性格タグ...';

  @override
  String get otherSectionTitle => 'その他';

  @override
  String get charLikesLabel => '好きなもの:(例: イチゴケーキ、猫、雨の日)';

  @override
  String get charDislikesLabel => '嫌いなもの:(例: 苦いメロン、うるさい場所)';

  @override
  String get charSecretsLabel => '人知れぬ小さな秘密: (例: 実は方向音痴)';

  @override
  String get charMannerismsSection => '言動';

  @override
  String get charToneLabel => '話し方とスタイル: (例: 見知らぬ人には冷たい)';

  @override
  String get charDialogueExampleLabel =>
      '会話例: (プレイヤー: あなたは本当にいい人ですね！ キャラクター: ...ああ。)';

  @override
  String get charBackgroundSection => 'キャラクター背景:';

  @override
  String get charBackgroundHint => 'キャラクターのバックグラウンドストーリーを入力してください (最大 2500 文字)';

  @override
  String get charStoryStartSection => 'ストーリーの始まり:';

  @override
  String get charStoryStartHint => 'キャラクターのプロットを入力してください (最大 2500 文字)';

  @override
  String get charStorySummaryLabel => 'ストーリーのあらすじ (最大 50 文字、出会いカードに表示されます)';

  @override
  String get charExtraInfoSection => 'キャラクターの追加情報:';

  @override
  String get charExtraInfoHint => '追加内容を入力してください...';

  @override
  String get charPublicToggleLabel => '他のプレイヤーがプレイできるように公開しますか？';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get createButton => '作成';

  @override
  String get saveButton => '保存';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get exitCreationTitle => 'キャラクター作成画面を終了します';

  @override
  String get saveDraftPrompt => '下書きとして保存しますか？';

  @override
  String get draftNeeded => 'はい';

  @override
  String get draftNotNeeded => 'いいえ';

  @override
  String get editExtraInfoTitle => '追加内容を編集';

  @override
  String get nameAndAvatarError => 'キャラクター名を入力し、アバターを少なくとも1枚アップロードしてください！';

  @override
  String get savingStatus => '保存中...';

  @override
  String get uploadingImagesStatus => '画像をアップロード中...';

  @override
  String get maxImagesError => '画像を10枚までしかアップロードできません。';

  @override
  String get uploadingImagesStatusShort => '画像を処理中...';

  @override
  String get savingCharacterData => 'キャラクターデータを保存中...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'キャラクター「$charName」が作成されました！';
  }

  @override
  String get uploadImageTimeoutError =>
      'キャラクター作成に失敗しました: 画像のアップロードがタイムアウトしました。インターネット接続を確認してください。';

  @override
  String createCharacterGenericError(String error) {
    return 'キャラクター作成に失敗しました: $error';
  }

  @override
  String get settingsSectionAppearance => '外観とコンテンツ';

  @override
  String get settingsSectionAccount => 'アカウントとコンテンツ管理';

  @override
  String get settingsSectionAbout => '私たちについて';

  @override
  String get accountManagement => 'アカウント管理';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => '不明';

  @override
  String get userIdCopied => 'ユーザーIDがクリップボードにコピーされました';

  @override
  String get characterManagement => 'キャラクター管理';

  @override
  String get viewBlockedCharacters => 'ブロックされたキャラクターを表示';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get logoutButton => 'ログアウト';

  @override
  String get logoutDialogTitle => 'ログアウトしますか？(´;ω;`)';

  @override
  String get logoutDialogActionCancel => '押し間違えました';

  @override
  String get logoutDialogActionConfirm => '確認';

  @override
  String get logoutSuccessSnackbar => 'はい！戻ってくるのを待っています♥(´∀` )';

  @override
  String get deleteAccountButton => 'アカウントを削除';

  @override
  String get deleteAccountDialogTitle => 'このアカウントを削除してもよろしいですか？இдஇ';

  @override
  String get deleteAccountDialogContent => 'この操作は元に戻せません。すべてのデータが完全に削除されます！';

  @override
  String get deleteAccountDialogActionCancel => 'いいえ、削除しません';

  @override
  String get deleteAccountDialogActionConfirm => '確認';

  @override
  String get deleteAccountSuccessSnackbar => 'アカウントが正常に削除されました。';

  @override
  String get appDisclaimer =>
      'ゲーム内のキャラクターやシーンはすべて架空のものですので、現実世界と混同しないでください！似ている点がある場合でも、それは偶然の一致です';

  @override
  String appVersion(String version) {
    return 'アプリのバージョン: $version';
  }

  @override
  String get dialogTitleHint => 'ヒント';

  @override
  String get completeProfilePrompt => 'まずプロフィールを編集して情報を完成させてください！';

  @override
  String get goToEdit => '編集へ';

  @override
  String get later => '後で';

  @override
  String chattingWith(String friendName) {
    return '$friendName とチャット中';
  }

  @override
  String chatContentWith(String friendName) {
    return '$friendName とのチャット内容';
  }

  @override
  String get chatInputHint => 'メッセージを入力...';
}
