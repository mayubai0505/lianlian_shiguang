// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get changeTheme => 'تغيير لون السمة';

  @override
  String get feedback => 'ملاحظات واقتراحات';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get allFriendsTitle => 'جميع الأصدقاء';

  @override
  String get noFriendsMessage => 'ليس لديك أي أصدقاء بعد.';

  @override
  String get unknownCharacter => 'شخصية غير معروفة';

  @override
  String errorLoadingFriends(String error) {
    return 'حدث خطأ أثناء تحميل قائمة الأصدقاء: $error';
  }

  @override
  String get tagGentle => 'لطيف';

  @override
  String get tagCheerful => 'مبهج';

  @override
  String get tagLively => 'مفعم بالحيوية';

  @override
  String get tagMischievous => 'مؤذ';

  @override
  String get tagRichYoungLady => 'سيدة شابة ثرية';

  @override
  String get tagRichYoungMaster => 'سيد شاب ثري';

  @override
  String get tagWealthyFamily => 'عائلة ثرية';

  @override
  String get tagScheming => 'مخطط';

  @override
  String get tagPossessive => 'متملك';

  @override
  String get tagParanoid => 'مذعور';

  @override
  String get tagPersistent => 'مصر';

  @override
  String get tagUncle => 'عم';

  @override
  String get tagAuntie => 'عمة';

  @override
  String get tagSeniorSister => 'أخت كبيرة';

  @override
  String get tagJuniorBrother => 'أخ صغير';

  @override
  String get tagHandsome => 'وسيم';

  @override
  String get tagStunning => 'مذهلة الجمال';

  @override
  String get tagContrast => 'تناقض';

  @override
  String get tagFlirty => 'مغازلة';

  @override
  String get tagAgeGap => 'فارق العمر';

  @override
  String get userNotFoundError => 'المستخدم غير موجود';

  @override
  String get imageDataMismatchError =>
      'بيانات الصورة غير متطابقة، يرجى إعادة اختيار الصورة.';

  @override
  String get createCharacterTitle => 'إنشاء شخصية';

  @override
  String get charAlbumTitle =>
      'ألبوم الشخصيات (الصورة الأولى هي الصورة الرمزية الرئيسية)';

  @override
  String get charNameLabel => 'اسم الشخصية:*';

  @override
  String get charDescSection => 'وصف الشخصية:';

  @override
  String get charAgeLabel => 'العمر:';

  @override
  String get charJobLabel => 'المهنة:*';

  @override
  String get charBirthdayLabel => 'تاريخ الميلاد:(MMDD)';

  @override
  String get charGenderLabel => 'الجنس *';

  @override
  String get genderNotSelected => 'لم يتم الاختيار';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get genderOther => 'أخرى';

  @override
  String get charHeightLabel => 'الطول:(سم)';

  @override
  String get charAppearanceLabel => 'وصف المظهر:';

  @override
  String get charPersonalityTagsSection => 'علامات الشخصية';

  @override
  String get charOtherPersonalityTagsHint => 'علامات شخصية أخرى...';

  @override
  String get otherSectionTitle => 'أخرى';

  @override
  String get charLikesLabel =>
      'الأشياء المفضلة:(مثال: كعكة الفراولة، القطط، الأيام الممطرة)';

  @override
  String get charDislikesLabel =>
      'الأشياء المكروهة:(مثال: القرع المر، الأماكن الصاخبة)';

  @override
  String get charSecretsLabel =>
      'أسرار صغيرة لا يعرفها أحد: (مثال: في الحقيقة ضائع في الطرق)';

  @override
  String get charMannerismsSection => 'السلوكيات والإيماءات';

  @override
  String get charToneLabel => 'نبرة وأسلوب الكلام: (مثال: بارد مع الغرباء)';

  @override
  String get charDialogueExampleLabel =>
      'مثال على الحوار: (اللاعب: أنت لطيف جدا! الشخصية: ...أوه.)';

  @override
  String get charBackgroundSection => 'خلفية الشخصية:';

  @override
  String get charBackgroundHint => 'أدخل قصة خلفية الشخصية (بحد أقصى 2500 حرف)';

  @override
  String get charStoryStartSection => 'بداية القصة:';

  @override
  String get charStoryStartHint => 'أدخل حبكة الشخصية (بحد أقصى 2500 حرف)';

  @override
  String get charStorySummaryLabel =>
      'ملخص القصة (بحد أقصى 50 حرفًا، سيظهر على بطاقة اللقاء)';

  @override
  String get charExtraInfoSection => 'معلومات إضافية للشخصية:';

  @override
  String get charExtraInfoHint => 'أدخل محتوى إضافي...';

  @override
  String get charPublicToggleLabel =>
      'هل تريد جعلها عامة ليقوم اللاعبون الآخرون باللعب بها؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get createButton => 'إنشاء';

  @override
  String get saveButton => 'حفظ';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get exitCreationTitle => 'ستخرج من شاشة إنشاء الشخصية';

  @override
  String get saveDraftPrompt => 'هل تريد الحفظ كمسودة؟';

  @override
  String get draftNeeded => 'نعم';

  @override
  String get draftNotNeeded => 'لا';

  @override
  String get editExtraInfoTitle => 'تعديل المحتوى الإضافي';

  @override
  String get nameAndAvatarError =>
      'الرجاء إدخال اسم الشخصية وتحميل صورة رمزية واحدة على الأقل!';

  @override
  String get savingStatus => 'جارٍ الحفظ...';

  @override
  String get uploadingImagesStatus => 'جارٍ تحميل الصور...';

  @override
  String get maxImagesError => 'يمكنك تحميل 10 صور كحد أقصى.';

  @override
  String get uploadingImagesStatusShort => 'جاري معالجة الصور...';

  @override
  String get savingCharacterData => 'جاري حفظ بيانات الشخصية...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'تم إنشاء الشخصية \"$charName\"!';
  }

  @override
  String get uploadImageTimeoutError =>
      'فشل إنشاء الشخصية: انتهت مهلة تحميل الصورة، يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String createCharacterGenericError(String error) {
    return 'فشل إنشاء الشخصية: $error';
  }

  @override
  String get settingsSectionAppearance => 'المظهر والمحتوى';

  @override
  String get settingsSectionAccount => 'إدارة الحساب والمحتوى';

  @override
  String get settingsSectionAbout => 'عنا';

  @override
  String get accountManagement => 'إدارة الحساب';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'غير معروف';

  @override
  String get userIdCopied => 'تم نسخ معرّف المستخدم إلى الحافظة';

  @override
  String get characterManagement => 'إدارة الشخصيات';

  @override
  String get viewBlockedCharacters => 'عرض الشخصيات المحظورة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get logoutButton => 'تسجيل الخروج';

  @override
  String get logoutDialogTitle => 'هل تريد تسجيل الخروج؟(´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'لقد ضغطت بالخطأ';

  @override
  String get logoutDialogActionConfirm => 'تأكيد';

  @override
  String get logoutSuccessSnackbar => 'حسناً! سأنتظرك حتى تعود♥(´∀` )';

  @override
  String get deleteAccountButton => 'حذف الحساب';

  @override
  String get deleteAccountDialogTitle =>
      'هل أنت متأكد من أنك تريد حذف هذا الحساب؟இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'لا يمكن التراجع عن هذا الإجراء، وسيتم حذف جميع البيانات بشكل دائم!';

  @override
  String get deleteAccountDialogActionCancel => 'لا، لا أريد الحذف';

  @override
  String get deleteAccountDialogActionConfirm => 'تأكيد';

  @override
  String get deleteAccountSuccessSnackbar => 'تم حذف الحساب بنجاح.';

  @override
  String get appDisclaimer =>
      'الشخصيات والمشاهد في اللعبة خيالية، يرجى عدم تطبيقها على الواقع! إذا كان هناك أي تشابه، فهو من قبيل الصدفة البحتة.';

  @override
  String appVersion(String version) {
    return 'إصدار التطبيق: $version';
  }

  @override
  String get dialogTitleHint => 'تلميح';

  @override
  String get completeProfilePrompt =>
      'يرجى تعديل ملفك الشخصي لإكمال بياناتك أولاً!';

  @override
  String get goToEdit => 'انتقال إلى التعديل';

  @override
  String get later => 'لاحقاً';

  @override
  String chattingWith(String friendName) {
    return 'تتحدث مع $friendName';
  }

  @override
  String chatContentWith(String friendName) {
    return 'محتوى الدردشة مع $friendName';
  }

  @override
  String get chatInputHint => 'اكتب رسالة...';
}
