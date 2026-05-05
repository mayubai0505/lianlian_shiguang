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
}
