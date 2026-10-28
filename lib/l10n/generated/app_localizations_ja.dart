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
  String get charNameLabel => 'キャラクター名:';

  @override
  String get charDescSection => 'キャラクター説明:';

  @override
  String get charAgeLabel => '年齢:';

  @override
  String get charJobLabel => '職業:';

  @override
  String get charBirthdayLabel => '誕生日:(MMDD)';

  @override
  String get charGenderLabel => '性別 ';

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
  String get logoutSuccessSnackbar => 'はい！戻ってくるのを待っています(´∀` )';

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
  String get appDisclaimer => 'ゲーム内のキャラクターや舞台はすべてフィクションです。現実と混同しないようご注意ください！';

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
  String get terms_title => '利用規約';

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
  String get voice_download_success => '音声データのダウンロードに成功しました。再生を準備しています...';

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
  String get test_mode_notice => 'テストモードは各モードの通常価格通りにポイントを消費し、正式な思い出には記録されません！';

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
  String get section_story_identity => 'ストーリーとあなたの身分';

  @override
  String get story_identity_desc => 'ストーリーの始まりと、このセーブデータでの「あなた」の特殊設定を定義します';

  @override
  String get advanced_writing_tips_title => '高度なライティングテクニック：\n';

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
  String get section_personality_evo => '性格と好感度の変化';

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
  String get section_habits => '好みと習慣';

  @override
  String get tone_hint_detail => '必須。例：言葉数は少なく、問い返すのが好き。口癖は「バカ」。翻訳調の使用は禁止。';

  @override
  String get dialogue_example_hint =>
      'プレイヤー：疲れちゃった。\nキャラクター：(頭を撫でる) よしよし、早く休め。';

  @override
  String get section_easter_eggs => '隠しイースターエッグと特殊ストーリー';

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
  String get section_voice_gen => '彼の専用ボイス生成';

  @override
  String get voice_gen_desc =>
      'ヒントを入力して、世界に一つだけの専用ボイスを作りましょう！\n（ヒント：生成後に気に入らなくても、いつでも作り直せます！）';

  @override
  String get voice_generating_status => 'ボイスを調合中...';

  @override
  String get voice_select_prompt => '3つのボイスを用意しました。選んでください：';

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
  String get voice_advanced_tuning => '詳細設定：話し方の感情を微調整';

  @override
  String get voice_stability_low => 'ワイルド/吐息';

  @override
  String voice_stability_value(String value) {
    return '理性度: $value';
  }

  @override
  String get voice_stability_high => '安定/冷静';

  @override
  String get voice_style_low => '冷淡/抑圧';

  @override
  String voice_style_value(String value) {
    return 'ドラマチック度: $value';
  }

  @override
  String get voice_style_high => '大げさ/情熱的';

  @override
  String get voice_test_btn_testing => '感情を適用中...';

  @override
  String get voice_test_btn => '現在の感情を試聴';

  @override
  String get section_social_circle => '彼の交友関係';

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
    return '$name に対する見解を編集';
  }

  @override
  String get social_attitude_label => '彼の見解 / 態度';

  @override
  String get social_attitude_hint => '例：うるさい奴だと思っているが、実は頼りにしている...';

  @override
  String get social_save_changes => '変更を保存';

  @override
  String get social_add_title => 'キャラクター関係を追加';

  @override
  String get social_select_target => '対象を選択';

  @override
  String get social_thoughts_label => 'この人に対する彼の見解...';

  @override
  String get social_thoughts_hint => '例：あのピアニストはうるさすぎる...';

  @override
  String get social_add_confirm => '追加を確定';

  @override
  String get gallery_load_failed => '画像の読み込みに失敗しました\nネットワークを確認してください。';

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
  String get voice_test_script =>
      '君を見つめるたびに、僕が心の中で何を考えているか、本当に分かっているのかい？……本当に君には敵わないな。';

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
  String get like_own_char_warning => '自分が作ったキャラクターに「いいね」はできません！';

  @override
  String get like_success_msg => '「いいね」を送信しました！作者がとても喜びます';

  @override
  String get unlike_success_msg => '「いいね」を取り消しました';

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
  String get report_title => 'コメントを通報';

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
  String get report_success => '通報に成功しました、通知を受理しました！速やかに審査いたします';

  @override
  String get report_failed => '通報に失敗しました。ネットワーク接続を確認してください。';

  @override
  String get lore_delete_title => '警告：記憶の消去';

  @override
  String get lore_delete_content => 'この記憶は一度削除すると完全に消えてしまいます。本当に消去しますか？';

  @override
  String get lore_delete_cancel => '間違えました';

  @override
  String get lore_delete_confirm => '消去を確定';

  @override
  String get lore_delete_success => '記憶の断片を完全に消去しました。';

  @override
  String get lore_add_title => '新しい記憶を書く';

  @override
  String get lore_edit_title => '記憶の断片を編集';

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
  String get lore_lock_label => 'この記憶を封印する';

  @override
  String get lore_lock_desc => 'チェックを入れると作者のみ閲覧可能になり、プレイヤーは閲覧できなくなります';

  @override
  String get lore_empty_error => 'タイトルと内容は空にできません！';

  @override
  String get lore_add_success => '新しい記憶が正常に封印されました！';

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
  String get lore_sealed_msg => 'この記憶は封印されており、現在は閲覧できません。';

  @override
  String get lore_not_open_msg => 'この記憶はまだ外部に公開されていません...';

  @override
  String get lore_unnamed => '名もなき断片';

  @override
  String get lore_add_btn_limit => '新しい記憶の断片を書く（上限10件）';

  @override
  String get lore_collapse => '手紙を閉じる';

  @override
  String get echo_delete_title => 'コメントを削除';

  @override
  String get echo_delete_content => 'この時空のエコーを削除してもよろしいですか？\n削除すると二度と復元できません！';

  @override
  String get echo_keep => '残す';

  @override
  String get echo_clear_success => '時空のエコーを削除しました';

  @override
  String get echo_energy_full_title => ' 宇宙エネルギーが上限に達しました';

  @override
  String get echo_energy_full_content =>
      '時空エネルギーが上限（最大3件）に達しました。新しい宇宙の記録を開くには、古い時空の経験を削除してください！';

  @override
  String get echo_write_title => '時空のエコーを残す';

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
  String get follow_own_warning => '作者は自分をフォローできません！';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '$playerName が $creatorName をフォローしました！';
  }

  @override
  String get mailbox_follow_title => '新しい守護者を獲得';

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
    return '現在の好感度: $value';
  }

  @override
  String get gallery_empty => 'アルバムにまだ写真がありません';

  @override
  String gallery_unlocked_msg(String desc) {
    return '背景を「$desc」に設定しました！';
  }

  @override
  String gallery_lock_msg(String value) {
    return '好感度が $value に達すると解放されます！';
  }

  @override
  String get gallery_reset_bg => 'デフォルトの通話背景に戻しました';

  @override
  String get background_story_title => '最初の出会いの物語';

  @override
  String get background_story_empty =>
      'このキャラクターはとても謎めいていて、まだ最初の出会いの物語がありません...';

  @override
  String followed_creator_msg(String creatorName) {
    return '$creatorName をフォローしました';
  }

  @override
  String get mailbox_title => '専用ポスト';

  @override
  String get mailbox_empty => 'ポストは空っぽです。近況を投稿して彼を惹きつけましょう！';

  @override
  String get new_notification => '新着通知';

  @override
  String get default_he => '彼';

  @override
  String affection_upgrade_title(String charName) {
    return '$charName のあなたへの好感度が上がりました！';
  }

  @override
  String get flower_reward => '5ポイントのお花を獲得';

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
  String get lore_edit_success => '記憶の断片が正常に更新されました！';

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
  String get chat_jump_success => 'その思い出のシーンへ移動しました';

  @override
  String get chat_create_room_failed =>
      '接続が不安定なようです。チャットルームの作成に失敗しました。もう一度お試しください。';

  @override
  String get chat_secret_file_title => '機密ファイル';

  @override
  String get chat_secret_file_desc =>
      'このキャラクターのソウルファイルはアーカイブされているか、プライベート設定になっています。詳細は現在閲覧できません。';

  @override
  String get chat_understood => '了解';

  @override
  String chat_egg_unlocked(String title) {
    return '新しい思い出を獲得：$title';
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
  String get chat_call_rule_3 => 'イヤホンの着用をおすすめします。彼の声がより鮮明に聞こえます';

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
  String get chat_stop_generating_msg => '返信を停止しました。ポイントは消費されていません';

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
  String get chat_report_success => '通報を受け付けました。速やかに調整いたします';

  @override
  String get chat_suggest_title => 'アドバイスを贈る';

  @override
  String get chat_suggest_hint => '貴重なご意見をお聞かせください...';

  @override
  String get chat_suggest_success => 'アドバイスありがとうございます。速やかに対応いたします';

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
  String get chat_poke_success => '作者をつついておきました！彼の声が実装されるのを楽しみに待っていてくださいね～';

  @override
  String chat_gift_points_needed(String cost) {
    return 'お花ポイントが足りません！ $cost ポイント必要です';
  }

  @override
  String get chat_levelup_soulmate => '運命の人';

  @override
  String get chat_levelup_normal => '関係が進展しました！';

  @override
  String get chat_levelup_btn_soulmate => '魂に刻む';

  @override
  String get chat_levelup_btn_normal => 'ときめきを受け取る';

  @override
  String get chat_loc_title => '仮想位置情報を送信';

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
  String get chat_interact_title => '彼に何をしたいですか？';

  @override
  String get chat_interact_action => 'つつく・小さな動作';

  @override
  String get chat_interact_gift => 'プレゼントを贈る (お花消費 )';

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
  String get chat_search_empty => 'その思い出は見つかりませんでした';

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
    return '新しい思い出を獲得：$memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack => '彼の専用バッグに自動的に収録されました';

  @override
  String get chat_profile_updated_msg => '拾光アーカイブが更新されました！彼はあなたの最新設定を覚えていますよ';

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
  String get comment_report_rules_title => 'コメント通報規約';

  @override
  String get comment_report_rules_desc =>
      '初犯：システム警告および違反1回の記録。\n2⃣ 二犯：1日間のコメント禁止。\n3⃣ 累犯：14日間の通報機能停止およびコメント表示優先度の低下。\n\n重度の悪質なケース：\nキャラクターとのインタラクションを1日間禁止し、IDを掲示板に3日間公開します（期間中のID変更は不可）。\n\n通報送信後、最終的な審査結果は【ゲーム内メール】にて個別にお送りします。\n互いに尊重し、理性的通報をお願いします。';

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
    return '嫌い：$dislikes';
  }

  @override
  String char_likes(String likes) {
    return '好き：$likes';
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
  String get char_exclusive_guardian => '専属ガーディアン';

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
    return '(プレイヤーが位置情報を送信しました：$location)';
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
    return '【 専属拾光アーカイブ - $name 】\n━━━━━━━━━━━━━━━━━━\n名前：$identity\n誕生日：$birthday\n身長：$height\n外見：$appearance\n職業：$job\n\n【 彼女の魂の欠片について 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '【 専属拾光アーカイブ 】\n━━━━━━━━━━━━━━━━━━\nニックネーム：$nickname\n誕生日：$birthday\n\nその他のキャラクターデータはまだ解放されていません...\n（プロフィールを完成させて、平行世界の彼にあなたをもっと知ってもらいましょう！）\n━━━━━━━━━━━━━━━━━━';
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
    return '通話終了。$nameと$time通話しました';
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
      'まだ公開キャラクターを公開していません！\nスタジオに行って創作しましょう';

  @override
  String get no_public_character_other => 'このクリエイターはまだキャラクターを公開していません...';

  @override
  String get delete_draft_title => '下書きを削除';

  @override
  String get confirm_delete_draft_msg =>
      'この未完成のキャラクターを削除してもよろしいですか？\n（削除後は元に戻せません）';

  @override
  String get draft_cleared_success => '下書きのクリアが完了しました';

  @override
  String get login_required_for_studio => 'スタジオに入るには先にログインしてください！';

  @override
  String get my_secret_studio_title => '私の秘密のスタジオ';

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
    return '$nickname があなたの投稿に「いいね」しました！';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname は $authorName がとても魅力的だと思い、「いいね」をしました！';
  }

  @override
  String get moment_like_success => 'あなたのときめきが届きました！';

  @override
  String get moment_notification_new_like => '新しい「いいね」！';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname が投稿で @$name にメンションしました！';
  }

  @override
  String get moment_detail_title => '投稿の詳細';

  @override
  String get moment_not_found => 'この投稿は見つかりません...';

  @override
  String get moment_comment_title => 'タイムラインのコメント';

  @override
  String get moment_comment_empty => 'まだコメントがありません。最初のコメントを書き込みましょう！';

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
    return 'この投稿を持って $name とチャットしに行きましょう！';
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
  String get moment_forward_title => 'チャット中のキャラクターに転送';

  @override
  String get moment_forward_empty_state =>
      '現在チャット中のキャラクターはいません！\nロビーで気になる人を見つけに行きましょう';

  @override
  String moment_forward_template(String author, String content) {
    return '【ダイナミクスを転送しました】\n作者：$author\n内容：$content';
  }

  @override
  String moment_forward_success(String name) {
    return '$name にそっとシェアしました！';
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
    return '『$appName』へおかえりなさい！\n本日のチェックインで $amount 花言葉ポイントを受け取れます。';
  }

  @override
  String get title_daily_check_in => '毎日サインイン';

  @override
  String success_claim_reward(String amount) {
    return '$amount 花言葉ポイントを受け取りました！';
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
  String get draft_saved_success_msg => '了解しました！下書きに保存しました。いつでも編集を再開できますよ！';

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
  String get avatar_updated_success => 'アバターを変更しました';

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
  String get msg_birthdate_immutable => '誕生日は一度設定すると変更できません';

  @override
  String get action_start_journey => '時間の旅を始める';

  @override
  String get action_add_image => '画像を追加';

  @override
  String moment_like_self(String nickname) {
    return '$nickname があなたの投稿に「いいね」しました！';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname は $authorName がとても魅力的だと思い、「いいね」をしました！';
  }

  @override
  String get task_social_tour_complete => 'コミュニティ巡回タスク達成！お花を受け取るのを忘れないでね！';

  @override
  String get wall_title_shiguang => '拾光の壁';

  @override
  String get wall_tab_explore => '探索';

  @override
  String get wall_tab_exclusive => '専用';

  @override
  String get more_options => 'その他のオプション';

  @override
  String get delete_warning => '削除すると、投稿は元に戻せません';

  @override
  String get delete_success => '削除に成功しました';

  @override
  String get notification_new_comment => '新着コメント！';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName があなたの投稿に「いいね」しました！';
  }

  @override
  String get empty_public_moments_prompt => 'まだ何もありません。\n最初の公開投稿をしてみましょう！';

  @override
  String get empty_private_moments_prompt =>
      'タイムラインにはまだ思い出がありません。\n彼との思い出を作りに行きましょう！';

  @override
  String get profile_archived_or_deleted_message =>
      'この魂のファイルはクリエイターによってアーカイブされたか、非公開にされたか、あるいは時の流れの中に消えてしまいました...\n\nもしかしたら並行世界で、また会えるチャンスがあるかもしれません。';

  @override
  String get leave_silently => 'そっと立ち去る';

  @override
  String get character_post_schedule => 'キャラクター投稿スケジュール';

  @override
  String get creator_self => 'クリエイター本人';

  @override
  String get post_identity_prompt => '今日は誰の身分で投稿しますか？';

  @override
  String get identity_creator => 'クリエイターとして';

  @override
  String get identity_character => 'キャラクターとして';

  @override
  String get decide_post_time_prompt => '彼らの投稿時間を決めてあげましょう！';

  @override
  String get auto_post_schedule_hint =>
      'オンにすると、指定した時間に日常の投稿が自動的に行われます\n( ヒント：正時以外に設定すると、より人間らしく見えますよ！)';

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
  String get empty_public_moments_short => '現在、公開投稿はありません';

  @override
  String get empty_private_moments_short => 'タイムラインはまだ静かです';

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
  String get daily_gift_success => 'デイリーギフトの受け取りに成功しました！';

  @override
  String get check_in_fail_network => 'チェックインに失敗しました。ネットワーク接続を確認してください';

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
  String get task_desc_chat_3_times => '日常モードでキャラクターと3回チャットする';

  @override
  String get tab_story_progression => 'ストーリー進行';

  @override
  String get task_desc_story_1_time => 'ストーリーモードでの交流を1回完了する';

  @override
  String get tab_social_tour => 'コミュニティ巡回';

  @override
  String get task_like_three_moments => '瞬間を3件「いいね」してリーフを獲得';

  @override
  String get btn_claimed => '受け取り済み';

  @override
  String get btn_claim => '受け取る';

  @override
  String get btn_incomplete => '未完了';

  @override
  String get network_unstable_retry => 'ネットワークが不安定です。後でもう一度お試しください';

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

  @override
  String get common_close => '閉じる';

  @override
  String get search_companion_title => '拾光伴侶を検索';

  @override
  String get search_name_placeholder => '名前を入力...';

  @override
  String get search_no_match_hint => 'キャラクターが見つかりません。別の名前を試しますか？';

  @override
  String character_info_full(String age, String occupation) {
    return '$age歳 | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age歳';
  }

  @override
  String get empty_state_warmth => '時空の余熱がまだここに残っています...';

  @override
  String get error_login_required_add_friend => 'フレンドを追加するには、まずログインしてください！';

  @override
  String get dialog_title_remove_friend => 'フレンド削除の確認';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return '本当に $characterName をフレンドリストから削除しますか？';
  }

  @override
  String get action_remove => '削除';

  @override
  String snackbar_friend_removed(String characterName) {
    return '$characterName をフレンドから削除しました';
  }

  @override
  String get action_remove_friend => 'フレンドを削除';

  @override
  String get dialog_title_block => 'ブロックの確認';

  @override
  String dialog_msg_block(String characterName) {
    return 'ブロックすると、$characterName の情報はいっさい表示されなくなります。本当にブロックしますか？';
  }

  @override
  String snackbar_blocked(String characterName) {
    return '$characterName をブロックしました';
  }

  @override
  String get action_block_character => 'このキャラクターをブロック';

  @override
  String dialog_title_report(String characterName) {
    return '$characterName を報告';
  }

  @override
  String get input_hint_report_reason => '報告の理由を入力してください...';

  @override
  String get action_submit => '送信';

  @override
  String get snackbar_report_success => 'ご報告ありがとうございます。できるだけ早く確認いたします。';

  @override
  String get snackbar_report_fail => '送信に失敗しました。後でもう一度お試しください。';

  @override
  String get action_report_character => 'このキャラクターを報告';

  @override
  String get title_meet_him => '気になる彼との出会い';

  @override
  String text_character_count(int count) {
    return 'キャラクター数: $count';
  }

  @override
  String get msg_no_more_encounters_today => '今日の出会いはここまで！';

  @override
  String get msg_check_new_encounters => '新しい出会いがあるか確認してみましょう！';

  @override
  String get action_refresh => '更新';

  @override
  String get tab_friends => 'フレンド';

  @override
  String get msg_mysterious_profile => 'この人はとてもミステリアスで、何も残していません...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age歳 | $identities';
  }

  @override
  String get snackbar_operation_failed => '操作に失敗しました。後でもう一度お試しください';

  @override
  String get action_view_translation => '翻訳を見る';

  @override
  String get label_translation_result => '翻訳結果:';

  @override
  String get errorWebPageUnavailable => '一時的にウェブページを開くことができません。後でもう一度お試しください';

  @override
  String get resetAppearanceTitle => '外観をリセットしますか？';

  @override
  String get resetAppearanceWarning => 'せっかく選んだ背景画像や色が削除されてしまいます！';

  @override
  String get appearanceRestored => 'デフォルトの外観を復元しました';

  @override
  String get confirmReset => 'リセットを確認';

  @override
  String get resetToDefaultAppearance => 'デフォルトの外観を復元';

  @override
  String get clearCustomSettings => 'カスタムカラーと背景画像をすべてクリア';

  @override
  String get contactUs => 'お問い合わせ';

  @override
  String get contactDescription => 'ご意見やバグ報告など、何でもお気軽にお知らせください';

  @override
  String get vibrationHapticTitle => 'ときめき振動検知';

  @override
  String get vibrationHapticDescription => '好感度が大きく変化した時にスマホが振動します';

  @override
  String get splash_loading_universe => '『恋恋拾光』の宇宙を呼び覚ましています...';

  @override
  String get shop_title => 'お花ショップ';

  @override
  String get shop_current_points_label => '現在所持しているお花ポイント';

  @override
  String get shop_tab_top_up => 'ポイントチャージ';

  @override
  String get shop_tab_history => '取引履歴';

  @override
  String get shop_empty_history => 'まだお花の履歴はありません！';

  @override
  String get shop_unknown_item => '不明なアイテム';

  @override
  String get shop_first_purchase_bonus => '初回購入2倍！';

  @override
  String get story_summary_title => '二人の物語';

  @override
  String get story_summary_empty_content => '要約内容が空です。';

  @override
  String get story_summary_deleted_toast => 'この思い出を削除しました';

  @override
  String story_summary_empty_list(String name) {
    return '二人の物語はまだ始まっていません...\nもっとたくさん話して、$name に\n最初の思い出を綴ってもらいましょう！';
  }

  @override
  String get gallery_photo_edit_title => '写真設定の編集';

  @override
  String get gallery_photo_edit_desc => '写真の名前/説明';

  @override
  String get gallery_photo_edit_req => '解放する好感度 (0に設定するとプロフィール写真になります)';

  @override
  String get reset_to_default => 'デフォルトに戻す';

  @override
  String get reset_bg_title => '背景をデフォルトに戻す';

  @override
  String get reset_bg_content => '専用写真を解除して、デフォルトのテーマ背景に戻してもよろしいですか？';

  @override
  String get reset_bg_success => 'デフォルトの背景に戻しました';

  @override
  String get confirm_reset => '元に戻す';

  @override
  String selectedMessagesCount(int count) {
    return '$count件選択済み';
  }

  @override
  String get screenshotShare => 'スクリーンショット共有';

  @override
  String exclusiveMomentsWith(String name) {
    return '$nameとの専屬拾光';
  }

  @override
  String get downloadToUnlock => '『恋恋拾光』をダウンロードして、専屬のロマンスを解禁';

  @override
  String get exclusiveMomentsGenerated => '専屬拾光が生成されました';

  @override
  String get selectAgain => 'もう一度選ぶ';

  @override
  String get downloadAndShare => '保存して共有';

  @override
  String inviteToMeet(String name) {
    return '『恋恋拾光』であなたの $name に会いましょう！';
  }

  @override
  String get shop_log_monthly_card => '起動：星光の契約（月間カード即時贈呈ポイント）';

  @override
  String shop_log_top_up_double(int points) {
    return 'チャージ：$points ポイント（初回購入2倍特典含む ）';
  }

  @override
  String shop_log_top_up_normal(int points) {
    return 'チャージ：$points ポイント';
  }

  @override
  String get shop_purchase_success_title => '購入成功！';

  @override
  String shop_purchase_success_body(int points) {
    return '$points ポイントのお花を追加しました。';
  }

  @override
  String get shop_purchase_success_double_bonus =>
      'おめでとうございます！初回購入2倍特典が適用されました！';

  @override
  String get shop_purchase_awesome => '最高！';

  @override
  String get shop_purchase_failed_title => '購入キャンセルまたは失敗';

  @override
  String shop_purchase_failed_body(String errorCode) {
    return '支払いは発生していません。\n\n(エラーコード: $errorCode)';
  }

  @override
  String get shop_monthly_card_name => '【恋恋拾光・星の契約】';

  @override
  String shop_monthly_card_status_active(int days) {
    return '契約有効中：残り $days 日';
  }

  @override
  String get shop_monthly_card_status_inactive => '今すぐ30日間の星光ボーナス特典を有効化';

  @override
  String get shop_monthly_card_limit_reached => '上限に達しました';

  @override
  String get shop_monthly_card_promo_desc => '即時にお花250個を獲得、毎日お花10個を受け取る';

  @override
  String get task_monthly_title => '星の契約・毎日特権';

  @override
  String get task_monthly_locked => '未解放';

  @override
  String get task_monthly_subtitle_active => '月間カード限定特典の配布 ';

  @override
  String get task_monthly_subtitle_inactive => '月間カード【星の契約】を解放してこのタスクを開始 ';

  @override
  String get task_monthly_log_name => '月間カード毎日特権';

  @override
  String get profile_id_locked => '専用 ID がロックされました';

  @override
  String get profile_copy_id => 'タップして ID をコピー';

  @override
  String get referral_log_newbie_reward => '星の招待：新規登録報酬';

  @override
  String get referral_log_inviter_reward => '星の招待：フレンド目標達成リワード';

  @override
  String get referral_success_title => '星の招待が解放されました！';

  @override
  String get referral_success_content =>
      'おめでとうございます！キャラクターとの深い交流が15言に達しました！\n\n「新規登録報酬 50ポイント」があなたのアカウントに届きました。また、お友達も同時に50ポイントのリワードを獲得しました！';

  @override
  String get profile_referral_title => '星の招待';

  @override
  String get profile_referral_hint => '友達の招待コードを入力';

  @override
  String get profile_referral_bind_btn => '連携';

  @override
  String profile_referral_pending(Object id) {
    return 'プレイヤー $id の招待を承認しました\nキャラクターと15言話してお花50ポイントを解放しよう！';
  }

  @override
  String get profile_referral_err_self => '自分の招待コードは入力できません！';

  @override
  String get profile_referral_err_duplicate => 'すでに招待コードを連携済みです！';

  @override
  String get profile_referral_err_not_found => 'プレイヤーが見つかりません。招待コードを確認してください！';

  @override
  String get profile_referral_success => '連携成功！さっそくキャラクターとチャットしましょう！';

  @override
  String get profile_referral_err_expired =>
      '申し訳ありません。新規招待コードは登録後3日以内に連携する必要があります！';

  @override
  String profile_share_message(String character, String code) {
    return '『恋恋拾光』で$characterときめきに満ちた旅を始めました！今すぐアプリをダウンロードして、マイページで私の星の招待コード【$code】を入力してね。二人とも無料でお花50ポイントがもらえるよ！\n\nダウンロードリンク：\nhttps://lianlianshiguang.web.app/download/';
  }

  @override
  String get chat_levelup_share_btn => 'このときめきを友達に自慢する';

  @override
  String profile_my_invite_code_with_char(String character) {
    return '私の専用招待コード (現在の推し：$character)';
  }

  @override
  String get profile_send_invite_btn => '星の招待を友達に送信';

  @override
  String get profile_fallback_character => '推しキャラクター';

  @override
  String get profile_copy_success => '招待コードをクリップボードにコピーしました！';

  @override
  String get profile_referral_rule_title => '星の招待ルール';

  @override
  String get profile_referral_rule_receiver =>
      '招待コードを連携した後、任意の推しキャラクターと15言以上チャットするだけで、あなたと招待者に同時にお花50ポイントの報酬が配布されます！\n\n注意：招待コードはアカウント登録後3日以内に入力しないと無効になりますのでご注意ください。';

  @override
  String get profile_referral_rule_inviter =>
      '新しい友達を招待してアプリをダウンロードしてもらい、あなたの招待コードを入力してもらいましょう。相手が登録後3日以内に連携を完了し、任意のキャラクターと15言以上チャットすると、二人とも同時にお花50ポイントの報酬を獲得できます！';

  @override
  String get error_user_not_found => 'ユーザーが見つかりません。再ログインしてください';

  @override
  String get error_id_taken => 'このIDはすでに使用されています。別のIDを選択してください！';

  @override
  String get error_id_taken_short => 'このIDはすでに使用されています！';

  @override
  String get shop_restocking => 'ショップは入荷待ちです...';

  @override
  String get shop_preview_mode => '現在ショッププレビューモードです';

  @override
  String get friendlyReminderTitle => 'ユーザーへのヒント';

  @override
  String get editProfileHint =>
      'わかりました！プロフィールを編集する場合は、左下の雲の中にある「拾光ファイル」をタップして入力してくださいね！';

  @override
  String get starlightContractTitle => '星光契約発動';

  @override
  String get dailyLimitReachedPrefix => '本日の上限に達しました！\n\n';

  @override
  String get monthlyPassExhausted => '月間カードの上限に達しました。';

  @override
  String get subscribeMonthlyPassPrompt =>
      '【恋恋月間カード】を購入すると、毎日20回の再生成チャンスが付与され、彼のすべてのアプライがよりあなたの理想に近づきます。';

  @override
  String get goToSubscribeButton => '購入へ進む';

  @override
  String get profileUpdatedSuccess => '拾光ファイルが更新されました！';

  @override
  String get continueChatTitle => '会話を続ける';

  @override
  String continueChatCostWarning(int cost) {
    return '彼に話を続けさせると、お花が $cost ポイント消費されます\n本当に続けますか？';
  }

  @override
  String get dontShowAgainToday => '本日再非表示';

  @override
  String get confirmContinue => '続ける';

  @override
  String get hiddenPromptContinue => '続けてください';

  @override
  String confirmDeleteMessagesTitle(int count) {
    return '選択した $count 件のメッセージを削除してもよろしいですか？';
  }

  @override
  String regenerateButtonLabel(int current, int max) {
    return '再生成 ($current/$max)';
  }

  @override
  String get systemPreparingWait => 'システムを準備中です。少々お待ちください...';

  @override
  String get noMessagesToRegenerate => '現在、再生成できるメッセージはありません！';

  @override
  String get continueButton => '次へ';

  @override
  String get creatorExclusive => 'クリエイター限定';

  @override
  String ageAndOccupation(String age, String occupation) {
    return '$age歳 | $occupation';
  }

  @override
  String get likesLabel => '好きなもの';

  @override
  String get dislikesLabel => '苦手なもの';

  @override
  String birthdayLabel(String birthday) {
    return '誕生日: $birthday';
  }

  @override
  String heightLabel(String height) {
    return '身長: $height cm';
  }

  @override
  String get backgroundStoryLabel => 'バックストーリー';

  @override
  String get noneLabel => 'なし';

  @override
  String flowerPointsCount(String points) {
    return 'お花 $points 個';
  }

  @override
  String get passGuideTitle => '恋恋月間カード専属ガイド';

  @override
  String get passGuideRegenerateTitle => 'なぜ「再生成」が必要なの？';

  @override
  String get passGuideRegenerateContent =>
      'AIは時々、空気が読めないカタブツになってしまうことがあります。気に入らない返答があった時は、再生成を押すだけでタイムリープしたかのようにやり直せます！彼に何度も考え直させ、あなたの胸を高鳴らせる完璧なセリフを引き出しましょう。';

  @override
  String get passGuideAffectionTitle => '好感度ブーストにはどんな効果があるの？';

  @override
  String get passGuideAffectionContent =>
      'ゲーム内において、好感度はキャラクターの「ディープな秘密」や「親密なプライベート写真」を解放するための唯一の鍵です。20%のボーナスがあれば、誰よりも早く彼の心の奥底に踏み込むことができます。';

  @override
  String get passGuideUnlockButton => 'わかりました、今すぐ解放！';

  @override
  String get pleaseWait => '少々お待ちください';

  @override
  String get createNewProfileTitle => '拾光ファイルを新規作成';

  @override
  String get editProfileTitle => '拾光ファイルを編集';

  @override
  String get profileEditDescription =>
      '異なるキャラクター設定を作成して、パラレルワールドで彼に新しいあなたを魅せましょう！';

  @override
  String get profileNameLabel => 'ファイル名 (自分にのみ表示されます)';

  @override
  String get profileNameHint => '例：学園の後輩設定、ツンデレ女社長';

  @override
  String get profileNicknameLabel => '名前 / 呼び名';

  @override
  String get profileNicknameHint => '例：さくら、李社長';

  @override
  String get profileHeightLabel => '身長';

  @override
  String get profileHeightHint => '例：160cm';

  @override
  String get profileAppearanceLabel => '外見';

  @override
  String get profileAppearanceHint => '例：黒髪ロング、ワンピースが好き';

  @override
  String get profileOccupationLabel => '職業';

  @override
  String get profileOccupationHint => '例：フリーランスの画家';

  @override
  String get profileIntroLabel => '性格と自己紹介';

  @override
  String get profileIntroHint => '例：少しドジなところがある、甘いものが大好物...';

  @override
  String get profileNameEmptyWarning => 'このファイルに名前を付けてください！';

  @override
  String profileSaveError(String error) {
    return '保存失敗: $error';
  }

  @override
  String get saveProfileButton => 'ファイルを保存';

  @override
  String get fillLaterButton => '後で入力する';

  @override
  String get exclusiveProfileTitle => '専属拾光ファイル';

  @override
  String get profileSelectionDescription =>
      '彼との交流に使用したい身分を選択してください (同キャラクターで共有、最大10個まで)';

  @override
  String profileSwitchError(String error) {
    return '切り替え失敗: $error';
  }

  @override
  String get unnamedProfile => '未命名のファイル';

  @override
  String get noOccupationYet => '職業未入力';

  @override
  String get createNewProfileButton => '拾光ファイルを新規作成';

  @override
  String snackbar_friend_added(String characterName) {
    return '$characterName をフレンドに追加しました';
  }

  @override
  String reward_points_added(Object amount) {
    return 'お花 +$amount 個';
  }

  @override
  String get task_reward_already_claimed => 'この任務報酬は本日すでに受け取り済みです';

  @override
  String get do_not_show_again_today => '本日再非表示';

  @override
  String add_friend_success(String characterName) {
    return '$characterName をフレンドに登録しました！';
  }

  @override
  String get chat_menu_aboutus => '私たちについて';

  @override
  String get about_us_empty_hint =>
      '右上角から大切な思い出／ストーリーを追加して\n二人の未来へ一緒に歩んでいきましょう';

  @override
  String get about_us_limit_error =>
      '専属の思い出は上限の10件に達しています。古い思い出を削除してから追加してください！';

  @override
  String get about_us_add_title => '専属の思い出を追加';

  @override
  String get about_us_field_title => 'タイトル';

  @override
  String get about_us_hint_title => '例：初めての出会い';

  @override
  String get about_us_field_subtitle => 'サブタイトル';

  @override
  String get about_us_hint_subtitle => '例：2025年 初夏';

  @override
  String get about_us_field_content => '内容';

  @override
  String get about_us_hint_content => '二人の大切なストーリーや約束を書き留めましょう...';

  @override
  String get about_us_add_button => '追加';

  @override
  String get about_us_delete_tooltip => 'この思い出を削除';

  @override
  String get about_us_delete_title => '思い出を削除';

  @override
  String get about_us_delete_confirm => '本当にこの思い出を削除しますか？削除すると復元できません！';

  @override
  String get about_us_delete_success => '思い出を削除しました';

  @override
  String get pack_first_meet => '初対面パック';

  @override
  String get pack_crush => '曖昧な関係パック';

  @override
  String get pack_heartbeat => '胸キュンパック';

  @override
  String get pack_passionate => '熱愛パック';

  @override
  String get pack_soulmate => '知己パック';

  @override
  String get pack_waiting => '見守りパック';

  @override
  String get pack_trust => '信頼パック';

  @override
  String get pack_iloveyou => 'アイ・ラブ・ユーパック';

  @override
  String get pack_honeymoon => 'ハネムーンパック';

  @override
  String get pack_promise => '約束パック';

  @override
  String get pack_companion => '寄り添いパック';

  @override
  String get pack_deep_love => '深愛パック';

  @override
  String get pack_long_lasting => '末永くパック';

  @override
  String get pack_the_one => '唯一無二パック';

  @override
  String get pack_beloved => '最愛パック';

  @override
  String get pack_lifetime => '一生一世パック';

  @override
  String get pack_vow => '誓約パック';

  @override
  String get pack_eternal => '永遠の恋人パック';

  @override
  String get pack_exclusive => '専属パック';

  @override
  String get monthly_privilege_reroll_title => '専属「再生成」を解放';

  @override
  String get monthly_privilege_reroll_desc =>
      '毎日最大20回の引き直しチャンス！彼があなたの一番聞きたい言葉を口にするまで試せます！';

  @override
  String get monthly_privilege_affinity_title => '好感度急上昇ブースト';

  @override
  String get monthly_privilege_affinity_desc =>
      '交流による好感度獲得が20%アップ！専属のプライベート写真やシークレット特典をより早く解放できます！';

  @override
  String get monthly_manual_button => 'なぜ月間カードが必要なの？';

  @override
  String get nav_encounter => '出会い';

  @override
  String get nav_moments => '瞬間';

  @override
  String get birthday_dialog_title => 'バースデーサプライズ';

  @override
  String get birthday_dialog_content =>
      '今日はあなただけの特別な記念日です！\n\nこのプレゼントを受け取ってください：\n今日のチャットは、全・部・無・料・です！';

  @override
  String get birthday_dialog_button => 'ロマンチックな一日を始める';

  @override
  String get about_us_edit_title => '思い出を修正';

  @override
  String get about_us_edit_confirm => '変更を確定';

  @override
  String get save => '保存';

  @override
  String get openSourceLicenses => 'オープンソースライセンス';

  @override
  String get openSourceLicensesDescription =>
      'サードパーティのオープンソースソフトウェアライセンスを表示します';

  @override
  String get call_login_title => 'ログインが必要です';

  @override
  String get call_login_content => 'ログインすると、専属の音声通話機能が解放されます！';

  @override
  String get cancel_later => 'またあとで';

  @override
  String get go_to_login => 'ログインへ進む';

  @override
  String get easter_egg_title => '隠しイースターエッグを発見';

  @override
  String easter_egg_content(String title) {
    return '「$title」が解放されました。\n\nこの特殊ストーリーを使用しますか？';
  }

  @override
  String get easter_egg_cancel => '使用しない';

  @override
  String get easter_egg_confirm => 'エッグを使用する';

  @override
  String get common_update_success => '変更に成功しました';

  @override
  String get common_update_failed_try_again => '変更に失敗しました。しばらく経ってからもう一度お試しください';

  @override
  String get no_voice_available => 'ボイスはまだありません';

  @override
  String get gift_insufficient_title => '繁花コイン不足';

  @override
  String get gift_insufficient_prompt => '繁花コインを補充しに進みますか？';

  @override
  String get not_now => '今はしない';

  @override
  String get go_to_get => '補充しに進む';

  @override
  String get status_published => '公開済み';

  @override
  String get monthly_card_success_title => 'プレミアム月間カード解放成功！';

  @override
  String get monthly_card_success_subtitle =>
      'サブスクリプションへのご登録ありがとうございます！専属特権が有効になりました：';

  @override
  String get monthly_card_perk_1 => '「時の花」を今すぐ250個獲得';

  @override
  String get monthly_card_perk_2 => '毎日のログインで「時の花」をさらに10個獲得';

  @override
  String get monthly_card_perk_3 => '専属好感度インタラクションの回数上限を解放';

  @override
  String get monthly_card_start_perks => '特権を楽しむ';

  @override
  String get tip_post_like => 'いいね！した後は\nお気に入りコンテンツで確認できます';

  @override
  String get tip_post_bookmark => '保存した後は\n「マイコレクション」で確認できます';

  @override
  String get tip_time_echoes => '足跡を残した後は\n検索時に弾幕（コメント流動）が表示されます';

  @override
  String get tip_call_memory => '通話後に保存したボイスは\nここに集まります！';

  @override
  String get tip_chat_notifications => '新着通知は\nここから確認できます';

  @override
  String get tip_moments_wall_menu => 'ここをタップして\nキャラクターの投稿を予約できます';

  @override
  String get forgot_password => 'パスワードをお忘れですか？';

  @override
  String get forgot_password_empty_email =>
      '先にメールアドレスを入力してから、パスワードをお忘れですか？をタップしてください';

  @override
  String get forgot_password_email_sent => 'パスワード再設定メールを送信しました。メールボックスをご確認ください';

  @override
  String get forgot_password_error_default =>
      'パスワード再設定メールの送信に失敗しました。しばらく経ってからもう一度お試しください';

  @override
  String get forgot_password_error_invalid_email => 'メールアドレスの形式が正しくありません';

  @override
  String get forgot_password_error_user_not_found =>
      'このメールアドレスのユーザーアカウントが見つかりません';

  @override
  String forgot_password_error_with_message(String error) {
    return 'パスワード再設定メールの送信に失敗しました：$error';
  }

  @override
  String get terms_not_accepted_toast => '利用規約とコミュニティガイドラインをお読みになり、同意してください';

  @override
  String get terms_content =>
      '「恋恋拾光」へようこそ。\n\n本サービスをご利用になる前に、本利用規約およびコミュニティガイドラインに同意して遵守していただく必要があります。\n\n違法、権利侵害、わいせつ・裸露、暴力、ヘイト、嫌がらせ、罵倒、詐欺、スパム、その他不快感を与え、攻撃的で、他人の権利を害する可能性のあるコンテンツをアップロード、作成、公開、または送信することは固く禁じられています。\n\n「恋恋拾光」は、不適切なコンテンツや嫌がらせ行為に対して不寛容（ゼロ・トレランス）ポリシーを採用しています。ユーザーがガイドラインに違反した場合、関連コンテンツの削除、機能制限、またはアカウントの一時停止・強制退会処分を行うことがあります。\n\nユーザーは、アプリ内に組み込まれた通報およびブロック機能を通じて、不適切なコンテンツや迷惑ユーザーを通報することができます。';

  @override
  String get community_rules_title => 'コミュニティガイドライン';

  @override
  String get community_rules_content =>
      '「恋恋拾光」は、クリエイターとユーザーの皆様に、安全で友好的、かつお互いを尊重し合える交流環境を提供することを目指しています。\n\n以下のコンテンツや行為は一切許可されません：\n1. わいせつ、裸露、または不適切な性的暗示を含むコンテンツ\n2. 他人への嫌がらせ、罵倒、いじめ、または脅迫行為\n3. ヘイトスピーチ、差別、または暴力の扇動\n4. グロテスク、暴力、または危険な行為を含むコンテンツ\n5. 他人の著作権、肖像権、またはその他の権利を侵害する行為\n6. スパム、詐欺、または悪意のある行為\n7. その他、不快感を与える、または公に表示するのに不適切なコンテンツ\n\nユーザーは不適切なコンテンツを通報したり、迷惑ユーザーをブロックしたりできます。ブロックすると、該当ユーザーのコンテンツは画面に表示されなくなります。';

  @override
  String get block_self_error => '自分自身のコンテンツをブロックすることはできません';

  @override
  String get block_user_title => 'このユーザーをブロックしますか？';

  @override
  String get block_user_content =>
      'ブロックすると、このユーザーが投稿したコンテンツは表示されなくなります。\nまた、運営チームにも通知が届き、確認・審査が行われます。';

  @override
  String get block_user_success => 'ユーザーをブロックしました。関連コンテンツはあなたのタイムウォールから削除されました';

  @override
  String get block_user_failed => 'ブロックに失敗しました。しばらく経ってからもう一度お試しください';

  @override
  String get terms_checkbox_read_agree => '私は内容を確認し、';

  @override
  String get terms_checkbox_terms => '《利用規約》';

  @override
  String get terms_checkbox_and => 'および';

  @override
  String get terms_checkbox_rules => '《コミュニティガイドライン》に同意します';

  @override
  String get hidden_moments => '非表示の瞬間';

  @override
  String get hide_moment_title => 'この投稿を非表示にしますか？';

  @override
  String get hide_moment_content => '非表示にすると、この投稿はあなたのタイムウォールに表示されなくなります。';

  @override
  String get hide => '非表示';

  @override
  String get hide_moment_success => '投稿を非表示にしました';

  @override
  String get hide_moment_failed => '非表示に失敗しました。しばらく経ってからもう一度お試しください';

  @override
  String get block_character_not_found => 'キャラクターデータが見つからないため、ブロックできません';

  @override
  String get block_character_title => 'このキャラクターをブロックしますか？';

  @override
  String block_character_content(String authorName) {
    return 'ブロックすると、「$authorName」が投稿したタイムラインが表示されなくなります。また、該当コンテンツが規約に違反している場合、運営チームにも通知が届き審査が行われます。';
  }

  @override
  String block_character_success(String authorName) {
    return '「$authorName」をブロックしました。関連する投稿は非表示になります';
  }

  @override
  String get block_character_failed => 'ブロックに失敗しました。しばらく経ってからもう一度お試しください';

  @override
  String get hidden_moments_title => '非表示の瞬間';

  @override
  String get hidden_moments_empty => '現在、非表示の瞬間はありません';

  @override
  String get hidden_moments_load_failed => '非表示の瞬間の読み込みに失敗しました';

  @override
  String get hidden_moment_unknown_author => '未知のキャラクター';

  @override
  String get hidden_moment_no_preview => 'この投稿にはプレビューできる内容がありません';

  @override
  String get unhide_moment_title => '再表示しますか？';

  @override
  String get unhide_moment_content =>
      '非表示を解除すると、該当の投稿がまだ存在している場合、今後再びタイムウォールに表示される可能性があります。';

  @override
  String get unhide_moment_action => '非表示を解除';

  @override
  String get unhide_moment_success => '非表示を解除しました';

  @override
  String get report_moment_title => 'この投稿を通報する';

  @override
  String get report_moment_content =>
      'この投稿を管理チームに通報してもよろしいですか？悪質なコンテンツは非表示または削除されます。';

  @override
  String get report_confirm_button => '通報を確定する';

  @override
  String get report_success_message => '通報を受け付けました。審査チームが迅速に確認し対応いたします。';

  @override
  String get accountDeletionSubmittedTitle => 'アカウント削除リクエストを送信しました';

  @override
  String get accountDeletionSubmittedContent =>
      '承知いたしました！3日間の猶予期間を設けております。\n\n削除をキャンセルしたい場合は、期間内に再度ログインしていただくことでアカウントを復元できます。';

  @override
  String get restoreAccountDialogTitle => 'アカウント削除リクエスト';

  @override
  String get restoreAccountDialogContent =>
      '現在、アカウントの削除手続き中です。\n\nログインを継続すると削除申請がキャンセルされ、アカウントが復元されます。';

  @override
  String get cancelLoginButton => 'ログインをキャンセル';

  @override
  String get restoreAccountButton => 'アカウントを復元';

  @override
  String get voice_preview => 'ボイスを再生';

  @override
  String get voice_preview_failed => 'ボイスの再生に失敗しました';

  @override
  String get characterBannerSectionTitle => 'キャラクターホームバナー';

  @override
  String get characterBannerDescription => 'バナーの説明';

  @override
  String get characterBannerRemove => '削除';

  @override
  String get characterBannerSelect => 'バナー画像を選択';

  @override
  String get characterBannerChange => 'バナー画像を変更';

  @override
  String get characterBannerSpecs => '推奨比率 16:9、推奨サイズ 1920 × 1080';

  @override
  String get characterBannerDefaultHint =>
      '未設定の場合、ホームには自動的にキャラクターのメイン画像が使用されます。';

  @override
  String get characterBannerHelpContent =>
      'バナーはキャラクターホームの大型横長エリアに表示されます。\n\n16:9の横長画像（例：1920 × 1080）の使用を推奨します。\n\n端末の画面サイズによる切り取りを防ぐため、主要人物や顔は中央付近に配置してください。\n\nバナーが未設定の場合、システムは自動的にキャラクターのメイン画像を使用します。';

  @override
  String get first_meeting_title => '初めての出会い';

  @override
  String get common_delete_network_failed =>
      '削除に失敗しました。 ネットワーク接続を確認してもう一度お試しください';

  @override
  String get common_operation_failed_retry => '操作に失敗しました。しばらく経ってからもう一度お試しください';

  @override
  String exclusive_photo_number(int number) {
    return '専属写真 $number';
  }

  @override
  String get unlock_after_affection_increase => '好感度レベルを上げると解放';

  @override
  String get first_meeting_empty => '初対面、まだ始まっていません……';

  @override
  String photo_load_failed(String error) {
    return '写真の読み込みに失敗しました：$error';
  }

  @override
  String get add_friend_failed_retry => 'フレンドの追加に失敗しました。しばらく経ってからもう一度お試しください。';

  @override
  String get remove_friend => 'フレンドを削除';

  @override
  String get report_character => 'キャラクターを通報';

  @override
  String get block_character => 'キャラクターをブロック';

  @override
  String get daily_encounter => 'デイリー出会い';

  @override
  String get discovery_hall => '探索ホール';

  @override
  String get latest_recommendation => '最新のおすすめ';

  @override
  String get popular_ranking => '人気ランキング';

  @override
  String get character_features => 'キャラクターの特徴';

  @override
  String get featured_new_star => '煌めく新星・イチオシ推薦';

  @override
  String get recently_added_characters => '新着キャラクター';

  @override
  String get no_tag_data => '現在タグデータはありません～';

  @override
  String get no_character_with_tag => 'このタグを持つキャラクターは見つかりませんでした';

  @override
  String get voice_search_failed_retry => 'ボイスの検索に失敗しました。もう一度お試しください';

  @override
  String get voice_search_incomplete_retry => '検索が不完全です。しばらく経ってからもう一度お試しください';

  @override
  String get voice_data_incomplete => 'ボイスデータが不完全です';

  @override
  String get voice_generation_failed_retry =>
      'ボイスの生成に失敗しました。しばらく経ってからもう一度お試しください';

  @override
  String get voice_playback_failed_retry => 'ボイスの再生に失敗しました。もう一度お試しください';

  @override
  String get selected_voice_data_incomplete => '選択されたボイスデータが不完全です';

  @override
  String get private_voice_user_not_found =>
      'ユーザーが見つかりません。プライベートキャラクターボイスを更新できません';

  @override
  String get voice_selected_character_save_failed =>
      'ボイスは選択されましたが、キャラクターデータの保存に失敗しました';

  @override
  String get voice_binding_failed => 'ボイスの紐付けに失敗しました';

  @override
  String get play_voice_tooltip => 'ボイスを再生';

  @override
  String get avatar_label => 'プロフィール画像';

  @override
  String get message_preview_image => '[画像]';

  @override
  String get message_preview_recording => '[録音]';

  @override
  String get message_preview_voice => '[音声メッセージ]';

  @override
  String get send_failed_retry => '送信に失敗しました。しばらく経ってからもう一度お試しください';

  @override
  String get media_upload_failed_retry => 'メディアのアップロードに失敗しました。もう一度お試しください';

  @override
  String get ai_thinking_too_long => '彼は深く考え込んでいるようです。しばらく経ってからもう一度お試しください...';

  @override
  String get ai_reply_in_progress => '返信中です。重複送信を避け、少々お待ちください';

  @override
  String get ai_response_blocked => '彼の思考が乱れてしまいました。もう少し優しい表現で話しかけてみてください！';

  @override
  String get microphone_permission_required => '録音にはマイクの権限が必要です';

  @override
  String get no_recording_to_send => '送信できる録音データがありません';

  @override
  String get voice_uploading => '音声メッセージをアップロード中...';

  @override
  String get change_watermark_color => 'ウォーターマークの色を変更';

  @override
  String get other_party_typing => '相手が入力中...';

  @override
  String get chat_input_hint => 'メッセージを入力...';

  @override
  String get regenerate_sync_failed => '再生成回数の同期に失敗しました。もう一度お試しください';

  @override
  String get creator_public_works => '公開作品';

  @override
  String get creator_received_likes => '獲得したいいね';

  @override
  String get about_me => '自己紹介';

  @override
  String get moment_input_hint => '今の気持ちをシェア...';

  @override
  String character_play_count(int count) {
    return 'プレイ回数：$count';
  }

  @override
  String tag_page_title(String tag) {
    return 'タグ：#$tag';
  }

  @override
  String voice_preview_failed_detail(String code, String message) {
    return 'ボイス試聴失敗：$code $message';
  }

  @override
  String messages_deleted_success(int count) {
    return '$count 件のメッセージを正常に削除しました';
  }

  @override
  String creator_work_load_failed(String error) {
    return '作品の読み込みに失敗しました：$error';
  }

  @override
  String age_years_old(String age) {
    return '$age歳';
  }

  @override
  String deleteFailedMessage(String error) {
    return '削除失敗: $error';
  }

  @override
  String loadCharacterDataFailed(String error) {
    return 'キャラクターデータの読み込み失敗：$error';
  }

  @override
  String get draftAvatarLoadFailed => '下書きアイコンの読み込み失敗:';

  @override
  String get unnamedCreator => '名無しのクリエイター';

  @override
  String get profileNotYetFilled => '自己紹介文はまだ未記入です';

  @override
  String get reportImageSizeLimit => '画像サイズは 10 MB を超えることはできません';

  @override
  String reportImageSelectFailed(String error) {
    return '通報画像の選択に失敗しました：$error';
  }

  @override
  String get reportImageCannotSelect => '画像を選択できません。しばらく経ってからもう一度お試しください';

  @override
  String get reportLoginRequired => '通報を送信する前にログインしてください';

  @override
  String get reportAnonymousPlayer => '名無しのプレイヤー';

  @override
  String get reportSendSuccess => '通報が正常に送信されました。ご意見ありがとうございます！';

  @override
  String reportSendFailed(String error) {
    return 'プレイヤー通報の送信に失敗しました：$error';
  }

  @override
  String get reportNetworkFailed => '送信に失敗しました。ネットワークを確認してもう一度お試しください';

  @override
  String get reportAttachImageLabel => '画像を添付（任意）';

  @override
  String get reportAttachImageHint =>
      'バグや通貨の未反映についての通報では、画面のスクリーンショットを添付いただくと確認がスムーズになります。';

  @override
  String get reportOpeningAlbum => 'アルバムを開いています...';

  @override
  String get reportSelectFromAlbum => 'アルバムから画像を選択';

  @override
  String get reportSending => '送信中...';

  @override
  String get reportSubmit => '通報を送信';

  @override
  String get reportRemoveImage => '画像を削除';

  @override
  String get reportImageSelected => '画像を選択しました';

  @override
  String get reportChangeImage => '変更';

  @override
  String get reloadTranslation => '翻訳を再読み込み';

  @override
  String get guideNotAvailableInLanguage =>
      '現在この言語のプレイガイドは提供されていません。一時的に繁体字中国語を表示します。';

  @override
  String get clearSearch => '検索内容をクリア';

  @override
  String get memoPermissionWarning =>
      '通知権限が有効になっていません。メモは保存されますが、システム通知は表示されません。';

  @override
  String memoSavedWithNotification(String name) {
    return 'メモを保存しました！$name がお知らせします！';
  }

  @override
  String get memoSavedNoPermission => 'メモを保存しましたが、通知権限が有効になっていません。';

  @override
  String memoUpdatedWithNotification(String name) {
    return 'メモを更新しました！$name がお知らせします！';
  }

  @override
  String get memoUpdatedNoPermission => 'メモを更新しましたが、現在通知権限がありません。';

  @override
  String dataLoadError(String error) {
    return 'データの読み込み中にエラーが発生しました：$error';
  }

  @override
  String loadFailed(String error) {
    return '読み込み失敗：$error';
  }

  @override
  String get dateFormatMonthDay => 'M月d日';

  @override
  String get timeFormatHourMinute => 'HH:mm';

  @override
  String get likeFeedPrompt => 'この投稿が気に入りましたか？ハートを贈りましょう！';

  @override
  String get saveFeedPocket => '特別な投稿をそっとポケットに仕舞いましょう。';

  @override
  String get newComment => '新しいコメント';

  @override
  String get someFriend => 'ある友人';

  @override
  String get myBackpackAndPrivileges => 'マイリュック＆特権';

  @override
  String get currentRomanticBond => '現在獲得したロマンチックキズナ';

  @override
  String get physicalGiftBoxUnlockStatus => 'リアルギフトボックス解放状況：';

  @override
  String get topLovePhysicalVipBox => '【極上の最愛】リアル VIP 専属ギフトボックス';

  @override
  String get physicalGiftBoxContents => '内容：専属直筆お手紙 + キャラクターぬいぐるみ + 公式感謝状';

  @override
  String get modifyShippingAddress => 'お届け先住所の変更';

  @override
  String get addressUnlockedFillNow => '解放されました！ここをタップしてお届け先情報を入力してください';

  @override
  String get addressSuccessfullyRegistered =>
      'お届け先住所の登録が完了しました。準備を進めさせていただきます！';

  @override
  String amountNeededForPhysicalPrize(String amount) {
    return 'リアル大賞解放まであと NT\$ $amount！';
  }

  @override
  String get avatarFrameHint => 'ヒント：その他のデジタルスキンやアイコン枠はショップや個人設定で確認・装着できます。';

  @override
  String get closeButton => '閉じる';

  @override
  String get physicalGiftBoxUnlockTitle => '【極上の最愛】リアルギフトボックス解放';

  @override
  String get physicalGiftBoxUnlockThanks => '『恋恋拾光』を温かく見守っていただき、心より感謝申し上げます！';

  @override
  String get physicalGiftBoxUnlockPrompt =>
      '以下の発送先情報を入力してください。専属の直筆お手紙とぬいぐるみをお送りします：';

  @override
  String get recipientRealName => '受取人本名';

  @override
  String get contactPhone => '連絡先電話番号';

  @override
  String get fullShippingAddress => '詳細住所（郵便番号を含む）';

  @override
  String get desiredCharacterDollName => 'ご希望のキャラクターぬいぐるみ名';

  @override
  String get characterNameExample => '例：希望するキャラクターの名前';

  @override
  String get fillLater => '後で入力する';

  @override
  String get fillCompleteAddressAndRoleHint => 'お届け先情報とご希望のキャラクター名をすべてご入力ください！';

  @override
  String get shippingInfoSubmittedSuccess =>
      'お届け先情報が正常に送信されました！実物のサプライズを楽しみにお待ちください！';

  @override
  String get confirmSubmit => '確認して送信';

  @override
  String get aboutMe => '自己紹介';

  @override
  String get myBackpack => 'マイリュック';

  @override
  String get ownerExclusiveArea => 'オーナー専属エリア';

  @override
  String get enterShiguangAdminBackend => '拾光管理コンソールに入る';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String get creatorGuidelines => 'クリエイターガイドライン';

  @override
  String get playGuide => 'プレイガイド';

  @override
  String get lianlianShiguang => '恋恋拾光';

  @override
  String get copyrightNotice => '© 2026 黙語白';

  @override
  String get cumulativeBenefits => '累計特典';

  @override
  String get perkFirstEncounter => '初見一瞬';

  @override
  String get perkFirstEncounterReward => '時光花 20個 + 専属ビギナー称号';

  @override
  String get perkGlimmerThrob => '微光のときめき';

  @override
  String get perkGlimmerThrobReward => '専属アイコン枠【微光のときめき】';

  @override
  String get perkStarryWhisper => '星空の囁き';

  @override
  String get perkStarryWhisperReward => '専属チャット吹き出し + 時光花 50個';

  @override
  String get perkRomanticSunset => 'ロマンチックな夕焼け';

  @override
  String get perkRomanticSunsetReward => '専属 App デスクトップアイコン';

  @override
  String get perkHeartbeat => '胸の高鳴り';

  @override
  String get perkHeartbeatReward => '画面タップエフェクト + 時光花 100個';

  @override
  String get perkEternalVow => '永恒の誓い';

  @override
  String get perkEternalVowReward => '高級動的アイコン枠 + 時光花 200個';

  @override
  String get perkSoulIntersection => '交差する魂';

  @override
  String get perkSoulIntersectionReward => '動的チャット吹き出しエフェクト + 専属上級称号';

  @override
  String get perkExclusiveWait => '専属の守護';

  @override
  String get perkExclusiveWaitReward => '極上動的ネームプレート + 時光花 500個';

  @override
  String get perkBrilliantGalaxy => '璀璨たる銀河';

  @override
  String get perkBrilliantGalaxyReward => '専属入場エフェクト + 専属カスタマーサポート';

  @override
  String get perkTopBeloved => '極上の最愛';

  @override
  String get perkTopBelovedReward => 'リアル VIP 専属ギフトボックス';

  @override
  String get cumulativeRomanticBond => '累計ロマンチックキズナ';

  @override
  String get allTopPrivilegesUnlocked => 'すべての最高級特権を解放しました！';

  @override
  String rechargeAmountForNextTier(String amount) {
    return 'あと NT\$ $amount チャージで次のランクを解放';
  }

  @override
  String get storyContentCannotBeEmpty => 'ストーリーの内容を空にすることはできません';

  @override
  String get writeYourStoryHint => 'ふたりの物語を書き綴りましょう...';

  @override
  String get characterBannerTitle => 'キャラクターホームバナー';

  @override
  String get mailDeleteTitle => 'メールを削除';

  @override
  String mailDeleteConfirm(int count) {
    return '$count 件のメールを削除しますか？\n削除後は元に戻せません。';
  }

  @override
  String mailDeleteSuccess(int count) {
    return '$count 件のメールを削除しました';
  }

  @override
  String get mailDeleteFailed => '削除に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get mailCancelSelection => '選択を解除';

  @override
  String mailSelectedCount(int count) {
    return '$count 件選択中';
  }

  @override
  String get moreOptions => 'その他';

  @override
  String mailDeleteSelected(int count) {
    return '$count 件のメールを削除';
  }

  @override
  String get officialManagementTeam => 'LoveyDovey運営チーム';

  @override
  String get rewardCampaignTitle => 'イベントギフト';

  @override
  String get rewardCampaignMissingData =>
      'このギフトメールにはイベントデータがありません。しばらくしてからもう一度お試しください';

  @override
  String rewardCampaignClaimSuccess(int amount) {
    return '花を $amount 個受け取りました';
  }

  @override
  String get rewardCampaignAlreadyClaimed => 'このギフトはすでに受け取り済みです';

  @override
  String get rewardCampaignClaimFailed => '受け取りに失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get rewardCampaignContains => 'このメールには';

  @override
  String rewardCampaignFlowerAmount(int amount) {
    return '花 $amount 個';
  }

  @override
  String rewardCampaignDeadline(String date) {
    return '受取期限：$date';
  }

  @override
  String get rewardCampaignClaiming => '受け取り中…';

  @override
  String get rewardCampaignClaimed => '受け取り済み';

  @override
  String get rewardCampaignEnded => 'イベントは終了しました';

  @override
  String get rewardCampaignClaimButton => 'ギフトを受け取る';

  @override
  String get mailDetailTitle => 'メール';

  @override
  String mailSender(String name) {
    return '差出人：$name';
  }

  @override
  String get mailCaseNumber => 'お問い合わせ番号';

  @override
  String get mailCopyCaseNumber => 'お問い合わせ番号をコピー';

  @override
  String get mailCaseNumberCopied => 'お問い合わせ番号をコピーしました';

  @override
  String get profilePageAboutMe => '自己紹介';

  @override
  String get profilePageTabBio => 'プロフィール';

  @override
  String get profilePageTabCharacters => 'キャラクター';

  @override
  String get profilePageTabMoments => '投稿';

  @override
  String get profilePageEditProfile => 'プロフィールを編集';

  @override
  String get profilePageFriends => '友達';

  @override
  String get profilePageWorks => '作品';

  @override
  String get profilePageFollowing => 'フォロー中';

  @override
  String get profilePageFollowers => 'フォロワー';

  @override
  String get profilePageHeartbeatDiary => 'ときめき日記';

  @override
  String get profilePageEditCharacter => 'キャラクターを編集';

  @override
  String get profilePagePreviewCharacter => 'キャラクタープロフィールをプレビュー';

  @override
  String get profilePageNoBio => '自己紹介はまだありません';

  @override
  String get profilePageNoBioHint => 'タップして自己紹介を書いてみましょう。';

  @override
  String get profilePageCreateCharacter => '新しいキャラクターを作成';

  @override
  String get profilePageNoCharacters => '作成したキャラクターはまだいません';

  @override
  String get profilePageNoCharactersHint => '最初のキャラクターを作成してみましょう。';

  @override
  String get profilePageCharacterActions => 'キャラクター操作';

  @override
  String get profilePagePublic => '公開';

  @override
  String get profilePagePrivate => '非公開';

  @override
  String get profilePageCreator => 'クリエイター';

  @override
  String get profilePageSelectPostingIdentity => '投稿者を選択';

  @override
  String get profilePagePostAsCreator => 'クリエイター本人として投稿';

  @override
  String get profilePagePublicCharacter => '公開キャラクター';

  @override
  String get profilePagePrivateCharacter => '非公開キャラクター';

  @override
  String get profilePagePleaseSignIn => '先にログインしてください';

  @override
  String get profilePagePublishMoment => '投稿する';

  @override
  String get profilePageFilterAll => 'すべて';

  @override
  String get profilePageFilterCreator => '本人';

  @override
  String get profilePageFilterCharacter => 'キャラクター';

  @override
  String get profilePageMomentsLoadFailed => '投稿の読み込みに失敗しました';

  @override
  String get profilePageTryAgainLater => 'しばらくしてからもう一度お試しください。';

  @override
  String get profilePageNoCreatorMoments => '本人による投稿はまだありません';

  @override
  String get profilePageNoCreatorMomentsHint => 'クリエイターとして投稿した内容がここに表示されます。';

  @override
  String get profilePageNoCharacterMoments => 'キャラクターによる投稿はまだありません';

  @override
  String get profilePageNoCharacterMomentsHint => 'キャラクターとして投稿した内容がここに表示されます。';

  @override
  String get profilePageNoMoments => '投稿はまだありません';

  @override
  String get profilePageNoMomentsHint => 'あなたとキャラクターが投稿した内容がここに表示されます。';

  @override
  String get profilePageDeleteMomentTitle => '投稿を削除';

  @override
  String get profilePageDeleteMomentConfirm => 'この投稿を完全に削除しますか？';

  @override
  String get profilePageCancel => 'キャンセル';

  @override
  String get profilePageDelete => '削除';

  @override
  String get profilePageMomentDeleted => '投稿を削除しました';

  @override
  String get profilePageDeleteFailed => '削除に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get profilePageReferralCompleted => '星の招待が完了しました';

  @override
  String profilePageInviter(String inviterId) {
    return '招待者：$inviterId';
  }

  @override
  String get profilePageReferralRewardReceived => '双方に花を50個付与しました';

  @override
  String get profilePageClaimed => '受け取り済み';

  @override
  String profilePageInviterBound(String inviterId) {
    return '招待者を登録しました：$inviterId';
  }

  @override
  String get profilePageReferralProgressHint =>
      'チャットを15通完了すると、双方に花が50個ずつ付与されます';

  @override
  String get profilePageAlreadyCheckedIn => '今日はすでにチェックイン済みです';

  @override
  String get profilePageReferralBindFailed => '登録に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get profilePageCharacterNotFound => 'このキャラクターのデータが見つかりません';

  @override
  String get periodGuideTitle => '生理日記の使い方';

  @override
  String get periodGuideContent =>
      '① まずカレンダーの日付を選択します。\n②「今日始まった」「まだ生理中」または「今日終わった」を選択します。\n③ 今日の気分と体調を選択します。自由に補足することもできます。\n④ 保存を押すと、チャット中にキャラクターが今日のあなたの状態を理解できるようになります。\n\n予測日は過去の記録に基づいて調整されます。日々の記録の参考としてのみご利用ください。';

  @override
  String get periodGotIt => 'わかりました';

  @override
  String get periodSelectAtLeastOne => '記録する項目を1つ以上選択してください';

  @override
  String get periodFutureDateError => '未来の日付に生理の状態を記録することはできません。';

  @override
  String get periodAlreadyOngoingError => '進行中の生理記録があります。先に終了してください。';

  @override
  String get periodNoOngoingError => '現在、進行中の生理記録はありません。先に「今日始まった」を選択してください。';

  @override
  String get periodBeforeStartError => '今回の生理開始日より前の日付は選択できません。';

  @override
  String get periodEndBeforeStartError => '終了日は開始日より前に設定できません。';

  @override
  String periodRecordSaved(String date) {
    return '$dateの記録を保存しました';
  }

  @override
  String get periodSaveFailed => '保存に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get periodDeleteTitle => '今回の生理記録を削除しますか？';

  @override
  String get periodDeleteContent => '削除すると、平均周期と次回予測も再計算されます。';

  @override
  String get periodCancel => 'キャンセル';

  @override
  String get periodDelete => '削除';

  @override
  String get periodNoOngoing => '現在、進行中の生理記録はありません';

  @override
  String periodDayCount(int count) {
    return '生理 $count 日目';
  }

  @override
  String get periodHelp => '使い方';

  @override
  String get periodAverageCycle => '平均周期';

  @override
  String get periodAverageDuration => '平均生理期間';

  @override
  String periodDays(int count) {
    return '$count 日';
  }

  @override
  String get periodNextPrediction => '次回予測';

  @override
  String get periodCalculatedAfterRecording => '記録後に計算';

  @override
  String get periodInsufficientData =>
      '現在はデータが不足しているため、暫定的に28日周期、生理期間5日として予測します。';

  @override
  String get periodPredictionDisclaimer =>
      '現在の記録に基づく予測です。日付は日々の記録の参考としてのみご利用ください。';

  @override
  String get periodStartedToday => '今日始まった';

  @override
  String get periodStillOngoing => 'まだ生理中';

  @override
  String get periodEndedToday => '今日終わった';

  @override
  String get periodDateNotReached => 'この日はまだ来ていません～';

  @override
  String get periodDateBeforeStart => 'この日は現在の生理開始日より前です。';

  @override
  String get periodMoodOkay => 'まあまあ';

  @override
  String get periodMoodHappy => 'うれしい';

  @override
  String get periodMoodLow => '落ち込んでいる';

  @override
  String get periodMoodUnwell => 'つらい';

  @override
  String get periodMoodIrritable => 'イライラ';

  @override
  String get periodMoodTired => '疲れた';

  @override
  String get periodMoodAnxious => '不安';

  @override
  String get periodSymptomAbdominalPain => '腹痛';

  @override
  String get periodSymptomLowerBackPain => '腰痛';

  @override
  String get periodSymptomHeadache => '頭痛';

  @override
  String get periodSymptomBreastTenderness => '胸の張り';

  @override
  String get periodSymptomSwelling => 'むくみ';

  @override
  String get periodSymptomSleepy => '眠い';

  @override
  String get periodSymptomIncreasedAppetite => '食欲増加';

  @override
  String get periodSymptomDigestiveDiscomfort => '胃腸の不調';

  @override
  String periodDiaryTitle(String characterName) {
    return '$characterNameの思いやり日記';
  }

  @override
  String get periodLoadFailed => '記録の読み込みに失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get periodWeekdaySun => '日';

  @override
  String get periodWeekdayMon => '月';

  @override
  String get periodWeekdayTue => '火';

  @override
  String get periodWeekdayWed => '水';

  @override
  String get periodWeekdayThu => '木';

  @override
  String get periodWeekdayFri => '金';

  @override
  String get periodWeekdaySat => '土';

  @override
  String get periodSaveInstruction => '状態を選択した後、一番下の「今日の記録を保存」を押すと正式に保存されます。';

  @override
  String get periodTodayMood => '今日の気分（複数選択可）';

  @override
  String get periodMoodDescription => 'これはその日の日記であり、カレンダー上に表示されるアイコンではありません。';

  @override
  String get periodOtherMood => 'その他の気分';

  @override
  String get periodOtherMoodHint => '例：傷ついた、不安を感じる……';

  @override
  String get periodTodaySymptoms => '今日の体調（複数選択可）';

  @override
  String get periodOtherSymptom => 'その他の体調';

  @override
  String get periodOtherSymptomHint => '例：寒気がする、食欲がない……';

  @override
  String periodNoteForCharacter(String characterName) {
    return '$characterNameに伝えたいこと（任意）';
  }

  @override
  String get periodNoteHint => '例：今日は静かに休みたいから、急かさないでほしい……';

  @override
  String get periodSaving => '保存中…';

  @override
  String get periodSaveToday => '今日の記録を保存';

  @override
  String get periodHistory => '生理履歴';

  @override
  String get periodOngoing => '進行中';

  @override
  String periodTotalDays(int count) {
    return '合計 $count 日';
  }

  @override
  String get periodDeleteRecord => '記録を削除';

  @override
  String get privateProfilePleaseSignIn => '先にログインしてください';

  @override
  String privateProfileLoreLoadFailed(String error) {
    return '記憶の欠片の読み込みに失敗しました：$error';
  }

  @override
  String privateProfileWriteNewLore(int count, int limit) {
    return '新しい記憶の欠片を書く（$count / $limit）';
  }

  @override
  String get privateProfileNoLore => '記憶の欠片はまだありません';

  @override
  String get privateProfileNoLoreHint =>
      'ここでは、テスト設定や物語の手がかり、キャラクターの大切な記憶を整理できます。';

  @override
  String get privateProfileUntitledLore => '無題の欠片';

  @override
  String get privateProfileEdit => '編集';

  @override
  String get privateProfileDelete => '削除';

  @override
  String get privateProfileAddLore => '記憶の欠片を追加';

  @override
  String get privateProfileLoreTitle => 'タイトル';

  @override
  String get privateProfileLoreTeaser => '短いヒント';

  @override
  String get privateProfileLoreContent => '詳細内容';

  @override
  String get privateProfileLockLore => '欠片をロック';

  @override
  String get privateProfileLockLoreHint =>
      '非公開キャラクターは現在クリエイターのみ閲覧できます。この項目は、キャラクターを公開した際に引き続き使用できるよう保持されます。';

  @override
  String get privateProfileCancel => 'キャンセル';

  @override
  String get privateProfileTitleContentRequired => 'タイトルと内容を入力してください';

  @override
  String get privateProfileLoreAdded => '記憶の欠片を追加しました';

  @override
  String get privateProfileAddFailed => '追加に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get privateProfilePublish => '公開';

  @override
  String get privateProfileDeleteLoreTitle => '記憶の欠片を削除';

  @override
  String get privateProfileDeleteLoreConfirm => 'この記憶の欠片を完全に削除しますか？';

  @override
  String get privateProfileLoreDeleted => '記憶の欠片を削除しました';

  @override
  String get privateProfileDeleteFailed => '削除に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get privateProfileEditLore => '記憶の欠片を編集';

  @override
  String get privateProfileSave => '保存';

  @override
  String get editProfileBirthdayReminderTitle => 'ちょっとしたお知らせ';

  @override
  String get editProfileBirthdayReminderContent =>
      '誕生日は、キャラクターからの誕生日のお祝い、誕生日プレゼント、関連イベントに影響します。\n\n今後の誕生日報酬に影響しないよう、\n誕生日を確認してから設定を完了することをおすすめします。';

  @override
  String get editProfileGotIt => 'わかりました';

  @override
  String get editProfileBirthdayConfirmTitle => '誕生日を確認';

  @override
  String get editProfileBirthdayConfirmContent =>
      '誕生日が正しいことを確認してください。\n\n誕生日は、誕生日のお祝い、誕生日プレゼント、関連イベントに使用されます。\n\n誕生日報酬の重複受け取りを防ぐため、設定完了後は誕生日を変更できません。\n\nこの誕生日を使用しますか？';

  @override
  String get editProfileReturnToEdit => '編集に戻る';

  @override
  String get editProfileConfirmSetting => '設定を確定';

  @override
  String get editProfileDefaultNickname => '出会ったばかりの旅人';

  @override
  String get editProfileNoChanges => '保存する変更はありません';

  @override
  String editProfileCreateFailed(String error) {
    return 'データの作成に失敗しました：$error';
  }

  @override
  String editProfileAvatarNumber(int number) {
    return 'アバター $number';
  }

  @override
  String get editProfileImageSelectionFailed => '画像の選択に失敗しました。別の画像を選択してください';

  @override
  String get editProfileCancel => 'キャンセル';

  @override
  String get editProfileConfirm => '確定';

  @override
  String get editProfileImageProcessingFailed => '画像の処理に失敗しました。別の画像を選択してください';

  @override
  String editProfileLoadFailed(String error) {
    return 'データの読み込みに失敗しました：$error';
  }

  @override
  String get editProfileBioLabel => '自己紹介';

  @override
  String get editProfileBioHelper => '自分自身や創作スタイルについて簡単に紹介してください';

  @override
  String get editProfileBioHint => '例：ファンタジー、ヤンデレ、没入型恋愛のキャラクターを作るのが好きです。';

  @override
  String get editProfileUserNotFound => 'ユーザーが見つかりません';

  @override
  String get editProfileGenerateIdFailed => 'プレイヤーIDの生成に失敗しました。もう一度お試しください';

  @override
  String get editProfileSignedInUserNotFound => '現在ログインしているユーザーが見つかりません';

  @override
  String editProfileAvatarReadFailed(int statusCode) {
    return 'アバターの読み込みに失敗しました。ステータスコード：$statusCode';
  }

  @override
  String editProfileAvatarFileNotFound(String path) {
    return '選択したアバターファイルが見つかりません：$path';
  }

  @override
  String get editProfileAvatarEmpty => 'アバター画像のデータが空です';

  @override
  String get chatPageSendFailed => '送信に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get chatPageRegenerateFailed =>
      '再生成に失敗しました。元のメッセージは保持されています。もう一度お試しください。';

  @override
  String get chatPageRegenerating => 'もう一度考えています...';

  @override
  String get chatPageThinkingTooLong => '考え込んでいるようです。しばらくしてからもう一度お試しください……';

  @override
  String get chatPageAlreadyReplying => '返信中です。少し待ってから、重複して送信しないでください';

  @override
  String get chatPageMediaUploadFailed => 'メディアのアップロードに失敗しました。もう一度お試しください';

  @override
  String get chatPageReportReceived => 'ご報告ありがとうございます。できるだけ早く確認いたします';

  @override
  String chatPageMessagesDeleted(int count) {
    return '$count 件のメッセージを削除しました';
  }

  @override
  String chatPageSelectPhotoFailed(String error) {
    return '写真を選択できませんでした：$error';
  }

  @override
  String get chatPageRecordingNotFound => '録音ファイルが見つかりません';

  @override
  String get chatPageRecordingEmpty => '録音ファイルが空です';

  @override
  String chatPageAudioPlaybackFailed(String error) {
    return '音声の再生に失敗しました：$error';
  }

  @override
  String get chatPageMicrophonePermissionRequired => '録音するにはマイクの使用許可が必要です';

  @override
  String chatPageStartRecordingFailed(String error) {
    return '録音を開始できませんでした：$error';
  }

  @override
  String get chatPageRecordingCreationFailed => '録音ファイルの作成に失敗しました。もう一度録音してください';

  @override
  String chatPageRecordingFailed(String error) {
    return '録音に失敗しました：$error';
  }

  @override
  String get chatPageRecordingNotFoundRetry => '録音ファイルが見つかりません。もう一度録音してください';

  @override
  String get chatPageRecordingEmptyRetry => '録音ファイルが空です。もう一度録音してください';

  @override
  String get chatPageNoRecordingToSend => '送信できる録音がありません';

  @override
  String chatPagePointCost(int count) {
    return '$count ポイント';
  }

  @override
  String get chatPageVoiceUploading => '音声をアップロード中……';

  @override
  String get chatPageChangeWatermarkColor => '透かしの色を変更';

  @override
  String chatPageMinutesSeconds(int minutes, int seconds) {
    return '$minutes 分 $seconds 秒';
  }

  @override
  String chatPageSeconds(int seconds) {
    return '$seconds 秒';
  }

  @override
  String get characterEditSelectSupportingCharacter => 'サブキャラクターを選択してください。';

  @override
  String get characterEditSelectGender => 'キャラクターの性別を選択してください。';

  @override
  String get characterEditCharacterSettings => 'キャラクター設定';

  @override
  String get characterEditWorldview => '世界観';

  @override
  String get characterEditSettingsMinLength => 'キャラクター設定は10文字以上入力してください。';

  @override
  String get characterEditWorldviewMinLength => '世界観は20文字以上入力してください。';

  @override
  String get characterEditSupportingCharacters => 'サブキャラクター';

  @override
  String get characterEditCharacterImage => 'キャラクター画像';

  @override
  String get characterEditWorldviewHint =>
      '世界の背景、歴史、時代、地域、勢力、制度、技術、魔法、世界のルールについて説明してください。';

  @override
  String get characterEditSettingsHint =>
      'キャラクターの性格、価値観、考え方、感情的な反応、行動習慣、話し方、核となる信念について説明してください。';

  @override
  String get characterEditUnknownCharacter => '不明なキャラクター';

  @override
  String get characterEditEditSupportingCharacter => 'サブキャラクターを編集';

  @override
  String get characterEditAddSupportingCharacter => 'サブキャラクターを追加';

  @override
  String get characterEditSupportingCharacterName => 'サブキャラクター名';

  @override
  String get characterEditGender => '性別';

  @override
  String get characterEditMale => '男性';

  @override
  String get characterEditFemale => '女性';

  @override
  String get characterEditOther => 'その他';

  @override
  String get characterEditAge => '年齢';

  @override
  String get characterEditIdentityOccupation => '身分／職業';

  @override
  String get characterEditRelationshipWithMain => 'メインキャラクターとの関係';

  @override
  String get characterEditRelationshipHint =>
      'メインキャラクターとの過去、立場、感情、秘密、現在の関係について説明してください。';

  @override
  String get characterEditCharacterProfile => '人物設定';

  @override
  String get characterEditCharacterProfileHint =>
      '性格、外見、習慣、価値観、能力、好み、苦手なもの、重要な経験について説明してください。';

  @override
  String get characterEditSpeakingStyle => '話し方';

  @override
  String get characterEditSpeakingStyleHint => '例：早口で、ツッコミが多く、率直に話す。';

  @override
  String get characterEditSupportingNameRequired => 'サブキャラクター名を入力してください。';

  @override
  String get characterEditSupportingGenderRequired => 'サブキャラクターの性別を選択してください。';

  @override
  String get characterEditProfileRequired => '人物設定を入力してください。';

  @override
  String get characterEditRelationshipTooLong =>
      'メインキャラクターとの関係が1,500文字を超えています。';

  @override
  String get characterEditProfileTooLong => '人物設定が1,500文字を超えています。';

  @override
  String get characterEditSave => '保存';

  @override
  String get characterEditAdd => '追加';

  @override
  String get creatorProfileNoBio => '自己紹介はまだありません';

  @override
  String get creatorProfileNoBioHint => 'このクリエイターはまだ自己紹介を追加していません。';

  @override
  String get creatorProfileNoCreatorMoments => 'クリエイターによる投稿はまだありません';

  @override
  String get creatorProfileNoCreatorMomentsHint =>
      'クリエイター本人として公開したコンテンツがここに表示されます。';

  @override
  String get creatorProfileNoCharacterMoments => '所属キャラクターによる投稿はまだありません';

  @override
  String get creatorProfileNoCharacterMomentsHint =>
      '公開キャラクターが投稿したコンテンツがここに表示されます。';

  @override
  String get creatorProfileNoPublicMoments => '公開投稿はまだありません';

  @override
  String get creatorProfileNoPublicMomentsHint =>
      'クリエイター本人と所属キャラクターが公開した投稿がここに表示されます。';

  @override
  String get creatorProfilePublicWorks => '公開作品';

  @override
  String get creatorProfileLikesReceived => '獲得した「いいね」';

  @override
  String get creatorProfileFollow => 'フォロー';

  @override
  String get creatorProfileFollowing => 'フォロー中';

  @override
  String get creatorProfileUnfollowed => 'フォローを解除しました';

  @override
  String creatorProfileFollowedCreator(String creatorName) {
    return '$creatorNameをフォローしました';
  }

  @override
  String get creatorProfileOperationFailed => '操作に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String creatorProfileWorksLoadFailed(String error) {
    return '作品の読み込みに失敗しました：$error';
  }

  @override
  String get characterProfileShareInvitation => 'LoveyDoveyから届いた出会いの招待状';

  @override
  String characterProfileShareCreator(String creatorName) {
    return 'クリエイター：$creatorName';
  }

  @override
  String characterProfileShareMessage(String characterName) {
    return 'LoveyDoveyで「$characterName」を検索して、二人だけの物語を始めましょう。';
  }

  @override
  String get characterProfileInvitationLabel => 'キャラクター招待カード';

  @override
  String characterProfileCardCreator(String creatorName) {
    return 'クリエイター  $creatorName';
  }

  @override
  String get characterProfileCardSearchHint => 'キャラクターを検索して、出会いを始めよう';

  @override
  String get characterProfileScanToDownload => 'スキャンしてダウンロード';

  @override
  String characterProfileShareTitle(String characterName) {
    return 'キャラクター「$characterName」をシェア';
  }

  @override
  String characterProfileShareSubject(String characterName) {
    return 'LoveyDoveyで$characterNameに会おう';
  }

  @override
  String get characterProfileShareFailed =>
      '招待カードの作成に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get characterProfilePrivateShareUnavailable => '非公開キャラクターは現在シェアできません';

  @override
  String get characterProfileShareCard => '招待カードをシェア';

  @override
  String get characterProfileShareCharacter => 'キャラクターをシェア';

  @override
  String get characterProfileReportCharacter => 'キャラクターを通報';

  @override
  String get characterProfileTranslate => '翻訳';

  @override
  String get loginMethodInfoTooltip => 'ログイン方法の説明';

  @override
  String get characterEditCoreSetting => 'キャラクターの基本設定';

  @override
  String get characterEditCoreSettingHint =>
      'キャラクターの性格、行動パターン、人との接し方、話し方について説明してください。\n\n例：一見すると冷淡で無口だが、実際はとても気配りができる。見知らぬ人とは距離を置き、好きな相手には行動で気遣いを示す。話し方は簡潔で率直であり、甘すぎる呼び方や軽薄な呼び方はしない。';

  @override
  String get characterEditNameDescription =>
      'キャラクターの公開表示名です。作成完了後、キャラクターのユーザー名はシステムによって自動的に生成されます。';

  @override
  String get characterEditNameHint => 'キャラクター名を入力してください';

  @override
  String get characterEditAgeDescription =>
      'キャラクターの年齢を設定します。世界観に合わせて外見年齢を入力することもできます。';

  @override
  String get characterEditAgeHint => '例：25';

  @override
  String get characterEditOccupationDescription =>
      '学生、医師、騎士、実業家など、キャラクターの現在の身分や職業です。';

  @override
  String get characterEditBirthdayDescription =>
      'キャラクターの誕生日を4桁の数字で入力するか、月と日をスラッシュで区切って設定してください。';

  @override
  String get characterEditBirthdayHint => '例：0825 または 08/25';

  @override
  String get characterEditHeightDescription => 'キャラクターの身長をセンチメートル単位で設定します。';

  @override
  String get characterEditHeightHint => '例：182';

  @override
  String get characterEditGenderDescription =>
      'キャラクターの性別に応じて、システムが適切な代名詞を使用します。';

  @override
  String get characterEditAppearanceDescription =>
      'キャラクターの顔立ち、髪型、服装、その他の外見的特徴を説明してください。';

  @override
  String get characterEditPlayerIdentityDescription =>
      '助手、同級生、幼なじみなど、物語におけるプレイヤーの立場を設定します。';

  @override
  String get characterEditWorldviewDescription =>
      '物語の時代、場所、社会的背景、特別なルールを説明してください。この内容はキャラクターページの「キャラクター紹介」に公開表示されるため、プレイヤーに事前に知られたくない秘密や物語の展開は入力しないでください。';

  @override
  String get characterEditStorySummaryDescription =>
      'キャラクターの状況をすぐに理解できるよう、この物語を一文で簡潔に紹介してください。';

  @override
  String get characterEditStorySummaryHint => '例：冷淡な医師との契約関係から始まる恋物語';

  @override
  String get characterEditInitialStoryDescription =>
      'プレイヤーが初めてチャットルームに入ったとき、最初に表示される物語の場面です。';

  @override
  String get characterEditFirstLineDescription =>
      'キャラクターが初めてプレイヤーに会ったときに話す最初の言葉です。';

  @override
  String get characterEditCustomStatusBar => 'ストーリーステータス欄（任意）';

  @override
  String get characterEditCustomStatusBarDescription =>
      'ストーリーモードと没入モードにのみ適用されます。返信の末尾に常に表示するキャラクターの状態、場所、服装、関係性などの情報を設定できます。空欄の場合、ステータス欄は生成されません。';

  @override
  String get characterProfileCharacterIntro => 'キャラクター紹介';

  @override
  String get characterProfileNoIntroduction => 'クリエイターはまだキャラクター紹介を入力していません';

  @override
  String get characterProfileViewMore => 'もっと見る';

  @override
  String get characterProfileCollapse => '折りたたむ';

  @override
  String get characterEditSelectedTagOrder => '選択したタグをドラッグして表示順を変更できます';

  @override
  String get mailActivityGiftFallback => 'イベントギフト';

  @override
  String get mailFilterAll => 'すべて';

  @override
  String get mailFilterCollected => '保存済み';

  @override
  String get mailCollectedEmptyTitle => '保存した手紙はまだありません';

  @override
  String get mailCollectedEmptyHint => '保存したい手紙を開き、右上の保存ボタンをタップしてください。';

  @override
  String get mailQixiLimitedBadge => '七夕限定';

  @override
  String get mailQixiThreeDayPromise => 'LoveyDovey七夕・三日間の約束';

  @override
  String mailQixiFromCharacter(String characterName) {
    return '$characterNameからの七夕の手紙';
  }

  @override
  String mailFromCharacter(String characterName) {
    return '$characterNameから';
  }

  @override
  String get mailQixiCollectionLabel => '2026年七夕限定コレクション';

  @override
  String get mailShareGenerating => 'シェア画像を作成しています……';

  @override
  String mailShareQixiMessage(String characterName) {
    return '$characterNameから七夕限定の手紙が届きました';
  }

  @override
  String get mailShareDefaultMessage => '「LoveyDovey」からの手紙';

  @override
  String get mailShareImageFailed => 'シェア画像の作成に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get mailCollectedSuccess => 'この手紙を保存しました';

  @override
  String get mailCollectedCancelled => '保存を解除しました';

  @override
  String get mailCollectedUpdateFailed => '保存状態の更新に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get mailRemoveCollectionTooltip => '保存を解除';

  @override
  String get mailAddCollectionTooltip => '手紙を保存';

  @override
  String get mailShareTooltip => '手紙をシェア';

  @override
  String mailQixiDayNumber(int day) {
    return '$day日目';
  }

  @override
  String get mailQixiDetailTitle => '七夕限定の手紙';

  @override
  String get mailQixiShareTooltip => '七夕の手紙をシェア';

  @override
  String get qixiMaxThreeFriends => '今回のイベントで選べるフレンドキャラクターは最大3人までです';

  @override
  String get qixiLoginRequired => '七夕イベントに参加するには、先にログインしてください';

  @override
  String get qixiOutsideEventPeriod => '現在は七夕イベントの開催期間外です';

  @override
  String get qixiSelectAtLeastOne => 'フレンドキャラクターを1人以上選択してください';

  @override
  String get qixiMysteryCharacter => '謎のキャラクター';

  @override
  String qixiOpeningStory(String characterName) {
    return '（七夕が近づき、夜の奥深くで眠っていた天の川が静かに目を覚ます。散らばっていた星の光は空の彼方でゆっくりと集まり、約束を果たそうとする二人が互いの名前を書き記す瞬間を待っているかのようだった。）\n\n（言い伝えによれば、鵲橋は本当に会いたいと願う者たちのためにだけ輝くという。あなたと「$characterName」の名前が同時に星の川へ浮かび上がったとき、一筋の淡い光が夜を越え、二人だけのこのチャットルームへと降り注いだ。）\n\n（この瞬間から、二人には「七夕・三日間の約束」が与えられる。3日間は連続していなくてもいい。大げさな告白を用意する必要もない。イベント期間中、異なる3日間にここへ戻り、ひと言の挨拶やその日の気持ち、今日あった小さな出来事を相手に伝えるだけでいい。）\n\n（無事に会えるたび、鵲橋の星がひとつずつ輝き始める。三日分の星明かりがすべて灯ったとき、会話の中に散りばめられた想いと記憶は、3日目の達成日が終わったあと、あなただけに宛てた七夕限定の手紙へと姿を変える。）\n\n（今、最初の星明かりが舞い降りた。鵲橋の向こう側では、「$characterName」もこの約束を受け取ったようだ。）\n\n——七夕・三日間の約束、今ここから始まる。';
  }

  @override
  String get qixiRoomOpenedLastMessage => '七夕・三日間の約束が始まりました';

  @override
  String get qixiCompanionSlotsFull => '七夕を共に過ごすキャラクターはすでに3人選択されています';

  @override
  String get qixiSingleRoomOpened => '七夕限定チャットルームが開かれました';

  @override
  String qixiMultipleRoomsOpened(int count) {
    return '七夕限定チャットルームが$count部屋開かれました';
  }

  @override
  String get qixiCreateRoomFailed => '七夕チャットルームを作成できませんでした。しばらくしてからもう一度お試しください';

  @override
  String get qixiEventStartsAt => 'イベントは8/19 00:00から開始します';

  @override
  String get qixiEventActiveUntil => 'イベント開催中・8/26 23:59まで';

  @override
  String get qixiEventEnded => '今回の七夕イベントは終了しました';

  @override
  String get qixiEventHeroTitle => '恋恋七夕・あなたと渡る鵲橋';

  @override
  String get qixiCharacterSelected => '選択済み';

  @override
  String get qixiFriendListLoadFailed =>
      'フレンド一覧を読み込めませんでした。しばらくしてからもう一度お試しください';

  @override
  String get qixiNoFriendCharacters => 'まだフレンドキャラクターがいません';

  @override
  String get qixiNoFriendCharactersHint =>
      'まずはお気に入りのキャラクターと出会ってから、一緒に鵲橋を渡りに戻ってきましょう！';

  @override
  String get qixiLoadingCharacter => 'キャラクター情報を読み込んでいます……';

  @override
  String get qixiEventPageTitle => '七夕限定イベント';

  @override
  String get qixiEventRules =>
      'イベント期間中、異なる3日間を選び、七夕限定チャットルームでメッセージを送り、キャラクターから返信を受け取ると、その日の星明かりが灯ります。限定レターは3日目の達成日が終了したあとに届きます。イベントの日付および毎日の進捗は台湾時間（UTC+8）を基準とします。';

  @override
  String qixiSelectCompanions(int count) {
    return '一緒に過ごすキャラクターを選択（$count/3）';
  }

  @override
  String get qixiSelectionLockedHint =>
      'フレンドに追加済みのキャラクターから最大3人まで選択できます。選択後は変更できません。';

  @override
  String get qixiConfirmCompanions => '同行キャラクターを確定';

  @override
  String get encounterDailyQuote1 => '今日は、新しい物語に出会えるかも。';

  @override
  String get encounterDailyQuote2 => '今日は、ときめきに先に話してもらおう。';

  @override
  String get encounterDailyQuote3 => '今日は、誰かがあなたとの出会いを待っているかも。';

  @override
  String get encounterDailyQuote4 => '今日は、新しい物語へ一歩踏み出してみよう。';

  @override
  String get encounterDailyQuote5 => '今日は、どんなときめきに出会えるかな？';

  @override
  String get encounterDailyQuote6 => '今日は、自分のために少しだけ期待を残しておこう。';

  @override
  String get encounterDailyQuote7 => '今日は、新しい出会いが始まっている。';

  @override
  String get encounterDailyQuote8 => '今日は、運命がちょっとした驚きを運んでくるかも。';

  @override
  String get encounterDailyQuote9 => '今日は、ひとつの出会いをゆっくり始めよう。';

  @override
  String get encounterDailyQuote10 => '今日は、思わず足を止めたくなる誰かに出会えるかも。';

  @override
  String get encounterDailyQuote11 => '今日は、どんな人に会いたい？';

  @override
  String get encounterDailyQuote12 => '今日は、そっと近づいてくるご縁を見逃さないで。';

  @override
  String get encounterJoinedToday => '今日、恋恋拾光にやってきました';

  @override
  String get encounterPopularChats => '最近たくさん話されています';

  @override
  String get qixiBannerActiveUntil => '期間限定・8/26 23:59まで';

  @override
  String get qixiBannerStartsAt => '8/19 限定オープン';

  @override
  String get encounterRecentlyArrived => '最近、恋恋拾光にやってきました';

  @override
  String get encounterRecentlyArrivedPlain => '最近、恋恋拾光にやってきました';

  @override
  String get encounterViewMore => 'もっと見る';

  @override
  String get encounterLovePrompt => '今日はどんな恋をしたい？';

  @override
  String get encounterNoCharacters => 'まだキャラクターがいません';

  @override
  String get encounterAllLoveTags => 'すべての恋愛タグ';

  @override
  String get chatQixiLetterSent => '限定レターを送りました';

  @override
  String get chatQixiLetterPendingTonight =>
      '三日分の星明かりが灯りました・今夜が終わったあとにレターが届きます';

  @override
  String get chatQixiTodayCompleted => '今日の星明かりが灯りました';

  @override
  String get chatQixiTodayNotCompleted => '今日はまだ達成していません';

  @override
  String get chatQixiPromiseTitle => '恋恋七夕・三日間の約束';

  @override
  String chatQixiStarProgress(int count) {
    return '星明かり $count/3';
  }

  @override
  String get chatQixiProgressRule =>
      '異なる3日間にチャットを達成すると、星明かりが灯ります。限定レターは3日目の終了後に届きます。毎日の進捗は台湾時間（UTC+8）を基準に計算されます。';

  @override
  String chatQixiDayNumber(int day) {
    return '$day日目';
  }

  @override
  String get chatWebPurchaseUnavailable =>
      'Web版では現在チャージサービスをご利用いただけません。花花の購入またはサブスクリプションには『恋恋拾光』アプリをご利用ください。';

  @override
  String get chatAiThinkingTimeout => '彼は考え込んでいるようです。しばらくしてからもう一度お試しください……';

  @override
  String get chatAiResponseBlocked =>
      '彼の思考が少し乱れているようです。もう少しやさしい言い方に変えてお試しください。';

  @override
  String get chatRecordingStartFailed => '録音を開始できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get chatRecordingPlaybackFailed =>
      '録音を再生できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get chatRoomNotReady => 'チャットルームの準備がまだ完了していません。しばらくしてからもう一度お試しください。';

  @override
  String get chatRegenerateLimitReached => '本日の再生成回数を使い切りました';

  @override
  String get chatTypingIndicator => '相手が入力中……';

  @override
  String get chatRegenerateCountSyncFailed =>
      '再生成には成功しましたが、回数を同期できませんでした。しばらくしてから更新してください。';

  @override
  String get chatRoomNotFound => 'このキャラクターのチャットルームが見つかりません';

  @override
  String get momentsSearchTooltip => '拾光ウォールを検索';

  @override
  String get momentsCreatorNotFound => 'このクリエイターの情報が見つかりません';

  @override
  String get momentCommentLoadFailed => 'コメントの読み込みに失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get momentCollapseReplies => '返信を閉じる';

  @override
  String momentViewOtherReplies(int count) {
    return '他の$count件の返信を見る';
  }

  @override
  String get momentSwitchCommentIdentity => 'コメントする身分を切り替える';

  @override
  String get momentSendCommentTooltip => 'コメントを送信';

  @override
  String get momentShareCharactersLoadFailed =>
      'チャットしたキャラクターの読み込みに失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get momentReportLoginRequired => '投稿を通報するには、先にログインしてください';

  @override
  String get momentReportSubmitted => '通報を送信しました。内容を確認します';

  @override
  String get momentSelectShareCharacter =>
      'この投稿を共有する、チャットしたことのあるキャラクターを選択してください';

  @override
  String get momentTagCharacterUnavailable => 'このタグはキャラクタープロフィールにリンクされていません';

  @override
  String get momentCharacterNotFound => 'キャラクター情報が見つかりません';

  @override
  String get appUpdateTitle => '新しいバージョンがあります';

  @override
  String get appUpdateMessage =>
      'LoveyDoveyの新しいバージョンが利用できます。最新機能と修正をご利用いただくため、アップデートしてください。';

  @override
  String get appUpdateLater => 'あとで';

  @override
  String get appUpdateGo => 'アップデート';

  @override
  String get appUpdateCurrentVersion => '現在のバージョン';

  @override
  String get appUpdateLatestVersion => '最新バージョン';

  @override
  String get appUpdateStoreOpenFailed => 'ストアを開けませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get auth_error_requires_recent_login =>
      'ログインの有効期限が切れています。パスワードを変更する前に、もう一度ログインしてください。';

  @override
  String get auth_error_too_many_requests => '試行回数が多すぎます。しばらくしてからもう一度お試しください。';

  @override
  String get auth_error_network_failed =>
      '現在、ネットワーク接続が不安定です。しばらくしてからもう一度お試しください。';

  @override
  String get change_password_failed => 'パスワードの変更に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get change_password_account_not_found =>
      '現在ログイン中のアカウントが見つかりません。もう一度ログインしてからお試しください。';

  @override
  String get change_password_not_password_account =>
      'このアカウントはメールアドレスとパスワードによるログインを使用していないため、ここではパスワードを変更できません。';

  @override
  String get change_password_same_as_current =>
      '新しいパスワードには現在のパスワードと異なるものを設定してください。';

  @override
  String get change_password_success_title => 'パスワードを更新しました';

  @override
  String get change_password_success_message =>
      '新しいパスワードを設定しました。次回からは新しいパスワードでログインしてください。';

  @override
  String get change_password_title => 'パスワードを変更';

  @override
  String get change_password_security_title => 'アカウントのセキュリティ';

  @override
  String get change_password_description =>
      '本人確認のために現在のパスワードを入力してから、新しいログインパスワードを設定してください。';

  @override
  String get change_password_current_label => '現在のパスワード';

  @override
  String get change_password_current_required => '現在のパスワードを入力してください';

  @override
  String get change_password_new_label => '新しいパスワード';

  @override
  String get change_password_new_required => '新しいパスワードを入力してください';

  @override
  String get change_password_new_min_length => '新しいパスワードは6文字以上で入力してください';

  @override
  String get change_password_confirm_label => '新しいパスワードを確認';

  @override
  String get change_password_confirm_required => '新しいパスワードをもう一度入力してください';

  @override
  String get change_password_mismatch => '新しいパスワードが一致しません';

  @override
  String get change_password_hint =>
      'パスワードは6文字以上で設定してください。変更後、ほかの端末で再度ログインする際は新しいパスワードを使用してください。';

  @override
  String get character_npc_add => '＋ サブキャラクターを追加';

  @override
  String character_npc_added_count(int count) {
    return '追加済みのサブキャラクター：$count人';
  }

  @override
  String get character_npc_unnamed => '名前未設定のサブキャラクター';

  @override
  String get character_npc_title => 'サブキャラクター設定';

  @override
  String get character_npc_description =>
      '物語に登場する重要な人物を作成して、キャラクターの世界をより豊かにしましょう。';

  @override
  String get character_npc_empty_title => 'サブキャラクターはまだ追加されていません';

  @override
  String get character_npc_empty_description =>
      '追加したサブキャラクターの設定は、ここで確認、編集、管理できます。';

  @override
  String character_npc_age(String age) {
    return '$age歳';
  }

  @override
  String character_npc_relationship_with_main(String relationship) {
    return 'メインキャラクターとの関係：$relationship';
  }

  @override
  String get character_management_login_required => '先にログインしてください';

  @override
  String get character_management_character_tab => 'キャラクター';

  @override
  String get character_management_creator_tab => 'クリエイター';

  @override
  String get character_management_blocked_characters_empty =>
      '連絡を停止したキャラクターがここに表示されます。';

  @override
  String get character_management_blocked_creators_load_failed =>
      'ブロックしたクリエイターを読み込めませんでした';

  @override
  String get character_management_blocked_creators_empty =>
      'ブロックしたクリエイターがここに表示されます。';

  @override
  String get character_management_creator_fallback => 'クリエイター';

  @override
  String get character_management_blocked_creator_status => 'クリエイターをブロック中';

  @override
  String get character_management_blocked_creator_description =>
      'このクリエイターの公開キャラクターと今後追加されるキャラクターは、おすすめに表示されません。';

  @override
  String get character_management_unblock_creator_title => 'クリエイターのブロックを解除';

  @override
  String character_management_unblock_creator_confirm(String creatorName) {
    return '「$creatorName」のブロックを解除しますか？\n\n解除すると、このクリエイターとそのキャラクターが再びおすすめに表示される場合があります。個別にブロックしたキャラクターは、引き続きブロックされます。';
  }

  @override
  String character_management_unblock_creator_success(String creatorName) {
    return '「$creatorName」のブロックを解除しました';
  }

  @override
  String get character_management_unblock_creator_failed =>
      'ブロックの解除に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get character_management_title => 'キャラクター管理';

  @override
  String get character_management_subtitle => '連絡を停止したキャラクターを管理します';

  @override
  String get character_management_character_fallback => 'キャラクター';

  @override
  String get character_management_blocked_character_status => '連絡を停止中';

  @override
  String get character_management_blocked_character_description =>
      '関連データを削除せず、会話と通知のみを停止します。';

  @override
  String character_management_unblock_character_confirm(String charName) {
    return '「$charName」のブロックを解除しますか？解除すると、関連コンテンツが再び表示される場合があります。';
  }

  @override
  String get creator_follow_following_title => 'フォロー中のクリエイター';

  @override
  String get creator_follow_followers_title => 'あなたをフォローしているプレイヤー';

  @override
  String creator_follow_load_failed(String error) {
    return '読み込みに失敗しました：$error';
  }

  @override
  String get creator_follow_empty_following_title => 'フォロー中のクリエイターはいません';

  @override
  String get creator_follow_empty_followers_title => 'フォロワーはまだいません';

  @override
  String get creator_follow_empty_following_description =>
      'キャラクタープロフィールやクリエイターワークショップから、気になるクリエイターをフォローしてみましょう。';

  @override
  String get creator_follow_empty_followers_description =>
      'ほかのプレイヤーがあなたをフォローすると、ここに表示されます。';

  @override
  String get creator_follow_unknown_player => '不明なプレイヤー';

  @override
  String creator_follow_player_id(String playerId) {
    return 'ID：$playerId';
  }

  @override
  String get creator_follow_no_player_id => 'プレイヤーIDはまだ設定されていません';

  @override
  String get creator_follow_following => 'フォロー中';

  @override
  String get creator_follow_unfollow_title => 'フォローを解除';

  @override
  String get creator_follow_unfollow_confirm => 'このクリエイターのフォローを解除しますか？';

  @override
  String get creator_follow_unfollow => 'フォローを解除';

  @override
  String interaction_history_load_failed(String error) {
    return '読み込みに失敗しました：$error';
  }

  @override
  String get creator_profile_report_creator => 'クリエイターを通報';

  @override
  String get creator_profile_block_creator => 'クリエイターをブロック';

  @override
  String get creator_profile_report_login_required => 'クリエイターを通報するにはログインしてください';

  @override
  String get creator_profile_report_self_not_allowed =>
      '自分のクリエイターページを通報することはできません';

  @override
  String creator_profile_report_reason_prompt1(String creatorName) {
    return '「$creatorName」を通報する理由を選択してください：';
  }

  @override
  String get creator_profile_report_reason_inappropriate =>
      '不適切または規約に違反するコンテンツ';

  @override
  String get creator_profile_report_reason_harassment => '嫌がらせ、攻撃、またはヘイトコンテンツ';

  @override
  String get creator_profile_report_reason_impersonation =>
      '他人へのなりすまし、または身元の偽装';

  @override
  String get creator_profile_report_reason_spam => 'スパムまたは悪質な宣伝';

  @override
  String get creator_profile_report_success => '通報を受け付けました。ご報告ありがとうございます';

  @override
  String get creator_profile_report_failed =>
      '通報を送信できませんでした。しばらくしてからもう一度お試しください';

  @override
  String get creator_profile_block_login_required =>
      'クリエイターをブロックするにはログインしてください';

  @override
  String get creator_profile_block_self_not_allowed => '自分自身をブロックすることはできません';

  @override
  String creator_profile_block_confirm(String creatorName) {
    return '「$creatorName」をブロックしますか？\n\nブロックすると、このクリエイターの公開ページは表示されなくなります。また、このクリエイターが現在公開しているキャラクターもブロックリストに追加されます。';
  }

  @override
  String get creator_profile_block_confirm_button => 'ブロックする';

  @override
  String creator_profile_block_success(String creatorName) {
    return '「$creatorName」をブロックしました';
  }

  @override
  String get creator_profile_block_failed => 'ブロックに失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get creator_scene_edit_title_edit => 'シーンを編集';

  @override
  String get creator_scene_edit_title_add => 'シーンを追加';

  @override
  String get creator_scene_edit_heading_edit => 'この物語の始まりを調整しましょう';

  @override
  String get creator_scene_edit_heading_add => '新しい物語の始まりを書きましょう';

  @override
  String get creator_scene_edit_scene_title_label => 'シーンタイトル';

  @override
  String get creator_scene_edit_scene_title_hint => '例：雨の夜の再会';

  @override
  String get creator_scene_edit_description_label => 'シーン説明';

  @override
  String get creator_scene_edit_description_hint =>
      '物語が始まる時間、場所、関係性、状況を説明してください。';

  @override
  String get creator_scene_edit_opening_label => 'キャラクターの導入';

  @override
  String get creator_scene_edit_opening_hint =>
      'キャラクターがこの物語に登場したときの最初の反応やセリフを書いてください。';

  @override
  String get creator_scene_edit_opening_note =>
      'キャラクターの導入が、このシーンの第一幕となります。その後の会話も、キャラクター本来の設定を軸に続いていきます。';

  @override
  String get creator_scene_edit_save_changes => '変更を保存';

  @override
  String get creator_scene_edit_save_scene => 'シーンを保存';

  @override
  String get creator_scene_edit_error_title_required => 'シーンタイトルを入力してください。';

  @override
  String get creator_scene_edit_error_description_required => 'シーン説明を入力してください。';

  @override
  String get creator_scene_edit_error_opening_required => 'キャラクターの導入を入力してください。';

  @override
  String get creator_scene_edit_save_failed => '保存に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get creator_scene_delete_title => 'シーンを削除しますか？';

  @override
  String get creator_scene_delete_target_fallback => 'このシーン';

  @override
  String creator_scene_delete_confirm(String sceneTitle) {
    return '「$sceneTitle」を削除しますか？削除すると元に戻せません。';
  }

  @override
  String get creator_scene_delete_failed => '削除に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get creator_scene_empty_title => 'クリエイターシーンはまだありません';

  @override
  String creator_scene_empty_description(String characterName) {
    return '$characterNameの異なる世界線を書いて、\nプレイヤーが別の物語から始められるようにしましょう。';
  }

  @override
  String get creator_scene_add => 'シーンを追加';

  @override
  String get creator_scene_unnamed => 'タイトル未設定のシーン';

  @override
  String creator_scene_opening(String opening) {
    return 'キャラクターの導入：$opening';
  }

  @override
  String get creator_scene_edit => '編集';

  @override
  String get creator_scene_delete => '削除';

  @override
  String get creator_scene_title => 'クリエイターシーン';

  @override
  String get creator_scene_character_unavailable => '現在、キャラクター情報を読み込めません。';

  @override
  String get creator_scene_load_failed =>
      'シーンの読み込みに失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get creator_scene_heading => 'キャラクターに異なる物語の始まりを作成';

  @override
  String get custom_scene_edit_heading_edit => 'あなただけの物語を調整しましょう';

  @override
  String get custom_scene_edit_heading_add => 'このチャットだけの物語を書きましょう';

  @override
  String get custom_scene_edit_description_hint =>
      '物語が始まる時間、場所、関係性、そして始めたい状況を説明してください。';

  @override
  String get custom_scene_edit_note =>
      '自分で作成したシーンには、あらかじめ設定されたキャラクターの導入はありません。開始すると、キャラクターはシーン説明と本来の設定に沿って物語に登場します。';

  @override
  String get moment_create_no_mentionable_characters =>
      '現在、メンションできるキャラクターはいません。';

  @override
  String get moment_create_mention_my_characters => '自分のキャラクターをメンション';

  @override
  String get moment_create_no_matching_characters => '該当するキャラクターが見つかりません';

  @override
  String get moment_create_my_character => '自分のキャラクター';

  @override
  String get moment_create_friend_character => 'フレンドのキャラクター';

  @override
  String get moment_create_public_visibility_hint => '投稿はモーメントウォールに表示されます';

  @override
  String get moment_create_private_visibility_hint => '指定された範囲内でのみ表示されます';

  @override
  String get moment_create_add_image => '画像を追加';

  @override
  String get moment_create_mention_character => 'キャラクターをメンション';

  @override
  String get moment_edit_content_hint => '今の気持ちをシェア...';

  @override
  String get moment_forward_chat_preview => '【投稿をシェアしました】';

  @override
  String get feedback_image_too_large => '画像サイズは10MB以下にしてください';

  @override
  String get feedback_image_pick_failed => '画像を選択できませんでした。しばらくしてからもう一度お試しください';

  @override
  String get feedback_category_general => '一般的な問題';

  @override
  String get feedback_category_bug => '不具合の報告';

  @override
  String get feedback_category_suggestion => '機能の提案';

  @override
  String get feedback_category_flower => 'フラワーポイントの問題';

  @override
  String get feedback_category_payment => 'チャージ／支払いの問題';

  @override
  String get feedback_category_ai_reply => 'AIの返信に関する問題';

  @override
  String get feedback_category_character_report => 'キャラクターを通報';

  @override
  String get feedback_category_moment_report => '投稿を通報';

  @override
  String get feedback_screenshot_required_error =>
      '状況を確認するため、この種類の問題には画面のスクリーンショットを添付してください';

  @override
  String get feedback_login_required => '報告を送信するにはログインしてください';

  @override
  String get feedback_mail_received_title => '【受付完了】ご報告を受け付けました';

  @override
  String feedback_mail_received_body(String caseNumber) {
    return 'ご報告を受け付けました。できるだけ早く状況を確認いたします。\n\n受付番号：$caseNumber\n\nサポートから追加の回答がある場合は、LoveyDoveyのメールボックスを通じてお知らせします。';
  }

  @override
  String get feedback_submit_success => '報告を送信しました。ご意見ありがとうございます！';

  @override
  String get feedback_submit_failed => '送信に失敗しました。ネットワーク接続を確認して、もう一度お試しください';

  @override
  String get feedback_category_section_title => '問題の種類';

  @override
  String get feedback_reported_content_title => '報告対象のコンテンツ';

  @override
  String get feedback_screenshot_required_title => '問題のスクリーンショット（必須）';

  @override
  String get feedback_image_optional_title => '追加画像（任意）';

  @override
  String get feedback_screenshot_required_description =>
      '実際の状況を確認するため、問題が発生したときのスクリーンショットを添付してください。';

  @override
  String get feedback_image_optional_description =>
      '関連する画像がある場合は、確認のために添付することもできます。';

  @override
  String get feedback_footer_message =>
      '皆さまのご意見は、ゲーム体験の継続的な改善に役立てられます。ありがとうございます！';

  @override
  String get feedback_select_image_semantics => '報告用の画像を選択';

  @override
  String get feedback_opening_gallery => 'ギャラリーを開いています…';

  @override
  String get feedback_select_image_upload => 'ここをタップしてアップロードする画像を選択';

  @override
  String get feedback_image_requirements => 'JPG・PNG対応、1枚につき10MBまで';

  @override
  String get feedback_submitting_semantics => '送信中';

  @override
  String get feedback_submit_semantics => '報告を送信';

  @override
  String get feedback_submit_button => '送信';

  @override
  String get feedback_remove_image => '画像を削除';

  @override
  String get feedback_selected_image => '画像を選択済み';

  @override
  String get feedback_change_image => '変更';

  @override
  String get profile_backpack_title => '私だけのバッグと特典';

  @override
  String get profile_backpack_total_spent => '現在までのロマンチックな絆';

  @override
  String profile_backpack_total_spent_amount(int amount) {
    return 'NT\$ $amount';
  }

  @override
  String get profile_backpack_physical_gift_status => '現物ギフトボックスの解放状況：';

  @override
  String get profile_backpack_vip_gift_title => '【最愛ランク】VIP限定現物ギフトボックス';

  @override
  String get profile_backpack_vip_gift_contents =>
      '内容：限定手書きレター＋キャラクターモチーフのぬいぐるみ＋公式感謝状';

  @override
  String get profile_backpack_edit_shipping_info => '配送先情報を変更';

  @override
  String get profile_backpack_unlock_shipping_info => '解放済み！タップして配送先情報を入力';

  @override
  String get profile_backpack_shipping_registered =>
      '配送先住所を登録しました。できるだけ早く準備いたします！';

  @override
  String profile_backpack_amount_remaining(int amount) {
    return 'あとNT\$ $amountで現物の豪華特典を解放できます！';
  }

  @override
  String get profile_backpack_hint => 'ヒント：その他の外観やアバターフレームはバッグから確認できます。';

  @override
  String get profile_backpack_close => '閉じる';

  @override
  String get profile_physical_gift_title => '【最愛ランク】現物ギフトボックス解放';

  @override
  String get profile_physical_gift_description =>
      '「LoveyDovey」への格別なご愛顧、誠にありがとうございます！\n以下の配送先情報をご入力ください。限定の手書きレターとキャラクターモチーフのぬいぐるみをお届けします：';

  @override
  String get profile_physical_gift_recipient_name => '受取人の本名';

  @override
  String get profile_physical_gift_phone => '電話番号';

  @override
  String get profile_physical_gift_address => '配送先住所（郵便番号を含む）';

  @override
  String get profile_physical_gift_character_name => '希望するキャラクターのぬいぐるみ名';

  @override
  String get profile_physical_gift_character_hint => '例：希望するキャラクター名を入力';

  @override
  String get profile_physical_gift_fill_later => 'あとで入力';

  @override
  String get profile_physical_gift_required_error =>
      '配送先情報と希望するキャラクター名をすべて入力してください！';

  @override
  String get profile_physical_gift_submit_success =>
      '配送先情報を送信しました！現物のサプライズを楽しみにお待ちください！';

  @override
  String get profile_physical_gift_confirm_submit => '送信する';

  @override
  String get profile_tooltip_announcement => 'お知らせ';

  @override
  String get profile_tooltip_settings => '設定';

  @override
  String get profile_tooltip_backpack => 'マイバッグ';

  @override
  String get profile_backpack_menu_title => 'マイバッグ';

  @override
  String get profile_about_me_title => '私について';

  @override
  String get profile_tab_bio_title => '自己紹介';

  @override
  String get profile_check_in_done => 'チェックイン済み';

  @override
  String get profile_check_in => 'チェックイン';

  @override
  String get profile_check_in_done_subtitle => '今日はもう足跡を残しました';

  @override
  String get profile_check_in_not_done_subtitle => '今日はまだチェックインしていません';

  @override
  String get profile_likes_label => 'いいね';

  @override
  String get profile_heartbeat_diary_subtitle => 'ときめいた瞬間を記録';

  @override
  String get profile_create_scene => 'シーンを作成';

  @override
  String get profile_link_invalid => 'リンクの形式が正しくありません';

  @override
  String get profile_link_open_failed => 'このリンクを開けません';

  @override
  String get profile_link_default_name => 'マイリンク';

  @override
  String get profile_publish_moment_short => '今をつづる';

  @override
  String edit_profile_default_link_name(int index) {
    return 'マイリンク $index';
  }

  @override
  String get edit_profile_done => '完了';

  @override
  String get edit_profile_social_links => 'SNSとリンク';

  @override
  String get edit_profile_add_link => 'リンクを追加';

  @override
  String get edit_profile_link_name_hint => 'リンク名';

  @override
  String get edit_profile_link_url_hint => 'リンクを入力';

  @override
  String get theme_name_starlight => '星明かりの紫';

  @override
  String get theme_name_sakura => '桜色';

  @override
  String get theme_name_ocean => 'オーシャンブルー';

  @override
  String get theme_name_sunset => 'サンセットオレンジ';

  @override
  String get theme_name_mint => 'フォレストミント';

  @override
  String get theme_name_midnight => 'ミッドナイトモード';

  @override
  String get theme_name_custom => 'カスタムカラー';

  @override
  String get theme_selection_choose_theme => 'テーマカラーを選択';

  @override
  String get theme_selection_title => '雰囲気を変える';

  @override
  String get theme_selection_description =>
      'お気に入りのテーマカラーを選んで、LoveyDoveyをもっと自分らしく彩りましょう。';

  @override
  String get theme_selection_preview => 'プレビュー';

  @override
  String get theme_selection_characters => 'キャラクター';

  @override
  String get theme_selection_posts => '投稿';

  @override
  String theme_selection_previewing(String themeName) {
    return '現在のプレビュー：$themeName';
  }

  @override
  String get theme_selection_apply => 'テーマを適用';

  @override
  String get theme_selection_restore_default => 'デフォルトに戻す';

  @override
  String get theme_selection_choose_color => '自分だけのカラーを選択';

  @override
  String theme_selection_applied(String themeName) {
    return '「$themeName」を適用しました';
  }

  @override
  String get welcome_guide_help => 'プレイガイド';

  @override
  String get welcome_guide_start => '旅を始める';

  @override
  String get welcome_guide_next => '次へ';

  @override
  String get welcome_guide_welcome_title => '「LoveyDovey」へようこそ';

  @override
  String get welcome_guide_welcome_description =>
      'ここでは、ひとつひとつの出会いが、忘れられない物語になるかもしれません。「LoveyDovey」とともに、ふたりだけの素敵な思い出を紡いでいきましょう。';

  @override
  String get welcome_guide_chat_title => 'チャットモード';

  @override
  String get welcome_guide_chat_description =>
      '「LoveyDovey」には複数のチャットモードがあり、それぞれ異なる交流を楽しめます。';

  @override
  String get welcome_guide_daily_title => '日常モード';

  @override
  String get welcome_guide_daily_description =>
      'お互いに寄り添い、日々の出来事を分かち合いながら、気軽な会話を楽しみましょう。';

  @override
  String get welcome_guide_story_title => 'ストーリーモード';

  @override
  String get welcome_guide_story_description =>
      'キャラクターの物語を進め、特別なストーリーや交流をさらに解放しましょう。';

  @override
  String get welcome_guide_immersive_title => '没入モード';

  @override
  String get welcome_guide_immersive_description =>
      'より深く入り込める、臨場感あふれる会話を体験できます。';

  @override
  String get welcome_guide_chat_more => 'チャットモードの詳しい紹介は「ゲームヘルプ」から確認できます。';

  @override
  String get welcome_guide_encounter_title => '出会い';

  @override
  String get welcome_guide_encounter_description =>
      'キャラクターには、それぞれ個性豊かな性格、物語、声があります。お気に入りのキャラクターに出会ったら、フレンドに追加して会話や交流を楽しみ、日常を分かち合いながら、ふたりだけの思い出を作りましょう。';

  @override
  String get welcome_guide_more_title => 'さらに楽しめるコンテンツ';

  @override
  String get welcome_guide_more_description =>
      'コレクション、クリエイター、ショップなど、多彩な機能も用意されています。詳しくは「ゲームヘルプ」をご覧ください。';

  @override
  String preference_selection_max_error(int count) {
    return '選択できる好みは最大$count個です。';
  }

  @override
  String get preference_selection_save_failed =>
      '現在、好みを保存できません。しばらくしてからもう一度お試しください。';

  @override
  String get preference_selection_title => 'どんな人と出会いたいですか？';

  @override
  String get preference_selection_description =>
      '好きなタイプを3～5個選んでください。LoveyDoveyがここからあなたのことを知っていきます。';

  @override
  String get preference_selection_recommendation_note =>
      '今後は実際の交流に合わせて、あなたにより合うおすすめへ少しずつ調整されます。';

  @override
  String get preference_selection_selected => '選択済み';

  @override
  String get preference_selection_start => 'ここから始める';

  @override
  String get preference_group_personality => '性格・雰囲気';

  @override
  String get preference_group_relationship_age => '関係性・年齢差';

  @override
  String get preference_group_story => '物語の雰囲気';

  @override
  String get preference_tag_gentle => '優しい';

  @override
  String get preference_tag_cold => 'クール';

  @override
  String get preference_tag_scheming => '腹黒';

  @override
  String get preference_tag_tsundere => 'ツンデレ';

  @override
  String get preference_tag_loyal => '忠犬系';

  @override
  String get preference_tag_yandere => 'ヤンデレ';

  @override
  String get preference_tag_mysterious => 'ミステリアス';

  @override
  String get preference_tag_healing => '癒やし系';

  @override
  String get preference_tag_gap_moe => 'ギャップ萌え';

  @override
  String get preference_tag_older => '年上';

  @override
  String get preference_tag_younger => '年下';

  @override
  String get preference_tag_ceo => '俺様社長';

  @override
  String get preference_tag_school => '学園';

  @override
  String get preference_tag_workplace => '職場';

  @override
  String get preference_tag_ancient => '時代もの';

  @override
  String get preference_tag_nonhuman => '人外';

  @override
  String get encounter_load_failed => '出会いのデータを読み込めませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get encounter_no_available_characters => '現在、出会えるキャラクターはいません';

  @override
  String get encounter_category_empty => '現在、このカテゴリーにキャラクターはいません';

  @override
  String get encounter_category_all => 'すべて';

  @override
  String get encounter_category_xianxia => '仙侠';

  @override
  String get encounter_category_childhood_friend => '幼なじみ';

  @override
  String get encounter_category_master_disciple => '師弟';

  @override
  String get encounter_category_sweet_romance => '溺愛';

  @override
  String get encounter_category_other => 'その他';

  @override
  String get character_edit_tab_character_settings => 'キャラクター設定';

  @override
  String get character_edit_test => 'テスト';

  @override
  String get character_edit_supporting_basic_info => '基本情報';

  @override
  String get character_edit_supporting_main_setting => 'メインキャラクターとの関係';

  @override
  String get character_edit_supporting_main_description =>
      'このサブキャラクターとメインキャラクターの関係や、物語での立ち位置を説明してください。';

  @override
  String get character_edit_banner_preview_hint => '画像をタップすると拡大表示できます';

  @override
  String get character_edit_main_photo_hint => '1枚目の画像がメインアイコンとして使用されます';

  @override
  String get character_edit_other_photos => 'その他のキャラクター画像';

  @override
  String get character_edit_photo_action_hint =>
      '画像をタップするとプレビューできます。鉛筆アイコンから画像設定を編集できます';

  @override
  String character_edit_over_limit_warning(String label, String count) {
    return '$labelが$count文字を超えています。修正してから公開してください。';
  }

  @override
  String get memo_notification_channel_name => 'メモのリマインダー';

  @override
  String get memo_notification_channel_description => '設定したメモをキャラクターがお知らせします';

  @override
  String memo_notification_title(String characterName) {
    return '$characterNameからのリマインダー';
  }

  @override
  String memo_notification_tsundere(String memoContent) {
    return 'べ、別に心配してるわけじゃない。ただ忘れられたら困るだけ。今日、忘れないで：$memoContent';
  }

  @override
  String memo_notification_dominant(String memoContent) {
    return '予定はもう覚えておいた。時間どおりに済ませろ。今日、忘れるな：$memoContent';
  }

  @override
  String memo_notification_yandere(String memoContent) {
    return '忘れちゃだめだよ？　私はずっと覚えてるから。今日、忘れないで：$memoContent';
  }

  @override
  String memo_notification_gentle(String memoContent) {
    return '忙しくて忘れてしまいそうだから、ちょっとだけお知らせに来たよ。今日、忘れないでね：$memoContent';
  }

  @override
  String memo_notification_cold(String memoContent) {
    return 'ひとつ伝えておく。今日、忘れないように：$memoContent';
  }

  @override
  String memo_notification_sunny(String memoContent) {
    return 'ねえ、今日はまだ大事なことがあるよ！　忘れないでね：$memoContent';
  }

  @override
  String memo_notification_lazy(String memoContent) {
    return 'このまま寝転んでいたいけど、一応知らせておくね。今日、忘れないで：$memoContent';
  }

  @override
  String memo_notification_older(String memoContent) {
    return 'いい子だから、今日のことを忘れないようにね。覚えておいて：$memoContent';
  }

  @override
  String memo_notification_younger(String memoContent) {
    return 'ちゃんと代わりに覚えておいたよ！　今日、忘れないでね：$memoContent';
  }

  @override
  String memo_notification_mechanical(String memoContent) {
    return 'リマインダーを起動しました。本日のタスク：$memoContent';
  }

  @override
  String memo_notification_default(String memoContent) {
    return '今日、忘れないで：$memoContent';
  }

  @override
  String get recommendation_load_failed =>
      '現在、おすすめを読み込めません。しばらくしてからもう一度お試しください。';

  @override
  String get recommendation_reload => '再読み込み';

  @override
  String get recommendation_empty => '現在、おすすめできるキャラクターはいません。';

  @override
  String get recommendation_title => 'あなたのために選んだ出会い';

  @override
  String get recommendation_featured_title => 'まずはこの人たちから';

  @override
  String get recommendation_featured_subtitle => 'あなたに特に合いそうな出会いを先にご紹介します。';

  @override
  String get recommendation_matched_behavior_title => 'あなたの好みに近づいています';

  @override
  String get recommendation_matched_initial_title => '最初に選んだ好みに合わせて';

  @override
  String get recommendation_matched_behavior_subtitle =>
      '4日目以降は、最近の交流も表示順に反映されます。';

  @override
  String get recommendation_matched_initial_subtitle =>
      '今は最初に選んだタグを使って、候補を絞り込んでいます。';

  @override
  String get recommendation_explore_title => 'こんな人も好きかも';

  @override
  String get recommendation_explore_subtitle =>
      'ときには思いがけない相手と出会えるよう、ランダムなおすすめも少し残しています。';

  @override
  String get recommendation_refreshing => '新しい出会いを探しています……';

  @override
  String get recommendation_badge_for_you => 'あなたへのおすすめ';

  @override
  String get recommendation_badge_featured => '注目の出会い';

  @override
  String get recommendation_badge_explore => '新しい発見';

  @override
  String get recommendation_default_occupation_hint =>
      '少し覗いてみませんか？　次に心ときめく相手かもしれません。';

  @override
  String get recommendation_explore_fallback =>
      'いつもと違う方向にも、思いがけないときめきがあるかもしれません。';

  @override
  String get recommendation_behavior_hint_similar_type =>
      '最近、このタイプのキャラクターをよく見ています';

  @override
  String get recommendation_behavior_hint_forming => '最近の交流から好みが少しずつ見えてきました';

  @override
  String get recommendation_behavior_hint_recent => '最近の交流をもとに選びました';

  @override
  String recommendation_reason_liked_tags(String tags) {
    return '「$tags」が好きなあなたへ';
  }

  @override
  String get recommendation_reason_popular => '最近、多くの人がこのキャラクターを見ています';

  @override
  String get recommendation_reason_default => '次の運命の出会いになるかもしれません';

  @override
  String get scene_delete_title => 'シーンを削除しますか？';

  @override
  String scene_delete_content(String title) {
    return '「$title」を削除しますか？削除すると元に戻せません。';
  }

  @override
  String get scene_unnamed => 'タイトル未設定のシーン';

  @override
  String get scene_cancel => 'キャンセル';

  @override
  String get scene_delete => '削除';

  @override
  String get scene_delete_failed => '削除に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get scene_start_failed => '現在、シーンを開始できません。しばらくしてからもう一度お試しください。';

  @override
  String get scene_end_title => 'シーンを終了しますか？';

  @override
  String get scene_end_content => '終了すると通常のチャットに戻ります。現在の会話履歴は削除されません。';

  @override
  String get scene_end_action => 'シーンを終了';

  @override
  String get scene_ended => 'シーンを終了しました';

  @override
  String get scene_end_failed => '現在、シーンを終了できません。しばらくしてからもう一度お試しください。';

  @override
  String get scene_active_label => '進行中';

  @override
  String scene_opening(String opening) {
    return 'キャラクターの導入：$opening';
  }

  @override
  String get scene_edit => '編集';

  @override
  String get scene_start => 'シーンを開始';

  @override
  String get scene_creator_load_failed => 'クリエイターシーンを読み込めませんでした。';

  @override
  String get scene_creator_empty_title => 'クリエイターシーンはまだありません';

  @override
  String get scene_creator_empty_body => 'このキャラクターのクリエイターは、まだ追加の物語を作成していません。';

  @override
  String get scene_custom_load_failed => '自作シーンを読み込めませんでした。';

  @override
  String get scene_custom_empty_title => '自分のシーンはまだありません';

  @override
  String get scene_custom_empty_body => 'このチャットだけの、あなただけの物語を作りましょう。';

  @override
  String get scene_add => 'シーンを追加';

  @override
  String get scene_title => 'シーン';

  @override
  String get scene_tab_creator => 'クリエイターシーン';

  @override
  String get scene_tab_custom => '自分で作成';

  @override
  String get chat_book_player => 'プレイヤー';

  @override
  String get chat_book_title => '会話記録';

  @override
  String get chat_book_export_pdf => 'PDFを書き出す';

  @override
  String get chat_book_brand => '— LoveyDovey';

  @override
  String get chat_book_change_cover => '表紙を変更';

  @override
  String get chat_book_cover_subtitle => 'ふたりで過ごした時間 · 会話記念ブック';

  @override
  String get chat_book_choose_cover => '記念ブックの表紙を選択';

  @override
  String get chat_book_initial_story => '最初の物語';

  @override
  String chat_book_transcript_title(String characterName) {
    return '$characterName · 会話記録';
  }

  @override
  String chat_book_continuation(String name) {
    return '$name · 続き';
  }

  @override
  String get chat_book_previous_page => '前のページ';

  @override
  String get chat_book_next_page => '次のページ';

  @override
  String get chat_book_photo_message => '〔写真〕';

  @override
  String get chat_book_audio_message => '〔ボイスメッセージ〕';

  @override
  String get chat_book_generic_message => '〔メッセージ〕';

  @override
  String chat_book_export_failed(String error) {
    return 'PDFの書き出しに失敗しました：$error';
  }

  @override
  String email_policy_open_failed(String title) {
    return '$titleを開けませんでした。ネットワーク接続を確認して、もう一度お試しください。';
  }

  @override
  String email_policy_read_instruction(String title) {
    return '最初に$titleを開き、全文をお読みください。読み終えたら「LoveyDovey」に戻ると、「確認して同意する」を押せるようになります。';
  }

  @override
  String get email_policy_opening => '開いています……';

  @override
  String email_policy_read_full(String title) {
    return '$titleの全文を読む';
  }

  @override
  String email_policy_opened_ready(String title) {
    return '$titleを開きました。同意を確認できます。';
  }

  @override
  String email_policy_not_opened(String title) {
    return '$titleをまだ開いていません。';
  }

  @override
  String get email_policy_cancel_login => 'ログインをキャンセル';

  @override
  String get email_policy_agree => '確認して同意する';

  @override
  String get email_policy_status_check_failed =>
      '現在、規約への同意状況を確認できません。しばらくしてからもう一度お試しください。';

  @override
  String get email_policy_login_notice =>
      '初回ログイン時または規約の更新時に、利用規約とプライバシーポリシーをお読みいただき、同意をお願いしています。';

  @override
  String get email_policy_refresh => '更新';

  @override
  String get email_policy_page_load_failed => 'ページを読み込めませんでした';

  @override
  String get email_policy_check_network => 'ネットワーク接続を確認して、もう一度お試しください。';

  @override
  String get email_policy_reload => '再読み込み';

  @override
  String get login_method_info_google_title => 'Googleでかんたんログイン';

  @override
  String get login_method_info_apple_title => 'Appleでログイン';

  @override
  String get login_method_info_facebook_title => 'Facebookでログイン';

  @override
  String get login_method_info_email_title => 'LoveyDoveyアカウント（メール）';

  @override
  String get login_method_info_email_provider => 'LoveyDoveyアカウント（メール）';

  @override
  String login_method_info_content(String providerName) {
    return '$providerNameを使用して「LoveyDovey」にログインします。\n\nご注意ください：\n\n• $providerNameとその他のログイン方法は、それぞれ異なるアカウントとして扱われます。\n\n• $providerNameでアカウントを作成した場合は、今後も同じ方法でログインしてください。\n\n• キャラクターデータ、チャット履歴、購入内容は、ほかのログイン方法で作成したアカウントとは共有されません。\n\n異なるアカウントが作成され、データを共有できなくなることを防ぐため、初回ログイン後も同じログイン方法を使用することをおすすめします。';
  }

  @override
  String get login_method_info_got_it => 'わかりました';

  @override
  String creator_studio_delete_failed(String error) {
    return '削除に失敗しました：$error';
  }

  @override
  String get creator_studio_subtitle => 'ひらめきを集め、キャラクターを整理しながら、ゆっくり作品を仕上げましょう';

  @override
  String creator_studio_load_failed(String error) {
    return 'スタジオを読み込めませんでした：$error';
  }

  @override
  String get creator_studio_add_character => 'キャラクターを追加';

  @override
  String get creator_studio_public_title => '公開キャラクター';

  @override
  String get creator_studio_public_subtitle => '公開済みで、ほかのプレイヤーも見つけることができます';

  @override
  String get creator_studio_public_empty => '現在、公開キャラクターはいません';

  @override
  String get creator_studio_private_title => '非公開キャラクター';

  @override
  String get creator_studio_private_subtitle => '自分だけが見ることができます';

  @override
  String get creator_studio_private_empty => '現在、非公開キャラクターはいません';

  @override
  String get creator_studio_draft_title => '下書き';

  @override
  String get creator_studio_draft_subtitle => 'まだ完成していない作品';

  @override
  String get creator_studio_draft_empty => '現在、未完成の下書きはありません';

  @override
  String get creator_studio_draft_empty_title => '下書きはまだありません';

  @override
  String get creator_studio_draft_empty_hint => 'ひらめいたら、まずはここに残しておきましょう';

  @override
  String get creator_studio_status_public => '公開中';

  @override
  String get creator_studio_status_private => '非公開';

  @override
  String get creator_studio_status_draft => '下書き';

  @override
  String get creator_studio_character_load_failed => 'キャラクターデータを読み込めませんでした';

  @override
  String get creator_studio_delete_draft_tooltip => '下書きを削除';

  @override
  String get creator_studio_unnamed_creator => '名前未設定のクリエイター';

  @override
  String get creator_studio_no_bio => '自己紹介はまだ入力されていません';

  @override
  String get chat_input_tools => '機能';

  @override
  String get chat_input_expand_tools => '機能を表示';

  @override
  String get chat_input_stop => '停止';

  @override
  String get chat_input_send => '送信';

  @override
  String get chat_side_menu_section_chat => 'チャット';

  @override
  String get chat_side_menu_section_relationship => '関係';

  @override
  String get chat_side_menu_section_memory => '記憶管理';

  @override
  String get character_navigator_confidential_title => '機密ファイル';

  @override
  String get character_navigator_unavailable_message =>
      'このキャラクターは非公開に変更されたか、公開停止、規約違反による保管、または削除された可能性があります。';

  @override
  String get character_navigator_got_it => 'わかりました';

  @override
  String get character_navigator_load_failed_title => '読み込みに失敗しました';

  @override
  String get character_navigator_load_failed_message =>
      '現在、キャラクターデータを読み込めません。しばらくしてからもう一度お試しください。';

  @override
  String get character_navigator_confirm => 'OK';

  @override
  String get character_profile_add_bookmark => 'キャラクターを保存';

  @override
  String get character_profile_remove_bookmark => '保存を解除';

  @override
  String get character_profile_pronoun_female => '彼女';

  @override
  String get character_profile_pronoun_male => '彼';

  @override
  String get character_profile_pronoun_neutral => 'そのキャラクター';

  @override
  String get chat_home_pin_limit_reached =>
      '固定できるチャットは3件までです。先にほかのチャットの固定を解除してください。';

  @override
  String get chat_home_pinned_success => 'チャットを固定しました';

  @override
  String get chat_home_unpinned_success => '固定を解除しました';

  @override
  String chat_home_pin_update_failed(String error) {
    return '固定状態を更新できませんでした：$error';
  }

  @override
  String get chat_home_unpin => '固定を解除';

  @override
  String get chat_home_pin => 'チャットを固定';

  @override
  String chat_home_time_label(String time) {
    return '時間：$time';
  }

  @override
  String get main_check_in_already_done => '今日はすでにチェックイン済みです';

  @override
  String get nav_recommend => 'おすすめ';

  @override
  String get moments_auto_reply_title => 'AIによるプレイヤー投稿への自動返信を許可';

  @override
  String get moments_auto_reply_description =>
      'オンにすると、このキャラクターがプレイヤーの投稿に返信するようシステムから選ばれることがあります。';

  @override
  String get mailOriginalQuestionLabel => '最初に尋ねたこと';

  @override
  String get hidden_moments_empty_hint => '非表示にした投稿はまだありません';

  @override
  String get moment_search_unavailable => '現在、検索を利用できません。しばらくしてからもう一度お試しください。';

  @override
  String get moment_search_hint => '公開投稿、キャラクター、クリエイターを検索';

  @override
  String get moment_search_instruction => '投稿内容、キャラクター名、またはクリエイター名を入力';

  @override
  String get moment_search_no_results => '関連する公開投稿が見つかりません';

  @override
  String get settingsErrorTitle => 'エラーが発生しました';

  @override
  String get settingsChangePasswordSubtitle => '現在のパスワードを確認して、新しいログインパスワードを設定';

  @override
  String get settingsCreatorGuidelines => 'クリエイターガイドライン';

  @override
  String get settingsPlayGuide => 'プレイガイド';

  @override
  String get language_selection_subtitle => '使い慣れた言語を選択してください';

  @override
  String get search_character_hint => 'キャラクター、クリエイター、職業、タグを検索';

  @override
  String get search_character_clear => 'クリア';

  @override
  String get search_character_recent => '最近の検索';

  @override
  String get search_character_load_failed =>
      '検索データを読み込めませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get search_character_popular => '最近みんなが注目しているキャラクター';

  @override
  String search_character_result_count(int count) {
    return '$count人のキャラクターが見つかりました';
  }

  @override
  String get shop_tab_monthly => 'マンスリーパス';

  @override
  String shop_joined_days(int days) {
    return 'LoveyDoveyに来てから$days日目';
  }

  @override
  String get shop_vip_tier_1_title => 'ひと目惚れ';

  @override
  String get shop_vip_tier_1_reward => 'フラワー20ポイント＋初心者限定称号';

  @override
  String get shop_vip_tier_2_title => 'きらめく鼓動';

  @override
  String get shop_vip_tier_2_reward => '限定アバターフレーム【きらめく鼓動】';

  @override
  String get shop_vip_tier_3_title => '星空のささやき';

  @override
  String get shop_vip_tier_3_reward => '限定チャットバブル＋フラワー50ポイント';

  @override
  String get shop_vip_tier_4_title => 'ロマンチックな夕暮れ';

  @override
  String get shop_vip_tier_4_reward => '限定アプリアイコン';

  @override
  String get shop_vip_tier_5_title => '胸のときめき';

  @override
  String get shop_vip_tier_5_reward => '画面タップエフェクト（Lottie）＋フラワー100ポイント';

  @override
  String get shop_vip_tier_6_title => '永遠の誓い';

  @override
  String get shop_vip_tier_6_reward => '上級アニメーションアバターフレーム＋フラワー200ポイント';

  @override
  String get shop_vip_tier_7_title => '魂の邂逅';

  @override
  String get shop_vip_tier_7_reward => 'アニメーションチャットバブル＋限定上級称号';

  @override
  String get shop_vip_tier_8_title => 'あなただけを想って';

  @override
  String get shop_vip_tier_8_reward => '最高級アニメーションネームプレート＋フラワー500ポイント';

  @override
  String get shop_vip_tier_9_title => 'きらめく銀河';

  @override
  String get shop_vip_tier_9_reward => '限定登場Lottieエフェクト＋専用カスタマーサポート';

  @override
  String get shop_vip_tier_10_title => '最愛ランク';

  @override
  String get shop_vip_tier_10_reward => '【VIP限定現物ギフトボックス】（手書きレター＋キャラクターぬいぐるみ）';

  @override
  String get shop_vip_total_bond => '累計ロマンチックな絆';

  @override
  String get shop_vip_all_unlocked => 'すべての最高級特典を解放しました！';

  @override
  String shop_vip_next_unlock(int amount) {
    return 'あとNT\$ $amountチャージすると次のランクを解放できます';
  }

  @override
  String get call_connecting => '通話に接続しています...';

  @override
  String get call_listening_auto_send => '聞き取り中...（話し終えると自動で送信されます）';

  @override
  String get call_listening_release_to_send => '聞き取り中...（指を離すと送信されます）';

  @override
  String call_sending_transcript(String text) {
    return ' $text\n\n（送信中...）';
  }

  @override
  String get help_translation_fallback =>
      'この言語のプレイガイドはまだ提供されていないため、一時的に繁体字中国語で表示します。';

  @override
  String get help_all_categories => 'すべて';

  @override
  String get help_subtitle_companion => '日常機能と便利なサポートツール';

  @override
  String get help_subtitle_ai_chat => 'チャット、音声、スマートインタラクション関連';

  @override
  String get help_subtitle_creation => 'キャラクター設定と創作機能関連';

  @override
  String get help_subtitle_explore => 'キャラクターやゲームコンテンツの探索';

  @override
  String get help_subtitle_care => '優しい寄り添いと日々の気遣い';

  @override
  String get help_subtitle_general => '一般的な機能と操作方法';

  @override
  String get chat_interact_fun => '楽しい遊び';

  @override
  String get memo_notification_permission_missing =>
      '通知が許可されていません。メモは保存されますが、システムからのリマインダーは表示されません。';

  @override
  String memo_saved_with_reminder(String characterName) {
    return 'メモを保存しました。$characterNameがリマインドしてくれます！';
  }

  @override
  String get memo_saved_without_notification => 'メモを保存しましたが、通知はまだ許可されていません。';

  @override
  String memo_updated_with_reminder(String characterName) {
    return 'メモを更新しました。$characterNameがリマインドしてくれます！';
  }

  @override
  String get memo_updated_without_notification => 'メモを更新しましたが、現在は通知が許可されていません。';

  @override
  String memo_load_error(String error) {
    return 'データの読み込み中にエラーが発生しました：$error';
  }

  @override
  String get story_summary_content_required => 'ストーリーの内容を入力してください';

  @override
  String get story_summary_edit_hint => '二人の物語を書いてください...';

  @override
  String get profile_section_basic_info => '基本情報';

  @override
  String get profile_section_about_me => '私について';

  @override
  String get dice_duel_you => 'あなた';

  @override
  String get dice_duel_result_saved => '対決結果を保存しました！';

  @override
  String get dice_duel_rolling => '宇宙のエネルギーを集めています...';

  @override
  String get butterfly_loading_connecting => '時をつないでいます...';

  @override
  String get character_block_login_required => 'キャラクターをブロックするには、先にログインしてください';

  @override
  String get character_block_self_forbidden => '自分が作成したキャラクターはブロックできません';

  @override
  String get character_block_title => 'キャラクターをブロック';

  @override
  String character_block_confirm_message(String characterName) {
    return '「$characterName」をブロックしますか？\n\nブロックすると、出会いやモーメントなどのおすすめコンテンツにこのキャラクターが表示されなくなります。';
  }

  @override
  String get character_block_confirm => 'ブロックする';

  @override
  String character_block_success(String characterName) {
    return '「$characterName」をブロックしました';
  }

  @override
  String get character_block_failed => 'ブロックに失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get character_unblock_success => 'ブロックを解除しました';

  @override
  String get character_unblock_failed => 'ブロックの解除に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get character_report_login_required => 'キャラクターを通報するには、先にログインしてください';

  @override
  String get character_report_self_forbidden => '自分が作成したキャラクターは通報できません';

  @override
  String get character_report_submitted => '通報を送信しました。内容を確認いたします';

  @override
  String get character_report_open_failed =>
      '通報ページを開けませんでした。しばらくしてからもう一度お試しください';

  @override
  String chat_loader_error(String error) {
    return '読み込みに失敗しました：$error';
  }

  @override
  String get announcement_connection_failed => '接続に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get announcement_latest => '最新';

  @override
  String announcement_published_at(String date) {
    return '公開日時：$date';
  }

  @override
  String get announcement_operations_team => 'LoveyDovey運営チーム';

  @override
  String get legal_creator_guidelines => 'クリエイターガイドライン';

  @override
  String get legal_refresh => '更新';

  @override
  String get legal_page_load_failed => 'ページの読み込みに失敗しました';

  @override
  String get legal_check_connection_retry => 'インターネット接続を確認して、もう一度お試しください。';

  @override
  String get legal_reload => '再読み込み';

  @override
  String get chat_web_purchase_unavailable =>
      'Web版では現在、チャージをご利用いただけません。花ポイントの購入やサブスクリプションの登録には「LoveyDovey」アプリをご利用ください。';

  @override
  String get chat_dont_show_again => '今後このメッセージを表示しない';

  @override
  String get chat_menu_save_transcript => '会話履歴を保存';

  @override
  String get chat_menu_reply_model => '応答モデル';

  @override
  String get chat_reply_model_menu_tip => '応答モデルの場所が変わりました！右上のメニューから選択できます。';

  @override
  String get defaultProfileName => 'デフォルトプロフィール';

  @override
  String get creator_social_links_manage => 'ソーシャルリンクを管理';

  @override
  String get creator_social_links_title => '個人・ソーシャルリンク';

  @override
  String get creator_social_links_hint =>
      'クリエイターページで公開したいリンクを入力してください。未入力の項目は表示されません。';

  @override
  String get creator_social_links_website => '個人ウェブサイト';

  @override
  String get creator_social_links_saved => 'ソーシャルリンクを保存しました';

  @override
  String get creator_social_links_load_failed =>
      'ソーシャルリンクの読み込みに失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get creator_social_links_save_failed =>
      'ソーシャルリンクの保存に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get creator_social_links_open_failed => 'このリンクを開けませんでした';

  @override
  String get chat_regenerate_bottom_tip =>
      '「再生成」はここに移動しました！別の返答がほしいときはここから使えます。';

  @override
  String get chat_continue_bottom_tip =>
      '「続ける」はここに移動しました！キャラクターに続きを話してほしいときはここから使えます。';

  @override
  String get languageSelectionSubtitle => '使い慣れた言語を選んでください';

  @override
  String get chatStatusBarTitle => 'ステータス';

  @override
  String get chatStatusBarSubtitle => 'チャットに表示する情報を選択';

  @override
  String get chatStatusMood => '気分';

  @override
  String get chatStatusOutfit => '服装';

  @override
  String get chatStatusRelationship => '関係';

  @override
  String get chatStatusThought => '考え';

  @override
  String get chatStatusWeather => '天気';

  @override
  String get chatStatusCurrentState => '現在の状態';

  @override
  String get chatStatusAction => '動作';

  @override
  String get chatStatusAffinity => '好感度';

  @override
  String get chatPreferenceTitle => 'チャット設定';

  @override
  String get chatPreferenceSubtitle => 'この設定は現在のチャットだけに適用され、変更または削除するまで有効です。';

  @override
  String get chatPreferenceHint =>
      '例：\\n「ベイビー」と呼ばないで\\n返事を短めにして\\n私の行動や表情を頻繁に補わないで';

  @override
  String get chatPreferenceClear => 'クリア';

  @override
  String get chatSettingsDone => '完了';

  @override
  String get chat_mode_resonance => '共鳴';

  @override
  String get chat_mode_gemini_cost => '1日最初の10回は無料、その後1ポイント';

  @override
  String get chat_mode_gemini_desc => '気軽な会話や日常の寄り添いにおすすめ。';

  @override
  String get chat_mode_story_cost => '5ポイント';

  @override
  String get chat_mode_immersive_cost => '7ポイント';

  @override
  String get chat_mode_resonance_cost => '10ポイント';

  @override
  String get chat_mode_resonance_desc => '感情や関係性の緊張感、キャラクターの反応をより繊細に広げます。';

  @override
  String get chat_mode_gemini_cost_short => '花1個';

  @override
  String get chat_mode_story_cost_short => '花5個';

  @override
  String get chat_mode_immersive_cost_short => '花7個';

  @override
  String get chat_mode_resonance_cost_short => '花10個';

  @override
  String get notification_channel_chat_description =>
      'キャラクターからの最新返信やゲームのお知らせを受け取るために使用します。';

  @override
  String get subscription_star_contract_name => '恋恋拾光・星の契約';

  @override
  String moment_notification_comment_on_your_post(
      Object commentText, Object senderNickname) {
    return '$senderNicknameさんがあなたの投稿にコメントしました：「$commentText」';
  }

  @override
  String get moment_notification_new_reply_title => '投稿に新しい返信があります！💬';

  @override
  String get moment_notification_character_popularity_title =>
      'キャラクターの人気急上昇！🔥';

  @override
  String get font_size_small => '小';

  @override
  String get font_size_standard => '標準';

  @override
  String get font_size_slightly_large => 'やや大';

  @override
  String get font_size_large => '大';

  @override
  String get font_size_extra_large => '特大';

  @override
  String get font_selection_title => 'フォント';

  @override
  String get font_selection_description => 'ストーリーやチャットを読みやすいフォントを選んでください。';

  @override
  String get font_size_title => '文字サイズ';

  @override
  String get font_selection_tagline => '好きな彼と、もう一度ふたりだけの物語を綴ろう。';

  @override
  String font_selection_applied_message(Object value1) {
    return '「$value1」を適用しました';
  }

  @override
  String get font_selection_local_storage_note =>
      'フォントと文字サイズはすぐに反映され、この端末に保存されます。外観を初期設定に戻すと「拾光明朝＋標準サイズ」に戻ります。';

  @override
  String get inbox_customer_service_report => 'カスタマーサポートへの報告';

  @override
  String get inbox_content_text_message_player_title_send => 'プレイヤーが送信した件名';

  @override
  String get inbox_content_text_message_player_content_send => 'プレイヤーが送信した内容';

  @override
  String avatar_frame_equipped_message(Object value1) {
    return '「$value1」を装備しました';
  }

  @override
  String get avatar_frame_unequip_frame_snackbar => 'アバターフレームを外しました';

  @override
  String get avatar_frame_unequip_frame_message_event => 'イベントアバターフレーム';

  @override
  String get avatar_frame_message => 'アバターフレーム';

  @override
  String avatar_frame_load_failed(Object value1) {
    return 'アバターフレームの読み込みに失敗しました：$value1';
  }

  @override
  String get avatar_frame_parse_frames_message_select => '使用したいアバターフレームを選択';

  @override
  String get avatar_frame_parse_frames_message_event =>
      'イベントで獲得したアバターフレームは永久に保持され、いつでも変更・解除できます。';

  @override
  String get avatar_frame_parse_frames_title => 'アバターフレームを使用しない';

  @override
  String get avatar_frame_parse_frames_subtitle_avatar => '元のアバターを表示';

  @override
  String get avatar_frame_parse_frames_message_event_shop_redeem_current =>
      '所持しているアバターフレームはまだありません。\nイベントショップで交換するとここに表示されます。';

  @override
  String get avatar_frame_parse_frames_message_event_variant_b =>
      'イベント限定アバターフレーム';

  @override
  String get background_settings_message => '限定背景';

  @override
  String get background_title_exclusive_photo_current => '専用写真はまだありません';

  @override
  String get background_subtitle_unlock_character_photo =>
      '今後解放したキャラクター写真がここに表示されます。';

  @override
  String get background_title_login => 'ログインすると限定背景を確認できます';

  @override
  String get background_subtitle_redeem_chat_event =>
      'イベント交換で獲得したチャット背景はここに保存されます。';

  @override
  String get background_title => '限定背景をまだ獲得していません';

  @override
  String get background_subtitle_event_shop_redeem_chat =>
      'イベントショップで交換したチャット背景が今後ここに表示されます。';

  @override
  String get background_is_limited_background_type_message_chat_event =>
      'イベント限定チャット背景';

  @override
  String background_is_limited_background_type_message_current_chat(
      Object value1) {
    return '「$value1」を現在のチャット背景に設定しますか？';
  }

  @override
  String character_edit_message_character_settings(Object value1) {
    return '【角色性格與設定】\n$value1';
  }

  @override
  String character_edit_message(Object value1) {
    return '【說話語氣與風格】\n$value1';
  }

  @override
  String character_edit_message_variant_b(Object value1) {
    return '【社交與環境互動】\n$value1';
  }

  @override
  String character_edit_save_to_draft_message_current_character(Object value1) {
    return '現在のメインキャラクター：【$value1】\n';
  }

  @override
  String character_edit_message_back(Object result) {
    return '🚪 返回原本的 ProfilePage：$result';
  }

  @override
  String character_edit_save_character_message(Object value1) {
    return '📦 準備搬移 $value1 則記憶碎片：';
  }

  @override
  String character_edit_message_complete(Object value1) {
    return '✅ 已完成搬移 $value1 則記憶碎片';
  }

  @override
  String character_edit_preload_first_voice_sample_message_background_start(
      Object voiceId) {
    return '⏳ 開始背景預載第一個 Voice：$voiceId';
  }

  @override
  String get character_edit_preload_first_voice_sample_message_update =>
      '⚠️ Voice 清單已更新，略過舊的預載結果';

  @override
  String
      get character_edit_preload_first_voice_sample_message_background_complete =>
          '✅ 第一個 Voice 已背景預載完成';

  @override
  String get character_edit_preload_first_voice_sample_message_failed =>
      '⚠️ 第一個 Voice 預載失敗：';

  @override
  String character_edit_preload_first_voice_sample_message(Object value1) {
    return '✅ matchVoiceFromBank 回傳：$value1';
  }

  @override
  String get character_edit_error_voice => '語音服務回傳格式錯誤';

  @override
  String get character_edit_error_voice_variant_b => '語音服務沒有回傳 previews';

  @override
  String character_edit_message_success_voice_match(Object value1) {
    return '✅ 成功配對 $value1 個 Voice Bank 聲音';
  }

  @override
  String get character_edit_message_failed_match =>
      '========== Voice Bank 配對失敗 ==========';

  @override
  String get character_edit_message_error_match =>
      '========== Voice Bank 配對未知錯誤 ==========';

  @override
  String get character_edit_preview_voice_sample_error_preview => '試聽服務回傳格式錯誤';

  @override
  String get character_edit_preview_voice_sample_error_preview_variant_b =>
      '試聽音訊資料為空';

  @override
  String get character_edit_preview_voice_sample_error_failed_preview =>
      '試聽音訊解析失敗';

  @override
  String get character_edit_test_voice_settings_message_failed =>
      '========== testVoiceSettings 失敗 ==========';

  @override
  String character_edit_confirm_voice_selection_message_selected(
      Object realVoiceId) {
    return '✅ Voice選定正式 Voice ID：$realVoiceId';
  }

  @override
  String
      get character_edit_confirm_voice_selection_message_save_failed_select =>
          '========== 儲存 Voice Bank 選擇失敗 ==========';

  @override
  String
      get character_edit_confirm_voice_selection_message_failed_voice_selected =>
          '========== 選定 Voice Bank 聲音失敗 ==========';

  @override
  String get character_to_map_message_creator => '謎のクリエイター';

  @override
  String get character_get_character_by_id_message_load_background_story =>
      'バックストーリーを読み込み中...';

  @override
  String get character_get_character_by_id_message_sync => '初期ストーリーを同期中...';

  @override
  String get character_get_character_by_id_message => '最初のセリフを準備中...';

  @override
  String get character_get_character_by_id_message_background => '背景を読み込み中...';

  @override
  String get character_get_character_by_id_message_load => '世界観を読み込み中...';

  @override
  String get character_get_character_by_id_message_load_settings =>
      'キャラクターの中核設定を読み込み中...';

  @override
  String get character_get_character_by_id_message_variant_b => '性格を読み込み中...';

  @override
  String get character_get_character_by_id_message_appearance =>
      '外見設定を読み込み中...';

  @override
  String get character_get_character_by_id_message_variant_c => '口調を読み込み中...';

  @override
  String get character_get_character_by_id_message_load_variant_b => '未読み込み';

  @override
  String get character_get_character_by_id_message_variant_d => '見知らぬ人';

  @override
  String get character_get_character_by_id_message_load_variant_c =>
      '会話例を読み込み中...';

  @override
  String get character_get_character_by_id_message_variant_e => '初対面';

  @override
  String get character_get_character_by_id_message_variant_f => '顔見知り';

  @override
  String get character_get_character_by_id_message_variant_g => '曖昧な関係';

  @override
  String get chat_input_message_sticker => 'スタンプ';

  @override
  String get chat_text => '本日の無料雑談上限に達しました';

  @override
  String get chat_message_flowers_today_continue =>
      '本日の無料雑談10回を使い切りました。\n\nこれ以降の雑談は1回につき花1個が必要です。続けますか？';

  @override
  String get chat_text_continue => '同意して続ける';

  @override
  String get chat_empty_message_label_current_sticker => '現在使用できるスタンプはありません。';

  @override
  String get chat_empty_message_label_sticker => '最近使用したスタンプはまだありません';

  @override
  String get chat_empty_message_label_sticker_variant_b => 'お気に入りのスタンプはまだありません';

  @override
  String get chat_empty_message_label_current_sticker_variant_b =>
      '現在使用できるスタンプはありません';

  @override
  String get chat_empty_message_sticker => 'マイスタンプ';

  @override
  String get chat_empty_message => '最近使用';

  @override
  String get chat_empty_message_variant_b => 'お気に入り';

  @override
  String get chat_send_sticker_message_current_unavailable_sticker =>
      'このスタンプは現在使用できません';

  @override
  String chat_message_theater(Object sceneTitle) {
    return '—— 劇場・$sceneTitle ——';
  }

  @override
  String get chat_handle_regenerate_button_message_character_reply_again =>
      'キャラクターの直前の返信を再生成します。';

  @override
  String creator_profile_reason_tile_message_report_select_reason(
      Object creatorName) {
    return '「$creatorName」を通報する理由を選択してください：';
  }

  @override
  String get widget_key_message => '状態';

  @override
  String get widget_key_message_variant_b => '場所';

  @override
  String get widget_label_character => 'キャラクターの状態はまだありません';

  @override
  String get widget_format_post_time_label_moment_latest => '最新の投稿';

  @override
  String get widget_format_post_time_label_update_moment => 'たった今投稿を更新しました';

  @override
  String widget_format_post_time_label_minutes_ago_update_moment(
      Object value1) {
    return '$value1分前に投稿を更新しました';
  }

  @override
  String widget_format_post_time_label_hours_ago_update_moment(Object value1) {
    return '$value1時間前に投稿を更新しました';
  }

  @override
  String get widget_format_post_time_label_update_moment_days => '昨日投稿を更新しました';

  @override
  String widget_format_post_time_label_update_moment_days_ago(Object value1) {
    return '$value1日前に投稿を更新しました';
  }

  @override
  String widget_format_post_time_label_update_moment_variant_b(
      Object value1, Object value2) {
    return '$value1/$value2に投稿を更新しました';
  }

  @override
  String get widget_format_post_time_message_share_photo => '写真をシェアしました';

  @override
  String get widget_format_post_time_message_update_moment => '投稿を更新しました';

  @override
  String get widget_format_post_time_message_current_character_moment =>
      'キャラクターの投稿はまだありません';

  @override
  String get widget_extract_daily_quote_message => '場所：';

  @override
  String get widget_format_daily_quote_time_message_today => '今日のひとことはまだありません';

  @override
  String get widget_load_period_care_state_message_today =>
      '「今日は無理しすぎないで。僕がそばでゆっくり付き合うよ。」';

  @override
  String widget_load_period_care_state_message_period_days(Object dayCount) {
    return '生理 $dayCount 日目';
  }

  @override
  String get widget_load_period_care_state_message_days =>
      '「この数日は少し早めに休んで。無理しすぎないでね。」';

  @override
  String get widget_load_period_care_state_message_today_start => '今日開始予定';

  @override
  String widget_load_period_care_state_message_days_variant_b(
      Object daysUntil) {
    return 'あと $daysUntil 日の予定';
  }

  @override
  String get widget_load_period_care_state_message_today_variant_b =>
      '「お疲れさま。今日はちゃんと自分をいたわってね。」';

  @override
  String get widget_load_period_care_state_message_period_end => '生理が終わったばかり';

  @override
  String get widget_load_period_care_state_message_today_variant_c =>
      '「今日もちゃんと自分を大事にしてね。」';

  @override
  String get widget_load_period_care_state_message_current_reminder =>
      '現在、特別な周期リマインダーはありません';

  @override
  String get widget_load_period_care_state_message => '周期記録がまだ十分ではありません';

  @override
  String get widget_parse_character_birthday_message => '年';

  @override
  String get widget_parse_character_birthday_message_variant_b => '月';

  @override
  String get widget_build_birthday_countdown_lines_message_character_birthday =>
      'キャラクターの誕生日';

  @override
  String get widget_build_birthday_countdown_lines_message_birthday_settings =>
      '誕生日未設定';

  @override
  String widget_build_birthday_countdown_lines_message_birthday_countdown(
      Object birthdayLabel) {
    return '彼の誕生日まで・$birthdayLabel';
  }

  @override
  String get widget_build_birthday_countdown_lines_message_today => '今日です';

  @override
  String widget_build_birthday_countdown_lines_message_days(Object days) {
    return 'あと $days 日';
  }

  @override
  String get widget_build_birthday_countdown_lines_message => '彼と出会って';

  @override
  String get widget_build_birthday_countdown_lines_message_variant_b =>
      '出会いの記録はまだありません';

  @override
  String widget_build_birthday_countdown_lines_message_days_variant_b(
      Object value1) {
    return '$value1 日';
  }

  @override
  String get widget_build_birthday_countdown_lines_message_variant_c => '大切な日';

  @override
  String get widget_build_birthday_countdown_lines_message_date_select =>
      '日付未選択';

  @override
  String widget_build_birthday_countdown_lines_message_elapsed_days(
      Object value1) {
    return '$value1 日経過';
  }

  @override
  String get widget_settings_remove_title_character_latest => 'キャラクターの最新投稿';

  @override
  String get widget_settings_remove_subtitle_moment_latest =>
      'Appを開かなくても彼の最新投稿を確認できます。';

  @override
  String get widget_settings_remove_title_period => '生理期サポート';

  @override
  String get widget_settings_remove_subtitle_character_end =>
      '始まる前・期間中・終わった後も、キャラクターから少し多めの気遣いを。';

  @override
  String get widget_settings_remove_title => '今日のひとこと';

  @override
  String get widget_settings_remove_subtitle_days =>
      '毎日スマホを開くと、ホーム画面でひとことがあなたを待っています。';

  @override
  String get widget_settings_remove_title_reminder => '記念日／リマインダー';

  @override
  String get widget_settings_remove_subtitle_character_birthday_reminder =>
      '出会った日や誕生日を一緒に覚えて、キャラクターに大切な予定を知らせてもらいましょう。';

  @override
  String get widget_settings_remove_title_character => 'キャラクター状態';

  @override
  String get widget_settings_remove_subtitle_chat_latest_mood =>
      'チャットの最新の気分・状態・場所をホーム画面に表示します。';

  @override
  String get widget_settings_size_label => '中';

  @override
  String get widget_settings_size_label_message_send =>
      'ホーム画面への追加リクエストを送信しました。';

  @override
  String get widget_settings_size_label_message_try_again_later_failed =>
      'ホーム画面への追加に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String
      get widget_settings_edit_saved_widget_message_character_reminder_again =>
          '旧「キャラクターToDoリマインダー」は「記念日／リマインダー」に統合されました。もう一度作成してください。';

  @override
  String get widget_settings_delete_saved_widget_title_delete_small =>
      'ウィジェットを削除しますか？';

  @override
  String
      widget_settings_delete_saved_widget_message_stop_display_long_press_home_after_delete(
          Object value1, Object value2) {
    return '「$value1・$value2」を削除しますか？\n\n削除後、このウィジェットはキャラクター内容の表示を停止し、ホーム画面を長押しして削除するよう案内します。';
  }

  @override
  String
      get widget_settings_delete_saved_widget_message_delete_settings_small =>
          'ウィジェット設定を削除しました。ホーム画面上の対応ウィジェットは無効になりました。';

  @override
  String get widget_settings_message_desktop_widget => 'ホーム画面ウィジェット';

  @override
  String get widget_settings_message_character_days => '好きなキャラクターと毎日を一緒に。';

  @override
  String get widget_settings_message_small => 'マイウィジェット';

  @override
  String get widget_settings_message_desktop_widget_variant_b =>
      'ホーム画面ウィジェットはまだありません';

  @override
  String get widget_settings_message_character_reminder =>
      '好きなキャラクターを選び、リマインダー・投稿・状態をホーム画面に表示できます。';

  @override
  String widget_settings_message_size(Object value1) {
    return '$value1サイズ';
  }

  @override
  String get widget_settings_tooltip => 'ホーム画面に追加';

  @override
  String get widget_settings_tooltip_small => 'ウィジェットを編集';

  @override
  String get widget_settings_tooltip_delete_small => 'ウィジェットを削除';

  @override
  String get widget_settings_message_desktop_widget_variant_c =>
      'ホーム画面ウィジェットを追加';

  @override
  String get widget_settings_message_character_photo_content_select_small =>
      '各ウィジェットごとにキャラクター、キャラクター写真、表示内容を個別に選べます。複数のキャラクターを同時にホーム画面へ配置することもできます。';

  @override
  String get widget_settings_desktop_type_selection_message_select_small =>
      'ウィジェットを選択';

  @override
  String get widget_settings_desktop_type_selection_message_select =>
      'まず、ホーム画面でどのように寄り添ってほしいかを選んでください。';

  @override
  String
      get widget_settings_go_to_photo_step_message_try_again_later_failed_load_character_photo =>
          'キャラクター写真の読み込みに失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get widget_settings_message_character_select => 'キャラクターを選択';

  @override
  String get widget_settings_message_character_friend_days =>
      '友だち追加済み、または一度でもチャットしたキャラクターのみ表示されます。';

  @override
  String get widget_settings_hint_character_search => 'キャラクターを検索';

  @override
  String get widget_settings_message_try_again_later_failed_load_character =>
      'キャラクターの読み込みに失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get widget_settings_message_current_character_chat_friend_add =>
      '該当するキャラクターがいません。まずチャットするか、友だちに追加してみましょう。';

  @override
  String get widget_settings_message_character_photo_select => '次へ・キャラクター写真を選択';

  @override
  String
      get widget_settings_desktop_photo_selection_message_character_photo_select =>
          'キャラクター写真を選択';

  @override
  String
      widget_settings_desktop_photo_selection_message_current_affection_unlocked_photo(
          Object value1) {
    return '現在の好感度 $value1・解放済みの写真はそのまま使用できます。';
  }

  @override
  String
      get widget_settings_desktop_photo_selection_message_current_character_photo =>
          'このキャラクターには現在使用できる写真がありません。';

  @override
  String
      widget_settings_desktop_photo_selection_message_required_affection_unlock_photo(
          Object value1) {
    return 'この写真を解放するには好感度 $value1 が必要です。';
  }

  @override
  String get widget_settings_message_photo_public => '公開写真';

  @override
  String widget_settings_message_unlock(Object value1) {
    return '好感度 $value1 で解放';
  }

  @override
  String widget_settings_message_unlocked(Object value1) {
    return '解放済み・好感度 $value1';
  }

  @override
  String get widget_settings_message_content_settings => '次へ・表示内容を設定';

  @override
  String get widget_settings_open_preview_message_player_select =>
      '先にプレイヤーが作成したイベント／ToDoを選択してください。';

  @override
  String get widget_settings_pick_custom_memo_event_message_login_account =>
      '先にログインしてください。';

  @override
  String
      get widget_settings_pick_custom_memo_event_message_memo_current_character =>
          'このキャラクターにはまだイベント／メモがありません。';

  @override
  String get widget_settings_pick_custom_memo_event_message_player_select =>
      'プレイヤー作成イベントを選択';

  @override
  String get widget_settings_message_try_again_later_failed_load =>
      'イベントの読み込みに失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get widget_settings_message_content_settings_variant_b => '表示内容を設定';

  @override
  String get widget_settings_subtitle_content => 'ホーム画面に表示したい内容を調整します。';

  @override
  String get widget_settings_message_small_variant_b => '次へ・ウィジェットをプレビュー';

  @override
  String get widget_settings_title => '投稿表示';

  @override
  String get widget_settings_title_variant_b => '投稿画像を表示';

  @override
  String get widget_settings_title_variant_c => 'いいね数を表示';

  @override
  String get widget_settings_title_comment => 'コメント数を表示';

  @override
  String get widget_settings_title_variant_d => 'プライバシーと寄り添い';

  @override
  String get widget_settings_title_variant_e => 'プライバシーモード';

  @override
  String get widget_settings_subtitle_period_character =>
      'ホーム画面にはキャラクターからの気遣いだけを表示し、生理情報は直接表示しません。';

  @override
  String get widget_settings_title_variant_f => '詳細モード';

  @override
  String get widget_settings_subtitle_end => '開始間近・進行中・終了直後などの周期状態を表示できます。';

  @override
  String get widget_settings_title_variant_g => '周期状態を表示';

  @override
  String get widget_settings_title_time => '時間を表示';

  @override
  String get widget_settings_title_update => '更新方法';

  @override
  String get widget_settings_message_update_days => '1日1回更新';

  @override
  String get widget_settings_message_update => 'Appを開くたびに更新';

  @override
  String get widget_settings_text_update => 'Appを開いた後に更新';

  @override
  String get widget_settings_title_content => '記念日の内容';

  @override
  String get widget_settings_title_days => '出会ってからの日数';

  @override
  String get widget_settings_subtitle_character_today_days =>
      'あなたとキャラクターが出会ってから今日までの日数を表示します。';

  @override
  String get widget_settings_subtitle_character_birthday =>
      'キャラクターの誕生日まであとどのくらいかを表示します。';

  @override
  String get widget_settings_title_player => 'プレイヤー作成イベント／ToDo';

  @override
  String get widget_settings_message_memo_character_select_reminder =>
      'このキャラクターのメモ／リマインダーからイベントまたはToDoを選択します。';

  @override
  String widget_settings_message_selected(Object _selectedMemoContent) {
    return '選択済み：$_selectedMemoContent';
  }

  @override
  String get widget_settings_message_select => '最大3項目まで選択';

  @override
  String get widget_settings_message_character => 'キャラクター状態は最大3項目まで表示できます。';

  @override
  String get widget_settings_message_small_variant_c => 'ウィジェットをプレビュー';

  @override
  String get widget_settings_title_confirm => '最終確認';

  @override
  String get widget_settings_subtitle_large => 'ホーム画面に置いたときの見た目を先に確認しましょう。';

  @override
  String get widget_settings_title_size => 'サイズ';

  @override
  String get widget_settings_title_variant_h => 'レイアウト';

  @override
  String get widget_settings_label_photo => '全面写真';

  @override
  String get widget_settings_label_character => 'キャラクターカード';

  @override
  String get widget_settings_message_sync => '同期中…';

  @override
  String get widget_settings_message_desktop_widget_add => 'ホーム画面ウィジェットを追加';

  @override
  String get widget_settings_sample_lines_message_today_end =>
      '「今日は思ったより少し早く終わった。」';

  @override
  String get widget_settings_sample_lines_message_days => '「この数日は無理しすぎないで。」';

  @override
  String get widget_settings_sample_lines_message_period => '生理中';

  @override
  String get widget_settings_sample_lines_message_today => '「今日は少し多めに休んで。」';

  @override
  String get widget_settings_sample_lines_message_today_variant_b =>
      '「今日もちゃんとご飯を食べるのを忘れないで。」';

  @override
  String get widget_settings_sample_lines_label_birthday_countdown => '彼の誕生日まで';

  @override
  String get widget_settings_sample_lines_label_days => 'あと12日';

  @override
  String get widget_settings_sample_lines_label_days_variant_b => '128日';

  @override
  String get widget_settings_sample_lines_message_mood => '気分｜少し疲れている';

  @override
  String get widget_settings_sample_lines_message_end => '状態｜仕事が終わったばかり';

  @override
  String get widget_settings_sample_lines_message => '場所｜会社の下';

  @override
  String get widget_settings_sample_lines_message_variant_b => '関係｜恋人';

  @override
  String get widget_settings_sample_lines_message_variant_c => '服装｜ライトグレーのニット';

  @override
  String get widget_settings_sample_lines_message_days_variant_b => '天気｜少し涼しい';

  @override
  String get widget_settings_sample_lines_message_variant_d => '考え｜早く君に会いたい';

  @override
  String get widget_settings_sample_lines_message_variant_e => '行動｜机を片づけている';

  @override
  String get widget_settings_sample_lines_message_affection => '好感度｜穏やかで親しい';

  @override
  String get edit_profile_message => 'プロフィール装飾';

  @override
  String get edit_profile_message_current => '現在未使用';

  @override
  String
      get event_memory_character_load_characters_message_login_character_select =>
          'キャラクターを選ぶ前にログインしてください';

  @override
  String get event_memory_character_center_message_memory_select =>
      'この思い出を一緒に残したい相手を選んでください';

  @override
  String get event_memory_character_center_message_character_friend_add =>
      '自分で作成したキャラクターと、友だち追加済みのキャラクターだけが表示されます。';

  @override
  String get event_memory_character_center_message_current_character_select =>
      '現在選択できるキャラクターはいません';

  @override
  String
      get event_memory_character_center_message_public_character_character_friend_add =>
          '自分のキャラクターを作成するか、好きな公開キャラクターを友だちに追加してください。';

  @override
  String get event_memory_character_message_character_select =>
      '先にキャラクターを選択してください';

  @override
  String event_memory_character_message_continue(Object value1) {
    return '$value1 と続ける';
  }

  @override
  String get event_memory_character_card_message_private => '自分の・非公開';

  @override
  String get event_memory_character_error_label_load_again => '再読み込み';

  @override
  String
      get event_memory_collection_show_collection_intro_if_needed_message_collection =>
          '拾光コレクション';

  @override
  String
      get event_memory_collection_show_collection_intro_if_needed_message_collection_content =>
          'ここはコレクション一覧です。保存したすべての内容を確認できます。';

  @override
  String get event_memory_collection_text_collection_login =>
      'コレクションを見るにはログインしてください';

  @override
  String get event_memory_collection_message_memory => '思い出';

  @override
  String get event_memory_collection_message_chat_background => 'チャット背景';

  @override
  String get event_memory_collection_message_avatar_frame_collection =>
      'コレクションしたアバターフレームはまだありません';

  @override
  String get event_memory_collection_message_avatar_frame =>
      '今後入手した限定アバターフレームがここに表示されます。';

  @override
  String get event_memory_collection_message_collection_sticker =>
      'コレクションしたスタンプはまだありません';

  @override
  String get event_memory_collection_message_sticker => '今後集めたスタンプはここに保存されます。';

  @override
  String get event_memory_collection_message_collection_chat_background =>
      'コレクションしたチャット背景はまだありません';

  @override
  String get event_memory_collection_message_chat_background_variant_b =>
      '今後入手した限定チャット背景がここに表示されます。';

  @override
  String get event_memory_collection_tab_title_collection_temporary =>
      '現在コレクションを読み込めません';

  @override
  String get event_memory_collection_tab_title_collection_memory =>
      'コレクションした思い出はまだありません';

  @override
  String get event_memory_collection_tab_subtitle_limited_memory_complete =>
      '限定思い出を完了すると、お気に入りの場面をここに残せます。';

  @override
  String get event_memory_collection_item_card_label => '限定アイテム';

  @override
  String get event_memory_collection_confirm_delete_owned_item_message_delete =>
      '限定アイテムを削除しますか？';

  @override
  String
      event_memory_collection_confirm_delete_owned_item_message_after_delete_unavailable(
          Object _itemTypeLabel) {
    return '削除すると、この$_itemTypeLabelは使用できなくなり、';
  }

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_collection =>
          '「拾光コレクション」にも表示されなくなります。\n\n';

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_unavailable =>
          'これは今回入手した限定アイテムを手放すことを意味し、この操作は元に戻せません。\n\n';

  @override
  String
      event_memory_collection_confirm_delete_owned_item_message_delete_variant_b(
          Object value1) {
    return '「$value1」を削除してもよろしいですか？';
  }

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_delete_variant_c =>
          '限定アイテムを削除しました';

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_not_found_delete =>
          'この限定アイテムが見つかりません。すでに削除されている可能性があります';

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_collection_current_delete =>
          'このコレクションは現在削除できません';

  @override
  String get event_memory_collection_show_preview_message => '画像を準備中';

  @override
  String get event_memory_collection_show_preview_message_failed_load =>
      '画像の読み込みに失敗しました';

  @override
  String get event_memory_collection_save_to_gallery_message_save_current =>
      'Web版では現在、スマートフォンの写真ライブラリへ直接保存できません';

  @override
  String get event_memory_collection_save_to_gallery_message_save_memory =>
      'この思い出を保存するには写真ライブラリへのアクセス許可が必要です';

  @override
  String get event_memory_collection_save_to_gallery_message_memory =>
      '思い出の画像はまだ準備できていません。もう一度お試しください。';

  @override
  String get event_memory_collection_save_to_gallery_message_failed_memory =>
      '思い出画像の生成に失敗しました';

  @override
  String get event_memory_collection_save_to_gallery_message_save =>
      'スマートフォンの写真ライブラリに保存しました ♡';

  @override
  String
      get event_memory_collection_save_to_gallery_message_save_confirm_failed =>
          '保存に失敗しました。写真ライブラリの権限を確認してもう一度お試しください。';

  @override
  String
      get event_memory_collection_delete_collection_title_collection_cancel =>
          'コレクションから外しますか？';

  @override
  String
      get event_memory_collection_delete_collection_message_collection_cancel_memory =>
          'コレクションを解除すると、この思い出は「拾光コレクション」に表示されなくなります。\n\nコレクションを解除してもよろしいですか？';

  @override
  String
      get event_memory_collection_delete_collection_message_try_again_later_collection_cancel_failed =>
          'コレクション解除に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get event_memory_collection_message_collection_memory => '思い出コレクション';

  @override
  String get event_memory_collection_label_play => 'もう一度再生';

  @override
  String get event_memory_collection_label_save => '保存中…';

  @override
  String get event_memory_collection_label_save_variant_b => '写真ライブラリに保存';

  @override
  String get event_memory_collection_collected_card_message_limited_memory =>
      '恋恋拾光・限定思い出';

  @override
  String get event_memory_collection_create_state_message_end_story =>
      '物語が終わっても、\n消えない瞬間がある。';

  @override
  String get event_memory_collection_text_collection =>
      'このコレクションには再生できるSceneがありません';

  @override
  String get event_memory_collection_message => 'スキップ';

  @override
  String get event_memory_collection_message_end => 'タップして終了';

  @override
  String get event_memory_collection_message_continue => 'タップして続ける';

  @override
  String get event_memory_collection_message_variant_b => 'タップして全文を表示';

  @override
  String get event_memory_collection_collected_label_collection => 'たった今コレクション';

  @override
  String get event_memory_collection_collected_item_label_collection_date =>
      'コレクション日未記録';

  @override
  String event_memory_collection_collected_item_label_collection(
      Object day, Object month, Object value1) {
    return '$value1/$month/$day にコレクション';
  }

  @override
  String get event_memory_text_not_found_event => 'イベントデータが見つかりません';

  @override
  String get event_memory_message_limited_memory_failed_load =>
      '限定思い出の読み込みに失敗しました';

  @override
  String get event_memory_as_map_label_unlocked => '解放済み';

  @override
  String event_memory_as_map_label_unlock(Object currencyIcon,
      Object currencyName, Object currentValue, Object requiredValue) {
    return '$currencyIcon $requiredValue $currencyName を累積して解放（$currentValue / $requiredValue）';
  }

  @override
  String get event_memory_as_map_label_unlock_task_event_complete =>
      '指定のイベントミッション完了後に解放';

  @override
  String get event_memory_as_map_label_redeem_unlock_event =>
      '指定のイベント商品を交換後に解放';

  @override
  String get event_memory_as_map_label_unlock_variant_b => '未解放';

  @override
  String get event_memory_hero_message => 'この季節に、ふたりだけの瞬間を残そう。';

  @override
  String event_memory_hero_message_limited_memory(
      Object totalCount, Object unlockedCount) {
    return '限定思い出  $unlockedCount / $totalCount';
  }

  @override
  String get event_memory_status_label_unlocked => '解放済み・未視聴';

  @override
  String get event_memory_status_label => '視聴済み';

  @override
  String get event_memory_status_label_collection => 'コレクション済み';

  @override
  String get event_memory_footer_label_memory_start => 'この思い出を開始できます';

  @override
  String get event_memory_footer_label => 'もう一度見ることができます';

  @override
  String get event_memory_footer_label_collection => '拾光コレクションに保存済み';

  @override
  String get event_memory_empty_message_limited_memory_event_public =>
      'このイベントではまだ限定思い出が公開されていません';

  @override
  String get event_memory_performance_finish_message_memory => 'この思い出を残しました。';

  @override
  String get event_memory_performance_finish_message_save_collection =>
      'コレクションはゲーム内に保存されます。写真ライブラリへの権限はスマートフォンに保存するときだけ求められます。';

  @override
  String get event_memory_performance_finish_message => '処理中…';

  @override
  String get event_memory_performance_finish_message_collection_memory =>
      'この思い出をコレクション';

  @override
  String
      get event_memory_performance_confirm_uncollect_memory_message_collection_cancel_memory_again_remove =>
          '解除すると、この思い出は「拾光コレクション」から削除されます。あとで再び視聴してコレクションすることもできます。';

  @override
  String
      get event_memory_performance_uncollect_memory_message_collection_login =>
          'コレクションを管理するには先にログインしてください';

  @override
  String
      get event_memory_performance_collect_memory_message_collection_login_memory =>
          'この思い出をコレクションするには先にログインしてください';

  @override
  String
      get event_memory_performance_collect_memory_message_collection_memory =>
          'この思い出をコレクションしました ♡';

  @override
  String
      get event_memory_performance_collect_memory_message_try_again_later_collection_failed =>
          'コレクションに失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get event_memory_performance_text_panel_message_complete => 'タップして完了';

  @override
  String get event_memory_performance_build_performance_message => 'スキップ';

  @override
  String get event_memory_performance_text_play => '再生できるSceneがありません';

  @override
  String get event_memory_profile_change_profile_message_profile =>
      '拾光プロフィールを変更';

  @override
  String get event_memory_profile_message_profile_confirm => '拾光プロフィールを確認';

  @override
  String get event_memory_profile_center_text_profile_not_found =>
      '使用できる拾光プロフィールが見つかりません';

  @override
  String get event_memory_profile_center_message_memory =>
      'この思い出には、どの自分として残りますか？';

  @override
  String get event_memory_profile_center_message_profile_character_start =>
      'このキャラクターと最近使用した拾光プロフィールを優先して選択しました。開始前に変更できます。';

  @override
  String event_memory_profile_center_message(Object value1) {
    return '「$value1」として';
  }

  @override
  String event_memory_profile_center_message_memory_variant_b(Object value1) {
    return '「$value1」とこの思い出を残す';
  }

  @override
  String get event_memory_profile_center_label_memory_start => '思い出を開始';

  @override
  String get event_message_failed_load => 'イベントデータの読み込みに失敗しました';

  @override
  String get event_message_not_found => 'イベントが見つかりません';

  @override
  String get event_remaining_label => 'イベント開催中';

  @override
  String event_remaining_label_days(Object value1) {
    return '残り $value1 日';
  }

  @override
  String event_remaining_label_hours(Object value1) {
    return '残り $value1 時間';
  }

  @override
  String get event_remaining_label_end => 'まもなく終了';

  @override
  String get event_balance_pill_tooltip_back => '戻る';

  @override
  String event_claim_task_message_claim_current(
      Object currency, Object reward, Object value1, Object value2) {
    return '$value1 $reward $value2 を受け取りました。現在 $currency 所持しています';
  }

  @override
  String get event_claim_task_message_reward_claim => '報酬を受け取りました';

  @override
  String get event_claim_task_message_claim_failed => '受け取りに失敗しました';

  @override
  String get event_claim_task_message_task_claim => 'このミッションの報酬はすでに受け取っています';

  @override
  String get event_claim_task_message_incomplete_task => 'ミッションはまだ完了していません';

  @override
  String get event_task_list_label_task_load => 'ミッションを読み込み中…';

  @override
  String get event_task_list_label_task_current => '現在ミッションはありません';

  @override
  String get event_task_list_label_task_login_progress =>
      'ログインするとイベントミッションの進捗を確認できます';

  @override
  String get event_milestone_progress_label_reward_load => '累積報酬を読み込み中…';

  @override
  String get event_milestone_progress_label_reward_current => '現在累積報酬はありません';

  @override
  String event_build_with_total_message_current(Object totalEarned) {
    return '現在  $totalEarned';
  }

  @override
  String get event_progress_ref_message_redeem_confirm => '交換を確認';

  @override
  String event_progress_ref_message_redeem_flowers(
      Object itemName, Object price, Object rewardAmount, Object value1) {
    return '$value1 $price を使って「$itemName」と交換しますか？\n\n交換後、花を $rewardAmount 個獲得できます。';
  }

  @override
  String event_progress_ref_message_redeem(
      Object itemName, Object price, Object value1) {
    return '$value1 $price を使って「$itemName」と交換しますか？';
  }

  @override
  String event_progress_ref_message_redeem_success_flowers(
      Object returnedReward) {
    return '交換成功！花を $returnedReward 個獲得しました';
  }

  @override
  String event_progress_ref_message_event_collection_redeem_success_add(
      Object itemName) {
    return '交換成功！「$itemName」をイベントコレクションに追加しました';
  }

  @override
  String get event_progress_ref_message_redeem_failed => '交換に失敗しました';

  @override
  String get event_progress_ref_message_redeem_variant_b => 'この商品はすでに交換済みです';

  @override
  String get event_progress_ref_message_insufficient => '通貨が足りません';

  @override
  String event_progress_ref_message_insufficient_variant_b(Object value1) {
    return '$value1が足りません';
  }

  @override
  String get event_progress_ref_message_redeem_variant_c => '交換';

  @override
  String get event_progress_ref_message_redeem_variant_d => '交換済み';

  @override
  String event_message_redeem_flowers(Object rewardAmount) {
    return '交換後、花を $rewardAmount 個獲得できます';
  }

  @override
  String event_message_redeem(Object redeemedCount) {
    return '$redeemedCount 回交換済み';
  }

  @override
  String get event_message_event_shop_login => 'ログインするとイベントショップを利用できます';

  @override
  String get event_message_redeem_current => '現在交換できる商品はありません';

  @override
  String event_shop_item_card_message_flowers(Object rewardAmount) {
    return '花を $rewardAmount 個獲得';
  }

  @override
  String get event_message_insufficient => '不足';

  @override
  String get notification_message_player => 'プレイヤー添付画像';

  @override
  String notification_message_qixi_letter(Object value1) {
    return '$value1からの七夕の手紙';
  }

  @override
  String recommendation_remaining_label_days(Object value1) {
    return '残り $value1 日';
  }

  @override
  String recommendation_remaining_label_hours(Object value1) {
    return '残り $value1 時間';
  }

  @override
  String get settings_subtitle_character_days => '好きなキャラクターと毎日を一緒に';

  @override
  String moment_notification_comment_on_character_post(
      Object authorName, Object commentText, Object senderNickname) {
    return '$senderNicknameさんが$authorNameさんにコメントしました：「$commentText」';
  }

  @override
  String get inbox_content_text_message_customer_service_message_send =>
      '送信済みのお問い合わせ';

  @override
  String get character_edit_relationship_none_label => 'なし';

  @override
  String get auth_cancel_account_deletion_failed =>
      'アカウント削除のキャンセルに失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get auth_delete_account_failed => 'アカウントの削除に失敗しました';

  @override
  String get auth_request_account_deletion_failed =>
      'アカウント削除の申請に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get theme_font_shiguang_serif => '拾光明朝';

  @override
  String get theme_font_clean_sans => '清雅ゴシック';

  @override
  String get theme_font_system => 'システムフォント';

  @override
  String get theme_font_shiguang_serif_description => 'やわらかく文学的で、没入感のある読書に最適';

  @override
  String get theme_font_clean_sans_description => 'すっきり読みやすく、長時間の読書にも快適';

  @override
  String get theme_font_system_description => '端末の標準システムフォントに従う';

  @override
  String get font_selection_serif_name => 'Noto Serif TC';

  @override
  String get font_selection_sans_name => 'Noto Sans TC';

  @override
  String get font_selection_system_name => 'システムフォント';

  @override
  String get font_selection_serif_description => '物語に浸る読書に適した、上品なセリフ体。';

  @override
  String get font_selection_sans_description => 'すっきりと柔らかな印象のサンセリフ体。';

  @override
  String get font_selection_system_description => '端末の標準フォントを使用します。';

  @override
  String get font_selection_preview_sentence => '大好きなあの人と、二人だけの物語をもう一度紡ごう。';

  @override
  String get avatar_frame_error_generic => 'エラー';

  @override
  String get avatar_frame_sign_in_required => '先にログインしてください';

  @override
  String get avatar_frame_default_name => 'イベントアバターフレーム';

  @override
  String get background_exclusive_photos_tab => '限定写真';

  @override
  String get background_world_sign_in_chat => 'ログインしてワールドチャットに入ってください';

  @override
  String get background_world_photo_load_error => 'エラー';

  @override
  String get background_world_no_photos => '選択できるワールド写真がありません';

  @override
  String get background_world_cover => 'ワールドのカバー';

  @override
  String get background_world_cover_confirm => 'ワールドのカバーをこのチャットの背景に設定しますか？';

  @override
  String get background_world_default_limited => '限定背景';

  @override
  String get background_world_default_character => 'キャラクター';

  @override
  String get background_world_no_character_photos => '使用できるキャラクター写真がありません';

  @override
  String background_world_unlock_required(int count) {
    return '解放には好感度 $count が必要です';
  }

  @override
  String background_world_character_confirm(String name) {
    return '「$name」の写真をワールドチャットの背景に設定しますか？';
  }

  @override
  String background_world_affection_count(int count) {
    return '好感度 $count';
  }

  @override
  String get reply_selection => '返信オプション';

  @override
  String get chat_home_character_tab => 'キャラクターチャット';

  @override
  String get chat_home_world_tab => 'オープンワールド';

  @override
  String get chat_home_world_error_generic => 'エラー';

  @override
  String get chat_home_world_pinned => 'ワールドチャットを固定しました';

  @override
  String get chat_home_world_deleted => 'ワールドチャットと会話履歴を削除しました';

  @override
  String get chat_home_world_action_done => '完了しました';

  @override
  String get chat_home_world_rename_title => 'この思い出に名前をつける';

  @override
  String chat_home_world_delete_confirm(String name) {
    return '「$name」のチャット履歴を削除しますか？\n\n会話、ストーリーの要約、人物関係、メモが完全に削除され、復元できません。クリエイターが公開した世界設定は残ります。';
  }

  @override
  String get chat_home_world_empty_title => 'オープンワールドのチャット履歴はまだありません';

  @override
  String get chat_home_world_empty_desc => 'オープンワールドで遊び始めると、ここにチャットが表示されます。';

  @override
  String get chat_home_world_unnamed => '名前のない世界';

  @override
  String get chat_home_world_private_test => 'プライベートテスト';

  @override
  String get chat_home_world_no_messages => 'メッセージはまだありません';

  @override
  String get expand_features => '機能を展開';

  @override
  String get chat_sticker_all => 'すべて';

  @override
  String get chat_mode_short_daily => '日常';

  @override
  String get chat_mode_short_story => '物語';

  @override
  String get chat_mode_short_immersive => '没入';

  @override
  String get chat_mode_short_resonance => '共鳴';

  @override
  String get chat_mode_short_gemini => '雑談';

  @override
  String get chat_theater_tool => '劇場';

  @override
  String chat_regenerate_insufficient_flowers(int cost) {
    return '花が足りません。再生成には花が$cost個必要です。';
  }

  @override
  String get chat_regenerate_paid_title => '有料で再生成';

  @override
  String chat_regenerate_paid_confirm(int cost) {
    return '本日の無料再生成回数を使い切りました。現在のモードでは花を$cost個消費します。続行しますか？';
  }

  @override
  String get chat_generic_error => 'エラー';

  @override
  String get chat_regenerate_confirm => '確認';

  @override
  String get comment_add_photo => '写真を追加';

  @override
  String get comment_error_generic => 'エラー';

  @override
  String creator_profile_report_reason_prompt(String creatorName) {
    return '「$creatorName」を通報する理由を選択してください：';
  }

  @override
  String get creator_profile_open_worlds => 'オープンワールド';

  @override
  String get creator_profile_generic_error => 'エラー';

  @override
  String get creator_profile_refresh => '更新';

  @override
  String get creator_profile_no_open_worlds => 'このクリエイターはまだオープンワールドを公開していません。';

  @override
  String get creator_profile_unnamed_world => '名前のない世界';

  @override
  String get creator_program_required_fields => '創作方針と応募理由を入力してください。';

  @override
  String get creator_program_submitted => '申請を送信しました。審査には約1～3日かかります。';

  @override
  String get creator_program_error => 'エラー';

  @override
  String get creator_program_login_required => 'クリエイタープログラムへの応募前にログインしてください。';

  @override
  String get creator_program_title => 'クリエイタープログラム';

  @override
  String get creator_program_headline => 'あなたの作品をもっと多くの人へ';

  @override
  String get creator_program_intro =>
      '公開作品があれば、《戀戀拾光》クリエイタープログラムに応募できます。応募後1～3日以内に審査します。';

  @override
  String get creator_program_benefits_title => 'プログラム特典';

  @override
  String get creator_program_benefit_dashboard =>
      'クリエイターダッシュボード：ファン数、公開キャラ数、総いいね数、今月の新規ファン数を確認できます。';

  @override
  String get creator_program_benefit_fans =>
      'ファン交流：手紙の送信、ファン管理、自分の花を使った特典の贈呈ができます。';

  @override
  String get creator_program_benefit_exposure =>
      '公式紹介：新キャラがInstagramやゲーム内のクリエイターおすすめに優先掲載される可能性があります。';

  @override
  String get creator_program_benefit_monthly =>
      '月間創作報酬：月内に新規キャラを3人以上公開すると、翌月に花を520個受け取れます。';

  @override
  String get creator_program_benefit_merch =>
      'グッズ企画：キャラが公式グッズ・ギフト企画に参加した場合、企画内容に応じて現金の創作報酬を受け取れます。';

  @override
  String creator_program_last_review_note(String reason) {
    return '前回の審査コメント：$reason';
  }

  @override
  String get creator_program_apply_heading => '参加申請';

  @override
  String get creator_program_direction_label => '創作ジャンル';

  @override
  String get creator_program_direction_hint => '例：現代恋愛、時代物、ファンタジー、BL、GL…';

  @override
  String get creator_program_reason_label => '応募理由';

  @override
  String get creator_program_reason_hint => 'キャラクターの創作やファンとの交流について教えてください。';

  @override
  String get creator_program_social_label => 'SNSリンク（任意）';

  @override
  String get creator_program_social_hint => 'Instagram、Threads、個人サイトなど';

  @override
  String get creator_program_submit => '申請を送信';

  @override
  String get creator_program_public_character_note =>
      '送信前に、公開キャラが1人以上いることを確認します。';

  @override
  String get creator_program_status_pending => '申請審査中';

  @override
  String get creator_program_status_pending_desc =>
      '申請を受け付けました。審査は約1～3日です。結果はゲーム内メールでお知らせします。';

  @override
  String get creator_program_status_approved => 'クリエイター資格が承認されました 🎉';

  @override
  String get creator_program_status_approved_desc =>
      '《戀戀拾光》クリエイタープログラムへようこそ！ダッシュボード、ファン管理、おすすめバナーは今後この資格と連動する予定です。';

  @override
  String get creator_program_status_suspended => 'クリエイター資格停止中';

  @override
  String get creator_program_status_suspended_desc =>
      '現在クリエイター専用機能は利用できません。ゲーム内メールの公式通知をご確認ください。';

  @override
  String get creator_program_status_revoked => 'クリエイター資格取り消し';

  @override
  String get creator_program_status_revoked_desc =>
      'クリエイター専用機能は利用できません。ご不明な点はサポートにお問い合わせください。';

  @override
  String get creator_program_status_title => 'クリエイター資格状況';

  @override
  String creator_program_current_status(String status) {
    return '現在の状態：$status';
  }

  @override
  String creator_program_official_note(String reason) {
    return '公式からの説明：$reason';
  }

  @override
  String get creator_dashboard_error1 => 'エラー';

  @override
  String get creator_dashboard_access_title1 => 'クリエイターダッシュボード';

  @override
  String get creator_dashboard_status_notice_title1 =>
      'Creator Dashboard Access Notice';

  @override
  String get creator_dashboard_apply_title1 => 'クリエイターダッシュボードを申請';

  @override
  String get creator_dashboard_access_subtitle1 =>
      'キャラクターのプレイ状況・フォロワーの増減・フォロワー管理';

  @override
  String get creator_dashboard_pending1 =>
      'Application submitted · Under review';

  @override
  String get creator_dashboard_legacy_pending1 =>
      'Application pending confirmation';

  @override
  String get creator_dashboard_syncing1 =>
      'Syncing dashboard access. Please try again later.';

  @override
  String get creator_dashboard_suspended1 =>
      'Dashboard access suspended. Contact support.';

  @override
  String get creator_dashboard_apply_subtitle1 =>
      'Apply for access to character analytics and follower management';

  @override
  String get creator_dashboard_rejected1 =>
      'Application declined · You may apply again';

  @override
  String get creator_dashboard_submitted1 =>
      'Application submitted. Please wait for review.';

  @override
  String get creator_dashboard_benefits_title1 => 'Creator Dashboard features';

  @override
  String get creator_dashboard_benefit_monthly1 =>
      '🌸 Monthly creation reward: Publish 3 distinct new characters this month to claim 300 Flowers once.';

  @override
  String get creator_dashboard_benefit_analytics1 =>
      '• View public-character play metrics, follower totals, and follow/unfollow activity';

  @override
  String get creator_dashboard_benefit_mail1 =>
      '• Fan messages: private messages and announcements (daily limits apply)';

  @override
  String get creator_dashboard_benefit_gifts1 =>
      '• Fan rewards: gift your own Flowers to followers';

  @override
  String get creator_dashboard_reward_note1 =>
      'Approval required. Private characters, drafts, and republished older characters do not count toward the monthly reward.';

  @override
  String get creator_dashboard_apply_cta1 =>
      'Learn more and request dashboard access';

  @override
  String get creator_dashboard_my_characters1 => 'マイキャラクター';

  @override
  String get creator_dashboard_my_worlds1 => 'マイオープンワールド';

  @override
  String get creator_dashboard_create_world1 => 'オープンワールドを作成';

  @override
  String get creator_dashboard_public_worlds1 => '公開済みワールド';

  @override
  String get creator_dashboard_public_worlds_hint1 =>
      'Other players can explore';

  @override
  String get creator_dashboard_private_worlds1 => '非公開ワールド';

  @override
  String get creator_dashboard_private_worlds_hint1 =>
      'Only you can view and edit';

  @override
  String get creator_dashboard_world_drafts1 => 'ワールドの下書き';

  @override
  String get creator_dashboard_world_drafts_hint1 => 'Worlds not yet finished';

  @override
  String get creator_dashboard_no_drafts1 => 'No drafts yet';

  @override
  String get creator_dashboard_no_worlds1 => 'No worlds yet';

  @override
  String get creator_dashboard_unnamed_world1 => '無題のワールド';

  @override
  String get creator_dashboard_delete_world_draft1 => 'Delete world draft';

  @override
  String get creator_dashboard_private_test1 => 'プライベートテスト';

  @override
  String get creator_dashboard_delete_world_confirm_title1 =>
      'Delete world draft?';

  @override
  String get creator_dashboard_delete_world_confirm_body1 =>
      'This cannot be undone. Uploaded images will not be deleted.';

  @override
  String get creator_dashboard_draft_deleted1 => 'World draft deleted';

  @override
  String get creator_dashboard_validation1 =>
      'Creative direction must be 2–100 characters and application reason 10–500 characters.';

  @override
  String get creator_dashboard_confirm_application_title1 =>
      'Confirm dashboard application';

  @override
  String get creator_dashboard_confirm_application_body1 =>
      'Your request will be reviewed. Approval grants dashboard access and does not constitute a partnership agreement.';

  @override
  String get creator_dashboard_confirm_send1 => '送信する';

  @override
  String get creator_dashboard_form_heading1 =>
      'Apply for the Lianlian Shiguang Creator Dashboard';

  @override
  String get creator_dashboard_form_description1 =>
      'Tell us about your creative direction and how you plan to use character analytics and follower management. This is not a partnership contract.';

  @override
  String get creator_dashboard_direction_label1 => '創作の方向性';

  @override
  String get creator_dashboard_direction_hint1 => '例：現代恋愛、時代物、ファンタジー、BL、GL…';

  @override
  String get creator_dashboard_reason_label1 => 'ダッシュボード申請理由';

  @override
  String get creator_dashboard_reason_hint1 =>
      'Share your experience and which dashboard features you need';

  @override
  String get creator_dashboard_sending1 => '送信中…';

  @override
  String get creator_dashboard_submit1 => 'ダッシュボードを申請';

  @override
  String get creator_dashboard_privacy_note1 =>
      'Approval is not guaranteed. Do not enter identity numbers, banking details, or other sensitive information.';

  @override
  String get creator_dashboard_revoked_limit1 =>
      'Dashboard application limit reached. Please contact support.';

  @override
  String get creator_dashboard_revoked_notice1 =>
      'Your dashboard access was revoked. Check the page for available reapplication options.';

  @override
  String get creator_support_page_title1 => 'お問い合わせセンター';

  @override
  String get creator_support_new_report1 => '新しいお問い合わせ';

  @override
  String get creator_support_error1 => 'エラー';

  @override
  String get creator_support_no_cases1 => 'お問い合わせはありません';

  @override
  String get creator_support_unread1 => '未読';

  @override
  String get creator_support_load_more1 => 'さらに読み込む';

  @override
  String get creator_support_category_label1 => 'お問い合わせの分類';

  @override
  String get creator_support_character_optional1 => '関連キャラクター（任意）';

  @override
  String get creator_support_no_character1 => '指定なし';

  @override
  String get creator_support_report_title1 => '件名';

  @override
  String get creator_support_report_description1 => '内容';

  @override
  String creator_support_select_images1(int count) {
    return 'スクリーンショットを選択（$count/3、各2MB未満）';
  }

  @override
  String get creator_support_images_private1 => '画像は投稿者と運営のみ閲覧できます。';

  @override
  String get creator_support_submitting1 => '送信中…';

  @override
  String get creator_support_submit1 => '送信を確定';

  @override
  String get creator_support_image_too_large1 => '画像が2MBを超えています。別の画像を選択してください。';

  @override
  String get creator_support_fill_title_description1 => '件名と内容を入力してください';

  @override
  String get creator_support_case_sent1 => 'お問い合わせを送信しました';

  @override
  String creator_support_case_sent_partial1(int count) {
    return '送信しましたが、画像$count枚のアップロードに失敗しました';
  }

  @override
  String get creator_support_detail_title1 => 'お問い合わせ詳細';

  @override
  String get creator_support_image_max1 => '画像は1枚2MB未満にしてください';

  @override
  String get creator_support_jpg_png_only1 => 'JPG / PNGのみ対応';

  @override
  String get creator_support_reply_sent1 => '返信を送信しました';

  @override
  String creator_support_reply_sent_partial1(int count) {
    return '文章は送信しましたが、画像$count枚のアップロードに失敗しました';
  }

  @override
  String get creator_support_empty_content1 => '内容を入力してください';

  @override
  String get creator_support_recall_message1 => 'メッセージを取り消す';

  @override
  String get creator_support_delete_message1 => 'メッセージを削除';

  @override
  String get creator_support_recall_warning1 =>
      '双方に「このメッセージは取り消されました」と表示され、添付ファイルは閲覧できません。';

  @override
  String get creator_support_delete_warning1 => '自分の画面のみ非表示にします。相手には残ります。';

  @override
  String get creator_support_cancel1 => 'キャンセル';

  @override
  String get creator_support_confirm1 => '確認';

  @override
  String get creator_support_operation_success1 => '操作が完了しました';

  @override
  String get creator_support_edit_message1 => 'メッセージを編集';

  @override
  String creator_support_recall_remaining1(int seconds) {
    return '取り消す（残り$seconds秒）';
  }

  @override
  String get creator_support_recall_expired1 => '取り消す（60秒経過）';

  @override
  String get creator_support_case_updated1 => 'お問い合わせを更新しました';

  @override
  String get creator_support_loading1 => '読み込み中…';

  @override
  String creator_support_creator_uid1(String uid) {
    return 'クリエイターUID：$uid';
  }

  @override
  String get creator_support_internal_note1 => '運営内部メモ（クリエイターには非表示）';

  @override
  String get creator_support_save_internal_note1 => '内部メモを保存';

  @override
  String get creator_support_case_images1 => '添付画像';

  @override
  String get creator_support_official1 => '恋恋拾光運営';

  @override
  String get creator_support_creator1 => 'クリエイター';

  @override
  String get creator_support_recalled1 => 'このメッセージは取り消されました';

  @override
  String get creator_support_edited1 => '編集済み';

  @override
  String get creator_support_reply_hint1 => '返信を入力…';

  @override
  String get creator_support_attach_image1 => '画像を添付（最大3枚）';

  @override
  String get creator_support_send1 => '送信';

  @override
  String get creator_support_admin_title1 => 'クリエイターお問い合わせ管理';

  @override
  String get creator_support_new_reply1 => '新しい返信';

  @override
  String get creator_support_load_more_cases1 => 'さらに読み込む';

  @override
  String get creator_support_image_load_error1 => '画像を読み込めませんでした';

  @override
  String get creator_support_edit_hint1 => 'メッセージを編集';

  @override
  String get creator_support_save1 => '保存';

  @override
  String get creator_support_status_pending1 => '対応待ち';

  @override
  String get creator_support_status_progress1 => '対応中';

  @override
  String get creator_support_status_waiting1 => '追加情報待ち';

  @override
  String get creator_support_status_resolved1 => '解決済み';

  @override
  String get creator_support_cat_character1 => 'キャラクター管理';

  @override
  String get creator_support_cat_ai1 => 'AIキャラクターの会話異常';

  @override
  String get creator_support_cat_dashboard1 => 'クリエイター管理画面';

  @override
  String get creator_support_cat_cooperation1 => '提携と特典';

  @override
  String get creator_support_cat_other1 => 'その他';

  @override
  String get desktop_widget_size_small1 => '小';

  @override
  String get desktop_widget_size_medium1 => '中';

  @override
  String get desktop_widget_size_large1 => '大';

  @override
  String get desktop_widget_cancel1 => 'キャンセル';

  @override
  String get desktop_widget_delete1 => '削除';

  @override
  String desktop_widget_days_remaining1(int days) {
    return 'あと$days日';
  }

  @override
  String get desktop_widget_days_today1 => '今日がその日';

  @override
  String desktop_widget_days_elapsed1(int days) {
    return '$days日前';
  }

  @override
  String get desktop_widget_daily_quote1 => '今日のひと言';

  @override
  String get desktop_widget_update_daily1 => '毎日1回更新';

  @override
  String get desktop_widget_character_birthday1 => 'キャラクターの誕生日';

  @override
  String get desktop_widget_change1 => '変更';

  @override
  String get desktop_widget_mood1 => '気分';

  @override
  String get desktop_widget_current_state1 => '現在の状態';

  @override
  String get desktop_widget_location1 => '場所';

  @override
  String get desktop_widget_relationship1 => '関係';

  @override
  String get desktop_widget_outfit1 => '服装';

  @override
  String get desktop_widget_weather1 => '天気';

  @override
  String get desktop_widget_thought1 => '考え';

  @override
  String get desktop_widget_action1 => '動作';

  @override
  String get desktop_widget_affinity1 => '好感度';

  @override
  String get desktop_widget_character_status1 => 'キャラクターの状態';

  @override
  String get desktop_widget_no_posts1 => 'キャラクターの投稿はまだありません';

  @override
  String get desktop_widget_crop_position1 => 'キャラクターの位置を調整';

  @override
  String get desktop_widget_crop_action1 => '拡大／ドラッグで構図を調整';

  @override
  String get desktop_widget_crop_hint1 => '調整画面では2本指で拡大縮小、1本指でドラッグできます。';

  @override
  String get desktop_widget_crop_title1 => 'キャラクターの構図を調整';

  @override
  String get desktop_widget_reset1 => 'リセット';

  @override
  String get desktop_widget_crop_instructions1 =>
      '1本指で位置を調整し、2本指で拡大縮小します。枠内がウィジェットの表示範囲です。';

  @override
  String desktop_widget_crop_position_scale1(int x, int y, String scale) {
    return '位置：$x% / $y%・倍率：$scale×';
  }

  @override
  String get desktop_widget_apply1 => '適用';

  @override
  String get desktop_widget_just_posted1 => 'たった今投稿しました';

  @override
  String get desktop_widget_important_day1 => '大切な日';

  @override
  String get desktop_widget_no_date1 => '日付が未選択です';

  @override
  String get desktop_widget_first_met1 => '彼と出会った日';

  @override
  String get desktop_widget_error1 => 'エラー';

  @override
  String get event_memory_select_character_title1 => 'キャラクターを選択';

  @override
  String get event_memory_my_characters1 => '自分のキャラクター';

  @override
  String get event_memory_friend_characters1 => '友達のキャラクター';

  @override
  String get event_memory_friend_badge1 => '友達';

  @override
  String get event_memory_unnamed_character1 => '名前のないキャラクター';

  @override
  String get event_memory_generic_error1 => 'エラー';

  @override
  String get memory_collection_title1 => '思い出コレクション';

  @override
  String get memory_collection_avatar_frames1 => 'アイコンフレーム';

  @override
  String get memory_collection_stickers1 => 'ステッカー';

  @override
  String get memory_collection_memories1 => '思い出';

  @override
  String get memory_collection_try_again1 => 'しばらくしてからもう一度お試しください。';

  @override
  String get memory_collection_error1 => 'エラー';

  @override
  String get memory_collection_chat_background1 => 'チャット背景';

  @override
  String get memory_collection_got_it1 => 'わかりました';

  @override
  String get memory_collection_not_now1 => '今はしない';

  @override
  String get memory_collection_confirm_delete1 => '削除を確定';

  @override
  String get memory_collection_close1 => '閉じる';

  @override
  String get memory_collection_delete1 => '削除';

  @override
  String get memory_collection_image_preparing1 => '画像を準備中';

  @override
  String get memory_collection_remove_favorite1 => 'コレクションから削除';

  @override
  String get memory_collection_removed1 => 'コレクションから削除しました';

  @override
  String get event_memory_performance_opening1 => '物語が終わっても、\n消えない瞬間がある。';

  @override
  String get event_memory_performance_generic_error1 => 'エラー';

  @override
  String get event_memory_performance_collected1 => '保存済み';

  @override
  String get event_memory_performance_saving1 => '保存中…';

  @override
  String get event_memory_performance_save_gallery1 => '写真ライブラリに保存';

  @override
  String get event_memory_performance_done1 => '完了';

  @override
  String get event_memory_performance_uncollect_title1 => 'コレクションから削除しますか？';

  @override
  String get event_memory_performance_not_now1 => '今はしない';

  @override
  String get event_memory_performance_uncollect1 => 'コレクションから削除';

  @override
  String get event_memory_performance_uncollected1 => 'コレクションから削除しました';

  @override
  String get event_memory_performance_login_to_collect1 =>
      'この思い出を保存するにはログインしてください';

  @override
  String get event_memory_performance_web_gallery_unsupported1 =>
      'Web版では端末の写真ライブラリに直接保存できません';

  @override
  String get event_memory_performance_gallery_permission1 =>
      '保存するには写真へのアクセス許可が必要です';

  @override
  String get event_memory_performance_image_not_ready1 =>
      '思い出の画像を準備中です。もう一度お試しください';

  @override
  String get event_memory_performance_gallery_saved1 => '写真ライブラリに保存しました';

  @override
  String get event_memory_performance_skip1 => 'スキップ';

  @override
  String get event_memory_performance_memory_label1 => '思い出';

  @override
  String get event_memory_performance_tap_continue1 => 'タップして続ける';

  @override
  String get event_memory_performance_tap_show_full1 => 'タップして全文を表示';

  @override
  String get event_memory_performance_brand_limited_memory1 => '恋恋拾光・限定の思い出';

  @override
  String get event_ended1 => 'イベントは終了しました';

  @override
  String get event_default_name1 => '期間限定イベント';

  @override
  String get event_default_subtitle1 => '彼と一緒に、この季節だけの特別な思い出を。';

  @override
  String get event_currency_default1 => 'イベント通貨';

  @override
  String get event_tasks_today1 => '今日のミッション';

  @override
  String event_tasks_subtitle1(String currency) {
    return 'ミッションを達成し、$currencyを集めて限定コンテンツを解放しよう。';
  }

  @override
  String get event_milestones_title1 => '累計進捗';

  @override
  String event_milestones_subtitle1(String currency) {
    return '$currencyを貯めてイベント限定報酬を受け取ろう。';
  }

  @override
  String get event_memory_title1 => '限定の思い出';

  @override
  String get event_memory_subtitle1 => 'このイベントだけの思い出を残そう。';

  @override
  String get event_shop_title1 => 'イベントショップ';

  @override
  String event_shop_subtitle1(String currency) {
    return '$currencyを使って限定報酬と交換しよう。';
  }

  @override
  String get event_info_title1 => 'イベント詳細';

  @override
  String get event_info_default1 =>
      '期間中の指定ミッションを達成するとイベント通貨を獲得できます。\n交換した報酬はイベント規則に従ってアカウントに配布されます。\n終了後の未使用通貨はイベント規則に従って処理されます。';

  @override
  String get event_generic_error1 => 'エラー';

  @override
  String get event_task_default1 => 'イベントミッション';

  @override
  String get event_claimed1 => '受取済み';

  @override
  String get event_claim1 => '受け取る';

  @override
  String get event_in_progress1 => '進行中';

  @override
  String get event_reward_default1 => '限定報酬';

  @override
  String get event_product_default1 => 'イベント商品';

  @override
  String get event_cancel1 => 'キャンセル';

  @override
  String get event_confirm_exchange1 => '交換を確定';

  @override
  String get event_limited_product1 => '限定商品';

  @override
  String event_insufficient_currency1(String currency) {
    return '$currencyが不足しています';
  }

  @override
  String get event_close1 => '閉じる';

  @override
  String event_redeemed_count_limit1(int count, int max) {
    return '交換済み $count / $max 回';
  }

  @override
  String event_redeemed_count1(int count) {
    return '交換済み $count 回';
  }

  @override
  String get event_redeemed1 => '交換済み';

  @override
  String get event_exchange1 => '交換';

  @override
  String get login_account_deletion_started1 => 'アカウントの削除手続きが開始されました';

  @override
  String get login_account_deletion_expired_description1 =>
      '削除の取り消し期限である3日間を過ぎたため、このアカウントは復元できません。サポートが必要な場合はお問い合わせください。';

  @override
  String get login_account_deletion_confirm1 => '確認';

  @override
  String get event_memory_limited_title1 => '限定の思い出';

  @override
  String get moment_detail_add_photo1 => '写真を追加';

  @override
  String get moment_detail_error1 => 'エラー';

  @override
  String get notification_claim_before_delete1 => 'ギフトメッセージを削除する前に花を受け取ってください';

  @override
  String get notification_error1 => 'エラー';

  @override
  String get notification_creator_gift_already_claimed1 => 'この花はすでに受け取り済みです';

  @override
  String notification_creator_gift_claim_success1(Object amount) {
    return '花を$amount個受け取りました！';
  }

  @override
  String get notification_creator_gift_title1 => 'クリエイターからのギフト';

  @override
  String notification_creator_gift_amount1(Object amount) {
    return '花 $amount個';
  }

  @override
  String get notification_creator_gift_claimed1 => '受取済み';

  @override
  String get notification_creator_gift_claiming1 => '受取中…';

  @override
  String get notification_creator_gift_claim_button1 => '花を受け取る';

  @override
  String get notification_support_subject1 => 'プレイヤーが送信した件名';

  @override
  String get notification_support_content1 => 'プレイヤーが送信した内容';

  @override
  String get notification_support_reported1 => '通報された内容';

  @override
  String get notification_support_reply1 => 'サポートからの返信';

  @override
  String get notification_share_mail1 => 'メッセージを共有';

  @override
  String get notification_original_question1 => '以前のお問い合わせ';

  @override
  String get notification_preferences_chat_title1 => 'キャラクターとのチャット';

  @override
  String get notification_preferences_chat_subtitle1 => 'キャラクターからの返信のプッシュ通知';

  @override
  String get notification_preferences_moments_title1 => '新しい投稿';

  @override
  String get notification_preferences_moments_subtitle1 =>
      'フォロー中のクリエイターやキャラクターの新規投稿';

  @override
  String get notification_preferences_social_title1 => 'ソーシャル通知';

  @override
  String get notification_preferences_social_subtitle1 =>
      'いいね、コメント、フォロー、キャラクターとの交流';

  @override
  String get notification_preferences_announcements_title1 => '公式のお知らせ';

  @override
  String get notification_preferences_announcements_subtitle1 =>
      '公式からの一般的なお知らせ通知';

  @override
  String get notification_preferences_events_title1 => 'イベントのリマインダー';

  @override
  String get notification_preferences_events_subtitle1 => 'イベント終了間近のお知らせ';

  @override
  String get notification_preferences_save_failed1 =>
      '通知設定を保存できませんでした。後でもう一度お試しください。';

  @override
  String get notification_preferences_page_title1 => '通知設定';

  @override
  String get notification_preferences_login_required1 => '先にログインしてください';

  @override
  String get notification_preferences_load_failed1 =>
      '通知設定を読み込めませんでした。後でもう一度お試しください。';

  @override
  String get notification_preferences_footer1 =>
      'ここでの設定は同じプレイヤーアカウントのすべての端末に同期されます。端末の通知許可は各端末で個別に設定してください。プッシュ通知をオフにしても、ゲーム内メールや受信済みの通知は削除されません。';

  @override
  String get official_studio_text_0011 =>
      'Guide completed, but the viewed status could not sync and may appear again.';

  @override
  String get official_studio_text_0021 => 'ログインしてください';

  @override
  String get official_studio_text_0031 => 'Creator Partnership Studio';

  @override
  String get official_studio_text_0041 => 'Guide';

  @override
  String get official_studio_text_0051 =>
      'Unable to verify creator eligibility. Try again later.';

  @override
  String get official_studio_text_0061 =>
      'You do not currently have official creator access.\\nIf approved, contact support to verify activation.';

  @override
  String get official_studio_text_0071 => 'Verified Partner Creator';

  @override
  String get official_studio_text_0081 =>
      'Welcome back to the creator studio. More features are coming soon.';

  @override
  String get official_studio_text_0091 => 'Creator Tools';

  @override
  String get official_studio_text_0101 => 'フォロワー管理';

  @override
  String get official_studio_text_0111 => 'View and remove followers';

  @override
  String get official_studio_text_0121 => 'クリエイター分析';

  @override
  String get official_studio_text_0131 =>
      'Character popularity and total play count';

  @override
  String get official_studio_text_0141 => 'ファンレター';

  @override
  String get official_studio_text_0151 => 'Send messages to your followers';

  @override
  String get official_studio_text_0161 => 'Fan Benefits';

  @override
  String get official_studio_text_0171 => 'Gift your own flowers to followers';

  @override
  String get official_studio_text_0181 => '月間クリエイター報酬';

  @override
  String get official_studio_text_0191 =>
      'Publish 3 new characters to claim 300 flowers';

  @override
  String get official_studio_text_0201 => 'クリエイターバナー';

  @override
  String get official_studio_text_0211 => 'Set your public creator-page banner';

  @override
  String get official_studio_text_0221 => 'パートナー情報';

  @override
  String get official_studio_text_0231 =>
      'Partnership status, benefits and notices';

  @override
  String get official_studio_text_0241 => 'Support Center';

  @override
  String get official_studio_text_0251 =>
      'Report issues and track support replies';

  @override
  String get official_studio_text_0261 =>
      'Eligibility verification failed. Try again later.';

  @override
  String get official_studio_text_0271 =>
      'Official creator access is not available';

  @override
  String get official_studio_text_0281 => 'Unable to load public characters';

  @override
  String get official_studio_text_0291 => 'Creator Overview';

  @override
  String get official_studio_text_0301 => 'Total Plays';

  @override
  String get official_studio_text_0311 => 'Current Followers';

  @override
  String get official_studio_text_0321 => 'Unavailable';

  @override
  String get official_studio_text_0331 => 'Public Character Breakdown';

  @override
  String get official_studio_text_0341 =>
      'No public characters yet. They will appear here after publishing.';

  @override
  String get official_studio_text_0351 => 'Unnamed Character';

  @override
  String get official_studio_text_0361 => 'Total plays (playCount)';

  @override
  String get official_studio_text_0371 =>
      'Statistics reflect available database fields. Plays are not messages, unique players, or revenue.';

  @override
  String get official_studio_text_0381 => 'Unable to load followers';

  @override
  String get official_studio_text_0391 => 'No followers yet';

  @override
  String get official_studio_text_0401 => 'Follower List';

  @override
  String get official_studio_text_0411 =>
      'Up to 100 followers shown; only public nicknames and avatars are displayed.';

  @override
  String get official_studio_text_0421 => 'Remove Follower';

  @override
  String get official_studio_text_0431 => 'キャンセル';

  @override
  String get official_studio_text_0441 => 'Confirm Removal';

  @override
  String get official_studio_text_0451 => 'Follower removed';

  @override
  String get official_studio_text_0461 =>
      'Removal failed. Please try again later.';

  @override
  String get official_studio_text_0471 => 'Player';

  @override
  String get official_studio_text_0481 => 'Unable to load public data';

  @override
  String get official_studio_text_0491 => 'This player';

  @override
  String get official_studio_text_0501 =>
      'Cropped image is still too large. Choose another.';

  @override
  String get official_studio_text_0511 => 'Banner updated';

  @override
  String get official_studio_text_0521 =>
      'Image processing failed. Choose another image.';

  @override
  String get official_studio_text_0531 => 'Banner removed';

  @override
  String get official_studio_text_0541 => 'Removal failed';

  @override
  String get official_studio_text_0551 => 'Please sign in';

  @override
  String get official_studio_text_0561 => 'Public Profile Banner';

  @override
  String get official_studio_text_0571 => 'Image failed to load';

  @override
  String get official_studio_text_0581 => 'No banner set';

  @override
  String get official_studio_text_0591 =>
      'Select a photo, position it within the white frame and confirm to upload.';

  @override
  String get official_studio_text_0601 => 'Processing…';

  @override
  String get official_studio_text_0611 => 'Select and Crop Image';

  @override
  String get official_studio_text_0621 => 'Remove Current Banner';

  @override
  String get official_studio_text_0631 => 'Cannot open this image';

  @override
  String get official_studio_text_0641 =>
      'Cropped file is too large. Choose another image.';

  @override
  String get official_studio_text_0651 => 'Cropping failed. Try again.';

  @override
  String get official_studio_text_0661 => 'Adjust Banner Crop';

  @override
  String get official_studio_text_0671 =>
      'Move the image to select the banner area';

  @override
  String get official_studio_text_0681 =>
      'Drag to move · Pinch or use slider to zoom';

  @override
  String get official_studio_text_0691 =>
      'The white frame shows the final banner (2.5:1)';

  @override
  String get official_studio_text_0701 => 'Zoom';

  @override
  String get official_studio_text_0711 => 'Reset Position';

  @override
  String get official_studio_text_0721 => 'Cropping…';

  @override
  String get official_studio_text_0731 => 'Crop and Upload';

  @override
  String get official_studio_text_0741 => 'Partnership Eligibility';

  @override
  String get official_studio_text_0751 => 'Verifying Eligibility';

  @override
  String get official_studio_text_0761 => 'Available Creator Tools';

  @override
  String get official_studio_text_0771 =>
      'Follower management, analytics, fan mail, flower gifts, monthly rewards and banners.';

  @override
  String get official_studio_text_0781 =>
      'Under current rules, create and first publish three eligible characters this month to claim 300 flowers. Final eligibility is verified by the server.';

  @override
  String get official_studio_text_0791 => 'Official Notices and Agreement';

  @override
  String get official_studio_text_0801 =>
      'Signed agreement terms and official notices take precedence. This page does not replace an agreement. Contact support for questions.';

  @override
  String get official_studio_text_0811 =>
      'Mail subject must contain 1–100 characters';

  @override
  String get official_studio_text_0821 =>
      'Mail body must contain 1–5000 characters';

  @override
  String get official_studio_text_0831 => 'Please select a follower';

  @override
  String get official_studio_text_0841 => 'Confirm Fan Mail';

  @override
  String get official_studio_text_0851 =>
      'Send to all current followers? This uses one broadcast credit.';

  @override
  String get official_studio_text_0861 =>
      'Send to this follower? This uses one private-message credit.';

  @override
  String get official_studio_text_0871 => 'Confirm Send';

  @override
  String get official_studio_text_0881 =>
      'Mail job created. Messages will be delivered gradually.';

  @override
  String get official_studio_text_0891 => 'Today’s Sending Quota';

  @override
  String get official_studio_text_0901 =>
      'Resets daily at 00:00 Taiwan time. A broadcast reaches all followers.';

  @override
  String get official_studio_text_0911 => 'All Followers';

  @override
  String get official_studio_text_0921 => 'One Follower';

  @override
  String get official_studio_text_0931 => 'Unable to get follower list';

  @override
  String get official_studio_text_0941 =>
      'No followers available for messaging';

  @override
  String get official_studio_text_0951 => 'Select a follower (first 100)';

  @override
  String get official_studio_text_0961 => 'Mail Subject';

  @override
  String get official_studio_text_0971 => 'Message';

  @override
  String get official_studio_text_0981 => 'Write a letter to your fans…';

  @override
  String get official_studio_text_0991 => 'Submitting…';

  @override
  String get official_studio_text_1001 => 'Confirm and Send';

  @override
  String get official_studio_text_1011 => 'Sending History';

  @override
  String get official_studio_text_1021 => 'No sending history yet';

  @override
  String get official_studio_text_1031 => 'Queued';

  @override
  String get official_studio_text_1041 => 'Delivering';

  @override
  String get official_studio_text_1051 => 'Completed';

  @override
  String get official_studio_text_1061 => 'Cancelled';

  @override
  String get official_studio_text_1071 => 'Delivery Failed';

  @override
  String get official_studio_text_1081 => 'Untitled Message';

  @override
  String get official_studio_text_1091 =>
      'Shows the latest 20 sending jobs. New and pending jobs stop when creator access is revoked.';

  @override
  String get official_studio_text_1101 => 'Player without a nickname';

  @override
  String get official_studio_text_1111 =>
      'Unable to load followers. Try again later.';

  @override
  String get official_studio_text_1121 => 'Insufficient Flowers';

  @override
  String get official_studio_text_1131 => 'Maybe Later';

  @override
  String get official_studio_text_1141 => 'ショップへ';

  @override
  String get official_studio_text_1151 =>
      'You may gift 1–1000 flowers per follower';

  @override
  String get official_studio_text_1161 => 'Select 1–20 followers';

  @override
  String get official_studio_text_1171 => 'Maximum 5000 flowers per gift';

  @override
  String get official_studio_text_1181 =>
      'Gift message is limited to 300 characters';

  @override
  String get official_studio_text_1191 => 'Confirm Flower Gift';

  @override
  String get official_studio_text_1201 => 'Confirm Gift';

  @override
  String get official_studio_text_1211 =>
      'Gift already submitted; flowers were not deducted twice';

  @override
  String get official_studio_text_1221 => 'Fan Benefits · Flower Gifts';

  @override
  String get official_studio_text_1231 => 'Unable to load flower balance';

  @override
  String get official_studio_text_1241 => 'My Flower Balance';

  @override
  String get official_studio_text_1251 =>
      'Flowers are deducted from your own balance, not paid by the platform.';

  @override
  String get official_studio_text_1261 => 'Select followers (up to 20)';

  @override
  String get official_studio_text_1271 =>
      'Search by public nickname or UID; eligibility is verified by the server at submission.';

  @override
  String get official_studio_text_1281 => 'フォロワーを検索';

  @override
  String get official_studio_text_1291 => 'Enter nickname or player UID';

  @override
  String get official_studio_text_1301 => 'Clear Search';

  @override
  String get official_studio_text_1311 => 'No eligible followers available';

  @override
  String get official_studio_text_1321 =>
      'No matching followers on this page. Continue searching.';

  @override
  String get official_studio_text_1331 => 'No matching followers found';

  @override
  String get official_studio_text_1341 => 'Select up to 20 followers';

  @override
  String get official_studio_text_1351 => 'Searching…';

  @override
  String get official_studio_text_1361 => 'Load More Followers';

  @override
  String get official_studio_text_1371 => 'Search More Followers';

  @override
  String get official_studio_text_1381 => 'Flowers per Follower';

  @override
  String get official_studio_text_1391 => 'e.g. 10';

  @override
  String get official_studio_text_1401 => 'Gift Message (Optional)';

  @override
  String get official_studio_text_1411 => 'Estimated Deduction';

  @override
  String get official_studio_text_1421 =>
      'Up to 20 followers and 5000 flowers per gift. Flowers are deducted on submission; recipients must claim them in their mailbox.';

  @override
  String get official_studio_text_1431 => 'Unable to load monthly tasks';

  @override
  String get official_studio_text_1441 =>
      'Unable to load progress. Try again later.';

  @override
  String get official_studio_text_1451 => 'Confirm Creator Reward';

  @override
  String get official_studio_text_1461 =>
      'Claim 300 flowers for this month? Each month can only be claimed once.';

  @override
  String get official_studio_text_1471 => 'Confirm Claim';

  @override
  String get official_studio_text_1481 => 'Monthly reward already claimed';

  @override
  String get official_studio_text_1491 => 'Successfully claimed 300 flowers!';

  @override
  String get official_studio_text_1501 => 'Claim failed. Try again later.';

  @override
  String get official_studio_text_1511 =>
      'Unable to verify claim. Refresh your history.';

  @override
  String get official_studio_text_1521 => 'This month';

  @override
  String get official_studio_text_1531 =>
      'Create and first publish three different characters each month, then claim 300 flowers.';

  @override
  String get official_studio_text_1541 =>
      'Rules: Only signed and verified partner creators are eligible. Counted characters must be created and first published this month and remain public. Private, draft and republished older characters do not count. Resets monthly in Taiwan time, once per month.';

  @override
  String get official_studio_text_1551 =>
      'Duplicate, empty or rule-violating characters may lead to review or partnership suspension under the agreement.';

  @override
  String get official_studio_text_1561 =>
      'Welcome to the Partner Creator Program';

  @override
  String get official_studio_text_1571 => 'Track your work and stay connected';

  @override
  String get official_studio_text_1581 =>
      'Share flowers and earn creator rewards';

  @override
  String get official_studio_text_1591 => 'Build your page and get support';

  @override
  String get official_studio_text_1601 => 'Your own creative space';

  @override
  String get official_studio_text_1611 => 'Followers · Analytics · Fan Mail';

  @override
  String get official_studio_text_1621 => 'Fan Benefits · Monthly Rewards';

  @override
  String get official_studio_text_1631 =>
      'Banners · Partnership Info · Support';

  @override
  String get official_studio_text_1641 =>
      'Welcome to the official creator studio of Lianlian Shiguang, combining creator tools, fan engagement, benefits and partnership information.';

  @override
  String get official_studio_text_1651 =>
      'View and manage followers, track plays and character performance, and send messages to one follower or your entire audience.';

  @override
  String get official_studio_text_1661 =>
      'Gift flowers from your balance to fans. You may also earn monthly rewards for newly created and first-published eligible characters.';

  @override
  String get official_studio_text_1671 =>
      'Upload your personal creator banner. Review partnership rules and benefits in Partnership Info, or contact the Support Center.';

  @override
  String get official_studio_text_1681 =>
      'Only officially eligible partner creators can use these features.';

  @override
  String get official_studio_text_1691 =>
      'Fan mail has daily sending limits. Check your quota before sending.';

  @override
  String get official_studio_text_1701 =>
      'Flower gifts deduct your balance. Monthly rewards follow current rules and server verification.';

  @override
  String get official_studio_text_1711 =>
      'New creator-exclusive features will be added here over time.';

  @override
  String get official_studio_text_1721 => 'Creator Studio Guide';

  @override
  String get official_studio_text_1731 => 'スキップ';

  @override
  String get official_studio_text_1741 => '戻る';

  @override
  String get official_studio_text_1751 => '完了';

  @override
  String get official_studio_text_1761 => '次へ';

  @override
  String official_studio_text_1771(String name) {
    return 'Confirm removal of $name? They will unfollow you but can follow again.';
  }

  @override
  String official_studio_text_1781(int count) {
    return 'Private messages: $count / 30';
  }

  @override
  String official_studio_text_1791(int count) {
    return 'Broadcasts: $count / 5';
  }

  @override
  String official_studio_text_1801(int count) {
    return 'Gift sent! $count flowers are waiting in your followers’ mailboxes.';
  }

  @override
  String official_studio_text_1811(int count) {
    return '$count flowers 🌸';
  }

  @override
  String official_studio_text_1821(int count) {
    return '$count followers';
  }

  @override
  String official_studio_text_1831(int count) {
    return '$count flowers';
  }

  @override
  String official_studio_text_1841(String month) {
    return '$month creator reward';
  }

  @override
  String official_studio_text_1851(int count) {
    return 'This month: $count / 3';
  }

  @override
  String official_studio_text_1861(int count) {
    return '$count public characters remaining';
  }

  @override
  String official_studio_text_1871(int count) {
    return 'Insufficient flowers: need $count more';
  }

  @override
  String get official_studio_text_1881 => 'Unable to load sending quota';

  @override
  String get official_studio_text_1891 =>
      'Sending is not confirmed. Check your history before retrying.';

  @override
  String get official_studio_text_1901 =>
      'Connection failed. Check your history before trying again.';

  @override
  String get official_studio_text_1911 =>
      'Gift status unconfirmed. Check history before retrying.';

  @override
  String official_studio_text_1921(int balance, int total, int missing) {
    return 'Balance: $balance\\nRequired: $total\\nMissing: $missing\\n\\nVisit the shop to get more flowers.';
  }

  @override
  String official_studio_text_1931(int followers, int amount, int total) {
    return 'Send $followers flowers gifts of $amount each, deducting $total flowers.\\nGifts cannot be revoked.';
  }

  @override
  String official_studio_text_1941(String mode, String status, int count) {
    return '$mode · $status · Delivered to $count';
  }

  @override
  String get official_studio_text_1951 => 'Public characters';

  @override
  String get official_studio_text_1961 => 'Loading…';

  @override
  String get official_studio_text_1971 => 'Select followers';

  @override
  String get official_studio_text_1981 => 'Claimed this month';

  @override
  String get preference_selection_title1 => '好きなキャラクターのタイプを選ぼう';

  @override
  String get preference_selection_description1 =>
      '気になるタグを3～5個選ぶと、好みに合うキャラクターをおすすめできます。';

  @override
  String get preference_selection_recommendation_note1 =>
      'この設定はおすすめの改善にのみ使用されます。ほかのタイプのキャラクターも自由に楽しめます。';

  @override
  String get preference_selection_selected1 => '選択済み';

  @override
  String get preference_selection_start1 => '探索を始める';

  @override
  String preference_selection_max_error1(int count) {
    return 'タグは最大$count個まで選択できます。';
  }

  @override
  String get preference_selection_save_failed1 =>
      '好みを保存できませんでした。後でもう一度お試しください。';

  @override
  String get preference_group_personality1 => '性格・雰囲気';

  @override
  String get preference_group_relationship_age1 => '関係性・年齢差';

  @override
  String get preference_group_story1 => '物語の世界観';

  @override
  String get preference_tag_gentle1 => '優しい';

  @override
  String get preference_tag_cold1 => 'クール';

  @override
  String get preference_tag_scheming1 => '腹黒';

  @override
  String get preference_tag_tsundere1 => 'ツンデレ';

  @override
  String get preference_tag_loyal1 => '忠犬系';

  @override
  String get preference_tag_yandere1 => 'ヤンデレ';

  @override
  String get preference_tag_mysterious1 => 'ミステリアス';

  @override
  String get preference_tag_healing1 => '癒やし系';

  @override
  String get preference_tag_gap_moe1 => 'ギャップ萌え';

  @override
  String get preference_tag_older1 => '年上';

  @override
  String get preference_tag_younger1 => '年下';

  @override
  String get preference_tag_ceo1 => '俺様社長';

  @override
  String get preference_tag_school1 => '学園';

  @override
  String get preference_tag_workplace1 => '職場';

  @override
  String get preference_tag_ancient1 => '時代劇風';

  @override
  String get preference_tag_nonhuman1 => '人外';

  @override
  String get private_label1 => '非公開';

  @override
  String get profile_page_world_tab1 => 'オープンワールド';

  @override
  String get profile_page_login_required1 => 'ログインしてください';

  @override
  String get profile_page_world_load_failed1 =>
      'ワールドを読み込めませんでした。後でもう一度お試しください。';

  @override
  String get profile_page_my_worlds1 => 'マイワールド';

  @override
  String get profile_page_create_world1 => 'ワールドを作成';

  @override
  String get profile_page_worlds_empty1 => 'まだワールドがありません';

  @override
  String get profile_page_worlds_empty_hint1 => '最初のワールドを作成しましょう';

  @override
  String get profile_page_world_untitled1 => '名前のないワールド';

  @override
  String get profile_page_world_public1 => '公開';

  @override
  String get profile_page_world_private1 => '非公開';

  @override
  String profile_page_world_character_count1(int count) {
    return 'キャラクター $count 人';
  }

  @override
  String get profile_page_world_enter_chat1 => 'チャットに入る';

  @override
  String get profile_page_world_edit1 => '編集';

  @override
  String get profile_page_create_character1 => 'キャラクターを作成';

  @override
  String get profile_page_event_frame_default1 => 'イベントアバターフレーム';

  @override
  String get public_worlds_explore_title1 => '公開ワールドを探す';

  @override
  String get public_worlds_search_tooltip1 => 'オープンワールドを検索';

  @override
  String get public_worlds_load_failed1 => '公開ワールドを読み込めません';

  @override
  String get public_worlds_refresh1 => '再読み込み';

  @override
  String get public_worlds_empty1 => '公開ワールドは準備中です。お楽しみに！';

  @override
  String get public_worlds_unnamed1 => '名前のないワールド';

  @override
  String get world_explore_subtitle1 => 'さまざまな世界に足を踏み入れ、新しい旅を楽しもう';

  @override
  String get settings_notification_preferences_title1 => '通知設定';

  @override
  String get settings_notification_preferences_subtitle1 =>
      '受け取る通知の種類を設定し、デバイス間で同期します';

  @override
  String get settings_admin_section1 => '管理';

  @override
  String get settings_admin_dashboard1 => '管理ダッシュボード';

  @override
  String get settings_admin_tools_subtitle1 => '拾光の内部管理ツール';

  @override
  String get world_chat_back1 => '戻る';

  @override
  String get world_chat_mode_tooltip1 => '返信モード（AIと花の消費は未連携）';

  @override
  String get world_chat_menu1 => '世界観メニュー';

  @override
  String get world_chat_mode_story1 => 'ストーリー';

  @override
  String get world_chat_mode_immersive1 => '没入';

  @override
  String get world_chat_mode_resonance1 => '共鳴';

  @override
  String get world_chat_mode_interaction1 => '交流';

  @override
  String world_chat_mode_cost1(String mode, int cost) {
    return '$mode · 花 $cost 個';
  }

  @override
  String world_memo_read_failed1(String error) {
    return 'メモの読み込みに失敗しました：$error';
  }

  @override
  String get world_memo_sync_failed1 => '同期に一時的に失敗しました。前回読み込んだメモを表示しています。';

  @override
  String get world_memo_server_no_id1 => 'サーバーからメモ ID が返されませんでした';

  @override
  String world_memo_save_failed1(String error) {
    return '保存に失敗しました：$error';
  }

  @override
  String get world_memo_delete_title1 => 'メモを削除しますか？';

  @override
  String get world_memo_delete_warning1 => '削除すると元に戻せません。';

  @override
  String get world_memo_cancel1 => 'キャンセル';

  @override
  String get world_memo_delete1 => '削除';

  @override
  String world_memo_cancel_reminder_failed1(String error) {
    return 'メモは削除されましたが、以前の端末の通知を解除できませんでした：$error';
  }

  @override
  String world_memo_delete_failed1(String error) {
    return '削除に失敗しました：$error';
  }

  @override
  String get world_memo_title1 => 'メモ';

  @override
  String world_memo_world_personal1(String worldName) {
    return '$worldName｜個人メモ';
  }

  @override
  String get world_memo_sync_notice1 =>
      '通知時刻は端末間で同期され、ログイン済みで通知を許可した端末にプッシュ通知が届きます。';

  @override
  String get world_memo_loading1 => '読み込み中…';

  @override
  String get world_memo_empty1 => 'メモはまだありません。右下の＋から追加できます。';

  @override
  String world_memo_reminder_date1(String date) {
    return '通知日時：$date';
  }

  @override
  String get world_memo_reminder_future1 => '通知時刻は現在より後に設定してください';

  @override
  String get world_memo_content_required1 => 'メモの内容を入力してください';

  @override
  String get world_memo_edit_title1 => 'メモを編集';

  @override
  String get world_memo_add_title1 => 'メモを追加';

  @override
  String get world_memo_content_label1 => 'メモの内容';

  @override
  String get world_memo_content_hint1 => '覚えておきたいことを書きましょう…';

  @override
  String get world_memo_reminder_settings1 => '通知設定';

  @override
  String get world_memo_no_reminder1 => '通知未設定';

  @override
  String get world_memo_reminder_choose1 => '日時を選んでクラウド同期の通知を設定';

  @override
  String get world_memo_clear_reminder1 => '通知日時を消去';

  @override
  String get world_memo_save1 => 'メモを保存';

  @override
  String get world_chat_open_world1 => 'オープンワールド';

  @override
  String get world_chat_flower_sync1 => '花の残高を同期できません';

  @override
  String get world_chat_web_store_unavailable1 => 'Web版では花を購入できません';

  @override
  String get world_chat_sync_unavailable1 =>
      'リアルタイム同期が利用できません。チャットを開き直して履歴を読み込めます';

  @override
  String get world_chat_stopped1 => '生成を停止しました。花は消費されません';

  @override
  String get world_chat_cannot_stop1 => '返信が完了した可能性があります。チャット履歴と花の残高をご確認ください';

  @override
  String get world_chat_stop_retry1 => '停止できませんでした。もう一度お試しください';

  @override
  String get world_chat_connection_failed1 => '接続に失敗しました';

  @override
  String get world_chat_network_failed1 => 'ネットワークに接続できません';

  @override
  String get world_chat_no_regenerate1 => '再生成できる返信がありません';

  @override
  String get world_chat_paid_regenerate1 => '有料で再生成';

  @override
  String get world_chat_cancel1 => 'キャンセル';

  @override
  String get world_chat_confirm1 => '確認';

  @override
  String get world_chat_no_continue1 => '続けられるストーリーがありません';

  @override
  String get world_chat_no_save1 => '保存できる会話がありません';

  @override
  String get world_chat_loading1 => 'チャットを読み込み中です';

  @override
  String get world_chat_unnamed_character1 => '名前のないキャラクター';

  @override
  String get world_chat_bg_wait1 => '読み込み完了後に背景を変更できます';

  @override
  String get world_chat_sign_in1 => '先にログインしてください';

  @override
  String get world_chat_choose_mode1 => 'ワールドモードを選択';

  @override
  String get world_chat_mode_charge_expl1 => '返信成功時のみモード別に花を消費します。失敗時は無料です';

  @override
  String get world_chat_photo_selected1 => '写真を選択しました';

  @override
  String get world_chat_got_it1 => 'わかりました';

  @override
  String get world_chat_status_settings1 => 'ワールド状態表示設定';

  @override
  String get world_chat_save_settings1 => '設定を保存';

  @override
  String get world_chat_status_saved1 => 'この世界の状態表示設定を保存しました';

  @override
  String get world_chat_not_ready1 => 'ワールドチャットの準備ができていません';

  @override
  String get world_chat_enter_first1 => '先にワールドチャットに入ってください';

  @override
  String get world_chat_photo1 => '写真';

  @override
  String get world_chat_profile1 => 'プロフィール';

  @override
  String get world_chat_interaction1 => 'インタラクション';

  @override
  String get world_chat_theater1 => 'シアター';

  @override
  String get world_chat_status1 => 'ステータス';

  @override
  String get world_chat_secret1 => '秘密の章';

  @override
  String get world_chat_mood1 => '気分';

  @override
  String get world_chat_outfit1 => '服装';

  @override
  String get world_chat_relationship1 => '関係';

  @override
  String get world_chat_thought1 => '考え';

  @override
  String get world_chat_weather1 => '天気';

  @override
  String get world_chat_current_state1 => '現在の状態';

  @override
  String get world_chat_action1 => '動作';

  @override
  String get world_chat_affinity1 => '好感度';

  @override
  String get world_chat_generating1 => '世界は静かに動いています…';

  @override
  String get world_chat_screenshot1 => 'スクリーンショットを共有';

  @override
  String get world_chat_copy1 => '内容をコピー';

  @override
  String get world_chat_copied1 => 'コピーしました';

  @override
  String get world_chat_edit1 => '編集';

  @override
  String get world_chat_delete1 => '削除';

  @override
  String get world_chat_report1 => 'この会話を通報';

  @override
  String get world_chat_feedback1 => '意見を送る';

  @override
  String get world_chat_edit_segment1 => 'キャラクターの段落を編集';

  @override
  String get world_chat_save1 => '保存';

  @override
  String get world_chat_updated1 => 'メッセージを更新しました';

  @override
  String get world_chat_delete_segment1 => '段落を削除';

  @override
  String get world_chat_deleted_segment1 => '段落を削除しました';

  @override
  String get world_chat_edit_message1 => 'メッセージを編集';

  @override
  String get world_chat_edit_hint1 => '文章を編集';

  @override
  String get world_chat_delete_conversation1 => '会話を削除';

  @override
  String get world_chat_no_chat1 => 'まだ会話がありません';

  @override
  String get world_chat_cancel_select1 => '選択を解除';

  @override
  String get world_chat_input_hint1 => 'あなたたちの物語を書こう…';

  @override
  String get world_chat_screenshot_done1 => '特別なひとときが完成しました';

  @override
  String get world_chat_screenshot_style1 => 'スクショの配色を変更';

  @override
  String get world_chat_reselect1 => '選び直す';

  @override
  String get world_chat_download_share1 => 'ダウンロードして共有';

  @override
  String get world_records_summary_title1 => 'ストーリーのあらすじ';

  @override
  String world_records_loaded_count1(int count) {
    return 'チャットメッセージ $count 件を読み込み、物語の順に整理しました。';
  }

  @override
  String get world_records_auto_summary_pending1 =>
      '読み込んだ会話の振り返りです。AI による自動要約はまだ利用できません。';

  @override
  String get world_records_empty_story1 => '振り返るストーリーはまだありません';

  @override
  String get world_records_narrator_name1 => '世界の語り手';

  @override
  String get world_records_relationships_title1 => '人物関係';

  @override
  String get world_records_affinity_note1 =>
      '好感度は正式なキャラクターごとに個別に計算され、一時的なNPCは対象外です。';

  @override
  String get world_records_empty_characters1 => '正式なキャラクターのデータはまだありません';

  @override
  String world_records_affinity_score_with_next1(int score, int next) {
    return '好感度 $score / $next';
  }

  @override
  String world_records_affinity_score_only1(int score) {
    return '好感度 $score';
  }

  @override
  String world_records_relationship_stage1(int stage) {
    return '関係ステージ $stage';
  }

  @override
  String get world_records_local_memo_read_failed1 => '端末のメモを読み込めませんでした';

  @override
  String get world_records_memo_saved_local1 => 'この端末にメモを保存しました';

  @override
  String get world_records_memo_save_failed1 => 'メモを保存できませんでした';

  @override
  String get world_records_memo_unsaved1 => '未保存のメモ';

  @override
  String get world_records_memo_save_before_exit1 => '保存してから終了しますか？';

  @override
  String get world_records_continue_editing1 => '編集を続ける';

  @override
  String get world_records_save_and_exit1 => '保存して終了';

  @override
  String get world_records_world_memo_title1 => '世界へのメモ';

  @override
  String get world_records_save1 => '保存';

  @override
  String get world_records_memo_local_disclaimer1 =>
      '個人メモ｜このバージョンでは端末内のみに保存され、AIへの送信や端末間同期は行われません。';

  @override
  String get world_records_memo_hint1 =>
      '世界で見つけた手がかりや、やりたいこと、キャラクターに伝えたいことを記録…';

  @override
  String get world_records_narrator_short1 => '語り手';

  @override
  String get world_records_summary_service_missing1 =>
      'ストーリー要約サービス（worldStoryMemory）が未デプロイです。デプロイ後に開き直してください。';

  @override
  String get world_records_summary_load_failed1 =>
      'ストーリーのあらすじを読み込めません。後でもう一度お試しください。';

  @override
  String get world_records_summary_intro1 =>
      '出会いも選択も物語の一部になります。大切な経験や人物との関係をここに記録し、物語を紡いでいきましょう。';

  @override
  String get world_records_summary_empty1 => '物語は続いています。印象的な章はまもなくここに記録されます。';

  @override
  String get world_search_title1 => '会話を検索';

  @override
  String get world_search_hint1 => '登場人物、セリフ、ナレーションを検索';

  @override
  String get world_search_clear1 => '検索をクリア';

  @override
  String get world_search_start1 => 'キーワードを入力して検索';

  @override
  String world_search_results1(int count) {
    return '$count 件の結果が見つかりました';
  }

  @override
  String get world_search_empty_prompt1 => 'プレイヤー、登場人物、ナレーションを検索';

  @override
  String get world_search_no_results1 => '一致する会話がありません';

  @override
  String get world_search_unknown_speaker1 => '不明な人物';

  @override
  String get world_search_collapse1 => '閉じる';

  @override
  String get world_search_expand1 => '展開';

  @override
  String get world_search_scope1 => '検索対象：読み込み済みの最新200件のメッセージ';

  @override
  String get world_menu_subtitle1 => 'オープンワールド・機能は順次公開';

  @override
  String get world_menu_chat_section1 => 'チャット';

  @override
  String get world_menu_search1 => '会話を検索';

  @override
  String get world_menu_save_transcript1 => '会話履歴を保存';

  @override
  String get world_menu_memories_background1 => '思い出と背景';

  @override
  String get world_menu_relations_section1 => '世界の関係';

  @override
  String get world_menu_story_summary1 => 'ストーリーの要約';

  @override
  String get world_menu_relationships1 => '人物関係';

  @override
  String get world_menu_memos1 => 'メモ';

  @override
  String get world_menu_memory_section1 => '記憶の管理';

  @override
  String get world_menu_reset_progress1 => '世界の進行状況をリセット';

  @override
  String get world_chat_book_confirm1 => '確認';

  @override
  String get world_custom_scene_title_required1 => '劇場のタイトルを入力してください。';

  @override
  String get world_custom_scene_description_required1 => 'シーンの説明を入力してください。';

  @override
  String get world_custom_scene_save_failed1 =>
      '保存に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get world_custom_scene_edit_title1 => '劇場を編集';

  @override
  String get world_custom_scene_add_title1 => '劇場を追加';

  @override
  String get world_discovery_share_desc1 => 'クリエイターのオープンワールドに入り、あなただけの物語を始めよう。';

  @override
  String world_discovery_share_text1(
      String title, String description, String link) {
    return '恋恋拾光・オープンワールドへの招待\n\n「$title」\n\n$description\n\n今すぐ探索：$link';
  }

  @override
  String get world_discovery_brand1 => '恋恋拾光';

  @override
  String get world_discovery_invite1 => 'オープンワールドへの招待';

  @override
  String get world_discovery_scan1 => 'スキャンしてダウンロード';

  @override
  String get world_discovery_cancel1 => 'キャンセル';

  @override
  String get world_discovery_share_button1 => '招待カードを共有';

  @override
  String get world_discovery_share_missing_card1 => '招待カードが見つかりません';

  @override
  String get world_discovery_share_image_failed1 => '共有画像を作成できません';

  @override
  String get world_discovery_share_failed1 => '招待カードを共有できませんでした。もう一度お試しください。';

  @override
  String get world_discovery_story_open1 => '物語の始まり';

  @override
  String get world_discovery_story_unset1 => '物語の始まりは未設定です';

  @override
  String get world_discovery_first_unset1 => '最初のセリフは未設定です';

  @override
  String get world_discovery_background_title1 => '世界観の背景と説明';

  @override
  String world_discovery_era1(String era) {
    return '時代・舞台：$era';
  }

  @override
  String get world_discovery_background_unset1 => '世界観の背景は未設定です';

  @override
  String get world_discovery_background_full1 => '世界観の詳細';

  @override
  String get world_discovery_people_unset1 => '登場人物は未設定です';

  @override
  String get world_discovery_people_intro1 => '登場人物の紹介';

  @override
  String get world_discovery_appearance_unset1 => '外見の設定はありません';

  @override
  String get world_discovery_creator_unset1 => 'クリエイター情報がありません';

  @override
  String get world_discovery_creator1 => 'クリエイター';

  @override
  String get world_discovery_creator_load_failed1 => 'クリエイター情報を読み込めません';

  @override
  String world_discovery_world_load_failed1(String error) {
    return 'オープンワールドの読み込みに失敗：$error';
  }

  @override
  String get world_discovery_unpublished1 => 'この世界は非公開です';

  @override
  String get world_discovery_open_world1 => 'オープンワールド';

  @override
  String get world_discovery_share_tooltip1 => 'オープンワールドを共有';

  @override
  String get world_discovery_world_background1 => '世界の背景';

  @override
  String get world_discovery_not_playable1 => 'この世界はまだプレイできません。';

  @override
  String get world_discovery_enter1 => '世界に入る';

  @override
  String get world_edit_login_required1 => '先にログインしてください';

  @override
  String get world_edit_no_edit_permission1 => 'この世界を編集する権限がありません';

  @override
  String get world_edit_secret_permission_error1 =>
      'Unable to access secret chapters. Check the deployed Firestore rules. Saving is paused to protect existing data.';

  @override
  String world_edit_secret_read_error_code1(String code) {
    return 'Could not load secret chapters ($code). Saving is paused to protect existing data.';
  }

  @override
  String get world_edit_secret_read_error1 =>
      'Could not load secret chapters. Saving is paused to protect existing data.';

  @override
  String world_edit_world_read_error1(String error) {
    return 'Could not load world: $error';
  }

  @override
  String world_edit_image_max1(int count) {
    return 'A world can have up to $count images';
  }

  @override
  String world_edit_image_read_error1(String error) {
    return 'Could not load images: $error';
  }

  @override
  String get world_edit_tag_heading1 => 'Theme tags (up to 5)';

  @override
  String get world_edit_tag_max1 => 'Select up to 5 tags';

  @override
  String get world_edit_tag_custom1 =>
      'Tags (customizable; separate with commas)';

  @override
  String get world_edit_secret_not_ready1 =>
      'Secret chapters have not loaded. Publishing is paused to protect your content. Check permissions and reopen this page.';

  @override
  String get world_edit_required_publish1 =>
      'Enter a world name, at least one image, world background, story opening, and first line';

  @override
  String get world_edit_max_tags_save1 =>
      'Only 5 theme tags are allowed. Remove extras before saving';

  @override
  String get world_edit_secret_validation1 =>
      'Each chapter needs a title, unlock condition, and secret content (up to 12 chapters)';

  @override
  String get world_edit_draft_saved1 => 'World draft and secret chapters saved';

  @override
  String get world_edit_publish_unconfirmed1 =>
      'The server has not confirmed public eligibility. Please try publishing again later.';

  @override
  String world_edit_publish_backend_error1(String code, String message) {
    return 'World data was saved, but public activation failed ($code): $message. Fix the issue and select “Publish open world” again.';
  }

  @override
  String get world_edit_publish_service_missing1 =>
      'Verify that worldPublish is deployed';

  @override
  String get world_edit_public_published1 => 'Public open world published';

  @override
  String get world_edit_private_saved1 => 'Private open world saved';

  @override
  String world_edit_save_publish_failed1(String error) {
    return 'Save or publish failed: $error';
  }

  @override
  String get world_edit_save_draft_question1 => '下書きを保存しますか？';

  @override
  String get world_edit_save_draft_explain1 =>
      '退出する前にこの世界を保存しますか？未保存の変更は失われます。';

  @override
  String get world_edit_discard1 => '保存しない';

  @override
  String get world_edit_cancel1 => 'キャンセル';

  @override
  String get world_edit_save_draft1 => '下書きを保存';

  @override
  String get world_edit_world_name1 => 'オープンワールド名 *';

  @override
  String get world_edit_world_images1 => '世界の画像（最大6枚、最初の画像が表紙）';

  @override
  String get world_edit_cover1 => '表紙';

  @override
  String get world_edit_set_cover1 => '表紙に設定';

  @override
  String get world_edit_short_pitch1 =>
      'One-line card description (optional, up to 60 characters)';

  @override
  String get world_edit_public_summary1 => '公開用の世界紹介（ネタバレなし）';

  @override
  String get world_edit_era1 =>
      'Time period (e.g. fictional present day, Republican era)';

  @override
  String get world_edit_world_rules1 => '世界の背景とルール *';

  @override
  String get world_edit_full_lore1 => '世界の詳細設定・出来事・場所（AI用）';

  @override
  String get world_edit_npc_intro1 =>
      '主要キャラクターやNPCの名前、容姿、誕生日、関係、写真を設定できます。プレイヤーは自分の物語の主人公です。';

  @override
  String get world_edit_main_characters1 => '主要キャラクター';

  @override
  String get world_edit_main_subtitle1 =>
      'Important characters who appear frequently in this world';

  @override
  String get world_edit_npc_subtitle1 =>
      'Other characters who may become interaction partners as the story unfolds';

  @override
  String world_edit_people_count1(int count) {
    return '$count人';
  }

  @override
  String get world_edit_role_unset1 => 'Role / occupation not set';

  @override
  String get world_edit_remove_person1 => 'Remove character';

  @override
  String world_edit_add_person1(String type) {
    return '$typeを追加';
  }

  @override
  String get world_edit_add_secret1 => '秘密の章を追加';

  @override
  String get world_edit_edit_secret1 => '秘密の章を編集';

  @override
  String get world_edit_chapter_title1 => '章のタイトル *';

  @override
  String get world_edit_unlock_condition1 =>
      'Unlock condition (description for server evaluation) *';

  @override
  String get world_edit_secret_content1 => '秘密の内容 *';

  @override
  String get world_edit_confirm1 => '確認';

  @override
  String get world_edit_story_opening1 => '物語の始まり *';

  @override
  String get world_edit_first_line1 => '物語の最初の一言 *';

  @override
  String get world_edit_secret_chapters1 => '秘密の章';

  @override
  String get world_edit_secret_explain1 =>
      'Secret chapters are stored privately. Publishing the world does not reveal them; players must meet story conditions to unlock them.';

  @override
  String get world_edit_add_secret_max1 => 'Add secret chapter (up to 12)';

  @override
  String get world_edit_publish_settings1 => '公開設定';

  @override
  String get world_edit_private_world1 => '非公開ワールド';

  @override
  String get world_edit_private_world_desc1 => '自分だけがプレイ・テストでき、他のプレイヤーは入れません';

  @override
  String get world_edit_public_world1 => '公開ワールド';

  @override
  String get world_edit_public_world_desc1 => '他のプレイヤーも参加でき、それぞれ独立した物語を進めます';

  @override
  String get world_edit_create_world1 => 'オープンワールドを作成';

  @override
  String get world_edit_basic_tab1 => '基本設定';

  @override
  String get world_edit_characters_tab1 => '登場人物';

  @override
  String get world_edit_story_tab1 => '物語設定';

  @override
  String get world_edit_publish_world1 => 'オープンワールドを公開';

  @override
  String get world_edit_name_required1 => '人物の名前を入力してください';

  @override
  String world_edit_edit_person1(String type) {
    return '$typeを編集';
  }

  @override
  String get world_edit_upload_photo1 => '人物の写真をアップロード（任意）';

  @override
  String get world_edit_allow_photo1 =>
      'Allow generating other images from this character\'s photo';

  @override
  String get world_edit_allow_photo_explain1 =>
      'Use this character\'s photo as a reference only when appropriate for the story. Chatting and ordinary gifts still work if disabled. Set separately for each character.';

  @override
  String get world_edit_name1 => '名前 *';

  @override
  String get world_edit_gender1 => '性別／ジェンダー';

  @override
  String get world_edit_birthday1 => '誕生日（例：5月16日）';

  @override
  String get world_edit_age1 => '年齢';

  @override
  String get world_edit_role1 => '役割／職業';

  @override
  String get world_edit_appearance1 => '外見';

  @override
  String get world_edit_personality1 => '性格と人物設定';

  @override
  String get world_edit_background1 => '過去の経歴';

  @override
  String get world_edit_relationships1 => '他の人物との関係';

  @override
  String get world_edit_speech_style1 => '話し方／口調';

  @override
  String get world_edit_dialogue_examples1 => '会話例（AIが口調を理解するため）';

  @override
  String get world_edit_save_person1 => '人物設定を保存';

  @override
  String get world_edit_tag_mystery1 => 'サスペンス';

  @override
  String get world_edit_tag_horror1 => 'ホラー';

  @override
  String get world_edit_tag_romance1 => '恋愛';

  @override
  String get world_edit_tag_modern_fantasy1 => '現代ファンタジー';

  @override
  String get world_edit_tag_school1 => '学園';

  @override
  String get world_edit_tag_ensemble1 => '群像劇';

  @override
  String get world_edit_tag_adventure1 => '冒険';

  @override
  String get world_edit_tag_daily1 => '日常';

  @override
  String get world_edit_tag_detective1 => '推理';

  @override
  String get world_edit_tag_otherworld1 => '異世界';

  @override
  String get chooseNpc1 => 'NPCを選択';

  @override
  String get chooseInteractionTarget1 => '交流相手を選択';

  @override
  String get unnamedCharacter1 => '名前のないキャラクター';

  @override
  String get chooseTargetFirst1 => '先に交流相手を選択してください';

  @override
  String get confirmGift1 => 'ギフトを確認';

  @override
  String giftConfirmDetail1(String target, String gift, int cost) {
    return '$targetに$giftを贈ります。花を$cost個消費します。AIの返信成功後にのみ引き落とされます。';
  }

  @override
  String get cancel1 => 'キャンセル';

  @override
  String get send1 => '送信';

  @override
  String get sendLocationTitle1 => '場所を送信（花3個）';

  @override
  String get customLocation1 => '場所を入力';

  @override
  String get confirm1 => '確認';

  @override
  String get cafe1 => 'カフェ';

  @override
  String get park1 => '公園';

  @override
  String get restaurant1 => 'レストラン';

  @override
  String get street1 => '通り';

  @override
  String get giftHeart1 => 'ハート';

  @override
  String get giftFlower1 => '花';

  @override
  String get giftSun1 => '太陽';

  @override
  String get giftConfetti1 => '紙吹雪';

  @override
  String get giftCoffee1 => 'コーヒー';

  @override
  String get giftCake1 => 'ケーキ';

  @override
  String get interactionPlayTitle1 => '交流アクション';

  @override
  String interactionTargetLabel1(String target) {
    return '交流相手：$target';
  }

  @override
  String get intimateInteraction1 => '親密な交流';

  @override
  String get poke1 => 'つつく';

  @override
  String get hug1 => 'ハグ';

  @override
  String get holdHands1 => '手をつなぐ';

  @override
  String get gifts1 => 'ギフト';

  @override
  String get funActivities1 => 'お楽しみ';

  @override
  String get sendLocation1 => '場所を送信';

  @override
  String get diceDuel1 => 'サイコロ対決';

  @override
  String get world_profile_name_too_long1 =>
      'ワールド内のキャラクター名は40文字以内にしてください。短くしてから保存してください。';

  @override
  String get world_profile_identity_too_long1 =>
      'ワールド内の人物情報が2,000文字を超えています。短くしてから保存してください。';

  @override
  String get world_relationship_live_title1 => '人物関係';

  @override
  String get world_relationship_live_load_failed1 =>
      '関係データを読み込めません。Firestore の権限を確認してください。';

  @override
  String get world_relationship_live_no_people1 => 'この世界にはまだ人物が登録されていません。';

  @override
  String get world_relationship_live_not_met1 => '現在の関係：まだ出会っていない';

  @override
  String get world_relationship_live_first_meeting1 => '初対面';

  @override
  String world_relationship_live_current_relation1(String relation) {
    return '現在の関係：$relation';
  }

  @override
  String get world_relationship_live_thought_title1 => 'プレイヤーへの現在の思い';

  @override
  String get world_relationship_live_thought_pending1 =>
      '今後の交流を通して少しずつ印象が形作られます。';

  @override
  String world_scene_full_load_error1(String error) {
    return '劇場の読み込みに失敗しました：$error';
  }

  @override
  String get world_scene_full_delete_title1 => '劇場を削除';

  @override
  String world_scene_full_delete_confirm1(String title) {
    return '「$title」を削除しますか？';
  }

  @override
  String get world_scene_full_cancel1 => 'キャンセル';

  @override
  String get world_scene_full_delete1 => '削除';

  @override
  String world_scene_full_delete_error1(String error) {
    return '劇場の削除に失敗しました：$error';
  }

  @override
  String get world_scene_full_missing_fields1 => 'タイトルとシーンの説明を入力してください。';

  @override
  String world_scene_full_activate_error1(String error) {
    return '劇場の開始に失敗しました：$error';
  }

  @override
  String get world_scene_full_end_title1 => '劇場を終了';

  @override
  String get world_scene_full_end_confirm1 => '現在の劇場を終了しますか？';

  @override
  String world_scene_full_end_error1(String error) {
    return '劇場の終了に失敗しました：$error';
  }

  @override
  String get world_scene_full_unnamed1 => '無題の劇場';

  @override
  String world_scene_full_opening1(String opening) {
    return '導入：$opening';
  }

  @override
  String get world_scene_full_edit1 => '編集';

  @override
  String get world_scene_full_start1 => '劇場を開始';

  @override
  String get world_scene_full_creator_empty1 => 'クリエイターの劇場はまだありません';

  @override
  String get world_scene_full_custom_empty1 => '作成した劇場はまだありません';

  @override
  String get world_scene_full_add1 => '劇場を追加';

  @override
  String get world_scene_full_page_title1 => '劇場';

  @override
  String get world_scene_full_creator_tab1 => 'クリエイター劇場';

  @override
  String get world_scene_full_custom_tab1 => '自作劇場';

  @override
  String world_scene_full_active1(String title) {
    return '進行中の劇場：$title';
  }

  @override
  String get world_scene_required1 => 'シーンのタイトルと内容を入力してください';

  @override
  String get world_scene_title1 => 'シーン';

  @override
  String get world_scene_beta_notice1 =>
      'ワールドシーンのテスト版：ワールドチャットAIでシーンを開始します。専用セーブと正式な開始APIはまだ未対応です。';

  @override
  String get world_scene_creator_scenes1 => 'クリエイターのシーン';

  @override
  String get world_scene_no_creator_scenes1 =>
      'この世界には現在、利用できるクリエイターのシーン設定がありません';

  @override
  String get world_scene_custom_scenes1 => 'シーンを自作する';

  @override
  String get world_scene_name1 => 'シーン名';

  @override
  String get world_scene_setup1 => '背景、場所、登場人物、導入状況';

  @override
  String get world_scene_start1 => 'シーンを開始';

  @override
  String get worldSearchTitle1 => 'オープンワールドを検索';

  @override
  String get worldSearchHint1 => 'ワールド名、クリエイター、タグを検索';

  @override
  String get worldSearchClear1 => '検索をクリア';

  @override
  String get worldSearchEmpty1 => '一致するオープンワールドが見つかりません';

  @override
  String get worldSearchTrending1 => '人気のワールド';

  @override
  String get worldSearchResults1 => '検索結果';

  @override
  String get worldSearchUnnamed1 => '名前のないワールド';

  @override
  String worldSearchCreator1(String creator) {
    return 'クリエイター：$creator';
  }

  @override
  String get world_secret_chapters_title1 => '秘密の章';

  @override
  String get world_secret_chapters_close1 => '閉じる';

  @override
  String get world_secret_chapters_read_failed1 => '秘密の章を現在読み込めません';

  @override
  String get world_secret_chapters_retry1 => '読み込みに失敗しました。タップして再試行';

  @override
  String get world_secret_chapters_empty1 => 'クリエイターはまだ秘密の章を設定していません';

  @override
  String world_secret_chapters_locked_chapter1(String number) {
    return '第$number章 · ？？？';
  }

  @override
  String get world_secret_chapters_unlocked1 => '解放済み · タップして読む';

  @override
  String get world_secret_chapters_locked1 => '未解放 · 物語を探索しよう';

  @override
  String world_timeline_load_failed1(String error) {
    return 'ストーリーの要約を読み込めませんでした：$error';
  }

  @override
  String get world_timeline_edit_summary1 => 'ストーリーの要約を編集';

  @override
  String get world_timeline_cancel1 => 'キャンセル';

  @override
  String get world_timeline_save1 => '保存';

  @override
  String world_timeline_save_failed1(String error) {
    return '保存に失敗しました：$error';
  }

  @override
  String get world_timeline_delete_summary1 => '要約を削除';

  @override
  String get world_timeline_delete_confirm1 => 'このストーリーの記録を削除しますか？';

  @override
  String get world_timeline_delete1 => '削除';

  @override
  String world_timeline_delete_failed1(String error) {
    return '削除に失敗しました：$error';
  }

  @override
  String get world_timeline_our_story1 => '私たちの物語';

  @override
  String get world_timeline_retry1 => '再試行';

  @override
  String get world_timeline_empty1 => '物語はまだ続いています。物語が進むと新しい記録が追加されます。';

  @override
  String get world_timeline_recent1 => '最近の記録';

  @override
  String get world_timeline_edit1 => '編集';

  @override
  String get echo_login_to_post1 => 'ログインしてから時空のこだまを残してください';

  @override
  String get echo_limit1 => '同じオープンワールドに残せるこだまは1人3件までです';

  @override
  String get echo_count_fail1 => 'こだまの件数を確認できません。後でもう一度お試しください';

  @override
  String get echo_compose_title1 => '時空のこだまを残す';

  @override
  String get echo_compose_desc1 => '好きなカードを選び、残したい言葉を書いてください。';

  @override
  String get echo_compose_hint1 => 'この世界にどんな言葉を残しますか？';

  @override
  String get echo_send1 => 'こだまを投稿';

  @override
  String get echo_player1 => 'プレイヤー';

  @override
  String get echo_sent1 => '時空のこだまを投稿しました';

  @override
  String get echo_post_fail1 => '投稿に失敗しました。権限と通信状況をご確認ください';

  @override
  String get echo_login1 => 'ログインしてください';

  @override
  String get echo_like_fail1 => 'いいねに失敗しました';

  @override
  String get echo_delete_title1 => 'このこだまを削除しますか？';

  @override
  String get echo_delete_warning1 => '削除すると元に戻せません。';

  @override
  String get echo_cancel1 => 'キャンセル';

  @override
  String get echo_delete1 => '削除';

  @override
  String get echo_deleted1 => 'こだまを削除しました';

  @override
  String get echo_delete_fail1 => '削除に失敗しました';

  @override
  String get echo_reason_inappropriate1 => '不適切な内容';

  @override
  String get echo_reason_harassment1 => '嫌がらせ・攻撃';

  @override
  String get echo_reason_spam1 => 'スパム';

  @override
  String get echo_reason_other1 => 'その他';

  @override
  String get echo_report_title1 => '時空のこだまを通報';

  @override
  String get echo_already_reported1 => 'このこだまは通報済みです';

  @override
  String get echo_report_received1 => '通報を受け付けました';

  @override
  String get echo_report_fail1 => '通報に失敗しました';

  @override
  String get echo_options1 => 'こだまのオプション';

  @override
  String get echo_delete_option1 => 'こだまを削除';

  @override
  String get echo_report_option1 => 'こだまを通報';

  @override
  String get echo_wall_title1 => '時空のこだま';

  @override
  String get echo_add1 => 'こだまを残す';

  @override
  String get echo_load_fail1 => '時空のこだまを読み込めません。Firestoreの権限をご確認ください';

  @override
  String get echo_empty1 => 'まだこだまがありません。最初の物語を残しましょう。';

  @override
  String get store_pack_30_name1 => '出会いパック';

  @override
  String get store_pack_70_name1 => 'ときめきの予感パック';

  @override
  String get store_pack_120_name1 => '胸キュンパック';

  @override
  String get store_pack_190_name1 => '熱愛パック';

  @override
  String get store_pack_250_name1 => '親友パック';

  @override
  String get store_pack_330_name1 => '見守りパック';

  @override
  String get store_pack_450_name1 => '信頼パック';

  @override
  String get store_pack_520_name1 => '愛してるパック';

  @override
  String get store_pack_690_name1 => 'ハネムーンパック';

  @override
  String get store_pack_720_name1 => '約束パック';

  @override
  String get store_pack_750_name1 => '寄り添いパック';

  @override
  String get store_pack_830_name1 => '深愛パック';

  @override
  String get store_pack_990_name1 => '末永くパック';

  @override
  String get store_pack_1050_name1 => 'かけがえのない人パック';

  @override
  String get store_pack_1290_name1 => '最愛パック';

  @override
  String get store_pack_1314_name1 => '一生一緒パック';

  @override
  String get store_pack_1930_name1 => '誓いパック';

  @override
  String get store_pack_2990_name1 => '永遠の恋人パック';
}
