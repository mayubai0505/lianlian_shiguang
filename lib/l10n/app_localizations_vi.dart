// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get changeTheme => 'Thay đổi màu chủ đề';

  @override
  String get feedback => 'Phản hồi & Gợi ý';

  @override
  String get changeLanguage => 'Thay đổi ngôn ngữ';

  @override
  String get allFriendsTitle => 'Tất cả bạn bè';

  @override
  String get noFriendsMessage => 'Bạn chưa có bất kỳ người bạn nào.';

  @override
  String get unknownCharacter => 'Nhân vật không xác định';

  @override
  String errorLoadingFriends(String error) {
    return 'Đã xảy ra lỗi khi tải danh sách bạn bè: $error';
  }

  @override
  String get tagGentle => 'Dịu dàng';

  @override
  String get tagCheerful => 'Vui vẻ';

  @override
  String get tagLively => 'Hoạt bát';

  @override
  String get tagMischievous => 'Nghịch ngợm';

  @override
  String get tagRichYoungLady => 'Tiểu thư';

  @override
  String get tagRichYoungMaster => 'Công tử';

  @override
  String get tagWealthyFamily => 'Gia đình giàu có';

  @override
  String get tagScheming => 'Tính toán';

  @override
  String get tagPossessive => 'Chiếm hữu';

  @override
  String get tagParanoid => 'Hoang tưởng';

  @override
  String get tagPersistent => 'Kiên trì';

  @override
  String get tagUncle => 'Chú';

  @override
  String get tagAuntie => 'Dì';

  @override
  String get tagSeniorSister => 'Chị học';

  @override
  String get tagJuniorBrother => 'Em học';

  @override
  String get tagHandsome => 'Đẹp trai';

  @override
  String get tagStunning => 'Xinh đẹp lộng lẫy';

  @override
  String get tagContrast => 'Trái ngược';

  @override
  String get tagFlirty => 'Gợi cảm';

  @override
  String get tagAgeGap => 'Chênh lệch tuổi';

  @override
  String get userNotFoundError => 'Không tìm thấy người dùng';

  @override
  String get imageDataMismatchError =>
      'Dữ liệu hình ảnh không khớp, vui lòng chọn lại hình ảnh.';

  @override
  String get createCharacterTitle => 'Tạo nhân vật';

  @override
  String get charAlbumTitle =>
      'Album nhân vật (ảnh đầu tiên là hình đại diện chính)';

  @override
  String get charNameLabel => 'Tên nhân vật:*';

  @override
  String get charDescSection => 'Mô tả nhân vật:';

  @override
  String get charAgeLabel => 'Tuổi:';

  @override
  String get charJobLabel => 'Nghề nghiệp:*';

  @override
  String get charBirthdayLabel => 'Ngày sinh:(MMDD)';

  @override
  String get charGenderLabel => 'Giới tính *';

  @override
  String get genderNotSelected => 'Chưa chọn';

  @override
  String get genderMale => 'Nam';

  @override
  String get genderFemale => 'Nữ';

  @override
  String get genderOther => 'Khác';

  @override
  String get charHeightLabel => 'Chiều cao:(cm)';

  @override
  String get charAppearanceLabel => 'Mô tả ngoại hình:';

  @override
  String get charPersonalityTagsSection => 'Thẻ tính cách';

  @override
  String get charOtherPersonalityTagsHint => 'Thẻ tính cách khác...';

  @override
  String get otherSectionTitle => 'Khác';

  @override
  String get charLikesLabel =>
      'Những thứ yêu thích:(ví dụ: bánh kem dâu, mèo, ngày mưa)';

  @override
  String get charDislikesLabel => 'Những thứ ghét:(ví dụ: khổ qua, nơi ồn ào)';

  @override
  String get charSecretsLabel =>
      'Bí mật nhỏ không ai biết: (ví dụ: thực ra là người mù đường)';

  @override
  String get charMannerismsSection => 'Cử chỉ và hành động';

  @override
  String get charToneLabel =>
      'Giọng điệu và phong cách nói: (ví dụ: lạnh nhạt với người lạ)';

  @override
  String get charDialogueExampleLabel =>
      'Ví dụ đối thoại: (Người chơi: Bạn thật tốt bụng! Nhân vật: ...Ồ.)';

  @override
  String get charBackgroundSection => 'Bối cảnh nhân vật:';

  @override
  String get charBackgroundHint =>
      'Nhập câu chuyện nền của nhân vật (tối đa 2500 từ)';

  @override
  String get charStoryStartSection => 'Khởi đầu cốt truyện:';

  @override
  String get charStoryStartHint =>
      'Nhập cốt truyện của nhân vật (tối đa 2500 từ)';

  @override
  String get charStorySummaryLabel =>
      'Tóm tắt câu chuyện (tối đa 50 từ, sẽ hiển thị trên thẻ gặp gỡ)';

  @override
  String get charExtraInfoSection => 'Thông tin bổ sung về nhân vật:';

  @override
  String get charExtraInfoHint => 'Nhập nội dung bổ sung...';

  @override
  String get charPublicToggleLabel => 'Công khai cho người chơi khác chơi chứ?';

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get createButton => 'Tạo';

  @override
  String get saveButton => 'Lưu';

  @override
  String get cancelButton => 'Hủy';

  @override
  String get exitCreationTitle => 'Bạn sẽ thoát khỏi màn hình tạo nhân vật';

  @override
  String get saveDraftPrompt => 'Có cần lưu thành bản nháp không?';

  @override
  String get draftNeeded => 'Có';

  @override
  String get draftNotNeeded => 'Không';

  @override
  String get editExtraInfoTitle => 'Chỉnh sửa nội dung bổ sung';

  @override
  String get nameAndAvatarError =>
      'Vui lòng điền tên nhân vật và tải lên ít nhất một hình đại diện!';

  @override
  String get savingStatus => 'Đang lưu...';

  @override
  String get uploadingImagesStatus => 'Đang tải lên hình ảnh...';

  @override
  String get maxImagesError => 'Chỉ có thể tải lên tối đa 10 hình ảnh.';

  @override
  String get uploadingImagesStatusShort => 'Đang xử lý hình ảnh...';

  @override
  String get savingCharacterData => 'Đang lưu dữ liệu nhân vật...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'Đã tạo nhân vật \"$charName\"!';
  }

  @override
  String get uploadImageTimeoutError =>
      'Tạo nhân vật thất bại: Tải lên hình ảnh quá thời gian, vui lòng kiểm tra kết nối internet của bạn.';

  @override
  String createCharacterGenericError(String error) {
    return 'Tạo nhân vật thất bại: $error';
  }

  @override
  String get settingsSectionAppearance => 'Giao diện & Nội dung';

  @override
  String get settingsSectionAccount => 'Quản lý Tài khoản & Nội dung';

  @override
  String get settingsSectionAbout => 'Về chúng tôi';

  @override
  String get accountManagement => 'Quản lý tài khoản';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'Không xác định';

  @override
  String get userIdCopied => 'ID người dùng đã được sao chép vào khay nhớ tạm';

  @override
  String get characterManagement => 'Quản lý nhân vật';

  @override
  String get viewBlockedCharacters => 'Xem các nhân vật đã bị chặn';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get logoutButton => 'Đăng xuất';

  @override
  String get logoutDialogTitle => 'Bạn có muốn đăng xuất không?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'Tôi bấm nhầm';

  @override
  String get logoutDialogActionConfirm => 'Xác nhận';

  @override
  String get logoutSuccessSnackbar =>
      'Được rồi! Tôi sẽ đợi bạn quay lại♥(´∀` )';

  @override
  String get deleteAccountButton => 'Xóa tài khoản';

  @override
  String get deleteAccountDialogTitle =>
      'Bạn có chắc chắn muốn xóa tài khoản này không?இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'Thao tác này không thể hoàn tác, tất cả dữ liệu sẽ bị xóa vĩnh viễn!';

  @override
  String get deleteAccountDialogActionCancel => 'Không, tôi không muốn xóa';

  @override
  String get deleteAccountDialogActionConfirm => 'Xác nhận';

  @override
  String get deleteAccountSuccessSnackbar =>
      'Tài khoản đã được xóa thành công.';

  @override
  String get appDisclaimer =>
      'Các nhân vật và bối cảnh trong trò chơi đều là hư cấu, vui lòng không áp dụng vào đời thực! Nếu có điểm tương đồng, đó chỉ là sự trùng hợp ngẫu nhiên.';

  @override
  String appVersion(String version) {
    return 'Phiên bản ứng dụng: $version';
  }

  @override
  String get dialogTitleHint => 'Gợi ý';

  @override
  String get completeProfilePrompt =>
      'Vui lòng chỉnh sửa hồ sơ của bạn để hoàn thiện thông tin trước nhé!';

  @override
  String get goToEdit => 'Đến chỉnh sửa';

  @override
  String get later => 'Để sau';

  @override
  String chattingWith(String friendName) {
    return 'Trò chuyện với $friendName';
  }

  @override
  String chatContentWith(String friendName) {
    return 'Nội dung trò chuyện với $friendName';
  }

  @override
  String get chatInputHint => 'Nhập tin nhắn...';
}
