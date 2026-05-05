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

  @override
  String get characterNotFoundError => 'Không tìm thấy dữ liệu nhân vật';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'Tải chi tiết nhân vật thất bại: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'Mối quan hệ ban đầu';

  @override
  String get relationship_childhood_friend => 'Bạn thanh mai trúc mã';

  @override
  String get relationship_senior_junior => 'Anh/chị/em khóa trên/khóa dưới';

  @override
  String get relationship_bickering_couple => 'Cặp đôi oan gia';

  @override
  String get relationship_colleagues => 'Đồng nghiệp';

  @override
  String get relationship_other => 'Khác (vui lòng nhập thủ công)';

  @override
  String get chatModeDaily => 'Chế độ Hàng ngày';

  @override
  String get chatModeStory => 'Chế độ Cốt truyện';

  @override
  String get chatModeImmersive => 'Chế độ nhập vai';

  @override
  String get chatModeGemini => 'Bạn đồng hành cuộc sống';

  @override
  String get announcement_new => 'Thông Báo Mới';

  @override
  String get mail_notification =>
      'Một bức thư thời gian mới đã đến! Hãy kiểm tra cuộn giấy da ngay!';

  @override
  String get customer_service_reply => 'Phản hồi từ CSKH';

  @override
  String get system_announcement => 'Thông báo hệ thống';

  @override
  String get empty_announcement => 'Hiện tại không có thông báo nào.';

  @override
  String get untitled => 'Không tiêu đề';

  @override
  String get no_content => 'Không có nội dung';

  @override
  String get privacy_policy_title => 'Chính sách bảo mật Lianlian Shiguang';

  @override
  String get privacy_policy_date =>
      'Cập nhật lần cuối: Ngày 10 tháng 4 năm 2026';

  @override
  String get privacy_policy_body =>
      'Chính sách bảo mật của \"Lianlian Shiguang\"\nCập nhật lần cuối: Ngày 10 tháng 4 năm 2026\n\nChào mừng bạn đến với \"Lianlian Shiguang\" (sau đây gọi là \"Dịch vụ\"). Chúng tôi coi trọng quyền riêng tư của bạn. Chính sách này giải thích cách chúng tôi thu thập, sử dụng và bảo vệ thông tin của bạn.\n\n1. Thông tin tài khoản:\nĐăng nhập bên thứ ba: Qua Google, Facebook hoặc Apple, chúng tôi thu thập Firebase UID, email và biệt danh của bạn.\nEmail: Mật khẩu được mã hóa bởi Firebase, đội ngũ phát triển không thể xem mật khẩu gốc.\nDữ liệu tương tác: Lưu trữ lịch sử trò chuyện để AI có trí nhớ liên tục.\n\n2. Cách sử dụng thông tin:\nTối ưu hóa phản hồi của AI, xử lý nạp điểm, xác minh danh tính và bảo mật máy chủ.\n\n3. Hợp tác kỹ thuật:\nSử dụng Google Cloud / Firebase và mô hình AI từ OpenRouter / xAI / Meta. Chúng tôi không bán lịch sử trò chuyện cho bên quảng cáo.\n\n4. Lưu trữ và Xóa dữ liệu:\nDữ liệu được lưu trữ bảo mật trên đám mây. Bạn có thể yêu cầu xóa tài khoản vĩnh viễn bất cứ lúc nào.';

  @override
  String get terms_title => 'Điều khoản dịch vụ Lianlian Shiguang';

  @override
  String get terms_date => 'Cập nhật lần cuối: Ngày 10 tháng 4 năm 2026';

  @override
  String get terms_body =>
      'Điều khoản Dịch vụ của \"Lianlian Shiguang\"\nCập nhật lần cuối: Ngày 10 tháng 4 năm 2026\n\nVui lòng đọc kỹ trước khi dùng. Việc bắt đầu sử dụng đồng nghĩa với việc bạn đồng ý:\n\n1. Bản chất dịch vụ:\nTương tác phi ngôn ngữ: Phản hồi do AI tạo ra, không đại diện cho quan điểm của nhà phát triển. AI có thể tạo nội dung hư cấu.\n\n2. Điểm ảo:\nĐiểm là hàng hóa ảo, không được hoàn lại sau khi đã sử dụng (đọc truyện, gọi điện, tặng quà).\n\n3. Quy định hành vi:\nCấm tạo nội dung bạo lực, vi phạm pháp luật hoặc can thiệp hệ thống.\n\n4. Sở hữu trí tuệ:\nNhân vật chính thức (như Trình An), kịch bản và logic trò chơi thuộc về \"Đội ngũ phát triển Lianlian Shiguang\".\n\n5. Chấm dứt dịch vụ:\nTài khoản có thể bị tạm dừng vĩnh viễn nếu vi phạm quy định.';

  @override
  String get login_required => 'Vui lòng đăng nhập trước';

  @override
  String get cloud_character_mgmt => 'Quản lý nhân vật đám mây';

  @override
  String get connection_error => 'Lỗi kết nối';

  @override
  String get no_characters_met => 'Bạn chưa quen biết nhân vật nào!';

  @override
  String get status_paused => 'Trạng thái: Đã tạm dừng liên lạc';

  @override
  String get status_in_progress => 'Trạng thái: Đang chinh phục';

  @override
  String get unblock => 'Bỏ chặn';

  @override
  String get block => 'Chặn';

  @override
  String get confirm_block_title => 'Xác nhận chặn?';

  @override
  String confirm_block_msg(Object charName) {
    return 'Sau khi chặn, bạn tạm thời sẽ không nhận được tin nhắn từ $charName.';
  }

  @override
  String get think_again => 'Suy nghĩ lại';

  @override
  String get confirm_block_btn => 'Xác nhận chặn';

  @override
  String get no_char_info => 'Chưa có thông tin chi tiết về nhân vật này...';

  @override
  String get private_mailbox => 'Hòm thư riêng';

  @override
  String get user_info_not_found => 'Không tìm thấy thông tin người dùng';

  @override
  String get load_failed => 'Tải thất bại, vui lòng thử lại sau';

  @override
  String get empty_mailbox => 'Hòm thư hiện tại đang trống~';

  @override
  String get system_notification => 'Thông báo hệ thống';

  @override
  String get interaction_records => 'Lịch sử tương tác';

  @override
  String get liked_content => 'Nội dung đã thích';

  @override
  String get my_favorites => 'Bộ sưu tập của tôi';

  @override
  String get login_to_view_records => 'Vui lòng đăng nhập để xem lịch sử';

  @override
  String get no_likes_yet => 'Bạn chưa thích bất kỳ bài viết nào!';

  @override
  String get empty_favorites =>
      'Bộ sưu tập trống, hãy đến Sảnh chính dạo chơi nhé!';

  @override
  String get theme_sakura_pink => 'Hồng Sakura';

  @override
  String get theme_ocean_blue => 'Xanh Đại Dương';

  @override
  String get theme_sunset_orange => 'Cam Hoàng Hôn';

  @override
  String get theme_mint_forest => 'Rừng Bạc Hà';

  @override
  String get theme_midnight => 'Chế độ đêm';

  @override
  String get change_atmosphere => 'Thay đổi không khí';

  @override
  String get custom_color => 'Màu tùy chỉnh';

  @override
  String get custom_color_desc => 'Pha chế màu sắc không khí của riêng bạn';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';
}
