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

  @override
  String get characterNotFoundError => 'لم يتم العثور على بيانات الشخصية';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'فشل تحميل تفاصيل الشخصية: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'العلاقة الأولية';

  @override
  String get relationship_childhood_friend => 'صديق الطفولة';

  @override
  String get relationship_senior_junior => 'زميل/ة أكبر/أصغر';

  @override
  String get relationship_bickering_couple => 'زوجان يتشاجران';

  @override
  String get relationship_colleagues => 'زملاء عمل';

  @override
  String get relationship_other => 'أخرى (يرجى الإدخال يدوياً)';

  @override
  String get chatModeDaily => 'وضع يومي';

  @override
  String get chatModeStory => 'وضع القصة';

  @override
  String get chatModeImmersive => 'وضع الانغماس';

  @override
  String get chatModeGemini => 'مرافقة الحياة';

  @override
  String get announcement_new => 'إعلان جديد';

  @override
  String get mail_notification =>
      'وصلت رسالة زمنية جديدة! اذهب وتحقق من لفافة البردي الآن!';

  @override
  String get customer_service_reply => 'رد خدمة العملاء';

  @override
  String get system_announcement => 'إعلان النظام';

  @override
  String get empty_announcement => 'لا توجد إعلانات حالياً';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get no_content => 'لا يوجد محتوى';

  @override
  String get privacy_policy_title => 'سياسة الخصوصية لـ \"Lianlian Shiguang\"';

  @override
  String get privacy_policy_date => 'آخر تحديث: 10 أبريل 2026';

  @override
  String get privacy_policy_body =>
      'سياسة الخصوصية لـ \"Lianlian Shiguang\"\nتاريخ التحديث الأخير: 10 أبريل 2026\n\nمرحبًا بك في \"Lianlian Shiguang\" (المشار إليها فيما يلي بـ \"الخدمة\"). نحن نولي أهمية كبرى لخصوصيتك. تهدف هذه السياسة إلى توضيح كيفية جمعنا واستخدامنا وحمايتنا لمعلوماتك الشخصية.\n\n1. معلومات الحساب:\nتسجيل الدخول عبر طرف ثالث: عندما تقوم بتسجيل الدخول عبر حسابات Google أو Facebook أو Apple، نجمع معرف Firebase UID الخاص بك، وبريدك الإلكتروني، واسمك المستعار العام.\nالتسجيل عبر البريد الإلكتروني: عندما تختار التسجيل عبر البريد الإلكتروني، نجمع حساب بريدك الإلكتروني. يتم إدارة وتخزين كلمة مرور تسجيل الدخول الخاصة بك من خلال تقنية تشفير Firebase، ولا يمكن لفريق التطوير الوصول إلى كلمة المرور الأصلية الخاصة بك. نحن نلتزم باتخاذ معايير أمان الصناعة لضمان سلامة بياناتك الشخصية.\n\nبيانات التفاعل: لتمكين شخصيات الذكاء الاصطناعي من امتلاك ذاكرة مستمرة، نقوم بجمع وتخزين سجلات حواراتك مع الذكاء الاصطناعي والمحتوى الذي تكتبه للشخصيات داخل اللعبة.\n\nمعلومات الجهاز: تشمل طراز الجهاز، وإصدار نظام التشغيل، ومعرف الجهاز الفريد، وتستخدم لتحسين النظام.\n\n2. كيفية استخدام المعلومات:\nتحسين تجربة الذكاء الاصطناعي: استخدام سجلات الحوار لتحسين جودة ردود الذكاء الاصطناعي واستمرارية الشخصية.\nعمليات الخدمة: تستخدم لمعالجة شحن النقاط، وسجلات الاستهلاك، والتحقق من هوية المستخدم.\nالحماية الأمنية: مراقبة السلوكيات الضارة لحماية الخادم من الهجمات.\n\n3. التعاون التقني مع أطراف ثالثة:\nتعتمد هذه الخدمة على التقنيات الدولية الرئيسية التالية للدعم:\nGoogle Cloud / Firebase: لتخزين البيانات والتحقق من الهوية.\nOpenRouter / xAI / Meta: لتوفير منطق الحساب لنماذج الذكاء الاصطناعي.\nملاحظة: لن نقوم ببيع سجلات حواراتك الأصلية لأي معلن.\n\n4. تخزين وحذف البيانات:\nسيتم تخزين بياناتك بشكل آمن في خوادم سحابية. يمكنك الاتصال بنا في أي وقت لطلب حذف حسابك وجميع بيانات الحوار المرتبطة به بشكل دائم.';

  @override
  String get terms_title => 'شروط الخدمة لـ \"Lianlian Shiguang\"';

  @override
  String get terms_date => 'آخر تحديث: 10 أبريل 2026';

  @override
  String get terms_body =>
      'شروط استخدام خدمة \"Lianlian Shiguang\"\nتاريخ التحديث الأخير: 10 أبريل 2026\n\nقبل استخدام \"Lianlian Shiguang\" (المشار إليها فيما يلي بـ \"الخدمة\")، يرجى قراءة الشروط التالية بعناية. البدء في استخدام الخدمة يعني موافقتك على ما يلي:\n\n1. طبيعة الخدمة وإخلاء المسؤولية:\nتفاعل غير بشري: يتم إنشاء جميع ردود الشخصيات في هذه الخدمة بواسطة الذكاء الاصطناعي التوليدي (Generative AI). ولا تمثل تصريحات الشخصيات موقف المطور.\nمخاطر السرد: قد ينشئ الذكاء الاصطناعي محتوى خياليًا أو غير دقيق أو غير مريح. يجب أن يتمتع المستخدم بالقدرة على التمييز بين الخيال والواقع.\n\n2. النقاط الافتراضية ونموذج الدفع:\nطبيعة النقاط: النقاط داخل هذه الخدمة هي سلع افتراضية، وبمجرد استهلاكها (مثل: دخول القصة، وضع الانغماس، إرسال الهدايا، المكالمات الصوتية) لا يمكن استردادها.\nاختلاف التكلفة: تعتمد معايير استهلاك النقاط في الأوضاع المختلفة على تكاليف حساب الذكاء الاصطناعي، وتحتفظ الخدمة بالحق في تعديل التكاليف.\n\n3. قواعد سلوك المستخدم:\nالمحظورات: يُحظر استخدام الذكاء الاصطناعي لإنشاء محتوى يتضمن عنفًا مفرطًا، أو توجيهًا إجراميًا، أو ينتهك القانون.\nالتدخل في النظام: يُمنع منعًا باتًا الحصول على بيانات الخدمة بشكل غير قانوني من خلال أي أدوات أتمتة أو هندسة عكسية.\n\n4. حقوق الملكية الفكرية وملكية المحتوى:\nالمحتوى الأصلي: تنتمي حقوق الملكية الفكرية لأسماء الشخصيات (مثل الشخصيات الرسمية كـ Cheng An)، وإعدادات الخلفية، ونصوص القصص، ونصوص الحوار، ومنطق اللعبة، والأسماء التجارية الحصرية إلى \"فريق تطوير Lianlian Shiguang\".\nموارد مرخصة من أطراف ثالثة: الرموز والخطوط والرموز التعبيرية المستخدمة في واجهة الخدمة تعود ملكيتها لأصحاب التراخيص الأصليين، ويتم استخدامها قانونيًا وفقًا لاتفاقيات المصدر المفتوح أو الترخيص.\nالمحتوى المنشأ بالذكاء الاصطناعي: بعض الصور الفنية في الخدمة تم إنشاؤها باستخدام أدوات الذكاء الاصطناعي (مثل Niji.journey)، ويضمن الفريق الحصول على تراخيص الاستخدام التجاري لها. تعود حقوق الاستخدام والتشغيل لهذه الصور إلى الفريق.\nالأفعال المحظورة: يُمنع منعًا باتًا استخدام أي من المحتويات المذكورة أعلاه للربح التجاري أو إعادة التوزيع دون إذن رسمي.\n\n5. إنهاء الخدمة:\nفي حال مخالفة المستخدم للوائح المذكورة أعلاه، يحق للخدمة تعليق الحساب أو تعطيله نهائيًا دون إشعار مسبق.';

  @override
  String get login_required => 'يرجى تسجيل الدخول أولاً';

  @override
  String get cloud_character_mgmt => 'إدارة الشخصيات السحابية';

  @override
  String get connection_error => 'خطأ في الاتصال';

  @override
  String get no_characters_met => 'لم تقابل أي شخصيات بعد!';

  @override
  String get status_paused => 'الحالة: تم إيقاف الاتصال';

  @override
  String get status_in_progress => 'الحالة: قيد التقدم';

  @override
  String get unblock => 'إلغاء الحظر';

  @override
  String get block => 'حظر';

  @override
  String get confirm_block_title => 'هل أنت متأكد أنك تريد الحظر؟';

  @override
  String confirm_block_msg(Object charName) {
    return 'بعد الحظر، لن تتمكن مؤقتًا من تلقي رسائل من $charName.';
  }

  @override
  String get think_again => 'فكر مرة أخرى';

  @override
  String get confirm_block_btn => 'تأكيد الحظر';

  @override
  String get no_char_info => 'لا توجد معلومات مفصلة لهذه الشخصية حالياً...';

  @override
  String get private_mailbox => 'بريد خاص';

  @override
  String get user_info_not_found => 'تعذر العثور على معلومات المستخدم';

  @override
  String get load_failed => 'فشل التحميل، يرجى المحاولة لاحقاً';

  @override
  String get empty_mailbox => 'صندوق البريد فارغ حالياً~';

  @override
  String get system_notification => 'إشعار النظام';

  @override
  String get interaction_records => 'سجلات التفاعل';

  @override
  String get liked_content => 'المحتوى المفضل';

  @override
  String get my_favorites => 'مفضلاتي';

  @override
  String get login_to_view_records => 'يرجى تسجيل الدخول لعرض السجلات';

  @override
  String get no_likes_yet => 'لم تعجب بأي منشورات بعد!';

  @override
  String get empty_favorites => 'المجلد المفضل فارغ، اذهب واستكشف القاعة!';

  @override
  String get theme_sakura_pink => 'ساكورا وردي';

  @override
  String get theme_ocean_blue => 'أزرق المحيط';

  @override
  String get theme_sunset_orange => 'برتقالي الغروب';

  @override
  String get theme_mint_forest => 'غابة النعناع';

  @override
  String get theme_midnight => 'نمط منتصف الليل';

  @override
  String get change_atmosphere => 'تغيير الأجواء';

  @override
  String get custom_color => 'لون مخصص';

  @override
  String get custom_color_desc => 'صمم لون الأجواء الخاص بك';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';
}
