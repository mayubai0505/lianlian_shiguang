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
  String block_warning_msg(String charName) {
    return 'ブロックすると、一時的に $charName からのメッセージを受信できなくなります。';
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

  @override
  String get confirm_delete_title => '削除の確認';

  @override
  String get confirm_delete_memory_msg => '本当にこの記憶を忘れさせますか？この操作は元に戻せません。';

  @override
  String get delete_btn => '削除';

  @override
  String get memory_erased_msg => 'この記憶は消去されました';

  @override
  String get delete_failed_msg => '削除に失敗しました';

  @override
  String get edit_memory_title => '思い出を編集';

  @override
  String get modify_memory_hint => 'この記憶を修正...';

  @override
  String get memory_re_recorded_msg => '記憶が再記録されました';

  @override
  String get update_failed_msg => '更新に失敗しました';

  @override
  String get update_favorite_failed_msg => 'お気に入り状態の更新に失敗しました';

  @override
  String char_notebook_title(String charName) {
    return '$charNameのノート';
  }

  @override
  String get error_loading_memory => '記憶の読み込み中にエラーが発生しました';

  @override
  String get empty_notebook_msg =>
      'ノートには何もありません...\nたくさんチャットして、あなたのことを記録してもらいましょう！';

  @override
  String get date_format_text => 'yyyy年M月d日';

  @override
  String get remove_special_focus => '特別なお気に入りを解除';

  @override
  String get mark_special_focus => '特別なお気に入りに登録';

  @override
  String get edit_btn => '編集';

  @override
  String get load_gallery_failed => 'ギャラリーの読み込みに失敗しました';

  @override
  String get traditional_chinese => '繁体字中国語';

  @override
  String get all => 'すべて';

  @override
  String get official_recommendation => '公式おすすめ';

  @override
  String get my_exclusive => '私専用';

  @override
  String encounter_count(int count) {
    return '$count 回の出会い';
  }

  @override
  String get official => '公式';

  @override
  String get private => 'プライベート';

  @override
  String get first_encounter => '初めての出会い';

  @override
  String char_exclusive_memory(String charName) {
    return '$charNameの専用の思い出';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return 'この思い出のロックを解除するには、好感度が $affectionLevel 必要です！';
  }

  @override
  String get affection => '好感度';

  @override
  String get unlock => 'ロック解除';

  @override
  String get change_chat_bg => 'チャット背景を変更';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return '「$cgDesc」を $charName とのチャット背景に設定しますか？';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return '背景を「$cgDesc」に変更しました';
  }

  @override
  String get confirm_change => '変更を確定';

  @override
  String get empty_treasure_box => '宝箱は空っぽです...\nチャットして隠されたサプライズを見つけましょう！';

  @override
  String get unknown_story => '未知のストーリー';

  @override
  String get open_this_memory => 'この思い出を開く';

  @override
  String get open_exclusive_story => '専用ストーリーを開く';

  @override
  String confirm_use_egg(String eggTitle) {
    return '今すぐ「$eggTitle」を体験しますか？\n\n(このアイテムは使い捨てです。使用すると自動的にストーリーに入ります)';
  }

  @override
  String get wait_a_bit => 'ちょっと待って';

  @override
  String guiding_into_story(String eggTitle) {
    return 'ストーリーに案内中...';
  }

  @override
  String get use_now => '今すぐ使う';

  @override
  String playback_failed_status(String statusCode) {
    return '再生失敗、ステータスコード：$statusCode';
  }

  @override
  String get playback_error => '再生エラーが発生しました';

  @override
  String get unknown_contact => '不明な連絡先';

  @override
  String call_memory_with(String charName) {
    return '$charName との通話の思い出';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return '好感度 $affection で解放';
  }

  @override
  String get no_call_record => 'この通話には会話の記録が残っていないようです...';

  @override
  String get me => '私';

  @override
  String get playing => '再生中...';

  @override
  String get listen => '聴く';

  @override
  String get no_exclusive_voice => 'このキャラクターにはまだ専用ボイスが設定されていません！';

  @override
  String get voice_download_success => '✅ 音声データのダウンロードに成功しました。再生を準備しています...';

  @override
  String get onboarding_invitation => '— 時の招待状 —';

  @override
  String get onboarding_welcome => '「恋々拾光」へようこそ';

  @override
  String get onboarding_quote => '「すべての出逢いは、久しぶりの再会。」';

  @override
  String get onboarding_gift_title => '初対面の贈り物：50の花言葉';

  @override
  String get onboarding_gift_subtitle => 'この花々が、彼との物語の始まりに寄り添います。';

  @override
  String get onboarding_start_button => '時の旅を始める';

  @override
  String get onboarding_more_info => 'この物語についてもっと知る';

  @override
  String get legal_agreement_prefix => '次へ進むと、以下の内容に同意したことになります：';

  @override
  String get legal_terms_button => '利用規約';

  @override
  String get legal_and => ' および ';

  @override
  String get legal_privacy_button => 'プライバシーポリシー';

  @override
  String get call_memory_title => '通話の思い出';

  @override
  String get please_login_first => '先にログインしてください';

  @override
  String get no_call_memories => '保存された通話記録はありません。\n最大10件まで保存可能です。';

  @override
  String call_with_name(String name) {
    return '$name との通話';
  }

  @override
  String call_duration(String time) {
    return '通話時間：$time';
  }

  @override
  String get delete_call_title => '通話記録を削除';

  @override
  String delete_call_confirm(String name) {
    return '$name との通話記録を削除しますか？\n（削除後は復元できません）';
  }

  @override
  String get keep_it => '残しておく';

  @override
  String get confirm_delete => '削除する';

  @override
  String get press_mic_to_speak => 'マイクを押して話し始めてください...';

  @override
  String get call_ended => '通話が終了しました';

  @override
  String character_thinking(String name) {
    return '（$name が考えています...）';
  }

  @override
  String character_picking_up(String name) {
    return '（$name が電話に出ています...）';
  }

  @override
  String get call_interrupted_login => '（通話中断）先にログインしてください...';

  @override
  String get silence => '（沈黙）';

  @override
  String get bad_signal => '（電波が弱いです...）';

  @override
  String get static_noise => '（ザザッ）...よく聞こえません...';

  @override
  String get type_message_hint => '文字を入力...';

  @override
  String get draft_saved_success => '下書きが秘密のスタジオに安全に保存されました！';

  @override
  String get draft_save_failed => '保存に失敗しました。後でもう一度お試しください';

  @override
  String get draft_save_title => '下書きを保存しますか？';

  @override
  String get draft_save_content => '作品がまだ公開されていません。先に秘密のスタジオに保存しますか？';

  @override
  String get not_save => '保存しない';

  @override
  String get save_draft => '下書きを保存';

  @override
  String confirm_delete_char_content(String name) {
    return 'キャラクター「$name」を削除してもよろしいですか？\n\nこの操作は取り消せません！';
  }

  @override
  String get char_deleted => 'キャラクターを削除しました';

  @override
  String get ok_button => 'はい！';

  @override
  String get cannot_save_title => '保存できません';

  @override
  String get cannot_save_content => 'キャラクター名を入力し、アバターを少なくとも1枚アップロードしてください！';

  @override
  String get word_count_exceeded => '文字数制限を超えています';

  @override
  String word_count_error_detail(String field, int limit) {
    return '「$field」が$limit文字を超えています。短くしてから保存してください。';
  }

  @override
  String get content_missing => '内容が不足しています';

  @override
  String get content_missing_personality => '「詳細な性格」を入力してください！少なくとも10文字以上必要です。';

  @override
  String get content_missing_bg =>
      '「キャラクターの背景」が短すぎます！背景を説明するために少なくとも20文字以上入力してください。';

  @override
  String get content_missing_tone =>
      '「口調と習慣」を設定してください。そうしないと、キャラクター崩壊（OOC）しやすくなります！';

  @override
  String get user_not_found => 'エラー：ユーザーが見つかりません';

  @override
  String char_saved_success(String name, String action) {
    return 'キャラクター「$name」が$actionされました！';
  }

  @override
  String save_error_detail(String error) {
    return '保存失敗：$error';
  }

  @override
  String get easter_egg_add_title => '隠しイースターエッグを追加';

  @override
  String get easter_egg_edit_title => 'イースターエッグを編集';

  @override
  String get keyword_label => 'トリガーキーワード（必須）';

  @override
  String get keyword_hint => '例：遊園地に行く、イチゴケーキ';

  @override
  String get egg_title_label => 'イースターエッグのタイトル（プレイヤーに表示）';

  @override
  String get egg_title_hint => '例：週末のデート';

  @override
  String get egg_teaser_label => '短い予告（プレイヤーに表示）';

  @override
  String get egg_teaser_hint => 'これから起こる出来事の始まりを説明してください...';

  @override
  String get egg_scene_label => '強制的なシーン切り替え（任意）';

  @override
  String get egg_scene_hint => '例：遊園地、お化け屋敷';

  @override
  String get egg_prompt_label => '台本指示';

  @override
  String get egg_prompt_hint =>
      'このシーンをどのように演じるか。\n（システム：遊園地にシーンが切り替わり、キャラクターが(プレイヤー名)を見て笑う...）';

  @override
  String get confirm_button => '確認';

  @override
  String get keyword_empty_error => 'キーワードを入力してください';

  @override
  String get voice_custom_title => '専用ボイスのカスタマイズ';

  @override
  String get voice_custom_hint => '例：低音のドS社長、優しい年下男子...';

  @override
  String get voice_generate_start => '生成開始';

  @override
  String get voice_bind_first => '先に専用ボイスを選んで「バインド」してください！';

  @override
  String get voice_test_failed =>
      '試聴失敗：「君に決めた！」をクリックして正式にバインドしてから、微調整を行ってください！';

  @override
  String voice_name_default(String name) {
    return '$name の専用ボイス';
  }

  @override
  String get voice_description_default =>
      'これは「恋恋拾光」の専用キャラクターのために作成された唯一無二のボイスです。プレイヤーが自ら選び生成したものです。';

  @override
  String get voice_bind_failed => 'ボイスのバインドに失敗しました。API残高やネットワーク状態を確認してください';

  @override
  String voice_bind_success(String name) {
    return '「$name」のソウルボイスが正式にバインドされました！';
  }

  @override
  String get voice_bind_success_draft =>
      'ボイスのバインドに成功しました！スライダーを動かして感情をテストできます！';

  @override
  String sync_failed(String error) {
    return '同期失敗、ネットワークを確認してください：$error';
  }

  @override
  String edit_character_title(String name) {
    return '$name を編集';
  }

  @override
  String get test_mode_tooltip => '全機能テスト';

  @override
  String get test_mode_error =>
      '⚠️ キャラクターファイルが見つかりません！下の「保存/公開」をクリックしてから、テストプレイしてください。';

  @override
  String get test_mode_notice =>
      '💡 テストモードは各モードの通常価格通りにポイントを消費し、正式な思い出には記録されません！';

  @override
  String get delete_character_tooltip => 'キャラクターを削除';

  @override
  String get tab_basic_story => '基本設定とストーリー';

  @override
  String get tab_voice => '専用ボイス';

  @override
  String get tab_relationship => '人間関係';

  @override
  String get save_changes_button => '変更を保存';

  @override
  String get section_basic_info => '基本データ';

  @override
  String get hint_occupation => '複数の身分に対応。スラッシュやコンマで区切ってください（例：学生/ハッカー）';

  @override
  String get hint_appearance => '例：銀色の長髪、琥珀色の瞳、いつも白衣を着ている...';

  @override
  String get section_story_identity => '🎭 ストーリーとあなたの身分';

  @override
  String get story_identity_desc => 'ストーリーの始まりと、このセーブデータでの「あなた」の特殊設定を定義します';

  @override
  String get advanced_writing_tips_title => '💡 高度なライティングテクニック：\n';

  @override
  String get advanced_writing_tips_1 => 'ストーリーやセリフの中に ';

  @override
  String get advanced_writing_tips_2 => '(プレイヤー名)';

  @override
  String get advanced_writing_tips_3 =>
      ' と入力すると、プレイ時に自動的にプレイヤーの本当のニックネームに置き換わります！\n';

  @override
  String get advanced_writing_tips_4 => '例：「';

  @override
  String get advanced_writing_tips_5 => '(プレイヤー名)';

  @override
  String get advanced_writing_tips_6 => '、どうしてこんなに遅かったの？」';

  @override
  String get player_identity_label => 'プレイヤーのデフォルト身分 (Player Identity) - 💡 任意';

  @override
  String get player_identity_hint =>
      '【任意】空欄の場合、AIはあなたの「プロフィール」を読み取って交流します。\n入力した場合、特定の身分を強制的に演じます（例：彼の冷徹なシステム、または裏切られた妻）。';

  @override
  String get background_label => 'キャラクターの背景と世界観';

  @override
  String get background_hint =>
      '彼の過去や世界観（現代都市、ABO、終末世界など）を説明してください。例：ゾンビが蔓延る世界で、彼はあなたを守る特殊部隊員...';

  @override
  String get story_summary_label => '一行ストーリー紹介';

  @override
  String get story_initial_label => '最初の出会いのストーリー';

  @override
  String get story_initial_hint =>
      '例：あなたがドアを開けると、彼が窓際に座っているのが見えます。彼は振り向いて言います。「(プレイヤー名)、こっちへ来い」...';

  @override
  String get first_line_label => 'キャラクターの第一声';

  @override
  String get first_line_hint => '例：(プレイヤー名)、やっと来たか。';

  @override
  String get section_personality_evo => '🌟 性格と好感度の変化';

  @override
  String get detailed_personality_label => '詳細な性格';

  @override
  String get detailed_personality_hint =>
      '彼の核心となる性格を記述してください。例：ツンデレ、口は悪いが心は優しい。他人には冷淡だが、プレイヤーにだけ笑顔を見せる。';

  @override
  String get affection_evo_desc => 'AIは以下の設定に基づいて好感度を上げるタイミングを判断します：';

  @override
  String get stage_1_label => '段階一：見知らぬ人/警戒 (Lv1)';

  @override
  String get stage_1_hint => '出会ったばかりの頃の反応。好感度アップの条件（例：礼儀正しい、プライバシーを探らない）。';

  @override
  String get stage_2_label => '段階二：知り合い/友達 (Lv2)';

  @override
  String get stage_2_hint => '親しくなった後の変化。好感度アップの条件（例：お菓子を分ける、猫の話題で盛り上がる）。';

  @override
  String get stage_3_label => '段階三：親密/恋人 (Lv3)';

  @override
  String get stage_3_hint => '完全に堕ちた後の反応。嫉妬する？それとも黙って拗ねる？';

  @override
  String get social_interaction_label => '社会・環境との相互作用';

  @override
  String get social_interaction_hint => '例：通行人にどう接するか？嫌いなものに直面したとき、どう反応するか？';

  @override
  String get section_habits => '🗣️ 好みと習慣';

  @override
  String get tone_hint_detail => '必須。例：言葉数は少なく、問い返すのが好き。口癖は「バカ」。翻訳調の使用は禁止。';

  @override
  String get dialogue_example_hint =>
      'プレイヤー：疲れちゃった。\nキャラクター：(頭を撫でる) よしよし、早く休め。';

  @override
  String get section_easter_eggs => '🎁 隠しイースターエッグと特殊ストーリー';

  @override
  String get no_easter_eggs => 'イースターエッグは未設定です。下のボタンから追加してください';

  @override
  String get no_scene_change => 'シーンを切り替えない';

  @override
  String get add_easter_egg_button => '隠しイースターエッグを追加';

  @override
  String get other_extra_info => 'その他の補足情報';

  @override
  String get visibility_label => 'キャラクターの公開範囲';

  @override
  String get visibility_public => '公開';

  @override
  String get visibility_private => '非公開';

  @override
  String get section_voice_gen => '🎙️ 彼の専用ボイス生成';

  @override
  String get voice_gen_desc =>
      'ヒントを入力して、世界に一つだけの専用ボイスを作りましょう！\n（💡 ヒント：生成後に気に入らなくても、いつでも作り直せます！）';

  @override
  String get voice_generating_status => 'ボイスを調合中...';

  @override
  String get voice_select_prompt => '✨ 3つのボイスを用意しました。選んでください：';

  @override
  String voice_sample_name(int index) {
    return 'ボイスサンプル $index';
  }

  @override
  String get voice_sample_desc => 'カードをクリックして選択、右側をクリックして試聴';

  @override
  String get voice_preparing => 'ボイスを準備しています...';

  @override
  String get voice_retry => '破棄して再試行';

  @override
  String get voice_confirm_selection => '君に決めた！';

  @override
  String get voice_bind_success_banner => '専用ボイスのバインドに成功しました！';

  @override
  String get voice_remake => 'ボイスを作り直す';

  @override
  String get voice_btn_generating => '生成中です、お待ちください...';

  @override
  String get voice_btn_generate => 'ヒントを入力して専用ボイスを生成';

  @override
  String get voice_advanced_tuning => '🎛️ 詳細設定：話し方の感情を微調整';

  @override
  String get voice_stability_low => 'ワイルド/吐息 🐺';

  @override
  String voice_stability_value(String value) {
    return '理性度: $value';
  }

  @override
  String get voice_stability_high => '安定/冷静 🤖';

  @override
  String get voice_style_low => '冷淡/抑圧 🧊';

  @override
  String voice_style_value(String value) {
    return 'ドラマチック度: $value';
  }

  @override
  String get voice_style_high => '大げさ/情熱的 🔥';

  @override
  String get voice_test_btn_testing => '感情を適用中...';

  @override
  String get voice_test_btn => '現在の感情を試聴';

  @override
  String get section_social_circle => '👥 彼の交友関係';

  @override
  String get social_circle_desc =>
      '他のキャラクターに対する彼の見方を設定します。プレイヤーがチャットで相手の名を出した際、ここでの設定に基づいて反応します（例：嫉妬、怒り）。';

  @override
  String get social_no_drama => '今のところ、他の男神とのトラブルはありません...';

  @override
  String social_target(String name) {
    return '対象：$name';
  }

  @override
  String social_attitude(String attitude) {
    return '見解：$attitude';
  }

  @override
  String social_edit_title(String name) {
    return '$name に対する見解を編集 💬';
  }

  @override
  String get social_attitude_label => '彼の見解 / 態度';

  @override
  String get social_attitude_hint => '例：うるさい奴だと思っているが、実は頼りにしている...';

  @override
  String get social_save_changes => '変更を保存';

  @override
  String get social_add_title => 'キャラクター関係を追加 🤝';

  @override
  String get social_select_target => '対象を選択';

  @override
  String get social_thoughts_label => 'この人に対する彼の見解...';

  @override
  String get social_thoughts_hint => '例：あのピアニストはうるさすぎる...';

  @override
  String get social_add_confirm => '追加を確定';

  @override
  String get gallery_load_failed =>
      '画像の読み込みに失敗しました 🥲\nネットワークを確認してください。Web版の場合はコンソールを確認してください。';

  @override
  String gallery_affection_req(int level) {
    return '好感度 $level';
  }

  @override
  String get gallery_upload_limit => '最大10枚までアップロード可能です';

  @override
  String get gallery_photo_setup => '写真の解放条件を設定';

  @override
  String get gallery_photo_desc_label => 'この写真は何ですか？';

  @override
  String get gallery_photo_desc_hint => '例：パジャマ姿、デート写真';

  @override
  String get gallery_photo_req_label => '解放に必要な好感度は？';

  @override
  String get gallery_photo_req_hint => '数字を入力してください（0は無料）';

  @override
  String get gallery_cancel_upload => 'アップロードをキャンセル';

  @override
  String get gallery_confirm_add => '追加を確定';

  @override
  String get default_photo_desc => '専用写真';

  @override
  String get draft_photo_desc => '下書き写真';

  @override
  String get loading_text => '読み込み中...';

  @override
  String get default_unnamed_character => '未命名キャラクター';

  @override
  String elevenlabs_error(String code) {
    return 'ElevenLabs エラー：$code';
  }

  @override
  String get voice_sample_script =>
      '（コホン）こんにちは。これは僕専用のボイステストです。これから先、僕はここで君と一緒にいます。嬉しい時も、悲しい時も、何でも僕に聞かせてください।。この話すリズムや音色は、聞き慣れましたか？もし気に入ってくれたなら、これを僕の専用ボイスとして決めましょう。これからの一日一日を楽しみにしています。';

  @override
  String get voice_test_script => '今の僕の話し方はどうですか？もし気に入ってくれたなら、これで決めましょう。';

  @override
  String get field_background => 'キャラクターの背景';

  @override
  String get field_tone => '口調と習慣';

  @override
  String get field_initial_story => '最初のストーリー';

  @override
  String get update_action => '更新';

  @override
  String get default_new_player => '新規プレイヤー';

  @override
  String get translating_status => '翻訳中...';

  @override
  String get translate_profile_btn => 'プロフィール内容を翻訳';

  @override
  String translate_failed(String error) {
    return '翻訳失敗: $error';
  }

  @override
  String get like_own_char_warning => '自分が作ったキャラクターに「いいね」はできません！🤭';

  @override
  String get like_success_msg => '「いいね」を送信しました！作者がとても喜びます💖';

  @override
  String get unlike_success_msg => '「いいね」を取り消しました💔';

  @override
  String get like_label => 'いいね';

  @override
  String get dislike_label => 'よくないね';

  @override
  String get block_char => 'このキャラクターをブロック';

  @override
  String get char_blocked_msg => 'このキャラクターをブロックしました。';

  @override
  String get dislike_dialog_title => 'このキャラクターが苦手ですか？';

  @override
  String get dislike_dialog_subtitle => '理由をこっそり教えてください。運営が審査と確認を行います：';

  @override
  String get dislike_hint => '設定がつまらない、画像が不適切...';

  @override
  String get dislike_thanks => 'フィードバックありがとうございます！運営にメッセージが届きました。';

  @override
  String get dislike_submit => 'こっそり送信';

  @override
  String get report_title => '📢 コメントを通報';

  @override
  String get report_subtitle => '通報の理由を選択してください：\n通報後、速やかに内容を審査いたします。';

  @override
  String get report_opt_1 => '性的または残酷な暴力表現';

  @override
  String get report_opt_2 => 'キャラクターへの中傷、侮辱、攻撃';

  @override
  String get report_opt_3 => 'ヘイトスピーチ、個人攻撃';

  @override
  String get report_opt_4 => 'スパム、広告詐欺';

  @override
  String get report_opt_5 => 'その他の不適切な内容';

  @override
  String get report_confirm => '通報を確定';

  @override
  String get report_success => '通報に成功しました、通知を受理しました！速やかに審査いたします🛡️';

  @override
  String get report_failed => '通報に失敗しました。ネットワーク接続を確認してください。';

  @override
  String get lore_delete_title => '⚠️ 警告：記憶の消去';

  @override
  String get lore_delete_content => 'この記憶は一度削除すると完全に消えてしまいます。本当に消去しますか？';

  @override
  String get lore_delete_cancel => '間違えました';

  @override
  String get lore_delete_confirm => '消去を確定';

  @override
  String get lore_delete_success => '🗑️ 記憶の断片を完全に消去しました。';

  @override
  String get lore_add_title => '新しい記憶を書く 🖋️';

  @override
  String get lore_edit_title => '記憶の断片を編集 🖋️';

  @override
  String get lore_title_label => '記憶のタイトル';

  @override
  String get lore_title_hint => '例：初めて出会った雨の日';

  @override
  String get lore_teaser_label => '概要 / イントロ';

  @override
  String get lore_teaser_hint => 'カードに表示される短い説明...';

  @override
  String get lore_content_label => '記憶の詳細内容';

  @override
  String get lore_content_hint => '詳細な物語や設定をここに書いてください...';

  @override
  String get lore_lock_label => '🔒 この記憶を封印する';

  @override
  String get lore_lock_desc => 'チェックを入れると作者のみ閲覧可能になり、プレイヤーは閲覧できなくなります';

  @override
  String get lore_empty_error => 'タイトルと内容は空にできません！';

  @override
  String get lore_add_success => '✨ 新しい記憶が正常に封印されました！';

  @override
  String get lore_publish => '記憶を公開';

  @override
  String get lore_save_edit => '変更を保存';

  @override
  String lore_write_first(Object pronoun) {
    return '$pronounの最初の過去を書き記しましょう！';
  }

  @override
  String lore_waiting(Object pronoun) {
    return '$pronounとの物語を楽しみにしています...';
  }

  @override
  String get lore_sealed_msg => '🔒 この記憶は封印されており、現在は閲覧できません。';

  @override
  String get lore_not_open_msg => 'この記憶はまだ外部に公開されていません...';

  @override
  String get lore_unnamed => '名もなき断片';

  @override
  String get lore_add_btn_limit => '新しい記憶の断片を書く（上限10件）';

  @override
  String get lore_collapse => '手紙を閉じる';

  @override
  String get echo_delete_title => '🗑️ コメントを削除';

  @override
  String get echo_delete_content => 'この時空のエコーを削除してもよろしいですか？\n削除すると二度と復元できません！';

  @override
  String get echo_keep => '残す';

  @override
  String get echo_clear_success => '時空のエコーを削除しました 🧹';

  @override
  String get echo_energy_full_title => '⚠️ 宇宙エネルギーが上限に達しました';

  @override
  String get echo_energy_full_content =>
      '時空エネルギーが上限（最大3件）に達しました。新しい宇宙の記録を開くには、古い時空の経験を削除してください！';

  @override
  String get echo_write_title => '時空のエコーを残す 🌌';

  @override
  String get echo_write_subtitle => 'ここでの経験や心に響く言葉を書き残しましょう！';

  @override
  String get echo_hint => '「たとえ世界が終わっても、君の呼吸を最優先に守るから...」';

  @override
  String get echo_theme_label => '付箋の枠を選択：';

  @override
  String get theme_butterfly => '蝶';

  @override
  String get theme_sprout => '若葉';

  @override
  String get theme_star => '星空';

  @override
  String get theme_planet => '惑星';

  @override
  String get echo_publish_btn => '時空の記録を公開';

  @override
  String get echo_wall_title => '時空のエコーウォール';

  @override
  String get echo_leave_memory => '経験を残す';

  @override
  String get echo_empty_msg => 'まだ時空の旅人の記録がありません...\nあなたが最初の一人になりますか？';

  @override
  String get creator_label => '作者';

  @override
  String get follow_btn => 'フォロー';

  @override
  String get followed_btn => 'フォロー中';

  @override
  String get follow_own_warning => '作者は自分をフォローできません！🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName が $creatorName をフォローしました！';
  }

  @override
  String get mailbox_follow_title => '新しい守護者を獲得 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName があなたをフォローしました！';
  }

  @override
  String get tab_private_profile => '秘密のプロフィール';

  @override
  String get tab_memory_fragments => '記憶の断片';

  @override
  String get tab_time_echoes => '時空のエコー';

  @override
  String get chat_free_btn => 'おしゃべり(無料)';

  @override
  String get start_story_btn => 'ストーリー開始';

  @override
  String get default_chat_initial => '何か用かな？';

  @override
  String get gallery_title => '専用通話背景';

  @override
  String gallery_current_affection(String value) {
    return '現在の好感度: $value 💕';
  }

  @override
  String get gallery_empty => 'アルバムにまだ写真がありません';

  @override
  String gallery_unlocked_msg(String desc) {
    return '背景を「$desc」に設定しました！';
  }

  @override
  String gallery_lock_msg(String value) {
    return '好感度が $value に達すると解放されます！🍃';
  }

  @override
  String get gallery_reset_bg => 'デフォルトの通話背景に戻しました';

  @override
  String get background_story_title => '背景ストーリー';

  @override
  String get background_story_empty => 'このキャラクターは謎に包まれており、背景ストーリーはまだありません...';

  @override
  String followed_creator_msg(String creatorName) {
    return '$creatorName をフォローしました 🦋';
  }

  @override
  String get mailbox_title => '専用ポスト 💌';

  @override
  String get mailbox_empty => 'ポストは空っぽです。近況を投稿して彼を惹きつけましょう！';

  @override
  String get new_notification => '新着通知';

  @override
  String get default_he => '彼';

  @override
  String affection_upgrade_title(String charName) {
    return '$charName のあなたへの好感度が上がりました！ 💖';
  }

  @override
  String get flower_reward => '🌸 5ポイントのお花を獲得';

  @override
  String get affection_quote_lv5 =>
      '「思いもしなかった……君が僕にとって、こんなに大切な存在になるなんて。君のいない世界なんて、もう想像もできないくらいに」';

  @override
  String get affection_quote_lv4 => '「人生で一番幸運だったのは、たぶんあの日、振り返った先に君がいたことだと思う」';

  @override
  String get affection_quote_lv3 => '「最近……ぼーっとする時間が増えた気がする。頭の中が君のことでいっぱいなんだ」';

  @override
  String get affection_quote_lv2 => '「君からの誘いなら、少し時間を空けるくらい……別に構わないよ」';

  @override
  String get affection_quote_lv1 => '「最近よく君を見かけるね。……このくらいの頻度で会うのも、悪くない気がするよ」';

  @override
  String get affection_quote_lv0 => '「君もここにいたんだ。これも一種の奇妙な縁なのかな？」';

  @override
  String get lore_edit_success => '✨ 記憶の断片が正常に更新されました！';

  @override
  String get delete_failed_network => '削除に失敗しました。ネットワークまたは権限を確認してください。';

  @override
  String get ai_chat_language => '日本語';

  @override
  String get ai_chat_language_code => 'ja-JP';

  @override
  String get chat_home_title => 'メッセージ';

  @override
  String get call_memory_tooltip => '通話の思い出';

  @override
  String get login_to_view_chat => 'ログインしてチャット履歴を表示してください';

  @override
  String load_chat_failed(String error) {
    return 'チャットリストの読み込みに失敗しました: $error';
  }

  @override
  String get chat_list_empty => 'チャットルームが空っぽです...';

  @override
  String get go_to_encounter => '「邂逅」へ行って誰かと話してみましょう！';

  @override
  String confirm_delete_chat(String charName) {
    return '$charName との会話を削除してもよろしいですか？';
  }

  @override
  String affection_score_short(String score) {
    return '好感度 $score';
  }

  @override
  String get character_not_found => 'キャラクターデータを読み込めません。削除された可能性があります。';

  @override
  String get preparing_chat_room => '専用チャットルームを準備しています...';

  @override
  String get rename_chat_title => 'この記憶に名前を付ける';

  @override
  String get rename_chat_hint => '例：(程聿)から(離婚カウントダウン)に変更';

  @override
  String get save_tag_btn => 'タグを保存';

  @override
  String get room_name_updated => '部屋名を更新しました！';

  @override
  String update_failed(String error) {
    return '更新失敗: $error';
  }

  @override
  String get chat_mode_daily => '日常';

  @override
  String get chat_mode_story => 'ストーリー';

  @override
  String get chat_mode_immersive => '没入';

  @override
  String get chat_mode_gemini => 'おしゃべり';

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
      'キャラクターデータが見つかりません。戻ってやり直すか、ネットワークを確認してください。';

  @override
  String get chat_jump_success => 'その思い出のシーンへ移動しました 🍃';

  @override
  String get chat_create_room_failed =>
      '接続が不安定なようです。チャットルームの作成に失敗しました。もう一度お試しください。';

  @override
  String get chat_secret_file_title => '🔒 機密ファイル';

  @override
  String get chat_secret_file_desc =>
      'このキャラクターのソウルファイルはアーカイブされているか、プライベート設定になっています。詳細は現在閲覧できません。';

  @override
  String get chat_understood => '了解';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ 新しい思い出を獲得：$title';
  }

  @override
  String get chat_egg_saved => '専用バッグに自動的に収録されました';

  @override
  String get chat_points_not_enough_title => 'お花が足りません';

  @override
  String get chat_points_not_enough_desc => 'お花が足りません！ショップへ行って補充してください。';

  @override
  String chat_call_confirm_title(String name) {
    return '$name に電話をかけますか？';
  }

  @override
  String get chat_call_rule_1 => '通話ごとに 20 お花が消費されます';

  @override
  String get chat_call_rule_2 => '通話時間は1分間です。話しにくい場合はテキストで伝えることもできます';

  @override
  String get chat_call_rule_3 => 'イヤホンの着用をおすすめします。彼の声がより鮮明に聞こえます ✨';

  @override
  String get chat_call_btn_cancel => '今はやめておく';

  @override
  String get chat_call_pref_title => '通話設定';

  @override
  String get chat_call_lang_select => '通話言語を選択';

  @override
  String get chat_call_save_memory => '今回の通話の思い出を保存する';

  @override
  String get chat_call_save_memory_desc => '通話終了後、繰り返し聞き直すことができます';

  @override
  String get chat_call_btn_start => '通話を開始';

  @override
  String chat_points_shortage(String points) {
    return 'お花ポイントが足りません！現在 $points ポイントです';
  }

  @override
  String get chat_room_not_ready => 'チャットルームの準備ができていません。もう一度入り直してください。';

  @override
  String get chat_stop_generating_msg => '返信を停止しました。ポイントは消費されていません 🍃';

  @override
  String get chat_heartbeat_up => '彼の鼓動が速くなっています...';

  @override
  String get chat_heartbeat_down => '彼の視線が冷たくなっています...';

  @override
  String get chat_msg_copy => 'コピー';

  @override
  String get chat_msg_copied => 'クリップボードにコピーしました！';

  @override
  String get chat_msg_report => 'このメッセージを通報する';

  @override
  String get chat_msg_suggest => 'アドバイスする';

  @override
  String get chat_report_title => '会話を通報する';

  @override
  String get chat_report_lang => '外国語が表示された';

  @override
  String get chat_report_inapp => '不適切な返信';

  @override
  String get chat_report_context => '文脈がつながっていない';

  @override
  String get chat_report_other => 'その他の理由';

  @override
  String get chat_report_hint => '問題を詳しく入力してください...';

  @override
  String get chat_report_submit => '送信';

  @override
  String get chat_report_success => '✅ 通報を受け付けました。速やかに調整いたします';

  @override
  String get chat_suggest_title => 'アドバイスを贈る';

  @override
  String get chat_suggest_hint => '貴重なご意見をお聞かせください...';

  @override
  String get chat_suggest_success => '💖 アドバイスありがとうございます。速やかに対応いたします';

  @override
  String get chat_del_warn => 'メッセージは削除すると復元できません。';

  @override
  String get chat_reset_title => '記憶のリセット';

  @override
  String get chat_reset_desc =>
      'リセットの程度を選択してください：\n\n1. 【対話のみ】：対話履歴を消去しますが、好感度は維持します。\n2. 【完全リセット】：すべてをゼロに戻し、初対面の状態に戻ります。';

  @override
  String get chat_reset_only_chat => '対話履歴のみ';

  @override
  String get chat_reset_full => '完全リセット';

  @override
  String get chat_reset_full_msg => 'すべてが最初に戻りました。彼はもうあなたのことを覚えていません...';

  @override
  String get chat_reset_chat_msg => '対話は消去されましたが、あなたへの愛着は残っています。';

  @override
  String get chat_edit_ai_hint => '彼の返信を編集する...';

  @override
  String get chat_edit_user_hint => '新しい内容を入力してください...';

  @override
  String chat_no_voice_msg(String name) {
    return '現在 $name の声はまだありません...';
  }

  @override
  String get chat_poke_btn => 'つつく';

  @override
  String get chat_poke_success => '✨ 作者をつついておきました！彼の声が実装されるのを楽しみに待っていてくださいね～';

  @override
  String chat_gift_points_needed(String cost) {
    return 'お花ポイントが足りません！ $cost ポイント必要です 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ 運命の人 ✨';

  @override
  String get chat_levelup_normal => '関係が進展しました！ 💖';

  @override
  String get chat_levelup_btn_soulmate => '魂に刻む';

  @override
  String get chat_levelup_btn_normal => 'ときめきを受け取る';

  @override
  String get chat_loc_title => '📍 仮想位置情報を送信';

  @override
  String get chat_loc_custom_btn => 'カスタム位置情報を送信';

  @override
  String get chat_loc_hint => '他の場所を入力... (例：君の心の中)';

  @override
  String get chat_loc_1 => '君の家の前';

  @override
  String get chat_loc_2 => '学校で';

  @override
  String get chat_loc_3 => 'さっき通りかかったカフェで';

  @override
  String get chat_loc_4 => 'コンビニで';

  @override
  String get chat_interact_title => '✨ 彼に何をしたいですか？';

  @override
  String get chat_interact_action => 'つつく・小さな動作';

  @override
  String get chat_interact_gift => 'プレゼントを贈る (お花消費 🌸)';

  @override
  String get chat_action_poke => '頬をつつく';

  @override
  String get chat_action_hug => '抱っこをねだる';

  @override
  String get chat_action_hand => 'こっそり手を繋ぐ';

  @override
  String get chat_dice_btn => 'サイコロを振る';

  @override
  String get chat_loading_failed => '思い出の読み込みに失敗しました。戻ってやり直してください。';

  @override
  String get chat_test_mode_msg => 'テストモード中です。自由におしゃべりしましょう！（会話は保存されません）';

  @override
  String get chat_empty_msg => '彼とときめきの旅を始めましょう！';

  @override
  String get chat_ai_typing => '相手が返信しています...';

  @override
  String get chat_input_hint_default => '彼に何を伝えたいですか...';

  @override
  String get chat_typing_indicator => '入力中...';

  @override
  String get chat_menu_search => '会話を検索';

  @override
  String get chat_menu_gallery => '専用の思い出と背景';

  @override
  String get chat_menu_aboutme => '私に関すること';

  @override
  String get chat_menu_memo => '彼へのメモ';

  @override
  String get chat_menu_period => '生理周期管理';

  @override
  String get chat_menu_reset => '記憶のリセット';

  @override
  String get chat_search_hint => 'どの甘い会話を思い出したいですか？';

  @override
  String get chat_search_empty => 'その思い出は見つかりませんでした 🥺';

  @override
  String get chat_search_you => 'あなたの発言';

  @override
  String get chat_search_him => '彼の発言';

  @override
  String get chat_tool_backpack => 'バッグ';

  @override
  String get chat_tool_story => 'ストーリー要約';

  @override
  String get chat_tool_photo => '写真';

  @override
  String get chat_tool_record => '録音';

  @override
  String get chat_tool_profile => '拾光アーカイブ';

  @override
  String get chat_tool_interact => '交流機能';

  @override
  String get chat_record_recording => '録音中...';

  @override
  String get chat_record_start => 'マイクをクリックして録音開始';

  @override
  String get chat_record_done => '録音完了';

  @override
  String get chat_mode_daily_desc => '友達のような、楽しく軽やかな日常会話！';

  @override
  String get chat_mode_story_desc => '小説のように進むストーリー。';

  @override
  String get chat_mode_immersive_desc => '究極の没入体験、自由で深いインタラクション。';

  @override
  String get chat_switch_mode_title => 'チャットモードを切り替える';

  @override
  String get chat_voice_call => '音声通話';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【システムイベント】$playerName が 【$giftName】 を贈りました。';
  }

  @override
  String get rel_title_soulmate => 'ソウルメイト/深い愛';

  @override
  String get rel_title_lover => '熱愛期/専属の彼氏';

  @override
  String get rel_title_ambiguous => '曖昧な関係/探り合い';

  @override
  String get rel_title_friend => 'ただの友達/好意の芽生え';

  @override
  String get rel_title_acquaintance => '顔見知り/少し見覚えがある';

  @override
  String get rel_title_stranger => '他人/初対面';

  @override
  String get rel_title_tense => '緊張関係/嫌悪感の始まり';

  @override
  String get rel_title_avoiding => '赤の他人/意図的な回避';

  @override
  String get rel_title_hostile => '極度の嫌悪/冷たい敵意';

  @override
  String get rel_title_nemesis => '不倶戴天の敵/二度と会わない';

  @override
  String get rel_msg_soulmate =>
      '「思いもしなかった……君が僕にとって、こんなに大切な存在になるなんて。君のいない世界なんて、もう想像もできないくらいに」';

  @override
  String get rel_msg_lover => '「人生で一番幸運だったのは、たぶんあの日、振り返った先に君がいたことだと思う」';

  @override
  String get rel_msg_ambiguous => '「最近……ぼーっとする時間が増えた気がする。頭の中が君のことでいっぱいなんだ」';

  @override
  String get rel_msg_friend => '「君からの誘いなら、少し時間を空けるくらい……別に構わないよ」';

  @override
  String get rel_msg_acquaintance => '「最近よく君を見かけるね。……このくらいの頻度で会うのも、悪くない気がするよ」';

  @override
  String get rel_msg_stranger => '「君もここにいたんだ。これも一種の奇妙な縁なのかな？」';

  @override
  String chat_edit_char_count(String count) {
    return '$count 文字';
  }

  @override
  String get chat_mysterious_player => '謎のプレイヤー';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return 'プレイヤー $playerName が $characterName の声を聞けるのを楽しみに待っています。早く生成しましょう！';
  }

  @override
  String get gift_heart => 'ハート';

  @override
  String get gift_flower => 'お花';

  @override
  String get gift_sun => '太陽';

  @override
  String get gift_confetti => 'クラッカー';

  @override
  String get gift_coffee => 'コーヒー';

  @override
  String get gift_cake => 'ケーキ';

  @override
  String get chat_action_poke_prompt => '（プレイヤーが突然手を伸ばし、いたずらっぽくあなたの頬をつついた）';

  @override
  String get chat_action_hug_prompt => '（プレイヤーが心細そうに両手を広げ、温かい抱擁を求めている）';

  @override
  String get chat_action_hand_prompt => '（プレイヤーがテーブルの下で、そっとあなたの手を握った）';

  @override
  String get chat_menu_send_location => '仮想位置情報を送信';

  @override
  String get weekday_mon => '(月)';

  @override
  String get weekday_tue => '(火)';

  @override
  String get weekday_wed => '(水)';

  @override
  String get weekday_thu => '(木)';

  @override
  String get weekday_fri => '(金)';

  @override
  String get weekday_sat => '(土)';

  @override
  String get weekday_sun => '(日)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ 新しい思い出を獲得：$memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack => '彼の専用バッグに自動的に収録されました';

  @override
  String get chat_profile_updated_msg =>
      '拾光アーカイブが更新されました！彼はあなたの最新設定を覚えていますよ 🍃';

  @override
  String get comment_loading_author => '読み込み中...';

  @override
  String comment_post_failed(String error) {
    return 'コメントに失敗しました。接続を確認してください：$error';
  }

  @override
  String get comment_delete_confirm_desc => 'このコメントを永久に削除してもよろしいですか？';

  @override
  String get comment_delete_failed => '削除に失敗しました。ネットワーク接続を確認してください';

  @override
  String get comment_identity_title => '表示名を選択';

  @override
  String get comment_identity_myself => '自分自身';

  @override
  String get comment_report_title => '通報の確認';

  @override
  String get comment_report_rules_title => '⚖️ コメント通報規約';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ 初犯：システム警告および違反1回の記録。\n2️⃣ 二犯：1日間のコメント禁止。\n3️⃣ 累犯：14日間の通報機能停止およびコメント表示優先度の低下。\n\n🚨 重度の悪質なケース：\nキャラクターとのインタラクションを1日間禁止し、IDを掲示板に3日間公開します（期間中のID変更は不可）。\n\n💡 通報送信後、最終的な審査結果は【ゲーム内メール】にて個別にお送りします。\n互いに尊重し、理性的通報をお願いします。';

  @override
  String get comment_report_understood => '了解しました';

  @override
  String get comment_report_confirm_desc =>
      'このコメントを通報してもよろしいですか？\n悪質な虚偽通報は処罰の対象となる場合があります。';

  @override
  String get comment_report_submit_btn => '通報を確定';

  @override
  String get comment_report_success => '通報ありがとうございます。速やかに確認いたします！';

  @override
  String get comment_report_failed => '通報の送信に失敗しました。後でもう一度お試しください。';

  @override
  String get comment_option_delete => 'コメントを削除';

  @override
  String get comment_option_report => 'コメントを通報';

  @override
  String comment_time_days_ago(String days) {
    return '$days日前';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '$hours時間前';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '$mins分前';
  }

  @override
  String get comment_time_just_now => 'たった今';

  @override
  String get comment_sheet_title => 'コメント';

  @override
  String get comment_empty_state => 'まだコメントがありません。最初の投稿者になりましょう！';

  @override
  String get comment_reply_btn => '返信';

  @override
  String comment_replying_to(String name) {
    return '@$name に返信中';
  }

  @override
  String comment_input_hint(String name) {
    return '$name としてコメント...';
  }

  @override
  String char_story_expect(String pronoun) {
    return '$pronounとの物語が楽しみ...';
  }

  @override
  String get common_update_failed => '更新に失敗しました。ネットワークを確認してください';

  @override
  String get char_edit_fragment => '欠片を編集';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 嫌い：$dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 好き：$likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age歳 | $job';
  }

  @override
  String get common_got_it => '了解しました';

  @override
  String get common_add_failed => '追加に失敗しました。ネットワークを確認してください';

  @override
  String common_delete_failed_with_err(String error) {
    return '削除に失敗しました。ネットワーク状況を確認してください：$error';
  }

  @override
  String get char_exclusive_guardian => '専属ガーディアン 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerNameが$charNameに「いいね」しました！';
  }

  @override
  String chat_translation_prefix(String content) {
    return '【訳】$content (これは翻訳された感情的なコンテンツです)';
  }

  @override
  String get player_default_nickname => '旅人';

  @override
  String get moment_create_title => '新規投稿を作成';

  @override
  String get moment_create_post_btn => '投稿';

  @override
  String get moment_create_hint => '新しい出来事をシェア...';

  @override
  String get moment_create_error_empty => 'テキストまたは画像のどちらかが少なくとも必要です！';

  @override
  String get moment_create_error_failed => '投稿に失敗しました。後でもう一度お試しください';

  @override
  String get moment_create_visibility_public => '公開 (全員が閲覧可能)';

  @override
  String get moment_create_visibility_private => '非公開 (フレンドのみ閲覧可能)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (プレイヤーが位置情報を送信しました：$location)';
  }

  @override
  String get chat_you => 'あなた';

  @override
  String get chat_opponent => '相手';

  @override
  String chat_dice_duel_result(String name) {
    return '【システムイベント】$nameとのサイコロ対決！結果は...';
  }

  @override
  String get chat_loading_status => '読み込み中...';

  @override
  String chat_error_load_msg(String error) {
    return 'メッセージの読み込みに失敗しました: $error';
  }

  @override
  String get chat_voice_msg_label => '音声メッセージ';

  @override
  String chat_special_story_trigger(String title) {
    return '【特殊ストーリー解放：$title】';
  }

  @override
  String common_edit_failed(String error) {
    return '編集に失敗しました: $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'リセットに失敗しました: $error';
  }

  @override
  String get chat_default_greeting => 'こんにちは...';

  @override
  String get chat_memory_cleared => '記憶が完全に消去されました';

  @override
  String get chat_history_reset => '会話がリセットされました';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 【 専属拾光アーカイブ - $name 】\n━━━━━━━━━━━━━━━━━━\n🔹 名前：$identity\n🔹 誕生日：$birthday\n🔹 身長：$height\n🔹 外見：$appearance\n🔹 職業：$job\n\n📖 【 彼女の魂の欠片について 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 【 専属拾光アーカイブ 】\n━━━━━━━━━━━━━━━━━━\n🔹 ニックネーム：$nickname\n🔹 誕生日：$birthday\n\n🔒 その他のキャラクターデータはまだ解放されていません...\n（プロフィールを完成させて、平行世界の彼にあなたをもっと知ってもらいましょう！✨）\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => '無題のファイル';

  @override
  String get chat_default_player_name => 'プレイヤー';

  @override
  String get error_system_confusion => 'システムに少し混乱が生じています。もう一度お試しください。';

  @override
  String get error_msg_send_failed => 'メッセージの送信に失敗しました。もう一度お試しください。';

  @override
  String get error_system_busy => 'システムが混み合っています。後でもう一度お試しください。';

  @override
  String get error_network_unavailable => '現在接続できません。再試行してください。';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 通話終了。$nameと$time通話しました';
  }

  @override
  String chat_exclusive_story(String title) {
    return '専属ストーリー：$title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'これはあなたと$nameだけの隠された思い出です...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return '「$keyword」に関する専属の思い出が静かに解放されました...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '【隠しイベント発生：$title】\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......（彼は静かにあなたを見つめ、あなたが先に話すのを待っているようだ）';

  @override
  String get chat_new_room_created => '新しいチャットルームが作成されました';

  @override
  String portfolio_title(String nickname) {
    return '$nicknameの作品集';
  }

  @override
  String get enter_secret_studio => '私の秘密のスタジオに入る';

  @override
  String get no_public_character_mine =>
      'まだ公開キャラクターを公開していません！\nスタジオに行って創作しましょう✨';

  @override
  String get no_public_character_other => 'このクリエイターはまだキャラクターを公開していません...';

  @override
  String get delete_draft_title => '下書きを削除';

  @override
  String get confirm_delete_draft_msg =>
      'この未完成のキャラクターを削除してもよろしいですか？\n（削除後は元に戻せません）';

  @override
  String get draft_cleared_success => '下書きのクリアが完了しました 🧹';

  @override
  String get login_required_for_studio => 'スタジオに入るには先にログインしてください！';

  @override
  String get my_secret_studio_title => '私の秘密のスタジオ 🛠️';

  @override
  String get create_new_character_btn => '新しいキャラクターを作成';

  @override
  String get unnamed_draft => '無題の下書き';

  @override
  String get click_to_edit_story => 'クリックして彼のストーリーの編集を続ける...';

  @override
  String get label_draft => '下書き';

  @override
  String get studio_empty_title => '現在、スタジオは空っぽです';

  @override
  String get studio_empty_subtitle => '右下をクリックして、最初のキャラクターを作り始めましょう！';

  @override
  String get common_no_changes => '変更はありません';

  @override
  String get moment_updated_success => '投稿が更新されました！';

  @override
  String common_save_failed(String error) {
    return '保存に失敗しました: $error';
  }

  @override
  String get moment_edit_title => '投稿を編集';

  @override
  String get action_change_image => '画像を変更';

  @override
  String get action_remove_image => '画像を削除';

  @override
  String get moment_delete_confirm_title => 'この投稿を削除してもよろしいですか？';

  @override
  String get moment_delete_confirm_content => '削除すると、このタイムラインの思い出は消えてしまいますよ！';

  @override
  String get action_confirm_delete => '削除を確定';

  @override
  String get friend_unknown => 'ある友人';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname があなたの投稿に「いいね」しました！ 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname は $authorName がとても魅力的だと思い、「いいね」をしました！ ✨';
  }

  @override
  String get moment_like_success => 'あなたのときめきが届きました！ ✨';

  @override
  String get moment_notification_new_like => '新しい「いいね」！ 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname が投稿で @$name にメンションしました！ ✨';
  }

  @override
  String get moment_detail_title => '投稿の詳細';

  @override
  String get moment_not_found => 'この投稿は見つかりません... 😢';

  @override
  String get moment_comment_title => 'タイムラインのコメント';

  @override
  String get moment_comment_empty => 'まだコメントがありません。最初のコメントを書き込みましょう！ 🛋';

  @override
  String moment_replying_to(String name) {
    return '@$name に返信中';
  }

  @override
  String moment_reply_hint(String name) {
    return '@$name に返信...';
  }

  @override
  String get moment_leave_comment_hint => 'あなたの反応を残す...';

  @override
  String get moment_delete_permanent_confirm => 'この投稿は完全に削除されます。よろしいですか？';

  @override
  String get moment_action_delete => '投稿を削除';

  @override
  String get moment_action_report => 'この投稿を報告';

  @override
  String get moment_action_share => 'この投稿をシェア';

  @override
  String get moment_forward_hint => 'この投稿をキャラクターに転送...';

  @override
  String moment_reply_private(String name) {
    return '$name にDMで返信';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return 'この投稿を持って $name とチャットしに行きましょう！ 💬';
  }

  @override
  String get moment_share_to_apps => '他のアプリで共有';

  @override
  String moment_likes_label(String count) {
    return '$count 枚の葉っぱ';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '『$appName』$authorの投稿をチェックしよう：$content\n\n今すぐダウンロードして、あなただけの専属時間を始めよう：$appLink';
  }

  @override
  String get moment_forward_title => 'チャット中のキャラクターに転送 💌';

  @override
  String get moment_forward_empty_state =>
      '現在チャット中のキャラクターはいません！\nロビーで気になる人を見つけに行きましょう 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【ダイナミクスを転送しました】\n作者：$author\n内容：$content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ $name にそっとシェアしました！';
  }

  @override
  String get action_send => '送信';

  @override
  String get memo_delete_confirm => 'このメモを削除してもよろしいですか？この操作は取り消せません。';

  @override
  String get memo_add_title => 'メモを追加';

  @override
  String get memo_edit_title => 'メモを編集';

  @override
  String memo_hint_text(String name) {
    return '$name について何を書き留めますか？';
  }

  @override
  String get memo_label_reminder_date => 'リマインダー日:';

  @override
  String get memo_action_save => 'メモを保存';

  @override
  String get memo_error_empty_content => '内容を空にすることはできません！';

  @override
  String memo_list_title(String name) {
    return '$name とのメモ';
  }

  @override
  String get memo_empty_state => 'まだメモがありません！\n右上のボタンから新しく追加しましょう！';

  @override
  String memo_reminder_date_display(String date) {
    return 'リマインダー日：$date';
  }

  @override
  String get daily_gift_title => '時光デイリーギフト';

  @override
  String daily_login_welcome(String appName, String amount) {
    return '『$appName』へおかえりなさい！\n本日のチェックインで $amount 花言葉ポイントを受け取れます。🌸';
  }

  @override
  String get title_daily_check_in => '毎日サインイン';

  @override
  String success_claim_reward(String amount) {
    return '$amount 花言葉ポイントを受け取りました！ 🌸';
  }

  @override
  String get error_claim_failed => '受け取りに失敗しました。ネットワークを確認して再試行してください。';

  @override
  String get action_claim_now => '今すぐ受け取る';

  @override
  String get common_or => 'または';

  @override
  String get title_language_settings => '言語設定';

  @override
  String get app_name => '恋恋拾光';

  @override
  String get login_slogan => 'あなただけの専属時間を始めよう';

  @override
  String get login_with_google => 'Google でログイン';

  @override
  String get login_with_apple => 'Apple でログイン';

  @override
  String get login_with_facebook => 'Facebook でログイン';

  @override
  String get login_with_email => '恋恋アカウントでログイン (メール)';

  @override
  String get title_contact_us_heading => '私たちはあなたの提案をとても大切にしています！';

  @override
  String get desc_contact_us_body => 'ゲームをより良くするために、ここにあなたの考えを書き込んでください。';

  @override
  String get error_feedback_empty => '提案の内容は空にできません！';

  @override
  String get email_subject_feedback => '恋恋拾光 - プレイヤーからのフィードバック';

  @override
  String get msg_email_app_not_found_copied =>
      'メールアプリを自動で開けませんでした。公式メールアドレスをコピーしました！';

  @override
  String get title_contact_us => 'お問い合わせ';

  @override
  String get desc_contact_us =>
      '私たちはあなたの提案をとても大切にしています！\nゲームをより良くするために、ここにあなたの考えを書き込んでください。';

  @override
  String get hint_enter_feedback => 'ここに提案を入力してください...';

  @override
  String get action_send_via_email => 'メールで送信';

  @override
  String get error_email_password_empty => 'メールアドレスとパスワードは空にできません！';

  @override
  String get auth_error_default => 'エラーが発生しました。後でもう一度お試しください。';

  @override
  String get auth_error_user_not_found => 'このメールアドレスは見つかりません。先に登録してください！';

  @override
  String get auth_error_wrong_password => 'パスワードが間違っています。もう一度お試しください！';

  @override
  String get auth_error_email_in_use => 'このメールアドレスは既に登録されています！直接ログインしてください。';

  @override
  String get auth_error_weak_password => 'パスワードが弱すぎます。少なくとも6文字以上入力してください！';

  @override
  String get auth_error_invalid_email => 'メールアドレスの形式が正しくありません！';

  @override
  String get title_welcome_back => 'おかえりなさい';

  @override
  String get title_register_account => '専用アカウントを登録';

  @override
  String get label_email => 'メールアドレス';

  @override
  String get label_password => 'パスワード';

  @override
  String get action_login => 'ログイン';

  @override
  String get action_register => '登録';

  @override
  String get prompt_no_account => 'まだアカウントを持っていませんか？ここをクリックして登録';

  @override
  String get prompt_has_account => 'すでにアカウントを持っていますか？ここをクリックしてログイン';

  @override
  String get error_nickname_empty => 'ニックネームは空にできません！';

  @override
  String get profile_saved_success => 'プロフィールを保存しました！';

  @override
  String get error_id_empty => 'IDは空にできません！';

  @override
  String get error_id_too_long => 'IDの長さは10文字を超えてはいけません！';

  @override
  String get error_id_already_used => 'このIDはすでに使用されています。別のものを選択してください！';

  @override
  String profile_save_failed(String error) {
    return '保存に失敗しました：$error';
  }

  @override
  String get draft_saved_success_msg => '了解しました！下書きに保存しました。いつでも編集を再開できますよ！✨';

  @override
  String get dialog_reminder_title => 'リマインダー';

  @override
  String get warning_id_not_edited => '専用IDがまだ編集されていませんが、今すぐ保存してもよろしいですか？';

  @override
  String get action_continue_editing => '編集を続ける';

  @override
  String get action_edit_later => '後で編集する';

  @override
  String get action_edit_later_short => '後で編集';

  @override
  String get action_cancel_changes => '変更をキャンセル';

  @override
  String get error_birthdate_locked => '生年月日は既に設定されているため、変更できません！';

  @override
  String get action_select_avatar => 'アバターを選択';

  @override
  String get action_choose_from_gallery => 'ギャラリーから選択';

  @override
  String get title_adjust_avatar => 'アバターを調整';

  @override
  String get avatar_updated_success => 'アバターを変更しました 🍃';

  @override
  String get title_create_profile => 'プロフィールを作成';

  @override
  String get title_edit_profile => 'プロフィールを編集';

  @override
  String get label_your_nickname => 'あなたのニックネーム';

  @override
  String get label_player_exclusive_id => 'プレイヤー専用ID';

  @override
  String get msg_id_locked => 'IDはロックされており、再度変更することはできません。';

  @override
  String get msg_id_change_chance => 'IDを無料で変更できるチャンスが1回あります。';

  @override
  String get action_select_birthdate => '生年月日を選択してください';

  @override
  String label_birthdate(String date) {
    return '生年月日：$date';
  }

  @override
  String get msg_birthdate_immutable => '誕生日は一度設定すると変更できません ✨';

  @override
  String get action_start_journey => '時間の旅を始める';

  @override
  String get action_add_image => '画像を追加';

  @override
  String moment_like_self(String nickname) {
    return '$nickname があなたの投稿に「いいね」しました！ 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname は $authorName がとても魅力的だと思い、「いいね」をしました！ ✨';
  }

  @override
  String get task_social_tour_complete => '✨ コミュニティ巡回タスク達成！お花を受け取るのを忘れないでね！ 🌸';

  @override
  String get wall_title_shiguang => '拾光の壁';

  @override
  String get wall_tab_explore => '🌍 探索';

  @override
  String get wall_tab_exclusive => '🔒 専用';

  @override
  String get more_options => 'その他のオプション';

  @override
  String get delete_warning => '削除すると、投稿は元に戻せません';

  @override
  String get delete_success => '削除に成功しました';

  @override
  String get notification_new_comment => '新着コメント！ 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName があなたの投稿に「いいね」しました！';
  }

  @override
  String get empty_public_moments_prompt => 'まだ何もありません。\n最初の公開投稿をしてみましょう！ 🌍';

  @override
  String get empty_private_moments_prompt =>
      'タイムラインにはまだ思い出がありません。\n彼との思い出を作りに行きましょう！ ✨';

  @override
  String get profile_archived_or_deleted_message =>
      'この魂のファイルはクリエイターによってアーカイブされたか、非公開にされたか、あるいは時の流れの中に消えてしまいました...\n\nもしかしたら並行世界で、また会えるチャンスがあるかもしれません。 ✨';

  @override
  String get leave_silently => 'そっと立ち去る';

  @override
  String get character_post_schedule => 'キャラクター投稿スケジュール';

  @override
  String get creator_self => 'クリエイター本人';

  @override
  String get post_identity_prompt => '今日は誰の身分で投稿しますか？';

  @override
  String get identity_creator => '✨ クリエイターとして';

  @override
  String get identity_character => 'キャラクターとして';

  @override
  String get decide_post_time_prompt => '彼らの投稿時間を決めてあげましょう！';

  @override
  String get auto_post_schedule_hint =>
      'オンにすると、指定した時間に日常の投稿が自動的に行われます\n(💡 ヒント：正時以外に設定すると、より人間らしく見えますよ！)';

  @override
  String get no_characters_created_yet => 'まだキャラクターを作成していません！';

  @override
  String time_hour(String hour) {
    return '$hour 時';
  }

  @override
  String time_minute(String minute) {
    return '$minute 分';
  }

  @override
  String get empty_public_moments_short => '現在、公開投稿はありません 🌍';

  @override
  String get empty_private_moments_short => 'タイムラインはまだ静かです ✨';

  @override
  String get my_created_characters => '作成したキャラクター';

  @override
  String get no_characters_yet => 'まだキャラクターが作成されていません';

  @override
  String play_count_display(int count) {
    return 'プレイ回数: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return '$characterNameのケアカレンダー';
  }

  @override
  String get care_calendar_greeting => '今日の気分はどう？';

  @override
  String get care_calendar_save_btn => '記録を保存して、彼にケアしてもらう';

  @override
  String get care_calendar_delete_confirm => 'この記録を削除しますか？';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName：「全部メモしたよ。ここ数日辛かったね、俺はずっと君のそばにいるから。」';
  }

  @override
  String get daily_gift_success => 'デイリーギフトの受け取りに成功しました！🌸';

  @override
  String get check_in_fail_network => 'チェックインに失敗しました。ネットワーク接続を確認してください 🍃';

  @override
  String task_completed(String taskName) {
    return 'タスク完了：$taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return '「$taskName」から $rewardAmount 個のお花を受け取りました！';
  }

  @override
  String claim_failed_error(String e) {
    return '受け取り失敗: $e';
  }

  @override
  String get tab_heartbeat_diary => 'ときめき日記';

  @override
  String get tab_daily_chit_chat => '日常の雑談';

  @override
  String get task_desc_chat_3_times => 'キャラクターと日常チャットを3回行う';

  @override
  String get tab_story_progression => 'ストーリー進行';

  @override
  String get task_desc_story_1_time => 'ストーリーモードでの交流を1回完了する';

  @override
  String get tab_social_tour => 'コミュニティ巡回';

  @override
  String get task_desc_like_3_moments => 'タイムラインの投稿に3回「いいね」する';

  @override
  String get btn_claimed => '受け取り済み';

  @override
  String get btn_claim => '受け取る';

  @override
  String get btn_incomplete => '未完了';

  @override
  String get network_unstable_retry => 'ネットワークが不安定です。後でもう一度お試しください 🍃';

  @override
  String get title_time_travel => 'タイムトラベル';

  @override
  String get select_chat_mode => 'チャットモードを選択';

  @override
  String get mode_chat => 'チャット';

  @override
  String get mode_daily_desc => '気軽な雑談で絆を深める';

  @override
  String get mode_story_desc => 'ストーリーの奥深くに入り込み、没入感を体験';

  @override
  String get greeting_hello => 'こんにちは！';

  @override
  String get greeting_default_daily => '私に用事？';

  @override
  String get title_personal_homepage => 'マイページ';

  @override
  String get title_time_letters => '時光の手紙';

  @override
  String get status_signed_in_today => '本日サインイン済み';

  @override
  String get status_signing_in => 'サインイン中...';

  @override
  String get status_daily_sign_in => '毎日サインイン（+10 お花）';

  @override
  String get toast_id_copied => 'ID をコピーしました！';

  @override
  String get hint_click_avatar_to_edit => 'アバターをタップしてプロフィールを編集';

  @override
  String get title_my_friends => '私のフレンド';

  @override
  String get action_show_all => 'すべて表示';

  @override
  String get empty_no_characters_created => 'まだキャラクターを作成していません。';
}
