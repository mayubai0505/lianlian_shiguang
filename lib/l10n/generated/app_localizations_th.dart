// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get changeTheme => 'เปลี่ยนสีธีม';

  @override
  String get feedback => 'ข้อเสนอแนะและคำแนะนำ';

  @override
  String get changeLanguage => 'เปลี่ยนภาษา';

  @override
  String get allFriendsTitle => 'เพื่อนทั้งหมด';

  @override
  String get noFriendsMessage => 'คุณยังไม่มีเพื่อนเลย';

  @override
  String get unknownCharacter => 'ตัวละครที่ไม่รู้จัก';

  @override
  String errorLoadingFriends(String error) {
    return 'เกิดข้อผิดพลาดขณะโหลดรายชื่อเพื่อน: $error';
  }

  @override
  String get tagGentle => 'อ่อนโยน';

  @override
  String get tagCheerful => 'ร่าเริง';

  @override
  String get tagLively => 'มีชีวิตชีวา';

  @override
  String get tagMischievous => 'ซุกซน';

  @override
  String get tagRichYoungLady => 'คุณหนู';

  @override
  String get tagRichYoungMaster => 'คุณชาย';

  @override
  String get tagWealthyFamily => 'ตระกูลร่ำรวย';

  @override
  String get tagScheming => 'มีเล่ห์เหลี่ยม';

  @override
  String get tagPossessive => 'ชอบครอบครอง';

  @override
  String get tagParanoid => 'หวาดระแวง';

  @override
  String get tagPersistent => 'มุ่งมั่น';

  @override
  String get tagUncle => 'ลุง';

  @override
  String get tagAuntie => 'ป้า';

  @override
  String get tagSeniorSister => 'รุ่นพี่(หญิง)';

  @override
  String get tagJuniorBrother => 'รุ่นน้อง(ชาย)';

  @override
  String get tagHandsome => 'หล่อ';

  @override
  String get tagStunning => 'สวยงามน่าตะลึง';

  @override
  String get tagContrast => 'ขัดแย้ง';

  @override
  String get tagFlirty => 'เจ้าชู้';

  @override
  String get tagAgeGap => 'ช่องว่างระหว่างวัย';

  @override
  String get userNotFoundError => 'ไม่พบผู้ใช้';

  @override
  String get imageDataMismatchError =>
      'ข้อมูลรูปภาพไม่ตรงกัน กรุณาเลือกรูปภาพใหม่อีกครั้ง';

  @override
  String get createCharacterTitle => 'สร้างตัวละคร';

  @override
  String get charAlbumTitle => 'อัลบั้มตัวละคร (รูปแรกเป็นรูปโปรไฟล์หลัก)';

  @override
  String get charNameLabel => 'ชื่อตัวละคร:*';

  @override
  String get charDescSection => 'คำอธิบายตัวละคร:';

  @override
  String get charAgeLabel => 'อายุ:';

  @override
  String get charJobLabel => 'อาชีพ:*';

  @override
  String get charBirthdayLabel => 'วันเกิด:(MMDD)';

  @override
  String get charGenderLabel => 'เพศ *';

  @override
  String get genderNotSelected => 'ไม่ได้เลือก';

  @override
  String get genderMale => 'ชาย';

  @override
  String get genderFemale => 'หญิง';

  @override
  String get genderOther => 'อื่นๆ';

  @override
  String get charHeightLabel => 'ส่วนสูง:(cm)';

  @override
  String get charAppearanceLabel => 'ลักษณะภายนอก:';

  @override
  String get charPersonalityTagsSection => 'แท็กบุคลิกภาพ';

  @override
  String get charOtherPersonalityTagsHint => 'แท็กบุคลิกภาพอื่นๆ...';

  @override
  String get otherSectionTitle => 'อื่นๆ';

  @override
  String get charLikesLabel =>
      'สิ่งที่ชอบ:(เช่น เค้กสตรอว์เบอร์รี, แมว, วันฝนตก)';

  @override
  String get charDislikesLabel => 'สิ่งที่เกลียด:(เช่น มะระ, ที่ที่เสียงดัง)';

  @override
  String get charSecretsLabel =>
      'ความลับเล็กๆ ที่ไม่มีใครรู้: (เช่น จริงๆ แล้วเป็นคนหลงทาง)';

  @override
  String get charMannerismsSection => 'กิริยาท่าทาง';

  @override
  String get charToneLabel =>
      'น้ำเสียงและสไตล์การพูด: (เช่น พูดเย็นชาใส่คนแปลกหน้า)';

  @override
  String get charDialogueExampleLabel =>
      'ตัวอย่างบทสนทนา: (ผู้เล่น: คุณใจดีจัง! ตัวละคร: ...อ้อ.)';

  @override
  String get charBackgroundSection => 'ประวัติเบื้องหลังตัวละคร:';

  @override
  String get charBackgroundHint =>
      'ใส่เรื่องราวเบื้องหลังตัวละคร (ไม่เกิน 2500 ตัวอักษร)';

  @override
  String get charStoryStartSection => 'จุดเริ่มต้นของเรื่องราว:';

  @override
  String get charStoryStartHint =>
      'ใส่เนื้อเรื่องของตัวละคร (ไม่เกิน 2500 ตัวอักษร)';

  @override
  String get charStorySummaryLabel =>
      'บทสรุปเรื่องราว (ไม่เกิน 50 ตัวอักษร, จะแสดงในบัตรนัดพบ)';

  @override
  String get charExtraInfoSection => 'ข้อมูลเพิ่มเติมเกี่ยวกับตัวละคร:';

  @override
  String get charExtraInfoHint => 'ใส่ข้อมูลเพิ่มเติม...';

  @override
  String get charPublicToggleLabel => 'เปิดเผยให้ผู้เล่นคนอื่นเล่นได้หรือไม่?';

  @override
  String get yes => 'ใช่';

  @override
  String get no => 'ไม่';

  @override
  String get createButton => 'สร้าง';

  @override
  String get saveButton => 'บันทึก';

  @override
  String get cancelButton => 'ยกเลิก';

  @override
  String get exitCreationTitle => 'คุณกำลังจะออกจากหน้าจอสร้างตัวละคร';

  @override
  String get saveDraftPrompt => 'ต้องการบันทึกเป็นฉบับร่างหรือไม่?';

  @override
  String get draftNeeded => 'ต้องการ';

  @override
  String get draftNotNeeded => 'ไม่ต้องการ';

  @override
  String get editExtraInfoTitle => 'แก้ไขข้อมูลเพิ่มเติม';

  @override
  String get nameAndAvatarError =>
      'โปรดกรอกชื่อตัวละครและอัปโหลดรูปโปรไฟล์อย่างน้อยหนึ่งรูป!';

  @override
  String get savingStatus => 'กำลังบันทึก...';

  @override
  String get uploadingImagesStatus => 'กำลังอัปโหลดรูปภาพ...';

  @override
  String get maxImagesError => 'สามารถอัปโหลดได้สูงสุด 10 รูปภาพเท่านั้น';

  @override
  String get uploadingImagesStatusShort => 'กำลังประมวลผลรูปภาพ...';

  @override
  String get savingCharacterData => 'กำลังบันทึกข้อมูลตัวละคร...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'สร้างตัวละคร \"$charName\" แล้ว!';
  }

  @override
  String get uploadImageTimeoutError =>
      'สร้างตัวละครไม่สำเร็จ: อัปโหลดรูปภาพหมดเวลาแล้ว โปรดตรวจสอบการเชื่อมต่ออินเทอร์เน็ตของคุณ';

  @override
  String createCharacterGenericError(String error) {
    return 'สร้างตัวละครไม่สำเร็จ: $error';
  }

  @override
  String get settingsSectionAppearance => 'รูปลักษณ์และเนื้อหา';

  @override
  String get settingsSectionAccount => 'การจัดการบัญชีและเนื้อหา';

  @override
  String get settingsSectionAbout => 'เกี่ยวกับเรา';

  @override
  String get accountManagement => 'การจัดการบัญชี';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'ไม่ทราบ';

  @override
  String get userIdCopied => 'คัดลอก ID ผู้ใช้ไปยังคลิปบอร์ดแล้ว';

  @override
  String get characterManagement => 'การจัดการตัวละคร';

  @override
  String get viewBlockedCharacters => 'ดูตัวละครที่ถูกบล็อก';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get termsOfService => 'ข้อกำหนดในการให้บริการ';

  @override
  String get logoutButton => 'ออกจากระบบ';

  @override
  String get logoutDialogTitle => 'คุณต้องการออกจากระบบหรือไม่?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'ฉันกดผิด';

  @override
  String get logoutDialogActionConfirm => 'ยืนยัน';

  @override
  String get logoutSuccessSnackbar => 'ตกลง! ฉันจะรอคุณกลับมา♥(´∀` )';

  @override
  String get deleteAccountButton => 'ลบบัญชี';

  @override
  String get deleteAccountDialogTitle =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบบัญชีนี้?இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'การดำเนินการนี้ไม่สามารถย้อนกลับได้ ข้อมูลทั้งหมดจะถูกลบอย่างถาวร!';

  @override
  String get deleteAccountDialogActionCancel => 'ไม่ ฉันไม่ได้ต้องการลบ';

  @override
  String get deleteAccountDialogActionConfirm => 'ยืนยัน';

  @override
  String get deleteAccountSuccessSnackbar => 'ลบบัญชีสำเร็จแล้ว';

  @override
  String get appDisclaimer =>
      'ตัวละครและฉากในเกมนี้เป็นเรื่องสมมติทั้งหมด โปรดอย่านำไปผูกโยงกับความเป็นจริง!';

  @override
  String appVersion(String version) {
    return 'เวอร์ชันแอป: $version';
  }

  @override
  String get dialogTitleHint => 'คำแนะนำ';

  @override
  String get completeProfilePrompt =>
      'กรุณาแก้ไขโปรไฟล์ของคุณเพื่อกรอกข้อมูลให้สมบูรณ์ก่อน!';

  @override
  String get goToEdit => 'ไปที่แก้ไข';

  @override
  String get later => 'ภายหลัง';

  @override
  String chattingWith(String friendName) {
    return 'กำลังแชทกับ $friendName';
  }

  @override
  String chatContentWith(String friendName) {
    return 'เนื้อหาการแชทกับ $friendName';
  }

  @override
  String get chatInputHint => 'พิมพ์ข้อความ...';

  @override
  String get characterNotFoundError => 'ไม่พบข้อมูลตัวละคร';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'โหลดรายละเอียดตัวละครไม่สำเร็จ: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'ความสัมพันธ์เริ่มต้น';

  @override
  String get relationship_childhood_friend => 'เพื่อนสมัยเด็ก';

  @override
  String get relationship_senior_junior => 'รุ่นพี่รุ่นน้อง';

  @override
  String get relationship_bickering_couple => 'คู่กัด';

  @override
  String get relationship_colleagues => 'เพื่อนร่วมงาน';

  @override
  String get relationship_other => 'อื่น ๆ (โปรดป้อนด้วยตนเอง)';

  @override
  String get chatModeDaily => 'โหมดประจำวัน';

  @override
  String get chatModeStory => 'โหมดเนื้อเรื่อง';

  @override
  String get chatModeImmersive => 'โหมดดื่มด่ำ';

  @override
  String get chatModeGemini => 'เพื่อนคู่ชีวิต';

  @override
  String get announcement_new => 'ประกาศใหม่';

  @override
  String get mail_notification =>
      'จดหมายแห่งเวลาฉบับใหม่มาถึงแล้ว! ไปตรวจสอบที่ม้วนกระดาษหนังได้เลย!';

  @override
  String get customer_service_reply => 'ตอบกลับจากฝ่ายบริการลูกค้า';

  @override
  String get system_announcement => 'ประกาศจากระบบ';

  @override
  String get empty_announcement => 'ขณะนี้ยังไม่มีประกาศ';

  @override
  String get untitled => 'ไม่มีหัวข้อ';

  @override
  String get no_content => 'ไม่มีเนื้อหา';

  @override
  String get privacy_policy_title =>
      'นโยบายความเป็นส่วนตัวของ Lianlian Shiguang';

  @override
  String get privacy_policy_date => 'อัปเดตล่าสุด: 10 เมษายน 2026';

  @override
  String get privacy_policy_body =>
      'นโยบายความเป็นส่วนตัวของ \"Lianlian Shiguang\"\nอัปเดตล่าสุด: 10 เมษายน 2026\n\nยินดีต้อนรับสู่ \"Lianlian Shiguang\" (ซึ่งต่อไปนี้จะเรียกว่า \"บริการ\") เราให้ความสำคัญกับความเป็นส่วนตัวของคุณ นโยบายนี้อธิบายถึงการเก็บรวบรวม การใช้ และการคุ้มครองข้อมูลส่วนบุคคลของคุณ\n\n1. ข้อมูลบัญชี:\nการเข้าสู่ระบบผ่านบุคคลที่สาม: เมื่อคุณเข้าสู่ระบบผ่าน Google, Facebook หรือ Apple เราจะเก็บรวบรวม Firebase UID, อีเมล และชื่อเล่นสาธารณะของคุณ\nการลงทะเบียนผ่านอีเมล: รหัสผ่านของคุณจะถูกจัดการและจัดเก็บผ่านเทคโนโลยีการเข้ารหัสของ Firebase ทีมพัฒนาไม่สามารถเข้าถึงรหัสผ่านดั้งเดิมของคุณได้\n\nข้อมูลการโต้ตอบ: เพื่อให้ตัวละคร AI มีความจำที่ต่อเนื่อง เราจะจัดเก็บบันทึกการสนทนาระหว่างคุณกับ AI\nข้อมูลอุปกรณ์: รุ่นอุปกรณ์, เวอร์ชันระบบปฏิบัติการ และรหัสประจำตัวอุปกรณ์ เพื่อการเพิ่มประสิทธิภาพระบบ\n\n2. การใช้ข้อมูล:\nเพื่อพัฒนาประสบการณ์ AI, การดำเนินงานด้านบริการ (การเติมพอยท์) และการรักษาความปลอดภัย\n\n3. ความร่วมมือทางเทคนิค:\nบริการนี้ได้รับการสนับสนุนโดยเทคโนโลยีระดับโลก เช่น Google Cloud / Firebase และ OpenRouter / xAI / Meta\nหมายเหตุ: เราจะไม่ขายบันทึกการสนทนาของคุณให้กับผู้โฆษณา\n\n4. การจัดเก็บและการลบข้อมูล:\nข้อมูลของคุณจะถูกจัดเก็บอย่างปลอดภัยบนเซิร์ฟเวอร์คลาวด์ คุณสามารถติดต่อเราเพื่อขอลบบัญชีและข้อมูลทั้งหมดเป็นการถาวรได้ตลอดเวลา';

  @override
  String get terms_title => 'เงื่อนไขการให้บริการของ Lianlian Shiguang';

  @override
  String get terms_date => 'อัปเดตล่าสุด: 10 เมษายน 2026';

  @override
  String get terms_body =>
      'เงื่อนไขการให้บริการของ \"Lianlian Shiguang\"\nอัปเดตล่าสุด: 10 เมษายน 2026\n\nโปรดอ่านเงื่อนไขต่อไปนี้อย่างละเอียดก่อนใช้บริการ การเริ่มใช้งานหมายถึงคุณยอมรับข้อตกลงดังนี้:\n\n1. ลักษณะของบริการและคำสงวนสิทธิ์:\nการโต้ตอบที่ไม่ใช่มนุษย์: คำตอบทั้งหมดถูกสร้างโดย AI (Generative AI) ซึ่งไม่ถือเป็นมุมมองของผู้พัฒนา\nความเสี่ยงด้านเนื้อหา: AI อาจสร้างเนื้อหาที่เป็นเรื่องแต่ง ไม่ถูกต้อง หรือไม่เหมาะสม\n\n2. พอยท์เสมือนและรูปแบบการชำระเงิน:\nพอยท์ภายในบริการเป็นสินค้าเสมือน เมื่อใช้งานแล้ว (เช่น เข้าสู่เนื้อหา, โหมดสมจริง, ส่งของขวัญ, การโทรด้วยเสียง) จะไม่สามารถคืนเงินได้\n\n3. ข้อกำหนดพฤติกรรมผู้ใช้:\nห้ามใช้ AI สร้างเนื้อหาที่รุนแรง ผิดกฎหมาย หรือแทรกแซงระบบ\n\n4. ทรัพย์สินทางปัญญา:\nเนื้อหาต้นฉบับ: ชื่อตัวละคร (เช่น เฉิงอัน และตัวละครทางการอื่นๆ) เนื้อเรื่อง และตรรกะของเกมเป็นของ \"ทีมพัฒนา Lianlian Shiguang\"\n\n5. การยุติบริการ:\nหากผู้เล่นละเมิดข้อบังคับ บริการมีสิทธิ์ระงับบัญชีได้โดยไม่ต้องแจ้งให้ทราบล่วงหน้า';

  @override
  String get login_required => 'กรุณาเข้าสู่ระบบก่อน';

  @override
  String get cloud_character_mgmt => 'การจัดการตัวละครบนคลาวด์';

  @override
  String get connection_error => 'การเชื่อมต่อผิดพลาด';

  @override
  String get no_characters_met => 'คุณยังไม่รู้จักตัวละครใดๆ เลย!';

  @override
  String get status_paused => 'สถานะ: ระงับการติดต่อ';

  @override
  String get status_in_progress => 'สถานะ: กำลังพัฒนาความสัมพันธ์';

  @override
  String get unblock => 'ปลดบล็อก';

  @override
  String get block => 'บล็อก';

  @override
  String get confirm_block_title => 'ยืนยันการบล็อกหรือไม่?';

  @override
  String block_warning_msg(String charName) {
    return 'หลังจากบล็อก คุณจะไม่ได้รับข้อความจาก $charName ชั่วคราว';
  }

  @override
  String get think_again => 'ลองคิดดูอีกที';

  @override
  String get confirm_block_btn => 'ยืนยันการบล็อก';

  @override
  String get no_char_info => 'ยังไม่มีข้อมูลโดยละเอียดของตัวละครนี้...';

  @override
  String get private_mailbox => 'กล่องจดหมายส่วนตัว';

  @override
  String get user_info_not_found => 'ไม่พบข้อมูลผู้ใช้';

  @override
  String get load_failed => 'โหลดไม่สำเร็จ กรุณาลองใหม่อีกครั้ง';

  @override
  String get empty_mailbox => 'ตอนนี้กล่องจดหมายว่างเปล่า~';

  @override
  String get system_notification => 'แจ้งเตือนระบบ';

  @override
  String get interaction_records => 'บันทึกการโต้ตอบ';

  @override
  String get liked_content => 'เนื้อหาที่กดไลก์';

  @override
  String get my_favorites => 'รายการโปรดของฉัน';

  @override
  String get login_to_view_records => 'กรุณาเข้าสู่ระบบเพื่อดูบันทึก';

  @override
  String get no_likes_yet => 'คุณยังไม่ได้กดไลก์โพสต์ใดๆ เลย!';

  @override
  String get empty_favorites => 'รายการโปรดว่างเปล่า ไปดูที่ห้องโถงกันเถอะ!';

  @override
  String get theme_sakura_pink => 'ชมพูซากุระ';

  @override
  String get theme_ocean_blue => 'น้ำเงินทะเล';

  @override
  String get theme_sunset_orange => 'ส้มพระอาทิตย์ตก';

  @override
  String get theme_mint_forest => 'ป่ามินต์';

  @override
  String get theme_midnight => 'โหมดกลางคืน';

  @override
  String get change_atmosphere => 'เปลี่ยนบรรยากาศ';

  @override
  String get custom_color => 'สีที่กำหนดเอง';

  @override
  String get custom_color_desc => 'ปรุงแต่งสีบรรยากาศเฉพาะตัวของคุณ';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get confirm => 'ตกลง';

  @override
  String get confirm_delete_title => 'ยืนยันการลบ';

  @override
  String get confirm_delete_memory_msg =>
      'คุณแน่ใจหรือไม่ว่าต้องการให้เขาลืมเรื่องนี้? การดำเนินการนี้ไม่สามารถยกเลิกได้';

  @override
  String get delete_btn => 'ลบ';

  @override
  String get memory_erased_msg => 'ความทรงจำนี้ถูกลบไปแล้ว';

  @override
  String get delete_failed_msg => 'ลบไม่สำเร็จ';

  @override
  String get edit_memory_title => 'แก้ไขความทรงจำ';

  @override
  String get modify_memory_hint => 'แก้ไขความทรงจำนี้...';

  @override
  String get memory_re_recorded_msg => 'บันทึกความทรงจำใหม่แล้ว';

  @override
  String get update_failed_msg => 'อัปเดตไม่สำเร็จ';

  @override
  String get update_favorite_failed_msg => 'อัปเดตสถานะรายการโปรดไม่สำเร็จ';

  @override
  String char_notebook_title(String charName) {
    return 'สมุดบันทึกของ $charName';
  }

  @override
  String get error_loading_memory => 'เกิดข้อผิดพลาดในการโหลดความทรงจำ';

  @override
  String get empty_notebook_msg =>
      'สมุดบันทึกว่างเปล่า...\nรีบไปคุยกันเถอะ เขาจะได้จดจำทุกเรื่องราวของคุณ!';

  @override
  String get date_format_text => 'd MMM yyyy';

  @override
  String get remove_special_focus => 'ยกเลิกความสนใจพิเศษ';

  @override
  String get mark_special_focus => 'ทำเครื่องหมายเป็นความสนใจพิเศษ';

  @override
  String get edit_btn => 'แก้ไข';

  @override
  String get load_gallery_failed => 'โหลดแกลเลอรีไม่สำเร็จ';

  @override
  String get traditional_chinese => 'จีนตัวเต็ม';

  @override
  String get all => 'ทั้งหมด';

  @override
  String get official_recommendation => 'คำแนะนำอย่างเป็นทางการ';

  @override
  String get my_exclusive => 'พิเศษสำหรับฉัน';

  @override
  String encounter_count(int count) {
    return 'พบกัน $count ครั้ง';
  }

  @override
  String get official => 'ทางการ';

  @override
  String get private => 'ส่วนตัว';

  @override
  String get first_encounter => 'พบกันครั้งแรก';

  @override
  String char_exclusive_memory(String charName) {
    return 'ความทรงจำพิเศษของ $charName';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return 'ความสนิทสนมต้องถึง $affectionLevel จึงจะปลดล็อกความทรงจำนี้ได้!';
  }

  @override
  String get affection => 'ความสนิทสนม';

  @override
  String get unlock => 'ปลดล็อก';

  @override
  String get change_chat_bg => 'เปลี่ยนพื้นหลังแชท';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return 'ตั้งค่า \"$cgDesc\" เป็นพื้นหลังแชทกับ $charName หรือไม่?';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return 'เปลี่ยนพื้นหลังเป็น \"$cgDesc\" แล้ว';
  }

  @override
  String get confirm_change => 'ยืนยันการเปลี่ยน';

  @override
  String get empty_treasure_box =>
      'กล่องสมบัติว่างเปล่า...\nไปแชทเพื่อค้นหาเซอร์ไพรส์ที่ซ่อนอยู่กันเถอะ!';

  @override
  String get unknown_story => 'เนื้อเรื่องที่ไม่รู้จัก';

  @override
  String get open_this_memory => 'เปิดความทรงจำนี้';

  @override
  String get open_exclusive_story => 'เปิดเนื้อเรื่องพิเศษ';

  @override
  String confirm_use_egg(String eggTitle) {
    return 'ต้องการสัมผัส \"$eggTitle\" ตอนนี้เลยหรือไม่?\n\n(ไอเท็มนี้ใช้ได้ครั้งเดียว และจะเข้าสู่เนื้อเรื่องอัตโนมัติเมื่อใช้)';
  }

  @override
  String get wait_a_bit => 'รอก่อน';

  @override
  String guiding_into_story(String eggTitle) {
    return 'กำลังนำทางเข้าสู่เนื้อเรื่อง...';
  }

  @override
  String get use_now => 'ใช้ตอนนี้';

  @override
  String playback_failed_status(String statusCode) {
    return 'เล่นไม่สำเร็จ รหัสสถานะ: $statusCode';
  }

  @override
  String get playback_error => 'เกิดข้อผิดพลาดในการเล่น';

  @override
  String get unknown_contact => 'ผู้ติดต่อที่ไม่รู้จัก';

  @override
  String call_memory_with(String charName) {
    return 'ความทรงจำการโทรกับ $charName';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return 'ปลดล็อกที่ระดับความสนิทสนม $affection';
  }

  @override
  String get no_call_record =>
      'ดูเหมือนจะไม่มีบันทึกการสนทนาสำหรับการโทรครั้งนี้...';

  @override
  String get me => 'ฉัน';

  @override
  String get playing => 'กำลังเล่น...';

  @override
  String get listen => 'ฟัง';

  @override
  String get no_exclusive_voice => 'ตัวละครนี้ยังไม่ได้ตั้งค่าเสียงเฉพาะตัวนะ!';

  @override
  String get voice_download_success =>
      '✅ ดาวน์โหลดข้อมูลเสียงสำเร็จ เตรียมพร้อมเล่น...';

  @override
  String get onboarding_invitation => '— คำเชิญแห่งกาลเวลา —';

  @override
  String get onboarding_welcome => 'ยินดีต้อนรับสู่ Lian Lian Shi Guang';

  @override
  String get onboarding_quote => '「ทุกการพบพาน คือการกลับมาพบกันอีกครั้ง」';

  @override
  String get onboarding_gift_title => 'ของขวัญแรกพบ: 50 ภาษาดอกไม้';

  @override
  String get onboarding_gift_subtitle =>
      'ดอกไม้เหล่านี้จะอยู่เคียงข้างคุณในการเริ่มต้นเรื่องราวกับเขา';

  @override
  String get onboarding_start_button => 'เริ่มต้นการเดินทางแห่งกาลเวลา';

  @override
  String get onboarding_more_info => 'เรียนรู้เพิ่มเติมเกี่ยวกับเรื่องราว';

  @override
  String get legal_agreement_prefix => 'การดำเนินการต่อ แสดงว่าคุณยอมรับ';

  @override
  String get legal_terms_button => 'ข้อกำหนดการให้บริการ';

  @override
  String get legal_and => ' และ ';

  @override
  String get legal_privacy_button => 'นโยบายความเป็นส่วนตัว';

  @override
  String get call_memory_title => 'ความทรงจำการโทร';

  @override
  String get please_login_first => 'กรุณาเข้าสู่ระบบก่อน';

  @override
  String get no_call_memories =>
      'ยังไม่มีความทรงจำการโทรที่บันทึกไว้\nสามารถบันทึกได้สูงสุด 10 รายการ';

  @override
  String call_with_name(String name) {
    return 'โทรกับ $name';
  }

  @override
  String call_duration(String time) {
    return 'ระยะเวลา: $time';
  }

  @override
  String get delete_call_title => 'ลบประวัติการโทร';

  @override
  String delete_call_confirm(String name) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบความทรงจำนี้กับ $name?\n(ไม่สามารถกู้คืนได้)';
  }

  @override
  String get keep_it => 'เก็บไว้ก่อน';

  @override
  String get confirm_delete => 'ลบ';

  @override
  String get press_mic_to_speak => 'กรุณากดไมโครโฟนเพื่อเริ่มพูด...';

  @override
  String get call_ended => 'วางสายแล้ว';

  @override
  String character_thinking(String name) {
    return '($name กำลังใช้ความคิด...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name กำลังรับสาย...)';
  }

  @override
  String get call_interrupted_login => '(สายหลุด) กรุณาเข้าสู่ระบบก่อนนะคะ...';

  @override
  String get silence => '(เงียบ)';

  @override
  String get bad_signal => '(สัญญาณไม่ดี...)';

  @override
  String get static_noise => '(เสียงซ่า)... ได้ยินไม่ชัดเจน...';

  @override
  String get type_message_hint => 'พิมพ์ข้อความ...';

  @override
  String get draft_saved_success =>
      'บันทึกร่างจดหมายไว้ในสตูดิโอลับเรียบร้อยแล้ว!';

  @override
  String get draft_save_failed => 'การบันทึกล้มเหลว โปรดลองอีกครั้งในภายหลัง';

  @override
  String get draft_save_title => 'ต้องการบันทึกร่างหรือไม่?';

  @override
  String get draft_save_content =>
      'ผลงานของคุณยังไม่ได้เผยแพร่ ต้องการบันทึกไว้ในสตูดิโอลับก่อนไหม?';

  @override
  String get not_save => 'ไม่บันทึก';

  @override
  String get save_draft => 'บันทึกร่าง';

  @override
  String confirm_delete_char_content(String name) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบตัวละคร \"$name\"?\n\nการดำเนินการนี้ไม่สามารถย้อนกลับได้!';
  }

  @override
  String get char_deleted => 'ลบตัวละครแล้ว';

  @override
  String get ok_button => 'ตกลง!';

  @override
  String get cannot_save_title => 'ไม่สามารถบันทึกได้';

  @override
  String get cannot_save_content =>
      'โปรดกรอกชื่อตัวละครและอัปโหลดรูปโปรไฟล์อย่างน้อยหนึ่งรูป!';

  @override
  String get word_count_exceeded => 'จำนวนคำเกินกำหนด';

  @override
  String word_count_error_detail(String field, int limit) {
    return '\"$field\" เกินขีดจำกัด $limit คำ โปรดตัดทอนออกก่อนบันทึก';
  }

  @override
  String get content_missing => 'เนื้อหาขาดหาย';

  @override
  String get content_missing_personality =>
      'โปรดกรอก \"บุคลิกภาพโดยละเอียด\"! อย่างน้อย 10 คำ';

  @override
  String get content_missing_bg =>
      '\"คำแนะนำตัวละคร\" สั้นเกินไป! โปรดเขียนอย่างน้อย 20 คำเพื่ออธิบายภูมิหลัง';

  @override
  String get content_missing_tone =>
      'โปรดตั้งค่า \"น้ำเสียงและนิสัย\" ไม่อย่างนั้นตัวละครอาจหลุดบุคลิก (OOC) ได้ง่าย!';

  @override
  String get user_not_found => 'ข้อผิดพลาด: ไม่พบผู้ใช้';

  @override
  String char_saved_success(String name, String action) {
    return 'ตัวละคร \"$name\" ถูก $action แล้ว!';
  }

  @override
  String save_error_detail(String error) {
    return 'การบันทึกล้มเหลว: $error';
  }

  @override
  String get easter_egg_add_title => 'เพิ่มอีสเตอร์เอ็กที่ซ่อนอยู่';

  @override
  String get easter_egg_edit_title => 'แก้ไขอีสเตอร์เอ็ก';

  @override
  String get keyword_label => 'คำสำคัญที่ใช้กระตุ้น (จำเป็น)';

  @override
  String get keyword_hint => 'เช่น: ไปสวนสนุก, เค้กสตรอว์เบอร์รี';

  @override
  String get egg_title_label => 'ชื่ออีสเตอร์เอ็ก (สำหรับผู้เล่นเห็น)';

  @override
  String get egg_title_hint => 'เช่น: เดทในวันหยุดสุดสัปดาห์';

  @override
  String get egg_teaser_label => 'ตัวอย่างสั้นๆ (สำหรับผู้เล่นเห็น)';

  @override
  String get egg_teaser_hint => 'อธิบายจุดเริ่มต้นของสิ่งที่จะเกิดขึ้น...';

  @override
  String get egg_scene_label => 'การเปลี่ยนฉากแบบบังคับ (ไม่บังคับ)';

  @override
  String get egg_scene_hint => 'เช่น: สวนสนุก, บ้านผีสิง';

  @override
  String get egg_prompt_label => 'คำสั่งสคริปต์';

  @override
  String get egg_prompt_hint =>
      'วิธีแสดงฉากนี้\n(ระบบ: ฉากเปลี่ยนไปที่สวนสนุก ตัวละครมองที่ (ชื่อผู้เล่น) แล้วยิ้ม...)';

  @override
  String get confirm_button => 'ยืนยัน';

  @override
  String get keyword_empty_error => 'คำสำคัญต้องไม่ว่างเปล่า';

  @override
  String get voice_custom_title => 'สั่งทำเสียงส่วนตัว';

  @override
  String get voice_custom_hint =>
      'เช่น: ประธานบริษัทเสียงทุ้ม, หนุ่มน้อยผู้อ่อนโยน...';

  @override
  String get voice_generate_start => 'เริ่มสร้าง';

  @override
  String get voice_bind_first => 'โปรดเลือกและ \"ผูก\" เสียงส่วนตัวก่อน!';

  @override
  String get voice_test_failed =>
      'ลองฟังล้มเหลว: โปรดคลิก \"เลือกคุณแล้ว!\" เพื่อผูกเสียงอย่างเป็นทางการก่อนทำการปรับแต่งละเอียด!';

  @override
  String voice_name_default(String name) {
    return 'เสียงส่วนตัวของ $name';
  }

  @override
  String get voice_description_default =>
      'นี่คือเสียงที่เป็นเอกลักษณ์ซึ่งสร้างขึ้นสำหรับตัวละครเฉพาะใน \"Lian Lian Shi Guang\" โดยผู้เล่นเป็นผู้เลือกและสร้างขึ้นเอง';

  @override
  String get voice_bind_failed =>
      'ผูกเสียงล้มเหลว โปรดตรวจสอบโควตา API หรือสถานะเครือข่าย';

  @override
  String voice_bind_success(String name) {
    return 'เสียงจิตวิญญาณของ \"$name\" ถูกผูกไว้เป็นทางการแล้ว!';
  }

  @override
  String get voice_bind_success_draft =>
      'ผูกเสียงสำเร็จ! ตอนนี้คุณสามารถลากแถบเพื่อทดสอบอารมณ์ได้แล้ว!';

  @override
  String sync_failed(String error) {
    return 'การซิงค์ล้มเหลว โปรดตรวจสอบเครือข่าย: $error';
  }

  @override
  String edit_character_title(String name) {
    return 'แก้ไข $name';
  }

  @override
  String get test_mode_tooltip => 'ทดสอบฟังก์ชันเต็มรูปแบบ';

  @override
  String get test_mode_error =>
      '⚠️ ไม่พบไฟล์ตัวละคร! โปรดคลิก \"บันทึก/เผยแพร่\" ที่ด้านล่างสุดก่อนลองเล่น!';

  @override
  String get test_mode_notice =>
      '💡 โหมดทดสอบจะหักคะแนนตามราคาปกติของแต่ละโหมด และจะไม่ถูกบันทึกในความทรงจำที่เป็นทางการ!';

  @override
  String get delete_character_tooltip => 'ลบตัวละคร';

  @override
  String get tab_basic_story => 'พื้นฐานและเนื้อเรื่อง';

  @override
  String get tab_voice => 'เสียงส่วนตัว';

  @override
  String get tab_relationship => 'ความสัมพันธ์ทางสังคม';

  @override
  String get save_changes_button => 'บันทึกการเปลี่ยนแปลง';

  @override
  String get section_basic_info => 'ข้อมูลพื้นฐาน';

  @override
  String get hint_occupation =>
      'รองรับหลายตัวตน โปรดใช้เครื่องหมายทับหรือคอมมาแยก (เช่น: นักเรียน/แฮกเกอร์)';

  @override
  String get hint_appearance =>
      'เช่น: ผมยาวสีเงิน, ตาสีอำพัน, มักจะสวมชุดกาวน์สีขาว...';

  @override
  String get section_story_identity => '🎭 เนื้อเรื่องและตัวตนของคุณ';

  @override
  String get story_identity_desc =>
      'กำหนดการเปิดเนื้อเรื่องและการตั้งค่าพิเศษสำหรับ \"คุณ\" ในเซฟนี้';

  @override
  String get advanced_writing_tips_title => '💡 เทคนิคการเขียนขั้นสูง:\n';

  @override
  String get advanced_writing_tips_1 => 'ใส่คำว่า ';

  @override
  String get advanced_writing_tips_2 => '(ชื่อผู้เล่น)';

  @override
  String get advanced_writing_tips_3 =>
      ' ในเนื้อเรื่องหรือบทพูด ระบบจะแทนที่ด้วยชื่อเล่นจริงของผู้เล่นโดยอัตโนมัติขณะเล่น!\n';

  @override
  String get advanced_writing_tips_4 => 'ตัวอย่าง: \"';

  @override
  String get advanced_writing_tips_5 => '(ชื่อผู้เล่น)';

  @override
  String get advanced_writing_tips_6 => ' ทำไมคุณถึงมาสายจัง?\"';

  @override
  String get player_identity_label =>
      'ตัวตนเริ่มต้นของผู้เล่น (Player Identity) - 💡 ไม่บังคับ';

  @override
  String get player_identity_hint =>
      '【ไม่บังคับ】หากปล่อยว่างไว้ AI จะอ่านจาก \"โปรไฟล์\" ของคุณเพื่อโต้ตอบ\nหากกรอกข้อมูล จะเป็นการบังคับให้สวมบทบาทเฉพาะ (เช่น ระบบที่เย็นชาของเขา หรือภรรยาที่ถูกทรยศ)';

  @override
  String get background_label => 'ภูมิหลังและโลกของตัวละคร';

  @override
  String get background_hint =>
      'อธิบายอดีตและโลกที่เขาอาศัยอยู่ (เช่น เมืองสมัยใหม่, ABO, วันสิ้นโลก) เช่น นี่คือโลกที่มีซอมบี้ระบาด และเขาเป็นทหารหน่วยรบพิเศษที่คอยปกป้องคุณ...';

  @override
  String get story_summary_label => 'บทนำเนื้อเรื่องสั้นๆ หนึ่งประโยค';

  @override
  String get story_initial_label => 'เรื่องราวการพบกันครั้งแรก';

  @override
  String get story_initial_hint =>
      'เช่น คุณผลักประตูเข้าไปแล้วเห็นเขานั่งอยู่ริมหน้าต่าง เขาหันมาแล้วพูดว่า \"(ชื่อผู้เล่น) มานี่สิ\"...';

  @override
  String get first_line_label => 'ประโยคแรกของตัวละคร';

  @override
  String get first_line_hint => 'เช่น (ชื่อผู้เล่น) ในที่สุดคุณก็มาถึงแล้ว';

  @override
  String get section_personality_evo => '🌟 การพัฒนาบุคลิกภาพและความสนิทสนม';

  @override
  String get detailed_personality_label => 'บุคลิกภาพโดยละเอียด';

  @override
  String get detailed_personality_hint =>
      'อธิบายบุคลิกหลักของเขา เช่น ซึนเดระ ปากแข็งใจอ่อน เย็นชากับคนนอกแต่ยิ้มให้ผู้เล่นคนเดียว';

  @override
  String get affection_evo_desc =>
      'AI จะตัดสินใจว่าควรเพิ่มความสนิทสนมเมื่อใดตามการตั้งค่าต่อไปนี้:';

  @override
  String get stage_1_label => 'ขั้นที่ 1: คนแปลกหน้า/ระแวดระวัง (Lv1)';

  @override
  String get stage_1_hint =>
      'ปฏิกิริยาเมื่อแรกพบ เงื่อนไขความชอบ (เช่น สุภาพ ไม่ก้าวก่ายความเป็นส่วนตัว)';

  @override
  String get stage_2_label => 'ขั้นที่ 2: คนคุ้นเคย/เพื่อน (Lv2)';

  @override
  String get stage_2_hint =>
      'การเปลี่ยนแปลงเมื่อสนิทกันแล้ว เงื่อนไขความชอบ (เช่น แบ่งขนมกัน คุยเรื่องแมว)';

  @override
  String get stage_3_label => 'ขั้นที่ 3: คนใกล้ชิด/คนรัก (Lv3)';

  @override
  String get stage_3_hint =>
      'ปฏิกิริยาเมื่อตกหลุมรักเต็มเปี่ยม จะหึงไหม? หรือจะงอนเงียบๆ?';

  @override
  String get social_interaction_label => 'การโต้ตอบทางสังคมและสิ่งแวดล้อม';

  @override
  String get social_interaction_hint =>
      'เช่น ปฏิบัติต่อคนเดินถนนอย่างไร? เมื่อเจอสิ่งที่เกลียดจะทำอย่างไร?';

  @override
  String get section_habits => '🗣️ ความชอบและนิสัย';

  @override
  String get tone_hint_detail =>
      'จำเป็นต้องกรอก เช่น พูดจาสั้นๆ ชอบถามย้อน คำติดปากคือ \"คนบ้า\" ห้ามใช้น้ำเสียงแบบโปรแกรมแปลภาษา';

  @override
  String get dialogue_example_hint =>
      'ผู้เล่น: ฉันเหนื่อยมากเลย\nตัวละคร: (ลูบหัว) เด็กดี ไปพักผ่อนเร็ว';

  @override
  String get section_easter_eggs =>
      '🎁 อีสเตอร์เอ็กที่ซ่อนอยู่และเนื้อเรื่องพิเศษ';

  @override
  String get no_easter_eggs =>
      'ยังไม่ได้ตั้งค่าอีสเตอร์เอ็ก คลิกปุ่มด้านล่างเพื่อเพิ่ม';

  @override
  String get no_scene_change => 'ไม่เปลี่ยนฉาก';

  @override
  String get add_easter_egg_button => 'เพิ่มอีสเตอร์เอ็กที่ซ่อนอยู่';

  @override
  String get other_extra_info => 'ข้อมูลเพิ่มเติมอื่นๆ';

  @override
  String get visibility_label => 'การมองเห็นตัวละคร';

  @override
  String get visibility_public => 'สาธารณะ';

  @override
  String get visibility_private => 'ส่วนตัว';

  @override
  String get section_voice_gen => '🎙️ สร้างเสียงส่วนตัวของเขา';

  @override
  String get voice_gen_desc =>
      'ใส่คำอธิบายเพื่อให้เขามีเสียงส่วนตัวหนึ่งเดียวในโลก!\n(💡 คำแนะนำ: หากไม่พอใจหลังสร้าง สามารถสั่งทำใหม่ได้ตลอดเวลา!)';

  @override
  String get voice_generating_status => 'กำลังปรุงแต่งน้ำเสียง...';

  @override
  String get voice_select_prompt => '✨ เตรียมเสียงไว้ให้ 3 แบบ โปรดเลือก:';

  @override
  String voice_sample_name(int index) {
    return 'ตัวอย่างเสียง $index';
  }

  @override
  String get voice_sample_desc =>
      'คลิกที่การ์ดเพื่อเลือก คลิกที่ด้านขวาเพื่อลองฟัง';

  @override
  String get voice_preparing => 'กำลังเตรียมเสียงอยู่...';

  @override
  String get voice_retry => 'ละทิ้งและลองใหม่';

  @override
  String get voice_confirm_selection => 'เลือกคุณแล้ว!';

  @override
  String get voice_bind_success_banner => 'ผูกเสียงส่วนตัวสำเร็จแล้ว!';

  @override
  String get voice_remake => 'ทำเสียงใหม่';

  @override
  String get voice_btn_generating => 'กำลังสร้าง โปรดรอสักครู่...';

  @override
  String get voice_btn_generate => 'กรอกคำอธิบายเพื่อสร้างเสียงส่วนตัว';

  @override
  String get voice_advanced_tuning => '🎛️ ขั้นสูง: ปรับจูนอารมณ์การพูด';

  @override
  String get voice_stability_low => 'ดุดัน/เสียงลม 🐺';

  @override
  String voice_stability_value(String value) {
    return 'ความมีเหตุผล: $value';
  }

  @override
  String get voice_stability_high => 'มั่นคง/สงบ 🤖';

  @override
  String get voice_style_low => 'เย็นชา/กดดัน 🧊';

  @override
  String voice_style_value(String value) {
    return 'การแสดงออกทางอารมณ์: $value';
  }

  @override
  String get voice_style_high => 'เล่นใหญ่/ลึกซึ้ง 🔥';

  @override
  String get voice_test_btn_testing => 'กำลังปรับใช้อารมณ์...';

  @override
  String get voice_test_btn => 'ลองฟังอารมณ์ปัจจุบัน';

  @override
  String get section_social_circle => '👥 วงสังคมของเขา';

  @override
  String get social_circle_desc =>
      'ตั้งค่าความเห็นของเขาที่มีต่อตัวละครอื่น เมื่อผู้เล่นกล่าวถึงอีกฝ่ายในแชท เขาจะโต้ตอบตามการตั้งค่านี้ (เช่น หึงหวง, โกรธ)';

  @override
  String get social_no_drama => 'ตอนนี้ยังไม่มีเรื่องบาดหมางกับคนอื่น...';

  @override
  String social_target(String name) {
    return 'เป้าหมาย: $name';
  }

  @override
  String social_attitude(String attitude) {
    return 'ความเห็น: $attitude';
  }

  @override
  String social_edit_title(String name) {
    return 'แก้ไขความเห็นที่มีต่อ $name 💬';
  }

  @override
  String get social_attitude_label => 'ความเห็น / ทัศนคติของเขา';

  @override
  String get social_attitude_hint =>
      'เช่น รู้สึกว่าอีกฝ่ายน่ารำคาญ แต่จริงๆ แล้วพึ่งพาเขามาก...';

  @override
  String get social_save_changes => 'บันทึกการแก้ไข';

  @override
  String get social_add_title => 'เพิ่มความสัมพันธ์ตัวละคร 🤝';

  @override
  String get social_select_target => 'เลือกเป้าหมาย';

  @override
  String get social_thoughts_label => 'ความเห็นของเขาต่อคนนี้...';

  @override
  String get social_thoughts_hint => 'เช่น นักเปียโนคนนั้นหนวกหูเกินไป...';

  @override
  String get social_add_confirm => 'ยืนยันการเพิ่ม';

  @override
  String get gallery_load_failed =>
      'โหลดรูปภาพล้มเหลว 🥲\nโปรดตรวจสอบเครือข่าย หากเป็น Web โปรดดูที่ console';

  @override
  String gallery_affection_req(int level) {
    return 'ความสนิทสนม $level';
  }

  @override
  String get gallery_upload_limit => 'อัปโหลดได้สูงสุด 10 รูปเท่านั้น';

  @override
  String get gallery_photo_setup => 'ตั้งค่าเงื่อนไขการปลดล็อกรูปภาพ';

  @override
  String get gallery_photo_desc_label => 'รูปนี้คืออะไร?';

  @override
  String get gallery_photo_desc_hint => 'เช่น รูปชุดนอน, รูปไปเดท';

  @override
  String get gallery_photo_req_label => 'ต้องการความสนิทสนมเท่าไรเพื่อปลดล็อก?';

  @override
  String get gallery_photo_req_hint => 'กรอกตัวเลข 0 หมายถึงฟรี';

  @override
  String get gallery_cancel_upload => 'ยกเลิกการอัปโหลด';

  @override
  String get gallery_confirm_add => 'ยืนยันการเพิ่ม';

  @override
  String get default_photo_desc => 'รูปภาพส่วนตัว';

  @override
  String get draft_photo_desc => 'รูปภาพร่าง';

  @override
  String get loading_text => 'กำลังโหลด...';

  @override
  String get default_unnamed_character => 'ตัวละครที่ยังไม่ตั้งชื่อ';

  @override
  String elevenlabs_error(String code) {
    return 'ข้อผิดพลาด ElevenLabs: $code';
  }

  @override
  String get voice_sample_script =>
      '(กระแอม) สวัสดีครับ นี่คือการทดสอบเสียงของผมโดยเฉพาะ ในวันต่อๆ ไป ผมจะอยู่ที่นี่กับคุณ ไม่ว่าจะมีความสุขหรือเศร้า คุณสามารถแบ่งปันกับผมได้เสมอ จังหวะและโทนเสียงแบบนี้ คุณฟังแล้วชินหรือยังครับ? ถ้าคุณคิดว่าดี เรามาตกลงใช้เสียงนี้เป็นเสียงเฉพาะสำหรับแชทกับคุณในอนาคตกันเถอะ ผมตั้งตารอคอยในทุกๆ วันที่กำลังจะมาถึงของเรานะ';

  @override
  String get voice_test_script =>
      'คุณคิดว่าน้ำเสียงของผมตอนนี้เป็นอย่างไรบ้างครับ? ถ้าพอใจแล้ว เรามาตกลงใช้แบบนี้กันเถอะ';

  @override
  String get field_background => 'ภูมิหลังตัวละคร';

  @override
  String get field_tone => 'น้ำเสียงและนิสัย';

  @override
  String get field_initial_story => 'เนื้อเรื่องเริ่มต้น';

  @override
  String get update_action => 'อัปเดต';

  @override
  String get default_new_player => 'ผู้เล่นใหม่';

  @override
  String get translating_status => 'กำลังแปล...';

  @override
  String get translate_profile_btn => 'แปลเนื้อหาโปรไฟล์';

  @override
  String translate_failed(String error) {
    return 'การแปลล้มเหลว: $error';
  }

  @override
  String get like_own_char_warning =>
      'ไม่สามารถกดไลก์ตัวละครที่ตัวเองสร้างได้นะ! 🤭';

  @override
  String get like_success_msg => 'ส่งความชอบแล้ว! ผู้สร้างต้องดีใจมากแน่ๆ 💖';

  @override
  String get unlike_success_msg => 'ยกเลิกความชอบแล้ว 💔';

  @override
  String get like_label => 'ชอบ';

  @override
  String get dislike_label => 'ไม่ชอบ';

  @override
  String get block_char => 'บล็อกตัวละครนี้';

  @override
  String get char_blocked_msg => 'บล็อกตัวละครนี้แล้ว';

  @override
  String get dislike_dialog_title => 'ไม่ค่อยชอบตัวละครนี้เหรอ?';

  @override
  String get dislike_dialog_subtitle =>
      'ช่วยบอกเหตุผลกับเราแบบลับๆ หน่อยนะ ทางทีมงานจะทำการตรวจสอบ:';

  @override
  String get dislike_hint => 'การตั้งค่าน่าเบื่อเกินไป, รูปภาพไม่เหมาะสม...';

  @override
  String get dislike_thanks =>
      'ขอบคุณสำหรับข้อเสนอแนะ! ทีมงานได้รับข้อความลับของคุณแล้ว';

  @override
  String get dislike_submit => 'ส่งแบบลับๆ';

  @override
  String get report_title => '📢 รายงานความคิดเห็น';

  @override
  String get report_subtitle =>
      'โปรดเลือกเหตุผลที่รายงาน:\nเราจะตรวจสอบเนื้อหาโดยเร็วที่สุดหลังจากได้รับรายงาน';

  @override
  String get report_opt_1 => 'เนื้อหาลามกอนาจารหรือรุนแรง';

  @override
  String get report_opt_2 => 'ดูหมิ่น ดูแคลน หรือโจมตีตัวละคร';

  @override
  String get report_opt_3 => 'ประทุษวาจาหรือโจมตีบุคคล';

  @override
  String get report_opt_4 => 'สแปมหรือโฆษณาหลอกลวง';

  @override
  String get report_opt_5 => 'เนื้อหาที่ไม่เหมาะสมอื่นๆ';

  @override
  String get report_confirm => 'ยืนยันการรายงาน';

  @override
  String get report_success =>
      'รายงานสำเร็จ ได้รับการแจ้งเตือนแล้ว! จะตรวจสอบเนื้อหาโดยเร็วที่สุด 🛡️';

  @override
  String get report_failed =>
      'รายงานล้มเหลว โปรดตรวจสอบการเชื่อมต่ออินเทอร์เน็ต';

  @override
  String get lore_delete_title => '⚠️ คำเตือน: ลบความทรงจำ';

  @override
  String get lore_delete_content =>
      'ความทรงจำนี้จะหายไปถาวรเมื่อลบออก คุณแน่ใจไหมว่าต้องการลบมันทิ้ง?';

  @override
  String get lore_delete_cancel => 'กดผิด';

  @override
  String get lore_delete_confirm => 'ยืนยันการลบ';

  @override
  String get lore_delete_success => '🗑️ เศษเสี้ยวความทรงจำถูกลบออกไปแล้ว';

  @override
  String get lore_add_title => 'เขียนความทรงจำใหม่ 🖋️';

  @override
  String get lore_edit_title => 'แก้ไขเศษเสี้ยวความทรงจำ 🖋️';

  @override
  String get lore_title_label => 'ชื่อหัวข้อความทรงจำ';

  @override
  String get lore_title_hint => 'เช่น: วันฝนตกที่พบกันครั้งแรก';

  @override
  String get lore_teaser_label => 'บทสรุป / คำนำ';

  @override
  String get lore_teaser_hint => 'คำอธิบายสั้นๆ ที่แสดงบนการ์ด...';

  @override
  String get lore_content_label => 'เนื้อหาความทรงจำฉบับเต็ม';

  @override
  String get lore_content_hint =>
      'เขียนเรื่องราวหรือการตั้งค่าโดยละเอียดที่นี่...';

  @override
  String get lore_lock_label => '🔒 ปิดผนึกความทรงจำนี้';

  @override
  String get lore_lock_desc =>
      'เมื่อเลือกแล้ว จะมีเพียงผู้สร้างเท่านั้นที่เห็น ผู้เล่นคนอื่นจะไม่เห็น';

  @override
  String get lore_empty_error => 'หัวข้อและเนื้อหาต้องไม่ว่างเปล่านะ!';

  @override
  String get lore_add_success => '✨ ความทรงจำใหม่ถูกปิดผนึกเรียบร้อยแล้ว!';

  @override
  String get lore_publish => 'เผยแพร่ความทรงจำ';

  @override
  String get lore_save_edit => 'บันทึกการแก้ไข';

  @override
  String lore_write_first(Object pronoun) {
    return 'มาเริ่มเขียนอดีตบทแรกให้กับ $pronoun กันเถอะ!';
  }

  @override
  String lore_waiting(Object pronoun) {
    return 'ตั้งตารอเรื่องราวกับ $pronoun...';
  }

  @override
  String get lore_sealed_msg =>
      '🔒 ความทรงจำนี้ถูกปิดผนึกอยู่ ไม่สามารถดูได้ในขณะนี้';

  @override
  String get lore_not_open_msg => 'ความทรงจำนี้ยังไม่เปิดให้เข้าชมทั่วไป...';

  @override
  String get lore_unnamed => 'เศษเสี้ยวที่ไม่มีชื่อ';

  @override
  String get lore_add_btn_limit =>
      'เขียนเศษเสี้ยวความทรงจำใหม่ (จำกัด 10 รายการ)';

  @override
  String get lore_collapse => 'พับจดหมาย';

  @override
  String get echo_delete_title => '🗑️ ลบความคิดเห็น';

  @override
  String get echo_delete_content =>
      'แน่ใจนะว่าต้องการลบเสียงสะท้อนแห่งกาลเวลานี้?\nลบแล้วกู้คืนไม่ได้นะ!';

  @override
  String get echo_keep => 'เก็บไว้';

  @override
  String get echo_clear_success => 'ลบเสียงสะท้อนแห่งกาลเวลาแล้ว 🧹';

  @override
  String get echo_energy_full_title => '⚠️ พลังงานจักรวาลเต็มขีดจำกัดแล้ว';

  @override
  String get echo_energy_full_content =>
      'พลังงานกาลเวลาของคุณเต็มแล้ว (สูงสุด 3 รายการ) โปรดลบบันทึกเก่าออกก่อน เพื่อเริ่มบันทึกจักรวาลครั้งใหม่!';

  @override
  String get echo_write_title => 'ทิ้งเสียงสะท้อนแห่งกาลเวลาของคุณไว้ 🌌';

  @override
  String get echo_write_subtitle =>
      'เขียนประสบการณ์หรือคำพูดที่น่าประทับใจที่นี่!';

  @override
  String get echo_hint =>
      '「ต่อให้โลกจะล่มสลาย ฉันก็จะปกป้องลมหายใจของเธอเป็นอันดับแรก...」';

  @override
  String get echo_theme_label => 'เลือกกรอบข้อความ:';

  @override
  String get theme_butterfly => 'ผีเสื้อ';

  @override
  String get theme_sprout => 'ต้นกล้า';

  @override
  String get theme_star => 'ท้องฟ้าพร่างดาว';

  @override
  String get theme_planet => 'ดวงดาว';

  @override
  String get echo_publish_btn => 'เผยแพร่บันทึกกาลเวลา';

  @override
  String get echo_wall_title => 'กำแพงเสียงสะท้อนแห่งกาลเวลา';

  @override
  String get echo_leave_memory => 'ทิ้งประสบการณ์ไว้';

  @override
  String get echo_empty_msg =>
      'ยังไม่มีนักเดินทางข้ามเวลามันทิ้งบันทึกไว้เลย...\nคุณอยากเป็นคนแรกไหม?';

  @override
  String get creator_label => 'ผู้สร้าง';

  @override
  String get follow_btn => 'ติดตาม';

  @override
  String get followed_btn => 'ติดตามแล้ว';

  @override
  String get follow_own_warning => 'ผู้สร้างไม่สามารถติดตามตัวเองได้นะ! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName ติดตาม $creatorName แล้ว!';
  }

  @override
  String get mailbox_follow_title => 'ได้รับผู้พิทักษ์คนใหม่ 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName เพิ่งติดตามคุณ!';
  }

  @override
  String get tab_private_profile => 'โปรไฟล์ส่วนตัว';

  @override
  String get tab_memory_fragments => 'เศษเสี้ยวความทรงจำ';

  @override
  String get tab_time_echoes => 'เสียงสะท้อนแห่งกาลเวลา';

  @override
  String get chat_free_btn => 'คุยเล่น (ฟรี)';

  @override
  String get start_story_btn => 'เริ่มเนื้อเรื่อง';

  @override
  String get default_chat_initial => 'มีธุระอะไรกับฉันหรือเปล่า?';

  @override
  String get gallery_title => 'พื้นหลังการโทรส่วนตัว';

  @override
  String gallery_current_affection(String value) {
    return 'ระดับความสนิทสนมปัจจุบัน: $value 💕';
  }

  @override
  String get gallery_empty => 'ยังไม่มีรูปภาพในอัลบั้ม';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'ตั้งค่าพื้นหลังเป็น「$desc」เรียบร้อยแล้ว!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'สะสมระดับความสนิทสนมให้ถึง $value เพื่อปลดล็อกนะ! 🍃';
  }

  @override
  String get gallery_reset_bg => 'คืนค่าพื้นหลังการโทรเริ่มต้นแล้ว';

  @override
  String get background_story_title => 'เรื่องราวเบื้องหลัง';

  @override
  String get background_story_empty =>
      'ตัวละครนี้ลึกลับมาก ยังไม่มีเรื่องราวเบื้องหลังเลย...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'ติดตาม $creatorName แล้ว 🦋';
  }

  @override
  String get mailbox_title => 'ตู้จดหมายส่วนตัว 💌';

  @override
  String get mailbox_empty =>
      'ตู้จดหมายว่างเปล่า ลองโพสต์อะไรบางอย่างเพื่อดึงดูดเขาดูสิ!';

  @override
  String get new_notification => 'การแจ้งเตือนใหม่';

  @override
  String get default_he => 'เขา';

  @override
  String affection_upgrade_title(String charName) {
    return '$charName มีความรู้สึกดีๆ ให้คุณเพิ่มขึ้นแล้ว! 💖';
  }

  @override
  String get flower_reward => '🌸 ได้รับดอกไม้ 5 แต้ม';

  @override
  String get affection_quote_lv5 =>
      '「ไม่นึกเลยว่า... เธอจะกลายเป็นคนที่สำคัญสำหรับฉันมากขนาดนี้ สำคัญจน... ฉันไม่อาจจินตนาการถึงโลกที่ไม่มีเธอได้เลย」';

  @override
  String get affection_quote_lv4 =>
      '「เรื่องที่โชคดีที่สุดในชีวิตของฉัน คงจะเป็นวันนั้น วันที่ฉันหันกลับไปแล้วได้พบเธอ」';

  @override
  String get affection_quote_lv3 =>
      '「พักนี้... ฉันพบว่าตัวเองเหม่อลอยบ่อยขึ้น และในหัวก็มีแต่เรื่องของเธอเต็มไปหมด」';

  @override
  String get affection_quote_lv2 =>
      '「ในเมื่อเป็นคำชวนของเธอ จะให้ฉันสละเวลาว่างซักหน่อย... ก็ไม่ใช่ว่าจะทำไม่ได้」';

  @override
  String get affection_quote_lv1 =>
      '「ช่วงนี้เจอเธอถามบ่อยๆ รู้สึกว่า... ก็ไม่ได้เกลียดความถี่ในการเจอกันแบบนี้หรอกนะ」';

  @override
  String get affection_quote_lv0 =>
      '「ที่แท้เธอก็อยู่ที่นี่ด้วยเหมือนกัน นี่นับว่าเป็นพรหมลิขิตที่แปลกประหลาดอย่างหนึ่งหรือเปล่านะ?」';

  @override
  String get lore_edit_success => '✨ อัปเดตเศษเสี้ยวความทรงจำสำเร็จแล้ว!';

  @override
  String get delete_failed_network =>
      'ล้มเหลวในการลบ โปรดตรวจสอบเครือข่ายหรือสิทธิ์การใช้งาน';

  @override
  String get ai_chat_language => 'ภาษาไทย';

  @override
  String get ai_chat_language_code => 'th-TH';

  @override
  String get chat_home_title => 'ข้อความ';

  @override
  String get call_memory_tooltip => 'ความทรงจำการโทร';

  @override
  String get login_to_view_chat => 'กรุณาเข้าสู่ระบบเพื่อดูประวัติการแชท';

  @override
  String load_chat_failed(String error) {
    return 'โหลดรายการแชทล้มเหลว: $error';
  }

  @override
  String get chat_list_empty => 'ห้องแชทว่างเปล่า...';

  @override
  String get go_to_encounter => 'ไปที่ \"พบปะ\" เพื่อหาใครสักคนคุยด้วยสิ!';

  @override
  String confirm_delete_chat(String charName) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบการสนทนากับ $charName?';
  }

  @override
  String affection_score_short(String score) {
    return 'ความสนิทสนม $score';
  }

  @override
  String get character_not_found =>
      'ไม่สามารถโหลดข้อมูลตัวละครได้ ตัวละครอาจถูกลบไปแล้ว';

  @override
  String get preparing_chat_room => 'กำลังเตรียมห้องแชทส่วนตัวสำหรับคุณ...';

  @override
  String get rename_chat_title => 'ตั้งชื่อความทรงจำนี้';

  @override
  String get rename_chat_hint =>
      'เช่น: เปลี่ยนจาก (เฉิงอวี้) เป็น (นับถอยหลังการหย่า)';

  @override
  String get save_tag_btn => 'บันทึกแท็ก';

  @override
  String get room_name_updated => 'อัปเดตชื่อห้องแล้ว!';

  @override
  String update_failed(String error) {
    return 'อัปเดตล้มเหลว: $error';
  }

  @override
  String get chat_mode_daily => 'กิจวัตร';

  @override
  String get chat_mode_story => 'เนื้อเรื่อง';

  @override
  String get chat_mode_immersive => 'สมจริง';

  @override
  String get chat_mode_gemini => 'คุยเล่น';

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
      'ไม่พบข้อมูลตัวละคร โปรดลองอีกครั้งหรือตรวจสอบเครือข่ายของคุณ';

  @override
  String get chat_jump_success => 'กระโดดไปยังช่วงความทรงจำนี้แล้ว 🍃';

  @override
  String get chat_create_room_failed =>
      'การเชื่อมต่อไม่เสถียร สร้างห้องแชทล้มเหลว โปรดลองอีกครั้ง';

  @override
  String get chat_secret_file_title => '🔒 ไฟล์ลับ';

  @override
  String get chat_secret_file_desc =>
      'ไฟล์จิตวิญญาณของตัวละครนี้ถูกเก็บถาวรหรือตั้งค่าเป็นส่วนตัว ไม่สามารถดูข้อมูลรายละเอียดได้ในขณะนี้';

  @override
  String get chat_understood => 'รับทราบ';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ ได้รับความทรงจำใหม่: $title';
  }

  @override
  String get chat_egg_saved => 'บันทึกเข้าสู่กระเป๋าพิเศษโดยอัตโนมัติแล้ว';

  @override
  String get chat_points_not_enough_title => 'ดอกไม้ไม่พอ';

  @override
  String get chat_points_not_enough_desc =>
      'ดอกไม้ของคุณไม่พอ! โปรดไปที่ร้านค้าเพื่อเติมดอกไม้';

  @override
  String chat_call_confirm_title(String name) {
    return 'ต้องการโทรหา $name ไหม?';
  }

  @override
  String get chat_call_rule_1 => 'การโทรแต่ละครั้งจะหัก 20 ดอกไม้';

  @override
  String get chat_call_rule_2 =>
      'ระยะเวลาสนทนาคือ 1 นาที หากไม่สะดวกพูดสามารถส่งข้อความแทนได้';

  @override
  String get chat_call_rule_3 =>
      'แนะนำให้สวมหูฟังเพื่อให้ได้ยินเสียงของเขาชัดเจนขึ้น ✨';

  @override
  String get chat_call_btn_cancel => 'ไว้ก่อนนะ';

  @override
  String get chat_call_pref_title => 'ตั้งค่าการโทรของคุณ';

  @override
  String get chat_call_lang_select => 'เลือกภาษาในการสนทนา';

  @override
  String get chat_call_save_memory => 'บันทึกความทรงจำการโทรครั้งนี้';

  @override
  String get chat_call_save_memory_desc =>
      'สามารถกลับมาฟังซ้ำได้หลังจากจบการสนทนา';

  @override
  String get chat_call_btn_start => 'เริ่มการโทร';

  @override
  String chat_points_shortage(String points) {
    return 'คะแนนดอกไม้ไม่พอ! ปัจจุบันมี $points คะแนน';
  }

  @override
  String get chat_room_not_ready =>
      'ห้องแชทยังไม่พร้อม โปรดลองเข้าใหม่อีกครั้ง';

  @override
  String get chat_stop_generating_msg =>
      'หยุดการตอบกลับแล้ว ไม่มีการหักคะแนน 🍃';

  @override
  String get chat_heartbeat_up => 'หัวใจเขาเต้นแรงขึ้นแล้ว...';

  @override
  String get chat_heartbeat_down => 'สายตาเขาเริ่มเย็นชาลง...';

  @override
  String get chat_msg_copy => 'คัดลอกเนื้อหา';

  @override
  String get chat_msg_copied => 'คัดลอกไปยังคลิปบอร์ดแล้ว!';

  @override
  String get chat_msg_report => 'รายงานข้อความนี้';

  @override
  String get chat_msg_suggest => 'ให้คำแนะนำ';

  @override
  String get chat_report_title => 'รายงานการสนทนานี้';

  @override
  String get chat_report_lang => 'ปรากฏภาษาต่างประเทศ';

  @override
  String get chat_report_inapp => 'คำตอบไม่เหมาะสม';

  @override
  String get chat_report_context => 'บริบทไม่ต่อเนื่องกัน';

  @override
  String get chat_report_other => 'เหตุผลอื่นๆ';

  @override
  String get chat_report_hint => 'โปรดอธิบายปัญหาที่คุณพบ...';

  @override
  String get chat_report_submit => 'ส่ง';

  @override
  String get chat_report_success => '✅ ส่งรายงานแล้ว เราจะรีบดำเนินการปรับปรุง';

  @override
  String get chat_suggest_title => 'ให้คำแนะนำ';

  @override
  String get chat_suggest_hint => 'โปรดเขียนข้อเสนอแนะอันมีค่าของคุณ...';

  @override
  String get chat_suggest_success =>
      '💖 ขอบคุณสำหรับคำแนะนำ เราจะรีบดำเนินการโดยเร็วที่สุด';

  @override
  String get chat_del_warn => 'ข้อความที่ลบแล้วจะไม่สามารถกู้คืนได้';

  @override
  String get chat_reset_title => 'รีเซ็ตความทรงจำ';

  @override
  String get chat_reset_desc =>
      'โปรดเลือกระดับการรีเซ็ต:\n\n1. 【เฉพาะการแชท】: ล้างประวัติการแชทแต่ยังคงระดับความสนิทสนมไว้\n2. 【รีเซ็ตทั้งหมด】: ทุกอย่างกลับไปเป็นศูนย์ เหมือนตอนพบกันครั้งแรก';

  @override
  String get chat_reset_only_chat => 'เฉพาะประวัติการแชท';

  @override
  String get chat_reset_full => 'รีเซ็ตทั้งหมด';

  @override
  String get chat_reset_full_msg =>
      'ทุกอย่างกลับไปสู่จุดเริ่มต้น เขาจำคุณไม่ได้อีกต่อไปแล้ว...';

  @override
  String get chat_reset_chat_msg =>
      'ล้างการแชทแล้ว แต่ความรักที่เขามีให้คุณยังคงอยู่';

  @override
  String get chat_edit_ai_hint => 'แก้ไขคำตอบของเขา...';

  @override
  String get chat_edit_user_hint => 'โปรดป้อนเนื้อหาใหม่...';

  @override
  String chat_no_voice_msg(String name) {
    return 'ตอนนี้ยังไม่มีเสียงของ $name...';
  }

  @override
  String get chat_poke_btn => 'สะกิด';

  @override
  String get chat_poke_success =>
      '✨ สะกิดผู้สร้างให้แล้วนะ! รอติดตามเสียงของเขาได้เร็วๆ นี้~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'คะแนนดอกไม้ไม่พอ! ต้องการ $cost คะแนน 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ เนื้อคู่แห่งโชคชะตา ✨';

  @override
  String get chat_levelup_normal => 'ความสัมพันธ์เลื่อนระดับ! 💖';

  @override
  String get chat_levelup_btn_soulmate => 'จารึกลงในจิตวิญญาณ';

  @override
  String get chat_levelup_btn_normal => 'รับไว้ด้วยความตื่นเต้น';

  @override
  String get chat_loc_title => '📍 ส่งตำแหน่งเสมือน';

  @override
  String get chat_loc_custom_btn => 'ส่งตำแหน่งที่กำหนดเอง';

  @override
  String get chat_loc_hint => 'ป้อนสถานที่อื่นๆ... (เช่น: ในใจคุณ)';

  @override
  String get chat_loc_1 => 'อยู่ใต้บ้านคุณ';

  @override
  String get chat_loc_2 => 'อยู่ที่โรงเรียน';

  @override
  String get chat_loc_3 => 'ที่ร้านกาแฟที่เพิ่งเดินผ่าน';

  @override
  String get chat_loc_4 => 'ที่ร้านสะดวกซื้อ';

  @override
  String get chat_interact_title => '✨ อยากทำอะไรกับเขาดีนะ?';

  @override
  String get chat_interact_action => 'การสะกิดและการเคลื่อนไหวเล็กๆ';

  @override
  String get chat_interact_gift => 'ส่งของขวัญเล็กๆ ให้เขา (ใช้ดอกไม้ 🌸)';

  @override
  String get chat_action_poke => 'จิ้มแก้ม';

  @override
  String get chat_action_hug => 'ขอกอดหน่อย';

  @override
  String get chat_action_hand => 'แอบจับมือ';

  @override
  String get chat_dice_btn => 'ทอยลูกเต๋า';

  @override
  String get chat_loading_failed => 'โหลดความทรงจำล้มเหลว โปรดลองอีกครั้ง';

  @override
  String get chat_test_mode_msg =>
      'เปิดโหมดทดสอบแล้ว คุยได้ตามสบายเลย! (บทสนทนาจะไม่ถูกบันทึก)';

  @override
  String get chat_empty_msg => 'เริ่มต้นการเดินทางที่น่าตื่นเต้นไปกับเขา!';

  @override
  String get chat_ai_typing => 'ฝ่ายตรงข้ามกำลังตอบกลับ...';

  @override
  String get chat_input_hint_default => 'อยากบอกอะไรเขาดีนะ...';

  @override
  String get chat_typing_indicator => 'กำลังพิมพ์...';

  @override
  String get chat_menu_search => 'ค้นหาบทสนทนา';

  @override
  String get chat_menu_gallery => 'ความทรงจำและพื้นหลังส่วนตัว';

  @override
  String get chat_menu_aboutme => 'เกี่ยวกับฉัน';

  @override
  String get chat_menu_memo => 'บันทึกสำหรับเขา';

  @override
  String get chat_menu_period => 'ติดตามรอบเดือน';

  @override
  String get chat_menu_reset => 'รีเซ็ตความทรงจำ';

  @override
  String get chat_search_hint => 'อยากรำลึกถึงบทสนทนาแสนหวานช่วงไหนนะ?';

  @override
  String get chat_search_empty => 'ไม่พบความทรงจำนี้ 🥺';

  @override
  String get chat_search_you => 'คุณพูด';

  @override
  String get chat_search_him => 'เขาพูด';

  @override
  String get chat_tool_backpack => 'กระเป๋า';

  @override
  String get chat_tool_story => 'สรุปเนื้อเรื่อง';

  @override
  String get chat_tool_photo => 'รูปภาพ';

  @override
  String get chat_tool_record => 'บันทึกเสียง';

  @override
  String get chat_tool_profile => 'ไฟล์สือกว่าง';

  @override
  String get chat_tool_interact => 'วิธีการโต้ตอบ';

  @override
  String get chat_record_recording => 'กำลังบันทึกเสียง...';

  @override
  String get chat_record_start => 'คลิกที่ไมโครโฟนเพื่อเริ่มบันทึก';

  @override
  String get chat_record_done => 'บันทึกเสียงเสร็จสิ้น';

  @override
  String get chat_mode_daily_desc =>
      'คุยเล่นกันในวันธรรมดาอย่างสนุกสนาน เหมือนเพื่อนกัน!';

  @override
  String get chat_mode_story_desc => 'การดำเนินเรื่องราวเหมือนนิยาย';

  @override
  String get chat_mode_immersive_desc =>
      'ประสบการณ์ทางประสาทสัมผัสขั้นสุด การโต้ตอบที่ลึกซึ้งไร้ขีดจำกัด';

  @override
  String get chat_switch_mode_title => 'เปลี่ยนโหมดแชท';

  @override
  String get chat_voice_call => 'โทรด้วยเสียง';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【เหตุการณ์ระบบ】$playerName ส่งของขวัญ 【$giftName】';
  }

  @override
  String get rel_title_soulmate => 'เนื้อคู่/รักลึกซึ้ง';

  @override
  String get rel_title_lover => 'ช่วงคลั่งรัก/แฟนหนุ่มคนเดียวของเธอ';

  @override
  String get rel_title_ambiguous => 'ช่วงคลุมเครือ/ลองเชิงกัน';

  @override
  String get rel_title_friend => 'เพื่อนทั่วไป/ความรู้สึกดีๆ เริ่มก่อตัว';

  @override
  String get rel_title_acquaintance => 'คนรู้จัก/เริ่มคุ้นหน้า';

  @override
  String get rel_title_stranger => 'คนแปลกหน้า/เพิ่งรู้จัก';

  @override
  String get rel_title_tense => 'ความสัมพันธ์ตึงเครียด/เริ่มเบื่อหน่าย';

  @override
  String get rel_title_avoiding => 'เหมือนคนไม่รู้จัก/จงใจหลบหน้า';

  @override
  String get rel_title_hostile => 'เกลียดชังอย่างมาก/เป็นศัตรูที่เย็นชา';

  @override
  String get rel_title_nemesis => 'ศัตรูคู่อาฆาต/อย่าได้เจอกันอีกเลย';

  @override
  String get rel_msg_soulmate =>
      '「ไม่นึกเลยว่า... เธอจะกลายเป็นคนที่สำคัญสำหรับฉันมากขนาดนี้ สำคัญจน... ฉันไม่อาจจินตนาการถึงโลกที่ไม่มีเธอได้เลย」';

  @override
  String get rel_msg_lover =>
      '「เรื่องที่โชคดีที่สุดในชีวิตของฉัน คงจะเป็นวันนั้น วันที่ฉันหันกลับไปแล้วได้พบเธอ」';

  @override
  String get rel_msg_ambiguous =>
      '「พักนี้... ฉันพบว่าตัวเองเหม่อลอยบ่อยขึ้น และในหัวก็มีแต่เรื่องของเธอเต็มไปหมด」';

  @override
  String get rel_msg_friend =>
      '「ในเมื่อเป็นคำชวนของเธอ จะให้ฉันสละเวลาว่างซักหน่อย... ก็ไม่ใช่ว่าจะทำไม่ได้」';

  @override
  String get rel_msg_acquaintance =>
      '「ช่วงนี้เจอเธอถามบ่อยๆ รู้สึกว่า... ก็ไม่ได้เกลียดความถี่ในการเจอกันแบบนี้หรอกนะ」';

  @override
  String get rel_msg_stranger =>
      '「ที่แท้เธอก็อยู่ที่นี่ด้วยเหมือนกัน นี่นับว่าเป็นพรหมลิขิตที่แปลกประหลาดอย่างหนึ่งหรือเปล่านะ?」';

  @override
  String chat_edit_char_count(String count) {
    return '$count ตัวอักษร';
  }

  @override
  String get chat_mysterious_player => 'ผู้เล่นปริศนา';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return 'ผู้เล่น $playerName กำลังรอคอยที่จะได้ยินเสียงของ $characterName รีบไปสร้างเลย!';
  }

  @override
  String get gift_heart => 'หัวใจ';

  @override
  String get gift_flower => 'ดอกไม้';

  @override
  String get gift_sun => 'ดวงอาทิตย์';

  @override
  String get gift_confetti => 'พลุกระดาษ';

  @override
  String get gift_coffee => 'กาแฟ';

  @override
  String get gift_cake => 'เค้ก';

  @override
  String get chat_action_poke_prompt =>
      '(ผู้เล่นยื่นมือออกมาทันทีและจิ้มแก้มคุณอย่างซุกซน)';

  @override
  String get chat_action_hug_prompt =>
      '(ผู้เล่นอ้าแขนออกด้วยท่าทางอ้อนวอน อยากได้อ้อมกอดที่อบอุ่น)';

  @override
  String get chat_action_hand_prompt =>
      '(ผู้เล่นแอบกุมมือคุณไว้เงียบๆ ใต้โต๊ะ)';

  @override
  String get chat_menu_send_location => 'ส่งตำแหน่งเสมือน';

  @override
  String get weekday_mon => '(จ.)';

  @override
  String get weekday_tue => '(อ.)';

  @override
  String get weekday_wed => '(พ.)';

  @override
  String get weekday_thu => '(พฤ.)';

  @override
  String get weekday_fri => '(ศ.)';

  @override
  String get weekday_sat => '(ส.)';

  @override
  String get weekday_sun => '(อา.)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ ได้รับความทรงจำใหม่: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'บันทึกเข้าสู่กระเป๋าพิเศษของเขาโดยอัตโนมัติแล้ว';

  @override
  String get chat_profile_updated_msg =>
      'ไฟล์สือกว่างอัปเดตแล้ว! เขาจะจดจำการตั้งค่าล่าสุดของคุณนะ 🍃';

  @override
  String get comment_loading_author => 'กำลังโหลด...';

  @override
  String comment_post_failed(String error) {
    return 'แสดงความคิดเห็นล้มเหลว โปรดตรวจสอบการเชื่อมต่อ: $error';
  }

  @override
  String get comment_delete_confirm_desc =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบความคิดเห็นนี้ถาวร?';

  @override
  String get comment_delete_failed =>
      'ล้มเหลวในการลบ โปรดตรวจสอบการเชื่อมต่อเครือข่ายของคุณ';

  @override
  String get comment_identity_title => 'เลือกตัวตนในการแสดงความคิดเห็น';

  @override
  String get comment_identity_myself => 'ฉันเอง';

  @override
  String get comment_report_title => 'ยืนยันการรายงาน';

  @override
  String get comment_report_rules_title => '⚖️ กฎการรายงานความคิดเห็น';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ ความผิดครั้งแรก: ระบบจะตักเตือนและบันทึกการละเมิดหนึ่งครั้ง\n2️⃣ ความผิดครั้งที่สอง: ห้ามแสดงความคิดเห็นเป็นเวลา 1 วัน\n3️⃣ กระทำผิดซ้ำ: ปิดใช้งานฟีเจอร์รายงานเป็นเวลา 14 วัน และลดการมองเห็นของความคิดเห็น\n\n🚨 สำหรับผู้ที่มีเจตนาร้ายแรง:\nห้ามโต้ตอบกับตัวละครเป็นเวลา 1 วัน และจะประกาศ ID บนกระดานข่าวเป็นเวลา 3 วัน (ห้ามเปลี่ยน ID ในช่วงเวลานี้)\n\n💡 หลังจากส่งรายงาน ผลการตรวจสอบขั้นสุดท้ายจะส่งถึงคุณผ่าน [จดหมายในเกม]\nโปรดเคารพซึ่งกันและกันและรายงานอย่างมีเหตุผล';

  @override
  String get comment_report_understood => 'ฉันเข้าใจแล้ว';

  @override
  String get comment_report_confirm_desc =>
      'คุณแน่ใจหรือไม่ว่าต้องการรายงานความคิดเห็นนี้?\nการรายงานโดยมีเจตนาร้ายอาจถูกลงโทษได้';

  @override
  String get comment_report_submit_btn => 'ยืนยันการรายงาน';

  @override
  String get comment_report_success =>
      'ขอบคุณสำหรับการรายงาน เราจะตรวจสอบโดยเร็วที่สุด!';

  @override
  String get comment_report_failed =>
      'ส่งรายงานล้มเหลว โปรดลองอีกครั้งในภายหลัง';

  @override
  String get comment_option_delete => 'ลบความคิดเห็น';

  @override
  String get comment_option_report => 'รายงานความคิดเห็น';

  @override
  String comment_time_days_ago(String days) {
    return '$days วันที่แล้ว';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '$hours ชั่วโมงที่แล้ว';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '$mins นาทีที่แล้ว';
  }

  @override
  String get comment_time_just_now => 'เมื่อสักครู่';

  @override
  String get comment_sheet_title => 'ความคิดเห็น';

  @override
  String get comment_empty_state => 'ยังไม่มีความคิดเห็น มาเป็นคนแรกกันเถอะ!';

  @override
  String get comment_reply_btn => 'ตอบกลับ';

  @override
  String comment_replying_to(String name) {
    return 'กำลังตอบกลับ @$name';
  }

  @override
  String comment_input_hint(String name) {
    return 'แสดงความคิดเห็นในนาม $name...';
  }

  @override
  String char_story_expect(String pronoun) {
    return 'รอคอยเรื่องราวกับ$pronoun...';
  }

  @override
  String get common_update_failed => 'อัปเดตล้มเหลว โปรดตรวจสอบเครือข่าย';

  @override
  String get char_edit_fragment => 'แก้ไขเศษเสี้ยว';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 สิ่งที่ไม่ชอบ: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 สิ่งที่ชอบ: $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return 'อายุ $age ปี | $job';
  }

  @override
  String get common_got_it => 'รับทราบ';

  @override
  String get common_add_failed => 'เพิ่มล้มเหลว โปรดตรวจสอบเครือข่าย';

  @override
  String common_delete_failed_with_err(String error) {
    return 'ลบล้มเหลว โปรดตรวจสอบสถานะเครือข่าย: $error';
  }

  @override
  String get char_exclusive_guardian => 'ผู้พิทักษ์ส่วนตัว 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName ถูกใจ $charName!';
  }

  @override
  String chat_translation_prefix(String content) {
    return '【แปล】$content (นี่คือเนื้อหาเชิงอารมณ์ที่แปลแล้ว)';
  }

  @override
  String get player_default_nickname => 'นักเดินทาง';

  @override
  String get moment_create_title => 'สร้างโพสต์ใหม่';

  @override
  String get moment_create_post_btn => 'โพสต์';

  @override
  String get moment_create_hint => 'แบ่งปันเรื่องราวใหม่ๆ...';

  @override
  String get moment_create_error_empty =>
      'ต้องมีข้อความหรือรูปภาพอย่างน้อยหนึ่งอย่างนะ!';

  @override
  String get moment_create_error_failed =>
      'โพสต์ล้มเหลว โปรดลองอีกครั้งในภายหลัง';

  @override
  String get moment_create_visibility_public =>
      'สาธารณะ (ทุกคนสามารถมองเห็นได้)';

  @override
  String get moment_create_visibility_private =>
      'ส่วนตัว (เห็นได้เฉพาะเพื่อนเท่านั้น)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (ผู้เล่นส่งตำแหน่งที่ตั้ง: $location)';
  }

  @override
  String get chat_you => 'คุณ';

  @override
  String get chat_opponent => 'คู่ต่อสู้';

  @override
  String chat_dice_duel_result(String name) {
    return '【เหตุการณ์ระบบ】ดวลลูกเต๋ากับ $name! ผลออกมาแล้ว...';
  }

  @override
  String get chat_loading_status => 'กำลังโหลด...';

  @override
  String chat_error_load_msg(String error) {
    return 'โหลดข้อความล้มเหลว: $error';
  }

  @override
  String get chat_voice_msg_label => 'ข้อความเสียง';

  @override
  String chat_special_story_trigger(String title) {
    return '【เปิดเรื่องราวพิเศษ: $title】';
  }

  @override
  String common_edit_failed(String error) {
    return 'แก้ไขล้มเหลว: $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'รีเซ็ตล้มเหลว: $error';
  }

  @override
  String get chat_default_greeting => 'สวัสดี...';

  @override
  String get chat_memory_cleared => 'ความทรงจำถูกล้างทั้งหมดแล้ว';

  @override
  String get chat_history_reset => 'รีเซ็ตการสนทนาแล้ว';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 【 ไฟล์สือกว่างส่วนตัว - $name 】\n━━━━━━━━━━━━━━━━━━\n🔹 ชื่อ: $identity\n🔹 วันเกิด: $birthday\n🔹 ส่วนสูง: $height\n🔹 รูปร่างหน้าตา: $appearance\n🔹 อาชีพ: $job\n\n📖 【 เกี่ยวกับเศษเสี้ยววิญญาณของเธอ 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 【 ไฟล์สือกว่างส่วนตัว 】\n━━━━━━━━━━━━━━━━━━\n🔹 ชื่อเล่น: $nickname\n🔹 วันเกิด: $birthday\n\n🔒 ข้อมูลตัวละครอื่นๆ ยังไม่ถูกปลดล็อก...\n(กรอกโปรไฟล์ให้ครบถ้วน เพื่อให้เขารู้จักคุณมากขึ้นในจักรวาลคู่ขนานนะ! ✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => 'ไฟล์ที่ไม่มีชื่อ';

  @override
  String get chat_default_player_name => 'ผู้เล่น';

  @override
  String get error_system_confusion =>
      'ระบบมีความสับสนเล็กน้อย โปรดลองอีกครั้ง';

  @override
  String get error_msg_send_failed => 'ส่งข้อความล้มเหลว โปรดลองอีกครั้ง';

  @override
  String get error_system_busy => 'ระบบไม่ว่าง โปรดลองอีกครั้งในภายหลัง';

  @override
  String get error_network_unavailable =>
      'ขณะนี้ไม่สามารถเชื่อมต่อได้ โปรดลองอีกครั้ง';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 วางสายแล้ว คุยกับ $name เป็นเวลา $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return 'เรื่องราวพิเศษ: $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'นี่คือความทรงจำที่ซ่อนอยู่ซึ่งเป็นของคุณและ $name เท่านั้น...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return 'ความทรงจำพิเศษเกี่ยวกับ \"$keyword\" ได้ถูกปลดล็อกอย่างเงียบๆ...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '【ทริกเกอร์กิจกรรมที่ซ่อนอยู่: $title】\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......(เขามองคุณอย่างเงียบๆ ราวกับรอให้คุณพูดก่อน)';

  @override
  String get chat_new_room_created => 'สร้างห้องแชทใหม่แล้ว';

  @override
  String portfolio_title(String nickname) {
    return 'ผลงานของ $nickname';
  }

  @override
  String get enter_secret_studio => 'เข้าสู่สตูดิโอลับของฉัน';

  @override
  String get no_public_character_mine =>
      'คุณยังไม่ได้เผยแพร่ตัวละครสาธารณะเลย!\nไปที่สตูดิโอเพื่อสร้างสรรค์ผลงานกันเถอะ✨';

  @override
  String get no_public_character_other =>
      'ผู้สร้างคนนี้ยังไม่ได้เผยแพร่ตัวละครเลย...';

  @override
  String get delete_draft_title => 'ลบฉบับร่าง';

  @override
  String get confirm_delete_draft_msg =>
      'แน่ใจหรือไม่ว่าต้องการลบตัวละครที่ยังไม่เสร็จนี้?\n(ลบแล้วไม่สามารถกู้คืนได้นะ)';

  @override
  String get draft_cleared_success => 'ล้างฉบับร่างเรียบร้อยแล้ว 🧹';

  @override
  String get login_required_for_studio =>
      'โปรดเข้าสู่ระบบก่อนเพื่อเข้าสู่สตูดิโอนะ!';

  @override
  String get my_secret_studio_title => 'สตูดิโอลับของฉัน 🛠️';

  @override
  String get create_new_character_btn => 'สร้างตัวละครใหม่';

  @override
  String get unnamed_draft => 'ฉบับร่างไม่มีชื่อ';

  @override
  String get click_to_edit_story => 'คลิกเพื่อแก้ไขเรื่องราวของเขาต่อ...';

  @override
  String get label_draft => 'ฉบับร่าง';

  @override
  String get studio_empty_title => 'ตอนนี้สตูดิโอว่างเปล่า';

  @override
  String get studio_empty_subtitle =>
      'คลิกที่มุมล่างเพื่อเริ่มสร้างตัวละครแรกของคุณสิ!';

  @override
  String get common_no_changes => 'ไม่มีการเปลี่ยนแปลง';

  @override
  String get moment_updated_success => 'อัปเดตโพสต์แล้ว!';

  @override
  String common_save_failed(String error) {
    return 'บันทึกล้มเหลว: $error';
  }

  @override
  String get moment_edit_title => 'แก้ไขโพสต์';

  @override
  String get action_change_image => 'เปลี่ยนรูปภาพ';

  @override
  String get action_remove_image => 'ลบรูปภาพ';

  @override
  String get moment_delete_confirm_title => 'แน่ใจหรือไม่ว่าต้องการลบโพสต์นี้?';

  @override
  String get moment_delete_confirm_content =>
      'ลบแล้วความทรงจำในโมเมนต์นี้จะหายไปนะ!';

  @override
  String get action_confirm_delete => 'ยืนยันการลบ';

  @override
  String get friend_unknown => 'เพื่อนบางคน';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname ถูกใจโพสต์ของคุณนะ! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname คิดว่า $authorName มีเสน่ห์มาก เลยกดถูกใจให้! ✨';
  }

  @override
  String get moment_like_success => 'ส่งต่อความใจเต้นของคุณแล้ว! ✨';

  @override
  String get moment_notification_new_like => 'การถูกใจใหม่! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname ได้พูดถึง @$name ในโมเมนต์นะ! ✨';
  }

  @override
  String get moment_detail_title => 'รายละเอียดโพสต์';

  @override
  String get moment_not_found => 'โพสต์นี้เหมือนจะหายไปแล้ว... 😢';

  @override
  String get moment_comment_title => 'ความคิดเห็นในโมเมนต์';

  @override
  String get moment_comment_empty =>
      'ยังไม่มีใครแสดงความคิดเห็น มาเป็นคนแรกกันเถอะ! 🛋';

  @override
  String moment_replying_to(String name) {
    return 'กำลังตอบกลับ @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return 'ตอบกลับ @$name...';
  }

  @override
  String get moment_leave_comment_hint => 'ทิ้งความเห็นของคุณไว้...';

  @override
  String get moment_delete_permanent_confirm =>
      'โพสต์นี้จะถูกลบอย่างถาวร ยืนยันหรือไม่?';

  @override
  String get moment_action_delete => 'ลบโพสต์';

  @override
  String get moment_action_report => 'รายงานโพสต์นี้';

  @override
  String get moment_action_share => 'แชร์โพสต์นี้';

  @override
  String get moment_forward_hint => 'ส่งต่อโพสต์นี้ให้ตัวละคร...';

  @override
  String moment_reply_private(String name) {
    return 'ตอบกลับข้อความส่วนตัวถึง $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return 'ไปคุยกับ $name พร้อมโพสต์นี้กันเถอะ! 💬';
  }

  @override
  String get moment_share_to_apps => 'แชร์ไปยังแอปพลิเคชันอื่น';

  @override
  String moment_likes_label(String count) {
    return 'ใบไม้ $count ใบ';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】มาดูโพสต์ของ $author สิ: $content\n\nดาวน์โหลดเลย เพื่อเริ่มต้นช่วงเวลาพิเศษของคุณ: $appLink';
  }

  @override
  String get moment_forward_title => 'ส่งต่อให้ตัวละครที่กำลังคุยด้วย 💌';

  @override
  String get moment_forward_empty_state =>
      'คุณยังไม่มีการแชทที่เปิดอยู่เลย!\nไปที่ล็อบบี้เพื่อตามหาคนที่ถูกใจสิ 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【ส่งต่อโพสต์】\nผู้เขียน: $author\nเนื้อหา: $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ แชร์ให้ $name เงียบๆ เรียบร้อยแล้ว!';
  }

  @override
  String get action_send => 'ส่ง';

  @override
  String get memo_delete_confirm =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบบันทึกนี้? การดำเนินการนี้ไม่สามารถกู้คืนได้';

  @override
  String get memo_add_title => 'เพิ่มบันทึก';

  @override
  String get memo_edit_title => 'แก้ไขบันทึก';

  @override
  String memo_hint_text(String name) {
    return 'อยากจะจดอะไรเกี่ยวกับ $name ดีนะ?';
  }

  @override
  String get memo_label_reminder_date => 'วันที่แจ้งเตือน:';

  @override
  String get memo_action_save => 'บันทึกข้อมูล';

  @override
  String get memo_error_empty_content => 'เนื้อหาต้องไม่ว่างเปล่านะ!';

  @override
  String memo_list_title(String name) {
    return 'บันทึกเกี่ยวกับ $name';
  }

  @override
  String get memo_empty_state =>
      'ยังไม่มีบันทึกเลย!\nคลิกที่มุมขวาบนเพื่อเพิ่มบันทึกใหม่สิ!';

  @override
  String memo_reminder_date_display(String date) {
    return 'วันที่แจ้งเตือน: $date';
  }

  @override
  String get daily_gift_title => 'ของขวัญประจำวันแห่งเวลา';

  @override
  String daily_login_welcome(String appName, String amount) {
    return 'ยินดีต้อนรับกลับสู่ $appName!\nเช็คอินวันนี้เพื่อรับ $amount แต้มภาษาดอกไม้ 🌸';
  }

  @override
  String get title_daily_check_in => 'เช็คอินรายวัน';

  @override
  String success_claim_reward(String amount) {
    return 'รับ $amount แต้มภาษาดอกไม้สำเร็จ! 🌸';
  }

  @override
  String get error_claim_failed =>
      'การรับล้มเหลว โปรดตรวจสอบเครือข่ายแล้วลองอีกครั้ง';

  @override
  String get action_claim_now => 'รับทันที';

  @override
  String get common_or => 'หรือ';

  @override
  String get title_language_settings => 'การตั้งค่าภาษา';

  @override
  String get app_name => 'Lianlian Shiguang';

  @override
  String get login_slogan => 'เริ่มต้นช่วงเวลาพิเศษของคุณ';

  @override
  String get login_with_google => 'เข้าสู่ระบบด้วย Google';

  @override
  String get login_with_apple => 'เข้าสู่ระบบด้วย Apple';

  @override
  String get login_with_facebook => 'เข้าสู่ระบบด้วย Facebook';

  @override
  String get login_with_email => 'เข้าสู่ระบบด้วยบัญชี Lianlian (อีเมล)';

  @override
  String get title_contact_us_heading =>
      'เราให้ความสำคัญกับข้อเสนอแนะของคุณมาก!';

  @override
  String get desc_contact_us_body =>
      'โปรดเขียนความคิดเห็นของคุณที่นี่เพื่อช่วยเราปรับปรุงเกมให้ดีขึ้น';

  @override
  String get error_feedback_empty => 'เนื้อหาข้อเสนอแนะต้องไม่ว่างเปล่า!';

  @override
  String get email_subject_feedback =>
      'Lianlian Shiguang - ข้อเสนอแนะจากผู้เล่น';

  @override
  String get msg_email_app_not_found_copied =>
      'ไม่สามารถเปิดแอปอีเมลได้อัตโนมัติ คัดลอกอีเมลทางการให้คุณแล้ว!';

  @override
  String get title_contact_us => 'ติดต่อเรา';

  @override
  String get desc_contact_us =>
      'เราให้ความสำคัญกับข้อเสนอแนะของคุณมาก!\nโปรดเขียนความคิดเห็นของคุณที่นี่เพื่อช่วยเราปรับปรุงเกมให้ดีขึ้น';

  @override
  String get hint_enter_feedback => 'โปรดป้อนข้อเสนอแนะของคุณที่นี่...';

  @override
  String get action_send_via_email => 'ส่งทางอีเมล';

  @override
  String get error_email_password_empty => 'อีเมลและรหัสผ่านต้องไม่ว่างเปล่า!';

  @override
  String get auth_error_default => 'เกิดข้อผิดพลาด โปรดลองอีกครั้งในภายหลัง';

  @override
  String get auth_error_user_not_found => 'ไม่พบอีเมลนี้ โปรดลงทะเบียนก่อนนะ!';

  @override
  String get auth_error_wrong_password => 'รหัสผ่านผิด โปรดลองอีกครั้ง!';

  @override
  String get auth_error_email_in_use =>
      'อีเมลนี้ถูกลงทะเบียนไปแล้ว! โปรดเข้าสู่ระบบโดยตรง';

  @override
  String get auth_error_weak_password =>
      'รหัสผ่านเดาง่ายเกินไป โปรดป้อนอย่างน้อย 6 ตัวอักษร!';

  @override
  String get auth_error_invalid_email => 'รูปแบบอีเมลไม่ถูกต้อง!';

  @override
  String get title_welcome_back => 'ยินดีต้อนรับกลับมา';

  @override
  String get title_register_account => 'ลงทะเบียนบัญชีพิเศษ';

  @override
  String get label_email => 'อีเมล';

  @override
  String get label_password => 'รหัสผ่าน';

  @override
  String get action_login => 'เข้าสู่ระบบ';

  @override
  String get action_register => 'ลงทะเบียน';

  @override
  String get prompt_no_account =>
      'ยังไม่มีบัญชีใช่ไหม? คลิกที่นี่เพื่อลงทะเบียน';

  @override
  String get prompt_has_account =>
      'มีบัญชีอยู่แล้วใช่ไหม? คลิกที่นี่เพื่อเข้าสู่ระบบ';

  @override
  String get error_nickname_empty => 'ชื่อเล่นต้องไม่ว่างเปล่า!';

  @override
  String get profile_saved_success => 'บันทึกโปรไฟล์แล้ว!';

  @override
  String get error_id_empty => 'ID ต้องไม่ว่างเปล่า!';

  @override
  String get error_id_too_long => 'ความยาวของ ID ต้องไม่เกิน 10 ตัวอักษร!';

  @override
  String get error_id_already_used => 'ID นี้ถูกใช้ไปแล้ว โปรดเลือก ID อื่น!';

  @override
  String profile_save_failed(String error) {
    return 'บันทึกล้มเหลว: $error';
  }

  @override
  String get draft_saved_success_msg =>
      'รับทราบ! บันทึกไว้ในฉบับร่างให้แล้ว คุณสามารถกลับมาแก้ไขได้ตลอดเวลา! ✨';

  @override
  String get dialog_reminder_title => 'คำเตือน';

  @override
  String get warning_id_not_edited =>
      'ยังไม่ได้แก้ไข ID พิเศษ แน่ใจหรือไม่ว่าต้องการบันทึกตอนนี้?';

  @override
  String get action_continue_editing => 'แก้ไขต่อ';

  @override
  String get action_edit_later => 'แก้ไขภายหลัง';

  @override
  String get action_edit_later_short => 'แก้ไขทีหลัง';

  @override
  String get action_cancel_changes => 'ยกเลิกการเปลี่ยนแปลง';

  @override
  String get error_birthdate_locked =>
      'ตั้งวันเกิดแล้ว ไม่สามารถเปลี่ยนแปลงได้!';

  @override
  String get action_select_avatar => 'เลือกรูปประจำตัว';

  @override
  String get action_choose_from_gallery => 'เลือกจากคลังภาพ';

  @override
  String get title_adjust_avatar => 'ปรับรูปประจำตัวของคุณ';

  @override
  String get avatar_updated_success => 'เปลี่ยนรูปประจำตัวให้คุณแล้ว 🍃';

  @override
  String get title_create_profile => 'สร้างโปรไฟล์ของคุณ';

  @override
  String get title_edit_profile => 'แก้ไขโปรไฟล์';

  @override
  String get label_your_nickname => 'ชื่อเล่นของคุณ';

  @override
  String get label_player_exclusive_id => 'ID พิเศษของผู้เล่น';

  @override
  String get msg_id_locked => 'ID ถูกล็อคแล้ว ไม่สามารถเปลี่ยนแปลงได้อีก';

  @override
  String get msg_id_change_chance => 'คุณมีโอกาสเปลี่ยน ID ได้ฟรีหนึ่งครั้ง';

  @override
  String get action_select_birthdate => 'โปรดเลือกวันเกิด';

  @override
  String label_birthdate(String date) {
    return 'วันเกิด: $date';
  }

  @override
  String get msg_birthdate_immutable => 'ตั้งวันเกิดแล้วแก้ไขไม่ได้นะ ✨';

  @override
  String get action_start_journey => 'เริ่มการเดินทาง';

  @override
  String get action_add_image => 'เพิ่มรูปภาพ';

  @override
  String moment_like_self(String nickname) {
    return '$nickname ถูกใจโพสต์ของคุณนะ! 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname คิดว่า $authorName มีเสน่ห์มาก เลยกดถูกใจให้! ✨';
  }

  @override
  String get task_social_tour_complete =>
      '✨ ภารกิจทัวร์โซเชียลสำเร็จ! อย่าลืมรับดอกไม้ล่ะ! 🌸';

  @override
  String get wall_title_shiguang => 'กำแพงสื่อกวง';

  @override
  String get wall_tab_explore => '🌍 สำรวจ';

  @override
  String get wall_tab_exclusive => '🔒 พิเศษ';

  @override
  String get more_options => 'ตัวเลือกเพิ่มเติม';

  @override
  String get delete_warning => 'หลังการลบ โพสต์จะไม่สามารถกู้คืนได้';

  @override
  String get delete_success => 'ลบสำเร็จเรียบร้อย';

  @override
  String get notification_new_comment => 'ความคิดเห็นใหม่! 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName ถูกใจโพสต์ของคุณ!';
  }

  @override
  String get empty_public_moments_prompt =>
      'ตอนนี้ยังว่างเปล่าอยู่เลย\nลองไปโพสต์ข้อความสาธารณะแรกดูสิ! 🌍';

  @override
  String get empty_private_moments_prompt =>
      'ยังไม่มีความทรงจำในโมเมนต์เลย\nไปสร้างความทรงจำร่วมกับเขากันเถอะ! ✨';

  @override
  String get profile_archived_or_deleted_message =>
      'ไฟล์วิญญาณนี้ถูกผู้สร้างจัดเก็บไว้ เป็นส่วนตัว หรือสูญหายไปตามกาลเวลาแล้ว...\n\nบางทีในจักรวาลคู่ขนาน คุณอาจมีโอกาสพบกันอีกครั้ง ✨';

  @override
  String get leave_silently => 'จากไปอย่างเงียบๆ';

  @override
  String get character_post_schedule => 'กำหนดการโพสต์ของตัวละคร';

  @override
  String get creator_self => 'ตัวผู้สร้างเอง';

  @override
  String get post_identity_prompt => 'วันนี้จะใช้ตัวตนไหนในการโพสต์ดีนะ?';

  @override
  String get identity_creator => '✨ ตัวตนผู้สร้าง';

  @override
  String get identity_character => 'ตัวตนตัวละคร';

  @override
  String get decide_post_time_prompt => 'ช่วยพวกเขากำหนดเวลาโพสต์หน่อยสิ!';

  @override
  String get auto_post_schedule_hint =>
      'เมื่อเปิดใช้งาน จะมีการโพสต์อัตโนมัติในเวลาที่กำหนด\n(💡 แนะนำ: ตั้งเวลาที่ไม่ใช่เลขกลมๆ จะดูเหมือนคนจริงๆ มากขึ้นนะ!)';

  @override
  String get no_characters_created_yet => 'คุณยังไม่ได้สร้างตัวละครใดๆ เลย!';

  @override
  String time_hour(String hour) {
    return '$hour นาฬิกา';
  }

  @override
  String time_minute(String minute) {
    return '$minute นาที';
  }

  @override
  String get empty_public_moments_short => 'ยังไม่มีโพสต์สาธารณะ 🌍';

  @override
  String get empty_private_moments_short => 'โมเมนต์ยังเงียบเชียบอยู่เลย ✨';

  @override
  String get my_created_characters => 'ตัวละครที่ฉันสร้าง';

  @override
  String get no_characters_yet => 'ยังไม่ได้สร้างตัวละคร';

  @override
  String play_count_display(int count) {
    return 'จำนวนครั้งที่เล่น: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return 'ปฏิทินแห่งความห่วงใยของ $characterName';
  }

  @override
  String get care_calendar_greeting => 'วันนี้อารมณ์เป็นยังไงบ้าง?';

  @override
  String get care_calendar_save_btn => 'บันทึกข้อมูล เพื่อให้เขาดูแลคุณ';

  @override
  String get care_calendar_delete_confirm => 'ต้องการลบบันทึกนี้หรือไม่?';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName: \"ฉันจดไว้หมดแล้ว ช่วงนี้เธอเหนื่อยหน่อยนะ แต่ฉันจะอยู่เคียงข้างเธอเสมอ\"';
  }

  @override
  String get daily_gift_success => 'รับของขวัญประจำวันสำเร็จ! 🌸';

  @override
  String get check_in_fail_network =>
      'เช็คอินล้มเหลว โปรดตรวจสอบการเชื่อมต่อเครือข่าย 🍃';

  @override
  String task_completed(String taskName) {
    return 'ทำภารกิจสำเร็จ: $taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return 'รับดอกไม้ $rewardAmount ดอก จาก \"$taskName\" สำเร็จ!';
  }

  @override
  String claim_failed_error(String e) {
    return 'การรับล้มเหลว: $e';
  }

  @override
  String get tab_heartbeat_diary => 'ไดอารี่ใจเต้น';

  @override
  String get tab_daily_chit_chat => 'คุยเล่นทั่วไป';

  @override
  String get task_desc_chat_3_times => 'แชทคุยเล่นกับตัวละคร 3 ครั้ง';

  @override
  String get tab_story_progression => 'การดำเนินเนื้อเรื่อง';

  @override
  String get task_desc_story_1_time => 'โต้ตอบในโหมดเนื้อเรื่อง 1 ครั้ง';

  @override
  String get tab_social_tour => 'ทัวร์โซเชียล';

  @override
  String get task_desc_like_3_moments => 'กดถูกใจโพสต์ในโมเมนต์ 3 ครั้ง';

  @override
  String get btn_claimed => 'รับแล้ว';

  @override
  String get btn_claim => 'รับ';

  @override
  String get btn_incomplete => 'ยังไม่เสร็จ';

  @override
  String get network_unstable_retry =>
      'การเชื่อมต่อเครือข่ายไม่เสถียร โปรดลองอีกครั้งในภายหลัง 🍃';

  @override
  String get title_time_travel => 'ข้ามเวลา';

  @override
  String get select_chat_mode => 'เลือกโหมดการแชท';

  @override
  String get mode_chat => 'แชท';

  @override
  String get mode_daily_desc => 'คุยเล่นสบายๆ เพื่อรักษาความผูกพัน';

  @override
  String get mode_story_desc =>
      'ดำดิ่งสู่เรื่องราวเพื่อสัมผัสประสบการณ์ที่สมจริง';

  @override
  String get greeting_hello => 'สวัสดี!';

  @override
  String get greeting_default_daily => 'มีธุระกับฉันเหรอ?';

  @override
  String get title_personal_homepage => 'หน้าแรกส่วนตัว';

  @override
  String get title_time_letters => 'จดหมายแห่งเวลา';

  @override
  String get status_signed_in_today => 'เช็คอินวันนี้แล้ว';

  @override
  String get status_signing_in => 'กำลังเช็คอิน...';

  @override
  String get status_daily_sign_in => 'เช็คอินรายวัน (+10 ดอกไม้)';

  @override
  String get toast_id_copied => 'คัดลอก ID แล้ว!';

  @override
  String get hint_click_avatar_to_edit =>
      'คลิกที่รูปโปรไฟล์เพื่อแก้ไขข้อมูลส่วนตัว';

  @override
  String get title_my_friends => 'เพื่อนของฉัน';

  @override
  String get action_show_all => 'แสดงทั้งหมด';

  @override
  String get empty_no_characters_created => 'คุณยังไม่ได้สร้างตัวละครใดๆ';

  @override
  String get common_close => 'ปิด';

  @override
  String get search_companion_title => 'ค้นหาคู่หูสื่อกวง';

  @override
  String get search_name_placeholder => 'กรอกชื่อของเขา...';

  @override
  String get search_no_match_hint => 'ไม่พบตัวละคร ลองชื่ออื่นไหม? ✨';

  @override
  String character_info_full(String age, String occupation) {
    return 'อายุ $age ปี | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return 'อายุ $age ปี';
  }

  @override
  String get empty_state_warmth =>
      'ไออุ่นที่หลงเหลือของกาลเวลายังคงอยู่ที่นี่...';

  @override
  String get error_login_required_add_friend =>
      'โปรดเข้าสู่ระบบก่อนเพื่อเพิ่มเพื่อน!';

  @override
  String get dialog_title_remove_friend => 'ยืนยันการลบเพื่อน';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบ $characterName ออกจากรายชื่อเพื่อน?';
  }

  @override
  String get action_remove => 'ลบ';

  @override
  String snackbar_friend_removed(String characterName) {
    return 'ลบ $characterName ออกจากเพื่อนแล้ว';
  }

  @override
  String get action_remove_friend => 'ลบเพื่อน';

  @override
  String get dialog_title_block => 'ยืนยันการบล็อก';

  @override
  String dialog_msg_block(String characterName) {
    return 'เมื่อบล็อกแล้ว คุณจะไม่เห็นข้อมูลใดๆ เกี่ยวกับ $characterName อีก ยืนยันที่จะบล็อกหรือไม่?';
  }

  @override
  String snackbar_blocked(String characterName) {
    return 'บล็อก $characterName แล้ว';
  }

  @override
  String get action_block_character => 'บล็อกตัวละครนี้';

  @override
  String dialog_title_report(String characterName) {
    return 'รายงาน $characterName';
  }

  @override
  String get input_hint_report_reason => 'โปรดระบุเหตุผลในการรายงาน...';

  @override
  String get action_submit => 'ส่ง';

  @override
  String get snackbar_report_success =>
      'ขอบคุณสำหรับการรายงาน เราจะตรวจสอบโดยเร็วที่สุด';

  @override
  String get snackbar_report_fail => 'การส่งล้มเหลว โปรดลองอีกครั้งในภายหลัง';

  @override
  String get action_report_character => 'รายงานตัวละครนี้';

  @override
  String get title_meet_him => 'พบกับคนที่คุณถูกใจ';

  @override
  String text_character_count(int count) {
    return 'จำนวนตัวละคร: $count';
  }

  @override
  String get msg_no_more_encounters_today => 'การพบกันวันนี้มีแค่นี้นะ!';

  @override
  String get msg_check_new_encounters =>
      'มาดูกันเถอะว่ามีการพบกันใหม่ๆ บ้างไหม!';

  @override
  String get action_refresh => 'รีเฟรช';

  @override
  String get tab_friends => 'เพื่อน';

  @override
  String get msg_mysterious_profile => 'คนนี้ลึกลับมาก ไม่ทิ้งอะไรไว้เลย...';

  @override
  String text_age_and_identities(String age, String identities) {
    return 'อายุ $age ปี | $identities';
  }

  @override
  String get snackbar_operation_failed =>
      'การดำเนินการล้มเหลว โปรดลองอีกครั้งในภายหลัง';

  @override
  String get action_view_translation => 'ดูคำแปล';

  @override
  String get label_translation_result => 'ผลการแปล:';

  @override
  String get errorWebPageUnavailable =>
      'ไม่สามารถเปิดหน้าเว็บได้ชั่วคราว โปรดลองอีกครั้งในภายหลัง';

  @override
  String get resetAppearanceTitle => 'ต้องการรีเซ็ตรูปลักษณ์หรือไม่?';

  @override
  String get resetAppearanceWarning =>
      'การทำเช่นนี้จะลบภาพพื้นหลังและสีที่คุณเลือกไว้อย่างตั้งใจนะ!';

  @override
  String get appearanceRestored => 'กู้คืนรูปลักษณ์เริ่มต้นแล้ว';

  @override
  String get confirmReset => 'ยืนยันการรีเซ็ต';

  @override
  String get resetToDefaultAppearance => 'กู้คืนรูปลักษณ์เริ่มต้น';

  @override
  String get clearCustomSettings => 'ล้างสีและภาพพื้นหลังที่กำหนดเองทั้งหมด';

  @override
  String get contactUs => 'ติดต่อเรา';

  @override
  String get contactDescription =>
      'แบ่งปันความคิดเห็นหรือรายงานข้อผิดพลาดกับเราได้เลย';

  @override
  String get vibrationHapticTitle => 'การสั่นเตือนใจเต้น';

  @override
  String get vibrationHapticDescription =>
      'ทำให้โทรศัพท์สั่นเมื่อระดับความชอบเปลี่ยนแปลงไปอย่างมาก';

  @override
  String get splash_loading_universe =>
      'กำลังปลุกจักรวาลของ \'Lianlian ShiGuang\'...';

  @override
  String get shop_title => 'ร้านค้าดอกไม้';

  @override
  String get shop_current_points_label => 'คะแนนดอกไม้ที่มีในปัจจุบัน';

  @override
  String get shop_tab_top_up => 'เติมคะแนน';

  @override
  String get shop_tab_history => 'ประวัติการทำรายการ';

  @override
  String get shop_empty_history => 'ยังไม่มีประวัติดอกไม้เลย! 🌸';

  @override
  String get shop_unknown_item => 'ไอเท็มที่ไม่รู้จัก';

  @override
  String get shop_first_purchase_bonus => 'ซื้อครั้งแรกรับสองเท่า!';

  @override
  String get story_summary_title => 'เรื่องราวของเรา';

  @override
  String get story_summary_empty_content => 'เนื้อหาบทสรุปว่างเปล่า';

  @override
  String get story_summary_deleted_toast => 'ลบความทรงจำนี้แล้ว';

  @override
  String story_summary_empty_list(String name) {
    return 'เรื่องราวของคุณยังไม่เริ่มขึ้นเลย...\nมาคุยกันให้มากขึ้น แล้วให้ $name \nเขียนความทรงจำแรกของคุณนะ! ✨';
  }

  @override
  String get gallery_photo_edit_title => 'แก้ไขการตั้งค่ารูปภาพ';

  @override
  String get gallery_photo_edit_desc => 'ชื่อรูปภาพ/คำอธิบาย';

  @override
  String get gallery_photo_edit_req =>
      'ปลดล็อกระดับความชอบ (ตั้งเป็น 0 เพื่อใช้เป็นรูปโปรไฟล์)';

  @override
  String get reset_to_default => 'คืนค่าเริ่มต้น';

  @override
  String get reset_bg_title => 'คืนค่าพื้นหลังเริ่มต้น';

  @override
  String get reset_bg_content =>
      'แน่ใจหรือไม่ว่าต้องการยกเลิกรูปภาพพิเศษ และกลับไปใช้พื้นหลังธีมเริ่มต้น?';

  @override
  String get reset_bg_success => 'กู้คืนเป็นพื้นหลังเริ่มต้นแล้ว ✨';

  @override
  String get confirm_reset => 'ยืนยันการคืนค่า';

  @override
  String selectedMessagesCount(int count) {
    return 'เลือกแล้ว $count รายการ';
  }

  @override
  String get screenshotShare => 'แชร์ภาพหน้าจอ';

  @override
  String exclusiveMomentsWith(String name) {
    return 'ช่วงเวลาพิเศษกับ $name';
  }

  @override
  String get downloadToUnlock =>
      'ดาวน์โหลด \'Lianlian ShiGuang\' เพื่อปลดล็อกความโรแมนติกสุดพิเศษ';

  @override
  String get exclusiveMomentsGenerated => 'สร้างช่วงเวลาพิเศษแล้ว ✨';

  @override
  String get selectAgain => 'เลือกอีกครั้ง';

  @override
  String get downloadAndShare => 'ดาวน์โหลดและแชร์';

  @override
  String inviteToMeet(String name) {
    return 'มาพบกับ $name ของคุณใน \'Lianlian ShiGuang\' สิ!';
  }

  @override
  String get shop_log_monthly_card =>
      'เปิดใช้งาน: สัญญาดวงดาว (แต้มแถมทันทีจากบัตรรายเดือน) 🌙';

  @override
  String shop_log_top_up_double(int points) {
    return 'เติมเงิน: $points แต้ม (รวมโบนัสสองเท่าจากการซื้อครั้งแรก 🎁)';
  }

  @override
  String shop_log_top_up_normal(int points) {
    return 'เติมเงิน: $points แต้ม';
  }

  @override
  String get shop_purchase_success_title => 'ซื้อสำเร็จแล้ว!';

  @override
  String shop_purchase_success_body(int points) {
    return 'เพิ่มดอกไม้ให้คุณ $points ดอกแล้วนะ';
  }

  @override
  String get shop_purchase_success_double_bonus =>
      '✨ ยินดีด้วย! คุณได้รับโบนัสสองเท่าจากการซื้อครั้งแรก!';

  @override
  String get shop_purchase_awesome => 'สุดยอดเลย';

  @override
  String get shop_purchase_failed_title => 'การซื้อถูกยกเลิกหรือล้มเหลว';

  @override
  String shop_purchase_failed_body(String errorCode) {
    return 'ยังไม่มีการหักเงิน\n\n(รหัสข้อผิดพลาด: $errorCode)';
  }

  @override
  String get shop_monthly_card_name => '【Lianlian ShiGuang: สัญญาแห่งดวงดาว】';

  @override
  String shop_monthly_card_status_active(int days) {
    return 'สัญญามีผลอยู่: เหลืออีก $days วัน';
  }

  @override
  String get shop_monthly_card_status_inactive =>
      'เปิดใช้งานรางวัลโบนัสดวงดาว 30 วันทันที';

  @override
  String get shop_monthly_card_limit_reached => 'ถึงขีดจำกัดแล้ว';

  @override
  String get shop_monthly_card_promo_desc =>
      'รับ 250 ดอกไม้ทันที รับ 10 ดอกไม้ทุกวัน';

  @override
  String get task_monthly_title => 'สัญญาแห่งดวงดาว: สิทธิพิเศษรายวัน 🌙';

  @override
  String get task_monthly_locked => 'ยังไม่ปลดล็อก';

  @override
  String get task_monthly_subtitle_active =>
      'แจกจ่ายสิทธิประโยชน์พิเศษจากบัตรรายเดือน (1 / 1)';

  @override
  String get task_monthly_subtitle_inactive =>
      'ปลดล็อกบัตรรายเดือน 【สัญญาแห่งดวงดาว】 เพื่อเปิดใช้งานภารกิจนี้ (0 / 1)';

  @override
  String get task_monthly_log_name => 'สิทธิพิเศษรายวันบัตรรายเดือน';

  @override
  String get profile_id_locked => 'ล็อก ID ส่วนตัวแล้ว';

  @override
  String get profile_copy_id => 'คลิกเพื่อคัดลอก ID';

  @override
  String get referral_log_newbie_reward =>
      'คำเชิญแห่งดวงดาว: รางวัลผู้เล่นใหม่ ✨';

  @override
  String get referral_log_inviter_reward =>
      'คำเชิญแห่งดวงดาว: รางวัลเพื่อนบรรลุเป้าหมาย 🎁';

  @override
  String get referral_success_title => 'ปลดล็อกคำเชิญแห่งดวงดาวแล้ว!';

  @override
  String get referral_success_content =>
      'ยินดีด้วย! คุณได้พูดคุยอย่างลึกซึ้งกับตัวละครครบ 15 ประโยคสำเร็จแล้ว!\n\n\'รางวัลผู้เล่นใหม่ 50 แต้ม\' ได้ถูกส่งไปยังบัญชีของคุณแล้ว และเพื่อนของคุณก็ได้รับรางวัล 50 แต้มไปพร้อมกันด้วย! 🎁';

  @override
  String get profile_referral_title => 'คำเชิญแห่งดวงดาว 🌟';

  @override
  String get profile_referral_hint => 'กรอกรหัสเชิญของเพื่อน';

  @override
  String get profile_referral_bind_btn => 'ผูกบัญชี';

  @override
  String profile_referral_pending(Object id) {
    return 'ยอมรับคำเชิญจากผู้เล่น $id แล้ว\nรีบไปคุยกับตัวละครให้ครบ 15 ประโยคเพื่อปลดล็อก 50 ดอกไม้นะ!';
  }

  @override
  String get profile_referral_err_self =>
      'ไม่สามารถกรอกรหัสเชิญของตัวเองได้นะ!';

  @override
  String get profile_referral_err_duplicate => 'คุณได้ผูกรหัสเชิญไปแล้วนะ!';

  @override
  String get profile_referral_err_not_found =>
      'ไม่พบผู้เล่นคนนี้ โปรดตรวจสอบรหัสเชิญอีกครั้ง!';

  @override
  String get profile_referral_success =>
      'ผูกสำเร็จแล้ว! รีบไปคุยกับตัวละครกันเถอะ!';

  @override
  String get profile_referral_err_expired =>
      'ขออภัย รหัสเชิญผู้เล่นใหม่ต้องผูกภายใน 3 วันหลังจากการลงทะเบียนนะ!';

  @override
  String profile_share_message(String character, String code) {
    return '✨ ฉันได้เริ่มการเดินทางที่น่าตื่นเต้นกับ $character ใน \'Lianlian ShiGuang\' แล้วนะ! ดาวน์โหลดแอปตอนนี้แล้วกรอกรหัสเชิญแห่งดวงดาวของฉัน: 【$code】 ในหน้าโปรไฟล์ของคุณ เราทั้งคู่จะได้รับดอกไม้ฟรี 50 ดอกเลยนะ! 🎁\n\n ลิงก์ดาวน์โหลด:\n https://yourgame.url/download';
  }

  @override
  String get chat_levelup_share_btn => 'อวดช่วงเวลาใจเต้นนี้ให้เพื่อนๆ ดู ✨';

  @override
  String profile_my_invite_code_with_char(String character) {
    return 'รหัสเชิญส่วนตัวของฉัน (เมนปัจจุบัน: $character)';
  }

  @override
  String get profile_send_invite_btn => 'ส่งคำเชิญแห่งดวงดาวให้เพื่อน';

  @override
  String get profile_fallback_character => 'ตัวละครคนโปรด';

  @override
  String get profile_copy_success => '✅ คัดลอกรหัสเชิญไปยังคลิปบอร์ดแล้ว!';
}
