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
}
