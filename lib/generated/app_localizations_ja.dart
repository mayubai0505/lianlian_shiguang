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

  @override
  String get characterNotFoundError => 'キャラクターデータが見つかりません';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'キャラクター詳細の読み込みに失敗しました: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => '初期の関係';

  @override
  String get relationship_childhood_friend => '幼なじみ';

  @override
  String get relationship_senior_junior => '先輩後輩';

  @override
  String get relationship_bickering_couple => '喧嘩するほど仲が良いカップル';

  @override
  String get relationship_colleagues => '職場の同僚';

  @override
  String get relationship_other => 'その他 (手動で入力してください)';

  @override
  String get chatModeDaily => '日常モード';

  @override
  String get chatModeStory => 'ストーリーモード';

  @override
  String get chatModeImmersive => '没入モード';

  @override
  String get chatModeGemini => '生活のパートナー';

  @override
  String get announcement_new => '新しいお知らせ';

  @override
  String get mail_notification => '新しい「時の手紙」が届きました！今すぐ羊皮紙を確認しましょう！';

  @override
  String get customer_service_reply => 'カスタマーサポートからの返信';

  @override
  String get system_announcement => 'システムからのお知らせ';

  @override
  String get empty_announcement => '現在、お知らせはありません';

  @override
  String get untitled => '無題';

  @override
  String get no_content => '内容なし';

  @override
  String get privacy_policy_title => '「恋恋拾光」プライバシーポリシー';

  @override
  String get privacy_policy_date => '最終更新日：2026年4月10日';

  @override
  String get privacy_policy_body =>
      '「恋恋拾光」プライバシーポリシー\n最終更新日：2026年4月10日\n\n「恋恋拾光」（以下「本サービス」）をご利用いただきありがとうございます。当社はお客様のプライバシーを尊重し、個人情報の収集、使用、および保護について説明します。\n\n1. アカウント情報：\nサードパーティログイン：Google、Facebook、またはAppleアカウントでログインする際、Firebase UID、メールアドレス、公開ニックネームを収集します。\nメール登録：メールで登録する場合、メールアドレスを収集します。パスワードはFirebaseの暗号化技術で管理され、開発チームは元のパスワードを閲覧できません。\n\nインタラクションデータ：AIキャラに継続的な記憶を持たせるため、AIとの対話記録およびゲーム内でキャラのために作成した内容を保存します。\n\nデバイス情報：システム最適化のため、モデル名、OSバージョン、固有識別子を収集します。\n\n2. 情報の使用目的\nAI体験の向上：対話記録を利用してAIの回答品質と性格の一貫性を最適化します。\nサービスの運営：ポイントのチャージ、消費記録、ユーザー認証に使用します。\n安全保護：不正行為を監視し、サーバーを攻撃から保護します。\n\n3. サードパーティ技術協力\n本サービスは以下の技術を採用しています：\nGoogle Cloud / Firebase：データ保存と認証。\nOpenRouter / xAI / Meta：AIモデルの演算論理。\n備考：元の対話記録を広告主に販売することはありません。\n\n4. データの保存と削除\nデータはクラウドサーバーに安全に保存されます。いつでもアカウントおよび全データの永久削除をリクエストできます。';

  @override
  String get terms_title => '「恋恋拾光」サービス利用規約';

  @override
  String get terms_date => '最終更新日：2026年4月10日';

  @override
  String get terms_body =>
      '「恋恋拾光」利用規約\n最終更新日：2026年4月10日\n\n本サービスを利用する前に、以下の規約をよくお読みください。利用を開始した時点で、以下の内容に同意したものとみなされます。\n\n1. サービスの性質と免責事項\n非人間との対話：すべての回答はAI（生成AI）によって生成されます。キャラの発言は制作者の立場を代表するものではありません。\n叙事のリスク：AIは架空、不正確、または不快な内容を生成する可能性があります。ユーザーは虚構と現実を区別する能力を持つ必要があります。\n\n2. 仮想ポイントと支払い\nポイントの性質：サービス内のポイントは仮想商品であり、消費後（ストーリー、没入モード、ギフト、通話など）は返金できません。\nコストの差異：各モードの消費基準はAI演算コストに基づいて設定され、当社はこれを調整する権利を留保します。\n\n3. ユーザー行動規範\n禁止事項：極端な暴力、犯罪誘導、または法律に違反する内容の生成を禁止します。\nシステム妨害：自動化ツールやリバースエンジニアリングによるデータ取得を厳禁します。\n\n4. 知的財産権\nオリジナルコンテンツ：「程安」などの公式キャラ、設定、脚本、対話、ゲームロジックの著作権は「恋恋拾光開発チーム」に帰属します。\nライセンス資源：アイコンやフォントは原権利者（Google、Apple等）に帰属し、規約に従い使用しています。\nAI生成コンテンツ：一部の画像はAIツール（Niji.journey等）で生成され、商用ライセンスを取得済みです。権利は本チームに帰属します。\n禁止行為：許可なく商用利用、二次配布、悪意あるモデル学習に使用することを禁じます。\n\n5. サービスの終了\n規約に違反した場合、事前の通知なくアカウントを停止または永久無効化する権利を有します。';

  @override
  String get login_required => '先にログインしてください';

  @override
  String get cloud_character_mgmt => 'クラウドキャラクター管理';

  @override
  String get connection_error => '接続エラー';

  @override
  String get no_characters_met => 'まだ誰とも出会っていません！';

  @override
  String get status_paused => 'ステータス：連絡停止中';

  @override
  String get status_in_progress => 'ステータス：攻略中';

  @override
  String get unblock => 'ブロック解除';

  @override
  String get block => 'ブロック';

  @override
  String get confirm_block_title => 'ブロックしますか？';

  @override
  String confirm_block_msg(Object charName) {
    return 'ブロックすると、当面の間 $charName からのメッセージを受け取れなくなります。';
  }

  @override
  String get think_again => 'もう少し考える';

  @override
  String get confirm_block_btn => 'ブロックを確定';

  @override
  String get no_char_info => 'このキャラクターの詳細情報はまだありません...';

  @override
  String get private_mailbox => '専用メールボックス';

  @override
  String get user_info_not_found => 'ユーザー情報が見つかりません';

  @override
  String get load_failed => '読み込み失敗、後でもう一度お試しください';

  @override
  String get empty_mailbox => '現在メールボックスは空です〜';

  @override
  String get system_notification => 'システム通知';

  @override
  String get interaction_records => '交流記録';

  @override
  String get liked_content => 'いいねした内容';

  @override
  String get my_favorites => 'お気に入り';

  @override
  String get login_to_view_records => '記録を見るにはログインしてください';

  @override
  String get no_likes_yet => 'まだ何もいいねしていません！';

  @override
  String get empty_favorites => 'お気に入りフォルダは空です。ロビーを覗いてみましょう！';

  @override
  String get theme_sakura_pink => 'サクラピンク';

  @override
  String get theme_ocean_blue => 'オーシャンブルー';

  @override
  String get theme_sunset_orange => 'サンセットオレンジ';

  @override
  String get theme_mint_forest => 'ミントフォレスト';

  @override
  String get theme_midnight => '深夜モード';

  @override
  String get change_atmosphere => '雰囲気を変える';

  @override
  String get custom_color => 'カスタムカラー';

  @override
  String get custom_color_desc => '自分だけのカラーを調合する';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確定';
}
