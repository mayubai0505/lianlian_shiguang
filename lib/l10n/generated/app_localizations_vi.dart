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
  String get charNameLabel => 'Tên nhân vật:';

  @override
  String get charDescSection => 'Mô tả nhân vật:';

  @override
  String get charAgeLabel => 'Tuổi:';

  @override
  String get charJobLabel => 'Nghề nghiệp:';

  @override
  String get charBirthdayLabel => 'Ngày sinh:(MMDD)';

  @override
  String get charGenderLabel => 'Giới tính ';

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
  String get logoutSuccessSnackbar => 'Được rồi! Tôi sẽ đợi bạn quay lại(´∀` )';

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
  String get terms_title => 'Điều khoản Sử dụng';

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
      'Tải dữ liệu giọng nói thành công, chuẩn bị phát...';

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
  String get test_mode_notice =>
      'Chế độ thử nghiệm sẽ khấu trừ điểm theo giá gốc của từng chế độ và không tính vào ký ức chính thức!';

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
  String get section_story_identity => 'Cốt truyện và Danh tính của bạn';

  @override
  String get story_identity_desc =>
      'Xác định mở đầu câu chuyện và các thiết lập đặc biệt cho \"Bạn\" trong bản lưu này';

  @override
  String get advanced_writing_tips_title => 'Kỹ thuật viết nâng cao:\n';

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
  String get section_personality_evo => 'Tiến hóa tính cách và độ thân thiết';

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
  String get section_habits => 'Sở thích và thói quen';

  @override
  String get tone_hint_detail =>
      'Bắt buộc. Ví dụ: Nói năng ngắn gọn, thích hỏi ngược lại. Câu cửa miệng là \"đồ ngốc\". Cấm sử dụng giọng điệu dịch máy.';

  @override
  String get dialogue_example_hint =>
      'Người chơi: Em mệt quá.\nNhân vật: (Xoa đầu) Ngoan, đi nghỉ sớm đi.';

  @override
  String get section_easter_eggs => 'Trứng Phục sinh ẩn và Cốt truyện đặc biệt';

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
  String get section_voice_gen => 'Tạo giọng nói độc quyền của anh ta';

  @override
  String get voice_gen_desc =>
      'Nhập từ khóa gợi ý để anh ta có giọng nói độc nhất vô nhị trên thế giới!\n(Nhắc nhở: Nếu không hài lòng sau khi tạo, bạn có thể đặt làm lại bất cứ lúc nào!)';

  @override
  String get voice_generating_status => 'Đang điều phối giọng nói...';

  @override
  String get voice_select_prompt =>
      'Đã chuẩn bị cho bạn ba loại giọng nói, vui lòng chọn:';

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
  String get voice_advanced_tuning => 'Nâng cao: Điều chỉnh cảm xúc khi nói';

  @override
  String get voice_stability_low => 'Hoang dã/Thở';

  @override
  String voice_stability_value(String value) {
    return 'Độ lý trí: $value';
  }

  @override
  String get voice_stability_high => 'Ổn định/Điềm tĩnh';

  @override
  String get voice_style_low => 'Lạnh nhạt/Kìm nén';

  @override
  String voice_style_value(String value) {
    return 'Thể hiện kịch tính: $value';
  }

  @override
  String get voice_style_high => 'Phô trương/Sâu sắc';

  @override
  String get voice_test_btn_testing => 'Đang áp dụng cảm xúc...';

  @override
  String get voice_test_btn => 'Nghe thử cảm xúc hiện tại';

  @override
  String get section_social_circle => 'Vòng xã giao của anh ta';

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
    return 'Chỉnh sửa cái nhìn về $name';
  }

  @override
  String get social_attitude_label => 'Cái nhìn / Thái độ của anh ta';

  @override
  String get social_attitude_hint =>
      'Ví dụ: Thấy đối phương rất phiền phức, nhưng thực ra rất dựa dẫm...';

  @override
  String get social_save_changes => 'Lưu chỉnh sửa';

  @override
  String get social_add_title => 'Thêm quan hệ nhân vật';

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
      'Tải hình ảnh thất bại \nVui lòng xác nhận mạng bình thường.';

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
      'Không thể nhấn thích nhân vật do chính mình tạo ra!';

  @override
  String get like_success_msg => 'Đã gửi lượt thích! Người sáng tạo sẽ rất vui';

  @override
  String get unlike_success_msg => 'Đã rút lại lượt thích';

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
  String get report_title => 'Báo cáo bình luận';

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
      'Báo cáo thành công, đã nhận được thông báo! Sẽ sớm kiểm duyệt nội dung ';

  @override
  String get report_failed =>
      'Báo cáo thất bại, vui lòng kiểm tra kết nối mạng.';

  @override
  String get lore_delete_title => 'Cảnh báo: Xóa ký ức';

  @override
  String get lore_delete_content =>
      'Ký ức này một khi đã xóa sẽ biến mất vĩnh viễn, bạn có chắc chắn muốn xóa không?';

  @override
  String get lore_delete_cancel => 'Bấm nhầm';

  @override
  String get lore_delete_confirm => 'Xác nhận xóa';

  @override
  String get lore_delete_success => 'Mảnh ký ức đã được xóa sạch.';

  @override
  String get lore_add_title => 'Viết ký ức mới ';

  @override
  String get lore_edit_title => 'Chỉnh sửa mảnh ký ức ';

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
  String get lore_lock_label => 'Niêm phong ký ức này';

  @override
  String get lore_lock_desc =>
      'Khi chọn, chỉ người sáng tạo mới thấy, người chơi khác không thể xem';

  @override
  String get lore_empty_error => 'Tiêu đề và nội dung không được để trống!';

  @override
  String get lore_add_success => 'Ký ức mới đã được niêm phong thành công!';

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
      'Ký ức này đã bị niêm phong, hiện không thể xem.';

  @override
  String get lore_not_open_msg => 'Ký ức này chưa mở cho công chúng...';

  @override
  String get lore_unnamed => 'Mảnh ký ức không tên';

  @override
  String get lore_add_btn_limit => 'Viết mảnh ký ức mới (tối đa 10 mục)';

  @override
  String get lore_collapse => 'Đóng thư';

  @override
  String get echo_delete_title => 'Xóa bình luận';

  @override
  String get echo_delete_content =>
      'Bạn có chắc chắn muốn xóa Tiếng vọng thời không này không?\nXóa rồi sẽ không lấy lại được đâu!';

  @override
  String get echo_keep => 'Giữ lại';

  @override
  String get echo_clear_success => 'Đã dọn dẹp Tiếng vọng thời không';

  @override
  String get echo_energy_full_title => 'Năng lượng vũ trụ đã đạt giới hạn';

  @override
  String get echo_energy_full_content =>
      'Năng lượng thời không của bạn đã đạt giới hạn (tối đa 3 mục), vui lòng xóa kỷ niệm cũ để mở bản ghi vũ trụ mới nhé!';

  @override
  String get echo_write_title => 'Để lại Tiếng vọng thời không của bạn';

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
      'Người sáng tạo không thể theo dõi chính mình đâu!';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return ' $playerName đã theo dõi $creatorName!';
  }

  @override
  String get mailbox_follow_title => 'Nhận được người bảo vệ mới';

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
    return 'Mức độ thân thiết hiện tại: $value';
  }

  @override
  String get gallery_empty => 'Album chưa có ảnh nào';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'Đã đặt hình nền thành \"$desc\"!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'Đạt mức độ thân thiết $value để mở khóa nhé!';
  }

  @override
  String get gallery_reset_bg => 'Đã khôi phục nền cuộc gọi mặc định';

  @override
  String get background_story_title => 'Câu chuyện gặp gỡ đầu tiên';

  @override
  String get background_story_empty =>
      'Nhân vật này rất bí ẩn và vẫn chưa có câu chuyện gặp gỡ đầu tiên...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'Đã theo dõi $creatorName';
  }

  @override
  String get mailbox_title => 'Hộp thư độc quyền';

  @override
  String get mailbox_empty =>
      'Hộp thư trống rỗng, hãy đăng bài để thu hút anh ấy nhé!';

  @override
  String get new_notification => 'Thông báo mới';

  @override
  String get default_he => 'Anh ấy';

  @override
  String affection_upgrade_title(String charName) {
    return 'Độ thân thiết của $charName dành cho bạn đã tăng lên!';
  }

  @override
  String get flower_reward => 'Nhận được 5 điểm hoa';

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
  String get lore_edit_success => 'Mảnh ký ức đã được cập nhật thành công!';

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
  String get chat_jump_success => 'Đã chuyển đến phân đoạn ký ức này';

  @override
  String get chat_create_room_failed =>
      'Kết nối không ổn định, tạo phòng trò chuyện thất bại, vui lòng thử lại.';

  @override
  String get chat_secret_file_title => 'Hồ sơ tuyệt mật';

  @override
  String get chat_secret_file_desc =>
      'Hồ sơ linh hồn của nhân vật này đã được lưu trữ hoặc chuyển sang chế độ riêng tư, tạm thời không thể xem chi tiết.';

  @override
  String get chat_understood => 'Đã hiểu';

  @override
  String chat_egg_unlocked(String title) {
    return 'Nhận được ký ức mới: $title';
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
      'Nên đeo tai nghe để nghe rõ giọng nói của anh ấy hơn';

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
      'Đã dừng phản hồi, điểm hoa không bị trừ';

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
      'Báo cáo đã được gửi, chúng tôi sẽ sớm điều chỉnh';

  @override
  String get chat_suggest_title => 'Góp ý cho chúng tôi';

  @override
  String get chat_suggest_hint => 'Vui lòng viết ý kiến quý báu của bạn...';

  @override
  String get chat_suggest_success =>
      'Cảm ơn góp ý của bạn, chúng tôi sẽ xử lý sớm nhất có thể';

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
      'Đã giúp em chọc nhà sáng tạo rồi nhé! Hãy chờ đợi giọng nói của anh ấy sớm ra mắt nha~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'Điểm hoa không đủ! Cần $cost điểm';
  }

  @override
  String get chat_levelup_soulmate => 'Người tình định mệnh';

  @override
  String get chat_levelup_normal => 'Mối quan hệ thăng cấp!';

  @override
  String get chat_levelup_btn_soulmate => 'Khắc sâu vào linh hồn';

  @override
  String get chat_levelup_btn_normal => 'Rung động đón nhận';

  @override
  String get chat_loc_title => 'Gửi định vị ảo';

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
  String get chat_interact_title => 'Bạn muốn làm gì với anh ấy?';

  @override
  String get chat_interact_action => 'Chọc ghẹo và hành động nhỏ';

  @override
  String get chat_interact_gift => 'Tặng quà nhỏ cho anh ấy (tiêu tốn hoa )';

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
  String get chat_search_empty => 'Không tìm thấy đoạn ký ức này';

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
    return 'Nhận được ký ức mới: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'Đã tự động đưa vào kho đồ độc quyền của anh ấy';

  @override
  String get chat_profile_updated_msg =>
      'Hồ sơ Thập Quang đã cập nhật! Anh ấy sẽ nhớ những thiết lập mới nhất của bạn đó';

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
  String get comment_report_rules_title => 'Quy định báo cáo bình luận';

  @override
  String get comment_report_rules_desc =>
      'Vi phạm lần đầu: Hệ thống cảnh cáo và ghi lại một lần vi phạm.\n2⃣ Vi phạm lần hai: Cấm bình luận trong 1 ngày.\n3⃣ Tái phạm: Vô hiệu hóa tính năng báo cáo trong 14 ngày và giảm khả năng hiển thị bình luận.\n\nĐối với hành vi ác ý nghiêm trọng:\nCấm tương tác với nhân vật trong 1 ngày, ID sẽ được thông báo trên bảng tin trong 3 ngày (trong thời gian này không được đổi ID).\n\nSau khi gửi báo cáo, kết quả xét duyệt cuối cùng sẽ được gửi cho bạn qua [Thư trong trò chơi].\nVui lòng tôn trọng lẫn nhau và báo cáo một cách lý trí.';

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
    return 'Ghét: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return 'Thích: $likes';
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
  String get char_exclusive_guardian => 'Người bảo vệ độc quyền';

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
    return '(Người chơi đã gửi vị trí: $location)';
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
    return '【 Hồ sơ Thập Quang độc quyền - $name 】\n━━━━━━━━━━━━━━━━━━\nTên: $identity\nSinh nhật: $birthday\nChiều cao: $height\nNgoại hình: $appearance\nNghề nghiệp: $job\n\n【 Về mảnh ghép linh hồn của cô ấy 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '【 Hồ sơ Thập Quang độc quyền 】\n━━━━━━━━━━━━━━━━━━\nBiệt danh: $nickname\nSinh nhật: $birthday\n\nCác dữ liệu nhân vật khác chưa được mở khóa...\n(Hãy điền đầy đủ hồ sơ để anh ấy hiểu bạn hơn trong vũ trụ song song nhé! )\n━━━━━━━━━━━━━━━━━━';
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
    return 'Cuộc gọi kết thúc, đã trò chuyện với $name trong $time';
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
      'Bạn chưa phát hành bất kỳ nhân vật công khai nào!\nHãy đến phòng làm việc để sáng tạo nhé';

  @override
  String get no_public_character_other =>
      'Người sáng tạo này vẫn chưa phát hành nhân vật nào...';

  @override
  String get delete_draft_title => 'Xóa bản nháp';

  @override
  String get confirm_delete_draft_msg =>
      'Bạn có chắc chắn muốn xóa nhân vật chưa hoàn thành này không?\n(Không thể khôi phục sau khi xóa)';

  @override
  String get draft_cleared_success => 'Đã dọn sạch bản nháp';

  @override
  String get login_required_for_studio =>
      'Vui lòng đăng nhập trước để vào phòng làm việc!';

  @override
  String get my_secret_studio_title => 'Phòng làm việc bí mật của tôi';

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
    return '$nickname cảm thấy bài viết của bạn rất tuyệt!';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname thấy $authorName rất quyến rũ nên đã nhấn thích!';
  }

  @override
  String get moment_like_success => 'Đã gửi đi sự rung động của bạn!';

  @override
  String get moment_notification_new_like => 'Lượt thích mới!';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname đã nhắc đến @$name trong bài viết nhé!';
  }

  @override
  String get moment_detail_title => 'Chi tiết bài viết';

  @override
  String get moment_not_found => 'Bài viết này hình như đã biến mất rồi...';

  @override
  String get moment_comment_title => 'Bình luận khoảnh khắc';

  @override
  String get moment_comment_empty =>
      'Chưa có ai bình luận, hãy là người đầu tiên nhé!';

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
    return 'Hãy cùng trò chuyện với $name về bài viết này nào!';
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
  String get moment_forward_title => 'Chuyển tiếp cho nhân vật đang trò chuyện';

  @override
  String get moment_forward_empty_state =>
      'Bạn hiện chưa có cuộc trò chuyện nào!\nHãy đến Sảnh để tìm người tâm đầu ý hợp nhé';

  @override
  String moment_forward_template(String author, String content) {
    return '【Đã chuyển tiếp một bài viết】\nTác giả: $author\nNội dung: $content';
  }

  @override
  String moment_forward_success(String name) {
    return 'Đã âm thầm chia sẻ với $name rồi nhé!';
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
    return 'Chào mừng bạn quay lại với $appName!\nĐiểm danh hôm nay để nhận $amount điểm Ngôn ngữ hoa.';
  }

  @override
  String get title_daily_check_in => 'Điểm danh mỗi ngày';

  @override
  String success_claim_reward(String amount) {
    return 'Nhận thành công $amount điểm Ngôn ngữ hoa!';
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
      'Đã rõ! Đã lưu vào bản nháp cho bạn, bạn có thể quay lại chỉnh sửa bất cứ lúc nào!';

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
  String get avatar_updated_success => 'Đã đổi ảnh đại diện cho bạn';

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
      'Sinh nhật sau khi thiết lập sẽ không thể thay đổi';

  @override
  String get action_start_journey => 'Bắt đầu hành trình';

  @override
  String get action_add_image => 'Thêm hình ảnh';

  @override
  String moment_like_self(String nickname) {
    return '$nickname cảm thấy bài viết của bạn rất tuyệt!';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname thấy $authorName rất quyến rũ nên đã nhấn thích!';
  }

  @override
  String get task_social_tour_complete =>
      'Hoàn thành nhiệm vụ dạo quanh mạng xã hội! Đừng quên nhận hoa nhé!';

  @override
  String get wall_title_shiguang => 'Tường Thập Quang';

  @override
  String get wall_tab_explore => 'Khám phá';

  @override
  String get wall_tab_exclusive => 'Độc quyền';

  @override
  String get more_options => 'Tùy chọn khác';

  @override
  String get delete_warning =>
      'Sau khi xóa, bài viết sẽ không thể lấy lại được';

  @override
  String get delete_success => 'Xóa thành công';

  @override
  String get notification_new_comment => 'Bình luận mới!';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName đã thích bài viết của bạn!';
  }

  @override
  String get empty_public_moments_prompt =>
      'Hiện tại đang trống rỗng,\nhãy đi đăng bài viết công khai đầu tiên nhé!';

  @override
  String get empty_private_moments_prompt =>
      'Vòng bạn bè vẫn chưa có khoảnh khắc nào,\nhãy đi tạo kỷ niệm cùng anh ấy nhé!';

  @override
  String get profile_archived_or_deleted_message =>
      'Hồ sơ linh hồn này đã được người sáng tạo lưu trữ, đặt ở chế độ riêng tư, hoặc đã tan biến trong dòng chảy thời gian...\n\nCó lẽ ở một vũ trụ song song nào đó, bạn vẫn có cơ hội gặp lại họ.';

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
  String get identity_creator => 'Tư cách Người sáng tạo';

  @override
  String get identity_character => 'Tư cách Nhân vật';

  @override
  String get decide_post_time_prompt =>
      'Giúp họ quyết định thời gian đăng bài nhé!';

  @override
  String get auto_post_schedule_hint =>
      'Sau khi bật, các bài đăng hàng ngày sẽ được đăng tự động vào thời gian đã chỉ định\n( Gợi ý: Hãy đặt thời gian lẻ để trông giống người thật hơn nhé!)';

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
  String get empty_public_moments_short => 'Hiện chưa có bài đăng công khai';

  @override
  String get empty_private_moments_short => 'Vòng bạn bè vẫn đang im lìm';

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
  String get daily_gift_success => 'Nhận quà tặng mỗi ngày thành công!';

  @override
  String get check_in_fail_network =>
      'Điểm danh thất bại, vui lòng kiểm tra kết nối mạng';

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
      'Trò chuyện với nhân vật 3 lần trong Chế độ Hằng ngày';

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
      'Kết nối mạng không ổn định, vui lòng thử lại sau';

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
      'Không tìm thấy nhân vật, thử tên khác nhé?';

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
  String get shop_empty_history => 'Hiện chưa có lịch sử nạp Hoa nào!';

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
    return 'Câu chuyện của hai bạn vẫn chưa bắt đầu...\nHãy trò chuyện nhiều hơn để $name\nviết nên những hồi ức đầu tiên nhé!';
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
  String get reset_bg_success => 'Đã khôi phục về hình nền mặc định';

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
  String get exclusiveMomentsGenerated => 'Đã tạo khoảnh khắc độc quyền';

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
      'Kích hoạt: Khế ước Tinh quang (Tặng điểm tức thì từ thẻ tháng)';

  @override
  String shop_log_top_up_double(int points) {
    return 'Nạp: $points điểm (Bao gồm nhân đôi lần nạp đầu )';
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
      'Chúc mừng bạn đã kích hoạt phần thưởng nhân đôi lần mua đầu!';

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
  String get task_monthly_title => 'Tinh Chi Khế Ước · Đặc quyền mỗi ngày';

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
      'Tinh Chi Mời Gọi: Phần thưởng người mới';

  @override
  String get referral_log_inviter_reward =>
      'Tinh Chi Mời Gọi: Phần thưởng bạn bè đạt mốc';

  @override
  String get referral_success_title => 'Đã mở khóa Tinh Chi Mời Gọi!';

  @override
  String get referral_success_content =>
      'Chúc mừng bạn đã giao lưu sâu sắc với nhân vật đạt mốc 15 câu thành công!\n\n\'Phần thưởng người mới 50 điểm\' đã được gửi đến tài khoản của bạn, và bạn của bạn cũng đồng thời nhận được phần thưởng 50 điểm!';

  @override
  String get profile_referral_title => 'Tinh Chi Mời Gọi';

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
    return 'Mình đã bắt đầu hành trình rung động cùng $character trong 《Luyến Luyến Thập Quang》 rồi đấy! Hãy tải ngay App và nhập mã Tinh Chi Mời Gọi của mình: 【$code】 tại trang cá nhân nhé, cả hai chúng mình đều sẽ nhận được 50 điểm Hoa miễn phí đấy!\n\nLink tải:\nhttps://lianlianshiguang.web.app/download/';
  }

  @override
  String get chat_levelup_share_btn =>
      'Khoe khoảnh khắc rung động này với bạn bè';

  @override
  String profile_my_invite_code_with_char(String character) {
    return 'Mã mời độc quyền của tôi (Bias hiện tại: $character)';
  }

  @override
  String get profile_send_invite_btn => 'Gửi Tinh Chi Mời Gọi cho bạn bè';

  @override
  String get profile_fallback_character => 'Nhân vật yêu thích';

  @override
  String get profile_copy_success => 'Đã sao chép mã mời vào khay nhớ tạm!';

  @override
  String get profile_referral_rule_title => 'Quy tắc Tinh Chi Mời Gọi';

  @override
  String get profile_referral_rule_receiver =>
      'Sau khi liên kết mã mời, chỉ cần trò chuyện với bất kỳ nhân vật yêu thích nào đạt mốc 15 câu, bạn và người mời sẽ đồng thời nhận được phần thưởng 50 Hoa!\n\nLưu ý: Vui lòng nhập mã mời trong vòng 3 ngày sau khi đăng ký tài khoản để mã có hiệu lực.';

  @override
  String get profile_referral_rule_inviter =>
      'Mời bạn mới tải App và nhập mã mời của bạn. Khi người đó hoàn thành liên kết trong vòng 3 ngày sau khi đăng ký và trò chuyện với bất kỳ nhân vật nào đạt 15 câu, cả hai bên sẽ đồng thời nhận được phần thưởng 50 điểm Hoa nhé!';

  @override
  String get error_user_not_found =>
      'Không tìm thấy người dùng, vui lòng đăng nhập lại';

  @override
  String get error_id_taken => 'ID này đã được sử dụng, vui lòng chọn ID khác!';

  @override
  String get error_id_taken_short => 'ID này đã được sử dụng!';

  @override
  String get shop_restocking => 'Cửa hàng đang bổ sung hàng hóa...';

  @override
  String get shop_preview_mode => 'Hiện tại đang ở chế độ xem trước cửa hàng';

  @override
  String get friendlyReminderTitle => 'Nhắc nhở thân thiện';

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
    return 'Để anh ấy nói tiếp sẽ tiêu tốn $cost điểm Hoa\nBạn có chắc chắn muốn tiếp tục không?';
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
  String get creatorExclusive => 'Dành riêng cho nhà sáng tạo';

  @override
  String ageAndOccupation(String age, String occupation) {
    return '$age tuổi | $occupation';
  }

  @override
  String get likesLabel => 'Sở thích';

  @override
  String get dislikesLabel => 'Ghét';

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
      'Tại sao bạn lại cần chức năng \"Tạo lại\"?';

  @override
  String get passGuideRegenerateContent =>
      'AI đôi khi sẽ giống như một khúc gỗ ngốc nghếch, không hiểu phong tình. Khi gặp phải câu trả lời không ưng ý, chỉ cần nhấn tạo lại là giống như thời gian quay ngược vậy! Bạn có thể khiến anh ấy suy nghĩ lại, cho đến khi nói ra câu thoại hoàn hảo khiến tim bạn đập loạn nhịp.';

  @override
  String get passGuideAffectionTitle =>
      'Tăng tốc độ hảo cảm thì có tác dụng gì?';

  @override
  String get passGuideAffectionContent =>
      'Trong game, độ hảo cảm là chiếc chìa khóa duy nhất để mở khóa \"bí mật sâu kín\" và \"ảnh riêng tư thân mật\" của nhân vật. Việc được cộng thêm 20% sẽ giúp bạn bước vào sâu trong tim anh ấy nhanh hơn những người khác.';

  @override
  String get passGuideUnlockButton => 'Mình đã hiểu, mở khóa ngay!';

  @override
  String get pleaseWait => 'Vui lòng chờ';

  @override
  String get createNewProfileTitle => 'Tạo Hồ Sơ Thập Quang Mới';

  @override
  String get editProfileTitle => 'Chỉnh Sửa Hồ Sơ Thập Quang';

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
  String get exclusiveProfileTitle => 'Hồ Sơ Thập Quang Độc Quyền';

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
  String get birthday_dialog_title => 'Bất ngờ sinh nhật';

  @override
  String get birthday_dialog_content =>
      'Hôm nay là ngày kỷ niệm dành riêng cho bạn!\n\nXin vui lòng nhận món quà này:\nHôm nay trò chuyện H.O.À.N T.O.À.N M.I.Ễ.N P.H.Í!';

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
  String get easter_egg_title => 'Phát hiện Easter Egg ẩn';

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
      'Mở khóa Thẻ Tháng Premium thành công!';

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

  @override
  String get forgot_password => 'Quên mật khẩu?';

  @override
  String get forgot_password_empty_email =>
      'Vui lòng nhập email trước, sau đó nhấn Quên mật khẩu';

  @override
  String get forgot_password_email_sent =>
      'Email đặt lại mật khẩu đã được gửi, vui lòng kiểm tra hộp thư của bạn';

  @override
  String get forgot_password_error_default =>
      'Gửi email đặt lại mật khẩu thất bại, vui lòng thử lại sau';

  @override
  String get forgot_password_error_invalid_email =>
      'Định dạng email không chính xác';

  @override
  String get forgot_password_error_user_not_found =>
      'Không tìm thấy tài khoản nào liên kết với email này';

  @override
  String forgot_password_error_with_message(String error) {
    return 'Gửi email đặt lại mật khẩu thất bại: $error';
  }

  @override
  String get terms_not_accepted_toast =>
      'Vui lòng đọc và đồng ý với Điều khoản Sử dụng và Quy chuẩn Cộng đồng trước';

  @override
  String get terms_content =>
      'Chào mừng bạn đến với Liên Liên Thập Quang (Lian Lian Shi Guang).\n\nTrước khi sử dụng dịch vụ này, bạn phải đồng ý tuân thủ Điều khoản Sử dụng và Quy chuẩn Cộng đồng này.\n\nBạn không được tải lên, tạo, đăng tải hoặc truyền tải bất kỳ nội dung nào bất hợp pháp, vi phạm quyền sở hữu, khiêu dâm, khỏa thân, bạo lực, thù hận, quấy rối, lăng mạ, lừa đảo, tin nhắn rác (spam), hoặc các nội dung gây phản cảm, xúc phạm, gây hại đến quyền lợi của người khác.\n\nLian Lian Shi Guang áp dụng chính sách nghiêm cấm tuyệt đối (Zero-Tolerance) đối với nội dung không phù hợp và hành vi lạm dụng. Nếu người dùng vi phạm quy định, chúng tôi có thể xóa nội dung liên quan, giới hạn tính năng, tạm ngưng hoặc chấm dứt tài khoản.\n\nNgười dùng có thể báo cáo nội dung không phù hợp hoặc người dùng lạm dụng thông qua tính năng báo cáo và chặn được tích hợp sẵn trong Ứng dụng.';

  @override
  String get community_rules_title => 'Quy chuẩn Cộng đồng';

  @override
  String get community_rules_content =>
      'Lian Lian Shi Guang hy vọng mang đến một môi trường tương tác an toàn, thân thiện và tôn trọng các nhà sáng tạo cũng như người dùng.\n\nChúng tôi không cho phép các nội dung hoặc hành vi sau đây:\n1. Nội dung khiêu dâm, khỏa thân hoặc gợi dục không phù hợp\n2. Quấy rối, lăng mạ, bắt nạt hoặc đe dọa người khác\n3. Thù hận, phân biệt đối xử hoặc kích động bạo lực\n4. Nội dung máu me, bạo lực hoặc hành vi nguy hiểm\n5. Vi phạm bản quyền, quyền hình ảnh hoặc các quyền khác của người khác\n6. Tin nhắn rác, lừa đảo hoặc hành vi ác ý\n7. Các nội dung gây phản cảm hoặc không phù hợp để hiển thị công khai khác\n\nNgười dùng có thể báo cáo nội dung không phù hợp, đồng thời cũng có thể chặn người dùng lạm dụng. Sau khi chặn, nội dung của người dùng đó sẽ không còn hiển thị trên màn hình của bạn nữa.';

  @override
  String get block_self_error => 'Không thể chặn nội dung của chính mình';

  @override
  String get block_user_title => 'Chặn người dùng này?';

  @override
  String get block_user_content =>
      'Sau khi chặn, bạn sẽ không còn nhìn thấy nội dung do người dùng này đăng tải nữa.\nChúng tôi cũng sẽ nhận được thông báo và tiến hành xét duyệt.';

  @override
  String get block_user_success =>
      'Đã chặn người dùng này, các nội dung liên quan đã được xóa khỏi Tường Kỷ Niệm của bạn';

  @override
  String get block_user_failed => 'Chặn thất bại, vui lòng thử lại sau';

  @override
  String get terms_checkbox_read_agree => 'Tôi đã đọc và đồng ý với';

  @override
  String get terms_checkbox_terms => '《Điều khoản Sử dụng》';

  @override
  String get terms_checkbox_and => 'và';

  @override
  String get terms_checkbox_rules => '《Quy chuẩn Cộng đồng》';

  @override
  String get hidden_moments => 'Khoảnh khắc ẩn';

  @override
  String get hide_moment_title => 'Ẩn khoảnh khắc này?';

  @override
  String get hide_moment_content =>
      'Sau khi ẩn, bài viết này sẽ không còn xuất hiện trên Tường Kỷ Niệm của bạn nữa.';

  @override
  String get hide => 'Ẩn';

  @override
  String get hide_moment_success => 'Đã ẩn khoảnh khắc này';

  @override
  String get hide_moment_failed => 'Ẩn thất bại, vui lòng thử lại sau';

  @override
  String get block_character_not_found =>
      'Không tìm thấy dữ liệu nhân vật, không thể chặn';

  @override
  String get block_character_title => 'Chặn nhân vật này?';

  @override
  String block_character_content(String authorName) {
    return 'Sau khi chặn, bạn sẽ không nhìn thấy các khoảnh khắc do \"$authorName\" đăng tải nữa. Nếu nội dung này vi phạm quy định, chúng tôi cũng sẽ nhận được thông báo và tiến hành xét duyệt.';
  }

  @override
  String block_character_success(String authorName) {
    return 'Đã chặn \"$authorName\", các khoảnh khắc liên quan đã được ẩn';
  }

  @override
  String get block_character_failed => 'Chặn thất bại, vui lòng thử lại sau';

  @override
  String get hidden_moments_title => 'Khoảnh khắc ẩn';

  @override
  String get hidden_moments_empty => 'Hiện tại không có khoảnh khắc nào bị ẩn';

  @override
  String get hidden_moments_load_failed => 'Tải khoảnh khắc ẩn thất bại';

  @override
  String get hidden_moment_unknown_author => 'Nhân vật bí ẩn';

  @override
  String get hidden_moment_no_preview =>
      'Bài viết này không có nội dung để xem trước';

  @override
  String get unhide_moment_title => 'Hủy ẩn khoảnh khắc?';

  @override
  String get unhide_moment_content =>
      'Sau khi hủy ẩn, nếu bài viết này vẫn còn tồn tại, nó có thể sẽ xuất hiện lại trên Tường Kỷ Niệm của bạn trong tương lai.';

  @override
  String get unhide_moment_action => 'Hủy ẩn';

  @override
  String get unhide_moment_success => 'Đã hủy ẩn thành công';

  @override
  String get report_moment_title => 'Báo cáo khoảnh khắc này';

  @override
  String get report_moment_content =>
      'Bạn có chắc chắn muốn báo cáo khoảnh khắc này đến ban quản trị không? Các nội dung độc hại sẽ bị ẩn hoặc xóa bỏ.';

  @override
  String get report_confirm_button => 'Xác nhận báo cáo';

  @override
  String get report_success_message =>
      'Chúng tôi đã nhận được báo cáo của bạn. Đội ngũ kiểm duyệt sẽ tiến hành xử lý trong thời gian sớm nhất.';

  @override
  String get accountDeletionSubmittedTitle => 'Đã gửi yêu cầu xóa tài khoản';

  @override
  String get accountDeletionSubmittedContent =>
      'Đã hiểu! Chúng tôi sẽ dành thời hạn gia hạn 3 ngày cho tài khoản của bạn.\n\nNếu muốn hủy xóa tài khoản, bạn chỉ cần đăng nhập lại trong thời hạn này để khôi phục tài khoản.';

  @override
  String get restoreAccountDialogTitle => 'Yêu cầu xóa tài khoản';

  @override
  String get restoreAccountDialogContent =>
      'Tài khoản của bạn hiện đang trong hàng đợi chờ xóa.\n\nNếu tiếp tục đăng nhập, yêu cầu xóa sẽ bị hủy và tài khoản của bạn sẽ được khôi phục.';

  @override
  String get cancelLoginButton => 'Hủy đăng nhập';

  @override
  String get restoreAccountButton => 'Khôi phục tài khoản';

  @override
  String get voice_preview => 'Phát giọng nói';

  @override
  String get voice_preview_failed => 'Phát giọng nói thất bại';

  @override
  String get characterBannerSectionTitle => 'Banner trang chủ nhân vật';

  @override
  String get characterBannerDescription => 'Mô tả banner';

  @override
  String get characterBannerRemove => 'Xóa';

  @override
  String get characterBannerSelect => 'Chọn ảnh banner';

  @override
  String get characterBannerChange => 'Thay đổi ảnh banner';

  @override
  String get characterBannerSpecs =>
      'Tỷ lệ khuyến nghị 16:9, kích thước khuyến nghị 1920 × 1080';

  @override
  String get characterBannerDefaultHint =>
      'Nếu không cài đặt, trang chủ sẽ tự động sử dụng ảnh đại diện chính của nhân vật.';

  @override
  String get characterBannerHelpContent =>
      'Banner sẽ hiển thị ở khu vực hình ngang lớn trên trang chủ của nhân vật.\n\nKhuyến nghị sử dụng hình ảnh ngang tỷ lệ 16:9, ví dụ 1920 × 1080.\n\nNên đặt nhân vật chính và khuôn mặt ở gần trung tâm để tránh bị cắt trên các kích thước màn hình điện thoại khác nhau.\n\nNếu không thiết lập banner, hệ thống sẽ tự động sử dụng ảnh đại diện chính của nhân vật.';

  @override
  String get first_meeting_title => 'Lần đầu gặp gỡ';

  @override
  String get common_delete_network_failed =>
      'Xóa thất bại. Vui lòng kiểm tra kết nối mạng rồi thử lại';

  @override
  String get common_operation_failed_retry =>
      'Thao tác thất bại. Vui lòng thử lại sau';

  @override
  String exclusive_photo_number(int number) {
    return 'Ảnh độc quyền $number';
  }

  @override
  String get unlock_after_affection_increase =>
      'Mở khóa sau khi tăng Mức độ Hảo cảm';

  @override
  String get first_meeting_empty => 'Lần đầu gặp gỡ, chưa bắt đầu...';

  @override
  String photo_load_failed(String error) {
    return 'Tải ảnh thất bại: $error';
  }

  @override
  String get add_friend_failed_retry =>
      'Thêm bạn thất bại. Vui lòng thử lại sau.';

  @override
  String get remove_friend => 'Xóa bạn';

  @override
  String get report_character => 'Báo cáo nhân vật';

  @override
  String get block_character => 'Chặn nhân vật';

  @override
  String get daily_encounter => 'Gặp gỡ mỗi ngày';

  @override
  String get discovery_hall => 'Sảnh khám phá';

  @override
  String get latest_recommendation => 'Đề xuất mới nhất';

  @override
  String get popular_ranking => 'Bảng xếp hạng nổi bật';

  @override
  String get character_features => 'Đặc điểm nhân vật';

  @override
  String get featured_new_star => 'Ngôi sao mới tỏa sáng · Đề xuất hàng đầu';

  @override
  String get recently_added_characters => 'Nhân vật mới thêm gần đây';

  @override
  String get no_tag_data => 'Hiện tại chưa có dữ liệu thẻ~';

  @override
  String get no_character_with_tag => 'Không tìm thấy nhân vật nào có thẻ này';

  @override
  String get voice_search_failed_retry =>
      'Tìm kiếm giọng nói thất bại. Vui lòng thử lại';

  @override
  String get voice_search_incomplete_retry =>
      'Tìm kiếm chưa hoàn tất. Vui lòng thử lại sau';

  @override
  String get voice_data_incomplete => 'Dữ liệu giọng nói không đầy đủ';

  @override
  String get voice_generation_failed_retry =>
      'Tạo giọng nói thất bại. Vui lòng thử lại sau';

  @override
  String get voice_playback_failed_retry =>
      'Phát giọng nói thất bại. Vui lòng thử lại';

  @override
  String get selected_voice_data_incomplete =>
      'Dữ liệu giọng nói đã chọn không đầy đủ';

  @override
  String get private_voice_user_not_found =>
      'Không tìm thấy người dùng. Không thể cập nhật giọng nói nhân vật riêng tư';

  @override
  String get voice_selected_character_save_failed =>
      'Giọng nói đã chọn nhưng lưu dữ liệu nhân vật thất bại';

  @override
  String get voice_binding_failed => 'Liên kết giọng nói thất bại';

  @override
  String get play_voice_tooltip => 'Phát giọng nói';

  @override
  String get avatar_label => 'Ảnh đại diện';

  @override
  String get message_preview_image => '[Hình ảnh]';

  @override
  String get message_preview_recording => '[Bản ghi âm]';

  @override
  String get message_preview_voice => '[Tin nhắn thoại]';

  @override
  String get send_failed_retry => 'Gửi thất bại. Vui lòng thử lại sau';

  @override
  String get media_upload_failed_retry =>
      'Tải phương tiện lên thất bại. Vui lòng thử lại';

  @override
  String get ai_thinking_too_long =>
      'Anh ấy dường như đang trầm tư. Vui lòng thử lại sau...';

  @override
  String get ai_reply_in_progress =>
      'Anh ấy đang trả lời, vui lòng chờ một chút và không gửi lặp lại';

  @override
  String get ai_response_blocked =>
      'Suy nghĩ của anh ấy đã bị gián đoạn, hãy đổi sang cách nói nhẹ nhàng hơn nhé!';

  @override
  String get microphone_permission_required =>
      'Cần quyền truy cập micro để ghi âm';

  @override
  String get no_recording_to_send => 'Không có bản ghi âm nào để gửi';

  @override
  String get voice_uploading => 'Đang tải tin nhắn thoại lên...';

  @override
  String get change_watermark_color => 'Đổi màu hình mờ (watermark)';

  @override
  String get other_party_typing => 'Đối phương đang nhập...';

  @override
  String get chat_input_hint => 'Vui lòng nhập...';

  @override
  String get regenerate_sync_failed =>
      'Đồng bộ số lần tạo lại thất bại. Vui lòng thử lại';

  @override
  String get creator_public_works => 'Tác phẩm công khai';

  @override
  String get creator_received_likes => 'Lượt thích nhận được';

  @override
  String get about_me => 'Về tôi';

  @override
  String get moment_input_hint => 'Chia sẻ cảm xúc của bạn...';

  @override
  String character_play_count(int count) {
    return 'Số lượt chơi: $count';
  }

  @override
  String tag_page_title(String tag) {
    return 'Thẻ: #$tag';
  }

  @override
  String voice_preview_failed_detail(String code, String message) {
    return 'Nghe thử giọng nói thất bại: $code $message';
  }

  @override
  String messages_deleted_success(int count) {
    return 'Đã xóa thành công $count tin nhắn';
  }

  @override
  String creator_work_load_failed(String error) {
    return 'Tải tác phẩm thất bại: $error';
  }

  @override
  String age_years_old(String age) {
    return '$age tuổi';
  }

  @override
  String deleteFailedMessage(String error) {
    return 'Xóa thất bại: $error';
  }

  @override
  String loadCharacterDataFailed(String error) {
    return 'Tải dữ liệu nhân vật thất bại: $error';
  }

  @override
  String get draftAvatarLoadFailed => 'Tải ảnh đại diện bản nháp thất bại:';

  @override
  String get unnamedCreator => 'Nhà sáng tạo ẩn danh';

  @override
  String get profileNotYetFilled => 'Chưa điền phần giới thiệu bản thân';

  @override
  String get reportImageSizeLimit =>
      'Kích thước hình ảnh không được vượt quá 10 MB';

  @override
  String reportImageSelectFailed(String error) {
    return 'Chọn ảnh báo cáo thất bại: $error';
  }

  @override
  String get reportImageCannotSelect =>
      'Không thể chọn hình ảnh. Vui lòng thử lại sau';

  @override
  String get reportLoginRequired => 'Vui lòng đăng nhập trước khi gửi báo cáo';

  @override
  String get reportAnonymousPlayer => 'Người chơi ẩn danh';

  @override
  String get reportSendSuccess =>
      'Gửi báo cáo thành công. Cảm ơn ý kiến đóng góp của bạn!';

  @override
  String reportSendFailed(String error) {
    return 'Gửi báo cáo người chơi thất bại: $error';
  }

  @override
  String get reportNetworkFailed =>
      'Gửi thất bại. Vui lòng kiểm tra kết nối mạng rồi thử lại';

  @override
  String get reportAttachImageLabel => 'Đính kèm hình ảnh (Tùy chọn)';

  @override
  String get reportAttachImageHint =>
      'Khi báo cáo Bug hoặc tài nguyên chưa vào tài khoản, việc gửi đính kèm ảnh màn hình sẽ giúp đội ngũ xác nhận nhanh hơn.';

  @override
  String get reportOpeningAlbum => 'Đang mở thư viện ảnh...';

  @override
  String get reportSelectFromAlbum => 'Chọn ảnh từ thư viện';

  @override
  String get reportSending => 'Đang gửi...';

  @override
  String get reportSubmit => 'Gửi báo cáo';

  @override
  String get reportRemoveImage => 'Xóa hình ảnh';

  @override
  String get reportImageSelected => 'Đã chọn hình ảnh';

  @override
  String get reportChangeImage => 'Thay đổi';

  @override
  String get reloadTranslation => 'Tải lại bản dịch';

  @override
  String get guideNotAvailableInLanguage =>
      'Hướng dẫn chơi hiện chưa có sẵn bằng tiếng Việt; tạm thời hiển thị bằng tiếng Trung Phồn thể.';

  @override
  String get clearSearch => 'Xóa tìm kiếm';

  @override
  String get memoPermissionWarning =>
      'Quyền thông báo chưa được bật. Ghi chú vẫn sẽ được lưu nhưng sẽ không hiển thị nhắc nhở hệ thống.';

  @override
  String memoSavedWithNotification(String name) {
    return 'Đã lưu ghi chú! $name sẽ nhắc nhở bạn!';
  }

  @override
  String get memoSavedNoPermission =>
      'Đã lưu ghi chú, nhưng quyền thông báo chưa được bật.';

  @override
  String memoUpdatedWithNotification(String name) {
    return 'Đã cập nhật ghi chú! $name sẽ nhắc nhở bạn!';
  }

  @override
  String get memoUpdatedNoPermission =>
      'Đã cập nhật ghi chú, nhưng hiện tại chưa có quyền thông báo.';

  @override
  String dataLoadError(String error) {
    return 'Đã xảy ra lỗi khi tải dữ liệu: $error';
  }

  @override
  String loadFailed(String error) {
    return 'Tải thất bại: $error';
  }

  @override
  String get dateFormatMonthDay => 'd MMM';

  @override
  String get timeFormatHourMinute => 'HH:mm';

  @override
  String get likeFeedPrompt =>
      'Bạn thích bài viết này? Hãy gửi trao chút tình cảm cho người ấy nhé!';

  @override
  String get saveFeedPocket =>
      'Gói gọn những khoảnh khắc đặc biệt cất vào túi riêng của bạn.';

  @override
  String get newComment => 'Bình luận mới';

  @override
  String get someFriend => 'Một người bạn';

  @override
  String get myBackpackAndPrivileges => 'Balo & Đặc quyền của tôi';

  @override
  String get currentRomanticBond => 'Đã tích lũy mối duyên lãng mạn hiện tại';

  @override
  String get physicalGiftBoxUnlockStatus =>
      'Trạng thái mở khóa hộp quà hiện vật:';

  @override
  String get topLovePhysicalVipBox =>
      'Hộp quà VIP hiện vật độc quyền 【Đỉnh Cao Chí Ái】';

  @override
  String get physicalGiftBoxContents =>
      'Bao gồm: Thư tay độc quyền + Búp bê nhân vật + Thư cảm ơn chính thức';

  @override
  String get modifyShippingAddress => 'Sửa thông tin địa chỉ nhận hàng';

  @override
  String get addressUnlockedFillNow =>
      'Đã mở khóa! Nhấn vào đây để điền thông tin nhận hàng';

  @override
  String get addressSuccessfullyRegistered =>
      'Bạn đã đăng ký địa chỉ nhận hàng thành công, chúng tôi sẽ chuẩn bị cho bạn trong thời gian sớm nhất!';

  @override
  String amountNeededForPhysicalPrize(String amount) {
    return 'Chỉ còn thiếu NT\$ $amount nữa là có thể mở khóa phần thưởng hiện vật!';
  }

  @override
  String get avatarFrameHint =>
      'Gợi ý: Các giao diện kỹ thuật số và khung ảnh đại diện khác có thể xem và trang bị tại Cửa hàng hoặc Cài đặt cá nhân.';

  @override
  String get closeButton => 'Đóng';

  @override
  String get physicalGiftBoxUnlockTitle =>
      'Mở khóa hộp quà hiện vật 【Đỉnh Cao Chí Ái】';

  @override
  String get physicalGiftBoxUnlockThanks =>
      'Cảm ơn sự đồng hành chân thành của bạn dành cho Lian Lian Shi Guang!';

  @override
  String get physicalGiftBoxUnlockPrompt =>
      'Vui lòng điền thông tin nhận hàng bên dưới, chúng tôi sẽ gửi thư tay và búp bê nhân vật cho bạn:';

  @override
  String get recipientRealName => 'Họ và tên thật người nhận';

  @override
  String get contactPhone => 'Số điện thoại liên hệ';

  @override
  String get fullShippingAddress =>
      'Địa chỉ nhận hàng đầy đủ (bao gồm Mã bưu chính)';

  @override
  String get desiredCharacterDollName => 'Tên nhân vật búp bê muốn nhận';

  @override
  String get characterNameExample => 'Ví dụ: Tên nhân vật bạn muốn nhận';

  @override
  String get fillLater => 'Điền sau';

  @override
  String get fillCompleteAddressAndRoleHint =>
      'Vui lòng điền đầy đủ thông tin nhận hàng và tên nhân vật bạn yêu thích nhé!';

  @override
  String get shippingInfoSubmittedSuccess =>
      'Thông tin nhận hàng đã gửi thành công! Hãy đón chờ bất ngờ hiện vật từ chúng tôi nhé!';

  @override
  String get confirmSubmit => 'Xác nhận gửi';

  @override
  String get aboutMe => 'Về tôi';

  @override
  String get myBackpack => 'Balo của tôi';

  @override
  String get ownerExclusiveArea => 'Khu vực độc quyền của chủ sở hữu';

  @override
  String get enterShiguangAdminBackend =>
      'Vào bảng điều khiển quản trị Shiguang';

  @override
  String get errorOccurred => 'Đã xảy ra lỗi';

  @override
  String get creatorGuidelines => 'Quy chuẩn cho nhà sáng tạo';

  @override
  String get playGuide => 'Hướng dẫn chơi';

  @override
  String get lianlianShiguang => 'Lian Lian Shi Guang';

  @override
  String get copyrightNotice => '© 2026 Mặc Ngữ Bạch';

  @override
  String get cumulativeBenefits => 'Quyền lợi tích lũy';

  @override
  String get perkFirstEncounter => 'Sơ Kiến Khuynh Tâm';

  @override
  String get perkFirstEncounterReward =>
      '20 Hoa Thời Gian + Danh hiệu người chơi mới';

  @override
  String get perkGlimmerThrob => 'Vi Quang Ký Động';

  @override
  String get perkGlimmerThrobReward =>
      'Khung ảnh đại diện độc quyền 【Vi Quang Ký Động】';

  @override
  String get perkStarryWhisper => 'Tinh Không Như N喃';

  @override
  String get perkStarryWhisperReward =>
      'Khung chat độc quyền + 50 Hoa Thời Gian';

  @override
  String get perkRomanticSunset => 'Lãng Mạn Tịch Dương';

  @override
  String get perkRomanticSunsetReward => 'Biểu tượng ứng dụng độc quyền';

  @override
  String get perkHeartbeat => 'Phập Phồng Xao Xuyến';

  @override
  String get perkHeartbeatReward =>
      'Hiệu ứng chạm màn hình + 100 Hoa Thời Gian';

  @override
  String get perkEternalVow => 'Vĩnh Hằng Thệ Ước';

  @override
  String get perkEternalVowReward =>
      'Khung ảnh đại diện động cao cấp + 200 Hoa Thời Gian';

  @override
  String get perkSoulIntersection => 'Linh Hồn Giao Hội';

  @override
  String get perkSoulIntersectionReward =>
      'Hiệu ứng khung chat động + Danh hiệu cao cấp độc quyền';

  @override
  String get perkExclusiveWait => 'Độc Quyền Thủ Hậu';

  @override
  String get perkExclusiveWaitReward =>
      'Thẻ tên động đỉnh cao + 500 Hoa Thời Gian';

  @override
  String get perkBrilliantGalaxy => 'Trái Diệu Tinh Hà';

  @override
  String get perkBrilliantGalaxyReward =>
      'Hiệu ứng xuất hiện độc quyền + CSKH riêng biệt';

  @override
  String get perkTopBeloved => 'Đỉnh Cao Chí Ái';

  @override
  String get perkTopBelovedReward => 'Hộp quà hiện vật VIP độc quyền';

  @override
  String get cumulativeRomanticBond => 'Tích lũy duyên lãng mạn';

  @override
  String get allTopPrivilegesUnlocked =>
      'Bạn đã mở khóa toàn bộ đặc quyền đỉnh cao!';

  @override
  String rechargeAmountForNextTier(String amount) {
    return 'Nạp thêm NT\$ $amount để mở khóa cấp tiếp theo';
  }

  @override
  String get storyContentCannotBeEmpty =>
      'Nội dung câu chuyện không được để trống';

  @override
  String get writeYourStoryHint => 'Viết nên câu chuyện của hai bạn...';

  @override
  String get characterBannerTitle => 'Banner trang chủ nhân vật';

  @override
  String get mailDeleteTitle => 'Xóa thư';

  @override
  String mailDeleteConfirm(int count) {
    return 'Bạn có chắc muốn xóa $count thư không?\nKhông thể khôi phục sau khi xóa.';
  }

  @override
  String mailDeleteSuccess(int count) {
    return 'Đã xóa $count thư';
  }

  @override
  String get mailDeleteFailed => 'Xóa không thành công. Vui lòng thử lại sau.';

  @override
  String get mailCancelSelection => 'Hủy chọn';

  @override
  String mailSelectedCount(int count) {
    return 'Đã chọn $count thư';
  }

  @override
  String get moreOptions => 'Thêm';

  @override
  String mailDeleteSelected(int count) {
    return 'Xóa $count thư';
  }

  @override
  String get officialManagementTeam => 'Đội ngũ quản lý LoveyDovey';

  @override
  String get rewardCampaignTitle => 'Quà sự kiện';

  @override
  String get rewardCampaignMissingData =>
      'Thư quà tặng này thiếu dữ liệu sự kiện. Vui lòng thử lại sau.';

  @override
  String rewardCampaignClaimSuccess(int amount) {
    return 'Đã nhận $amount Bông Hoa';
  }

  @override
  String get rewardCampaignAlreadyClaimed => 'Phần quà này đã được nhận';

  @override
  String get rewardCampaignClaimFailed =>
      'Nhận không thành công. Vui lòng thử lại sau.';

  @override
  String get rewardCampaignContains => 'Trong thư này có';

  @override
  String rewardCampaignFlowerAmount(int amount) {
    return '$amount Bông Hoa';
  }

  @override
  String rewardCampaignDeadline(String date) {
    return 'Hạn nhận: $date';
  }

  @override
  String get rewardCampaignClaiming => 'Đang nhận…';

  @override
  String get rewardCampaignClaimed => 'Đã nhận';

  @override
  String get rewardCampaignEnded => 'Sự kiện đã kết thúc';

  @override
  String get rewardCampaignClaimButton => 'Nhận quà';

  @override
  String get mailDetailTitle => 'Thư';

  @override
  String mailSender(String name) {
    return 'Người gửi: $name';
  }

  @override
  String get mailCaseNumber => 'Mã vụ việc';

  @override
  String get mailCopyCaseNumber => 'Sao chép mã vụ việc';

  @override
  String get mailCaseNumberCopied => 'Đã sao chép mã vụ việc';

  @override
  String get profilePageAboutMe => 'Giới thiệu về tôi';

  @override
  String get profilePageTabBio => 'Giới thiệu';

  @override
  String get profilePageTabCharacters => 'Nhân vật';

  @override
  String get profilePageTabMoments => 'Bài đăng';

  @override
  String get profilePageEditProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get profilePageFriends => 'Bạn bè';

  @override
  String get profilePageWorks => 'Tác phẩm';

  @override
  String get profilePageFollowing => 'Đang theo dõi';

  @override
  String get profilePageFollowers => 'Người theo dõi';

  @override
  String get profilePageHeartbeatDiary => 'Nhật ký rung động';

  @override
  String get profilePageEditCharacter => 'Chỉnh sửa nhân vật';

  @override
  String get profilePagePreviewCharacter => 'Xem trước hồ sơ nhân vật';

  @override
  String get profilePageNoBio => 'Chưa có phần giới thiệu';

  @override
  String get profilePageNoBioHint => 'Nhấn để viết đôi điều về bạn.';

  @override
  String get profilePageCreateCharacter => 'Tạo nhân vật mới';

  @override
  String get profilePageNoCharacters => 'Chưa tạo nhân vật nào';

  @override
  String get profilePageNoCharactersHint =>
      'Hãy bắt đầu tạo nhân vật đầu tiên của bạn.';

  @override
  String get profilePageCharacterActions => 'Thao tác với nhân vật';

  @override
  String get profilePagePublic => 'Công khai';

  @override
  String get profilePagePrivate => 'Riêng tư';

  @override
  String get profilePageCreator => 'Nhà sáng tạo';

  @override
  String get profilePageSelectPostingIdentity => 'Chọn danh tính đăng bài';

  @override
  String get profilePagePostAsCreator => 'Đăng với tư cách nhà sáng tạo';

  @override
  String get profilePagePublicCharacter => 'Nhân vật công khai';

  @override
  String get profilePagePrivateCharacter => 'Nhân vật riêng tư';

  @override
  String get profilePagePleaseSignIn => 'Vui lòng đăng nhập trước';

  @override
  String get profilePagePublishMoment => 'Đăng bài';

  @override
  String get profilePageFilterAll => 'Tất cả';

  @override
  String get profilePageFilterCreator => 'Tôi';

  @override
  String get profilePageFilterCharacter => 'Nhân vật';

  @override
  String get profilePageMomentsLoadFailed => 'Không thể tải bài đăng';

  @override
  String get profilePageTryAgainLater => 'Vui lòng thử lại sau.';

  @override
  String get profilePageNoCreatorMoments => 'Bạn chưa đăng bài nào';

  @override
  String get profilePageNoCreatorMomentsHint =>
      'Nội dung được đăng với tư cách nhà sáng tạo sẽ hiển thị tại đây.';

  @override
  String get profilePageNoCharacterMoments =>
      'Các nhân vật của bạn chưa đăng bài nào';

  @override
  String get profilePageNoCharacterMomentsHint =>
      'Nội dung được đăng với tư cách nhân vật sẽ hiển thị tại đây.';

  @override
  String get profilePageNoMoments => 'Chưa có bài đăng';

  @override
  String get profilePageNoMomentsHint =>
      'Bài đăng của bạn và các nhân vật sẽ hiển thị tại đây.';

  @override
  String get profilePageDeleteMomentTitle => 'Xóa bài đăng';

  @override
  String get profilePageDeleteMomentConfirm =>
      'Bạn có chắc muốn xóa vĩnh viễn bài đăng này không?';

  @override
  String get profilePageCancel => 'Hủy';

  @override
  String get profilePageDelete => 'Xóa';

  @override
  String get profilePageMomentDeleted => 'Đã xóa bài đăng';

  @override
  String get profilePageDeleteFailed =>
      'Xóa không thành công. Vui lòng thử lại sau.';

  @override
  String get profilePageReferralCompleted => 'Đã hoàn thành Lời mời Ngôi sao';

  @override
  String profilePageInviter(String inviterId) {
    return 'Người mời: $inviterId';
  }

  @override
  String get profilePageReferralRewardReceived =>
      'Cả hai bên đã nhận được 50 Bông Hoa';

  @override
  String get profilePageClaimed => 'Đã nhận';

  @override
  String profilePageInviterBound(String inviterId) {
    return 'Đã liên kết người mời: $inviterId';
  }

  @override
  String get profilePageReferralProgressHint =>
      'Sau khi hoàn thành 15 tin nhắn trò chuyện, mỗi bên sẽ nhận được 50 Bông Hoa';

  @override
  String get profilePageAlreadyCheckedIn => 'Hôm nay bạn đã điểm danh rồi';

  @override
  String get profilePageReferralBindFailed =>
      'Liên kết không thành công. Vui lòng thử lại sau.';

  @override
  String get profilePageCharacterNotFound =>
      'Không tìm thấy dữ liệu của nhân vật này';

  @override
  String get periodGuideTitle => 'Sử dụng Nhật ký Kinh nguyệt như thế nào?';

  @override
  String get periodGuideContent =>
      '① Trước tiên, hãy chọn một ngày trên lịch.\n② Chọn “Bắt đầu hôm nay”, “Vẫn đang có kinh” hoặc “Kết thúc hôm nay”.\n③ Chọn tâm trạng và tình trạng cơ thể trong ngày. Bạn cũng có thể tự bổ sung thông tin.\n④ Nhấn Lưu để nhân vật có thể hiểu tình trạng của bạn hôm nay khi trò chuyện.\n\nNgày dự đoán sẽ được điều chỉnh dựa trên lịch sử ghi chép của bạn và chỉ dùng để tham khảo cho việc theo dõi cá nhân.';

  @override
  String get periodGotIt => 'Tôi hiểu rồi';

  @override
  String get periodSelectAtLeastOne =>
      'Vui lòng chọn ít nhất một mục để ghi lại';

  @override
  String get periodFutureDateError =>
      'Không thể đánh dấu trạng thái kinh nguyệt cho ngày trong tương lai.';

  @override
  String get periodAlreadyOngoingError =>
      'Đã có một kỳ kinh đang diễn ra. Vui lòng kết thúc kỳ kinh đó trước.';

  @override
  String get periodNoOngoingError =>
      'Hiện không có kỳ kinh nào đang diễn ra. Vui lòng chọn “Bắt đầu hôm nay” trước.';

  @override
  String get periodBeforeStartError =>
      'Ngày không được sớm hơn ngày bắt đầu của kỳ kinh hiện tại.';

  @override
  String get periodEndBeforeStartError =>
      'Ngày kết thúc không được sớm hơn ngày bắt đầu.';

  @override
  String periodRecordSaved(String date) {
    return 'Đã lưu ghi chép ngày $date';
  }

  @override
  String get periodSaveFailed => 'Lưu không thành công. Vui lòng thử lại sau';

  @override
  String get periodDeleteTitle => 'Xóa ghi chép kỳ kinh này?';

  @override
  String get periodDeleteContent =>
      'Sau khi xóa, chu kỳ trung bình và lần dự đoán tiếp theo cũng sẽ được tính lại.';

  @override
  String get periodCancel => 'Hủy';

  @override
  String get periodDelete => 'Xóa';

  @override
  String get periodNoOngoing => 'Hiện không có kỳ kinh nào đang diễn ra';

  @override
  String periodDayCount(int count) {
    return 'Ngày thứ $count của kỳ kinh';
  }

  @override
  String get periodHelp => 'Hướng dẫn sử dụng';

  @override
  String get periodAverageCycle => 'Chu kỳ trung bình';

  @override
  String get periodAverageDuration => 'Thời gian hành kinh trung bình';

  @override
  String periodDays(int count) {
    return '$count ngày';
  }

  @override
  String get periodNextPrediction => 'Dự đoán tiếp theo';

  @override
  String get periodCalculatedAfterRecording => 'Tính sau khi ghi chép';

  @override
  String get periodInsufficientData =>
      'Hiện chưa có đủ dữ liệu. Tạm thời, dự đoán sẽ sử dụng chu kỳ 28 ngày và thời gian hành kinh 5 ngày.';

  @override
  String get periodPredictionDisclaimer =>
      'Dự đoán dựa trên các ghi chép hiện có. Ngày chỉ dùng để tham khảo cho việc theo dõi cá nhân.';

  @override
  String get periodStartedToday => 'Bắt đầu hôm nay';

  @override
  String get periodStillOngoing => 'Vẫn đang có kinh';

  @override
  String get periodEndedToday => 'Kết thúc hôm nay';

  @override
  String get periodDateNotReached => 'Ngày này vẫn chưa đến～';

  @override
  String get periodDateBeforeStart =>
      'Ngày này sớm hơn ngày bắt đầu của kỳ kinh hiện tại.';

  @override
  String get periodMoodOkay => 'Khá ổn';

  @override
  String get periodMoodHappy => 'Vui vẻ';

  @override
  String get periodMoodLow => 'Buồn';

  @override
  String get periodMoodUnwell => 'Khó chịu';

  @override
  String get periodMoodIrritable => 'Cáu kỉnh';

  @override
  String get periodMoodTired => 'Mệt mỏi';

  @override
  String get periodMoodAnxious => 'Lo lắng';

  @override
  String get periodSymptomAbdominalPain => 'Đau bụng';

  @override
  String get periodSymptomLowerBackPain => 'Đau thắt lưng';

  @override
  String get periodSymptomHeadache => 'Đau đầu';

  @override
  String get periodSymptomBreastTenderness => 'Căng tức ngực';

  @override
  String get periodSymptomSwelling => 'Phù nề';

  @override
  String get periodSymptomSleepy => 'Buồn ngủ';

  @override
  String get periodSymptomIncreasedAppetite => 'Tăng cảm giác thèm ăn';

  @override
  String get periodSymptomDigestiveDiscomfort => 'Khó chịu đường tiêu hóa';

  @override
  String periodDiaryTitle(String characterName) {
    return 'Nhật ký quan tâm của $characterName';
  }

  @override
  String get periodLoadFailed => 'Không thể tải ghi chép. Vui lòng thử lại sau';

  @override
  String get periodWeekdaySun => 'CN';

  @override
  String get periodWeekdayMon => 'T2';

  @override
  String get periodWeekdayTue => 'T3';

  @override
  String get periodWeekdayWed => 'T4';

  @override
  String get periodWeekdayThu => 'T5';

  @override
  String get periodWeekdayFri => 'T6';

  @override
  String get periodWeekdaySat => 'T7';

  @override
  String get periodSaveInstruction =>
      'Sau khi chọn trạng thái, hãy nhấn “Lưu ghi chép hôm nay” ở phía dưới để lưu chính thức.';

  @override
  String get periodTodayMood => 'Tâm trạng hôm nay (Có thể chọn nhiều mục)';

  @override
  String get periodMoodDescription =>
      'Đây là những ghi chép nhật ký trong ngày, không phải biểu tượng hiển thị trên lịch.';

  @override
  String get periodOtherMood => 'Tâm trạng khác';

  @override
  String get periodOtherMoodHint => 'Ví dụ: tủi thân, cảm thấy bất an……';

  @override
  String get periodTodaySymptoms =>
      'Tình trạng cơ thể hôm nay (Có thể chọn nhiều mục)';

  @override
  String get periodOtherSymptom => 'Tình trạng cơ thể khác';

  @override
  String get periodOtherSymptomHint => 'Ví dụ: cảm thấy lạnh, không muốn ăn……';

  @override
  String periodNoteForCharacter(String characterName) {
    return 'Điều bạn muốn $characterName biết (Không bắt buộc)';
  }

  @override
  String get periodNoteHint =>
      'Ví dụ: hôm nay tôi muốn nghỉ ngơi yên tĩnh và không muốn bị thúc giục……';

  @override
  String get periodSaving => 'Đang lưu…';

  @override
  String get periodSaveToday => 'Lưu ghi chép hôm nay';

  @override
  String get periodHistory => 'Lịch sử kinh nguyệt';

  @override
  String get periodOngoing => 'Đang diễn ra';

  @override
  String periodTotalDays(int count) {
    return 'Tổng cộng $count ngày';
  }

  @override
  String get periodDeleteRecord => 'Xóa ghi chép';

  @override
  String get privateProfilePleaseSignIn => 'Vui lòng đăng nhập trước';

  @override
  String privateProfileLoreLoadFailed(String error) {
    return 'Không thể tải Mảnh Ký Ức: $error';
  }

  @override
  String privateProfileWriteNewLore(int count, int limit) {
    return 'Viết Mảnh Ký Ức mới ($count / $limit)';
  }

  @override
  String get privateProfileNoLore => 'Chưa có Mảnh Ký Ức';

  @override
  String get privateProfileNoLoreHint =>
      'Bạn có thể sắp xếp các thiết lập thử nghiệm, manh mối câu chuyện và ký ức quan trọng của nhân vật tại đây.';

  @override
  String get privateProfileUntitledLore => 'Mảnh chưa đặt tên';

  @override
  String get privateProfileEdit => 'Chỉnh sửa';

  @override
  String get privateProfileDelete => 'Xóa';

  @override
  String get privateProfileAddLore => 'Thêm Mảnh Ký Ức';

  @override
  String get privateProfileLoreTitle => 'Tiêu đề';

  @override
  String get privateProfileLoreTeaser => 'Gợi ý ngắn';

  @override
  String get privateProfileLoreContent => 'Nội dung đầy đủ';

  @override
  String get privateProfileLockLore => 'Khóa mảnh ký ức';

  @override
  String get privateProfileLockLoreHint =>
      'Hiện tại, nhân vật riêng tư chỉ hiển thị với nhà sáng tạo. Trường này sẽ được giữ lại để tiếp tục sử dụng khi nhân vật được đặt thành công khai.';

  @override
  String get privateProfileCancel => 'Hủy';

  @override
  String get privateProfileTitleContentRequired =>
      'Vui lòng nhập tiêu đề và nội dung';

  @override
  String get privateProfileLoreAdded => 'Đã thêm Mảnh Ký Ức';

  @override
  String get privateProfileAddFailed =>
      'Thêm không thành công. Vui lòng thử lại sau';

  @override
  String get privateProfilePublish => 'Đăng';

  @override
  String get privateProfileDeleteLoreTitle => 'Xóa Mảnh Ký Ức';

  @override
  String get privateProfileDeleteLoreConfirm =>
      'Bạn có chắc muốn xóa vĩnh viễn Mảnh Ký Ức này không?';

  @override
  String get privateProfileLoreDeleted => 'Đã xóa Mảnh Ký Ức';

  @override
  String get privateProfileDeleteFailed =>
      'Xóa không thành công. Vui lòng thử lại sau';

  @override
  String get privateProfileEditLore => 'Chỉnh sửa Mảnh Ký Ức';

  @override
  String get privateProfileSave => 'Lưu';

  @override
  String get editProfileBirthdayReminderTitle => 'Lời nhắc nhỏ';

  @override
  String get editProfileBirthdayReminderContent =>
      'Ngày sinh của bạn sẽ ảnh hưởng đến lời chúc mừng sinh nhật từ nhân vật, quà sinh nhật và các sự kiện liên quan.\n\nBạn nên xác nhận ngày sinh trước khi hoàn tất thiết lập\nđể tránh ảnh hưởng đến phần thưởng sinh nhật sau này.';

  @override
  String get editProfileGotIt => 'Tôi hiểu rồi';

  @override
  String get editProfileBirthdayConfirmTitle => 'Xác nhận ngày sinh';

  @override
  String get editProfileBirthdayConfirmContent =>
      'Vui lòng kiểm tra xem ngày sinh có chính xác không.\n\nNgày sinh sẽ được sử dụng cho lời chúc mừng sinh nhật, quà sinh nhật và các sự kiện liên quan.\n\nĐể tránh nhận phần thưởng sinh nhật nhiều lần, bạn sẽ không thể thay đổi ngày sinh sau khi hoàn tất thiết lập.\n\nBạn có chắc muốn sử dụng ngày sinh này không?';

  @override
  String get editProfileReturnToEdit => 'Quay lại chỉnh sửa';

  @override
  String get editProfileConfirmSetting => 'Xác nhận thiết lập';

  @override
  String get editProfileDefaultNickname => 'Lữ khách mới quen';

  @override
  String get editProfileNoChanges => 'Không có thay đổi nào cần lưu';

  @override
  String editProfileCreateFailed(String error) {
    return 'Không thể tạo dữ liệu: $error';
  }

  @override
  String editProfileAvatarNumber(int number) {
    return 'Ảnh đại diện $number';
  }

  @override
  String get editProfileImageSelectionFailed =>
      'Không thể chọn hình ảnh. Vui lòng chọn hình ảnh khác';

  @override
  String get editProfileCancel => 'Hủy';

  @override
  String get editProfileConfirm => 'Xác nhận';

  @override
  String get editProfileImageProcessingFailed =>
      'Không thể xử lý hình ảnh. Vui lòng chọn hình ảnh khác';

  @override
  String editProfileLoadFailed(String error) {
    return 'Không thể tải dữ liệu: $error';
  }

  @override
  String get editProfileBioLabel => 'Giới thiệu';

  @override
  String get editProfileBioHelper =>
      'Giới thiệu ngắn gọn về bản thân hoặc phong cách sáng tạo của bạn';

  @override
  String get editProfileBioHint =>
      'Ví dụ: Tôi thích sáng tạo các nhân vật lãng mạn giả tưởng, ám ảnh và nhập vai.';

  @override
  String get editProfileUserNotFound => 'Không tìm thấy người dùng';

  @override
  String get editProfileGenerateIdFailed =>
      'Không thể tạo ID Người chơi. Vui lòng thử lại';

  @override
  String get editProfileSignedInUserNotFound =>
      'Không tìm thấy người dùng hiện đang đăng nhập';

  @override
  String editProfileAvatarReadFailed(int statusCode) {
    return 'Không thể tải ảnh đại diện. Mã trạng thái: $statusCode';
  }

  @override
  String editProfileAvatarFileNotFound(String path) {
    return 'Không tìm thấy tệp ảnh đại diện đã chọn: $path';
  }

  @override
  String get editProfileAvatarEmpty => 'Dữ liệu ảnh đại diện trống';

  @override
  String get chatPageSendFailed => 'Gửi không thành công. Vui lòng thử lại sau';

  @override
  String get chatPageRegenerateFailed =>
      'Tạo lại không thành công. Tin nhắn ban đầu đã được giữ lại. Vui lòng thử lại.';

  @override
  String get chatPageRegenerating => 'Đang suy nghĩ lại...';

  @override
  String get chatPageThinkingTooLong =>
      'Có vẻ anh ấy đang trầm ngâm. Vui lòng thử lại sau……';

  @override
  String get chatPageAlreadyReplying =>
      'Anh ấy đang trả lời. Vui lòng chờ một lát và đừng gửi lại';

  @override
  String get chatPageMediaUploadFailed =>
      'Tải nội dung đa phương tiện lên không thành công. Vui lòng thử lại';

  @override
  String get chatPageReportReceived =>
      'Cảm ơn bạn đã báo cáo. Chúng tôi sẽ kiểm tra sớm nhất có thể';

  @override
  String chatPageMessagesDeleted(int count) {
    return 'Đã xóa thành công $count tin nhắn';
  }

  @override
  String chatPageSelectPhotoFailed(String error) {
    return 'Không thể chọn ảnh: $error';
  }

  @override
  String get chatPageRecordingNotFound => 'Không tìm thấy tệp ghi âm';

  @override
  String get chatPageRecordingEmpty => 'Tệp ghi âm trống';

  @override
  String chatPageAudioPlaybackFailed(String error) {
    return 'Không thể phát âm thanh: $error';
  }

  @override
  String get chatPageMicrophonePermissionRequired =>
      'Cần cấp quyền sử dụng micrô để ghi âm';

  @override
  String chatPageStartRecordingFailed(String error) {
    return 'Không thể bắt đầu ghi âm: $error';
  }

  @override
  String get chatPageRecordingCreationFailed =>
      'Không thể tạo tệp ghi âm. Vui lòng ghi âm lại';

  @override
  String chatPageRecordingFailed(String error) {
    return 'Ghi âm không thành công: $error';
  }

  @override
  String get chatPageRecordingNotFoundRetry =>
      'Không tìm thấy tệp ghi âm. Vui lòng ghi âm lại';

  @override
  String get chatPageRecordingEmptyRetry =>
      'Tệp ghi âm trống. Vui lòng ghi âm lại';

  @override
  String get chatPageNoRecordingToSend => 'Không có bản ghi âm nào để gửi';

  @override
  String chatPagePointCost(int count) {
    return '$count điểm';
  }

  @override
  String get chatPageVoiceUploading => 'Đang tải bản ghi âm lên……';

  @override
  String get chatPageChangeWatermarkColor => 'Đổi màu hình mờ';

  @override
  String chatPageMinutesSeconds(int minutes, int seconds) {
    return '$minutes phút $seconds giây';
  }

  @override
  String chatPageSeconds(int seconds) {
    return '$seconds giây';
  }

  @override
  String get characterEditSelectSupportingCharacter =>
      'Vui lòng chọn nhân vật phụ.';

  @override
  String get characterEditSelectGender =>
      'Vui lòng chọn giới tính của nhân vật.';

  @override
  String get characterEditCharacterSettings => 'Thiết lập Nhân vật';

  @override
  String get characterEditWorldview => 'Bối cảnh Thế giới';

  @override
  String get characterEditSettingsMinLength =>
      'Thiết lập nhân vật phải có ít nhất 10 ký tự.';

  @override
  String get characterEditWorldviewMinLength =>
      'Bối cảnh thế giới phải có ít nhất 20 ký tự.';

  @override
  String get characterEditSupportingCharacters => 'Nhân vật Phụ';

  @override
  String get characterEditCharacterImage => 'Hình ảnh Nhân vật';

  @override
  String get characterEditWorldviewHint =>
      'Mô tả bối cảnh, lịch sử, thời đại, khu vực, thế lực, chế độ, công nghệ, phép thuật và quy tắc của thế giới.';

  @override
  String get characterEditSettingsHint =>
      'Mô tả tính cách, giá trị, cách suy nghĩ, phản ứng cảm xúc, thói quen hành vi, cách nói chuyện và niềm tin cốt lõi của nhân vật.';

  @override
  String get characterEditUnknownCharacter => 'Nhân vật Không xác định';

  @override
  String get characterEditEditSupportingCharacter => 'Chỉnh sửa Nhân vật Phụ';

  @override
  String get characterEditAddSupportingCharacter => 'Thêm Nhân vật Phụ';

  @override
  String get characterEditSupportingCharacterName => 'Tên Nhân vật Phụ';

  @override
  String get characterEditGender => 'Giới tính';

  @override
  String get characterEditMale => 'Nam';

  @override
  String get characterEditFemale => 'Nữ';

  @override
  String get characterEditOther => 'Khác';

  @override
  String get characterEditAge => 'Tuổi';

  @override
  String get characterEditIdentityOccupation => 'Thân phận／Nghề nghiệp';

  @override
  String get characterEditRelationshipWithMain =>
      'Mối quan hệ với Nhân vật Chính';

  @override
  String get characterEditRelationshipHint =>
      'Mô tả quá khứ, lập trường, tình cảm, bí mật và mối quan hệ hiện tại với nhân vật chính.';

  @override
  String get characterEditCharacterProfile => 'Thiết lập Nhân vật';

  @override
  String get characterEditCharacterProfileHint =>
      'Mô tả tính cách, ngoại hình, thói quen, giá trị, khả năng, sở thích, điều không thích và những trải nghiệm quan trọng của nhân vật.';

  @override
  String get characterEditSpeakingStyle => 'Cách nói chuyện';

  @override
  String get characterEditSpeakingStyleHint =>
      'Ví dụ: nói nhanh, thích châm chọc và nói chuyện thẳng thắn.';

  @override
  String get characterEditSupportingNameRequired =>
      'Vui lòng nhập tên nhân vật phụ.';

  @override
  String get characterEditSupportingGenderRequired =>
      'Vui lòng chọn giới tính của nhân vật phụ.';

  @override
  String get characterEditProfileRequired =>
      'Vui lòng nhập thiết lập nhân vật.';

  @override
  String get characterEditRelationshipTooLong =>
      'Mối quan hệ với nhân vật chính đã vượt quá 1.500 ký tự.';

  @override
  String get characterEditProfileTooLong =>
      'Thiết lập nhân vật đã vượt quá 1.500 ký tự.';

  @override
  String get characterEditSave => 'Lưu';

  @override
  String get characterEditAdd => 'Thêm';

  @override
  String get creatorProfileNoBio => 'Chưa có phần giới thiệu';

  @override
  String get creatorProfileNoBioHint =>
      'Nhà sáng tạo này chưa thêm phần giới thiệu.';

  @override
  String get creatorProfileNoCreatorMoments => 'Nhà sáng tạo chưa đăng bài nào';

  @override
  String get creatorProfileNoCreatorMomentsHint =>
      'Nội dung công khai được đăng với tư cách nhà sáng tạo sẽ hiển thị tại đây.';

  @override
  String get creatorProfileNoCharacterMoments =>
      'Các nhân vật của nhà sáng tạo chưa đăng bài nào';

  @override
  String get creatorProfileNoCharacterMomentsHint =>
      'Nội dung do các nhân vật công khai của nhà sáng tạo đăng sẽ hiển thị tại đây.';

  @override
  String get creatorProfileNoPublicMoments => 'Chưa có bài đăng công khai';

  @override
  String get creatorProfileNoPublicMomentsHint =>
      'Các bài đăng công khai của nhà sáng tạo và nhân vật sẽ hiển thị tại đây.';

  @override
  String get creatorProfilePublicWorks => 'Tác phẩm Công khai';

  @override
  String get creatorProfileLikesReceived => 'Lượt thích đã nhận';

  @override
  String get creatorProfileFollow => 'Theo dõi';

  @override
  String get creatorProfileFollowing => 'Đang theo dõi';

  @override
  String get creatorProfileUnfollowed => 'Đã bỏ theo dõi';

  @override
  String creatorProfileFollowedCreator(String creatorName) {
    return 'Đã theo dõi $creatorName';
  }

  @override
  String get creatorProfileOperationFailed =>
      'Thao tác không thành công. Vui lòng thử lại sau';

  @override
  String creatorProfileWorksLoadFailed(String error) {
    return 'Không thể tải tác phẩm: $error';
  }

  @override
  String get characterProfileShareInvitation => 'Lời mời gặp gỡ từ LoveyDovey';

  @override
  String characterProfileShareCreator(String creatorName) {
    return 'Nhà sáng tạo: $creatorName';
  }

  @override
  String characterProfileShareMessage(String characterName) {
    return 'Tìm kiếm “$characterName” trong LoveyDovey và bắt đầu câu chuyện chỉ thuộc về hai bạn.';
  }

  @override
  String get characterProfileInvitationLabel => 'Thiệp mời Nhân vật';

  @override
  String characterProfileCardCreator(String creatorName) {
    return 'Nhà sáng tạo  $creatorName';
  }

  @override
  String get characterProfileCardSearchHint =>
      'Tìm kiếm nhân vật và bắt đầu cuộc gặp gỡ';

  @override
  String get characterProfileScanToDownload => 'Quét để Tải xuống';

  @override
  String characterProfileShareTitle(String characterName) {
    return 'Chia sẻ nhân vật “$characterName”';
  }

  @override
  String characterProfileShareSubject(String characterName) {
    return 'Gặp gỡ $characterName tại LoveyDovey';
  }

  @override
  String get characterProfileShareFailed =>
      'Không thể tạo thiệp mời. Vui lòng thử lại sau';

  @override
  String get characterProfilePrivateShareUnavailable =>
      'Hiện không thể chia sẻ nhân vật riêng tư';

  @override
  String get characterProfileShareCard => 'Chia sẻ Thiệp mời';

  @override
  String get characterProfileShareCharacter => 'Chia sẻ Nhân vật';

  @override
  String get characterProfileReportCharacter => 'Báo cáo Nhân vật';

  @override
  String get characterProfileTranslate => 'Dịch';

  @override
  String get loginMethodInfoTooltip => 'Thông tin về phương thức đăng nhập';

  @override
  String get characterEditCoreSetting => 'Thiết lập cốt lõi của nhân vật';

  @override
  String get characterEditCoreSettingHint =>
      'Hãy mô tả tính cách, kiểu hành vi, cách tương tác với người khác và phong cách nói chuyện của nhân vật.\n\nVí dụ: Bề ngoài anh ấy lạnh lùng và ít nói, nhưng thực chất lại rất tinh tế. Anh ấy giữ khoảng cách với người lạ, quan tâm người mình thích bằng hành động, nói chuyện ngắn gọn và thẳng thắn, đồng thời không sử dụng những cách gọi quá ngọt ngào hoặc suồng sã.';

  @override
  String get characterEditNameDescription =>
      'Đây là tên hiển thị công khai của nhân vật. Sau khi hoàn tất quá trình tạo, hệ thống sẽ tự động tạo tên người dùng cho nhân vật.';

  @override
  String get characterEditNameHint => 'Vui lòng nhập tên nhân vật';

  @override
  String get characterEditAgeDescription =>
      'Thiết lập tuổi của nhân vật. Bạn cũng có thể nhập độ tuổi ngoại hình phù hợp với thế giới của câu chuyện.';

  @override
  String get characterEditAgeHint => 'Ví dụ: 25';

  @override
  String get characterEditOccupationDescription =>
      'Thân phận hoặc nghề nghiệp hiện tại của nhân vật, chẳng hạn như học sinh, bác sĩ, hiệp sĩ hoặc doanh nhân.';

  @override
  String get characterEditBirthdayDescription =>
      'Thiết lập ngày sinh của nhân vật bằng bốn chữ số hoặc dùng dấu gạch chéo để ngăn cách tháng và ngày.';

  @override
  String get characterEditBirthdayHint => 'Ví dụ: 0825 hoặc 08/25';

  @override
  String get characterEditHeightDescription =>
      'Thiết lập chiều cao của nhân vật theo đơn vị centimet.';

  @override
  String get characterEditHeightHint => 'Ví dụ: 182';

  @override
  String get characterEditGenderDescription =>
      'Hệ thống sẽ sử dụng đại từ phù hợp dựa trên giới tính của nhân vật.';

  @override
  String get characterEditAppearanceDescription =>
      'Mô tả đường nét khuôn mặt, kiểu tóc, trang phục và các đặc điểm ngoại hình khác của nhân vật.';

  @override
  String get characterEditPlayerIdentityDescription =>
      'Thiết lập thân phận của người chơi trong câu chuyện, chẳng hạn như trợ lý, bạn cùng lớp hoặc bạn thanh mai trúc mã.';

  @override
  String get characterEditWorldviewDescription =>
      'Mô tả thời đại, địa điểm, bối cảnh xã hội và các quy tắc đặc biệt của câu chuyện. Nội dung này sẽ được hiển thị công khai trong mục “Giới thiệu nhân vật” trên trang nhân vật, vì vậy hãy tránh điền những bí mật hoặc tình tiết mà bạn không muốn người chơi biết trước.';

  @override
  String get characterEditStorySummaryDescription =>
      'Giới thiệu ngắn gọn câu chuyện bằng một câu để người chơi có thể nhanh chóng hiểu được tình huống của nhân vật.';

  @override
  String get characterEditStorySummaryHint =>
      'Ví dụ: Câu chuyện tình yêu bắt đầu từ mối quan hệ hợp đồng với một bác sĩ lạnh lùng';

  @override
  String get characterEditInitialStoryDescription =>
      'Bối cảnh câu chuyện mà người chơi sẽ nhìn thấy đầu tiên khi vào phòng trò chuyện lần đầu.';

  @override
  String get characterEditFirstLineDescription =>
      'Câu nói đầu tiên của nhân vật khi gặp người chơi lần đầu.';

  @override
  String get characterEditCustomStatusBar =>
      'Thanh trạng thái cốt truyện (không bắt buộc)';

  @override
  String get characterEditCustomStatusBarDescription =>
      'Chỉ áp dụng cho Chế độ Cốt truyện và Chế độ Nhập vai. Bạn có thể thiết lập trạng thái, địa điểm, trang phục hoặc thông tin mối quan hệ của nhân vật để luôn hiển thị ở cuối câu trả lời. Nếu để trống, thanh trạng thái sẽ không được tạo.';

  @override
  String get characterProfileCharacterIntro => 'Giới thiệu nhân vật';

  @override
  String get characterProfileNoIntroduction =>
      'Nhà sáng tạo chưa thêm phần giới thiệu nhân vật';

  @override
  String get characterProfileViewMore => 'Xem thêm';

  @override
  String get characterProfileCollapse => 'Thu gọn';

  @override
  String get characterEditSelectedTagOrder =>
      'Kéo các thẻ đã chọn để điều chỉnh thứ tự hiển thị';

  @override
  String get mailActivityGiftFallback => 'Quà sự kiện';

  @override
  String get mailFilterAll => 'Tất cả';

  @override
  String get mailFilterCollected => 'Đã lưu';

  @override
  String get mailCollectedEmptyTitle => 'Hiện chưa có thư nào được lưu';

  @override
  String get mailCollectedEmptyHint =>
      'Mở bức thư bạn muốn lưu rồi nhấn nút lưu ở góc trên bên phải.';

  @override
  String get mailQixiLimitedBadge => 'Phiên bản giới hạn Thất Tịch';

  @override
  String get mailQixiThreeDayPromise => 'Thất Tịch LoveyDovey・Lời hẹn ba ngày';

  @override
  String mailQixiFromCharacter(String characterName) {
    return 'Thư Thất Tịch từ $characterName';
  }

  @override
  String mailFromCharacter(String characterName) {
    return 'Từ $characterName';
  }

  @override
  String get mailQixiCollectionLabel => 'Bộ sưu tập giới hạn Thất Tịch 2026';

  @override
  String get mailShareGenerating => 'Đang tạo ảnh chia sẻ……';

  @override
  String mailShareQixiMessage(String characterName) {
    return 'Tôi đã nhận được thư Thất Tịch giới hạn từ $characterName';
  }

  @override
  String get mailShareDefaultMessage => 'Một bức thư từ 「LoveyDovey」';

  @override
  String get mailShareImageFailed =>
      'Không thể tạo ảnh chia sẻ, vui lòng thử lại sau';

  @override
  String get mailCollectedSuccess => 'Đã lưu bức thư này';

  @override
  String get mailCollectedCancelled => 'Đã bỏ lưu';

  @override
  String get mailCollectedUpdateFailed =>
      'Không thể cập nhật trạng thái lưu, vui lòng thử lại sau';

  @override
  String get mailRemoveCollectionTooltip => 'Bỏ lưu';

  @override
  String get mailAddCollectionTooltip => 'Lưu thư';

  @override
  String get mailShareTooltip => 'Chia sẻ thư';

  @override
  String mailQixiDayNumber(int day) {
    return 'Ngày thứ $day';
  }

  @override
  String get mailQixiDetailTitle => 'Thư giới hạn Thất Tịch';

  @override
  String get mailQixiShareTooltip => 'Chia sẻ thư Thất Tịch';

  @override
  String get qixiMaxThreeFriends =>
      'Trong sự kiện này, bạn chỉ có thể chọn tối đa 3 nhân vật bạn bè';

  @override
  String get qixiLoginRequired =>
      'Vui lòng đăng nhập trước khi tham gia sự kiện Thất Tịch';

  @override
  String get qixiOutsideEventPeriod =>
      'Hiện không nằm trong thời gian diễn ra sự kiện Thất Tịch';

  @override
  String get qixiSelectAtLeastOne =>
      'Vui lòng chọn ít nhất một nhân vật bạn bè trước';

  @override
  String get qixiMysteryCharacter => 'Nhân vật bí ẩn';

  @override
  String qixiOpeningStory(String characterName) {
    return '(Khi Thất Tịch đến gần, dải ngân hà đang ngủ sâu trong màn đêm khẽ thức giấc. Những ánh sao rải rác dần tụ lại nơi chân trời, như thể đang chờ hai người sẵn lòng đến cuộc hẹn và viết tên của nhau.)\n\n(Tương truyền, Cầu Ô Thước chỉ sáng lên vì những người thực sự mong muốn được gặp nhau. Khi tên của bạn và \"$characterName\" cùng xuất hiện trên dòng sông sao, một tia sáng dịu dàng xuyên qua màn đêm và rơi xuống phòng trò chuyện chỉ thuộc về hai người.)\n\n(Từ giây phút này, hai người cùng có một \"Lời Hẹn Ba Ngày Thất Tịch\". Không cần phải là ba ngày liên tiếp, cũng không cần chuẩn bị một lời tỏ tình thật hoành tráng. Trong thời gian diễn ra sự kiện, chỉ cần quay lại đây vào ba ngày khác nhau và chia sẻ một lời chào, một tâm trạng, hay một chuyện nhỏ xảy ra trong ngày hôm nay.)\n\n(Mỗi lần gặp nhau thành công sẽ thắp sáng thêm một ánh sao trên Cầu Ô Thước. Khi ánh sao của cả ba ngày đều được thắp sáng, những tình cảm và ký ức rải rác trong cuộc trò chuyện sẽ hóa thành một lá thư Thất Tịch giới hạn chỉ dành riêng cho bạn sau khi ngày hoàn thành thứ ba kết thúc.)\n\n(Lúc này, tia sáng đầu tiên đã rơi xuống. Ở đầu bên kia của Cầu Ô Thước, dường như \"$characterName\" cũng đã nhận được lời hẹn này.)\n\n——Lời Hẹn Ba Ngày Thất Tịch bắt đầu từ bây giờ.';
  }

  @override
  String get qixiRoomOpenedLastMessage =>
      'Lời Hẹn Ba Ngày Thất Tịch đã bắt đầu';

  @override
  String get qixiCompanionSlotsFull =>
      'Bạn đã chọn đủ số nhân vật đồng hành Thất Tịch';

  @override
  String get qixiSingleRoomOpened =>
      'Phòng trò chuyện Thất Tịch riêng đã được mở';

  @override
  String qixiMultipleRoomsOpened(int count) {
    return 'Đã mở $count phòng trò chuyện Thất Tịch riêng';
  }

  @override
  String get qixiCreateRoomFailed =>
      'Không thể tạo phòng trò chuyện Thất Tịch. Vui lòng thử lại sau';

  @override
  String get qixiEventStartsAt => 'Sự kiện bắt đầu lúc 00:00 ngày 8/19';

  @override
  String get qixiEventActiveUntil =>
      'Sự kiện đang diễn ra · Kết thúc lúc 23:59 ngày 8/26';

  @override
  String get qixiEventEnded => 'Sự kiện Thất Tịch lần này đã kết thúc';

  @override
  String get qixiEventHeroTitle =>
      'Thất Tịch Lovey Time · Cùng Bạn Đến Cầu Ô Thước';

  @override
  String get qixiCharacterSelected => 'Đã chọn';

  @override
  String get qixiFriendListLoadFailed =>
      'Không thể tải danh sách bạn bè. Vui lòng thử lại sau';

  @override
  String get qixiNoFriendCharacters => 'Hiện bạn chưa có nhân vật bạn bè nào';

  @override
  String get qixiNoFriendCharactersHint =>
      'Hãy gặp một nhân vật bạn thích trước, rồi quay lại cùng nhau bước lên Cầu Ô Thước nhé!';

  @override
  String get qixiLoadingCharacter => 'Đang tải dữ liệu nhân vật……';

  @override
  String get qixiEventPageTitle => 'Sự Kiện Thất Tịch Giới Hạn';

  @override
  String get qixiEventRules =>
      'Trong thời gian sự kiện, hãy chọn 3 ngày khác nhau, gửi tin nhắn trong phòng trò chuyện Thất Tịch riêng và nhận được phản hồi thành công từ nhân vật để thắp sáng một trong ba ánh sao. Thư giới hạn sẽ được gửi sau khi ngày hoàn thành thứ ba kết thúc. Ngày sự kiện và tiến độ hằng ngày đều được tính theo giờ Đài Loan (UTC+8).';

  @override
  String qixiSelectCompanions(int count) {
    return 'Chọn Nhân Vật Đồng Hành ($count/3)';
  }

  @override
  String get qixiSelectionLockedHint =>
      'Bạn có thể chọn tối đa 3 nhân vật đã thêm làm bạn. Sau khi chọn sẽ không thể thay đổi.';

  @override
  String get qixiConfirmCompanions => 'Xác Nhận Nhân Vật Đồng Hành';

  @override
  String get encounterDailyQuote1 =>
      'Hôm nay, có lẽ bạn sẽ gặp một câu chuyện mới.';

  @override
  String get encounterDailyQuote2 =>
      'Hôm nay, hãy để trái tim lên tiếng trước.';

  @override
  String get encounterDailyQuote3 =>
      'Hôm nay, có lẽ ai đó đang chờ được gặp bạn.';

  @override
  String get encounterDailyQuote4 =>
      'Hôm nay, hãy thử bước vào một câu chuyện mới.';

  @override
  String get encounterDailyQuote5 =>
      'Hôm nay, bạn sẽ gặp cảm giác rung động như thế nào nhỉ?';

  @override
  String get encounterDailyQuote6 =>
      'Hôm nay, hãy dành cho bản thân một chút mong chờ.';

  @override
  String get encounterDailyQuote7 =>
      'Hôm nay, một cuộc gặp gỡ mới đang bắt đầu.';

  @override
  String get encounterDailyQuote8 =>
      'Hôm nay, có lẽ định mệnh sẽ mang đến một bất ngờ nho nhỏ.';

  @override
  String get encounterDailyQuote9 =>
      'Hôm nay, hãy để một cuộc gặp gỡ từ từ bắt đầu.';

  @override
  String get encounterDailyQuote10 =>
      'Hôm nay, có lẽ sẽ có ai đó khiến bạn phải dừng bước.';

  @override
  String get encounterDailyQuote11 =>
      'Hôm nay, bạn muốn gặp một người như thế nào?';

  @override
  String get encounterDailyQuote12 =>
      'Hôm nay, đừng bỏ lỡ nhân duyên đang lặng lẽ đến gần.';

  @override
  String get encounterJoinedToday => 'Tham gia Lovey Time hôm nay';

  @override
  String get encounterPopularChats =>
      'Gần đây có rất nhiều người đang trò chuyện';

  @override
  String get qixiBannerActiveUntil =>
      'Mở giới hạn thời gian · Đến 23:59 ngày 8/26';

  @override
  String get qixiBannerStartsAt => 'Mở giới hạn từ 8/19';

  @override
  String get encounterRecentlyArrived => 'Gần đây đã đến Lovey Time';

  @override
  String get encounterRecentlyArrivedPlain => 'Gần đây đã đến Lovey Time';

  @override
  String get encounterViewMore => 'Xem thêm';

  @override
  String get encounterLovePrompt =>
      'Hôm nay bạn muốn trải nghiệm kiểu tình yêu nào?';

  @override
  String get encounterNoCharacters => 'Hiện chưa có nhân vật nào';

  @override
  String get encounterAllLoveTags => 'Tất cả thẻ tình yêu';

  @override
  String get chatQixiLetterSent => 'Thư giới hạn đã được gửi';

  @override
  String get chatQixiLetterPendingTonight =>
      'Ba ánh sao đã được thắp sáng · Thư sẽ được gửi sau đêm nay';

  @override
  String get chatQixiTodayCompleted => 'Ánh sao hôm nay đã được thắp sáng';

  @override
  String get chatQixiTodayNotCompleted => 'Hôm nay vẫn chưa hoàn thành';

  @override
  String get chatQixiPromiseTitle => 'Thất Tịch Lovey Time · Lời Hẹn Ba Ngày';

  @override
  String chatQixiStarProgress(int count) {
    return 'Ánh sao $count/3';
  }

  @override
  String get chatQixiProgressRule =>
      'Hoàn thành trò chuyện vào ba ngày khác nhau để thắp sáng các vì sao. Thư giới hạn sẽ được gửi sau khi ngày thứ ba kết thúc. Tiến độ hằng ngày được tính theo giờ Đài Loan (UTC+8).';

  @override
  String chatQixiDayNumber(int day) {
    return 'Ngày $day';
  }

  @override
  String get chatWebPurchaseUnavailable =>
      'Phiên bản web hiện chưa hỗ trợ nạp tiền. Vui lòng sử dụng ứng dụng Lovey Time để mua Flowers hoặc đăng ký gói.';

  @override
  String get chatAiThinkingTimeout =>
      'Có vẻ anh ấy đang chìm trong suy nghĩ. Vui lòng thử lại sau một lát……';

  @override
  String get chatAiResponseBlocked =>
      'Có vẻ suy nghĩ của anh ấy đang bị xáo trộn đôi chút. Hãy thử diễn đạt lại nhẹ nhàng hơn.';

  @override
  String get chatRecordingStartFailed =>
      'Không thể bắt đầu ghi âm. Vui lòng thử lại sau.';

  @override
  String get chatRecordingPlaybackFailed =>
      'Không thể phát bản ghi âm. Vui lòng thử lại sau.';

  @override
  String get chatRoomNotReady =>
      'Phòng trò chuyện vẫn chưa sẵn sàng. Vui lòng thử lại sau.';

  @override
  String get chatRegenerateLimitReached =>
      'Bạn đã dùng hết số lần tạo lại hôm nay';

  @override
  String get chatTypingIndicator => 'Đối phương đang nhập……';

  @override
  String get chatRegenerateCountSyncFailed =>
      'Đã tạo lại thành công nhưng không thể đồng bộ số lượt. Vui lòng tải lại sau.';

  @override
  String get chatRoomNotFound =>
      'Không tìm thấy phòng trò chuyện của nhân vật này';

  @override
  String get momentsSearchTooltip => 'Tìm kiếm trên Tường Khoảnh Khắc';

  @override
  String get momentsCreatorNotFound =>
      'Không tìm thấy thông tin của nhà sáng tạo này';

  @override
  String get momentCommentLoadFailed =>
      'Không thể tải bình luận. Vui lòng thử lại sau';

  @override
  String get momentCollapseReplies => 'Thu gọn phản hồi';

  @override
  String momentViewOtherReplies(int count) {
    return 'Xem thêm $count phản hồi khác';
  }

  @override
  String get momentSwitchCommentIdentity => 'Chuyển danh tính bình luận';

  @override
  String get momentSendCommentTooltip => 'Gửi bình luận';

  @override
  String get momentShareCharactersLoadFailed =>
      'Không thể tải các nhân vật đã trò chuyện. Vui lòng thử lại sau';

  @override
  String get momentReportLoginRequired =>
      'Vui lòng đăng nhập trước khi báo cáo bài đăng';

  @override
  String get momentReportSubmitted =>
      'Báo cáo đã được gửi. Chúng tôi sẽ tiến hành xem xét';

  @override
  String get momentSelectShareCharacter =>
      'Chọn một nhân vật bạn đã từng trò chuyện để chia sẻ bài đăng này';

  @override
  String get momentTagCharacterUnavailable =>
      'Thẻ này không được liên kết với hồ sơ nhân vật';

  @override
  String get momentCharacterNotFound => 'Không tìm thấy dữ liệu nhân vật';

  @override
  String get appUpdateTitle => 'Đã có phiên bản mới';

  @override
  String get appUpdateMessage =>
      'Đã có phiên bản mới của LoveyDovey. Hãy cập nhật ngay để nhận các tính năng và bản sửa lỗi mới nhất.';

  @override
  String get appUpdateLater => 'Để sau';

  @override
  String get appUpdateGo => 'Cập nhật ngay';

  @override
  String get appUpdateCurrentVersion => 'Phiên bản hiện tại';

  @override
  String get appUpdateLatestVersion => 'Phiên bản mới nhất';

  @override
  String get appUpdateStoreOpenFailed =>
      'Hiện không thể mở cửa hàng. Vui lòng thử lại sau.';

  @override
  String get auth_error_requires_recent_login =>
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại trước khi đổi mật khẩu.';

  @override
  String get auth_error_too_many_requests =>
      'Bạn đã thử quá nhiều lần. Vui lòng thử lại sau.';

  @override
  String get auth_error_network_failed =>
      'Kết nối mạng hiện không ổn định. Vui lòng thử lại sau.';

  @override
  String get change_password_failed =>
      'Không thể đổi mật khẩu. Vui lòng thử lại sau.';

  @override
  String get change_password_account_not_found =>
      'Không tìm thấy tài khoản đang đăng nhập. Vui lòng đăng nhập lại rồi thử lại.';

  @override
  String get change_password_not_password_account =>
      'Tài khoản này không sử dụng phương thức đăng nhập bằng email và mật khẩu nên không thể đổi mật khẩu tại đây.';

  @override
  String get change_password_same_as_current =>
      'Mật khẩu mới không được trùng với mật khẩu hiện tại.';

  @override
  String get change_password_success_title => 'Đã cập nhật mật khẩu';

  @override
  String get change_password_success_message =>
      'Mật khẩu mới đã được thiết lập. Vui lòng sử dụng mật khẩu mới trong lần đăng nhập tiếp theo.';

  @override
  String get change_password_title => 'Đổi mật khẩu';

  @override
  String get change_password_security_title => 'Bảo mật tài khoản';

  @override
  String get change_password_description =>
      'Trước tiên, hãy nhập mật khẩu hiện tại để xác minh danh tính, sau đó thiết lập mật khẩu đăng nhập mới.';

  @override
  String get change_password_current_label => 'Mật khẩu hiện tại';

  @override
  String get change_password_current_required =>
      'Vui lòng nhập mật khẩu hiện tại';

  @override
  String get change_password_new_label => 'Mật khẩu mới';

  @override
  String get change_password_new_required => 'Vui lòng nhập mật khẩu mới';

  @override
  String get change_password_new_min_length =>
      'Mật khẩu mới phải có ít nhất 6 ký tự';

  @override
  String get change_password_confirm_label => 'Xác nhận mật khẩu mới';

  @override
  String get change_password_confirm_required =>
      'Vui lòng nhập lại mật khẩu mới';

  @override
  String get change_password_mismatch => 'Mật khẩu mới nhập hai lần không khớp';

  @override
  String get change_password_hint =>
      'Mật khẩu phải có ít nhất 6 ký tự. Sau khi thay đổi, hãy sử dụng mật khẩu mới khi đăng nhập lại trên các thiết bị khác.';

  @override
  String get character_npc_add => '＋ Thêm nhân vật phụ';

  @override
  String character_npc_added_count(int count) {
    return 'Nhân vật phụ đã thêm: $count';
  }

  @override
  String get character_npc_unnamed => 'Nhân vật phụ chưa đặt tên';

  @override
  String get character_npc_title => 'Thiết lập nhân vật phụ';

  @override
  String get character_npc_description =>
      'Tạo những nhân vật quan trọng sẽ xuất hiện trong câu chuyện để thế giới của nhân vật trở nên hoàn chỉnh hơn.';

  @override
  String get character_npc_empty_title => 'Chưa thêm nhân vật phụ';

  @override
  String get character_npc_empty_description =>
      'Sau khi thêm, bạn có thể xem, chỉnh sửa và quản lý thiết lập của các nhân vật phụ tại đây.';

  @override
  String character_npc_age(String age) {
    return '$age tuổi';
  }

  @override
  String character_npc_relationship_with_main(String relationship) {
    return 'Quan hệ với nhân vật chính: $relationship';
  }

  @override
  String get character_management_login_required => 'Vui lòng đăng nhập trước';

  @override
  String get character_management_character_tab => 'Nhân vật';

  @override
  String get character_management_creator_tab => 'Nhà sáng tạo';

  @override
  String get character_management_blocked_characters_empty =>
      'Những nhân vật bạn tạm dừng liên hệ sẽ xuất hiện tại đây.';

  @override
  String get character_management_blocked_creators_load_failed =>
      'Không thể tải danh sách nhà sáng tạo đã chặn';

  @override
  String get character_management_blocked_creators_empty =>
      'Những nhà sáng tạo bạn chặn sẽ xuất hiện tại đây.';

  @override
  String get character_management_creator_fallback => 'Nhà sáng tạo';

  @override
  String get character_management_blocked_creator_status =>
      'Đã chặn nhà sáng tạo';

  @override
  String get character_management_blocked_creator_description =>
      'Các nhân vật công khai và nhân vật được họ thêm sau này sẽ không xuất hiện trong mục đề xuất.';

  @override
  String get character_management_unblock_creator_title =>
      'Bỏ chặn nhà sáng tạo';

  @override
  String character_management_unblock_creator_confirm(String creatorName) {
    return 'Bạn có chắc muốn bỏ chặn “$creatorName” không?\n\nSau khi bỏ chặn, nhà sáng tạo này và các nhân vật của họ có thể xuất hiện lại trong nội dung đề xuất. Những nhân vật bạn đã chặn riêng trước đó vẫn sẽ bị chặn.';
  }

  @override
  String character_management_unblock_creator_success(String creatorName) {
    return 'Đã bỏ chặn “$creatorName”';
  }

  @override
  String get character_management_unblock_creator_failed =>
      'Không thể bỏ chặn, vui lòng thử lại sau';

  @override
  String get character_management_title => 'Quản lý nhân vật';

  @override
  String get character_management_subtitle =>
      'Quản lý những nhân vật bạn đã tạm dừng liên hệ';

  @override
  String get character_management_character_fallback => 'Nhân vật';

  @override
  String get character_management_blocked_character_status =>
      'Đang tạm dừng liên hệ';

  @override
  String get character_management_blocked_character_description =>
      'Tạm dừng trò chuyện và thông báo mà không xóa dữ liệu liên quan.';

  @override
  String character_management_unblock_character_confirm(String charName) {
    return 'Bạn có chắc muốn bỏ chặn “$charName” không? Sau khi bỏ chặn, nội dung liên quan có thể xuất hiện trở lại.';
  }

  @override
  String get creator_follow_following_title => 'Nhà sáng tạo tôi theo dõi';

  @override
  String get creator_follow_followers_title => 'Người chơi theo dõi tôi';

  @override
  String creator_follow_load_failed(String error) {
    return 'Không thể tải: $error';
  }

  @override
  String get creator_follow_empty_following_title =>
      'Bạn chưa theo dõi nhà sáng tạo nào';

  @override
  String get creator_follow_empty_followers_title =>
      'Hiện chưa có người theo dõi';

  @override
  String get creator_follow_empty_following_description =>
      'Hãy theo dõi những nhà sáng tạo bạn yêu thích từ hồ sơ nhân vật hoặc Xưởng sáng tạo.';

  @override
  String get creator_follow_empty_followers_description =>
      'Khi người chơi khác theo dõi bạn, họ sẽ xuất hiện tại đây.';

  @override
  String get creator_follow_unknown_player => 'Người chơi không xác định';

  @override
  String creator_follow_player_id(String playerId) {
    return 'ID: $playerId';
  }

  @override
  String get creator_follow_no_player_id => 'Chưa thiết lập ID người chơi';

  @override
  String get creator_follow_following => 'Đang theo dõi';

  @override
  String get creator_follow_unfollow_title => 'Bỏ theo dõi';

  @override
  String get creator_follow_unfollow_confirm =>
      'Bạn có chắc muốn bỏ theo dõi nhà sáng tạo này không?';

  @override
  String get creator_follow_unfollow => 'Bỏ theo dõi';

  @override
  String interaction_history_load_failed(String error) {
    return 'Không thể tải: $error';
  }

  @override
  String get creator_profile_report_creator => 'Báo cáo nhà sáng tạo';

  @override
  String get creator_profile_block_creator => 'Chặn nhà sáng tạo';

  @override
  String get creator_profile_report_login_required =>
      'Vui lòng đăng nhập trước khi báo cáo nhà sáng tạo';

  @override
  String get creator_profile_report_self_not_allowed =>
      'Bạn không thể báo cáo trang nhà sáng tạo của chính mình';

  @override
  String creator_profile_report_reason_prompt1(String creatorName) {
    return 'Vui lòng chọn lý do báo cáo “$creatorName”:';
  }

  @override
  String get creator_profile_report_reason_inappropriate =>
      'Nội dung không phù hợp hoặc vi phạm quy định';

  @override
  String get creator_profile_report_reason_harassment =>
      'Nội dung quấy rối, công kích hoặc thù ghét';

  @override
  String get creator_profile_report_reason_impersonation =>
      'Mạo danh người khác hoặc giả mạo danh tính';

  @override
  String get creator_profile_report_reason_spam =>
      'Nội dung rác hoặc quảng bá độc hại';

  @override
  String get creator_profile_report_success =>
      'Đã nhận được báo cáo. Cảm ơn bạn đã thông báo';

  @override
  String get creator_profile_report_failed =>
      'Không thể gửi báo cáo, vui lòng thử lại sau';

  @override
  String get creator_profile_block_login_required =>
      'Vui lòng đăng nhập trước khi chặn nhà sáng tạo';

  @override
  String get creator_profile_block_self_not_allowed =>
      'Bạn không thể tự chặn chính mình';

  @override
  String creator_profile_block_confirm(String creatorName) {
    return 'Bạn có chắc muốn chặn “$creatorName” không?\n\nSau khi chặn, bạn sẽ không còn thấy trang công khai của nhà sáng tạo này. Những nhân vật công khai hiện do họ tạo cũng sẽ được thêm vào danh sách chặn.';
  }

  @override
  String get creator_profile_block_confirm_button => 'Xác nhận chặn';

  @override
  String creator_profile_block_success(String creatorName) {
    return 'Đã chặn “$creatorName”';
  }

  @override
  String get creator_profile_block_failed =>
      'Không thể chặn, vui lòng thử lại sau';

  @override
  String get creator_scene_edit_title_edit => 'Chỉnh sửa phân cảnh';

  @override
  String get creator_scene_edit_title_add => 'Thêm phân cảnh';

  @override
  String get creator_scene_edit_heading_edit =>
      'Điều chỉnh phần mở đầu của câu chuyện này';

  @override
  String get creator_scene_edit_heading_add =>
      'Viết phần mở đầu cho một câu chuyện mới';

  @override
  String get creator_scene_edit_scene_title_label => 'Tiêu đề phân cảnh';

  @override
  String get creator_scene_edit_scene_title_hint =>
      'Ví dụ: Gặp lại trong đêm mưa';

  @override
  String get creator_scene_edit_description_label => 'Mô tả bối cảnh';

  @override
  String get creator_scene_edit_description_hint =>
      'Mô tả thời gian, địa điểm, mối quan hệ và tình huống diễn ra câu chuyện.';

  @override
  String get creator_scene_edit_opening_label => 'Mở đầu của nhân vật';

  @override
  String get creator_scene_edit_opening_hint =>
      'Viết phản ứng hoặc câu thoại đầu tiên của nhân vật khi bước vào câu chuyện này.';

  @override
  String get creator_scene_edit_opening_note =>
      'Phần mở đầu của nhân vật sẽ là cảnh đầu tiên của câu chuyện này. Những cuộc trò chuyện sau đó vẫn tiếp tục dựa trên thiết lập tính cách ban đầu của nhân vật.';

  @override
  String get creator_scene_edit_save_changes => 'Lưu thay đổi';

  @override
  String get creator_scene_edit_save_scene => 'Lưu phân cảnh';

  @override
  String get creator_scene_edit_error_title_required =>
      'Vui lòng nhập tiêu đề phân cảnh trước.';

  @override
  String get creator_scene_edit_error_description_required =>
      'Vui lòng nhập mô tả bối cảnh trước.';

  @override
  String get creator_scene_edit_error_opening_required =>
      'Vui lòng nhập phần mở đầu của nhân vật trước.';

  @override
  String get creator_scene_edit_save_failed =>
      'Không thể lưu, vui lòng thử lại sau.';

  @override
  String get creator_scene_delete_title => 'Xóa phân cảnh?';

  @override
  String get creator_scene_delete_target_fallback => 'phân cảnh này';

  @override
  String creator_scene_delete_confirm(String sceneTitle) {
    return 'Bạn có chắc muốn xóa “$sceneTitle” không? Sau khi xóa sẽ không thể khôi phục.';
  }

  @override
  String get creator_scene_delete_failed =>
      'Không thể xóa, vui lòng thử lại sau.';

  @override
  String get creator_scene_empty_title => 'Chưa có phân cảnh của nhà sáng tạo';

  @override
  String creator_scene_empty_description(String characterName) {
    return 'Viết những dòng thời gian khác nhau cho $characterName,\nđể người chơi có thể bắt đầu từ một câu chuyện khác.';
  }

  @override
  String get creator_scene_add => 'Thêm phân cảnh';

  @override
  String get creator_scene_unnamed => 'Phân cảnh chưa đặt tên';

  @override
  String creator_scene_opening(String opening) {
    return 'Mở đầu của nhân vật: $opening';
  }

  @override
  String get creator_scene_edit => 'Chỉnh sửa';

  @override
  String get creator_scene_delete => 'Xóa';

  @override
  String get creator_scene_title => 'Phân cảnh của nhà sáng tạo';

  @override
  String get creator_scene_character_unavailable =>
      'Hiện không thể tải thông tin nhân vật.';

  @override
  String get creator_scene_load_failed =>
      'Không thể tải phân cảnh, vui lòng thử lại sau.';

  @override
  String get creator_scene_heading =>
      'Tạo những phần mở đầu khác nhau cho nhân vật';

  @override
  String get custom_scene_edit_heading_edit =>
      'Điều chỉnh câu chuyện chỉ thuộc về riêng bạn';

  @override
  String get custom_scene_edit_heading_add =>
      'Viết một câu chuyện dành riêng cho phòng trò chuyện này';

  @override
  String get custom_scene_edit_description_hint =>
      'Mô tả thời gian, địa điểm, mối quan hệ và tình huống mà bạn muốn dùng để bắt đầu câu chuyện.';

  @override
  String get custom_scene_edit_note =>
      'Phân cảnh do bạn tự tạo sẽ không có phần mở đầu nhân vật được thiết lập sẵn. Sau khi bắt đầu, nhân vật sẽ bước vào câu chuyện dựa trên mô tả bối cảnh và thiết lập tính cách ban đầu.';

  @override
  String get moment_create_no_mentionable_characters =>
      'Hiện không có nhân vật nào có thể được nhắc đến.';

  @override
  String get moment_create_mention_my_characters => 'Nhắc đến nhân vật của tôi';

  @override
  String get moment_create_no_matching_characters =>
      'Không tìm thấy nhân vật phù hợp';

  @override
  String get moment_create_my_character => 'Nhân vật của tôi';

  @override
  String get moment_create_friend_character => 'Nhân vật của bạn bè';

  @override
  String get moment_create_public_visibility_hint =>
      'Bài đăng sẽ xuất hiện trên Tường khoảnh khắc';

  @override
  String get moment_create_private_visibility_hint =>
      'Chỉ hiển thị trong phạm vi riêng được chỉ định';

  @override
  String get moment_create_add_image => 'Thêm hình ảnh';

  @override
  String get moment_create_mention_character => 'Nhắc đến nhân vật';

  @override
  String get moment_edit_content_hint => 'Chia sẻ cảm xúc của bạn...';

  @override
  String get moment_forward_chat_preview => '【Đã chia sẻ một bài viết】';

  @override
  String get feedback_image_too_large =>
      'Kích thước hình ảnh không được vượt quá 10 MB';

  @override
  String get feedback_image_pick_failed =>
      'Không thể chọn hình ảnh, vui lòng thử lại sau';

  @override
  String get feedback_category_general => 'Vấn đề chung';

  @override
  String get feedback_category_bug => 'Báo cáo lỗi';

  @override
  String get feedback_category_suggestion => 'Đề xuất tính năng';

  @override
  String get feedback_category_flower => 'Vấn đề điểm Hoa';

  @override
  String get feedback_category_payment => 'Vấn đề nạp tiền / thanh toán';

  @override
  String get feedback_category_ai_reply => 'Phản hồi AI bất thường';

  @override
  String get feedback_category_character_report => 'Báo cáo nhân vật';

  @override
  String get feedback_category_moment_report => 'Báo cáo bài viết';

  @override
  String get feedback_screenshot_required_error =>
      'Vui lòng đính kèm ảnh chụp màn hình cho loại vấn đề này để chúng tôi có thể kiểm tra';

  @override
  String get feedback_login_required =>
      'Vui lòng đăng nhập trước khi gửi báo cáo';

  @override
  String get feedback_mail_received_title =>
      '【Đã tạo yêu cầu】Chúng tôi đã nhận được báo cáo của bạn';

  @override
  String feedback_mail_received_body(String caseNumber) {
    return 'Chúng tôi đã nhận được báo cáo của bạn và sẽ kiểm tra trong thời gian sớm nhất.\n\nMã yêu cầu: $caseNumber\n\nNếu bộ phận hỗ trợ có phản hồi thêm, bạn sẽ nhận được thông báo qua hộp thư LoveyDovey.';
  }

  @override
  String get feedback_submit_success =>
      'Báo cáo đã được gửi thành công. Cảm ơn ý kiến của bạn!';

  @override
  String get feedback_submit_failed =>
      'Không thể gửi, vui lòng kiểm tra kết nối mạng rồi thử lại';

  @override
  String get feedback_category_section_title => 'Loại vấn đề';

  @override
  String get feedback_reported_content_title => 'Nội dung bị báo cáo';

  @override
  String get feedback_screenshot_required_title => 'Ảnh chụp vấn đề (bắt buộc)';

  @override
  String get feedback_image_optional_title =>
      'Hình ảnh bổ sung (không bắt buộc)';

  @override
  String get feedback_screenshot_required_description =>
      'Vui lòng đính kèm ảnh chụp màn hình khi vấn đề xảy ra để đội ngũ có thể kiểm tra tình trạng thực tế.';

  @override
  String get feedback_image_optional_description =>
      'Nếu có hình ảnh liên quan, bạn cũng có thể đính kèm để hỗ trợ đội ngũ kiểm tra.';

  @override
  String get feedback_footer_message =>
      'Ý kiến của bạn sẽ giúp chúng tôi tiếp tục cải thiện trải nghiệm trò chơi. Xin cảm ơn!';

  @override
  String get feedback_select_image_semantics => 'Chọn hình ảnh báo cáo';

  @override
  String get feedback_opening_gallery => 'Đang mở thư viện ảnh…';

  @override
  String get feedback_select_image_upload =>
      'Nhấn vào đây để chọn hình ảnh tải lên';

  @override
  String get feedback_image_requirements =>
      'Hỗ trợ JPG và PNG, tối đa 10 MB mỗi hình';

  @override
  String get feedback_submitting_semantics => 'Đang gửi';

  @override
  String get feedback_submit_semantics => 'Gửi báo cáo';

  @override
  String get feedback_submit_button => 'Gửi';

  @override
  String get feedback_remove_image => 'Xóa hình ảnh';

  @override
  String get feedback_selected_image => 'Đã chọn hình ảnh';

  @override
  String get feedback_change_image => 'Thay đổi';

  @override
  String get profile_backpack_title => 'Ba lô và đặc quyền riêng của tôi';

  @override
  String get profile_backpack_total_spent => 'Tổng liên kết lãng mạn hiện tại';

  @override
  String profile_backpack_total_spent_amount(int amount) {
    return 'NT\$ $amount';
  }

  @override
  String get profile_backpack_physical_gift_status =>
      'Trạng thái mở khóa hộp quà hiện vật:';

  @override
  String get profile_backpack_vip_gift_title =>
      '【Tình yêu tối thượng】Hộp quà VIP hiện vật độc quyền';

  @override
  String get profile_backpack_vip_gift_contents =>
      'Bao gồm: thư viết tay độc quyền + búp bê đại diện nhân vật + thư cảm ơn chính thức';

  @override
  String get profile_backpack_edit_shipping_info =>
      'Chỉnh sửa thông tin nhận hàng';

  @override
  String get profile_backpack_unlock_shipping_info =>
      'Đã mở khóa! Nhấn vào đây để nhập thông tin nhận hàng';

  @override
  String get profile_backpack_shipping_registered =>
      'Bạn đã đăng ký địa chỉ nhận hàng thành công. Chúng tôi sẽ chuẩn bị quà trong thời gian sớm nhất!';

  @override
  String profile_backpack_amount_remaining(int amount) {
    return 'Chỉ còn NT\$ $amount nữa để mở khóa phần thưởng hiện vật lớn!';
  }

  @override
  String get profile_backpack_hint =>
      'Mẹo nhỏ: Bạn có thể xem các giao diện và khung ảnh đại diện khác trong ba lô.';

  @override
  String get profile_backpack_close => 'Đóng';

  @override
  String get profile_physical_gift_title =>
      '【Tình yêu tối thượng】Mở khóa hộp quà hiện vật';

  @override
  String get profile_physical_gift_description =>
      'Cảm ơn bạn vì đã luôn hết lòng ủng hộ 《LoveyDovey》!\nVui lòng điền thông tin nhận hàng bên dưới. Chúng tôi sẽ gửi đến bạn thư viết tay độc quyền và búp bê đại diện nhân vật:';

  @override
  String get profile_physical_gift_recipient_name =>
      'Họ tên thật của người nhận';

  @override
  String get profile_physical_gift_phone => 'Số điện thoại liên hệ';

  @override
  String get profile_physical_gift_address =>
      'Địa chỉ nhận hàng đầy đủ (bao gồm mã bưu chính)';

  @override
  String get profile_physical_gift_character_name =>
      'Tên nhân vật bạn muốn nhận búp bê đại diện';

  @override
  String get profile_physical_gift_character_hint =>
      'Ví dụ: Nhập tên nhân vật mong muốn';

  @override
  String get profile_physical_gift_fill_later => 'Điền sau';

  @override
  String get profile_physical_gift_required_error =>
      'Vui lòng điền đầy đủ thông tin nhận hàng và tên nhân vật bạn yêu thích!';

  @override
  String get profile_physical_gift_submit_success =>
      'Thông tin nhận hàng đã được gửi thành công! Hãy chờ đón món quà bất ngờ từ chúng tôi!';

  @override
  String get profile_physical_gift_confirm_submit => 'Xác nhận gửi';

  @override
  String get profile_tooltip_announcement => 'Thông báo';

  @override
  String get profile_tooltip_settings => 'Cài đặt';

  @override
  String get profile_tooltip_backpack => 'Ba lô của tôi';

  @override
  String get profile_backpack_menu_title => 'Ba lô của tôi';

  @override
  String get profile_about_me_title => 'Về tôi';

  @override
  String get profile_tab_bio_title => 'Giới thiệu bản thân';

  @override
  String get profile_check_in_done => 'Đã điểm danh';

  @override
  String get profile_check_in => 'Điểm danh';

  @override
  String get profile_check_in_done_subtitle => 'Hôm nay bạn đã để lại dấu chân';

  @override
  String get profile_check_in_not_done_subtitle => 'Hôm nay bạn chưa điểm danh';

  @override
  String get profile_likes_label => 'Lượt thích';

  @override
  String get profile_heartbeat_diary_subtitle =>
      'Ghi lại những khoảnh khắc rung động';

  @override
  String get profile_create_scene => 'Tạo phân cảnh';

  @override
  String get profile_link_invalid => 'Định dạng liên kết không hợp lệ';

  @override
  String get profile_link_open_failed => 'Không thể mở liên kết này';

  @override
  String get profile_link_default_name => 'Liên kết của tôi';

  @override
  String get profile_publish_moment_short => 'Viết về khoảnh khắc này';

  @override
  String edit_profile_default_link_name(int index) {
    return 'Liên kết của tôi $index';
  }

  @override
  String get edit_profile_done => 'Hoàn tất';

  @override
  String get edit_profile_social_links => 'Mạng xã hội và liên kết';

  @override
  String get edit_profile_add_link => 'Thêm liên kết';

  @override
  String get edit_profile_link_name_hint => 'Tên liên kết';

  @override
  String get edit_profile_link_url_hint => 'Nhập liên kết';

  @override
  String get theme_name_starlight => 'Tím ánh sao';

  @override
  String get theme_name_sakura => 'Hồng anh đào';

  @override
  String get theme_name_ocean => 'Xanh đại dương';

  @override
  String get theme_name_sunset => 'Cam hoàng hôn';

  @override
  String get theme_name_mint => 'Bạc hà rừng xanh';

  @override
  String get theme_name_midnight => 'Chế độ đêm';

  @override
  String get theme_name_custom => 'Màu tùy chỉnh';

  @override
  String get theme_selection_choose_theme => 'Chọn màu chủ đề';

  @override
  String get theme_selection_title => 'Thay đổi không khí';

  @override
  String get theme_selection_description =>
      'Chọn màu chủ đề bạn yêu thích để LoveyDovey mang đậm phong cách của riêng bạn.';

  @override
  String get theme_selection_preview => 'Xem trước';

  @override
  String get theme_selection_characters => 'Nhân vật';

  @override
  String get theme_selection_posts => 'Bài viết';

  @override
  String theme_selection_previewing(String themeName) {
    return 'Đang xem trước: $themeName';
  }

  @override
  String get theme_selection_apply => 'Áp dụng chủ đề';

  @override
  String get theme_selection_restore_default => 'Khôi phục mặc định';

  @override
  String get theme_selection_choose_color => 'Chọn màu sắc riêng của bạn';

  @override
  String theme_selection_applied(String themeName) {
    return 'Đã áp dụng “$themeName”';
  }

  @override
  String get welcome_guide_help => 'Hướng dẫn chơi';

  @override
  String get welcome_guide_start => 'Bắt đầu hành trình';

  @override
  String get welcome_guide_next => 'Tiếp theo';

  @override
  String get welcome_guide_welcome_title => 'Chào mừng đến với 《LoveyDovey》';

  @override
  String get welcome_guide_welcome_description =>
      'Tại đây, mỗi cuộc gặp gỡ đều có thể trở thành một câu chuyện khó quên. Mong rằng 《LoveyDovey》sẽ luôn đồng hành cùng bạn để tạo nên những kỷ niệm đẹp chỉ thuộc về hai người.';

  @override
  String get welcome_guide_chat_title => 'Chế độ trò chuyện';

  @override
  String get welcome_guide_chat_description =>
      '《LoveyDovey》cung cấp nhiều chế độ trò chuyện, mỗi chế độ mang đến một trải nghiệm tương tác khác nhau.';

  @override
  String get welcome_guide_daily_title => 'Chế độ thường ngày';

  @override
  String get welcome_guide_daily_description =>
      'Ở bên nhau, chia sẻ cuộc sống và tận hưởng những cuộc trò chuyện nhẹ nhàng, thoải mái.';

  @override
  String get welcome_guide_story_title => 'Chế độ cốt truyện';

  @override
  String get welcome_guide_story_description =>
      'Phát triển câu chuyện của nhân vật và mở khóa thêm nhiều tình tiết cùng tương tác độc quyền.';

  @override
  String get welcome_guide_immersive_title => 'Chế độ nhập vai';

  @override
  String get welcome_guide_immersive_description =>
      'Trải nghiệm những cuộc trò chuyện cuốn hút và chân thực hơn.';

  @override
  String get welcome_guide_chat_more =>
      'Bạn có thể xem thêm thông tin về các chế độ trò chuyện trong mục “Hướng dẫn trò chơi”.';

  @override
  String get welcome_guide_encounter_title => 'Gặp gỡ';

  @override
  String get welcome_guide_encounter_description =>
      'Mỗi nhân vật đều có tính cách, câu chuyện và giọng nói riêng. Khi gặp được nhân vật mình yêu thích, bạn có thể thêm họ làm bạn, trò chuyện, tương tác, chia sẻ cuộc sống và cùng nhau tạo nên những kỷ niệm riêng.';

  @override
  String get welcome_guide_more_title => 'Nhiều nội dung hơn';

  @override
  String get welcome_guide_more_description =>
      'Ngoài ra còn có bộ sưu tập, nhà sáng tạo, cửa hàng cùng nhiều tính năng phong phú khác. Hãy đến mục “Hướng dẫn trò chơi” để tìm hiểu thêm.';

  @override
  String preference_selection_max_error(int count) {
    return 'Bạn chỉ có thể chọn tối đa $count sở thích.';
  }

  @override
  String get preference_selection_save_failed =>
      'Hiện không thể lưu sở thích của bạn, vui lòng thử lại sau.';

  @override
  String get preference_selection_title =>
      'Bạn muốn gặp một người như thế nào?';

  @override
  String get preference_selection_description =>
      'Chọn 3–5 kiểu người bạn yêu thích để LoveyDovey bắt đầu hiểu bạn hơn.';

  @override
  String get preference_selection_recommendation_note =>
      'Sau này, đề xuất sẽ dần được điều chỉnh dựa trên tương tác thực tế để phù hợp với bạn hơn.';

  @override
  String get preference_selection_selected => 'Đã chọn';

  @override
  String get preference_selection_start => 'Bắt đầu từ đây';

  @override
  String get preference_group_personality => 'Tính cách・Khí chất';

  @override
  String get preference_group_relationship_age => 'Mối quan hệ・Độ tuổi';

  @override
  String get preference_group_story => 'Không khí câu chuyện';

  @override
  String get preference_tag_gentle => 'Dịu dàng';

  @override
  String get preference_tag_cold => 'Lạnh lùng';

  @override
  String get preference_tag_scheming => 'Thâm sâu';

  @override
  String get preference_tag_tsundere => 'Tsundere';

  @override
  String get preference_tag_loyal => 'Trung thành';

  @override
  String get preference_tag_yandere => 'Yandere';

  @override
  String get preference_tag_mysterious => 'Bí ẩn';

  @override
  String get preference_tag_healing => 'Chữa lành';

  @override
  String get preference_tag_gap_moe => 'Tương phản cuốn hút';

  @override
  String get preference_tag_older => 'Lớn tuổi hơn';

  @override
  String get preference_tag_younger => 'Nhỏ tuổi hơn';

  @override
  String get preference_tag_ceo => 'Tổng tài bá đạo';

  @override
  String get preference_tag_school => 'Học đường';

  @override
  String get preference_tag_workplace => 'Công sở';

  @override
  String get preference_tag_ancient => 'Cổ trang';

  @override
  String get preference_tag_nonhuman => 'Phi nhân loại';

  @override
  String get encounter_load_failed =>
      'Không thể tải dữ liệu gặp gỡ, vui lòng thử lại sau.';

  @override
  String get encounter_no_available_characters =>
      'Hiện chưa có nhân vật nào để gặp gỡ';

  @override
  String get encounter_category_empty =>
      'Hiện chưa có nhân vật trong danh mục này';

  @override
  String get encounter_category_all => 'Tất cả';

  @override
  String get encounter_category_xianxia => 'Tiên hiệp';

  @override
  String get encounter_category_childhood_friend => 'Thanh mai trúc mã';

  @override
  String get encounter_category_master_disciple => 'Sư đồ';

  @override
  String get encounter_category_sweet_romance => 'Ngọt sủng';

  @override
  String get encounter_category_other => 'Khác';

  @override
  String get character_edit_tab_character_settings => 'Thiết lập nhân vật';

  @override
  String get character_edit_test => 'Kiểm tra';

  @override
  String get character_edit_supporting_basic_info => 'Thông tin cơ bản';

  @override
  String get character_edit_supporting_main_setting =>
      'Mối quan hệ với nhân vật chính';

  @override
  String get character_edit_supporting_main_description =>
      'Mô tả mối quan hệ giữa nhân vật phụ này với nhân vật chính và vai trò của họ trong câu chuyện.';

  @override
  String get character_edit_banner_preview_hint =>
      'Nhấn vào hình ảnh để xem kích thước lớn';

  @override
  String get character_edit_main_photo_hint =>
      'Hình ảnh đầu tiên sẽ được dùng làm ảnh đại diện chính';

  @override
  String get character_edit_other_photos => 'Hình ảnh khác của nhân vật';

  @override
  String get character_edit_photo_action_hint =>
      'Nhấn vào hình ảnh để xem trước; nhấn biểu tượng bút chì để chỉnh sửa thiết lập hình ảnh';

  @override
  String character_edit_over_limit_warning(String label, String count) {
    return '$label đã vượt quá giới hạn $count ký tự. Vui lòng chỉnh sửa trước khi đăng.';
  }

  @override
  String get memo_notification_channel_name => 'Nhắc nhở ghi chú';

  @override
  String get memo_notification_channel_description =>
      'Nhân vật nhắc người chơi về những ghi chú đã thiết lập';

  @override
  String memo_notification_title(String characterName) {
    return '$characterName nhắc bạn';
  }

  @override
  String memo_notification_tsundere(String memoContent) {
    return 'Tôi đâu có lo cho bạn, chỉ sợ bạn quên thôi. Hôm nay đừng quên: $memoContent';
  }

  @override
  String memo_notification_dominant(String memoContent) {
    return 'Lịch trình đã được tôi ghi nhớ giúp bạn rồi. Hãy hoàn thành đúng giờ. Hôm nay đừng quên: $memoContent';
  }

  @override
  String memo_notification_yandere(String memoContent) {
    return 'Không được quên đâu nhé, vì tôi sẽ luôn ghi nhớ. Hôm nay đừng quên: $memoContent';
  }

  @override
  String memo_notification_gentle(String memoContent) {
    return 'Sợ bạn bận quá rồi quên mất nên tôi muốn nhắc bạn một chút. Hôm nay đừng quên: $memoContent';
  }

  @override
  String memo_notification_cold(String memoContent) {
    return 'Có một việc cần nhắc bạn. Hôm nay đừng quên: $memoContent';
  }

  @override
  String memo_notification_sunny(String memoContent) {
    return 'Này, hôm nay vẫn còn một việc quan trọng đấy! Đừng quên: $memoContent';
  }

  @override
  String memo_notification_lazy(String memoContent) {
    return 'Dù rất muốn nằm tiếp nhưng tôi vẫn phải nhắc bạn. Hôm nay đừng quên: $memoContent';
  }

  @override
  String memo_notification_older(String memoContent) {
    return 'Ngoan nào, đừng quên việc hôm nay nhé. Hãy nhớ: $memoContent';
  }

  @override
  String memo_notification_younger(String memoContent) {
    return 'Tôi đã ngoan ngoãn nhớ giúp bạn rồi đấy! Hôm nay đừng quên: $memoContent';
  }

  @override
  String memo_notification_mechanical(String memoContent) {
    return 'Đã kích hoạt lời nhắc. Nhiệm vụ hôm nay: $memoContent';
  }

  @override
  String memo_notification_default(String memoContent) {
    return 'Hôm nay đừng quên: $memoContent';
  }

  @override
  String get recommendation_load_failed =>
      'Hiện không thể tải đề xuất, vui lòng thử lại sau.';

  @override
  String get recommendation_reload => 'Tải lại';

  @override
  String get recommendation_empty => 'Hiện chưa có nhân vật nào để đề xuất.';

  @override
  String get recommendation_title => 'Những cuộc gặp gỡ dành riêng cho bạn';

  @override
  String get recommendation_featured_title => 'Hãy gặp những người này trước';

  @override
  String get recommendation_featured_subtitle =>
      'Những cuộc gặp gỡ phù hợp nhất với bạn sẽ được ưu tiên hiển thị.';

  @override
  String get recommendation_matched_behavior_title =>
      'Ngày càng gần với sở thích của bạn';

  @override
  String get recommendation_matched_initial_title =>
      'Dựa trên sở thích ban đầu của bạn';

  @override
  String get recommendation_matched_behavior_subtitle =>
      'Bắt đầu sau ngày thứ 4, những tương tác gần đây cũng sẽ ảnh hưởng đến thứ tự đề xuất.';

  @override
  String get recommendation_matched_initial_subtitle =>
      'Hiện tại, chúng tôi sẽ dùng các thẻ bạn chọn lúc đầu để thu hẹp phạm vi.';

  @override
  String get recommendation_explore_title => 'Có thể bạn cũng sẽ thích';

  @override
  String get recommendation_explore_subtitle =>
      'Chúng tôi sẽ giữ lại một số lựa chọn ngẫu nhiên để đôi khi bạn có thể gặp được một người thật khác biệt.';

  @override
  String get recommendation_refreshing =>
      'Đang chuẩn bị những cuộc gặp gỡ mới cho bạn……';

  @override
  String get recommendation_badge_for_you => 'Đề xuất cho bạn';

  @override
  String get recommendation_badge_featured => 'Gặp gỡ nổi bật';

  @override
  String get recommendation_badge_explore => 'Khám phá';

  @override
  String get recommendation_default_occupation_hint =>
      'Hãy mở ra xem thử, biết đâu đây chính là người tiếp theo khiến bạn rung động.';

  @override
  String get recommendation_explore_fallback =>
      'Thử một hướng khác xem sao, biết đâu lại chạm đúng điểm rung động của bạn.';

  @override
  String get recommendation_behavior_hint_similar_type =>
      'Gần đây bạn thường dành nhiều thời gian cho kiểu nhân vật này';

  @override
  String get recommendation_behavior_hint_forming =>
      'Sở thích tương tác gần đây của bạn đang dần hình thành';

  @override
  String get recommendation_behavior_hint_recent =>
      'Được chọn dựa trên những tương tác gần đây của bạn';

  @override
  String recommendation_reason_liked_tags(String tags) {
    return 'Vì bạn thích・$tags';
  }

  @override
  String get recommendation_reason_popular =>
      'Gần đây có khá nhiều người ghé xem nhân vật này';

  @override
  String get recommendation_reason_default =>
      'Có thể đây sẽ là cuộc gặp gỡ tiếp theo vừa vặn với bạn';

  @override
  String get scene_delete_title => 'Xóa phân cảnh?';

  @override
  String scene_delete_content(String title) {
    return 'Bạn có chắc muốn xóa “$title” không? Sau khi xóa sẽ không thể khôi phục.';
  }

  @override
  String get scene_unnamed => 'Phân cảnh chưa đặt tên';

  @override
  String get scene_cancel => 'Hủy';

  @override
  String get scene_delete => 'Xóa';

  @override
  String get scene_delete_failed => 'Không thể xóa, vui lòng thử lại sau.';

  @override
  String get scene_start_failed =>
      'Hiện không thể bắt đầu phân cảnh, vui lòng thử lại sau.';

  @override
  String get scene_end_title => 'Kết thúc phân cảnh?';

  @override
  String get scene_end_content =>
      'Sau khi kết thúc, bạn sẽ trở lại trò chuyện thông thường nhưng lịch sử cuộc trò chuyện hiện tại sẽ không bị xóa.';

  @override
  String get scene_end_action => 'Kết thúc phân cảnh';

  @override
  String get scene_ended => 'Phân cảnh đã kết thúc';

  @override
  String get scene_end_failed =>
      'Hiện không thể kết thúc phân cảnh, vui lòng thử lại sau.';

  @override
  String get scene_active_label => 'Đang diễn ra';

  @override
  String scene_opening(String opening) {
    return 'Mở đầu của nhân vật: $opening';
  }

  @override
  String get scene_edit => 'Chỉnh sửa';

  @override
  String get scene_start => 'Bắt đầu phân cảnh';

  @override
  String get scene_creator_load_failed =>
      'Không thể tải phân cảnh của nhà sáng tạo.';

  @override
  String get scene_creator_empty_title =>
      'Hiện chưa có phân cảnh của nhà sáng tạo';

  @override
  String get scene_creator_empty_body =>
      'Nhà sáng tạo của nhân vật này chưa tạo thêm câu chuyện nào.';

  @override
  String get scene_custom_load_failed => 'Không thể tải phân cảnh tự tạo.';

  @override
  String get scene_custom_empty_title => 'Bạn chưa có phân cảnh riêng';

  @override
  String get scene_custom_empty_body =>
      'Tạo một câu chuyện chỉ thuộc về bạn dành riêng cho phòng trò chuyện này.';

  @override
  String get scene_add => 'Thêm phân cảnh';

  @override
  String get scene_title => 'Phân cảnh';

  @override
  String get scene_tab_creator => 'Phân cảnh của nhà sáng tạo';

  @override
  String get scene_tab_custom => 'Tự tạo';

  @override
  String get chat_book_player => 'Người chơi';

  @override
  String get chat_book_title => 'Lịch sử trò chuyện';

  @override
  String get chat_book_export_pdf => 'Xuất PDF';

  @override
  String get chat_book_brand => '— LoveyDovey';

  @override
  String get chat_book_change_cover => 'Đổi bìa';

  @override
  String get chat_book_cover_subtitle =>
      'Khoảnh khắc bên nhau · Sách kỷ niệm trò chuyện';

  @override
  String get chat_book_choose_cover => 'Chọn bìa sách kỷ niệm';

  @override
  String get chat_book_initial_story => 'Câu chuyện ban đầu';

  @override
  String chat_book_transcript_title(String characterName) {
    return '$characterName · Lịch sử trò chuyện';
  }

  @override
  String chat_book_continuation(String name) {
    return '$name · Tiếp';
  }

  @override
  String get chat_book_previous_page => 'Trang trước';

  @override
  String get chat_book_next_page => 'Trang tiếp theo';

  @override
  String get chat_book_photo_message => '〔Hình ảnh〕';

  @override
  String get chat_book_audio_message => '〔Tin nhắn thoại〕';

  @override
  String get chat_book_generic_message => '〔Tin nhắn〕';

  @override
  String chat_book_export_failed(String error) {
    return 'Không thể xuất PDF: $error';
  }

  @override
  String email_policy_open_failed(String title) {
    return 'Không thể mở $title, vui lòng kiểm tra kết nối mạng rồi thử lại.';
  }

  @override
  String email_policy_read_instruction(String title) {
    return 'Trước tiên, vui lòng mở và đọc toàn bộ $title. Sau khi đọc xong, hãy quay lại 《LoveyDovey》để nhấn “Tôi đã đọc và đồng ý”.';
  }

  @override
  String get email_policy_opening => 'Đang mở……';

  @override
  String email_policy_read_full(String title) {
    return 'Đọc toàn bộ $title';
  }

  @override
  String email_policy_opened_ready(String title) {
    return 'Đã mở $title. Bạn có thể xác nhận đồng ý.';
  }

  @override
  String email_policy_not_opened(String title) {
    return 'Bạn chưa mở $title.';
  }

  @override
  String get email_policy_cancel_login => 'Hủy đăng nhập';

  @override
  String get email_policy_agree => 'Tôi đã đọc và đồng ý';

  @override
  String get email_policy_status_check_failed =>
      'Hiện không thể xác nhận trạng thái đồng ý với điều khoản, vui lòng thử lại sau.';

  @override
  String get email_policy_login_notice =>
      'Khi đăng nhập lần đầu hoặc khi điều khoản được cập nhật, hệ thống sẽ yêu cầu bạn đọc và đồng ý với Điều khoản dịch vụ cùng Chính sách quyền riêng tư.';

  @override
  String get email_policy_refresh => 'Làm mới';

  @override
  String get email_policy_page_load_failed => 'Không thể tải trang';

  @override
  String get email_policy_check_network =>
      'Vui lòng kiểm tra kết nối mạng rồi thử lại.';

  @override
  String get email_policy_reload => 'Tải lại';

  @override
  String get login_method_info_google_title => 'Đăng nhập nhanh bằng Google';

  @override
  String get login_method_info_apple_title => 'Đăng nhập bằng Apple';

  @override
  String get login_method_info_facebook_title => 'Đăng nhập bằng Facebook';

  @override
  String get login_method_info_email_title => 'Tài khoản LoveyDovey (Email)';

  @override
  String get login_method_info_email_provider => 'Tài khoản LoveyDovey (Email)';

  @override
  String login_method_info_content(String providerName) {
    return 'Đăng nhập vào 《LoveyDovey》bằng $providerName.\n\nXin lưu ý:\n\n• $providerName và các phương thức đăng nhập khác sử dụng những hệ thống tài khoản riêng biệt.\n\n• Nếu tạo tài khoản bằng $providerName, vui lòng tiếp tục sử dụng cùng phương thức đó để đăng nhập.\n\n• Dữ liệu nhân vật, lịch sử trò chuyện và nội dung đã mua sẽ không được chia sẻ với các phương thức đăng nhập khác.\n\nBạn nên tiếp tục sử dụng cùng một phương thức sau lần đăng nhập đầu tiên để tránh tạo nhiều tài khoản riêng biệt khiến dữ liệu không thể dùng chung.';
  }

  @override
  String get login_method_info_got_it => 'Đã hiểu';

  @override
  String creator_studio_delete_failed(String error) {
    return 'Không thể xóa: $error';
  }

  @override
  String get creator_studio_subtitle =>
      'Lưu giữ cảm hứng, sắp xếp nhân vật và từ từ hoàn thiện tác phẩm của bạn';

  @override
  String creator_studio_load_failed(String error) {
    return 'Không thể tải xưởng sáng tạo: $error';
  }

  @override
  String get creator_studio_add_character => 'Thêm nhân vật';

  @override
  String get creator_studio_public_title => 'Nhân vật công khai';

  @override
  String get creator_studio_public_subtitle =>
      'Đã được đăng và người chơi khác có thể khám phá';

  @override
  String get creator_studio_public_empty => 'Hiện chưa có nhân vật công khai';

  @override
  String get creator_studio_private_title => 'Nhân vật riêng tư';

  @override
  String get creator_studio_private_subtitle => 'Chỉ mình bạn có thể nhìn thấy';

  @override
  String get creator_studio_private_empty => 'Hiện chưa có nhân vật riêng tư';

  @override
  String get creator_studio_draft_title => 'Bản nháp';

  @override
  String get creator_studio_draft_subtitle => 'Những tác phẩm chưa hoàn thiện';

  @override
  String get creator_studio_draft_empty =>
      'Hiện không có bản nháp nào chưa hoàn thiện';

  @override
  String get creator_studio_draft_empty_title => 'Chưa có bản nháp nào ở đây';

  @override
  String get creator_studio_draft_empty_hint =>
      'Khi có cảm hứng, hãy ghi lại ở đây trước';

  @override
  String get creator_studio_status_public => 'Công khai';

  @override
  String get creator_studio_status_private => 'Riêng tư';

  @override
  String get creator_studio_status_draft => 'Bản nháp';

  @override
  String get creator_studio_character_load_failed =>
      'Không thể tải dữ liệu nhân vật';

  @override
  String get creator_studio_delete_draft_tooltip => 'Xóa bản nháp';

  @override
  String get creator_studio_unnamed_creator => 'Nhà sáng tạo chưa đặt tên';

  @override
  String get creator_studio_no_bio => 'Chưa điền phần giới thiệu bản thân';

  @override
  String get chat_input_tools => 'Tính năng';

  @override
  String get chat_input_expand_tools => 'Mở rộng tính năng';

  @override
  String get chat_input_stop => 'Dừng';

  @override
  String get chat_input_send => 'Gửi';

  @override
  String get chat_side_menu_section_chat => 'Trò chuyện';

  @override
  String get chat_side_menu_section_relationship => 'Mối quan hệ';

  @override
  String get chat_side_menu_section_memory => 'Quản lý ký ức';

  @override
  String get character_navigator_confidential_title => 'Hồ sơ mật';

  @override
  String get character_navigator_unavailable_message =>
      'Nhân vật này có thể đã được chuyển sang riêng tư, gỡ khỏi nền tảng, lưu trữ do vi phạm hoặc bị xóa.';

  @override
  String get character_navigator_got_it => 'Tôi hiểu rồi';

  @override
  String get character_navigator_load_failed_title => 'Không thể tải';

  @override
  String get character_navigator_load_failed_message =>
      'Tạm thời không thể tải dữ liệu nhân vật, vui lòng thử lại sau.';

  @override
  String get character_navigator_confirm => 'Xác nhận';

  @override
  String get character_profile_add_bookmark => 'Lưu nhân vật';

  @override
  String get character_profile_remove_bookmark => 'Bỏ lưu';

  @override
  String get character_profile_pronoun_female => 'Cô ấy';

  @override
  String get character_profile_pronoun_male => 'Anh ấy';

  @override
  String get character_profile_pronoun_neutral => 'Nhân vật ấy';

  @override
  String get chat_home_pin_limit_reached =>
      'Bạn chỉ có thể ghim tối đa 3 cuộc trò chuyện. Vui lòng bỏ ghim một cuộc trò chuyện khác trước.';

  @override
  String get chat_home_pinned_success => 'Đã ghim cuộc trò chuyện';

  @override
  String get chat_home_unpinned_success => 'Đã bỏ ghim';

  @override
  String chat_home_pin_update_failed(String error) {
    return 'Không thể cập nhật trạng thái ghim: $error';
  }

  @override
  String get chat_home_unpin => 'Bỏ ghim';

  @override
  String get chat_home_pin => 'Ghim cuộc trò chuyện';

  @override
  String chat_home_time_label(String time) {
    return 'Thời gian: $time';
  }

  @override
  String get main_check_in_already_done => 'Hôm nay bạn đã điểm danh rồi';

  @override
  String get nav_recommend => 'Đề xuất';

  @override
  String get moments_auto_reply_title =>
      'Cho phép AI tự động phản hồi bài viết của người chơi';

  @override
  String get moments_auto_reply_description =>
      'Khi bật, hệ thống có thể chọn nhân vật này để phản hồi bài viết của người chơi.';

  @override
  String get mailOriginalQuestionLabel => 'Câu hỏi ban đầu của bạn';

  @override
  String get hidden_moments_empty_hint => 'Hiện chưa có bài viết nào bị ẩn';

  @override
  String get moment_search_unavailable =>
      'Tính năng tìm kiếm tạm thời không khả dụng, vui lòng thử lại sau.';

  @override
  String get moment_search_hint =>
      'Tìm kiếm bài viết công khai, nhân vật hoặc nhà sáng tạo';

  @override
  String get moment_search_instruction =>
      'Nhập nội dung bài viết, tên nhân vật hoặc tên nhà sáng tạo';

  @override
  String get moment_search_no_results =>
      'Không tìm thấy bài viết công khai liên quan';

  @override
  String get settingsErrorTitle => 'Đã xảy ra lỗi';

  @override
  String get settingsChangePasswordSubtitle =>
      'Xác minh mật khẩu hiện tại rồi thiết lập mật khẩu đăng nhập mới';

  @override
  String get settingsCreatorGuidelines => 'Quy định dành cho nhà sáng tạo';

  @override
  String get settingsPlayGuide => 'Hướng dẫn chơi';

  @override
  String get language_selection_subtitle => 'Chọn ngôn ngữ bạn thường sử dụng';

  @override
  String get search_character_hint =>
      'Tìm kiếm nhân vật, nhà sáng tạo, nghề nghiệp hoặc thẻ';

  @override
  String get search_character_clear => 'Xóa';

  @override
  String get search_character_recent => 'Tìm kiếm gần đây';

  @override
  String get search_character_load_failed =>
      'Không thể tải dữ liệu tìm kiếm, vui lòng thử lại sau.';

  @override
  String get search_character_popular => 'Đang được yêu thích gần đây';

  @override
  String search_character_result_count(int count) {
    return 'Tìm thấy $count nhân vật';
  }

  @override
  String get shop_tab_monthly => 'Gói tháng';

  @override
  String shop_joined_days(int days) {
    return 'Bạn đã đến với LoveyDovey được $days ngày';
  }

  @override
  String get shop_vip_tier_1_title => 'Vừa gặp đã yêu';

  @override
  String get shop_vip_tier_1_reward =>
      '20 điểm Hoa + danh hiệu người mới độc quyền';

  @override
  String get shop_vip_tier_2_title => 'Rung động ánh sáng';

  @override
  String get shop_vip_tier_2_reward =>
      'Khung ảnh đại diện độc quyền 【Rung động ánh sáng】';

  @override
  String get shop_vip_tier_3_title => 'Lời thì thầm dưới trời sao';

  @override
  String get shop_vip_tier_3_reward =>
      'Bong bóng trò chuyện độc quyền + 50 điểm Hoa';

  @override
  String get shop_vip_tier_4_title => 'Hoàng hôn lãng mạn';

  @override
  String get shop_vip_tier_4_reward => 'Biểu tượng ứng dụng độc quyền';

  @override
  String get shop_vip_tier_5_title => 'Trái tim rung động';

  @override
  String get shop_vip_tier_5_reward =>
      'Hiệu ứng chạm màn hình (Lottie) + 100 điểm Hoa';

  @override
  String get shop_vip_tier_6_title => 'Lời thề vĩnh cửu';

  @override
  String get shop_vip_tier_6_reward =>
      'Khung ảnh đại diện động cao cấp + 200 điểm Hoa';

  @override
  String get shop_vip_tier_7_title => 'Giao hòa tâm hồn';

  @override
  String get shop_vip_tier_7_reward =>
      'Hiệu ứng bong bóng trò chuyện động + danh hiệu cao cấp độc quyền';

  @override
  String get shop_vip_tier_8_title => 'Chỉ đợi riêng người';

  @override
  String get shop_vip_tier_8_reward =>
      'Bảng tên động cao cấp nhất + 500 điểm Hoa';

  @override
  String get shop_vip_tier_9_title => 'Dải ngân hà rực rỡ';

  @override
  String get shop_vip_tier_9_reward =>
      'Hiệu ứng xuất hiện Lottie độc quyền + hỗ trợ khách hàng riêng';

  @override
  String get shop_vip_tier_10_title => 'Tình yêu tối thượng';

  @override
  String get shop_vip_tier_10_reward =>
      '【Hộp quà VIP hiện vật độc quyền】 (Thư viết tay + Búp bê nhân vật)';

  @override
  String get shop_vip_total_bond => 'Liên kết lãng mạn tích lũy';

  @override
  String get shop_vip_all_unlocked =>
      'Bạn đã mở khóa toàn bộ đặc quyền cao cấp!';

  @override
  String shop_vip_next_unlock(int amount) {
    return 'Nạp thêm NT\$ $amount để mở khóa cấp tiếp theo';
  }

  @override
  String get call_connecting => 'Đang kết nối cuộc gọi...';

  @override
  String get call_listening_auto_send =>
      'Đang lắng nghe... (Sẽ tự động gửi khi bạn nói xong)';

  @override
  String get call_listening_release_to_send =>
      'Đang lắng nghe... (Thả tay để gửi)';

  @override
  String call_sending_transcript(String text) {
    return ' $text\n\n(Đang gửi...)';
  }

  @override
  String get help_translation_fallback =>
      'Hiện chưa có hướng dẫn chơi bằng ngôn ngữ này. Hệ thống sẽ tạm thời hiển thị bằng tiếng Trung phồn thể.';

  @override
  String get help_all_categories => 'Tất cả';

  @override
  String get help_subtitle_companion =>
      'Các tính năng hằng ngày và công cụ hỗ trợ hữu ích';

  @override
  String get help_subtitle_ai_chat =>
      'Trò chuyện, giọng nói và tương tác thông minh';

  @override
  String get help_subtitle_creation =>
      'Thiết lập nhân vật và các tính năng sáng tạo';

  @override
  String get help_subtitle_explore => 'Khám phá nhân vật và nội dung trò chơi';

  @override
  String get help_subtitle_care => 'Đồng hành dịu dàng và quan tâm mỗi ngày';

  @override
  String get help_subtitle_general =>
      'Các tính năng phổ biến và hướng dẫn sử dụng';

  @override
  String get chat_interact_fun => 'Hoạt động thú vị';

  @override
  String get memo_notification_permission_missing =>
      'Quyền thông báo chưa được bật. Ghi chú vẫn sẽ được lưu nhưng thông báo hệ thống sẽ không hiển thị.';

  @override
  String memo_saved_with_reminder(String characterName) {
    return 'Đã lưu ghi chú. $characterName sẽ nhắc bạn!';
  }

  @override
  String get memo_saved_without_notification =>
      'Đã lưu ghi chú nhưng quyền thông báo chưa được bật.';

  @override
  String memo_updated_with_reminder(String characterName) {
    return 'Đã cập nhật ghi chú. $characterName sẽ nhắc bạn!';
  }

  @override
  String get memo_updated_without_notification =>
      'Đã cập nhật ghi chú nhưng hiện chưa có quyền thông báo.';

  @override
  String memo_load_error(String error) {
    return 'Đã xảy ra lỗi khi tải dữ liệu: $error';
  }

  @override
  String get story_summary_content_required =>
      'Nội dung câu chuyện không được để trống';

  @override
  String get story_summary_edit_hint => 'Viết nên câu chuyện của hai người...';

  @override
  String get profile_section_basic_info => 'Thông tin cơ bản';

  @override
  String get profile_section_about_me => 'Về tôi';

  @override
  String get dice_duel_you => 'Bạn';

  @override
  String get dice_duel_result_saved => 'Đã lưu kết quả đối đầu!';

  @override
  String get dice_duel_rolling => 'Đang hội tụ năng lượng vũ trụ...';

  @override
  String get butterfly_loading_connecting => 'Đang kết nối với thời gian...';

  @override
  String get character_block_login_required =>
      'Vui lòng đăng nhập trước khi chặn nhân vật';

  @override
  String get character_block_self_forbidden =>
      'Bạn không thể chặn nhân vật do mình tạo';

  @override
  String get character_block_title => 'Chặn nhân vật';

  @override
  String character_block_confirm_message(String characterName) {
    return 'Bạn có chắc muốn chặn “$characterName” không?\n\nSau khi chặn, nhân vật này sẽ không còn xuất hiện trong các nội dung đề xuất như Gặp gỡ và Khoảnh khắc.';
  }

  @override
  String get character_block_confirm => 'Xác nhận chặn';

  @override
  String character_block_success(String characterName) {
    return 'Đã chặn “$characterName”';
  }

  @override
  String get character_block_failed =>
      'Không thể chặn nhân vật, vui lòng thử lại sau';

  @override
  String get character_unblock_success => 'Đã bỏ chặn nhân vật';

  @override
  String get character_unblock_failed =>
      'Không thể bỏ chặn nhân vật, vui lòng thử lại sau';

  @override
  String get character_report_login_required =>
      'Vui lòng đăng nhập trước khi báo cáo nhân vật';

  @override
  String get character_report_self_forbidden =>
      'Bạn không thể báo cáo nhân vật do mình tạo';

  @override
  String get character_report_submitted =>
      'Đã gửi báo cáo. Chúng tôi sẽ tiến hành xem xét';

  @override
  String get character_report_open_failed =>
      'Không thể mở trang báo cáo, vui lòng thử lại sau';

  @override
  String chat_loader_error(String error) {
    return 'Không thể tải: $error';
  }

  @override
  String get announcement_connection_failed =>
      'Kết nối thất bại, vui lòng thử lại sau';

  @override
  String get announcement_latest => 'Mới nhất';

  @override
  String announcement_published_at(String date) {
    return 'Ngày đăng: $date';
  }

  @override
  String get announcement_operations_team => 'Đội ngũ vận hành LoveyDovey';

  @override
  String get legal_creator_guidelines => 'Quy định dành cho nhà sáng tạo';

  @override
  String get legal_refresh => 'Làm mới';

  @override
  String get legal_page_load_failed => 'Không thể tải trang';

  @override
  String get legal_check_connection_retry =>
      'Vui lòng kiểm tra kết nối mạng rồi thử lại.';

  @override
  String get legal_reload => 'Tải lại';

  @override
  String get chat_web_purchase_unavailable =>
      'Phiên bản web hiện chưa hỗ trợ nạp tiền. Vui lòng sử dụng ứng dụng LoveyDovey để mua Điểm Hoa hoặc đăng ký gói thuê bao.';

  @override
  String get chat_dont_show_again => 'Không hiển thị lại';

  @override
  String get chat_menu_save_transcript => 'Lưu lịch sử trò chuyện';

  @override
  String get chat_menu_reply_model => 'Mô hình phản hồi';

  @override
  String get chat_reply_model_menu_tip =>
      'Mô hình phản hồi đã được chuyển sang vị trí mới! Giờ bạn có thể tìm thấy trong menu ở góc trên bên phải.';

  @override
  String get defaultProfileName => 'Hồ sơ mặc định';

  @override
  String get creator_social_links_manage => 'Quản lý liên kết mạng xã hội';

  @override
  String get creator_social_links_title => 'Liên kết cá nhân và mạng xã hội';

  @override
  String get creator_social_links_hint =>
      'Nhập các liên kết bạn muốn hiển thị công khai trên trang nhà sáng tạo. Những mục để trống sẽ không được hiển thị.';

  @override
  String get creator_social_links_website => 'Trang web cá nhân';

  @override
  String get creator_social_links_saved => 'Đã lưu các liên kết mạng xã hội';

  @override
  String get creator_social_links_load_failed =>
      'Không thể tải các liên kết mạng xã hội, vui lòng thử lại sau';

  @override
  String get creator_social_links_save_failed =>
      'Không thể lưu các liên kết mạng xã hội, vui lòng thử lại sau';

  @override
  String get creator_social_links_open_failed => 'Không thể mở liên kết này';

  @override
  String get chat_regenerate_bottom_tip =>
      '“Tạo lại” đã chuyển xuống đây! Hãy dùng nút này khi bạn muốn một câu trả lời khác.';

  @override
  String get chat_continue_bottom_tip =>
      '“Tiếp tục” đã chuyển xuống đây! Hãy dùng nút này khi bạn muốn nhân vật nói tiếp.';

  @override
  String get languageSelectionSubtitle => 'Chọn ngôn ngữ bạn quen dùng';

  @override
  String get chatStatusBarTitle => 'Trạng thái';

  @override
  String get chatStatusBarSubtitle =>
      'Chọn thông tin muốn hiển thị trong cuộc trò chuyện';

  @override
  String get chatStatusMood => 'Tâm trạng';

  @override
  String get chatStatusOutfit => 'Trang phục';

  @override
  String get chatStatusRelationship => 'Mối quan hệ';

  @override
  String get chatStatusThought => 'Suy nghĩ';

  @override
  String get chatStatusWeather => 'Thời tiết';

  @override
  String get chatStatusCurrentState => 'Trạng thái hiện tại';

  @override
  String get chatStatusAction => 'Hành động';

  @override
  String get chatStatusAffinity => 'Độ thân mật';

  @override
  String get chatPreferenceTitle => 'Tùy chọn trò chuyện';

  @override
  String get chatPreferenceSubtitle =>
      'Các cài đặt này chỉ áp dụng cho cuộc trò chuyện hiện tại và sẽ duy trì cho đến khi bạn sửa hoặc xóa.';

  @override
  String get chatPreferenceHint =>
      'Ví dụ:\\nĐừng gọi tôi là cưng\\nTrả lời ngắn hơn\\nĐừng thường xuyên tự thêm hành động hoặc biểu cảm cho tôi';

  @override
  String get chatPreferenceClear => 'Xóa';

  @override
  String get chatSettingsDone => 'Xong';

  @override
  String get chat_mode_resonance => 'Cộng hưởng';

  @override
  String get chat_mode_gemini_cost =>
      '10 lượt đầu mỗi ngày miễn phí, sau đó 1 điểm';

  @override
  String get chat_mode_gemini_desc =>
      'Phù hợp cho trò chuyện nhẹ nhàng và đồng hành hằng ngày.';

  @override
  String get chat_mode_story_cost => '5 điểm';

  @override
  String get chat_mode_immersive_cost => '7 điểm';

  @override
  String get chat_mode_resonance_cost => '10 điểm';

  @override
  String get chat_mode_resonance_desc =>
      'Mở rộng cảm xúc, căng thẳng trong mối quan hệ và phản ứng nhân vật tinh tế hơn.';

  @override
  String get chat_mode_gemini_cost_short => '1 Hoa';

  @override
  String get chat_mode_story_cost_short => '5 Hoa';

  @override
  String get chat_mode_immersive_cost_short => '7 Hoa';

  @override
  String get chat_mode_resonance_cost_short => '10 Hoa';

  @override
  String get notification_channel_chat_description =>
      'Dùng để nhận phản hồi mới nhất từ nhân vật và lời nhắc trong trò chơi.';

  @override
  String get subscription_star_contract_name =>
      'Lianlian Shiguang · Khế Ước Sao';

  @override
  String moment_notification_comment_on_your_post(
      Object commentText, Object senderNickname) {
    return '$senderNickname đã bình luận bài viết của bạn: “$commentText”';
  }

  @override
  String get moment_notification_new_reply_title =>
      'Có phản hồi mới trong bài viết của bạn! 💬';

  @override
  String get moment_notification_character_popularity_title =>
      'Độ nổi tiếng của nhân vật đang tăng vọt! 🔥';

  @override
  String get font_size_small => 'Nhỏ';

  @override
  String get font_size_standard => 'Tiêu chuẩn';

  @override
  String get font_size_slightly_large => 'Hơi lớn';

  @override
  String get font_size_large => 'Lớn';

  @override
  String get font_size_extra_large => 'Rất lớn';

  @override
  String get font_selection_title => 'Phông chữ';

  @override
  String get font_selection_description =>
      'Chọn phông chữ phù hợp nhất để đọc truyện và trò chuyện.';

  @override
  String get font_size_title => 'Cỡ chữ';

  @override
  String get font_selection_tagline =>
      'Một lần nữa, hãy viết nên câu chuyện của hai người cùng người bạn yêu thích.';

  @override
  String font_selection_applied_message(Object value1) {
    return 'Đã áp dụng “$value1”';
  }

  @override
  String get font_selection_local_storage_note =>
      'Phông chữ và cỡ chữ sẽ được áp dụng ngay và lưu trên thiết bị này. Khi khôi phục giao diện mặc định, thiết lập sẽ trở về “Shiguang Serif + Tiêu chuẩn”.';

  @override
  String get inbox_customer_service_report => 'Báo cáo hỗ trợ khách hàng';

  @override
  String get inbox_content_text_message_player_title_send =>
      'Tiêu đề do người chơi gửi';

  @override
  String get inbox_content_text_message_player_content_send =>
      'Nội dung do người chơi gửi';

  @override
  String avatar_frame_equipped_message(Object value1) {
    return 'Đã trang bị “$value1”';
  }

  @override
  String get avatar_frame_unequip_frame_snackbar =>
      'Đã tháo khung ảnh đại diện';

  @override
  String get avatar_frame_unequip_frame_message_event =>
      'Khung ảnh đại diện sự kiện';

  @override
  String get avatar_frame_message => 'Khung ảnh đại diện';

  @override
  String avatar_frame_load_failed(Object value1) {
    return 'Không thể tải khung ảnh đại diện: $value1';
  }

  @override
  String get avatar_frame_parse_frames_message_select =>
      'Chọn khung ảnh đại diện bạn muốn sử dụng';

  @override
  String get avatar_frame_parse_frames_message_event =>
      'Khung ảnh đại diện nhận từ sự kiện sẽ được giữ vĩnh viễn và có thể đổi hoặc tháo bất cứ lúc nào.';

  @override
  String get avatar_frame_parse_frames_title => 'Không dùng khung ảnh đại diện';

  @override
  String get avatar_frame_parse_frames_subtitle_avatar =>
      'Hiển thị ảnh đại diện gốc';

  @override
  String get avatar_frame_parse_frames_message_event_shop_redeem_current =>
      'Bạn chưa sở hữu khung ảnh đại diện nào.\nKhung đổi trong cửa hàng sự kiện sẽ xuất hiện tại đây.';

  @override
  String get avatar_frame_parse_frames_message_event_variant_b =>
      'Khung ảnh đại diện giới hạn sự kiện';

  @override
  String get background_settings_message => 'Hình nền giới hạn';

  @override
  String get background_title_exclusive_photo_current =>
      'Chưa có ảnh độc quyền';

  @override
  String get background_subtitle_unlock_character_photo =>
      'Ảnh nhân vật mở khóa sau này sẽ xuất hiện tại đây.';

  @override
  String get background_title_login => 'Đăng nhập để xem hình nền giới hạn';

  @override
  String get background_subtitle_redeem_chat_event =>
      'Hình nền trò chuyện nhận từ sự kiện sẽ được lưu tại đây.';

  @override
  String get background_title => 'Bạn chưa nhận được hình nền giới hạn nào';

  @override
  String get background_subtitle_event_shop_redeem_chat =>
      'Hình nền trò chuyện đổi trong cửa hàng sự kiện sẽ xuất hiện tại đây.';

  @override
  String get background_is_limited_background_type_message_chat_event =>
      'Hình nền trò chuyện giới hạn sự kiện';

  @override
  String background_is_limited_background_type_message_current_chat(
      Object value1) {
    return 'Đặt “$value1” làm hình nền cho cuộc trò chuyện hiện tại?';
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
    return 'Nhân vật chính hiện tại: 【$value1】\n';
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
  String get character_to_map_message_creator => 'Nhà sáng tạo bí ẩn';

  @override
  String get character_get_character_by_id_message_load_background_story =>
      'Đang tải câu chuyện nền...';

  @override
  String get character_get_character_by_id_message_sync =>
      'Đang đồng bộ cốt truyện mở đầu...';

  @override
  String get character_get_character_by_id_message =>
      'Đang chuẩn bị câu mở đầu...';

  @override
  String get character_get_character_by_id_message_background =>
      'Đang tải hình nền...';

  @override
  String get character_get_character_by_id_message_load =>
      'Đang tải thế giới quan...';

  @override
  String get character_get_character_by_id_message_load_settings =>
      'Đang tải thiết lập cốt lõi của nhân vật...';

  @override
  String get character_get_character_by_id_message_variant_b =>
      'Đang tải tính cách...';

  @override
  String get character_get_character_by_id_message_appearance =>
      'Đang tải mô tả ngoại hình...';

  @override
  String get character_get_character_by_id_message_variant_c =>
      'Đang tải giọng điệu...';

  @override
  String get character_get_character_by_id_message_load_variant_b => 'Chưa tải';

  @override
  String get character_get_character_by_id_message_variant_d => 'Người lạ';

  @override
  String get character_get_character_by_id_message_load_variant_c =>
      'Đang tải ví dụ hội thoại...';

  @override
  String get character_get_character_by_id_message_variant_e => 'Lần đầu gặp';

  @override
  String get character_get_character_by_id_message_variant_f => 'Đã quen';

  @override
  String get character_get_character_by_id_message_variant_g => 'Mập mờ';

  @override
  String get chat_input_message_sticker => 'Nhãn dán';

  @override
  String get chat_text =>
      'Bạn đã đạt giới hạn trò chuyện thường miễn phí hôm nay';

  @override
  String get chat_message_flowers_today_continue =>
      'Bạn đã dùng hết 10 lượt trò chuyện thường miễn phí hôm nay.\n\nTừ bây giờ, mỗi lượt trò chuyện thường cần 1 Hoa. Tiếp tục?';

  @override
  String get chat_text_continue => 'Đồng ý và tiếp tục';

  @override
  String get chat_empty_message_label_current_sticker =>
      'Hiện chưa có nhãn dán nào có thể sử dụng.';

  @override
  String get chat_empty_message_label_sticker =>
      'Chưa có nhãn dán dùng gần đây';

  @override
  String get chat_empty_message_label_sticker_variant_b =>
      'Chưa có nhãn dán yêu thích';

  @override
  String get chat_empty_message_label_current_sticker_variant_b =>
      'Hiện chưa có nhãn dán nào có thể sử dụng';

  @override
  String get chat_empty_message_sticker => 'Nhãn dán của tôi';

  @override
  String get chat_empty_message => 'Dùng gần đây';

  @override
  String get chat_empty_message_variant_b => 'Yêu thích';

  @override
  String get chat_send_sticker_message_current_unavailable_sticker =>
      'Nhãn dán này hiện không thể sử dụng';

  @override
  String chat_message_theater(Object sceneTitle) {
    return '—— Nhà hát・$sceneTitle ——';
  }

  @override
  String get chat_handle_regenerate_button_message_character_reply_again =>
      'Phản hồi trước đó của nhân vật sẽ được tạo lại.';

  @override
  String creator_profile_reason_tile_message_report_select_reason(
      Object creatorName) {
    return 'Chọn lý do báo cáo “$creatorName”:';
  }

  @override
  String get widget_key_message => 'Trạng thái';

  @override
  String get widget_key_message_variant_b => 'Vị trí';

  @override
  String get widget_label_character => 'Chưa có trạng thái nhân vật';

  @override
  String get widget_format_post_time_label_moment_latest => 'Bài viết mới nhất';

  @override
  String get widget_format_post_time_label_update_moment =>
      'Vừa cập nhật bài viết';

  @override
  String widget_format_post_time_label_minutes_ago_update_moment(
      Object value1) {
    return 'Đã cập nhật bài viết $value1 phút trước';
  }

  @override
  String widget_format_post_time_label_hours_ago_update_moment(Object value1) {
    return 'Đã cập nhật bài viết $value1 giờ trước';
  }

  @override
  String get widget_format_post_time_label_update_moment_days =>
      'Đã cập nhật bài viết hôm qua';

  @override
  String widget_format_post_time_label_update_moment_days_ago(Object value1) {
    return 'Đã cập nhật bài viết $value1 ngày trước';
  }

  @override
  String widget_format_post_time_label_update_moment_variant_b(
      Object value1, Object value2) {
    return 'Đã cập nhật bài viết vào $value1/$value2';
  }

  @override
  String get widget_format_post_time_message_share_photo =>
      'Đã chia sẻ một ảnh';

  @override
  String get widget_format_post_time_message_update_moment =>
      'Đã cập nhật một bài viết';

  @override
  String get widget_format_post_time_message_current_character_moment =>
      'Chưa có bài viết của nhân vật';

  @override
  String get widget_extract_daily_quote_message => 'Vị trí:';

  @override
  String get widget_format_daily_quote_time_message_today =>
      'Hôm nay chưa có một câu nào';

  @override
  String get widget_load_period_care_state_message_today =>
      '“Hôm nay đừng cố quá. Anh sẽ ở bên em, mình cứ từ từ thôi.”';

  @override
  String widget_load_period_care_state_message_period_days(Object dayCount) {
    return 'Ngày thứ $dayCount của kỳ kinh';
  }

  @override
  String get widget_load_period_care_state_message_days =>
      '“Mấy hôm nay nhớ nghỉ sớm một chút. Đừng để bản thân quá mệt.”';

  @override
  String get widget_load_period_care_state_message_today_start =>
      'Dự kiến bắt đầu hôm nay';

  @override
  String widget_load_period_care_state_message_days_variant_b(
      Object daysUntil) {
    return 'Dự kiến còn $daysUntil ngày';
  }

  @override
  String get widget_load_period_care_state_message_today_variant_b =>
      '“Em đã cố gắng nhiều rồi. Hôm nay nhớ chăm sóc bản thân thật tốt.”';

  @override
  String get widget_load_period_care_state_message_period_end =>
      'Kỳ kinh vừa kết thúc';

  @override
  String get widget_load_period_care_state_message_today_variant_c =>
      '“Hôm nay cũng nhớ chăm sóc bản thân thật tốt nhé.”';

  @override
  String get widget_load_period_care_state_message_current_reminder =>
      'Hiện không có lời nhắc chu kỳ đặc biệt';

  @override
  String get widget_load_period_care_state_message =>
      'Chưa có đủ dữ liệu chu kỳ';

  @override
  String get widget_parse_character_birthday_message => 'Năm';

  @override
  String get widget_parse_character_birthday_message_variant_b => 'Tháng';

  @override
  String get widget_build_birthday_countdown_lines_message_character_birthday =>
      'Sinh nhật nhân vật';

  @override
  String get widget_build_birthday_countdown_lines_message_birthday_settings =>
      'Chưa đặt sinh nhật';

  @override
  String widget_build_birthday_countdown_lines_message_birthday_countdown(
      Object birthdayLabel) {
    return 'Đến sinh nhật của anh ấy・$birthdayLabel';
  }

  @override
  String get widget_build_birthday_countdown_lines_message_today =>
      'Chính là hôm nay';

  @override
  String widget_build_birthday_countdown_lines_message_days(Object days) {
    return 'Còn $days ngày';
  }

  @override
  String get widget_build_birthday_countdown_lines_message =>
      'Từ ngày gặp anh ấy';

  @override
  String get widget_build_birthday_countdown_lines_message_variant_b =>
      'Chưa có ghi chép lần gặp';

  @override
  String widget_build_birthday_countdown_lines_message_days_variant_b(
      Object value1) {
    return '$value1 ngày';
  }

  @override
  String get widget_build_birthday_countdown_lines_message_variant_c =>
      'Ngày quan trọng';

  @override
  String get widget_build_birthday_countdown_lines_message_date_select =>
      'Chưa chọn ngày';

  @override
  String widget_build_birthday_countdown_lines_message_elapsed_days(
      Object value1) {
    return 'Đã qua $value1 ngày';
  }

  @override
  String get widget_settings_remove_title_character_latest =>
      'Bài viết mới nhất của nhân vật';

  @override
  String get widget_settings_remove_subtitle_moment_latest =>
      'Xem cập nhật mới nhất của anh ấy mà không cần mở app.';

  @override
  String get widget_settings_remove_title_period => 'Đồng hành trong kỳ kinh';

  @override
  String get widget_settings_remove_subtitle_character_end =>
      'Thêm một chút quan tâm từ nhân vật trước, trong và sau kỳ kinh.';

  @override
  String get widget_settings_remove_title => 'Một câu hôm nay';

  @override
  String get widget_settings_remove_subtitle_days =>
      'Mỗi ngày, một câu sẽ chờ bạn trên màn hình chính.';

  @override
  String get widget_settings_remove_title_reminder => 'Kỷ niệm / Nhắc nhở';

  @override
  String get widget_settings_remove_subtitle_character_birthday_reminder =>
      'Cùng ghi nhớ ngày gặp nhau và sinh nhật, đồng thời để nhân vật nhắc bạn những điều quan trọng.';

  @override
  String get widget_settings_remove_title_character => 'Trạng thái nhân vật';

  @override
  String get widget_settings_remove_subtitle_chat_latest_mood =>
      'Đưa tâm trạng, trạng thái và vị trí mới nhất trong cuộc trò chuyện ra màn hình chính.';

  @override
  String get widget_settings_size_label => 'Vừa';

  @override
  String get widget_settings_size_label_message_send =>
      'Đã gửi yêu cầu thêm vào màn hình chính.';

  @override
  String get widget_settings_size_label_message_try_again_later_failed =>
      'Không thể thêm vào màn hình chính. Vui lòng thử lại sau.';

  @override
  String get widget_settings_edit_saved_widget_message_character_reminder_again =>
      '“Nhắc việc của nhân vật” phiên bản cũ đã được gộp vào “Kỷ niệm / Nhắc nhở”. Vui lòng tạo lại.';

  @override
  String get widget_settings_delete_saved_widget_title_delete_small =>
      'Xóa tiện ích?';

  @override
  String
      widget_settings_delete_saved_widget_message_stop_display_long_press_home_after_delete(
          Object value1, Object value2) {
    return 'Bạn có chắc muốn xóa “$value1・$value2”?\n\nSau khi xóa, tiện ích này trên màn hình chính sẽ ngừng hiển thị nội dung nhân vật và nhắc người chơi nhấn giữ màn hình chính để gỡ bỏ.';
  }

  @override
  String get widget_settings_delete_saved_widget_message_delete_settings_small =>
      'Đã xóa cài đặt tiện ích; tiện ích tương ứng trên màn hình chính đã bị vô hiệu hóa.';

  @override
  String get widget_settings_message_desktop_widget =>
      'Tiện ích màn hình chính';

  @override
  String get widget_settings_message_character_days =>
      'Để nhân vật bạn yêu thích đồng hành cùng bạn mỗi ngày.';

  @override
  String get widget_settings_message_small => 'Tiện ích của tôi';

  @override
  String get widget_settings_message_desktop_widget_variant_b =>
      'Chưa có tiện ích màn hình chính';

  @override
  String get widget_settings_message_character_reminder =>
      'Chọn một nhân vật bạn thích và hiển thị lời nhắc, bài viết hoặc trạng thái của họ trên màn hình chính.';

  @override
  String widget_settings_message_size(Object value1) {
    return 'Kích thước $value1';
  }

  @override
  String get widget_settings_tooltip => 'Thêm vào màn hình chính';

  @override
  String get widget_settings_tooltip_small => 'Chỉnh sửa tiện ích';

  @override
  String get widget_settings_tooltip_delete_small => 'Xóa tiện ích';

  @override
  String get widget_settings_message_desktop_widget_variant_c =>
      'Thêm tiện ích màn hình chính';

  @override
  String get widget_settings_message_character_photo_content_select_small =>
      'Mỗi tiện ích có thể chọn riêng nhân vật, ảnh nhân vật và nội dung hiển thị. Bạn cũng có thể đặt nhiều nhân vật cùng lúc trên màn hình chính.';

  @override
  String get widget_settings_desktop_type_selection_message_select_small =>
      'Chọn tiện ích';

  @override
  String get widget_settings_desktop_type_selection_message_select =>
      'Trước tiên, hãy chọn cách bạn muốn nhân vật đồng hành cùng mình trên màn hình chính.';

  @override
  String
      get widget_settings_go_to_photo_step_message_try_again_later_failed_load_character_photo =>
          'Không thể tải ảnh nhân vật. Vui lòng thử lại sau.';

  @override
  String get widget_settings_message_character_select => 'Chọn nhân vật';

  @override
  String get widget_settings_message_character_friend_days =>
      'Chỉ hiển thị những nhân vật bạn đã kết bạn hoặc từng trò chuyện.';

  @override
  String get widget_settings_hint_character_search => 'Tìm nhân vật';

  @override
  String get widget_settings_message_try_again_later_failed_load_character =>
      'Không thể tải nhân vật. Vui lòng thử lại sau.';

  @override
  String get widget_settings_message_current_character_chat_friend_add =>
      'Hiện không có nhân vật phù hợp. Hãy trò chuyện với nhân vật trước hoặc thêm họ làm bạn.';

  @override
  String get widget_settings_message_character_photo_select =>
      'Tiếp theo・Chọn ảnh nhân vật';

  @override
  String
      get widget_settings_desktop_photo_selection_message_character_photo_select =>
          'Chọn ảnh nhân vật';

  @override
  String
      widget_settings_desktop_photo_selection_message_current_affection_unlocked_photo(
          Object value1) {
    return 'Độ thân mật hiện tại $value1・Ảnh đã mở khóa có thể dùng ngay.';
  }

  @override
  String
      get widget_settings_desktop_photo_selection_message_current_character_photo =>
          'Nhân vật này hiện không có ảnh khả dụng.';

  @override
  String
      widget_settings_desktop_photo_selection_message_required_affection_unlock_photo(
          Object value1) {
    return 'Cần độ thân mật $value1 để mở khóa ảnh này.';
  }

  @override
  String get widget_settings_message_photo_public => 'Ảnh công khai';

  @override
  String widget_settings_message_unlock(Object value1) {
    return 'Mở khóa ở độ thân mật $value1';
  }

  @override
  String widget_settings_message_unlocked(Object value1) {
    return 'Đã mở khóa・Độ thân mật $value1';
  }

  @override
  String get widget_settings_message_content_settings =>
      'Tiếp theo・Thiết lập nội dung hiển thị';

  @override
  String get widget_settings_open_preview_message_player_select =>
      'Vui lòng chọn trước một sự kiện / việc cần làm do người chơi tạo.';

  @override
  String get widget_settings_pick_custom_memo_event_message_login_account =>
      'Vui lòng đăng nhập trước.';

  @override
  String
      get widget_settings_pick_custom_memo_event_message_memo_current_character =>
          'Nhân vật này hiện chưa có sự kiện / ghi chú nào.';

  @override
  String get widget_settings_pick_custom_memo_event_message_player_select =>
      'Chọn sự kiện do người chơi tạo';

  @override
  String get widget_settings_message_try_again_later_failed_load =>
      'Không thể tải sự kiện. Vui lòng thử lại sau.';

  @override
  String get widget_settings_message_content_settings_variant_b =>
      'Thiết lập nội dung hiển thị';

  @override
  String get widget_settings_subtitle_content =>
      'Điều chỉnh nội dung bạn muốn thấy trên màn hình chính.';

  @override
  String get widget_settings_message_small_variant_b =>
      'Tiếp theo・Xem trước tiện ích';

  @override
  String get widget_settings_title => 'Hiển thị bài viết';

  @override
  String get widget_settings_title_variant_b => 'Hiển thị ảnh bài viết';

  @override
  String get widget_settings_title_variant_c => 'Hiển thị số lượt thích';

  @override
  String get widget_settings_title_comment => 'Hiển thị số bình luận';

  @override
  String get widget_settings_title_variant_d => 'Riêng tư & Đồng hành';

  @override
  String get widget_settings_title_variant_e => 'Chế độ riêng tư';

  @override
  String get widget_settings_subtitle_period_character =>
      'Trên màn hình chính chỉ hiển thị sự quan tâm của nhân vật, không hiển thị trực tiếp thông tin kỳ kinh.';

  @override
  String get widget_settings_title_variant_f => 'Chế độ chi tiết';

  @override
  String get widget_settings_subtitle_end =>
      'Có thể hiển thị trạng thái chu kỳ như sắp đến, đang diễn ra hoặc vừa kết thúc.';

  @override
  String get widget_settings_title_variant_g => 'Hiển thị trạng thái chu kỳ';

  @override
  String get widget_settings_title_time => 'Hiển thị thời gian';

  @override
  String get widget_settings_title_update => 'Cách cập nhật';

  @override
  String get widget_settings_message_update_days => 'Cập nhật mỗi ngày một lần';

  @override
  String get widget_settings_message_update => 'Cập nhật mỗi khi mở app';

  @override
  String get widget_settings_text_update => 'Cập nhật sau khi mở app';

  @override
  String get widget_settings_title_content => 'Nội dung kỷ niệm';

  @override
  String get widget_settings_title_days => 'Số ngày từ lần gặp';

  @override
  String get widget_settings_subtitle_character_today_days =>
      'Hiển thị số ngày từ khi bạn và nhân vật gặp nhau đến hôm nay.';

  @override
  String get widget_settings_subtitle_character_birthday =>
      'Hiển thị còn bao lâu nữa đến sinh nhật nhân vật.';

  @override
  String get widget_settings_title_player =>
      'Sự kiện / Việc cần làm do người chơi tạo';

  @override
  String get widget_settings_message_memo_character_select_reminder =>
      'Chọn một sự kiện hoặc việc cần làm từ ghi chú / lời nhắc của nhân vật này.';

  @override
  String widget_settings_message_selected(Object _selectedMemoContent) {
    return 'Đã chọn: $_selectedMemoContent';
  }

  @override
  String get widget_settings_message_select => 'Chọn tối đa 3 mục';

  @override
  String get widget_settings_message_character =>
      'Trạng thái nhân vật có thể hiển thị tối đa 3 mục.';

  @override
  String get widget_settings_message_small_variant_c => 'Xem trước tiện ích';

  @override
  String get widget_settings_title_confirm => 'Xác nhận cuối';

  @override
  String get widget_settings_subtitle_large =>
      'Hãy xem trước sơ bộ diện mạo trên màn hình chính.';

  @override
  String get widget_settings_title_size => 'Kích thước';

  @override
  String get widget_settings_title_variant_h => 'Bố cục';

  @override
  String get widget_settings_label_photo => 'Ảnh toàn màn hình';

  @override
  String get widget_settings_label_character => 'Thẻ nhân vật';

  @override
  String get widget_settings_message_sync => 'Đang đồng bộ…';

  @override
  String get widget_settings_message_desktop_widget_add =>
      'Thêm tiện ích màn hình chính';

  @override
  String get widget_settings_sample_lines_message_today_end =>
      '“Hôm nay kết thúc sớm hơn dự kiến một chút.”';

  @override
  String get widget_settings_sample_lines_message_days =>
      '“Mấy hôm nay đừng cố quá.”';

  @override
  String get widget_settings_sample_lines_message_period =>
      'Đang trong kỳ kinh';

  @override
  String get widget_settings_sample_lines_message_today =>
      '“Hôm nay nghỉ ngơi thêm một chút nhé.”';

  @override
  String get widget_settings_sample_lines_message_today_variant_b =>
      '“Hôm nay cũng đừng quên ăn uống đầy đủ.”';

  @override
  String get widget_settings_sample_lines_label_birthday_countdown =>
      'Đến sinh nhật của anh ấy';

  @override
  String get widget_settings_sample_lines_label_days => 'Còn 12 ngày';

  @override
  String get widget_settings_sample_lines_label_days_variant_b => '128 ngày';

  @override
  String get widget_settings_sample_lines_message_mood => 'Tâm trạng｜Hơi mệt';

  @override
  String get widget_settings_sample_lines_message_end =>
      'Trạng thái｜Vừa tan làm';

  @override
  String get widget_settings_sample_lines_message =>
      'Vị trí｜Dưới tòa nhà công ty';

  @override
  String get widget_settings_sample_lines_message_variant_b =>
      'Quan hệ｜Người yêu';

  @override
  String get widget_settings_sample_lines_message_variant_c =>
      'Trang phục｜Áo len xám nhạt';

  @override
  String get widget_settings_sample_lines_message_days_variant_b =>
      'Thời tiết｜Hơi se lạnh';

  @override
  String get widget_settings_sample_lines_message_variant_d =>
      'Suy nghĩ｜Muốn gặp em sớm hơn';

  @override
  String get widget_settings_sample_lines_message_variant_e =>
      'Hành động｜Đang dọn bàn';

  @override
  String get widget_settings_sample_lines_message_affection =>
      'Độ thân mật｜Ổn định và gần gũi';

  @override
  String get edit_profile_message => 'Trang trí hồ sơ';

  @override
  String get edit_profile_message_current => 'Hiện không sử dụng';

  @override
  String
      get event_memory_character_load_characters_message_login_character_select =>
          'Vui lòng đăng nhập trước khi chọn nhân vật';

  @override
  String get event_memory_character_center_message_memory_select =>
      'Chọn người bạn muốn cùng lưu giữ ký ức này';

  @override
  String get event_memory_character_center_message_character_friend_add =>
      'Chỉ những nhân vật bạn tự tạo và nhân vật đã kết bạn mới xuất hiện ở đây.';

  @override
  String get event_memory_character_center_message_current_character_select =>
      'Hiện không có nhân vật nào để chọn';

  @override
  String get event_memory_character_center_message_public_character_character_friend_add =>
      'Hãy tạo nhân vật của riêng bạn hoặc thêm một nhân vật công khai bạn thích làm bạn trước.';

  @override
  String get event_memory_character_message_character_select =>
      'Vui lòng chọn nhân vật trước';

  @override
  String event_memory_character_message_continue(Object value1) {
    return 'Tiếp tục cùng $value1';
  }

  @override
  String get event_memory_character_card_message_private => 'Của tôi・Riêng tư';

  @override
  String get event_memory_character_error_label_load_again => 'Tải lại';

  @override
  String
      get event_memory_collection_show_collection_intro_if_needed_message_collection =>
          'Bộ sưu tập Shiguang';

  @override
  String
      get event_memory_collection_show_collection_intro_if_needed_message_collection_content =>
          'Đây là danh sách bộ sưu tập, nơi bạn có thể xem mọi nội dung đã lưu.';

  @override
  String get event_memory_collection_text_collection_login =>
      'Vui lòng đăng nhập để xem bộ sưu tập';

  @override
  String get event_memory_collection_message_memory => 'Ký ức';

  @override
  String get event_memory_collection_message_chat_background =>
      'Hình nền trò chuyện';

  @override
  String get event_memory_collection_message_avatar_frame_collection =>
      'Chưa sưu tập khung ảnh đại diện nào';

  @override
  String get event_memory_collection_message_avatar_frame =>
      'Khung ảnh đại diện giới hạn bạn nhận được sau này sẽ xuất hiện ở đây.';

  @override
  String get event_memory_collection_message_collection_sticker =>
      'Chưa sưu tập nhãn dán nào';

  @override
  String get event_memory_collection_message_sticker =>
      'Nhãn dán bạn sưu tập sau này sẽ được lưu ở đây.';

  @override
  String get event_memory_collection_message_collection_chat_background =>
      'Chưa sưu tập hình nền trò chuyện nào';

  @override
  String get event_memory_collection_message_chat_background_variant_b =>
      'Hình nền trò chuyện giới hạn bạn nhận được sau này sẽ xuất hiện ở đây.';

  @override
  String get event_memory_collection_tab_title_collection_temporary =>
      'Tạm thời không thể tải bộ sưu tập';

  @override
  String get event_memory_collection_tab_title_collection_memory =>
      'Chưa sưu tập ký ức nào';

  @override
  String get event_memory_collection_tab_subtitle_limited_memory_complete =>
      'Sau khi hoàn thành ký ức giới hạn, bạn có thể giữ lại những khoảnh khắc mình thích ở đây.';

  @override
  String get event_memory_collection_item_card_label => 'Vật phẩm giới hạn';

  @override
  String get event_memory_collection_confirm_delete_owned_item_message_delete =>
      'Xóa vật phẩm giới hạn?';

  @override
  String
      event_memory_collection_confirm_delete_owned_item_message_after_delete_unavailable(
          Object _itemTypeLabel) {
    return 'Sau khi xóa, bạn sẽ không thể sử dụng $_itemTypeLabel này nữa,';
  }

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_collection =>
          'và nó cũng sẽ không còn xuất hiện trong “Bộ sưu tập Shiguang”.\n\n';

  @override
  String get event_memory_collection_confirm_delete_owned_item_message_unavailable =>
      'Điều này có nghĩa bạn sẽ từ bỏ vật phẩm giới hạn đã nhận lần này, và thao tác này không thể hoàn tác.\n\n';

  @override
  String
      event_memory_collection_confirm_delete_owned_item_message_delete_variant_b(
          Object value1) {
    return 'Bạn có chắc muốn xóa “$value1”?';
  }

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_delete_variant_c =>
          'Đã xóa vật phẩm giới hạn';

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_not_found_delete =>
          'Không tìm thấy vật phẩm giới hạn này, có thể nó đã bị xóa';

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_collection_current_delete =>
          'Hiện không thể xóa bộ sưu tập này';

  @override
  String get event_memory_collection_show_preview_message =>
      'Đang chuẩn bị ảnh';

  @override
  String get event_memory_collection_show_preview_message_failed_load =>
      'Không thể tải ảnh';

  @override
  String get event_memory_collection_save_to_gallery_message_save_current =>
      'Phiên bản web hiện chưa hỗ trợ lưu trực tiếp vào thư viện ảnh trên điện thoại';

  @override
  String get event_memory_collection_save_to_gallery_message_save_memory =>
      'Cần quyền truy cập thư viện ảnh để lưu ký ức này';

  @override
  String get event_memory_collection_save_to_gallery_message_memory =>
      'Ảnh ký ức chưa sẵn sàng. Vui lòng thử lại.';

  @override
  String get event_memory_collection_save_to_gallery_message_failed_memory =>
      'Không thể tạo ảnh ký ức';

  @override
  String get event_memory_collection_save_to_gallery_message_save =>
      'Đã lưu vào thư viện ảnh trên điện thoại ♡';

  @override
  String
      get event_memory_collection_save_to_gallery_message_save_confirm_failed =>
          'Lưu thất bại. Hãy kiểm tra quyền thư viện ảnh rồi thử lại.';

  @override
  String
      get event_memory_collection_delete_collection_title_collection_cancel =>
          'Bỏ khỏi bộ sưu tập?';

  @override
  String get event_memory_collection_delete_collection_message_collection_cancel_memory =>
      'Sau khi bỏ khỏi bộ sưu tập, ký ức này sẽ không còn xuất hiện trong “Bộ sưu tập Shiguang”.\n\nBạn có chắc muốn bỏ sưu tập?';

  @override
  String
      get event_memory_collection_delete_collection_message_try_again_later_collection_cancel_failed =>
          'Không thể bỏ khỏi bộ sưu tập. Vui lòng thử lại sau.';

  @override
  String get event_memory_collection_message_collection_memory =>
      'Bộ sưu tập ký ức';

  @override
  String get event_memory_collection_label_play => 'Phát lại';

  @override
  String get event_memory_collection_label_save => 'Đang lưu…';

  @override
  String get event_memory_collection_label_save_variant_b =>
      'Lưu vào thư viện ảnh';

  @override
  String get event_memory_collection_collected_card_message_limited_memory =>
      'Lianlian Shiguang・Ký ức giới hạn';

  @override
  String get event_memory_collection_create_state_message_end_story =>
      'Có những khoảnh khắc\nkhông biến mất chỉ vì câu chuyện đã kết thúc.';

  @override
  String get event_memory_collection_text_collection =>
      'Ký ức đã lưu này không có Scene nào có thể phát lại';

  @override
  String get event_memory_collection_message => 'Bỏ qua';

  @override
  String get event_memory_collection_message_end => 'Chạm để kết thúc';

  @override
  String get event_memory_collection_message_continue => 'Chạm để tiếp tục';

  @override
  String get event_memory_collection_message_variant_b =>
      'Chạm để hiển thị toàn bộ văn bản';

  @override
  String get event_memory_collection_collected_label_collection =>
      'Vừa sưu tập';

  @override
  String get event_memory_collection_collected_item_label_collection_date =>
      'Chưa ghi nhận ngày sưu tập';

  @override
  String event_memory_collection_collected_item_label_collection(
      Object day, Object month, Object value1) {
    return 'Đã sưu tập vào $value1/$month/$day';
  }

  @override
  String get event_memory_text_not_found_event =>
      'Không tìm thấy dữ liệu sự kiện';

  @override
  String get event_memory_message_limited_memory_failed_load =>
      'Không thể tải ký ức giới hạn';

  @override
  String get event_memory_as_map_label_unlocked => 'Đã mở khóa';

  @override
  String event_memory_as_map_label_unlock(Object currencyIcon,
      Object currencyName, Object currentValue, Object requiredValue) {
    return 'Tích lũy $currencyIcon $requiredValue $currencyName để mở khóa ($currentValue / $requiredValue)';
  }

  @override
  String get event_memory_as_map_label_unlock_task_event_complete =>
      'Mở khóa sau khi hoàn thành nhiệm vụ sự kiện được chỉ định';

  @override
  String get event_memory_as_map_label_redeem_unlock_event =>
      'Mở khóa sau khi đổi vật phẩm sự kiện được chỉ định';

  @override
  String get event_memory_as_map_label_unlock_variant_b => 'Chưa mở khóa';

  @override
  String get event_memory_hero_message =>
      'Hãy lưu lại trong mùa này một khoảnh khắc chỉ thuộc về hai người.';

  @override
  String event_memory_hero_message_limited_memory(
      Object totalCount, Object unlockedCount) {
    return 'Ký ức giới hạn  $unlockedCount / $totalCount';
  }

  @override
  String get event_memory_status_label_unlocked => 'Đã mở khóa・Chưa xem';

  @override
  String get event_memory_status_label => 'Đã xem';

  @override
  String get event_memory_status_label_collection => 'Đã sưu tập';

  @override
  String get event_memory_footer_label_memory_start =>
      'Bạn có thể bắt đầu ký ức này';

  @override
  String get event_memory_footer_label => 'Bạn có thể xem lại';

  @override
  String get event_memory_footer_label_collection =>
      'Đã lưu vào Bộ sưu tập Shiguang';

  @override
  String get event_memory_empty_message_limited_memory_event_public =>
      'Sự kiện này chưa công bố ký ức giới hạn nào';

  @override
  String get event_memory_performance_finish_message_memory =>
      'Ký ức này đã được lưu lại.';

  @override
  String get event_memory_performance_finish_message_save_collection =>
      'Bộ sưu tập được giữ trong trò chơi. Chỉ khi lưu vào điện thoại, hệ thống mới yêu cầu quyền thư viện ảnh.';

  @override
  String get event_memory_performance_finish_message => 'Đang xử lý…';

  @override
  String get event_memory_performance_finish_message_collection_memory =>
      'Sưu tập ký ức này';

  @override
  String get event_memory_performance_confirm_uncollect_memory_message_collection_cancel_memory_again_remove =>
      'Sau khi bỏ sưu tập, ký ức này sẽ bị xóa khỏi “Bộ sưu tập Shiguang”. Sau này bạn vẫn có thể xem lại và sưu tập lại.';

  @override
  String
      get event_memory_performance_uncollect_memory_message_collection_login =>
          'Vui lòng đăng nhập trước khi quản lý bộ sưu tập';

  @override
  String
      get event_memory_performance_collect_memory_message_collection_login_memory =>
          'Vui lòng đăng nhập trước khi sưu tập ký ức này';

  @override
  String
      get event_memory_performance_collect_memory_message_collection_memory =>
          'Đã sưu tập ký ức này ♡';

  @override
  String
      get event_memory_performance_collect_memory_message_try_again_later_collection_failed =>
          'Sưu tập thất bại. Vui lòng thử lại sau.';

  @override
  String get event_memory_performance_text_panel_message_complete =>
      'Chạm để hoàn tất';

  @override
  String get event_memory_performance_build_performance_message => 'Bỏ qua';

  @override
  String get event_memory_performance_text_play => 'Không có Scene nào để phát';

  @override
  String get event_memory_profile_change_profile_message_profile =>
      'Đổi Hồ sơ Shiguang';

  @override
  String get event_memory_profile_message_profile_confirm =>
      'Xác nhận Hồ sơ Shiguang';

  @override
  String get event_memory_profile_center_text_profile_not_found =>
      'Không tìm thấy Hồ sơ Shiguang khả dụng';

  @override
  String get event_memory_profile_center_message_memory =>
      'Bạn sẽ là ai trong ký ức này?';

  @override
  String get event_memory_profile_center_message_profile_character_start =>
      'Hồ sơ Shiguang bạn dùng gần đây nhất với nhân vật này đã được ưu tiên chọn. Bạn có thể đổi trước khi bắt đầu.';

  @override
  String event_memory_profile_center_message(Object value1) {
    return 'Với tư cách “$value1” cùng';
  }

  @override
  String event_memory_profile_center_message_memory_variant_b(Object value1) {
    return '“$value1” trong ký ức này';
  }

  @override
  String get event_memory_profile_center_label_memory_start => 'Bắt đầu ký ức';

  @override
  String get event_message_failed_load => 'Không thể tải dữ liệu sự kiện';

  @override
  String get event_message_not_found => 'Không tìm thấy sự kiện';

  @override
  String get event_remaining_label => 'Sự kiện đang diễn ra';

  @override
  String event_remaining_label_days(Object value1) {
    return 'Còn $value1 ngày';
  }

  @override
  String event_remaining_label_hours(Object value1) {
    return 'Còn $value1 giờ';
  }

  @override
  String get event_remaining_label_end => 'Sắp kết thúc';

  @override
  String get event_balance_pill_tooltip_back => 'Quay lại';

  @override
  String event_claim_task_message_claim_current(
      Object currency, Object reward, Object value1, Object value2) {
    return 'Đã nhận $value1 $reward $value2. Hiện bạn có $currency';
  }

  @override
  String get event_claim_task_message_reward_claim => 'Đã nhận phần thưởng';

  @override
  String get event_claim_task_message_claim_failed => 'Nhận thất bại';

  @override
  String get event_claim_task_message_task_claim =>
      'Nhiệm vụ này đã được nhận thưởng';

  @override
  String get event_claim_task_message_incomplete_task =>
      'Nhiệm vụ chưa hoàn thành';

  @override
  String get event_task_list_label_task_load => 'Đang tải nhiệm vụ…';

  @override
  String get event_task_list_label_task_current => 'Hiện không có nhiệm vụ';

  @override
  String get event_task_list_label_task_login_progress =>
      'Đăng nhập để xem tiến độ nhiệm vụ sự kiện';

  @override
  String get event_milestone_progress_label_reward_load =>
      'Đang tải phần thưởng tích lũy…';

  @override
  String get event_milestone_progress_label_reward_current =>
      'Hiện không có phần thưởng tích lũy';

  @override
  String event_build_with_total_message_current(Object totalEarned) {
    return 'Hiện tại  $totalEarned';
  }

  @override
  String get event_progress_ref_message_redeem_confirm => 'Xác nhận đổi';

  @override
  String event_progress_ref_message_redeem_flowers(
      Object itemName, Object price, Object rewardAmount, Object value1) {
    return 'Dùng $value1 $price để đổi “$itemName”?\n\nSau khi đổi, bạn sẽ nhận $rewardAmount Hoa.';
  }

  @override
  String event_progress_ref_message_redeem(
      Object itemName, Object price, Object value1) {
    return 'Dùng $value1 $price để đổi “$itemName”?';
  }

  @override
  String event_progress_ref_message_redeem_success_flowers(
      Object returnedReward) {
    return 'Đổi thành công! Nhận $returnedReward Hoa';
  }

  @override
  String event_progress_ref_message_event_collection_redeem_success_add(
      Object itemName) {
    return 'Đổi thành công! “$itemName” đã được thêm vào Bộ sưu tập sự kiện';
  }

  @override
  String get event_progress_ref_message_redeem_failed => 'Đổi thất bại';

  @override
  String get event_progress_ref_message_redeem_variant_b =>
      'Vật phẩm này đã được đổi rồi';

  @override
  String get event_progress_ref_message_insufficient => 'Không đủ tiền tệ';

  @override
  String event_progress_ref_message_insufficient_variant_b(Object value1) {
    return 'Không đủ $value1';
  }

  @override
  String get event_progress_ref_message_redeem_variant_c => 'Đổi';

  @override
  String get event_progress_ref_message_redeem_variant_d => 'Đã đổi';

  @override
  String event_message_redeem_flowers(Object rewardAmount) {
    return 'Sau khi đổi, bạn sẽ nhận $rewardAmount Hoa';
  }

  @override
  String event_message_redeem(Object redeemedCount) {
    return 'Đã đổi $redeemedCount lần';
  }

  @override
  String get event_message_event_shop_login =>
      'Đăng nhập để sử dụng cửa hàng sự kiện';

  @override
  String get event_message_redeem_current =>
      'Hiện không có vật phẩm nào có thể đổi';

  @override
  String event_shop_item_card_message_flowers(Object rewardAmount) {
    return 'Nhận $rewardAmount Hoa';
  }

  @override
  String get event_message_insufficient => 'Không đủ';

  @override
  String get notification_message_player => 'Ảnh đính kèm của người chơi';

  @override
  String notification_message_qixi_letter(Object value1) {
    return 'Thư Thất Tịch từ $value1';
  }

  @override
  String recommendation_remaining_label_days(Object value1) {
    return 'Còn $value1 ngày';
  }

  @override
  String recommendation_remaining_label_hours(Object value1) {
    return 'Còn $value1 giờ';
  }

  @override
  String get settings_subtitle_character_days =>
      'Để nhân vật bạn yêu thích đồng hành cùng bạn mỗi ngày';

  @override
  String moment_notification_comment_on_character_post(
      Object authorName, Object commentText, Object senderNickname) {
    return '$senderNickname đã để lại lời nhắn cho $authorName: “$commentText”';
  }

  @override
  String get inbox_content_text_message_customer_service_message_send =>
      'Tin nhắn hỗ trợ khách hàng đã gửi';

  @override
  String get character_edit_relationship_none_label => 'Không có';

  @override
  String get auth_cancel_account_deletion_failed =>
      'Không thể hủy xóa tài khoản. Vui lòng thử lại sau.';

  @override
  String get auth_delete_account_failed => 'Không thể xóa tài khoản';

  @override
  String get auth_request_account_deletion_failed =>
      'Không thể yêu cầu xóa tài khoản. Vui lòng thử lại sau.';

  @override
  String get theme_font_shiguang_serif => 'Shiguang Serif';

  @override
  String get theme_font_clean_sans => 'Sans Thanh Nhã';

  @override
  String get theme_font_system => 'Phông hệ thống';

  @override
  String get theme_font_shiguang_serif_description =>
      'Mềm mại và giàu chất văn, phù hợp để đọc nhập tâm';

  @override
  String get theme_font_clean_sans_description =>
      'Rõ ràng, gọn gàng, thoải mái khi đọc lâu';

  @override
  String get theme_font_system_description =>
      'Dùng phông hệ thống mặc định của thiết bị';

  @override
  String get font_selection_serif_name => 'Noto Serif TC';

  @override
  String get font_selection_sans_name => 'Noto Sans TC';

  @override
  String get font_selection_system_name => 'Phông chữ hệ thống';

  @override
  String get font_selection_serif_description =>
      'Phông chữ có chân thanh lịch, phù hợp để đọc nhập tâm.';

  @override
  String get font_selection_sans_description =>
      'Phông chữ không chân rõ ràng, dịu mắt.';

  @override
  String get font_selection_system_description =>
      'Sử dụng phông chữ mặc định của thiết bị.';

  @override
  String get font_selection_preview_sentence =>
      'Viết tiếp một chương câu chuyện của riêng hai người cùng người bạn yêu mến.';

  @override
  String get avatar_frame_error_generic => 'Lỗi';

  @override
  String get avatar_frame_sign_in_required => 'Vui lòng đăng nhập trước';

  @override
  String get avatar_frame_default_name => 'Khung ảnh đại diện sự kiện';

  @override
  String get background_exclusive_photos_tab => 'Ảnh độc quyền';

  @override
  String get background_world_sign_in_chat =>
      'Vui lòng đăng nhập và vào cuộc trò chuyện thế giới';

  @override
  String get background_world_photo_load_error => 'Lỗi';

  @override
  String get background_world_no_photos => 'Không có ảnh thế giới để chọn';

  @override
  String get background_world_cover => 'Ảnh bìa thế giới';

  @override
  String get background_world_cover_confirm =>
      'Đặt ảnh bìa thế giới làm hình nền cho cuộc trò chuyện này?';

  @override
  String get background_world_default_limited => 'Hình nền giới hạn';

  @override
  String get background_world_default_character => 'Nhân vật';

  @override
  String get background_world_no_character_photos =>
      'Không có ảnh nhân vật khả dụng';

  @override
  String background_world_unlock_required(int count) {
    return 'Cần $count điểm thiện cảm để mở khóa';
  }

  @override
  String background_world_character_confirm(String name) {
    return 'Đặt ảnh của $name làm hình nền cuộc trò chuyện thế giới?';
  }

  @override
  String background_world_affection_count(int count) {
    return '$count thiện cảm';
  }

  @override
  String get reply_selection => 'Tùy chọn trả lời';

  @override
  String get chat_home_character_tab => 'Trò chuyện với nhân vật';

  @override
  String get chat_home_world_tab => 'Thế giới mở';

  @override
  String get chat_home_world_error_generic => 'Lỗi';

  @override
  String get chat_home_world_pinned => 'Đã ghim cuộc trò chuyện thế giới';

  @override
  String get chat_home_world_deleted =>
      'Đã xóa cuộc trò chuyện và lịch sử của thế giới';

  @override
  String get chat_home_world_action_done => 'Hoàn tất';

  @override
  String get chat_home_world_rename_title => 'Đặt tên cho ký ức này';

  @override
  String chat_home_world_delete_confirm(String name) {
    return 'Xóa lịch sử trò chuyện của “$name”?\n\nHội thoại, tóm tắt truyện, các mối quan hệ và ghi chú sẽ bị xóa vĩnh viễn, không thể khôi phục. Thế giới đã công bố của tác giả vẫn được giữ nguyên.';
  }

  @override
  String get chat_home_world_empty_title =>
      'Chưa có cuộc trò chuyện Thế giới mở';

  @override
  String get chat_home_world_empty_desc =>
      'Bắt đầu chơi trong Thế giới mở để xem cuộc trò chuyện tại đây.';

  @override
  String get chat_home_world_unnamed => 'Thế giới chưa đặt tên';

  @override
  String get chat_home_world_private_test => 'Chơi thử riêng tư';

  @override
  String get chat_home_world_no_messages => 'Chưa có tin nhắn';

  @override
  String get expand_features => 'Hiển thị thêm tính năng';

  @override
  String get chat_sticker_all => 'Tất cả';

  @override
  String get chat_mode_short_daily => 'Hằng ngày';

  @override
  String get chat_mode_short_story => 'Cốt truyện';

  @override
  String get chat_mode_short_immersive => 'Nhập vai';

  @override
  String get chat_mode_short_resonance => 'Cộng hưởng';

  @override
  String get chat_mode_short_gemini => 'Trò chuyện';

  @override
  String get chat_theater_tool => 'Nhà hát';

  @override
  String chat_regenerate_insufficient_flowers(int cost) {
    return 'Không đủ Hoa. Tạo lại cần $cost Hoa.';
  }

  @override
  String get chat_regenerate_paid_title => 'Tạo lại có phí';

  @override
  String chat_regenerate_paid_confirm(int cost) {
    return 'Bạn đã dùng hết lượt tạo lại miễn phí hôm nay. Ở chế độ hiện tại, lần này tốn $cost Hoa. Tiếp tục?';
  }

  @override
  String get chat_generic_error => 'Lỗi';

  @override
  String get chat_regenerate_confirm => 'Xác nhận';

  @override
  String get comment_add_photo => 'Thêm ảnh';

  @override
  String get comment_error_generic => 'Lỗi';

  @override
  String creator_profile_report_reason_prompt(String creatorName) {
    return 'Chọn lý do báo cáo “$creatorName”:';
  }

  @override
  String get creator_profile_open_worlds => 'Thế giới mở';

  @override
  String get creator_profile_generic_error => 'Lỗi';

  @override
  String get creator_profile_refresh => 'Làm mới';

  @override
  String get creator_profile_no_open_worlds =>
      'Nhà sáng tạo này chưa xuất bản thế giới mở nào.';

  @override
  String get creator_profile_unnamed_world => 'Thế giới chưa có tên';

  @override
  String get creator_program_required_fields =>
      'Vui lòng nhập định hướng sáng tác và lý do đăng ký.';

  @override
  String get creator_program_submitted =>
      'Đã gửi đơn đăng ký. Thời gian xét duyệt khoảng 1–3 ngày.';

  @override
  String get creator_program_error => 'Lỗi';

  @override
  String get creator_program_login_required =>
      'Vui lòng đăng nhập trước khi đăng ký chương trình nhà sáng tạo.';

  @override
  String get creator_program_title => 'Chương trình nhà sáng tạo';

  @override
  String get creator_program_headline =>
      'Để nhiều người biết đến tác phẩm của bạn hơn';

  @override
  String get creator_program_intro =>
      'Nếu có tác phẩm công khai, bạn có thể đăng ký tham gia chương trình nhà sáng tạo 《戀戀拾光》. Đơn sẽ được xét duyệt trong 1–3 ngày.';

  @override
  String get creator_program_benefits_title => 'Quyền lợi chương trình';

  @override
  String get creator_program_benefit_dashboard =>
      'Bảng điều khiển nhà sáng tạo: xem số người theo dõi, nhân vật công khai, tổng lượt thích và người theo dõi mới trong tháng.';

  @override
  String get creator_program_benefit_fans =>
      'Quản lý người hâm mộ: gửi thư, quản lý fan và tặng phúc lợi bằng hoa của bạn.';

  @override
  String get creator_program_benefit_exposure =>
      'Quảng bá chính thức: nhân vật mới có cơ hội được giới thiệu trên Instagram và trong đề xuất của trò chơi.';

  @override
  String get creator_program_benefit_monthly =>
      'Thưởng sáng tác hằng tháng: công khai ít nhất 3 nhân vật mới trong tháng để nhận 520 hoa vào tháng sau.';

  @override
  String get creator_program_benefit_merch =>
      'Hợp tác sản phẩm: nếu nhân vật của bạn tham gia dự án sản phẩm hoặc hộp quà chính thức, bạn có thể nhận thưởng tiền mặt theo từng dự án.';

  @override
  String creator_program_last_review_note(String reason) {
    return 'Ghi chú xét duyệt lần trước: $reason';
  }

  @override
  String get creator_program_apply_heading => 'Đăng ký tham gia';

  @override
  String get creator_program_direction_label => 'Định hướng sáng tác';

  @override
  String get creator_program_direction_hint =>
      'Ví dụ: tình cảm hiện đại, cổ trang, kỳ ảo, BL, GL…';

  @override
  String get creator_program_reason_label => 'Lý do muốn tham gia';

  @override
  String get creator_program_reason_hint =>
      'Hãy chia sẻ cách bạn muốn phát triển nhân vật và kết nối với người hâm mộ.';

  @override
  String get creator_program_social_label =>
      'Liên kết mạng xã hội (không bắt buộc)';

  @override
  String get creator_program_social_hint =>
      'Instagram, Threads, trang web cá nhân, v.v.';

  @override
  String get creator_program_submit => 'Gửi đơn đăng ký';

  @override
  String get creator_program_public_character_note =>
      'Trước khi gửi, hệ thống sẽ kiểm tra tài khoản có ít nhất 1 nhân vật công khai.';

  @override
  String get creator_program_status_pending => 'Đang xét duyệt đơn';

  @override
  String get creator_program_status_pending_desc =>
      'Đã nhận đơn. Xét duyệt khoảng 1–3 ngày. Kết quả sẽ được thông báo qua hộp thư trong trò chơi.';

  @override
  String get creator_program_status_approved =>
      'Đã duyệt tư cách nhà sáng tạo 🎉';

  @override
  String get creator_program_status_approved_desc =>
      'Chúc mừng bạn tham gia chương trình nhà sáng tạo 《戀戀拾光》! Bảng điều khiển, quản lý fan và biểu ngữ đề xuất sẽ liên kết với trạng thái này trong các tính năng sắp tới.';

  @override
  String get creator_program_status_suspended =>
      'Tạm đình chỉ tư cách nhà sáng tạo';

  @override
  String get creator_program_status_suspended_desc =>
      'Các tính năng dành riêng cho nhà sáng tạo tạm thời không khả dụng. Hãy xem thông báo chính thức trong hộp thư trò chơi.';

  @override
  String get creator_program_status_revoked =>
      'Đã thu hồi tư cách nhà sáng tạo';

  @override
  String get creator_program_status_revoked_desc =>
      'Các tính năng riêng cho nhà sáng tạo không còn khả dụng. Nếu có thắc mắc, hãy liên hệ hỗ trợ.';

  @override
  String get creator_program_status_title => 'Trạng thái nhà sáng tạo';

  @override
  String creator_program_current_status(String status) {
    return 'Trạng thái hiện tại: $status';
  }

  @override
  String creator_program_official_note(String reason) {
    return 'Ghi chú chính thức: $reason';
  }

  @override
  String get creator_dashboard_error1 => 'Lỗi';

  @override
  String get creator_dashboard_access_title1 => 'Bảng điều khiển nhà sáng tạo';

  @override
  String get creator_dashboard_status_notice_title1 =>
      'Creator Dashboard Access Notice';

  @override
  String get creator_dashboard_apply_title1 =>
      'Đăng ký bảng điều khiển nhà sáng tạo';

  @override
  String get creator_dashboard_access_subtitle1 =>
      'Thống kê lượt chơi nhân vật · Người theo dõi tăng/giảm · Quản lý người theo dõi';

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
  String get creator_dashboard_my_characters1 => 'Nhân vật của tôi';

  @override
  String get creator_dashboard_my_worlds1 => 'Thế giới mở của tôi';

  @override
  String get creator_dashboard_create_world1 => 'Tạo thế giới mở';

  @override
  String get creator_dashboard_public_worlds1 => 'Thế giới đã công khai';

  @override
  String get creator_dashboard_public_worlds_hint1 =>
      'Other players can explore';

  @override
  String get creator_dashboard_private_worlds1 => 'Thế giới riêng tư';

  @override
  String get creator_dashboard_private_worlds_hint1 =>
      'Only you can view and edit';

  @override
  String get creator_dashboard_world_drafts1 => 'Bản nháp thế giới';

  @override
  String get creator_dashboard_world_drafts_hint1 => 'Worlds not yet finished';

  @override
  String get creator_dashboard_no_drafts1 => 'No drafts yet';

  @override
  String get creator_dashboard_no_worlds1 => 'No worlds yet';

  @override
  String get creator_dashboard_unnamed_world1 => 'Thế giới chưa đặt tên';

  @override
  String get creator_dashboard_delete_world_draft1 => 'Delete world draft';

  @override
  String get creator_dashboard_private_test1 => 'Thử nghiệm riêng tư';

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
  String get creator_dashboard_confirm_send1 => 'Xác nhận gửi';

  @override
  String get creator_dashboard_form_heading1 =>
      'Apply for the Lianlian Shiguang Creator Dashboard';

  @override
  String get creator_dashboard_form_description1 =>
      'Tell us about your creative direction and how you plan to use character analytics and follower management. This is not a partnership contract.';

  @override
  String get creator_dashboard_direction_label1 => 'Định hướng sáng tác';

  @override
  String get creator_dashboard_direction_hint1 =>
      'Ví dụ: tình cảm hiện đại, cổ trang, kỳ ảo, BL, GL…';

  @override
  String get creator_dashboard_reason_label1 => 'Lý do đăng ký bảng điều khiển';

  @override
  String get creator_dashboard_reason_hint1 =>
      'Share your experience and which dashboard features you need';

  @override
  String get creator_dashboard_sending1 => 'Đang gửi…';

  @override
  String get creator_dashboard_submit1 =>
      'Gửi yêu cầu truy cập bảng điều khiển';

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
  String get creator_support_page_title1 => 'Trung tâm hỗ trợ';

  @override
  String get creator_support_new_report1 => 'Gửi báo cáo mới';

  @override
  String get creator_support_error1 => 'Lỗi';

  @override
  String get creator_support_no_cases1 => 'Chưa có báo cáo nào';

  @override
  String get creator_support_unread1 => 'Chưa đọc';

  @override
  String get creator_support_load_more1 => 'Tải thêm';

  @override
  String get creator_support_category_label1 => 'Loại vấn đề';

  @override
  String get creator_support_character_optional1 =>
      'Nhân vật liên quan (tùy chọn)';

  @override
  String get creator_support_no_character1 => 'Không chọn nhân vật';

  @override
  String get creator_support_report_title1 => 'Tiêu đề vấn đề';

  @override
  String get creator_support_report_description1 => 'Mô tả vấn đề';

  @override
  String creator_support_select_images1(int count) {
    return 'Chọn ảnh chụp ($count/3, dưới 2 MB mỗi ảnh)';
  }

  @override
  String get creator_support_images_private1 =>
      'Chỉ nhà sáng tạo và đội ngũ chính thức xem được ảnh.';

  @override
  String get creator_support_submitting1 => 'Đang gửi…';

  @override
  String get creator_support_submit1 => 'Xác nhận gửi';

  @override
  String get creator_support_image_too_large1 =>
      'Ảnh vượt quá 2 MB. Hãy chọn ảnh khác.';

  @override
  String get creator_support_fill_title_description1 =>
      'Vui lòng nhập tiêu đề và nội dung.';

  @override
  String get creator_support_case_sent1 => 'Đã gửi báo cáo';

  @override
  String creator_support_case_sent_partial1(int count) {
    return 'Đã gửi báo cáo nhưng tải lên thất bại $count ảnh';
  }

  @override
  String get creator_support_detail_title1 => 'Chi tiết báo cáo';

  @override
  String get creator_support_image_max1 => 'Mỗi ảnh phải dưới 2 MB';

  @override
  String get creator_support_jpg_png_only1 => 'Chỉ hỗ trợ JPG / PNG';

  @override
  String get creator_support_reply_sent1 => 'Đã gửi trả lời';

  @override
  String creator_support_reply_sent_partial1(int count) {
    return 'Đã gửi nội dung nhưng tải lên thất bại $count ảnh';
  }

  @override
  String get creator_support_empty_content1 => 'Nội dung không được để trống';

  @override
  String get creator_support_recall_message1 => 'Thu hồi tin nhắn';

  @override
  String get creator_support_delete_message1 => 'Xóa tin nhắn';

  @override
  String get creator_support_recall_warning1 =>
      'Cả hai bên sẽ thấy “Tin nhắn đã được thu hồi”; tệp đính kèm không thể xem.';

  @override
  String get creator_support_delete_warning1 =>
      'Chỉ ẩn trên màn hình của bạn; bên kia vẫn giữ tin nhắn.';

  @override
  String get creator_support_cancel1 => 'Hủy';

  @override
  String get creator_support_confirm1 => 'Xác nhận';

  @override
  String get creator_support_operation_success1 => 'Thao tác thành công';

  @override
  String get creator_support_edit_message1 => 'Chỉnh sửa tin nhắn';

  @override
  String creator_support_recall_remaining1(int seconds) {
    return 'Thu hồi tin nhắn (còn $seconds giây)';
  }

  @override
  String get creator_support_recall_expired1 =>
      'Thu hồi tin nhắn (quá 60 giây)';

  @override
  String get creator_support_case_updated1 => 'Đã cập nhật báo cáo';

  @override
  String get creator_support_loading1 => 'Đang tải…';

  @override
  String creator_support_creator_uid1(String uid) {
    return 'UID nhà sáng tạo: $uid';
  }

  @override
  String get creator_support_internal_note1 =>
      'Ghi chú nội bộ (ẩn với nhà sáng tạo)';

  @override
  String get creator_support_save_internal_note1 => 'Lưu ghi chú nội bộ';

  @override
  String get creator_support_case_images1 => 'Ảnh chụp báo cáo';

  @override
  String get creator_support_official1 =>
      'Đội ngũ chính thức Lianlian Shiguang';

  @override
  String get creator_support_creator1 => 'Nhà sáng tạo';

  @override
  String get creator_support_recalled1 => 'Tin nhắn đã được thu hồi';

  @override
  String get creator_support_edited1 => 'Đã chỉnh sửa';

  @override
  String get creator_support_reply_hint1 => 'Nhập trả lời…';

  @override
  String get creator_support_attach_image1 => 'Đính kèm ảnh (tối đa 3)';

  @override
  String get creator_support_send1 => 'Gửi';

  @override
  String get creator_support_admin_title1 => 'Quản lý báo cáo nhà sáng tạo';

  @override
  String get creator_support_new_reply1 => 'Trả lời mới';

  @override
  String get creator_support_load_more_cases1 => 'Tải thêm báo cáo';

  @override
  String get creator_support_image_load_error1 => 'Không tải được ảnh chụp';

  @override
  String get creator_support_edit_hint1 => 'Chỉnh sửa nội dung tin nhắn';

  @override
  String get creator_support_save1 => 'Lưu';

  @override
  String get creator_support_status_pending1 => 'Chờ xử lý';

  @override
  String get creator_support_status_progress1 => 'Đang xử lý';

  @override
  String get creator_support_status_waiting1 => 'Chờ bổ sung';

  @override
  String get creator_support_status_resolved1 => 'Đã giải quyết';

  @override
  String get creator_support_cat_character1 => 'Quản lý nhân vật';

  @override
  String get creator_support_cat_ai1 => 'Lỗi tương tác nhân vật AI';

  @override
  String get creator_support_cat_dashboard1 => 'Bảng điều khiển nhà sáng tạo';

  @override
  String get creator_support_cat_cooperation1 => 'Hợp tác và quyền lợi';

  @override
  String get creator_support_cat_other1 => 'Vấn đề khác';

  @override
  String get desktop_widget_size_small1 => 'Nhỏ';

  @override
  String get desktop_widget_size_medium1 => 'Vừa';

  @override
  String get desktop_widget_size_large1 => 'Lớn';

  @override
  String get desktop_widget_cancel1 => 'Hủy';

  @override
  String get desktop_widget_delete1 => 'Xóa';

  @override
  String desktop_widget_days_remaining1(int days) {
    return 'Còn $days ngày';
  }

  @override
  String get desktop_widget_days_today1 => 'Chính là hôm nay';

  @override
  String desktop_widget_days_elapsed1(int days) {
    return 'Đã qua $days ngày';
  }

  @override
  String get desktop_widget_daily_quote1 => 'Câu nói hôm nay';

  @override
  String get desktop_widget_update_daily1 => 'Cập nhật mỗi ngày một lần';

  @override
  String get desktop_widget_character_birthday1 => 'Sinh nhật nhân vật';

  @override
  String get desktop_widget_change1 => 'Thay đổi';

  @override
  String get desktop_widget_mood1 => 'Tâm trạng';

  @override
  String get desktop_widget_current_state1 => 'Trạng thái hiện tại';

  @override
  String get desktop_widget_location1 => 'Địa điểm';

  @override
  String get desktop_widget_relationship1 => 'Mối quan hệ';

  @override
  String get desktop_widget_outfit1 => 'Trang phục';

  @override
  String get desktop_widget_weather1 => 'Thời tiết';

  @override
  String get desktop_widget_thought1 => 'Suy nghĩ';

  @override
  String get desktop_widget_action1 => 'Hành động';

  @override
  String get desktop_widget_affinity1 => 'Độ thiện cảm';

  @override
  String get desktop_widget_character_status1 => 'Trạng thái nhân vật';

  @override
  String get desktop_widget_no_posts1 => 'Chưa có bài đăng của nhân vật';

  @override
  String get desktop_widget_crop_position1 => 'Điều chỉnh vị trí nhân vật';

  @override
  String get desktop_widget_crop_action1 => 'Phóng to / kéo để căn khung';

  @override
  String get desktop_widget_crop_hint1 =>
      'Dùng hai ngón để thu phóng và một ngón để kéo, không làm cuộn cả trang.';

  @override
  String get desktop_widget_crop_title1 => 'Điều chỉnh khung hình nhân vật';

  @override
  String get desktop_widget_reset1 => 'Đặt lại';

  @override
  String get desktop_widget_crop_instructions1 =>
      'Kéo một ngón để di chuyển và dùng hai ngón để đổi kích thước. Khung hiển thị vùng sẽ xuất hiện trên tiện ích.';

  @override
  String desktop_widget_crop_position_scale1(int x, int y, String scale) {
    return 'Vị trí: $x% / $y% · Thu phóng: $scale×';
  }

  @override
  String get desktop_widget_apply1 => 'Áp dụng';

  @override
  String get desktop_widget_just_posted1 => 'Vừa cập nhật bài đăng';

  @override
  String get desktop_widget_important_day1 => 'Ngày quan trọng';

  @override
  String get desktop_widget_no_date1 => 'Chưa chọn ngày';

  @override
  String get desktop_widget_first_met1 => 'Ngày gặp anh ấy';

  @override
  String get desktop_widget_error1 => 'Lỗi';

  @override
  String get event_memory_select_character_title1 => 'Chọn nhân vật';

  @override
  String get event_memory_my_characters1 => 'Nhân vật của tôi';

  @override
  String get event_memory_friend_characters1 => 'Nhân vật bạn bè';

  @override
  String get event_memory_friend_badge1 => 'Bạn bè';

  @override
  String get event_memory_unnamed_character1 => 'Nhân vật chưa đặt tên';

  @override
  String get event_memory_generic_error1 => 'Lỗi';

  @override
  String get memory_collection_title1 => 'Bộ sưu tập ký ức';

  @override
  String get memory_collection_avatar_frames1 => 'Khung ảnh đại diện';

  @override
  String get memory_collection_stickers1 => 'Nhãn dán';

  @override
  String get memory_collection_memories1 => 'Ký ức';

  @override
  String get memory_collection_try_again1 => 'Vui lòng thử lại sau.';

  @override
  String get memory_collection_error1 => 'Lỗi';

  @override
  String get memory_collection_chat_background1 => 'Hình nền trò chuyện';

  @override
  String get memory_collection_got_it1 => 'Đã hiểu';

  @override
  String get memory_collection_not_now1 => 'Để sau';

  @override
  String get memory_collection_confirm_delete1 => 'Xác nhận xóa';

  @override
  String get memory_collection_close1 => 'Đóng';

  @override
  String get memory_collection_delete1 => 'Xóa';

  @override
  String get memory_collection_image_preparing1 => 'Đang chuẩn bị ảnh';

  @override
  String get memory_collection_remove_favorite1 => 'Xóa khỏi bộ sưu tập';

  @override
  String get memory_collection_removed1 => 'Đã xóa khỏi bộ sưu tập';

  @override
  String get event_memory_performance_opening1 =>
      'Có những khoảnh khắc vẫn còn mãi,\ndù câu chuyện đã khép lại.';

  @override
  String get event_memory_performance_generic_error1 => 'Lỗi';

  @override
  String get event_memory_performance_collected1 => 'Đã lưu';

  @override
  String get event_memory_performance_saving1 => 'Đang lưu…';

  @override
  String get event_memory_performance_save_gallery1 => 'Lưu vào thư viện ảnh';

  @override
  String get event_memory_performance_done1 => 'Hoàn tất';

  @override
  String get event_memory_performance_uncollect_title1 => 'Bỏ khỏi bộ sưu tập?';

  @override
  String get event_memory_performance_not_now1 => 'Để sau';

  @override
  String get event_memory_performance_uncollect1 => 'Bỏ khỏi bộ sưu tập';

  @override
  String get event_memory_performance_uncollected1 => 'Đã bỏ khỏi bộ sưu tập';

  @override
  String get event_memory_performance_login_to_collect1 =>
      'Đăng nhập để lưu kỷ niệm này';

  @override
  String get event_memory_performance_web_gallery_unsupported1 =>
      'Bản web chưa hỗ trợ lưu trực tiếp vào thư viện ảnh điện thoại';

  @override
  String get event_memory_performance_gallery_permission1 =>
      'Cần quyền truy cập ảnh để lưu kỷ niệm này';

  @override
  String get event_memory_performance_image_not_ready1 =>
      'Ảnh kỷ niệm chưa sẵn sàng. Vui lòng thử lại';

  @override
  String get event_memory_performance_gallery_saved1 =>
      'Đã lưu vào thư viện ảnh';

  @override
  String get event_memory_performance_skip1 => 'Bỏ qua';

  @override
  String get event_memory_performance_memory_label1 => 'Kỷ niệm';

  @override
  String get event_memory_performance_tap_continue1 => 'Chạm để tiếp tục';

  @override
  String get event_memory_performance_tap_show_full1 =>
      'Chạm để xem toàn bộ nội dung';

  @override
  String get event_memory_performance_brand_limited_memory1 =>
      'Lianlian Shiguang · Kỷ niệm giới hạn';

  @override
  String get event_ended1 => 'Sự kiện đã kết thúc';

  @override
  String get event_default_name1 => 'Sự kiện giới hạn thời gian';

  @override
  String get event_default_subtitle1 =>
      'Cùng anh ấy tạo những kỷ niệm đặc biệt mùa này.';

  @override
  String get event_currency_default1 => 'Tiền sự kiện';

  @override
  String get event_tasks_today1 => 'Nhiệm vụ hôm nay';

  @override
  String event_tasks_subtitle1(String currency) {
    return 'Hoàn thành nhiệm vụ, thu thập $currency và mở khóa nội dung độc quyền.';
  }

  @override
  String get event_milestones_title1 => 'Tiến độ tích lũy';

  @override
  String event_milestones_subtitle1(String currency) {
    return 'Tích lũy $currency để nhận thưởng độc quyền.';
  }

  @override
  String get event_memory_title1 => 'Kỷ niệm độc quyền';

  @override
  String get event_memory_subtitle1 => 'Lưu giữ kỷ niệm riêng của sự kiện.';

  @override
  String get event_shop_title1 => 'Cửa hàng sự kiện';

  @override
  String event_shop_subtitle1(String currency) {
    return 'Dùng $currency đổi phần thưởng độc quyền.';
  }

  @override
  String get event_info_title1 => 'Thông tin sự kiện';

  @override
  String get event_info_default1 =>
      'Hoàn thành nhiệm vụ chỉ định để nhận tiền sự kiện.\nPhần thưởng đổi sẽ được gửi theo quy định.\nTiền chưa sử dụng sẽ được xử lý theo quy định khi sự kiện kết thúc.';

  @override
  String get event_generic_error1 => 'Lỗi';

  @override
  String get event_task_default1 => 'Nhiệm vụ sự kiện';

  @override
  String get event_claimed1 => 'Đã nhận';

  @override
  String get event_claim1 => 'Nhận';

  @override
  String get event_in_progress1 => 'Đang tiến hành';

  @override
  String get event_reward_default1 => 'Phần thưởng độc quyền';

  @override
  String get event_product_default1 => 'Vật phẩm sự kiện';

  @override
  String get event_cancel1 => 'Hủy';

  @override
  String get event_confirm_exchange1 => 'Xác nhận đổi';

  @override
  String get event_limited_product1 => 'Vật phẩm độc quyền';

  @override
  String event_insufficient_currency1(String currency) {
    return 'Không đủ $currency';
  }

  @override
  String get event_close1 => 'Đóng';

  @override
  String event_redeemed_count_limit1(int count, int max) {
    return 'Đã đổi $count / $max lần';
  }

  @override
  String event_redeemed_count1(int count) {
    return 'Đã đổi $count lần';
  }

  @override
  String get event_redeemed1 => 'Đã đổi';

  @override
  String get event_exchange1 => 'Đổi';

  @override
  String get login_account_deletion_started1 => 'Tài khoản đang được xóa';

  @override
  String get login_account_deletion_expired_description1 =>
      'Đã hết thời hạn ba ngày để hủy xóa tài khoản. Không thể khôi phục tài khoản này nữa. Vui lòng liên hệ bộ phận hỗ trợ nếu cần trợ giúp.';

  @override
  String get login_account_deletion_confirm1 => 'Đồng ý';

  @override
  String get event_memory_limited_title1 => 'Kỷ niệm độc quyền';

  @override
  String get moment_detail_add_photo1 => 'Thêm ảnh';

  @override
  String get moment_detail_error1 => 'Lỗi';

  @override
  String get notification_claim_before_delete1 =>
      'Nhận hoa trước khi xóa thư quà tặng';

  @override
  String get notification_error1 => 'Lỗi';

  @override
  String get notification_creator_gift_already_claimed1 =>
      'Bạn đã nhận số hoa này rồi';

  @override
  String notification_creator_gift_claim_success1(Object amount) {
    return 'Đã nhận thành công $amount bông hoa!';
  }

  @override
  String get notification_creator_gift_title1 => 'Quà tặng từ nhà sáng tạo';

  @override
  String notification_creator_gift_amount1(Object amount) {
    return '$amount bông hoa';
  }

  @override
  String get notification_creator_gift_claimed1 => 'Đã nhận';

  @override
  String get notification_creator_gift_claiming1 => 'Đang nhận…';

  @override
  String get notification_creator_gift_claim_button1 => 'Nhận hoa';

  @override
  String get notification_support_subject1 => 'Tiêu đề người chơi gửi';

  @override
  String get notification_support_content1 => 'Nội dung người chơi gửi';

  @override
  String get notification_support_reported1 => 'Nội dung bị báo cáo';

  @override
  String get notification_support_reply1 => 'Phản hồi hỗ trợ';

  @override
  String get notification_share_mail1 => 'Chia sẻ thư';

  @override
  String get notification_original_question1 => 'Câu hỏi ban đầu của bạn';

  @override
  String get notification_preferences_chat_title1 => 'Trò chuyện với nhân vật';

  @override
  String get notification_preferences_chat_subtitle1 =>
      'Thông báo đẩy khi nhân vật trả lời';

  @override
  String get notification_preferences_moments_title1 => 'Bài đăng mới';

  @override
  String get notification_preferences_moments_subtitle1 =>
      'Bài đăng mới từ nhà sáng tạo và nhân vật bạn theo dõi';

  @override
  String get notification_preferences_social_title1 => 'Thông báo xã hội';

  @override
  String get notification_preferences_social_subtitle1 =>
      'Lượt thích, bình luận, theo dõi và tương tác với nhân vật';

  @override
  String get notification_preferences_announcements_title1 =>
      'Thông báo chính thức';

  @override
  String get notification_preferences_announcements_subtitle1 =>
      'Thông báo đẩy về các thông báo chính thức';

  @override
  String get notification_preferences_events_title1 => 'Nhắc nhở sự kiện';

  @override
  String get notification_preferences_events_subtitle1 =>
      'Thông báo khi sự kiện sắp kết thúc';

  @override
  String get notification_preferences_save_failed1 =>
      'Không thể lưu cài đặt thông báo. Vui lòng thử lại sau.';

  @override
  String get notification_preferences_page_title1 => 'Tùy chọn thông báo';

  @override
  String get notification_preferences_login_required1 =>
      'Vui lòng đăng nhập vào tài khoản trước';

  @override
  String get notification_preferences_load_failed1 =>
      'Không thể tải tùy chọn thông báo. Vui lòng thử lại sau.';

  @override
  String get notification_preferences_footer1 =>
      'Các cài đặt này được đồng bộ trên mọi thiết bị dùng cùng tài khoản người chơi. Quyền thông báo của hệ thống phải được thiết lập riêng trên từng thiết bị. Tắt thông báo đẩy sẽ không xóa hộp thư trong trò chơi hoặc những thông báo đã nhận.';

  @override
  String get official_studio_text_0011 =>
      'Guide completed, but the viewed status could not sync and may appear again.';

  @override
  String get official_studio_text_0021 => 'Vui lòng đăng nhập trước';

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
  String get official_studio_text_0101 => 'Quản lý người theo dõi';

  @override
  String get official_studio_text_0111 => 'View and remove followers';

  @override
  String get official_studio_text_0121 => 'Thống kê nhà sáng tạo';

  @override
  String get official_studio_text_0131 =>
      'Character popularity and total play count';

  @override
  String get official_studio_text_0141 => 'Thư người hâm mộ';

  @override
  String get official_studio_text_0151 => 'Send messages to your followers';

  @override
  String get official_studio_text_0161 => 'Fan Benefits';

  @override
  String get official_studio_text_0171 => 'Gift your own flowers to followers';

  @override
  String get official_studio_text_0181 => 'Thưởng sáng tạo hàng tháng';

  @override
  String get official_studio_text_0191 =>
      'Publish 3 new characters to claim 300 flowers';

  @override
  String get official_studio_text_0201 => 'Ảnh bìa nhà sáng tạo';

  @override
  String get official_studio_text_0211 => 'Set your public creator-page banner';

  @override
  String get official_studio_text_0221 => 'Thông tin hợp tác';

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
  String get official_studio_text_0431 => 'Hủy';

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
  String get official_studio_text_1141 => 'Đến cửa hàng';

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
  String get official_studio_text_1281 => 'Tìm người theo dõi';

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
  String get official_studio_text_1731 => 'Bỏ qua';

  @override
  String get official_studio_text_1741 => 'Trước';

  @override
  String get official_studio_text_1751 => 'Hoàn tất';

  @override
  String get official_studio_text_1761 => 'Tiếp theo';

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
  String get preference_selection_title1 => 'Chọn kiểu nhân vật bạn yêu thích';

  @override
  String get preference_selection_description1 =>
      'Chọn 3–5 thẻ bạn thích để nhận gợi ý nhân vật hợp gu hơn.';

  @override
  String get preference_selection_recommendation_note1 =>
      'Các sở thích này chỉ giúp cải thiện đề xuất. Bạn vẫn có thể khám phá những kiểu nhân vật khác.';

  @override
  String get preference_selection_selected1 => 'Đã chọn';

  @override
  String get preference_selection_start1 => 'Bắt đầu khám phá';

  @override
  String preference_selection_max_error1(int count) {
    return 'Bạn chỉ có thể chọn tối đa $count thẻ.';
  }

  @override
  String get preference_selection_save_failed1 =>
      'Không thể lưu sở thích. Vui lòng thử lại sau.';

  @override
  String get preference_group_personality1 => 'Tính cách';

  @override
  String get preference_group_relationship_age1 =>
      'Mối quan hệ và chênh lệch tuổi';

  @override
  String get preference_group_story1 => 'Bối cảnh câu chuyện';

  @override
  String get preference_tag_gentle1 => 'Dịu dàng';

  @override
  String get preference_tag_cold1 => 'Lạnh lùng';

  @override
  String get preference_tag_scheming1 => 'Thâm hiểm';

  @override
  String get preference_tag_tsundere1 => 'Tsundere';

  @override
  String get preference_tag_loyal1 => 'Trung thành';

  @override
  String get preference_tag_yandere1 => 'Yandere';

  @override
  String get preference_tag_mysterious1 => 'Bí ẩn';

  @override
  String get preference_tag_healing1 => 'Chữa lành';

  @override
  String get preference_tag_gap_moe1 => 'Tương phản bất ngờ';

  @override
  String get preference_tag_older1 => 'Lớn tuổi hơn';

  @override
  String get preference_tag_younger1 => 'Nhỏ tuổi hơn';

  @override
  String get preference_tag_ceo1 => 'Tổng tài bá đạo';

  @override
  String get preference_tag_school1 => 'Học đường';

  @override
  String get preference_tag_workplace1 => 'Công sở';

  @override
  String get preference_tag_ancient1 => 'Cổ trang';

  @override
  String get preference_tag_nonhuman1 => 'Phi nhân loại';

  @override
  String get private_label1 => 'ส่วนตัว';

  @override
  String get profile_page_world_tab1 => 'Thế giới mở';

  @override
  String get profile_page_login_required1 => 'Vui lòng đăng nhập trước';

  @override
  String get profile_page_world_load_failed1 =>
      'Không thể tải thế giới. Vui lòng thử lại sau.';

  @override
  String get profile_page_my_worlds1 => 'Thế giới mở của tôi';

  @override
  String get profile_page_create_world1 => 'Tạo thế giới';

  @override
  String get profile_page_worlds_empty1 => 'Chưa có thế giới nào được tạo';

  @override
  String get profile_page_worlds_empty_hint1 =>
      'Hãy tạo thế giới đầu tiên của bạn';

  @override
  String get profile_page_world_untitled1 => 'Thế giới chưa đặt tên';

  @override
  String get profile_page_world_public1 => 'Công khai';

  @override
  String get profile_page_world_private1 => 'Riêng tư';

  @override
  String profile_page_world_character_count1(int count) {
    return '$count nhân vật';
  }

  @override
  String get profile_page_world_enter_chat1 => 'Vào trò chuyện';

  @override
  String get profile_page_world_edit1 => 'Chỉnh sửa';

  @override
  String get profile_page_create_character1 => 'Tạo nhân vật';

  @override
  String get profile_page_event_frame_default1 => 'Khung ảnh đại diện sự kiện';

  @override
  String get public_worlds_explore_title1 => 'Khám phá thế giới công khai';

  @override
  String get public_worlds_search_tooltip1 => 'Tìm kiếm thế giới mở';

  @override
  String get public_worlds_load_failed1 =>
      'Tạm thời không thể tải thế giới công khai';

  @override
  String get public_worlds_refresh1 => 'Làm mới';

  @override
  String get public_worlds_empty1 =>
      'Thế giới công khai đang được chuẩn bị. Hãy đón chờ!';

  @override
  String get public_worlds_unnamed1 => 'Thế giới chưa đặt tên';

  @override
  String get world_explore_subtitle1 =>
      'Bước vào những thế giới khác nhau và khám phá những hành trình độc đáo';

  @override
  String get settings_notification_preferences_title1 => 'Tùy chọn thông báo';

  @override
  String get settings_notification_preferences_subtitle1 =>
      'Chọn loại thông báo muốn nhận và đồng bộ cài đặt giữa các thiết bị';

  @override
  String get settings_admin_section1 => 'Quản trị';

  @override
  String get settings_admin_dashboard1 => 'Bảng điều khiển quản trị';

  @override
  String get settings_admin_tools_subtitle1 => 'Công cụ quản lý nội bộ';

  @override
  String get world_chat_back1 => 'Quay lại';

  @override
  String get world_chat_mode_tooltip1 =>
      'Chế độ phản hồi (AI và trừ hoa chưa được kết nối)';

  @override
  String get world_chat_menu1 => 'Menu thế giới';

  @override
  String get world_chat_mode_story1 => 'Cốt truyện';

  @override
  String get world_chat_mode_immersive1 => 'Nhập vai';

  @override
  String get world_chat_mode_resonance1 => 'Cộng hưởng';

  @override
  String get world_chat_mode_interaction1 => 'Tương tác';

  @override
  String world_chat_mode_cost1(String mode, int cost) {
    return '$mode · $cost hoa';
  }

  @override
  String world_memo_read_failed1(String error) {
    return 'Không thể tải ghi chú: $error';
  }

  @override
  String get world_memo_sync_failed1 =>
      'Đồng bộ tạm thời thất bại. Đang hiển thị ghi chú đã tải trước đó.';

  @override
  String get world_memo_server_no_id1 => 'Máy chủ không trả về ID ghi chú';

  @override
  String world_memo_save_failed1(String error) {
    return 'Lưu thất bại: $error';
  }

  @override
  String get world_memo_delete_title1 => 'Xóa ghi chú?';

  @override
  String get world_memo_delete_warning1 => 'Không thể hoàn tác sau khi xóa.';

  @override
  String get world_memo_cancel1 => 'Hủy';

  @override
  String get world_memo_delete1 => 'Xóa';

  @override
  String world_memo_cancel_reminder_failed1(String error) {
    return 'Đã xóa ghi chú nhưng không thể hủy nhắc nhở trên thiết bị cũ: $error';
  }

  @override
  String world_memo_delete_failed1(String error) {
    return 'Xóa thất bại: $error';
  }

  @override
  String get world_memo_title1 => 'Ghi chú';

  @override
  String world_memo_world_personal1(String worldName) {
    return '$worldName | Ghi chú cá nhân';
  }

  @override
  String get world_memo_sync_notice1 =>
      'Thời gian nhắc nhở được đồng bộ giữa các thiết bị. Thông báo đẩy được gửi đến các thiết bị đã đăng nhập và cho phép thông báo.';

  @override
  String get world_memo_loading1 => 'Đang tải…';

  @override
  String get world_memo_empty1 => 'Chưa có ghi chú. Nhấn + để thêm mới.';

  @override
  String world_memo_reminder_date1(String date) {
    return 'Nhắc nhở: $date';
  }

  @override
  String get world_memo_reminder_future1 =>
      'Thời gian nhắc nhở phải ở tương lai';

  @override
  String get world_memo_content_required1 => 'Hãy nhập nội dung ghi chú trước';

  @override
  String get world_memo_edit_title1 => 'Sửa ghi chú';

  @override
  String get world_memo_add_title1 => 'Ghi chú mới';

  @override
  String get world_memo_content_label1 => 'Nội dung ghi chú';

  @override
  String get world_memo_content_hint1 => 'Viết điều bạn muốn ghi nhớ…';

  @override
  String get world_memo_reminder_settings1 => 'Cài đặt nhắc nhở';

  @override
  String get world_memo_no_reminder1 => 'Chưa đặt nhắc nhở';

  @override
  String get world_memo_reminder_choose1 =>
      'Chọn ngày giờ để đồng bộ nhắc nhở qua đám mây';

  @override
  String get world_memo_clear_reminder1 => 'Xóa ngày nhắc nhở';

  @override
  String get world_memo_save1 => 'Lưu ghi chú';

  @override
  String get world_chat_open_world1 => 'Thế giới mở';

  @override
  String get world_chat_flower_sync1 => 'Tạm thời không thể đồng bộ số hoa';

  @override
  String get world_chat_web_store_unavailable1 => 'Bản web chưa hỗ trợ mua hoa';

  @override
  String get world_chat_sync_unavailable1 =>
      'Không thể đồng bộ thời gian thực. Hãy mở lại cuộc trò chuyện để tải lịch sử.';

  @override
  String get world_chat_stopped1 => 'Đã dừng tạo phản hồi, không trừ hoa.';

  @override
  String get world_chat_cannot_stop1 =>
      'Phản hồi có thể đã hoàn tất, không thể dừng. Hãy kiểm tra trò chuyện và số hoa.';

  @override
  String get world_chat_stop_retry1 =>
      'Không thể dừng lúc này. Vui lòng thử lại.';

  @override
  String get world_chat_connection_failed1 => 'Kết nối thất bại';

  @override
  String get world_chat_network_failed1 => 'Mạng tạm thời không khả dụng';

  @override
  String get world_chat_no_regenerate1 => 'Chưa có phản hồi nào để tạo lại';

  @override
  String get world_chat_paid_regenerate1 => 'Tạo lại có tính phí';

  @override
  String get world_chat_cancel1 => 'Hủy';

  @override
  String get world_chat_confirm1 => 'Xác nhận';

  @override
  String get world_chat_no_continue1 => 'Chưa có cốt truyện để tiếp tục';

  @override
  String get world_chat_no_save1 => 'Chưa có cuộc trò chuyện nào để lưu';

  @override
  String get world_chat_loading1 => 'Cuộc trò chuyện đang tải';

  @override
  String get world_chat_unnamed_character1 => 'Nhân vật chưa đặt tên';

  @override
  String get world_chat_bg_wait1 =>
      'Có thể đổi hình nền sau khi tải xong trò chuyện';

  @override
  String get world_chat_sign_in1 => 'Vui lòng đăng nhập trước';

  @override
  String get world_chat_choose_mode1 => 'Chọn chế độ thế giới';

  @override
  String get world_chat_mode_charge_expl1 =>
      'Mỗi phản hồi thành công sẽ trừ hoa theo chế độ; thất bại không tính phí.';

  @override
  String get world_chat_photo_selected1 => 'Đã chọn ảnh';

  @override
  String get world_chat_got_it1 => 'Đã hiểu';

  @override
  String get world_chat_status_settings1 =>
      'Cài đặt hiển thị trạng thái thế giới';

  @override
  String get world_chat_save_settings1 => 'Lưu cài đặt';

  @override
  String get world_chat_status_saved1 =>
      'Đã lưu tùy chọn hiển thị trạng thái của thế giới này';

  @override
  String get world_chat_not_ready1 => 'Trò chuyện thế giới chưa sẵn sàng';

  @override
  String get world_chat_enter_first1 => 'Hãy vào trò chuyện thế giới trước';

  @override
  String get world_chat_photo1 => 'Ảnh';

  @override
  String get world_chat_profile1 => 'Hồ sơ';

  @override
  String get world_chat_interaction1 => 'Tương tác';

  @override
  String get world_chat_theater1 => 'Sân khấu';

  @override
  String get world_chat_status1 => 'Trạng thái';

  @override
  String get world_chat_secret1 => 'Chương bí mật';

  @override
  String get world_chat_mood1 => 'Tâm trạng';

  @override
  String get world_chat_outfit1 => 'Trang phục';

  @override
  String get world_chat_relationship1 => 'Mối quan hệ';

  @override
  String get world_chat_thought1 => 'Suy nghĩ';

  @override
  String get world_chat_weather1 => 'Thời tiết';

  @override
  String get world_chat_current_state1 => 'Trạng thái hiện tại';

  @override
  String get world_chat_action1 => 'Hành động';

  @override
  String get world_chat_affinity1 => 'Độ thiện cảm';

  @override
  String get world_chat_generating1 => 'Thế giới đang lặng lẽ chuyển mình…';

  @override
  String get world_chat_screenshot1 => 'Chia sẻ ảnh chụp màn hình';

  @override
  String get world_chat_copy1 => 'Sao chép nội dung';

  @override
  String get world_chat_copied1 => 'Đã sao chép';

  @override
  String get world_chat_edit1 => 'Chỉnh sửa';

  @override
  String get world_chat_delete1 => 'Xóa';

  @override
  String get world_chat_report1 => 'Báo cáo cuộc trò chuyện';

  @override
  String get world_chat_feedback1 => 'Góp ý';

  @override
  String get world_chat_edit_segment1 => 'Chỉnh sửa đoạn của nhân vật';

  @override
  String get world_chat_save1 => 'Lưu';

  @override
  String get world_chat_updated1 => 'Đã cập nhật tin nhắn';

  @override
  String get world_chat_delete_segment1 => 'Xóa đoạn';

  @override
  String get world_chat_deleted_segment1 => 'Đã xóa đoạn';

  @override
  String get world_chat_edit_message1 => 'Chỉnh sửa tin nhắn';

  @override
  String get world_chat_edit_hint1 => 'Sửa nội dung của bạn';

  @override
  String get world_chat_delete_conversation1 => 'Xóa cuộc trò chuyện';

  @override
  String get world_chat_no_chat1 => 'Chưa có cuộc trò chuyện nào';

  @override
  String get world_chat_cancel_select1 => 'Hủy chọn';

  @override
  String get world_chat_input_hint1 => 'Viết nên câu chuyện của hai người…';

  @override
  String get world_chat_screenshot_done1 => 'Khoảnh khắc riêng đã sẵn sàng';

  @override
  String get world_chat_screenshot_style1 => 'Đổi màu ảnh chụp màn hình';

  @override
  String get world_chat_reselect1 => 'Chọn lại';

  @override
  String get world_chat_download_share1 => 'Tải xuống và chia sẻ';

  @override
  String get world_records_summary_title1 => 'Tóm tắt cốt truyện';

  @override
  String world_records_loaded_count1(int count) {
    return 'Đã tải $count tin nhắn và sắp xếp theo trình tự câu chuyện.';
  }

  @override
  String get world_records_auto_summary_pending1 =>
      'Hiện chỉ xem lại được những cuộc trò chuyện đã tải; tính năng AI tự động tóm tắt chưa khả dụng.';

  @override
  String get world_records_empty_story1 => 'Chưa có cốt truyện để xem lại';

  @override
  String get world_records_narrator_name1 => 'Người dẫn chuyện';

  @override
  String get world_records_relationships_title1 => 'Quan hệ nhân vật';

  @override
  String get world_records_affinity_note1 =>
      'Điểm tình cảm được tính riêng cho từng nhân vật chính thức; NPC tạm thời không được tính điểm.';

  @override
  String get world_records_empty_characters1 =>
      'Chưa có dữ liệu nhân vật chính thức';

  @override
  String world_records_affinity_score_with_next1(int score, int next) {
    return 'Tình cảm $score / $next';
  }

  @override
  String world_records_affinity_score_only1(int score) {
    return 'Tình cảm $score';
  }

  @override
  String world_records_relationship_stage1(int stage) {
    return 'Giai đoạn quan hệ $stage';
  }

  @override
  String get world_records_local_memo_read_failed1 =>
      'Không thể tải ghi chú trên thiết bị';

  @override
  String get world_records_memo_saved_local1 =>
      'Đã lưu ghi chú trên thiết bị này';

  @override
  String get world_records_memo_save_failed1 => 'Không thể lưu ghi chú';

  @override
  String get world_records_memo_unsaved1 => 'Ghi chú chưa lưu';

  @override
  String get world_records_memo_save_before_exit1 => 'Lưu trước khi thoát?';

  @override
  String get world_records_continue_editing1 => 'Tiếp tục chỉnh sửa';

  @override
  String get world_records_save_and_exit1 => 'Lưu và thoát';

  @override
  String get world_records_world_memo_title1 => 'Ghi chú cho thế giới này';

  @override
  String get world_records_save1 => 'Lưu';

  @override
  String get world_records_memo_local_disclaimer1 =>
      'Ghi chú riêng tư | Phiên bản này chỉ lưu trên thiết bị hiện tại, không gửi cho AI và không đồng bộ giữa các thiết bị.';

  @override
  String get world_records_memo_hint1 =>
      'Ghi lại manh mối, dự định hoặc những điều muốn nói với nhân vật…';

  @override
  String get world_records_narrator_short1 => 'Lời dẫn';

  @override
  String get world_records_summary_service_missing1 =>
      'Dịch vụ tóm tắt cốt truyện (worldStoryMemory) chưa được triển khai. Hãy triển khai rồi mở lại.';

  @override
  String get world_records_summary_load_failed1 =>
      'Tạm thời không thể tải tóm tắt cốt truyện. Vui lòng thử lại sau.';

  @override
  String get world_records_summary_intro1 =>
      'Mỗi cuộc gặp gỡ và lựa chọn đều trở thành một phần câu chuyện. Những trải nghiệm và mối quan hệ quan trọng sẽ được lưu lại tại đây.';

  @override
  String get world_records_summary_empty1 =>
      'Câu chuyện vẫn tiếp diễn. Những chương đáng nhớ sẽ sớm xuất hiện ở đây.';

  @override
  String get world_search_title1 => 'Tìm kiếm hội thoại';

  @override
  String get world_search_hint1 => 'Tìm nhân vật, lời thoại hoặc lời dẫn';

  @override
  String get world_search_clear1 => 'Xóa tìm kiếm';

  @override
  String get world_search_start1 => 'Nhập từ khóa để bắt đầu tìm kiếm';

  @override
  String world_search_results1(int count) {
    return 'Tìm thấy $count kết quả';
  }

  @override
  String get world_search_empty_prompt1 =>
      'Tìm người chơi, nhân vật và lời dẫn';

  @override
  String get world_search_no_results1 => 'Không có hội thoại phù hợp';

  @override
  String get world_search_unknown_speaker1 => 'Nhân vật không xác định';

  @override
  String get world_search_collapse1 => 'Thu gọn';

  @override
  String get world_search_expand1 => 'Mở rộng';

  @override
  String get world_search_scope1 =>
      'Phạm vi tìm kiếm: 200 tin nhắn gần nhất đã tải trong cuộc trò chuyện';

  @override
  String get world_menu_subtitle1 =>
      'Thế giới mở · Các tính năng sẽ được mở dần';

  @override
  String get world_menu_chat_section1 => 'Trò chuyện';

  @override
  String get world_menu_search1 => 'Tìm kiếm hội thoại';

  @override
  String get world_menu_save_transcript1 => 'Lưu lịch sử trò chuyện';

  @override
  String get world_menu_memories_background1 => 'Kỷ niệm và hình nền';

  @override
  String get world_menu_relations_section1 => 'Mối quan hệ trong thế giới';

  @override
  String get world_menu_story_summary1 => 'Tóm tắt cốt truyện';

  @override
  String get world_menu_relationships1 => 'Quan hệ nhân vật';

  @override
  String get world_menu_memos1 => 'Ghi chú';

  @override
  String get world_menu_memory_section1 => 'Quản lý ký ức';

  @override
  String get world_menu_reset_progress1 => 'Đặt lại tiến trình thế giới';

  @override
  String get world_chat_book_confirm1 => 'Xác nhận';

  @override
  String get world_custom_scene_title_required1 =>
      'Vui lòng nhập tiêu đề cảnh.';

  @override
  String get world_custom_scene_description_required1 =>
      'Vui lòng nhập mô tả cảnh.';

  @override
  String get world_custom_scene_save_failed1 =>
      'Lưu thất bại. Vui lòng thử lại sau.';

  @override
  String get world_custom_scene_edit_title1 => 'Chỉnh sửa cảnh';

  @override
  String get world_custom_scene_add_title1 => 'Thêm cảnh';

  @override
  String get world_discovery_share_desc1 =>
      'Bước vào thế giới mở của nhà sáng tạo và bắt đầu câu chuyện của riêng bạn.';

  @override
  String world_discovery_share_text1(
      String title, String description, String link) {
    return 'Lianlian Shiguang · Lời mời vào thế giới mở\n\n“$title”\n\n$description\n\nKhám phá ngay: $link';
  }

  @override
  String get world_discovery_brand1 => 'Lianlian Shiguang';

  @override
  String get world_discovery_invite1 => 'Lời mời vào thế giới mở';

  @override
  String get world_discovery_scan1 => 'Quét để tải xuống';

  @override
  String get world_discovery_cancel1 => 'Hủy';

  @override
  String get world_discovery_share_button1 => 'Chia sẻ thiệp mời';

  @override
  String get world_discovery_share_missing_card1 =>
      'Không tìm thấy thiệp mời thế giới mở';

  @override
  String get world_discovery_share_image_failed1 => 'Không thể tạo ảnh chia sẻ';

  @override
  String get world_discovery_share_failed1 =>
      'Không thể chia sẻ thiệp mời. Vui lòng thử lại.';

  @override
  String get world_discovery_story_open1 => 'Mở đầu câu chuyện';

  @override
  String get world_discovery_story_unset1 => 'Chưa thiết lập phần mở đầu';

  @override
  String get world_discovery_first_unset1 =>
      'Chưa thiết lập câu thoại đầu tiên';

  @override
  String get world_discovery_background_title1 => 'Bối cảnh và mô tả thế giới';

  @override
  String world_discovery_era1(String era) {
    return 'Bối cảnh thời gian: $era';
  }

  @override
  String get world_discovery_background_unset1 =>
      'Chưa thiết lập bối cảnh thế giới';

  @override
  String get world_discovery_background_full1 => 'Bối cảnh thế giới đầy đủ';

  @override
  String get world_discovery_people_unset1 => 'Chưa có nhân vật';

  @override
  String get world_discovery_people_intro1 => 'Giới thiệu nhân vật';

  @override
  String get world_discovery_appearance_unset1 => 'Chưa có mô tả ngoại hình';

  @override
  String get world_discovery_creator_unset1 =>
      'Chưa có thông tin người sáng tạo';

  @override
  String get world_discovery_creator1 => 'Người sáng tạo';

  @override
  String get world_discovery_creator_load_failed1 =>
      'Không thể tải thông tin người sáng tạo';

  @override
  String world_discovery_world_load_failed1(String error) {
    return 'Không thể tải thế giới mở: $error';
  }

  @override
  String get world_discovery_unpublished1 => 'Thế giới này chưa được công khai';

  @override
  String get world_discovery_open_world1 => 'Thế giới mở';

  @override
  String get world_discovery_share_tooltip1 => 'Chia sẻ thế giới mở';

  @override
  String get world_discovery_world_background1 => 'Bối cảnh thế giới';

  @override
  String get world_edit_custom_status_title1 =>
      'Định dạng phản hồi / thanh trạng thái tùy chỉnh';

  @override
  String get world_edit_custom_status_hint1 =>
      'Không bắt buộc. Thiết lập mẫu thanh trạng thái cho tương tác trong thế giới, như thời gian, địa điểm hoặc trạng thái nhân vật. Nội dung này không thuộc phần giới thiệu công khai.';

  @override
  String get world_edit_custom_status_field1 =>
      'Nội dung thanh trạng thái tùy chỉnh';

  @override
  String get world_discovery_not_playable1 => 'Thế giới mở này chưa thể chơi.';

  @override
  String get world_discovery_enter1 => 'Vào thế giới';

  @override
  String get world_edit_login_required1 => 'Vui lòng đăng nhập trước';

  @override
  String get world_edit_no_edit_permission1 =>
      'You do not have permission to edit this world';

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
  String get world_edit_save_draft_question1 => 'Lưu bản nháp?';

  @override
  String get world_edit_save_draft_explain1 =>
      'Lưu thế giới này trước khi thoát? Các thay đổi chưa lưu sẽ bị mất.';

  @override
  String get world_edit_discard1 => 'Không lưu';

  @override
  String get world_edit_cancel1 => 'Hủy';

  @override
  String get world_edit_save_draft1 => 'Lưu bản nháp';

  @override
  String get world_edit_world_name1 => 'Tên thế giới mở *';

  @override
  String get world_edit_world_images1 =>
      'World images (up to 6; first image is the cover)';

  @override
  String get world_edit_cover1 => 'Ảnh bìa';

  @override
  String get world_edit_set_cover1 => 'Đặt làm ảnh bìa';

  @override
  String get world_edit_short_pitch1 =>
      'One-line card description (optional, up to 60 characters)';

  @override
  String get world_edit_public_summary1 => 'Public world description ';

  @override
  String get world_edit_creator_message_optional1 =>
      'Lời nhắn từ nhà sáng tạo (không bắt buộc)';

  @override
  String get world_discovery_creator_message1 => 'Lời nhắn từ nhà sáng tạo';

  @override
  String get world_edit_era1 =>
      'Time period (e.g. fictional present day, Republican era)';

  @override
  String get world_edit_world_rules1 => 'World background and rules *';

  @override
  String get world_edit_full_lore1 =>
      'Full world lore, events and locations (for AI)';

  @override
  String get world_edit_npc_intro1 =>
      'Set names, appearances, birthdays, relationships, and photos for main characters and NPCs. Each player remains the protagonist of their own story.';

  @override
  String get world_edit_main_characters1 => 'Nhân vật chính';

  @override
  String get world_edit_main_subtitle1 =>
      'Important characters who appear frequently in this world';

  @override
  String get world_edit_npc_subtitle1 =>
      'Other characters who may become interaction partners as the story unfolds';

  @override
  String world_edit_people_count1(int count) {
    return '$count nhân vật';
  }

  @override
  String get world_edit_role_unset1 => 'Role / occupation not set';

  @override
  String get world_edit_remove_person1 => 'Remove character';

  @override
  String world_edit_add_person1(String type) {
    return 'Thêm $type';
  }

  @override
  String get world_edit_add_secret1 => 'Thêm chương bí mật';

  @override
  String get world_edit_edit_secret1 => 'Sửa chương bí mật';

  @override
  String get world_edit_chapter_title1 => 'Tiêu đề chương *';

  @override
  String get world_edit_unlock_condition1 =>
      'Unlock condition (description for server evaluation) *';

  @override
  String get world_edit_secret_content1 => 'Nội dung bí mật *';

  @override
  String get world_edit_confirm1 => 'Xác nhận';

  @override
  String get world_edit_story_opening1 => 'Mở đầu câu chuyện *';

  @override
  String get world_edit_first_line1 => 'Câu thoại đầu tiên *';

  @override
  String get world_edit_secret_chapters1 => 'Chương bí mật';

  @override
  String get world_edit_secret_explain1 =>
      'Secret chapters are stored privately. Publishing the world does not reveal them; players must meet story conditions to unlock them.';

  @override
  String get world_edit_add_secret_max1 => 'Add secret chapter (up to 12)';

  @override
  String get world_edit_publish_settings1 => 'Cài đặt xuất bản';

  @override
  String get world_edit_private_world1 => 'Thế giới riêng tư';

  @override
  String get world_edit_private_world_desc1 =>
      'Chỉ bạn có thể chơi và thử nghiệm; người khác không thể vào';

  @override
  String get world_edit_public_world1 => 'Thế giới công khai';

  @override
  String get world_edit_public_world_desc1 =>
      'Người chơi khác có thể vào và mỗi người có tiến trình riêng';

  @override
  String get world_edit_create_world1 => 'Tạo thế giới mở';

  @override
  String get world_edit_basic_tab1 => 'Cài đặt cơ bản';

  @override
  String get world_edit_characters_tab1 => 'Nhân vật thế giới';

  @override
  String get world_edit_story_tab1 => 'Cài đặt câu chuyện';

  @override
  String get world_edit_publish_world1 => 'Đăng thế giới mở';

  @override
  String get world_edit_name_required1 => 'Vui lòng nhập tên nhân vật';

  @override
  String world_edit_edit_person1(String type) {
    return 'Sửa $type';
  }

  @override
  String get world_edit_upload_photo1 => 'Tải ảnh nhân vật lên (tùy chọn)';

  @override
  String get world_edit_allow_photo1 =>
      'Allow generating other images from this character\'s photo';

  @override
  String get world_edit_allow_photo_explain1 =>
      'Use this character\'s photo as a reference only when appropriate for the story. Chatting and ordinary gifts still work if disabled. Set separately for each character.';

  @override
  String get world_edit_name1 => 'Tên *';

  @override
  String get world_edit_gender1 => 'Giới tính / bản dạng giới';

  @override
  String get world_edit_birthday1 => 'Sinh nhật (VD: 16 tháng 5)';

  @override
  String get world_edit_age1 => 'Tuổi';

  @override
  String get world_edit_role1 => 'Vai trò / nghề nghiệp';

  @override
  String get world_edit_appearance1 => 'Ngoại hình';

  @override
  String get world_edit_personality1 => 'Tính cách và thiết lập';

  @override
  String get world_edit_background1 => 'Quá khứ';

  @override
  String get world_edit_relationships1 => 'Quan hệ với nhân vật khác';

  @override
  String get world_edit_speech_style1 => 'Cách nói / giọng điệu';

  @override
  String get world_edit_dialogue_examples1 => 'Ví dụ hội thoại (cho AI)';

  @override
  String get world_edit_save_person1 => 'Lưu thiết lập nhân vật';

  @override
  String get world_edit_tag_mystery1 => 'Hồi hộp';

  @override
  String get world_edit_tag_horror1 => 'Kinh dị';

  @override
  String get world_edit_tag_romance1 => 'Lãng mạn';

  @override
  String get world_edit_tag_modern_fantasy1 => 'Kỳ ảo đô thị';

  @override
  String get world_edit_tag_school1 => 'Học đường';

  @override
  String get world_edit_tag_ensemble1 => 'Quần tượng';

  @override
  String get world_edit_tag_adventure1 => 'Phiêu lưu';

  @override
  String get world_edit_tag_daily1 => 'Đời thường';

  @override
  String get world_edit_tag_detective1 => 'Trinh thám';

  @override
  String get world_edit_tag_otherworld1 => 'Dị giới';

  @override
  String get chooseNpc1 => 'Chọn NPC';

  @override
  String get chooseInteractionTarget1 => 'Chọn người tương tác';

  @override
  String get unnamedCharacter1 => 'Nhân vật chưa đặt tên';

  @override
  String get chooseTargetFirst1 => 'Hãy chọn người tương tác trước';

  @override
  String get confirmGift1 => 'Xác nhận tặng quà';

  @override
  String giftConfirmDetail1(String target, String gift, int cost) {
    return 'Gửi $gift cho $target tốn $cost hoa. Chỉ trừ điểm sau khi AI phản hồi thành công.';
  }

  @override
  String get cancel1 => 'Hủy';

  @override
  String get send1 => 'Gửi';

  @override
  String get sendLocationTitle1 => 'Gửi địa điểm (3 hoa)';

  @override
  String get customLocation1 => 'Địa điểm tùy chỉnh';

  @override
  String get confirm1 => 'Xác nhận';

  @override
  String get cafe1 => 'Quán cà phê';

  @override
  String get park1 => 'Công viên';

  @override
  String get restaurant1 => 'Nhà hàng';

  @override
  String get street1 => 'Đường phố';

  @override
  String get giftHeart1 => 'Trái tim';

  @override
  String get giftFlower1 => 'Hoa';

  @override
  String get giftSun1 => 'Mặt trời';

  @override
  String get giftConfetti1 => 'Pháo giấy';

  @override
  String get giftCoffee1 => 'Cà phê';

  @override
  String get giftCake1 => 'Bánh kem';

  @override
  String get interactionPlayTitle1 => 'Tương tác';

  @override
  String interactionTargetLabel1(String target) {
    return 'Người tương tác: $target';
  }

  @override
  String get intimateInteraction1 => 'Tương tác thân mật';

  @override
  String get poke1 => 'Chọc nhẹ';

  @override
  String get hug1 => 'Ôm';

  @override
  String get holdHands1 => 'Nắm tay';

  @override
  String get gifts1 => 'Quà tặng';

  @override
  String get funActivities1 => 'Trò chơi vui';

  @override
  String get sendLocation1 => 'Gửi địa điểm';

  @override
  String get diceDuel1 => 'Đấu xúc xắc';

  @override
  String get world_profile_name_too_long1 =>
      'Tên nhân vật trong thế giới không được vượt quá 40 ký tự. Hãy rút ngắn trước khi lưu.';

  @override
  String get world_profile_identity_too_long1 =>
      'Thông tin nhân vật trong thế giới vượt quá 2.000 ký tự. Hãy rút ngắn trước khi lưu.';

  @override
  String get world_relationship_live_title1 => 'Mối quan hệ nhân vật';

  @override
  String get world_relationship_live_load_failed1 =>
      'Không thể tải dữ liệu quan hệ. Hãy kiểm tra quyền Firestore.';

  @override
  String get world_relationship_live_no_people1 =>
      'Thế giới này chưa có nhân vật nào.';

  @override
  String get world_relationship_live_not_met1 =>
      'Quan hệ hiện tại: Chưa gặp nhau';

  @override
  String get world_relationship_live_first_meeting1 => 'Lần đầu gặp gỡ';

  @override
  String world_relationship_live_current_relation1(String relation) {
    return 'Quan hệ hiện tại: $relation';
  }

  @override
  String get world_relationship_live_thought_title1 =>
      'Suy nghĩ hiện tại về người chơi';

  @override
  String get world_relationship_live_thought_pending1 =>
      'Ấn tượng sẽ dần hình thành qua những lần tương tác tiếp theo.';

  @override
  String world_scene_full_load_error1(String error) {
    return 'Không thể tải cảnh: $error';
  }

  @override
  String get world_scene_full_delete_title1 => 'Xóa cảnh';

  @override
  String world_scene_full_delete_confirm1(String title) {
    return 'Xóa “$title”?';
  }

  @override
  String get world_scene_full_cancel1 => 'Hủy';

  @override
  String get world_scene_full_delete1 => 'Xóa';

  @override
  String world_scene_full_delete_error1(String error) {
    return 'Không thể xóa cảnh: $error';
  }

  @override
  String get world_scene_full_missing_fields1 =>
      'Vui lòng nhập tiêu đề và mô tả cảnh.';

  @override
  String world_scene_full_activate_error1(String error) {
    return 'Không thể bắt đầu cảnh: $error';
  }

  @override
  String get world_scene_full_end_title1 => 'Kết thúc cảnh';

  @override
  String get world_scene_full_end_confirm1 => 'Kết thúc cảnh hiện tại?';

  @override
  String world_scene_full_end_error1(String error) {
    return 'Không thể kết thúc cảnh: $error';
  }

  @override
  String get world_scene_full_unnamed1 => 'Cảnh chưa đặt tên';

  @override
  String world_scene_full_opening1(String opening) {
    return 'Mở đầu: $opening';
  }

  @override
  String get world_scene_full_edit1 => 'Chỉnh sửa';

  @override
  String get world_scene_full_start1 => 'Bắt đầu cảnh';

  @override
  String get world_scene_full_creator_empty1 => 'Chưa có cảnh của nhà sáng tạo';

  @override
  String get world_scene_full_custom_empty1 => 'Bạn chưa tạo cảnh nào';

  @override
  String get world_scene_full_add1 => 'Cảnh mới';

  @override
  String get world_scene_full_page_title1 => 'Cảnh';

  @override
  String get world_scene_full_creator_tab1 => 'Cảnh của nhà sáng tạo';

  @override
  String get world_scene_full_custom_tab1 => 'Cảnh tự tạo';

  @override
  String world_scene_full_active1(String title) {
    return 'Cảnh đang diễn ra: $title';
  }

  @override
  String get world_scene_required1 => 'Vui lòng nhập tiêu đề và nội dung cảnh';

  @override
  String get world_scene_title1 => 'Cảnh';

  @override
  String get world_scene_beta_notice1 =>
      'Bản thử nghiệm cảnh thế giới: cảnh được mở bằng AI trò chuyện thế giới. Chức năng lưu riêng và API bắt đầu chính thức chưa được tích hợp.';

  @override
  String get world_scene_creator_scenes1 => 'Cảnh của nhà sáng tạo';

  @override
  String get world_scene_no_creator_scenes1 =>
      'Thế giới này hiện chưa có cảnh của nhà sáng tạo khả dụng';

  @override
  String get world_scene_custom_scenes1 => 'Tự tạo cảnh';

  @override
  String get world_scene_name1 => 'Tên cảnh';

  @override
  String get world_scene_setup1 =>
      'Bối cảnh, địa điểm, nhân vật và tình huống mở đầu';

  @override
  String get world_scene_start1 => 'Bắt đầu cảnh';

  @override
  String get worldSearchTitle1 => 'Tìm thế giới mở';

  @override
  String get worldSearchHint1 => 'Tìm tên thế giới, nhà sáng tạo hoặc thẻ';

  @override
  String get worldSearchClear1 => 'Xóa tìm kiếm';

  @override
  String get worldSearchEmpty1 => 'Không tìm thấy thế giới mở phù hợp';

  @override
  String get worldSearchTrending1 => 'Thế giới phổ biến';

  @override
  String get worldSearchResults1 => 'Kết quả tìm kiếm';

  @override
  String get worldSearchUnnamed1 => 'Thế giới chưa đặt tên';

  @override
  String worldSearchCreator1(String creator) {
    return 'Người sáng tạo: $creator';
  }

  @override
  String get world_secret_chapters_title1 => 'Chương bí mật';

  @override
  String get world_secret_chapters_close1 => 'Đóng';

  @override
  String get world_secret_chapters_read_failed1 =>
      'Hiện không thể đọc chương bí mật này';

  @override
  String get world_secret_chapters_retry1 => 'Tải thất bại. Nhấn để thử lại';

  @override
  String get world_secret_chapters_empty1 =>
      'Nhà sáng tạo chưa thêm chương bí mật nào';

  @override
  String world_secret_chapters_locked_chapter1(String number) {
    return 'Chương $number · ???';
  }

  @override
  String get world_secret_chapters_unlocked1 => 'Đã mở khóa · Nhấn để đọc';

  @override
  String get world_secret_chapters_locked1 =>
      'Chưa mở khóa · Tiếp tục khám phá câu chuyện';

  @override
  String world_timeline_load_failed1(String error) {
    return 'Không thể tải tóm tắt câu chuyện: $error';
  }

  @override
  String get world_timeline_edit_summary1 => 'Chỉnh sửa tóm tắt truyện';

  @override
  String get world_timeline_cancel1 => 'Hủy';

  @override
  String get world_timeline_save1 => 'Lưu';

  @override
  String world_timeline_save_failed1(String error) {
    return 'Lưu thất bại: $error';
  }

  @override
  String get world_timeline_delete_summary1 => 'Xóa tóm tắt';

  @override
  String get world_timeline_delete_confirm1 =>
      'Xóa mục ghi chép câu chuyện này?';

  @override
  String get world_timeline_delete1 => 'Xóa';

  @override
  String world_timeline_delete_failed1(String error) {
    return 'Xóa thất bại: $error';
  }

  @override
  String get world_timeline_our_story1 => 'Câu chuyện của chúng ta';

  @override
  String get world_timeline_retry1 => 'Thử lại';

  @override
  String get world_timeline_empty1 =>
      'Câu chuyện vẫn đang tiếp diễn. Những ghi chép mới sẽ xuất hiện khi câu chuyện tiến triển.';

  @override
  String get world_timeline_recent1 => 'Ghi chép gần đây';

  @override
  String get world_timeline_edit1 => 'Chỉnh sửa';

  @override
  String get echo_login_to_post1 => 'Đăng nhập để để lại tiếng vọng thời gian';

  @override
  String get echo_limit1 =>
      'Mỗi người chơi chỉ có thể để lại tối đa 3 tiếng vọng trong cùng một thế giới mở';

  @override
  String get echo_count_fail1 =>
      'Không thể kiểm tra số tiếng vọng. Vui lòng thử lại sau.';

  @override
  String get echo_compose_title1 => 'Để lại tiếng vọng thời gian';

  @override
  String get echo_compose_desc1 =>
      'Chọn mẫu thẻ yêu thích rồi viết điều bạn muốn lưu lại.';

  @override
  String get echo_compose_hint1 => 'Bạn muốn để lại lời gì trong thế giới này?';

  @override
  String get echo_send1 => 'Gửi tiếng vọng';

  @override
  String get echo_player1 => 'Người chơi';

  @override
  String get echo_sent1 => 'Đã đăng tiếng vọng thời gian';

  @override
  String get echo_post_fail1 =>
      'Không thể đăng. Hãy kiểm tra quyền và kết nối mạng.';

  @override
  String get echo_login1 => 'Vui lòng đăng nhập';

  @override
  String get echo_like_fail1 => 'Không thể thích';

  @override
  String get echo_delete_title1 => 'Xóa tiếng vọng này?';

  @override
  String get echo_delete_warning1 => 'Không thể hoàn tác sau khi xóa.';

  @override
  String get echo_cancel1 => 'Hủy';

  @override
  String get echo_delete1 => 'Xóa';

  @override
  String get echo_deleted1 => 'Đã xóa tiếng vọng';

  @override
  String get echo_delete_fail1 => 'Xóa thất bại';

  @override
  String get echo_reason_inappropriate1 => 'Nội dung không phù hợp';

  @override
  String get echo_reason_harassment1 => 'Quấy rối hoặc công kích';

  @override
  String get echo_reason_spam1 => 'Tin rác';

  @override
  String get echo_reason_other1 => 'Khác';

  @override
  String get echo_report_title1 => 'Báo cáo tiếng vọng';

  @override
  String get echo_already_reported1 => 'Bạn đã báo cáo tiếng vọng này';

  @override
  String get echo_report_received1 => 'Đã nhận báo cáo';

  @override
  String get echo_report_fail1 => 'Báo cáo thất bại';

  @override
  String get echo_options1 => 'Tùy chọn tiếng vọng';

  @override
  String get echo_delete_option1 => 'Xóa tiếng vọng';

  @override
  String get echo_report_option1 => 'Báo cáo tiếng vọng';

  @override
  String get echo_wall_title1 => 'Tiếng vọng thời gian';

  @override
  String get echo_add1 => 'Để lại tiếng vọng';

  @override
  String get echo_load_fail1 =>
      'Không thể tải tiếng vọng. Hãy kiểm tra quyền Firestore.';

  @override
  String get echo_empty1 =>
      'Chưa có tiếng vọng nào. Hãy để lại câu chuyện đầu tiên.';

  @override
  String get store_pack_30_name1 => 'Gói Gặp Gỡ Đầu Tiên';

  @override
  String get store_pack_70_name1 => 'Gói Rung Động';

  @override
  String get store_pack_120_name1 => 'Gói Tim Đập Rộn Ràng';

  @override
  String get store_pack_190_name1 => 'Gói Tình Yêu Nồng Cháy';

  @override
  String get store_pack_250_name1 => 'Gói Tri Kỷ';

  @override
  String get store_pack_330_name1 => 'Gói Chờ Đợi';

  @override
  String get store_pack_450_name1 => 'Gói Tin Tưởng';

  @override
  String get store_pack_520_name1 => 'Gói Anh Yêu Em';

  @override
  String get store_pack_690_name1 => 'Gói Tuần Trăng Mật';

  @override
  String get store_pack_720_name1 => 'Gói Lời Hứa';

  @override
  String get store_pack_750_name1 => 'Gói Bên Nhau';

  @override
  String get store_pack_830_name1 => 'Gói Tình Yêu Sâu Đậm';

  @override
  String get store_pack_990_name1 => 'Gói Bền Lâu';

  @override
  String get store_pack_1050_name1 => 'Gói Duy Nhất';

  @override
  String get store_pack_1290_name1 => 'Gói Chân Ái';

  @override
  String get store_pack_1314_name1 => 'Gói Trọn Đời';

  @override
  String get store_pack_1930_name1 => 'Gói Thề Ước';

  @override
  String get store_pack_2990_name1 => 'Gói Tình Nhân Vĩnh Cửu';
}
