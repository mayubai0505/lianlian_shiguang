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
  String get charNameLabel => '캐릭터 이름:*';

  @override
  String get charDescSection => '캐릭터 설명:';

  @override
  String get charAgeLabel => '나이:';

  @override
  String get charJobLabel => '직업:*';

  @override
  String get charBirthdayLabel => '생일:(MMDD)';

  @override
  String get charGenderLabel => '성별 *';

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
  String get appDisclaimer =>
      '게임 내의 캐릭터와 장면은 모두 허구이므로 현실에 대입하지 마세요! 유사한 점이 있더라도 이는 순전히 우연입니다';

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
  String get terms_title => '「연연습광」 서비스 이용약관';

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
  String confirm_block_msg(Object charName) {
    return '차단 후에는 당분간 $charName 님의 메시지를 받을 수 없습니다.';
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
}
