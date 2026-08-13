// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get settingsTitle => '설정';

  @override
  String get changeTheme => '테마 색상 변경';

  @override
  String get feedback => '피드백';

  @override
  String get changeLanguage => '언어 변경';

  @override
  String get allFriendsTitle => '모든 친구';

  @override
  String get noFriendsMessage => '아직 친구가 없습니다.';

  @override
  String get unknownCharacter => '알 수 없는 캐릭터';

  @override
  String errorLoadingFriends(String error) {
    return '친구 목록을 불러오는 중 오류가 발생했습니다: $error';
  }

  @override
  String get tagGentle => '온화한';

  @override
  String get tagCheerful => '쾌활한';

  @override
  String get tagLively => '활발한';

  @override
  String get tagMischievous => '장난꾸러기';

  @override
  String get tagRichYoungLady => '아가씨';

  @override
  String get tagRichYoungMaster => '도련님';

  @override
  String get tagWealthyFamily => '부잣집';

  @override
  String get tagScheming => '속셈';

  @override
  String get tagPossessive => '집착';

  @override
  String get tagParanoid => '편집증';

  @override
  String get tagPersistent => '고집';

  @override
  String get tagUncle => '아저씨';

  @override
  String get tagAuntie => '아줌마';

  @override
  String get tagSeniorSister => '선배(여자)';

  @override
  String get tagJuniorBrother => '후배(남자)';

  @override
  String get tagHandsome => '멋진';

  @override
  String get tagStunning => '매혹적인';

  @override
  String get tagContrast => '반전';

  @override
  String get tagFlirty => '유혹적';

  @override
  String get tagAgeGap => '나이 차이';

  @override
  String get userNotFoundError => '사용자를 찾을 수 없습니다';

  @override
  String get imageDataMismatchError => '이미지 데이터가 일치하지 않습니다. 이미지를 다시 선택해주세요.';

  @override
  String get createCharacterTitle => '캐릭터 생성';

  @override
  String get charAlbumTitle => '캐릭터 앨범 (첫 번째 이미지가 메인 아바타)';

  @override
  String get charNameLabel => '캐릭터 이름:';

  @override
  String get charDescSection => '캐릭터 설명:';

  @override
  String get charAgeLabel => '나이:';

  @override
  String get charJobLabel => '직업:';

  @override
  String get charBirthdayLabel => '생일:(MMDD)';

  @override
  String get charGenderLabel => '성별 ';

  @override
  String get genderNotSelected => '선택 안함';

  @override
  String get genderMale => '남';

  @override
  String get genderFemale => '여';

  @override
  String get genderOther => '기타';

  @override
  String get charHeightLabel => '키:(cm)';

  @override
  String get charAppearanceLabel => '외모 설명:';

  @override
  String get charPersonalityTagsSection => '성격 태그';

  @override
  String get charOtherPersonalityTagsHint => '기타 성격 태그...';

  @override
  String get otherSectionTitle => '기타';

  @override
  String get charLikesLabel => '좋아하는 것:(예: 딸기 케이크, 고양이, 비 오는 날)';

  @override
  String get charDislikesLabel => '싫어하는 것:(예: 여주, 시끄러운 장소)';

  @override
  String get charSecretsLabel => '아무도 모르는 작은 비밀: (예: 사실 길치)';

  @override
  String get charMannerismsSection => '말과 행동';

  @override
  String get charToneLabel => '말투와 스타일: (예: 낯선 사람에게는 차가운)';

  @override
  String get charDialogueExampleLabel =>
      '대화 예시: (플레이어: 당신은 정말 좋은 사람이에요! 캐릭터: ...아. )';

  @override
  String get charBackgroundSection => '캐릭터 배경:';

  @override
  String get charBackgroundHint => '캐릭터의 배경 이야기를 입력하세요 (최대 2500자)';

  @override
  String get charStoryStartSection => '이야기 시작:';

  @override
  String get charStoryStartHint => '캐릭터의 줄거리를 입력하세요 (최대 2500자)';

  @override
  String get charStorySummaryLabel => '이야기 요약 (최대 50자, 만남 카드에 표시됨)';

  @override
  String get charExtraInfoSection => '캐릭터 추가 내용:';

  @override
  String get charExtraInfoHint => '추가 내용을 입력하세요...';

  @override
  String get charPublicToggleLabel => '다른 플레이어가 플레이할 수 있도록 공개하시겠습니까?';

  @override
  String get yes => '예';

  @override
  String get no => '아니요';

  @override
  String get createButton => '생성';

  @override
  String get saveButton => '저장';

  @override
  String get cancelButton => '취소';

  @override
  String get exitCreationTitle => '캐릭터 생성 화면을 종료합니다';

  @override
  String get saveDraftPrompt => '초안으로 저장하시겠습니까?';

  @override
  String get draftNeeded => '예';

  @override
  String get draftNotNeeded => '아니요';

  @override
  String get editExtraInfoTitle => '추가 내용 편집';

  @override
  String get nameAndAvatarError => '캐릭터 이름을 입력하고 아바타를 하나 이상 업로드해주세요!';

  @override
  String get savingStatus => '저장 중...';

  @override
  String get uploadingImagesStatus => '이미지 업로드 중...';

  @override
  String get maxImagesError => '최대 10장까지 이미지를 업로드할 수 있습니다.';

  @override
  String get uploadingImagesStatusShort => '이미지 처리 중...';

  @override
  String get savingCharacterData => '캐릭터 데이터 저장 중...';

  @override
  String characterCreatedSuccess(String charName) {
    return '캐릭터 \"$charName\"이(가) 생성되었습니다!';
  }

  @override
  String get uploadImageTimeoutError =>
      '캐릭터 생성 실패: 이미지 업로드 시간이 초과되었습니다. 인터넷 연결을 확인해주세요.';

  @override
  String createCharacterGenericError(String error) {
    return '캐릭터 생성 실패: $error';
  }

  @override
  String get settingsSectionAppearance => '외관 및 콘텐츠';

  @override
  String get settingsSectionAccount => '계정 및 콘텐츠 관리';

  @override
  String get settingsSectionAbout => '우리에 대하여';

  @override
  String get accountManagement => '계정 관리';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => '알 수 없음';

  @override
  String get userIdCopied => '사용자 ID가 클립보드에 복사되었습니다';

  @override
  String get characterManagement => '캐릭터 관리';

  @override
  String get viewBlockedCharacters => '차단된 캐릭터 보기';

  @override
  String get privacyPolicy => '개인정보 보호정책';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get logoutButton => '로그아웃';

  @override
  String get logoutDialogTitle => '로그아웃하시겠습니까?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => '잘못 눌렀어요';

  @override
  String get logoutDialogActionConfirm => '확인';

  @override
  String get logoutSuccessSnackbar => '좋아요! 다시 돌아올 때까지 기다릴게요♥(´∀` )';

  @override
  String get deleteAccountButton => '계정 삭제';

  @override
  String get deleteAccountDialogTitle => '이 계정을 정말 삭제하시겠습니까?இдஇ';

  @override
  String get deleteAccountDialogContent =>
      '이 작업은 되돌릴 수 없으며, 모든 데이터가 영구적으로 삭제됩니다!';

  @override
  String get deleteAccountDialogActionCancel => '아니요, 삭제하지 않을게요';

  @override
  String get deleteAccountDialogActionConfirm => '확인';

  @override
  String get deleteAccountSuccessSnackbar => '계정이 성공적으로 삭제되었습니다.';

  @override
  String get appDisclaimer => '게임 속 캐릭터와 배경은 모두 허구이오니 현실과 혼동하지 마세요!';

  @override
  String appVersion(String version) {
    return '앱 버전: $version';
  }

  @override
  String get dialogTitleHint => '힌트';

  @override
  String get completeProfilePrompt => '먼저 프로필을 편집하여 정보를 완성해 주세요!';

  @override
  String get goToEdit => '편집으로 이동';

  @override
  String get later => '나중에';

  @override
  String chattingWith(String friendName) {
    return '$friendName 님과 대화 중';
  }

  @override
  String chatContentWith(String friendName) {
    return '$friendName 님과의 대화 내용';
  }

  @override
  String get chatInputHint => '메시지 입력...';

  @override
  String get characterNotFoundError => '캐릭터 데이터를 찾을 수 없습니다';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return '캐릭터 세부 정보 로드 실패: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => '초기 관계';

  @override
  String get relationship_childhood_friend => '소꿉친구';

  @override
  String get relationship_senior_junior => '선후배';

  @override
  String get relationship_bickering_couple => '티격태격하는 사이';

  @override
  String get relationship_colleagues => '직장 동료';

  @override
  String get relationship_other => '기타 (수동으로 입력해주세요)';

  @override
  String get chatModeDaily => '일상 모드';

  @override
  String get chatModeStory => '스토리 모드';

  @override
  String get chatModeImmersive => '몰입 모드';

  @override
  String get chatModeGemini => '생활 동반자';

  @override
  String get announcement_new => '새 공지사항';

  @override
  String get mail_notification => '새로운 시간의 편지가 도착했습니다! 지금 바로 양피지 두루마리를 확인하세요!';

  @override
  String get customer_service_reply => '고객센터 답변';

  @override
  String get system_announcement => '시스템 공지';

  @override
  String get empty_announcement => '현재 공지사항이 없습니다';

  @override
  String get untitled => '제목 없음';

  @override
  String get no_content => '내용 없음';

  @override
  String get privacy_policy_title => '「연연습광」 개인정보 처리방침';

  @override
  String get privacy_policy_date => '최근 업데이트: 2026년 4月 10일';

  @override
  String get privacy_policy_body =>
      '「연연습광」 개인정보 처리방침\n최근 업데이트: 2026년 4월 10일\n\n「연연습광」(이하 \"본 서비스\")을 이용해 주셔서 감사합니다. 당사는 귀하의 개인정보를 소중히 여기며, 본 정책은 정보 수집 및 보호 방식을 설명합니다.\n\n1. 계정 정보:\n제3자 로그인: Google, Facebook, Apple 계정으로 로그인 시 Firebase UID, 이메일, 닉네임을 수집합니다.\n이메일 가입: 이메일 가입 시 계정 정보를 수집하며, 비밀번호는 Firebase 암호화 기술로 안전하게 관리됩니다.\n\n상호작용 데이터: AI 캐릭터의 연속적인 기억을 위해 AI와의 대화 기록 및 게임 내 작성 내용을 저장합니다.\n기기 정보: 기기 모델, OS 버전, 고유 식별자를 시스템 최적화를 위해 수집합니다.\n\n2. 정보의 이용 목적\nAI 경험 향상: 대화 기록을 통한 AI 답변 품질 및 성격 일관성 최적화.\n서비스 운영: 포인트 충전, 소비 기록 처리 및 본인 인증.\n보안 보호: 악성 행위 모니터링 및 서버 보호.\n\n3. 제3자 기술 협력\n본 서비스는 Google Cloud / Firebase, OpenRouter / xAI / Meta의 기술을 사용합니다. 당사는 귀하의 대화 기록을 광고주에게 판매하지 않습니다.\n\n4. 데이터 저장 및 삭제\n데이터는 클라우드 서버에 안전하게 저장됩니다. 언제든지 계정 및 모든 데이터의 영구 삭제를 요청할 수 있습니다.';

  @override
  String get terms_title => '이용약관';

  @override
  String get terms_date => '최근 업데이트: 2026년 4月 10일';

  @override
  String get terms_body =>
      '「연연습광」 서비스 이용약관\n최근 업데이트: 2026년 4월 10일\n\n본 서비스를 이용하시기 전에 다음 약관을 주의 깊게 읽어주시기 바랍니다. 이용을 시작함은 다음 내용에 동의함을 의미합니다.\n\n1. 서비스의 성격 및 면책 조항\n비인간 상호작용: 모든 답변은 생성형 AI가 생성하며, 제작자의 입장을 대변하지 않습니다.\n서사적 리스크: AI는 허구적이거나 부정확한 내용을 생성할 수 있습니다. 사용자는 현실과 허구를 구분해야 합니다.\n\n2. 가상 포인트 및 결제\n포인트 성격: 서비스 내 포인트는 가상 상품으로, 소모 시(스토리, 몰입 모드, 선물, 통화 등) 환불이 불가능합니다.\n비용 차이: 각 모드의 포인트 소모 기준은 AI 연산 비용에 따라 설정되며 조정될 수 있습니다.\n\n3. 사용자 행동 규범\n금지 사항: 극단적 폭력, 범죄 유도 또는 법률 위반 내용 생성을 금지합니다.\n시스템 간섭: 자동화 도구나 리버스 엔지니어링을 통한 데이터 탈취를 엄격히 금지합니다.\n\n4. 지식재산권\n독창적 콘텐츠: \'정안(Cheng An)\' 등 공식 캐릭터, 설정, 시나리오, 게임 로직의 권리는 \'연연습광 개발팀\'에 있습니다.\n라이선스 자원: 아이콘, 폰트 등은 원저작권자(Google, Apple 등)의 규정에 따라 적법하게 사용됩니다.\nAI 생성 콘텐츠: 일부 이미지는 AI 도구(Niji.journey 등)를 통해 생성되었으며 상업적 라이선스를 확보하였습니다.\n금지 행위: 허가 없는 상업적 이용, 재배포, 악의적인 모델 학습 이용을 금지합니다.\n\n5. 서비스 종료\n약관 위반 시 사전 통지 없이 계정이 정지 또는 영구 비활성화될 수 있습니다.';

  @override
  String get login_required => '먼저 로그인해 주세요';

  @override
  String get cloud_character_mgmt => '클라우드 캐릭터 관리';

  @override
  String get connection_error => '연결 오류';

  @override
  String get no_characters_met => '아직 만난 캐릭터가 없어요!';

  @override
  String get status_paused => '상태: 연락 중지됨';

  @override
  String get status_in_progress => '상태: 공략 중';

  @override
  String get unblock => '차단 해제';

  @override
  String get block => '차단';

  @override
  String get confirm_block_title => '차단하시겠습니까?';

  @override
  String block_warning_msg(String charName) {
    return '차단 후에는 한동안 $charName의 메시지를 받을 수 없습니다.';
  }

  @override
  String get think_again => '다시 생각하기';

  @override
  String get confirm_block_btn => '차단 확정';

  @override
  String get no_char_info => '이 캐릭터에 대한 상세 정보가 아직 없습니다...';

  @override
  String get private_mailbox => '전용 우체통';

  @override
  String get user_info_not_found => '사용자 정보를 찾을 수 없습니다';

  @override
  String get load_failed => '로드 실패, 나중에 다시 시도하세요';

  @override
  String get empty_mailbox => '현재 우체통이 비어 있습니다~';

  @override
  String get system_notification => '시스템 알림';

  @override
  String get interaction_records => '교류 기록';

  @override
  String get liked_content => '좋아요 표시한 콘텐츠';

  @override
  String get my_favorites => '내 보관함';

  @override
  String get login_to_view_records => '기록을 보려면 로그인하세요';

  @override
  String get no_likes_yet => '아직 좋아요를 누른 게시물이 없어요!';

  @override
  String get empty_favorites => '보관함이 비어 있습니다. 로비에서 찾아보세요!';

  @override
  String get theme_sakura_pink => '사쿠라 핑크';

  @override
  String get theme_ocean_blue => '오션 블루';

  @override
  String get theme_sunset_orange => '선셋 오렌지';

  @override
  String get theme_mint_forest => '민트 포레스트';

  @override
  String get theme_midnight => '심야 모드';

  @override
  String get change_atmosphere => '분위기 변경';

  @override
  String get custom_color => '커스텀 컬러';

  @override
  String get custom_color_desc => '나만의 전용 컬러 조제하기';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get confirm_delete_title => '삭제 확인';

  @override
  String get confirm_delete_memory_msg => '정말 이 기억을 지우시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get delete_btn => '삭제';

  @override
  String get memory_erased_msg => '이 기억이 완전히 지워졌습니다';

  @override
  String get delete_failed_msg => '삭제 실패';

  @override
  String get edit_memory_title => '기억 편집';

  @override
  String get modify_memory_hint => '이 기억 수정...';

  @override
  String get memory_re_recorded_msg => '기억이 다시 기록되었습니다';

  @override
  String get update_failed_msg => '업데이트 실패';

  @override
  String get update_favorite_failed_msg => '즐겨찾기 상태 업데이트 실패';

  @override
  String char_notebook_title(String charName) {
    return '$charName의 노트';
  }

  @override
  String get error_loading_memory => '기억을 불러오는 중 오류가 발생했습니다';

  @override
  String get empty_notebook_msg =>
      '노트가 비어있습니다...\n빨리 채팅을 해서 당신에 대한 모든 것을 적게 하세요!';

  @override
  String get date_format_text => 'yyyy년 M월 d일';

  @override
  String get remove_special_focus => '특별 관심 취소';

  @override
  String get mark_special_focus => '특별 관심 표시';

  @override
  String get edit_btn => '편집';

  @override
  String get load_gallery_failed => '갤러리 불러오기 실패';

  @override
  String get traditional_chinese => '번체 중국어';

  @override
  String get all => '전체';

  @override
  String get official_recommendation => '공식 추천';

  @override
  String get my_exclusive => '나만의 독점';

  @override
  String encounter_count(int count) {
    return '$count 번째 만남';
  }

  @override
  String get official => '공식';

  @override
  String get private => '개인';

  @override
  String get first_encounter => '첫 만남';

  @override
  String char_exclusive_memory(String charName) {
    return '$charName의 전용 추억';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return '이 추억을 잠금 해제하려면 호감도가 $affectionLevel 에 도달해야 합니다!';
  }

  @override
  String get affection => '호감도';

  @override
  String get unlock => '잠금 해제';

  @override
  String get change_chat_bg => '채팅 배경 변경';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return '\'$cgDesc\'를 $charName 와의 채팅 배경으로 설정하시겠습니까?';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return '배경이 \'$cgDesc\'(으)로 변경되었습니다';
  }

  @override
  String get confirm_change => '변경 확인';

  @override
  String get empty_treasure_box => '보물상자가 비어있습니다...\n채팅을 통해 숨겨진 이스터에그를 찾아보세요!';

  @override
  String get unknown_story => '알 수 없는 스토리';

  @override
  String get open_this_memory => '이 추억 열기';

  @override
  String get open_exclusive_story => '전용 스토리 열기';

  @override
  String confirm_use_egg(String eggTitle) {
    return '지금 \'$eggTitle\'을(를) 체험하시겠습니까?\n\n(이 아이템은 일회용이며, 사용 후 자동으로 스토리로 진입합니다)';
  }

  @override
  String get wait_a_bit => '조금 기다리기';

  @override
  String guiding_into_story(String eggTitle) {
    return '스토리로 안내 중...';
  }

  @override
  String get use_now => '지금 사용';

  @override
  String playback_failed_status(String statusCode) {
    return '재생 실패, 상태 코드: $statusCode';
  }

  @override
  String get playback_error => '재생 오류 발생';

  @override
  String get unknown_contact => '알 수 없는 연락처';

  @override
  String call_memory_with(String charName) {
    return '$charName 와(과)의 통화 추억';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return '호감도 $affection에서 해제';
  }

  @override
  String get no_call_record => '이 통화에는 대화 기록이 남지 않은 것 같습니다...';

  @override
  String get me => '나';

  @override
  String get playing => '재생 중...';

  @override
  String get listen => '듣기';

  @override
  String get no_exclusive_voice => '이 캐릭터는 아직 전용 음성이 설정되지 않았어요!';

  @override
  String get voice_download_success => '✅ 음성 데이터 다운로드 성공, 재생을 준비합니다...';

  @override
  String get onboarding_invitation => '— 시간의 초대장 —';

  @override
  String get onboarding_welcome => '연연습광에 오신 것을 환영합니다';

  @override
  String get onboarding_quote => '\"모든 만남은 오랜만의 재회입니다.\"';

  @override
  String get onboarding_gift_title => '첫 만남 선물: 50송이의 꽃';

  @override
  String get onboarding_gift_subtitle => '이 꽃들이 그와의 이야기를 시작하는 데 함께할 것입니다.';

  @override
  String get onboarding_start_button => '시간 여행 시작하기';

  @override
  String get onboarding_more_info => '시간의 이야기에 대해 더 알아보기';

  @override
  String get legal_agreement_prefix => '계속하면 다음 항목에 동의하는 것으로 간주됩니다:';

  @override
  String get legal_terms_button => '서비스 이용약관';

  @override
  String get legal_and => ' 및 ';

  @override
  String get legal_privacy_button => '개인정보 처리방침';

  @override
  String get call_memory_title => '통화 추억';

  @override
  String get please_login_first => '먼저 로그인해 주세요';

  @override
  String get no_call_memories => '저장된 통화 추억이 없습니다.\n최대 10개까지만 저장할 수 있습니다.';

  @override
  String call_with_name(String name) {
    return '$name와의 통화';
  }

  @override
  String call_duration(String time) {
    return '통화 시간: $time';
  }

  @override
  String get delete_call_title => '통화 기록 삭제';

  @override
  String delete_call_confirm(String name) {
    return '$name와의 통화 추억을 정말 삭제하시겠습니까?\n(삭제 후에는 복구할 수 없습니다)';
  }

  @override
  String get keep_it => '유지하기';

  @override
  String get confirm_delete => '삭제';

  @override
  String get press_mic_to_speak => '마이크를 눌러 말을 시작하세요...';

  @override
  String get call_ended => '통화가 종료되었습니다';

  @override
  String character_thinking(String name) {
    return '($name(이)가 생각 중...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name(이)가 전화를 받는 중...)';
  }

  @override
  String get call_interrupted_login => '(통화 중단) 먼저 로그인해 주세요...';

  @override
  String get silence => '(침묵)';

  @override
  String get bad_signal => '(신호가 약함...)';

  @override
  String get static_noise => '(지지직)... 잘 안 들려요...';

  @override
  String get type_message_hint => '메시지 입력...';

  @override
  String get draft_saved_success => '초안이 비밀 작업실에 안전하게 저장되었습니다!';

  @override
  String get draft_save_failed => '저장 실패, 나중에 다시 시도해 주세요';

  @override
  String get draft_save_title => '초안을 저장하시겠습니까?';

  @override
  String get draft_save_content => '아직 게시하지 않은 작업물이 있습니다. 비밀 작업실에 먼저 저장할까요?';

  @override
  String get not_save => '저장 안 함';

  @override
  String get save_draft => '초안 저장';

  @override
  String confirm_delete_char_content(String name) {
    return '정말로 캐릭터 \"$name\"을(를) 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다!';
  }

  @override
  String get char_deleted => '캐릭터가 삭제되었습니다';

  @override
  String get ok_button => '확인!';

  @override
  String get cannot_save_title => '저장 불가';

  @override
  String get cannot_save_content => '캐릭터 이름을 입력하고 아바타를 최소 한 장 업로드해 주세요!';

  @override
  String get word_count_exceeded => '글자 수 초과';

  @override
  String word_count_error_detail(String field, int limit) {
    return '\"$field\" 필드가 $limit자를 초과했습니다. 내용을 줄인 후 다시 저장해 주세요.';
  }

  @override
  String get content_missing => '내용 누락';

  @override
  String get content_missing_personality =>
      '\"상세 성격\"을 입력해 주세요! 최소 10자 이상 작성해야 합니다.';

  @override
  String get content_missing_bg =>
      '\"캐릭터 소개\"가 너무 짧습니다! 배경 설명을 위해 최소 20자 이상 작성해 주세요.';

  @override
  String get content_missing_tone =>
      '\"말투와 습관\"을 설정해 주세요. 설정하지 않으면 캐릭터 붕괴(OOC)가 발생하기 쉽습니다!';

  @override
  String get user_not_found => '오류: 사용자를 찾을 수 없음';

  @override
  String char_saved_success(String name, String action) {
    return '캐릭터 \"$name\"이(가) $action되었습니다!';
  }

  @override
  String save_error_detail(String error) {
    return '저장 실패: $error';
  }

  @override
  String get easter_egg_add_title => '숨겨진 이스터 에그 추가';

  @override
  String get easter_egg_edit_title => '이스터 에그 편집';

  @override
  String get keyword_label => '트리거 키워드 (필수)';

  @override
  String get keyword_hint => '예: 놀이공원 가기, 딸기 케이크';

  @override
  String get egg_title_label => '이스터 에그 제목 (플레이어에게 표시)';

  @override
  String get egg_title_hint => '예: 주말 데이트';

  @override
  String get egg_teaser_label => '짧은 예고 (플레이어에게 표시)';

  @override
  String get egg_teaser_hint => '앞으로 일어날 일의 도입부를 설명해 주세요...';

  @override
  String get egg_scene_label => '강제 장면 전환 (선택 사항)';

  @override
  String get egg_scene_hint => '예: 놀이공원, 귀신의 집';

  @override
  String get egg_prompt_label => '시나리오 명령';

  @override
  String get egg_prompt_hint =>
      '이 스토리를 어떻게 연출할지 입력하세요.\n(시스템: 놀이공원으로 장면 전환, 캐릭터가 (플레이어 이름)을(를) 보며 웃는다...)';

  @override
  String get confirm_button => '확인';

  @override
  String get keyword_empty_error => '키워드는 비워둘 수 없습니다';

  @override
  String get voice_custom_title => '전용 보이스 맞춤 제작';

  @override
  String get voice_custom_hint => '예: 저음의 냉철한 본부장, 다정한 연하남...';

  @override
  String get voice_generate_start => '생성 시작';

  @override
  String get voice_bind_first => '먼저 전용 보이스를 선택하고 \"연동\"해 주세요!';

  @override
  String get voice_test_failed =>
      '미리듣기 실패: 세부 조정을 하기 전에 \"너로 정했다!\"를 클릭하여 보이스를 공식 연동해 주세요!';

  @override
  String voice_name_default(String name) {
    return '$name의 전용 보이스';
  }

  @override
  String get voice_description_default =>
      '이것은 \'연연습광\'의 전용 캐릭터를 위해 만들어진 유일무이한 보이스로, 플레이어가 직접 선택하여 생성했습니다.';

  @override
  String get voice_bind_failed => '보이스 연동 실패, API 잔액 또는 네트워크 상태를 확인해 주세요';

  @override
  String voice_bind_success(String name) {
    return '\"$name\"의 소울 보이스가 공식 연동되었습니다!';
  }

  @override
  String get voice_bind_success_draft =>
      '보이스 연동 성공! 이제 슬라이더를 움직여 감정을 테스트해 보세요!';

  @override
  String sync_failed(String error) {
    return '동기화 실패, 네트워크를 확인해 주세요: $error';
  }

  @override
  String edit_character_title(String name) {
    return '$name 편집';
  }

  @override
  String get test_mode_tooltip => '전체 기능 테스트';

  @override
  String get test_mode_error =>
      '⚠️ 캐릭터 파일을 찾을 수 없습니다! 하단의 \'저장/게시\'를 먼저 클릭한 후 테스트해 주세요.';

  @override
  String get test_mode_notice =>
      '💡 테스트 모드는 각 모드의 원래 가격에 따라 포인트가 차감되며, 공식 추억에는 기록되지 않습니다!';

  @override
  String get delete_character_tooltip => '캐릭터 삭제';

  @override
  String get tab_basic_story => '기본 및 스토리';

  @override
  String get tab_voice => '전용 보이스';

  @override
  String get tab_relationship => '인간 관계';

  @override
  String get save_changes_button => '변경 사항 저장';

  @override
  String get section_basic_info => '기초 정보';

  @override
  String get hint_occupation => '다중 신분 지원, 슬래시나 쉼표로 구분해 주세요 (예: 학생/해커)';

  @override
  String get hint_appearance => '예: 은색 긴 머리, 호박색 눈동자, 항상 가운을 입고 있음...';

  @override
  String get section_story_identity => '🎭 스토리와 당신의 신분';

  @override
  String get story_identity_desc =>
      '스토리 시작과 이 세이브 데이터에서의 \'당신\'에 대한 특수 설정을 정의합니다';

  @override
  String get advanced_writing_tips_title => '💡 고급 작성 팁:\n';

  @override
  String get advanced_writing_tips_1 => '스토리나 대사에 ';

  @override
  String get advanced_writing_tips_2 => '(플레이어 이름)';

  @override
  String get advanced_writing_tips_3 =>
      '을(를) 입력하면, 플레이 시 자동으로 플레이어의 실제 닉네임으로 바뀝니다!\n';

  @override
  String get advanced_writing_tips_4 => '예시: \"';

  @override
  String get advanced_writing_tips_5 => '(플레이어 이름)';

  @override
  String get advanced_writing_tips_6 => ', 왜 이렇게 늦게 왔어?\"';

  @override
  String get player_identity_label => '플레이어 기본 신분 (Player Identity) - 💡 선택 사항';

  @override
  String get player_identity_hint =>
      '【선택 사항】비워두면 AI가 당신의 \'프로필\'을 읽고 소통합니다.\n입력하면 특정 신분을 강제로 연기하게 됩니다 (예: 그의 냉혈한 시스템, 혹은 배신당한 아내).';

  @override
  String get background_label => '캐릭터 배경 및 세계관';

  @override
  String get background_hint =>
      '그의 과거와 세계관(예: 현대 도시, ABO, 아포칼립스)을 설명해 주세요. 예: 좀비가 창궐하는 세상에서 당신을 지키는 특수부대원...';

  @override
  String get story_summary_label => '한 줄 스토리 소개';

  @override
  String get story_initial_label => '첫 만남 스토리';

  @override
  String get story_initial_hint =>
      '예: 당신이 문을 열자 창가에 앉아 있는 그가 보입니다. 그는 고개를 돌려 말합니다. \"(플레이어 이름), 이쪽으로 와.\"';

  @override
  String get first_line_label => '캐릭터의 첫 마디';

  @override
  String get first_line_hint => '예: (플레이어 이름), 드디어 왔네.';

  @override
  String get section_personality_evo => '🌟 성격과 호감도 변화';

  @override
  String get detailed_personality_label => '상세 성격';

  @override
  String get detailed_personality_hint =>
      '그의 핵심 성격을 묘사해 주세요. 예: 츤데레, 겉은 차갑지만 속은 따뜻함. 타인에게는 냉담하지만 플레이어에게만 미소 지음.';

  @override
  String get affection_evo_desc => 'AI는 다음 설정에 따라 호감도를 올릴 타이밍을 판단합니다:';

  @override
  String get stage_1_label => '단계 1: 낯섦/경계 (Lv1)';

  @override
  String get stage_1_hint =>
      '처음 만났을 때의 반응. 호감도 상승 조건(예: 예의 바른 태도, 사생활을 캐묻지 않음).';

  @override
  String get stage_2_label => '단계 2: 친숙/친구 (Lv2)';

  @override
  String get stage_2_hint => '친해진 후의 변화. 호감도 상승 조건(예: 간식을 나눠 먹음, 고양이 화제로 대화).';

  @override
  String get stage_3_label => '단계 3: 친밀/연인 (Lv3)';

  @override
  String get stage_3_hint => '완전히 빠져든 후의 반응. 질투를 할까요? 아니면 조용히 삐질까요?';

  @override
  String get social_interaction_label => '사회 및 환경 상호작용';

  @override
  String get social_interaction_hint =>
      '예: 행인을 어떻게 대하는지? 싫어하는 것(지뢰)을 마주했을 때 어떻게 반응하는지?';

  @override
  String get section_habits => '🗣️ 취향과 습관';

  @override
  String get tone_hint_detail =>
      '필수 입력. 예: 짧게 말함, 되묻는 것을 좋아함. 입버릇은 \"바보\". 번역투 사용 금지.';

  @override
  String get dialogue_example_hint =>
      '플레이어: 너무 힘들어.\n캐릭터: (머리를 쓰다듬으며) 착하지, 어서 가서 쉬어.';

  @override
  String get section_easter_eggs => '🎁 숨겨진 이스터 에그와 특수 스토리';

  @override
  String get no_easter_eggs => '설정된 이스터 에그가 없습니다. 아래 버튼을 눌러 추가하세요';

  @override
  String get no_scene_change => '장면 전환 없음';

  @override
  String get add_easter_egg_button => '숨겨진 이스터 에그 추가';

  @override
  String get other_extra_info => '기타 보충 정보';

  @override
  String get visibility_label => '캐릭터 공개 범위';

  @override
  String get visibility_public => '공개';

  @override
  String get visibility_private => '비공개';

  @override
  String get section_voice_gen => '🎙️ 그의 전용 보이스 생성';

  @override
  String get voice_gen_desc =>
      '제시어를 입력하여 세상에 단 하나뿐인 전용 보이스를 만들어 보세요!\n(💡 팁: 생성 후 마음에 들지 않으면 언제든 다시 제작할 수 있습니다!)';

  @override
  String get voice_generating_status => '보이스를 조합하는 중...';

  @override
  String get voice_select_prompt => '✨ 세 가지 보이스를 준비했습니다. 선택해 주세요:';

  @override
  String voice_sample_name(int index) {
    return '보이스 샘플 $index';
  }

  @override
  String get voice_sample_desc => '카드를 클릭하여 선택, 오른쪽을 클릭하여 미리듣기';

  @override
  String get voice_preparing => '보이스를 준비 중입니다...';

  @override
  String get voice_retry => '취소하고 다시 시도';

  @override
  String get voice_confirm_selection => '너로 정했다!';

  @override
  String get voice_bind_success_banner => '전용 보이스가 성공적으로 연동되었습니다!';

  @override
  String get voice_remake => '보이스 다시 만들기';

  @override
  String get voice_btn_generating => '생성 중입니다. 잠시만 기다려 주세요...';

  @override
  String get voice_btn_generate => '제시어를 입력하여 전용 보이스 생성';

  @override
  String get voice_advanced_tuning => '🎛️ 고급: 말하는 감정 미세 조정';

  @override
  String get voice_stability_low => '와일드/숨소리 🐺';

  @override
  String voice_stability_value(String value) {
    return '이성도: $value';
  }

  @override
  String get voice_stability_high => '안정/침착 🤖';

  @override
  String get voice_style_low => '냉담/억제 🧊';

  @override
  String voice_style_value(String value) {
    return '드라마틱 표현: $value';
  }

  @override
  String get voice_style_high => '과장/다정 🔥';

  @override
  String get voice_test_btn_testing => '감정 적용 중...';

  @override
  String get voice_test_btn => '현재 감정 미리듣기';

  @override
  String get section_social_circle => '👥 그의 인맥';

  @override
  String get social_circle_desc =>
      '다른 캐릭터에 대한 그의 생각을 설정합니다. 플레이어가 대화 중에 상대를 언급하면 여기의 설정에 따라 반응합니다 (예: 질투, 분노).';

  @override
  String get social_no_drama => '아직 다른 남신들과의 갈등이 없습니다...';

  @override
  String social_target(String name) {
    return '대상: $name';
  }

  @override
  String social_attitude(String attitude) {
    return '생각: $attitude';
  }

  @override
  String social_edit_title(String name) {
    return '$name에 대한 생각 편집 💬';
  }

  @override
  String get social_attitude_label => '그의 생각 / 태도';

  @override
  String get social_attitude_hint => '예: 상대가 시끄럽다고 생각하지만 사실 많이 의지함...';

  @override
  String get social_save_changes => '변경 사항 저장';

  @override
  String get social_add_title => '캐릭터 관계 추가 🤝';

  @override
  String get social_select_target => '대상 선택';

  @override
  String get social_thoughts_label => '이 사람에 대한 그의 생각...';

  @override
  String get social_thoughts_hint => '예: 저 피아니스트는 너무 시끄러워...';

  @override
  String get social_add_confirm => '추가 확인';

  @override
  String get gallery_load_failed =>
      '이미지 로드 실패 🥲\n네트워크를 확인해 주세요. 웹 버전이라면 콘솔을 확인해 보세요.';

  @override
  String gallery_affection_req(int level) {
    return '호감도 $level';
  }

  @override
  String get gallery_upload_limit => '이미지는 최대 10장까지 업로드 가능합니다';

  @override
  String get gallery_photo_setup => '사진 해제 조건 설정';

  @override
  String get gallery_photo_desc_label => '이 사진은 무엇인가요?';

  @override
  String get gallery_photo_desc_hint => '예: 잠옷 차림, 데이트 사진';

  @override
  String get gallery_photo_req_label => '해제에 필요한 호감도는 얼마인가요?';

  @override
  String get gallery_photo_req_hint => '숫자를 입력하세요 (0은 무료)';

  @override
  String get gallery_cancel_upload => '업로드 취소';

  @override
  String get gallery_confirm_add => '추가 확인';

  @override
  String get default_photo_desc => '전용 사진';

  @override
  String get draft_photo_desc => '초안 사진';

  @override
  String get loading_text => '로딩 중...';

  @override
  String get default_unnamed_character => '이름 없는 캐릭터';

  @override
  String elevenlabs_error(String code) {
    return 'ElevenLabs 오류: $code';
  }

  @override
  String get voice_sample_script =>
      '(큼큼) 안녕하세요. 이건 저만의 전용 목소리 테스트예요. 앞으로의 시간 동안 저는 여기서 당신과 함께할 거예요. 기쁠 때나 슬플 때나 언제든 저에게 들려주세요. 지금의 말하기 속도와 음색은 어떠신가요? 괜찮으시다면 이 목소리를 당신과 대화할 저의 전용 목소리로 정할게요. 우리의 앞날이 매일매일 기대돼요.';

  @override
  String get voice_test_script =>
      '매번 널 바라볼 때마다 내 마음속으로 무슨 생각을 하는지 정말 알기나 해? …… 정말 너란 사람은 못 말리겠다니까.';

  @override
  String get field_background => '캐릭터 배경';

  @override
  String get field_tone => '말투와 습관';

  @override
  String get field_initial_story => '초기 스토리';

  @override
  String get update_action => '업데이트';

  @override
  String get default_new_player => '신규 플레이어';

  @override
  String get translating_status => '번역 중...';

  @override
  String get translate_profile_btn => '프로필 내용 번역';

  @override
  String translate_failed(String error) {
    return '번역 실패: $error';
  }

  @override
  String get like_own_char_warning => '자신이 만든 캐릭터에는 \'좋아요\'를 누를 수 없어요! 🤭';

  @override
  String get like_success_msg => '좋아요를 보냈습니다! 제작자가 매우 기뻐할 거예요 💖';

  @override
  String get unlike_success_msg => '좋아요를 취소했습니다 💔';

  @override
  String get like_label => '좋아요';

  @override
  String get dislike_label => '싫어요';

  @override
  String get block_char => '이 캐릭터 차단';

  @override
  String get char_blocked_msg => '캐릭터를 차단했습니다.';

  @override
  String get dislike_dialog_title => '이 캐릭터가 마음에 안 드시나요?';

  @override
  String get dislike_dialog_subtitle => '이유를 비밀스럽게 알려주세요. 운영진에서 검토하겠습니다:';

  @override
  String get dislike_hint => '설정이 지루함, 이미지가 부적절함...';

  @override
  String get dislike_thanks => '피드백 감사합니다! 운영진에게 비밀 메시지가 전달되었습니다.';

  @override
  String get dislike_submit => '비밀리에 전송';

  @override
  String get report_title => '📢 댓글 신고';

  @override
  String get report_subtitle => '신고 이유를 선택해 주세요:\n신고 후 신속하게 내용을 검토하겠습니다.';

  @override
  String get report_opt_1 => '음란물 또는 잔인한 폭력 내용';

  @override
  String get report_opt_2 => '캐릭터 비하, 모욕 또는 공격';

  @override
  String get report_opt_3 => '혐오 발언 또는 인신공격';

  @override
  String get report_opt_4 => '스팸 메시지 또는 광고 사기';

  @override
  String get report_opt_5 => '기타 부적절한 내용';

  @override
  String get report_confirm => '신고 확정';

  @override
  String get report_success => '신고 성공, 알림을 수신했습니다! 신속하게 검토하겠습니다 🛡️';

  @override
  String get report_failed => '신고 실패, 네트워크 연결을 확인해 주세요.';

  @override
  String get lore_delete_title => '⚠️ 경고: 기억 삭제';

  @override
  String get lore_delete_content => '이 기억은 삭제하면 완전히 사라집니다. 정말로 지우시겠습니까?';

  @override
  String get lore_delete_cancel => '잘못 눌렀어요';

  @override
  String get lore_delete_confirm => '삭제 확정';

  @override
  String get lore_delete_success => '🗑️ 기억의 파편이 완전히 삭제되었습니다.';

  @override
  String get lore_add_title => '새 기억 쓰기 🖋️';

  @override
  String get lore_edit_title => '기억의 파편 편집 🖋️';

  @override
  String get lore_title_label => '기억 제목';

  @override
  String get lore_title_hint => '예: 처음 만난 어느 비 오는 날';

  @override
  String get lore_teaser_label => '요약 / 서문';

  @override
  String get lore_teaser_hint => '카드에 표시되는 짧은 설명...';

  @override
  String get lore_content_label => '전체 기억 내용';

  @override
  String get lore_content_hint => '상세한 이야기나 설정을 적어주세요...';

  @override
  String get lore_lock_label => '🔒 이 기억 봉인하기';

  @override
  String get lore_lock_desc => '체크하면 제작자 본인만 볼 수 있으며, 플레이어는 볼 수 없습니다';

  @override
  String get lore_empty_error => '제목과 내용은 비워둘 수 없어요!';

  @override
  String get lore_add_success => '✨ 새 기억이 성공적으로 봉인되었습니다!';

  @override
  String get lore_publish => '기억 게시';

  @override
  String get lore_save_edit => '수정사항 저장';

  @override
  String lore_write_first(Object pronoun) {
    return '$pronoun의 첫 번째 과거를 기록해 보세요!';
  }

  @override
  String lore_waiting(Object pronoun) {
    return '$pronoun와의 이야기를 기다리는 중...';
  }

  @override
  String get lore_sealed_msg => '🔒 이 기억은 봉인되어 현재 볼 수 없습니다.';

  @override
  String get lore_not_open_msg => '이 기억은 아직 공개되지 않았습니다...';

  @override
  String get lore_unnamed => '이름 없는 파편';

  @override
  String get lore_add_btn_limit => '새로운 기억의 파편 쓰기 (최대 10개)';

  @override
  String get lore_collapse => '편지 접기';

  @override
  String get echo_delete_title => '🗑️ 댓글 삭제';

  @override
  String get echo_delete_content =>
      '이 시공의 메아리를 삭제하시겠습니까?\n삭제 후에는 다시 복구할 수 없습니다!';

  @override
  String get echo_keep => '유지';

  @override
  String get echo_clear_success => '시공의 메아리가 삭제되었습니다 🧹';

  @override
  String get echo_energy_full_title => '⚠️ 우주 에너지가 한계에 도달함';

  @override
  String get echo_energy_full_content =>
      '시공 에너지가 한계(최대 3개)에 도달했습니다. 새로운 우주 기록을 남기려면 기존의 시공 기록을 삭제해 주세요!';

  @override
  String get echo_write_title => '시공의 메아리 남기기 🌌';

  @override
  String get echo_write_subtitle => '이곳에서의 경험이나 설레는 문구를 남겨보세요!';

  @override
  String get echo_hint => '「세상이 끝난대도, 너의 숨결을 지키는 게 내 우선순위야...」';

  @override
  String get echo_theme_label => '노트 테두리 선택:';

  @override
  String get theme_butterfly => '나비';

  @override
  String get theme_sprout => '새싹';

  @override
  String get theme_star => '별밤';

  @override
  String get theme_planet => '행성';

  @override
  String get echo_publish_btn => '시공 기록 게시';

  @override
  String get echo_wall_title => '시공의 메아리 벽';

  @override
  String get echo_leave_memory => '경험 남기기';

  @override
  String get echo_empty_msg => '아직 기록을 남긴 시공 여행자가 없습니다...\n당신이 첫 번째가 되어보시겠어요?';

  @override
  String get creator_label => '제작자';

  @override
  String get follow_btn => '팔로우';

  @override
  String get followed_btn => '팔로우 중';

  @override
  String get follow_own_warning => '제작자 본인은 팔로우할 수 없어요! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName 님이 $creatorName 님을 팔로우했습니다!';
  }

  @override
  String get mailbox_follow_title => '새로운 수호자 획득 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName 님이 방금 당신을 팔로우했습니다!';
  }

  @override
  String get tab_private_profile => '비밀 프로필';

  @override
  String get tab_memory_fragments => '기억의 파편';

  @override
  String get tab_time_echoes => '시공의 메아';

  @override
  String get chat_free_btn => '잡담(무료)';

  @override
  String get start_story_btn => '스토리 시작';

  @override
  String get default_chat_initial => '나한테 볼일 있어?';

  @override
  String get gallery_title => '전용 통화 배경';

  @override
  String gallery_current_affection(String value) {
    return '현재 호감도: $value 💕';
  }

  @override
  String get gallery_empty => '앨범에 아직 사진이 없어요';

  @override
  String gallery_unlocked_msg(String desc) {
    return '배경을 「$desc」(으)로 설정했습니다!';
  }

  @override
  String gallery_lock_msg(String value) {
    return '호감도 $value를 달성하면 해제됩니다! 🍃';
  }

  @override
  String get gallery_reset_bg => '기본 통화 배경으로 복원되었습니다';

  @override
  String get background_story_title => '배경 스토리';

  @override
  String get background_story_empty => '이 캐릭터는 신비로워요. 아직 배경 스토리가 없습니다...';

  @override
  String followed_creator_msg(String creatorName) {
    return '$creatorName 님을 팔로우했습니다 🦋';
  }

  @override
  String get mailbox_title => '전용 우체통 💌';

  @override
  String get mailbox_empty => '우체통이 비어 있습니다. 게시물을 올려서 그의 관심을 끌어보세요!';

  @override
  String get new_notification => '새 알림';

  @override
  String get default_he => '그';

  @override
  String affection_upgrade_title(String charName) {
    return '$charName 님의 당신에 대한 호감도가 상승했습니다! 💖';
  }

  @override
  String get flower_reward => '🌸 꽃 5포인트 획득';

  @override
  String get affection_quote_lv5 =>
      '「생각지도 못했어... 네가 나에게 이렇게 중요한 사람이 될 줄은. 네가 없는 세상은 상상조차 할 수 없을 만큼 말이야.」';

  @override
  String get affection_quote_lv4 =>
      '「내 인생에서 가장 운이 좋았던 건, 아마 그날 뒤를 돌아봤을 때 네가 있었던 일일 거야.」';

  @override
  String get affection_quote_lv3 =>
      '「요즘... 멍하니 있는 시간이 많아졌어. 머릿속이 온통 너로 가득 차서 말이야.」';

  @override
  String get affection_quote_lv2 => '「네가 제안한 거니까, 시간을 좀 내보는 것도... 안 될 건 없지.」';

  @override
  String get affection_quote_lv1 =>
      '「요즘 너를 자주 보네. 뭐랄까... 이런 만남의 빈도가 나쁘지는 않은 것 같아.」';

  @override
  String get affection_quote_lv0 => '「너도 여기 있었구나. 이것도 일종의 묘한 인연일까?」';

  @override
  String get lore_edit_success => '✨ 기억의 파편이 성공적으로 업데이트되었습니다!';

  @override
  String get delete_failed_network => '삭제 실패, 네트워크 또는 권한을 확인해 주세요.';

  @override
  String get ai_chat_language => '한국어';

  @override
  String get ai_chat_language_code => 'ko-KR';

  @override
  String get chat_home_title => '메시지';

  @override
  String get call_memory_tooltip => '통화 추억';

  @override
  String get login_to_view_chat => '로그인하여 채팅 기록을 확인하세요';

  @override
  String load_chat_failed(String error) {
    return '채팅 목록 로드 실패: $error';
  }

  @override
  String get chat_list_empty => '채팅방이 비어 있습니다...';

  @override
  String get go_to_encounter => '\'해후\'에서 대화할 사람을 찾아보세요!';

  @override
  String confirm_delete_chat(String charName) {
    return '$charName 님과의 대화를 삭제하시겠습니까?';
  }

  @override
  String affection_score_short(String score) {
    return '호감도 $score';
  }

  @override
  String get character_not_found => '캐릭터 정보를 불러올 수 없습니다. 삭제되었을 가능성이 있습니다.';

  @override
  String get preparing_chat_room => '전용 채팅방을 준비하고 있습니다...';

  @override
  String get rename_chat_title => '이 기억의 이름 짓기';

  @override
  String get rename_chat_hint => '예: (정율)을 (이혼 카운트다운)으로 변경';

  @override
  String get save_tag_btn => '태그 저장';

  @override
  String get room_name_updated => '방 이름이 업데이트되었습니다!';

  @override
  String update_failed(String error) {
    return '업데이트 실패: $error';
  }

  @override
  String get chat_mode_daily => '일상';

  @override
  String get chat_mode_story => '스토리';

  @override
  String get chat_mode_immersive => '몰입';

  @override
  String get chat_mode_gemini => '잡담';

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
      '캐릭터 정보를 찾을 수 없습니다. 돌아가서 다시 시도하거나 네트워크를 확인해 주세요.';

  @override
  String get chat_jump_success => '해당 기억으로 이동했습니다 🍃';

  @override
  String get chat_create_room_failed => '연결이 불안정하여 채팅방 생성에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get chat_secret_file_title => '🔒 기밀 파일';

  @override
  String get chat_secret_file_desc =>
      '이 캐릭터의 영혼 파일은 보관되었거나 개인 권한으로 전환되어 상세 정보를 일시적으로 확인할 수 없습니다.';

  @override
  String get chat_understood => '확인';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ 새로운 기억 획득: $title';
  }

  @override
  String get chat_egg_saved => '전용 가방에 자동 수록되었습니다';

  @override
  String get chat_points_not_enough_title => '꽃 부족';

  @override
  String get chat_points_not_enough_desc => '꽃이 부족합니다! 상점에서 충전해 주세요.';

  @override
  String chat_call_confirm_title(String name) {
    return '$name 님에게 전화를 걸까요?';
  }

  @override
  String get chat_call_rule_1 => '통화 시마다 꽃 20송이가 차감됩니다';

  @override
  String get chat_call_rule_2 => '통화 시간은 1분이며, 말하기 어려운 상황이라면 텍스트로 전달 가능합니다';

  @override
  String get chat_call_rule_3 => '그의 목소리를 더 선명하게 듣기 위해 이어폰 착용을 권장합니다 ✨';

  @override
  String get chat_call_btn_cancel => '다음에';

  @override
  String get chat_call_pref_title => '통화 환경 설정';

  @override
  String get chat_call_lang_select => '통화 언어 선택';

  @override
  String get chat_call_save_memory => '이번 통화 기억 저장';

  @override
  String get chat_call_save_memory_desc => '통화 종료 후 다시 듣기가 가능합니다';

  @override
  String get chat_call_btn_start => '통화 시작';

  @override
  String chat_points_shortage(String points) {
    return '꽃 포인트가 부족해요! 현재 $points송이 보유 중';
  }

  @override
  String get chat_room_not_ready => '채팅방이 준비되지 않았습니다. 다시 입장해 주세요.';

  @override
  String get chat_stop_generating_msg => '답변이 중단되었습니다. 포인트는 차감되지 않았습니다 🍃';

  @override
  String get chat_heartbeat_up => '그의 심장이 빨라집니다...';

  @override
  String get chat_heartbeat_down => '그의 눈빛이 차가워집니다...';

  @override
  String get chat_msg_copy => '내용 복사';

  @override
  String get chat_msg_copied => '클립보드에 복사되었습니다!';

  @override
  String get chat_msg_report => '이 대화 신고';

  @override
  String get chat_msg_suggest => '제안하기';

  @override
  String get chat_report_title => '이 대화 신고하기';

  @override
  String get chat_report_lang => '외국어 노출';

  @override
  String get chat_report_inapp => '부적절한 답변';

  @override
  String get chat_report_context => '문맥이 이어지지 않음';

  @override
  String get chat_report_other => '기타 사유';

  @override
  String get chat_report_hint => '겪으신 문제를 설명해 주세요...';

  @override
  String get chat_report_submit => '보내기';

  @override
  String get chat_report_success => '✅ 신고가 접수되었습니다. 신속히 조정하겠습니다';

  @override
  String get chat_suggest_title => '의견 보내기';

  @override
  String get chat_suggest_hint => '소중한 의견을 남겨주세요...';

  @override
  String get chat_suggest_success => '💖 제안 감사합니다. 신속히 처리하겠습니다';

  @override
  String get chat_del_warn => '메시지는 삭제 후 복구할 수 없습니다.';

  @override
  String get chat_reset_title => '기억 리셋';

  @override
  String get chat_reset_desc =>
      '리셋 단계를 선택해 주세요:\n\n1. 【대화만】: 대화 기록만 삭제하고 호감도는 유지합니다.\n2. 【완전 리셋】: 모든 것이 초기화되어 처음 만난 것처럼 돌아갑니다.';

  @override
  String get chat_reset_only_chat => '대화 기록만';

  @override
  String get chat_reset_full => '완전 리셋';

  @override
  String get chat_reset_full_msg => '모든 것이 처음으로 돌아갔습니다. 그는 이제 당신을 기억하지 못합니다...';

  @override
  String get chat_reset_chat_msg => '대화 기록이 비워졌지만, 당신을 향한 그의 애정은 그대로입니다.';

  @override
  String get chat_edit_ai_hint => '그의 답변 편집...';

  @override
  String get chat_edit_user_hint => '새로운 내용을 입력하세요...';

  @override
  String chat_no_voice_msg(String name) {
    return '현재 $name 님의 목소리가 아직 준비되지 않았습니다...';
  }

  @override
  String get chat_poke_btn => '찌르기';

  @override
  String get chat_poke_success => '✨ 제작자를 콕콕 찔러두었습니다! 그의 목소리가 업데이트되길 기대해 주세요~';

  @override
  String chat_gift_points_needed(String cost) {
    return '꽃 포인트가 부족해요! $cost송이가 필요합니다 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ 운명의 상대 ✨';

  @override
  String get chat_levelup_normal => '관계 진전! 💖';

  @override
  String get chat_levelup_btn_soulmate => '영혼에 새기기';

  @override
  String get chat_levelup_btn_normal => '두근거리며 수락';

  @override
  String get chat_loc_title => '📍 가상 위치 전송';

  @override
  String get chat_loc_custom_btn => '사용자 지정 위치 전송';

  @override
  String get chat_loc_hint => '기타 장소 입력... (예: 네 마음속)';

  @override
  String get chat_loc_1 => '네 집 앞이야';

  @override
  String get chat_loc_2 => '학교에 있어';

  @override
  String get chat_loc_3 => '방금 지나친 카페야';

  @override
  String get chat_loc_4 => '편의점에 있어';

  @override
  String get chat_interact_title => '✨ 그에게 무엇을 하고 싶나요?';

  @override
  String get chat_interact_action => '찌르기와 작은 스킨십';

  @override
  String get chat_interact_gift => '작은 선물 보내기 (꽃 소모 🌸)';

  @override
  String get chat_action_poke => '볼 콕 찌르기';

  @override
  String get chat_action_hug => '안아달라고 하기';

  @override
  String get chat_action_hand => '몰래 손잡기';

  @override
  String get chat_dice_btn => '주사위 굴리기';

  @override
  String get chat_loading_failed => '기억 로드 실패. 다시 시도해 주세요.';

  @override
  String get chat_test_mode_msg =>
      '테스트 모드 활성화 중. 자유롭게 대화해 보세요! (대화는 저장되지 않습니다)';

  @override
  String get chat_empty_msg => '그와 함께 설레는 여정을 시작해 보세요!';

  @override
  String get chat_ai_typing => '상대방이 답변 중입니다...';

  @override
  String get chat_input_hint_default => '그에게 하고 싶은 말...';

  @override
  String get chat_typing_indicator => '입력 중...';

  @override
  String get chat_menu_search => '대화 검색';

  @override
  String get chat_menu_gallery => '전용 추억과 배경';

  @override
  String get chat_menu_aboutme => '나와 관련된 정보';

  @override
  String get chat_menu_memo => '그를 위한 메모';

  @override
  String get chat_menu_period => '생리 주기 추적';

  @override
  String get chat_menu_reset => '기억 리셋';

  @override
  String get chat_search_hint => '어떤 달콤한 대화를 다시 보고 싶나요?';

  @override
  String get chat_search_empty => '해당 기억을 찾을 수 없어요 🥺';

  @override
  String get chat_search_you => '당신의 말';

  @override
  String get chat_search_him => '그의 말';

  @override
  String get chat_tool_backpack => '가방';

  @override
  String get chat_tool_story => '스토리 요약';

  @override
  String get chat_tool_photo => '사진';

  @override
  String get chat_tool_record => '녹음';

  @override
  String get chat_tool_profile => '습광 프로필';

  @override
  String get chat_tool_interact => '상호작용';

  @override
  String get chat_record_recording => '녹음 중...';

  @override
  String get chat_record_start => '마이크를 눌러 녹음 시작';

  @override
  String get chat_record_done => '녹음 완료';

  @override
  String get chat_mode_daily_desc => '친구처럼 즐겁고 가벼운 일상 대화!';

  @override
  String get chat_mode_story_desc => '소설처럼 진행되는 스토리.';

  @override
  String get chat_mode_immersive_desc => '극대화된 감각 체험, 자유롭고 깊은 상호작용.';

  @override
  String get chat_switch_mode_title => '채팅 모드 전환';

  @override
  String get chat_voice_call => '음성 통화';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【시스템 이벤트】$playerName 님이 【$giftName】을(를) 선물했습니다.';
  }

  @override
  String get rel_title_soulmate => '영혼의 동반자/깊은 사랑';

  @override
  String get rel_title_lover => '열애기/전용 남자친구';

  @override
  String get rel_title_ambiguous => '썸/서로 탐색 중';

  @override
  String get rel_title_friend => '일반 친구/호감의 싹';

  @override
  String get rel_title_acquaintance => '안면 있는 사이/약간 낯익음';

  @override
  String get rel_title_stranger => '낯선 사람/초면';

  @override
  String get rel_title_tense => '긴장 관계/짜증남';

  @override
  String get rel_title_avoiding => '남남인 사이/의도적 회피';

  @override
  String get rel_title_hostile => '극도로 혐오함/싸늘한 적의';

  @override
  String get rel_title_nemesis => '불구대천/영원히 만나지 않음';

  @override
  String get rel_msg_soulmate =>
      '「생각지도 못했어... 네가 나에게 이렇게 중요한 사람이 될 줄은. 네가 없는 세상은 상상조차 할 수 없을 만큼 말이야.」';

  @override
  String get rel_msg_lover =>
      '「내 인생에서 가장 운이 좋았던 건, 아마 그날 뒤를 돌아봤을 때 네가 있었던 일일 거야.」';

  @override
  String get rel_msg_ambiguous =>
      '「요즘... 멍하니 있는 시간이 많아졌어. 머릿속이 온통 너로 가득 차서 말이야.」';

  @override
  String get rel_msg_friend => '「네가 제안한 거니까, 시간을 좀 내보는 것도... 안 될 건 없지.」';

  @override
  String get rel_msg_acquaintance =>
      '「요즘 너를 자주 보네. 뭐랄까... 이런 만남의 빈도가 나쁘지는 않은 것 같아.」';

  @override
  String get rel_msg_stranger => '「너도 여기 있었구나. 이것도 일종의 묘한 인연일까?」';

  @override
  String chat_edit_char_count(String count) {
    return '$count 자';
  }

  @override
  String get chat_mysterious_player => '신비로운 플레이어';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return '플레이어 $playerName 님이 $characterName 님의 목소리를 기다리고 있습니다. 어서 생성해 보세요!';
  }

  @override
  String get gift_heart => '하트';

  @override
  String get gift_flower => '꽃';

  @override
  String get gift_sun => '태양';

  @override
  String get gift_confetti => '꽃가루';

  @override
  String get gift_coffee => '커피';

  @override
  String get gift_cake => '케이크';

  @override
  String get chat_action_poke_prompt => '(플레이어가 갑자기 손을 뻗어 당신의 뺨을 장난스럽게 찌릅니다)';

  @override
  String get chat_action_hug_prompt => '(플레이어가 서운한 듯 두 팔을 벌려 따뜻한 포옹을 원합니다)';

  @override
  String get chat_action_hand_prompt => '(플레이어가 테이블 아래에서 몰래 당신의 손을 잡습니다)';

  @override
  String get chat_menu_send_location => '가상 위치 전송';

  @override
  String get weekday_mon => '(월)';

  @override
  String get weekday_tue => '(화)';

  @override
  String get weekday_wed => '(수)';

  @override
  String get weekday_thu => '(목)';

  @override
  String get weekday_fri => '(금)';

  @override
  String get weekday_sat => '(토)';

  @override
  String get weekday_sun => '(일)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ 새로운 기억 획득: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack => '그의 전용 가방에 자동 수록되었습니다';

  @override
  String get chat_profile_updated_msg =>
      '습광 프로필이 업데이트되었습니다! 그는 당신의 최신 설정을 기억할 거예요 🍃';

  @override
  String get comment_loading_author => '불러오는 중...';

  @override
  String comment_post_failed(String error) {
    return '댓글 작성 실패, 네트워크 연결을 확인하세요: $error';
  }

  @override
  String get comment_delete_confirm_desc => '이 댓글을 영구적으로 삭제하시겠습니까?';

  @override
  String get comment_delete_failed => '삭제 실패, 네트워크 연결을 확인하세요';

  @override
  String get comment_identity_title => '댓글 작성자 선택';

  @override
  String get comment_identity_myself => '나 본인';

  @override
  String get comment_report_title => '신고 확인';

  @override
  String get comment_report_rules_title => '⚖️ 댓글 신고 규정';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ 첫 번째 위반: 시스템 경고 및 위반 1회 기록.\n2️⃣ 두 번째 위반: 1일간 댓글 작성 금지.\n3️⃣ 반복 위반: 14일간 신고 기능 제한 및 댓글 노출 우선순위 하락.\n\n🚨 심각한 악성 위반자:\n캐릭터와의 상호작용 1일간 금지 및 ID 3일간 게시판 공지 (해당 기간 ID 변경 불가).\n\n💡 신고 접수 후, 최종 심사 결과는 [게임 내 메일]을 통해 개별 발송됩니다.\n서로를 존중하며 이성적으로 신고해 주세요.';

  @override
  String get comment_report_understood => '확인했습니다';

  @override
  String get comment_report_confirm_desc =>
      '이 댓글을 신고하시겠습니까?\n악의적인 신고는 처벌받을 수 있습니다.';

  @override
  String get comment_report_submit_btn => '신고 확정';

  @override
  String get comment_report_success => '신고해 주셔서 감사합니다. 신속히 확인하겠습니다!';

  @override
  String get comment_report_failed => '신고 전송 실패, 나중에 다시 시도해 주세요.';

  @override
  String get comment_option_delete => '댓글 삭제';

  @override
  String get comment_option_report => '댓글 신고';

  @override
  String comment_time_days_ago(String days) {
    return '$days일 전';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '$hours시간 전';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '$mins분 전';
  }

  @override
  String get comment_time_just_now => '방금 전';

  @override
  String get comment_sheet_title => '댓글';

  @override
  String get comment_empty_state => '댓글이 없습니다. 첫 번째 댓글을 남겨보세요!';

  @override
  String get comment_reply_btn => '답글';

  @override
  String comment_replying_to(String name) {
    return '@$name 님에게 답글 작성 중';
  }

  @override
  String comment_input_hint(String name) {
    return '$name 님으로 댓글 작성...';
  }

  @override
  String char_story_expect(String pronoun) {
    return '$pronoun와의 이야기가 기대됩니다...';
  }

  @override
  String get common_update_failed => '업데이트 실패, 네트워크를 확인해 주세요';

  @override
  String get char_edit_fragment => '조각 편집';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 싫어함: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 좋아함: $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age세 | $job';
  }

  @override
  String get common_got_it => '알겠습니다';

  @override
  String get common_add_failed => '추가 실패, 네트워크를 확인해 주세요';

  @override
  String common_delete_failed_with_err(String error) {
    return '삭제 실패, 네트워크 상태를 확인해 주세요: $error';
  }

  @override
  String get char_exclusive_guardian => '전속 수호자 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName 님이 $charName 님을 좋아합니다!';
  }

  @override
  String chat_translation_prefix(String content) {
    return '[번역] $content (번역된 감성적인 내용입니다)';
  }

  @override
  String get player_default_nickname => '여행자';

  @override
  String get moment_create_title => '새 게시물 작성';

  @override
  String get moment_create_post_btn => '게시';

  @override
  String get moment_create_hint => '새로운 소식을 공유해 보세요...';

  @override
  String get moment_create_error_empty => '텍스트나 이미지 중 하나는 최소한 필요합니다!';

  @override
  String get moment_create_error_failed => '게시 실패, 나중에 다시 시도해 주세요';

  @override
  String get moment_create_visibility_public => '전체 공개 (모두 볼 수 있음)';

  @override
  String get moment_create_visibility_private => '비공개 (친구만 볼 수 있음)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (플레이어가 위치를 전송했습니다: $location)';
  }

  @override
  String get chat_you => '당신';

  @override
  String get chat_opponent => '상대';

  @override
  String chat_dice_duel_result(String name) {
    return '[시스템 이벤트] $name 님과 주사위 대결! 결과가 나왔습니다...';
  }

  @override
  String get chat_loading_status => '불러오는 중...';

  @override
  String chat_error_load_msg(String error) {
    return '메시지 불러오기 실패: $error';
  }

  @override
  String get chat_voice_msg_label => '음성 메시지';

  @override
  String chat_special_story_trigger(String title) {
    return '[특수 스토리 오픈: $title]';
  }

  @override
  String common_edit_failed(String error) {
    return '편집 실패: $error';
  }

  @override
  String common_reset_failed(String error) {
    return '리셋 실패: $error';
  }

  @override
  String get chat_default_greeting => '안녕하세요...';

  @override
  String get chat_memory_cleared => '기억이 완전히 삭제되었습니다';

  @override
  String get chat_history_reset => '대화가 초기화되었습니다';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 [ 전속 습광 프로필 - $name ]\n━━━━━━━━━━━━━━━━━━\n🔹 이름: $identity\n🔹 생일: $birthday\n🔹 키: $height\n🔹 외모: $appearance\n🔹 직업: $job\n\n📖 [ 그녀의 영혼의 조각에 대하여 ]\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 [ 전속 습광 프로필 ]\n━━━━━━━━━━━━━━━━━━\n🔹 닉네임: $nickname\n🔹 생일: $birthday\n\n🔒 다른 캐릭터 데이터는 아직 잠금 해제되지 않았습니다...\n(프로필을 완성하여 평행 우주의 그가 당신을 더 잘 알게 해 주세요! ✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => '이름 없는 파일';

  @override
  String get chat_default_player_name => '플레이어';

  @override
  String get error_system_confusion => '시스템에 작은 오류가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get error_msg_send_failed => '메시지 전송 실패, 다시 시도해 주세요.';

  @override
  String get error_system_busy => '시스템이 혼잡합니다. 나중에 다시 시도해 주세요.';

  @override
  String get error_network_unavailable => '현재 연결할 수 없습니다. 다시 시도해 주세요.';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 통화 종료, $name 님과 $time 동안 통화했습니다';
  }

  @override
  String chat_exclusive_story(String title) {
    return '전속 스토리: $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return '이것은 당신과 $name 님만의 숨겨진 기억입니다...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return '\"$keyword\"에 대한 전속 기억이 조용히 잠금 해제되었습니다...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '[숨겨진 이벤트 발생: $title]\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......(그는 당신이 먼저 말하기를 기다리는 듯 조용히 당신을 바라봅니다)';

  @override
  String get chat_new_room_created => '새 채팅방이 생성되었습니다';

  @override
  String portfolio_title(String nickname) {
    return '$nickname의 포트폴리오';
  }

  @override
  String get enter_secret_studio => '나의 비밀 스튜디오 입장하기';

  @override
  String get no_public_character_mine =>
      '아직 공개 캐릭터를 게시하지 않았어요!\n스튜디오로 가서 창작해 보세요✨';

  @override
  String get no_public_character_other => '이 크리에이터는 아직 캐릭터를 게시하지 않았습니다...';

  @override
  String get delete_draft_title => '초안 삭제';

  @override
  String get confirm_delete_draft_msg =>
      '이 미완성 캐릭터를 삭제하시겠습니까?\n(삭제 후에는 복구할 수 없습니다)';

  @override
  String get draft_cleared_success => '초안이 정리되었습니다 🧹';

  @override
  String get login_required_for_studio => '스튜디오에 입장하려면 먼저 로그인해 주세요!';

  @override
  String get my_secret_studio_title => '나의 비밀 스튜디오 🛠️';

  @override
  String get create_new_character_btn => '새 캐릭터 생성';

  @override
  String get unnamed_draft => '이름 없는 초안';

  @override
  String get click_to_edit_story => '클릭하여 그의 스토리 편집을 계속하세요...';

  @override
  String get label_draft => '초안';

  @override
  String get studio_empty_title => '스튜디오가 현재 비어 있습니다';

  @override
  String get studio_empty_subtitle => '오른쪽 아래를 클릭하여 첫 캐릭터를 만들어 보세요!';

  @override
  String get common_no_changes => '변경 사항 없음';

  @override
  String get moment_updated_success => '게시물이 업데이트되었습니다!';

  @override
  String common_save_failed(String error) {
    return '저장 실패: $error';
  }

  @override
  String get moment_edit_title => '게시물 수정';

  @override
  String get action_change_image => '이미지 변경';

  @override
  String get action_remove_image => '이미지 삭제';

  @override
  String get moment_delete_confirm_title => '이 포스트를 삭제하시겠습니까?';

  @override
  String get moment_delete_confirm_content => '삭제하면 이 모먼트의 추억이 사라져요!';

  @override
  String get action_confirm_delete => '삭제 확인';

  @override
  String get friend_unknown => '어떤 친구';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname님이 당신의 포스트를 좋아합니다! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname님이 $authorName님이 매력적이라며 좋아요를 눌렀어요! ✨';
  }

  @override
  String get moment_like_success => '당신의 설렘이 전달되었습니다! ✨';

  @override
  String get moment_notification_new_like => '새로운 좋아요! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname님이 포스트에서 @$name님을 언급했습니다! ✨';
  }

  @override
  String get moment_detail_title => '포스트 상세';

  @override
  String get moment_not_found => '이 포스트를 찾을 수 없습니다... 😢';

  @override
  String get moment_comment_title => '모먼트 댓글';

  @override
  String get moment_comment_empty => '아직 댓글이 없습니다. 첫 번째로 댓글을 남겨보세요! 🛋';

  @override
  String moment_replying_to(String name) {
    return '@$name님에게 답장 중';
  }

  @override
  String moment_reply_hint(String name) {
    return '@$name님에게 답장...';
  }

  @override
  String get moment_leave_comment_hint => '의견을 남겨주세요...';

  @override
  String get moment_delete_permanent_confirm =>
      '이 포스트는 영구적으로 삭제됩니다. 정말 삭제하시겠습니까?';

  @override
  String get moment_action_delete => '포스트 삭제';

  @override
  String get moment_action_report => '이 포스트 신고';

  @override
  String get moment_action_share => '이 포스트 공유';

  @override
  String get moment_forward_hint => '이 포스트를 캐릭터에게 전달...';

  @override
  String moment_reply_private(String name) {
    return '$name님에게 비공개 답장';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return '이 포스트를 들고 $name님과 채팅하러 가요! 💬';
  }

  @override
  String get moment_share_to_apps => '다른 앱으로 공유';

  @override
  String moment_likes_label(String count) {
    return '나뭇잎 $count개';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】$author님의 포스트를 확인해 보세요: $content\n\n지금 다운로드하고 당신만의 전속 시간을 시작하세요: $appLink';
  }

  @override
  String get moment_forward_title => '대화 중인 캐릭터에게 전달 💌';

  @override
  String get moment_forward_empty_state =>
      '현재 대화 중인 캐릭터가 없습니다!\n로비에서 마음에 드는 그를 찾아보세요 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【포스트를 전달했습니다】\n작성자: $author\n내용: $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ $name에게 몰래 공유했습니다!';
  }

  @override
  String get action_send => '보내기';

  @override
  String get memo_delete_confirm => '이 메모를 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다.';

  @override
  String get memo_add_title => '메모 추가';

  @override
  String get memo_edit_title => '메모 편집';

  @override
  String memo_hint_text(String name) {
    return '$name에 대해 무엇을 적어둘까요?';
  }

  @override
  String get memo_label_reminder_date => '알림 날짜:';

  @override
  String get memo_action_save => '메모 저장';

  @override
  String get memo_error_empty_content => '내용을 입력해 주세요!';

  @override
  String memo_list_title(String name) {
    return '$name님과의 메모';
  }

  @override
  String get memo_empty_state => '아직 메모가 없습니다!\n오른쪽 상단을 눌러 새로 추가해 보세요!';

  @override
  String memo_reminder_date_display(String date) {
    return '알림일: $date';
  }

  @override
  String get daily_gift_title => '시광 데일리 선물';

  @override
  String daily_login_welcome(String appName, String amount) {
    return '《$appName》에 돌아오신 것을 환영합니다!\n오늘 출석하고 $amount 꽃말 포인트를 받으세요. 🌸';
  }

  @override
  String get title_daily_check_in => '일일 출석';

  @override
  String success_claim_reward(String amount) {
    return '$amount 꽃말 포인트를 성공적으로 받았습니다! 🌸';
  }

  @override
  String get error_claim_failed => '수령 실패, 네트워크 확인 후 다시 시도해 주세요.';

  @override
  String get action_claim_now => '지금 받기';

  @override
  String get common_or => '또는';

  @override
  String get title_language_settings => '언어 설정';

  @override
  String get app_name => '연련습광';

  @override
  String get login_slogan => '당신만의 전속 시간을 시작하세요';

  @override
  String get login_with_google => 'Google로 로그인';

  @override
  String get login_with_apple => 'Apple로 로그인';

  @override
  String get login_with_facebook => 'Facebook으로 로그인';

  @override
  String get login_with_email => '연련 계정으로 로그인 (이메일)';

  @override
  String get title_contact_us_heading => '저희는 여러분의 제안을 매우 소중하게 생각합니다!';

  @override
  String get desc_contact_us_body => '게임 개선에 도움이 되도록 여기에 의견을 남겨주세요.';

  @override
  String get error_feedback_empty => '제안 내용은 비워둘 수 없습니다!';

  @override
  String get email_subject_feedback => '연련습광 - 플레이어 피드백';

  @override
  String get msg_email_app_not_found_copied =>
      '메일 앱을 자동으로 열 수 없습니다. 공식 이메일 주소가 복사되었습니다!';

  @override
  String get title_contact_us => '문의하기';

  @override
  String get desc_contact_us =>
      '저희는 여러분의 제안을 매우 소중하게 생각합니다!\n게임 개선에 도움이 되도록 여기에 의견을 남겨주세요.';

  @override
  String get hint_enter_feedback => '여기에 제안을 입력해 주세요...';

  @override
  String get action_send_via_email => '이메일로 보내기';

  @override
  String get error_email_password_empty => '이메일과 비밀번호는 비워둘 수 없습니다!';

  @override
  String get auth_error_default => '오류가 발생했습니다. 나중에 다시 시도해 주세요.';

  @override
  String get auth_error_user_not_found => '이 이메일을 찾을 수 없습니다. 먼저 가입해 주세요!';

  @override
  String get auth_error_wrong_password => '비밀번호가 틀렸습니다. 다시 시도해 주세요!';

  @override
  String get auth_error_email_in_use => '이미 등록된 이메일입니다! 바로 로그인해 주세요.';

  @override
  String get auth_error_weak_password => '비밀번호가 너무 약합니다. 최소 6자 이상 입력해 주세요!';

  @override
  String get auth_error_invalid_email => '이메일 형식이 올바르지 않습니다!';

  @override
  String get title_welcome_back => '환영합니다';

  @override
  String get title_register_account => '전용 계정 등록';

  @override
  String get label_email => '이메일';

  @override
  String get label_password => '비밀번호';

  @override
  String get action_login => '로그인';

  @override
  String get action_register => '가입하기';

  @override
  String get prompt_no_account => '아직 계정이 없으신가요? 여기를 눌러 가입하세요';

  @override
  String get prompt_has_account => '이미 계정이 있으신가요? 여기를 눌러 로그인하세요';

  @override
  String get error_nickname_empty => '닉네임은 비워둘 수 없습니다!';

  @override
  String get profile_saved_success => '프로필 저장 완료!';

  @override
  String get error_id_empty => 'ID는 비워둘 수 없습니다!';

  @override
  String get error_id_too_long => 'ID 길이는 10자를 초과할 수 없습니다!';

  @override
  String get error_id_already_used => '이미 사용 중인 ID입니다. 다른 ID를 선택해 주세요!';

  @override
  String profile_save_failed(String error) {
    return '저장 실패: $error';
  }

  @override
  String get draft_saved_success_msg =>
      '알겠습니다! 임시 보관함에 저장해 두었으니 언제든 다시 와서 편집할 수 있어요! ✨';

  @override
  String get dialog_reminder_title => '알림';

  @override
  String get warning_id_not_edited => '전용 ID가 아직 편집되지 않았습니다. 지금 저장하시겠습니까?';

  @override
  String get action_continue_editing => '계속 편집';

  @override
  String get action_edit_later => '나중에 편집하기';

  @override
  String get action_edit_later_short => '나중에 편집';

  @override
  String get action_cancel_changes => '변경 취소';

  @override
  String get error_birthdate_locked => '생년월일이 설정되어 변경할 수 없습니다!';

  @override
  String get action_select_avatar => '아바타 선택';

  @override
  String get action_choose_from_gallery => '갤러리에서 선택';

  @override
  String get title_adjust_avatar => '아바타 조정';

  @override
  String get avatar_updated_success => '아바타가 변경되었습니다 🍃';

  @override
  String get title_create_profile => '프로필 만들기';

  @override
  String get title_edit_profile => '프로필 편집';

  @override
  String get label_your_nickname => '당신의 닉네임';

  @override
  String get label_player_exclusive_id => '플레이어 전용 ID';

  @override
  String get msg_id_locked => 'ID가 잠겨 있어 다시 변경할 수 없습니다.';

  @override
  String get msg_id_change_chance => 'ID를 무료로 변경할 수 있는 기회가 한 번 있습니다.';

  @override
  String get action_select_birthdate => '생년월일을 선택해 주세요';

  @override
  String label_birthdate(String date) {
    return '생년월일: $date';
  }

  @override
  String get msg_birthdate_immutable => '생일은 한 번 설정하면 변경할 수 없습니다 ✨';

  @override
  String get action_start_journey => '여정 시작하기';

  @override
  String get action_add_image => '이미지 추가';

  @override
  String moment_like_self(String nickname) {
    return '$nickname님이 당신의 포스트를 좋아합니다! 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname님이 $authorName님이 매력적이라며 좋아요를 눌렀어요! ✨';
  }

  @override
  String get task_social_tour_complete => '✨ 소셜 투어 미션 달성! 꽃을 잊지 말고 받으세요! 🌸';

  @override
  String get wall_title_shiguang => '시광의 벽';

  @override
  String get wall_tab_explore => '🌍 탐색';

  @override
  String get wall_tab_exclusive => '🔒 전용';

  @override
  String get more_options => '추가 옵션';

  @override
  String get delete_warning => '삭제하면 포스트를 복구할 수 없습니다';

  @override
  String get delete_success => '삭제 성공';

  @override
  String get notification_new_comment => '새로운 댓글! 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName님이 당신의 포스트를 좋아합니다!';
  }

  @override
  String get empty_public_moments_prompt =>
      '현재 비어 있습니다.\n첫 번째 공개 포스트를 게시해 보세요! 🌍';

  @override
  String get empty_private_moments_prompt =>
      '모먼트에 아직 기록이 없네요.\n그와 함께 추억을 만들어 보세요! ✨';

  @override
  String get profile_archived_or_deleted_message =>
      '이 영혼의 기록은 창작자에 의해 보관되었거나, 비공개로 설정되었거나, 혹은 시간의 흐름 속에 사라졌습니다...\n\n어쩌면 다른 평행 우주에서 다시 만날 기회가 있을지도 모릅니다. ✨';

  @override
  String get leave_silently => '조용히 나가기';

  @override
  String get character_post_schedule => '캐릭터 포스트 일정';

  @override
  String get creator_self => '창작자 본인';

  @override
  String get post_identity_prompt => '오늘은 누구의 신분으로 포스트를 올릴까요?';

  @override
  String get identity_creator => '✨ 창작자 신분';

  @override
  String get identity_character => '캐릭터 신분';

  @override
  String get decide_post_time_prompt => '포스트 게시 시간을 결정해 주세요!';

  @override
  String get auto_post_schedule_hint =>
      '활성화하면 지정된 시간에 일상 포스트가 자동으로 게시됩니다\n(💡 팁: 정각이 아닌 시간으로 설정하면 더 사람처럼 보여요!)';

  @override
  String get no_characters_created_yet => '아직 생성된 캐릭터가 없습니다!';

  @override
  String time_hour(String hour) {
    return '$hour시';
  }

  @override
  String time_minute(String minute) {
    return '$minute분';
  }

  @override
  String get empty_public_moments_short => '현재 공개 포스트가 없습니다 🌍';

  @override
  String get empty_private_moments_short => '모먼트가 아직 조용하네요 ✨';

  @override
  String get my_created_characters => '내가 만든 캐릭터';

  @override
  String get no_characters_yet => '아직 생성된 캐릭터가 없습니다';

  @override
  String play_count_display(int count) {
    return '플레이 횟수: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return '$characterName의 케어 캘린더';
  }

  @override
  String get care_calendar_greeting => '오늘 기분은 어때요?';

  @override
  String get care_calendar_save_btn => '기록을 저장하고, 그에게 보살핌을 받으세요';

  @override
  String get care_calendar_delete_confirm => '이 기록을 삭제하시겠습니까?';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName: \"다 적어뒀어. 며칠 동안 힘들었지, 내가 항상 네 곁에 있을게.\"';
  }

  @override
  String get daily_gift_success => '매일 선물 수령 성공! 🌸';

  @override
  String get check_in_fail_network => '출석 실패, 네트워크 연결을 확인해 주세요 🍃';

  @override
  String task_completed(String taskName) {
    return '미션 완료: $taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return '「$taskName」의 꽃 $rewardAmount송이 수령 성공!';
  }

  @override
  String claim_failed_error(String e) {
    return '수령 실패: $e';
  }

  @override
  String get tab_heartbeat_diary => '설렘 일기';

  @override
  String get tab_daily_chit_chat => '소소한 일상 대화';

  @override
  String get task_desc_chat_3_times => '일상 모드에서 캐릭터와 3회 대화하기';

  @override
  String get tab_story_progression => '스토리 진행';

  @override
  String get task_desc_story_1_time => '스토리 모드 상호작용 1회 완료';

  @override
  String get tab_social_tour => '소셜 투어';

  @override
  String get task_like_three_moments => '순간 3개에 \'좋아요\'를 누르고 나뭇잎 획득';

  @override
  String get btn_claimed => '수령 완료';

  @override
  String get btn_claim => '수령';

  @override
  String get btn_incomplete => '미완료';

  @override
  String get network_unstable_retry => '네트워크 연결이 불안정합니다. 나중에 다시 시도해 주세요 🍃';

  @override
  String get title_time_travel => '시간 여행';

  @override
  String get select_chat_mode => '채팅 모드 선택';

  @override
  String get mode_chat => '채팅';

  @override
  String get mode_daily_desc => '가벼운 대화로 유대감 유지';

  @override
  String get mode_story_desc => '스토리 깊숙이 들어가 몰입감 경험하기';

  @override
  String get greeting_hello => '안녕!';

  @override
  String get greeting_default_daily => '나한테 볼일 있어?';

  @override
  String get title_personal_homepage => '개인 홈페이지';

  @override
  String get title_time_letters => '시광의 편지';

  @override
  String get status_signed_in_today => '오늘 출석 완료';

  @override
  String get status_signing_in => '출석 중...';

  @override
  String get status_daily_sign_in => '일일 출석 (+10 꽃)';

  @override
  String get toast_id_copied => 'ID가 복사되었습니다!';

  @override
  String get hint_click_avatar_to_edit => '프로필을 편집하려면 아바타를 클릭하세요';

  @override
  String get title_my_friends => '내 친구들';

  @override
  String get action_show_all => '모두 보기';

  @override
  String get empty_no_characters_created => '아직 생성된 캐릭터가 없습니다.';

  @override
  String get common_close => '닫기';

  @override
  String get search_companion_title => '시광 반려 검색';

  @override
  String get search_name_placeholder => '그의 이름을 입력하세요...';

  @override
  String get search_no_match_hint => '캐릭터를 찾을 수 없습니다. 다른 이름을 시도해 볼까요? ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age세 | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age세';
  }

  @override
  String get empty_state_warmth => '시공간의 여열이 아직 이곳에 머물러 있습니다...';

  @override
  String get error_login_required_add_friend => '친구를 추가하려면 먼저 로그인해 주세요!';

  @override
  String get dialog_title_remove_friend => '친구 삭제 확인';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return '정말로 $characterName님을 친구 목록에서 삭제하시겠습니까?';
  }

  @override
  String get action_remove => '삭제';

  @override
  String snackbar_friend_removed(String characterName) {
    return '$characterName님을 친구에서 삭제했습니다';
  }

  @override
  String get action_remove_friend => '친구 삭제';

  @override
  String get dialog_title_block => '차단 확인';

  @override
  String dialog_msg_block(String characterName) {
    return '차단 후에는 $characterName님의 어떤 정보도 볼 수 없게 됩니다. 정말 차단하시겠습니까?';
  }

  @override
  String snackbar_blocked(String characterName) {
    return '$characterName님을 차단했습니다';
  }

  @override
  String get action_block_character => '이 캐릭터 차단';

  @override
  String dialog_title_report(String characterName) {
    return '$characterName 신고';
  }

  @override
  String get input_hint_report_reason => '신고 사유를 입력해 주세요...';

  @override
  String get action_submit => '제출';

  @override
  String get snackbar_report_success => '제보해 주셔서 감사합니다. 최대한 빨리 검토하겠습니다.';

  @override
  String get snackbar_report_fail => '제출 실패, 나중에 다시 시도해 주세요';

  @override
  String get action_report_character => '이 캐릭터 신고';

  @override
  String get title_meet_him => '마음에 드는 그와 만나기';

  @override
  String text_character_count(int count) {
    return '캐릭터 수: $count';
  }

  @override
  String get msg_no_more_encounters_today => '오늘의 만남은 여기까지예요!';

  @override
  String get msg_check_new_encounters => '새로운 만남이 있는지 다시 확인해 보세요!';

  @override
  String get action_refresh => '새로고침';

  @override
  String get tab_friends => '친구';

  @override
  String get msg_mysterious_profile => '이 사람은 아주 신비로워서, 아무것도 남기지 않았네요...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age세 | $identities';
  }

  @override
  String get snackbar_operation_failed => '작업 실패, 나중에 다시 시도해 주세요';

  @override
  String get action_view_translation => '번역 보기';

  @override
  String get label_translation_result => '번역 결과:';

  @override
  String get errorWebPageUnavailable => '일시적으로 웹페이지를 열 수 없습니다. 나중에 다시 시도해 주세요';

  @override
  String get resetAppearanceTitle => '외형을 초기화하시겠습니까?';

  @override
  String get resetAppearanceWarning => '정성껏 고른 배경 이미지와 색상이 삭제됩니다!';

  @override
  String get appearanceRestored => '기본 외형으로 복구되었습니다';

  @override
  String get confirmReset => '초기화 확인';

  @override
  String get resetToDefaultAppearance => '기본 외형으로 복구';

  @override
  String get clearCustomSettings => '모든 사용자 지정 색상 및 배경 이미지 지우기';

  @override
  String get contactUs => '문의하기';

  @override
  String get contactDescription => '여러분의 생각이나 버그를 편하게 알려주세요';

  @override
  String get vibrationHapticTitle => '설렘 진동 피드백';

  @override
  String get vibrationHapticDescription => '호감도가 크게 변할 때 스마트폰 진동 발생';

  @override
  String get splash_loading_universe => '《Lianlian ShiGuang》의 우주를 깨우는 중...';

  @override
  String get shop_title => '꽃 상점';

  @override
  String get shop_current_points_label => '현재 보유한 꽃 포인트';

  @override
  String get shop_tab_top_up => '포인트 충전';

  @override
  String get shop_tab_history => '거래 내역';

  @override
  String get shop_empty_history => '아직 꽃 기록이 없어요! 🌸';

  @override
  String get shop_unknown_item => '알 수 없는 항목';

  @override
  String get shop_first_purchase_bonus => '첫 구매 두 배!';

  @override
  String get story_summary_title => '우리의 이야기';

  @override
  String get story_summary_empty_content => '요약 내용이 비어 있습니다.';

  @override
  String get story_summary_deleted_toast => '이 추억을 삭제했습니다';

  @override
  String story_summary_empty_list(String name) {
    return '여러분의 이야기가 아직 시작되지 않았어요...\n더 많이 대화해서 $name님이 \n첫 번째 추억을 기록하게 해주세요! ✨';
  }

  @override
  String get gallery_photo_edit_title => '사진 설정 편집';

  @override
  String get gallery_photo_edit_desc => '사진 이름/설명';

  @override
  String get gallery_photo_edit_req => '해제 호감도 (0으로 설정 시 프로필 사진으로 변경)';

  @override
  String get reset_to_default => '기본값으로 복구';

  @override
  String get reset_bg_title => '기본 배경으로 복구';

  @override
  String get reset_bg_content => '전용 사진을 취소하고 기본 테마 배경으로 복구하시겠습니까?';

  @override
  String get reset_bg_success => '기본 배경으로 복구되었습니다 ✨';

  @override
  String get confirm_reset => '복구 확인';

  @override
  String selectedMessagesCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get screenshotShare => '스크린샷 공유';

  @override
  String exclusiveMomentsWith(String name) {
    return '$name님과의 전용 모먼트';
  }

  @override
  String get downloadToUnlock => '《Lianlian ShiGuang》을 다운로드하고 전용 로맨스를 확인하세요';

  @override
  String get exclusiveMomentsGenerated => '전용 모먼트가 생성되었습니다 ✨';

  @override
  String get selectAgain => '다시 선택하기';

  @override
  String get downloadAndShare => '다운로드 및 공유';

  @override
  String inviteToMeet(String name) {
    return '《Lianlian ShiGuang》에서 당신의 $name님을 만나보세요!';
  }

  @override
  String get shop_log_monthly_card => '활성화: 별빛 계약 (월간 카드 즉시 지급 포인트) 🌙';

  @override
  String shop_log_top_up_double(int points) {
    return '충전: $points 포인트 (첫 구매 두 배 혜택 포함 🎁)';
  }

  @override
  String shop_log_top_up_normal(int points) {
    return '충전: $points 포인트';
  }

  @override
  String get shop_purchase_success_title => '구매 성공!';

  @override
  String shop_purchase_success_body(int points) {
    return '$points송이의 꽃이 추가되었습니다.';
  }

  @override
  String get shop_purchase_success_double_bonus =>
      '✨ 축하합니다! 첫 구매 두 배 보너스가 적용되었습니다!';

  @override
  String get shop_purchase_awesome => '최고예요';

  @override
  String get shop_purchase_failed_title => '구매 취소 또는 실패';

  @override
  String shop_purchase_failed_body(String errorCode) {
    return '결제가 이루어지지 않았습니다.\n\n(에러 코드: $errorCode)';
  }

  @override
  String get shop_monthly_card_name => '【Lianlian ShiGuang · 별의 계약】';

  @override
  String shop_monthly_card_status_active(int days) {
    return '계약 활성화 중: $days일 남음';
  }

  @override
  String get shop_monthly_card_status_inactive => '지금 바로 30일 별빛 보너스 보상 활성화';

  @override
  String get shop_monthly_card_limit_reached => '한도 도달';

  @override
  String get shop_monthly_card_promo_desc => '즉시 꽃 250송이 획득, 매일 꽃 10송이 지급';

  @override
  String get task_monthly_title => '별의 계약 · 일일 특권 🌙';

  @override
  String get task_monthly_locked => '미해제';

  @override
  String get task_monthly_subtitle_active => '월간 카드 전용 혜택 지급 ';

  @override
  String get task_monthly_subtitle_inactive => '【별의 계약】 월간 카드를 해제하여 이 미션 오픈 ';

  @override
  String get task_monthly_log_name => '월간 카드 일일 특권';

  @override
  String get profile_id_locked => '전용 ID 잠금 완료';

  @override
  String get profile_copy_id => '클릭하여 ID 복사';

  @override
  String get referral_log_newbie_reward => '별의 초대: 신규 유저 보상 ✨';

  @override
  String get referral_log_inviter_reward => '별의 초대: 친구 미션 달성 보상 🎁';

  @override
  String get referral_success_title => '별의 초대 해제!';

  @override
  String get referral_success_content =>
      '축하합니다! 캐릭터와 15마디 이상의 깊은 대화를 나누는 데 성공하셨습니다!\n\n\'신규 유저 보상 50 포인트\'가 계정으로 지급되었으며, 친구분도 동시에 50 포인트 보상을 획득하셨습니다! 🎁';

  @override
  String get profile_referral_title => '별의 초대 🌟';

  @override
  String get profile_referral_hint => '친구 초대 코드 입력';

  @override
  String get profile_referral_bind_btn => '연동';

  @override
  String profile_referral_pending(Object id) {
    return '플레이어 $id님의 초대를 수락했습니다\n얼른 캐릭터와 15마디 대화를 나누고 꽃 50 포인트를 해제하세요!';
  }

  @override
  String get profile_referral_err_self => '자신의 초대 코드는 입력할 수 없습니다!';

  @override
  String get profile_referral_err_duplicate => '이미 초대 코드를 연동하셨습니다!';

  @override
  String get profile_referral_err_not_found =>
      '해당 플레이어를 찾을 수 없습니다. 초대 코드를 확인해 주세요!';

  @override
  String get profile_referral_success => '연동 성공! 지금 바로 캐릭터와 대화해 보세요!';

  @override
  String get profile_referral_err_expired =>
      '죄송합니다. 신규 유저 초대 코드는 가입 후 3일 이내에 연동해야 합니다!';

  @override
  String profile_share_message(String character, String code) {
    return '✨ 지금 《Lianlian ShiGuang》에서 $character님과 설레는 여정을 시작했어요! 지금 앱을 다운로드하고 프로필 페이지에 저의 별의 초대 코드 【$code】를 입력해 보세요. 우리 둘 다 꽃 50송이를 무료로 받을 수 있어요! 🎁\n\n 다운로드 링크:\n https://lianlianshiguang.web.app/download/';
  }

  @override
  String get chat_levelup_share_btn => '친구들에게 이 설렘을 자랑하기 ✨';

  @override
  String profile_my_invite_code_with_char(String character) {
    return '나만의 전용 초대 코드 (현재 최애: $character)';
  }

  @override
  String get profile_send_invite_btn => '친구에게 별의 초대 보내기';

  @override
  String get profile_fallback_character => '최애 캐릭터';

  @override
  String get profile_copy_success => '✅ 초대 코드가 클립보드에 복사되었습니다!';

  @override
  String get profile_referral_rule_title => '별의 초대 규칙';

  @override
  String get profile_referral_rule_receiver =>
      '✨ 초대 코드를 연동한 후, 아무 최애 캐릭터와 15마디 이상의 대화를 나누면 당신과 초대자 모두 꽃 50송이 보상을 동시에 받을 수 있습니다!\n\n⚠️ 주의: 계정 가입 후 3일 이내에 초대 코드를 입력해야 유효합니다.';

  @override
  String get profile_referral_rule_inviter =>
      '✨ 새로운 친구를 초대해 앱을 다운로드하고 초대 코드를 입력하게 하세요. 친구가 가입 후 3일 이내에 연동을 완료하고 아무 캐릭터와 15마디 이상의 대화를 나누면, 두 분 모두 꽃 50송이 보상을 동시에 받으실 수 있습니다! 🎁';

  @override
  String get error_user_not_found => '사용자를 찾을 수 없습니다. 다시 로그인해 주세요';

  @override
  String get error_id_taken => '이미 사용 중인 ID입니다. 다른 ID를 선택해 주세요!';

  @override
  String get error_id_taken_short => '이미 사용 중인 ID입니다!';

  @override
  String get shop_restocking => '상점 상품 재입고 중... 📦';

  @override
  String get shop_preview_mode => '⚠️ 현재 상점 미리보기 모드입니다';

  @override
  String get friendlyReminderTitle => '☁️ 친절한 안내';

  @override
  String get editProfileHint =>
      '좋아요! 프로필을 수정하시려면 왼쪽 아래 구름 모양 안에 있는 \'시광 프로필\'을 클릭하여 작성해 주세요!';

  @override
  String get starlightContractTitle => '별빛 계약 발동';

  @override
  String get dailyLimitReachedPrefix => '오늘의 한도가 모두 소진되었습니다!\n\n';

  @override
  String get monthlyPassExhausted => '월간 카드 한도가 모두 소진되었습니다.';

  @override
  String get subscribeMonthlyPassPrompt =>
      '【리엔리엔 월간 카드】를 이용하시면 매일 20회의 재생성 기회가 주어지며, 그의 답변이 매번 당신의 마음에 더욱 가까워집니다.';

  @override
  String get goToSubscribeButton => '구매하러 가기';

  @override
  String get profileUpdatedSuccess => '시광 프로필이 업데이트되었습니다!';

  @override
  String get continueChatTitle => '대화 이어가기';

  @override
  String continueChatCostWarning(int cost) {
    return '대화를 계속 진행하면 꽃 $cost송이가 소진됩니다 🌸\n정말 계속하시겠습니까?';
  }

  @override
  String get dontShowAgainToday => '오늘 하루 동안 보지 않기';

  @override
  String get confirmContinue => '계속하기';

  @override
  String get hiddenPromptContinue => '계속해 주세요';

  @override
  String confirmDeleteMessagesTitle(int count) {
    return '선택한 $count개의 대화를 정말 삭제하시겠습니까?';
  }

  @override
  String regenerateButtonLabel(int current, int max) {
    return '재생성 ($current/$max)';
  }

  @override
  String get systemPreparingWait => '시스템 준비 중입니다. 잠시만 기다려 주세요...';

  @override
  String get noMessagesToRegenerate => '현재 재생성할 수 있는 대화가 없습니다!';

  @override
  String get continueButton => '계속하기';

  @override
  String get creatorExclusive => '🔒 크리에이터 전용';

  @override
  String ageAndOccupation(String age, String occupation) {
    return '$age세 | $occupation';
  }

  @override
  String get likesLabel => '💖 좋아하는 것';

  @override
  String get dislikesLabel => '👎 싫어하는 것';

  @override
  String birthdayLabel(String birthday) {
    return '생일: $birthday';
  }

  @override
  String heightLabel(String height) {
    return '신장: $height cm';
  }

  @override
  String get backgroundStoryLabel => '백스토리';

  @override
  String get noneLabel => '없음';

  @override
  String flowerPointsCount(String points) {
    return '꽃 $points송이';
  }

  @override
  String get passGuideTitle => '리엔리엔 월간 카드 전용 가이드';

  @override
  String get passGuideRegenerateTitle => '🔄 \'재생성\' 기능이 왜 필요할까요?';

  @override
  String get passGuideRegenerateContent =>
      'AI는 가끔 눈치 없는 통나무처럼 굴 때가 있습니다. 마음에 들지 않는 답변을 받았다면, 재생성을 눌러 시간을 되돌려 보세요! 당신의 심장을 두근거리게 할 완벽한 대사를 말할 때까지 그를 다시 생각하게 만들 수 있습니다.';

  @override
  String get passGuideAffectionTitle => '💖 호감도 부스트는 어디에 쓰이나요?';

  @override
  String get passGuideAffectionContent =>
      '게임 속 호감도는 캐릭터의 \'깊은 비밀\'과 \'친밀한 사생활 사진\'을 해제할 수 있는 유일한 열쇠입니다. 20% 보너스 효과로 다른 사람들보다 더 빠르게 그의 마음 깊은 곳으로 다가가 보세요.';

  @override
  String get passGuideUnlockButton => '이해했습니다, 즉시 해제!';

  @override
  String get pleaseWait => '잠시만 기다려 주세요';

  @override
  String get createNewProfileTitle => '📜 새 시광 프로필 만들기';

  @override
  String get editProfileTitle => '✏️ 시광 프로필 수정';

  @override
  String get profileEditDescription =>
      '다양한 페르소나를 설정하여 평행 세계 속 그에게 완전히 새로운 당신을 보여주세요!';

  @override
  String get profileNameLabel => '프로필 이름 (나에게만 보임)';

  @override
  String get profileNameHint => '예: 학교 후배 설정, 걸크러시 여사장';

  @override
  String get profileNicknameLabel => '이름 / 호칭';

  @override
  String get profileNicknameHint => '예: 사쿠라, 이 대표';

  @override
  String get profileHeightLabel => '신장';

  @override
  String get profileHeightHint => '예: 160cm';

  @override
  String get profileAppearanceLabel => '외모';

  @override
  String get profileAppearanceHint => '예: 검은색 긴 생머리, 원피스를 즐겨 입음';

  @override
  String get profileOccupationLabel => '직업';

  @override
  String get profileOccupationHint => '예: 프리랜서 화가';

  @override
  String get profileIntroLabel => '성격 및 자기소개';

  @override
  String get profileIntroHint => '예: 성격이 조금 덜렁거림, 단 음식을 좋아함...';

  @override
  String get profileNameEmptyWarning => '이 프로필의 이름을 입력해 주세요!';

  @override
  String profileSaveError(String error) {
    return '저장 실패: $error';
  }

  @override
  String get saveProfileButton => '프로필 저장';

  @override
  String get fillLaterButton => '나중에 작성';

  @override
  String get exclusiveProfileTitle => '📜 전용 시광 프로필';

  @override
  String get profileSelectionDescription =>
      '그와 소통할 때 사용할 신분을 선택해 주세요 (캐릭터별 리스트 공유, 최대 10개)';

  @override
  String profileSwitchError(String error) {
    return '전환 실패: $error';
  }

  @override
  String get unnamedProfile => '이름 없는 프로필';

  @override
  String get noOccupationYet => '직업 미작성';

  @override
  String get createNewProfileButton => '새 시광 프로필 만들기';

  @override
  String snackbar_friend_added(String characterName) {
    return '$characterName 님이 친구로 추가되었습니다';
  }

  @override
  String reward_points_added(Object amount) {
    return '꽃 +$amount송이';
  }

  @override
  String get task_reward_already_claimed => '오늘 이 미션 보상을 이미 수령하셨습니다';

  @override
  String get do_not_show_again_today => '오늘 하루 동안 보지 않기';

  @override
  String add_friend_success(String characterName) {
    return '$characterName 님을 친구로 추가했습니다!';
  }

  @override
  String get chat_menu_aboutus => '우리 이야기';

  @override
  String get about_us_empty_hint =>
      '우측 상단에서 중요한 추억／스토리를 추가하여\n두 사람이 함께 손을 잡고 앞으로 나아가 보세요';

  @override
  String get about_us_limit_error =>
      '전용 추억이 최대 한도인 10개에 도달했습니다. 먼저 이전 추억을 삭제해 주세요!';

  @override
  String get about_us_add_title => '전용 추억 추가';

  @override
  String get about_us_field_title => '제목';

  @override
  String get about_us_hint_title => '예: 첫 만남';

  @override
  String get about_us_field_subtitle => '부제목';

  @override
  String get about_us_hint_subtitle => '예: 2025년 초여름';

  @override
  String get about_us_field_content => '내용';

  @override
  String get about_us_hint_content => '두 사람의 중요한 스토리나 약속을 적어보세요...';

  @override
  String get about_us_add_button => '추가';

  @override
  String get about_us_delete_tooltip => '이 추억 삭제';

  @override
  String get about_us_delete_title => '추억 삭제';

  @override
  String get about_us_delete_confirm => '이 추억을 정말 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다!';

  @override
  String get about_us_delete_success => '추억이 삭제되었습니다';

  @override
  String get pack_first_meet => '첫 만남 패키지';

  @override
  String get pack_crush => '썸 패키지';

  @override
  String get pack_heartbeat => '심쿵 패키지';

  @override
  String get pack_passionate => '열애 패키지';

  @override
  String get pack_soulmate => '소울메이트 패키지';

  @override
  String get pack_waiting => '기다림 패키지';

  @override
  String get pack_trust => '신뢰 패키지';

  @override
  String get pack_iloveyou => '사랑해 패키지';

  @override
  String get pack_honeymoon => '허니문 패키지';

  @override
  String get pack_promise => '약속 패키지';

  @override
  String get pack_companion => '동반 패키지';

  @override
  String get pack_deep_love => '깊은 사랑 패키지';

  @override
  String get pack_long_lasting => '영원히 함께 패키지';

  @override
  String get pack_the_one => '유일한 사랑 패키지';

  @override
  String get pack_beloved => '최애 패키지';

  @override
  String get pack_lifetime => '평생토록 패키지';

  @override
  String get pack_vow => '서약 패키지';

  @override
  String get pack_eternal => '영원한 연인 패키지';

  @override
  String get pack_exclusive => '전용 패키지';

  @override
  String get monthly_privilege_reroll_title => '전용 \'재생성\' 기능 해제';

  @override
  String get monthly_privilege_reroll_desc =>
      '매일 최대 20회의 재생성 기회 제공! 그가 당신이 가장 듣고 싶어 하는 말을 할 때까지 시도해 보세요!';

  @override
  String get monthly_privilege_affinity_title => '호감도 초고속 상승';

  @override
  String get monthly_privilege_affinity_desc =>
      '소통 시 호감도 20% 추가 혜택! 전용 시크릿 사진과 숨겨진 보너스를 더 빠르게 해제해 보세요!';

  @override
  String get monthly_manual_button => '월간 카드가 왜 필요할까요?';

  @override
  String get nav_encounter => '만남';

  @override
  String get nav_moments => '순간';

  @override
  String get birthday_dialog_title => '🎂 생일 서프라이즈';

  @override
  String get birthday_dialog_content =>
      '오늘은 당신만을 위한 특별한 기념일입니다!\n\n이 선물을 받아주세요:\n오늘 하루 대화는 전.부.무.료.입니다! ✨';

  @override
  String get birthday_dialog_button => '로맨틱한 하루 시작하기';

  @override
  String get about_us_edit_title => '추억 수정';

  @override
  String get about_us_edit_confirm => '수정 확인';

  @override
  String get save => '저장';

  @override
  String get openSourceLicenses => '오픈소스 라이선스';

  @override
  String get openSourceLicensesDescription => '제3자 오픈소스 소프트웨어 라이선스 보기';

  @override
  String get call_login_title => '로그인 필요';

  @override
  String get call_login_content => '로그인하시면 전용 음성 통화 기능을 해제할 수 있습니다!';

  @override
  String get cancel_later => '나중에 하기';

  @override
  String get go_to_login => '로그인하기';

  @override
  String get easter_egg_title => '숨겨진 이스터 에그 발견 ✨';

  @override
  String easter_egg_content(String title) {
    return '당신은 \'$title\'을(를) 발동시켰습니다.\n\n이 특별한 스토리를 사용하시겠습니까?';
  }

  @override
  String get easter_egg_cancel => '사용 안 함';

  @override
  String get easter_egg_confirm => '이스터 에그 사용';

  @override
  String get common_update_success => '수정에 성공했습니다';

  @override
  String get common_update_failed_try_again => '수정에 실패했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get no_voice_available => '현재 보이스가 없습니다';

  @override
  String get gift_insufficient_title => '번화 코인 부족';

  @override
  String get gift_insufficient_prompt => '번화 코인을 더 획득하러 이동하시겠습니까?';

  @override
  String get not_now => '나중에 하기';

  @override
  String get go_to_get => '획득하러 가기';

  @override
  String get status_published => '게시됨';

  @override
  String get monthly_card_success_title => '✨ 프리미엄 월간 카드 해제 성공!';

  @override
  String get monthly_card_success_subtitle => '구독해 주셔서 감사합니다! 전용 혜택이 적용되었습니다:';

  @override
  String get monthly_card_perk_1 => '시간의 꽃 250송이 즉시 획득';

  @override
  String get monthly_card_perk_2 => '매일 로그인 시 시간의 꽃 10송이 추가 수령';

  @override
  String get monthly_card_perk_3 => '전용 호감도 상호작용 횟수 제한 해제';

  @override
  String get monthly_card_start_perks => '혜택 즐기기';

  @override
  String get tip_post_like => '좋아요를 누른 후\n좋아한 콘텐츠에서 확인할 수 있습니다';

  @override
  String get tip_post_bookmark => '저장한 후\n\'내 저장\'에서 확인할 수 있습니다';

  @override
  String get tip_time_echoes => '발자취를 남긴 후\n검색 시 탄막 댓글이 나타납니다';

  @override
  String get tip_call_memory => '통화 후 저장한 보이스는\n여기에 보관됩니다!';

  @override
  String get tip_chat_notifications => '여기에서\n새 알림을 확인할 수 있습니다';

  @override
  String get tip_moments_wall_menu => '여기를 누르면\n캐릭터의 포스트 게시를 예약할 수 있습니다';

  @override
  String get forgot_password => '비밀번호를 잊으셨나요?';

  @override
  String get forgot_password_empty_email =>
      '먼저 이메일을 입력한 후 \'비밀번호를 잊으셨나요?\'를 눌러주세요';

  @override
  String get forgot_password_email_sent =>
      '비밀번호 재설정 이메일이 발송되었습니다. 이메일함을 확인해 주세요';

  @override
  String get forgot_password_error_default =>
      '비밀번호 재설정 이메일 발송에 실패했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get forgot_password_error_invalid_email => '이메일 형식이 올바르지 않습니다';

  @override
  String get forgot_password_error_user_not_found => '이 이메일로 가입된 계정을 찾을 수 없습니다';

  @override
  String forgot_password_error_with_message(String error) {
    return '비밀번호 재설정 이메일 발송 실패: $error';
  }

  @override
  String get terms_not_accepted_toast => '이용약관 및 커뮤니티 가이드라인을 읽고 동의해 주세요';

  @override
  String get terms_content =>
      '연연습광(戀戀拾光)에 오신 것을 환영합니다.\n\n본 서비스를 이용하시기 전에 귀하는 본 이용약관 및 커뮤니티 가이드라인을 준수하는 데 동의하셔야 합니다.\n\n귀하는 불법, 권리 침해, 음란 및 노출, 폭력, 혐오, 괴롭힘, 욕설, 사기, 스팸 메시지 또는 기타 불쾌감을 주거나 공격적이고 타인의 권익을 해치는 콘텐츠를 업로드, 생성, 게시 또는 전송할 수 없습니다.\n\n연연습광은 부적절한 콘텐츠 및 악용 행위에 대해 무관용(Zero-Tolerance) 정책을 적용합니다. 사용자가 규정을 위반하는 경우, 당사는 관련 콘텐츠를 삭제하거나 기능을 제한하고, 계정을 일시 정지 또는 해지할 수 있습니다.\n\n사용자는 앱 내에 내장된 신고 및 차단 기능을 통해 부적절한 콘텐츠나 악용 사용자를 신고할 수 있습니다.';

  @override
  String get community_rules_title => '커뮤니티 가이드라인';

  @override
  String get community_rules_content =>
      '연연습광은 크리에이터와 사용자에게 안전하고 우호적이며 서로를 존중하는 상호작용 환경을 제공하고자 합니다.\n\n당사는 다음과 같은 콘텐츠나 행위를 허용하지 않습니다:\n1. 음란 및 노출 또는 부적절한 성적 암시를 포함한 콘텐츠\n2. 타인을 괴롭히거나 욕설, 따돌림(불링) 또는 위협하는 행위\n3. 혐오, 차별 또는 폭력을 선동하는 행위\n4. 잔혹함, 폭력 또는 위험한 행동을 담은 콘텐츠\n5. 타인의 저작권, 초상권 또는 기타 권리를 침해하는 행위\n6. 스팸, 사기 또는 악의적인 행위\n7. 기타 불쾌감을 주거나 공개적으로 표시하기에 부적절한 콘텐츠\n\n사용자는 부적절한 콘텐츠를 신고할 수 있으며, 악용 사용자를 차단할 수도 있습니다. 차단 후에는 해당 사용자의 콘텐츠가 귀하의 화면에 더 이상 표시되지 않습니다.';

  @override
  String get block_self_error => '자신의 콘텐츠는 차단할 수 없습니다';

  @override
  String get block_user_title => '이 사용자를 차단하시겠습니까?';

  @override
  String get block_user_content =>
      '차단하면 이 사용자가 게시한 콘텐츠를 더 이상 볼 수 없습니다.\n저희 측에도 알림이 전송되어 검토가 진행됩니다.';

  @override
  String get block_user_success => '해당 사용자가 차단되었으며, 관련 콘텐츠가 당신의 타임월에서 삭제되었습니다';

  @override
  String get block_user_failed => '차단에 실패했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get terms_checkbox_read_agree => '본인은 ';

  @override
  String get terms_checkbox_terms => '《이용약관》';

  @override
  String get terms_checkbox_and => '및';

  @override
  String get terms_checkbox_rules => '《커뮤니티 가이드라인》을 읽었으며 이에 동의합니다';

  @override
  String get hidden_moments => '숨겨진 순간';

  @override
  String get hide_moment_title => '이 순간을 숨기시겠습니까?';

  @override
  String get hide_moment_content => '숨긴 후에는 이 포스트가 당신의 타임월에 더 이상 표시되지 않습니다.';

  @override
  String get hide => '숨기기';

  @override
  String get hide_moment_success => '이 순간을 숨겼습니다';

  @override
  String get hide_moment_failed => '숨기기에 실패했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get block_character_not_found => '캐릭터 데이터를 찾을 수 없어 차단할 수 없습니다';

  @override
  String get block_character_title => '이 캐릭터를 차단하시겠습니까?';

  @override
  String block_character_content(String authorName) {
    return '차단하면 「$authorName」이(가) 게시한 순간들을 더 이상 볼 수 없습니다. 해당 콘텐츠가 규정 위반에 해당하는 경우, 저희 측에도 알림이 전송되어 검토가 진행됩니다.';
  }

  @override
  String block_character_success(String authorName) {
    return '「$authorName」을(를) 차단했으며, 관련 순간들이 숨겨졌습니다';
  }

  @override
  String get block_character_failed => '차단에 실패했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get hidden_moments_title => '숨겨진 순간';

  @override
  String get hidden_moments_empty => '현재 숨겨진 순간이 없습니다';

  @override
  String get hidden_moments_load_failed => '숨겨진 순간을 불러오는 데 실패했습니다';

  @override
  String get hidden_moment_unknown_author => '알 수 없는 캐릭터';

  @override
  String get hidden_moment_no_preview => '이 포스트에는 미리 볼 수 있는 내용이 없습니다';

  @override
  String get unhide_moment_title => '숨기기 해제?';

  @override
  String get unhide_moment_content =>
      '해제 후 해당 포스트가 여전히 존재한다면, 향후 당신의 타임월에 다시 표시될 수 있습니다.';

  @override
  String get unhide_moment_action => '숨기기 해제';

  @override
  String get unhide_moment_success => '숨기기가 해제되었습니다';

  @override
  String get report_moment_title => '이 순간 신고하기';

  @override
  String get report_moment_content =>
      '이 순간을 관리팀에 신고하시겠습니까? 악성 콘텐츠는 숨김 처리되거나 삭제됩니다.';

  @override
  String get report_confirm_button => '신고 확인';

  @override
  String get report_success_message =>
      '신고가 접수되었습니다. 검토팀에서 신속하게 확인 후 처리해 드리겠습니다.';

  @override
  String get accountDeletionSubmittedTitle => '계정 삭제 요청 제출 완료';

  @override
  String get accountDeletionSubmittedContent =>
      '네, 알겠습니다! 계정 삭제 유예 기간 3일이 제공됩니다.\n\n계정 삭제를 취소하고 싶다면 해당 기간 내에 다시 로그인하기만 하면 계정이 복구됩니다.';

  @override
  String get restoreAccountDialogTitle => '계정 삭제 요청';

  @override
  String get restoreAccountDialogContent =>
      '현재 계정이 삭제 대기 중입니다.\n\n로그인을 계속하시면 삭제 요청이 취소되고 계정이 복구됩니다.';

  @override
  String get cancelLoginButton => '로그인 취소';

  @override
  String get restoreAccountButton => '계정 복구';

  @override
  String get voice_preview => '보이스 재생';

  @override
  String get voice_preview_failed => '보이스 재생 실패';

  @override
  String get characterBannerSectionTitle => '캐릭터 홈 배너';

  @override
  String get characterBannerDescription => '배너 설명';

  @override
  String get characterBannerRemove => '제거';

  @override
  String get characterBannerSelect => '배너 이미지 선택';

  @override
  String get characterBannerChange => '배너 이미지 변경';

  @override
  String get characterBannerSpecs => '권장 비율 16:9, 권장 크기 1920 × 1080';

  @override
  String get characterBannerDefaultHint =>
      '설정하지 않으면 홈 화면에 캐릭터의 메인 이미지가 자동으로 사용됩니다.';

  @override
  String get characterBannerHelpContent =>
      '배너는 캐릭터 홈의 대형 가로 영역에 표시됩니다.\n\n16:9 가로 이미지(예: 1920 × 1080)를 사용하는 것을 권장합니다.\n\n주요 인물과 얼굴은 화면 중앙에 배치하여 기기 화면 크기에 따라 잘리지 않도록 해주세요.\n\n배너를 설정하지 않으면 시스템이 자동으로 캐릭터의 메인 이미지를 적용합니다.';

  @override
  String get first_meeting_title => '첫 만남';

  @override
  String get common_delete_network_failed => '삭제 실패. 네트워크 연결을 확인한 후 다시 시도해 주세요';

  @override
  String get common_operation_failed_retry => '작업 실패. 잠시 후 다시 시도해 주세요';

  @override
  String exclusive_photo_number(int number) {
    return '전용 사진 $number';
  }

  @override
  String get unlock_after_affection_increase => '호감도 레벨 상승 후 해제';

  @override
  String get first_meeting_empty => '첫 만남, 아직 시작되지 않았습니다...';

  @override
  String photo_load_failed(String error) {
    return '사진 불러오기 실패: $error';
  }

  @override
  String get add_friend_failed_retry => '친구 추가 실패. 잠시 후 다시 시도해 주세요.';

  @override
  String get remove_friend => '친구 삭제';

  @override
  String get report_character => '캐릭터 신고';

  @override
  String get block_character => '캐릭터 차단';

  @override
  String get daily_encounter => '매일의 만남';

  @override
  String get discovery_hall => '탐색 홀';

  @override
  String get latest_recommendation => '최신 추천';

  @override
  String get popular_ranking => '인기 순위';

  @override
  String get character_features => '캐릭터 특징';

  @override
  String get featured_new_star => '빛나는 신성 · 강력 추천';

  @override
  String get recently_added_characters => '최근 등록된 신규 캐릭터';

  @override
  String get no_tag_data => '현재 태그 데이터가 없습니다~';

  @override
  String get no_character_with_tag => '이 태그를 가진 캐릭터를 찾을 수 없습니다';

  @override
  String get voice_search_failed_retry => '음성 검색 실패. 다시 시도해 주세요';

  @override
  String get voice_search_incomplete_retry => '검색 미완료. 잠시 후 다시 시도해 주세요';

  @override
  String get voice_data_incomplete => '음성 데이터가 불완전합니다';

  @override
  String get voice_generation_failed_retry => '음성 생성 실패. 잠시 후 다시 시도해 주세요';

  @override
  String get voice_playback_failed_retry => '음성 재생 실패. 다시 시도해 주세요';

  @override
  String get selected_voice_data_incomplete => '선택한 음성 데이터가 불완전합니다';

  @override
  String get private_voice_user_not_found =>
      '사용자를 찾을 수 없습니다. 비공개 캐릭터 음성을 업데이트할 수 없습니다';

  @override
  String get voice_selected_character_save_failed =>
      '음성은 선택되었으나 캐릭터 데이터 저장에 실패했습니다';

  @override
  String get voice_binding_failed => '음성 바인딩 실패';

  @override
  String get play_voice_tooltip => '보이스 재생';

  @override
  String get avatar_label => '프로필 이미지';

  @override
  String get message_preview_image => '[사진]';

  @override
  String get message_preview_recording => '[녹음]';

  @override
  String get message_preview_voice => '[음성 메시지]';

  @override
  String get send_failed_retry => '전송 실패. 잠시 후 다시 시도해 주세요 😢';

  @override
  String get media_upload_failed_retry => '미디어 업로드 실패. 다시 시도해 주세요';

  @override
  String get ai_thinking_too_long => '그가 깊은 생각에 잠긴 것 같습니다. 잠시 후 다시 시도해 주세요...';

  @override
  String get ai_reply_in_progress => '답장 중입니다. 중복 전송하지 말고 잠시만 기다려 주세요';

  @override
  String get ai_response_blocked => '그의 생각이 산만해졌습니다. 조금 더 다정한 표현으로 말해 보세요!';

  @override
  String get microphone_permission_required => '녹음하려면 마이크 권한이 필요합니다';

  @override
  String get no_recording_to_send => '전송할 녹음 파일이 없습니다';

  @override
  String get voice_uploading => '음성 메시지 업로드 중...';

  @override
  String get change_watermark_color => '워터마크 색상 변경';

  @override
  String get other_party_typing => '상대방이 입력 중입니다...';

  @override
  String get chat_input_hint => '메시지를 입력하세요...';

  @override
  String get regenerate_sync_failed => '재생성 횟수 동기화 실패. 다시 시도해 주세요 😢';

  @override
  String get creator_public_works => '공개 작품';

  @override
  String get creator_received_likes => '받은 좋아요';

  @override
  String get about_me => '자기소개';

  @override
  String get moment_input_hint => '당신의 마음을 공유하세요...';

  @override
  String character_play_count(int count) {
    return '플레이 횟수: $count';
  }

  @override
  String tag_page_title(String tag) {
    return '태그: #$tag';
  }

  @override
  String voice_preview_failed_detail(String code, String message) {
    return '음성 미리듣기 실패: $code $message';
  }

  @override
  String messages_deleted_success(int count) {
    return '$count개의 메시지를 성공적으로 삭제했습니다';
  }

  @override
  String creator_work_load_failed(String error) {
    return '작품 불러오기 실패: $error';
  }

  @override
  String age_years_old(String age) {
    return '$age세';
  }

  @override
  String deleteFailedMessage(String error) {
    return '삭제 실패: $error';
  }

  @override
  String loadCharacterDataFailed(String error) {
    return '캐릭터 데이터 로드 실패: $error';
  }

  @override
  String get draftAvatarLoadFailed => '임시 저장 프로필 로드 실패:';

  @override
  String get unnamedCreator => '이름 없는 크리에이터';

  @override
  String get profileNotYetFilled => '자기소개가 아직 작성되지 않았습니다';

  @override
  String get reportImageSizeLimit => '이미지 크기는 10 MB를 초과할 수 없습니다';

  @override
  String reportImageSelectFailed(String error) {
    return '신고 이미지 선택 실패: $error';
  }

  @override
  String get reportImageCannotSelect => '이미지를 선택할 수 없습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get reportLoginRequired => '신고서를 제출하기 전에 먼저 로그인해 주세요';

  @override
  String get reportAnonymousPlayer => '이름 없는 플레이어';

  @override
  String get reportSendSuccess => '신고가 성공적으로 제출되었습니다. 소중한 의견 감사합니다!';

  @override
  String reportSendFailed(String error) {
    return '플레이어 신고 제출 실패: $error';
  }

  @override
  String get reportNetworkFailed => '전송 실패. 네트워크를 확인한 후 다시 시도해 주세요';

  @override
  String get reportAttachImageLabel => '이미지 첨부 (선택 사항)';

  @override
  String get reportAttachImageHint =>
      '버그 신고나 재화 미지급 문의 시, 화면 스크린샷을 첨부하시면 빠른 확인에 도움이 됩니다.';

  @override
  String get reportOpeningAlbum => '앨범 열기 중...';

  @override
  String get reportSelectFromAlbum => '앨범에서 이미지 선택';

  @override
  String get reportSending => '제출 중...';

  @override
  String get reportSubmit => '신고 제출';

  @override
  String get reportRemoveImage => '이미지 제거';

  @override
  String get reportImageSelected => '이미지 선택됨';

  @override
  String get reportChangeImage => '변경';

  @override
  String get reloadTranslation => '번역 다시 불러오기';

  @override
  String get guideNotAvailableInLanguage =>
      '현재 이 언어의 이용 가이드가 제공되지 않아 임시로 번체 중국어로 표시됩니다.';

  @override
  String get clearSearch => '검색어 지우기';

  @override
  String get memoPermissionWarning =>
      '알림 권한이 활성화되지 않았습니다. 메모는 저장되지만 시스템 알림은 표시되지 않습니다.';

  @override
  String memoSavedWithNotification(String name) {
    return '메모가 저장되었습니다! $name이(가) 알려드릴게요!';
  }

  @override
  String get memoSavedNoPermission => '메모가 저장되었으나 알림 권한이 설정되어 있지 않습니다.';

  @override
  String memoUpdatedWithNotification(String name) {
    return '메모가 수정되었습니다! $name이(가) 알려드릴게요!';
  }

  @override
  String get memoUpdatedNoPermission => '메모가 수정되었으나 현재 알림 권한이 없습니다.';

  @override
  String dataLoadError(String error) {
    return '데이터를 불러오는 중 오류가 발생했습니다: $error';
  }

  @override
  String loadFailed(String error) {
    return '불러오기 실패: $error';
  }

  @override
  String get dateFormatMonthDay => 'M월 d일';

  @override
  String get timeFormatHourMinute => 'HH:mm';

  @override
  String get likeFeedPrompt => '이 포스트가 마음에 드시나요? 마음을 표현해 보세요!';

  @override
  String get saveFeedPocket => '특별한 포스트를 마음속 주머니에 살며시 담아두세요.';

  @override
  String get newComment => '새 댓글';

  @override
  String get someFriend => '어느 친구';

  @override
  String get myBackpackAndPrivileges => '내 인벤토리 & 특권';

  @override
  String get currentRomanticBond => '현재 누적된 로맨틱 인연';

  @override
  String get physicalGiftBoxUnlockStatus => '실물 기프트 박스 해제 상태:';

  @override
  String get topLovePhysicalVipBox => '【최고의 지애】 실물 VIP 전용 기프트 박스';

  @override
  String get physicalGiftBoxContents => '구성: 전용 손편지 + 캐릭터 인형 + 공식 감사 편지';

  @override
  String get modifyShippingAddress => '배송지 정보 수정';

  @override
  String get addressUnlockedFillNow => '해제 완료! 배송지 정보를 입력하려면 클릭하세요';

  @override
  String get addressSuccessfullyRegistered =>
      '배송지가 성공적으로 등록되었습니다. 빠르게 준비해 드리겠습니다!';

  @override
  String amountNeededForPhysicalPrize(String amount) {
    return '실물 대상을 해제하려면 NT\$ $amount 남았습니다!';
  }

  @override
  String get avatarFrameHint =>
      '힌트: 기타 디지털 외형 및 테두리는 상점이나 개인 설정에서 확인하고 착용할 수 있습니다.';

  @override
  String get closeButton => '닫기';

  @override
  String get physicalGiftBoxUnlockTitle => '【최고의 지애】 실물 기프트 박스 해제';

  @override
  String get physicalGiftBoxUnlockThanks => '《연연습광》에 대한 변함없는 사랑에 감사드립니다!';

  @override
  String get physicalGiftBoxUnlockPrompt =>
      '전용 손편지와 인형을 발송해 드릴 수 있도록 아래 배송지 정보를 입력해 주세요:';

  @override
  String get recipientRealName => '수령인 실명';

  @override
  String get contactPhone => '연락처';

  @override
  String get fullShippingAddress => '상세 배송지 주소 (우편번호 포함)';

  @override
  String get desiredCharacterDollName => '받고 싶은 캐릭터 인형 이름';

  @override
  String get characterNameExample => '예: 희망하는 캐릭터 이름';

  @override
  String get fillLater => '나중에 입력';

  @override
  String get fillCompleteAddressAndRoleHint =>
      '배송지 정보와 희망하는 캐릭터 이름을 모두 작성해 주세요!';

  @override
  String get shippingInfoSubmittedSuccess =>
      '배송지 정보가 정상적으로 제출되었습니다! 실물 깜짝 선물을 기대해 주세요!';

  @override
  String get confirmSubmit => '확인 및 제출';

  @override
  String get aboutMe => '자기소개';

  @override
  String get myBackpack => '내 인벤토리';

  @override
  String get ownerExclusiveArea => '마스터 전용 구역';

  @override
  String get enterShiguangAdminBackend => '연연습광 관리자 콘솔 입장';

  @override
  String get errorOccurred => '오류가 발생했습니다';

  @override
  String get creatorGuidelines => '크리에이터 가이드라인';

  @override
  String get playGuide => '이용 가이드';

  @override
  String get lianlianShiguang => '연연습광';

  @override
  String get copyrightNotice => '© 2026 Mo Yu Bai';

  @override
  String get cumulativeBenefits => '누적 혜택';

  @override
  String get perkFirstEncounter => '첫눈의 설렘';

  @override
  String get perkFirstEncounterReward => '시간의 꽃 20송이 + 전용 초보자 칭호';

  @override
  String get perkGlimmerThrob => '미광의 두근거림';

  @override
  String get perkGlimmerThrobReward => '전용 프로필 테두리 【미광의 두근거림】';

  @override
  String get perkStarryWhisper => '별빛 속삭임';

  @override
  String get perkStarryWhisperReward => '전용 채팅 말풍선 + 시간의 꽃 50송이';

  @override
  String get perkRomanticSunset => '낭만 노을';

  @override
  String get perkRomanticSunsetReward => '전용 App 바탕화면 아이콘';

  @override
  String get perkHeartbeat => '심장 두근거림';

  @override
  String get perkHeartbeatReward => '화면 터치 이펙트 + 시간의 꽃 100송이';

  @override
  String get perkEternalVow => '영원한 서약';

  @override
  String get perkEternalVowReward => '고급 움직이는 프로필 테두리 + 시간의 꽃 200송이';

  @override
  String get perkSoulIntersection => '영혼의 교차';

  @override
  String get perkSoulIntersectionReward => '움직이는 채팅 말풍선 이펙트 + 전용 상급 칭호';

  @override
  String get perkExclusiveWait => '전용의 기다림';

  @override
  String get perkExclusiveWaitReward => '최고급 움직이는 네임패드 + 시간의 꽃 500송이';

  @override
  String get perkBrilliantGalaxy => '찬란한 은하';

  @override
  String get perkBrilliantGalaxyReward => '전용 입장 이펙트 + 전용 고객센터';

  @override
  String get perkTopBeloved => '최고의 지애';

  @override
  String get perkTopBelovedReward => '실물 VIP 전용 기프트 박스';

  @override
  String get cumulativeRomanticBond => '누적 로맨틱 인연';

  @override
  String get allTopPrivilegesUnlocked => '모든 최고급 특권을 해제하셨습니다!';

  @override
  String rechargeAmountForNextTier(String amount) {
    return 'NT\$ $amount 추가 충전 시 다음 단계 해제';
  }

  @override
  String get storyContentCannotBeEmpty => '스토리 내용은 비워둘 수 없습니다';

  @override
  String get writeYourStoryHint => '둘만의 이야기를 작성해 보세요...';

  @override
  String get characterBannerTitle => '캐릭터 홈 배너';

  @override
  String get mailDeleteTitle => '메일 삭제';

  @override
  String mailDeleteConfirm(int count) {
    return '메일 $count개를 삭제하시겠습니까?\n삭제 후에는 복구할 수 없습니다.';
  }

  @override
  String mailDeleteSuccess(int count) {
    return '메일 $count개를 삭제했습니다';
  }

  @override
  String get mailDeleteFailed => '삭제하지 못했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get mailCancelSelection => '선택 취소';

  @override
  String mailSelectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get moreOptions => '더보기';

  @override
  String mailDeleteSelected(int count) {
    return '메일 $count개 삭제';
  }

  @override
  String get officialManagementTeam => 'LoveyDovey 운영팀';

  @override
  String get rewardCampaignTitle => '이벤트 선물';

  @override
  String get rewardCampaignMissingData =>
      '이 선물 메일에 이벤트 데이터가 없습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String rewardCampaignClaimSuccess(int amount) {
    return '꽃 $amount개를 받았습니다';
  }

  @override
  String get rewardCampaignAlreadyClaimed => '이미 받은 선물입니다';

  @override
  String get rewardCampaignClaimFailed => '받지 못했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get rewardCampaignContains => '이 메일에는';

  @override
  String rewardCampaignFlowerAmount(int amount) {
    return '꽃 $amount개';
  }

  @override
  String rewardCampaignDeadline(String date) {
    return '수령 기한: $date';
  }

  @override
  String get rewardCampaignClaiming => '받는 중…';

  @override
  String get rewardCampaignClaimed => '수령 완료';

  @override
  String get rewardCampaignEnded => '이벤트가 종료되었습니다';

  @override
  String get rewardCampaignClaimButton => '선물 받기';

  @override
  String get mailDetailTitle => '메일';

  @override
  String mailSender(String name) {
    return '보낸 사람: $name';
  }

  @override
  String get mailCaseNumber => '문의 번호';

  @override
  String get mailCopyCaseNumber => '문의 번호 복사';

  @override
  String get mailCaseNumberCopied => '문의 번호가 복사되었습니다';

  @override
  String get profilePageAboutMe => '📝 내 소개';

  @override
  String get profilePageTabBio => '자기소개';

  @override
  String get profilePageTabCharacters => '캐릭터';

  @override
  String get profilePageTabMoments => '게시물';

  @override
  String get profilePageEditProfile => '프로필 편집';

  @override
  String get profilePageFriends => '친구';

  @override
  String get profilePageWorks => '작품';

  @override
  String get profilePageFollowing => '팔로잉';

  @override
  String get profilePageFollowers => '팔로워';

  @override
  String get profilePageHeartbeatDiary => '두근두근 일기';

  @override
  String get profilePageEditCharacter => '캐릭터 편집';

  @override
  String get profilePagePreviewCharacter => '캐릭터 프로필 미리 보기';

  @override
  String get profilePageNoBio => '아직 자기소개가 없습니다';

  @override
  String get profilePageNoBioHint => '눌러서 자기소개를 작성해 보세요.';

  @override
  String get profilePageCreateCharacter => '새 캐릭터 만들기';

  @override
  String get profilePageNoCharacters => '아직 만든 캐릭터가 없습니다';

  @override
  String get profilePageNoCharactersHint => '첫 번째 캐릭터를 만들어 보세요.';

  @override
  String get profilePageCharacterActions => '캐릭터 작업';

  @override
  String get profilePagePublic => '공개';

  @override
  String get profilePagePrivate => '비공개';

  @override
  String get profilePageCreator => '크리에이터';

  @override
  String get profilePageSelectPostingIdentity => '게시할 신분 선택';

  @override
  String get profilePagePostAsCreator => '크리에이터 본인으로 게시';

  @override
  String get profilePagePublicCharacter => '공개 캐릭터';

  @override
  String get profilePagePrivateCharacter => '비공개 캐릭터';

  @override
  String get profilePagePleaseSignIn => '먼저 로그인해 주세요';

  @override
  String get profilePagePublishMoment => '게시물 등록';

  @override
  String get profilePageFilterAll => '전체';

  @override
  String get profilePageFilterCreator => '본인';

  @override
  String get profilePageFilterCharacter => '캐릭터';

  @override
  String get profilePageMomentsLoadFailed => '게시물을 불러오지 못했습니다';

  @override
  String get profilePageTryAgainLater => '잠시 후 다시 시도해 주세요.';

  @override
  String get profilePageNoCreatorMoments => '아직 본인이 게시한 게시물이 없습니다';

  @override
  String get profilePageNoCreatorMomentsHint =>
      '크리에이터 신분으로 게시한 콘텐츠가 여기에 표시됩니다.';

  @override
  String get profilePageNoCharacterMoments => '아직 캐릭터가 게시한 게시물이 없습니다';

  @override
  String get profilePageNoCharacterMomentsHint =>
      '캐릭터 신분으로 게시한 콘텐츠가 여기에 표시됩니다.';

  @override
  String get profilePageNoMoments => '아직 게시물이 없습니다';

  @override
  String get profilePageNoMomentsHint => '본인과 캐릭터가 게시한 콘텐츠가 여기에 표시됩니다.';

  @override
  String get profilePageDeleteMomentTitle => '게시물 삭제';

  @override
  String get profilePageDeleteMomentConfirm => '이 게시물을 영구적으로 삭제하시겠습니까?';

  @override
  String get profilePageCancel => '취소';

  @override
  String get profilePageDelete => '삭제';

  @override
  String get profilePageMomentDeleted => '게시물이 삭제되었습니다';

  @override
  String get profilePageDeleteFailed => '삭제하지 못했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get profilePageReferralCompleted => '별의 초대가 완료되었습니다';

  @override
  String profilePageInviter(String inviterId) {
    return '초대한 사람: $inviterId';
  }

  @override
  String get profilePageReferralRewardReceived => '양쪽 모두 꽃 50개를 받았습니다';

  @override
  String get profilePageClaimed => '수령 완료';

  @override
  String profilePageInviterBound(String inviterId) {
    return '초대한 사람이 등록되었습니다: $inviterId';
  }

  @override
  String get profilePageReferralProgressHint =>
      '채팅 메시지 15개를 완료하면 양쪽 모두 꽃 50개씩 받습니다';

  @override
  String get profilePageAlreadyCheckedIn => '오늘은 이미 출석 체크를 했습니다';

  @override
  String get profilePageReferralBindFailed => '등록하지 못했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get profilePageCharacterNotFound => '이 캐릭터의 데이터를 찾을 수 없습니다';

  @override
  String get periodGuideTitle => '생리 일기는 어떻게 사용하나요?';

  @override
  String get periodGuideContent =>
      '① 먼저 달력에서 날짜를 선택하세요.\n② ‘오늘 시작했어요’, ‘아직 생리 중이에요’ 또는 ‘오늘 끝났어요’를 선택하세요.\n③ 오늘의 기분과 몸 상태를 선택하세요. 직접 내용을 추가할 수도 있습니다.\n④ 저장을 누르면 채팅할 때 캐릭터가 오늘의 상태를 이해할 수 있습니다.\n\n예상 날짜는 이전 기록에 따라 조정되며, 일상 기록을 위한 참고용으로만 제공됩니다.';

  @override
  String get periodGotIt => '알겠어요';

  @override
  String get periodSelectAtLeastOne => '기록할 항목을 하나 이상 선택해 주세요';

  @override
  String get periodFutureDateError => '미래 날짜에는 생리 상태를 표시할 수 없습니다.';

  @override
  String get periodAlreadyOngoingError =>
      '이미 진행 중인 생리 기록이 있습니다. 먼저 해당 기록을 종료해 주세요.';

  @override
  String get periodNoOngoingError =>
      '현재 진행 중인 생리 기록이 없습니다. 먼저 ‘오늘 시작했어요’를 선택해 주세요.';

  @override
  String get periodBeforeStartError => '이번 생리 시작일보다 이전 날짜를 선택할 수 없습니다.';

  @override
  String get periodEndBeforeStartError => '종료일은 시작일보다 빠를 수 없습니다.';

  @override
  String periodRecordSaved(String date) {
    return '$date의 기록을 저장했습니다';
  }

  @override
  String get periodSaveFailed => '저장하지 못했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get periodDeleteTitle => '이번 생리 기록을 삭제할까요?';

  @override
  String get periodDeleteContent => '삭제하면 평균 주기와 다음 예상일도 다시 계산됩니다.';

  @override
  String get periodCancel => '취소';

  @override
  String get periodDelete => '삭제';

  @override
  String get periodNoOngoing => '현재 진행 중인 생리 기록이 없습니다';

  @override
  String periodDayCount(int count) {
    return '생리 $count일째';
  }

  @override
  String get periodHelp => '사용 방법';

  @override
  String get periodAverageCycle => '평균 주기';

  @override
  String get periodAverageDuration => '평균 생리 기간';

  @override
  String periodDays(int count) {
    return '$count일';
  }

  @override
  String get periodNextPrediction => '다음 예상일';

  @override
  String get periodCalculatedAfterRecording => '기록 후 계산';

  @override
  String get periodInsufficientData =>
      '현재 데이터가 부족하여 임시로 28일 주기와 5일의 생리 기간을 기준으로 예상합니다.';

  @override
  String get periodPredictionDisclaimer =>
      '현재 기록을 기반으로 예상한 날짜이며, 일상 기록을 위한 참고용으로만 제공됩니다.';

  @override
  String get periodStartedToday => '🩸 오늘 시작했어요';

  @override
  String get periodStillOngoing => '아직 생리 중이에요';

  @override
  String get periodEndedToday => '오늘 끝났어요';

  @override
  String get periodDateNotReached => '아직 오지 않은 날이에요～';

  @override
  String get periodDateBeforeStart => '이 날짜는 현재 생리 시작일보다 이전입니다.';

  @override
  String get periodMoodOkay => '괜찮아요';

  @override
  String get periodMoodHappy => '행복해요';

  @override
  String get periodMoodLow => '우울해요';

  @override
  String get periodMoodUnwell => '힘들어요';

  @override
  String get periodMoodIrritable => '짜증 나요';

  @override
  String get periodMoodTired => '피곤해요';

  @override
  String get periodMoodAnxious => '불안해요';

  @override
  String get periodSymptomAbdominalPain => '복통';

  @override
  String get periodSymptomLowerBackPain => '허리 통증';

  @override
  String get periodSymptomHeadache => '두통';

  @override
  String get periodSymptomBreastTenderness => '가슴 통증';

  @override
  String get periodSymptomSwelling => '부종';

  @override
  String get periodSymptomSleepy => '졸림';

  @override
  String get periodSymptomIncreasedAppetite => '식욕 증가';

  @override
  String get periodSymptomDigestiveDiscomfort => '소화 불편';

  @override
  String periodDiaryTitle(String characterName) {
    return '$characterName의 다정한 일기';
  }

  @override
  String get periodLoadFailed => '기록을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get periodWeekdaySun => '일';

  @override
  String get periodWeekdayMon => '월';

  @override
  String get periodWeekdayTue => '화';

  @override
  String get periodWeekdayWed => '수';

  @override
  String get periodWeekdayThu => '목';

  @override
  String get periodWeekdayFri => '금';

  @override
  String get periodWeekdaySat => '토';

  @override
  String get periodSaveInstruction =>
      '상태를 선택한 후 맨 아래의 ‘오늘의 기록 저장’을 눌러야 정상적으로 저장됩니다.';

  @override
  String get periodTodayMood => '오늘의 기분(복수 선택 가능)';

  @override
  String get periodMoodDescription => '해당 날짜의 일기 항목이며 달력에 표시되는 아이콘이 아닙니다.';

  @override
  String get periodOtherMood => '다른 기분';

  @override
  String get periodOtherMoodHint => '예: 서운함, 불안함……';

  @override
  String get periodTodaySymptoms => '오늘의 몸 상태(복수 선택 가능)';

  @override
  String get periodOtherSymptom => '다른 몸 상태';

  @override
  String get periodOtherSymptomHint => '예: 추위를 느낌, 입맛이 없음……';

  @override
  String periodNoteForCharacter(String characterName) {
    return '$characterName에게 알려주고 싶은 내용(선택 사항)';
  }

  @override
  String get periodNoteHint => '예: 오늘은 조용히 쉬고 싶으니 재촉하지 않았으면 좋겠어……';

  @override
  String get periodSaving => '저장 중…';

  @override
  String get periodSaveToday => '오늘의 기록 저장';

  @override
  String get periodHistory => '생리 기록';

  @override
  String get periodOngoing => '진행 중';

  @override
  String periodTotalDays(int count) {
    return '총 $count일';
  }

  @override
  String get periodDeleteRecord => '기록 삭제';

  @override
  String get privateProfilePleaseSignIn => '먼저 로그인해 주세요';

  @override
  String privateProfileLoreLoadFailed(String error) {
    return '기억 조각을 불러오지 못했습니다: $error';
  }

  @override
  String privateProfileWriteNewLore(int count, int limit) {
    return '새 기억 조각 작성 ($count / $limit)';
  }

  @override
  String get privateProfileNoLore => '아직 기억 조각이 없습니다';

  @override
  String get privateProfileNoLoreHint =>
      '여기에서 테스트 설정, 이야기의 단서와 캐릭터의 중요한 기억을 정리할 수 있습니다.';

  @override
  String get privateProfileUntitledLore => '제목 없는 조각';

  @override
  String get privateProfileEdit => '편집';

  @override
  String get privateProfileDelete => '삭제';

  @override
  String get privateProfileAddLore => '기억 조각 추가';

  @override
  String get privateProfileLoreTitle => '제목';

  @override
  String get privateProfileLoreTeaser => '간단한 힌트';

  @override
  String get privateProfileLoreContent => '전체 내용';

  @override
  String get privateProfileLockLore => '조각 잠금';

  @override
  String get privateProfileLockLoreHint =>
      '비공개 캐릭터는 현재 크리에이터만 볼 수 있습니다. 캐릭터를 공개한 후에도 사용할 수 있도록 이 항목은 유지됩니다.';

  @override
  String get privateProfileCancel => '취소';

  @override
  String get privateProfileTitleContentRequired => '제목과 내용을 입력해 주세요';

  @override
  String get privateProfileLoreAdded => '기억 조각이 추가되었습니다';

  @override
  String get privateProfileAddFailed => '추가하지 못했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get privateProfilePublish => '공개';

  @override
  String get privateProfileDeleteLoreTitle => '기억 조각 삭제';

  @override
  String get privateProfileDeleteLoreConfirm => '이 기억 조각을 영구적으로 삭제하시겠습니까?';

  @override
  String get privateProfileLoreDeleted => '기억 조각이 삭제되었습니다';

  @override
  String get privateProfileDeleteFailed => '삭제하지 못했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get privateProfileEditLore => '기억 조각 편집';

  @override
  String get privateProfileSave => '저장';

  @override
  String get editProfileBirthdayReminderTitle => '🎂 잠깐 알려드려요';

  @override
  String get editProfileBirthdayReminderContent =>
      '생일은 캐릭터의 생일 축하, 생일 선물 및 관련 이벤트에 영향을 줍니다.\n\n향후 생일 보상에 영향을 주지 않도록\n생일을 확인한 후 설정을 완료하는 것을 권장합니다.';

  @override
  String get editProfileGotIt => '알겠어요';

  @override
  String get editProfileBirthdayConfirmTitle => '🎂 생일 확인';

  @override
  String get editProfileBirthdayConfirmContent =>
      '생일이 정확한지 확인해 주세요.\n\n생일은 생일 축하, 생일 선물 및 관련 이벤트에 사용됩니다.\n\n생일 보상의 중복 수령을 방지하기 위해 설정을 완료한 후에는 생일을 다시 변경할 수 없습니다.\n\n이 생일을 사용하시겠습니까?';

  @override
  String get editProfileReturnToEdit => '수정으로 돌아가기';

  @override
  String get editProfileConfirmSetting => '설정 확인';

  @override
  String get editProfileDefaultNickname => '처음 만난 여행자';

  @override
  String get editProfileNoChanges => '저장할 변경 사항이 없습니다';

  @override
  String editProfileCreateFailed(String error) {
    return '데이터를 생성하지 못했습니다: $error';
  }

  @override
  String editProfileAvatarNumber(int number) {
    return '프로필 이미지 $number';
  }

  @override
  String get editProfileImageSelectionFailed =>
      '이미지를 선택하지 못했습니다. 다른 이미지를 선택해 주세요';

  @override
  String get editProfileCancel => '취소';

  @override
  String get editProfileConfirm => '확인';

  @override
  String get editProfileImageProcessingFailed =>
      '이미지를 처리하지 못했습니다. 다른 이미지를 선택해 주세요';

  @override
  String editProfileLoadFailed(String error) {
    return '데이터를 불러오지 못했습니다: $error';
  }

  @override
  String get editProfileBioLabel => '자기소개';

  @override
  String get editProfileBioHelper => '본인이나 창작 스타일을 간단히 소개해 주세요';

  @override
  String get editProfileBioHint => '예: 판타지, 집착형, 몰입형 연애 캐릭터를 만드는 것을 좋아합니다.';

  @override
  String get editProfileUserNotFound => '사용자를 찾을 수 없습니다';

  @override
  String get editProfileGenerateIdFailed => '플레이어 ID를 생성하지 못했습니다. 다시 시도해 주세요';

  @override
  String get editProfileSignedInUserNotFound => '현재 로그인한 사용자를 찾을 수 없습니다';

  @override
  String editProfileAvatarReadFailed(int statusCode) {
    return '프로필 이미지를 불러오지 못했습니다. 상태 코드: $statusCode';
  }

  @override
  String editProfileAvatarFileNotFound(String path) {
    return '선택한 프로필 이미지 파일을 찾을 수 없습니다: $path';
  }

  @override
  String get editProfileAvatarEmpty => '프로필 이미지 데이터가 비어 있습니다';

  @override
  String get chatPageSendFailed => '전송하지 못했습니다. 잠시 후 다시 시도해 주세요 😢';

  @override
  String get chatPageRegenerateFailed =>
      '다시 생성하지 못했습니다. 기존 메시지는 유지되었습니다. 다시 시도해 주세요.';

  @override
  String get chatPageRegenerating => '💭 다시 생각하는 중...';

  @override
  String get chatPageThinkingTooLong => '생각에 잠긴 것 같아요. 잠시 후 다시 시도해 주세요……';

  @override
  String get chatPageAlreadyReplying => '답변 중입니다. 잠시 기다려 주시고 중복으로 전송하지 마세요';

  @override
  String get chatPageMediaUploadFailed => '미디어를 업로드하지 못했습니다. 다시 시도해 주세요';

  @override
  String get chatPageReportReceived => '신고해 주셔서 감사합니다. 최대한 빨리 확인하겠습니다';

  @override
  String chatPageMessagesDeleted(int count) {
    return '✅ 메시지 $count개를 삭제했습니다';
  }

  @override
  String chatPageSelectPhotoFailed(String error) {
    return '사진을 선택할 수 없습니다: $error';
  }

  @override
  String get chatPageRecordingNotFound => '녹음 파일을 찾을 수 없습니다';

  @override
  String get chatPageRecordingEmpty => '녹음 파일이 비어 있습니다';

  @override
  String chatPageAudioPlaybackFailed(String error) {
    return '오디오를 재생하지 못했습니다: $error';
  }

  @override
  String get chatPageMicrophonePermissionRequired => '녹음하려면 마이크 권한이 필요합니다';

  @override
  String chatPageStartRecordingFailed(String error) {
    return '녹음을 시작할 수 없습니다: $error';
  }

  @override
  String get chatPageRecordingCreationFailed => '녹음 파일을 생성하지 못했습니다. 다시 녹음해 주세요';

  @override
  String chatPageRecordingFailed(String error) {
    return '녹음하지 못했습니다: $error';
  }

  @override
  String get chatPageRecordingNotFoundRetry => '녹음 파일을 찾을 수 없습니다. 다시 녹음해 주세요';

  @override
  String get chatPageRecordingEmptyRetry => '녹음 파일이 비어 있습니다. 다시 녹음해 주세요';

  @override
  String get chatPageNoRecordingToSend => '전송할 수 있는 녹음이 없습니다';

  @override
  String chatPagePointCost(int count) {
    return '$count포인트';
  }

  @override
  String get chatPageVoiceUploading => '음성을 업로드하는 중……';

  @override
  String get chatPageChangeWatermarkColor => '워터마크 색상 변경';

  @override
  String chatPageMinutesSeconds(int minutes, int seconds) {
    return '$minutes분 $seconds초';
  }

  @override
  String chatPageSeconds(int seconds) {
    return '$seconds초';
  }

  @override
  String get characterEditSelectSupportingCharacter => '조연 캐릭터를 선택해 주세요.';

  @override
  String get characterEditSelectGender => '캐릭터의 성별을 선택해 주세요.';

  @override
  String get characterEditCharacterSettings => '캐릭터 설정';

  @override
  String get characterEditWorldview => '세계관';

  @override
  String get characterEditSettingsMinLength => '캐릭터 설정을 10자 이상 입력해 주세요.';

  @override
  String get characterEditWorldviewMinLength => '세계관을 20자 이상 입력해 주세요.';

  @override
  String get characterEditSupportingCharacters => '조연 캐릭터';

  @override
  String get characterEditCharacterImage => '캐릭터 이미지';

  @override
  String get characterEditWorldviewHint =>
      '세계의 배경, 역사, 시대, 지역, 세력, 제도, 기술, 마법과 규칙을 설명해 주세요.';

  @override
  String get characterEditSettingsHint =>
      '캐릭터의 성격, 가치관, 사고방식, 감정적 반응, 행동 습관, 말투와 핵심 신념을 설명해 주세요.';

  @override
  String get characterEditUnknownCharacter => '알 수 없는 캐릭터';

  @override
  String get characterEditEditSupportingCharacter => '조연 캐릭터 편집';

  @override
  String get characterEditAddSupportingCharacter => '조연 캐릭터 추가';

  @override
  String get characterEditSupportingCharacterName => '조연 캐릭터 이름';

  @override
  String get characterEditGender => '성별';

  @override
  String get characterEditMale => '남성';

  @override
  String get characterEditFemale => '여성';

  @override
  String get characterEditOther => '기타';

  @override
  String get characterEditAge => '나이';

  @override
  String get characterEditIdentityOccupation => '신분／직업';

  @override
  String get characterEditRelationshipWithMain => '주요 캐릭터와의 관계';

  @override
  String get characterEditRelationshipHint =>
      '주요 캐릭터와의 과거, 입장, 감정, 비밀과 현재 관계를 설명해 주세요.';

  @override
  String get characterEditCharacterProfile => '인물 설정';

  @override
  String get characterEditCharacterProfileHint =>
      '성격, 외모, 습관, 가치관, 능력, 선호하는 것, 싫어하는 것과 중요한 경험을 설명해 주세요.';

  @override
  String get characterEditSpeakingStyle => '말투';

  @override
  String get characterEditSpeakingStyleHint =>
      '예: 말이 빠르고, 자주 태클을 걸며, 직설적으로 말함.';

  @override
  String get characterEditSupportingNameRequired => '조연 캐릭터의 이름을 입력해 주세요.';

  @override
  String get characterEditSupportingGenderRequired => '조연 캐릭터의 성별을 선택해 주세요.';

  @override
  String get characterEditProfileRequired => '인물 설정을 입력해 주세요.';

  @override
  String get characterEditRelationshipTooLong => '주요 캐릭터와의 관계가 1,500자를 초과했습니다.';

  @override
  String get characterEditProfileTooLong => '인물 설정이 1,500자를 초과했습니다.';

  @override
  String get characterEditSave => '저장';

  @override
  String get characterEditAdd => '추가';

  @override
  String get creatorProfileNoBio => '아직 자기소개가 없습니다';

  @override
  String get creatorProfileNoBioHint => '이 크리에이터는 아직 자기소개를 작성하지 않았습니다.';

  @override
  String get creatorProfileNoCreatorMoments => '크리에이터가 아직 게시물을 올리지 않았습니다';

  @override
  String get creatorProfileNoCreatorMomentsHint =>
      '크리에이터 본인으로 공개한 콘텐츠가 여기에 표시됩니다.';

  @override
  String get creatorProfileNoCharacterMoments => '소속 캐릭터가 아직 게시물을 올리지 않았습니다';

  @override
  String get creatorProfileNoCharacterMomentsHint =>
      '소속 공개 캐릭터가 게시한 콘텐츠가 여기에 표시됩니다.';

  @override
  String get creatorProfileNoPublicMoments => '아직 공개 게시물이 없습니다';

  @override
  String get creatorProfileNoPublicMomentsHint =>
      '크리에이터 본인과 소속 캐릭터가 게시한 공개 콘텐츠가 여기에 표시됩니다.';

  @override
  String get creatorProfilePublicWorks => '공개 작품';

  @override
  String get creatorProfileLikesReceived => '받은 좋아요';

  @override
  String get creatorProfileFollow => '팔로우';

  @override
  String get creatorProfileFollowing => '팔로잉';

  @override
  String get creatorProfileUnfollowed => '팔로우를 취소했습니다';

  @override
  String creatorProfileFollowedCreator(String creatorName) {
    return '$creatorName 님을 팔로우했습니다';
  }

  @override
  String get creatorProfileOperationFailed => '작업하지 못했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String creatorProfileWorksLoadFailed(String error) {
    return '작품을 불러오지 못했습니다: $error';
  }

  @override
  String get characterProfileShareInvitation => '🦋 LoveyDovey에서 온 만남의 초대장';

  @override
  String characterProfileShareCreator(String creatorName) {
    return '✦ 크리에이터: $creatorName';
  }

  @override
  String characterProfileShareMessage(String characterName) {
    return 'LoveyDovey에서 ‘$characterName’을 검색하고 두 사람만의 이야기를 시작해 보세요.';
  }

  @override
  String get characterProfileInvitationLabel => '캐릭터 초대 카드';

  @override
  String characterProfileCardCreator(String creatorName) {
    return '크리에이터  $creatorName';
  }

  @override
  String get characterProfileCardSearchHint => '캐릭터를 검색하고 만남을 시작하세요  🦋';

  @override
  String get characterProfileScanToDownload => '스캔하여 다운로드';

  @override
  String characterProfileShareTitle(String characterName) {
    return '캐릭터 ‘$characterName’ 공유';
  }

  @override
  String characterProfileShareSubject(String characterName) {
    return 'LoveyDovey에서 $characterName을 만나 보세요';
  }

  @override
  String get characterProfileShareFailed =>
      '초대 카드를 생성하지 못했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get characterProfilePrivateShareUnavailable =>
      '비공개 캐릭터는 현재 공유할 수 없습니다';

  @override
  String get characterProfileShareCard => '초대 카드 공유';

  @override
  String get characterProfileShareCharacter => '캐릭터 공유';

  @override
  String get characterProfileReportCharacter => '캐릭터 신고';

  @override
  String get characterProfileTranslate => '번역';

  @override
  String get loginMethodInfoTooltip => '로그인 방법 안내';

  @override
  String get characterEditCoreSetting => '캐릭터 핵심 설정';

  @override
  String get characterEditCoreSettingHint =>
      '캐릭터의 성격, 행동 방식, 다른 사람을 대하는 태도와 말투를 설명해 주세요.\n\n예시: 겉으로는 차갑고 말수가 적어 보이지만, 실제로는 매우 세심하다. 낯선 사람과는 거리를 두며, 좋아하는 사람에게는 행동으로 배려를 표현한다. 짧고 직설적으로 말하며, 지나치게 달콤하거나 가벼운 애칭은 사용하지 않는다.';

  @override
  String get characterEditNameDescription =>
      '캐릭터에게 공개적으로 표시되는 이름입니다. 생성을 완료하면 시스템이 캐릭터 사용자 이름을 자동으로 생성합니다.';

  @override
  String get characterEditNameHint => '캐릭터 이름을 입력해 주세요';

  @override
  String get characterEditAgeDescription =>
      '캐릭터의 나이를 설정합니다. 세계관에 따라 외관상 나이를 입력할 수도 있습니다.';

  @override
  String get characterEditAgeHint => '예: 25';

  @override
  String get characterEditOccupationDescription =>
      '학생, 의사, 기사 또는 사업가 등 캐릭터의 현재 신분이나 직업입니다.';

  @override
  String get characterEditBirthdayDescription =>
      '캐릭터의 생일을 네 자리 숫자로 입력하거나 월과 일을 슬래시로 구분해 설정해 주세요.';

  @override
  String get characterEditBirthdayHint => '예: 0825 또는 08/25';

  @override
  String get characterEditHeightDescription => '캐릭터의 키를 센티미터 단위로 설정합니다.';

  @override
  String get characterEditHeightHint => '예: 182';

  @override
  String get characterEditGenderDescription =>
      '시스템이 캐릭터의 성별에 따라 적절한 대명사를 사용합니다.';

  @override
  String get characterEditAppearanceDescription =>
      '캐릭터의 이목구비, 헤어스타일, 의상과 기타 외모 특징을 설명해 주세요.';

  @override
  String get characterEditPlayerIdentityDescription =>
      '비서, 동급생 또는 소꿉친구 등 이야기 속 플레이어의 신분을 설정합니다.';

  @override
  String get characterEditWorldviewDescription =>
      '이야기의 시대, 장소, 사회적 배경과 특별한 규칙을 설명해 주세요. 이 내용은 캐릭터 페이지의 ‘캐릭터 소개’에 공개되므로, 플레이어에게 미리 알리고 싶지 않은 비밀이나 이야기 전개는 입력하지 마세요.';

  @override
  String get characterEditStorySummaryDescription =>
      '캐릭터의 상황을 빠르게 이해할 수 있도록 이야기를 한 문장으로 간단히 소개해 주세요.';

  @override
  String get characterEditStorySummaryHint => '예: 냉정한 의사와의 계약 관계에서 시작되는 사랑 이야기';

  @override
  String get characterEditInitialStoryDescription =>
      '플레이어가 채팅방에 처음 입장했을 때 가장 먼저 보게 되는 이야기 상황입니다.';

  @override
  String get characterEditFirstLineDescription =>
      '캐릭터가 플레이어를 처음 만났을 때 하는 첫 번째 말입니다.';

  @override
  String get characterEditCustomStatusBar => '스토리 상태 표시줄(선택 사항)';

  @override
  String get characterEditCustomStatusBarDescription =>
      '스토리 모드와 몰입 모드에만 적용됩니다. 답변 끝에 항상 표시할 캐릭터의 상태, 위치, 복장 또는 관계 정보를 설정할 수 있습니다. 비워 두면 상태 표시줄이 생성되지 않습니다.';

  @override
  String get characterProfileCharacterIntro => '캐릭터 소개';

  @override
  String get characterProfileNoIntroduction => '크리에이터가 아직 캐릭터 소개를 작성하지 않았습니다';

  @override
  String get characterProfileViewMore => '더 보기';

  @override
  String get characterProfileCollapse => '접기';
}
