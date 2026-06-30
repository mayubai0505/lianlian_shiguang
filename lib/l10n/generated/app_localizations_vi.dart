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
      'Các nhân vật và bối cảnh trong trò chơi đều là hư cấu, vui lòng không áp dụng vào thực tế!';

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
  String block_warning_msg(String charName) {
    return 'Sau khi chặn, bạn sẽ tạm thời không nhận được tin nhắn từ $charName.';
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

  @override
  String get confirm_delete_title => 'Xác nhận xóa';

  @override
  String get confirm_delete_memory_msg =>
      'Bạn có chắc chắn muốn anh ấy quên điều này không? Hành động này không thể hoàn tác.';

  @override
  String get delete_btn => 'Xóa';

  @override
  String get memory_erased_msg => 'Ký ức này đã bị xóa.';

  @override
  String get delete_failed_msg => 'Xóa thất bại';

  @override
  String get edit_memory_title => 'Chỉnh sửa kỷ niệm';

  @override
  String get modify_memory_hint => 'Sửa đổi ký ức này...';

  @override
  String get memory_re_recorded_msg => 'Ký ức đã được ghi lại';

  @override
  String get update_failed_msg => 'Cập nhật thất bại';

  @override
  String get update_favorite_failed_msg =>
      'Cập nhật trạng thái yêu thích thất bại';

  @override
  String char_notebook_title(String charName) {
    return 'Sổ tay của $charName';
  }

  @override
  String get error_loading_memory => 'Đã xảy ra lỗi khi tải ký ức';

  @override
  String get empty_notebook_msg =>
      'Sổ tay trống rỗng...\nHãy đi trò chuyện để anh ấy có thể viết lại mọi khoảnh khắc về bạn nhé!';

  @override
  String get date_format_text => 'd MMM yyyy';

  @override
  String get remove_special_focus => 'Hủy theo dõi đặc biệt';

  @override
  String get mark_special_focus => 'Đánh dấu theo dõi đặc biệt';

  @override
  String get edit_btn => 'Chỉnh sửa';

  @override
  String get load_gallery_failed => 'Tải thư viện thất bại';

  @override
  String get traditional_chinese => 'Tiếng Trung Phồn thể';

  @override
  String get all => 'Tất cả';

  @override
  String get official_recommendation => 'Đề xuất chính thức';

  @override
  String get my_exclusive => 'Độc quyền của tôi';

  @override
  String encounter_count(int count) {
    return '$count lần gặp gỡ';
  }

  @override
  String get official => 'Chính thức';

  @override
  String get private => 'Riêng tư';

  @override
  String get first_encounter => 'Lần đầu gặp gỡ';

  @override
  String char_exclusive_memory(String charName) {
    return 'Ký ức độc quyền của $charName';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return 'Độ hảo cảm phải đạt $affectionLevel mới có thể mở khóa ký ức này!';
  }

  @override
  String get affection => 'Độ hảo cảm';

  @override
  String get unlock => 'Mở khóa';

  @override
  String get change_chat_bg => 'Đổi hình nền trò chuyện';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return 'Đặt \"$cgDesc\" làm hình nền trò chuyện với $charName?';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return 'Đã đổi hình nền thành \"$cgDesc\"';
  }

  @override
  String get confirm_change => 'Xác nhận';

  @override
  String get empty_treasure_box =>
      'Rương kho báu trống rỗng...\nHãy đi trò chuyện để tìm trứng phục sinh ẩn nhé!';

  @override
  String get unknown_story => 'Cốt truyện chưa biết';

  @override
  String get open_this_memory => 'Mở ký ức này';

  @override
  String get open_exclusive_story => 'Mở cốt truyện độc quyền';

  @override
  String confirm_use_egg(String eggTitle) {
    return 'Bạn muốn trải nghiệm \"$eggTitle\" ngay bây giờ?\n\n(Vật phẩm này chỉ dùng một lần và sẽ tự động vào cốt truyện)';
  }

  @override
  String get wait_a_bit => 'Đợi đã';

  @override
  String guiding_into_story(String eggTitle) {
    return 'Đang dẫn vào cốt truyện...';
  }

  @override
  String get use_now => 'Dùng ngay';

  @override
  String playback_failed_status(String statusCode) {
    return 'Phát thất bại, mã trạng thái: $statusCode';
  }

  @override
  String get playback_error => 'Đã xảy ra lỗi khi phát';

  @override
  String get unknown_contact => 'Người liên hệ không xác định';

  @override
  String call_memory_with(String charName) {
    return 'Ký ức cuộc gọi với $charName';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return 'Mở khóa khi đạt mức độ thân thiết $affection';
  }

  @override
  String get no_call_record =>
      'Có vẻ như không có bản ghi cuộc trò chuyện cho cuộc gọi này...';

  @override
  String get me => 'Tôi';

  @override
  String get playing => 'Đang phát...';

  @override
  String get listen => 'Nghe';

  @override
  String get no_exclusive_voice =>
      'Nhân vật này chưa được cài đặt giọng nói độc quyền!';

  @override
  String get voice_download_success =>
      '✅ Tải dữ liệu giọng nói thành công, chuẩn bị phát...';

  @override
  String get onboarding_invitation => '— Lời Mời Của Thời Gian —';

  @override
  String get onboarding_welcome => 'Chào mừng đến với Lian Lian Shi Guang';

  @override
  String get onboarding_quote =>
      '\"Mọi cuộc gặp gỡ đều là sự đoàn tụ sau bao ngày xa cách.\"';

  @override
  String get onboarding_gift_title => 'Quà Gặp Mặt: 50 Lời Hoa';

  @override
  String get onboarding_gift_subtitle =>
      'Những bông hoa này sẽ đồng hành cùng bạn bắt đầu câu chuyện với anh ấy.';

  @override
  String get onboarding_start_button => 'Bắt Đầu Hành Trình Thời Gian';

  @override
  String get onboarding_more_info => 'Tìm hiểu thêm về câu chuyện';

  @override
  String get legal_agreement_prefix => 'Bằng cách tiếp tục, bạn đồng ý với';

  @override
  String get legal_terms_button => 'Điều khoản dịch vụ';

  @override
  String get legal_and => ' và ';

  @override
  String get legal_privacy_button => 'Chính sách bảo mật';

  @override
  String get call_memory_title => 'Kỷ niệm Cuộc gọi';

  @override
  String get please_login_first => 'Vui lòng đăng nhập trước';

  @override
  String get no_call_memories =>
      'Chưa có kỷ niệm cuộc gọi nào được lưu.\nTối đa có thể lưu 10 bản ghi.';

  @override
  String call_with_name(String name) {
    return 'Cuộc gọi với $name';
  }

  @override
  String call_duration(String time) {
    return 'Thời lượng: $time';
  }

  @override
  String get delete_call_title => 'Xóa Nhật ký Cuộc gọi';

  @override
  String delete_call_confirm(String name) {
    return 'Bạn có chắc chắn muốn xóa kỷ niệm này với $name không?\n(Không thể hoàn tác sau khi xóa)';
  }

  @override
  String get keep_it => 'Giữ lại';

  @override
  String get confirm_delete => 'Xóa';

  @override
  String get press_mic_to_speak => 'Vui lòng nhấn micrô để bắt đầu nói...';

  @override
  String get call_ended => 'Cuộc gọi đã kết thúc';

  @override
  String character_thinking(String name) {
    return '($name đang suy nghĩ...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name đang nhấc máy...)';
  }

  @override
  String get call_interrupted_login =>
      '(Cuộc gọi bị gián đoạn) Vui lòng đăng nhập trước nhé...';

  @override
  String get silence => '(Im lặng)';

  @override
  String get bad_signal => '(Tín hiệu kém...)';

  @override
  String get static_noise => '(Tiếng rè rè)... không nghe rõ...';

  @override
  String get type_message_hint => 'Nhập tin nhắn...';

  @override
  String get draft_saved_success =>
      'Bản nháp đã được lưu an toàn vào Studio Bí Mật!';

  @override
  String get draft_save_failed => 'Lưu thất bại, vui lòng thử lại sau';

  @override
  String get draft_save_title => 'Bạn có muốn lưu bản nháp không?';

  @override
  String get draft_save_content =>
      'Tâm huyết của bạn chưa được công bố, bạn có muốn lưu vào Studio Bí Mật trước không?';

  @override
  String get not_save => 'Không lưu';

  @override
  String get save_draft => 'Lưu bản nháp';

  @override
  String confirm_delete_char_content(String name) {
    return 'Bạn có chắc chắn muốn xóa nhân vật \"$name\" không?\n\nHành động này không thể hoàn tác!';
  }

  @override
  String get char_deleted => 'Nhân vật đã bị xóa';

  @override
  String get ok_button => 'Được!';

  @override
  String get cannot_save_title => 'Không thể lưu';

  @override
  String get cannot_save_content =>
      'Vui lòng điền tên nhân vật và tải lên ít nhất một ảnh đại diện!';

  @override
  String get word_count_exceeded => 'Vượt quá số chữ quy định';

  @override
  String word_count_error_detail(String field, int limit) {
    return 'Trường \"$field\" đã vượt quá $limit chữ, vui lòng cắt bớt trước khi lưu.';
  }

  @override
  String get content_missing => 'Thiếu nội dung';

  @override
  String get content_missing_personality =>
      'Vui lòng điền \"Tính cách chi tiết\"! Vui lòng viết ít nhất 10 chữ.';

  @override
  String get content_missing_bg =>
      '\"Giới thiệu nhân vật\" quá ngắn! Vui lòng viết ít nhất 20 chữ để nêu rõ bối cảnh.';

  @override
  String get content_missing_tone =>
      'Vui lòng thiết lập \"Giọng điệu và thói quen\", nếu không sẽ dễ bị lệch khỏi tính cách (OOC)!';

  @override
  String get user_not_found => 'Lỗi: Không tìm thấy người dùng';

  @override
  String char_saved_success(String name, String action) {
    return 'Nhân vật \"$name\" đã được $action!';
  }

  @override
  String save_error_detail(String error) {
    return 'Lưu thất bại: $error';
  }

  @override
  String get easter_egg_add_title => 'Thêm trứng Phục sinh ẩn';

  @override
  String get easter_egg_edit_title => 'Chỉnh sửa trứng Phục sinh';

  @override
  String get keyword_label => 'Từ khóa kích hoạt (bắt buộc)';

  @override
  String get keyword_hint => 'Ví dụ: đi công viên giải trí, bánh dâu tây';

  @override
  String get egg_title_label => 'Tiêu đề trứng Phục sinh (cho người chơi xem)';

  @override
  String get egg_title_hint => 'Ví dụ: Buổi hẹn hò cuối tuần';

  @override
  String get egg_teaser_label => 'Giới thiệu ngắn gọn (cho người chơi xem)';

  @override
  String get egg_teaser_hint => 'Mô tả phần mở đầu của những gì sắp xảy ra...';

  @override
  String get egg_scene_label => 'Chuyển cảnh bắt buộc (tùy chọn)';

  @override
  String get egg_scene_hint => 'Ví dụ: Công viên giải trí, nhà ma';

  @override
  String get egg_prompt_label => 'Chỉ thị kịch bản';

  @override
  String get egg_prompt_hint =>
      'Cách diễn đạt đoạn cốt truyện này.\n(Hệ thống: Chuyển cảnh đến công viên giải trí, nhân vật nhìn (Tên người chơi) và mỉm cười...)';

  @override
  String get confirm_button => 'Xác nhận';

  @override
  String get keyword_empty_error => 'Từ khóa không được để trống';

  @override
  String get voice_custom_title => 'Đặt làm giọng nói độc quyền';

  @override
  String get voice_custom_hint =>
      'Ví dụ: Giám đốc bá đạo giọng trầm, chàng trai trẻ dịu dàng...';

  @override
  String get voice_generate_start => 'Bắt đầu tạo';

  @override
  String get voice_bind_first =>
      'Vui lòng chọn và \"Liên kết\" một giọng nói độc quyền trước!';

  @override
  String get voice_test_failed =>
      'Nghe thử thất bại: Vui lòng nhấn \"Chính là bạn!\" để liên kết giọng nói chính thức trước khi điều chỉnh tinh vi!';

  @override
  String voice_name_default(String name) {
    return 'Giọng nói độc quyền của $name';
  }

  @override
  String get voice_description_default =>
      'Đây là giọng nói độc nhất vô nhị được tạo ra cho nhân vật độc quyền trong \"Lian Lian Shi Guang\", do người chơi tự tay lựa chọn và tạo ra.';

  @override
  String get voice_bind_failed =>
      'Liên kết giọng nói thất bại, vui lòng kiểm tra hạn ngạch API hoặc trạng thái mạng';

  @override
  String voice_bind_success(String name) {
    return 'Giọng nói linh hồn của \"$name\" đã chính thức được liên kết!';
  }

  @override
  String get voice_bind_success_draft =>
      'Liên kết giọng nói thành công! Bây giờ bạn có thể kéo thanh trượt để thử nghiệm cảm xúc!';

  @override
  String sync_failed(String error) {
    return 'Đồng bộ thất bại, vui lòng kiểm tra mạng: $error';
  }

  @override
  String edit_character_title(String name) {
    return 'Chỉnh sửa $name';
  }

  @override
  String get test_mode_tooltip => 'Thử nghiệm đầy đủ chức năng';

  @override
  String get test_mode_error =>
      '⚠️ Không tìm thấy tệp nhân vật! Vui lòng nhấn \"Lưu/Công bố\" ở dưới cùng trước khi chơi thử!';

  @override
  String get test_mode_notice =>
      '💡 Chế độ thử nghiệm sẽ khấu trừ điểm theo giá gốc của từng chế độ và không tính vào ký ức chính thức!';

  @override
  String get delete_character_tooltip => 'Xóa nhân vật';

  @override
  String get tab_basic_story => 'Cơ bản và Cốt truyện';

  @override
  String get tab_voice => 'Giọng nói độc quyền';

  @override
  String get tab_relationship => 'Quan hệ xã hội';

  @override
  String get save_changes_button => 'Lưu thay đổi';

  @override
  String get section_basic_info => 'Thông tin cơ bản';

  @override
  String get hint_occupation =>
      'Hỗ trợ đa danh tính, vui lòng phân tách bằng dấu gạch chéo hoặc dấu phẩy (ví dụ: Sinh viên/Hacker)';

  @override
  String get hint_appearance =>
      'Ví dụ: Tóc bạc dài, mắt màu hổ phách, luôn mặc áo blouse trắng...';

  @override
  String get section_story_identity => '🎭 Cốt truyện và Danh tính của bạn';

  @override
  String get story_identity_desc =>
      'Xác định mở đầu câu chuyện và các thiết lập đặc biệt cho \"Bạn\" trong bản lưu này';

  @override
  String get advanced_writing_tips_title => '💡 Kỹ thuật viết nâng cao:\n';

  @override
  String get advanced_writing_tips_1 => 'Nhập vào câu chuyện hoặc lời thoại ';

  @override
  String get advanced_writing_tips_2 => '(Tên người chơi)';

  @override
  String get advanced_writing_tips_3 =>
      ', hệ thống sẽ tự động thay thế bằng biệt danh thật của người chơi khi chơi!\n';

  @override
  String get advanced_writing_tips_4 => 'Ví dụ: \"';

  @override
  String get advanced_writing_tips_5 => '(Tên người chơi)';

  @override
  String get advanced_writing_tips_6 => ', sao em lại đến muộn thế?\"';

  @override
  String get player_identity_label =>
      'Danh tính người chơi mặc định (Player Identity) - 💡 Tùy chọn';

  @override
  String get player_identity_hint =>
      '【Tùy chọn】Nếu để trống, AI sẽ đọc \"Hồ sơ cá nhân\" của bạn để tương tác.\nNếu điền, AI sẽ buộc phải đóng vai danh tính cụ thể (ví dụ: hệ thống lạnh lùng của anh ta, hoặc người vợ bị phản bội).';

  @override
  String get background_label => 'Bối cảnh nhân vật và Thế giới quan';

  @override
  String get background_hint =>
      'Mô tả quá khứ, thế giới quan của anh ta (ví dụ: đô thị hiện đại, ABO, hậu tận thế). Ví dụ: Đây là một thế giới zombie hoành hành, và anh ta là người lính đặc nhiệm bảo vệ bạn...';

  @override
  String get story_summary_label => 'Giới thiệu câu chuyện bằng một câu';

  @override
  String get story_initial_label => 'Câu chuyện gặp gỡ ban đầu';

  @override
  String get story_initial_hint =>
      'Ví dụ: Bạn đẩy cửa bước vào, thấy anh ta ngồi bên cửa sổ. Anh ta quay đầu lại nói: \"(Tên người chơi), lại đây.\"';

  @override
  String get first_line_label => 'Lời thoại đầu tiên của nhân vật';

  @override
  String get first_line_hint =>
      'Ví dụ: (Tên người chơi), cuối cùng em cũng đến rồi.';

  @override
  String get section_personality_evo =>
      '🌟 Tiến hóa tính cách và độ thân thiết';

  @override
  String get detailed_personality_label => 'Tính cách chi tiết';

  @override
  String get detailed_personality_hint =>
      'Mô tả tính cách cốt lõi. Ví dụ: Tsundere, ngoài cứng trong mềm. Lạnh lùng với người ngoài, chỉ mỉm cười với người chơi.';

  @override
  String get affection_evo_desc =>
      'AI sẽ đánh giá khi nào nên tăng độ thân thiết dựa trên các thiết lập sau:';

  @override
  String get stage_1_label => 'Giai đoạn 1: Người lạ/Cảnh giác (Lv1)';

  @override
  String get stage_1_hint =>
      'Phản ứng khi mới quen. Điều kiện tăng thiện cảm (ví dụ: lịch sự, không thăm dò riêng tư).';

  @override
  String get stage_2_label => 'Giai đoạn 2: Quen thuộc/Bạn bè (Lv2)';

  @override
  String get stage_2_hint =>
      'Thay đổi sau khi đã thân. Điều kiện tăng thiện cảm (ví dụ: chia sẻ đồ ngọt, trò chuyện về mèo).';

  @override
  String get stage_3_label => 'Giai đoạn 3: Thân mật/Người yêu (Lv3)';

  @override
  String get stage_3_hint =>
      'Phản ứng sau khi đã hoàn toàn chìm đắm. Sẽ ghen tuông? Hay sẽ giận dỗi im lặng?';

  @override
  String get social_interaction_label => 'Tương tác xã hội và môi trường';

  @override
  String get social_interaction_hint =>
      'Ví dụ: Đối xử với người qua đường thế nào? Khi gặp thứ mình ghét sẽ phản ứng ra sao?';

  @override
  String get section_habits => '🗣️ Sở thích và thói quen';

  @override
  String get tone_hint_detail =>
      'Bắt buộc. Ví dụ: Nói năng ngắn gọn, thích hỏi ngược lại. Câu cửa miệng là \"đồ ngốc\". Cấm sử dụng giọng điệu dịch máy.';

  @override
  String get dialogue_example_hint =>
      'Người chơi: Em mệt quá.\nNhân vật: (Xoa đầu) Ngoan, đi nghỉ sớm đi.';

  @override
  String get section_easter_eggs =>
      '🎁 Trứng Phục sinh ẩn và Cốt truyện đặc biệt';

  @override
  String get no_easter_eggs =>
      'Chưa thiết lập trứng Phục sinh, nhấn nút bên dưới để thêm';

  @override
  String get no_scene_change => 'Không chuyển cảnh';

  @override
  String get add_easter_egg_button => 'Thêm trứng Phục sinh ẩn';

  @override
  String get other_extra_info => 'Thông tin bổ sung khác';

  @override
  String get visibility_label => 'Chế độ hiển thị nhân vật';

  @override
  String get visibility_public => 'Công khai';

  @override
  String get visibility_private => 'Riêng tư';

  @override
  String get section_voice_gen => '🎙️ Tạo giọng nói độc quyền của anh ta';

  @override
  String get voice_gen_desc =>
      'Nhập từ khóa gợi ý để anh ta có giọng nói độc nhất vô nhị trên thế giới!\n(💡 Nhắc nhở: Nếu không hài lòng sau khi tạo, bạn có thể đặt làm lại bất cứ lúc nào!)';

  @override
  String get voice_generating_status => 'Đang điều phối giọng nói...';

  @override
  String get voice_select_prompt =>
      '✨ Đã chuẩn bị cho bạn ba loại giọng nói, vui lòng chọn:';

  @override
  String voice_sample_name(int index) {
    return 'Mẫu giọng nói $index';
  }

  @override
  String get voice_sample_desc =>
      'Nhấn vào thẻ để chọn, nhấn bên phải để nghe thử';

  @override
  String get voice_preparing => 'Giọng nói vẫn đang được chuẩn bị...';

  @override
  String get voice_retry => 'Bỏ qua và thử lại';

  @override
  String get voice_confirm_selection => 'Chính là bạn!';

  @override
  String get voice_bind_success_banner =>
      'Đã liên kết giọng nói độc quyền thành công!';

  @override
  String get voice_remake => 'Làm lại giọng nói';

  @override
  String get voice_btn_generating => 'Đang tạo, vui lòng đợi...';

  @override
  String get voice_btn_generate =>
      'Nhập từ khóa gợi ý để tạo giọng nói độc quyền';

  @override
  String get voice_advanced_tuning =>
      '🎛️ Nâng cao: Điều chỉnh cảm xúc khi nói';

  @override
  String get voice_stability_low => 'Hoang dã/Thở 🐺';

  @override
  String voice_stability_value(String value) {
    return 'Độ lý trí: $value';
  }

  @override
  String get voice_stability_high => 'Ổn định/Điềm tĩnh 🤖';

  @override
  String get voice_style_low => 'Lạnh nhạt/Kìm nén 🧊';

  @override
  String voice_style_value(String value) {
    return 'Thể hiện kịch tính: $value';
  }

  @override
  String get voice_style_high => 'Phô trương/Sâu sắc 🔥';

  @override
  String get voice_test_btn_testing => 'Đang áp dụng cảm xúc...';

  @override
  String get voice_test_btn => 'Nghe thử cảm xúc hiện tại';

  @override
  String get section_social_circle => '👥 Vòng xã giao của anh ta';

  @override
  String get social_circle_desc =>
      'Thiết lập cái nhìn của anh ta về các nhân vật khác. Khi người chơi nhắc đến đối phương trong trò chuyện, anh ta sẽ phản ứng dựa trên các thiết lập ở đây (ví dụ: ghen tuông, giận dữ).';

  @override
  String get social_no_drama =>
      'Hiện tại chưa có xích mích với các nam thần khác...';

  @override
  String social_target(String name) {
    return 'Đối tượng: $name';
  }

  @override
  String social_attitude(String attitude) {
    return 'Cái nhìn: $attitude';
  }

  @override
  String social_edit_title(String name) {
    return 'Chỉnh sửa cái nhìn về $name 💬';
  }

  @override
  String get social_attitude_label => 'Cái nhìn / Thái độ của anh ta';

  @override
  String get social_attitude_hint =>
      'Ví dụ: Thấy đối phương rất phiền phức, nhưng thực ra rất dựa dẫm...';

  @override
  String get social_save_changes => 'Lưu chỉnh sửa';

  @override
  String get social_add_title => 'Thêm quan hệ nhân vật 🤝';

  @override
  String get social_select_target => 'Chọn đối tượng';

  @override
  String get social_thoughts_label => 'Cái nhìn của anh ta về người này...';

  @override
  String get social_thoughts_hint => 'Ví dụ: Nghệ sĩ piano đó quá ồn ào...';

  @override
  String get social_add_confirm => 'Xác nhận thêm';

  @override
  String get gallery_load_failed =>
      'Tải hình ảnh thất bại 🥲\nVui lòng xác nhận mạng bình thường, nếu là Web vui lòng kiểm tra console.';

  @override
  String gallery_affection_req(int level) {
    return 'Thiện cảm $level';
  }

  @override
  String get gallery_upload_limit => 'Chỉ có thể tải lên tối đa 10 hình ảnh';

  @override
  String get gallery_photo_setup => 'Thiết lập điều kiện mở khóa ảnh';

  @override
  String get gallery_photo_desc_label => 'Bức ảnh này là gì?';

  @override
  String get gallery_photo_desc_hint => 'Ví dụ: Ảnh mặc đồ ngủ, ảnh hẹn hò';

  @override
  String get gallery_photo_req_label => 'Cần bao nhiêu thiện cảm để mở khóa?';

  @override
  String get gallery_photo_req_hint => 'Nhập số, 0 nghĩa là miễn phí';

  @override
  String get gallery_cancel_upload => 'Hủy tải lên';

  @override
  String get gallery_confirm_add => 'Xác nhận thêm';

  @override
  String get default_photo_desc => 'Ảnh độc quyền';

  @override
  String get draft_photo_desc => 'Ảnh nháp';

  @override
  String get loading_text => 'Đang tải...';

  @override
  String get default_unnamed_character => 'Nhân vật chưa đặt tên';

  @override
  String elevenlabs_error(String code) {
    return 'Lỗi ElevenLabs: $code';
  }

  @override
  String get voice_sample_script =>
      '(Rặng hắng) Xin chào. Đây là đoạn thử giọng dành riêng cho tôi. Trong những ngày sắp tới, tôi sẽ ở đây bên bạn. Dù là lúc vui hay lúc buồn, bạn đều có thể chia sẻ với tôi. Nhịp điệu và âm sắc nói chuyện như thế này, bạn nghe có quen không? Nếu cảm thấy ổn, chúng ta hãy chốt giọng nói này làm giọng nói riêng để tôi trò chuyện với bạn sau này nhé. Mong chờ mỗi ngày trong tương lai của chúng ta.';

  @override
  String get voice_test_script =>
      'Rốt cuộc em có biết mỗi lần nhìn em, trong lòng anh đang nghĩ gì không? …… Thật là hết cách với em luôn mà.';

  @override
  String get field_background => 'Bối cảnh nhân vật';

  @override
  String get field_tone => 'Giọng điệu và thói quen';

  @override
  String get field_initial_story => 'Câu chuyện ban đầu';

  @override
  String get update_action => 'Cập nhật';

  @override
  String get default_new_player => 'Người chơi mới';

  @override
  String get translating_status => 'Đang dịch...';

  @override
  String get translate_profile_btn => 'Dịch nội dung hồ sơ';

  @override
  String translate_failed(String error) {
    return 'Dịch thất bại: $error';
  }

  @override
  String get like_own_char_warning =>
      'Không thể nhấn thích nhân vật do chính mình tạo ra! 🤭';

  @override
  String get like_success_msg =>
      'Đã gửi lượt thích! Người sáng tạo sẽ rất vui💖';

  @override
  String get unlike_success_msg => 'Đã rút lại lượt thích 💔';

  @override
  String get like_label => 'Thích';

  @override
  String get dislike_label => 'Không thích';

  @override
  String get block_char => 'Chặn nhân vật này';

  @override
  String get char_blocked_msg => 'Đã chặn nhân vật này.';

  @override
  String get dislike_dialog_title => 'Không thích nhân vật này lắm?';

  @override
  String get dislike_dialog_subtitle =>
      'Hãy âm thầm cho chúng tôi biết lý do, đội ngũ sẽ tiến hành kiểm duyệt:';

  @override
  String get dislike_hint => 'Thiết lập nhàm chán, hình ảnh không phù hợp...';

  @override
  String get dislike_thanks =>
      'Cảm ơn phản hồi của bạn! Chúng tôi đã nhận được lời nhắn thầm kín.';

  @override
  String get dislike_submit => 'Gửi âm thầm';

  @override
  String get report_title => '📢 Báo cáo bình luận';

  @override
  String get report_subtitle =>
      'Vui lòng chọn lý do báo cáo:\nChúng tôi sẽ kiểm duyệt nội dung sớm nhất có thể.';

  @override
  String get report_opt_1 => 'Nội dung khiêu dâm hoặc bạo lực máu me';

  @override
  String get report_opt_2 => 'Phỉ báng, xúc phạm hoặc tấn công nhân vật';

  @override
  String get report_opt_3 => 'Ngôn từ thù ghét hoặc tấn công cá nhân';

  @override
  String get report_opt_4 => 'Tin nhắn rác hoặc quảng cáo lừa đảo';

  @override
  String get report_opt_5 => 'Nội dung không phù hợp khác';

  @override
  String get report_confirm => 'Xác nhận báo cáo';

  @override
  String get report_success =>
      'Báo cáo thành công, đã nhận được thông báo! Sẽ sớm kiểm duyệt nội dung 🛡️';

  @override
  String get report_failed =>
      'Báo cáo thất bại, vui lòng kiểm tra kết nối mạng.';

  @override
  String get lore_delete_title => '⚠️ Cảnh báo: Xóa ký ức';

  @override
  String get lore_delete_content =>
      'Ký ức này một khi đã xóa sẽ biến mất vĩnh viễn, bạn có chắc chắn muốn xóa không?';

  @override
  String get lore_delete_cancel => 'Bấm nhầm';

  @override
  String get lore_delete_confirm => 'Xác nhận xóa';

  @override
  String get lore_delete_success => '🗑️ Mảnh ký ức đã được xóa sạch.';

  @override
  String get lore_add_title => 'Viết ký ức mới 🖋️';

  @override
  String get lore_edit_title => 'Chỉnh sửa mảnh ký ức 🖋️';

  @override
  String get lore_title_label => 'Tiêu đề ký ức';

  @override
  String get lore_title_hint => 'Ví dụ: Ngày mưa lần đầu gặp gỡ';

  @override
  String get lore_teaser_label => 'Tóm tắt / Lời dẫn';

  @override
  String get lore_teaser_hint => 'Mô tả ngắn gọn hiển thị trên thẻ...';

  @override
  String get lore_content_label => 'Nội dung ký ức đầy đủ';

  @override
  String get lore_content_hint =>
      'Viết câu chuyện hoặc thiết lập chi tiết tại đây...';

  @override
  String get lore_lock_label => '🔒 Niêm phong ký ức này';

  @override
  String get lore_lock_desc =>
      'Khi chọn, chỉ người sáng tạo mới thấy, người chơi khác không thể xem';

  @override
  String get lore_empty_error => 'Tiêu đề và nội dung không được để trống!';

  @override
  String get lore_add_success => '✨ Ký ức mới đã được niêm phong thành công!';

  @override
  String get lore_publish => 'Công bố ký ức';

  @override
  String get lore_save_edit => 'Lưu chỉnh sửa';

  @override
  String lore_write_first(Object pronoun) {
    return 'Hãy viết quá khứ đầu tiên cho $pronoun nhé!';
  }

  @override
  String lore_waiting(Object pronoun) {
    return 'Mong chờ câu chuyện cùng $pronoun...';
  }

  @override
  String get lore_sealed_msg =>
      '🔒 Ký ức này đã bị niêm phong, hiện không thể xem.';

  @override
  String get lore_not_open_msg => 'Ký ức này chưa mở cho công chúng...';

  @override
  String get lore_unnamed => 'Mảnh ký ức không tên';

  @override
  String get lore_add_btn_limit => 'Viết mảnh ký ức mới (tối đa 10 mục)';

  @override
  String get lore_collapse => 'Đóng thư';

  @override
  String get echo_delete_title => '🗑️ Xóa bình luận';

  @override
  String get echo_delete_content =>
      'Bạn có chắc chắn muốn xóa Tiếng vọng thời không này không?\nXóa rồi sẽ không lấy lại được đâu!';

  @override
  String get echo_keep => 'Giữ lại';

  @override
  String get echo_clear_success => 'Đã dọn dẹp Tiếng vọng thời không 🧹';

  @override
  String get echo_energy_full_title => '⚠️ Năng lượng vũ trụ đã đạt giới hạn';

  @override
  String get echo_energy_full_content =>
      'Năng lượng thời không của bạn đã đạt giới hạn (tối đa 3 mục), vui lòng xóa kỷ niệm cũ để mở bản ghi vũ trụ mới nhé!';

  @override
  String get echo_write_title => 'Để lại Tiếng vọng thời không của bạn 🌌';

  @override
  String get echo_write_subtitle =>
      'Hãy viết về trải nghiệm hoặc những câu nói rung động tại đây!';

  @override
  String get echo_hint =>
      '「Dù thế giới có tận thế, tôi cũng sẽ ưu tiên bảo vệ hơi thở của em...」';

  @override
  String get echo_theme_label => 'Chọn khung ghi chú:';

  @override
  String get theme_butterfly => 'Bướm';

  @override
  String get theme_sprout => 'Mầm non';

  @override
  String get theme_star => 'Sao trời';

  @override
  String get theme_planet => 'Hành tinh';

  @override
  String get echo_publish_btn => 'Công bố bản ghi thời không';

  @override
  String get echo_wall_title => 'Tường Tiếng vọng thời không';

  @override
  String get echo_leave_memory => 'Để lại trải nghiệm';

  @override
  String get echo_empty_msg =>
      'Chưa có nhà lữ hành thời không nào để lại bản ghi...\nBạn có muốn là người đầu tiên không?';

  @override
  String get creator_label => 'Người sáng tạo';

  @override
  String get follow_btn => 'Theo dõi';

  @override
  String get followed_btn => 'Đã theo dõi';

  @override
  String get follow_own_warning =>
      'Người sáng tạo không thể theo dõi chính mình đâu! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName đã theo dõi $creatorName!';
  }

  @override
  String get mailbox_follow_title => 'Nhận được người bảo vệ mới 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName vừa theo dõi bạn!';
  }

  @override
  String get tab_private_profile => 'Hồ sơ riêng tư';

  @override
  String get tab_memory_fragments => 'Mảnh ký ức';

  @override
  String get tab_time_echoes => 'Tiếng vọng thời không';

  @override
  String get chat_free_btn => 'Tán gẫu (miễn phí)';

  @override
  String get start_story_btn => 'Bắt đầu cốt truyện';

  @override
  String get default_chat_initial => 'Có việc gì tìm tôi sao?';

  @override
  String get gallery_title => 'Nền cuộc gọi độc quyền';

  @override
  String gallery_current_affection(String value) {
    return 'Mức độ thân thiết hiện tại: $value 💕';
  }

  @override
  String get gallery_empty => 'Album chưa có ảnh nào';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'Đã đặt hình nền thành \"$desc\"!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'Đạt mức độ thân thiết $value để mở khóa nhé! 🍃';
  }

  @override
  String get gallery_reset_bg => 'Đã khôi phục nền cuộc gọi mặc định';

  @override
  String get background_story_title => 'Câu chuyện bối cảnh';

  @override
  String get background_story_empty =>
      'Nhân vật này rất bí ẩn, chưa có câu chuyện bối cảnh...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'Đã theo dõi $creatorName 🦋';
  }

  @override
  String get mailbox_title => 'Hộp thư độc quyền 💌';

  @override
  String get mailbox_empty =>
      'Hộp thư trống rỗng, hãy đăng bài để thu hút anh ấy nhé!';

  @override
  String get new_notification => 'Thông báo mới';

  @override
  String get default_he => 'Anh ấy';

  @override
  String affection_upgrade_title(String charName) {
    return 'Độ thân thiết của $charName dành cho bạn đã tăng lên! 💖';
  }

  @override
  String get flower_reward => '🌸 Nhận được 5 điểm hoa';

  @override
  String get affection_quote_lv5 =>
      '「Không ngờ... em lại trở nên quan trọng với anh đến thế. Quan trọng đến mức... anh không thể tưởng tượng nổi một thế giới không có em.」';

  @override
  String get affection_quote_lv4 =>
      '「Điều may mắn nhất trong đời anh, có lẽ chính là ngày hôm đó, khi anh quay đầu lại và nhìn thấy em.」';

  @override
  String get affection_quote_lv3 =>
      '「Dạo gần đây... anh thấy mình thẩn thờ nhiều hơn, và trong đầu anh toàn là hình bóng của em thôi.」';

  @override
  String get affection_quote_lv2 =>
      '「Vì đó là lời mời của em, nên anh dành ra chút thời gian cũng không phải là không thể.」';

  @override
  String get affection_quote_lv1 =>
      '「Dạo này thường xuyên gặp em, cảm giác... cũng không ghét tần suất gặp mặt này cho lắm.」';

  @override
  String get affection_quote_lv0 =>
      '「Hóa ra em cũng ở đây, đây có tính là một loại duyên phận kỳ diệu không nhỉ?」';

  @override
  String get lore_edit_success => '✨ Mảnh ký ức đã được cập nhật thành công!';

  @override
  String get delete_failed_network =>
      'Xóa thất bại, vui lòng kiểm tra mạng hoặc quyền hạn.';

  @override
  String get ai_chat_language => 'Tiếng Việt';

  @override
  String get ai_chat_language_code => 'vi-VN';

  @override
  String get chat_home_title => 'Tin nhắn';

  @override
  String get call_memory_tooltip => 'Kỷ niệm cuộc gọi';

  @override
  String get login_to_view_chat =>
      'Vui lòng đăng nhập để xem lịch sử trò chuyện';

  @override
  String load_chat_failed(String error) {
    return 'Tải danh sách thất bại: $error';
  }

  @override
  String get chat_list_empty => 'Phòng trò chuyện trống rỗng...';

  @override
  String get go_to_encounter =>
      'Hãy đến \"Gặp gỡ\" để tìm ai đó trò chuyện nhé!';

  @override
  String confirm_delete_chat(String charName) {
    return 'Bạn có chắc chắn muốn xóa cuộc trò chuyện với $charName?';
  }

  @override
  String affection_score_short(String score) {
    return 'Thân thiết $score';
  }

  @override
  String get character_not_found =>
      'Không tìm thấy dữ liệu, nhân vật có thể đã bị xóa.';

  @override
  String get preparing_chat_room =>
      'Đang chuẩn bị phòng trò chuyện độc quyền của bạn...';

  @override
  String get rename_chat_title => 'Đặt tên cho kỷ niệm này';

  @override
  String get rename_chat_hint =>
      'Ví dụ: Đổi (Trình Du) thành (Đếm ngược ly hôn)';

  @override
  String get save_tag_btn => 'Lưu thẻ';

  @override
  String get room_name_updated => 'Tên phòng đã được cập nhật!';

  @override
  String update_failed(String error) {
    return 'Cập nhật thất bại: $error';
  }

  @override
  String get chat_mode_daily => 'Hằng ngày';

  @override
  String get chat_mode_story => 'Cốt truyện';

  @override
  String get chat_mode_immersive => 'Đắm chìm';

  @override
  String get chat_mode_gemini => 'Tán gẫu';

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
      'Không tìm thấy dữ liệu nhân vật, vui lòng quay lại thử lại hoặc kiểm tra mạng.';

  @override
  String get chat_jump_success => 'Đã chuyển đến phân đoạn ký ức này 🍃';

  @override
  String get chat_create_room_failed =>
      'Kết nối không ổn định, tạo phòng trò chuyện thất bại, vui lòng thử lại.';

  @override
  String get chat_secret_file_title => '🔒 Hồ sơ tuyệt mật';

  @override
  String get chat_secret_file_desc =>
      'Hồ sơ linh hồn của nhân vật này đã được lưu trữ hoặc chuyển sang chế độ riêng tư, tạm thời không thể xem chi tiết.';

  @override
  String get chat_understood => 'Đã hiểu';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ Nhận được ký ức mới: $title';
  }

  @override
  String get chat_egg_saved => 'Đã tự động đưa vào kho đồ độc quyền';

  @override
  String get chat_points_not_enough_title => 'Không đủ hoa';

  @override
  String get chat_points_not_enough_desc =>
      'Hoa của bạn không đủ! Vui lòng đến cửa hàng để nạp thêm.';

  @override
  String chat_call_confirm_title(String name) {
    return 'Bạn muốn gọi cho $name chứ?';
  }

  @override
  String get chat_call_rule_1 => 'Mỗi cuộc gọi sẽ trừ 20 điểm hoa';

  @override
  String get chat_call_rule_2 =>
      'Thời gian gọi là 1 phút, nếu không tiện nói chuyện bạn có thể truyền đạt bằng tin nhắn';

  @override
  String get chat_call_rule_3 =>
      'Nên đeo tai nghe để nghe rõ giọng nói của anh ấy hơn ✨';

  @override
  String get chat_call_btn_cancel => 'Để sau đi';

  @override
  String get chat_call_pref_title => 'Thiết lập ưu tiên cuộc gọi';

  @override
  String get chat_call_lang_select => 'Chọn ngôn ngữ cuộc gọi';

  @override
  String get chat_call_save_memory => 'Lưu lại ký ức cuộc gọi này';

  @override
  String get chat_call_save_memory_desc =>
      'Có thể nghe lại sau khi cuộc gọi kết thúc';

  @override
  String get chat_call_btn_start => 'Bắt đầu cuộc gọi';

  @override
  String chat_points_shortage(String points) {
    return 'Điểm hoa không đủ! Hiện tại có $points điểm';
  }

  @override
  String get chat_room_not_ready =>
      'Phòng trò chuyện chưa sẵn sàng, vui lòng vào lại.';

  @override
  String get chat_stop_generating_msg =>
      'Đã dừng phản hồi, điểm hoa không bị trừ 🍃';

  @override
  String get chat_heartbeat_up => 'Tim anh ấy đập nhanh hơn rồi...';

  @override
  String get chat_heartbeat_down => 'Ánh mắt anh ấy trở nên lạnh lùng...';

  @override
  String get chat_msg_copy => 'Sao chép nội dung';

  @override
  String get chat_msg_copied => 'Đã sao chép vào bộ nhớ tạm!';

  @override
  String get chat_msg_report => 'Báo cáo tin nhắn này';

  @override
  String get chat_msg_suggest => 'Góp ý';

  @override
  String get chat_report_title => 'Báo cáo cuộc hội thoại này';

  @override
  String get chat_report_lang => 'Xuất hiện tiếng nước ngoài';

  @override
  String get chat_report_inapp => 'Phản hồi không phù hợp';

  @override
  String get chat_report_context => 'Ngữ cảnh không liên kết';

  @override
  String get chat_report_other => 'Lý do khác';

  @override
  String get chat_report_hint => 'Vui lòng mô tả vấn đề bạn gặp phải...';

  @override
  String get chat_report_submit => 'Gửi đi';

  @override
  String get chat_report_success =>
      '✅ Báo cáo đã được gửi, chúng tôi sẽ sớm điều chỉnh';

  @override
  String get chat_suggest_title => 'Góp ý cho chúng tôi';

  @override
  String get chat_suggest_hint => 'Vui lòng viết ý kiến quý báu của bạn...';

  @override
  String get chat_suggest_success =>
      '💖 Cảm ơn góp ý của bạn, chúng tôi sẽ xử lý sớm nhất có thể';

  @override
  String get chat_del_warn => 'Tin nhắn sau khi xóa sẽ không thể khôi phục.';

  @override
  String get chat_reset_title => 'Đặt lại ký ức';

  @override
  String get chat_reset_desc =>
      'Vui lòng chọn mức độ đặt lại:\n\n1. 【Chỉ cuộc trò chuyện】: Xóa lịch sử trò chuyện nhưng giữ nguyên độ thân thiết.\n2. 【Đặt lại hoàn toàn】: Mọi thứ trở về con số không, như lần đầu gặp mặt.';

  @override
  String get chat_reset_only_chat => 'Chỉ lịch sử trò chuyện';

  @override
  String get chat_reset_full => 'Đặt lại hoàn toàn';

  @override
  String get chat_reset_full_msg =>
      'Mọi thứ đã trở về lúc bắt đầu, anh ấy không còn nhớ em nữa...';

  @override
  String get chat_reset_chat_msg =>
      'Cuộc trò chuyện đã được làm trống, nhưng tình cảm anh ấy dành cho em vẫn còn đó.';

  @override
  String get chat_edit_ai_hint => 'Chỉnh sửa phản hồi của anh ấy...';

  @override
  String get chat_edit_user_hint => 'Vui lòng nhập nội dung mới...';

  @override
  String chat_no_voice_msg(String name) {
    return 'Hiện tại vẫn chưa có giọng nói của $name...';
  }

  @override
  String get chat_poke_btn => 'Chọc một cái';

  @override
  String get chat_poke_success =>
      '✨ Đã giúp em chọc nhà sáng tạo rồi nhé! Hãy chờ đợi giọng nói của anh ấy sớm ra mắt nha~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'Điểm hoa không đủ! Cần $cost điểm 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ Người tình định mệnh ✨';

  @override
  String get chat_levelup_normal => 'Mối quan hệ thăng cấp! 💖';

  @override
  String get chat_levelup_btn_soulmate => 'Khắc sâu vào linh hồn';

  @override
  String get chat_levelup_btn_normal => 'Rung động đón nhận';

  @override
  String get chat_loc_title => '📍 Gửi định vị ảo';

  @override
  String get chat_loc_custom_btn => 'Gửi định vị tùy chỉnh';

  @override
  String get chat_loc_hint => 'Nhập địa điểm khác... (Ví dụ: Trong tim anh)';

  @override
  String get chat_loc_1 => 'Dưới lầu nhà em';

  @override
  String get chat_loc_2 => 'Ở trường học';

  @override
  String get chat_loc_3 => 'Ở quán cà phê vừa đi ngang qua';

  @override
  String get chat_loc_4 => 'Ở cửa hàng tiện lợi';

  @override
  String get chat_interact_title => '✨ Bạn muốn làm gì với anh ấy?';

  @override
  String get chat_interact_action => 'Chọc ghẹo và hành động nhỏ';

  @override
  String get chat_interact_gift => 'Tặng quà nhỏ cho anh ấy (tiêu tốn hoa 🌸)';

  @override
  String get chat_action_poke => 'Chọc má';

  @override
  String get chat_action_hug => 'Đòi ôm';

  @override
  String get chat_action_hand => 'Âm thầm nắm tay';

  @override
  String get chat_dice_btn => 'Tung xúc xắc';

  @override
  String get chat_loading_failed =>
      'Tải ký ức thất bại, vui lòng quay lại thử lại.';

  @override
  String get chat_test_mode_msg =>
      'Chế độ thử nghiệm đã mở, hãy cứ trò chuyện thoải mái! (Cuộc trò chuyện sẽ không được lưu)';

  @override
  String get chat_empty_msg =>
      'Hãy bắt đầu hành trình rung động cùng anh ấy thôi nào!';

  @override
  String get chat_ai_typing => 'Đối phương đang trả lời...';

  @override
  String get chat_input_hint_default => 'Muốn nói gì với anh ấy đây...';

  @override
  String get chat_typing_indicator => 'Đang nhập...';

  @override
  String get chat_menu_search => 'Tìm kiếm trò chuyện';

  @override
  String get chat_menu_gallery => 'Ký ức và hình nền độc quyền';

  @override
  String get chat_menu_aboutme => 'Liên quan đến tôi';

  @override
  String get chat_menu_memo => 'Bản ghi nhớ cho anh ấy';

  @override
  String get chat_menu_period => 'Theo dõi kỳ kinh nguyệt';

  @override
  String get chat_menu_reset => 'Đặt lại ký ức';

  @override
  String get chat_search_hint =>
      'Bạn muốn hồi tưởng đoạn hội thoại ngọt ngào nào?';

  @override
  String get chat_search_empty => 'Không tìm thấy đoạn ký ức này 🥺';

  @override
  String get chat_search_you => 'Bạn nói';

  @override
  String get chat_search_him => 'Anh ấy nói';

  @override
  String get chat_tool_backpack => 'Kho đồ';

  @override
  String get chat_tool_story => 'Tóm tắt cốt truyện';

  @override
  String get chat_tool_photo => 'Ảnh';

  @override
  String get chat_tool_record => 'Ghi âm';

  @override
  String get chat_tool_profile => 'Hồ sơ Thập Quang';

  @override
  String get chat_tool_interact => 'Cách chơi tương tác';

  @override
  String get chat_record_recording => 'Đang ghi âm...';

  @override
  String get chat_record_start => 'Nhấn vào micro để bắt đầu ghi âm';

  @override
  String get chat_record_done => 'Ghi âm hoàn tất';

  @override
  String get chat_mode_daily_desc =>
      'Tán gẫu vui vẻ mỗi ngày, giống như những người bạn vậy!';

  @override
  String get chat_mode_story_desc => 'Cốt truyện tiến triển như tiểu thuyết.';

  @override
  String get chat_mode_immersive_desc =>
      'Trải nghiệm cảm quan cực hạn, tương tác sâu sắc không giới hạn.';

  @override
  String get chat_switch_mode_title => 'Chuyển đổi chế độ trò chuyện';

  @override
  String get chat_voice_call => 'Gọi thoại';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【Sự kiện hệ thống】$playerName đã tặng một 【$giftName】.';
  }

  @override
  String get rel_title_soulmate => 'Tri kỷ/Yêu sâu đậm';

  @override
  String get rel_title_lover => 'Giai đoạn mặn nồng/Bạn trai độc quyền';

  @override
  String get rel_title_ambiguous => 'Giai đoạn mập mờ/Thăm dò lẫn nhau';

  @override
  String get rel_title_friend => 'Bạn bình thường/Cảm tình chớm nở';

  @override
  String get rel_title_acquaintance => 'Người quen/Hơi quen mặt';

  @override
  String get rel_title_stranger => 'Người lạ/Mới quen';

  @override
  String get rel_title_tense => 'Quan hệ căng thẳng/Cảm thấy chán ghét';

  @override
  String get rel_title_avoiding => 'Như người dưng/Cố ý né tránh';

  @override
  String get rel_title_hostile => 'Cực kỳ ghét bỏ/Thù địch lạnh lùng';

  @override
  String get rel_title_nemesis =>
      'Kẻ thù không đội trời chung/Không bao giờ gặp lại';

  @override
  String get rel_msg_soulmate =>
      '「Không ngờ... em lại trở nên quan trọng với anh đến thế. Quan trọng đến mức... anh không thể tưởng tượng nổi một thế giới không có em.」';

  @override
  String get rel_msg_lover =>
      '「Điều may mắn nhất trong đời anh, có lẽ chính là ngày hôm đó, khi anh quay đầu lại và nhìn thấy em.」';

  @override
  String get rel_msg_ambiguous =>
      '「Dạo gần đây... anh thấy mình thẩn thờ nhiều hơn, và trong đầu anh toàn là hình bóng của em thôi.」';

  @override
  String get rel_msg_friend =>
      '「Vì đó là lời mời của em, nên anh dành ra chút thời gian cũng không phải là không thể.」';

  @override
  String get rel_msg_acquaintance =>
      '「Dạo này thường xuyên gặp em, cảm giác... cũng không ghét tần suất gặp mặt này cho lắm.」';

  @override
  String get rel_msg_stranger =>
      '「Hóa ra em cũng ở đây, đây có tính là một loại duyên phận kỳ diệu không nhỉ?」';

  @override
  String chat_edit_char_count(String count) {
    return '$count ký tự';
  }

  @override
  String get chat_mysterious_player => 'Người chơi bí ẩn';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return 'Người chơi $playerName đang rất mong chờ được nghe giọng nói của $characterName, hãy đi tạo ngay nhé!';
  }

  @override
  String get gift_heart => 'Trái tim';

  @override
  String get gift_flower => 'Hoa';

  @override
  String get gift_sun => 'Mặt trời';

  @override
  String get gift_confetti => 'Pháo hoa giấy';

  @override
  String get gift_coffee => 'Cà phê';

  @override
  String get gift_cake => 'Bánh ngọt';

  @override
  String get chat_action_poke_prompt =>
      '(Người chơi bất ngờ đưa tay ra, tinh nghịch chọc vào má bạn)';

  @override
  String get chat_action_hug_prompt =>
      '(Người chơi tủi thân mở rộng vòng tay, muốn một cái ôm ấm áp)';

  @override
  String get chat_action_hand_prompt =>
      '(Người chơi âm thầm nắm lấy tay bạn dưới gầm bàn)';

  @override
  String get chat_menu_send_location => 'Gửi định vị ảo';

  @override
  String get weekday_mon => '(Thứ 2)';

  @override
  String get weekday_tue => '(Thứ 3)';

  @override
  String get weekday_wed => '(Thứ 4)';

  @override
  String get weekday_thu => '(Thứ 5)';

  @override
  String get weekday_fri => '(Thứ 6)';

  @override
  String get weekday_sat => '(Thứ 7)';

  @override
  String get weekday_sun => '(CN)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ Nhận được ký ức mới: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'Đã tự động đưa vào kho đồ độc quyền của anh ấy';

  @override
  String get chat_profile_updated_msg =>
      'Hồ sơ Thập Quang đã cập nhật! Anh ấy sẽ nhớ những thiết lập mới nhất của bạn đó 🍃';

  @override
  String get comment_loading_author => 'Đang tải...';

  @override
  String comment_post_failed(String error) {
    return 'Bình luận thất bại, vui lòng kiểm tra kết nối: $error';
  }

  @override
  String get comment_delete_confirm_desc =>
      'Bạn có chắc chắn muốn xóa vĩnh viễn bình luận này không?';

  @override
  String get comment_delete_failed =>
      'Xóa thất bại, vui lòng kiểm tra kết nối mạng của bạn';

  @override
  String get comment_identity_title => 'Chọn danh tính bình luận';

  @override
  String get comment_identity_myself => 'Chính tôi';

  @override
  String get comment_report_title => 'Xác nhận báo cáo';

  @override
  String get comment_report_rules_title => '⚖️ Quy định báo cáo bình luận';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ Vi phạm lần đầu: Hệ thống cảnh cáo và ghi lại một lần vi phạm.\n2️⃣ Vi phạm lần hai: Cấm bình luận trong 1 ngày.\n3️⃣ Tái phạm: Vô hiệu hóa tính năng báo cáo trong 14 ngày và giảm khả năng hiển thị bình luận.\n\n🚨 Đối với hành vi ác ý nghiêm trọng:\nCấm tương tác với nhân vật trong 1 ngày, ID sẽ được thông báo trên bảng tin trong 3 ngày (trong thời gian này không được đổi ID).\n\n💡 Sau khi gửi báo cáo, kết quả xét duyệt cuối cùng sẽ được gửi cho bạn qua [Thư trong trò chơi].\nVui lòng tôn trọng lẫn nhau và báo cáo một cách lý trí.';

  @override
  String get comment_report_understood => 'Tôi đã hiểu';

  @override
  String get comment_report_confirm_desc =>
      'Bạn có chắc chắn muốn báo cáo bình luận này không?\nBáo cáo ác ý có thể bị trừng phạt.';

  @override
  String get comment_report_submit_btn => 'Xác nhận báo cáo';

  @override
  String get comment_report_success =>
      'Cảm ơn bạn đã báo cáo, chúng tôi sẽ sớm xác minh!';

  @override
  String get comment_report_failed =>
      'Gửi báo cáo thất bại, vui lòng thử lại sau.';

  @override
  String get comment_option_delete => 'Xóa bình luận';

  @override
  String get comment_option_report => 'Báo cáo bình luận';

  @override
  String comment_time_days_ago(String days) {
    return '$days ngày trước';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '$hours giờ trước';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '$mins phút trước';
  }

  @override
  String get comment_time_just_now => 'Vừa xong';

  @override
  String get comment_sheet_title => 'Bình luận';

  @override
  String get comment_empty_state =>
      'Chưa có ai bình luận, hãy là người đầu tiên!';

  @override
  String get comment_reply_btn => 'Trả lời';

  @override
  String comment_replying_to(String name) {
    return 'Đang trả lời @$name';
  }

  @override
  String comment_input_hint(String name) {
    return 'Bình luận dưới danh nghĩa $name...';
  }

  @override
  String char_story_expect(String pronoun) {
    return 'Mong chờ câu chuyện với $pronoun...';
  }

  @override
  String get common_update_failed =>
      'Cập nhật thất bại, vui lòng kiểm tra mạng';

  @override
  String get char_edit_fragment => 'Chỉnh sửa mảnh ghép';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 Ghét: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 Thích: $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age tuổi | $job';
  }

  @override
  String get common_got_it => 'Đã hiểu';

  @override
  String get common_add_failed => 'Thêm thất bại, vui lòng kiểm tra mạng';

  @override
  String common_delete_failed_with_err(String error) {
    return 'Xóa thất bại, vui lòng kiểm tra trạng thái mạng: $error';
  }

  @override
  String get char_exclusive_guardian => 'Người bảo vệ độc quyền 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName đã thích $charName!';
  }

  @override
  String chat_translation_prefix(String content) {
    return '[Dịch] $content (Đây là nội dung cảm xúc đã được dịch)';
  }

  @override
  String get player_default_nickname => 'Lữ khách';

  @override
  String get moment_create_title => 'Tạo bài viết mới';

  @override
  String get moment_create_post_btn => 'Đăng';

  @override
  String get moment_create_hint => 'Chia sẻ điều gì đó mới...';

  @override
  String get moment_create_error_empty =>
      'Cần có ít nhất văn bản hoặc hình ảnh!';

  @override
  String get moment_create_error_failed =>
      'Đăng bài thất bại, vui lòng thử lại sau';

  @override
  String get moment_create_visibility_public =>
      'Công khai (Mọi người đều có thể xem)';

  @override
  String get moment_create_visibility_private =>
      'Riêng tư (Chỉ bạn bè mới có thể xem)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (Người chơi đã gửi vị trí: $location)';
  }

  @override
  String get chat_you => 'Bạn';

  @override
  String get chat_opponent => 'Đối thủ';

  @override
  String chat_dice_duel_result(String name) {
    return '【Sự kiện hệ thống】Quyết đấu xúc xắc với $name! Kết quả đã có...';
  }

  @override
  String get chat_loading_status => 'Đang tải...';

  @override
  String chat_error_load_msg(String error) {
    return 'Tải tin nhắn thất bại: $error';
  }

  @override
  String get chat_voice_msg_label => 'Tin nhắn thoại';

  @override
  String chat_special_story_trigger(String title) {
    return '【Mở cốt truyện đặc biệt: $title】';
  }

  @override
  String common_edit_failed(String error) {
    return 'Chỉnh sửa thất bại: $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'Đặt lại thất bại: $error';
  }

  @override
  String get chat_default_greeting => 'Xin chào...';

  @override
  String get chat_memory_cleared => 'Ký ức đã được xóa hoàn toàn';

  @override
  String get chat_history_reset => 'Cuộc trò chuyện đã được đặt lại';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 【 Hồ sơ Thập Quang độc quyền - $name 】\n━━━━━━━━━━━━━━━━━━\n🔹 Tên: $identity\n🔹 Sinh nhật: $birthday\n🔹 Chiều cao: $height\n🔹 Ngoại hình: $appearance\n🔹 Nghề nghiệp: $job\n\n📖 【 Về mảnh ghép linh hồn của cô ấy 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 【 Hồ sơ Thập Quang độc quyền 】\n━━━━━━━━━━━━━━━━━━\n🔹 Biệt danh: $nickname\n🔹 Sinh nhật: $birthday\n\n🔒 Các dữ liệu nhân vật khác chưa được mở khóa...\n(Hãy điền đầy đủ hồ sơ để anh ấy hiểu bạn hơn trong vũ trụ song song nhé! ✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => 'Hồ sơ chưa đặt tên';

  @override
  String get chat_default_player_name => 'Người chơi';

  @override
  String get error_system_confusion =>
      'Hệ thống đang hơi nhầm lẫn, vui lòng thử lại.';

  @override
  String get error_msg_send_failed =>
      'Gửi tin nhắn thất bại, vui lòng thử lại.';

  @override
  String get error_system_busy => 'Hệ thống bận, vui lòng thử lại sau.';

  @override
  String get error_network_unavailable =>
      'Hiện tại không thể kết nối, vui lòng thử lại.';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 Cuộc gọi kết thúc, đã trò chuyện với $name trong $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return 'Cốt truyện độc quyền: $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'Đây là một ký ức ẩn dành riêng cho bạn và $name...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return 'Một ký ức độc quyền về \"$keyword\" đã âm thầm mở khóa...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '【Kích hoạt sự kiện ẩn: $title】\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......(Anh ấy lẳng lặng nhìn bạn, dường như đang đợi bạn lên tiếng trước)';

  @override
  String get chat_new_room_created => 'Phòng trò chuyện mới đã được tạo';

  @override
  String portfolio_title(String nickname) {
    return 'Tác phẩm của $nickname';
  }

  @override
  String get enter_secret_studio => 'Vào phòng làm việc bí mật của tôi';

  @override
  String get no_public_character_mine =>
      'Bạn chưa phát hành bất kỳ nhân vật công khai nào!\nHãy đến phòng làm việc để sáng tạo nhé✨';

  @override
  String get no_public_character_other =>
      'Người sáng tạo này vẫn chưa phát hành nhân vật nào...';

  @override
  String get delete_draft_title => 'Xóa bản nháp';

  @override
  String get confirm_delete_draft_msg =>
      'Bạn có chắc chắn muốn xóa nhân vật chưa hoàn thành này không?\n(Không thể khôi phục sau khi xóa)';

  @override
  String get draft_cleared_success => 'Đã dọn sạch bản nháp 🧹';

  @override
  String get login_required_for_studio =>
      'Vui lòng đăng nhập trước để vào phòng làm việc!';

  @override
  String get my_secret_studio_title => 'Phòng làm việc bí mật của tôi 🛠️';

  @override
  String get create_new_character_btn => 'Tạo nhân vật mới';

  @override
  String get unnamed_draft => 'Bản nháp chưa đặt tên';

  @override
  String get click_to_edit_story =>
      'Nhấn vào để tiếp tục chỉnh sửa câu chuyện của anh ấy...';

  @override
  String get label_draft => 'Bản nháp';

  @override
  String get studio_empty_title => 'Phòng làm việc hiện đang trống không';

  @override
  String get studio_empty_subtitle =>
      'Nhấn vào góc dưới để bắt đầu tạo nhân vật đầu tiên của bạn nhé!';

  @override
  String get common_no_changes => 'Không có thay đổi nào';

  @override
  String get moment_updated_success => 'Bài viết đã được cập nhật!';

  @override
  String common_save_failed(String error) {
    return 'Lưu thất bại: $error';
  }

  @override
  String get moment_edit_title => 'Chỉnh sửa bài viết';

  @override
  String get action_change_image => 'Đổi hình ảnh';

  @override
  String get action_remove_image => 'Xóa hình ảnh';

  @override
  String get moment_delete_confirm_title =>
      'Bạn có chắc chắn muốn xóa bài viết này không?';

  @override
  String get moment_delete_confirm_content =>
      'Sau khi xóa, ký ức trong khoảnh khắc này sẽ biến mất đấy!';

  @override
  String get action_confirm_delete => 'Xác nhận xóa';

  @override
  String get friend_unknown => 'Một người bạn';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname cảm thấy bài viết của bạn rất tuyệt! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname thấy $authorName rất quyến rũ nên đã nhấn thích! ✨';
  }

  @override
  String get moment_like_success => 'Đã gửi đi sự rung động của bạn! ✨';

  @override
  String get moment_notification_new_like => 'Lượt thích mới! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname đã nhắc đến @$name trong bài viết nhé! ✨';
  }

  @override
  String get moment_detail_title => 'Chi tiết bài viết';

  @override
  String get moment_not_found => 'Bài viết này hình như đã biến mất rồi... 😢';

  @override
  String get moment_comment_title => 'Bình luận khoảnh khắc';

  @override
  String get moment_comment_empty =>
      'Chưa có ai bình luận, hãy là người đầu tiên nhé! 🛋';

  @override
  String moment_replying_to(String name) {
    return 'Đang trả lời @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return 'Trả lời @$name...';
  }

  @override
  String get moment_leave_comment_hint => 'Để lại phản hồi của bạn...';

  @override
  String get moment_delete_permanent_confirm =>
      'Bài viết này sẽ bị xóa vĩnh viễn, bạn có chắc chắn không?';

  @override
  String get moment_action_delete => 'Xóa bài viết';

  @override
  String get moment_action_report => 'Báo cáo bài viết này';

  @override
  String get moment_action_share => 'Chia sẻ bài viết này';

  @override
  String get moment_forward_hint => 'Chuyển tiếp bài viết này cho nhân vật...';

  @override
  String moment_reply_private(String name) {
    return 'Trả lời tin nhắn riêng cho $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return 'Hãy cùng trò chuyện với $name về bài viết này nào! 💬';
  }

  @override
  String get moment_share_to_apps => 'Chia sẻ sang ứng dụng khác';

  @override
  String moment_likes_label(String count) {
    return '$count Chiếc lá';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】Vào xem bài viết của $author nè: $content\n\nTải ngay để bắt đầu khoảng thời gian độc quyền của bạn: $appLink';
  }

  @override
  String get moment_forward_title =>
      'Chuyển tiếp cho nhân vật đang trò chuyện 💌';

  @override
  String get moment_forward_empty_state =>
      'Bạn hiện chưa có cuộc trò chuyện nào!\nHãy đến Sảnh để tìm người tâm đầu ý hợp nhé 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【Đã chuyển tiếp một bài viết】\nTác giả: $author\nNội dung: $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ Đã âm thầm chia sẻ với $name rồi nhé!';
  }

  @override
  String get action_send => 'Gửi';

  @override
  String get memo_delete_confirm =>
      'Bạn có chắc chắn muốn xóa ghi chú này không? Thao tác này không thể hoàn tác.';

  @override
  String get memo_add_title => 'Thêm ghi chú';

  @override
  String get memo_edit_title => 'Chỉnh sửa ghi chú';

  @override
  String memo_hint_text(String name) {
    return 'Bạn muốn ghi lại điều gì về $name?';
  }

  @override
  String get memo_label_reminder_date => 'Ngày nhắc nhở:';

  @override
  String get memo_action_save => 'Lưu ghi chú';

  @override
  String get memo_error_empty_content => 'Nội dung không được để trống!';

  @override
  String memo_list_title(String name) {
    return 'Ghi chú về $name';
  }

  @override
  String get memo_empty_state =>
      'Chưa có ghi chú nào!\nNhấn vào góc trên bên phải để thêm mới nhé!';

  @override
  String memo_reminder_date_display(String date) {
    return 'Ngày nhắc: $date';
  }

  @override
  String get daily_gift_title => 'Quà tặng thời gian mỗi ngày';

  @override
  String daily_login_welcome(String appName, String amount) {
    return 'Chào mừng bạn quay lại với $appName!\nĐiểm danh hôm nay để nhận $amount điểm Ngôn ngữ hoa. 🌸';
  }

  @override
  String get title_daily_check_in => 'Điểm danh mỗi ngày';

  @override
  String success_claim_reward(String amount) {
    return 'Nhận thành công $amount điểm Ngôn ngữ hoa! 🌸';
  }

  @override
  String get error_claim_failed =>
      'Nhận thất bại, vui lòng kiểm tra mạng và thử lại.';

  @override
  String get action_claim_now => 'Nhận ngay';

  @override
  String get common_or => 'hoặc';

  @override
  String get title_language_settings => 'Cài đặt ngôn ngữ';

  @override
  String get app_name => 'Luyến Luyến Thập Quang';

  @override
  String get login_slogan => 'Bắt đầu khoảng thời gian độc quyền của bạn';

  @override
  String get login_with_google => 'Đăng nhập bằng Google';

  @override
  String get login_with_apple => 'Đăng nhập bằng Apple';

  @override
  String get login_with_facebook => 'Đăng nhập bằng Facebook';

  @override
  String get login_with_email => 'Đăng nhập bằng tài khoản Luyến Luyến (Email)';

  @override
  String get title_contact_us_heading =>
      'Chúng tôi rất coi trọng những góp ý của bạn!';

  @override
  String get desc_contact_us_body =>
      'Vui lòng viết ra suy nghĩ của bạn ở đây để giúp chúng tôi làm cho trò chơi trở nên tốt hơn.';

  @override
  String get error_feedback_empty => 'Nội dung góp ý không được để trống!';

  @override
  String get email_subject_feedback =>
      'Luyến Luyến Thập Quang - Góp ý của người chơi';

  @override
  String get msg_email_app_not_found_copied =>
      'Không thể tự động mở ứng dụng thư, đã sao chép email chính thức cho bạn!';

  @override
  String get title_contact_us => 'Liên hệ chúng tôi';

  @override
  String get desc_contact_us =>
      'Chúng tôi rất coi trọng những góp ý của bạn!\nVui lòng viết ra suy nghĩ của bạn ở đây để giúp chúng tôi làm cho trò chơi trở nên tốt hơn.';

  @override
  String get hint_enter_feedback => 'Vui lòng nhập góp ý của bạn tại đây...';

  @override
  String get action_send_via_email => 'Gửi qua Email';

  @override
  String get error_email_password_empty =>
      'Email và mật khẩu không được để trống!';

  @override
  String get auth_error_default => 'Đã xảy ra lỗi, vui lòng thử lại sau.';

  @override
  String get auth_error_user_not_found =>
      'Không tìm thấy email này, vui lòng đăng ký trước!';

  @override
  String get auth_error_wrong_password => 'Sai mật khẩu, vui lòng thử lại!';

  @override
  String get auth_error_email_in_use =>
      'Email này đã được đăng ký! Vui lòng đăng nhập trực tiếp.';

  @override
  String get auth_error_weak_password =>
      'Mật khẩu quá yếu, vui lòng nhập ít nhất 6 ký tự!';

  @override
  String get auth_error_invalid_email => 'Định dạng email không hợp lệ!';

  @override
  String get title_welcome_back => 'Chào mừng trở lại';

  @override
  String get title_register_account => 'Đăng ký tài khoản độc quyền';

  @override
  String get label_email => 'Email';

  @override
  String get label_password => 'Mật khẩu';

  @override
  String get action_login => 'Đăng nhập';

  @override
  String get action_register => 'Đăng ký';

  @override
  String get prompt_no_account => 'Chưa có tài khoản? Nhấn vào đây để đăng ký';

  @override
  String get prompt_has_account => 'Đã có tài khoản? Nhấn vào đây để đăng nhập';

  @override
  String get error_nickname_empty => 'Biệt danh không được để trống!';

  @override
  String get profile_saved_success => 'Đã lưu hồ sơ!';

  @override
  String get error_id_empty => 'ID không được để trống!';

  @override
  String get error_id_too_long => 'Độ dài ID không được vượt quá 10 ký tự!';

  @override
  String get error_id_already_used =>
      'ID này đã được sử dụng, vui lòng chọn ID khác!';

  @override
  String profile_save_failed(String error) {
    return 'Lưu thất bại: $error';
  }

  @override
  String get draft_saved_success_msg =>
      'Đã rõ! Đã lưu vào bản nháp cho bạn, bạn có thể quay lại chỉnh sửa bất cứ lúc nào! ✨';

  @override
  String get dialog_reminder_title => 'Nhắc nhở';

  @override
  String get warning_id_not_edited =>
      'ID độc quyền chưa được chỉnh sửa, bạn có chắc chắn muốn lưu bây giờ không?';

  @override
  String get action_continue_editing => 'Tiếp tục chỉnh sửa';

  @override
  String get action_edit_later => 'Chỉnh sửa sau';

  @override
  String get action_edit_later_short => 'Sửa sau';

  @override
  String get action_cancel_changes => 'Hủy thay đổi';

  @override
  String get error_birthdate_locked =>
      'Ngày sinh đã được đặt, không thể thay đổi!';

  @override
  String get action_select_avatar => 'Chọn ảnh đại diện';

  @override
  String get action_choose_from_gallery => 'Chọn từ thư viện';

  @override
  String get title_adjust_avatar => 'Điều chỉnh ảnh đại diện của bạn';

  @override
  String get avatar_updated_success => 'Đã đổi ảnh đại diện cho bạn 🍃';

  @override
  String get title_create_profile => 'Tạo hồ sơ của bạn';

  @override
  String get title_edit_profile => 'Chỉnh sửa hồ sơ';

  @override
  String get label_your_nickname => 'Biệt danh của bạn';

  @override
  String get label_player_exclusive_id => 'ID độc quyền của người chơi';

  @override
  String get msg_id_locked => 'ID đã bị khóa, không thể thay đổi nữa.';

  @override
  String get msg_id_change_chance => 'Bạn có một cơ hội miễn phí để đổi ID.';

  @override
  String get action_select_birthdate => 'Vui lòng chọn ngày sinh';

  @override
  String label_birthdate(String date) {
    return 'Ngày sinh: $date';
  }

  @override
  String get msg_birthdate_immutable =>
      'Sinh nhật sau khi thiết lập sẽ không thể thay đổi ✨';

  @override
  String get action_start_journey => 'Bắt đầu hành trình';

  @override
  String get action_add_image => 'Thêm hình ảnh';

  @override
  String moment_like_self(String nickname) {
    return '$nickname cảm thấy bài viết của bạn rất tuyệt! 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname thấy $authorName rất quyến rũ nên đã nhấn thích! ✨';
  }

  @override
  String get task_social_tour_complete =>
      '✨ Hoàn thành nhiệm vụ dạo quanh mạng xã hội! Đừng quên nhận hoa nhé! 🌸';

  @override
  String get wall_title_shiguang => 'Tường Thập Quang';

  @override
  String get wall_tab_explore => '🌍 Khám phá';

  @override
  String get wall_tab_exclusive => '🔒 Độc quyền';

  @override
  String get more_options => 'Tùy chọn khác';

  @override
  String get delete_warning =>
      'Sau khi xóa, bài viết sẽ không thể lấy lại được';

  @override
  String get delete_success => 'Xóa thành công';

  @override
  String get notification_new_comment => 'Bình luận mới! 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName đã thích bài viết của bạn!';
  }

  @override
  String get empty_public_moments_prompt =>
      'Hiện tại đang trống rỗng,\nhãy đi đăng bài viết công khai đầu tiên nhé! 🌍';

  @override
  String get empty_private_moments_prompt =>
      'Vòng bạn bè vẫn chưa có khoảnh khắc nào,\nhãy đi tạo kỷ niệm cùng anh ấy nhé! ✨';

  @override
  String get profile_archived_or_deleted_message =>
      'Hồ sơ linh hồn này đã được người sáng tạo lưu trữ, đặt ở chế độ riêng tư, hoặc đã tan biến trong dòng chảy thời gian...\n\nCó lẽ ở một vũ trụ song song nào đó, bạn vẫn có cơ hội gặp lại họ. ✨';

  @override
  String get leave_silently => 'Lặng lẽ rời đi';

  @override
  String get character_post_schedule => 'Lịch đăng bài của nhân vật';

  @override
  String get creator_self => 'Chính người sáng tạo';

  @override
  String get post_identity_prompt =>
      'Hôm nay bạn muốn đăng bài với tư cách ai?';

  @override
  String get identity_creator => '✨ Tư cách Người sáng tạo';

  @override
  String get identity_character => 'Tư cách Nhân vật';

  @override
  String get decide_post_time_prompt =>
      'Giúp họ quyết định thời gian đăng bài nhé!';

  @override
  String get auto_post_schedule_hint =>
      'Sau khi bật, các bài đăng hàng ngày sẽ được đăng tự động vào thời gian đã chỉ định\n(💡 Gợi ý: Hãy đặt thời gian lẻ để trông giống người thật hơn nhé!)';

  @override
  String get no_characters_created_yet =>
      'Bạn vẫn chưa tạo bất kỳ nhân vật nào!';

  @override
  String time_hour(String hour) {
    return '$hour giờ';
  }

  @override
  String time_minute(String minute) {
    return '$minute phút';
  }

  @override
  String get empty_public_moments_short => 'Hiện chưa có bài đăng công khai 🌍';

  @override
  String get empty_private_moments_short => 'Vòng bạn bè vẫn đang im lìm ✨';

  @override
  String get my_created_characters => 'Nhân vật tôi đã tạo';

  @override
  String get no_characters_yet => 'Chưa tạo nhân vật nào';

  @override
  String play_count_display(int count) {
    return 'Số lần chơi: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return 'Lịch quan tâm của $characterName';
  }

  @override
  String get care_calendar_greeting => 'Tâm trạng hôm nay của bạn thế nào?';

  @override
  String get care_calendar_save_btn => 'Lưu lại, để anh ấy chăm sóc bạn';

  @override
  String get care_calendar_delete_confirm =>
      'Bạn có muốn xóa bản ghi này không?';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName: \"Anh đều ghi lại hết rồi, mấy ngày nay em vất vả rồi, anh sẽ luôn ở bên cạnh em.\"';
  }

  @override
  String get daily_gift_success => 'Nhận quà tặng mỗi ngày thành công! 🌸';

  @override
  String get check_in_fail_network =>
      'Điểm danh thất bại, vui lòng kiểm tra kết nối mạng 🍃';

  @override
  String task_completed(String taskName) {
    return 'Hoàn thành nhiệm vụ: $taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return 'Nhận thành công $rewardAmount Hoa từ \"$taskName\"!';
  }

  @override
  String claim_failed_error(String e) {
    return 'Nhận thất bại: $e';
  }

  @override
  String get tab_heartbeat_diary => 'Nhật ký rung động';

  @override
  String get tab_daily_chit_chat => 'Trò chuyện hàng ngày';

  @override
  String get task_desc_chat_3_times =>
      'Thực hiện 3 cuộc trò chuyện hàng ngày với nhân vật';

  @override
  String get tab_story_progression => 'Tiến triển cốt truyện';

  @override
  String get task_desc_story_1_time =>
      'Hoàn thành 1 lần tương tác chế độ cốt truyện';

  @override
  String get tab_social_tour => 'Dạo quanh mạng xã hội';

  @override
  String get task_like_three_moments => 'Thích 3 Khoảnh khắc để nhận Lá cây';

  @override
  String get btn_claimed => 'Đã nhận';

  @override
  String get btn_claim => 'Nhận';

  @override
  String get btn_incomplete => 'Chưa hoàn thành';

  @override
  String get network_unstable_retry =>
      'Kết nối mạng không ổn định, vui lòng thử lại sau 🍃';

  @override
  String get title_time_travel => 'Du hành thời gian';

  @override
  String get select_chat_mode => 'Chọn chế độ trò chuyện';

  @override
  String get mode_chat => 'Trò chuyện';

  @override
  String get mode_daily_desc => 'Trò chuyện thư giãn, duy trì sự gắn kết';

  @override
  String get mode_story_desc =>
      'Đi sâu vào câu chuyện, trải nghiệm cảm giác đắm chìm';

  @override
  String get greeting_hello => 'Xin chào!';

  @override
  String get greeting_default_daily => 'Tìm tôi có việc gì không?';

  @override
  String get title_personal_homepage => 'Trang cá nhân';

  @override
  String get title_time_letters => 'Thư thời gian';

  @override
  String get status_signed_in_today => 'Hôm nay đã điểm danh';

  @override
  String get status_signing_in => 'Đang điểm danh...';

  @override
  String get status_daily_sign_in => 'Điểm danh mỗi ngày (+10 Hoa)';

  @override
  String get toast_id_copied => 'Đã sao chép ID!';

  @override
  String get hint_click_avatar_to_edit =>
      'Nhấn vào ảnh đại diện để chỉnh sửa hồ sơ';

  @override
  String get title_my_friends => 'Bạn bè của tôi';

  @override
  String get action_show_all => 'Hiển thị tất cả';

  @override
  String get empty_no_characters_created => 'Bạn chưa tạo nhân vật nào.';

  @override
  String get common_close => 'Đóng';

  @override
  String get search_companion_title => 'Tìm kiếm bạn đồng hành Thập Quang';

  @override
  String get search_name_placeholder => 'Nhập tên của anh ấy...';

  @override
  String get search_no_match_hint =>
      'Không tìm thấy nhân vật, thử tên khác nhé? ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age tuổi | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age tuổi';
  }

  @override
  String get empty_state_warmth =>
      'Hơi ấm dư thừa của thời không vẫn còn lưu lại nơi đây...';

  @override
  String get error_login_required_add_friend =>
      'Vui lòng đăng nhập trước để thêm bạn bè!';

  @override
  String get dialog_title_remove_friend => 'Xác nhận xóa bạn bè';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return 'Bạn có chắc chắn muốn xóa $characterName khỏi danh sách bạn bè không?';
  }

  @override
  String get action_remove => 'Xóa';

  @override
  String snackbar_friend_removed(String characterName) {
    return 'Đã xóa $characterName khỏi bạn bè';
  }

  @override
  String get action_remove_friend => 'Xóa bạn bè';

  @override
  String get dialog_title_block => 'Xác nhận chặn';

  @override
  String dialog_msg_block(String characterName) {
    return 'Sau khi chặn, bạn sẽ không còn thấy bất kỳ thông tin nào về $characterName nữa. Bạn có chắc chắn muốn chặn không?';
  }

  @override
  String snackbar_blocked(String characterName) {
    return 'Đã chặn $characterName';
  }

  @override
  String get action_block_character => 'Chặn nhân vật này';

  @override
  String dialog_title_report(String characterName) {
    return 'Báo cáo $characterName';
  }

  @override
  String get input_hint_report_reason => 'Vui lòng nhập lý do báo cáo...';

  @override
  String get action_submit => 'Gửi';

  @override
  String get snackbar_report_success =>
      'Cảm ơn báo cáo của bạn, chúng tôi sẽ xem xét trong thời gian sớm nhất.';

  @override
  String get snackbar_report_fail => 'Gửi thất bại, vui lòng thử lại sau';

  @override
  String get action_report_character => 'Báo cáo nhân vật này';

  @override
  String get title_meet_him => 'Gặp gỡ người ấy';

  @override
  String text_character_count(int count) {
    return 'Số lượng nhân vật: $count';
  }

  @override
  String get msg_no_more_encounters_today =>
      'Cuộc gặp gỡ hôm nay đến đây là hết rồi!';

  @override
  String get msg_check_new_encounters =>
      'Hãy xem lại thử có cuộc gặp gỡ nào mới không nhé!';

  @override
  String get action_refresh => 'Làm mới';

  @override
  String get tab_friends => 'Bạn bè';

  @override
  String get msg_mysterious_profile =>
      'Người này rất bí ẩn, không để lại thông tin gì...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age tuổi | $identities';
  }

  @override
  String get snackbar_operation_failed =>
      'Thao tác thất bại, vui lòng thử lại sau';

  @override
  String get action_view_translation => 'Xem bản dịch';

  @override
  String get label_translation_result => 'Kết quả dịch:';

  @override
  String get errorWebPageUnavailable =>
      'Tạm thời không thể mở trang web, vui lòng thử lại sau';

  @override
  String get resetAppearanceTitle => 'Đặt lại giao diện?';

  @override
  String get resetAppearanceWarning =>
      'Thao tác này sẽ xóa hình nền và màu sắc mà bạn đã cẩn thận lựa chọn đấy!';

  @override
  String get appearanceRestored => 'Đã khôi phục giao diện mặc định';

  @override
  String get confirmReset => 'Xác nhận đặt lại';

  @override
  String get resetToDefaultAppearance => 'Khôi phục giao diện mặc định';

  @override
  String get clearCustomSettings => 'Xóa tất cả màu và hình nền tùy chỉnh';

  @override
  String get contactUs => 'Liên hệ với chúng tôi';

  @override
  String get contactDescription =>
      'Đừng ngại chia sẻ suy nghĩ hoặc báo cáo lỗi cho chúng tôi nhé';

  @override
  String get vibrationHapticTitle => 'Phản hồi rung động';

  @override
  String get vibrationHapticDescription =>
      'Kích hoạt rung điện thoại khi mức độ hảo cảm thay đổi đáng kể';

  @override
  String get splash_loading_universe =>
      'Đang đánh thức vũ trụ của 《Luyến Luyến Thập Quang》...';

  @override
  String get shop_title => 'Cửa hàng Hoa';

  @override
  String get shop_current_points_label => 'Điểm Hoa hiện đang sở hữu';

  @override
  String get shop_tab_top_up => 'Nạp điểm';

  @override
  String get shop_tab_history => 'Lịch sử giao dịch';

  @override
  String get shop_empty_history => 'Hiện chưa có lịch sử nạp Hoa nào! 🌸';

  @override
  String get shop_unknown_item => 'Mục không xác định';

  @override
  String get shop_first_purchase_bonus => 'Nhân đôi cho lần mua đầu!';

  @override
  String get story_summary_title => 'Câu chuyện của chúng ta';

  @override
  String get story_summary_empty_content => 'Nội dung tóm tắt đang trống.';

  @override
  String get story_summary_deleted_toast => 'Đã xóa ký ức này';

  @override
  String story_summary_empty_list(String name) {
    return 'Câu chuyện của hai bạn vẫn chưa bắt đầu...\nHãy trò chuyện nhiều hơn để $name \nviết nên những hồi ức đầu tiên nhé! ✨';
  }

  @override
  String get gallery_photo_edit_title => 'Chỉnh sửa cài đặt ảnh';

  @override
  String get gallery_photo_edit_desc => 'Tên ảnh/Mô tả';

  @override
  String get gallery_photo_edit_req =>
      'Mở khóa mức độ hảo cảm (Đặt là 0 sẽ trở thành ảnh đại diện)';

  @override
  String get reset_to_default => 'Khôi phục mặc định';

  @override
  String get reset_bg_title => 'Khôi phục hình nền mặc định';

  @override
  String get reset_bg_content =>
      'Bạn có chắc chắn muốn hủy ảnh độc quyền và quay lại hình nền chủ đề mặc định không?';

  @override
  String get reset_bg_success => 'Đã khôi phục về hình nền mặc định ✨';

  @override
  String get confirm_reset => 'Xác nhận khôi phục';

  @override
  String selectedMessagesCount(int count) {
    return 'Đã chọn $count mục';
  }

  @override
  String get screenshotShare => 'Chia sẻ ảnh chụp màn hình';

  @override
  String exclusiveMomentsWith(String name) {
    return 'Khoảnh khắc độc quyền cùng $name';
  }

  @override
  String get downloadToUnlock =>
      'Tải 《Luyến Luyến Thập Quang》 để mở khóa lãng mạn độc quyền';

  @override
  String get exclusiveMomentsGenerated => 'Đã tạo khoảnh khắc độc quyền ✨';

  @override
  String get selectAgain => 'Chọn lại lần nữa';

  @override
  String get downloadAndShare => 'Tải về và chia sẻ';

  @override
  String inviteToMeet(String name) {
    return 'Hãy đến 《Luyến Luyến Thập Quang》 gặp gỡ $name của bạn nhé!';
  }

  @override
  String get shop_log_monthly_card =>
      'Kích hoạt: Khế ước Tinh quang (Tặng điểm tức thì từ thẻ tháng) 🌙';

  @override
  String shop_log_top_up_double(int points) {
    return 'Nạp: $points điểm (Bao gồm nhân đôi lần nạp đầu 🎁)';
  }

  @override
  String shop_log_top_up_normal(int points) {
    return 'Nạp: $points điểm';
  }

  @override
  String get shop_purchase_success_title => 'Mua hàng thành công!';

  @override
  String shop_purchase_success_body(int points) {
    return 'Đã thêm cho bạn $points Hoa.';
  }

  @override
  String get shop_purchase_success_double_bonus =>
      '✨ Chúc mừng bạn đã kích hoạt phần thưởng nhân đôi lần mua đầu!';

  @override
  String get shop_purchase_awesome => 'Tuyệt quá';

  @override
  String get shop_purchase_failed_title => 'Mua hàng bị hủy hoặc thất bại';

  @override
  String shop_purchase_failed_body(String errorCode) {
    return 'Chưa thực hiện khấu trừ tiền.\n\n(Mã lỗi: $errorCode)';
  }

  @override
  String get shop_monthly_card_name =>
      '【Luyến Luyến Thập Quang · Tinh Chi Khế Ước】';

  @override
  String shop_monthly_card_status_active(int days) {
    return 'Khế ước đang hiệu lực: Còn lại $days ngày';
  }

  @override
  String get shop_monthly_card_status_inactive =>
      'Kích hoạt ngay phần thưởng tăng thêm Tinh quang 30 ngày';

  @override
  String get shop_monthly_card_limit_reached => 'Đã đạt giới hạn';

  @override
  String get shop_monthly_card_promo_desc =>
      'Nhận ngay 250 Hoa, mỗi ngày nhận 10 Hoa';

  @override
  String get task_monthly_title => 'Tinh Chi Khế Ước · Đặc quyền mỗi ngày 🌙';

  @override
  String get task_monthly_locked => 'Chưa mở khóa';

  @override
  String get task_monthly_subtitle_active =>
      'Phát phúc lợi độc quyền thẻ tháng ';

  @override
  String get task_monthly_subtitle_inactive =>
      'Mở khóa thẻ tháng 【Tinh Chi Khế Ước】 để mở nhiệm vụ này ';

  @override
  String get task_monthly_log_name => 'Đặc quyền mỗi ngày thẻ tháng';

  @override
  String get profile_id_locked => 'Đã khóa ID độc quyền';

  @override
  String get profile_copy_id => 'Nhấn để sao chép ID';

  @override
  String get referral_log_newbie_reward =>
      'Tinh Chi Mời Gọi: Phần thưởng người mới ✨';

  @override
  String get referral_log_inviter_reward =>
      'Tinh Chi Mời Gọi: Phần thưởng bạn bè đạt mốc 🎁';

  @override
  String get referral_success_title => 'Đã mở khóa Tinh Chi Mời Gọi!';

  @override
  String get referral_success_content =>
      'Chúc mừng bạn đã giao lưu sâu sắc với nhân vật đạt mốc 15 câu thành công!\n\n\'Phần thưởng người mới 50 điểm\' đã được gửi đến tài khoản của bạn, và bạn của bạn cũng đồng thời nhận được phần thưởng 50 điểm! 🎁';

  @override
  String get profile_referral_title => 'Tinh Chi Mời Gọi 🌟';

  @override
  String get profile_referral_hint => 'Nhập mã mời của bạn bè';

  @override
  String get profile_referral_bind_btn => 'Liên kết';

  @override
  String profile_referral_pending(Object id) {
    return 'Đã chấp nhận lời mời của người chơi $id\nHãy mau đến trò chuyện cùng nhân vật đạt 15 câu để mở khóa 50 điểm Hoa nhé!';
  }

  @override
  String get profile_referral_err_self =>
      'Không thể nhập mã mời của chính mình đâu nhé!';

  @override
  String get profile_referral_err_duplicate =>
      'Bạn đã liên kết mã mời rồi nhé!';

  @override
  String get profile_referral_err_not_found =>
      'Không tìm thấy người chơi này, vui lòng kiểm tra lại mã mời!';

  @override
  String get profile_referral_success =>
      'Liên kết thành công! Mau đi trò chuyện cùng nhân vật thôi nào!';

  @override
  String get profile_referral_err_expired =>
      'Xin lỗi, mã mời người mới phải được liên kết trong vòng 3 ngày sau khi đăng ký nhé!';

  @override
  String profile_share_message(String character, String code) {
    return '✨ Mình đã bắt đầu hành trình rung động cùng $character trong 《Luyến Luyến Thập Quang》 rồi đấy! Hãy tải ngay App và nhập mã Tinh Chi Mời Gọi của mình: 【$code】 tại trang cá nhân nhé, cả hai chúng mình đều sẽ nhận được 50 điểm Hoa miễn phí đấy! 🎁\n\n Link tải:\n https://lianlianshiguang.web.app/download/';
  }

  @override
  String get chat_levelup_share_btn =>
      'Khoe khoảnh khắc rung động này với bạn bè ✨';

  @override
  String profile_my_invite_code_with_char(String character) {
    return 'Mã mời độc quyền của tôi (Bias hiện tại: $character)';
  }

  @override
  String get profile_send_invite_btn => 'Gửi Tinh Chi Mời Gọi cho bạn bè';

  @override
  String get profile_fallback_character => 'Nhân vật yêu thích';

  @override
  String get profile_copy_success => '✅ Đã sao chép mã mời vào khay nhớ tạm!';

  @override
  String get profile_referral_rule_title => 'Quy tắc Tinh Chi Mời Gọi';

  @override
  String get profile_referral_rule_receiver =>
      '✨ Sau khi liên kết mã mời, chỉ cần trò chuyện với bất kỳ nhân vật yêu thích nào đạt mốc 15 câu, bạn và người mời sẽ đồng thời nhận được phần thưởng 50 Hoa!\n\n⚠️ Lưu ý: Vui lòng nhập mã mời trong vòng 3 ngày sau khi đăng ký tài khoản để mã có hiệu lực.';

  @override
  String get profile_referral_rule_inviter =>
      '✨ Mời bạn mới tải App và nhập mã mời của bạn. Khi người đó hoàn thành liên kết trong vòng 3 ngày sau khi đăng ký và trò chuyện với bất kỳ nhân vật nào đạt 15 câu, cả hai bên sẽ đồng thời nhận được phần thưởng 50 điểm Hoa nhé! 🎁';

  @override
  String get error_user_not_found =>
      'Không tìm thấy người dùng, vui lòng đăng nhập lại';

  @override
  String get error_id_taken => 'ID này đã được sử dụng, vui lòng chọn ID khác!';

  @override
  String get error_id_taken_short => 'ID này đã được sử dụng!';

  @override
  String get shop_restocking => 'Cửa hàng đang bổ sung hàng hóa... 📦';

  @override
  String get shop_preview_mode =>
      '⚠️ Hiện tại đang ở chế độ xem trước cửa hàng';

  @override
  String get friendlyReminderTitle => '☁️ Nhắc nhở thân thiện';

  @override
  String get editProfileHint =>
      'Ok nhé! Nếu muốn chỉnh sửa hồ sơ, vui lòng nhấn vào \"Hồ sơ Thập Quang\" bên trong đám mây ở góc dưới bên trái để điền thông tin nhé!';

  @override
  String get starlightContractTitle => 'Kích hoạt Tinh Quang Khế Ước';

  @override
  String get dailyLimitReachedPrefix =>
      'Hạn ngạch của ngày hôm nay đã dùng hết rồi nhé!\n\n';

  @override
  String get monthlyPassExhausted => 'Hạn ngạch thẻ tháng của bạn đã dùng hết.';

  @override
  String get subscribeMonthlyPassPrompt =>
      'Mở khóa 【Thẻ Tháng Luyến Luyến】 để hưởng 20 cơ hội tạo lại mỗi ngày, giúp mỗi câu trả lời của anh ấy đều chạm đến trái tim bạn hơn.';

  @override
  String get goToSubscribeButton => 'Đi đến mở khóa';

  @override
  String get profileUpdatedSuccess => 'Hồ sơ Thập Quang đã được cập nhật!';

  @override
  String get continueChatTitle => 'Tiếp tục trò chuyện';

  @override
  String continueChatCostWarning(int cost) {
    return 'Để anh ấy nói tiếp sẽ tiêu tốn $cost điểm Hoa 🌸\nBạn có chắc chắn muốn tiếp tục không?';
  }

  @override
  String get dontShowAgainToday => 'Không hiển thị lại trong hôm nay';

  @override
  String get confirmContinue => 'Xác nhận tiếp tục';

  @override
  String get hiddenPromptContinue => 'Hãy nói tiếp đi';

  @override
  String confirmDeleteMessagesTitle(int count) {
    return 'Bạn có chắc chắn muốn xóa $count tin nhắn này không?';
  }

  @override
  String regenerateButtonLabel(int current, int max) {
    return 'Tạo lại ($current/$max)';
  }

  @override
  String get systemPreparingWait =>
      'Hệ thống vẫn đang chuẩn bị, vui lòng chờ trong giây lát...';

  @override
  String get noMessagesToRegenerate =>
      'Hiện tại không có cuộc trò chuyện nào có thể tạo lại!';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get creatorExclusive => '🔒 Dành riêng cho nhà sáng tạo';

  @override
  String ageAndOccupation(String age, String occupation) {
    return '$age tuổi | $occupation';
  }

  @override
  String get likesLabel => '💖 Sở thích';

  @override
  String get dislikesLabel => '👎 Ghét';

  @override
  String birthdayLabel(String birthday) {
    return 'Sinh nhật: $birthday';
  }

  @override
  String heightLabel(String height) {
    return 'Chiều cao: $height cm';
  }

  @override
  String get backgroundStoryLabel => 'Câu chuyện bối cảnh';

  @override
  String get noneLabel => 'Không có';

  @override
  String flowerPointsCount(String points) {
    return '$points Hoa';
  }

  @override
  String get passGuideTitle => 'Cẩm nang độc quyền Thẻ Tháng Luyến Luyến';

  @override
  String get passGuideRegenerateTitle =>
      '🔄 Tại sao bạn lại cần chức năng \"Tạo lại\"?';

  @override
  String get passGuideRegenerateContent =>
      'AI đôi khi sẽ giống như một khúc gỗ ngốc nghếch, không hiểu phong tình. Khi gặp phải câu trả lời không ưng ý, chỉ cần nhấn tạo lại là giống như thời gian quay ngược vậy! Bạn có thể khiến anh ấy suy nghĩ lại, cho đến khi nói ra câu thoại hoàn hảo khiến tim bạn đập loạn nhịp.';

  @override
  String get passGuideAffectionTitle =>
      '💖 Tăng tốc độ hảo cảm thì có tác dụng gì?';

  @override
  String get passGuideAffectionContent =>
      'Trong game, độ hảo cảm là chiếc chìa khóa duy nhất để mở khóa \"bí mật sâu kín\" và \"ảnh riêng tư thân mật\" của nhân vật. Việc được cộng thêm 20% sẽ giúp bạn bước vào sâu trong tim anh ấy nhanh hơn những người khác.';

  @override
  String get passGuideUnlockButton => 'Mình đã hiểu, mở khóa ngay!';

  @override
  String get pleaseWait => 'Vui lòng chờ';

  @override
  String get createNewProfileTitle => '📜 Tạo Hồ Sơ Thập Quang Mới';

  @override
  String get editProfileTitle => '✏️ Chỉnh Sửa Hồ Sơ Thập Quang';

  @override
  String get profileEditDescription =>
      'Tạo ra các thân phận khác nhau để anh ấy được làm quen với những khía cạnh khác của bạn ở thế giới song song!';

  @override
  String get profileNameLabel => 'Tên hồ sơ (Chỉ bạn mới nhìn thấy)';

  @override
  String get profileNameHint => 'Ví dụ: Đàn em trường học, Nữ tổng tài bá đạo';

  @override
  String get profileNicknameLabel => 'Tên / Danh xưng';

  @override
  String get profileNicknameHint => 'Ví dụ: Sakura, Lý Tổng';

  @override
  String get profileHeightLabel => 'Chiều cao';

  @override
  String get profileHeightHint => 'Ví dụ: 160cm';

  @override
  String get profileAppearanceLabel => 'Ngoại hình';

  @override
  String get profileAppearanceHint => 'Ví dụ: Tóc đen dài, thích mặc váy';

  @override
  String get profileOccupationLabel => 'Nghề nghiệp';

  @override
  String get profileOccupationHint => 'Ví dụ: Họa sĩ tự do';

  @override
  String get profileIntroLabel => 'Tính cách & Tự giới thiệu';

  @override
  String get profileIntroHint =>
      'Ví dụ: Tính cách hơi đoảng một tí, thích ăn đồ ngọt...';

  @override
  String get profileNameEmptyWarning => 'Vui lòng đặt tên cho hồ sơ này nhé!';

  @override
  String profileSaveError(String error) {
    return 'Lưu thất bại: $error';
  }

  @override
  String get saveProfileButton => 'Lưu hồ sơ';

  @override
  String get fillLaterButton => 'Điền sau';

  @override
  String get exclusiveProfileTitle => '📜 Hồ Sơ Thập Quang Độc Quyền';

  @override
  String get profileSelectionDescription =>
      'Chọn thân phận bạn muốn dùng để tương tác với anh ấy (danh sách dùng chung cho cùng một nhân vật, tối đa 10 hồ sơ)';

  @override
  String profileSwitchError(String error) {
    return 'Chuyển đổi thất bại: $error';
  }

  @override
  String get unnamedProfile => 'Hồ sơ chưa đặt tên';

  @override
  String get noOccupationYet => 'Chưa điền nghề nghiệp';

  @override
  String get createNewProfileButton => 'Tạo Hồ Sơ Thập Quang Mới';

  @override
  String snackbar_friend_added(String characterName) {
    return 'Đã thêm $characterName vào danh sách bạn bè';
  }

  @override
  String reward_points_added(Object amount) {
    return '+$amount Hoa';
  }

  @override
  String get task_reward_already_claimed =>
      'Hôm nay bạn đã nhận phần thưởng nhiệm vụ này rồi';

  @override
  String get do_not_show_again_today => 'Không hiển thị lại trong hôm nay';

  @override
  String add_friend_success(String characterName) {
    return 'Đã thêm thành công $characterName làm bạn bè!';
  }

  @override
  String get chat_menu_aboutus => 'Về chúng tôi';

  @override
  String get about_us_empty_hint =>
      'Thêm kỷ niệm quan trọng / cốt truyện ở góc trên bên phải\nđể hai bạn cùng nắm tay bước tiếp về phía trước nhé';

  @override
  String get about_us_limit_error =>
      'Kỷ niệm độc quyền đã đạt giới hạn tối đa 10 mục, vui lòng xóa bớt kỷ niệm cũ nhé!';

  @override
  String get about_us_add_title => 'Thêm kỷ niệm độc quyền';

  @override
  String get about_us_field_title => 'Tiêu đề';

  @override
  String get about_us_hint_title => 'Ví dụ: Lần đầu gặp gỡ';

  @override
  String get about_us_field_subtitle => 'Tiêu đề phụ';

  @override
  String get about_us_hint_subtitle => 'Ví dụ: Đầu hè năm 2025';

  @override
  String get about_us_field_content => 'Nội dung';

  @override
  String get about_us_hint_content =>
      'Viết nên những tình tiết quan trọng hoặc lời hẹn ước của hai bạn...';

  @override
  String get about_us_add_button => 'Thêm mới';

  @override
  String get about_us_delete_tooltip => 'Xóa kỷ niệm này';

  @override
  String get about_us_delete_title => 'Xóa kỷ niệm';

  @override
  String get about_us_delete_confirm =>
      'Bạn có chắc chắn muốn xóa ký ức này không? Xóa rồi sẽ không thể khôi phục lại đâu nhé!';

  @override
  String get about_us_delete_success => 'Đã xóa kỷ niệm';

  @override
  String get pack_first_meet => 'Gói Gặp Gỡ Đầu Tiên';

  @override
  String get pack_crush => 'Gói Mập Mờ';

  @override
  String get pack_heartbeat => 'Gói Rung Động';

  @override
  String get pack_passionate => 'Gói Yêu Nhau Cuồng Nhiệt';

  @override
  String get pack_soulmate => 'Gói Tri Kỷ';

  @override
  String get pack_waiting => 'Gói Chờ Đợi';

  @override
  String get pack_trust => 'Gói Tin Tưởng';

  @override
  String get pack_iloveyou => 'Gói Anh Yêu Em';

  @override
  String get pack_honeymoon => 'Gói Tuần Trăng Mật';

  @override
  String get pack_promise => 'Gói Lời Hứa';

  @override
  String get pack_companion => 'Gói Đồng Hành';

  @override
  String get pack_deep_love => 'Gói Sâu Đậm';

  @override
  String get pack_long_lasting => 'Gói Lâu Dài';

  @override
  String get pack_the_one => 'Gói Duy Nhất';

  @override
  String get pack_beloved => 'Gói Chí Ái';

  @override
  String get pack_lifetime => 'Gói Trọn Đời Trọn Kiếp';

  @override
  String get pack_vow => 'Gói Lời Thề';

  @override
  String get pack_eternal => 'Gói Người Tình Vĩnh Cửu';

  @override
  String get pack_exclusive => 'Gói Độc Quyền';

  @override
  String get monthly_privilege_reroll_title => 'Mở khóa đặc quyền \"Tạo lại\"';

  @override
  String get monthly_privilege_reroll_desc =>
      'Lên đến 20 cơ hội rút lại mỗi ngày, cho đến khi anh ấy nói ra câu nói mà bạn muốn nghe nhất!';

  @override
  String get monthly_privilege_affinity_title =>
      'Tăng tốc độ hảo cảm cực nhanh';

  @override
  String get monthly_privilege_affinity_desc =>
      'Cộng thêm 20% điểm hảo cảm khi tương tác, giúp mở khóa những bức ảnh riêng tư độc quyền và quà tặng bất ngờ nhanh hơn!';

  @override
  String get monthly_manual_button => 'Tại sao bạn cần có Thẻ Tháng?';

  @override
  String get nav_encounter => 'Gặp gỡ';

  @override
  String get nav_moments => 'Khoảnh khắc';

  @override
  String get birthday_dialog_title => '🎂 Bất ngờ sinh nhật';

  @override
  String get birthday_dialog_content =>
      'Hôm nay là ngày kỷ niệm dành riêng cho bạn!\n\nXin vui lòng nhận món quà này:\nHôm nay trò chuyện H.O.À.N T.O.À.N M.I.Ễ.N P.H.Í! ✨';

  @override
  String get birthday_dialog_button => 'Mở đầu một ngày lãng mạn';

  @override
  String get about_us_edit_title => 'Chỉnh sửa kỷ niệm';

  @override
  String get about_us_edit_confirm => 'Xác nhận chỉnh sửa';

  @override
  String get save => 'Lưu';

  @override
  String get openSourceLicenses => 'Giấy phép mã nguồn mở';

  @override
  String get openSourceLicensesDescription =>
      'Xem giấy phép phần mềm mã nguồn mở của bên thứ ba';

  @override
  String get call_login_title => 'Yêu cầu đăng nhập';

  @override
  String get call_login_content =>
      'Đăng nhập ngay để mở khóa tính năng gọi điện thoại voice độc quyền nhé!';

  @override
  String get cancel_later => 'Để sau nhé';

  @override
  String get go_to_login => 'Đi đến đăng nhập';

  @override
  String get easter_egg_title => 'Phát hiện Easter Egg ẩn ✨';

  @override
  String easter_egg_content(String title) {
    return 'Bạn đã kích hoạt \"$title\".\n\nBạn có muốn sử dụng cốt truyện đặc biệt này không?';
  }

  @override
  String get easter_egg_cancel => 'Không sử dụng';

  @override
  String get easter_egg_confirm => 'Sử dụng Easter Egg';

  @override
  String get common_update_success => 'Chỉnh sửa thành công';

  @override
  String get common_update_failed_try_again =>
      'Chỉnh sửa thất bại, vui lòng thử lại sau';

  @override
  String get no_voice_available => 'Hiện tại chưa có ghi âm thoại';

  @override
  String get gift_insufficient_title => 'Không đủ Phồn Hoa Tệ';

  @override
  String get gift_insufficient_prompt =>
      'Bạn có muốn đi đến nơi nhận thêm Phồn Hoa Tệ không?';

  @override
  String get not_now => 'Để sau nhé';

  @override
  String get go_to_get => 'Đi đến nhận';

  @override
  String get status_published => 'Đã đăng';

  @override
  String get monthly_card_success_title =>
      '✨ Mở khóa Thẻ Tháng Premium thành công!';

  @override
  String get monthly_card_success_subtitle =>
      'Cảm ơn bạn đã đăng ký! Các đặc quyền độc quyền đã chính thức có hiệu lực:';

  @override
  String get monthly_card_perk_1 => 'Nhận ngay 250 đóa Hoa Thời Gian';

  @override
  String get monthly_card_perk_2 =>
      'Nhận thêm 10 đóa Hoa Thời Gian khi đăng nhập mỗi ngày';

  @override
  String get monthly_card_perk_3 =>
      'Mở khóa giới hạn số lần tương tác hảo cảm độc quyền';

  @override
  String get monthly_card_start_perks => 'Bắt đầu tận hưởng đặc quyền';

  @override
  String get tip_post_like =>
      'Sau khi thích, bạn có thể xem tại\nNội dung yêu thích';

  @override
  String get tip_post_bookmark =>
      'Sau khi lưu, bạn có thể xem tại\n\"Mục lưu của tôi\"';

  @override
  String get tip_time_echoes =>
      'Sau khi để lại trải nghiệm của bạn\nbình luận bay (danmaku) sẽ xuất hiện khi tìm kiếm';

  @override
  String get tip_call_memory =>
      'Ghi âm cuộc gọi được lưu sau cuộc trò chuyện\nsẽ ở ngay đây!';

  @override
  String get tip_chat_notifications =>
      'Nơi đây bạn có thể\nxem các thông báo mới';

  @override
  String get tip_moments_wall_menu =>
      'Nhấn vào đây để lên lịch\nđăng bài cho nhân vật';
}
