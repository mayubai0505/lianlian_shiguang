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
      'ตัวละครและฉากในเกมเป็นเพียงเรื่องสมมติ โปรดอย่าเชื่อมโยงกับความเป็นจริง! หากมีความคล้ายคลึงใด ๆ ถือเป็นเรื่องบังเอิญ';

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
  String confirm_block_msg(Object charName) {
    return 'หลังจากบล็อกแล้ว คุณจะไม่ได้รับข้อความจาก $charName ชั่วคราว';
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
}
