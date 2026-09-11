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
  String get charNameLabel => 'ชื่อตัวละคร:';

  @override
  String get charDescSection => 'คำอธิบายตัวละคร:';

  @override
  String get charAgeLabel => 'อายุ:';

  @override
  String get charJobLabel => 'อาชีพ:';

  @override
  String get charBirthdayLabel => 'วันเกิด:(MMDD)';

  @override
  String get charGenderLabel => 'เพศ ';

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
  String get logoutSuccessSnackbar => 'ตกลง! ฉันจะรอคุณกลับมา(´∀` )';

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
  String get terms_title => 'ข้อตกลงการใช้งาน';

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
      'ดาวน์โหลดข้อมูลเสียงสำเร็จ เตรียมพร้อมเล่น...';

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
  String get test_mode_notice =>
      'โหมดทดสอบจะหักคะแนนตามราคาปกติของแต่ละโหมด และจะไม่ถูกบันทึกในความทรงจำที่เป็นทางการ!';

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
  String get section_story_identity => 'เนื้อเรื่องและตัวตนของคุณ';

  @override
  String get story_identity_desc =>
      'กำหนดการเปิดเนื้อเรื่องและการตั้งค่าพิเศษสำหรับ \"คุณ\" ในเซฟนี้';

  @override
  String get advanced_writing_tips_title => 'เทคนิคการเขียนขั้นสูง:\n';

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
  String get section_personality_evo => 'การพัฒนาบุคลิกภาพและความสนิทสนม';

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
  String get section_habits => 'ความชอบและนิสัย';

  @override
  String get tone_hint_detail =>
      'จำเป็นต้องกรอก เช่น พูดจาสั้นๆ ชอบถามย้อน คำติดปากคือ \"คนบ้า\" ห้ามใช้น้ำเสียงแบบโปรแกรมแปลภาษา';

  @override
  String get dialogue_example_hint =>
      'ผู้เล่น: ฉันเหนื่อยมากเลย\nตัวละคร: (ลูบหัว) เด็กดี ไปพักผ่อนเร็ว';

  @override
  String get section_easter_eggs =>
      'อีสเตอร์เอ็กที่ซ่อนอยู่และเนื้อเรื่องพิเศษ';

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
  String get section_voice_gen => 'สร้างเสียงส่วนตัวของเขา';

  @override
  String get voice_gen_desc =>
      'ใส่คำอธิบายเพื่อให้เขามีเสียงส่วนตัวหนึ่งเดียวในโลก!\n(คำแนะนำ: หากไม่พอใจหลังสร้าง สามารถสั่งทำใหม่ได้ตลอดเวลา!)';

  @override
  String get voice_generating_status => 'กำลังปรุงแต่งน้ำเสียง...';

  @override
  String get voice_select_prompt => 'เตรียมเสียงไว้ให้ 3 แบบ โปรดเลือก:';

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
  String get voice_advanced_tuning => 'ขั้นสูง: ปรับจูนอารมณ์การพูด';

  @override
  String get voice_stability_low => 'ดุดัน/เสียงลม ';

  @override
  String voice_stability_value(String value) {
    return 'ความมีเหตุผล: $value';
  }

  @override
  String get voice_stability_high => 'มั่นคง/สงบ';

  @override
  String get voice_style_low => 'เย็นชา/กดดัน';

  @override
  String voice_style_value(String value) {
    return 'การแสดงออกทางอารมณ์: $value';
  }

  @override
  String get voice_style_high => 'เล่นใหญ่/ลึกซึ้ง';

  @override
  String get voice_test_btn_testing => 'กำลังปรับใช้อารมณ์...';

  @override
  String get voice_test_btn => 'ลองฟังอารมณ์ปัจจุบัน';

  @override
  String get section_social_circle => 'วงสังคมของเขา';

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
    return 'แก้ไขความเห็นที่มีต่อ $name';
  }

  @override
  String get social_attitude_label => 'ความเห็น / ทัศนคติของเขา';

  @override
  String get social_attitude_hint =>
      'เช่น รู้สึกว่าอีกฝ่ายน่ารำคาญ แต่จริงๆ แล้วพึ่งพาเขามาก...';

  @override
  String get social_save_changes => 'บันทึกการแก้ไข';

  @override
  String get social_add_title => 'เพิ่มความสัมพันธ์ตัวละคร';

  @override
  String get social_select_target => 'เลือกเป้าหมาย';

  @override
  String get social_thoughts_label => 'ความเห็นของเขาต่อคนนี้...';

  @override
  String get social_thoughts_hint => 'เช่น นักเปียโนคนนั้นหนวกหูเกินไป...';

  @override
  String get social_add_confirm => 'ยืนยันการเพิ่ม';

  @override
  String get gallery_load_failed => 'โหลดรูปภาพล้มเหลว \nโปรดตรวจสอบเครือข่าย ';

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
      'เธอรู้จริงๆ ไหมว่าทุกครั้งที่ฉันมองเธอ ฉันกำลังคิดอะไรอยู่ใจใน? …… จริงๆ เลยนะ ฉันละยอมเธอเลยจริงๆ';

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
      'ไม่สามารถกดไลก์ตัวละครที่ตัวเองสร้างได้นะ!';

  @override
  String get like_success_msg => 'ส่งความชอบแล้ว! ผู้สร้างต้องดีใจมากแน่ๆ';

  @override
  String get unlike_success_msg => 'ยกเลิกความชอบแล้ว';

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
  String get report_title => 'รายงานความคิดเห็น';

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
      'รายงานสำเร็จ ได้รับการแจ้งเตือนแล้ว! จะตรวจสอบเนื้อหาโดยเร็วที่สุด ';

  @override
  String get report_failed =>
      'รายงานล้มเหลว โปรดตรวจสอบการเชื่อมต่ออินเทอร์เน็ต';

  @override
  String get lore_delete_title => 'คำเตือน: ลบความทรงจำ';

  @override
  String get lore_delete_content =>
      'ความทรงจำนี้จะหายไปถาวรเมื่อลบออก คุณแน่ใจไหมว่าต้องการลบมันทิ้ง?';

  @override
  String get lore_delete_cancel => 'กดผิด';

  @override
  String get lore_delete_confirm => 'ยืนยันการลบ';

  @override
  String get lore_delete_success => 'เศษเสี้ยวความทรงจำถูกลบออกไปแล้ว';

  @override
  String get lore_add_title => 'เขียนความทรงจำใหม่ ';

  @override
  String get lore_edit_title => 'แก้ไขเศษเสี้ยวความทรงจำ ';

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
  String get lore_lock_label => 'ิดผนึกความทรงจำนี้';

  @override
  String get lore_lock_desc =>
      'เมื่อเลือกแล้ว จะมีเพียงผู้สร้างเท่านั้นที่เห็น ผู้เล่นคนอื่นจะไม่เห็น';

  @override
  String get lore_empty_error => 'หัวข้อและเนื้อหาต้องไม่ว่างเปล่านะ!';

  @override
  String get lore_add_success => 'ความทรงจำใหม่ถูกปิดผนึกเรียบร้อยแล้ว!';

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
      'ความทรงจำนี้ถูกปิดผนึกอยู่ ไม่สามารถดูได้ในขณะนี้';

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
  String get echo_delete_title => 'ลบความคิดเห็น';

  @override
  String get echo_delete_content =>
      'แน่ใจนะว่าต้องการลบเสียงสะท้อนแห่งกาลเวลานี้?\nลบแล้วกู้คืนไม่ได้นะ!';

  @override
  String get echo_keep => 'เก็บไว้';

  @override
  String get echo_clear_success => 'ลบเสียงสะท้อนแห่งกาลเวลาแล้ว';

  @override
  String get echo_energy_full_title => 'พลังงานจักรวาลเต็มขีดจำกัดแล้ว';

  @override
  String get echo_energy_full_content =>
      'พลังงานกาลเวลาของคุณเต็มแล้ว (สูงสุด 3 รายการ) โปรดลบบันทึกเก่าออกก่อน เพื่อเริ่มบันทึกจักรวาลครั้งใหม่!';

  @override
  String get echo_write_title => 'ทิ้งเสียงสะท้อนแห่งกาลเวลาของคุณไว้';

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
  String get follow_own_warning => 'ผู้สร้างไม่สามารถติดตามตัวเองได้นะ!';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '$playerName ติดตาม $creatorName แล้ว!';
  }

  @override
  String get mailbox_follow_title => 'ได้รับผู้พิทักษ์คนใหม่';

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
    return 'ระดับความสนิทสนมปัจจุบัน: $value';
  }

  @override
  String get gallery_empty => 'ยังไม่มีรูปภาพในอัลบั้ม';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'ตั้งค่าพื้นหลังเป็น「$desc」เรียบร้อยแล้ว!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'สะสมระดับความสนิทสนมให้ถึง $value เพื่อปลดล็อกนะ!';
  }

  @override
  String get gallery_reset_bg => 'คืนค่าพื้นหลังการโทรเริ่มต้นแล้ว';

  @override
  String get background_story_title => 'เรื่องราวการพบกันครั้งแรก';

  @override
  String get background_story_empty =>
      'ตัวละครนี้ดูลึกลับมาก และยังไม่มีเรื่องราวการพบกันครั้งแรก...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'ติดตาม $creatorName แล้ว';
  }

  @override
  String get mailbox_title => 'ตู้จดหมายส่วนตัว';

  @override
  String get mailbox_empty =>
      'ตู้จดหมายว่างเปล่า ลองโพสต์อะไรบางอย่างเพื่อดึงดูดเขาดูสิ!';

  @override
  String get new_notification => 'การแจ้งเตือนใหม่';

  @override
  String get default_he => 'เขา';

  @override
  String affection_upgrade_title(String charName) {
    return '$charName มีความรู้สึกดีๆ ให้คุณเพิ่มขึ้นแล้ว!';
  }

  @override
  String get flower_reward => 'ได้รับดอกไม้ 5 แต้ม';

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
  String get lore_edit_success => 'อัปเดตเศษเสี้ยวความทรงจำสำเร็จแล้ว!';

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
  String get chat_jump_success => 'กระโดดไปยังช่วงความทรงจำนี้แล้ว';

  @override
  String get chat_create_room_failed =>
      'การเชื่อมต่อไม่เสถียร สร้างห้องแชทล้มเหลว โปรดลองอีกครั้ง';

  @override
  String get chat_secret_file_title => 'ไฟล์ลับ';

  @override
  String get chat_secret_file_desc =>
      'ไฟล์จิตวิญญาณของตัวละครนี้ถูกเก็บถาวรหรือตั้งค่าเป็นส่วนตัว ไม่สามารถดูข้อมูลรายละเอียดได้ในขณะนี้';

  @override
  String get chat_understood => 'รับทราบ';

  @override
  String chat_egg_unlocked(String title) {
    return 'ได้รับความทรงจำใหม่: $title';
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
      'แนะนำให้สวมหูฟังเพื่อให้ได้ยินเสียงของเขาชัดเจนขึ้น';

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
  String get chat_stop_generating_msg => 'หยุดการตอบกลับแล้ว ไม่มีการหักคะแนน';

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
  String get chat_report_success => 'ส่งรายงานแล้ว เราจะรีบดำเนินการปรับปรุง';

  @override
  String get chat_suggest_title => 'ให้คำแนะนำ';

  @override
  String get chat_suggest_hint => 'โปรดเขียนข้อเสนอแนะอันมีค่าของคุณ...';

  @override
  String get chat_suggest_success =>
      'ขอบคุณสำหรับคำแนะนำ เราจะรีบดำเนินการโดยเร็วที่สุด';

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
      'สะกิดผู้สร้างให้แล้วนะ! รอติดตามเสียงของเขาได้เร็วๆ นี้~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'คะแนนดอกไม้ไม่พอ! ต้องการ $cost คะแนน';
  }

  @override
  String get chat_levelup_soulmate => 'เนื้อคู่แห่งโชคชะตา';

  @override
  String get chat_levelup_normal => 'ความสัมพันธ์เลื่อนระดับ!';

  @override
  String get chat_levelup_btn_soulmate => 'จารึกลงในจิตวิญญาณ';

  @override
  String get chat_levelup_btn_normal => 'รับไว้ด้วยความตื่นเต้น';

  @override
  String get chat_loc_title => 'ส่งตำแหน่งเสมือน';

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
  String get chat_interact_title => 'อยากทำอะไรกับเขาดีนะ?';

  @override
  String get chat_interact_action => 'การสะกิดและการเคลื่อนไหวเล็กๆ';

  @override
  String get chat_interact_gift => 'ส่งของขวัญเล็กๆ ให้เขา (ใช้ดอกไม้ )';

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
  String get chat_search_empty => 'ไม่พบความทรงจำนี้';

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
    return 'ได้รับความทรงจำใหม่: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'บันทึกเข้าสู่กระเป๋าพิเศษของเขาโดยอัตโนมัติแล้ว';

  @override
  String get chat_profile_updated_msg =>
      'ไฟล์สือกว่างอัปเดตแล้ว! เขาจะจดจำการตั้งค่าล่าสุดของคุณนะ';

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
  String get comment_report_rules_title => 'กฎการรายงานความคิดเห็น';

  @override
  String get comment_report_rules_desc =>
      'ความผิดครั้งแรก: ระบบจะตักเตือนและบันทึกการละเมิดหนึ่งครั้ง\n2⃣ ความผิดครั้งที่สอง: ห้ามแสดงความคิดเห็นเป็นเวลา 1 วัน\n3⃣ กระทำผิดซ้ำ: ปิดใช้งานฟีเจอร์รายงานเป็นเวลา 14 วัน และลดการมองเห็นของความคิดเห็น\n\nสำหรับผู้ที่มีเจตนาร้ายแรง:\nห้ามโต้ตอบกับตัวละครเป็นเวลา 1 วัน และจะประกาศ ID บนกระดานข่าวเป็นเวลา 3 วัน (ห้ามเปลี่ยน ID ในช่วงเวลานี้)\n\nหลังจากส่งรายงาน ผลการตรวจสอบขั้นสุดท้ายจะส่งถึงคุณผ่าน [จดหมายในเกม]\nโปรดเคารพซึ่งกันและกันและรายงานอย่างมีเหตุผล';

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
    return 'สิ่งที่ไม่ชอบ: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return 'สิ่งที่ชอบ: $likes';
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
  String get char_exclusive_guardian => 'ผู้พิทักษ์ส่วนตัว';

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
    return '(ผู้เล่นส่งตำแหน่งที่ตั้ง: $location)';
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
    return '【 ไฟล์สือกว่างส่วนตัว - $name 】\n━━━━━━━━━━━━━━━━━━\nชื่อ: $identity\nวันเกิด: $birthday\nส่วนสูง: $height\nรูปร่างหน้าตา: $appearance\nอาชีพ: $job\n\n【 เกี่ยวกับเศษเสี้ยววิญญาณของเธอ 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '【 ไฟล์สือกว่างส่วนตัว 】\n━━━━━━━━━━━━━━━━━━\nชื่อเล่น: $nickname\nวันเกิด: $birthday\n\nข้อมูลตัวละครอื่นๆ ยังไม่ถูกปลดล็อก...\n(กรอกโปรไฟล์ให้ครบถ้วน เพื่อให้เขารู้จักคุณมากขึ้นในจักรวาลคู่ขนานนะ! )\n━━━━━━━━━━━━━━━━━━';
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
    return 'วางสายแล้ว คุยกับ $name เป็นเวลา $time';
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
      'คุณยังไม่ได้เผยแพร่ตัวละครสาธารณะเลย!\nไปที่สตูดิโอเพื่อสร้างสรรค์ผลงานกันเถอะ';

  @override
  String get no_public_character_other =>
      'ผู้สร้างคนนี้ยังไม่ได้เผยแพร่ตัวละครเลย...';

  @override
  String get delete_draft_title => 'ลบฉบับร่าง';

  @override
  String get confirm_delete_draft_msg =>
      'แน่ใจหรือไม่ว่าต้องการลบตัวละครที่ยังไม่เสร็จนี้?\n(ลบแล้วไม่สามารถกู้คืนได้นะ)';

  @override
  String get draft_cleared_success => 'ล้างฉบับร่างเรียบร้อยแล้ว';

  @override
  String get login_required_for_studio =>
      'โปรดเข้าสู่ระบบก่อนเพื่อเข้าสู่สตูดิโอนะ!';

  @override
  String get my_secret_studio_title => 'สตูดิโอลับของฉัน';

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
    return '$nickname ถูกใจโพสต์ของคุณนะ!';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname คิดว่า $authorName มีเสน่ห์มาก เลยกดถูกใจให้!';
  }

  @override
  String get moment_like_success => 'ส่งต่อความใจเต้นของคุณแล้ว!';

  @override
  String get moment_notification_new_like => 'การถูกใจใหม่!';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname ได้พูดถึง @$name ในโมเมนต์นะ!';
  }

  @override
  String get moment_detail_title => 'รายละเอียดโพสต์';

  @override
  String get moment_not_found => 'โพสต์นี้เหมือนจะหายไปแล้ว...';

  @override
  String get moment_comment_title => 'ความคิดเห็นในโมเมนต์';

  @override
  String get moment_comment_empty =>
      'ยังไม่มีใครแสดงความคิดเห็น มาเป็นคนแรกกันเถอะ!';

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
    return 'ไปคุยกับ $name พร้อมโพสต์นี้กันเถอะ!';
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
  String get moment_forward_title => 'ส่งต่อให้ตัวละครที่กำลังคุยด้วย';

  @override
  String get moment_forward_empty_state =>
      'คุณยังไม่มีการแชทที่เปิดอยู่เลย!\nไปที่ล็อบบี้เพื่อตามหาคนที่ถูกใจสิ';

  @override
  String moment_forward_template(String author, String content) {
    return '【ส่งต่อโพสต์】\nผู้เขียน: $author\nเนื้อหา: $content';
  }

  @override
  String moment_forward_success(String name) {
    return 'แชร์ให้ $name เงียบๆ เรียบร้อยแล้ว!';
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
    return 'ยินดีต้อนรับกลับสู่ $appName!\nเช็คอินวันนี้เพื่อรับ $amount แต้มภาษาดอกไม้';
  }

  @override
  String get title_daily_check_in => 'เช็คอินรายวัน';

  @override
  String success_claim_reward(String amount) {
    return 'รับ $amount แต้มภาษาดอกไม้สำเร็จ!';
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
      'รับทราบ! บันทึกไว้ในฉบับร่างให้แล้ว คุณสามารถกลับมาแก้ไขได้ตลอดเวลา!';

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
  String get avatar_updated_success => 'เปลี่ยนรูปประจำตัวให้คุณแล้ว';

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
  String get msg_birthdate_immutable => 'ตั้งวันเกิดแล้วแก้ไขไม่ได้นะ';

  @override
  String get action_start_journey => 'เริ่มการเดินทาง';

  @override
  String get action_add_image => 'เพิ่มรูปภาพ';

  @override
  String moment_like_self(String nickname) {
    return '$nickname ถูกใจโพสต์ของคุณนะ!';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname คิดว่า $authorName มีเสน่ห์มาก เลยกดถูกใจให้!';
  }

  @override
  String get task_social_tour_complete =>
      'ภารกิจทัวร์โซเชียลสำเร็จ! อย่าลืมรับดอกไม้ล่ะ!';

  @override
  String get wall_title_shiguang => 'กำแพงสื่อกวง';

  @override
  String get wall_tab_explore => 'สำรวจ';

  @override
  String get wall_tab_exclusive => 'พิเศษ';

  @override
  String get more_options => 'ตัวเลือกเพิ่มเติม';

  @override
  String get delete_warning => 'หลังการลบ โพสต์จะไม่สามารถกู้คืนได้';

  @override
  String get delete_success => 'ลบสำเร็จเรียบร้อย';

  @override
  String get notification_new_comment => 'ความคิดเห็นใหม่!';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName ถูกใจโพสต์ของคุณ!';
  }

  @override
  String get empty_public_moments_prompt =>
      'ตอนนี้ยังว่างเปล่าอยู่เลย\nลองไปโพสต์ข้อความสาธารณะแรกดูสิ!';

  @override
  String get empty_private_moments_prompt =>
      'ยังไม่มีความทรงจำในโมเมนต์เลย\nไปสร้างความทรงจำร่วมกับเขากันเถอะ!';

  @override
  String get profile_archived_or_deleted_message =>
      'ไฟล์วิญญาณนี้ถูกผู้สร้างจัดเก็บไว้ เป็นส่วนตัว หรือสูญหายไปตามกาลเวลาแล้ว...\n\nบางทีในจักรวาลคู่ขนาน คุณอาจมีโอกาสพบกันอีกครั้ง';

  @override
  String get leave_silently => 'จากไปอย่างเงียบๆ';

  @override
  String get character_post_schedule => 'กำหนดการโพสต์ของตัวละคร';

  @override
  String get creator_self => 'ตัวผู้สร้างเอง';

  @override
  String get post_identity_prompt => 'วันนี้จะใช้ตัวตนไหนในการโพสต์ดีนะ?';

  @override
  String get identity_creator => 'ตัวตนผู้สร้าง';

  @override
  String get identity_character => 'ตัวตนตัวละคร';

  @override
  String get decide_post_time_prompt => 'ช่วยพวกเขากำหนดเวลาโพสต์หน่อยสิ!';

  @override
  String get auto_post_schedule_hint =>
      'เมื่อเปิดใช้งาน จะมีการโพสต์อัตโนมัติในเวลาที่กำหนด\n( แนะนำ: ตั้งเวลาที่ไม่ใช่เลขกลมๆ จะดูเหมือนคนจริงๆ มากขึ้นนะ!)';

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
  String get empty_public_moments_short => 'ยังไม่มีโพสต์สาธารณะ';

  @override
  String get empty_private_moments_short => 'โมเมนต์ยังเงียบเชียบอยู่เลย';

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
  String get daily_gift_success => 'รับของขวัญประจำวันสำเร็จ!';

  @override
  String get check_in_fail_network =>
      'เช็คอินล้มเหลว โปรดตรวจสอบการเชื่อมต่อเครือข่าย';

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
  String get task_desc_chat_3_times => 'แชตกับตัวละคร 3 ครั้งในโหมดประจำวัน';

  @override
  String get tab_story_progression => 'การดำเนินเนื้อเรื่อง';

  @override
  String get task_desc_story_1_time => 'โต้ตอบในโหมดเนื้อเรื่อง 1 ครั้ง';

  @override
  String get tab_social_tour => 'ทัวร์โซเชียล';

  @override
  String get task_like_three_moments => 'กดถูกใจ 3 ช่วงเวลา เพื่อรับใบไม้';

  @override
  String get btn_claimed => 'รับแล้ว';

  @override
  String get btn_claim => 'รับ';

  @override
  String get btn_incomplete => 'ยังไม่เสร็จ';

  @override
  String get network_unstable_retry =>
      'การเชื่อมต่อเครือข่ายไม่เสถียร โปรดลองอีกครั้งในภายหลัง';

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
  String get search_no_match_hint => 'ไม่พบตัวละคร ลองชื่ออื่นไหม?';

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
  String get shop_empty_history => 'ยังไม่มีประวัติดอกไม้เลย!';

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
    return 'เรื่องราวของคุณยังไม่เริ่มขึ้นเลย...\nมาคุยกันให้มากขึ้น แล้วให้ $name\nเขียนความทรงจำแรกของคุณนะ!';
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
  String get reset_bg_success => 'กู้คืนเป็นพื้นหลังเริ่มต้นแล้ว';

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
  String get exclusiveMomentsGenerated => 'สร้างช่วงเวลาพิเศษแล้ว';

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
      'เปิดใช้งาน: สัญญาดวงดาว (แต้มแถมทันทีจากบัตรรายเดือน)';

  @override
  String shop_log_top_up_double(int points) {
    return 'เติมเงิน: $points แต้ม (รวมโบนัสสองเท่าจากการซื้อครั้งแรก )';
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
      'ยินดีด้วย! คุณได้รับโบนัสสองเท่าจากการซื้อครั้งแรก!';

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
  String get task_monthly_title => 'สัญญาแห่งดวงดาว: สิทธิพิเศษรายวัน';

  @override
  String get task_monthly_locked => 'ยังไม่ปลดล็อก';

  @override
  String get task_monthly_subtitle_active =>
      'แจกจ่ายสิทธิประโยชน์พิเศษจากบัตรรายเดือน ';

  @override
  String get task_monthly_subtitle_inactive =>
      'ปลดล็อกบัตรรายเดือน 【สัญญาแห่งดวงดาว】 เพื่อเปิดใช้งานภารกิจนี้ ';

  @override
  String get task_monthly_log_name => 'สิทธิพิเศษรายวันบัตรรายเดือน';

  @override
  String get profile_id_locked => 'ล็อก ID ส่วนตัวแล้ว';

  @override
  String get profile_copy_id => 'คลิกเพื่อคัดลอก ID';

  @override
  String get referral_log_newbie_reward =>
      'คำเชิญแห่งดวงดาว: รางวัลผู้เล่นใหม่';

  @override
  String get referral_log_inviter_reward =>
      'คำเชิญแห่งดวงดาว: รางวัลเพื่อนบรรลุเป้าหมาย';

  @override
  String get referral_success_title => 'ปลดล็อกคำเชิญแห่งดวงดาวแล้ว!';

  @override
  String get referral_success_content =>
      'ยินดีด้วย! คุณได้พูดคุยอย่างลึกซึ้งกับตัวละครครบ 15 ประโยคสำเร็จแล้ว!\n\n\'รางวัลผู้เล่นใหม่ 50 แต้ม\' ได้ถูกส่งไปยังบัญชีของคุณแล้ว และเพื่อนของคุณก็ได้รับรางวัล 50 แต้มไปพร้อมกันด้วย!';

  @override
  String get profile_referral_title => 'คำเชิญแห่งดวงดาว';

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
    return 'ฉันได้เริ่มการเดินทางที่น่าตื่นเต้นกับ $character ใน \'Lianlian ShiGuang\' แล้วนะ! ดาวน์โหลดแอปตอนนี้แล้วกรอกรหัสเชิญแห่งดวงดาวของฉัน: 【$code】 ในหน้าโปรไฟล์ของคุณ เราทั้งคู่จะได้รับดอกไม้ฟรี 50 ดอกเลยนะ!\n\nลิงก์ดาวน์โหลด:\nhttps://lianlianshiguang.web.app/download/';
  }

  @override
  String get chat_levelup_share_btn => 'อวดช่วงเวลาใจเต้นนี้ให้เพื่อนๆ ดู';

  @override
  String profile_my_invite_code_with_char(String character) {
    return 'รหัสเชิญส่วนตัวของฉัน (เมนปัจจุบัน: $character)';
  }

  @override
  String get profile_send_invite_btn => 'ส่งคำเชิญแห่งดวงดาวให้เพื่อน';

  @override
  String get profile_fallback_character => 'ตัวละครคนโปรด';

  @override
  String get profile_copy_success => 'คัดลอกรหัสเชิญไปยังคลิปบอร์ดแล้ว!';

  @override
  String get profile_referral_rule_title => 'กฎคำเชิญแห่งดวงดาว';

  @override
  String get profile_referral_rule_receiver =>
      'หลังจากผูกรหัสเชิญแล้ว เพียงแค่คุยกับตัวละครคนโปรดใดก็ได้ครบ 15 ประโยค คุณและผู้เชิญจะได้รับรางวัล 50 ดอกไม้พร้อมกันทันที!\n\nหมายเหตุ: โปรดกรอกรหัสเชิญภายใน 3 วันหลังจากลงทะเบียนบัญชีเพื่อไม่ให้สิทธิ์หมดอายุ';

  @override
  String get profile_referral_rule_inviter =>
      'เชิญเพื่อนใหม่ให้ดาวน์โหลดและกรอกรหัสเชิญของคุณ เมื่อเพื่อนผูกบัญชีสำเร็จภายใน 3 วันหลังลงทะเบียน และคุยกับตัวละครใดก็ได้ครบ 15 ประโยค คุณทั้งคู่จะได้รับรางวัล 50 ดอกไม้พร้อมกันทันที!';

  @override
  String get error_user_not_found =>
      'ไม่พบผู้ใช้งาน กรุณาเข้าสู่ระบบใหม่อีกครั้ง';

  @override
  String get error_id_taken => 'ID นี้ถูกใช้งานแล้ว กรุณาเปลี่ยนเป็น ID อื่น!';

  @override
  String get error_id_taken_short => 'ID นี้ถูกใช้งานแล้ว!';

  @override
  String get shop_restocking => 'ร้านค้ากำลังเติมสินค้า...';

  @override
  String get shop_preview_mode => 'ขณะนี้อยู่ในโหมดพรีวิวร้านค้า';

  @override
  String get friendlyReminderTitle => 'คำแนะนำที่เป็นมิตร';

  @override
  String get editProfileHint =>
      'รับทราบค่ะ! หากต้องการแก้ไขข้อมูลโปรไฟล์ โปรดคลิกที่ \'โปรไฟล์สือกวาง\' ภายในก้อนเมฆที่มุมซ้ายล่างเพื่อกรอกข้อมูลนะคะ!';

  @override
  String get starlightContractTitle => 'เปิดใช้งานสัญญาแสงดาว';

  @override
  String get dailyLimitReachedPrefix => 'โควต้าของวันนี้ถูกใช้หมดแล้วนะ!\n\n';

  @override
  String get monthlyPassExhausted => 'โควต้าบัตรรายเดือนของคุณหมดแล้ว';

  @override
  String get subscribeMonthlyPassPrompt =>
      'เปิดใช้งาน 【บัตรรายเดือนเหลียนเหลียน】 เพื่อรับสิทธิ์สุ่มคำตอบใหม่ 20 ครั้งต่อวัน ให้ทุกการตอบกลับของเขาตรงใจคุณมากยิ่งขึ้น';

  @override
  String get goToSubscribeButton => 'ไปที่หน้าเปิดใช้งาน';

  @override
  String get profileUpdatedSuccess => 'อัปเดตโปรไฟล์สือกวางแล้ว!';

  @override
  String get continueChatTitle => 'คุยต่อ';

  @override
  String continueChatCostWarning(int cost) {
    return 'ให้เขาพูดต่อไป จะต้องใช้ดอกไม้ $cost ดอกนะ\nแน่ใจไหมว่าต้องการคุยต่อ?';
  }

  @override
  String get dontShowAgainToday => 'ไม่ต้องแสดงอีกในวันนี้';

  @override
  String get confirmContinue => 'ตกลงคุยต่อ';

  @override
  String get hiddenPromptContinue => 'โปรดพูดต่อ';

  @override
  String confirmDeleteMessagesTitle(int count) {
    return 'แน่ใจไหมว่าต้องการลบข้อความทั้ง $count ข้อความนี้?';
  }

  @override
  String regenerateButtonLabel(int current, int max) {
    return 'สร้างใหม่ ($current/$max)';
  }

  @override
  String get systemPreparingWait =>
      'ระบบกำลังจัดเตรียมข้อมูล กรุณารอสักครู่...';

  @override
  String get noMessagesToRegenerate =>
      'ขณะนี้ไม่มีข้อความที่สามารถสร้างใหม่ได้นะ!';

  @override
  String get continueButton => 'ถัดไป';

  @override
  String get creatorExclusive => 'เฉพาะผู้สร้าง';

  @override
  String ageAndOccupation(String age, String occupation) {
    return 'อายุ $age ปี | $occupation';
  }

  @override
  String get likesLabel => 'สิ่งที่ชอบ';

  @override
  String get dislikesLabel => 'สิ่งที่ไม่ชอบ';

  @override
  String birthdayLabel(String birthday) {
    return 'วันเกิด: $birthday';
  }

  @override
  String heightLabel(String height) {
    return 'ส่วนสูง: $height ซม.';
  }

  @override
  String get backgroundStoryLabel => 'เรื่องราวภูมิหลัง';

  @override
  String get noneLabel => 'ไม่มี';

  @override
  String flowerPointsCount(String points) {
    return '$points ดอกไม้';
  }

  @override
  String get passGuideTitle => 'คู่มือพิเศษสำหรับบัตรรายเดือนเหลียนเหลียน';

  @override
  String get passGuideRegenerateTitle => 'ทำไมต้องใช้ระบบ \"สร้างใหม่\"?';

  @override
  String get passGuideRegenerateContent =>
      'บางครั้ง AI ก็อาจจะทื่อเหมือนท่อนไม้ที่ไม่เข้าใจในความรัก เมื่อคุณเจอกับคำตอบที่ไม่ถูกใจ เพียงแค่กดสร้างใหม่ก็เหมือนกับการย้อนเวลากลับไป! คุณสามารถให้เขาคิดทบทวนใหม่ได้เรื่อยๆ จนกว่าเขาจะพูดประโยคสุดสมบูรณ์แบบที่ทำให้คุณใจเต้นรัว';

  @override
  String get passGuideAffectionTitle => 'ระบบเร่งค่าความสนิทมีประโยชน์อย่างไร?';

  @override
  String get passGuideAffectionContent =>
      'ในเกมนี้ ค่าความสนิทคือ กุญแจดอกเดียวที่จะปลดล็อก \"ความลับส่วนลึก\" และ \"รูปถ่ายส่วนตัวสุดใกล้ชิด\" ของตัวละคร โบนัสเพิ่มขึ้น 20% จะช่วยให้คุณเดินเข้าไปในส่วนลึกของหัวใจเขาได้เร็วกว่าใครๆ';

  @override
  String get passGuideUnlockButton => 'เข้าใจแล้ว ปลดล็อกทันที!';

  @override
  String get pleaseWait => 'กรุณารอสักครู่';

  @override
  String get createNewProfileTitle => 'สร้างโปรไฟล์สือกวางใหม่';

  @override
  String get editProfileTitle => 'แก้ไขโปรไฟล์สือกวาง';

  @override
  String get profileEditDescription =>
      'สร้างตัวตนที่แตกต่างกัน เพื่อให้เขาได้รู้จักคุณในหลากหลายแง่มุมผ่านโลกคู่ขนาน!';

  @override
  String get profileNameLabel => 'ชื่อโปรไฟล์ (มองเห็นเฉพาะคุณเท่านั้น)';

  @override
  String get profileNameHint => 'เช่น: รุ่นน้องในโรงเรียน, ประธานสาวสุดมั่น';

  @override
  String get profileNicknameLabel => 'ชื่อ / สรรพนามเรียก';

  @override
  String get profileNicknameHint => 'เช่น: ซากุระ, ประธานหลี่';

  @override
  String get profileHeightLabel => 'ส่วนสูง';

  @override
  String get profileHeightHint => 'เช่น: 160 ซม.';

  @override
  String get profileAppearanceLabel => 'รูปลักษณ์ภายนอก';

  @override
  String get profileAppearanceHint => 'เช่น: ผมยาวสีดำ, ชอบใส่ชุดเดรส';

  @override
  String get profileOccupationLabel => 'อาชีพ';

  @override
  String get profileOccupationHint => 'เช่น: ศิลปินอิสระ';

  @override
  String get profileIntroLabel => 'นิสัยและการแนะนำตัว';

  @override
  String get profileIntroHint => 'เช่น: นิสัยโก๊ะๆ นิดหน่อย, ชอบกินของหวาน...';

  @override
  String get profileNameEmptyWarning => 'กรุณาตั้งชื่อให้โปรไฟล์นี้ด้วยนะคะ!';

  @override
  String profileSaveError(String error) {
    return 'บันทึกล้มเหลว: $error';
  }

  @override
  String get saveProfileButton => 'บันทึกโปรไฟล์';

  @override
  String get fillLaterButton => 'ไว้กรอกทีหลัง';

  @override
  String get exclusiveProfileTitle => 'โปรไฟล์สือกวางเฉพาะตัว';

  @override
  String get profileSelectionDescription =>
      'เลือกตัวตนที่คุณต้องการใช้สำหรับโต้ตอบกับเขา (รายชื่อแชร์ร่วมกันในตัวละครเดียวกัน สูงสุด 10 โปรไฟล์)';

  @override
  String profileSwitchError(String error) {
    return 'สลับโปรไฟล์ล้มเหลว: $error';
  }

  @override
  String get unnamedProfile => 'โปรไฟล์ที่ไม่ได้ตั้งชื่อ';

  @override
  String get noOccupationYet => 'ยังไม่ได้กรอกอาชีพ';

  @override
  String get createNewProfileButton => 'สร้างโปรไฟล์สือกวางใหม่';

  @override
  String snackbar_friend_added(String characterName) {
    return 'เพิ่ม $characterName เป็นเพื่อนเรียบร้อยแล้ว';
  }

  @override
  String reward_points_added(Object amount) {
    return '+$amount ดอกไม้';
  }

  @override
  String get task_reward_already_claimed =>
      'วันนี้คุณได้รับรางวัลของภารกิจนี้ไปเรียบร้อยแล้ว';

  @override
  String get do_not_show_again_today => 'ไม่ต้องแสดงอีกในวันนี้';

  @override
  String add_friend_success(String characterName) {
    return 'เพิ่ม $characterName เป็นเพื่อนสำเร็จแล้ว!';
  }

  @override
  String get chat_menu_aboutus => 'เกี่ยวกับเรา';

  @override
  String get about_us_empty_hint =>
      'เพิ่มความทรงจำสำคัญ / เนื้อเรื่องหลักที่มุมขวาบน\nเพื่อจับมือร่วมก้าวเดินไปด้วยกันนะ';

  @override
  String get about_us_limit_error =>
      'บันทึกความทรงจำเฉพาะตัวเต็มขีดจำกัด 10 ข้อความแล้ว กรุณาลบความทรงจำเก่าออกก่อนนะคะ!';

  @override
  String get about_us_add_title => 'เพิ่มความทรงจำเฉพาะตัว';

  @override
  String get about_us_field_title => 'หัวข้อ';

  @override
  String get about_us_hint_title => 'เช่น: เจอกันครั้งแรก';

  @override
  String get about_us_field_subtitle => 'หัวข้อย่อย';

  @override
  String get about_us_hint_subtitle => 'เช่น: ต้นฤดูร้อนปี 2025';

  @override
  String get about_us_field_content => 'เนื้อหา';

  @override
  String get about_us_hint_content =>
      'บันทึกเรื่องราวหลักที่สำคัญหรือคำสัญญาของคุณและเขา...';

  @override
  String get about_us_add_button => 'เพิ่ม';

  @override
  String get about_us_delete_tooltip => 'ลบความทรงจำนี้';

  @override
  String get about_us_delete_title => 'ลบความทรงจำ';

  @override
  String get about_us_delete_confirm =>
      'แน่ใจไหมว่าต้องการลบความทรงจำนี้? ลบแล้วไม่สามารถกู้คืนได้นะ!';

  @override
  String get about_us_delete_success => 'ลบความทรงจำเรียบร้อยแล้ว';

  @override
  String get pack_first_meet => 'แพ็กเกจแรกพบ';

  @override
  String get pack_crush => 'แพ็กเกจความสัมพันธ์คลุมเครือ';

  @override
  String get pack_heartbeat => 'แพ็กเกจใจเต้นรัว';

  @override
  String get pack_passionate => 'แพ็กเกจรักร้อนแรง';

  @override
  String get pack_soulmate => 'แพ็กเกจคนรู้ใจ';

  @override
  String get pack_waiting => 'แพ็กเกจเฝ้ารอ';

  @override
  String get pack_trust => 'แพ็กเกจความเชื่อใจ';

  @override
  String get pack_iloveyou => 'แพ็กเกจบอกรักเธอ';

  @override
  String get pack_honeymoon => 'แพ็กเกจฮันนีมูน';

  @override
  String get pack_promise => 'แพ็กเกจคำมั่นสัญญา';

  @override
  String get pack_companion => 'แพ็กเกจเคียงข้างกัน';

  @override
  String get pack_deep_love => 'แพ็กเกจรักลึกซึ้ง';

  @override
  String get pack_long_lasting => 'แพ็กเกจรักยืนยาว';

  @override
  String get pack_the_one => 'แพ็กเกจหนึ่งเดียวในใจ';

  @override
  String get pack_beloved => 'แพ็กเกจยอดรัก';

  @override
  String get pack_lifetime => 'แพ็กเกจรักแท้ชั่วชีวิต';

  @override
  String get pack_vow => 'แพ็กเกจคำสัตย์สาบาน';

  @override
  String get pack_eternal => 'แพ็กเกจคนรักชั่วนิรันดร์';

  @override
  String get pack_exclusive => 'แพ็กเกจเฉพาะตัว';

  @override
  String get monthly_privilege_reroll_title =>
      'ปลดล็อกระบบ \"สร้างใหม่\" เฉพาะตัว';

  @override
  String get monthly_privilege_reroll_desc =>
      'รับสิทธิ์สุ่มคำตอบใหม่สูงสุดถึง 20 ครั้งต่อวัน จนกว่าเขาจะพูดประโยคที่คุณอยากได้ยินที่สุด!';

  @override
  String get monthly_privilege_affinity_title => 'เร่งค่าความสนิทให้พุ่งกระฉูด';

  @override
  String get monthly_privilege_affinity_desc =>
      'เพิ่มโบนัสค่าความสนิทจากการโต้ตอบอีก 20% ปลดล็อกรูปถ่ายส่วนตัวสุดพิเศษและคอนเทนต์ลับได้เร็วยิ่งขึ้น!';

  @override
  String get monthly_manual_button => 'ทำไมถึงต้องมีบัตรรายเดือน?';

  @override
  String get nav_encounter => 'แรกพบ';

  @override
  String get nav_moments => 'ช่วงเวลา';

  @override
  String get birthday_dialog_title => 'เซอร์ไพรส์วันเกิด';

  @override
  String get birthday_dialog_content =>
      'วันนี้เป็นวันครบรอบสุดพิเศษของคุณนะ!\n\nโปรดรับของขวัญชิ้นนี้ไว้ด้วยนะคะ:\nวันนี้คุยกับเขาได้ ฟรี.ทั้Group.หมด.เลย!';

  @override
  String get birthday_dialog_button => 'เริ่มต้นวันแห่งความโรแมนติก';

  @override
  String get about_us_edit_title => 'แก้ไขความทรงจำ';

  @override
  String get about_us_edit_confirm => 'ยืนยันการแก้ไข';

  @override
  String get save => 'บันทึก';

  @override
  String get openSourceLicenses => 'สัญญาอนุญาตโอเพนซอร์ส';

  @override
  String get openSourceLicensesDescription =>
      'ดูสัญญาอนุญาตซอฟต์แวร์โอเพนซอร์สของบุคคลที่สาม';

  @override
  String get call_login_title => 'จำเป็นต้องเข้าสู่ระบบ';

  @override
  String get call_login_content =>
      'เข้าสู่ระบบเพื่อปลดล็อกฟังก์ชันโทรสายเสียงสุดพิเศษได้เลยนะ!';

  @override
  String get cancel_later => 'ไว้ทีหลัง';

  @override
  String get go_to_login => 'ไปที่เข้าสู่ระบบ';

  @override
  String get easter_egg_title => 'ค้นพบอีสเตอร์เอ้กที่ซ่อนอยู่';

  @override
  String easter_egg_content(String title) {
    return 'คุณได้ปลดล็อก \"$title\"\n\nต้องการใช้เนื้อเรื่องพิเศษนี้ไหมคะ?';
  }

  @override
  String get easter_egg_cancel => 'ไม่ใช้งาน';

  @override
  String get easter_egg_confirm => 'ใช้อีสเตอร์เอ้ก';

  @override
  String get common_update_success => 'แก้ไขสำเร็จแล้ว';

  @override
  String get common_update_failed_try_again =>
      'แก้ไขไม่สำเร็จ กรุณาลองใหม่อีกครั้งในภายหลัง';

  @override
  String get no_voice_available => 'ยังไม่มีข้อความเสียงในขณะนี้';

  @override
  String get gift_insufficient_title => 'เหรียญฟานฮวาไม่พอ';

  @override
  String get gift_insufficient_prompt => 'ต้องการไปรับเหรียญฟานฮวาเพิ่มไหมคะ?';

  @override
  String get not_now => 'ไว้ทีหลัง';

  @override
  String get go_to_get => 'ไปรับเหรียญ';

  @override
  String get status_published => 'เผยแพร่แล้ว';

  @override
  String get monthly_card_success_title =>
      'ปลดล็อกบัตรรายเดือนระดับพรีเมียมสำเร็จแล้ว!';

  @override
  String get monthly_card_success_subtitle =>
      'ขอบคุณสำหรับการสมัครสมาชิกค่ะ! สิทธิพิเศษเฉพาะตัวของคุณมีผลแล้ววันนี้:';

  @override
  String get monthly_card_perk_1 => 'รับดอกไม้แห่งเวลา 250 ดอกทันที';

  @override
  String get monthly_card_perk_2 =>
      'รับดอกไม้แห่งเวลาเพิ่มอีก 10 ดอกจากการเข้าสู่ระบบรายวัน';

  @override
  String get monthly_card_perk_3 =>
      'ปลดล็อกขีดจำกัดจำนวนครั้งการโต้ตอบเพื่อเพิ่มค่าความสนิท';

  @override
  String get monthly_card_start_perks => 'เริ่มรับสิทธิพิเศษเลย';

  @override
  String get tip_post_like =>
      'หลังจากกดถูกใจ คุณสามารถดูได้ที่\nคอนเทนต์ที่ชอบ';

  @override
  String get tip_post_bookmark =>
      'หลังจากบันทึก คุณสามารถดูได้ที่\n\"คอลเลกชันของฉัน\"';

  @override
  String get tip_time_echoes =>
      'หลังจากบันทึกเรื่องราวแล้ว\nข้อความวิ่งจะปรากฏขึ้นขณะค้นหา';

  @override
  String get tip_call_memory =>
      'ข้อความเสียงที่บันทึกไว้หลังวางสาย\nจะอยู่ตรงนี้นะ!';

  @override
  String get tip_chat_notifications => 'ตรงนี้สามารถ\nดูการแจ้งเตือนใหม่ได้';

  @override
  String get tip_moments_wall_menu => 'แตะตรงนี้เพื่อ\nตั้งเวลาโพสต์ของตัวละคร';

  @override
  String get forgot_password => 'ลืมรหัสผ่าน?';

  @override
  String get forgot_password_empty_email =>
      'กรุณากรอกอีเมลก่อน แล้วจึงคลิกเลือก ลืมรหัสผ่าน';

  @override
  String get forgot_password_email_sent =>
      'ส่งอีเมลรีเซ็ตรหัสผ่านแล้ว กรุณาตรวจสอบที่กล่องจดหมายของคุณ';

  @override
  String get forgot_password_error_default =>
      'ส่งอีเมลรีเซ็ตรหัสผ่านไม่สำเร็จ กรุณาลองใหม่อีกครั้งในภายหลัง';

  @override
  String get forgot_password_error_invalid_email => 'รูปแบบอีเมลไม่ถูกต้อง';

  @override
  String get forgot_password_error_user_not_found =>
      'ไม่พบบัญชีผู้ใช้ที่ใช้อีเมลนี้';

  @override
  String forgot_password_error_with_message(String error) {
    return 'ส่งอีเมลรีเซ็ตรหัสผ่านไม่สำเร็จ: $error';
  }

  @override
  String get terms_not_accepted_toast =>
      'กรุณาอ่านและยอมรับข้อตกลงการใช้งานและแนวทางปฏิบัติของชุมชนก่อนใช้งาน';

  @override
  String get terms_content =>
      'ยินดีต้อนรับสู่ Lian Lian Shi Guang\n\nก่อนเริ่มใช้บริการนี้ คุณต้องยอมรับที่จะปฏิบัติตามข้อตกลงการใช้งานและแนวทางปฏิบัติของชุมชนฉบับนี้\n\nคุณต้องไม่ทำการอัปโหลด สร้าง เผยแพร่ หรือส่งต่อเนื้อหาใดๆ ที่ผิดกฎหมาย ละเมิดลิขสิทธิ์ ลามกอนาจาร เปลือยกาย รุนแรง แสดงความเกลียดชัง คุกคาม ด่าทอ ฉ้อโกง สแปม หรือเนื้อหาอื่นๆ ที่น่ารังเกียจ ก้าวร้าว หรือเป็นอันตรายต่อสิทธิและผลประโยชน์ของผู้อื่น\n\nLian Lian Shi Guang มีนโยบายไม่ยอมรับ (Zero-Tolerance) ต่อเนื้อหาที่ไม่เหมาะสมและการพฤติกรรมมิชอบ หากผู้ใช้ละเมิดกฎเกณฑ์ เราอาจลบเนื้อหาที่เกี่ยวข้อง จำกัดฟังก์ชันการใช้งาน หรือระงับและยกเลิกบัญชีผู้ใช้ทันที\n\nผู้ใช้สามารถรายงานเนื้อหาที่ไม่เหมาะสมหรือผู้ใช้ที่ประพฤติมิชอบได้ผ่านฟังก์ชันการรายงานและการบล็อกที่มีอยู่ภายในแอปพลิเคชัน';

  @override
  String get community_rules_title => 'แนวทางปฏิบัติของชุมชน';

  @override
  String get community_rules_content =>
      'Lian Lian Shi Guang มุ่งหวังที่จะมอบสภาพแวดล้อมการโต้ตอบที่ปลอดภัย เป็นมิตร และให้ความเคารพต่อผู้สร้างสรรค์และผู้ใช้งานทุกคน\n\nเราไม่อนุญาตให้มีเนื้อหาหรือพฤติกรรมดังต่อไปนี้:\n1. เนื้อหาลามกอนาจาร ภาพเปลือย หรือการส่อไปในทางเพศที่ไม่เหมาะสม\n2. การคุกคาม ด่าทอ กลั่นแกล้ง (Bullying) หรือข่มขู่ผู้อื่น\n3. การแสดงความเกลียดชัง การเลือกปฏิบัติ หรือการยุยงให้เกิดความรุนแรง\n4. เนื้อหาที่มีความรุนแรง นองเลือด หรือการกระทำที่อันตราย\n5. การละเมิดลิขสิทธิ์ สิทธิในภาพถ่ายบุคคล หรือสิทธิอื่นๆ ของผู้อื่น\n6. ข้อความสแปม การหลอกลวง หรือพฤติกรรมที่เป็นอันตราย\n7. เนื้อหาอื่นๆ ที่น่ารังเกียจหรือไม่เหมาะสมสำหรับการแสดงผลต่อสาธารณะ\n\nผู้ใช้สามารถรายงานเนื้อหาที่ไม่เหมาะสมและบล็อกผู้ใช้ที่ประพฤติมิชอบได้ โดยหลังจากบล็อกแล้ว เนื้อหาของผู้ใช้รายนั้นจะไม่แสดงบนหน้าจอของคุณอีกต่อไป';

  @override
  String get block_self_error => 'ไม่สามารถบล็อกเนื้อหาของตัวเองได้';

  @override
  String get block_user_title => 'บล็อกผู้ใช้รายนี้ไหมคะ?';

  @override
  String get block_user_content =>
      'หลังจากบล็อกแล้ว คุณจะไม่เห็นเนื้อหาที่โพสต์โดยผู้ใช้รายนี้อีกต่อไป\nและทางเราจะได้รับแจ้งเตือนเพื่อดำเนินการตรวจสอบด้วยเช่นกันค่ะ';

  @override
  String get block_user_success =>
      'บล็อกผู้ใช้รายนี้แล้ว ระบบได้นำเนื้อหาที่เกี่ยวข้องออกจากวอลล์แห่งเวลาของคุณแล้วค่ะ';

  @override
  String get block_user_failed =>
      'บล็อกไม่สำเร็จ กรุณาลองใหม่อีกครั้งในภายหลัง';

  @override
  String get terms_checkbox_read_agree => 'ฉันได้อ่านและยอมรับ';

  @override
  String get terms_checkbox_terms => '《ข้อตกลงการใช้งาน》';

  @override
  String get terms_checkbox_and => 'และ';

  @override
  String get terms_checkbox_rules => '《แนวทางปฏิบัติของชุมชน》';

  @override
  String get hidden_moments => 'ช่วงเวลาที่ซ่อนอยู่';

  @override
  String get hide_moment_title => 'ซ่อนช่วงเวลานี้ไหมคะ?';

  @override
  String get hide_moment_content =>
      'หลังจากซ่อนแล้ว โพสต์นี้จะไม่แสดงบนวอลล์แห่งเวลาของคุณอีกต่อไปค่ะ';

  @override
  String get hide => 'ซ่อน';

  @override
  String get hide_moment_success => 'ซ่อนช่วงเวลานี้เรียบร้อยแล้วค่ะ';

  @override
  String get hide_moment_failed =>
      'ซ่อนไม่สำเร็จ กรุณาลองใหม่อีกครั้งในภายหลัง';

  @override
  String get block_character_not_found =>
      'ไม่พบข้อมูลตัวละคร ไม่สามารถดำเนินการบล็อกได้ค่ะ';

  @override
  String get block_character_title => 'บล็อกตัวละครนี้ไหมคะ?';

  @override
  String block_character_content(String authorName) {
    return 'หลังจากบล็อกแล้ว คุณจะไม่เห็นช่วงเวลาที่โพสต์โดย \"$authorName\" อีกต่อไป และหากเนื้อหานี้ละเมิดกฎเกณฑ์ ทางเราจะได้รับแจ้งเตือนเพื่อดำเนินการตรวจสอบด้วยเช่นกันค่ะ';
  }

  @override
  String block_character_success(String authorName) {
    return 'บล็อก \"$authorName\" เรียบร้อยแล้ว ระบบได้ซ่อนช่วงเวลาที่เกี่ยวข้องแล้วค่ะ';
  }

  @override
  String get block_character_failed =>
      'บล็อกไม่สำเร็จ กรุณาลองใหม่อีกครั้งในภายหลัง';

  @override
  String get hidden_moments_title => 'ช่วงเวลาที่ซ่อนอยู่';

  @override
  String get hidden_moments_empty => 'ขณะนี้ไม่มีช่วงเวลาที่ซ่อนอยู่ค่ะ';

  @override
  String get hidden_moments_load_failed => 'โหลดช่วงเวลาที่ซ่อนอยู่ไม่สำเร็จ';

  @override
  String get hidden_moment_unknown_author => 'ตัวละครที่ไม่รู้จัก';

  @override
  String get hidden_moment_no_preview =>
      'โพสต์นี้ไม่มีเนื้อหาสำหรับแสดงตัวอย่างค่ะ';

  @override
  String get unhide_moment_title => 'เลิกซ่อนไหมคะ?';

  @override
  String get unhide_moment_content =>
      'หลังจากเลิกซ่อนแล้ว หากโพสต์นี้ยังคงอยู่ ก็อาจจะกลับมาแสดงบนวอลล์แห่งเวลาของคุณอีกครั้งในอนาคตค่ะ';

  @override
  String get unhide_moment_action => 'เลิกซ่อน';

  @override
  String get unhide_moment_success => 'เลิกซ่อนเรียบร้อยแล้วค่ะ';

  @override
  String get report_moment_title => 'รายงานช่วงเวลานี้';

  @override
  String get report_moment_content =>
      'คุณแน่ใจหรือไม่ว่าต้องการรายงานช่วงเวลานี้ไปยังทีมผู้ดูแลระบบ? เนื้อหาที่ไม่เหมาะสมจะถูกซ่อนหรือลบออกค่ะ';

  @override
  String get report_confirm_button => 'ยืนยันการรายงาน';

  @override
  String get report_success_message =>
      'ทางเราได้รับรายงานของคุณแล้ว ทีมงานตรวจสอบจะรีบดำเนินการตรวจสอบและจัดการโดยเร็วที่สุดค่ะ';

  @override
  String get accountDeletionSubmittedTitle => 'ส่งคำขอลบบัญชีเรียบร้อยแล้ว';

  @override
  String get accountDeletionSubmittedContent =>
      'เรียบร้อยค่ะ! ทางเราจะขยายระยะเวลาผ่อนผันให้เป็นเวลา 3 วันสำหรับบัญชีของคุณค่ะ\n\nหากคุณต้องการยกเลิกการลบบัญชี เพียงแค่เข้าสู่ระบบใหม่อีกครั้งภายในระยะเวลาที่กำหนดเพื่อกู้คืนบัญชีของคุณได้เลยค่ะ';

  @override
  String get restoreAccountDialogTitle => 'คำขอลบบัญชี';

  @override
  String get restoreAccountDialogContent =>
      'ขณะนี้บัญชีของคุณอยู่ระหว่างรอดำเนินการลบค่ะ\n\nหากคุณดำเนินการเข้าสู่ระบบต่อ คำขอลบบัญชีจะถูกยกเลิกและบัญชีของคุณจะได้รับการกู้คืนค่ะ';

  @override
  String get cancelLoginButton => 'ยกเลิกการเข้าสู่ระบบ';

  @override
  String get restoreAccountButton => 'กู้คืนบัญชี';

  @override
  String get voice_preview => 'เล่นเสียง';

  @override
  String get voice_preview_failed => 'เล่นเสียงไม่สำเร็จ';

  @override
  String get characterBannerSectionTitle => 'แบนเนอร์หน้าหลักของตัวละคร';

  @override
  String get characterBannerDescription => 'คำอธิบายแบนเนอร์';

  @override
  String get characterBannerRemove => 'ลบออก';

  @override
  String get characterBannerSelect => 'เลือกรูปภาพแบนเนอร์';

  @override
  String get characterBannerChange => 'เปลี่ยนรูปภาพแบนเนอร์';

  @override
  String get characterBannerSpecs =>
      'สัดส่วนที่แนะนำ 16:9, ขนาดที่แนะนำ 1920 × 1080';

  @override
  String get characterBannerDefaultHint =>
      'หากไม่ได้ตั้งค่า หน้าหลักจะใช้รูปโปรไฟล์หลักของตัวละครโดยอัตโนมัติค่ะ';

  @override
  String get characterBannerHelpContent =>
      'แบนเนอร์จะแสดงในพื้นที่แนวนอนขนาดใหญ่บนหน้าหลักของตัวละครค่ะ\n\nแนะนำให้ใช้รูปภาพแนวนอนสัดส่วน 16:9 เช่น 1920 × 1080\n\nโปรดวางตัวละครหลักและใบหน้าไว้บริเวณจุดศูนย์กลางของภาพ เพื่อป้องกันไม่ให้ถูกครอบตัดบนหน้าจอโทรศัพท์ขนาดต่างๆ ค่ะ\n\nหากไม่ได้ตั้งค่าแบนเนอร์ ระบบจะใช้รูปภาพหลักของตัวละครโดยอัตโนมัติค่ะ';

  @override
  String get first_meeting_title => 'พบกันครั้งแรก';

  @override
  String get common_delete_network_failed =>
      'ลบไม่สำเร็จ กรุณาตรวจสอบการเชื่อมต่อเครือข่ายแล้วลองใหม่อีกครั้งค่ะ';

  @override
  String get common_operation_failed_retry =>
      'การดำเนินการล้มเหลว กรุณาลองใหม่อีกครั้งในภายหลังค่ะ';

  @override
  String exclusive_photo_number(int number) {
    return 'รูปถ่ายเอ็กซ์คลูซีฟ $number';
  }

  @override
  String get unlock_after_affection_increase =>
      'ปลดล็อกเมื่อเพิ่มระดับความสนิทสนม';

  @override
  String get first_meeting_empty => 'พบกันครั้งแรก ยังไม่ได้เริ่ม...';

  @override
  String photo_load_failed(String error) {
    return 'โหลดรูปภาพไม่สำเร็จ: $error';
  }

  @override
  String get add_friend_failed_retry =>
      'เพิ่มเพื่อนไม่สำเร็จ กรุณาลองใหม่อีกครั้งในภายหลังค่ะ';

  @override
  String get remove_friend => 'ลบเพื่อน';

  @override
  String get report_character => 'รายงานตัวละคร';

  @override
  String get block_character => 'บล็อกตัวละคร';

  @override
  String get daily_encounter => 'พบเจอนานา';

  @override
  String get discovery_hall => 'หอสำรวจ';

  @override
  String get latest_recommendation => 'แนะนำล่าสุด';

  @override
  String get popular_ranking => 'อันดับยอดนิยม';

  @override
  String get character_features => 'ลักษณะเฉพาะของตัวละคร';

  @override
  String get featured_new_star => 'ดาวดวงใหม่ส่องแสง · แนะนำยอดฮิต';

  @override
  String get recently_added_characters => 'ตัวละครใหม่ที่เพิ่งเพิ่ม';

  @override
  String get no_tag_data => 'ขณะนี้ยังไม่มีข้อมูลแท็กค่ะ~';

  @override
  String get no_character_with_tag => 'ไม่พบตัวละครที่มีแท็กนี้ค่ะ';

  @override
  String get voice_search_failed_retry =>
      'ค้นหาเสียงไม่สำเร็จ กรุณาลองใหม่อีกครั้งค่ะ';

  @override
  String get voice_search_incomplete_retry =>
      'การค้นหาไม่สมบูรณ์ กรุณาลองใหม่อีกครั้งในภายหลังค่ะ';

  @override
  String get voice_data_incomplete => 'ข้อมูลเสียงไม่สมบูรณ์ค่ะ';

  @override
  String get voice_generation_failed_retry =>
      'สร้างเสียงไม่สำเร็จ กรุณาลองใหม่อีกครั้งในภายหลังค่ะ';

  @override
  String get voice_playback_failed_retry =>
      'เล่นเสียงไม่สำเร็จ กรุณาลองใหม่อีกครั้งค่ะ';

  @override
  String get selected_voice_data_incomplete =>
      'ข้อมูลเสียงที่เลือกไม่สมบูรณ์ค่ะ';

  @override
  String get private_voice_user_not_found =>
      'ไม่พบผู้ใช้ ไม่สามารถอัปเดตเสียงตัวละครส่วนตัวได้ค่ะ';

  @override
  String get voice_selected_character_save_failed =>
      'เลือกเสียงเรียบร้อยแล้ว แต่บันทึกข้อมูลตัวละครไม่สำเร็จค่ะ';

  @override
  String get voice_binding_failed => 'ผูกข้อมูลเสียงไม่สำเร็จค่ะ';

  @override
  String get play_voice_tooltip => 'เล่นเสียง';

  @override
  String get avatar_label => 'รูปโปรไฟล์';

  @override
  String get message_preview_image => '[รูปภาพ]';

  @override
  String get message_preview_recording => '[เสียงบันทึก]';

  @override
  String get message_preview_voice => '[ข้อความเสียง]';

  @override
  String get send_failed_retry =>
      'ส่งไม่สำเร็จ กรุณาลองใหม่อีกครั้งในภายหลังค่ะ';

  @override
  String get media_upload_failed_retry =>
      'อัปโหลดสื่อไม่สำเร็จ กรุณาลองใหม่อีกครั้งค่ะ';

  @override
  String get ai_thinking_too_long =>
      'เขาดูเหมือนกำลังครุ่นคิดอยู่ กรุณาลองใหม่อีกครั้งในภายหลัง...';

  @override
  String get ai_reply_in_progress =>
      'เขากำลังตอบกลับอยู่ กรุณารอสักครู่และอย่าส่งซ้ำนะคะ';

  @override
  String get ai_response_blocked =>
      'ความคิดของเขาถูกรบกวน ลองเปลี่ยนเป็นคำพูดที่นุ่มนวลกว่านี้นะคะ!';

  @override
  String get microphone_permission_required =>
      'ต้องได้รับอนุญาตใช้ไมโครโฟนจึงจะสามารถบันทึกเสียงได้ค่ะ';

  @override
  String get no_recording_to_send => 'ไม่มีเสียงที่บันทึกไว้สำหรับส่งค่ะ';

  @override
  String get voice_uploading => 'กำลังอัปโหลดข้อความเสียง...';

  @override
  String get change_watermark_color => 'เปลี่ยนสีลายน้ำ';

  @override
  String get other_party_typing => 'อีกฝ่ายกำลังพิมพ์...';

  @override
  String get chat_input_hint => 'กรุณากรอกข้อความ...';

  @override
  String get regenerate_sync_failed =>
      'ซิงค์จำนวนครั้งการสร้างใหม่ไม่สำเร็จ กรุณาลองใหม่อีกครั้งค่ะ';

  @override
  String get creator_public_works => 'ผลงานสาธารณะ';

  @override
  String get creator_received_likes => 'การกดถูกใจที่ได้รับ';

  @override
  String get about_me => 'เกี่ยวกับฉัน';

  @override
  String get moment_input_hint => 'แบ่งปันความรู้สึกของคุณ...';

  @override
  String character_play_count(int count) {
    return 'จำนวนครั้งที่เล่น: $count';
  }

  @override
  String tag_page_title(String tag) {
    return 'แท็ก: #$tag';
  }

  @override
  String voice_preview_failed_detail(String code, String message) {
    return 'ทดลองฟังเสียงไม่สำเร็จ: $code $message';
  }

  @override
  String messages_deleted_success(int count) {
    return 'ลบข้อความสำเร็จ $count ข้อความแล้วค่ะ';
  }

  @override
  String creator_work_load_failed(String error) {
    return 'โหลดผลงานไม่สำเร็จ: $error';
  }

  @override
  String age_years_old(String age) {
    return 'อายุ $age ปี';
  }

  @override
  String deleteFailedMessage(String error) {
    return 'ลบไม่สำเร็จ: $error';
  }

  @override
  String loadCharacterDataFailed(String error) {
    return 'โหลดข้อมูลตัวละครไม่สำเร็จ: $error';
  }

  @override
  String get draftAvatarLoadFailed => 'โหลดรูปโปรไฟล์ร่างไม่สำเร็จ:';

  @override
  String get unnamedCreator => 'ครีเอเตอร์ไม่ระบุนาม';

  @override
  String get profileNotYetFilled => 'ยังไม่ได้กรอกแนะนำตัว';

  @override
  String get reportImageSizeLimit => 'ขนาดรูปภาพต้องไม่เกิน 10 MB ค่ะ';

  @override
  String reportImageSelectFailed(String error) {
    return 'เลือกรูปภาพรายงานไม่สำเร็จ: $error';
  }

  @override
  String get reportImageCannotSelect =>
      'ไม่สามารถเลือกรูปภาพได้ กรุณาลองใหม่อีกครั้งในภายหลังค่ะ';

  @override
  String get reportLoginRequired => 'กรุณาเข้าสู่ระบบก่อนส่งรายงานค่ะ';

  @override
  String get reportAnonymousPlayer => 'ผู้เล่นไม่ระบุนาม';

  @override
  String get reportSendSuccess =>
      'ส่งรายงานเรียบร้อยแล้ว ขอบคุณสำหรับความคิดเห็นของคุณค่ะ!';

  @override
  String reportSendFailed(String error) {
    return 'ส่งรายงานผู้เล่นไม่สำเร็จ: $error';
  }

  @override
  String get reportNetworkFailed =>
      'ส่งไม่สำเร็จ กรุณาตรวจสอบการเชื่อมต่อเครือข่ายแล้วลองใหม่อีกครั้งค่ะ';

  @override
  String get reportAttachImageLabel => 'แนบรูปภาพ (ไม่บังคับ)';

  @override
  String get reportAttachImageHint =>
      'เมื่อรายงานปัญหาระบบหรือดอกไม้ไม่เข้าบัญชี สามารถแนบภาพแคปหน้าจอเพื่อให้ทีมงานตรวจสอบได้เร็วขึ้นค่ะ';

  @override
  String get reportOpeningAlbum => 'กำลังเปิดอัลบั้มรูปภาพ...';

  @override
  String get reportSelectFromAlbum => 'เลือกรูปภาพจากอัลบั้ม';

  @override
  String get reportSending => 'กำลังส่ง...';

  @override
  String get reportSubmit => 'ส่งรายงาน';

  @override
  String get reportRemoveImage => 'ลบรูปภาพออก';

  @override
  String get reportImageSelected => 'เลือกรูปภาพแล้ว';

  @override
  String get reportChangeImage => 'เปลี่ยน';

  @override
  String get reloadTranslation => 'โหลดการแปลใหม่';

  @override
  String get guideNotAvailableInLanguage =>
      'ขณะนี้ยังไม่มีคู่มือการเล่นในภาษาภาษาไทย จึงแสดงผลเป็นภาษาจีนตัวเต็มชั่วคราวค่ะ';

  @override
  String get clearSearch => 'ล้างการค้นหา';

  @override
  String get memoPermissionWarning =>
      'ยังไม่ได้เปิดสิทธิ์การแจ้งเตือน บันทึกจะถูกเก็บไว้ แต่จะไม่แสดงการแจ้งเตือนจากระบบค่ะ';

  @override
  String memoSavedWithNotification(String name) {
    return 'บันทึกเรียบร้อยแล้ว $name จะคอยเตือนคุณนะคะ!';
  }

  @override
  String get memoSavedNoPermission =>
      'บันทึกเรียบร้อยแล้ว แต่ยังไม่ได้เปิดสิทธิ์การแจ้งเตือนค่ะ';

  @override
  String memoUpdatedWithNotification(String name) {
    return 'อัปเดตบันทึกเรียบร้อยแล้ว $name จะคอยเตือนคุณนะคะ!';
  }

  @override
  String get memoUpdatedNoPermission =>
      'อัปเดตบันทึกเรียบร้อยแล้ว แต่ขณะนี้ยังไม่มีสิทธิ์การแจ้งเตือนค่ะ';

  @override
  String dataLoadError(String error) {
    return 'เกิดข้อผิดพลาดขณะโหลดข้อมูล: $error';
  }

  @override
  String loadFailed(String error) {
    return 'โหลดไม่สำเร็จ: $error';
  }

  @override
  String get dateFormatMonthDay => 'd MMM';

  @override
  String get timeFormatHourMinute => 'HH:mm';

  @override
  String get likeFeedPrompt => 'ชอบโพสต์นี้ไหมคะ? ส่งความรักให้เขาสิ!';

  @override
  String get saveFeedPocket => 'เก็บช่วงเวลาพิเศษไว้ในกระเป๋าของคุณเงียบๆ';

  @override
  String get newComment => 'ความคิดเห็นใหม่';

  @override
  String get someFriend => 'เพื่อนคนหนึ่ง';

  @override
  String get myBackpackAndPrivileges => 'กระเป๋าและสิทธิพิเศษของฉัน';

  @override
  String get currentRomanticBond => 'สายสัมพันธ์โรแมนติกที่สะสมได้ในปัจจุบัน';

  @override
  String get physicalGiftBoxUnlockStatus =>
      'สถานะการปลดล็อกกล่องของขวัญจับต้องได้:';

  @override
  String get topLovePhysicalVipBox =>
      'กล่องของขวัญ VIP เอ็กซ์คลูซีฟ 【รักสุดหัวใจ】';

  @override
  String get physicalGiftBoxContents =>
      'ประกอบด้วย: จดหมายเขียนด้วยมือ + ตุ๊กตาตัวละคร + จดหมายขอบคุณอย่างเป็นทางการ';

  @override
  String get modifyShippingAddress => 'แก้ไขข้อมูลที่อยู่จัดส่ง';

  @override
  String get addressUnlockedFillNow =>
      'ปลดล็อกแล้ว! แตะที่นี่เพื่อกรอกข้อมูลจัดส่งค่ะ';

  @override
  String get addressSuccessfullyRegistered =>
      'คุณได้ลงทะเบียนที่อยู่จัดส่งเรียบร้อยแล้ว เราจะรีบจัดเตรียมให้โดยเร็วที่สุดค่ะ!';

  @override
  String amountNeededForPhysicalPrize(String amount) {
    return 'ขาดอีกเพียง NT\$ $amount ก็จะปลดล็อกของรางวัลจับต้องได้แล้วค่ะ!';
  }

  @override
  String get avatarFrameHint =>
      'คำแนะนำ: สามารถดูและสวมใส่สกินดิจิทัลและกรอบรูปโปรไฟล์อื่นๆ ได้ที่ร้านค้าหรือการตั้งค่าส่วนตัวค่ะ';

  @override
  String get closeButton => 'ปิด';

  @override
  String get physicalGiftBoxUnlockTitle =>
      'ปลดล็อกกล่องของขวัญจับต้องได้ 【รักสุดหัวใจ】';

  @override
  String get physicalGiftBoxUnlockThanks =>
      'ขอบคุณสำหรับการสนับสนุนและการเคียงข้าง 《Lian Lian Shi Guang》 เสมอมาค่ะ!';

  @override
  String get physicalGiftBoxUnlockPrompt =>
      'กรุณากรอกข้อมูลจัดส่งด้านล่าง เพื่อให้เราจัดส่งจดหมายลายมือและตุ๊กตาตัวละครให้คุณค่ะ:';

  @override
  String get recipientRealName => 'ชื่อ-นามสกุลจริงของผู้รับ';

  @override
  String get contactPhone => 'เบอร์โทรศัพท์ติดต่อ';

  @override
  String get fullShippingAddress => 'ที่อยู่จัดส่งโดยละเอียด (รวมรหัสไปรษณีย์)';

  @override
  String get desiredCharacterDollName => 'ชื่อตัวละครของตุ๊กตาที่ต้องการรับ';

  @override
  String get characterNameExample => 'ตัวอย่าง: ชื่อตัวละครที่ต้องการกรอก';

  @override
  String get fillLater => 'ไว้กรอกทีหลัง';

  @override
  String get fillCompleteAddressAndRoleHint =>
      'กรุณากรอกข้อมูลจัดส่งและชื่อตัวละครที่คุณชื่นชอบให้ครบถ้วนนะคะ!';

  @override
  String get shippingInfoSubmittedSuccess =>
      'ส่งข้อมูลจัดส่งเรียบร้อยแล้ว! มารอลุ้นรับของขวัญสุดพิเศษกันนะคะ!';

  @override
  String get confirmSubmit => 'ยืนยันการส่ง';

  @override
  String get aboutMe => 'เกี่ยวกับฉัน';

  @override
  String get myBackpack => 'กระเป๋าของฉัน';

  @override
  String get ownerExclusiveArea => 'พื้นที่เฉพาะเจ้าของ';

  @override
  String get enterShiguangAdminBackend => 'เข้าสู่คอนโซลผู้ดูแลระบบ Shiguang';

  @override
  String get errorOccurred => 'เกิดข้อผิดพลาด';

  @override
  String get creatorGuidelines => 'แนวทางปฏิบัติสำหรับครีเอเตอร์';

  @override
  String get playGuide => 'คู่มือการเล่น';

  @override
  String get lianlianShiguang => 'Lian Lian Shi Guang';

  @override
  String get copyrightNotice => '© 2026 Mo Yu Bai';

  @override
  String get cumulativeBenefits => 'สิทธิประโยชน์สะสม';

  @override
  String get perkFirstEncounter => 'แรกรักประทับใจ';

  @override
  String get perkFirstEncounterReward =>
      'ดอกไม้แห่งเวลา 20 ดอก + ฉายามือใหม่เฉพาะตัว';

  @override
  String get perkGlimmerThrob => 'แสงริบหรี่ใจเต้น';

  @override
  String get perkGlimmerThrobReward =>
      'กรอบรูปโปรไฟล์เฉพาะตัว 【แสงริบหรี่ใจเต้น】';

  @override
  String get perkStarryWhisper => 'เสียงกระซิบแห่งดวงดาว';

  @override
  String get perkStarryWhisperReward =>
      'กรอบข้อความแชทเฉพาะตัว + ดอกไม้แห่งเวลา 50 ดอก';

  @override
  String get perkRomanticSunset => 'พระอาทิตย์ตกอันแสนโรแมนติก';

  @override
  String get perkRomanticSunsetReward => 'ไอคอนหน้าจอแอปแบบเฉพาะตัว';

  @override
  String get perkHeartbeat => 'เสียงหัวใจเต้น';

  @override
  String get perkHeartbeatReward =>
      'เอฟเฟกต์การแตะหน้าจอ + ดอกไม้แห่งเวลา 100 ดอก';

  @override
  String get perkEternalVow => 'คำสาบานนิรันดร์';

  @override
  String get perkEternalVowReward =>
      'กรอบรูปโปรไฟล์ดุ๊กดิ๊กขั้นสูง + ดอกไม้แห่งเวลา 200 ดอก';

  @override
  String get perkSoulIntersection => 'วิญญาณผูกพัน';

  @override
  String get perkSoulIntersectionReward =>
      'เอฟเฟกต์กรอบข้อความแชทดุ๊กดิ๊ก + ฉายาขั้นสูงเฉพาะตัว';

  @override
  String get perkExclusiveWait => 'การเฝ้ารอเฉพาะตัว';

  @override
  String get perkExclusiveWaitReward =>
      'ป้ายชื่อดุ๊กดิ๊กระดับพรีเมียม + ดอกไม้แห่งเวลา 500 ดอก';

  @override
  String get perkBrilliantGalaxy => 'ทางช้างเผือกทอแสง';

  @override
  String get perkBrilliantGalaxyReward =>
      'เอฟเฟกต์ปรากฏตัวเฉพาะตัว + บริการลูกค้า VIP ส่วนตัว';

  @override
  String get perkTopBeloved => 'รักสุดหัวใจ';

  @override
  String get perkTopBelovedReward =>
      'กล่องของขวัญ VIP เอ็กซ์คลูซีฟแบบจับต้องได้';

  @override
  String get cumulativeRomanticBond => 'สายสัมพันธ์โรแมนติกสะสม';

  @override
  String get allTopPrivilegesUnlocked =>
      'คุณได้ปลดล็อกสิทธิพิเศษระดับสูงสุดทั้งหมดแล้วค่ะ!';

  @override
  String rechargeAmountForNextTier(String amount) {
    return 'เติมเงินเพิ่มอีก NT\$ $amount เพื่อปลดล็อกระดับถัดไป';
  }

  @override
  String get storyContentCannotBeEmpty => 'เนื้อเรื่องต้องไม่ว่างเปล่า';

  @override
  String get writeYourStoryHint => 'เขียนเรื่องราวของคุณ...';

  @override
  String get characterBannerTitle => 'แบนเนอร์หน้าหลักของตัวละคร';

  @override
  String get mailDeleteTitle => 'ลบข้อความ';

  @override
  String mailDeleteConfirm(int count) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบข้อความ $count รายการ?\nเมื่อลบแล้วจะไม่สามารถกู้คืนได้';
  }

  @override
  String mailDeleteSuccess(int count) {
    return 'ลบข้อความ $count รายการแล้ว';
  }

  @override
  String get mailDeleteFailed => 'ลบไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get mailCancelSelection => 'ยกเลิกการเลือก';

  @override
  String mailSelectedCount(int count) {
    return 'เลือกแล้ว $count รายการ';
  }

  @override
  String get moreOptions => 'เพิ่มเติม';

  @override
  String mailDeleteSelected(int count) {
    return 'ลบข้อความ $count รายการ';
  }

  @override
  String get officialManagementTeam => 'ทีมผู้ดูแล LoveyDovey';

  @override
  String get rewardCampaignTitle => 'ของขวัญกิจกรรม';

  @override
  String get rewardCampaignMissingData =>
      'ข้อความของขวัญนี้ไม่มีข้อมูลกิจกรรม โปรดลองอีกครั้งในภายหลัง';

  @override
  String rewardCampaignClaimSuccess(int amount) {
    return 'รับดอกไม้ $amount ดอกแล้ว';
  }

  @override
  String get rewardCampaignAlreadyClaimed => 'รับของขวัญนี้ไปแล้ว';

  @override
  String get rewardCampaignClaimFailed =>
      'รับไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get rewardCampaignContains => 'ข้อความนี้มี';

  @override
  String rewardCampaignFlowerAmount(int amount) {
    return 'ดอกไม้ $amount ดอก';
  }

  @override
  String rewardCampaignDeadline(String date) {
    return 'หมดเขตรับ: $date';
  }

  @override
  String get rewardCampaignClaiming => 'กำลังรับ…';

  @override
  String get rewardCampaignClaimed => 'รับแล้ว';

  @override
  String get rewardCampaignEnded => 'กิจกรรมสิ้นสุดแล้ว';

  @override
  String get rewardCampaignClaimButton => 'รับของขวัญ';

  @override
  String get mailDetailTitle => 'ข้อความ';

  @override
  String mailSender(String name) {
    return 'ผู้ส่ง: $name';
  }

  @override
  String get mailCaseNumber => 'หมายเลขกรณี';

  @override
  String get mailCopyCaseNumber => 'คัดลอกหมายเลขกรณี';

  @override
  String get mailCaseNumberCopied => 'คัดลอกหมายเลขกรณีแล้ว';

  @override
  String get profilePageAboutMe => 'เกี่ยวกับฉัน';

  @override
  String get profilePageTabBio => 'แนะนำตัว';

  @override
  String get profilePageTabCharacters => 'ตัวละคร';

  @override
  String get profilePageTabMoments => 'โพสต์';

  @override
  String get profilePageEditProfile => 'แก้ไขโปรไฟล์';

  @override
  String get profilePageFriends => 'เพื่อน';

  @override
  String get profilePageWorks => 'ผลงาน';

  @override
  String get profilePageFollowing => 'กำลังติดตาม';

  @override
  String get profilePageFollowers => 'ผู้ติดตาม';

  @override
  String get profilePageHeartbeatDiary => 'ไดอารีหัวใจเต้น';

  @override
  String get profilePageEditCharacter => 'แก้ไขตัวละคร';

  @override
  String get profilePagePreviewCharacter => 'ดูตัวอย่างโปรไฟล์ตัวละคร';

  @override
  String get profilePageNoBio => 'ยังไม่มีคำแนะนำตัว';

  @override
  String get profilePageNoBioHint => 'แตะเพื่อเขียนเรื่องราวเกี่ยวกับตัวคุณ';

  @override
  String get profilePageCreateCharacter => 'สร้างตัวละครใหม่';

  @override
  String get profilePageNoCharacters => 'ยังไม่ได้สร้างตัวละคร';

  @override
  String get profilePageNoCharactersHint => 'เริ่มสร้างตัวละครแรกของคุณกันเลย';

  @override
  String get profilePageCharacterActions => 'การดำเนินการกับตัวละคร';

  @override
  String get profilePagePublic => 'สาธารณะ';

  @override
  String get profilePagePrivate => 'ส่วนตัว';

  @override
  String get profilePageCreator => 'ครีเอเตอร์';

  @override
  String get profilePageSelectPostingIdentity => 'เลือกตัวตนสำหรับโพสต์';

  @override
  String get profilePagePostAsCreator => 'โพสต์ในฐานะครีเอเตอร์';

  @override
  String get profilePagePublicCharacter => 'ตัวละครสาธารณะ';

  @override
  String get profilePagePrivateCharacter => 'ตัวละครส่วนตัว';

  @override
  String get profilePagePleaseSignIn => 'โปรดเข้าสู่ระบบก่อน';

  @override
  String get profilePagePublishMoment => 'เผยแพร่โพสต์';

  @override
  String get profilePageFilterAll => 'ทั้งหมด';

  @override
  String get profilePageFilterCreator => 'ฉัน';

  @override
  String get profilePageFilterCharacter => 'ตัวละคร';

  @override
  String get profilePageMomentsLoadFailed => 'โหลดโพสต์ไม่สำเร็จ';

  @override
  String get profilePageTryAgainLater => 'โปรดลองอีกครั้งในภายหลัง';

  @override
  String get profilePageNoCreatorMoments => 'คุณยังไม่ได้เผยแพร่โพสต์';

  @override
  String get profilePageNoCreatorMomentsHint =>
      'เนื้อหาที่เผยแพร่ในฐานะครีเอเตอร์จะแสดงที่นี่';

  @override
  String get profilePageNoCharacterMoments =>
      'ตัวละครของคุณยังไม่ได้เผยแพร่โพสต์';

  @override
  String get profilePageNoCharacterMomentsHint =>
      'เนื้อหาที่เผยแพร่ในฐานะตัวละครจะแสดงที่นี่';

  @override
  String get profilePageNoMoments => 'ยังไม่มีโพสต์';

  @override
  String get profilePageNoMomentsHint =>
      'โพสต์ที่เผยแพร่โดยคุณและตัวละครของคุณจะแสดงที่นี่';

  @override
  String get profilePageDeleteMomentTitle => 'ลบโพสต์';

  @override
  String get profilePageDeleteMomentConfirm =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบโพสต์นี้อย่างถาวร?';

  @override
  String get profilePageCancel => 'ยกเลิก';

  @override
  String get profilePageDelete => 'ลบ';

  @override
  String get profilePageMomentDeleted => 'ลบโพสต์แล้ว';

  @override
  String get profilePageDeleteFailed => 'ลบไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get profilePageReferralCompleted => 'คำเชิญแห่งดวงดาวเสร็จสมบูรณ์';

  @override
  String profilePageInviter(String inviterId) {
    return 'ผู้เชิญ: $inviterId';
  }

  @override
  String get profilePageReferralRewardReceived =>
      'ทั้งสองฝ่ายได้รับดอกไม้ 50 ดอกแล้ว';

  @override
  String get profilePageClaimed => 'รับแล้ว';

  @override
  String profilePageInviterBound(String inviterId) {
    return 'เชื่อมโยงผู้เชิญแล้ว: $inviterId';
  }

  @override
  String get profilePageReferralProgressHint =>
      'หลังจากส่งข้อความแชตครบ 15 ข้อความ ทั้งสองฝ่ายจะได้รับดอกไม้คนละ 50 ดอก';

  @override
  String get profilePageAlreadyCheckedIn => 'วันนี้คุณเช็กอินแล้ว';

  @override
  String get profilePageReferralBindFailed =>
      'เชื่อมโยงไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get profilePageCharacterNotFound => 'ไม่พบข้อมูลของตัวละครนี้';

  @override
  String get periodGuideTitle => 'ใช้ไดอารีประจำเดือนอย่างไร?';

  @override
  String get periodGuideContent =>
      '① ขั้นแรก ให้เลือกวันที่บนปฏิทิน\n② เลือก “เริ่มวันนี้” “ยังมีประจำเดือนอยู่” หรือ “สิ้นสุดวันนี้”\n③ เลือกอารมณ์และสภาพร่างกายของวันนี้ และสามารถเพิ่มรายละเอียดเพิ่มเติมได้\n④ กดบันทึก แล้วตัวละครจะสามารถเข้าใจสภาพของคุณในวันนี้ขณะสนทนาได้\n\nวันที่คาดการณ์จะปรับตามประวัติการบันทึกของคุณ และมีไว้เพื่อใช้อ้างอิงสำหรับการบันทึกส่วนตัวเท่านั้น';

  @override
  String get periodGotIt => 'เข้าใจแล้ว';

  @override
  String get periodSelectAtLeastOne =>
      'โปรดเลือกอย่างน้อยหนึ่งรายการเพื่อบันทึก';

  @override
  String get periodFutureDateError =>
      'ไม่สามารถระบุสถานะประจำเดือนในวันที่ในอนาคตได้';

  @override
  String get periodAlreadyOngoingError =>
      'มีประจำเดือนรอบหนึ่งที่กำลังดำเนินอยู่ โปรดระบุว่าสิ้นสุดแล้วก่อน';

  @override
  String get periodNoOngoingError =>
      'ขณะนี้ไม่มีประจำเดือนที่กำลังดำเนินอยู่ โปรดเลือก “เริ่มวันนี้” ก่อน';

  @override
  String get periodBeforeStartError =>
      'วันที่ต้องไม่อยู่ก่อนวันที่เริ่มต้นของประจำเดือนรอบนี้';

  @override
  String get periodEndBeforeStartError =>
      'วันที่สิ้นสุดต้องไม่อยู่ก่อนวันที่เริ่มต้น';

  @override
  String periodRecordSaved(String date) {
    return 'บันทึกข้อมูลของวันที่ $date แล้ว';
  }

  @override
  String get periodSaveFailed => 'บันทึกไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get periodDeleteTitle => 'ลบบันทึกประจำเดือนรอบนี้หรือไม่?';

  @override
  String get periodDeleteContent =>
      'หลังจากลบแล้ว ค่าเฉลี่ยรอบเดือนและการคาดการณ์ครั้งถัดไปจะถูกคำนวณใหม่';

  @override
  String get periodCancel => 'ยกเลิก';

  @override
  String get periodDelete => 'ลบ';

  @override
  String get periodNoOngoing => 'ขณะนี้ไม่มีประจำเดือนที่กำลังดำเนินอยู่';

  @override
  String periodDayCount(int count) {
    return 'วันที่ $count ของประจำเดือน';
  }

  @override
  String get periodHelp => 'วิธีใช้งาน';

  @override
  String get periodAverageCycle => 'รอบเดือนเฉลี่ย';

  @override
  String get periodAverageDuration => 'ระยะเวลาประจำเดือนเฉลี่ย';

  @override
  String periodDays(int count) {
    return '$count วัน';
  }

  @override
  String get periodNextPrediction => 'การคาดการณ์ครั้งถัดไป';

  @override
  String get periodCalculatedAfterRecording => 'คำนวณหลังจากบันทึก';

  @override
  String get periodInsufficientData =>
      'ขณะนี้มีข้อมูลไม่เพียงพอ จึงคาดการณ์ชั่วคราวโดยใช้รอบเดือน 28 วันและระยะเวลาประจำเดือน 5 วัน';

  @override
  String get periodPredictionDisclaimer =>
      'การคาดการณ์อิงตามข้อมูลที่บันทึกไว้ วันที่มีไว้เพื่อใช้อ้างอิงสำหรับการบันทึกส่วนตัวเท่านั้น';

  @override
  String get periodStartedToday => 'เริ่มวันนี้';

  @override
  String get periodStillOngoing => 'ยังมีประจำเดือนอยู่';

  @override
  String get periodEndedToday => 'สิ้นสุดวันนี้';

  @override
  String get periodDateNotReached => 'ยังไม่ถึงวันนี้นะ～';

  @override
  String get periodDateBeforeStart =>
      'วันนี้อยู่ก่อนวันที่เริ่มต้นของประจำเดือนรอบปัจจุบัน';

  @override
  String get periodMoodOkay => 'ค่อนข้างดี';

  @override
  String get periodMoodHappy => 'มีความสุข';

  @override
  String get periodMoodLow => 'รู้สึกเศร้า';

  @override
  String get periodMoodUnwell => 'ไม่สบาย';

  @override
  String get periodMoodIrritable => 'หงุดหงิด';

  @override
  String get periodMoodTired => 'เหนื่อย';

  @override
  String get periodMoodAnxious => 'กังวล';

  @override
  String get periodSymptomAbdominalPain => 'ปวดท้อง';

  @override
  String get periodSymptomLowerBackPain => 'ปวดหลังส่วนล่าง';

  @override
  String get periodSymptomHeadache => 'ปวดศีรษะ';

  @override
  String get periodSymptomBreastTenderness => 'คัดตึงเต้านม';

  @override
  String get periodSymptomSwelling => 'บวมน้ำ';

  @override
  String get periodSymptomSleepy => 'ง่วงนอน';

  @override
  String get periodSymptomIncreasedAppetite => 'อยากอาหารมากขึ้น';

  @override
  String get periodSymptomDigestiveDiscomfort => 'ไม่สบายท้อง';

  @override
  String periodDiaryTitle(String characterName) {
    return 'ไดอารีแสนใส่ใจของ $characterName';
  }

  @override
  String get periodLoadFailed => 'โหลดบันทึกไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get periodWeekdaySun => 'อา.';

  @override
  String get periodWeekdayMon => 'จ.';

  @override
  String get periodWeekdayTue => 'อ.';

  @override
  String get periodWeekdayWed => 'พ.';

  @override
  String get periodWeekdayThu => 'พฤ.';

  @override
  String get periodWeekdayFri => 'ศ.';

  @override
  String get periodWeekdaySat => 'ส.';

  @override
  String get periodSaveInstruction =>
      'หลังจากเลือกสถานะแล้ว โปรดกด “บันทึกข้อมูลวันนี้” ที่ด้านล่างเพื่อบันทึกข้อมูล';

  @override
  String get periodTodayMood => 'อารมณ์วันนี้ (เลือกได้หลายรายการ)';

  @override
  String get periodMoodDescription =>
      'รายการเหล่านี้เป็นบันทึกประจำวัน ไม่ใช่ไอคอนที่จะแสดงบนปฏิทิน';

  @override
  String get periodOtherMood => 'อารมณ์อื่น ๆ';

  @override
  String get periodOtherMoodHint => 'ตัวอย่าง: รู้สึกน้อยใจ ไม่รู้สึกปลอดภัย……';

  @override
  String get periodTodaySymptoms => 'สภาพร่างกายวันนี้ (เลือกได้หลายรายการ)';

  @override
  String get periodOtherSymptom => 'สภาพร่างกายอื่น ๆ';

  @override
  String get periodOtherSymptomHint => 'ตัวอย่าง: รู้สึกหนาว ไม่อยากอาหาร……';

  @override
  String periodNoteForCharacter(String characterName) {
    return 'สิ่งที่อยากให้ $characterName รู้ (ไม่บังคับ)';
  }

  @override
  String get periodNoteHint =>
      'ตัวอย่าง: วันนี้อยากพักผ่อนเงียบ ๆ และไม่อยากถูกเร่ง……';

  @override
  String get periodSaving => 'กำลังบันทึก…';

  @override
  String get periodSaveToday => 'บันทึกข้อมูลวันนี้';

  @override
  String get periodHistory => 'ประวัติประจำเดือน';

  @override
  String get periodOngoing => 'กำลังดำเนินอยู่';

  @override
  String periodTotalDays(int count) {
    return 'รวม $count วัน';
  }

  @override
  String get periodDeleteRecord => 'ลบบันทึก';

  @override
  String get privateProfilePleaseSignIn => 'โปรดเข้าสู่ระบบก่อน';

  @override
  String privateProfileLoreLoadFailed(String error) {
    return 'โหลดเศษเสี้ยวความทรงจำไม่สำเร็จ: $error';
  }

  @override
  String privateProfileWriteNewLore(int count, int limit) {
    return 'เขียนเศษเสี้ยวความทรงจำใหม่ ($count / $limit)';
  }

  @override
  String get privateProfileNoLore => 'ยังไม่มีเศษเสี้ยวความทรงจำ';

  @override
  String get privateProfileNoLoreHint =>
      'คุณสามารถจัดระเบียบการตั้งค่าทดสอบ เบาะแสของเรื่องราว และความทรงจำสำคัญของตัวละครได้ที่นี่';

  @override
  String get privateProfileUntitledLore => 'เศษเสี้ยวที่ไม่มีชื่อ';

  @override
  String get privateProfileEdit => 'แก้ไข';

  @override
  String get privateProfileDelete => 'ลบ';

  @override
  String get privateProfileAddLore => 'เพิ่มเศษเสี้ยวความทรงจำ';

  @override
  String get privateProfileLoreTitle => 'ชื่อเรื่อง';

  @override
  String get privateProfileLoreTeaser => 'คำใบ้สั้น ๆ';

  @override
  String get privateProfileLoreContent => 'เนื้อหาทั้งหมด';

  @override
  String get privateProfileLockLore => 'ล็อกเศษเสี้ยว';

  @override
  String get privateProfileLockLoreHint =>
      'ขณะนี้ตัวละครส่วนตัวสามารถมองเห็นได้โดยครีเอเตอร์เท่านั้น ช่องนี้จะยังคงถูกเก็บไว้เพื่อใช้งานต่อเมื่อตัวละครถูกตั้งเป็นสาธารณะ';

  @override
  String get privateProfileCancel => 'ยกเลิก';

  @override
  String get privateProfileTitleContentRequired =>
      'โปรดกรอกชื่อเรื่องและเนื้อหา';

  @override
  String get privateProfileLoreAdded => 'เพิ่มเศษเสี้ยวความทรงจำแล้ว';

  @override
  String get privateProfileAddFailed =>
      'เพิ่มไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get privateProfilePublish => 'เผยแพร่';

  @override
  String get privateProfileDeleteLoreTitle => 'ลบเศษเสี้ยวความทรงจำ';

  @override
  String get privateProfileDeleteLoreConfirm =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบเศษเสี้ยวความทรงจำนี้อย่างถาวร?';

  @override
  String get privateProfileLoreDeleted => 'ลบเศษเสี้ยวความทรงจำแล้ว';

  @override
  String get privateProfileDeleteFailed =>
      'ลบไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get privateProfileEditLore => 'แก้ไขเศษเสี้ยวความทรงจำ';

  @override
  String get privateProfileSave => 'บันทึก';

  @override
  String get editProfileBirthdayReminderTitle => 'แจ้งเตือนเล็กน้อย';

  @override
  String get editProfileBirthdayReminderContent =>
      'วันเกิดของคุณจะส่งผลต่อคำอวยพรวันเกิดจากตัวละคร ของขวัญวันเกิด และกิจกรรมที่เกี่ยวข้อง\n\nขอแนะนำให้ตรวจสอบวันเกิดให้ถูกต้องก่อนตั้งค่าให้เสร็จสิ้น\nเพื่อไม่ให้ส่งผลต่อรางวัลวันเกิดในอนาคต';

  @override
  String get editProfileGotIt => 'เข้าใจแล้ว';

  @override
  String get editProfileBirthdayConfirmTitle => 'ยืนยันวันเกิด';

  @override
  String get editProfileBirthdayConfirmContent =>
      'โปรดตรวจสอบว่าวันเกิดถูกต้องหรือไม่\n\nวันเกิดจะถูกใช้สำหรับคำอวยพรวันเกิด ของขวัญวันเกิด และกิจกรรมที่เกี่ยวข้อง\n\nเพื่อป้องกันการรับรางวัลวันเกิดซ้ำ จะไม่สามารถแก้ไขวันเกิดได้อีกหลังจากตั้งค่าเสร็จสิ้น\n\nยืนยันว่าจะใช้วันเกิดนี้หรือไม่?';

  @override
  String get editProfileReturnToEdit => 'กลับไปแก้ไข';

  @override
  String get editProfileConfirmSetting => 'ยืนยันการตั้งค่า';

  @override
  String get editProfileDefaultNickname => 'นักเดินทางที่เพิ่งรู้จัก';

  @override
  String get editProfileNoChanges => 'ไม่มีการเปลี่ยนแปลงที่ต้องบันทึก';

  @override
  String editProfileCreateFailed(String error) {
    return 'สร้างข้อมูลไม่สำเร็จ: $error';
  }

  @override
  String editProfileAvatarNumber(int number) {
    return 'รูปโปรไฟล์ $number';
  }

  @override
  String get editProfileImageSelectionFailed =>
      'เลือกรูปภาพไม่สำเร็จ โปรดเลือกรูปภาพอื่น';

  @override
  String get editProfileCancel => 'ยกเลิก';

  @override
  String get editProfileConfirm => 'ยืนยัน';

  @override
  String get editProfileImageProcessingFailed =>
      'ประมวลผลรูปภาพไม่สำเร็จ โปรดเลือกรูปภาพอื่น';

  @override
  String editProfileLoadFailed(String error) {
    return 'โหลดข้อมูลไม่สำเร็จ: $error';
  }

  @override
  String get editProfileBioLabel => 'แนะนำตัว';

  @override
  String get editProfileBioHelper =>
      'แนะนำตัวคุณหรือสไตล์การสร้างสรรค์ของคุณแบบสั้น ๆ';

  @override
  String get editProfileBioHint =>
      'ตัวอย่าง: ชอบสร้างตัวละครแนวโรแมนติกแฟนตาซี คลั่งรัก และชวนดื่มด่ำ';

  @override
  String get editProfileUserNotFound => 'ไม่พบผู้ใช้';

  @override
  String get editProfileGenerateIdFailed =>
      'สร้าง ID ผู้เล่นไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get editProfileSignedInUserNotFound =>
      'ไม่พบผู้ใช้ที่เข้าสู่ระบบอยู่ในขณะนี้';

  @override
  String editProfileAvatarReadFailed(int statusCode) {
    return 'โหลดรูปโปรไฟล์ไม่สำเร็จ รหัสสถานะ: $statusCode';
  }

  @override
  String editProfileAvatarFileNotFound(String path) {
    return 'ไม่พบไฟล์รูปโปรไฟล์ที่เลือก: $path';
  }

  @override
  String get editProfileAvatarEmpty => 'ข้อมูลรูปโปรไฟล์ว่างเปล่า';

  @override
  String get chatPageSendFailed => 'ส่งไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get chatPageRegenerateFailed =>
      'สร้างใหม่ไม่สำเร็จ ข้อความเดิมยังถูกเก็บไว้ โปรดลองอีกครั้ง';

  @override
  String get chatPageRegenerating => 'กำลังคิดใหม่...';

  @override
  String get chatPageThinkingTooLong =>
      'ดูเหมือนว่าเขากำลังครุ่นคิด โปรดลองอีกครั้งในภายหลัง……';

  @override
  String get chatPageAlreadyReplying =>
      'เขากำลังตอบอยู่ โปรดรอสักครู่และอย่าส่งซ้ำ';

  @override
  String get chatPageMediaUploadFailed =>
      'อัปโหลดสื่อไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get chatPageReportReceived =>
      'ขอบคุณสำหรับการรายงาน เราจะตรวจสอบโดยเร็วที่สุด';

  @override
  String chatPageMessagesDeleted(int count) {
    return 'ลบข้อความ $count รายการสำเร็จแล้ว';
  }

  @override
  String chatPageSelectPhotoFailed(String error) {
    return 'ไม่สามารถเลือกรูปภาพได้: $error';
  }

  @override
  String get chatPageRecordingNotFound => 'ไม่พบไฟล์บันทึกเสียง';

  @override
  String get chatPageRecordingEmpty => 'ไฟล์บันทึกเสียงว่างเปล่า';

  @override
  String chatPageAudioPlaybackFailed(String error) {
    return 'เล่นเสียงไม่สำเร็จ: $error';
  }

  @override
  String get chatPageMicrophonePermissionRequired =>
      'จำเป็นต้องอนุญาตการใช้ไมโครโฟนเพื่อบันทึกเสียง';

  @override
  String chatPageStartRecordingFailed(String error) {
    return 'ไม่สามารถเริ่มบันทึกเสียงได้: $error';
  }

  @override
  String get chatPageRecordingCreationFailed =>
      'สร้างไฟล์บันทึกเสียงไม่สำเร็จ โปรดบันทึกใหม่';

  @override
  String chatPageRecordingFailed(String error) {
    return 'บันทึกเสียงไม่สำเร็จ: $error';
  }

  @override
  String get chatPageRecordingNotFoundRetry =>
      'ไม่พบไฟล์บันทึกเสียง โปรดบันทึกใหม่';

  @override
  String get chatPageRecordingEmptyRetry =>
      'ไฟล์บันทึกเสียงว่างเปล่า โปรดบันทึกใหม่';

  @override
  String get chatPageNoRecordingToSend => 'ไม่มีไฟล์บันทึกเสียงที่สามารถส่งได้';

  @override
  String chatPagePointCost(int count) {
    return '$count คะแนน';
  }

  @override
  String get chatPageVoiceUploading => 'กำลังอัปโหลดเสียง……';

  @override
  String get chatPageChangeWatermarkColor => 'เปลี่ยนสีลายน้ำ';

  @override
  String chatPageMinutesSeconds(int minutes, int seconds) {
    return '$minutes นาที $seconds วินาที';
  }

  @override
  String chatPageSeconds(int seconds) {
    return '$seconds วินาที';
  }

  @override
  String get characterEditSelectSupportingCharacter => 'โปรดเลือกตัวละครสมทบ';

  @override
  String get characterEditSelectGender => 'โปรดเลือกเพศของตัวละคร';

  @override
  String get characterEditCharacterSettings => 'การตั้งค่าตัวละคร';

  @override
  String get characterEditWorldview => 'โลกทัศน์';

  @override
  String get characterEditSettingsMinLength =>
      'การตั้งค่าตัวละครต้องมีอย่างน้อย 10 ตัวอักษร';

  @override
  String get characterEditWorldviewMinLength =>
      'โลกทัศน์ต้องมีอย่างน้อย 20 ตัวอักษร';

  @override
  String get characterEditSupportingCharacters => 'ตัวละครสมทบ';

  @override
  String get characterEditCharacterImage => 'รูปภาพตัวละคร';

  @override
  String get characterEditWorldviewHint =>
      'อธิบายภูมิหลัง ประวัติศาสตร์ ยุคสมัย ภูมิภาค กลุ่มอำนาจ ระบบ เทคโนโลยี เวทมนตร์ และกฎของโลก';

  @override
  String get characterEditSettingsHint =>
      'อธิบายบุคลิก ค่านิยม วิธีคิด การตอบสนองทางอารมณ์ พฤติกรรมที่เคยชิน วิธีพูด และความเชื่อหลักของตัวละคร';

  @override
  String get characterEditUnknownCharacter => 'ตัวละครที่ไม่รู้จัก';

  @override
  String get characterEditEditSupportingCharacter => 'แก้ไขตัวละครสมทบ';

  @override
  String get characterEditAddSupportingCharacter => 'เพิ่มตัวละครสมทบ';

  @override
  String get characterEditSupportingCharacterName => 'ชื่อตัวละครสมทบ';

  @override
  String get characterEditGender => 'เพศ';

  @override
  String get characterEditMale => 'ชาย';

  @override
  String get characterEditFemale => 'หญิง';

  @override
  String get characterEditOther => 'อื่น ๆ';

  @override
  String get characterEditAge => 'อายุ';

  @override
  String get characterEditIdentityOccupation => 'สถานะ／อาชีพ';

  @override
  String get characterEditRelationshipWithMain => 'ความสัมพันธ์กับตัวละครหลัก';

  @override
  String get characterEditRelationshipHint =>
      'อธิบายอดีต จุดยืน ความรู้สึก ความลับ และความสัมพันธ์ปัจจุบันกับตัวละครหลัก';

  @override
  String get characterEditCharacterProfile => 'ข้อมูลตัวละคร';

  @override
  String get characterEditCharacterProfileHint =>
      'อธิบายบุคลิก รูปลักษณ์ นิสัย ค่านิยม ความสามารถ ความชอบ สิ่งที่ไม่ชอบ และประสบการณ์สำคัญของตัวละคร';

  @override
  String get characterEditSpeakingStyle => 'รูปแบบการพูด';

  @override
  String get characterEditSpeakingStyleHint =>
      'ตัวอย่าง: พูดเร็ว ชอบพูดเหน็บแนม และพูดตรงไปตรงมา';

  @override
  String get characterEditSupportingNameRequired => 'โปรดกรอกชื่อตัวละครสมทบ';

  @override
  String get characterEditSupportingGenderRequired =>
      'โปรดเลือกเพศของตัวละครสมทบ';

  @override
  String get characterEditProfileRequired => 'โปรดกรอกข้อมูลตัวละคร';

  @override
  String get characterEditRelationshipTooLong =>
      'ความสัมพันธ์กับตัวละครหลักมีความยาวเกิน 1,500 ตัวอักษร';

  @override
  String get characterEditProfileTooLong =>
      'ข้อมูลตัวละครมีความยาวเกิน 1,500 ตัวอักษร';

  @override
  String get characterEditSave => 'บันทึก';

  @override
  String get characterEditAdd => 'เพิ่ม';

  @override
  String get creatorProfileNoBio => 'ยังไม่มีคำแนะนำตัว';

  @override
  String get creatorProfileNoBioHint =>
      'ครีเอเตอร์คนนี้ยังไม่ได้เพิ่มคำแนะนำตัว';

  @override
  String get creatorProfileNoCreatorMoments =>
      'ครีเอเตอร์ยังไม่ได้เผยแพร่โพสต์';

  @override
  String get creatorProfileNoCreatorMomentsHint =>
      'เนื้อหาสาธารณะที่เผยแพร่ในฐานะครีเอเตอร์จะแสดงที่นี่';

  @override
  String get creatorProfileNoCharacterMoments =>
      'ตัวละครของครีเอเตอร์ยังไม่ได้เผยแพร่โพสต์';

  @override
  String get creatorProfileNoCharacterMomentsHint =>
      'เนื้อหาที่เผยแพร่โดยตัวละครสาธารณะของครีเอเตอร์จะแสดงที่นี่';

  @override
  String get creatorProfileNoPublicMoments => 'ยังไม่มีโพสต์สาธารณะ';

  @override
  String get creatorProfileNoPublicMomentsHint =>
      'โพสต์สาธารณะที่เผยแพร่โดยครีเอเตอร์และตัวละครจะแสดงที่นี่';

  @override
  String get creatorProfilePublicWorks => 'ผลงานสาธารณะ';

  @override
  String get creatorProfileLikesReceived => 'จำนวนถูกใจที่ได้รับ';

  @override
  String get creatorProfileFollow => 'ติดตาม';

  @override
  String get creatorProfileFollowing => 'กำลังติดตาม';

  @override
  String get creatorProfileUnfollowed => 'เลิกติดตามแล้ว';

  @override
  String creatorProfileFollowedCreator(String creatorName) {
    return 'ติดตาม $creatorName แล้ว';
  }

  @override
  String get creatorProfileOperationFailed =>
      'ดำเนินการไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String creatorProfileWorksLoadFailed(String error) {
    return 'โหลดผลงานไม่สำเร็จ: $error';
  }

  @override
  String get characterProfileShareInvitation =>
      'คำเชิญแห่งการพบเจอจาก LoveyDovey';

  @override
  String characterProfileShareCreator(String creatorName) {
    return 'ครีเอเตอร์: $creatorName';
  }

  @override
  String characterProfileShareMessage(String characterName) {
    return 'ค้นหา “$characterName” ใน LoveyDovey แล้วเริ่มต้นเรื่องราวที่เป็นของคุณสองคนเท่านั้น';
  }

  @override
  String get characterProfileInvitationLabel => 'การ์ดเชิญตัวละคร';

  @override
  String characterProfileCardCreator(String creatorName) {
    return 'ครีเอเตอร์  $creatorName';
  }

  @override
  String get characterProfileCardSearchHint =>
      'ค้นหาตัวละคร แล้วเริ่มต้นการพบเจอ';

  @override
  String get characterProfileScanToDownload => 'สแกนเพื่อดาวน์โหลด';

  @override
  String characterProfileShareTitle(String characterName) {
    return 'แชร์ตัวละคร “$characterName”';
  }

  @override
  String characterProfileShareSubject(String characterName) {
    return 'มารู้จัก $characterName ที่ LoveyDovey';
  }

  @override
  String get characterProfileShareFailed =>
      'สร้างการ์ดเชิญไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get characterProfilePrivateShareUnavailable =>
      'ขณะนี้ยังไม่สามารถแชร์ตัวละครส่วนตัวได้';

  @override
  String get characterProfileShareCard => 'แชร์การ์ดเชิญ';

  @override
  String get characterProfileShareCharacter => 'แชร์ตัวละคร';

  @override
  String get characterProfileReportCharacter => 'รายงานตัวละคร';

  @override
  String get characterProfileTranslate => 'แปล';

  @override
  String get loginMethodInfoTooltip => 'คำอธิบายวิธีเข้าสู่ระบบ';

  @override
  String get characterEditCoreSetting => 'การตั้งค่าหลักของตัวละคร';

  @override
  String get characterEditCoreSettingHint =>
      'โปรดอธิบายบุคลิก รูปแบบพฤติกรรม วิธีปฏิสัมพันธ์กับผู้อื่น และลักษณะการพูดของตัวละคร\n\nตัวอย่าง: ภายนอกเขาดูเย็นชาและพูดน้อย แต่ความจริงแล้วเป็นคนใส่ใจมาก เขารักษาระยะห่างกับคนแปลกหน้า ดูแลคนที่ชอบผ่านการกระทำ พูดสั้น กระชับ และตรงไปตรงมา โดยไม่ใช้คำเรียกที่หวานเลี่ยนหรือเจ้าชู้จนเกินไป';

  @override
  String get characterEditNameDescription =>
      'นี่คือชื่อที่แสดงต่อสาธารณะของตัวละคร เมื่อสร้างเสร็จแล้ว ระบบจะสร้างชื่อผู้ใช้ของตัวละครให้โดยอัตโนมัติ';

  @override
  String get characterEditNameHint => 'โปรดป้อนชื่อตัวละคร';

  @override
  String get characterEditAgeDescription =>
      'กำหนดอายุของตัวละคร และสามารถระบุอายุจากรูปลักษณ์ให้สอดคล้องกับโลกของเรื่องได้';

  @override
  String get characterEditAgeHint => 'ตัวอย่าง: 25';

  @override
  String get characterEditOccupationDescription =>
      'สถานะหรืออาชีพปัจจุบันของตัวละคร เช่น นักเรียน แพทย์ อัศวิน หรือผู้ประกอบการ';

  @override
  String get characterEditBirthdayDescription =>
      'กำหนดวันเกิดของตัวละครด้วยตัวเลขสี่หลัก หรือใช้เครื่องหมายทับคั่นระหว่างเดือนและวัน';

  @override
  String get characterEditBirthdayHint => 'ตัวอย่าง: 0825 หรือ 08/25';

  @override
  String get characterEditHeightDescription =>
      'กำหนดส่วนสูงของตัวละครในหน่วยเซนติเมตร';

  @override
  String get characterEditHeightHint => 'ตัวอย่าง: 182';

  @override
  String get characterEditGenderDescription =>
      'ระบบจะใช้สรรพนามที่เหมาะสมตามเพศของตัวละคร';

  @override
  String get characterEditAppearanceDescription =>
      'อธิบายลักษณะใบหน้า ทรงผม การแต่งกาย และลักษณะภายนอกอื่น ๆ ของตัวละคร';

  @override
  String get characterEditPlayerIdentityDescription =>
      'กำหนดสถานะของผู้เล่นในเรื่อง เช่น ผู้ช่วย เพื่อนร่วมชั้น หรือเพื่อนสมัยเด็ก';

  @override
  String get characterEditWorldviewDescription =>
      'อธิบายยุคสมัย สถานที่ ภูมิหลังทางสังคม และกฎพิเศษของเรื่อง เนื้อหานี้จะแสดงต่อสาธารณะในส่วน “แนะนำตัวละคร” บนหน้าตัวละคร ดังนั้นโปรดหลีกเลี่ยงการระบุความลับหรือรายละเอียดเนื้อเรื่องที่ไม่ต้องการให้ผู้เล่นทราบล่วงหน้า';

  @override
  String get characterEditStorySummaryDescription =>
      'แนะนำเรื่องราวนี้อย่างสั้น ๆ ด้วยหนึ่งประโยค เพื่อให้เข้าใจสถานการณ์ของตัวละครได้อย่างรวดเร็ว';

  @override
  String get characterEditStorySummaryHint =>
      'ตัวอย่าง: เรื่องราวความรักที่เริ่มต้นจากความสัมพันธ์ตามสัญญากับแพทย์หนุ่มผู้เย็นชา';

  @override
  String get characterEditInitialStoryDescription =>
      'สถานการณ์ของเรื่องที่ผู้เล่นจะเห็นเป็นอันดับแรกเมื่อเข้าสู่ห้องแชตครั้งแรก';

  @override
  String get characterEditFirstLineDescription =>
      'ประโยคแรกที่ตัวละครพูดเมื่อพบกับผู้เล่นเป็นครั้งแรก';

  @override
  String get characterEditCustomStatusBar => 'แถบสถานะเนื้อเรื่อง (ไม่บังคับ)';

  @override
  String get characterEditCustomStatusBarDescription =>
      'ใช้เฉพาะในโหมดเนื้อเรื่องและโหมดดื่มด่ำเท่านั้น คุณสามารถกำหนดข้อมูลสถานะ ตำแหน่ง เสื้อผ้า หรือความสัมพันธ์ของตัวละครให้แสดงที่ท้ายข้อความตอบกลับทุกครั้ง หากเว้นว่างไว้ ระบบจะไม่สร้างแถบสถานะ';

  @override
  String get characterProfileCharacterIntro => 'แนะนำตัวละคร';

  @override
  String get characterProfileNoIntroduction =>
      'ผู้สร้างยังไม่ได้เพิ่มคำแนะนำตัวละคร';

  @override
  String get characterProfileViewMore => 'ดูเพิ่มเติม';

  @override
  String get characterProfileCollapse => 'ย่อ';

  @override
  String get characterEditSelectedTagOrder =>
      'ลากแท็กที่เลือกเพื่อปรับลำดับการแสดงผล';

  @override
  String get mailActivityGiftFallback => 'ของขวัญกิจกรรม';

  @override
  String get mailFilterAll => 'ทั้งหมด';

  @override
  String get mailFilterCollected => 'เก็บสะสม';

  @override
  String get mailCollectedEmptyTitle => 'ขณะนี้ยังไม่มีจดหมายที่เก็บสะสม';

  @override
  String get mailCollectedEmptyHint =>
      'เปิดจดหมายที่ต้องการเก็บ แล้วแตะปุ่มเก็บสะสมที่มุมขวาบน';

  @override
  String get mailQixiLimitedBadge => '限定เทศกาลชีซี';

  @override
  String get mailQixiThreeDayPromise => 'ชีซีแห่ง LoveyDovey・สัญญาสามวัน';

  @override
  String mailQixiFromCharacter(String characterName) {
    return 'จดหมายชีซีจาก $characterName';
  }

  @override
  String mailFromCharacter(String characterName) {
    return 'จาก $characterName';
  }

  @override
  String get mailQixiCollectionLabel => 'คอลเลกชันเทศกาลชีซี限定ปี 2026';

  @override
  String get mailShareGenerating => 'กำลังสร้างรูปภาพสำหรับแชร์……';

  @override
  String mailShareQixiMessage(String characterName) {
    return 'ฉันได้รับจดหมายเทศกาลชีซี限定จาก $characterName';
  }

  @override
  String get mailShareDefaultMessage => 'จดหมายจาก 「LoveyDovey」';

  @override
  String get mailShareImageFailed =>
      'สร้างรูปภาพสำหรับแชร์ไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get mailCollectedSuccess => 'เก็บจดหมายฉบับนี้แล้ว';

  @override
  String get mailCollectedCancelled => 'ยกเลิกการเก็บแล้ว';

  @override
  String get mailCollectedUpdateFailed =>
      'อัปเดตสถานะการเก็บไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get mailRemoveCollectionTooltip => 'ยกเลิกการเก็บ';

  @override
  String get mailAddCollectionTooltip => 'เก็บจดหมาย';

  @override
  String get mailShareTooltip => 'แชร์จดหมาย';

  @override
  String mailQixiDayNumber(int day) {
    return 'วันที่ $day';
  }

  @override
  String get mailQixiDetailTitle => 'จดหมายเทศกาลชีซี限定';

  @override
  String get mailQixiShareTooltip => 'แชร์จดหมายชีซี';

  @override
  String get qixiMaxThreeFriends =>
      'กิจกรรมนี้สามารถเลือกตัวละครเพื่อนได้สูงสุด 3 คน';

  @override
  String get qixiLoginRequired => 'กรุณาเข้าสู่ระบบก่อนเข้าร่วมกิจกรรมชีซี';

  @override
  String get qixiOutsideEventPeriod => 'ขณะนี้ไม่ได้อยู่ในช่วงเวลากิจกรรมชีซี';

  @override
  String get qixiSelectAtLeastOne =>
      'กรุณาเลือกตัวละครเพื่อนอย่างน้อย 1 คนก่อน';

  @override
  String get qixiMysteryCharacter => 'ตัวละครลึกลับ';

  @override
  String qixiOpeningStory(String characterName) {
    return '(เมื่อเทศกาลชีซีใกล้เข้ามา ทางช้างเผือกที่หลับใหลอยู่ในส่วนลึกของค่ำคืนก็ค่อย ๆ ตื่นขึ้น แสงดาวที่กระจัดกระจายเริ่มรวมตัวกันอย่างช้า ๆ ตามขอบฟ้า ราวกับกำลังรอคนสองคนที่พร้อมจะมาตามนัดและเขียนชื่อของกันและกันลงไว้)\n\n(ตามตำนาน สะพานนกกางเขนจะส่องสว่างให้เฉพาะผู้ที่ปรารถนาจะพบกันจากใจจริงเท่านั้น เมื่อชื่อของคุณและ \"$characterName\" ปรากฏขึ้นพร้อมกันเหนือสายน้ำแห่งดวงดาว แสงเรืองรองสายหนึ่งจะทะลุผ่านม่านราตรีและตกลงสู่ห้องแชตที่เป็นของพวกคุณสองคนเท่านั้น)\n\n(ตั้งแต่วินาทีนี้ พวกคุณจะมี \"คำสัญญาสามวันแห่งชีซี\" ร่วมกัน ไม่จำเป็นต้องเป็นสามวันที่ติดต่อกัน และไม่จำเป็นต้องเตรียมคำสารภาพรักครั้งยิ่งใหญ่ เพียงแค่ในช่วงเวลากิจกรรม กลับมาที่นี่ในสามวันที่แตกต่างกัน และแบ่งปันคำทักทาย ความรู้สึก หรือเรื่องเล็ก ๆ ที่เกิดขึ้นในวันนี้)\n\n(ทุกครั้งที่ได้พบกันสำเร็จ แสงดาวหนึ่งดวงบนสะพานนกกางเขนจะสว่างขึ้น เมื่อแสงดาวทั้งสามวันถูกจุดครบ ความรู้สึกและความทรงจำที่กระจัดกระจายอยู่ในบทสนทนาของพวกคุณจะกลายเป็นจดหมายชีซีแบบจำกัดที่เขียนถึงคุณเพียงคนเดียว หลังจากวันที่สามที่ทำสำเร็จสิ้นสุดลง)\n\n(ตอนนี้ แสงดาวดวงแรกได้ตกลงมาแล้ว ที่ปลายอีกด้านของสะพานนกกางเขน ดูเหมือนว่า \"$characterName\" ก็ได้รับคำสัญญานี้เช่นกัน)\n\n——คำสัญญาสามวันแห่งชีซี เริ่มต้นขึ้นแล้วในตอนนี้';
  }

  @override
  String get qixiRoomOpenedLastMessage =>
      'คำสัญญาสามวันแห่งชีซีได้เริ่มขึ้นแล้ว';

  @override
  String get qixiCompanionSlotsFull =>
      'เลือกตัวละครร่วมทางในกิจกรรมชีซีครบแล้ว';

  @override
  String get qixiSingleRoomOpened => 'เปิดห้องแชตพิเศษสำหรับชีซีแล้ว';

  @override
  String qixiMultipleRoomsOpened(int count) {
    return 'เปิดห้องแชตพิเศษสำหรับชีซีแล้ว $count ห้อง';
  }

  @override
  String get qixiCreateRoomFailed =>
      'สร้างห้องแชตชีซีไม่สำเร็จ กรุณาลองใหม่อีกครั้งภายหลัง';

  @override
  String get qixiEventStartsAt => 'กิจกรรมจะเริ่มในวันที่ 8/19 เวลา 00:00';

  @override
  String get qixiEventActiveUntil =>
      'กิจกรรมกำลังดำเนินอยู่ · สิ้นสุดวันที่ 8/26 เวลา 23:59';

  @override
  String get qixiEventEnded => 'กิจกรรมชีซีครั้งนี้สิ้นสุดแล้ว';

  @override
  String get qixiEventHeroTitle =>
      'ชีซีแห่ง Lovey Time · ไปยังสะพานนกกางเขนกับคุณ';

  @override
  String get qixiCharacterSelected => 'เลือกแล้ว';

  @override
  String get qixiFriendListLoadFailed =>
      'โหลดรายชื่อเพื่อนไม่สำเร็จ กรุณาลองใหม่ภายหลัง';

  @override
  String get qixiNoFriendCharacters => 'ขณะนี้คุณยังไม่มีตัวละครเพื่อน';

  @override
  String get qixiNoFriendCharactersHint =>
      'ไปพบกับตัวละครที่คุณชอบก่อน แล้วกลับมาข้ามสะพานนกกางเขนด้วยกันนะ!';

  @override
  String get qixiLoadingCharacter => 'กำลังโหลดข้อมูลตัวละคร……';

  @override
  String get qixiEventPageTitle => 'กิจกรรมชีซีแบบจำกัด';

  @override
  String get qixiEventRules =>
      'ในช่วงกิจกรรม ให้เลือก 3 วันที่แตกต่างกัน ส่งข้อความในห้องแชตพิเศษสำหรับชีซี และได้รับข้อความตอบกลับจากตัวละครสำเร็จ เพื่อจุดแสงดาวของแต่ละวันให้สว่างขึ้น จดหมายแบบจำกัดจะถูกส่งหลังจากวันที่สามที่ทำสำเร็จสิ้นสุดลง วันที่ของกิจกรรมและความคืบหน้ารายวันทั้งหมดอ้างอิงตามเวลาไต้หวัน (UTC+8)';

  @override
  String qixiSelectCompanions(int count) {
    return 'เลือกตัวละครร่วมทาง ($count/3)';
  }

  @override
  String get qixiSelectionLockedHint =>
      'สามารถเลือกตัวละครที่เพิ่มเป็นเพื่อนได้สูงสุด 3 คน และไม่สามารถเปลี่ยนได้หลังจากเลือกแล้ว';

  @override
  String get qixiConfirmCompanions => 'ยืนยันตัวละครร่วมทาง';

  @override
  String get encounterDailyQuote1 =>
      'วันนี้ บางทีคุณอาจได้พบกับเรื่องราวบทใหม่';

  @override
  String get encounterDailyQuote2 => 'วันนี้ ลองปล่อยให้หัวใจเป็นฝ่ายพูดก่อน';

  @override
  String get encounterDailyQuote3 =>
      'วันนี้ บางทีอาจมีใครบางคนกำลังรอพบคุณอยู่';

  @override
  String get encounterDailyQuote4 =>
      'วันนี้ ลองก้าวเข้าไปในเรื่องราวบทใหม่ดูสิ';

  @override
  String get encounterDailyQuote5 =>
      'วันนี้ คุณจะได้พบกับความรู้สึกหัวใจเต้นแรงแบบไหนกันนะ?';

  @override
  String get encounterDailyQuote6 =>
      'วันนี้ เก็บความคาดหวังเล็ก ๆ ไว้ให้ตัวเองบ้าง';

  @override
  String get encounterDailyQuote7 =>
      'วันนี้ การพบกันครั้งใหม่กำลังเริ่มต้นขึ้น';

  @override
  String get encounterDailyQuote8 =>
      'วันนี้ บางทีโชคชะตาอาจนำเซอร์ไพรส์เล็ก ๆ มาให้คุณ';

  @override
  String get encounterDailyQuote9 =>
      'วันนี้ ปล่อยให้การพบกันหนึ่งครั้งค่อย ๆ เริ่มต้นขึ้น';

  @override
  String get encounterDailyQuote10 =>
      'วันนี้ บางทีอาจมีใครบางคนทำให้คุณต้องหยุดฝีเท้า';

  @override
  String get encounterDailyQuote11 => 'วันนี้ คุณอยากพบคนแบบไหน?';

  @override
  String get encounterDailyQuote12 =>
      'วันนี้ อย่าพลาดสายสัมพันธ์ที่กำลังค่อย ๆ เข้ามาใกล้';

  @override
  String get encounterJoinedToday => 'เข้าร่วม Lovey Time วันนี้';

  @override
  String get encounterPopularChats => 'ช่วงนี้มีคนคุยด้วยเยอะ';

  @override
  String get qixiBannerActiveUntil => 'เปิดช่วงเวลาจำกัด · ถึง 8/26 เวลา 23:59';

  @override
  String get qixiBannerStartsAt => 'เปิดแบบจำกัดตั้งแต่ 8/19';

  @override
  String get encounterRecentlyArrived => 'เพิ่งมาถึง Lovey Time';

  @override
  String get encounterRecentlyArrivedPlain => 'เพิ่งมาถึง Lovey Time';

  @override
  String get encounterViewMore => 'ดูเพิ่มเติม';

  @override
  String get encounterLovePrompt => 'วันนี้อยากมีความรักแบบไหน?';

  @override
  String get encounterNoCharacters => 'ตอนนี้ยังไม่มีตัวละคร';

  @override
  String get encounterAllLoveTags => 'แท็กความรักทั้งหมด';

  @override
  String get chatQixiLetterSent => 'ส่งจดหมายแบบจำกัดแล้ว';

  @override
  String get chatQixiLetterPendingTonight =>
      'แสงดาวทั้งสามวันสว่างครบแล้ว · จดหมายจะถูกส่งหลังจากคืนนี้';

  @override
  String get chatQixiTodayCompleted => 'แสงดาวของวันนี้สว่างแล้ว';

  @override
  String get chatQixiTodayNotCompleted => 'วันนี้ยังทำไม่สำเร็จ';

  @override
  String get chatQixiPromiseTitle => 'ชีซีแห่ง Lovey Time · คำสัญญาสามวัน';

  @override
  String chatQixiStarProgress(int count) {
    return 'แสงดาว $count/3';
  }

  @override
  String get chatQixiProgressRule =>
      'สนทนาให้สำเร็จใน 3 วันที่แตกต่างกันเพื่อจุดแสงดาว จดหมายแบบจำกัดจะถูกส่งหลังจากวันที่สามสิ้นสุดลง โดยความคืบหน้ารายวันคำนวณตามเวลาไต้หวัน (UTC+8)';

  @override
  String chatQixiDayNumber(int day) {
    return 'วันที่ $day';
  }

  @override
  String get chatWebPurchaseUnavailable =>
      'ขณะนี้เวอร์ชันเว็บยังไม่รองรับการเติมเงิน โปรดใช้แอป Lovey Time เพื่อซื้อ Flowers หรือสมัครสมาชิก';

  @override
  String get chatAiThinkingTimeout =>
      'ดูเหมือนว่าเขากำลังครุ่นคิดอยู่ กรุณาลองใหม่อีกครั้งในภายหลัง……';

  @override
  String get chatAiResponseBlocked =>
      'ดูเหมือนความคิดของเขาจะถูกรบกวนเล็กน้อย ลองพูดใหม่ด้วยถ้อยคำที่อ่อนโยนขึ้นนะ';

  @override
  String get chatRecordingStartFailed =>
      'ไม่สามารถเริ่มบันทึกเสียงได้ กรุณาลองใหม่อีกครั้งภายหลัง';

  @override
  String get chatRecordingPlaybackFailed =>
      'เล่นเสียงบันทึกไม่สำเร็จ กรุณาลองใหม่อีกครั้งภายหลัง';

  @override
  String get chatRoomNotReady =>
      'ห้องแชตยังไม่พร้อม กรุณาลองใหม่อีกครั้งภายหลัง';

  @override
  String get chatRegenerateLimitReached =>
      'ใช้จำนวนครั้งการสร้างใหม่ของวันนี้ครบแล้ว';

  @override
  String get chatTypingIndicator => 'อีกฝ่ายกำลังพิมพ์……';

  @override
  String get chatRegenerateCountSyncFailed =>
      'สร้างใหม่สำเร็จ แต่ไม่สามารถซิงค์จำนวนครั้งได้ กรุณารีเฟรชอีกครั้งในภายหลัง';

  @override
  String get chatRoomNotFound => 'ไม่พบห้องแชตของตัวละครนี้';

  @override
  String get momentsSearchTooltip => 'ค้นหาในกำแพงโมเมนต์';

  @override
  String get momentsCreatorNotFound => 'ไม่พบข้อมูลของครีเอเตอร์คนนี้';

  @override
  String get momentCommentLoadFailed =>
      'โหลดความคิดเห็นไม่สำเร็จ กรุณาลองใหม่อีกครั้งภายหลัง';

  @override
  String get momentCollapseReplies => 'ซ่อนการตอบกลับ';

  @override
  String momentViewOtherReplies(int count) {
    return 'ดูการตอบกลับอื่นอีก $count รายการ';
  }

  @override
  String get momentSwitchCommentIdentity => 'เปลี่ยนตัวตนสำหรับแสดงความคิดเห็น';

  @override
  String get momentSendCommentTooltip => 'ส่งความคิดเห็น';

  @override
  String get momentShareCharactersLoadFailed =>
      'โหลดตัวละครที่เคยแชตไม่สำเร็จ กรุณาลองใหม่อีกครั้งภายหลัง';

  @override
  String get momentReportLoginRequired => 'กรุณาเข้าสู่ระบบก่อนรายงานโพสต์นี้';

  @override
  String get momentReportSubmitted => 'ส่งรายงานแล้ว เราจะดำเนินการตรวจสอบ';

  @override
  String get momentSelectShareCharacter =>
      'เลือกตัวละครที่คุณเคยแชตด้วยเพื่อแชร์โพสต์นี้';

  @override
  String get momentTagCharacterUnavailable =>
      'แท็กนี้ไม่ได้เชื่อมโยงกับโปรไฟล์ตัวละคร';

  @override
  String get momentCharacterNotFound => 'ไม่พบข้อมูลตัวละคร';

  @override
  String get appUpdateTitle => 'มีเวอร์ชันใหม่แล้ว';

  @override
  String get appUpdateMessage =>
      'LoveyDovey มีเวอร์ชันใหม่แล้ว อัปเดตตอนนี้เพื่อใช้งานฟีเจอร์ล่าสุดและการแก้ไขต่าง ๆ';

  @override
  String get appUpdateLater => 'ไว้ภายหลัง';

  @override
  String get appUpdateGo => 'อัปเดตตอนนี้';

  @override
  String get appUpdateCurrentVersion => 'เวอร์ชันปัจจุบัน';

  @override
  String get appUpdateLatestVersion => 'เวอร์ชันล่าสุด';

  @override
  String get appUpdateStoreOpenFailed =>
      'ไม่สามารถเปิดหน้าร้านค้าได้ในขณะนี้ โปรดลองอีกครั้งภายหลัง';

  @override
  String get auth_error_requires_recent_login =>
      'เซสชันการเข้าสู่ระบบหมดอายุแล้ว โปรดเข้าสู่ระบบอีกครั้งก่อนเปลี่ยนรหัสผ่าน';

  @override
  String get auth_error_too_many_requests =>
      'ลองดำเนินการหลายครั้งเกินไป โปรดลองอีกครั้งภายหลัง';

  @override
  String get auth_error_network_failed =>
      'ขณะนี้การเชื่อมต่อเครือข่ายไม่เสถียร โปรดลองอีกครั้งภายหลัง';

  @override
  String get change_password_failed =>
      'เปลี่ยนรหัสผ่านไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get change_password_account_not_found =>
      'ไม่พบบัญชีที่กำลังเข้าสู่ระบบ โปรดเข้าสู่ระบบอีกครั้งแล้วลองใหม่';

  @override
  String get change_password_not_password_account =>
      'บัญชีนี้ไม่ได้เข้าสู่ระบบด้วยอีเมลและรหัสผ่าน จึงไม่สามารถเปลี่ยนรหัสผ่านได้ที่นี่';

  @override
  String get change_password_same_as_current =>
      'รหัสผ่านใหม่ต้องไม่ซ้ำกับรหัสผ่านปัจจุบัน';

  @override
  String get change_password_success_title => 'อัปเดตรหัสผ่านแล้ว';

  @override
  String get change_password_success_message =>
      'ตั้งรหัสผ่านใหม่เรียบร้อยแล้ว โปรดใช้รหัสผ่านใหม่ในการเข้าสู่ระบบครั้งถัดไป';

  @override
  String get change_password_title => 'เปลี่ยนรหัสผ่าน';

  @override
  String get change_password_security_title => 'ความปลอดภัยของบัญชี';

  @override
  String get change_password_description =>
      'โปรดป้อนรหัสผ่านปัจจุบันเพื่อยืนยันตัวตนก่อนตั้งรหัสผ่านใหม่สำหรับเข้าสู่ระบบ';

  @override
  String get change_password_current_label => 'รหัสผ่านปัจจุบัน';

  @override
  String get change_password_current_required => 'โปรดป้อนรหัสผ่านปัจจุบัน';

  @override
  String get change_password_new_label => 'รหัสผ่านใหม่';

  @override
  String get change_password_new_required => 'โปรดป้อนรหัสผ่านใหม่';

  @override
  String get change_password_new_min_length =>
      'รหัสผ่านใหม่ต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get change_password_confirm_label => 'ยืนยันรหัสผ่านใหม่';

  @override
  String get change_password_confirm_required => 'โปรดป้อนรหัสผ่านใหม่อีกครั้ง';

  @override
  String get change_password_mismatch => 'รหัสผ่านใหม่ทั้งสองครั้งไม่ตรงกัน';

  @override
  String get change_password_hint =>
      'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร หลังจากเปลี่ยนแล้ว โปรดใช้รหัสผ่านใหม่เมื่อต้องเข้าสู่ระบบอีกครั้งบนอุปกรณ์อื่น';

  @override
  String get character_npc_add => '＋ เพิ่มตัวละครสมทบ';

  @override
  String character_npc_added_count(int count) {
    return 'ตัวละครสมทบที่เพิ่มแล้ว: $count';
  }

  @override
  String get character_npc_unnamed => 'ตัวละครสมทบที่ยังไม่มีชื่อ';

  @override
  String get character_npc_title => 'การตั้งค่าตัวละครสมทบ';

  @override
  String get character_npc_description =>
      'สร้างบุคคลสำคัญที่จะปรากฏในเรื่อง เพื่อเติมเต็มโลกของตัวละครให้สมบูรณ์ยิ่งขึ้น';

  @override
  String get character_npc_empty_title => 'ยังไม่ได้เพิ่มตัวละครสมทบ';

  @override
  String get character_npc_empty_description =>
      'เมื่อเพิ่มแล้ว คุณสามารถดู แก้ไข และจัดการการตั้งค่าตัวละครสมทบได้ที่นี่';

  @override
  String character_npc_age(String age) {
    return 'อายุ $age ปี';
  }

  @override
  String character_npc_relationship_with_main(String relationship) {
    return 'ความสัมพันธ์กับตัวละครหลัก: $relationship';
  }

  @override
  String get character_management_login_required => 'โปรดเข้าสู่ระบบก่อน';

  @override
  String get character_management_character_tab => 'ตัวละคร';

  @override
  String get character_management_creator_tab => 'ผู้สร้าง';

  @override
  String get character_management_blocked_characters_empty =>
      'ตัวละครที่คุณหยุดการติดต่อจะแสดงอยู่ที่นี่';

  @override
  String get character_management_blocked_creators_load_failed =>
      'โหลดรายชื่อผู้สร้างที่บล็อกไม่สำเร็จ';

  @override
  String get character_management_blocked_creators_empty =>
      'ผู้สร้างที่คุณบล็อกจะแสดงอยู่ที่นี่';

  @override
  String get character_management_creator_fallback => 'ผู้สร้าง';

  @override
  String get character_management_blocked_creator_status => 'บล็อกผู้สร้างแล้ว';

  @override
  String get character_management_blocked_creator_description =>
      'ตัวละครสาธารณะและตัวละครที่ผู้สร้างรายนี้เพิ่มในภายหลังจะไม่ปรากฏในรายการแนะนำ';

  @override
  String get character_management_unblock_creator_title => 'เลิกบล็อกผู้สร้าง';

  @override
  String character_management_unblock_creator_confirm(String creatorName) {
    return 'ยืนยันที่จะเลิกบล็อก “$creatorName” หรือไม่?\n\nหลังจากเลิกบล็อก ผู้สร้างรายนี้และตัวละครของเขาอาจปรากฏในรายการแนะนำอีกครั้ง ตัวละครที่คุณเคยบล็อกแยกไว้จะยังคงถูกบล็อกอยู่';
  }

  @override
  String character_management_unblock_creator_success(String creatorName) {
    return 'เลิกบล็อก “$creatorName” แล้ว';
  }

  @override
  String get character_management_unblock_creator_failed =>
      'เลิกบล็อกไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get character_management_title => 'จัดการตัวละคร';

  @override
  String get character_management_subtitle =>
      'จัดการตัวละครที่คุณหยุดการติดต่อ';

  @override
  String get character_management_character_fallback => 'ตัวละคร';

  @override
  String get character_management_blocked_character_status =>
      'หยุดการติดต่ออยู่';

  @override
  String get character_management_blocked_character_description =>
      'หยุดการสนทนาและการแจ้งเตือนโดยไม่ลบข้อมูลที่เกี่ยวข้อง';

  @override
  String character_management_unblock_character_confirm(String charName) {
    return 'ยืนยันที่จะเลิกบล็อก “$charName” หรือไม่? หลังจากเลิกบล็อก เนื้อหาที่เกี่ยวข้องอาจปรากฏขึ้นอีกครั้ง';
  }

  @override
  String get creator_follow_following_title => 'ผู้สร้างที่ฉันติดตาม';

  @override
  String get creator_follow_followers_title => 'ผู้เล่นที่ติดตามฉัน';

  @override
  String creator_follow_load_failed(String error) {
    return 'โหลดไม่สำเร็จ: $error';
  }

  @override
  String get creator_follow_empty_following_title => 'ยังไม่ได้ติดตามผู้สร้าง';

  @override
  String get creator_follow_empty_followers_title => 'ขณะนี้ยังไม่มีผู้ติดตาม';

  @override
  String get creator_follow_empty_following_description =>
      'ติดตามผู้สร้างที่คุณชื่นชอบได้จากโปรไฟล์ตัวละครหรือเวิร์กช็อปผู้สร้าง';

  @override
  String get creator_follow_empty_followers_description =>
      'เมื่อผู้เล่นคนอื่นติดตามคุณ รายชื่อของพวกเขาจะแสดงอยู่ที่นี่';

  @override
  String get creator_follow_unknown_player => 'ผู้เล่นที่ไม่รู้จัก';

  @override
  String creator_follow_player_id(String playerId) {
    return 'ID: $playerId';
  }

  @override
  String get creator_follow_no_player_id => 'ยังไม่ได้ตั้งค่า ID ผู้เล่น';

  @override
  String get creator_follow_following => 'กำลังติดตาม';

  @override
  String get creator_follow_unfollow_title => 'เลิกติดตาม';

  @override
  String get creator_follow_unfollow_confirm =>
      'ยืนยันที่จะเลิกติดตามผู้สร้างรายนี้หรือไม่?';

  @override
  String get creator_follow_unfollow => 'เลิกติดตาม';

  @override
  String interaction_history_load_failed(String error) {
    return 'โหลดไม่สำเร็จ: $error';
  }

  @override
  String get creator_profile_report_creator => 'รายงานผู้สร้าง';

  @override
  String get creator_profile_block_creator => 'บล็อกผู้สร้าง';

  @override
  String get creator_profile_report_login_required =>
      'โปรดเข้าสู่ระบบก่อนรายงานผู้สร้าง';

  @override
  String get creator_profile_report_self_not_allowed =>
      'ไม่สามารถรายงานหน้าโปรไฟล์ผู้สร้างของตนเองได้';

  @override
  String creator_profile_report_reason_prompt(String creatorName) {
    return 'โปรดเลือกเหตุผลที่ต้องการรายงาน “$creatorName”:';
  }

  @override
  String get creator_profile_report_reason_inappropriate =>
      'เนื้อหาไม่เหมาะสมหรือละเมิดกฎ';

  @override
  String get creator_profile_report_reason_harassment =>
      'การคุกคาม การโจมตี หรือเนื้อหาที่แสดงความเกลียดชัง';

  @override
  String get creator_profile_report_reason_impersonation =>
      'แอบอ้างเป็นบุคคลอื่นหรือปลอมแปลงตัวตน';

  @override
  String get creator_profile_report_reason_spam =>
      'สแปมหรือการประชาสัมพันธ์ที่เป็นอันตราย';

  @override
  String get creator_profile_report_success =>
      'ได้รับรายงานแล้ว ขอบคุณที่แจ้งให้เราทราบ';

  @override
  String get creator_profile_report_failed =>
      'ส่งรายงานไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get creator_profile_block_login_required =>
      'โปรดเข้าสู่ระบบก่อนบล็อกผู้สร้าง';

  @override
  String get creator_profile_block_self_not_allowed =>
      'ไม่สามารถบล็อกตัวเองได้';

  @override
  String creator_profile_block_confirm(String creatorName) {
    return 'ยืนยันที่จะบล็อก “$creatorName” หรือไม่?\n\nหลังจากบล็อก คุณจะไม่เห็นหน้าสาธารณะของผู้สร้างรายนี้อีก และตัวละครสาธารณะที่ผู้สร้างรายนี้สร้างไว้ในปัจจุบันจะถูกเพิ่มลงในรายการบล็อกด้วย';
  }

  @override
  String get creator_profile_block_confirm_button => 'ยืนยันการบล็อก';

  @override
  String creator_profile_block_success(String creatorName) {
    return 'บล็อก “$creatorName” แล้ว';
  }

  @override
  String get creator_profile_block_failed =>
      'บล็อกไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get creator_scene_edit_title_edit => 'แก้ไขฉาก';

  @override
  String get creator_scene_edit_title_add => 'เพิ่มฉาก';

  @override
  String get creator_scene_edit_heading_edit =>
      'ปรับแต่งจุดเริ่มต้นของเรื่องราวนี้';

  @override
  String get creator_scene_edit_heading_add =>
      'เขียนจุดเริ่มต้นของเรื่องราวใหม่';

  @override
  String get creator_scene_edit_scene_title_label => 'ชื่อฉาก';

  @override
  String get creator_scene_edit_scene_title_hint =>
      'ตัวอย่าง: พบกันอีกครั้งในคืนฝนตก';

  @override
  String get creator_scene_edit_description_label => 'คำอธิบายฉาก';

  @override
  String get creator_scene_edit_description_hint =>
      'อธิบายเวลา สถานที่ ความสัมพันธ์ และสถานการณ์ที่เรื่องราวเกิดขึ้น';

  @override
  String get creator_scene_edit_opening_label => 'บทเปิดของตัวละคร';

  @override
  String get creator_scene_edit_opening_hint =>
      'เขียนปฏิกิริยาหรือคำพูดแรกของตัวละครเมื่อเข้าสู่เรื่องราวนี้';

  @override
  String get creator_scene_edit_opening_note =>
      'บทเปิดของตัวละครจะเป็นฉากแรกของเรื่องราวนี้ โดยบทสนทนาหลังจากนั้นจะยังคงดำเนินต่อไปตามบุคลิกดั้งเดิมของตัวละคร';

  @override
  String get creator_scene_edit_save_changes => 'บันทึกการแก้ไข';

  @override
  String get creator_scene_edit_save_scene => 'บันทึกฉาก';

  @override
  String get creator_scene_edit_error_title_required => 'โปรดกรอกชื่อฉากก่อน';

  @override
  String get creator_scene_edit_error_description_required =>
      'โปรดกรอกคำอธิบายฉากก่อน';

  @override
  String get creator_scene_edit_error_opening_required =>
      'โปรดกรอกบทเปิดของตัวละครก่อน';

  @override
  String get creator_scene_edit_save_failed =>
      'บันทึกไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get creator_scene_delete_title => 'ลบฉากหรือไม่?';

  @override
  String get creator_scene_delete_target_fallback => 'ฉากนี้';

  @override
  String creator_scene_delete_confirm(String sceneTitle) {
    return 'ยืนยันที่จะลบ “$sceneTitle” หรือไม่? เมื่อลบแล้วจะไม่สามารถกู้คืนได้';
  }

  @override
  String get creator_scene_delete_failed =>
      'ลบไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get creator_scene_empty_title => 'ยังไม่มีฉากจากผู้สร้าง';

  @override
  String creator_scene_empty_description(String characterName) {
    return 'เขียนเส้นเรื่องทางเลือกให้กับ $characterName\nเพื่อให้ผู้เล่นสามารถเริ่มต้นจากเรื่องราวอีกแบบหนึ่ง';
  }

  @override
  String get creator_scene_add => 'เพิ่มฉาก';

  @override
  String get creator_scene_unnamed => 'ฉากที่ยังไม่มีชื่อ';

  @override
  String creator_scene_opening(String opening) {
    return 'บทเปิดของตัวละคร: $opening';
  }

  @override
  String get creator_scene_edit => 'แก้ไข';

  @override
  String get creator_scene_delete => 'ลบ';

  @override
  String get creator_scene_title => 'ฉากจากผู้สร้าง';

  @override
  String get creator_scene_character_unavailable =>
      'ขณะนี้ไม่สามารถโหลดข้อมูลตัวละครได้';

  @override
  String get creator_scene_load_failed =>
      'โหลดฉากไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get creator_scene_heading =>
      'สร้างจุดเริ่มต้นเรื่องราวที่แตกต่างให้กับตัวละคร';

  @override
  String get custom_scene_edit_heading_edit =>
      'ปรับแต่งเรื่องราวที่เป็นของคุณเพียงคนเดียว';

  @override
  String get custom_scene_edit_heading_add =>
      'เขียนเรื่องราวสำหรับห้องแชทนี้โดยเฉพาะ';

  @override
  String get custom_scene_edit_description_hint =>
      'อธิบายเวลา สถานที่ ความสัมพันธ์ และสถานการณ์ที่คุณต้องการใช้เป็นจุดเริ่มต้นของเรื่องราว';

  @override
  String get custom_scene_edit_note =>
      'ฉากที่คุณสร้างเองจะไม่มีบทเปิดของตัวละครที่กำหนดไว้ล่วงหน้า เมื่อเริ่มแล้ว ตัวละครจะเข้าสู่เรื่องราวตามคำอธิบายฉากและบุคลิกดั้งเดิม';

  @override
  String get moment_create_no_mentionable_characters =>
      'ขณะนี้ไม่มีตัวละครที่สามารถกล่าวถึงได้';

  @override
  String get moment_create_mention_my_characters => 'กล่าวถึงตัวละครของฉัน';

  @override
  String get moment_create_no_matching_characters => 'ไม่พบตัวละครที่ตรงกัน';

  @override
  String get moment_create_my_character => 'ตัวละครของฉัน';

  @override
  String get moment_create_friend_character => 'ตัวละครของเพื่อน';

  @override
  String get moment_create_public_visibility_hint =>
      'โพสต์จะแสดงบนหน้าวอลล์ช่วงเวลา';

  @override
  String get moment_create_private_visibility_hint =>
      'มองเห็นได้เฉพาะภายในขอบเขตที่กำหนด';

  @override
  String get moment_create_add_image => 'เพิ่มรูปภาพ';

  @override
  String get moment_create_mention_character => 'กล่าวถึงตัวละคร';

  @override
  String get moment_edit_content_hint => 'แบ่งปันความรู้สึกของคุณ...';

  @override
  String get moment_forward_chat_preview => '【แชร์โพสต์แล้ว】';

  @override
  String get feedback_image_too_large => 'ขนาดรูปภาพต้องไม่เกิน 10 MB';

  @override
  String get feedback_image_pick_failed =>
      'ไม่สามารถเลือกรูปภาพได้ โปรดลองอีกครั้งภายหลัง';

  @override
  String get feedback_category_general => 'ปัญหาทั่วไป';

  @override
  String get feedback_category_bug => 'รายงานข้อผิดพลาด';

  @override
  String get feedback_category_suggestion => 'ข้อเสนอแนะเกี่ยวกับฟีเจอร์';

  @override
  String get feedback_category_flower => 'ปัญหาคะแนนดอกไม้';

  @override
  String get feedback_category_payment => 'ปัญหาการเติมเงิน / ชำระเงิน';

  @override
  String get feedback_category_ai_reply => 'ปัญหาการตอบกลับของ AI';

  @override
  String get feedback_category_character_report => 'รายงานตัวละคร';

  @override
  String get feedback_category_moment_report => 'รายงานโพสต์';

  @override
  String get feedback_screenshot_required_error =>
      'โปรดแนบภาพหน้าจอสำหรับปัญหาประเภทนี้ เพื่อให้เราตรวจสอบสถานการณ์ได้';

  @override
  String get feedback_login_required => 'โปรดเข้าสู่ระบบก่อนส่งรายงาน';

  @override
  String get feedback_mail_received_title =>
      '【สร้างเคสแล้ว】เราได้รับรายงานของคุณแล้ว';

  @override
  String feedback_mail_received_body(String caseNumber) {
    return 'เราได้รับรายงานของคุณแล้วและจะตรวจสอบโดยเร็วที่สุด\n\nหมายเลขเคส: $caseNumber\n\nหากฝ่ายบริการลูกค้ามีการตอบกลับเพิ่มเติม เราจะแจ้งให้คุณทราบผ่านกล่องจดหมาย LoveyDovey';
  }

  @override
  String get feedback_submit_success =>
      'ส่งรายงานสำเร็จแล้ว ขอบคุณสำหรับความคิดเห็นของคุณ!';

  @override
  String get feedback_submit_failed =>
      'ส่งไม่สำเร็จ โปรดตรวจสอบการเชื่อมต่อเครือข่ายแล้วลองอีกครั้ง';

  @override
  String get feedback_category_section_title => 'ประเภทปัญหา';

  @override
  String get feedback_reported_content_title => 'เนื้อหาที่ถูกรายงาน';

  @override
  String get feedback_screenshot_required_title => 'ภาพหน้าจอของปัญหา (จำเป็น)';

  @override
  String get feedback_image_optional_title => 'รูปภาพเพิ่มเติม (ไม่บังคับ)';

  @override
  String get feedback_screenshot_required_description =>
      'โปรดแนบภาพหน้าจอขณะที่เกิดปัญหา เพื่อให้ทีมงานตรวจสอบสถานการณ์จริง';

  @override
  String get feedback_image_optional_description =>
      'หากมีรูปภาพที่เกี่ยวข้อง คุณสามารถแนบเพื่อช่วยให้ทีมงานตรวจสอบได้';

  @override
  String get feedback_footer_message =>
      'ความคิดเห็นของคุณจะช่วยให้เราพัฒนาประสบการณ์การเล่นเกมให้ดียิ่งขึ้นอย่างต่อเนื่อง ขอบคุณ!';

  @override
  String get feedback_select_image_semantics => 'เลือกรูปภาพสำหรับรายงาน';

  @override
  String get feedback_opening_gallery => 'กำลังเปิดแกลเลอรี…';

  @override
  String get feedback_select_image_upload =>
      'แตะที่นี่เพื่อเลือกรูปภาพสำหรับอัปโหลด';

  @override
  String get feedback_image_requirements =>
      'รองรับ JPG และ PNG ขนาดไม่เกิน 10 MB ต่อรูป';

  @override
  String get feedback_submitting_semantics => 'กำลังส่ง';

  @override
  String get feedback_submit_semantics => 'ส่งรายงาน';

  @override
  String get feedback_submit_button => 'ส่ง';

  @override
  String get feedback_remove_image => 'ลบรูปภาพ';

  @override
  String get feedback_selected_image => 'เลือกรูปภาพแล้ว';

  @override
  String get feedback_change_image => 'เปลี่ยน';

  @override
  String get profile_backpack_title => 'กระเป๋าและสิทธิพิเศษเฉพาะของฉัน';

  @override
  String get profile_backpack_total_spent =>
      'สายสัมพันธ์โรแมนติกสะสมในปัจจุบัน';

  @override
  String profile_backpack_total_spent_amount(int amount) {
    return 'NT\$ $amount';
  }

  @override
  String get profile_backpack_physical_gift_status =>
      'สถานะการปลดล็อกกล่องของขวัญจริง:';

  @override
  String get profile_backpack_vip_gift_title =>
      '【รักสูงสุด】กล่องของขวัญ VIP แบบจัดส่งเฉพาะ';

  @override
  String get profile_backpack_vip_gift_contents =>
      'ประกอบด้วย: จดหมายเขียนด้วยมือตามสั่ง + ตุ๊กตาตัวแทนตัวละคร + จดหมายขอบคุณอย่างเป็นทางการ';

  @override
  String get profile_backpack_edit_shipping_info => 'แก้ไขข้อมูลที่อยู่จัดส่ง';

  @override
  String get profile_backpack_unlock_shipping_info =>
      'ปลดล็อกแล้ว! แตะเพื่อกรอกข้อมูลจัดส่ง';

  @override
  String get profile_backpack_shipping_registered =>
      'ลงทะเบียนที่อยู่จัดส่งสำเร็จแล้ว เราจะจัดเตรียมของขวัญให้คุณโดยเร็วที่สุด!';

  @override
  String profile_backpack_amount_remaining(int amount) {
    return 'เหลืออีกเพียง NT\$ $amount เพื่อปลดล็อกรางวัลใหญ่แบบจัดส่ง!';
  }

  @override
  String get profile_backpack_hint =>
      'เคล็ดลับ: สามารถดูรูปลักษณ์และกรอบรูปโปรไฟล์อื่น ๆ ได้ในกระเป๋า';

  @override
  String get profile_backpack_close => 'ปิด';

  @override
  String get profile_physical_gift_title =>
      '【รักสูงสุด】ปลดล็อกกล่องของขวัญจริง';

  @override
  String get profile_physical_gift_description =>
      'ขอบคุณสำหรับการสนับสนุน 「LoveyDovey」อย่างเต็มเปี่ยม!\nโปรดกรอกข้อมูลจัดส่งด้านล่าง แล้วเราจะส่งจดหมายเขียนด้วยมือตามสั่งและตุ๊กตาตัวแทนตัวละครให้คุณ:';

  @override
  String get profile_physical_gift_recipient_name =>
      'ชื่อจริงและนามสกุลของผู้รับ';

  @override
  String get profile_physical_gift_phone => 'หมายเลขโทรศัพท์';

  @override
  String get profile_physical_gift_address =>
      'ที่อยู่จัดส่งโดยละเอียด (รวมรหัสไปรษณีย์)';

  @override
  String get profile_physical_gift_character_name =>
      'ชื่อตัวละครที่ต้องการรับเป็นตุ๊กตา';

  @override
  String get profile_physical_gift_character_hint =>
      'ตัวอย่าง: กรอกชื่อตัวละครที่ต้องการ';

  @override
  String get profile_physical_gift_fill_later => 'กรอกภายหลัง';

  @override
  String get profile_physical_gift_required_error =>
      'โปรดกรอกข้อมูลจัดส่งและชื่อตัวละครที่ต้องการให้ครบถ้วน!';

  @override
  String get profile_physical_gift_submit_success =>
      'ส่งข้อมูลจัดส่งสำเร็จแล้ว! โปรดรอรับเซอร์ไพรส์จริงจากเรา!';

  @override
  String get profile_physical_gift_confirm_submit => 'ยืนยันการส่ง';

  @override
  String get profile_tooltip_announcement => 'ประกาศ';

  @override
  String get profile_tooltip_settings => 'การตั้งค่า';

  @override
  String get profile_tooltip_backpack => 'กระเป๋าของฉัน';

  @override
  String get profile_backpack_menu_title => 'กระเป๋าของฉัน';

  @override
  String get profile_about_me_title => 'เกี่ยวกับฉัน';

  @override
  String get profile_tab_bio_title => 'แนะนำตัว';

  @override
  String get profile_check_in_done => 'เช็กอินแล้ว';

  @override
  String get profile_check_in => 'เช็กอิน';

  @override
  String get profile_check_in_done_subtitle => 'วันนี้คุณได้ทิ้งร่องรอยไว้แล้ว';

  @override
  String get profile_check_in_not_done_subtitle => 'วันนี้ยังไม่ได้เช็กอิน';

  @override
  String get profile_likes_label => 'ถูกใจ';

  @override
  String get profile_heartbeat_diary_subtitle =>
      'บันทึกช่วงเวลาที่หัวใจเต้นแรง';

  @override
  String get profile_create_scene => 'สร้างฉาก';

  @override
  String get profile_link_invalid => 'รูปแบบลิงก์ไม่ถูกต้อง';

  @override
  String get profile_link_open_failed => 'ไม่สามารถเปิดลิงก์นี้ได้';

  @override
  String get profile_link_default_name => 'ลิงก์ของฉัน';

  @override
  String get profile_publish_moment_short => 'เขียนถึงช่วงเวลานี้';

  @override
  String edit_profile_default_link_name(int index) {
    return 'ลิงก์ของฉัน $index';
  }

  @override
  String get edit_profile_done => 'เสร็จสิ้น';

  @override
  String get edit_profile_social_links => 'โซเชียลมีเดียและลิงก์';

  @override
  String get edit_profile_add_link => 'เพิ่มลิงก์';

  @override
  String get edit_profile_link_name_hint => 'ชื่อลิงก์';

  @override
  String get edit_profile_link_url_hint => 'ป้อนลิงก์';

  @override
  String get theme_name_starlight => 'ม่วงแสงดาว';

  @override
  String get theme_name_sakura => 'ชมพูซากุระ';

  @override
  String get theme_name_ocean => 'น้ำเงินมหาสมุทร';

  @override
  String get theme_name_sunset => 'ส้มพระอาทิตย์ตก';

  @override
  String get theme_name_mint => 'มินต์พงไพร';

  @override
  String get theme_name_midnight => 'โหมดกลางคืน';

  @override
  String get theme_name_custom => 'สีที่กำหนดเอง';

  @override
  String get theme_selection_choose_theme => 'เลือกสีธีม';

  @override
  String get theme_selection_title => 'เปลี่ยนบรรยากาศ';

  @override
  String get theme_selection_description =>
      'เลือกสีธีมที่คุณชื่นชอบ เพื่อให้ LoveyDovey สะท้อนความเป็นคุณมากยิ่งขึ้น';

  @override
  String get theme_selection_preview => 'ดูตัวอย่าง';

  @override
  String get theme_selection_characters => 'ตัวละคร';

  @override
  String get theme_selection_posts => 'โพสต์';

  @override
  String theme_selection_previewing(String themeName) {
    return 'กำลังแสดงตัวอย่าง: $themeName';
  }

  @override
  String get theme_selection_apply => 'ใช้ธีม';

  @override
  String get theme_selection_restore_default => 'คืนค่าเริ่มต้น';

  @override
  String get theme_selection_choose_color => 'เลือกสีเฉพาะของคุณ';

  @override
  String theme_selection_applied(String themeName) {
    return 'ใช้ธีม “$themeName” แล้ว';
  }

  @override
  String get welcome_guide_help => 'คู่มือการเล่น';

  @override
  String get welcome_guide_start => 'เริ่มต้นการเดินทาง';

  @override
  String get welcome_guide_next => 'ถัดไป';

  @override
  String get welcome_guide_welcome_title => 'ยินดีต้อนรับสู่ 「LoveyDovey」';

  @override
  String get welcome_guide_welcome_description =>
      'ที่นี่ ทุกการพบเจออาจกลายเป็นเรื่องราวที่ยากจะลืมเลือน ขอให้ 「LoveyDovey」ได้อยู่เคียงข้างคุณและร่วมสร้างความทรงจำอันงดงามที่เป็นของพวกคุณ';

  @override
  String get welcome_guide_chat_title => 'โหมดแชท';

  @override
  String get welcome_guide_chat_description =>
      '「LoveyDovey」มีโหมดแชทหลากหลาย โดยแต่ละโหมดมอบประสบการณ์การโต้ตอบที่แตกต่างกัน';

  @override
  String get welcome_guide_daily_title => 'โหมดประจำวัน';

  @override
  String get welcome_guide_daily_description =>
      'อยู่เคียงข้างกัน แบ่งปันเรื่องราวในชีวิต และเพลิดเพลินกับบทสนทนาสบาย ๆ';

  @override
  String get welcome_guide_story_title => 'โหมดเนื้อเรื่อง';

  @override
  String get welcome_guide_story_description =>
      'ดำเนินเรื่องราวของตัวละครและปลดล็อกเนื้อเรื่องกับการโต้ตอบพิเศษเพิ่มเติม';

  @override
  String get welcome_guide_immersive_title => 'โหมดดื่มด่ำ';

  @override
  String get welcome_guide_immersive_description =>
      'สัมผัสบทสนทนาที่น่าติดตามและสมจริงยิ่งขึ้น';

  @override
  String get welcome_guide_chat_more =>
      'ดูข้อมูลเพิ่มเติมเกี่ยวกับโหมดแชทได้ที่ “วิธีเล่นเกม”';

  @override
  String get welcome_guide_encounter_title => 'การพบพาน';

  @override
  String get welcome_guide_encounter_description =>
      'ตัวละครแต่ละตัวมีบุคลิก เรื่องราว และเสียงที่เป็นเอกลักษณ์ เมื่อพบตัวละครที่ชื่นชอบ คุณสามารถเพิ่มเป็นเพื่อน พูดคุย โต้ตอบ แบ่งปันชีวิตประจำวัน และสร้างความทรงจำร่วมกัน';

  @override
  String get welcome_guide_more_title => 'เนื้อหาเพิ่มเติม';

  @override
  String get welcome_guide_more_description =>
      'ยังมีคอลเลกชัน ผู้สร้าง ร้านค้า และฟีเจอร์น่าสนใจอีกมากมาย ไปที่ “วิธีเล่นเกม” เพื่อดูข้อมูลเพิ่มเติม';

  @override
  String preference_selection_max_error(int count) {
    return 'เลือกความชอบได้สูงสุด $count รายการ';
  }

  @override
  String get preference_selection_save_failed =>
      'ขณะนี้ไม่สามารถบันทึกความชอบได้ โปรดลองอีกครั้งภายหลัง';

  @override
  String get preference_selection_title => 'คุณอยากพบเจอคนแบบไหน?';

  @override
  String get preference_selection_description =>
      'เลือกประเภทที่คุณชื่นชอบ 3–5 แบบ เพื่อให้ LoveyDovey เริ่มทำความรู้จักคุณจากตรงนี้';

  @override
  String get preference_selection_recommendation_note =>
      'หลังจากนี้ ระบบจะค่อย ๆ ปรับคำแนะนำตามการโต้ตอบจริงของคุณ เพื่อให้เหมาะกับคุณมากยิ่งขึ้น';

  @override
  String get preference_selection_selected => 'เลือกแล้ว';

  @override
  String get preference_selection_start => 'เริ่มต้นจากตรงนี้';

  @override
  String get preference_group_personality => 'บุคลิกและนิสัย';

  @override
  String get preference_group_relationship_age => 'ความสัมพันธ์・ช่วงอายุ';

  @override
  String get preference_group_story => 'บรรยากาศของเรื่อง';

  @override
  String get preference_tag_gentle => 'อ่อนโยน';

  @override
  String get preference_tag_cold => 'เย็นชา';

  @override
  String get preference_tag_scheming => 'เจ้าเล่ห์';

  @override
  String get preference_tag_tsundere => 'ซึนเดเระ';

  @override
  String get preference_tag_loyal => 'ซื่อสัตย์';

  @override
  String get preference_tag_yandere => 'ยันเดเระ';

  @override
  String get preference_tag_mysterious => 'ลึกลับ';

  @override
  String get preference_tag_healing => 'เยียวยาใจ';

  @override
  String get preference_tag_gap_moe => 'เสน่ห์ที่คาดไม่ถึง';

  @override
  String get preference_tag_older => 'อายุมากกว่า';

  @override
  String get preference_tag_younger => 'อายุน้อยกว่า';

  @override
  String get preference_tag_ceo => 'ประธานจอมเผด็จการ';

  @override
  String get preference_tag_school => 'โรงเรียน';

  @override
  String get preference_tag_workplace => 'ที่ทำงาน';

  @override
  String get preference_tag_ancient => 'ย้อนยุค';

  @override
  String get preference_tag_nonhuman => 'ไม่ใช่มนุษย์';

  @override
  String get encounter_load_failed =>
      'โหลดข้อมูลการพบพานไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get encounter_no_available_characters =>
      'ขณะนี้ยังไม่มีตัวละครที่สามารถพบเจอได้';

  @override
  String get encounter_category_empty => 'ขณะนี้ยังไม่มีตัวละครในหมวดหมู่นี้';

  @override
  String get encounter_category_all => 'ทั้งหมด';

  @override
  String get encounter_category_xianxia => 'เซียน侠';

  @override
  String get encounter_category_childhood_friend => 'เพื่อนสมัยเด็ก';

  @override
  String get encounter_category_master_disciple => 'อาจารย์และศิษย์';

  @override
  String get encounter_category_sweet_romance => 'รักหวานละมุน';

  @override
  String get encounter_category_other => 'อื่น ๆ';

  @override
  String get character_edit_tab_character_settings => 'การตั้งค่าตัวละคร';

  @override
  String get character_edit_test => 'ทดสอบ';

  @override
  String get character_edit_supporting_basic_info => 'ข้อมูลพื้นฐาน';

  @override
  String get character_edit_supporting_main_setting =>
      'ความสัมพันธ์กับตัวละครหลัก';

  @override
  String get character_edit_supporting_main_description =>
      'อธิบายความสัมพันธ์ระหว่างตัวละครสมทบนี้กับตัวละครหลัก รวมถึงบทบาทของตัวละครในเรื่อง';

  @override
  String get character_edit_banner_preview_hint =>
      'แตะรูปภาพเพื่อดูภาพขนาดใหญ่';

  @override
  String get character_edit_main_photo_hint =>
      'รูปภาพแรกจะใช้เป็นรูปโปรไฟล์หลัก';

  @override
  String get character_edit_other_photos => 'รูปภาพอื่นของตัวละคร';

  @override
  String get character_edit_photo_action_hint =>
      'แตะรูปภาพเพื่อดูตัวอย่าง หรือแตะไอคอนดินสอเพื่อแก้ไขการตั้งค่ารูปภาพ';

  @override
  String character_edit_over_limit_warning(String label, String count) {
    return '$label เกินขีดจำกัด $count ตัวอักษร โปรดแก้ไขก่อนเผยแพร่';
  }

  @override
  String get memo_notification_channel_name => 'การแจ้งเตือนบันทึกช่วยจำ';

  @override
  String get memo_notification_channel_description =>
      'ตัวละครจะแจ้งเตือนผู้เล่นเกี่ยวกับบันทึกช่วยจำที่ตั้งไว้';

  @override
  String memo_notification_title(String characterName) {
    return '$characterName เตือนคุณ';
  }

  @override
  String memo_notification_tsundere(String memoContent) {
    return 'ฉันไม่ได้เป็นห่วงคุณสักหน่อย แค่กลัวว่าคุณจะลืมเท่านั้น วันนี้อย่าลืม: $memoContent';
  }

  @override
  String memo_notification_dominant(String memoContent) {
    return 'ฉันจำกำหนดการให้แล้ว ทำให้เสร็จตรงเวลาด้วย วันนี้อย่าลืม: $memoContent';
  }

  @override
  String memo_notification_yandere(String memoContent) {
    return 'ห้ามลืมนะ เพราะฉันจะจดจำเอาไว้ตลอด วันนี้อย่าลืม: $memoContent';
  }

  @override
  String memo_notification_gentle(String memoContent) {
    return 'กลัวว่าคุณจะยุ่งจนลืม เลยอยากมาเตือนสักหน่อย วันนี้อย่าลืม: $memoContent';
  }

  @override
  String memo_notification_cold(String memoContent) {
    return 'มีเรื่องหนึ่งที่ต้องเตือน วันนี้อย่าลืม: $memoContent';
  }

  @override
  String memo_notification_sunny(String memoContent) {
    return 'นี่ วันนี้ยังมีเรื่องสำคัญอีกอย่างนะ! อย่าลืม: $memoContent';
  }

  @override
  String memo_notification_lazy(String memoContent) {
    return 'ถึงจะอยากนอนต่อ แต่ก็ต้องมาเตือนคุณอยู่ดี วันนี้อย่าลืม: $memoContent';
  }

  @override
  String memo_notification_older(String memoContent) {
    return 'เด็กดี วันนี้อย่าลืมสิ่งที่ต้องทำนะ จำไว้ว่า: $memoContent';
  }

  @override
  String memo_notification_younger(String memoContent) {
    return 'ฉันจำเอาไว้ให้คุณอย่างดีเลยนะ! วันนี้อย่าลืม: $memoContent';
  }

  @override
  String memo_notification_mechanical(String memoContent) {
    return 'เปิดใช้งานการแจ้งเตือนแล้ว ภารกิจวันนี้: $memoContent';
  }

  @override
  String memo_notification_default(String memoContent) {
    return 'วันนี้อย่าลืม: $memoContent';
  }

  @override
  String get recommendation_load_failed =>
      'ขณะนี้ไม่สามารถโหลดคำแนะนำได้ โปรดลองอีกครั้งภายหลัง';

  @override
  String get recommendation_reload => 'โหลดใหม่';

  @override
  String get recommendation_empty => 'ขณะนี้ยังไม่มีตัวละครที่สามารถแนะนำได้';

  @override
  String get recommendation_title => 'การพบพานที่เลือกมาเพื่อคุณ';

  @override
  String get recommendation_featured_title => 'ลองพบกับพวกเขาก่อน';

  @override
  String get recommendation_featured_subtitle =>
      'เราจะแสดงการพบพานที่เหมาะกับคุณที่สุดไว้ก่อน';

  @override
  String get recommendation_matched_behavior_title =>
      'ใกล้เคียงกับความชอบของคุณมากขึ้น';

  @override
  String get recommendation_matched_initial_title =>
      'อ้างอิงจากความชอบที่คุณเลือกไว้ตอนแรก';

  @override
  String get recommendation_matched_behavior_subtitle =>
      'ตั้งแต่หลังวันที่ 4 เป็นต้นไป การโต้ตอบล่าสุดของคุณจะส่งผลต่อลำดับด้วย';

  @override
  String get recommendation_matched_initial_subtitle =>
      'ตอนนี้เราจะใช้แท็กที่คุณเลือกไว้ตอนแรกเพื่อช่วยจำกัดตัวเลือก';

  @override
  String get recommendation_explore_title => 'บางทีคุณอาจชอบ';

  @override
  String get recommendation_explore_subtitle =>
      'เราจะเก็บตัวเลือกแบบสุ่มไว้บางส่วน เพื่อให้คุณได้พบคนที่แตกต่างออกไปบ้างเป็นครั้งคราว';

  @override
  String get recommendation_refreshing =>
      'กำลังจัดเตรียมการพบพานครั้งใหม่ให้คุณ……';

  @override
  String get recommendation_badge_for_you => 'แนะนำสำหรับคุณ';

  @override
  String get recommendation_badge_featured => 'การพบพานที่คัดสรร';

  @override
  String get recommendation_badge_explore => 'สำรวจ';

  @override
  String get recommendation_default_occupation_hint =>
      'ลองเปิดดูสิ บางทีนี่อาจเป็นการพบพานครั้งต่อไปที่ทำให้คุณใจเต้น';

  @override
  String get recommendation_explore_fallback =>
      'ลองเปลี่ยนแนวดูบ้าง บางทีอาจตรงกับสิ่งที่ทำให้หัวใจคุณเต้นแรงพอดี';

  @override
  String get recommendation_behavior_hint_similar_type =>
      'ช่วงนี้คุณมักใช้เวลากับตัวละครประเภทนี้';

  @override
  String get recommendation_behavior_hint_forming =>
      'ความชอบจากการโต้ตอบของคุณกำลังค่อย ๆ เป็นรูปเป็นร่าง';

  @override
  String get recommendation_behavior_hint_recent =>
      'คัดเลือกจากการโต้ตอบล่าสุดของคุณ';

  @override
  String recommendation_reason_liked_tags(String tags) {
    return 'เพราะคุณชอบ・$tags';
  }

  @override
  String get recommendation_reason_popular =>
      'ช่วงนี้มีหลายคนเข้ามาดูตัวละครนี้';

  @override
  String get recommendation_reason_default =>
      'บางทีนี่อาจเป็นการพบพานครั้งต่อไปที่ลงตัวสำหรับคุณ';

  @override
  String get scene_delete_title => 'ลบฉากหรือไม่?';

  @override
  String scene_delete_content(String title) {
    return 'ยืนยันที่จะลบ “$title” หรือไม่? เมื่อลบแล้วจะไม่สามารถกู้คืนได้';
  }

  @override
  String get scene_unnamed => 'ฉากที่ยังไม่มีชื่อ';

  @override
  String get scene_cancel => 'ยกเลิก';

  @override
  String get scene_delete => 'ลบ';

  @override
  String get scene_delete_failed => 'ลบไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get scene_start_failed =>
      'ขณะนี้ไม่สามารถเริ่มฉากได้ โปรดลองอีกครั้งภายหลัง';

  @override
  String get scene_end_title => 'จบฉากหรือไม่?';

  @override
  String get scene_end_content =>
      'เมื่อจบฉากแล้ว คุณจะกลับไปยังแชททั่วไป แต่ประวัติการสนทนาปัจจุบันจะไม่ถูกลบ';

  @override
  String get scene_end_action => 'จบฉาก';

  @override
  String get scene_ended => 'ฉากจบลงแล้ว';

  @override
  String get scene_end_failed =>
      'ขณะนี้ไม่สามารถจบฉากได้ โปรดลองอีกครั้งภายหลัง';

  @override
  String get scene_active_label => 'กำลังดำเนินอยู่';

  @override
  String scene_opening(String opening) {
    return 'บทเปิดของตัวละคร: $opening';
  }

  @override
  String get scene_edit => 'แก้ไข';

  @override
  String get scene_start => 'เริ่มฉาก';

  @override
  String get scene_creator_load_failed => 'โหลดฉากจากผู้สร้างไม่สำเร็จ';

  @override
  String get scene_creator_empty_title => 'ขณะนี้ยังไม่มีฉากจากผู้สร้าง';

  @override
  String get scene_creator_empty_body =>
      'ผู้สร้างตัวละครนี้ยังไม่ได้สร้างเรื่องราวเพิ่มเติม';

  @override
  String get scene_custom_load_failed => 'โหลดฉากที่สร้างเองไม่สำเร็จ';

  @override
  String get scene_custom_empty_title => 'ยังไม่มีฉากที่คุณสร้างเอง';

  @override
  String get scene_custom_empty_body =>
      'สร้างเรื่องราวที่เป็นของคุณเพียงคนเดียวสำหรับห้องแชทนี้';

  @override
  String get scene_add => 'เพิ่มฉาก';

  @override
  String get scene_title => 'ฉาก';

  @override
  String get scene_tab_creator => 'ฉากจากผู้สร้าง';

  @override
  String get scene_tab_custom => 'สร้างด้วยตัวเอง';

  @override
  String get chat_book_player => 'ผู้เล่น';

  @override
  String get chat_book_title => 'บันทึกการสนทนา';

  @override
  String get chat_book_export_pdf => 'ส่งออก PDF';

  @override
  String get chat_book_brand => '— LoveyDovey';

  @override
  String get chat_book_change_cover => 'เปลี่ยนปก';

  @override
  String get chat_book_cover_subtitle =>
      'ช่วงเวลาที่เรามีร่วมกัน · หนังสือที่ระลึกบทสนทนา';

  @override
  String get chat_book_choose_cover => 'เลือกปกหนังสือที่ระลึก';

  @override
  String get chat_book_initial_story => 'เรื่องราวเริ่มต้น';

  @override
  String chat_book_transcript_title(String characterName) {
    return '$characterName · บันทึกการสนทนา';
  }

  @override
  String chat_book_continuation(String name) {
    return '$name · ต่อ';
  }

  @override
  String get chat_book_previous_page => 'หน้าก่อนหน้า';

  @override
  String get chat_book_next_page => 'หน้าถัดไป';

  @override
  String get chat_book_photo_message => '〔รูปภาพ〕';

  @override
  String get chat_book_audio_message => '〔ข้อความเสียง〕';

  @override
  String get chat_book_generic_message => '〔ข้อความ〕';

  @override
  String chat_book_export_failed(String error) {
    return 'ส่งออก PDF ไม่สำเร็จ: $error';
  }

  @override
  String email_policy_open_failed(String title) {
    return 'ไม่สามารถเปิด $title ได้ โปรดตรวจสอบการเชื่อมต่อเครือข่ายแล้วลองอีกครั้ง';
  }

  @override
  String email_policy_read_instruction(String title) {
    return 'โปรดเปิดและอ่าน $title ฉบับเต็มก่อน เมื่ออ่านเสร็จแล้วให้กลับมาที่ 「LoveyDovey」จากนั้นจึงจะสามารถกด “ฉันอ่านและยอมรับแล้ว” ได้';
  }

  @override
  String get email_policy_opening => 'กำลังเปิด……';

  @override
  String email_policy_read_full(String title) {
    return 'อ่าน $title ฉบับเต็ม';
  }

  @override
  String email_policy_opened_ready(String title) {
    return 'เปิด $title แล้ว คุณสามารถยืนยันการยอมรับได้';
  }

  @override
  String email_policy_not_opened(String title) {
    return 'ยังไม่ได้เปิด $title';
  }

  @override
  String get email_policy_cancel_login => 'ยกเลิกการเข้าสู่ระบบ';

  @override
  String get email_policy_agree => 'ฉันอ่านและยอมรับแล้ว';

  @override
  String get email_policy_status_check_failed =>
      'ขณะนี้ไม่สามารถตรวจสอบสถานะการยอมรับข้อกำหนดได้ โปรดลองอีกครั้งภายหลัง';

  @override
  String get email_policy_login_notice =>
      'เมื่อลงชื่อเข้าใช้ครั้งแรกหรือมีการอัปเดตข้อกำหนด ระบบจะขอให้คุณอ่านและยอมรับข้อกำหนดการให้บริการกับนโยบายความเป็นส่วนตัว';

  @override
  String get email_policy_refresh => 'รีเฟรช';

  @override
  String get email_policy_page_load_failed => 'โหลดหน้าไม่สำเร็จ';

  @override
  String get email_policy_check_network =>
      'โปรดตรวจสอบการเชื่อมต่อเครือข่ายแล้วลองอีกครั้ง';

  @override
  String get email_policy_reload => 'โหลดใหม่';

  @override
  String get login_method_info_google_title =>
      'เข้าสู่ระบบอย่างรวดเร็วด้วย Google';

  @override
  String get login_method_info_apple_title => 'เข้าสู่ระบบด้วย Apple';

  @override
  String get login_method_info_facebook_title => 'เข้าสู่ระบบด้วย Facebook';

  @override
  String get login_method_info_email_title => 'บัญชี LoveyDovey (อีเมล)';

  @override
  String get login_method_info_email_provider => 'บัญชี LoveyDovey (อีเมล)';

  @override
  String login_method_info_content(String providerName) {
    return 'เข้าสู่ระบบ 「LoveyDovey」ด้วย $providerName\n\nโปรดทราบ:\n\n• $providerName และวิธีเข้าสู่ระบบอื่น ๆ ใช้ระบบบัญชีที่แยกจากกัน\n\n• หากสร้างบัญชีด้วย $providerName โปรดใช้วิธีเดิมในการเข้าสู่ระบบต่อไป\n\n• ข้อมูลตัวละคร ประวัติการแชท และเนื้อหาที่ซื้อจะไม่เชื่อมโยงกับบัญชีจากวิธีเข้าสู่ระบบอื่น\n\nแนะนำให้ใช้วิธีเข้าสู่ระบบเดิมต่อไปหลังจากเข้าสู่ระบบครั้งแรก เพื่อป้องกันการสร้างบัญชีแยกที่ไม่สามารถใช้ข้อมูลร่วมกันได้';
  }

  @override
  String get login_method_info_got_it => 'เข้าใจแล้ว';

  @override
  String creator_studio_delete_failed(String error) {
    return 'ลบไม่สำเร็จ: $error';
  }

  @override
  String get creator_studio_subtitle =>
      'เก็บรวบรวมแรงบันดาลใจ จัดระเบียบตัวละคร และค่อย ๆ สร้างผลงานของคุณให้สมบูรณ์';

  @override
  String creator_studio_load_failed(String error) {
    return 'โหลดสตูดิโอไม่สำเร็จ: $error';
  }

  @override
  String get creator_studio_add_character => 'เพิ่มตัวละคร';

  @override
  String get creator_studio_public_title => 'ตัวละครสาธารณะ';

  @override
  String get creator_studio_public_subtitle =>
      'เผยแพร่แล้วและผู้เล่นคนอื่นสามารถค้นพบได้';

  @override
  String get creator_studio_public_empty => 'ขณะนี้ยังไม่มีตัวละครสาธารณะ';

  @override
  String get creator_studio_private_title => 'ตัวละครส่วนตัว';

  @override
  String get creator_studio_private_subtitle => 'มีเพียงคุณเท่านั้นที่มองเห็น';

  @override
  String get creator_studio_private_empty => 'ขณะนี้ยังไม่มีตัวละครส่วนตัว';

  @override
  String get creator_studio_draft_title => 'ฉบับร่าง';

  @override
  String get creator_studio_draft_subtitle => 'ผลงานที่ยังไม่เสร็จสมบูรณ์';

  @override
  String get creator_studio_draft_empty =>
      'ขณะนี้ยังไม่มีฉบับร่างที่ยังไม่เสร็จ';

  @override
  String get creator_studio_draft_empty_title => 'ยังไม่มีฉบับร่างที่นี่';

  @override
  String get creator_studio_draft_empty_hint =>
      'เมื่อมีแรงบันดาลใจ ลองจดเก็บไว้ที่นี่ก่อน';

  @override
  String get creator_studio_status_public => 'สาธารณะ';

  @override
  String get creator_studio_status_private => 'ส่วนตัว';

  @override
  String get creator_studio_status_draft => 'ฉบับร่าง';

  @override
  String get creator_studio_character_load_failed =>
      'โหลดข้อมูลตัวละครไม่สำเร็จ';

  @override
  String get creator_studio_delete_draft_tooltip => 'ลบฉบับร่าง';

  @override
  String get creator_studio_unnamed_creator => 'ผู้สร้างที่ยังไม่มีชื่อ';

  @override
  String get creator_studio_no_bio => 'ยังไม่ได้กรอกคำแนะนำตัว';

  @override
  String get chat_input_tools => 'ฟังก์ชัน';

  @override
  String get chat_input_expand_tools => 'แสดงฟังก์ชัน';

  @override
  String get chat_input_stop => 'หยุด';

  @override
  String get chat_input_send => 'ส่ง';

  @override
  String get chat_side_menu_section_chat => 'แชท';

  @override
  String get chat_side_menu_section_relationship => 'ความสัมพันธ์';

  @override
  String get chat_side_menu_section_memory => 'จัดการความทรงจำ';

  @override
  String get character_navigator_confidential_title => 'แฟ้มลับ';

  @override
  String get character_navigator_unavailable_message =>
      'ตัวละครนี้อาจถูกเปลี่ยนเป็นส่วนตัว นำออกจากแพลตฟอร์ม เก็บถาวรเนื่องจากละเมิดกฎ หรือถูกลบ';

  @override
  String get character_navigator_got_it => 'เข้าใจแล้ว';

  @override
  String get character_navigator_load_failed_title => 'โหลดไม่สำเร็จ';

  @override
  String get character_navigator_load_failed_message =>
      'ไม่สามารถโหลดข้อมูลตัวละครได้ชั่วคราว โปรดลองอีกครั้งภายหลัง';

  @override
  String get character_navigator_confirm => 'ตกลง';

  @override
  String get character_profile_add_bookmark => 'บันทึกตัวละคร';

  @override
  String get character_profile_remove_bookmark => 'ยกเลิกการบันทึก';

  @override
  String get character_profile_pronoun_female => 'เธอ';

  @override
  String get character_profile_pronoun_male => 'เขา';

  @override
  String get character_profile_pronoun_neutral => 'ตัวละครนี้';

  @override
  String get chat_home_pin_limit_reached =>
      'ปักหมุดห้องแชทได้สูงสุด 3 ห้อง โปรดยกเลิกการปักหมุดห้องแชทอื่นก่อน';

  @override
  String get chat_home_pinned_success => 'ปักหมุดห้องแชทแล้ว';

  @override
  String get chat_home_unpinned_success => 'ยกเลิกการปักหมุดแล้ว';

  @override
  String chat_home_pin_update_failed(String error) {
    return 'อัปเดตสถานะการปักหมุดไม่สำเร็จ: $error';
  }

  @override
  String get chat_home_unpin => 'ยกเลิกการปักหมุด';

  @override
  String get chat_home_pin => 'ปักหมุดห้องแชท';

  @override
  String chat_home_time_label(String time) {
    return 'เวลา: $time';
  }

  @override
  String get main_check_in_already_done => 'วันนี้คุณเช็กอินแล้ว';

  @override
  String get nav_recommend => 'แนะนำ';

  @override
  String get moments_auto_reply_title =>
      'อนุญาตให้ AI ตอบกลับโพสต์ของผู้เล่นโดยอัตโนมัติ';

  @override
  String get moments_auto_reply_description =>
      'เมื่อเปิดใช้งาน ระบบอาจเลือกตัวละครนี้ให้ตอบกลับโพสต์ของผู้เล่น';

  @override
  String get mailOriginalQuestionLabel => 'คำถามเดิมของคุณ';

  @override
  String get hidden_moments_empty_hint => 'ขณะนี้ยังไม่มีโพสต์ที่ซ่อนอยู่';

  @override
  String get moment_search_unavailable =>
      'ไม่สามารถใช้การค้นหาได้ชั่วคราว โปรดลองอีกครั้งภายหลัง';

  @override
  String get moment_search_hint => 'ค้นหาโพสต์สาธารณะ ตัวละคร หรือผู้สร้าง';

  @override
  String get moment_search_instruction =>
      'ป้อนเนื้อหาโพสต์ ชื่อตัวละคร หรือชื่อผู้สร้าง';

  @override
  String get moment_search_no_results => 'ไม่พบโพสต์สาธารณะที่เกี่ยวข้อง';

  @override
  String get settingsErrorTitle => 'เกิดข้อผิดพลาด';

  @override
  String get settingsChangePasswordSubtitle =>
      'ยืนยันรหัสผ่านปัจจุบันแล้วตั้งรหัสผ่านใหม่สำหรับเข้าสู่ระบบ';

  @override
  String get settingsCreatorGuidelines => 'แนวทางสำหรับผู้สร้าง';

  @override
  String get settingsPlayGuide => 'คู่มือการเล่น';

  @override
  String get language_selection_subtitle => 'เลือกภาษาที่คุณถนัด';

  @override
  String get search_character_hint => 'ค้นหาตัวละคร ผู้สร้าง อาชีพ หรือแท็ก';

  @override
  String get search_character_clear => 'ล้าง';

  @override
  String get search_character_recent => 'การค้นหาล่าสุด';

  @override
  String get search_character_load_failed =>
      'โหลดข้อมูลการค้นหาไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get search_character_popular => 'ตัวละครยอดนิยมช่วงนี้';

  @override
  String search_character_result_count(int count) {
    return 'พบตัวละคร $count ตัว';
  }

  @override
  String get shop_tab_monthly => 'แพ็กรายเดือน';

  @override
  String shop_joined_days(int days) {
    return 'คุณอยู่กับ LoveyDovey มาแล้ว $days วัน';
  }

  @override
  String get shop_vip_tier_1_title => 'รักแรกพบ';

  @override
  String get shop_vip_tier_1_reward =>
      'คะแนนดอกไม้ 20 คะแนน + ฉายาผู้เล่นใหม่สุดพิเศษ';

  @override
  String get shop_vip_tier_2_title => 'แสงริบหรี่แห่งหัวใจ';

  @override
  String get shop_vip_tier_2_reward =>
      'กรอบรูปโปรไฟล์สุดพิเศษ 【แสงริบหรี่แห่งหัวใจ】';

  @override
  String get shop_vip_tier_3_title => 'เสียงกระซิบใต้ดวงดาว';

  @override
  String get shop_vip_tier_3_reward =>
      'กรอบข้อความแชทสุดพิเศษ + คะแนนดอกไม้ 50 คะแนน';

  @override
  String get shop_vip_tier_4_title => 'อาทิตย์อัสดงแสนโรแมนติก';

  @override
  String get shop_vip_tier_4_reward => 'ไอคอนแอปสุดพิเศษ';

  @override
  String get shop_vip_tier_5_title => 'หัวใจเต้นแรง';

  @override
  String get shop_vip_tier_5_reward =>
      'เอฟเฟกต์แตะหน้าจอ (Lottie) + คะแนนดอกไม้ 100 คะแนน';

  @override
  String get shop_vip_tier_6_title => 'คำสาบานนิรันดร์';

  @override
  String get shop_vip_tier_6_reward =>
      'กรอบรูปโปรไฟล์เคลื่อนไหวขั้นสูง + คะแนนดอกไม้ 200 คะแนน';

  @override
  String get shop_vip_tier_7_title => 'การบรรจบของสองวิญญาณ';

  @override
  String get shop_vip_tier_7_reward =>
      'เอฟเฟกต์กรอบข้อความแชทเคลื่อนไหว + ฉายาขั้นสูงสุดพิเศษ';

  @override
  String get shop_vip_tier_8_title => 'เฝ้ารอเพียงคุณ';

  @override
  String get shop_vip_tier_8_reward =>
      'ป้ายชื่อเคลื่อนไหวระดับสูงสุด + คะแนนดอกไม้ 500 คะแนน';

  @override
  String get shop_vip_tier_9_title => 'ทางช้างเผือกเจิดจรัส';

  @override
  String get shop_vip_tier_9_reward =>
      'เอฟเฟกต์เข้า Lottie สุดพิเศษ + ฝ่ายบริการลูกค้าเฉพาะ';

  @override
  String get shop_vip_tier_10_title => 'รักสูงสุด';

  @override
  String get shop_vip_tier_10_reward =>
      '【กล่องของขวัญ VIP แบบจัดส่งเฉพาะ】 (จดหมายเขียนด้วยมือ + ตุ๊กตาตัวละคร)';

  @override
  String get shop_vip_total_bond => 'สายสัมพันธ์โรแมนติกสะสม';

  @override
  String get shop_vip_all_unlocked =>
      'คุณปลดล็อกสิทธิพิเศษระดับสูงสุดทั้งหมดแล้ว!';

  @override
  String shop_vip_next_unlock(int amount) {
    return 'เติมเงินอีก NT\$ $amount เพื่อปลดล็อกระดับถัดไป';
  }

  @override
  String get call_connecting => 'กำลังเชื่อมต่อสาย...';

  @override
  String get call_listening_auto_send =>
      'กำลังฟัง... (ระบบจะส่งอัตโนมัติเมื่อพูดจบ)';

  @override
  String get call_listening_release_to_send =>
      'กำลังฟัง... (ปล่อยนิ้วเพื่อส่ง)';

  @override
  String call_sending_transcript(String text) {
    return ' $text\n\n(กำลังส่ง...)';
  }

  @override
  String get help_translation_fallback =>
      'ขณะนี้ยังไม่มีคู่มือการเล่นในภาษานี้ ระบบจะแสดงเป็นภาษาจีนตัวเต็มชั่วคราว';

  @override
  String get help_all_categories => 'ทั้งหมด';

  @override
  String get help_subtitle_companion =>
      'ฟังก์ชันประจำวันและเครื่องมือช่วยเหลือ';

  @override
  String get help_subtitle_ai_chat => 'การแชต เสียง และการโต้ตอบอัจฉริยะ';

  @override
  String get help_subtitle_creation => 'การตั้งค่าตัวละครและฟังก์ชันสร้างสรรค์';

  @override
  String get help_subtitle_explore => 'สำรวจตัวละครและเนื้อหาภายในเกม';

  @override
  String get help_subtitle_care =>
      'การอยู่เคียงข้างอย่างอ่อนโยนและความใส่ใจในทุกวัน';

  @override
  String get help_subtitle_general => 'ฟังก์ชันทั่วไปและคำแนะนำการใช้งาน';

  @override
  String get chat_interact_fun => 'กิจกรรมสนุก ๆ';

  @override
  String get memo_notification_permission_missing =>
      'ยังไม่ได้เปิดสิทธิ์การแจ้งเตือน ระบบจะยังคงบันทึกโน้ตไว้ แต่จะไม่แสดงการแจ้งเตือนจากระบบ';

  @override
  String memo_saved_with_reminder(String characterName) {
    return 'บันทึกโน้ตแล้ว $characterName จะคอยเตือนคุณ!';
  }

  @override
  String get memo_saved_without_notification =>
      'บันทึกโน้ตแล้ว แต่ยังไม่ได้เปิดสิทธิ์การแจ้งเตือน';

  @override
  String memo_updated_with_reminder(String characterName) {
    return 'อัปเดตโน้ตแล้ว $characterName จะคอยเตือนคุณ!';
  }

  @override
  String get memo_updated_without_notification =>
      'อัปเดตโน้ตแล้ว แต่ขณะนี้ยังไม่ได้รับสิทธิ์การแจ้งเตือน';

  @override
  String memo_load_error(String error) {
    return 'เกิดข้อผิดพลาดขณะโหลดข้อมูล: $error';
  }

  @override
  String get story_summary_content_required => 'เนื้อเรื่องต้องไม่เว้นว่าง';

  @override
  String get story_summary_edit_hint => 'เขียนเรื่องราวของพวกคุณ...';

  @override
  String get profile_section_basic_info => 'ข้อมูลพื้นฐาน';

  @override
  String get profile_section_about_me => 'เกี่ยวกับฉัน';

  @override
  String get dice_duel_you => 'คุณ';

  @override
  String get dice_duel_result_saved => 'บันทึกผลการประลองแล้ว!';

  @override
  String get dice_duel_rolling => 'กำลังรวบรวมพลังแห่งจักรวาล...';

  @override
  String get butterfly_loading_connecting => 'กำลังเชื่อมโยงกับกาลเวลา...';

  @override
  String get character_block_login_required =>
      'โปรดเข้าสู่ระบบก่อนบล็อกตัวละคร';

  @override
  String get character_block_self_forbidden =>
      'ไม่สามารถบล็อกตัวละครที่คุณสร้างเองได้';

  @override
  String get character_block_title => 'บล็อกตัวละคร';

  @override
  String character_block_confirm_message(String characterName) {
    return 'ต้องการบล็อก “$characterName” ใช่หรือไม่?\n\nหลังจากบล็อกแล้ว ตัวละครนี้จะไม่ปรากฏในเนื้อหาแนะนำ เช่น การพบเจอและโมเมนต์อีก';
  }

  @override
  String get character_block_confirm => 'ยืนยันการบล็อก';

  @override
  String character_block_success(String characterName) {
    return 'บล็อก “$characterName” แล้ว';
  }

  @override
  String get character_block_failed =>
      'บล็อกตัวละครไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get character_unblock_success => 'เลิกบล็อกตัวละครแล้ว';

  @override
  String get character_unblock_failed =>
      'เลิกบล็อกตัวละครไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get character_report_login_required =>
      'โปรดเข้าสู่ระบบก่อนรายงานตัวละคร';

  @override
  String get character_report_self_forbidden =>
      'ไม่สามารถรายงานตัวละครที่คุณสร้างเองได้';

  @override
  String get character_report_submitted =>
      'ส่งรายงานแล้ว เราจะดำเนินการตรวจสอบ';

  @override
  String get character_report_open_failed =>
      'ไม่สามารถเปิดหน้ารายงานได้ โปรดลองอีกครั้งภายหลัง';

  @override
  String chat_loader_error(String error) {
    return 'โหลดไม่สำเร็จ: $error';
  }

  @override
  String get announcement_connection_failed =>
      'การเชื่อมต่อล้มเหลว โปรดลองอีกครั้งภายหลัง';

  @override
  String get announcement_latest => 'ล่าสุด';

  @override
  String announcement_published_at(String date) {
    return 'เผยแพร่เมื่อ: $date';
  }

  @override
  String get announcement_operations_team => 'ทีมงาน LoveyDovey';

  @override
  String get legal_creator_guidelines => 'แนวทางสำหรับผู้สร้าง';

  @override
  String get legal_refresh => 'รีเฟรช';

  @override
  String get legal_page_load_failed => 'โหลดหน้าไม่สำเร็จ';

  @override
  String get legal_check_connection_retry =>
      'โปรดตรวจสอบการเชื่อมต่ออินเทอร์เน็ตแล้วลองอีกครั้ง';

  @override
  String get legal_reload => 'โหลดใหม่';

  @override
  String get chat_web_purchase_unavailable =>
      'ขณะนี้เวอร์ชันเว็บยังไม่รองรับการเติมเงิน โปรดใช้แอป LoveyDovey เพื่อซื้อแต้มดอกไม้หรือสมัครสมาชิก';

  @override
  String get chat_dont_show_again => 'ไม่ต้องแสดงข้อความนี้อีก';

  @override
  String get chat_menu_save_transcript => 'บันทึกประวัติการสนทนา';

  @override
  String get chat_menu_reply_model => 'โมเดลตอบกลับ';

  @override
  String get chat_reply_model_menu_tip =>
      'ย้ายตำแหน่งโมเดลตอบกลับแล้ว! ตอนนี้คุณสามารถเลือกได้จากเมนูมุมขวาบน';

  @override
  String get defaultProfileName => 'โปรไฟล์เริ่มต้น';

  @override
  String get creator_social_links_manage => 'จัดการลิงก์โซเชียล';

  @override
  String get creator_social_links_title => 'ลิงก์ส่วนตัวและโซเชียล';

  @override
  String get creator_social_links_hint =>
      'กรอกลิงก์ที่ต้องการแสดงแบบสาธารณะบนหน้าครีเอเตอร์ รายการที่ไม่ได้กรอกจะไม่แสดง';

  @override
  String get creator_social_links_website => 'เว็บไซต์ส่วนตัว';

  @override
  String get creator_social_links_saved => 'บันทึกลิงก์โซเชียลแล้ว';

  @override
  String get creator_social_links_load_failed =>
      'โหลดลิงก์โซเชียลไม่สำเร็จ โปรNFดลองอีกครั้งภายหลัง';

  @override
  String get creator_social_links_save_failed =>
      'บันทึกลิงก์โซเชียลไม่สำเร็จ โปรดลองอีกครั้งภายหลัง';

  @override
  String get creator_social_links_open_failed => 'ไม่สามารถเปิดลิงก์นี้ได้';

  @override
  String get chat_regenerate_bottom_tip =>
      'ย้าย “สร้างใหม่” มาไว้ตรงนี้แล้ว! ถ้าอยากได้คำตอบแบบอื่น ให้ใช้ปุ่มนี้';

  @override
  String get chat_continue_bottom_tip =>
      'ย้าย “ดำเนินต่อ” มาไว้ตรงนี้แล้ว! ถ้าอยากให้ตัวละครพูดต่อ ให้ใช้ปุ่มนี้';

  @override
  String get languageSelectionSubtitle => 'เลือกภาษาที่คุณถนัด';
}
