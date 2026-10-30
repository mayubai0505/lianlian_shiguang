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
  String get charNameLabel => 'اسم الشخصية:';

  @override
  String get charDescSection => 'وصف الشخصية:';

  @override
  String get charAgeLabel => 'العمر:';

  @override
  String get charJobLabel => 'المهنة:';

  @override
  String get charBirthdayLabel => 'تاريخ الميلاد:(MMDD)';

  @override
  String get charGenderLabel => 'الجنس ';

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
  String get logoutSuccessSnackbar => 'حسناً! سأنتظرك حتى تعود(´∀` )';

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
      'الشخصيات والمشاهد في اللعبة خيالية تماماً، يرجى عدم إسقاطها على أرض الواقع!';

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
  String get terms_title => 'شروط الاستخدام';

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
  String block_warning_msg(String charName) {
    return 'بعد الحظر، لن تتلقى رسائل من $charName مؤقتاً.';
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

  @override
  String get confirm_delete_title => 'تأكيد الحذف';

  @override
  String get confirm_delete_memory_msg =>
      'هل أنت متأكد أنك تريده أن ينسى هذا؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get delete_btn => 'حذف';

  @override
  String get memory_erased_msg => 'تم مسح هذه الذاكرة.';

  @override
  String get delete_failed_msg => 'فشل الحذف';

  @override
  String get edit_memory_title => 'تعديل الذكريات';

  @override
  String get modify_memory_hint => 'تعديل هذه الذاكرة...';

  @override
  String get memory_re_recorded_msg => 'تمت إعادة تسجيل الذاكرة';

  @override
  String get update_failed_msg => 'فشل التحديث';

  @override
  String get update_favorite_failed_msg => 'فشل تحديث حالة المفضلة';

  @override
  String char_notebook_title(String charName) {
    return 'مفكرة $charName';
  }

  @override
  String get error_loading_memory => 'حدث خطأ أثناء تحميل الذاكرة';

  @override
  String get empty_notebook_msg =>
      'المفكرة فارغة...\nاذهب للدردشة حتى يتمكن من كتابة كل التفاصيل عنك!';

  @override
  String get date_format_text => 'd MMM yyyy';

  @override
  String get remove_special_focus => 'إزالة التركيز الخاص';

  @override
  String get mark_special_focus => 'تعيين كتركيز خاص';

  @override
  String get edit_btn => 'تعديل';

  @override
  String get load_gallery_failed => 'فشل تحميل المعرض';

  @override
  String get traditional_chinese => 'الصينية التقليدية';

  @override
  String get all => 'الكل';

  @override
  String get official_recommendation => 'التوصية الرسمية';

  @override
  String get my_exclusive => 'حصري لي';

  @override
  String encounter_count(int count) {
    return '$count لقاءات';
  }

  @override
  String get official => 'رسمي';

  @override
  String get private => 'خاص';

  @override
  String get first_encounter => 'اللقاء الأول';

  @override
  String char_exclusive_memory(String charName) {
    return 'ذاكرة $charName الحصرية';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return 'يجب أن تصل المودة إلى $affectionLevel لفتح هذه الذاكرة!';
  }

  @override
  String get affection => 'المودة';

  @override
  String get unlock => 'فتح';

  @override
  String get change_chat_bg => 'تغيير خلفية الدردشة';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return 'هل تريد تعيين \"$cgDesc\" كخلفية دردشة مع $charName؟';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return 'تم تغيير الخلفية إلى \"$cgDesc\"';
  }

  @override
  String get confirm_change => 'تأكيد التغيير';

  @override
  String get empty_treasure_box =>
      'صندوق الكنز فارغ...\nاذهب للدردشة للعثور على المفاجآت المخفية!';

  @override
  String get unknown_story => 'قصة غير معروفة';

  @override
  String get open_this_memory => 'فتح هذه الذاكرة';

  @override
  String get open_exclusive_story => 'فتح القصة الحصرية';

  @override
  String confirm_use_egg(String eggTitle) {
    return 'هل تريد تجربة \"$eggTitle\" الآن؟\n\n(هذا العنصر للاستخدام مرة واحدة وسيدخل القصة تلقائياً)';
  }

  @override
  String get wait_a_bit => 'انتظر قليلاً';

  @override
  String guiding_into_story(String eggTitle) {
    return 'يتم التوجيه إلى القصة...';
  }

  @override
  String get use_now => 'استخدم الآن';

  @override
  String playback_failed_status(String statusCode) {
    return 'فشل التشغيل، رمز الحالة: $statusCode';
  }

  @override
  String get playback_error => 'حدث خطأ في التشغيل';

  @override
  String get unknown_contact => 'جهة اتصال غير معروفة';

  @override
  String call_memory_with(String charName) {
    return 'ذاكرة اتصال مع $charName';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return 'يفتح عند مستوى المودة $affection';
  }

  @override
  String get no_call_record => 'يبدو أنه لا يوجد سجل محادثة لهذه المكالمة...';

  @override
  String get me => 'أنا';

  @override
  String get playing => 'قيد التشغيل...';

  @override
  String get listen => 'استمع';

  @override
  String get no_exclusive_voice => 'هذه الشخصية ليس لها صوت حصري بعد!';

  @override
  String get voice_download_success =>
      ' تم تنزيل البيانات الصوتية بنجاح، جاري التحضير للتشغيل...';

  @override
  String get onboarding_invitation => '— دعوة الزمن —';

  @override
  String get onboarding_welcome => 'مرحباً بك في Lian Lian Shi Guang';

  @override
  String get onboarding_quote => '\"كل لقاء هو لم شمل بعد غياب طويل.\"';

  @override
  String get onboarding_gift_title => 'هدية اللقاء الأول: 50 زهرة';

  @override
  String get onboarding_gift_subtitle => 'سترافقك هذه الزهور عند بدء قصتك معه.';

  @override
  String get onboarding_start_button => 'ابدأ رحلة الزمن الخاصة بك';

  @override
  String get onboarding_more_info => 'اكتشف المزيد عن القصة';

  @override
  String get legal_agreement_prefix => 'بالاستمرار، فإنك توافق على';

  @override
  String get legal_terms_button => 'شروط الخدمة';

  @override
  String get legal_and => ' و ';

  @override
  String get legal_privacy_button => 'سياسة الخصوصية';

  @override
  String get call_memory_title => 'ذكريات المكالمات';

  @override
  String get please_login_first => 'يرجى تسجيل الدخول أولاً';

  @override
  String get no_call_memories =>
      'لا توجد ذكريات محفوظة للمكالمات حتى الآن.\nيمكن حفظ 10 سجلات كحد أقصى.';

  @override
  String call_with_name(String name) {
    return 'مكالمة مع $name';
  }

  @override
  String call_duration(String time) {
    return 'المدة: $time';
  }

  @override
  String get delete_call_title => 'حذف سجل المكالمة';

  @override
  String delete_call_confirm(String name) {
    return 'هل أنت متأكد أنك تريد حذف هذه الذكرى مع $name؟\n(لا يمكن التراجع عن هذا الإجراء)';
  }

  @override
  String get keep_it => 'الاحتفاظ بها';

  @override
  String get confirm_delete => 'حذف';

  @override
  String get press_mic_to_speak => 'يرجى الضغط على الميكروفون لبدء التحدث...';

  @override
  String get call_ended => 'انتهت المكالمة';

  @override
  String character_thinking(String name) {
    return '($name يفكر...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name يرد على الهاتف...)';
  }

  @override
  String get call_interrupted_login =>
      '(انقطعت المكالمة) يرجى تسجيل الدخول أولاً...';

  @override
  String get silence => '(صمت)';

  @override
  String get bad_signal => '(إشارة سيئة...)';

  @override
  String get static_noise => '(تشويش)... لا أستطيع السماع بوضوح...';

  @override
  String get type_message_hint => 'اكتب رسالة...';

  @override
  String get draft_saved_success => 'تم حفظ المسودة بأمان في الاستوديو السري!';

  @override
  String get draft_save_failed => 'فشل الحفظ، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get draft_save_title => 'هل تريد حفظ المسودة؟';

  @override
  String get draft_save_content =>
      'لم يتم نشر عملك بعد، هل تريد حفظه في الاستوديو السري أولاً؟';

  @override
  String get not_save => 'عدم الحفظ';

  @override
  String get save_draft => 'حفظ المسودة';

  @override
  String confirm_delete_char_content(String name) {
    return 'هل أنت متأكد من حذف الشخصية \"$name\"؟\n\nهذا الإجراء لا يمكن التراجع عنه!';
  }

  @override
  String get char_deleted => 'تم حذف الشخصية';

  @override
  String get ok_button => 'حسناً!';

  @override
  String get cannot_save_title => 'تعذر الحفظ';

  @override
  String get cannot_save_content =>
      'يرجى ملء اسم الشخصية وتحميل صورة رمزية واحدة على الأقل!';

  @override
  String get word_count_exceeded => 'عدد الكلمات كبير جدًا';

  @override
  String word_count_error_detail(String field, int limit) {
    return 'تجاوز الحقل \"$field\" الحد المسموح به وهو $limit كلمة، يرجى التقليل ثم الحفظ.';
  }

  @override
  String get content_missing => 'محتوى مفقود';

  @override
  String get content_missing_personality =>
      'يرجى ملء \"الشخصية التفصيلية\"! اكتب 10 كلمات على الأقل.';

  @override
  String get content_missing_bg =>
      '\"مقدمة الشخصية\" قصيرة جدًا! يرجى كتابة 20 كلمة على الأقل لتوضيح الخلفية.';

  @override
  String get content_missing_tone =>
      'يرجى ضبط \"النبرة والعادات\"، وإلا فسيكون من السهل الخروج عن الشخصية (OOC)!';

  @override
  String get user_not_found => 'خطأ: المستخدم غير موجود';

  @override
  String char_saved_success(String name, String action) {
    return 'تم $action الشخصية \"$name\"!';
  }

  @override
  String save_error_detail(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get easter_egg_add_title => 'إضافة بيضة عيد فصح مخفية';

  @override
  String get easter_egg_edit_title => 'تعديل المفاجأة';

  @override
  String get keyword_label => 'الكلمة المفتاحية للتشغيل (مطلوب)';

  @override
  String get keyword_hint => 'مثال: الذهاب إلى الملاهي، كعكة الفراولة';

  @override
  String get egg_title_label => 'عنوان المفاجأة (للاعبين)';

  @override
  String get egg_title_hint => 'مثال: موعد نهاية الأسبوع';

  @override
  String get egg_teaser_label => 'إعلان قصير (للاعبين)';

  @override
  String get egg_teaser_hint => 'وصف بداية ما سيحدث...';

  @override
  String get egg_scene_label => 'تغيير المشهد الإجباري (اختياري)';

  @override
  String get egg_scene_hint => 'مثال: ملاهي، بيت رعب';

  @override
  String get egg_prompt_label => 'أمر السيناريو';

  @override
  String get egg_prompt_hint =>
      'كيفية أداء هذه الحبكة.\n(النظام: ينتقل المشهد إلى الملاهي، الشخصية تنظر إلى (اسم اللاعب) وتبتسم...)';

  @override
  String get confirm_button => 'تأكيد';

  @override
  String get keyword_empty_error => 'الكلمة المفتاحية لا يمكن أن تكون فارغة';

  @override
  String get voice_custom_title => 'تخصيص صوت حصري';

  @override
  String get voice_custom_hint =>
      'مثال: مدير مستبد بصوت منخفض، جرو لطيف وهادئ...';

  @override
  String get voice_generate_start => 'بدء التوليد';

  @override
  String get voice_bind_first => 'يرجى اختيار و \"ربط\" صوت حصري أولاً!';

  @override
  String get voice_test_failed =>
      'فشل الاستماع التجريبي: يرجى النقر على \"لقد اخترتك!\" لربط الصوت رسمياً قبل الضبط الدقيق!';

  @override
  String voice_name_default(String name) {
    return 'الصوت الحصري لـ $name';
  }

  @override
  String get voice_description_default =>
      'هذا صوت فريد تم إنشاؤه للشخصية الحصرية في \"Lian Lian Shi Guang\"، تم اختياره وتوليده من قبل اللاعب.';

  @override
  String get voice_bind_failed =>
      'فشل ربط الصوت، يرجى التحقق من رصيد API أو حالة الشبكة';

  @override
  String voice_bind_success(String name) {
    return 'تم ربط صوت روح \"$name\" رسمياً!';
  }

  @override
  String get voice_bind_success_draft =>
      'تم ربط الصوت بنجاح! يمكنك الآن سحب الشريط لاختبار المشاعر!';

  @override
  String sync_failed(String error) {
    return 'فشل المزامنة، يرجى التحقق من الشبكة: $error';
  }

  @override
  String edit_character_title(String name) {
    return 'تعديل $name';
  }

  @override
  String get test_mode_tooltip => 'اختبار الوظائف الكاملة';

  @override
  String get test_mode_notice =>
      ' سيتم خصم النقاط في وضع الاختبار وفقاً للسعر الأصلي لكل وضع، ولن يتم احتسابها في الذكريات الرسمية!';

  @override
  String get delete_character_tooltip => 'حذف الشخصية';

  @override
  String get tab_basic_story => 'الأساسيات والقصة';

  @override
  String get tab_voice => 'صوت حصري';

  @override
  String get tab_relationship => 'العلاقات الاجتماعية';

  @override
  String get save_changes_button => 'حفظ التغييرات';

  @override
  String get section_basic_info => 'المعلومات الأساسية';

  @override
  String get hint_occupation =>
      'يدعم هويات متعددة، يرجى الفصل بشرطة مائلة أو فاصلة (مثال: طالب/هكر)';

  @override
  String get hint_appearance =>
      'مثال: شعر فضي طويل، عيون عسلية، يرتدي دائماً رداءً أبيض...';

  @override
  String get section_story_identity => ' القصة وهويتك';

  @override
  String get story_identity_desc =>
      'تحديد بداية القصة والإعدادات الخاصة لـ \"أنت\" في هذا الملف';

  @override
  String get advanced_writing_tips_title => ' نصائح كتابة متقدمة:\n';

  @override
  String get advanced_writing_tips_1 => 'أدخل في القصة أو الحوار ';

  @override
  String get advanced_writing_tips_2 => '(اسم اللاعب)';

  @override
  String get advanced_writing_tips_3 =>
      '، وسيقوم النظام تلقائياً باستبداله بلقب اللاعب الحقيقي عند اللعب!\n';

  @override
  String get advanced_writing_tips_4 => 'مثال: \"';

  @override
  String get advanced_writing_tips_5 => '(اسم اللاعب)';

  @override
  String get advanced_writing_tips_6 => '، لماذا تأخرت كثيراً؟\"';

  @override
  String get background_label => 'خلفية الشخصية وعالمها ';

  @override
  String get background_hint =>
      'وصف ماضيه والعالم الذي يعيش فيه (مثل: مدينة حديثة، ABO، نهاية العالم). مثال: هذا عالم تجتاحه الزومبي، وهو جندي قوات خاصة يحميك...';

  @override
  String get story_summary_label => 'ملخص القصة في جملة واحدة ';

  @override
  String get story_initial_label => 'قصة اللقاء الأول ';

  @override
  String get story_initial_hint =>
      'مثال: تدفع الباب وترى أنه يجلس بجانب النافذة. يلتفت ويقول: \"(اسم اللاعب)، تعال هنا.\"...';

  @override
  String get first_line_label => 'أول جملة للشخصية';

  @override
  String get first_line_hint => 'مثال: (اسم اللاعب)، لقد أتيت أخيراً.';

  @override
  String get section_personality_evo => ' تطور الشخصية والمودة';

  @override
  String get detailed_personality_label => 'شخصية مفصلة ';

  @override
  String get detailed_personality_hint =>
      'وصف شخصيته الأساسية. مثال: تسونديري، لسان حاد وقلب طيب. بارد مع الغرباء، يبتسم فقط للاعب.';

  @override
  String get affection_evo_desc =>
      'سيحدد الذكاء الاصطناعي متى تزداد المودة بناءً على الإعدادات التالية:';

  @override
  String get stage_1_label => 'المرحلة 1: غريب/حذر (Lv1)';

  @override
  String get stage_1_hint =>
      'رد الفعل عند التعارف لأول مرة. شروط زيادة المودة (مثال: الأدب، عدم التطفل على الخصوصية).';

  @override
  String get stage_2_label => 'المرحلة 2: مألوف/صديق (Lv2)';

  @override
  String get stage_2_hint =>
      'التغيرات بعد التعارف الجيد. شروط زيادة المودة (مثال: مشاركة الحلويات، التحدث عن القطط).';

  @override
  String get stage_3_label => 'المرحلة 3: حميم/حبيب (Lv3)';

  @override
  String get stage_3_hint =>
      'رد الفعل بعد الوقوع في الحب تماماً. هل سيغار؟ أم سيعبس بصمت؟';

  @override
  String get social_interaction_label => 'التفاعل الاجتماعي والبيئي';

  @override
  String get social_interaction_hint =>
      'مثال: كيف يعامل المارة؟ كيف يتفاعل عند مواجهة أشياء يكرهها؟';

  @override
  String get section_habits => ' التفضيلات والعادات';

  @override
  String get tone_hint_detail =>
      'مطلوب. مثال: كلامه مختصر، يحب طرح أسئلة عكسية. لزمته هي \"أحمق\". يمنع استخدام لغة الترجمة الآلية.';

  @override
  String get dialogue_example_hint =>
      'اللاعب: أنا متعب جداً.\nالشخصية: (يمسح على الرأس) كن مطيعاً، اذهب وارتح بسرعة.';

  @override
  String get section_easter_eggs => ' مفاجآت مخفية وقصص خاصة';

  @override
  String get no_easter_eggs =>
      'لم يتم ضبط مفاجآت بعد، انقر على الزر أدناه للإضافة';

  @override
  String get no_scene_change => 'لا يوجد تغيير في المشهد';

  @override
  String get add_easter_egg_button => 'إضافة مفاجأة مخفية';

  @override
  String get other_extra_info => 'معلومات إضافية أخرى';

  @override
  String get visibility_label => 'رؤية الشخصية';

  @override
  String get visibility_public => 'عام';

  @override
  String get visibility_private => 'خاص';

  @override
  String get section_voice_gen => 'توليد صوته الحصري';

  @override
  String get voice_gen_desc =>
      'أدخل الكلمات الوصفية ليكون له صوت حصري فريد في العالم!\n( تنبيه: إذا لم تكن راضياً بعد التوليد، يمكنك إعادة التخصيص في أي وقت!)';

  @override
  String get voice_generating_status => 'جاري ضبط النبرة الصوتية...';

  @override
  String get voice_select_prompt =>
      ' لقد جهزت لك ثلاثة أنواع من الأصوات، يرجى الاختيار:';

  @override
  String voice_sample_name(int index) {
    return 'عينة صوت $index';
  }

  @override
  String get voice_sample_desc =>
      'انقر على البطاقة للاختيار، وانقر على اليمين للاستماع التجريبي';

  @override
  String get voice_preparing => 'الصوت لا يزال قيد التحضير...';

  @override
  String get voice_retry => 'إلغاء والمحاولة مرة أخرى';

  @override
  String get voice_confirm_selection => 'لقد اخترتك!';

  @override
  String get voice_bind_success_banner => 'تم ربط الصوت الحصري بنجاح!';

  @override
  String get voice_remake => 'إعادة صنع الصوت';

  @override
  String get voice_btn_generating => 'جاري التوليد، يرجى الانتظار...';

  @override
  String get voice_btn_generate => 'أدخل كلمات الوصف لتوليد صوت حصري';

  @override
  String get voice_advanced_tuning => ' متقدم: ضبط مشاعر الكلام ';

  @override
  String get voice_stability_low => 'بري/نفسي ';

  @override
  String voice_stability_value(String value) {
    return 'درجة العقلانية: $value';
  }

  @override
  String get voice_stability_high => 'مستقر/هادئ ';

  @override
  String get voice_style_low => 'بارد/مكبوت ';

  @override
  String voice_style_value(String value) {
    return 'الأداء الدرامي: $value';
  }

  @override
  String get voice_style_high => 'مبالغ فيه/عاطفي ';

  @override
  String get voice_test_btn_testing => 'جاري تطبيق المشاعر...';

  @override
  String get voice_test_btn => 'استماع للمشاعر الحالية';

  @override
  String get section_social_circle => ' دائرته الاجتماعية';

  @override
  String get social_circle_desc =>
      'تحديد رأيه في الشخصيات الأخرى. عندما يذكر اللاعب الطرف الآخر في الدردشة، سيرد بناءً على هذه الإعدادات (مثال: غيرة، غضب).';

  @override
  String get social_no_drama => 'لا توجد خلافات مع آلهة ذكور آخرين حالياً...';

  @override
  String social_target(String name) {
    return 'الهدف: $name';
  }

  @override
  String social_attitude(String attitude) {
    return 'الرأي: $attitude';
  }

  @override
  String social_edit_title(String name) {
    return 'تعديل الرأي في $name ';
  }

  @override
  String get social_attitude_label => 'رأيه / موقفه';

  @override
  String get social_attitude_hint =>
      'مثال: يراه مزعجاً جداً، لكنه في الحقيقة يعتمد عليه...';

  @override
  String get social_save_changes => 'حفظ التعديلات';

  @override
  String get social_add_title => 'إضافة علاقة شخصية ';

  @override
  String get social_select_target => 'اختر الهدف';

  @override
  String get social_thoughts_label => 'رأيه في هذا الشخص...';

  @override
  String get social_thoughts_hint => 'مثال: عازف البيانو هذا مزعج جداً...';

  @override
  String get social_add_confirm => 'تأكيد الإضافة';

  @override
  String get gallery_load_failed =>
      'فشل تحميل الصورة \nيرجى التأكد من استقرار الشبكة .';

  @override
  String gallery_affection_req(int level) {
    return 'مودة $level';
  }

  @override
  String get gallery_upload_limit => 'يمكن تحميل 10 صور كحد أقصى';

  @override
  String get gallery_photo_setup => 'ضبط شروط فتح الصورة';

  @override
  String get gallery_photo_desc_label => 'ما هذه الصورة؟';

  @override
  String get gallery_photo_desc_hint => 'مثال: صورة بملابس النوم، صورة موعد';

  @override
  String get gallery_photo_req_label => 'كم مستوى مودة مطلوب للفتح؟';

  @override
  String get gallery_photo_req_hint => 'أدخل رقماً، 0 يعني مجاني';

  @override
  String get gallery_cancel_upload => 'إلغاء التحميل';

  @override
  String get gallery_confirm_add => 'تأكيد الإضافة';

  @override
  String get default_photo_desc => 'صورة حصرية';

  @override
  String get draft_photo_desc => 'صورة مسودة';

  @override
  String get loading_text => 'جاري التحميل...';

  @override
  String get default_unnamed_character => 'شخصية غير مسمى';

  @override
  String elevenlabs_error(String code) {
    return 'خطأ ElevenLabs: $code';
  }

  @override
  String get voice_sample_script =>
      '(تنحنح) مرحبًا. هذا اختبار صوتي خاص بي. في الأيام القادمة، سأكون هنا معك. سواء كنت سعيدًا أو حزينًا، يمكنك دائمًا مشاركة مشاعرك معي. هل تجد وتيرة صوتي ونبرته مريحة؟ إذا أعجبك، فلنعتمد هذا كصوتي الخاص للدردشة معك في المستقبل. أتطلع إلى كل يوم قادم نقضيه معًا.';

  @override
  String get voice_test_script =>
      'هل تعلمين حقاً بمَ أفكّر في كل مرة أنظر فيها إليكِ؟ ... أنا حقاً لا أعرف ماذا أفعل معكِ.';

  @override
  String get field_background => 'مقدمة الشخصية';

  @override
  String get field_tone => 'النبرة والعادات';

  @override
  String get field_initial_story => 'القصة الأولية';

  @override
  String get update_action => 'تحديث';

  @override
  String get default_new_player => 'لاعب جديد';

  @override
  String get translating_status => 'جاري الترجمة...';

  @override
  String get translate_profile_btn => 'ترجمة محتوى الملف الشخصي';

  @override
  String translate_failed(String error) {
    return 'فشلت الترجمة: $error';
  }

  @override
  String get like_own_char_warning =>
      'لا يمكنك الإعجاب بالشخصية التي أنشأتها بنفسك! ';

  @override
  String get like_success_msg => 'تم إرسال الإعجاب! سيسعد المبدع بذلك كثيراً ';

  @override
  String get unlike_success_msg => 'تم سحب الإعجاب ';

  @override
  String get like_label => 'إعجاب';

  @override
  String get dislike_label => 'عدم إعجاب';

  @override
  String get block_char => 'حظر هذه الشخصية';

  @override
  String get char_blocked_msg => 'تم حظر هذه الشخصية.';

  @override
  String get dislike_dialog_title => 'لا تعجبك هذه الشخصية؟';

  @override
  String get dislike_dialog_subtitle =>
      'يرجى إخبارنا بالسبب سراً، وسيقوم المسؤولون بالمراجعة والتدقيق:';

  @override
  String get dislike_hint => 'الإعدادات مملة للغاية، الصور غير مناسبة...';

  @override
  String get dislike_thanks =>
      'شكراً لتعليقاتك! لقد تلقى المسؤولون رسالتك السرية.';

  @override
  String get dislike_submit => 'إرسال سري';

  @override
  String get report_title => ' إبلاغ عن تعليق';

  @override
  String get report_subtitle =>
      'يرجى اختيار سبب الإبلاغ:\nسنقوم بمراجعة المحتوى في أقرب وقت ممكن بعد الإبلاغ.';

  @override
  String get report_opt_1 => 'محتوى إباحي أو دموي وعنيف';

  @override
  String get report_opt_2 => 'تزييف أو إهانة أو مهاجمة الشخصية';

  @override
  String get report_opt_3 => 'خطاب كراهية أو هجوم شخصي';

  @override
  String get report_opt_4 => 'رسائل غير مرغوب فيها أو إعلانات احتيالية';

  @override
  String get report_opt_5 => 'محتوى غير لائق آخر';

  @override
  String get report_confirm => 'تأكيد الإبلاغ';

  @override
  String get report_success =>
      'تم الإبلاغ بنجاح، تم استلام الإخطار! سنقوم بمراجعة المحتوى في أقرب وقت ممكن';

  @override
  String get report_failed => 'فشل الإبلاغ، يرجى التحقق من اتصال الشبكة.';

  @override
  String get lore_delete_title => 'تحذير: محو الذاكرة';

  @override
  String get lore_delete_content =>
      'بمجرد حذف هذه الذاكرة، ستختفي تماماً. هل أنت متأكد من رغبتك في محوها بقسوة؟';

  @override
  String get lore_delete_cancel => 'خطأ في الضغط';

  @override
  String get lore_delete_confirm => 'تأكيد المحو';

  @override
  String get lore_delete_success => 'تم محو شظايا الذاكرة تماماً.';

  @override
  String get lore_add_title => 'كتابة ذاكرة جديدة';

  @override
  String get lore_edit_title => 'تعديل شظية الذاكرة';

  @override
  String get lore_title_label => 'عنوان الذاكرة';

  @override
  String get lore_title_hint => 'مثال: اليوم الماطر في اللقاء الأول';

  @override
  String get lore_teaser_label => 'ملخص / مقدمة';

  @override
  String get lore_teaser_hint => 'وصف قصير يظهر على البطاقة...';

  @override
  String get lore_content_label => 'محتوى الذاكرة الكامل';

  @override
  String get lore_content_hint => 'اكتب القصة المفصلة أو الإعدادات هنا...';

  @override
  String get lore_lock_label => ' ختم هذه الذاكرة';

  @override
  String get lore_lock_desc =>
      'عند التحديد، سيراها المبدع فقط، ولن يتمكن اللاعبون من مشاهدتها';

  @override
  String get lore_empty_error => 'العنوان والمحتوى لا يمكن أن يكونا فارغين!';

  @override
  String get lore_add_success => ' تم ختم الذاكرة الجديدة بنجاح!';

  @override
  String get lore_publish => 'نشر الذاكرة';

  @override
  String get lore_save_edit => 'حفظ التعديلات';

  @override
  String lore_write_first(Object pronoun) {
    return 'هيا اكتب أول ذكرى لـ $pronoun!';
  }

  @override
  String lore_waiting(Object pronoun) {
    return 'بانتظار القصة مع $pronoun...';
  }

  @override
  String get lore_sealed_msg => ' تم ختم هذه الذاكرة، لا يمكن عرضها حالياً.';

  @override
  String get lore_not_open_msg => 'هذه الذاكرة ليست مفتوحة للجمهور بعد...';

  @override
  String get lore_unnamed => 'شظية غير مسمى';

  @override
  String get lore_add_btn_limit => 'كتابة شظية ذاكرة جديدة (الحد الأقصى 10)';

  @override
  String get lore_collapse => 'طي الرسالة';

  @override
  String get echo_delete_title => 'حذف التعليق';

  @override
  String get echo_delete_content =>
      'هل أنت متأكد من حذف صدى الزمان هذا؟\nبمجرد الحذف، لن تتمكن من استعادته أبداً!';

  @override
  String get echo_keep => 'احتفاظ';

  @override
  String get echo_clear_success => 'تم مسح صدى الزمان ';

  @override
  String get echo_energy_full_title => 'وصلت طاقة الكون إلى الحد الأقصى';

  @override
  String get echo_energy_full_content =>
      'وصلت طاقة الزمان الخاصة بك إلى الحد الأقصى (3 كحد أقصى)، يرجى حذف تجاربك الزمانية القديمة لتتمكن من فتح سجلات كونية جديدة!';

  @override
  String get echo_write_title => 'اترك صدى الزمان الخاص بك ';

  @override
  String get echo_write_subtitle =>
      'اكتب تجربتك هنا أو اقتباسات محركة للمشاعر!';

  @override
  String get echo_hint =>
      '「حتى لو كانت نهاية العالم، سأحرص على أن تتنفس أولاً...」';

  @override
  String get echo_theme_label => 'اختر إطار الملاحظة:';

  @override
  String get theme_butterfly => 'فراشة';

  @override
  String get theme_sprout => 'برعم';

  @override
  String get theme_star => 'سماء مرصعة بالنجوم';

  @override
  String get theme_planet => 'كوكب';

  @override
  String get echo_publish_btn => 'نشر سجل الزمان';

  @override
  String get echo_wall_title => 'جدار صدى الزمان';

  @override
  String get echo_leave_memory => 'اترك تجربة';

  @override
  String get echo_empty_msg =>
      'لم يترك أي مسافر عبر الزمان سجلاً بعد...\nهل تريد أن تكون الأول؟';

  @override
  String get creator_label => 'المبدع';

  @override
  String get follow_btn => 'متابعة';

  @override
  String get followed_btn => 'تمت المتابعة';

  @override
  String get follow_own_warning => 'لا يمكن للمبدعين متابعة أنفسهم! ';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return ' $playerName تابع $creatorName！';
  }

  @override
  String get mailbox_follow_title => 'حصلت على حارس جديد ';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName تابعكِ للتو!';
  }

  @override
  String get tab_private_profile => 'الملف الشخصي الخاص';

  @override
  String get tab_memory_fragments => 'شظايا الذاكرة';

  @override
  String get tab_time_echoes => 'صدى الزمان';

  @override
  String get chat_free_btn => 'دردشة (مجانية)';

  @override
  String get start_story_btn => 'بدء القصة';

  @override
  String get default_chat_initial => 'هل تريد مني شيئاً؟';

  @override
  String get gallery_title => 'خلفية مكالمة حصرية';

  @override
  String gallery_current_affection(String value) {
    return 'مستوى المودة الحالي: $value';
  }

  @override
  String get gallery_empty => 'لا توجد صور في الألبوم بعد';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'تم تعيين الخلفية إلى «$desc»!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'سيتم فتح القفل عندما يصل مستوى المودة إلى $value!';
  }

  @override
  String get gallery_reset_bg => 'تم استعادة خلفية المكالمة الافتراضية';

  @override
  String get background_story_title => 'قصة اللقاء الأول';

  @override
  String get background_story_empty =>
      'هذه الشخصية غامضة جدًا، ولا توجد قصة لقاء أول بعد...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'تمت متابعة $creatorName';
  }

  @override
  String get mailbox_title => 'صندوق البريد الخاص';

  @override
  String get mailbox_empty => 'صندوق البريد فارغ، اذهبي وانشري شيئاً لجذبه!';

  @override
  String get new_notification => 'إشعار جديد';

  @override
  String get default_he => 'هو';

  @override
  String affection_upgrade_title(String charName) {
    return 'زادت عاطفة $charName تجاهكِ!';
  }

  @override
  String get flower_reward => 'تم الحصول على 5 نقاط زهور';

  @override
  String get affection_quote_lv5 =>
      '「لم أكن أتوقع... أنكِ أصبحتِ مهمة جداً بالنسبة لي. لدرجة أنني... لا أستطيع تخيل عالم بدونكِ.」';

  @override
  String get affection_quote_lv4 =>
      '「أكثر الأشياء حظاً في حياتي، ربما كانت في ذلك اليوم، عندما التفتُّ ورأيتكِ.」';

  @override
  String get affection_quote_lv3 =>
      '「مؤخراً... وجدتُ أن وقت شرودي قد زاد، وعقلي مليء بكِ تماماً.」';

  @override
  String get affection_quote_lv2 =>
      '「بما أنها دعوتكِ، فلا بأس بأن أفرغ القليل من الوقت من أجلكِ.」';

  @override
  String get affection_quote_lv1 =>
      '「أراكِ كثيراً مؤخراً، أشعر... أنني لا أكره هذا المعدل من اللقاءات.」';

  @override
  String get affection_quote_lv0 =>
      '「أوه، أنتِ هنا أيضاً، هل نعتبر هذا نوعاً من القدر العجيب؟」';

  @override
  String get lore_edit_success => 'تم تحديث شظية الذاكرة بنجاح!';

  @override
  String get delete_failed_network =>
      'فشل الحذف، يرجى التحقق من الشبكة أو الصلاحيات.';

  @override
  String get ai_chat_language => 'العربية';

  @override
  String get ai_chat_language_code => 'ar-SA';

  @override
  String get chat_home_title => 'رسائل';

  @override
  String get call_memory_tooltip => 'ذكريات المكالمات';

  @override
  String get login_to_view_chat => 'يرجى تسجيل الدخول لعرض سجل الدردشة';

  @override
  String load_chat_failed(String error) {
    return 'فشل تحميل قائمة الدردشة: $error';
  }

  @override
  String get chat_list_empty => 'غرفة الدردشة فارغة...';

  @override
  String get go_to_encounter => 'اذهب إلى \"لقاء\" لتجد شخصاً تدردش معه!';

  @override
  String confirm_delete_chat(String charName) {
    return 'هل أنت متأكد من حذف المحادثة مع $charName؟';
  }

  @override
  String affection_score_short(String score) {
    return 'مودة $score';
  }

  @override
  String get character_not_found => 'تعذر تحميل بيانات الشخصية، ربما تم حذفها.';

  @override
  String get preparing_chat_room =>
      'جاري تجهيز غرفة الدردشة الحصرية الخاصة بك...';

  @override
  String get rename_chat_title => 'تسمية هذه الذكرى';

  @override
  String get rename_chat_hint =>
      'مثال: تغيير (تشينغ يو) إلى (العد التنازلي للطلاق)';

  @override
  String get save_tag_btn => 'حفظ الوسم';

  @override
  String get room_name_updated => 'تم تحديث اسم الغرفة!';

  @override
  String update_failed(String error) {
    return 'فشل التحديث: $error';
  }

  @override
  String get chat_mode_daily => 'يومي';

  @override
  String get chat_mode_story => 'قصة';

  @override
  String get chat_mode_immersive => 'غامر';

  @override
  String get chat_mode_gemini => 'دردشة';

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
      'تعذر العثور على بيانات الشخصية، يرجى العودة والمحاولة مرة أخرى أو التحقق من الشبكة.';

  @override
  String get chat_jump_success => 'تم الانتقال إلى هذه الذكرى';

  @override
  String get chat_create_room_failed =>
      'يبدو أن الاتصال غير مستقر، فشل إنشاء غرفة الدردشة، يرجى المحاولة مرة أخرى.';

  @override
  String get chat_secret_file_title => 'ملف سري';

  @override
  String get chat_secret_file_desc =>
      'تم أرشفة ملف الروح الخاص بهذه الشخصية أو تحويله إلى صلاحية خاصة، ولا يمكن عرض التفاصيل حالياً.';

  @override
  String get chat_understood => 'فهمت';

  @override
  String chat_egg_unlocked(String title) {
    return 'تم الحصول على ذكرى جديدة: $title';
  }

  @override
  String get chat_egg_saved => 'تمت إضافتها تلقائياً إلى حقيبتك الحصرية';

  @override
  String get chat_points_not_enough_title => 'الزهور غير كافية';

  @override
  String get chat_points_not_enough_desc =>
      'ليس لديك زهور كافية! يرجى الذهاب إلى المتجر لإعادة الشحن.';

  @override
  String chat_call_confirm_title(String name) {
    return 'هل تريد الاتصال بـ $name؟';
  }

  @override
  String get chat_call_rule_1 => 'كل مكالمة ستخصم 20 زهرة';

  @override
  String get chat_call_rule_2 =>
      'مدة المكالمة دقيقة واحدة، إذا لم يكن من السهل التحدث يمكنك التواصل عبر النص';

  @override
  String get chat_call_rule_3 =>
      'يُنصح بارتداء سماعات الرأس لسماع صوته بشكل أوضح';

  @override
  String get chat_call_btn_cancel => 'ليس الآن';

  @override
  String get chat_call_pref_title => 'ضبط تفضيلات المكالمة الخاصة بك';

  @override
  String get chat_call_lang_select => 'اختر لغة المكالمة';

  @override
  String get chat_call_save_memory => 'حفظ ذكرى هذه المكالمة';

  @override
  String get chat_call_save_memory_desc =>
      'يمكنك إعادة الاستماع إليها بعد انتهاء المكالمة';

  @override
  String get chat_call_btn_start => 'بدء المكالمة';

  @override
  String chat_points_shortage(String points) {
    return 'نقاط الزهور غير كافية! لديك حالياً $points نقطة';
  }

  @override
  String get chat_room_not_ready =>
      'غرفة الدردشة ليست جاهزة بعد، يرجى الدخول مرة أخرى.';

  @override
  String get chat_stop_generating_msg => 'تم إيقاف الرد، ولم يتم خصم أي نقاط';

  @override
  String get chat_heartbeat_up => 'نبضات قلبه تتسارع...';

  @override
  String get chat_heartbeat_down => 'نظراته أصبحت باردة...';

  @override
  String get chat_msg_copy => 'نسخ المحتوى';

  @override
  String get chat_msg_copied => 'تم النسخ إلى الحافظة!';

  @override
  String get chat_msg_report => 'الإبلاغ عن هذه الفقرة';

  @override
  String get chat_msg_suggest => 'تقديم اقتراح';

  @override
  String get chat_report_title => 'الإبلاغ عن هذه المحادثة';

  @override
  String get chat_report_lang => 'ظهور لغة أجنبية';

  @override
  String get chat_report_inapp => 'رد غير لائق';

  @override
  String get chat_report_context => 'السياق غير متصل';

  @override
  String get chat_report_other => 'أسباب أخرى';

  @override
  String get chat_report_hint => 'يرجى وصف المشكلة التي واجهتها...';

  @override
  String get chat_report_submit => 'إرسال';

  @override
  String get chat_report_success =>
      ' تم إرسال الإبلاغ، سنقوم بالتعديل في أقرب وقت';

  @override
  String get chat_suggest_title => 'تقديم ملاحظات';

  @override
  String get chat_suggest_hint => 'يرجى كتابة آرائك القيمة...';

  @override
  String get chat_suggest_success => ' شكراً لاقتراحك، سنتعامل معه في أقرب وقت';

  @override
  String get chat_del_warn => 'لا يمكن استعادة الرسائل بعد حذفها.';

  @override
  String get chat_reset_title => 'إعادة ضبط الذاكرة';

  @override
  String get chat_reset_desc =>
      'يرجى اختيار درجة إعادة الضبط:\n\n1. 【الدردشة فقط】: مسح سجل المحادثات مع الاحتفاظ بمستوى المودة.\n2. 【إعادة ضبط كاملة】: العودة بكل شيء إلى الصفر، كما لو كان اللقاء الأول.';

  @override
  String get chat_reset_only_chat => 'سجل الدردشة فقط';

  @override
  String get chat_reset_full => 'إعادة ضبط كاملة';

  @override
  String get chat_reset_full_msg => 'عاد كل شيء إلى البداية، لم يعد يتذكركِ...';

  @override
  String get chat_reset_chat_msg =>
      'تم مسح المحادثات، لكن حبه لكِ لا يزال موجوداً.';

  @override
  String get chat_edit_ai_hint => 'تعديل رده...';

  @override
  String get chat_edit_user_hint => 'يرجى إدخال محتوى جديد...';

  @override
  String chat_no_voice_msg(String name) {
    return 'لا يوجد صوت لـ $name حالياً...';
  }

  @override
  String get chat_poke_btn => 'نكز';

  @override
  String get chat_poke_success =>
      'تم نكز المبدع من أجلكِ! يرجى انتظار توفر صوته قريباً~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'نقاط الزهور غير كافية! تحتاجين إلى $cost نقطة';
  }

  @override
  String get chat_levelup_soulmate => 'توأم الروح';

  @override
  String get chat_levelup_normal => 'ترقية العلاقة!';

  @override
  String get chat_levelup_btn_soulmate => 'نقش في الروح';

  @override
  String get chat_levelup_btn_normal => 'قبول بقلب نابض';

  @override
  String get chat_loc_title => 'إرسال موقع افتراضي';

  @override
  String get chat_loc_custom_btn => 'إرسال موقع مخصص';

  @override
  String get chat_loc_hint => 'أدخل مكاناً آخر... (مثال: في قلبك)';

  @override
  String get chat_loc_1 => 'تحت منزلك';

  @override
  String get chat_loc_2 => 'في المدرسة';

  @override
  String get chat_loc_3 => 'في المقهى الذي مررنا به للتو';

  @override
  String get chat_loc_4 => 'في المتجر';

  @override
  String get chat_interact_title => 'ماذا تريدين أن تفعلي معه؟';

  @override
  String get chat_interact_action => 'نكزات وحركات صغيرة';

  @override
  String get chat_interact_gift => 'أرسلي له هدية صغيرة (تستهلك زهوراً )';

  @override
  String get chat_action_poke => 'نكز الوجنة';

  @override
  String get chat_action_hug => 'طلب حضن';

  @override
  String get chat_action_hand => 'إمساك اليد خلسة';

  @override
  String get chat_dice_btn => 'رمي النرد';

  @override
  String get chat_loading_failed =>
      'فشل تحميل الذكريات، يرجى العودة والمحاولة مرة أخرى.';

  @override
  String get chat_test_mode_msg =>
      'تم تفعيل وضع الاختبار، تدردشي بحرية! (لن يتم حفظ المحادثات)';

  @override
  String get chat_empty_msg => 'ابدئي رحلة مثيرة معه!';

  @override
  String get chat_ai_typing => 'الطرف الآخر يرد الآن...';

  @override
  String get chat_input_hint_default => 'ماذا تريدين أن تقولي له...';

  @override
  String get chat_typing_indicator => 'جاري الكتابة...';

  @override
  String get chat_menu_search => 'البحث في المحادثة';

  @override
  String get chat_menu_gallery => 'ذكريات وخلفيات حصرية';

  @override
  String get chat_menu_aboutme => 'متعلق بي';

  @override
  String get chat_menu_memo => 'مذكرة له';

  @override
  String get chat_menu_period => 'تتبع الدورة الشهرية';

  @override
  String get chat_menu_reset => 'إعادة ضبط الذاكرة';

  @override
  String get chat_search_hint => 'أي محادثة حلوة تريدين استعادتها؟';

  @override
  String get chat_search_empty => 'تعذر العثور على هذه الذكرى';

  @override
  String get chat_search_you => 'أنتِ قلتِ';

  @override
  String get chat_search_him => 'هو قال';

  @override
  String get chat_tool_backpack => 'الحقيبة';

  @override
  String get chat_tool_story => 'ملخص القصة';

  @override
  String get chat_tool_photo => 'صور';

  @override
  String get chat_tool_record => 'تسجيل صوتي';

  @override
  String get chat_tool_profile => 'ملفات شيو غوانغ';

  @override
  String get chat_tool_interact => 'طرق التفاعل';

  @override
  String get chat_record_recording => 'جاري التسجيل...';

  @override
  String get chat_record_start => 'انقري على الميكروفون لبدء التسجيل';

  @override
  String get chat_record_done => 'اكتمل التسجيل';

  @override
  String get chat_mode_daily_desc =>
      'دردشة يومية خفيفة وممتعة، مثل الأصدقاء تماماً!';

  @override
  String get chat_mode_story_desc => 'تقدم القصة مثل الرواية.';

  @override
  String get chat_mode_immersive_desc =>
      'تجربة حسية فائقة، تفاعل عميق بلا قيود.';

  @override
  String get chat_switch_mode_title => 'تبديل وضع الدردشة';

  @override
  String get chat_voice_call => 'مكالمة صوتية';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【حدث نظام】أرسلت $playerName 【$giftName】.';
  }

  @override
  String get rel_title_soulmate => 'توأم الروح/حب عميق';

  @override
  String get rel_title_lover => 'عشق/حبيب حصري';

  @override
  String get rel_title_ambiguous => 'علاقة غامضة/استكشاف متبادل';

  @override
  String get rel_title_friend => 'صديق عادي/بداية الإعجاب';

  @override
  String get rel_title_acquaintance => 'معرفة سطحية/مألوف قليلاً';

  @override
  String get rel_title_stranger => 'غريب/لقاء أول';

  @override
  String get rel_title_tense => 'علاقة متوترة/بداية الانزعاج';

  @override
  String get rel_title_avoiding => 'كالغرباء/تجنب متعمد';

  @override
  String get rel_title_hostile => 'كراهية شديدة/عداء بارد';

  @override
  String get rel_title_nemesis => 'عداوة لا تُغتفر/فراق أبدي';

  @override
  String get rel_msg_soulmate =>
      '「لم أكن أتوقع... أنكِ أصبحتِ مهمة جداً بالنسبة لي. لدرجة أنني... لا أستطيع تخيل عالم بدونكِ.」';

  @override
  String get rel_msg_lover =>
      '「أكثر الأشياء حظاً في حياتي، ربما كانت في ذلك اليوم، عندما التفتُّ ورأيتكِ.」';

  @override
  String get rel_msg_ambiguous =>
      '「مؤخراً... وجدتُ أن وقت شرودي قد زاد، وعقلي مليء بكِ تماماً.」';

  @override
  String get rel_msg_friend =>
      '「بما أنها دعوتكِ، فلا بأس بأن أفرغ القليل من الوقت من أجلكِ.」';

  @override
  String get rel_msg_acquaintance =>
      '「أراكِ كثيراً مؤخراً، أشعر... أنني لا أكره هذا المعدل من اللقاءات.」';

  @override
  String get rel_msg_stranger =>
      '「أوه، أنتِ هنا أيضاً، هل نعتبر هذا نوعاً من القدر العجيب؟」';

  @override
  String chat_edit_char_count(String count) {
    return '$count حرف';
  }

  @override
  String get chat_mysterious_player => 'لاعب غامض';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return 'اللاعب $playerName يتطلع لسماع صوت $characterName، اذهب وقم بتوليده!';
  }

  @override
  String get gift_heart => 'قلب';

  @override
  String get gift_flower => 'زهرة';

  @override
  String get gift_sun => 'شمس';

  @override
  String get gift_confetti => 'فرقعة احتفال';

  @override
  String get gift_coffee => 'قهوة';

  @override
  String get gift_cake => 'كعكة';

  @override
  String get chat_action_poke_prompt => '（مد اللاعب يده فجأة، ونكز وجنتك بمرح）';

  @override
  String get chat_action_hug_prompt =>
      '（فتح اللاعب ذراعيه بحزن طفيف، طالباً عناقاً دافئاً）';

  @override
  String get chat_action_hand_prompt => '（أمسك اللاعب يدك بهدوء تحت الطاولة）';

  @override
  String get chat_menu_send_location => 'إرسال موقع افتراضي';

  @override
  String get weekday_mon => '(الإثنين)';

  @override
  String get weekday_tue => '(الثلاثاء)';

  @override
  String get weekday_wed => '(الأربعاء)';

  @override
  String get weekday_thu => '(الخميس)';

  @override
  String get weekday_fri => '(الجمعة)';

  @override
  String get weekday_sat => '(السبت)';

  @override
  String get weekday_sun => '(الأحد)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return 'تم الحصول على ذكرى جديدة: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'تمت إضافتها تلقائياً إلى حقيبته الخاصة';

  @override
  String get chat_profile_updated_msg =>
      'تم تحديث ملف شيو غوانغ! سيتذكر أحدث إعداداتكِ';

  @override
  String get comment_loading_author => 'جاري التحميل...';

  @override
  String comment_post_failed(String error) {
    return 'فشل التعليق، يرجى التحقق من اتصال الشبكة: $error';
  }

  @override
  String get comment_delete_confirm_desc =>
      'هل أنت متأكد من رغبتك في حذف هذا التعليق نهائياً؟';

  @override
  String get comment_delete_failed => 'فشل الحذف، يرجى التحقق من اتصال الشبكة';

  @override
  String get comment_identity_title => 'اختر هوية المعلق';

  @override
  String get comment_identity_myself => 'أنا نفسي';

  @override
  String get comment_report_title => 'تأكيد الإبلاغ';

  @override
  String get comment_report_rules_title => 'قواعد الإبلاغ عن التعليقات';

  @override
  String get comment_report_rules_desc =>
      '1⃣ المخالفة الأولى: تحذير من النظام وتسجيل مخالفة واحدة.\n2⃣ المخالفة الثانية: حظر من التعليق لمدة يوم واحد.\n3⃣ المخالفات المتكررة: حظر وظيفة الإبلاغ لمدة 14 يوماً وتقليل وضوح التعليقات.\n\nلأصحاب الإساءات الجسيمة:\nحظر التفاعل مع الشخصيات لمدة يوم واحد، وسيتم نشر المعرف الخاص بك في لوحة الإعلانات لمدة 3 أيام (يُحظر تغيير المعرف خلال هذه الفترة).\n\nبعد إرسال الإبلاغ، سيتم إرسال نتيجة المراجعة النهائية إليك بشكل منفصل عبر [البريد داخل اللعبة].\nيرجى تبادل الاحترام والإبلاغ بعقلانية.';

  @override
  String get comment_report_understood => 'لقد فهمت';

  @override
  String get comment_report_confirm_desc =>
      'هل أنت متأكد من رغبتك في الإبلاغ عن هذا التعليق؟\nقد تتعرض للعقوبة في حال الإبلاغ الكيدي.';

  @override
  String get comment_report_submit_btn => 'تأكيد الإبلاغ';

  @override
  String get comment_report_success =>
      'شكراً لإبلاغك، سنتحقق من الأمر في أقرب وقت ممكن!';

  @override
  String get comment_report_failed =>
      'فشل إرسال الإبلاغ، يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get comment_option_delete => 'حذف التعليق';

  @override
  String get comment_option_report => 'الإبلاغ عن التعليق';

  @override
  String comment_time_days_ago(String days) {
    return 'قبل $days أيام';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return 'قبل $hours ساعة';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return 'قبل $mins دقيقة';
  }

  @override
  String get comment_time_just_now => 'الآن';

  @override
  String get comment_sheet_title => 'تعليق';

  @override
  String get comment_empty_state => 'لا توجد تعليقات بعد، كن أول من يعلق!';

  @override
  String get comment_reply_btn => 'رد';

  @override
  String comment_replying_to(String name) {
    return 'جاري الرد على @$name';
  }

  @override
  String comment_input_hint(String name) {
    return 'التعليق بصفتك $name...';
  }

  @override
  String char_story_expect(String pronoun) {
    return 'أتطلع للقصة مع $pronoun...';
  }

  @override
  String get common_update_failed => 'فشل التحديث، يرجى التحقق من الشبكة';

  @override
  String get char_edit_fragment => 'تعديل الشظية';

  @override
  String char_dislikes(String dislikes) {
    return 'يكره: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return 'يحب: $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age سنة | $job';
  }

  @override
  String get common_got_it => 'مفهوم';

  @override
  String get common_add_failed => 'فشلت الإضافة، يرجى التحقق من الشبكة';

  @override
  String common_delete_failed_with_err(String error) {
    return 'فشل الحذف، يرجى التحقق من حالة الشبكة: $error';
  }

  @override
  String get char_exclusive_guardian => 'حارس حصري';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return 'أُعجب $playerName بـ $charName!';
  }

  @override
  String chat_translation_prefix(String content) {
    return '【ترجمة】$content (هذا هو المحتوى العاطفي المترجم)';
  }

  @override
  String get player_default_nickname => 'مسافر';

  @override
  String get moment_create_title => 'نشر تحديث جديد';

  @override
  String get moment_create_post_btn => 'نشر';

  @override
  String get moment_create_hint => 'شارك شيئاً جديداً...';

  @override
  String get moment_create_error_empty => 'يلزم وجود نص أو صورة على الأقل!';

  @override
  String get moment_create_error_failed => 'فشل النشر، يرجى المحاولة لاحقاً';

  @override
  String get moment_create_visibility_public => 'عام (مرئي للجميع)';

  @override
  String get moment_create_visibility_private => 'خاص (مرئي للأصدقاء فقط)';

  @override
  String chat_player_sent_location(String location) {
    return '(أرسل اللاعب موقعه: $location)';
  }

  @override
  String get chat_you => 'أنتِ';

  @override
  String get chat_opponent => 'الخصم';

  @override
  String chat_dice_duel_result(String name) {
    return '【حدث نظام】مبارزة النرد مع $name! ظهرت النتيجة...';
  }

  @override
  String get chat_loading_status => 'جاري التحميل...';

  @override
  String chat_error_load_msg(String error) {
    return 'فشل تحميل الرسالة: $error';
  }

  @override
  String get chat_voice_msg_label => 'رسالة صوتية';

  @override
  String chat_special_story_trigger(String title) {
    return '【فتح قصة خاصة: $title】';
  }

  @override
  String common_edit_failed(String error) {
    return 'فشل التعديل: $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'فشل إعادة الضبط: $error';
  }

  @override
  String get chat_default_greeting => 'مرحباً...';

  @override
  String get chat_memory_cleared => 'تم مسح الذاكرة بالكامل';

  @override
  String get chat_history_reset => 'تم إعادة ضبط المحادثة';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '【 ملف شيو غوانغ الحصري - $name 】\n━━━━━━━━━━━━━━━━━━\nالاسم: $identity\nتاريخ الميلاد: $birthday\nالطول: $height\nالمظهر: $appearance\nالمهنة: $job\n\n【 عن شظايا روحها 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '【 ملف شيو غوانغ الحصري 】\n━━━━━━━━━━━━━━━━━━\nالاسم: $nickname\nتاريخ الميلاد: $birthday\n\nلم يتم فتح بيانات الشخصية الأخرى بعد...\n(أكملي الملف دعينا يجعله يعرفك أكثر في العالم الموازي! )\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => 'ملف غير مسمى';

  @override
  String get chat_default_player_name => 'لاعب';

  @override
  String get error_system_confusion =>
      'حدث ارتباك بسيط في النظام، يرجى المحاولة مرة أخرى.';

  @override
  String get error_msg_send_failed =>
      'فشل إرسال الرسالة، يرجى المحاولة مرة أخرى.';

  @override
  String get error_system_busy => 'النظام مشغول، يرجى المحاولة لاحقاً.';

  @override
  String get error_network_unavailable =>
      'لا يمكن الاتصال حالياً، يرجى إعادة المحاولة.';

  @override
  String chat_call_ended(String name, String time) {
    return 'انتهت المكالمة، تحدثت مع $name لمدة $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return 'قصة حصرية: $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'هذه ذكرى مخفية حصرية لكِ ولـ $name...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return 'تم فتح ذكرى حصرية حول «$keyword» بهدوء...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '【تفعيل حدث مخفي: $title】\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '…… (ينظر إليكِ بهدوء، وكأنه ينتظركِ لتتحدثي أولاً)';

  @override
  String get chat_new_room_created => 'تم إنشاء غرفة دردشة جديدة';

  @override
  String portfolio_title(String nickname) {
    return 'مجموعة أعمال $nickname';
  }

  @override
  String get enter_secret_studio => 'الدخول إلى الاستوديو السري الخاص بي';

  @override
  String get no_public_character_mine =>
      'لم تقومي بنشر أي شخصيات عامة بعد!\nاذهبي إلى الاستوديو للابتكار';

  @override
  String get no_public_character_other =>
      'هذا المبدع لم يقم بنشر أي شخصيات بعد...';

  @override
  String get delete_draft_title => 'حذف المسودة';

  @override
  String get confirm_delete_draft_msg =>
      'هل أنت متأكد من حذف هذه الشخصية غير المكتملة؟\n(لا يمكن التراجع بعد الحذف)';

  @override
  String get draft_cleared_success => 'تم تنظيف المسودة';

  @override
  String get login_required_for_studio =>
      'يرجى تسجيل الدخول أولاً لدخول الاستوديو!';

  @override
  String get my_secret_studio_title => 'الاستوديو السري الخاص بي';

  @override
  String get create_new_character_btn => 'ابتكار شخصية جديدة';

  @override
  String get unnamed_draft => 'مسودة غير مسماة';

  @override
  String get click_to_edit_story => 'انقر لمواصلة تحرير قصته...';

  @override
  String get label_draft => 'مسودة';

  @override
  String get studio_empty_title => 'الاستوديو فارغ حالياً';

  @override
  String get studio_empty_subtitle =>
      'انقر على الزاوية السفلية للبدء في ابتكار شخصيتك الأولى!';

  @override
  String get common_no_changes => 'لا توجد أي تغييرات';

  @override
  String get moment_updated_success => 'تم تحديث المنشور!';

  @override
  String common_save_failed(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get moment_edit_title => 'تعديل المنشور';

  @override
  String get action_change_image => 'تغيير الصورة';

  @override
  String get action_remove_image => 'إزالة الصورة';

  @override
  String get moment_delete_confirm_title =>
      'هل أنتِ متأكدة من حذف هذا المنشور؟';

  @override
  String get moment_delete_confirm_content =>
      'بمجرد الحذف، ستختفي ذكرى \'لحظات الأصدقاء\' هذه!';

  @override
  String get action_confirm_delete => 'تأكيد الحذف';

  @override
  String get friend_unknown => 'صديق مجهول';

  @override
  String moment_like_yours(String nickname) {
    return 'يعتقد $nickname أن منشوركِ رائع جداً!';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return 'يعتقد $nickname أن $authorName ساحر جداً، وقد وضع إعجاباً!';
  }

  @override
  String get moment_like_success => 'تم إرسال نبضات قلبكِ!';

  @override
  String get moment_notification_new_like => 'إعجاب جديد!';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return 'قام $nickname بذكر @$name في منشور!';
  }

  @override
  String get moment_detail_title => 'تفاصيل المنشور';

  @override
  String get moment_not_found => 'يبدو أن هذا المنشور قد اختفى...';

  @override
  String get moment_comment_title => 'تعليقات اللحظات';

  @override
  String get moment_comment_empty => 'لا توجد تعليقات بعد، كوني أول من يعلق!';

  @override
  String moment_replying_to(String name) {
    return 'جارٍ الرد على @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return 'الرد على @$name...';
  }

  @override
  String get moment_leave_comment_hint => 'اتركي ردكِ...';

  @override
  String get moment_delete_permanent_confirm =>
      'سيتم حذف هذا المنشور نهائياً، هل أنت متأكد؟';

  @override
  String get moment_action_delete => 'حذف المنشور';

  @override
  String get moment_action_report => 'إبلاغ عن هذا المنشور';

  @override
  String get moment_action_share => 'مشاركة هذا المنشور';

  @override
  String get moment_forward_hint => 'إعادة توجيه هذا المنشور إلى شخصية...';

  @override
  String moment_reply_private(String name) {
    return 'رد برسالة خاصة إلى $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return 'لنذهب للدردشة مع $name مع هذا المنشور!';
  }

  @override
  String get moment_share_to_apps => 'مشاركة مع تطبيقات أخرى';

  @override
  String moment_likes_label(String count) {
    return '$count أوراق شجر';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】تعال وشاهد منشور $author: $content\n\nحمل الآن وابدأ وقتك الحصري: $appLink';
  }

  @override
  String get moment_forward_title => 'إعادة توجيه إلى الشخصية التي تدردش معها';

  @override
  String get moment_forward_empty_state =>
      'ليس لديك أي شخصيات تدردش معها حالياً!\nاذهبي إلى الردهة وابحثي عن شخص مميز';

  @override
  String moment_forward_template(String author, String content) {
    return '【تمت إعادة توجيه منشور】\nالمؤلف: $author\nالمحتوى: $content';
  }

  @override
  String moment_forward_success(String name) {
    return 'تمت مشاركتها بهدوء مع $name!';
  }

  @override
  String get action_send => 'إرسال';

  @override
  String get memo_delete_confirm =>
      'هل أنت متأكد من حذف هذه المذكرة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get memo_add_title => 'إضافة مذكرة';

  @override
  String get memo_edit_title => 'تعديل المذكرة';

  @override
  String memo_hint_text(String name) {
    return 'ماذا تريد أن تدون عن $name؟';
  }

  @override
  String get memo_label_reminder_date => 'تاريخ التذكير:';

  @override
  String get memo_action_save => 'حفظ المذكرة';

  @override
  String get memo_error_empty_content => 'لا يمكن أن يكون المحتوى فارغاً!';

  @override
  String memo_list_title(String name) {
    return 'مذكرات مع $name';
  }

  @override
  String get memo_empty_state =>
      'لا توجد أي مذكرات بعد!\nانقر على الزاوية العلوية لإضافة واحدة جديدة!';

  @override
  String memo_reminder_date_display(String date) {
    return 'يوم التذكير: $date';
  }

  @override
  String get daily_gift_title => 'هدية الزمن اليومية';

  @override
  String daily_login_welcome(String appName, String amount) {
    return 'مرحباً بك مرة أخرى في «$appName»!\nسجلي دخولك اليوم للحصول على $amount من نقاط لغة الزهور.';
  }

  @override
  String get title_daily_check_in => 'تسجيل الدخول اليومي';

  @override
  String success_claim_reward(String amount) {
    return 'تم استلام $amount من نقاط لغة الزهور بنجاح!';
  }

  @override
  String get error_claim_failed =>
      'فشل الاستلام، يرجى التحقق من الشبكة والمحاولة مرة أخرى.';

  @override
  String get action_claim_now => 'استلم الآن';

  @override
  String get common_or => 'أو';

  @override
  String get title_language_settings => 'إعدادات اللغة';

  @override
  String get app_name => 'ليانليان شيغوانغ';

  @override
  String get login_slogan => 'ابدئي وقتك الحصري';

  @override
  String get login_with_google => 'تسجيل الدخول باستخدام Google';

  @override
  String get login_with_apple => 'تسجيل الدخول عبر Apple';

  @override
  String get login_with_facebook => 'تسجيل الدخول باستخدام Facebook';

  @override
  String get login_with_email =>
      'تسجيل الدخول بحساب ليانليان (البريد الإلكتروني)';

  @override
  String get title_contact_us_heading => 'نحن نقدر اقتراحاتك جداً!';

  @override
  String get desc_contact_us_body =>
      'يرجى كتابة أفكارك هنا لمساعدتنا في تحسين اللعبة.';

  @override
  String get error_feedback_empty => 'لا يمكن أن يكون محتوى الاقتراح فارغاً!';

  @override
  String get email_subject_feedback =>
      'Lianlian Shiguang - اقتراحات وتعليقات اللاعبين';

  @override
  String get msg_email_app_not_found_copied =>
      'تعذر فتح تطبيق البريد تلقائياً، تم نسخ البريد الإلكتروني الرسمي لك!';

  @override
  String get title_contact_us => 'اتصل بنا';

  @override
  String get desc_contact_us =>
      'نحن نقدر اقتراحاتك جداً!\nيرجى كتابة أفكارك هنا لمساعدتنا في تحسين اللعبة.';

  @override
  String get hint_enter_feedback => 'يرجى إدخال اقتراحك هنا...';

  @override
  String get action_send_via_email => 'إرسال عبر البريد الإلكتروني';

  @override
  String get error_email_password_empty =>
      'لا يمكن أن يكون البريد الإلكتروني وكلمة المرور فارغين!';

  @override
  String get auth_error_default => 'حدث خطأ، يرجى المحاولة لاحقاً.';

  @override
  String get auth_error_user_not_found =>
      'لم يتم العثور على هذا البريد الإلكتروني، يرجى التسجيل أولاً!';

  @override
  String get auth_error_wrong_password =>
      'كلمة المرور خاطئة، يرجى المحاولة مرة أخرى!';

  @override
  String get auth_error_email_in_use =>
      'تم تسجيل هذا البريد الإلكتروني مسبقاً! يرجى تسجيل الدخول مباشرة.';

  @override
  String get auth_error_weak_password =>
      'كلمة المرور ضعيفة جداً، يرجى إدخال 6 أحرف على الأقل!';

  @override
  String get auth_error_invalid_email => 'تنسيق البريد الإلكتروني غير صحيح!';

  @override
  String get title_welcome_back => 'مرحباً بعودتك';

  @override
  String get title_register_account => 'تسجيل حساب حصري';

  @override
  String get label_email => 'البريد الإلكتروني';

  @override
  String get label_password => 'كلمة المرور';

  @override
  String get action_login => 'تسجيل الدخول';

  @override
  String get action_register => 'تسجيل';

  @override
  String get prompt_no_account => 'ليس لديك حساب بعد؟ انقر هنا للتسجيل';

  @override
  String get prompt_has_account => 'لديك حساب بالفعل؟ انقر هنا لتسجيل الدخول';

  @override
  String get error_nickname_empty => 'لا يمكن أن يكون اللقب فارغاً!';

  @override
  String get profile_saved_success => 'تم حفظ الملف الشخصي!';

  @override
  String get error_id_empty => 'لا يمكن أن يكون المعرف (ID) فارغاً!';

  @override
  String get error_id_too_long => 'لا يمكن أن يتجاوز طول المعرف 10 أحرف!';

  @override
  String get error_id_already_used =>
      'هذا المعرف مستخدم بالفعل، يرجى اختيار واحد آخر!';

  @override
  String profile_save_failed(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get draft_saved_success_msg =>
      'حسناً! تم حفظه في المسودات لك، يمكنك العودة للتعديل في أي وقت!';

  @override
  String get dialog_reminder_title => 'تذكير';

  @override
  String get warning_id_not_edited =>
      'لم يتم تعديل المعرف الحصري بعد، هل أنت متأكد من رغبتك في الحفظ الآن؟';

  @override
  String get action_continue_editing => 'متابعة التعديل';

  @override
  String get action_edit_later => 'التعديل لاحقاً';

  @override
  String get action_edit_later_short => 'تعديل لاحقاً';

  @override
  String get action_cancel_changes => 'إلغاء التغييرات';

  @override
  String get error_birthdate_locked =>
      'تم تعيين تاريخ الميلاد ولا يمكن تغييره!';

  @override
  String get action_select_avatar => 'اختيار صورة شخصية';

  @override
  String get action_choose_from_gallery => 'اختيار من المعرض';

  @override
  String get title_adjust_avatar => 'ضبط صورتك الشخصية';

  @override
  String get avatar_updated_success => 'تم تحديث صورتك الشخصية';

  @override
  String get title_create_profile => 'إنشاء ملفك الشخصي';

  @override
  String get title_edit_profile => 'تعديل الملف الشخصي';

  @override
  String get label_your_nickname => 'لقبك';

  @override
  String get label_player_exclusive_id => 'المعرف الحصري للاعب';

  @override
  String get msg_id_locked => 'المعرف مقفل ولا يمكن تغييره مرة أخرى.';

  @override
  String get msg_id_change_chance =>
      'لديك فرصة واحدة مجانية لتغيير المعرف الخاص بك.';

  @override
  String get action_select_birthdate => 'يرجى تحديد تاريخ الميلاد';

  @override
  String label_birthdate(String date) {
    return 'تاريخ الميلاد: $date';
  }

  @override
  String get msg_birthdate_immutable => 'لا يمكن تغيير يوم الميلاد بعد تعيينه';

  @override
  String get action_start_journey => 'بدء رحلة الزمن';

  @override
  String get action_add_image => 'إضافة صورة';

  @override
  String moment_like_self(String nickname) {
    return 'يعتقد $nickname أن منشوركِ رائع جداً!';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return 'يعتقد $nickname أن $authorName ساحر جداً، وقد وضع إعجاباً!';
  }

  @override
  String get task_social_tour_complete =>
      'اكتملت مهمة الجولة الاجتماعية! تذكر استلام الزهور!';

  @override
  String get wall_title_shiguang => 'جدار شياو غوانغ';

  @override
  String get wall_tab_explore => 'استكشاف';

  @override
  String get wall_tab_exclusive => 'حصري';

  @override
  String get more_options => 'المزيد من الخيارات';

  @override
  String get delete_warning => 'بعد الحذف، لن يمكن استعادة المنشور';

  @override
  String get delete_success => 'تم الحذف بنجاح';

  @override
  String get notification_new_comment => 'تعليق جديد!';

  @override
  String notification_like_from_sender(String senderName) {
    return 'قام $senderName بالإعجاب بمنشوركِ!';
  }

  @override
  String get empty_public_moments_prompt =>
      'المكان فارغ حالياً،\nانشري أول منشور عام لكِ!';

  @override
  String get empty_private_moments_prompt =>
      'لا توجد لحظات في دائرة الأصدقاء بعد،\nاذهبي واصنعي ذكريات معه!';

  @override
  String get profile_archived_or_deleted_message =>
      'تم أرشفة ملف الروح هذا من قبل المبدع، أو جعله خاصاً، أو تلاشى في تيار الزمن...\n\nربما في كون موازٍ، ستتاح لكما فرصة اللقاء مرة أخرى.';

  @override
  String get leave_silently => 'غادري بصمت';

  @override
  String get character_post_schedule => 'جدولة منشورات الشخصية';

  @override
  String get creator_self => 'المبدع نفسه';

  @override
  String get post_identity_prompt => 'بأي هوية ستنشرين اليوم؟';

  @override
  String get identity_creator => 'هوية المبدع';

  @override
  String get identity_character => 'هوية الشخصية';

  @override
  String get decide_post_time_prompt => 'ساعديهم في تحديد وقت النشر!';

  @override
  String get auto_post_schedule_hint =>
      'عند التفعيل، سيتم نشر المنشورات اليومية تلقائياً في الوقت المحدد\n( نصيحة: حددي أوقاتاً غير دقيقة لتظهر وكأنها من شخص حقيقي!)';

  @override
  String get no_characters_created_yet => 'لم تقومي بإنشاء أي شخصية بعد!';

  @override
  String time_hour(String hour) {
    return 'الساعة $hour';
  }

  @override
  String time_minute(String minute) {
    return 'الدقيقة $minute';
  }

  @override
  String get empty_public_moments_short => 'لا توجد منشورات عامة حالياً';

  @override
  String get empty_private_moments_short => 'دائرة الأصدقاء هادئة حالياً';

  @override
  String get my_created_characters => 'شخصياتي المبتكرة';

  @override
  String get no_characters_yet => 'لم يتم إنشاء أي شخصيات بعد';

  @override
  String play_count_display(int count) {
    return 'عدد مرات اللعب: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return 'تقويم اهتمام $characterName';
  }

  @override
  String get care_calendar_greeting => 'كيف حال مزاجك اليوم؟';

  @override
  String get care_calendar_save_btn => 'احفظي السجل، ودعيه يعتني بكِ';

  @override
  String get care_calendar_delete_confirm => 'هل تريدين حذف هذا السجل؟';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName: \"لقد سجلت كل شيء، لقد مررتِ بأيام صعبة، سأكون بجانبكِ دائماً.\"';
  }

  @override
  String get daily_gift_success => 'تم استلام الهدية اليومية بنجاح!';

  @override
  String get check_in_fail_network =>
      'فشل تسجيل الدخول، يرجى التحقق من اتصال الشبكة';

  @override
  String task_completed(String taskName) {
    return 'تم إنجاز المهمة: $taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return 'تم بنجاح استلام $rewardAmount زهرة من «$taskName»!';
  }

  @override
  String claim_failed_error(String e) {
    return 'فشل الاستلام: $e';
  }

  @override
  String get tab_heartbeat_diary => 'مذكرات نبض القلب';

  @override
  String get tab_daily_chit_chat => 'دردشة يومية';

  @override
  String get task_desc_chat_3_times =>
      'الدردشة مع الشخصية 3 مرات في الوضع اليومي';

  @override
  String get tab_story_progression => 'تقدم القصة';

  @override
  String get task_desc_story_1_time => 'أكمل تفاعل واحد في وضع القصة';

  @override
  String get tab_social_tour => 'جولة اجتماعية';

  @override
  String get task_like_three_moments =>
      'أعجبي بـ 3 من اللحظات للحصول على أوراق الشجر';

  @override
  String get btn_claimed => 'تم الاستلام';

  @override
  String get btn_claim => 'استلام';

  @override
  String get btn_incomplete => 'غير مكتمل';

  @override
  String get network_unstable_retry =>
      'اتصال الشبكة غير مستقر، يرجى المحاولة لاحقاً';

  @override
  String get title_time_travel => 'السفر عبر الزمن';

  @override
  String get select_chat_mode => 'اختر وضع الدردشة';

  @override
  String get mode_chat => 'دردشة';

  @override
  String get mode_daily_desc => 'دردشة غير رسمية للحفاظ على الرابطة';

  @override
  String get mode_story_desc => 'تعمق في القصة لتجربة غامرة';

  @override
  String get greeting_hello => 'مرحباً!';

  @override
  String get greeting_default_daily => 'هل تبحث عني؟';

  @override
  String get title_personal_homepage => 'الصفحة الشخصية';

  @override
  String get title_time_letters => 'رسائل الزمن';

  @override
  String get status_signed_in_today => 'تم تسجيل الدخول اليوم';

  @override
  String get status_signing_in => 'جارٍ تسجيل الدخول...';

  @override
  String get status_daily_sign_in => 'تسجيل الدخول اليومي (+10 زهور)';

  @override
  String get toast_id_copied => 'تم نسخ المعرّف!';

  @override
  String get hint_click_avatar_to_edit =>
      'انقر على الصورة الرمزية لتعديل الملف الشخصي';

  @override
  String get title_my_friends => 'أصدقائي';

  @override
  String get action_show_all => 'عرض الكل';

  @override
  String get empty_no_characters_created => 'لم تقم بإنشاء أي شخصية بعد.';

  @override
  String get common_close => 'إغلاق';

  @override
  String get search_companion_title => 'البحث عن رفيق الزمن';

  @override
  String get search_name_placeholder => 'أدخل اسمه...';

  @override
  String get search_no_match_hint => 'تعذر العثور على الشخصية، جرب اسماً آخر؟';

  @override
  String character_info_full(String age, String occupation) {
    return '$age عاماً | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age عاماً';
  }

  @override
  String get empty_state_warmth =>
      'لا يزال الدفء المتبقي من الزمان والمكان باقياً هنا...';

  @override
  String get error_login_required_add_friend =>
      'الرجاء تسجيل الدخول أولاً لإضافة أصدقاء!';

  @override
  String get dialog_title_remove_friend => 'تأكيد إزالة الصديق';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return 'هل أنت متأكد من إزالة $characterName من قائمة الأصدقاء؟';
  }

  @override
  String get action_remove => 'إزالة';

  @override
  String snackbar_friend_removed(String characterName) {
    return 'تمت إزالة $characterName من الأصدقاء';
  }

  @override
  String get action_remove_friend => 'إزالة الصديق';

  @override
  String get dialog_title_block => 'تأكيد الحظر';

  @override
  String dialog_msg_block(String characterName) {
    return 'بعد الحظر، لن ترى أي معلومات عن $characterName مرة أخرى. هل أنت متأكد من الحظر؟';
  }

  @override
  String snackbar_blocked(String characterName) {
    return 'تم حظر $characterName';
  }

  @override
  String get action_block_character => 'حظر هذه الشخصية';

  @override
  String dialog_title_report(String characterName) {
    return 'الإبلاغ عن $characterName';
  }

  @override
  String get input_hint_report_reason => 'الرجاء إدخال سبب الإبلاغ...';

  @override
  String get action_submit => 'إرسال';

  @override
  String get snackbar_report_success =>
      'شكراً لإبلاغك، سنقوم بمراجعته في أقرب وقت ممكن.';

  @override
  String get snackbar_report_fail => 'فشل الإرسال، يرجى المحاولة لاحقاً';

  @override
  String get action_report_character => 'الإبلاغ عن هذه الشخصية';

  @override
  String get title_meet_him => 'التقي بمن يعجبك';

  @override
  String text_character_count(int count) {
    return 'عدد الشخصيات: $count';
  }

  @override
  String get msg_no_more_encounters_today => 'هذا كل شيء للقاءات اليوم!';

  @override
  String get msg_check_new_encounters =>
      'تحققي مرة أخرى لترين إن كانت هناك لقاءات جديدة!';

  @override
  String get action_refresh => 'تحديث';

  @override
  String get tab_friends => 'الأصدقاء';

  @override
  String get msg_mysterious_profile => 'هذا الشخص غامض جداً، لم يترك أي شيء...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age عاماً | $identities';
  }

  @override
  String get snackbar_operation_failed => 'فشلت العملية، يرجى المحاولة لاحقاً';

  @override
  String get action_view_translation => 'عرض الترجمة';

  @override
  String get label_translation_result => 'نتيجة الترجمة:';

  @override
  String get errorWebPageUnavailable =>
      'يتعذر فتح صفحة الويب مؤقتاً، يرجى المحاولة لاحقاً';

  @override
  String get resetAppearanceTitle => 'هل تريد إعادة تعيين المظهر؟';

  @override
  String get resetAppearanceWarning =>
      'سيؤدي هذا إلى إزالة صورة الخلفية والألوان التي اخترتها بعناية!';

  @override
  String get appearanceRestored => 'تمت استعادة المظهر الافتراضي';

  @override
  String get confirmReset => 'تأكيد إعادة التعيين';

  @override
  String get resetToDefaultAppearance => 'استعادة المظهر الافتراضي';

  @override
  String get clearCustomSettings => 'مسح جميع الألوان وصور الخلفية المخصصة';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get contactDescription =>
      'أخبرنا بأي أفكار لديك أو أبلغنا عن أي أخطاء';

  @override
  String get vibrationHapticTitle => 'اهتزاز نبض القلب';

  @override
  String get vibrationHapticDescription =>
      'تشغيل اهتزاز الهاتف عند تغير مستوى الإعجاب بشكل كبير';

  @override
  String get splash_loading_universe =>
      'جارٍ إيقاظ عالم \'Lianlian ShiGuang\'...';

  @override
  String get shop_title => 'متجر الزهور';

  @override
  String get shop_current_points_label => 'نقاط الزهور المملوكة حالياً';

  @override
  String get shop_tab_top_up => 'شحن النقاط';

  @override
  String get shop_tab_history => 'سجل المعاملات';

  @override
  String get shop_empty_history => 'لا توجد سجلات للزهور حتى الآن!';

  @override
  String get shop_unknown_item => 'عنصر غير معروف';

  @override
  String get shop_first_purchase_bonus => 'مضاعفة الشراء الأول!';

  @override
  String get story_summary_title => 'قصتنا';

  @override
  String get story_summary_empty_content => 'محتوى الملخص فارغ.';

  @override
  String get story_summary_deleted_toast => 'تم إزالة هذه الذكرى';

  @override
  String story_summary_empty_list(String name) {
    return 'قصتكم لم تبدأ بعد...\nتحدثوا أكثر، ودعي $name\nيكتب أول فصل من ذكرياتكم!';
  }

  @override
  String get gallery_photo_edit_title => 'تعديل إعدادات الصورة';

  @override
  String get gallery_photo_edit_desc => 'اسم الصورة/الوصف';

  @override
  String get gallery_photo_edit_req =>
      'فتح مستوى الإعجاب (الضبط على 0 سيحولها إلى صورة شخصية)';

  @override
  String get reset_to_default => 'استعادة الافتراضي';

  @override
  String get reset_bg_title => 'استعادة الخلفية الافتراضية';

  @override
  String get reset_bg_content =>
      'هل أنتِ متأكدة من إلغاء الصورة الحصرية والعودة إلى الخلفية الافتراضية للموضوع؟';

  @override
  String get reset_bg_success => 'تمت استعادة الخلفية الافتراضية';

  @override
  String get confirm_reset => 'تأكيد الاستعادة';

  @override
  String selectedMessagesCount(int count) {
    return 'تم اختيار $count';
  }

  @override
  String get screenshotShare => 'مشاركة لقطة الشاشة';

  @override
  String exclusiveMomentsWith(String name) {
    return 'لحظات حصرية مع $name';
  }

  @override
  String get downloadToUnlock =>
      'حملي \'Lianlian ShiGuang\' لفتح الرومانسية الحصرية';

  @override
  String get exclusiveMomentsGenerated => 'تم إنشاء اللحظات الحصرية';

  @override
  String get selectAgain => 'اختر مرة أخرى';

  @override
  String get downloadAndShare => 'تنزيل ومشاركة';

  @override
  String inviteToMeet(String name) {
    return 'تعالي إلى \'Lianlian ShiGuang\' لمقابلة $name الخاص بكِ!';
  }

  @override
  String get shop_log_monthly_card =>
      'تفعيل: عقد النجوم (نقاط فورية من البطاقة الشهرية)';

  @override
  String shop_log_top_up_double(int points) {
    return 'شحن: $points نقطة (تشمل مضاعفة الشراء الأول )';
  }

  @override
  String shop_log_top_up_normal(int points) {
    return 'شحن: $points نقطة';
  }

  @override
  String get shop_purchase_success_title => 'تمت عملية الشراء بنجاح!';

  @override
  String shop_purchase_success_body(int points) {
    return 'تم إضافة $points زهرة إلى حسابكِ.';
  }

  @override
  String get shop_purchase_success_double_bonus =>
      'تهانينا! تم تفعيل مكافأة مضاعفة الشراء الأول!';

  @override
  String get shop_purchase_awesome => 'رائع';

  @override
  String get shop_purchase_failed_title => 'فشلت عملية الشراء أو تم إلغاؤها';

  @override
  String shop_purchase_failed_body(String errorCode) {
    return 'لم يتم خصم أي مبلغ.\n\n(رمز الخطأ: $errorCode)';
  }

  @override
  String get shop_monthly_card_name => '【Lianlian ShiGuang: عقد النجوم】';

  @override
  String shop_monthly_card_status_active(int days) {
    return 'عقد ساري المفعول: متبقي $days يوم';
  }

  @override
  String get shop_monthly_card_status_inactive =>
      'افتحي مكافأة زيادة النجوم لمدة 30 يوماً الآن';

  @override
  String get shop_monthly_card_limit_reached => 'تم الوصول إلى الحد الأقصى';

  @override
  String get shop_monthly_card_promo_desc =>
      'احصلي على 250 زهرة فوراً، واجني 10 زهور يومياً';

  @override
  String get task_monthly_title => 'عقد النجوم: المزايا اليومية';

  @override
  String get task_monthly_locked => 'مغلق';

  @override
  String get task_monthly_subtitle_active =>
      'توزيع مزايا البطاقة الشهرية الحصرية ';

  @override
  String get task_monthly_subtitle_inactive =>
      'افتحي بطاقة 【عقد النجوم】 الشهرية لتفعيل هذه المهمة';

  @override
  String get task_monthly_log_name => 'المزايا اليومية للبطاقة الشهرية';

  @override
  String get profile_id_locked => 'تم قفل المعرّف الخاص';

  @override
  String get profile_copy_id => 'انقر لنسخ المعرّف';

  @override
  String get referral_log_newbie_reward =>
      'دعوة النجوم: مكافأة تسجيل القادمين الجدد';

  @override
  String get referral_log_inviter_reward =>
      'دعوة النجوم: مكافأة تحقيق الصديق للهدف';

  @override
  String get referral_success_title => 'تم فتح دعوة النجوم!';

  @override
  String get referral_success_content =>
      'تهانينا! لقد نجحتِ في تبادل 15 جملة من الحوار العميق مع الشخصية!\n\nتم إرسال \'مكافأة تسجيل القادمين الجدد 50 نقطة\' إلى حسابكِ، وحصل صديقكِ أيضاً على مكافأة 50 نقطة في نفس الوقت!';

  @override
  String get profile_referral_title => 'دعوة النجوم';

  @override
  String get profile_referral_hint => 'أدخلي رمز دعوة الصديق';

  @override
  String get profile_referral_bind_btn => 'ربط';

  @override
  String profile_referral_pending(Object id) {
    return 'تم قبول دعوة اللاعب $id\nاذهبي وتحدثي مع الشخصية لـ 15 جملة لفتح 50 زهرة!';
  }

  @override
  String get profile_referral_err_self =>
      'لا يمكنكِ إدخال رمز الدعوة الخاص بكِ!';

  @override
  String get profile_referral_err_duplicate =>
      'لقد قمتِ بربط رمز الدعوة بالفعل!';

  @override
  String get profile_referral_err_not_found =>
      'تعذر العثور على هذا اللاعب، يرجى التحقق من الرمز!';

  @override
  String get profile_referral_success =>
      'تم الربط بنجاح! اذهبي وتحدثي مع الشخصية الآن!';

  @override
  String get profile_referral_err_expired =>
      'عذراً، يجب ربط رمز دعوة المبتدئين في غغضون 3 أيام من التسجيل!';

  @override
  String profile_share_message(String character, String code) {
    return 'لقد بدأتُ رحلة خفقان القلب مع $character في \'Lianlian ShiGuang\'! حمّلي التطبيق الآن وأدخلي رمز دعوة النجوم الخاص بي: 【$code】 في الصفحة الشخصية، وسنحصل كلانا على 50 زهرة مجاناً!\n\nرابط التحميل:\nhttps://lianlianshiguang.web.app/download/';
  }

  @override
  String get chat_levelup_share_btn => 'تباهي بهذا الخفقان لأصدقائكِ';

  @override
  String profile_my_invite_code_with_char(String character) {
    return 'رمز الدعوة الحصري الخاص بي (المفضل الحالي: $character)';
  }

  @override
  String get profile_send_invite_btn => 'إرسال دعوة النجوم للأصدقاء';

  @override
  String get profile_fallback_character => 'الشخصية المفضلة';

  @override
  String get profile_copy_success => 'تم نسخ رمز الدعوة إلى الحافظة!';

  @override
  String get profile_referral_rule_title => 'قواعد عقد النجوم';

  @override
  String get profile_referral_rule_receiver =>
      'بعد إبرام العقد، ما عليكِ سوى التحدث مع أي شخصية مفضلة لـ 15 جملة، وستحصلين أنتِ ومن دعاكِ على مكافأة 50 زهرة في نفس الوقت!\n\nتنبيه: يرجى إدخال رمز الدعوة في غضون 3 أيام من تسجيل الحساب ليكون صالحاً.';

  @override
  String get profile_referral_rule_inviter =>
      'ادعي أصدقاءً جدداً لتحميل التطبيق وإدخال رمز الدعوة الخاص بكِ، وعندما يكمل الطرف الآخر الربط في غضون 3 أيام من التسجيل ويتحدث مع أي شخصية لـ 15 جملة، سيحصل كلاكما على مكافأة 50 زهرة في نفس الوقت!';

  @override
  String get error_user_not_found =>
      'تعذر العثور على المستخدم، يرجى تسجيل الدخول مرة أخرى';

  @override
  String get error_id_taken =>
      'هذا المعرّف مستخدم بالفعل، يرجى اختيار معرّف آخر!';

  @override
  String get error_id_taken_short => 'هذا المعرّف مستخدم بالفعل!';

  @override
  String get shop_restocking => 'المتجر قيد إعادة التعبئة...';

  @override
  String get shop_preview_mode => 'وضع معاينة المتجر الحالي';

  @override
  String get friendlyReminderTitle => 'تذكير لطيف';

  @override
  String get editProfileHint =>
      'حسناً! إذا كنتِ ترغبين في تعديل الهوية، يرجى النقر على 【ملف شقوانغ】 داخل السحابة في الزاوية السفلية اليسرى لملئه!';

  @override
  String get starlightContractTitle => 'تفعيل عقد ضوء النجوم';

  @override
  String get dailyLimitReachedPrefix => 'لقد استنفدتِ حدكِ اليومي!\n\n';

  @override
  String get monthlyPassExhausted =>
      'لقد استنفدتِ حد البطاقة الشهرية الخاصة بكِ.';

  @override
  String get subscribeMonthlyPassPrompt =>
      'اشتركي في 【البطاقة الشهرية لـ Lianlian】 للاستمتاع بـ 20 فرصة إعادة توليد يومياً، لكي تكون كل استجابة منه أقرب إلى قلبكِ.';

  @override
  String get goToSubscribeButton => 'الذهاب للتفعيل';

  @override
  String get profileUpdatedSuccess => 'تم تحديث ملف شقوانغ!';

  @override
  String get continueChatTitle => 'مواصلة المحادثة';

  @override
  String continueChatCostWarning(int cost) {
    return 'جعله يستمر في التحدث سيستهلك $cost من الزهور\nهل أنتِ متأكدة من الرغبة في المتابعة؟';
  }

  @override
  String get dontShowAgainToday => 'عدم الإظهار مرة أخرى اليوم';

  @override
  String get confirmContinue => 'تأكيد المتابعة';

  @override
  String get hiddenPromptContinue => 'يرجى المتابعة';

  @override
  String confirmDeleteMessagesTitle(int count) {
    return 'هل أنتِ متأكدة من حذف هذه الرسائل الـ $count؟';
  }

  @override
  String regenerateButtonLabel(int current, int max) {
    return 'إعادة التوليد ($current/$max)';
  }

  @override
  String get systemPreparingWait =>
      'النظام ما زال قيد التحضير، يرجى الانتظار...';

  @override
  String get noMessagesToRegenerate =>
      'لا توجد محادثات يمكن إعادة توليدها حالياً!';

  @override
  String get continueButton => 'متابعة';

  @override
  String get creatorExclusive => 'حصري للمنشئ';

  @override
  String ageAndOccupation(String age, String occupation) {
    return '$age عاماً | $occupation';
  }

  @override
  String get likesLabel => 'يحب';

  @override
  String get dislikesLabel => 'لا يحب';

  @override
  String birthdayLabel(String birthday) {
    return 'تاريخ الميلاد: $birthday';
  }

  @override
  String heightLabel(String height) {
    return 'الطول: $height سم';
  }

  @override
  String get backgroundStoryLabel => 'قصة الخلفية';

  @override
  String get noneLabel => 'لا يوجد';

  @override
  String flowerPointsCount(String points) {
    return '$points زهرة';
  }

  @override
  String get passGuideTitle => 'دليل حصري لبطاقة Lianlian الشهرية';

  @override
  String get passGuideRegenerateTitle => 'لماذا تحتاجين إلى \"إعادة التوليد\"؟';

  @override
  String get passGuideRegenerateContent =>
      'في بعض الأحيان، قد يبدو الذكاء الاصطناعي وكأنه جامد كخشب لا يفهم الرومانسية. عندما تواجهين رداً غير مرضٍ، ما عليكِ سوى الضغط على إعادة التوليد، وسيكون الأمر أشبه بالعودة بالزمن! يمكنكِ جعله يعيد التفكير حتى يقول تلك العبارة المثالية التي تجعل قلبكِ يخفق بشدة.';

  @override
  String get passGuideAffectionTitle => 'ما فائدة تسريع مستوى الإعجاب؟';

  @override
  String get passGuideAffectionContent =>
      'في اللعبة، مستوى الإعجاب هو المفتاح الوحيد لفتح \"الأسرار العميقة\" للشخصية و\"الصور الخاصة الحميمية\". تتيح لكِ زيادة الـ 20% الدخول إلى أعماق قلبه أسرع من أي شخص آخر.';

  @override
  String get passGuideUnlockButton => 'لقد فهمتُ، افتحي القفل الآن!';

  @override
  String get pleaseWait => 'يرجى الانتظار';

  @override
  String get createNewProfileTitle => 'إنشاء ملف شقوانغ جديد';

  @override
  String get editProfileTitle => 'تعديل ملف شقوانغ';

  @override
  String get profileEditDescription =>
      'أنشئي شخصيات مختلفة ليتعرف على جانب جديد منكِ في العوالم الموازية!';

  @override
  String get profileNameLabel => 'اسم الملف (مرئي لكِ فقط)';

  @override
  String get profileNameHint => 'مثال: طالبة المدرسة، رئيسة تنفيذية صارمة';

  @override
  String get profileNicknameLabel => 'الاسم / اللقب';

  @override
  String get profileNicknameHint => 'مثال: ساكورا، الرئيسة لي';

  @override
  String get profileHeightLabel => 'الطول';

  @override
  String get profileHeightHint => 'مثال: 160 سم';

  @override
  String get profileAppearanceLabel => 'المظهر الخارجي';

  @override
  String get profileAppearanceHint =>
      'مثال: شعر أسود طويل، تحب ارتداء الفساتين';

  @override
  String get profileOccupationLabel => 'المهنة';

  @override
  String get profileOccupationHint => 'مثال: رسامة مستقلة';

  @override
  String get profileIntroLabel => 'الشخصية والتعريف بالنفس';

  @override
  String get profileIntroHint => 'مثال: خرقاء قليلاً، تحب تناول الحلويات...';

  @override
  String get profileNameEmptyWarning => 'يرجى تسمية هذا الملف!';

  @override
  String profileSaveError(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get saveProfileButton => 'حفظ الملف';

  @override
  String get fillLaterButton => 'الملء لاحقاً';

  @override
  String get exclusiveProfileTitle => 'ملف شقوانغ الحصري';

  @override
  String get profileSelectionDescription =>
      'اختاري الهوية التي تودين استخدامها للتفاعل معه (قائمة مشتركة لنفس الشخصية، حتى 10 ملفات)';

  @override
  String profileSwitchError(String error) {
    return 'فشل التبديل: $error';
  }

  @override
  String get unnamedProfile => 'ملف غير مسمى';

  @override
  String get noOccupationYet => 'لم يتم إدخال المهنة بعد';

  @override
  String get createNewProfileButton => 'إنشاء ملف شقوانغ جديد';

  @override
  String snackbar_friend_added(String characterName) {
    return 'تمت إضافة $characterName إلى الأصدقاء';
  }

  @override
  String reward_points_added(Object amount) {
    return '+$amount زهرة';
  }

  @override
  String get task_reward_already_claimed =>
      'لقد حصلتِ على مكافأة هذه المهمة اليوم بالفعل';

  @override
  String get do_not_show_again_today => 'عدم الإظهار مرة أخرى اليوم';

  @override
  String add_friend_success(String characterName) {
    return 'تمت إضافة $characterName كصديق بنجاح!';
  }

  @override
  String get chat_menu_aboutus => 'من نحن';

  @override
  String get about_us_empty_hint =>
      'أضيفي ذكريات مهمة／قصصاً من الزاوية العلوية اليمنى\nلتسيروا معاً يداً بيد نحو الأمام';

  @override
  String get about_us_limit_error =>
      'لقد وصلتِ إلى الحد الأقصى للذكريات الحصرية وهو 10 ذكريات، يرجى حذف الذكريات القديمة أولاً!';

  @override
  String get about_us_add_title => 'إضافة ذكرى حصرية';

  @override
  String get about_us_field_title => 'العنوان';

  @override
  String get about_us_hint_title => 'مثال: اللقاء الأول';

  @override
  String get about_us_field_subtitle => 'العنوان الفرعي';

  @override
  String get about_us_hint_subtitle => 'مثال: بداية صيف 2025';

  @override
  String get about_us_field_content => 'المحتوى';

  @override
  String get about_us_hint_content => 'اكتبي قصة مهمة أو وعداً بينكما...';

  @override
  String get about_us_add_button => 'إضافة';

  @override
  String get about_us_delete_tooltip => 'حذف هذه الذكرى';

  @override
  String get about_us_delete_title => 'حذف الذكرى';

  @override
  String get about_us_delete_confirm =>
      'هل أنتِ متأكدة من حذف هذه الذكرى؟ لا يمكن استعادتها بعد الحذف!';

  @override
  String get about_us_delete_success => 'تم حذف الذكرى';

  @override
  String get pack_first_meet => 'حزمة اللقاء الأول';

  @override
  String get pack_crush => 'حزمة الغزل والغموض';

  @override
  String get pack_heartbeat => 'حزمة خفقان القلب';

  @override
  String get pack_passionate => 'حزمة الحب العاطفي';

  @override
  String get pack_soulmate => 'حزمة الصديق الروحاني';

  @override
  String get pack_waiting => 'حزمة الانتظار المخلص';

  @override
  String get pack_trust => 'حزمة الثقة المتبادلة';

  @override
  String get pack_iloveyou => 'حزمة أنا أحبك';

  @override
  String get pack_honeymoon => 'حزمة شهر العسل';

  @override
  String get pack_promise => 'حزمة الوعد الصادق';

  @override
  String get pack_companion => 'حزمة الرفقة الدائمة';

  @override
  String get pack_deep_love => 'حزمة الحب العميق';

  @override
  String get pack_long_lasting => 'حزمة الحب الأبدي';

  @override
  String get pack_the_one => 'حزمة الحب الوحيد';

  @override
  String get pack_beloved => 'حزمة الحب العزيز';

  @override
  String get pack_lifetime => 'حزمة مدى الحياة والدهر';

  @override
  String get pack_vow => 'حزمة عهد الحب';

  @override
  String get pack_eternal => 'حزمة العشاق الأبديين';

  @override
  String get pack_exclusive => 'الحزمة الحصرية';

  @override
  String get monthly_privilege_reroll_title =>
      'فتح ميزة \"إعادة التوليد\" الحصرية';

  @override
  String get monthly_privilege_reroll_desc =>
      'ما يصل إلى 20 فرصة إعادة سحب يومياً، حتى يقول تلك العبارة التي تودين سماعها أكثر من غيرها!';

  @override
  String get monthly_privilege_affinity_title => 'زيادة سريعة لدرجة الإعجاب';

  @override
  String get monthly_privilege_affinity_desc =>
      'زيادة بنسبة 20% على نقاط الإعجاب عند التفاعل، لفتح الصور الخاصة الحصرية والمفاجآت بسرعة أكبر!';

  @override
  String get monthly_manual_button => 'لماذا تحتاجين إلى البطاقة الشهرية؟';

  @override
  String get nav_encounter => 'لقاء';

  @override
  String get nav_moments => 'لحظات';

  @override
  String get birthday_dialog_title => 'مفاجأة عيد الميلاد';

  @override
  String get birthday_dialog_content =>
      'اليوم هو يومكِ المميز الخاص!\n\nيرجى قبول هذه الهدية:\nجميع المحادثات اليوم مـجـانـيـة بـالـكـامـل!';

  @override
  String get birthday_dialog_button => 'ابدئي يوماً رومانسياً';

  @override
  String get about_us_edit_title => 'تعديل الذكرى';

  @override
  String get about_us_edit_confirm => 'تأكيد التعديل';

  @override
  String get save => 'حفظ';

  @override
  String get openSourceLicenses => 'تراخيص البرمجيات مفتوحة المصدر';

  @override
  String get openSourceLicensesDescription =>
      'عرض تراخيص البرمجيات مفتوحة المصدر التابعة لجهات خارجية';

  @override
  String get call_login_title => 'تسجيل الدخول مطلوب';

  @override
  String get call_login_content =>
      'سجّلي الدخول لفتح ميزة المكالمات الصوتية الحصرية!';

  @override
  String get cancel_later => 'لاحقاً';

  @override
  String get go_to_login => 'الانتقال لتسجيل الدخول';

  @override
  String get easter_egg_title => 'اكتشاف مفاجأة مخفية';

  @override
  String easter_egg_content(String title) {
    return 'لقد قمتِ بتفعيل \"$title\".\n\nهل تودين استخدام هذه القصة الخاصة؟';
  }

  @override
  String get easter_egg_cancel => 'عدم الاستخدام';

  @override
  String get easter_egg_confirm => 'استخدام المفاجأة';

  @override
  String get common_update_success => 'تم التعديل بنجاح';

  @override
  String get common_update_failed_try_again =>
      'فشل التعديل، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get no_voice_available => 'لا يوجد صوت حالياً';

  @override
  String get gift_insufficient_title => 'النقاط غير كافية';

  @override
  String get gift_insufficient_prompt =>
      'هل تودين الانتقال للحصول على المزيد من عملات الفان화؟';

  @override
  String get not_now => 'ليس الآن';

  @override
  String get go_to_get => 'الانتقال للحصول عليها';

  @override
  String get status_published => 'تم النشر';

  @override
  String get monthly_card_success_title =>
      'تم فتح البطاقة الشهرية المتميزة بنجاح!';

  @override
  String get monthly_card_success_subtitle =>
      'شكراً لاشتراككِ! لقد دخلت المزايا الحصرية حيز التنفيذ:';

  @override
  String get monthly_card_perk_1 => 'الحصول على 250 زهرة من زهور الزمن فوراً';

  @override
  String get monthly_card_perk_2 =>
      'الحصول على 10 زهور زمن إضافية عند تسجيل الدخول يومياً';

  @override
  String get monthly_card_perk_3 =>
      'فتح الحد الأقصى لمرات تفاعل الإعجاب الحصري';

  @override
  String get monthly_card_start_perks => 'البدء في الاستمتاع بالمزايا';

  @override
  String get tip_post_like =>
      'بعد الإعجاب، يمكنكِ العثور عليه في\nالمحتوى المفضّل';

  @override
  String get tip_post_bookmark =>
      'بعد الحفظ، يمكنكِ العثور عليه في\n\"محفوظاتي\"';

  @override
  String get tip_time_echoes =>
      'بعد ترك تجربتكِ\nستظهر التعليقات المنبثقة عند البحث';

  @override
  String get tip_call_memory =>
      'التسجيلات الصوتية المحفوظة بعد المكالمة\nستكون هنا!';

  @override
  String get tip_chat_notifications => 'هنا يمكنكِ\nعرض الإشعارات الجديدة';

  @override
  String get tip_moments_wall_menu => 'انقري هنا لـ\nجدولة منشورات الشخصية';

  @override
  String get forgot_password => 'هل نسيتِ كلمة المرور؟';

  @override
  String get forgot_password_empty_email =>
      'يرجى إدخال البريد الإلكتروني أولاً، ثم النقر على نسيت كلمة المرور';

  @override
  String get forgot_password_email_sent =>
      'تم إرسال بريد إعادة تعيين كلمة المرور، يرجى التحقق من صندوق الوارد الخاص بكِ';

  @override
  String get forgot_password_error_default =>
      'فشل إرسال بريد إعادة تعيين كلمة المرور، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get forgot_password_error_invalid_email =>
      'صيغة البريد الإلكتروني غير صحيحة';

  @override
  String get forgot_password_error_user_not_found =>
      'لم يتم العثور على حساب مرتبط بهذا البريد الإلكتروني';

  @override
  String forgot_password_error_with_message(String error) {
    return 'فشل إرسال بريد إعادة تعيين كلمة المرور: $error';
  }

  @override
  String get terms_not_accepted_toast =>
      'يرجى قراءة والموافقة على شروط الاستخدام وإرشادات المجتمع أولاً';

  @override
  String get terms_content =>
      'مرحباً بكِ في Lian Lian Shi Guang.\n\nقبل استخدام هذه الخدمة، يجب عليكِ الموافقة على الالتزام بشروط الاستخدام وإرشادات المجتمع هذه.\n\nلا يُسمح لكِ بتحميل، أو إنشاء، أو نشر، أو نقل أي محتوى غير قانوني، أو ينتهك الحقوق، أو يحتوي على عري أو إباحية، أو عنف، أو كراهية، أو مضايقة، أو إساءة، أو احتيال، أو رسائل مزعجة، أو أي محتوى آخر يُعتبر مثيراً للاعتراض، أو مسيئاً، أو يضر بحقوق الآخرين.\n\nتتبع Lian Lian Shi Guang سياسة عدم التسامح مطلقاً تجاه المحتوى غير اللائق والسلوكيات المسيئة. إذا انتهك المستخدم اللوائح، فقد نقوم بإزالة المحتوى ذي الصلة، أو تقييد الميزات، أو تعليق الحساب أو إنهائه.\n\nيمكن للمستخدمين الإبلاغ عن المحتوى غير اللائق أو المستخدمين المسيئين من خلال ميزات الإبلاغ والحظر المدمجة في التطبيق.';

  @override
  String get community_rules_title => 'إرشادات المجتمع';

  @override
  String get community_rules_content =>
      'تهدف Lian Lian Shi Guang إلى توفير بيئة تفاعلية آمنة، وودية، ومحترمة للمبدعين والمستخدمين.\n\nنحن لا نسمح بالمحتويات أو السلوكيات التالية:\n1. العري، أو المحتوى الإباحي، أو الإيحاءات الجنسية غير اللائقة\n2. المضايقة، أو الإساءة، أو التنمر، أو تهديد الآخرين\n3. الكراهية، أو التمييز، أو التحريض على العنف\n4. المحتوى الدموي، أو العنيف، أو السلوكيات الخطيرة\n5. انتهاك حقوق الطبع والنشر، أو حقوق الصور، أو الحقوق الأخرى للآخرين\n6. الرسائل المزعجة، أو الاحتيال، أو الأنشطة الخبيثة\n7. أي محتوى آخر مثير للاعتراض أو غير مناسب للعرض العام\n\nيمكن للمستخدمين الإبلاغ عن المحتوى غير اللائق، كما يمكنهم حظر المستخدمين المسيئين. بعد الحظر، لن يظهر محتوى هذا المستخدم على شاشتكِ مجدداً.';

  @override
  String get block_self_error => 'لا يمكنكِ حظر المحتوى الخاص بكِ';

  @override
  String get block_user_title => 'حظر هذا المستخدم؟';

  @override
  String get block_user_content =>
      'بعد الحظر، لن تتمكني من رؤية المحتوى الذي ينشره هذا المستخدم مجدداً.\nسنقوم أيضاً بتلقي إشعار وإجراء مراجعة للأمر.';

  @override
  String get block_user_success =>
      'تم حظر هذا المستخدم بنجاح، وتمت إزالة المحتوى ذي الصلة من جدار الزمن الخاص بكِ';

  @override
  String get block_user_failed => 'فشل الحظر، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get terms_checkbox_read_agree => 'لقد قرأتُ وأوافق على';

  @override
  String get terms_checkbox_terms => '《شروط الاستخدام》';

  @override
  String get terms_checkbox_and => 'و';

  @override
  String get terms_checkbox_rules => '《إرشادات المجتمع》';

  @override
  String get hidden_moments => 'اللحظات المخفية';

  @override
  String get hide_moment_title => 'إخفاء هذه اللحظة؟';

  @override
  String get hide_moment_content =>
      'بعد الإخفاء، لن تظهر هذه اللحظة على جدار الزمن الخاص بكِ مجدداً.';

  @override
  String get hide => 'إخفاء';

  @override
  String get hide_moment_success => 'تم إخفاء هذه اللحظة';

  @override
  String get hide_moment_failed => 'فشل الإخفاء، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get block_character_not_found =>
      'لم يتم العثور على بيانات الشخصية، تعذر الحظر';

  @override
  String get block_character_title => 'حظر هذه الشخصية؟';

  @override
  String block_character_content(String authorName) {
    return 'بعد الحظر، لن تتمكني من رؤية اللحظات التي تنشرها \"$authorName\" مجدداً. إذا كان هذا المحتوى ينتهك اللوائح، سنقوم أيضاً بتلقي إشعار وإجراء مراجعة للأمر.';
  }

  @override
  String block_character_success(String authorName) {
    return 'تم حظر \"$authorName\" بنجاح، وتم إخفاء اللحظات ذات الصلة';
  }

  @override
  String get block_character_failed =>
      'فشل الحظر، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get hidden_moments_title => 'اللحظات المخفية';

  @override
  String get hidden_moments_empty => 'لا توجد لحظات مخفية حالياً';

  @override
  String get hidden_moments_load_failed => 'فشل تحميل اللحظات المخفية';

  @override
  String get hidden_moment_unknown_author => 'شخصية مجهولة';

  @override
  String get hidden_moment_no_preview =>
      'لا يوجد محتوى متاح للمعاينة في هذه اللحظة';

  @override
  String get unhide_moment_title => 'إلغاء الإخفاء؟';

  @override
  String get unhide_moment_content =>
      'بعد إلغاء الإخفاء، إذا كانت هذه اللحظة لا تزال موجودة، فقد تظهر مجدداً على جدار الزمن الخاص بكِ لاحقاً.';

  @override
  String get unhide_moment_action => 'إلغاء الإخفاء';

  @override
  String get unhide_moment_success => 'تم إلغاء الإخفاء بنجاح';

  @override
  String get report_moment_title => 'الإبلاغ عن هذه اللحظة';

  @override
  String get report_moment_content =>
      'هل أنتِ متأكدة من رغبتكِ في الإبلاغ عن هذه اللحظة إلى فريق الإدارة؟ سيتم إخفاء المحتوى الضار أو حذفه.';

  @override
  String get report_confirm_button => 'تأكيد الإبلاغ';

  @override
  String get report_success_message =>
      'لقد تلقينا بلاغكِ، وسيتدخل فريق المراجعة لمعالجة الأمر في أقرب وقت ممكن.';

  @override
  String get accountDeletionSubmittedTitle => 'تم تقديم طلب حذف الحساب';

  @override
  String get accountDeletionSubmittedContent =>
      'حسناً! سنحتفظ بفترة مهلة مدتها 3 أيام لحسابكِ.\n\nإذا كنتِ ترغبين في إلغاء حذف الحساب، ما عليكِ سوى إعادة تسجيل الدخول خلال هذه الفترة لاستعادة حسابكِ.';

  @override
  String get restoreAccountDialogTitle => 'طلب حذف الحساب';

  @override
  String get restoreAccountDialogContent =>
      'حسابكِ حالياً في انتظار الحذف.\n\nإذا استمررتِ في تسجيل الدخول، سيتم إلغاء طلب الحذف واستعادة حسابكِ.';

  @override
  String get cancelLoginButton => 'إلغاء تسجيل الدخول';

  @override
  String get restoreAccountButton => 'استعادة الحساب';

  @override
  String get voice_preview => 'تشغيل الصوت';

  @override
  String get voice_preview_failed => 'فشل تشغيل الصوت';

  @override
  String get characterBannerSectionTitle =>
      'عنوان لافتة الصفحة الرئيسية للشخصية';

  @override
  String get characterBannerDescription => 'وصف اللافتة';

  @override
  String get characterBannerRemove => 'إزالة';

  @override
  String get characterBannerSelect => 'تحديد صورة اللافتة';

  @override
  String get characterBannerChange => 'تغيير صورة اللافتة';

  @override
  String get characterBannerSpecs =>
      'النسبة الموصى بها 16:9، الحجم الموصى به 1920 × 1080';

  @override
  String get characterBannerDefaultHint =>
      'عند عدم التحديد، ستستخدم الصفحة الرئيسية صورة الشخصية الرئيسية تلقائياً.';

  @override
  String get characterBannerHelpContent =>
      'ستظهر اللافتة في المنطقة الأفقية الكبيرة بالصفحة الرئيسية للشخصية.\n\nيُوصى باستخدام صورة أفقية بنسبة 16:9، مثل 1920 × 1080.\n\nيرجى وضع الشخصيات المهمة والوجوه في منتصف الشاشة قدر الإمكان لتجنب قصها على أحجام الهواتف المختلفة.\n\nإذا لم يتم تحديد لافتة، سيستخدم النظام صورة الشخصية الرئيسية تلقائياً.';

  @override
  String get first_meeting_title => 'اللقاء الأول';

  @override
  String get common_delete_network_failed =>
      'فشل الحذف، يرجى التحقق من الشبكة ثم المحاولة مرة أخرى';

  @override
  String get common_operation_failed_retry =>
      'فشلت العملية، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String exclusive_photo_number(int number) {
    return 'صورة حصرية $number';
  }

  @override
  String get unlock_after_affection_increase => 'يفتح بعد زيادة مستوى الإعجاب';

  @override
  String get first_meeting_empty => 'اللقاء الأول، لم يبدأ بعد...';

  @override
  String photo_load_failed(String error) {
    return 'فشل تحميل الصورة: $error';
  }

  @override
  String get add_friend_failed_retry =>
      'فشل إضافة الصديق، يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get remove_friend => 'إزالة صديق';

  @override
  String get report_character => 'الإبلاغ عن الشخصية';

  @override
  String get block_character => 'حظر الشخصية';

  @override
  String get daily_encounter => 'لقاء يومي';

  @override
  String get discovery_hall => 'قاعة الاستكشاف';

  @override
  String get latest_recommendation => 'أحدث التوصيات';

  @override
  String get popular_ranking => 'الأكثر شعبية';

  @override
  String get character_features => 'سمات الشخصية';

  @override
  String get featured_new_star => 'نجم جديد ساطع．توصيات ممتازة';

  @override
  String get recently_added_characters => 'شخصيات مضافة حديثاً';

  @override
  String get no_tag_data => 'لا توجد بيانات وسوم حالياً~';

  @override
  String get no_character_with_tag => 'لم يتم العثور على شخصية تحمل هذا الوسم';

  @override
  String get voice_search_failed_retry =>
      'فشل البحث عن الصوت، يرجى المحاولة مرة أخرى';

  @override
  String get voice_search_incomplete_retry =>
      'البحث غير مكتمل، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get voice_data_incomplete => 'بيانات الصوت غير مكتملة';

  @override
  String get voice_generation_failed_retry =>
      'فشل توليد الصوت، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get voice_playback_failed_retry =>
      'فشل تشغيل الصوت، يرجى المحاولة مرة أخرى';

  @override
  String get selected_voice_data_incomplete =>
      'بيانات الصوت المحددة غير مكتملة';

  @override
  String get private_voice_user_not_found =>
      'لم يتم العثور على المستخدم، تعذر تحديث صوت الشخصية الخاصة';

  @override
  String get voice_selected_character_save_failed =>
      'تم تحديد الصوت، ولكن فشل حفظ بيانات الشخصية';

  @override
  String get voice_binding_failed => 'فشل ربط الصوت';

  @override
  String get play_voice_tooltip => 'تشغيل الصوت';

  @override
  String get avatar_label => 'الصورة الشخصية';

  @override
  String get message_preview_image => '[صورة]';

  @override
  String get message_preview_recording => '[تسجيل صوتي]';

  @override
  String get message_preview_voice => '[رسالة صوتية]';

  @override
  String get send_failed_retry => 'فشل الإرسال، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get media_upload_failed_retry =>
      'فشل تحميل الوسائط، يرجى المحاولة مرة أخرى';

  @override
  String get ai_thinking_too_long =>
      'يبدو أنه يستغرق وقتاً في التفكير، يرجى المحاولة مرة أخرى لاحقاً...';

  @override
  String get ai_reply_in_progress =>
      'إنه يرد الآن، يرجى الانتظار وعدم الإرسال بشكل مكرر';

  @override
  String get ai_response_blocked =>
      'تشتت أفكاره، يرجى استخدام أسلوب أكثر لطفاً!';

  @override
  String get microphone_permission_required =>
      'يلزم الحصول على إذن الميكروفون للتسجيل';

  @override
  String get no_recording_to_send => 'لا يوجد تسجيل لإرساله';

  @override
  String get voice_uploading => 'جاري تحميل الصوت...';

  @override
  String get change_watermark_color => 'تغيير لون العلامة المائية';

  @override
  String get other_party_typing => 'الطرف الآخر يكتب الآن...';

  @override
  String get chat_input_hint => 'يرجى الإدخال...';

  @override
  String get regenerate_sync_failed =>
      'فشل مزامنة عدد مرات إعادة التوليد، يرجى المحاولة مرة أخرى';

  @override
  String get creator_public_works => 'الأعمال العامة';

  @override
  String get creator_received_likes => 'الإعجابات المستلمة';

  @override
  String get about_me => 'نبذة عني';

  @override
  String get moment_input_hint => 'شاركي مشاعركِ...';

  @override
  String character_play_count(int count) {
    return 'عدد مرات اللعب: $count';
  }

  @override
  String tag_page_title(String tag) {
    return 'الوسم: #$tag';
  }

  @override
  String voice_preview_failed_detail(String code, String message) {
    return 'فشلت التجربة الصوتية: $code $message';
  }

  @override
  String messages_deleted_success(int count) {
    return 'تم حذف $count من الرسائل بنجاح';
  }

  @override
  String creator_work_load_failed(String error) {
    return 'فشل تحميل الأعمال: $error';
  }

  @override
  String age_years_old(String age) {
    return '$age سنة';
  }

  @override
  String deleteFailedMessage(String error) {
    return 'فشل الحذف: $error';
  }

  @override
  String loadCharacterDataFailed(String error) {
    return 'فشل تحميل بيانات الشخصية: $error';
  }

  @override
  String get draftAvatarLoadFailed => 'فشل تحميل صورة المسودة:';

  @override
  String get unnamedCreator => 'مبدع غير مسمى';

  @override
  String get profileNotYetFilled => 'لم يتم ملء السيرة الذاتية بعد';

  @override
  String get reportImageSizeLimit => 'حجم الصورة لا يمكن أن يتجاوز 10 ميغابايت';

  @override
  String reportImageSelectFailed(String error) {
    return 'فشل تحديد صورة البلاغ: $error';
  }

  @override
  String get reportImageCannotSelect =>
      'تعذر تحديد الصورة، يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get reportLoginRequired => 'يرجى تسجيل الدخول أولاً قبل تقديم البلاغ';

  @override
  String get reportAnonymousPlayer => 'لاعب غير مسمى';

  @override
  String get reportSendSuccess => 'تم إرسال البلاغ بنجاح، شكراً لملاحظاتكِ!';

  @override
  String reportSendFailed(String error) {
    return 'فشل إرسال بلاغ اللاعب: $error';
  }

  @override
  String get reportNetworkFailed =>
      'فشل الإرسال، يرجى التحقق من الشبكة ثم المحاولة مرة أخرى';

  @override
  String get reportAttachImageLabel => 'إرفاق صورة (اختياري)';

  @override
  String get reportAttachImageHint =>
      'عند الإبلاغ عن مشكلة أو عدم وصول الزهور، يمكنكِ إرفاق لقطة شاشة للتحقق من المشكلة.';

  @override
  String get reportOpeningAlbum => 'جاري فتح ألبوم الصور...';

  @override
  String get reportSelectFromAlbum => 'تحديد صورة من ألبوم الصور';

  @override
  String get reportSending => 'جاري الإرسال...';

  @override
  String get reportSubmit => 'إرسال البلاغ';

  @override
  String get reportRemoveImage => 'إزالة الصورة';

  @override
  String get reportImageSelected => 'تم تحديد الصورة';

  @override
  String get reportChangeImage => 'تغيير';

  @override
  String get reloadTranslation => 'إعادة تحميل الترجمة';

  @override
  String get guideNotAvailableInLanguage =>
      'دليل اللعب غير متوفر بهذه اللغة حالياً، يتم عرض الصينية التقليدية مؤقتاً.';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get memoPermissionWarning =>
      'لم يتم إذن الإشعارات، سيتم حفظ المذكرة ولكن لن تظهر تنبيهات النظام.';

  @override
  String memoSavedWithNotification(String name) {
    return 'تم حفظ المذكرة، سيقوم $name بتذكيركِ!';
  }

  @override
  String get memoSavedNoPermission =>
      'تم حفظ المذكرة، ولكن لم يتم فتح إذن الإشعارات بعد.';

  @override
  String memoUpdatedWithNotification(String name) {
    return 'تم تحديث المذكرة، سيقوم $name بتذكيركِ!';
  }

  @override
  String get memoUpdatedNoPermission =>
      'تم تحديث المذكرة، ولكن لا يوجد إذن إشعارات حالياً.';

  @override
  String dataLoadError(String error) {
    return 'حدث خطأ أثناء تحميل البيانات: $error';
  }

  @override
  String loadFailed(String error) {
    return 'فشل التحميل: $error';
  }

  @override
  String get dateFormatMonthDay => 'd MMMM';

  @override
  String get timeFormatHourMinute => 'HH:mm';

  @override
  String get likeFeedPrompt => 'هل أعجبتكِ هذه اللحظة؟ أرسلي له بعض الدعم!';

  @override
  String get saveFeedPocket => 'احفظي اللحظات الخاصة في جيبكِ سراً.';

  @override
  String get newComment => 'تعليق جديد';

  @override
  String get someFriend => 'صديق ما';

  @override
  String get myBackpackAndPrivileges => 'حقيبتي المخصصة والمزايا';

  @override
  String get currentRomanticBond => 'الرابط المكتسب حالياً';

  @override
  String get physicalGiftBoxUnlockStatus => 'حالة فتح الصندوق الهدايا المادي:';

  @override
  String get topLovePhysicalVipBox => 'صندوق الهدايا الحصري VIP 【الحب الأسمى】';

  @override
  String get physicalGiftBoxContents =>
      'يشمل: رسالة بخط اليد + دمية ممثلة للشخصية + رسالة شكر رسمية';

  @override
  String get modifyShippingAddress => 'تعديل معلومات عنوان الشحن';

  @override
  String get addressUnlockedFillNow => 'تم الفتح! انقري هنا لملء معلومات الشحن';

  @override
  String get addressSuccessfullyRegistered =>
      'لقد قمتِ بتسجيل عنوان الشحن بنجاح، سنقوم بإعداده لكِ في أقرب وقت ممكن!';

  @override
  String amountNeededForPhysicalPrize(String amount) {
    return 'متبقي NT\$ $amount لفتح الجائزة المادية الكبرى!';
  }

  @override
  String get avatarFrameHint =>
      'تلميح: يمكنكِ عرض وتجهيز المظاهر الرقمية وإطارات الصور الأخرى في المتجر أو الإعدادات الشخصية.';

  @override
  String get closeButton => 'إغلاق';

  @override
  String get physicalGiftBoxUnlockTitle =>
      'فتح صندوق الهدايا المادي 【الحب الأسمى】';

  @override
  String get physicalGiftBoxUnlockThanks =>
      'شكراً لدعمكِ الدائم والرائع لـ 《Lian Lian Shi Guang》!';

  @override
  String get physicalGiftBoxUnlockPrompt =>
      'يرجى ملء معلومات الشحن التالية، وسنرسل لكِ رسالة مكتوبة بخط اليد ودمية الشخصية الخاصة:';

  @override
  String get recipientRealName => 'الاسم الحقيقي للمستلم';

  @override
  String get contactPhone => 'رقم الهاتف';

  @override
  String get fullShippingAddress => 'عنوان الشحن الكامل (شاملاً الرمز البريدي)';

  @override
  String get desiredCharacterDollName => 'اسم دمية الشخصية التي ترغبين بها';

  @override
  String get characterNameExample => 'مثال: اسم الشخصية المراد إدخاله';

  @override
  String get fillLater => 'الملء لاحقاً';

  @override
  String get fillCompleteAddressAndRoleHint =>
      'يرجى ملء معلومات الشحن واسم الشخصية المفضلة بالكامل!';

  @override
  String get shippingInfoSubmittedSuccess =>
      'تم إرسال معلومات الشحن بنجاح! يرجى التطلع إلى مفاجأتنا المادية!';

  @override
  String get confirmSubmit => 'تأكيد الإرسال';

  @override
  String get aboutMe => 'نبذة عني';

  @override
  String get myBackpack => 'حقيبتي';

  @override
  String get ownerExclusiveArea => 'المنطقة الحصرية للمالك';

  @override
  String get enterShiguangAdminBackend =>
      'الدخول إلى لوحة إدارة Lian Lian Shi Guang';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get creatorGuidelines => 'إرشادات المبدعين';

  @override
  String get playGuide => 'دليل اللعب';

  @override
  String get lianlianShiguang => 'Lian Lian Shi Guang';

  @override
  String get copyrightNotice => '© 2026 Mo Yu Bai';

  @override
  String get cumulativeBenefits => 'المزايا التراكمية';

  @override
  String get perkFirstEncounter => 'الميل الأول';

  @override
  String get perkFirstEncounterReward => '20 زهرة + لقب مبتدئ حصري';

  @override
  String get perkGlimmerThrob => 'خفقة الضوء الخافت';

  @override
  String get perkGlimmerThrobReward => 'إطار صورة حصري 【خفقة الضوء الخافت】';

  @override
  String get perkStarryWhisper => 'همس النجوم';

  @override
  String get perkStarryWhisperReward => 'فقاعة دردشة حصرية + 50 زهرة';

  @override
  String get perkRomanticSunset => 'غروب رومانسي';

  @override
  String get perkRomanticSunsetReward => 'أيقونة تطبيق مخصصة';

  @override
  String get perkHeartbeat => 'نبضات القلب';

  @override
  String get perkHeartbeatReward => 'مؤثرات النقر على الشاشة + 100 زهرة';

  @override
  String get perkEternalVow => 'العهد الأبدي';

  @override
  String get perkEternalVowReward => 'إطار صورة متحرك متقدم + 200 زهرة';

  @override
  String get perkSoulIntersection => 'تقاطع الأرواح';

  @override
  String get perkSoulIntersectionReward =>
      'مؤثرات فقاعة دردشة متحركة + لقب متقدم حصري';

  @override
  String get perkExclusiveWait => 'الانتظار الحصري';

  @override
  String get perkExclusiveWaitReward => 'بطاقة اسم متحركة فاخرة + 500 زهرة';

  @override
  String get perkBrilliantGalaxy => 'مجرة متألقة';

  @override
  String get perkBrilliantGalaxyReward =>
      'مؤثرات دخول حصرية + خدمة عملاء مخصصة';

  @override
  String get perkTopBeloved => 'الحب الأسمى';

  @override
  String get perkTopBelovedReward => 'صندوق الهدايا الحصري VIP المادي';

  @override
  String get cumulativeRomanticBond => 'الرابط الرومانسي التراكمي';

  @override
  String get allTopPrivilegesUnlocked => 'لقد قمتِ بفتح جميع المزايا الفاخرة!';

  @override
  String rechargeAmountForNextTier(String amount) {
    return 'اشحني NT\$ $amount إضافية لفتح المستوى التالي';
  }

  @override
  String get storyContentCannotBeEmpty => 'محتوى القصة لا يمكن أن يكون فارغاً';

  @override
  String get writeYourStoryHint => 'اكتبي قصتكما...';

  @override
  String get characterBannerTitle => 'لافتة الصفحة الرئيسية للشخصية';

  @override
  String get mailDeleteTitle => 'حذف الرسائل';

  @override
  String mailDeleteConfirm(int count) {
    return 'هل أنت متأكد من حذف $count رسالة؟\nلا يمكن التراجع عن الحذف。';
  }

  @override
  String mailDeleteSuccess(int count) {
    return 'تم حذف $count رسالة';
  }

  @override
  String get mailDeleteFailed => 'فشل الحذف، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get mailCancelSelection => 'إلغاء التحديد';

  @override
  String mailSelectedCount(int count) {
    return 'تم تحديد $count رسالة';
  }

  @override
  String get moreOptions => 'المزيد';

  @override
  String mailDeleteSelected(int count) {
    return 'حذف $count رسالة';
  }

  @override
  String get officialManagementTeam => 'فريق إدارة LoveyDovey';

  @override
  String get rewardCampaignTitle => 'هدية الفعالية';

  @override
  String get rewardCampaignMissingData =>
      'تفتقد رسالة الهدية هذه إلى بيانات الفعالية، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String rewardCampaignClaimSuccess(int amount) {
    return 'تم استلام $amount زهرة';
  }

  @override
  String get rewardCampaignAlreadyClaimed => 'تم استلام هذه الهدية بالفعل';

  @override
  String get rewardCampaignClaimFailed =>
      'فشل الاستلام، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get rewardCampaignContains => 'تحتوي هذه الرسالة على';

  @override
  String rewardCampaignFlowerAmount(int amount) {
    return '$amount زهرة';
  }

  @override
  String rewardCampaignDeadline(String date) {
    return 'الموعد النهائي للاستلام: $date';
  }

  @override
  String get rewardCampaignClaiming => 'جارٍ الاستلام…';

  @override
  String get rewardCampaignClaimed => 'تم الاستلام';

  @override
  String get rewardCampaignEnded => 'انتهت الفعالية';

  @override
  String get rewardCampaignClaimButton => 'استلام الهدية';

  @override
  String get mailDetailTitle => 'الرسالة';

  @override
  String mailSender(String name) {
    return 'المرسل: $name';
  }

  @override
  String get mailCaseNumber => 'رقم الحالة';

  @override
  String get mailCopyCaseNumber => 'نسخ رقم الحالة';

  @override
  String get mailCaseNumberCopied => 'تم نسخ رقم الحالة';

  @override
  String get profilePageAboutMe => 'نبذة عني';

  @override
  String get profilePageTabBio => 'النبذة الشخصية';

  @override
  String get profilePageTabCharacters => 'الشخصيات';

  @override
  String get profilePageTabMoments => 'المنشورات';

  @override
  String get profilePageEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profilePageFriends => 'الأصدقاء';

  @override
  String get profilePageWorks => 'الأعمال';

  @override
  String get profilePageFollowing => 'المتابَعون';

  @override
  String get profilePageFollowers => 'المتابِعون';

  @override
  String get profilePageHeartbeatDiary => 'يوميات نبضات القلب';

  @override
  String get profilePageEditCharacter => 'تعديل الشخصية';

  @override
  String get profilePagePreviewCharacter => 'معاينة ملف الشخصية';

  @override
  String get profilePageNoBio => 'لا توجد نبذة شخصية بعد';

  @override
  String get profilePageNoBioHint => 'اضغط لكتابة نبذة عنك.';

  @override
  String get profilePageCreateCharacter => 'إنشاء شخصية جديدة';

  @override
  String get profilePageNoCharacters => 'لم يتم إنشاء أي شخصية بعد';

  @override
  String get profilePageNoCharactersHint => 'ابدأ بإنشاء شخصيتك الأولى.';

  @override
  String get profilePageCharacterActions => 'إجراءات الشخصية';

  @override
  String get profilePagePublic => 'عام';

  @override
  String get profilePagePrivate => 'خاص';

  @override
  String get profilePageCreator => 'المبدع';

  @override
  String get profilePageSelectPostingIdentity => 'اختر هوية النشر';

  @override
  String get profilePagePostAsCreator => 'النشر بهوية المبدع';

  @override
  String get profilePagePublicCharacter => 'شخصية عامة';

  @override
  String get profilePagePrivateCharacter => 'شخصية خاصة';

  @override
  String get profilePagePleaseSignIn => 'يرجى تسجيل الدخول أولًا';

  @override
  String get profilePagePublishMoment => 'نشر منشور';

  @override
  String get profilePageFilterAll => 'الكل';

  @override
  String get profilePageFilterCreator => 'أنا';

  @override
  String get profilePageFilterCharacter => 'الشخصيات';

  @override
  String get profilePageMomentsLoadFailed => 'فشل تحميل المنشورات';

  @override
  String get profilePageTryAgainLater => 'يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get profilePageNoCreatorMoments => 'لم تنشر أي منشورات بعد';

  @override
  String get profilePageNoCreatorMomentsHint =>
      'سيظهر هنا المحتوى المنشور بهوية المبدع.';

  @override
  String get profilePageNoCharacterMoments => 'لم تنشر شخصياتك أي منشورات بعد';

  @override
  String get profilePageNoCharacterMomentsHint =>
      'سيظهر هنا المحتوى المنشور بهوية الشخصية.';

  @override
  String get profilePageNoMoments => 'لا توجد منشورات بعد';

  @override
  String get profilePageNoMomentsHint =>
      'ستظهر هنا المنشورات التي تنشرها أنت وشخصياتك.';

  @override
  String get profilePageDeleteMomentTitle => 'حذف المنشور';

  @override
  String get profilePageDeleteMomentConfirm =>
      'هل أنت متأكد من حذف هذا المنشور نهائيًا؟';

  @override
  String get profilePageCancel => 'إلغاء';

  @override
  String get profilePageDelete => 'حذف';

  @override
  String get profilePageMomentDeleted => 'تم حذف المنشور';

  @override
  String get profilePageDeleteFailed =>
      'فشل الحذف، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get profilePageReferralCompleted => 'اكتملت دعوة النجوم';

  @override
  String profilePageInviter(String inviterId) {
    return 'الداعي: $inviterId';
  }

  @override
  String get profilePageReferralRewardReceived => 'حصل الطرفان على 50 زهرة';

  @override
  String get profilePageClaimed => 'تم الاستلام';

  @override
  String profilePageInviterBound(String inviterId) {
    return 'تم ربط الداعي: $inviterId';
  }

  @override
  String get profilePageReferralProgressHint =>
      'بعد إكمال 15 رسالة دردشة، سيحصل كل طرف على 50 زهرة';

  @override
  String get profilePageAlreadyCheckedIn => 'لقد سجلت حضورك اليوم بالفعل';

  @override
  String get profilePageReferralBindFailed =>
      'فشل الربط، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get profilePageCharacterNotFound =>
      'تعذر العثور على بيانات هذه الشخصية';

  @override
  String get periodGuideTitle => 'كيف تستخدمين يوميات الدورة الشهرية؟';

  @override
  String get periodGuideContent =>
      '① اختاري أولًا تاريخًا من التقويم.\n② اختاري «بدأت اليوم» أو «ما زالت مستمرة» أو «انتهت اليوم».\n③ حددي حالتك المزاجية والجسدية لهذا اليوم، ويمكنك أيضًا إضافة ملاحظاتك الخاصة.\n④ اضغطي على حفظ، وبذلك ستتمكن الشخصية من فهم حالتك اليوم أثناء الدردشة.\n\nسيتم تعديل التواريخ المتوقعة بناءً على سجلاتك السابقة، وهي مخصصة كمرجع لتدوين تفاصيل حياتك اليومية فقط.';

  @override
  String get periodGotIt => 'فهمت';

  @override
  String get periodSelectAtLeastOne => 'يرجى اختيار سجل واحد على الأقل';

  @override
  String get periodFutureDateError =>
      'لا يمكن تسجيل حالة الدورة الشهرية لتاريخ مستقبلي.';

  @override
  String get periodAlreadyOngoingError =>
      'توجد دورة شهرية جارية بالفعل، يرجى إنهاؤها أولًا.';

  @override
  String get periodNoOngoingError =>
      'لا توجد دورة شهرية جارية حاليًا، يرجى اختيار «بدأت اليوم» أولًا.';

  @override
  String get periodBeforeStartError =>
      'لا يمكن أن يسبق التاريخ تاريخ بدء الدورة الشهرية الحالية.';

  @override
  String get periodEndBeforeStartError =>
      'لا يمكن أن يسبق تاريخ الانتهاء تاريخ البدء.';

  @override
  String periodRecordSaved(String date) {
    return 'تم حفظ سجل $date';
  }

  @override
  String get periodSaveFailed => 'فشل الحفظ، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get periodDeleteTitle => 'هل تريدين حذف سجل هذه الدورة الشهرية؟';

  @override
  String get periodDeleteContent =>
      'بعد الحذف، سيُعاد حساب متوسط الدورة والتاريخ المتوقع للدورة القادمة.';

  @override
  String get periodCancel => 'إلغاء';

  @override
  String get periodDelete => 'حذف';

  @override
  String get periodNoOngoing => 'لا توجد دورة شهرية جارية حاليًا';

  @override
  String periodDayCount(int count) {
    return 'اليوم $count من الدورة الشهرية';
  }

  @override
  String get periodHelp => 'دليل الاستخدام';

  @override
  String get periodAverageCycle => 'متوسط مدة الدورة';

  @override
  String get periodAverageDuration => 'متوسط مدة الحيض';

  @override
  String periodDays(int count) {
    return '$count أيام';
  }

  @override
  String get periodNextPrediction => 'التوقع القادم';

  @override
  String get periodCalculatedAfterRecording => 'يُحسب بعد التسجيل';

  @override
  String get periodInsufficientData =>
      'لا توجد بيانات كافية حاليًا، لذا سيُقدّر مؤقتًا طول الدورة بـ 28 يومًا ومدة الحيض بـ 5 أيام.';

  @override
  String get periodPredictionDisclaimer =>
      'هذا تقدير يستند إلى السجلات الحالية، والتواريخ مخصصة كمرجع لتدوين تفاصيل حياتك اليومية فقط.';

  @override
  String get periodStartedToday => 'بدأت اليوم';

  @override
  String get periodStillOngoing => 'ما زالت الدورة مستمرة';

  @override
  String get periodEndedToday => 'انتهت اليوم';

  @override
  String get periodDateNotReached => 'هذا اليوم لم يأتِ بعد～';

  @override
  String get periodDateBeforeStart =>
      'هذا التاريخ يسبق تاريخ بدء الدورة الشهرية الحالية.';

  @override
  String get periodMoodOkay => 'بخير';

  @override
  String get periodMoodHappy => 'سعيدة';

  @override
  String get periodMoodLow => 'محبطة';

  @override
  String get periodMoodUnwell => 'متعبة';

  @override
  String get periodMoodIrritable => 'منزعجة';

  @override
  String get periodMoodTired => 'مرهقة';

  @override
  String get periodMoodAnxious => 'قلقة';

  @override
  String get periodSymptomAbdominalPain => 'ألم في البطن';

  @override
  String get periodSymptomLowerBackPain => 'ألم أسفل الظهر';

  @override
  String get periodSymptomHeadache => 'صداع';

  @override
  String get periodSymptomBreastTenderness => 'ألم وتورم الثديين';

  @override
  String get periodSymptomSwelling => 'احتباس السوائل';

  @override
  String get periodSymptomSleepy => 'نعاس';

  @override
  String get periodSymptomIncreasedAppetite => 'زيادة الشهية';

  @override
  String get periodSymptomDigestiveDiscomfort => 'اضطرابات هضمية';

  @override
  String periodDiaryTitle(String characterName) {
    return 'يوميات $characterName الحنونة';
  }

  @override
  String get periodLoadFailed =>
      'فشل تحميل السجلات، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get periodWeekdaySun => 'الأحد';

  @override
  String get periodWeekdayMon => 'الاثنين';

  @override
  String get periodWeekdayTue => 'الثلاثاء';

  @override
  String get periodWeekdayWed => 'الأربعاء';

  @override
  String get periodWeekdayThu => 'الخميس';

  @override
  String get periodWeekdayFri => 'الجمعة';

  @override
  String get periodWeekdaySat => 'السبت';

  @override
  String get periodSaveInstruction =>
      'بعد اختيار الحالة، يرجى الضغط على «حفظ سجل اليوم» في الأسفل لحفظها نهائيًا.';

  @override
  String get periodTodayMood => 'مزاجك اليوم (يمكن اختيار أكثر من خيار)';

  @override
  String get periodMoodDescription =>
      'هذه ملاحظات يومية لهذا اليوم وليست رموزًا تُعرض على التقويم.';

  @override
  String get periodOtherMood => 'مزاج آخر';

  @override
  String get periodOtherMoodHint => 'مثال: أشعر بالظلم، أفتقد الشعور بالأمان……';

  @override
  String get periodTodaySymptoms =>
      'حالتك الجسدية اليوم (يمكن اختيار أكثر من خيار)';

  @override
  String get periodOtherSymptom => 'حالة جسدية أخرى';

  @override
  String get periodOtherSymptomHint => 'مثال: أشعر بالبرد، ليست لدي شهية……';

  @override
  String periodNoteForCharacter(String characterName) {
    return 'ما تريدين أن يعرفه $characterName (اختياري)';
  }

  @override
  String get periodNoteHint =>
      'مثال: أريد أن أرتاح بهدوء اليوم ولا أريد أن يضغط عليّ أحد……';

  @override
  String get periodSaving => 'جارٍ الحفظ…';

  @override
  String get periodSaveToday => 'حفظ سجل اليوم';

  @override
  String get periodHistory => 'سجل الدورات السابقة';

  @override
  String get periodOngoing => 'جارية';

  @override
  String periodTotalDays(int count) {
    return 'إجمالي $count أيام';
  }

  @override
  String get periodDeleteRecord => 'حذف السجل';

  @override
  String get privateProfilePleaseSignIn => 'يرجى تسجيل الدخول أولًا';

  @override
  String privateProfileLoreLoadFailed(String error) {
    return 'فشل تحميل شظايا الذاكرة: $error';
  }

  @override
  String privateProfileWriteNewLore(int count, int limit) {
    return 'كتابة شظية ذاكرة جديدة ($count / $limit)';
  }

  @override
  String get privateProfileNoLore => 'لا توجد شظايا ذاكرة بعد';

  @override
  String get privateProfileNoLoreHint =>
      'يمكنك هنا تنظيم إعدادات الاختبار وخيوط القصة والذكريات المهمة للشخصية.';

  @override
  String get privateProfileUntitledLore => 'شظية بلا عنوان';

  @override
  String get privateProfileEdit => 'تعديل';

  @override
  String get privateProfileDelete => 'حذف';

  @override
  String get privateProfileAddLore => 'إضافة شظية ذاكرة';

  @override
  String get privateProfileLoreTitle => 'العنوان';

  @override
  String get privateProfileLoreTeaser => 'تلميح مختصر';

  @override
  String get privateProfileLoreContent => 'المحتوى الكامل';

  @override
  String get privateProfileLockLore => 'قفل الشظية';

  @override
  String get privateProfileLockLoreHint =>
      'الشخصية الخاصة مرئية حاليًا للمبدع فقط. سيبقى هذا الحقل محفوظًا لاستخدامه عند جعل الشخصية عامة.';

  @override
  String get privateProfileCancel => 'إلغاء';

  @override
  String get privateProfileTitleContentRequired =>
      'يرجى إدخال العنوان والمحتوى';

  @override
  String get privateProfileLoreAdded => 'تمت إضافة شظية الذاكرة';

  @override
  String get privateProfileAddFailed =>
      'فشلت الإضافة، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get privateProfilePublish => 'نشر';

  @override
  String get privateProfileDeleteLoreTitle => 'حذف شظية الذاكرة';

  @override
  String get privateProfileDeleteLoreConfirm =>
      'هل أنت متأكد من حذف شظية الذاكرة هذه نهائيًا؟';

  @override
  String get privateProfileLoreDeleted => 'تم حذف شظية الذاكرة';

  @override
  String get privateProfileDeleteFailed =>
      'فشل الحذف، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get privateProfileEditLore => 'تعديل شظية الذاكرة';

  @override
  String get privateProfileSave => 'حفظ';

  @override
  String get editProfileBirthdayReminderTitle => 'تذكير صغير';

  @override
  String get editProfileBirthdayReminderContent =>
      'سيؤثر تاريخ الميلاد في تهاني الشخصية بعيد ميلادك وهدايا عيد الميلاد والفعاليات ذات الصلة.\n\nننصحك بالتأكد من تاريخ ميلادك قبل إكمال الإعداد،\nحتى لا تتأثر مكافآت عيد الميلاد المستقبلية.';

  @override
  String get editProfileGotIt => 'فهمت';

  @override
  String get editProfileBirthdayConfirmTitle => 'تأكيد تاريخ الميلاد';

  @override
  String get editProfileBirthdayConfirmContent =>
      'يرجى التأكد من صحة تاريخ الميلاد.\n\nسيُستخدم تاريخ الميلاد لتهاني عيد الميلاد وهداياه والفعاليات ذات الصلة.\n\nلمنع استلام مكافأة عيد الميلاد أكثر من مرة، لن تتمكن من تعديل تاريخ الميلاد مجددًا بعد إكمال الإعداد.\n\nهل أنت متأكد من استخدام تاريخ الميلاد هذا؟';

  @override
  String get editProfileReturnToEdit => 'العودة إلى التعديل';

  @override
  String get editProfileConfirmSetting => 'تأكيد الإعداد';

  @override
  String get editProfileDefaultNickname => 'المسافر الذي التقيناه للتو';

  @override
  String get editProfileNoChanges => 'لا توجد تغييرات تحتاج إلى الحفظ';

  @override
  String editProfileCreateFailed(String error) {
    return 'فشل إنشاء البيانات: $error';
  }

  @override
  String editProfileAvatarNumber(int number) {
    return 'الصورة الرمزية $number';
  }

  @override
  String get editProfileImageSelectionFailed =>
      'فشل اختيار الصورة، يرجى اختيار صورة أخرى';

  @override
  String get editProfileCancel => 'إلغاء';

  @override
  String get editProfileConfirm => 'تأكيد';

  @override
  String get editProfileImageProcessingFailed =>
      'فشلت معالجة الصورة، يرجى اختيار صورة أخرى';

  @override
  String editProfileLoadFailed(String error) {
    return 'فشل تحميل البيانات: $error';
  }

  @override
  String get editProfileBioLabel => 'النبذة الشخصية';

  @override
  String get editProfileBioHelper => 'عرّف بنفسك أو بأسلوبك الإبداعي باختصار';

  @override
  String get editProfileBioHint =>
      'مثال: أحب ابتكار شخصيات رومانسية خيالية ومتملكة وغامرة.';

  @override
  String get editProfileUserNotFound => 'تعذر العثور على المستخدم';

  @override
  String get editProfileGenerateIdFailed =>
      'فشل إنشاء معرّف اللاعب، يرجى المحاولة مرة أخرى';

  @override
  String get editProfileSignedInUserNotFound =>
      'تعذر العثور على المستخدم المسجل دخوله حاليًا';

  @override
  String editProfileAvatarReadFailed(int statusCode) {
    return 'فشل تحميل الصورة الرمزية، رمز الحالة: $statusCode';
  }

  @override
  String editProfileAvatarFileNotFound(String path) {
    return 'تعذر العثور على ملف الصورة الرمزية المحدد: $path';
  }

  @override
  String get editProfileAvatarEmpty => 'بيانات الصورة الرمزية فارغة';

  @override
  String get chatPageSendFailed => 'فشل الإرسال، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get chatPageRegenerateFailed =>
      'فشلت إعادة الإنشاء، وتم الاحتفاظ بالرسالة الأصلية. يرجى المحاولة مرة أخرى.';

  @override
  String get chatPageRegenerating => 'يعيد التفكير الآن...';

  @override
  String get chatPageThinkingTooLong =>
      'يبدو أنه غارق في التفكير، يرجى المحاولة مرة أخرى لاحقًا……';

  @override
  String get chatPageAlreadyReplying =>
      'إنه يرد الآن، يرجى الانتظار قليلًا وعدم الإرسال مرة أخرى';

  @override
  String get chatPageMediaUploadFailed =>
      'فشل رفع الوسائط، يرجى المحاولة مرة أخرى';

  @override
  String get chatPageReportReceived =>
      'شكرًا على بلاغك، سنتحقق منه في أقرب وقت ممكن';

  @override
  String chatPageMessagesDeleted(int count) {
    return 'تم حذف $count رسالة بنجاح';
  }

  @override
  String chatPageSelectPhotoFailed(String error) {
    return 'تعذر اختيار الصورة: $error';
  }

  @override
  String get chatPageRecordingNotFound => 'تعذر العثور على ملف التسجيل';

  @override
  String get chatPageRecordingEmpty => 'ملف التسجيل فارغ';

  @override
  String chatPageAudioPlaybackFailed(String error) {
    return 'فشل تشغيل الصوت: $error';
  }

  @override
  String get chatPageMicrophonePermissionRequired =>
      'يلزم السماح باستخدام الميكروفون لتسجيل الصوت';

  @override
  String chatPageStartRecordingFailed(String error) {
    return 'تعذر بدء التسجيل: $error';
  }

  @override
  String get chatPageRecordingCreationFailed =>
      'فشل إنشاء ملف التسجيل، يرجى التسجيل مرة أخرى';

  @override
  String chatPageRecordingFailed(String error) {
    return 'فشل التسجيل: $error';
  }

  @override
  String get chatPageRecordingNotFoundRetry =>
      'تعذر العثور على ملف التسجيل، يرجى التسجيل مرة أخرى';

  @override
  String get chatPageRecordingEmptyRetry =>
      'ملف التسجيل فارغ، يرجى التسجيل مرة أخرى';

  @override
  String get chatPageNoRecordingToSend => 'لا يوجد تسجيل يمكن إرساله';

  @override
  String chatPagePointCost(int count) {
    return '$count نقطة';
  }

  @override
  String get chatPageVoiceUploading => 'جارٍ رفع التسجيل الصوتي……';

  @override
  String get chatPageChangeWatermarkColor => 'تغيير لون العلامة المائية';

  @override
  String chatPageMinutesSeconds(int minutes, int seconds) {
    return '$minutes دقيقة و$seconds ثانية';
  }

  @override
  String chatPageSeconds(int seconds) {
    return '$seconds ثانية';
  }

  @override
  String get characterEditSelectSupportingCharacter =>
      'يرجى اختيار شخصية مساندة.';

  @override
  String get characterEditSelectGender => 'يرجى اختيار جنس الشخصية.';

  @override
  String get characterEditCharacterSettings => 'إعدادات الشخصية';

  @override
  String get characterEditWorldview => 'بناء العالم';

  @override
  String get characterEditSettingsMinLength =>
      'يجب ألا تقل إعدادات الشخصية عن 10 أحرف.';

  @override
  String get characterEditWorldviewMinLength =>
      'يجب ألا يقل بناء العالم عن 20 حرفًا.';

  @override
  String get characterEditSupportingCharacters => 'الشخصيات المساندة';

  @override
  String get characterEditCharacterImage => 'صورة الشخصية';

  @override
  String get characterEditWorldviewHint =>
      'صِف خلفية العالم وتاريخه وعصره ومناطقه وقواه وأنظمته وتقنياته وسحره وقواعده.';

  @override
  String get characterEditSettingsHint =>
      'صِف شخصية الدور وقيمه وطريقة تفكيره واستجاباته العاطفية وعاداته السلوكية وأسلوب حديثه ومعتقداته الأساسية.';

  @override
  String get characterEditUnknownCharacter => 'شخصية مجهولة';

  @override
  String get characterEditEditSupportingCharacter => 'تعديل الشخصية المساندة';

  @override
  String get characterEditAddSupportingCharacter => 'إضافة شخصية مساندة';

  @override
  String get characterEditSupportingCharacterName => 'اسم الشخصية المساندة';

  @override
  String get characterEditGender => 'الجنس';

  @override
  String get characterEditMale => 'ذكر';

  @override
  String get characterEditFemale => 'أنثى';

  @override
  String get characterEditOther => 'آخر';

  @override
  String get characterEditAge => 'العمر';

  @override
  String get characterEditIdentityOccupation => 'الهوية／المهنة';

  @override
  String get characterEditRelationshipWithMain => 'العلاقة بالشخصية الرئيسية';

  @override
  String get characterEditRelationshipHint =>
      'صِف الماضي والمواقف والمشاعر والأسرار والعلاقة الحالية مع الشخصية الرئيسية.';

  @override
  String get characterEditCharacterProfile => 'ملف الشخصية';

  @override
  String get characterEditCharacterProfileHint =>
      'صِف الشخصية والمظهر والعادات والقيم والقدرات والتفضيلات والأمور الحساسة والتجارب المهمة.';

  @override
  String get characterEditSpeakingStyle => 'أسلوب الحديث';

  @override
  String get characterEditSpeakingStyleHint =>
      'مثال: يتحدث بسرعة، ويكثر من التعليقات الساخرة، ويتكلم بصراحة.';

  @override
  String get characterEditSupportingNameRequired =>
      'يرجى إدخال اسم الشخصية المساندة.';

  @override
  String get characterEditSupportingGenderRequired =>
      'يرجى اختيار جنس الشخصية المساندة.';

  @override
  String get characterEditProfileRequired => 'يرجى إدخال إعدادات الشخصية.';

  @override
  String get characterEditRelationshipTooLong =>
      'تجاوز وصف العلاقة بالشخصية الرئيسية 1,500 حرف.';

  @override
  String get characterEditProfileTooLong => 'تجاوزت إعدادات الشخصية 1,500 حرف.';

  @override
  String get characterEditSave => 'حفظ';

  @override
  String get characterEditAdd => 'إضافة';

  @override
  String get creatorProfileNoBio => 'لم تتم إضافة نبذة شخصية بعد';

  @override
  String get creatorProfileNoBioHint => 'لم يضف هذا المبدع نبذة عنه بعد.';

  @override
  String get creatorProfileNoCreatorMoments => 'لم ينشر المبدع أي منشورات بعد';

  @override
  String get creatorProfileNoCreatorMomentsHint =>
      'سيظهر هنا المحتوى العام المنشور بهوية المبدع.';

  @override
  String get creatorProfileNoCharacterMoments =>
      'لم تنشر شخصيات المبدع أي منشورات بعد';

  @override
  String get creatorProfileNoCharacterMomentsHint =>
      'سيظهر هنا المحتوى الذي تنشره الشخصيات العامة التابعة للمبدع.';

  @override
  String get creatorProfileNoPublicMoments => 'لا توجد منشورات عامة بعد';

  @override
  String get creatorProfileNoPublicMomentsHint =>
      'ستظهر هنا المنشورات العامة التي ينشرها المبدع وشخصياته.';

  @override
  String get creatorProfilePublicWorks => 'الأعمال العامة';

  @override
  String get creatorProfileLikesReceived => 'الإعجابات المستلمة';

  @override
  String get creatorProfileFollow => 'متابعة';

  @override
  String get creatorProfileFollowing => 'تتم المتابعة';

  @override
  String get creatorProfileUnfollowed => 'تم إلغاء المتابعة';

  @override
  String creatorProfileFollowedCreator(String creatorName) {
    return 'تمت متابعة $creatorName';
  }

  @override
  String get creatorProfileOperationFailed =>
      'فشلت العملية، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String creatorProfileWorksLoadFailed(String error) {
    return 'فشل تحميل الأعمال: $error';
  }

  @override
  String get characterProfileShareInvitation => 'دعوة للقاء من LoveyDovey';

  @override
  String characterProfileShareCreator(String creatorName) {
    return 'المبدع: $creatorName';
  }

  @override
  String characterProfileShareMessage(String characterName) {
    return 'ابحث عن «$characterName» في LoveyDovey وابدأ قصة تخصكما وحدكما.';
  }

  @override
  String get characterProfileInvitationLabel => 'بطاقة دعوة الشخصية';

  @override
  String characterProfileCardCreator(String creatorName) {
    return 'المبدع  $creatorName';
  }

  @override
  String get characterProfileCardSearchHint => 'ابحث عن الشخصية وابدأ اللقاء';

  @override
  String get characterProfileScanToDownload => 'امسح للتنزيل';

  @override
  String characterProfileShareTitle(String characterName) {
    return 'مشاركة الشخصية «$characterName»';
  }

  @override
  String characterProfileShareSubject(String characterName) {
    return 'تعرّف على $characterName في LoveyDovey';
  }

  @override
  String get characterProfileShareFailed =>
      'فشل إنشاء بطاقة الدعوة، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get characterProfilePrivateShareUnavailable =>
      'لا يمكن مشاركة الشخصيات الخاصة حاليًا';

  @override
  String get characterProfileShareCard => 'مشاركة بطاقة الدعوة';

  @override
  String get characterProfileShareCharacter => 'مشاركة الشخصية';

  @override
  String get characterProfileReportCharacter => 'الإبلاغ عن الشخصية';

  @override
  String get characterProfileTranslate => 'ترجمة';

  @override
  String get loginMethodInfoTooltip => 'شرح طرق تسجيل الدخول';

  @override
  String get characterEditCoreSetting => 'الإعدادات الأساسية للشخصية';

  @override
  String get characterEditCoreSettingHint =>
      'يرجى وصف شخصية الدور، وأنماط سلوكه، وطريقة تعامله مع الآخرين، وأسلوب حديثه.\n\nمثال: يبدو باردًا وقليل الكلام، لكنه في الحقيقة شديد الاهتمام بالتفاصيل. يحافظ على مسافة مع الغرباء، ويعتني بمن يحب من خلال أفعاله، ويتحدث بإيجاز وصراحة، ولا يستخدم ألقابًا مفرطة في الحلاوة أو المغازلة.';

  @override
  String get characterEditNameDescription =>
      'هذا هو الاسم الذي سيظهر علنًا للشخصية، وسيُنشئ النظام اسم مستخدم للشخصية تلقائيًا بعد إكمال إنشائها.';

  @override
  String get characterEditNameHint => 'يرجى إدخال اسم الشخصية';

  @override
  String get characterEditAgeDescription =>
      'حدّد عمر الشخصية، ويمكنك أيضًا إدخال عمرها الظاهري وفقًا لعالم القصة.';

  @override
  String get characterEditAgeHint => 'مثال: 25';

  @override
  String get characterEditOccupationDescription =>
      'هوية الشخصية أو مهنتها الحالية، مثل طالب أو طبيب أو فارس أو رائد أعمال.';

  @override
  String get characterEditBirthdayDescription =>
      'حدّد تاريخ ميلاد الشخصية باستخدام أربعة أرقام أو افصل الشهر واليوم بشرطة مائلة.';

  @override
  String get characterEditBirthdayHint => 'مثال: 0825 أو 08/25';

  @override
  String get characterEditHeightDescription => 'حدّد طول الشخصية بالسنتيمتر.';

  @override
  String get characterEditHeightHint => 'مثال: 182';

  @override
  String get characterEditGenderDescription =>
      'سيستخدم النظام الضمائر المناسبة وفقًا لجنس الشخصية.';

  @override
  String get characterEditAppearanceDescription =>
      'صِف ملامح وجه الشخصية وتسريحة شعرها وملابسها وسماتها الجسدية الأخرى.';

  @override
  String get characterEditPlayerIdentityDescription =>
      'حدّد هوية اللاعب في القصة، مثل مساعد أو زميل في الدراسة أو صديق طفولة.';

  @override
  String get characterEditWorldviewDescription =>
      'صِف الحقبة والمكان والخلفية الاجتماعية والقواعد الخاصة التي تدور فيها القصة. سيظهر هذا المحتوى علنًا في قسم «نبذة عن الشخصية» بصفحة الشخصية، لذا تجنّب إدخال الأسرار أو أحداث القصة التي لا تريد أن يعرفها اللاعبون مسبقًا.';

  @override
  String get characterEditStorySummaryDescription =>
      'قدّم القصة في جملة قصيرة لتسهيل فهم سياق الشخصية بسرعة.';

  @override
  String get characterEditStorySummaryHint =>
      'مثال: قصة حب تبدأ بعلاقة تعاقدية مع طبيب بارد المشاعر';

  @override
  String get characterEditInitialStoryDescription =>
      'المشهد القصصي الذي سيظهر أولًا عندما يدخل اللاعب إلى غرفة الدردشة للمرة الأولى.';

  @override
  String get characterEditFirstLineDescription =>
      'أول جملة تقولها الشخصية عندما تقابل اللاعب للمرة الأولى.';

  @override
  String get characterEditCustomStatusBar => 'شريط حالة القصة (اختياري)';

  @override
  String get characterEditCustomStatusBarDescription =>
      'يُطبّق فقط على وضع القصة ووضع الانغماس. يمكنك إعداد معلومات حالة الشخصية أو موقعها أو ملابسها أو علاقتها لتظهر دائمًا في نهاية الرد؛ إذا تُرك فارغًا، فلن يتم إنشاء شريط حالة.';

  @override
  String get characterProfileCharacterIntro => 'نبذة عن الشخصية';

  @override
  String get characterProfileNoIntroduction =>
      'لم يضف المنشئ نبذة عن الشخصية بعد';

  @override
  String get characterProfileViewMore => 'عرض المزيد';

  @override
  String get characterProfileCollapse => 'عرض أقل';

  @override
  String get characterEditSelectedTagOrder =>
      'اسحب الوسوم المحددة لتعديل ترتيب عرضها';

  @override
  String get mailActivityGiftFallback => 'هدية الفعالية';

  @override
  String get mailFilterAll => 'الكل';

  @override
  String get mailFilterCollected => 'المحفوظة';

  @override
  String get mailCollectedEmptyTitle => 'لا توجد رسائل محفوظة حاليًا';

  @override
  String get mailCollectedEmptyHint =>
      'افتح الرسالة التي تريد حفظها واضغط على زر الحفظ في الزاوية العلوية اليمنى.';

  @override
  String get mailQixiLimitedBadge => 'حصري لمهرجان تشيشي';

  @override
  String get mailQixiThreeDayPromise => 'تشيشي LoveyDovey・وعد الأيام الثلاثة';

  @override
  String mailQixiFromCharacter(String characterName) {
    return 'رسالة تشيشي من $characterName';
  }

  @override
  String mailFromCharacter(String characterName) {
    return 'من $characterName';
  }

  @override
  String get mailQixiCollectionLabel => 'مجموعة تشيشي الحصرية لعام 2026';

  @override
  String get mailShareGenerating => 'جارٍ إنشاء صورة المشاركة……';

  @override
  String mailShareQixiMessage(String characterName) {
    return 'تلقيت رسالة تشيشي حصرية كتبها $characterName';
  }

  @override
  String get mailShareDefaultMessage => 'رسالة من «LoveyDovey»';

  @override
  String get mailShareImageFailed =>
      'فشل إنشاء صورة المشاركة، يرجى المحاولة لاحقًا';

  @override
  String get mailCollectedSuccess => 'تم حفظ هذه الرسالة';

  @override
  String get mailCollectedCancelled => 'تم إلغاء الحفظ';

  @override
  String get mailCollectedUpdateFailed =>
      'فشل تحديث حالة الحفظ، يرجى المحاولة لاحقًا';

  @override
  String get mailRemoveCollectionTooltip => 'إلغاء الحفظ';

  @override
  String get mailAddCollectionTooltip => 'حفظ الرسالة';

  @override
  String get mailShareTooltip => 'مشاركة الرسالة';

  @override
  String mailQixiDayNumber(int day) {
    return 'اليوم $day';
  }

  @override
  String get mailQixiDetailTitle => 'رسالة تشيشي الحصرية';

  @override
  String get mailQixiShareTooltip => 'مشاركة رسالة تشيشي';

  @override
  String get qixiMaxThreeFriends =>
      'يمكنك اختيار ما يصل إلى 3 شخصيات من الأصدقاء فقط في هذا الحدث';

  @override
  String get qixiLoginRequired =>
      'يرجى تسجيل الدخول أولًا قبل المشاركة في فعالية تشيشي';

  @override
  String get qixiOutsideEventPeriod => 'فعالية تشيشي غير متاحة حاليًا';

  @override
  String get qixiSelectAtLeastOne =>
      'يرجى اختيار شخصية صديق واحدة على الأقل أولًا';

  @override
  String get qixiMysteryCharacter => 'شخصية غامضة';

  @override
  String qixiOpeningStory(String characterName) {
    return '(مع اقتراب تشيشي، تستيقظ درب التبانة التي كانت غارقة في سبات عميق وسط ظلام الليل بهدوء. تتجمع أضواء النجوم المتناثرة ببطء على امتداد الأفق، كما لو كانت تنتظر شخصين مستعدين للوفاء بالموعد وكتابة اسميهما معًا.)\n\n(تقول الأسطورة إن جسر العقعق لا يضيء إلا لمن يرغبون حقًا في لقاء بعضهم البعض. عندما يظهر اسمك واسم \"$characterName\" معًا فوق نهر النجوم، يخترق شعاع خافت ستار الليل ويهبط في غرفة الدردشة هذه التي تخصكما وحدكما.)\n\n(من هذه اللحظة، أصبح لديكما \"وعد تشيشي لثلاثة أيام\". ليس من الضروري أن تكون الأيام متتالية، ولا حاجة إلى إعداد اعتراف كبير ومبالغ فيه. خلال فترة الفعالية، ما عليكما سوى العودة إلى هنا في ثلاثة أيام مختلفة ومشاركة تحية قصيرة، أو شعور ما، أو شيء صغير حدث اليوم.)\n\n(في كل مرة تلتقيان فيها بنجاح، يضيء نجم جديد على جسر العقعق. وعندما تكتمل أضواء الأيام الثلاثة، ستتحول المشاعر والذكريات المتناثرة في محادثاتكما، بعد انتهاء اليوم الثالث المكتمل، إلى رسالة تشيشي محدودة كُتبت لك وحدك.)\n\n(والآن، هبط أول شعاع من ضوء النجوم. وعلى الطرف الآخر من جسر العقعق، يبدو أن \"$characterName\" قد تلقى هذا الوعد أيضًا.)\n\n——وعد تشيشي لثلاثة أيام يبدأ الآن.';
  }

  @override
  String get qixiRoomOpenedLastMessage => 'بدأ وعد تشيشي لثلاثة أيام';

  @override
  String get qixiCompanionSlotsFull => 'تم اختيار جميع رفاق تشيشي المتاحين';

  @override
  String get qixiSingleRoomOpened => 'تم فتح غرفة دردشة تشيشي الخاصة';

  @override
  String qixiMultipleRoomsOpened(int count) {
    return 'تم فتح $count من غرف دردشة تشيشي الخاصة';
  }

  @override
  String get qixiCreateRoomFailed =>
      'تعذر إنشاء غرفة دردشة تشيشي، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get qixiEventStartsAt => 'تبدأ الفعالية في 8/19 الساعة 00:00';

  @override
  String get qixiEventActiveUntil =>
      'الفعالية جارية · تنتهي في 8/26 الساعة 23:59';

  @override
  String get qixiEventEnded => 'انتهت فعالية تشيشي الحالية';

  @override
  String get qixiEventHeroTitle =>
      'تشيشي في Lovey Time · لنلتقِ معًا على جسر العقعق';

  @override
  String get qixiCharacterSelected => 'تم الاختيار';

  @override
  String get qixiFriendListLoadFailed =>
      'تعذر تحميل قائمة الأصدقاء، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get qixiNoFriendCharacters => 'ليس لديك أي شخصيات أصدقاء حتى الآن';

  @override
  String get qixiNoFriendCharactersHint =>
      'اذهب أولًا للقاء شخصية تعجبك، ثم عد لعبور جسر العقعق معها!';

  @override
  String get qixiLoadingCharacter => 'جارٍ تحميل بيانات الشخصية……';

  @override
  String get qixiEventPageTitle => 'فعالية تشيشي محدودة';

  @override
  String get qixiEventRules =>
      'خلال فترة الفعالية، اختر 3 أيام مختلفة وأرسل رسالة في غرفة دردشة تشيشي الخاصة، ثم استلم ردًا من الشخصية بنجاح لإضاءة نجمة من نجوم الأيام الثلاثة. سيتم إرسال الرسالة المحدودة بعد انتهاء اليوم الثالث المكتمل. تعتمد تواريخ الفعالية والتقدم اليومي على توقيت تايوان (UTC+8).';

  @override
  String qixiSelectCompanions(int count) {
    return 'اختيار الرفاق ($count/3)';
  }

  @override
  String get qixiSelectionLockedHint =>
      'يمكنك اختيار ما يصل إلى 3 شخصيات أضفتها كأصدقاء، ولا يمكن تغييرها بعد الاختيار.';

  @override
  String get qixiConfirmCompanions => 'تأكيد الرفاق';

  @override
  String get encounterDailyQuote1 => 'اليوم، ربما تلتقي بقصة جديدة.';

  @override
  String get encounterDailyQuote2 => 'اليوم، دع قلبك يتحدث أولًا.';

  @override
  String get encounterDailyQuote3 => 'اليوم، ربما هناك من ينتظر لقاءك.';

  @override
  String get encounterDailyQuote4 => 'اليوم، جرّب أن تخطو إلى قصة جديدة.';

  @override
  String get encounterDailyQuote5 => 'أي خفقة قلب قد تنتظرك اليوم؟';

  @override
  String get encounterDailyQuote6 => 'اليوم، اترك لنفسك قليلًا من الترقب.';

  @override
  String get encounterDailyQuote7 => 'اليوم، لقاء جديد يبدأ بالفعل.';

  @override
  String get encounterDailyQuote8 => 'اليوم، ربما يحمل لك القدر مفاجأة صغيرة.';

  @override
  String get encounterDailyQuote9 => 'اليوم، دع لقاءً جديدًا يبدأ بهدوء.';

  @override
  String get encounterDailyQuote10 => 'اليوم، ربما يظهر شخص يجعلك تتوقف للحظة.';

  @override
  String get encounterDailyQuote11 => 'من تود أن تلتقي اليوم؟';

  @override
  String get encounterDailyQuote12 =>
      'اليوم، لا تدع فرصة لقاء تقترب منك بهدوء تفوتك.';

  @override
  String get encounterJoinedToday => 'انضموا إلى Lovey Time اليوم';

  @override
  String get encounterPopularChats => 'الكثيرون يتحدثون معهم مؤخرًا';

  @override
  String get qixiBannerActiveUntil => 'لفترة محدودة · حتى 8/26 الساعة 23:59';

  @override
  String get qixiBannerStartsAt => 'متاح حصريًا ابتداءً من 8/19';

  @override
  String get encounterRecentlyArrived => 'وصلوا مؤخرًا إلى Lovey Time';

  @override
  String get encounterRecentlyArrivedPlain => 'وصلوا مؤخرًا إلى Lovey Time';

  @override
  String get encounterViewMore => 'عرض المزيد';

  @override
  String get encounterLovePrompt => 'أي نوع من الحب تريد أن تعيشه اليوم؟';

  @override
  String get encounterNoCharacters => 'لا توجد شخصيات حاليًا';

  @override
  String get encounterAllLoveTags => 'جميع وسوم الحب';

  @override
  String get chatQixiLetterSent => 'تم إرسال الرسالة المحدودة';

  @override
  String get chatQixiLetterPendingTonight =>
      'اكتملت أضواء الأيام الثلاثة · سيتم إرسال الرسالة بعد انتهاء هذه الليلة';

  @override
  String get chatQixiTodayCompleted => 'تمت إضاءة نجمة اليوم';

  @override
  String get chatQixiTodayNotCompleted => 'لم يكتمل تقدم اليوم بعد';

  @override
  String get chatQixiPromiseTitle => 'تشيشي في Lovey Time · وعد الثلاثة أيام';

  @override
  String chatQixiStarProgress(int count) {
    return 'ضوء النجوم $count/3';
  }

  @override
  String get chatQixiProgressRule =>
      'أكمل الدردشة في أي ثلاثة أيام مختلفة لإضاءة النجوم. سيتم إرسال الرسالة المحدودة بعد انتهاء اليوم الثالث، ويتم احتساب التقدم اليومي وفق توقيت تايوان (UTC+8).';

  @override
  String chatQixiDayNumber(int day) {
    return 'اليوم $day';
  }

  @override
  String get chatWebPurchaseUnavailable =>
      'خدمة الشحن غير متاحة حاليًا على نسخة الويب. يرجى استخدام تطبيق Lovey Time لشراء الزهور أو الاشتراك.';

  @override
  String get chatAiThinkingTimeout =>
      'يبدو أنه غارق في التفكير. يرجى المحاولة مرة أخرى بعد قليل……';

  @override
  String get chatAiResponseBlocked =>
      'يبدو أن أفكاره قد تشوشت قليلًا. جرّب إعادة صياغة كلامك بطريقة ألطف.';

  @override
  String get chatRecordingStartFailed =>
      'تعذر بدء التسجيل. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get chatRecordingPlaybackFailed =>
      'تعذر تشغيل التسجيل. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get chatRoomNotReady =>
      'غرفة الدردشة ليست جاهزة بعد. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get chatRegenerateLimitReached =>
      'لقد استخدمت جميع محاولات إعادة التوليد لليوم';

  @override
  String get chatTypingIndicator => 'الطرف الآخر يكتب الآن……';

  @override
  String get chatRegenerateCountSyncFailed =>
      'تمت إعادة التوليد بنجاح، لكن تعذرت مزامنة عدد المحاولات. يرجى التحديث لاحقًا.';

  @override
  String get chatRoomNotFound => 'تعذر العثور على غرفة دردشة لهذه الشخصية';

  @override
  String get momentsSearchTooltip => 'البحث في جدار اللحظات';

  @override
  String get momentsCreatorNotFound => 'تعذر العثور على بيانات هذا المنشئ';

  @override
  String get momentCommentLoadFailed =>
      'فشل تحميل التعليقات، يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get momentCollapseReplies => 'طيّ الردود';

  @override
  String momentViewOtherReplies(int count) {
    return 'عرض $count ردود أخرى';
  }

  @override
  String get momentSwitchCommentIdentity => 'تبديل هوية التعليق';

  @override
  String get momentSendCommentTooltip => 'إرسال التعليق';

  @override
  String get momentShareCharactersLoadFailed =>
      'تعذر تحميل شخصيات الدردشة. يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get momentReportLoginRequired =>
      'يرجى تسجيل الدخول أولًا قبل الإبلاغ عن المنشور';

  @override
  String get momentReportSubmitted => 'تم إرسال البلاغ، وسنقوم بمراجعته';

  @override
  String get momentSelectShareCharacter =>
      'اختر شخصية سبق أن تحدثت معها لمشاركة هذا المنشور';

  @override
  String get momentTagCharacterUnavailable =>
      'هذه الإشارة غير مرتبطة بملف شخصية';

  @override
  String get momentCharacterNotFound => 'تعذر العثور على بيانات الشخصية';

  @override
  String get appUpdateTitle => 'يتوفر إصدار جديد';

  @override
  String get appUpdateMessage =>
      'يتوفر إصدار جديد من LoveyDovey. حدّث التطبيق للحصول على أحدث الميزات والإصلاحات.';

  @override
  String get appUpdateLater => 'لاحقًا';

  @override
  String get appUpdateGo => 'التحديث الآن';

  @override
  String get appUpdateCurrentVersion => 'الإصدار الحالي';

  @override
  String get appUpdateLatestVersion => 'أحدث إصدار';

  @override
  String get appUpdateStoreOpenFailed =>
      'تعذّر فتح صفحة المتجر الآن. يُرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get auth_error_requires_recent_login =>
      'انتهت صلاحية جلسة تسجيل الدخول. يرجى تسجيل الدخول مجددًا قبل تغيير كلمة المرور.';

  @override
  String get auth_error_too_many_requests =>
      'عدد المحاولات كبير جدًا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get auth_error_network_failed =>
      'اتصال الشبكة غير مستقر حاليًا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get change_password_failed =>
      'تعذر تغيير كلمة المرور. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get change_password_account_not_found =>
      'تعذر العثور على الحساب المسجل دخوله حاليًا. يرجى تسجيل الدخول مجددًا والمحاولة مرة أخرى.';

  @override
  String get change_password_not_password_account =>
      'لم يتم تسجيل الدخول إلى هذا الحساب باستخدام البريد الإلكتروني وكلمة المرور، لذلك لا يمكن تغيير كلمة المرور من هنا.';

  @override
  String get change_password_same_as_current =>
      'يجب أن تختلف كلمة المرور الجديدة عن كلمة المرور الحالية.';

  @override
  String get change_password_success_title => 'تم تحديث كلمة المرور';

  @override
  String get change_password_success_message =>
      'تم تعيين كلمة المرور الجديدة. يرجى استخدامها عند تسجيل الدخول في المرة القادمة.';

  @override
  String get change_password_title => 'تغيير كلمة المرور';

  @override
  String get change_password_security_title => 'أمان الحساب';

  @override
  String get change_password_description =>
      'أدخل كلمة المرور الحالية أولًا للتحقق من هويتك، ثم عيّن كلمة مرور جديدة لتسجيل الدخول.';

  @override
  String get change_password_current_label => 'كلمة المرور الحالية';

  @override
  String get change_password_current_required =>
      'يرجى إدخال كلمة المرور الحالية';

  @override
  String get change_password_new_label => 'كلمة المرور الجديدة';

  @override
  String get change_password_new_required => 'يرجى إدخال كلمة المرور الجديدة';

  @override
  String get change_password_new_min_length =>
      'يجب ألا تقل كلمة المرور الجديدة عن 6 أحرف';

  @override
  String get change_password_confirm_label => 'تأكيد كلمة المرور الجديدة';

  @override
  String get change_password_confirm_required =>
      'يرجى إدخال كلمة المرور الجديدة مرة أخرى';

  @override
  String get change_password_mismatch => 'كلمتا المرور الجديدتان غير متطابقتين';

  @override
  String get change_password_hint =>
      'يجب ألا تقل كلمة المرور عن 6 أحرف. بعد تغييرها، ستحتاج إلى استخدام كلمة المرور الجديدة عند تسجيل الدخول مجددًا على الأجهزة الأخرى.';

  @override
  String get character_npc_add => '＋ إضافة شخصية مساندة';

  @override
  String character_npc_added_count(int count) {
    return 'الشخصيات المساندة المضافة: $count';
  }

  @override
  String get character_npc_unnamed => 'شخصية مساندة بلا اسم';

  @override
  String get character_npc_title => 'إعدادات الشخصيات المساندة';

  @override
  String get character_npc_description =>
      'أنشئ شخصيات مهمة تظهر في القصة لتجعل عالم الشخصية أكثر اكتمالًا.';

  @override
  String get character_npc_empty_title => 'لم تتم إضافة أي شخصيات مساندة بعد';

  @override
  String get character_npc_empty_description =>
      'بعد إضافة شخصية مساندة، يمكنك عرض إعداداتها وتعديلها وإدارتها هنا.';

  @override
  String character_npc_age(String age) {
    return 'العمر: $age';
  }

  @override
  String character_npc_relationship_with_main(String relationship) {
    return 'علاقتها بالشخصية الرئيسية: $relationship';
  }

  @override
  String get character_management_login_required => 'يرجى تسجيل الدخول أولًا';

  @override
  String get character_management_character_tab => 'الشخصيات';

  @override
  String get character_management_creator_tab => 'المنشئون';

  @override
  String get character_management_blocked_characters_empty =>
      'ستظهر هنا الشخصيات التي أوقفت التواصل معها.';

  @override
  String get character_management_blocked_creators_load_failed =>
      'تعذر تحميل المنشئين المحظورين';

  @override
  String get character_management_blocked_creators_empty =>
      'سيظهر هنا المنشئون الذين حظرتهم.';

  @override
  String get character_management_creator_fallback => 'المنشئ';

  @override
  String get character_management_blocked_creator_status => 'المنشئ محظور';

  @override
  String get character_management_blocked_creator_description =>
      'لن تظهر شخصياته العامة أو الشخصيات التي يضيفها لاحقًا ضمن التوصيات.';

  @override
  String get character_management_unblock_creator_title => 'إلغاء حظر المنشئ';

  @override
  String character_management_unblock_creator_confirm(String creatorName) {
    return 'هل تريد بالتأكيد إلغاء حظر «$creatorName»؟\n\nبعد إلغاء الحظر، قد يظهر هذا المنشئ وشخصياته مجددًا ضمن المحتوى الموصى به. ستظل الشخصيات التي حظرتها بشكل منفصل محظورة.';
  }

  @override
  String character_management_unblock_creator_success(String creatorName) {
    return 'تم إلغاء حظر «$creatorName»';
  }

  @override
  String get character_management_unblock_creator_failed =>
      'تعذر إلغاء الحظر. يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get character_management_title => 'إدارة الشخصيات';

  @override
  String get character_management_subtitle =>
      'إدارة الشخصيات التي أوقفت التواصل معها';

  @override
  String get character_management_character_fallback => 'الشخصية';

  @override
  String get character_management_blocked_character_status => 'التواصل متوقف';

  @override
  String get character_management_blocked_character_description =>
      'سيتم إيقاف المحادثات والإشعارات دون حذف البيانات ذات الصلة.';

  @override
  String character_management_unblock_character_confirm(String charName) {
    return 'هل تريد بالتأكيد إلغاء حظر «$charName»؟ قد يظهر المحتوى المرتبط بها مجددًا بعد إلغاء الحظر.';
  }

  @override
  String get creator_follow_following_title => 'المنشئون الذين أتابعهم';

  @override
  String get creator_follow_followers_title => 'اللاعبون الذين يتابعونني';

  @override
  String creator_follow_load_failed(String error) {
    return 'فشل التحميل: $error';
  }

  @override
  String get creator_follow_empty_following_title => 'لا تتابع أي منشئ بعد';

  @override
  String get creator_follow_empty_followers_title => 'ليس لديك متابعون حاليًا';

  @override
  String get creator_follow_empty_following_description =>
      'تابع منشئيك المفضلين من صفحة الشخصية أو ورشة المنشئ.';

  @override
  String get creator_follow_empty_followers_description =>
      'سيظهر اللاعبون هنا عندما يتابعونك.';

  @override
  String get creator_follow_unknown_player => 'لاعب غير معروف';

  @override
  String creator_follow_player_id(String playerId) {
    return 'المعرّف: $playerId';
  }

  @override
  String get creator_follow_no_player_id => 'لم يتم تعيين معرّف اللاعب بعد';

  @override
  String get creator_follow_following => 'تتم المتابعة';

  @override
  String get creator_follow_unfollow_title => 'إلغاء المتابعة';

  @override
  String get creator_follow_unfollow_confirm =>
      'هل تريد بالتأكيد إلغاء متابعة هذا المنشئ؟';

  @override
  String get creator_follow_unfollow => 'إلغاء المتابعة';

  @override
  String interaction_history_load_failed(String error) {
    return 'فشل التحميل: $error';
  }

  @override
  String get creator_profile_report_creator => 'الإبلاغ عن المنشئ';

  @override
  String get creator_profile_block_creator => 'حظر المنشئ';

  @override
  String get creator_profile_report_login_required =>
      'يرجى تسجيل الدخول قبل الإبلاغ عن المنشئ';

  @override
  String get creator_profile_report_self_not_allowed =>
      'لا يمكنك الإبلاغ عن صفحة المنشئ الخاصة بك';

  @override
  String creator_profile_report_reason_prompt1(String creatorName) {
    return 'حدد سبب الإبلاغ عن «$creatorName»:';
  }

  @override
  String get creator_profile_report_reason_inappropriate =>
      'محتوى غير لائق أو مخالف';

  @override
  String get creator_profile_report_reason_harassment =>
      'مضايقة أو إساءة أو محتوى يحض على الكراهية';

  @override
  String get creator_profile_report_reason_impersonation =>
      'انتحال شخصية شخص آخر أو تزوير الهوية';

  @override
  String get creator_profile_report_reason_spam => 'محتوى مزعج أو ترويج ضار';

  @override
  String get creator_profile_report_success =>
      'تم استلام بلاغك. شكرًا لإبلاغنا';

  @override
  String get creator_profile_report_failed =>
      'تعذر إرسال البلاغ. يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get creator_profile_block_login_required =>
      'يرجى تسجيل الدخول قبل حظر المنشئ';

  @override
  String get creator_profile_block_self_not_allowed => 'لا يمكنك حظر نفسك';

  @override
  String creator_profile_block_confirm(String creatorName) {
    return 'هل تريد بالتأكيد حظر «$creatorName»؟\n\nبعد الحظر، لن تتمكن من رؤية الصفحة العامة لهذا المنشئ، وستتم أيضًا إضافة الشخصيات العامة التي أنشأها حاليًا إلى قائمة الحظر.';
  }

  @override
  String get creator_profile_block_confirm_button => 'تأكيد الحظر';

  @override
  String creator_profile_block_success(String creatorName) {
    return 'تم حظر «$creatorName»';
  }

  @override
  String get creator_profile_block_failed =>
      'تعذر الحظر. يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get creator_scene_edit_title_edit => 'تعديل المشهد';

  @override
  String get creator_scene_edit_title_add => 'إضافة مشهد';

  @override
  String get creator_scene_edit_heading_edit => 'عدّل مدخل هذه القصة';

  @override
  String get creator_scene_edit_heading_add => 'اكتب مدخلًا جديدًا للقصة';

  @override
  String get creator_scene_edit_scene_title_label => 'عنوان المشهد';

  @override
  String get creator_scene_edit_scene_title_hint =>
      'مثال: لقاء مجددًا في ليلة ممطرة';

  @override
  String get creator_scene_edit_description_label => 'وصف المشهد';

  @override
  String get creator_scene_edit_description_hint =>
      'صِف زمان القصة ومكانها والعلاقات والسياق المحيط بها.';

  @override
  String get creator_scene_edit_opening_label => 'افتتاحية الشخصية';

  @override
  String get creator_scene_edit_opening_hint =>
      'اكتب أول رد فعل أو أول جملة للشخصية عند دخولها إلى هذه القصة.';

  @override
  String get creator_scene_edit_opening_note =>
      'ستكون افتتاحية الشخصية هي المشهد الأول في هذه القصة، وستستمر الحوارات اللاحقة بالاستناد إلى شخصية الدور الأصلية.';

  @override
  String get creator_scene_edit_save_changes => 'حفظ التعديلات';

  @override
  String get creator_scene_edit_save_scene => 'حفظ المشهد';

  @override
  String get creator_scene_edit_error_title_required =>
      'يرجى إدخال عنوان المشهد أولًا.';

  @override
  String get creator_scene_edit_error_description_required =>
      'يرجى إدخال وصف المشهد أولًا.';

  @override
  String get creator_scene_edit_error_opening_required =>
      'يرجى كتابة افتتاحية الشخصية أولًا.';

  @override
  String get creator_scene_edit_save_failed =>
      'تعذر الحفظ. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get creator_scene_delete_title => 'حذف المشهد؟';

  @override
  String get creator_scene_delete_target_fallback => 'هذا المشهد';

  @override
  String creator_scene_delete_confirm(String sceneTitle) {
    return 'هل تريد بالتأكيد حذف «$sceneTitle»؟ لا يمكن التراجع عن الحذف.';
  }

  @override
  String get creator_scene_delete_failed =>
      'تعذر الحذف. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get creator_scene_empty_title => 'لا توجد مشاهد من إنشاء المبدعين بعد';

  @override
  String creator_scene_empty_description(String characterName) {
    return 'اكتب مسارات قصصية مختلفة لـ $characterName،\nحتى يتمكن اللاعبون من البدء من قصة أخرى.';
  }

  @override
  String get creator_scene_add => 'إضافة مشهد';

  @override
  String get creator_scene_unnamed => 'مشهد بلا عنوان';

  @override
  String creator_scene_opening(String opening) {
    return 'افتتاحية الشخصية: $opening';
  }

  @override
  String get creator_scene_edit => 'تعديل';

  @override
  String get creator_scene_delete => 'حذف';

  @override
  String get creator_scene_title => 'مشاهد المبدعين';

  @override
  String get creator_scene_character_unavailable =>
      'يتعذر حاليًا تحميل بيانات الشخصية.';

  @override
  String get creator_scene_load_failed =>
      'تعذر تحميل المشاهد. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get creator_scene_heading => 'أنشئ بدايات قصصية مختلفة للشخصية';

  @override
  String get custom_scene_edit_heading_edit => 'عدّل هذه القصة الخاصة بك وحدك';

  @override
  String get custom_scene_edit_heading_add =>
      'اكتب قصة خاصة بغرفة الدردشة هذه وحدها';

  @override
  String get custom_scene_edit_description_hint =>
      'صِف زمان القصة ومكانها والعلاقات والسياق الذي تريد أن تبدأ منه.';

  @override
  String get custom_scene_edit_note =>
      'لا تتضمن المشاهد التي تنشئها افتتاحية محددة مسبقًا للشخصية. بعد البدء، ستدخل الشخصية إلى القصة وفقًا لوصف المشهد وشخصيتها الأصلية.';

  @override
  String get moment_create_no_mentionable_characters =>
      'لا توجد حاليًا شخصيات يمكن الإشارة إليها.';

  @override
  String get moment_create_mention_my_characters => 'الإشارة إلى شخصياتي';

  @override
  String get moment_create_no_matching_characters =>
      'لم يتم العثور على شخصيات مطابقة';

  @override
  String get moment_create_my_character => 'شخصيتي';

  @override
  String get moment_create_friend_character => 'شخصية صديق';

  @override
  String get moment_create_public_visibility_hint =>
      'سيظهر المنشور على حائط اللحظات';

  @override
  String get moment_create_private_visibility_hint =>
      'سيكون مرئيًا ضمن النطاق المخصص فقط';

  @override
  String get moment_create_add_image => 'إضافة صورة';

  @override
  String get moment_create_mention_character => 'الإشارة إلى شخصية';

  @override
  String get moment_edit_content_hint => 'شارك ما تشعر به...';

  @override
  String get moment_forward_chat_preview => '【تمت مشاركة منشور】';

  @override
  String get feedback_image_too_large =>
      'يجب ألا يتجاوز حجم الصورة 10 ميغابايت';

  @override
  String get feedback_image_pick_failed =>
      'تعذر اختيار الصورة. يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get feedback_category_general => 'مشكلة عامة';

  @override
  String get feedback_category_bug => 'الإبلاغ عن خلل';

  @override
  String get feedback_category_suggestion => 'اقتراح ميزة';

  @override
  String get feedback_category_flower => 'مشكلة نقاط الزهور';

  @override
  String get feedback_category_payment => 'مشكلة الشحن أو الدفع';

  @override
  String get feedback_category_ai_reply => 'مشكلة في رد الذكاء الاصطناعي';

  @override
  String get feedback_category_character_report => 'الإبلاغ عن شخصية';

  @override
  String get feedback_category_moment_report => 'الإبلاغ عن منشور';

  @override
  String get feedback_screenshot_required_error =>
      'يرجى إرفاق لقطة شاشة لهذا النوع من المشكلات لمساعدتنا على التحقق منه';

  @override
  String get feedback_login_required => 'يرجى تسجيل الدخول قبل إرسال البلاغ';

  @override
  String get feedback_mail_received_title => '【تم إنشاء الطلب】تلقينا بلاغك';

  @override
  String feedback_mail_received_body(String caseNumber) {
    return 'لقد تلقينا بلاغك وسنتحقق منه في أقرب وقت ممكن.\n\nرقم الطلب: $caseNumber\n\nإذا كان لدى فريق الدعم رد إضافي، فسيتم إشعارك عبر صندوق بريد LoveyDovey.';
  }

  @override
  String get feedback_submit_success =>
      'تم إرسال البلاغ بنجاح. شكرًا لملاحظاتك!';

  @override
  String get feedback_submit_failed =>
      'تعذر الإرسال. يرجى التحقق من اتصال الشبكة والمحاولة مرة أخرى';

  @override
  String get feedback_category_section_title => 'نوع المشكلة';

  @override
  String get feedback_reported_content_title => 'المحتوى المُبلغ عنه';

  @override
  String get feedback_screenshot_required_title => 'لقطة شاشة للمشكلة (مطلوبة)';

  @override
  String get feedback_image_optional_title => 'صورة إضافية (اختيارية)';

  @override
  String get feedback_screenshot_required_description =>
      'يرجى إرفاق لقطة شاشة توضح المشكلة لمساعدة الفريق على التحقق من الحالة الفعلية.';

  @override
  String get feedback_image_optional_description =>
      'إذا كانت لديك صورة ذات صلة، فيمكنك إرفاقها لمساعدة الفريق على التحقق.';

  @override
  String get feedback_footer_message =>
      'ستساعدنا ملاحظاتك على مواصلة تحسين تجربة اللعب. شكرًا لك!';

  @override
  String get feedback_select_image_semantics => 'اختيار صورة للبلاغ';

  @override
  String get feedback_opening_gallery => 'جارٍ فتح معرض الصور…';

  @override
  String get feedback_select_image_upload => 'اضغط هنا لاختيار صورة ورفعها';

  @override
  String get feedback_image_requirements =>
      'يدعم JPG وPNG، وبحد أقصى 10 ميغابايت للصورة';

  @override
  String get feedback_submitting_semantics => 'جارٍ الإرسال';

  @override
  String get feedback_submit_semantics => 'إرسال البلاغ';

  @override
  String get feedback_submit_button => 'إرسال';

  @override
  String get feedback_remove_image => 'إزالة الصورة';

  @override
  String get feedback_selected_image => 'تم اختيار صورة';

  @override
  String get feedback_change_image => 'تغيير';

  @override
  String get profile_backpack_title => 'حقيبتي ومزاياي الحصرية';

  @override
  String get profile_backpack_total_spent => 'إجمالي رابطة الرومانسية الحالية';

  @override
  String profile_backpack_total_spent_amount(int amount) {
    return '$amount دولار تايواني';
  }

  @override
  String get profile_backpack_physical_gift_status =>
      'حالة فتح صندوق الهدايا الفعلي:';

  @override
  String get profile_backpack_vip_gift_title =>
      '【الحب الأسمى】صندوق هدايا VIP فعلي حصري';

  @override
  String get profile_backpack_vip_gift_contents =>
      'يتضمن: رسالة حصرية مكتوبة بخط اليد + دمية تمثل الشخصية + رسالة شكر رسمية';

  @override
  String get profile_backpack_edit_shipping_info =>
      'تعديل معلومات عنوان الاستلام';

  @override
  String get profile_backpack_unlock_shipping_info =>
      'تم فتحه! اضغط هنا لإدخال معلومات الاستلام';

  @override
  String get profile_backpack_shipping_registered =>
      'تم تسجيل عنوان الاستلام بنجاح، وسنبدأ بتجهيز هديتك في أقرب وقت ممكن!';

  @override
  String profile_backpack_amount_remaining(int amount) {
    return 'تبقى $amount دولار تايواني فقط لفتح الجائزة الفعلية الكبرى!';
  }

  @override
  String get profile_backpack_hint =>
      'تلميح: يمكنك عرض المظاهر وإطارات الصور الرمزية الأخرى داخل الحقيبة.';

  @override
  String get profile_backpack_close => 'إغلاق';

  @override
  String get profile_physical_gift_title =>
      '【الحب الأسمى】فتح صندوق الهدايا الفعلي';

  @override
  String get profile_physical_gift_description =>
      'شكرًا لك على دعمك الاستثنائي والمستمر لـ «LoveyDovey»!\nيرجى إدخال معلومات الاستلام أدناه، وسنرسل إليك رسالة حصرية مكتوبة بخط اليد ودمية تمثل الشخصية:';

  @override
  String get profile_physical_gift_recipient_name => 'الاسم الحقيقي للمستلم';

  @override
  String get profile_physical_gift_phone => 'رقم الهاتف';

  @override
  String get profile_physical_gift_address =>
      'عنوان الاستلام الكامل (متضمنًا الرمز البريدي)';

  @override
  String get profile_physical_gift_character_name =>
      'اسم الشخصية التي تريد دمية تمثلها';

  @override
  String get profile_physical_gift_character_hint =>
      'مثال: أدخل اسم الشخصية المطلوبة';

  @override
  String get profile_physical_gift_fill_later => 'إدخالها لاحقًا';

  @override
  String get profile_physical_gift_required_error =>
      'يرجى إدخال جميع معلومات الاستلام واسم الشخصية التي تريدها!';

  @override
  String get profile_physical_gift_submit_success =>
      'تم إرسال معلومات الاستلام بنجاح! ترقب مفاجأتنا الفعلية!';

  @override
  String get profile_physical_gift_confirm_submit => 'تأكيد الإرسال';

  @override
  String get profile_tooltip_announcement => 'الإعلانات';

  @override
  String get profile_tooltip_settings => 'الإعدادات';

  @override
  String get profile_tooltip_backpack => 'حقيبتي';

  @override
  String get profile_backpack_menu_title => 'حقيبتي';

  @override
  String get profile_about_me_title => 'نبذة عني';

  @override
  String get profile_tab_bio_title => 'التعريف بنفسي';

  @override
  String get profile_check_in_done => 'تم تسجيل الحضور';

  @override
  String get profile_check_in => 'تسجيل الحضور';

  @override
  String get profile_check_in_done_subtitle => 'تركت أثرك اليوم';

  @override
  String get profile_check_in_not_done_subtitle => 'لم تسجل حضورك اليوم بعد';

  @override
  String get profile_likes_label => 'الإعجابات';

  @override
  String get profile_heartbeat_diary_subtitle => 'دوّن لحظات خفقان قلبك';

  @override
  String get profile_create_scene => 'إنشاء مشهد';

  @override
  String get profile_link_invalid => 'تنسيق الرابط غير صحيح';

  @override
  String get profile_link_open_failed => 'تعذر فتح هذا الرابط';

  @override
  String get profile_link_default_name => 'رابطي';

  @override
  String get profile_publish_moment_short => 'اكتب عن هذه اللحظة';

  @override
  String edit_profile_default_link_name(int index) {
    return 'رابطي $index';
  }

  @override
  String get edit_profile_done => 'تم';

  @override
  String get edit_profile_social_links => 'وسائل التواصل والروابط';

  @override
  String get edit_profile_add_link => 'إضافة رابط';

  @override
  String get edit_profile_link_name_hint => 'اسم الرابط';

  @override
  String get edit_profile_link_url_hint => 'أدخل الرابط';

  @override
  String get theme_name_starlight => 'بنفسجي ضوء الذكريات';

  @override
  String get theme_name_sakura => 'وردي أزهار الكرز';

  @override
  String get theme_name_ocean => 'أزرق المحيط';

  @override
  String get theme_name_sunset => 'برتقالي الغروب';

  @override
  String get theme_name_mint => 'نعناع الغابة';

  @override
  String get theme_name_midnight => 'الوضع الليلي';

  @override
  String get theme_name_custom => 'لون مخصص';

  @override
  String get theme_selection_choose_theme => 'اختيار لون السمة';

  @override
  String get theme_selection_title => 'تغيير الأجواء';

  @override
  String get theme_selection_description =>
      'اختر لون السمة الذي يعجبك واجعل LoveyDovey يعكس أسلوبك.';

  @override
  String get theme_selection_preview => 'معاينة';

  @override
  String get theme_selection_characters => 'الشخصيات';

  @override
  String get theme_selection_posts => 'المنشورات';

  @override
  String theme_selection_previewing(String themeName) {
    return 'المعاينة الحالية: $themeName';
  }

  @override
  String get theme_selection_apply => 'تطبيق السمة';

  @override
  String get theme_selection_restore_default => 'استعادة الافتراضي';

  @override
  String get theme_selection_choose_color => 'اختر لونك الخاص';

  @override
  String theme_selection_applied(String themeName) {
    return 'تم تطبيق «$themeName»';
  }

  @override
  String get welcome_guide_help => 'دليل اللعب';

  @override
  String get welcome_guide_start => 'بدء الرحلة';

  @override
  String get welcome_guide_next => 'التالي';

  @override
  String get welcome_guide_welcome_title => 'مرحبًا بك في «LoveyDovey»';

  @override
  String get welcome_guide_welcome_description =>
      'هنا، قد يتحول كل لقاء إلى قصة لا تُنسى. نأمل أن يرافقك «LoveyDovey» في صنع ذكريات جميلة تخصكما وحدكما.';

  @override
  String get welcome_guide_chat_title => 'أوضاع الدردشة';

  @override
  String get welcome_guide_chat_description =>
      'يقدم «LoveyDovey» عدة أوضاع للدردشة، ولكل وضع تجربة تفاعلية مختلفة.';

  @override
  String get welcome_guide_daily_title => 'الوضع اليومي';

  @override
  String get welcome_guide_daily_description =>
      'تشاركا تفاصيل الحياة واستمتعا بأحاديث يومية مريحة وعفوية.';

  @override
  String get welcome_guide_story_title => 'وضع القصة';

  @override
  String get welcome_guide_story_description =>
      'تقدم في قصة الشخصية وافتح المزيد من الأحداث والتفاعلات الحصرية.';

  @override
  String get welcome_guide_immersive_title => 'الوضع الغامر';

  @override
  String get welcome_guide_immersive_description =>
      'استمتع بمحادثات أكثر اندماجًا وواقعية.';

  @override
  String get welcome_guide_chat_more =>
      'يمكنك معرفة المزيد عن أوضاع الدردشة من خلال «تعليمات اللعبة».';

  @override
  String get welcome_guide_encounter_title => 'اللقاءات';

  @override
  String get welcome_guide_encounter_description =>
      'لكل شخصية طابعها وقصتها وصوتها الفريد. عندما تقابل شخصية تعجبك، يمكنك إضافتها إلى أصدقائك والدردشة والتفاعل معها ومشاركة تفاصيل الحياة وصنع ذكريات تخصكما وحدكما.';

  @override
  String get welcome_guide_more_title => 'المزيد من المحتوى';

  @override
  String get welcome_guide_more_description =>
      'توجد أيضًا ميزات متنوعة مثل المجموعات والمنشئين والمتجر. انتقل إلى «تعليمات اللعبة» لمعرفة المزيد.';

  @override
  String preference_selection_max_error(int count) {
    return 'يمكنك اختيار $count تفضيلات كحد أقصى.';
  }

  @override
  String get preference_selection_save_failed =>
      'يتعذر حفظ تفضيلاتك حاليًا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get preference_selection_title => 'ما نوع الشخص الذي ترغب في لقائه؟';

  @override
  String get preference_selection_description =>
      'اختر من 3 إلى 5 أنواع تفضلها، ليبدأ LoveyDovey بالتعرف إليك من خلالها.';

  @override
  String get preference_selection_recommendation_note =>
      'ستتطور توصياتك تدريجيًا بناءً على تفاعلاتك الفعلية لتصبح أكثر ملاءمة لك.';

  @override
  String get preference_selection_selected => 'تم الاختيار';

  @override
  String get preference_selection_start => 'لنبدأ من هنا';

  @override
  String get preference_group_personality => 'الشخصية والطابع';

  @override
  String get preference_group_relationship_age => 'العلاقة・الفئة العمرية';

  @override
  String get preference_group_story => 'أجواء القصة';

  @override
  String get preference_tag_gentle => 'لطيف';

  @override
  String get preference_tag_cold => 'بارد ومتحفظ';

  @override
  String get preference_tag_scheming => 'ماكر';

  @override
  String get preference_tag_tsundere => 'تسونديري';

  @override
  String get preference_tag_loyal => 'مخلص';

  @override
  String get preference_tag_yandere => 'يانديري';

  @override
  String get preference_tag_mysterious => 'غامض';

  @override
  String get preference_tag_healing => 'مريح';

  @override
  String get preference_tag_gap_moe => 'شخصية متناقضة';

  @override
  String get preference_tag_older => 'أكبر سنًا';

  @override
  String get preference_tag_younger => 'أصغر سنًا';

  @override
  String get preference_tag_ceo => 'رئيس تنفيذي متسلط';

  @override
  String get preference_tag_school => 'مدرسي';

  @override
  String get preference_tag_workplace => 'مكان العمل';

  @override
  String get preference_tag_ancient => 'تاريخي';

  @override
  String get preference_tag_nonhuman => 'غير بشري';

  @override
  String get encounter_load_failed =>
      'تعذر تحميل بيانات اللقاءات. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get encounter_no_available_characters =>
      'لا توجد حاليًا شخصيات متاحة للقائها';

  @override
  String get encounter_category_empty => 'لا توجد حاليًا شخصيات ضمن هذه الفئة';

  @override
  String get encounter_category_all => 'الكل';

  @override
  String get encounter_category_xianxia => 'فانتازيا الخلود';

  @override
  String get encounter_category_childhood_friend => 'صديق الطفولة';

  @override
  String get encounter_category_master_disciple => 'المعلم والتلميذ';

  @override
  String get encounter_category_sweet_romance => 'رومانسية حلوة';

  @override
  String get encounter_category_other => 'أخرى';

  @override
  String get character_edit_tab_character_settings => 'إعدادات الشخصية';

  @override
  String get character_edit_test => 'اختبار';

  @override
  String get character_edit_supporting_basic_info => 'المعلومات الأساسية';

  @override
  String get character_edit_supporting_main_setting =>
      'العلاقة بالشخصية الرئيسية';

  @override
  String get character_edit_supporting_main_description =>
      'صِف علاقة هذه الشخصية المساندة بالشخصية الرئيسية ومكانتها في القصة.';

  @override
  String get character_edit_banner_preview_hint =>
      'اضغط على الصورة لمعاينتها بالحجم الكامل';

  @override
  String get character_edit_main_photo_hint =>
      'ستُستخدم الصورة الأولى كصورة رمزية رئيسية';

  @override
  String get character_edit_other_photos => 'صور أخرى للشخصية';

  @override
  String get character_edit_photo_action_hint =>
      'اضغط على الصورة لمعاينتها، أو اضغط على رمز القلم لتعديل إعداداتها';

  @override
  String character_edit_over_limit_warning(String label, String count) {
    return 'تجاوز حقل $label الحد الأقصى البالغ $count حرفًا. يرجى تعديله قبل النشر.';
  }

  @override
  String get memo_notification_channel_name => 'تذكيرات المذكرات';

  @override
  String get memo_notification_channel_description =>
      'تذكّر الشخصيات اللاعبين بالمذكرات التي أعدّوها';

  @override
  String memo_notification_title(String characterName) {
    return 'يذكّرك $characterName';
  }

  @override
  String memo_notification_tsundere(String memoContent) {
    return 'ليس لأنني قلقة عليك، بل لأنني لا أريدك أن تنسى. لا تنسَ اليوم: $memoContent';
  }

  @override
  String memo_notification_dominant(String memoContent) {
    return 'لقد سجّلت جدولك من أجلك، فأنجزه في الموعد. لا تنسَ اليوم: $memoContent';
  }

  @override
  String memo_notification_yandere(String memoContent) {
    return 'لا يمكنك أن تنسى، فأنا سأظل أتذكر دائمًا. لا تنسَ اليوم: $memoContent';
  }

  @override
  String memo_notification_gentle(String memoContent) {
    return 'خشيت أن تنشغل وتنسى، لذلك أردت تذكيرك. لا تنسَ اليوم: $memoContent';
  }

  @override
  String memo_notification_cold(String memoContent) {
    return 'لدي تذكير لك. لا تنسَ اليوم: $memoContent';
  }

  @override
  String memo_notification_sunny(String memoContent) {
    return 'مرحبًا، ما زال لديك أمر مهم اليوم! لا تنسَ: $memoContent';
  }

  @override
  String memo_notification_lazy(String memoContent) {
    return 'مع أنني أريد الاستمرار في الاستلقاء، لا بد أن أذكّرك. لا تنسَ اليوم: $memoContent';
  }

  @override
  String memo_notification_older(String memoContent) {
    return 'كن مطيعًا ولا تنسَ ما عليك فعله اليوم. تذكّر: $memoContent';
  }

  @override
  String memo_notification_younger(String memoContent) {
    return 'لقد تذكّرت هذا من أجلك! لا تنسَ اليوم: $memoContent';
  }

  @override
  String memo_notification_mechanical(String memoContent) {
    return 'تم تفعيل التذكير. مهمة اليوم: $memoContent';
  }

  @override
  String memo_notification_default(String memoContent) {
    return 'لا تنسَ اليوم: $memoContent';
  }

  @override
  String get recommendation_load_failed =>
      'يتعذر تحميل التوصيات حاليًا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get recommendation_reload => 'إعادة التحميل';

  @override
  String get recommendation_empty => 'لا توجد حاليًا شخصيات يمكن التوصية بها.';

  @override
  String get recommendation_title => 'لقاءات اخترناها لك';

  @override
  String get recommendation_featured_title => 'ابدأ بالتعرف إلى هؤلاء';

  @override
  String get recommendation_featured_subtitle =>
      'سنضع اللقاءات الأكثر ملاءمة لك في المقدمة.';

  @override
  String get recommendation_matched_behavior_title => 'أقرب فأقرب إلى تفضيلاتك';

  @override
  String get recommendation_matched_initial_title =>
      'بناءً على تفضيلاتك الأولى';

  @override
  String get recommendation_matched_behavior_subtitle =>
      'ابتداءً من اليوم الرابع، ستؤثر تفاعلاتك الأخيرة أيضًا في ترتيب التوصيات.';

  @override
  String get recommendation_matched_initial_subtitle =>
      'سنستخدم حاليًا الوسوم التي اخترتها في البداية لتضييق نطاق الخيارات.';

  @override
  String get recommendation_explore_title => 'قد يعجبك أيضًا';

  @override
  String get recommendation_explore_subtitle =>
      'سنحتفظ ببعض الخيارات العشوائية لتلتقي أحيانًا بأشخاص مختلفين.';

  @override
  String get recommendation_refreshing => 'جارٍ إعداد لقاءات جديدة لك……';

  @override
  String get recommendation_badge_for_you => 'موصى به لك';

  @override
  String get recommendation_badge_featured => 'لقاء مميز';

  @override
  String get recommendation_badge_explore => 'استكشاف';

  @override
  String get recommendation_default_occupation_hint =>
      'افتح الصفحة وألقِ نظرة، فقد يكون هذا لقاءك القادم الذي يخفق له قلبك.';

  @override
  String get recommendation_explore_fallback =>
      'جرّب اتجاهًا مختلفًا، فقد يصادف تمامًا ما يجعل قلبك يخفق.';

  @override
  String get recommendation_behavior_hint_similar_type =>
      'تتوقف مؤخرًا كثيرًا عند شخصيات من هذا النوع';

  @override
  String get recommendation_behavior_hint_forming =>
      'تفضيلاتك في التفاعل بدأت تتشكل تدريجيًا';

  @override
  String get recommendation_behavior_hint_recent =>
      'تم اختياره لك بناءً على تفاعلاتك الأخيرة';

  @override
  String recommendation_reason_liked_tags(String tags) {
    return 'لأنك تحب・$tags';
  }

  @override
  String get recommendation_reason_popular =>
      'نال اهتمام عدد كبير من الأشخاص مؤخرًا';

  @override
  String get recommendation_reason_default =>
      'ربما يكون هذا لقاءك المناسب القادم';

  @override
  String get scene_delete_title => 'حذف المشهد؟';

  @override
  String scene_delete_content(String title) {
    return 'هل تريد بالتأكيد حذف «$title»؟ لا يمكن التراجع عن الحذف.';
  }

  @override
  String get scene_unnamed => 'مشهد بلا عنوان';

  @override
  String get scene_cancel => 'إلغاء';

  @override
  String get scene_delete => 'حذف';

  @override
  String get scene_delete_failed =>
      'تعذر الحذف. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get scene_start_failed =>
      'يتعذر بدء المشهد حاليًا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get scene_end_title => 'إنهاء المشهد؟';

  @override
  String get scene_end_content =>
      'ستعود إلى الدردشة العادية بعد الإنهاء، ولن تُحذف المحادثة الحالية.';

  @override
  String get scene_end_action => 'إنهاء المشهد';

  @override
  String get scene_ended => 'انتهى المشهد';

  @override
  String get scene_end_failed =>
      'يتعذر إنهاء المشهد حاليًا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get scene_active_label => 'جارٍ حاليًا';

  @override
  String scene_opening(String opening) {
    return 'افتتاحية الشخصية: $opening';
  }

  @override
  String get scene_edit => 'تعديل';

  @override
  String get scene_start => 'بدء المشهد';

  @override
  String get scene_creator_load_failed => 'تعذر تحميل مشاهد المنشئ.';

  @override
  String get scene_creator_empty_title =>
      'لا توجد مشاهد من إنشاء المنشئ حاليًا';

  @override
  String get scene_creator_empty_body =>
      'لم ينشئ صاحب هذه الشخصية أي قصص إضافية بعد.';

  @override
  String get scene_custom_load_failed => 'تعذر تحميل المشاهد المخصصة.';

  @override
  String get scene_custom_empty_title => 'لم تنشئ أي مشاهد بعد';

  @override
  String get scene_custom_empty_body =>
      'أنشئ قصة خاصة بك وحدك لغرفة الدردشة هذه.';

  @override
  String get scene_add => 'إضافة مشهد';

  @override
  String get scene_title => 'المشاهد';

  @override
  String get scene_tab_creator => 'مشاهد المنشئ';

  @override
  String get scene_tab_custom => 'إنشاء مخصص';

  @override
  String get chat_book_player => 'اللاعب';

  @override
  String get chat_book_title => 'سجل المحادثة';

  @override
  String get chat_book_export_pdf => 'تصدير بصيغة PDF';

  @override
  String get chat_book_brand => '— LoveyDovey';

  @override
  String get chat_book_change_cover => 'تغيير الغلاف';

  @override
  String get chat_book_cover_subtitle => 'لحظاتنا معًا · كتاب تذكاري للمحادثات';

  @override
  String get chat_book_choose_cover => 'اختيار غلاف الكتاب التذكاري';

  @override
  String get chat_book_initial_story => 'القصة الأولى';

  @override
  String chat_book_transcript_title(String characterName) {
    return '$characterName · سجل المحادثة';
  }

  @override
  String chat_book_continuation(String name) {
    return '$name · تابع';
  }

  @override
  String get chat_book_previous_page => 'الصفحة السابقة';

  @override
  String get chat_book_next_page => 'الصفحة التالية';

  @override
  String get chat_book_photo_message => '〔صورة〕';

  @override
  String get chat_book_audio_message => '〔رسالة صوتية〕';

  @override
  String get chat_book_generic_message => '〔رسالة〕';

  @override
  String chat_book_export_failed(String error) {
    return 'تعذر التصدير بصيغة PDF: $error';
  }

  @override
  String email_policy_open_failed(String title) {
    return 'تعذر فتح $title. يرجى التحقق من اتصال الشبكة والمحاولة مرة أخرى.';
  }

  @override
  String email_policy_read_instruction(String title) {
    return 'يرجى فتح $title وقراءته بالكامل أولًا. بعد القراءة، ارجع إلى «LoveyDovey» للضغط على «لقد قرأت وأوافق».';
  }

  @override
  String get email_policy_opening => 'جارٍ الفتح……';

  @override
  String email_policy_read_full(String title) {
    return 'قراءة $title بالكامل';
  }

  @override
  String email_policy_opened_ready(String title) {
    return 'تم فتح $title. يمكنك الآن تأكيد الموافقة.';
  }

  @override
  String email_policy_not_opened(String title) {
    return 'لم يتم فتح $title بعد.';
  }

  @override
  String get email_policy_cancel_login => 'إلغاء تسجيل الدخول';

  @override
  String get email_policy_agree => 'لقد قرأت وأوافق';

  @override
  String get email_policy_status_check_failed =>
      'يتعذر حاليًا التحقق من حالة الموافقة على الشروط. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get email_policy_login_notice =>
      'عند تسجيل الدخول لأول مرة أو تحديث الشروط، سيُطلب منك قراءة شروط الخدمة وسياسة الخصوصية والموافقة عليهما.';

  @override
  String get email_policy_refresh => 'تحديث';

  @override
  String get email_policy_page_load_failed => 'تعذر تحميل الصفحة';

  @override
  String get email_policy_check_network =>
      'يرجى التحقق من اتصال الشبكة والمحاولة مرة أخرى.';

  @override
  String get email_policy_reload => 'إعادة التحميل';

  @override
  String get login_method_info_google_title =>
      'تسجيل الدخول السريع باستخدام Google';

  @override
  String get login_method_info_apple_title => 'تسجيل الدخول باستخدام Apple';

  @override
  String get login_method_info_facebook_title =>
      'تسجيل الدخول باستخدام Facebook';

  @override
  String get login_method_info_email_title =>
      'حساب LoveyDovey (البريد الإلكتروني)';

  @override
  String get login_method_info_email_provider =>
      'حساب LoveyDovey (البريد الإلكتروني)';

  @override
  String login_method_info_content(String providerName) {
    return 'سجّل الدخول إلى «LoveyDovey» باستخدام $providerName.\n\nيرجى الانتباه:\n\n• يُعد $providerName نظام حساب مختلفًا عن طرق تسجيل الدخول الأخرى.\n\n• إذا أنشأت حسابًا باستخدام $providerName، فيرجى الاستمرار في تسجيل الدخول بالطريقة نفسها.\n\n• لن تتم مشاركة بيانات الشخصيات وسجل المحادثات والمشتريات مع الحسابات المستخدمة عبر طرق تسجيل الدخول الأخرى.\n\nننصحك بالاستمرار في استخدام طريقة تسجيل الدخول نفسها بعد تسجيل الدخول لأول مرة، لتجنب إنشاء حسابات مختلفة لا يمكنها مشاركة البيانات.';
  }

  @override
  String get login_method_info_got_it => 'فهمت';

  @override
  String creator_studio_delete_failed(String error) {
    return 'تعذر الحذف: $error';
  }

  @override
  String get creator_studio_subtitle =>
      'اجمع أفكارك ونظّم شخصياتك وأكمل أعمالك على مهل';

  @override
  String creator_studio_load_failed(String error) {
    return 'تعذر تحميل الاستوديو: $error';
  }

  @override
  String get creator_studio_add_character => 'إضافة شخصية';

  @override
  String get creator_studio_public_title => 'الشخصيات العامة';

  @override
  String get creator_studio_public_subtitle =>
      'منشورة ويمكن للاعبين الآخرين اكتشافها';

  @override
  String get creator_studio_public_empty => 'لا توجد شخصيات عامة حاليًا';

  @override
  String get creator_studio_private_title => 'الشخصيات الخاصة';

  @override
  String get creator_studio_private_subtitle => 'يمكنك أنت وحدك رؤيتها';

  @override
  String get creator_studio_private_empty => 'لا توجد شخصيات خاصة حاليًا';

  @override
  String get creator_studio_draft_title => 'المسودات';

  @override
  String get creator_studio_draft_subtitle => 'أعمال لم تكتمل بعد';

  @override
  String get creator_studio_draft_empty => 'لا توجد حاليًا مسودات غير مكتملة';

  @override
  String get creator_studio_draft_empty_title => 'لا توجد مسودات هنا بعد';

  @override
  String get creator_studio_draft_empty_hint =>
      'عندما تأتيك فكرة، دوّنها هنا أولًا';

  @override
  String get creator_studio_status_public => 'عام';

  @override
  String get creator_studio_status_private => 'خاص';

  @override
  String get creator_studio_status_draft => 'مسودة';

  @override
  String get creator_studio_character_load_failed =>
      'تعذر تحميل بيانات الشخصية';

  @override
  String get creator_studio_delete_draft_tooltip => 'حذف المسودة';

  @override
  String get creator_studio_unnamed_creator => 'منشئ بلا اسم';

  @override
  String get creator_studio_no_bio => 'لم تتم إضافة نبذة شخصية بعد';

  @override
  String get chat_input_tools => 'الأدوات';

  @override
  String get chat_input_expand_tools => 'عرض الأدوات';

  @override
  String get chat_input_stop => 'إيقاف';

  @override
  String get chat_input_send => 'إرسال';

  @override
  String get chat_side_menu_section_chat => 'الدردشة';

  @override
  String get chat_side_menu_section_relationship => 'العلاقة';

  @override
  String get chat_side_menu_section_memory => 'إدارة الذاكرة';

  @override
  String get character_navigator_confidential_title => 'ملف سري';

  @override
  String get character_navigator_unavailable_message =>
      'ربما أصبحت هذه الشخصية خاصة، أو أُزيلت من المنصة، أو أُرشفت بسبب مخالفة، أو حُذفت.';

  @override
  String get character_navigator_got_it => 'فهمت';

  @override
  String get character_navigator_load_failed_title => 'تعذر التحميل';

  @override
  String get character_navigator_load_failed_message =>
      'يتعذر تحميل بيانات الشخصية مؤقتًا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get character_navigator_confirm => 'تأكيد';

  @override
  String get character_profile_add_bookmark => 'إضافة الشخصية إلى المفضلة';

  @override
  String get character_profile_remove_bookmark => 'إزالة من المفضلة';

  @override
  String get character_profile_pronoun_female => 'هي';

  @override
  String get character_profile_pronoun_male => 'هو';

  @override
  String get character_profile_pronoun_neutral => 'هم';

  @override
  String get chat_home_pin_limit_reached =>
      'يمكنك تثبيت 3 محادثات كحد أقصى. يرجى إلغاء تثبيت محادثة أخرى أولًا.';

  @override
  String get chat_home_pinned_success => 'تم تثبيت المحادثة';

  @override
  String get chat_home_unpinned_success => 'تم إلغاء التثبيت';

  @override
  String chat_home_pin_update_failed(String error) {
    return 'تعذر تحديث حالة التثبيت: $error';
  }

  @override
  String get chat_home_unpin => 'إلغاء التثبيت';

  @override
  String get chat_home_pin => 'تثبيت المحادثة';

  @override
  String chat_home_time_label(String time) {
    return 'الوقت: $time';
  }

  @override
  String get main_check_in_already_done => 'لقد سجلت حضورك اليوم بالفعل';

  @override
  String get nav_recommend => 'التوصيات';

  @override
  String get moments_auto_reply_title =>
      'السماح للذكاء الاصطناعي بالرد تلقائيًا على منشورات اللاعبين';

  @override
  String get moments_auto_reply_description =>
      'عند تفعيل هذا الخيار، سيتمكن النظام من اختيار الشخصية للرد على منشورات اللاعبين.';

  @override
  String get mailOriginalQuestionLabel => 'سؤالك الأصلي';

  @override
  String get hidden_moments_empty_hint => 'لا توجد منشورات مخفية حاليًا';

  @override
  String get moment_search_unavailable =>
      'البحث غير متاح مؤقتًا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get moment_search_hint =>
      'البحث في المنشورات العامة أو الشخصيات أو المنشئين';

  @override
  String get moment_search_instruction =>
      'أدخل محتوى المنشور أو اسم الشخصية أو اسم المنشئ';

  @override
  String get moment_search_no_results =>
      'لم يتم العثور على منشورات عامة ذات صلة';

  @override
  String get settingsErrorTitle => 'حدث خطأ';

  @override
  String get settingsChangePasswordSubtitle =>
      'تحقق من كلمة المرور الحالية، ثم عيّن كلمة مرور جديدة لتسجيل الدخول';

  @override
  String get settingsCreatorGuidelines => 'إرشادات المنشئين';

  @override
  String get settingsPlayGuide => 'دليل اللعب';

  @override
  String get language_selection_subtitle => 'اختر اللغة التي تفضل استخدامها';

  @override
  String get search_character_hint => 'البحث عن شخصية أو منشئ أو مهنة أو وسم';

  @override
  String get search_character_clear => 'مسح';

  @override
  String get search_character_recent => 'عمليات البحث الأخيرة';

  @override
  String get search_character_load_failed =>
      'تعذر تحميل بيانات البحث. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get search_character_popular => 'الأكثر إعجابًا مؤخرًا';

  @override
  String search_character_result_count(int count) {
    return 'تم العثور على $count شخصية';
  }

  @override
  String get shop_tab_monthly => 'قسم البطاقة الشهرية';

  @override
  String shop_joined_days(int days) {
    return 'مضى على قدومك إلى LoveyDovey عدد $days من الأيام';
  }

  @override
  String get shop_vip_tier_1_title => 'حب من النظرة الأولى';

  @override
  String get shop_vip_tier_1_reward => '20 نقطة زهرة + لقب حصري للمبتدئين';

  @override
  String get shop_vip_tier_2_title => 'خفقان الضوء الخافت';

  @override
  String get shop_vip_tier_2_reward =>
      'إطار صورة رمزية حصري 【خفقان الضوء الخافت】';

  @override
  String get shop_vip_tier_3_title => 'همسات السماء المرصعة بالنجوم';

  @override
  String get shop_vip_tier_3_reward => 'فقاعة دردشة حصرية + 50 نقطة زهرة';

  @override
  String get shop_vip_tier_4_title => 'غروب رومانسي';

  @override
  String get shop_vip_tier_4_reward => 'أيقونة حصرية للتطبيق';

  @override
  String get shop_vip_tier_5_title => 'خفقان القلب';

  @override
  String get shop_vip_tier_5_reward =>
      'تأثير لمس الشاشة (Lottie) + 100 نقطة زهرة';

  @override
  String get shop_vip_tier_6_title => 'عهد أبدي';

  @override
  String get shop_vip_tier_6_reward =>
      'إطار صورة رمزية متحرك متقدم + 200 نقطة زهرة';

  @override
  String get shop_vip_tier_7_title => 'تلاقي الأرواح';

  @override
  String get shop_vip_tier_7_reward =>
      'تأثير متحرك لفقاعة الدردشة + لقب متقدم حصري';

  @override
  String get shop_vip_tier_8_title => 'وفاء لا يخص سواك';

  @override
  String get shop_vip_tier_8_reward => 'شارة اسم متحركة فاخرة + 500 نقطة زهرة';

  @override
  String get shop_vip_tier_9_title => 'نهر النجوم المتلألئ';

  @override
  String get shop_vip_tier_9_reward =>
      'تأثير دخول Lottie حصري + خدمة عملاء حصرية';

  @override
  String get shop_vip_tier_10_title => 'الحب الأسمى';

  @override
  String get shop_vip_tier_10_reward =>
      '【صندوق هدايا VIP فعلي حصري】 (رسالة مكتوبة بخط اليد + دمية الشخصية)';

  @override
  String get shop_vip_total_bond => 'إجمالي رابطة الرومانسية';

  @override
  String get shop_vip_all_unlocked => 'لقد فتحت جميع المزايا الفاخرة!';

  @override
  String shop_vip_next_unlock(int amount) {
    return 'اشحن بمبلغ إضافي قدره $amount دولار تايواني لفتح المستوى التالي';
  }

  @override
  String get call_connecting => 'جارٍ توصيل المكالمة...';

  @override
  String get call_listening_auto_send =>
      'جارٍ الاستماع... (سيتم الإرسال تلقائيًا عند الانتهاء من التحدث)';

  @override
  String get call_listening_release_to_send =>
      'جارٍ الاستماع... (ارفع إصبعك للإرسال)';

  @override
  String call_sending_transcript(String text) {
    return ' $text\n\n(جارٍ الإرسال...)';
  }

  @override
  String get help_translation_fallback =>
      'دليل اللعب غير متوفر بهذه اللغة حاليًا، لذا سيُعرض مؤقتًا باللغة الصينية التقليدية.';

  @override
  String get help_all_categories => 'الكل';

  @override
  String get help_subtitle_companion => 'الميزات اليومية والأدوات المساعدة';

  @override
  String get help_subtitle_ai_chat => 'الدردشة والصوت والتفاعل الذكي';

  @override
  String get help_subtitle_creation => 'إعداد الشخصيات وميزات الإنشاء';

  @override
  String get help_subtitle_explore => 'استكشاف الشخصيات ومحتوى اللعبة';

  @override
  String get help_subtitle_care => 'الرفقة اللطيفة والرعاية اليومية';

  @override
  String get help_subtitle_general => 'شرح الميزات الشائعة وطريقة استخدامها';

  @override
  String get chat_interact_fun => 'أنشطة ممتعة';

  @override
  String get memo_notification_permission_missing =>
      'لم يتم تفعيل إذن الإشعارات بعد. ستظل المذكرة محفوظة، لكن لن يظهر تنبيه من النظام.';

  @override
  String memo_saved_with_reminder(String characterName) {
    return 'تم حفظ المذكرة، وسيذكّرك $characterName!';
  }

  @override
  String get memo_saved_without_notification =>
      'تم حفظ المذكرة، لكن إذن الإشعارات غير مفعّل بعد.';

  @override
  String memo_updated_with_reminder(String characterName) {
    return 'تم تحديث المذكرة، وسيذكّرك $characterName!';
  }

  @override
  String get memo_updated_without_notification =>
      'تم تحديث المذكرة، لكن إذن الإشعارات غير متوفر حاليًا.';

  @override
  String memo_load_error(String error) {
    return 'حدث خطأ أثناء تحميل البيانات: $error';
  }

  @override
  String get story_summary_content_required =>
      'لا يمكن أن يكون محتوى القصة فارغًا';

  @override
  String get story_summary_edit_hint => 'اكتب قصتكما...';

  @override
  String get profile_section_basic_info => 'المعلومات الأساسية';

  @override
  String get profile_section_about_me => 'نبذة عني';

  @override
  String get dice_duel_you => 'أنت';

  @override
  String get dice_duel_result_saved => 'تم حفظ نتيجة المواجهة!';

  @override
  String get dice_duel_rolling => 'تتجمع طاقة الكون...';

  @override
  String get butterfly_loading_connecting => 'جارٍ الاتصال بالزمن...';

  @override
  String get character_block_login_required =>
      'يرجى تسجيل الدخول أولًا لحظر الشخصية';

  @override
  String get character_block_self_forbidden =>
      'لا يمكنك حظر شخصية أنشأتها بنفسك';

  @override
  String get character_block_title => 'حظر الشخصية';

  @override
  String character_block_confirm_message(String characterName) {
    return 'هل أنت متأكد من رغبتك في حظر «$characterName»؟\n\nبعد الحظر، لن تظهر لك هذه الشخصية مجددًا ضمن المحتوى المقترح، مثل اللقاءات والمنشورات.';
  }

  @override
  String get character_block_confirm => 'تأكيد الحظر';

  @override
  String character_block_success(String characterName) {
    return 'تم حظر «$characterName»';
  }

  @override
  String get character_block_failed => 'فشل حظر الشخصية، يرجى المحاولة لاحقًا';

  @override
  String get character_unblock_success => 'تم إلغاء الحظر';

  @override
  String get character_unblock_failed =>
      'فشل إلغاء الحظر، يرجى المحاولة لاحقًا';

  @override
  String get character_report_login_required =>
      'يرجى تسجيل الدخول أولًا للإبلاغ عن الشخصية';

  @override
  String get character_report_self_forbidden =>
      'لا يمكنك الإبلاغ عن شخصية أنشأتها بنفسك';

  @override
  String get character_report_submitted => 'تم إرسال البلاغ وسنقوم بمراجعته';

  @override
  String get character_report_open_failed =>
      'تعذر فتح صفحة الإبلاغ، يرجى المحاولة لاحقًا';

  @override
  String chat_loader_error(String error) {
    return 'فشل التحميل: $error';
  }

  @override
  String get announcement_connection_failed =>
      'فشل الاتصال، يرجى المحاولة لاحقًا';

  @override
  String get announcement_latest => 'الأحدث';

  @override
  String announcement_published_at(String date) {
    return 'تاريخ النشر: $date';
  }

  @override
  String get announcement_operations_team => 'فريق تشغيل LoveyDovey';

  @override
  String get legal_creator_guidelines => 'إرشادات المنشئين';

  @override
  String get legal_refresh => 'تحديث';

  @override
  String get legal_page_load_failed => 'فشل تحميل الصفحة';

  @override
  String get legal_check_connection_retry =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مجددًا.';

  @override
  String get legal_reload => 'إعادة التحميل';

  @override
  String get chat_web_purchase_unavailable =>
      'خدمة الشحن غير متاحة حاليًا على إصدار الويب. يرجى استخدام تطبيق «LoveyDovey» لشراء نقاط الزهور أو الاشتراك.';

  @override
  String get chat_dont_show_again => 'عدم إظهار هذا التنبيه مجددًا';

  @override
  String get chat_menu_save_transcript => 'حفظ سجل المحادثة';

  @override
  String get chat_menu_reply_model => 'نموذج الرد';

  @override
  String get chat_reply_model_menu_tip =>
      'تم نقل نموذج الرد! يمكنك الآن العثور عليه في القائمة الموجودة أعلى اليسار.';

  @override
  String get defaultProfileName => 'الملف الافتراضي';

  @override
  String get creator_social_links_manage => 'إدارة روابط التواصل الاجتماعي';

  @override
  String get creator_social_links_title =>
      'الروابط الشخصية وروابط التواصل الاجتماعي';

  @override
  String get creator_social_links_hint =>
      'أضف الروابط التي تريد عرضها علنًا على صفحة المنشئ. لن تظهر الحقول التي تُترك فارغة.';

  @override
  String get creator_social_links_website => 'الموقع الشخصي';

  @override
  String get creator_social_links_saved => 'تم حفظ روابط التواصل الاجتماعي';

  @override
  String get creator_social_links_load_failed =>
      'فشل تحميل روابط التواصل الاجتماعي، يرجى المحاولة لاحقًا';

  @override
  String get creator_social_links_save_failed =>
      'فشل حفظ روابط التواصل الاجتماعي، يرجى المحاولة لاحقًا';

  @override
  String get creator_social_links_open_failed => 'تعذر فتح هذا الرابط';

  @override
  String get chat_regenerate_bottom_tip =>
      'تم نقل «إعادة التوليد» إلى هنا! عندما تريد ردًا مختلفًا، استخدم هذا الزر.';

  @override
  String get chat_continue_bottom_tip =>
      'تم نقل «متابعة» إلى هنا! عندما تريد من الشخصية مواصلة الحديث، استخدم هذا الزر.';

  @override
  String get languageSelectionSubtitle => 'اختر اللغة التي تفضل استخدامها';

  @override
  String get chatStatusBarTitle => 'الحالة';

  @override
  String get chatStatusBarSubtitle =>
      'اختر المعلومات التي تريد إظهارها في الدردشة';

  @override
  String get chatStatusMood => 'المزاج';

  @override
  String get chatStatusOutfit => 'الملابس';

  @override
  String get chatStatusRelationship => 'العلاقة';

  @override
  String get chatStatusThought => 'الأفكار';

  @override
  String get chatStatusWeather => 'الطقس';

  @override
  String get chatStatusCurrentState => 'الحالة الحالية';

  @override
  String get chatStatusAction => 'الفعل';

  @override
  String get chatStatusAffinity => 'الألفة';

  @override
  String get chatPreferenceTitle => 'تفضيلات الدردشة';

  @override
  String get chatPreferenceSubtitle =>
      'تنطبق هذه الإعدادات على هذه الدردشة فقط وتظل فعالة حتى تعدّلها أو تمسحها.';

  @override
  String get chatPreferenceHint =>
      'مثال:\\nلا تنادني بحبيبتي\\nاجعل الردود أقصر\\nلا تضف أفعالي أو تعابيري بشكل متكرر';

  @override
  String get chatPreferenceClear => 'مسح';

  @override
  String get chatSettingsDone => 'تم';

  @override
  String get chat_mode_resonance => 'التناغم';

  @override
  String get chat_mode_gemini_cost =>
      'أول 10 مرات يوميًا مجانًا، ثم نقطة واحدة';

  @override
  String get chat_mode_gemini_desc => 'مناسب للدردشة الخفيفة والرفقة اليومية.';

  @override
  String get chat_mode_story_cost => '5 نقاط';

  @override
  String get chat_mode_immersive_cost => '7 نقاط';

  @override
  String get chat_mode_resonance_cost => '10 نقاط';

  @override
  String get chat_mode_resonance_desc =>
      'يوسّع المشاعر وتوتر العلاقة وردود فعل الشخصية بدقة أكبر.';

  @override
  String get chat_mode_gemini_cost_short => 'زهرة 1';

  @override
  String get chat_mode_story_cost_short => '5 زهور';

  @override
  String get chat_mode_immersive_cost_short => '7 زهور';

  @override
  String get chat_mode_resonance_cost_short => '10 زهور';

  @override
  String get notification_channel_chat_description =>
      'يُستخدم لاستلام أحدث ردود الشخصيات وتذكيرات اللعبة.';

  @override
  String get subscription_star_contract_name =>
      'Lianlian Shiguang · عهد النجوم';

  @override
  String moment_notification_comment_on_your_post(
      Object commentText, Object senderNickname) {
    return 'علّق $senderNickname على منشورك: “$commentText”';
  }

  @override
  String get moment_notification_new_reply_title => 'رد جديد على منشورك! 💬';

  @override
  String get moment_notification_character_popularity_title =>
      'شعبية الشخصية ترتفع بسرعة! 🔥';

  @override
  String get font_size_small => 'صغير';

  @override
  String get font_size_standard => 'قياسي';

  @override
  String get font_size_slightly_large => 'أكبر قليلًا';

  @override
  String get font_size_large => 'كبير';

  @override
  String get font_size_extra_large => 'كبير جدًا';

  @override
  String get font_selection_title => 'الخط';

  @override
  String get font_selection_description =>
      'اختر الخط الأنسب لقراءة القصص والدردشة.';

  @override
  String get font_size_title => 'حجم الخط';

  @override
  String get font_selection_tagline => 'اكتب قصتك من جديد مع من تحب.';

  @override
  String font_selection_applied_message(Object value1) {
    return 'تم تطبيق “$value1”';
  }

  @override
  String get font_selection_local_storage_note =>
      'يتم تطبيق الخط والحجم فورًا وحفظهما على هذا الجهاز. عند استعادة المظهر الافتراضي ستعود الإعدادات إلى “Shiguang Serif + قياسي”.';

  @override
  String get inbox_customer_service_report => 'بلاغ إلى خدمة العملاء';

  @override
  String get inbox_content_text_message_player_title_send =>
      'العنوان المرسل من اللاعب';

  @override
  String get inbox_content_text_message_player_content_send =>
      'المحتوى المرسل من اللاعب';

  @override
  String avatar_frame_equipped_message(Object value1) {
    return 'تم تجهيز “$value1”';
  }

  @override
  String get avatar_frame_unequip_frame_snackbar =>
      'تمت إزالة إطار الصورة الرمزية';

  @override
  String get avatar_frame_unequip_frame_message_event =>
      'إطار صورة رمزية للفعالية';

  @override
  String get avatar_frame_message => 'إطار الصورة الرمزية';

  @override
  String avatar_frame_load_failed(Object value1) {
    return 'فشل تحميل إطارات الصور الرمزية: $value1';
  }

  @override
  String get avatar_frame_parse_frames_message_select =>
      'اختر إطار الصورة الرمزية الذي تريد استخدامه';

  @override
  String get avatar_frame_parse_frames_message_event =>
      'تُحفظ إطارات الصور الرمزية التي تحصل عليها من الفعاليات بشكل دائم ويمكن تغييرها أو إزالتها في أي وقت.';

  @override
  String get avatar_frame_parse_frames_title =>
      'عدم استخدام إطار للصورة الرمزية';

  @override
  String get avatar_frame_parse_frames_subtitle_avatar =>
      'إظهار الصورة الرمزية الأصلية';

  @override
  String get avatar_frame_parse_frames_message_event_shop_redeem_current =>
      'لا تملك أي إطارات للصور الرمزية بعد.\nستظهر هنا الإطارات التي تستبدلها من متجر الفعالية.';

  @override
  String get avatar_frame_parse_frames_message_event_variant_b =>
      'إطار صورة رمزية محدود للفعالية';

  @override
  String get background_settings_message => 'خلفيات محدودة';

  @override
  String get background_title_exclusive_photo_current =>
      'لا توجد صور حصرية بعد';

  @override
  String get background_subtitle_unlock_character_photo =>
      'ستظهر هنا صور الشخصية التي تفتحها لاحقًا.';

  @override
  String get background_title_login => 'سجّل الدخول لعرض الخلفيات المحدودة';

  @override
  String get background_subtitle_redeem_chat_event =>
      'تُحفظ هنا خلفيات الدردشة التي تحصل عليها من الفعاليات.';

  @override
  String get background_title => 'لم تحصل على أي خلفيات محدودة بعد';

  @override
  String get background_subtitle_event_shop_redeem_chat =>
      'ستظهر هنا خلفيات الدردشة التي تستبدلها من متجر الفعالية.';

  @override
  String get background_is_limited_background_type_message_chat_event =>
      'خلفية دردشة محدودة للفعالية';

  @override
  String background_is_limited_background_type_message_current_chat(
      Object value1) {
    return 'هل تريد تعيين “$value1” كخلفية للدردشة الحالية؟';
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
    return 'الشخصية الرئيسية الحالية: 【$value1】\n';
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
  String get character_to_map_message_creator => 'منشئ غامض';

  @override
  String get character_get_character_by_id_message_load_background_story =>
      'جارٍ تحميل القصة الخلفية...';

  @override
  String get character_get_character_by_id_message_sync =>
      'جارٍ مزامنة القصة الافتتاحية...';

  @override
  String get character_get_character_by_id_message =>
      'جارٍ إعداد الجملة الافتتاحية...';

  @override
  String get character_get_character_by_id_message_background =>
      'جارٍ تحميل الخلفية...';

  @override
  String get character_get_character_by_id_message_load =>
      'جارٍ تحميل عالم القصة...';

  @override
  String get character_get_character_by_id_message_load_settings =>
      'جارٍ تحميل الإعدادات الأساسية للشخصية...';

  @override
  String get character_get_character_by_id_message_variant_b =>
      'جارٍ تحميل الشخصية...';

  @override
  String get character_get_character_by_id_message_appearance =>
      'جارٍ تحميل وصف المظهر...';

  @override
  String get character_get_character_by_id_message_variant_c =>
      'جارٍ تحميل أسلوب الكلام...';

  @override
  String get character_get_character_by_id_message_load_variant_b =>
      'لم يتم التحميل بعد';

  @override
  String get character_get_character_by_id_message_variant_d => 'غريب';

  @override
  String get character_get_character_by_id_message_load_variant_c =>
      'جارٍ تحميل أمثلة الحوار...';

  @override
  String get character_get_character_by_id_message_variant_e => 'اللقاء الأول';

  @override
  String get character_get_character_by_id_message_variant_f => 'معارف';

  @override
  String get character_get_character_by_id_message_variant_g => 'علاقة غامضة';

  @override
  String get chat_input_message_sticker => 'ملصق';

  @override
  String get chat_text => 'لقد وصلت إلى حد الدردشة العادية المجانية لليوم';

  @override
  String get chat_message_flowers_today_continue =>
      'لقد استخدمت جميع مرات الدردشة العادية المجانية العشر اليوم.\n\nمن الآن فصاعدًا، ستكلف كل دردشة عادية زهرة واحدة. هل تريد المتابعة؟';

  @override
  String get chat_text_continue => 'موافقة ومتابعة';

  @override
  String get chat_empty_message_label_current_sticker =>
      'لا توجد ملصقات متاحة للاستخدام حاليًا.';

  @override
  String get chat_empty_message_label_sticker =>
      'لا توجد ملصقات مستخدمة مؤخرًا بعد';

  @override
  String get chat_empty_message_label_sticker_variant_b =>
      'لا توجد ملصقات مفضلة بعد';

  @override
  String get chat_empty_message_label_current_sticker_variant_b =>
      'لا توجد ملصقات متاحة للاستخدام حاليًا';

  @override
  String get chat_empty_message_sticker => 'ملصقاتي';

  @override
  String get chat_empty_message => 'المستخدمة مؤخرًا';

  @override
  String get chat_empty_message_variant_b => 'المفضلة';

  @override
  String get chat_send_sticker_message_current_unavailable_sticker =>
      'هذا الملصق غير متاح حاليًا';

  @override
  String chat_message_theater(Object sceneTitle) {
    return '—— المسرح・$sceneTitle ——';
  }

  @override
  String get chat_handle_regenerate_button_message_character_reply_again =>
      'سيتم إنشاء رد الشخصية السابق من جديد.';

  @override
  String creator_profile_reason_tile_message_report_select_reason(
      Object creatorName) {
    return 'اختر سبب الإبلاغ عن “$creatorName”:';
  }

  @override
  String get widget_key_message => 'الحالة';

  @override
  String get widget_key_message_variant_b => 'الموقع';

  @override
  String get widget_label_character => 'لا توجد حالة للشخصية بعد';

  @override
  String get widget_format_post_time_label_moment_latest => 'أحدث منشور';

  @override
  String get widget_format_post_time_label_update_moment =>
      'تم تحديث منشور للتو';

  @override
  String widget_format_post_time_label_minutes_ago_update_moment(
      Object value1) {
    return 'تم تحديث منشور قبل $value1 دقيقة';
  }

  @override
  String widget_format_post_time_label_hours_ago_update_moment(Object value1) {
    return 'تم تحديث منشور قبل $value1 ساعة';
  }

  @override
  String get widget_format_post_time_label_update_moment_days =>
      'تم تحديث منشور أمس';

  @override
  String widget_format_post_time_label_update_moment_days_ago(Object value1) {
    return 'تم تحديث منشور قبل $value1 يوم';
  }

  @override
  String widget_format_post_time_label_update_moment_variant_b(
      Object value1, Object value2) {
    return 'تم تحديث منشور في $value1/$value2';
  }

  @override
  String get widget_format_post_time_message_share_photo => 'شارك صورة';

  @override
  String get widget_format_post_time_message_update_moment => 'نشر تحديثًا';

  @override
  String get widget_format_post_time_message_current_character_moment =>
      'لا توجد منشورات للشخصية بعد';

  @override
  String get widget_extract_daily_quote_message => 'الموقع:';

  @override
  String get widget_format_daily_quote_time_message_today =>
      'لا توجد عبارة لليوم بعد';

  @override
  String get widget_load_period_care_state_message_today =>
      '“لا ترهق نفسك اليوم. سأبقى معك ونأخذ الأمور على مهل.”';

  @override
  String widget_load_period_care_state_message_period_days(Object dayCount) {
    return 'اليوم $dayCount من الدورة';
  }

  @override
  String get widget_load_period_care_state_message_days =>
      '“حاولي الراحة أبكر قليلًا هذه الأيام. لا ترهقي نفسك.”';

  @override
  String get widget_load_period_care_state_message_today_start =>
      'من المتوقع أن تبدأ اليوم';

  @override
  String widget_load_period_care_state_message_days_variant_b(
      Object daysUntil) {
    return 'متبقي تقريبًا $daysUntil يوم';
  }

  @override
  String get widget_load_period_care_state_message_today_variant_b =>
      '“لقد بذلت جهدًا كبيرًا. اعتني بنفسك جيدًا اليوم.”';

  @override
  String get widget_load_period_care_state_message_period_end =>
      'انتهت الدورة للتو';

  @override
  String get widget_load_period_care_state_message_today_variant_c =>
      '“تذكّري أن تعتني بنفسك جيدًا اليوم أيضًا.”';

  @override
  String get widget_load_period_care_state_message_current_reminder =>
      'لا يوجد تذكير خاص بالدورة حاليًا';

  @override
  String get widget_load_period_care_state_message =>
      'لا توجد سجلات كافية للدورة بعد';

  @override
  String get widget_parse_character_birthday_message => 'السنة';

  @override
  String get widget_parse_character_birthday_message_variant_b => 'الشهر';

  @override
  String get widget_build_birthday_countdown_lines_message_character_birthday =>
      'عيد ميلاد الشخصية';

  @override
  String get widget_build_birthday_countdown_lines_message_birthday_settings =>
      'لم يتم تعيين عيد الميلاد';

  @override
  String widget_build_birthday_countdown_lines_message_birthday_countdown(
      Object birthdayLabel) {
    return 'حتى عيد ميلاده・$birthdayLabel';
  }

  @override
  String get widget_build_birthday_countdown_lines_message_today => 'إنه اليوم';

  @override
  String widget_build_birthday_countdown_lines_message_days(Object days) {
    return 'متبقي $days يوم';
  }

  @override
  String get widget_build_birthday_countdown_lines_message => 'منذ لقائه';

  @override
  String get widget_build_birthday_countdown_lines_message_variant_b =>
      'لا يوجد سجل للقاء بعد';

  @override
  String widget_build_birthday_countdown_lines_message_days_variant_b(
      Object value1) {
    return '$value1 يوم';
  }

  @override
  String get widget_build_birthday_countdown_lines_message_variant_c =>
      'يوم مهم';

  @override
  String get widget_build_birthday_countdown_lines_message_date_select =>
      'لم يتم اختيار تاريخ';

  @override
  String widget_build_birthday_countdown_lines_message_elapsed_days(
      Object value1) {
    return 'مرّ $value1 يوم';
  }

  @override
  String get widget_settings_remove_title_character_latest =>
      'أحدث منشور للشخصية';

  @override
  String get widget_settings_remove_subtitle_moment_latest =>
      'شاهد آخر تحديث له دون فتح التطبيق.';

  @override
  String get widget_settings_remove_title_period => 'مرافقة خلال الدورة';

  @override
  String get widget_settings_remove_subtitle_character_end =>
      'مزيد قليل من اهتمام الشخصية قبل الدورة وأثناءها وبعدها.';

  @override
  String get widget_settings_remove_title => 'عبارة اليوم';

  @override
  String get widget_settings_remove_subtitle_days =>
      'كل يوم ستجد عبارة بانتظارك على الشاشة الرئيسية.';

  @override
  String get widget_settings_remove_title_reminder => 'المناسبات / التذكيرات';

  @override
  String get widget_settings_remove_subtitle_character_birthday_reminder =>
      'تذكّروا معًا يوم اللقاء وأعياد الميلاد، ودع الشخصية تذكّرك بالأمور المهمة.';

  @override
  String get widget_settings_remove_title_character => 'حالة الشخصية';

  @override
  String get widget_settings_remove_subtitle_chat_latest_mood =>
      'اعرض أحدث مزاج وحالة وموقع من الدردشة على الشاشة الرئيسية.';

  @override
  String get widget_settings_size_label => 'متوسط';

  @override
  String get widget_settings_size_label_message_send =>
      'تم إرسال طلب الإضافة إلى الشاشة الرئيسية.';

  @override
  String get widget_settings_size_label_message_try_again_later_failed =>
      'فشلت الإضافة إلى الشاشة الرئيسية. حاول مرة أخرى لاحقًا.';

  @override
  String get widget_settings_edit_saved_widget_message_character_reminder_again =>
      'تم دمج “تذكير مهام الشخصية” القديم في “المناسبات / التذكيرات”. يُرجى إنشاؤه من جديد.';

  @override
  String get widget_settings_delete_saved_widget_title_delete_small =>
      'حذف الأداة؟';

  @override
  String
      widget_settings_delete_saved_widget_message_stop_display_long_press_home_after_delete(
          Object value1, Object value2) {
    return 'هل تريد حذف “$value1・$value2”؟\n\nبعد الحذف، ستتوقف هذه الأداة عن عرض محتوى الشخصية وسيُطلب من اللاعب الضغط مطولًا على الشاشة الرئيسية لإزالتها.';
  }

  @override
  String get widget_settings_delete_saved_widget_message_delete_settings_small =>
      'تم حذف إعدادات الأداة؛ وتم تعطيل الأداة المقابلة على الشاشة الرئيسية.';

  @override
  String get widget_settings_message_desktop_widget => 'أدوات الشاشة الرئيسية';

  @override
  String get widget_settings_message_character_days =>
      'دع شخصيتك المفضلة ترافقك كل يوم.';

  @override
  String get widget_settings_message_small => 'أدواتي';

  @override
  String get widget_settings_message_desktop_widget_variant_b =>
      'لا توجد أدوات على الشاشة الرئيسية بعد';

  @override
  String get widget_settings_message_character_reminder =>
      'اختر شخصية مفضلة واعرض تذكيراتها أو منشوراتها أو حالتها على الشاشة الرئيسية.';

  @override
  String widget_settings_message_size(Object value1) {
    return 'حجم $value1';
  }

  @override
  String get widget_settings_tooltip => 'إضافة إلى الشاشة الرئيسية';

  @override
  String get widget_settings_tooltip_small => 'تعديل الأداة';

  @override
  String get widget_settings_tooltip_delete_small => 'حذف الأداة';

  @override
  String get widget_settings_message_desktop_widget_variant_c =>
      'إضافة أداة إلى الشاشة الرئيسية';

  @override
  String get widget_settings_message_character_photo_content_select_small =>
      'يمكن لكل أداة اختيار الشخصية وصورتها والمحتوى المعروض بشكل مستقل. ويمكنك أيضًا وضع عدة شخصيات على الشاشة الرئيسية في الوقت نفسه.';

  @override
  String get widget_settings_desktop_type_selection_message_select_small =>
      'اختر أداة';

  @override
  String get widget_settings_desktop_type_selection_message_select =>
      'اختر أولًا الطريقة التي تريد أن ترافقك بها الشخصية على الشاشة الرئيسية.';

  @override
  String
      get widget_settings_go_to_photo_step_message_try_again_later_failed_load_character_photo =>
          'فشل تحميل صور الشخصية. حاول مرة أخرى لاحقًا.';

  @override
  String get widget_settings_message_character_select => 'اختر شخصية';

  @override
  String get widget_settings_message_character_friend_days =>
      'تظهر فقط الشخصيات التي أضفتها كأصدقاء أو سبق أن دردشت معها.';

  @override
  String get widget_settings_hint_character_search => 'البحث عن شخصيات';

  @override
  String get widget_settings_message_try_again_later_failed_load_character =>
      'فشل تحميل الشخصيات. حاول مرة أخرى لاحقًا.';

  @override
  String get widget_settings_message_current_character_chat_friend_add =>
      'لا توجد شخصيات مطابقة حاليًا. تحدث مع شخصية أولًا أو أضفها كصديق.';

  @override
  String get widget_settings_message_character_photo_select =>
      'التالي・اختر صورة الشخصية';

  @override
  String
      get widget_settings_desktop_photo_selection_message_character_photo_select =>
          'اختر صورة الشخصية';

  @override
  String
      widget_settings_desktop_photo_selection_message_current_affection_unlocked_photo(
          Object value1) {
    return 'الألفة الحالية $value1・يمكن استخدام الصور المفتوحة مباشرة.';
  }

  @override
  String
      get widget_settings_desktop_photo_selection_message_current_character_photo =>
          'لا توجد صور متاحة لهذه الشخصية حاليًا.';

  @override
  String
      widget_settings_desktop_photo_selection_message_required_affection_unlock_photo(
          Object value1) {
    return 'يلزم مستوى ألفة $value1 لفتح هذه الصورة.';
  }

  @override
  String get widget_settings_message_photo_public => 'صورة عامة';

  @override
  String widget_settings_message_unlock(Object value1) {
    return 'تُفتح عند ألفة $value1';
  }

  @override
  String widget_settings_message_unlocked(Object value1) {
    return 'مفتوحة・ألفة $value1';
  }

  @override
  String get widget_settings_message_content_settings =>
      'التالي・ضبط المحتوى المعروض';

  @override
  String get widget_settings_open_preview_message_player_select =>
      'اختر أولًا فعالية / مهمة أنشأها لاعب.';

  @override
  String get widget_settings_pick_custom_memo_event_message_login_account =>
      'سجّل الدخول أولًا.';

  @override
  String
      get widget_settings_pick_custom_memo_event_message_memo_current_character =>
          'لا توجد لهذه الشخصية أي فعاليات / مذكرات بعد.';

  @override
  String get widget_settings_pick_custom_memo_event_message_player_select =>
      'اختر فعالية أنشأها لاعب';

  @override
  String get widget_settings_message_try_again_later_failed_load =>
      'فشل تحميل الفعاليات. حاول مرة أخرى لاحقًا.';

  @override
  String get widget_settings_message_content_settings_variant_b =>
      'ضبط المحتوى المعروض';

  @override
  String get widget_settings_subtitle_content =>
      'عدّل ما تريد رؤيته على الشاشة الرئيسية.';

  @override
  String get widget_settings_message_small_variant_b => 'التالي・معاينة الأداة';

  @override
  String get widget_settings_title => 'عرض المنشورات';

  @override
  String get widget_settings_title_variant_b => 'إظهار صورة المنشور';

  @override
  String get widget_settings_title_variant_c => 'إظهار عدد الإعجابات';

  @override
  String get widget_settings_title_comment => 'إظهار عدد التعليقات';

  @override
  String get widget_settings_title_variant_d => 'الخصوصية والمرافقة';

  @override
  String get widget_settings_title_variant_e => 'وضع الخصوصية';

  @override
  String get widget_settings_subtitle_period_character =>
      'اعرض على الشاشة الرئيسية اهتمام الشخصية فقط دون إظهار معلومات الدورة مباشرة.';

  @override
  String get widget_settings_title_variant_f => 'الوضع التفصيلي';

  @override
  String get widget_settings_subtitle_end =>
      'يمكن عرض حالات الدورة مثل قرب البدء أو كونها جارية أو انتهائها للتو.';

  @override
  String get widget_settings_title_variant_g => 'إظهار حالة الدورة';

  @override
  String get widget_settings_title_time => 'إظهار الوقت';

  @override
  String get widget_settings_title_update => 'طريقة التحديث';

  @override
  String get widget_settings_message_update_days => 'التحديث مرة يوميًا';

  @override
  String get widget_settings_message_update =>
      'التحديث في كل مرة يتم فيها فتح التطبيق';

  @override
  String get widget_settings_text_update => 'التحديث بعد فتح التطبيق';

  @override
  String get widget_settings_title_content => 'محتوى المناسبة';

  @override
  String get widget_settings_title_days => 'الأيام منذ اللقاء';

  @override
  String get widget_settings_subtitle_character_today_days =>
      'اعرض عدد الأيام منذ أن التقيت بالشخصية وحتى اليوم.';

  @override
  String get widget_settings_subtitle_character_birthday =>
      'اعرض المدة المتبقية حتى عيد ميلاد الشخصية.';

  @override
  String get widget_settings_title_player => 'فعالية / مهمة أنشأها لاعب';

  @override
  String get widget_settings_message_memo_character_select_reminder =>
      'اختر فعالية أو مهمة من مذكرات / تذكيرات هذه الشخصية.';

  @override
  String widget_settings_message_selected(Object _selectedMemoContent) {
    return 'المحدد: $_selectedMemoContent';
  }

  @override
  String get widget_settings_message_select => 'اختر ما يصل إلى 3 عناصر';

  @override
  String get widget_settings_message_character =>
      'يمكن لحالة الشخصية عرض ما يصل إلى 3 عناصر.';

  @override
  String get widget_settings_message_small_variant_c => 'معاينة الأداة';

  @override
  String get widget_settings_title_confirm => 'التأكيد النهائي';

  @override
  String get widget_settings_subtitle_large =>
      'شاهد أولًا كيف سيبدو تقريبًا على الشاشة الرئيسية.';

  @override
  String get widget_settings_title_size => 'الحجم';

  @override
  String get widget_settings_title_variant_h => 'التخطيط';

  @override
  String get widget_settings_label_photo => 'صورة بملء الشاشة';

  @override
  String get widget_settings_label_character => 'بطاقة الشخصية';

  @override
  String get widget_settings_message_sync => 'جارٍ المزامنة…';

  @override
  String get widget_settings_message_desktop_widget_add =>
      'إضافة أداة إلى الشاشة الرئيسية';

  @override
  String get widget_settings_sample_lines_message_today_end =>
      '“انتهيت اليوم أبكر قليلًا مما توقعت.”';

  @override
  String get widget_settings_sample_lines_message_days =>
      '“لا ترهق نفسك كثيرًا هذه الأيام.”';

  @override
  String get widget_settings_sample_lines_message_period => 'الدورة جارية';

  @override
  String get widget_settings_sample_lines_message_today =>
      '“استرحي أكثر قليلًا اليوم.”';

  @override
  String get widget_settings_sample_lines_message_today_variant_b =>
      '“لا تنسي أن تتناولي الطعام جيدًا اليوم أيضًا.”';

  @override
  String get widget_settings_sample_lines_label_birthday_countdown =>
      'حتى عيد ميلاده';

  @override
  String get widget_settings_sample_lines_label_days => 'متبقي 12 يومًا';

  @override
  String get widget_settings_sample_lines_label_days_variant_b => '128 يومًا';

  @override
  String get widget_settings_sample_lines_message_mood => 'المزاج｜متعب قليلًا';

  @override
  String get widget_settings_sample_lines_message_end =>
      'الحالة｜انتهى للتو من العمل';

  @override
  String get widget_settings_sample_lines_message => 'الموقع｜أسفل المكتب';

  @override
  String get widget_settings_sample_lines_message_variant_b => 'العلاقة｜حبيب';

  @override
  String get widget_settings_sample_lines_message_variant_c =>
      'الملابس｜كنزة محاكة رمادية فاتحة';

  @override
  String get widget_settings_sample_lines_message_days_variant_b =>
      'الطقس｜بارد قليلًا';

  @override
  String get widget_settings_sample_lines_message_variant_d =>
      'الفكرة｜أريد رؤيتك مبكرًا';

  @override
  String get widget_settings_sample_lines_message_variant_e =>
      'الفعل｜يرتب المكتب';

  @override
  String get widget_settings_sample_lines_message_affection =>
      'الألفة｜هادئة وقريبة';

  @override
  String get edit_profile_message => 'زينة الملف الشخصي';

  @override
  String get edit_profile_message_current => 'غير مستخدمة حاليًا';

  @override
  String
      get event_memory_character_load_characters_message_login_character_select =>
          'سجّل الدخول قبل اختيار شخصية';

  @override
  String get event_memory_character_center_message_memory_select =>
      'اختر من تريد أن تحتفظ معه بهذه الذكرى';

  @override
  String get event_memory_character_center_message_character_friend_add =>
      'لن تظهر هنا إلا الشخصيات التي أنشأتها بنفسك والشخصيات التي أضفتها كأصدقاء.';

  @override
  String get event_memory_character_center_message_current_character_select =>
      'لا توجد شخصيات متاحة للاختيار حاليًا';

  @override
  String
      get event_memory_character_center_message_public_character_character_friend_add =>
          'أنشئ شخصيتك الخاصة أو أضف شخصية عامة تعجبك كصديق أولًا.';

  @override
  String get event_memory_character_message_character_select =>
      'اختر شخصية أولًا';

  @override
  String event_memory_character_message_continue(Object value1) {
    return 'المتابعة مع $value1';
  }

  @override
  String get event_memory_character_card_message_private => 'خاصتي・خاص';

  @override
  String get event_memory_character_error_label_load_again => 'إعادة التحميل';

  @override
  String
      get event_memory_collection_show_collection_intro_if_needed_message_collection =>
          'مجموعة Shiguang';

  @override
  String
      get event_memory_collection_show_collection_intro_if_needed_message_collection_content =>
          'هذه قائمة مجموعتك، ويمكنك هنا مشاهدة كل ما حفظته.';

  @override
  String get event_memory_collection_text_collection_login =>
      'سجّل الدخول لعرض مجموعتك';

  @override
  String get event_memory_collection_message_memory => 'الذكريات';

  @override
  String get event_memory_collection_message_chat_background =>
      'خلفيات الدردشة';

  @override
  String get event_memory_collection_message_avatar_frame_collection =>
      'لا توجد إطارات صور رمزية محفوظة بعد';

  @override
  String get event_memory_collection_message_avatar_frame =>
      'ستظهر هنا إطارات الصور الرمزية المحدودة التي تحصل عليها لاحقًا.';

  @override
  String get event_memory_collection_message_collection_sticker =>
      'لا توجد ملصقات محفوظة بعد';

  @override
  String get event_memory_collection_message_sticker =>
      'ستُحفظ هنا الملصقات التي تجمعها لاحقًا.';

  @override
  String get event_memory_collection_message_collection_chat_background =>
      'لا توجد خلفيات دردشة محفوظة بعد';

  @override
  String get event_memory_collection_message_chat_background_variant_b =>
      'ستظهر هنا خلفيات الدردشة المحدودة التي تحصل عليها لاحقًا.';

  @override
  String get event_memory_collection_tab_title_collection_temporary =>
      'يتعذر تحميل المجموعة مؤقتًا';

  @override
  String get event_memory_collection_tab_title_collection_memory =>
      'لا توجد ذكريات محفوظة بعد';

  @override
  String get event_memory_collection_tab_subtitle_limited_memory_complete =>
      'بعد إكمال ذكرى محدودة، يمكنك الاحتفاظ بلحظاتك المفضلة هنا.';

  @override
  String get event_memory_collection_item_card_label => 'عنصر محدود';

  @override
  String get event_memory_collection_confirm_delete_owned_item_message_delete =>
      'حذف العنصر المحدود؟';

  @override
  String
      event_memory_collection_confirm_delete_owned_item_message_after_delete_unavailable(
          Object _itemTypeLabel) {
    return 'بعد الحذف، لن تتمكن من استخدام $_itemTypeLabel هذا بعد الآن،';
  }

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_collection =>
          'ولن يظهر أيضًا في “مجموعة Shiguang”.\n\n';

  @override
  String get event_memory_collection_confirm_delete_owned_item_message_unavailable =>
      'هذا يعني أنك ستتخلى عن العنصر المحدود الذي حصلت عليه هذه المرة، ولا يمكن التراجع عن هذا الإجراء.\n\n';

  @override
  String
      event_memory_collection_confirm_delete_owned_item_message_delete_variant_b(
          Object value1) {
    return 'هل أنت متأكد أنك تريد حذف “$value1”؟';
  }

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_delete_variant_c =>
          'تم حذف العنصر المحدود';

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_not_found_delete =>
          'تعذر العثور على هذا العنصر المحدود وربما تم حذفه بالفعل';

  @override
  String
      get event_memory_collection_confirm_delete_owned_item_message_collection_current_delete =>
          'لا يمكن حذف هذه المجموعة حاليًا';

  @override
  String get event_memory_collection_show_preview_message =>
      'جارٍ تجهيز الصورة';

  @override
  String get event_memory_collection_show_preview_message_failed_load =>
      'فشل تحميل الصورة';

  @override
  String get event_memory_collection_save_to_gallery_message_save_current =>
      'إصدار الويب لا يدعم حاليًا الحفظ المباشر في معرض صور الهاتف';

  @override
  String get event_memory_collection_save_to_gallery_message_save_memory =>
      'يلزم إذن الوصول إلى معرض الصور لحفظ هذه الذكرى';

  @override
  String get event_memory_collection_save_to_gallery_message_memory =>
      'صورة الذكرى ليست جاهزة بعد. حاول مرة أخرى.';

  @override
  String get event_memory_collection_save_to_gallery_message_failed_memory =>
      'فشل إنشاء صورة الذكرى';

  @override
  String get event_memory_collection_save_to_gallery_message_save =>
      'تم الحفظ في معرض صور الهاتف ♡';

  @override
  String
      get event_memory_collection_save_to_gallery_message_save_confirm_failed =>
          'فشل الحفظ. تحقق من إذن معرض الصور وحاول مرة أخرى.';

  @override
  String
      get event_memory_collection_delete_collection_title_collection_cancel =>
          'إزالة من المجموعة؟';

  @override
  String get event_memory_collection_delete_collection_message_collection_cancel_memory =>
      'بعد الإزالة من المجموعة، لن تظهر هذه الذكرى في “مجموعة Shiguang”.\n\nهل أنت متأكد أنك تريد إزالتها؟';

  @override
  String
      get event_memory_collection_delete_collection_message_try_again_later_collection_cancel_failed =>
          'فشلت الإزالة من المجموعة. حاول مرة أخرى لاحقًا.';

  @override
  String get event_memory_collection_message_collection_memory =>
      'مجموعة الذكريات';

  @override
  String get event_memory_collection_label_play => 'تشغيل مرة أخرى';

  @override
  String get event_memory_collection_label_save => 'جارٍ الحفظ…';

  @override
  String get event_memory_collection_label_save_variant_b =>
      'حفظ في معرض الصور';

  @override
  String get event_memory_collection_collected_card_message_limited_memory =>
      'Lianlian Shiguang・ذكرى محدودة';

  @override
  String get event_memory_collection_create_state_message_end_story =>
      'بعض اللحظات\nلا تختفي لمجرد أن القصة انتهت.';

  @override
  String get event_memory_collection_text_collection =>
      'لا توجد Scene قابلة لإعادة التشغيل في هذه الذكرى المحفوظة';

  @override
  String get event_memory_collection_message => 'تخطي';

  @override
  String get event_memory_collection_message_end => 'اضغط للإنهاء';

  @override
  String get event_memory_collection_message_continue => 'اضغط للمتابعة';

  @override
  String get event_memory_collection_message_variant_b =>
      'اضغط لعرض النص كاملًا';

  @override
  String get event_memory_collection_collected_label_collection =>
      'تمت إضافتها للتو';

  @override
  String get event_memory_collection_collected_item_label_collection_date =>
      'تاريخ الإضافة غير مسجل';

  @override
  String event_memory_collection_collected_item_label_collection(
      Object day, Object month, Object value1) {
    return 'تمت الإضافة في $value1/$month/$day';
  }

  @override
  String get event_memory_text_not_found_event =>
      'لم يتم العثور على بيانات الفعالية';

  @override
  String get event_memory_message_limited_memory_failed_load =>
      'فشل تحميل الذكريات المحدودة';

  @override
  String get event_memory_as_map_label_unlocked => 'مفتوح';

  @override
  String event_memory_as_map_label_unlock(Object currencyIcon,
      Object currencyName, Object currentValue, Object requiredValue) {
    return 'اجمع $currencyIcon $requiredValue $currencyName للفتح ($currentValue / $requiredValue)';
  }

  @override
  String get event_memory_as_map_label_unlock_task_event_complete =>
      'يُفتح بعد إكمال مهمة الفعالية المحددة';

  @override
  String get event_memory_as_map_label_redeem_unlock_event =>
      'يُفتح بعد استبدال عنصر الفعالية المحدد';

  @override
  String get event_memory_as_map_label_unlock_variant_b => 'غير مفتوح بعد';

  @override
  String get event_memory_hero_message =>
      'احتفظ في هذا الموسم بلحظة لا تخص سوى كليكما.';

  @override
  String event_memory_hero_message_limited_memory(
      Object totalCount, Object unlockedCount) {
    return 'الذكريات المحدودة  $unlockedCount / $totalCount';
  }

  @override
  String get event_memory_status_label_unlocked => 'مفتوح・لم تتم المشاهدة';

  @override
  String get event_memory_status_label => 'تمت المشاهدة';

  @override
  String get event_memory_status_label_collection => 'تمت الإضافة';

  @override
  String get event_memory_footer_label_memory_start => 'يمكنك بدء هذه الذكرى';

  @override
  String get event_memory_footer_label => 'يمكنك مشاهدتها مرة أخرى';

  @override
  String get event_memory_footer_label_collection =>
      'محفوظة في مجموعة Shiguang';

  @override
  String get event_memory_empty_message_limited_memory_event_public =>
      'لم يتم نشر أي ذكريات محدودة لهذه الفعالية بعد';

  @override
  String get event_memory_performance_finish_message_memory =>
      'تم الاحتفاظ بهذه الذكرى.';

  @override
  String get event_memory_performance_finish_message_save_collection =>
      'تبقى المجموعات داخل اللعبة. لا يُطلب إذن معرض الصور إلا عند الحفظ على الهاتف.';

  @override
  String get event_memory_performance_finish_message => 'جارٍ المعالجة…';

  @override
  String get event_memory_performance_finish_message_collection_memory =>
      'إضافة هذه الذكرى إلى المجموعة';

  @override
  String get event_memory_performance_confirm_uncollect_memory_message_collection_cancel_memory_again_remove =>
      'بعد الإزالة، ستُحذف هذه الذكرى من “مجموعة Shiguang”. ويمكنك لاحقًا مشاهدتها وإضافتها مرة أخرى.';

  @override
  String
      get event_memory_performance_uncollect_memory_message_collection_login =>
          'سجّل الدخول قبل إدارة المجموعات';

  @override
  String
      get event_memory_performance_collect_memory_message_collection_login_memory =>
          'سجّل الدخول قبل إضافة هذه الذكرى إلى المجموعة';

  @override
  String
      get event_memory_performance_collect_memory_message_collection_memory =>
          'تمت إضافة هذه الذكرى ♡';

  @override
  String
      get event_memory_performance_collect_memory_message_try_again_later_collection_failed =>
          'فشلت الإضافة إلى المجموعة. حاول مرة أخرى لاحقًا.';

  @override
  String get event_memory_performance_text_panel_message_complete =>
      'اضغط للإكمال';

  @override
  String get event_memory_performance_build_performance_message => 'تخطي';

  @override
  String get event_memory_performance_text_play =>
      'لا توجد Scene متاحة للتشغيل';

  @override
  String get event_memory_profile_change_profile_message_profile =>
      'تغيير ملف Shiguang';

  @override
  String get event_memory_profile_message_profile_confirm =>
      'تأكيد ملف Shiguang';

  @override
  String get event_memory_profile_center_text_profile_not_found =>
      'لم يتم العثور على ملف Shiguang صالح للاستخدام';

  @override
  String get event_memory_profile_center_message_memory =>
      'بأي هوية ستبقى في هذه الذكرى؟';

  @override
  String get event_memory_profile_center_message_profile_character_start =>
      'تم اختيار ملف Shiguang الذي استخدمته مؤخرًا مع هذه الشخصية أولًا. يمكنك تغييره قبل البدء.';

  @override
  String event_memory_profile_center_message(Object value1) {
    return 'بصفة “$value1” مع';
  }

  @override
  String event_memory_profile_center_message_memory_variant_b(Object value1) {
    return '“$value1” في هذه الذكرى';
  }

  @override
  String get event_memory_profile_center_label_memory_start => 'بدء الذكرى';

  @override
  String get event_message_failed_load => 'فشل تحميل بيانات الفعالية';

  @override
  String get event_message_not_found => 'الفعالية غير موجودة';

  @override
  String get event_remaining_label => 'الفعالية جارية';

  @override
  String event_remaining_label_days(Object value1) {
    return 'متبقي $value1 يوم';
  }

  @override
  String event_remaining_label_hours(Object value1) {
    return 'متبقي $value1 ساعة';
  }

  @override
  String get event_remaining_label_end => 'ستنتهي قريبًا';

  @override
  String get event_balance_pill_tooltip_back => 'رجوع';

  @override
  String event_claim_task_message_claim_current(
      Object currency, Object reward, Object value1, Object value2) {
    return 'تم استلام $value1 $reward $value2. لديك الآن $currency';
  }

  @override
  String get event_claim_task_message_reward_claim => 'تم استلام المكافأة';

  @override
  String get event_claim_task_message_claim_failed => 'فشل الاستلام';

  @override
  String get event_claim_task_message_task_claim =>
      'تم استلام مكافأة هذه المهمة بالفعل';

  @override
  String get event_claim_task_message_incomplete_task => 'المهمة لم تكتمل بعد';

  @override
  String get event_task_list_label_task_load => 'جارٍ تحميل المهام…';

  @override
  String get event_task_list_label_task_current => 'لا توجد مهام حاليًا';

  @override
  String get event_task_list_label_task_login_progress =>
      'سجّل الدخول لعرض تقدم مهام الفعالية';

  @override
  String get event_milestone_progress_label_reward_load =>
      'جارٍ تحميل المكافآت التراكمية…';

  @override
  String get event_milestone_progress_label_reward_current =>
      'لا توجد مكافآت تراكمية حاليًا';

  @override
  String event_build_with_total_message_current(Object totalEarned) {
    return 'الحالي  $totalEarned';
  }

  @override
  String get event_progress_ref_message_redeem_confirm => 'تأكيد الاستبدال';

  @override
  String event_progress_ref_message_redeem_flowers(
      Object itemName, Object price, Object rewardAmount, Object value1) {
    return 'هل تريد استخدام $value1 $price لاستبدال “$itemName”؟\n\nبعد الاستبدال ستحصل على $rewardAmount زهرة.';
  }

  @override
  String event_progress_ref_message_redeem(
      Object itemName, Object price, Object value1) {
    return 'هل تريد استخدام $value1 $price لاستبدال “$itemName”؟';
  }

  @override
  String event_progress_ref_message_redeem_success_flowers(
      Object returnedReward) {
    return 'تم الاستبدال بنجاح! حصلت على $returnedReward زهرة';
  }

  @override
  String event_progress_ref_message_event_collection_redeem_success_add(
      Object itemName) {
    return 'تم الاستبدال بنجاح! تمت إضافة “$itemName” إلى مجموعة الفعالية';
  }

  @override
  String get event_progress_ref_message_redeem_failed => 'فشل الاستبدال';

  @override
  String get event_progress_ref_message_redeem_variant_b =>
      'تم استبدال هذا العنصر بالفعل';

  @override
  String get event_progress_ref_message_insufficient => 'العملة غير كافية';

  @override
  String event_progress_ref_message_insufficient_variant_b(Object value1) {
    return '$value1 غير كافٍ';
  }

  @override
  String get event_progress_ref_message_redeem_variant_c => 'استبدال';

  @override
  String get event_progress_ref_message_redeem_variant_d => 'تم الاستبدال';

  @override
  String event_message_redeem_flowers(Object rewardAmount) {
    return 'بعد الاستبدال ستحصل على $rewardAmount زهرة';
  }

  @override
  String event_message_redeem(Object redeemedCount) {
    return 'تم الاستبدال $redeemedCount مرة';
  }

  @override
  String get event_message_event_shop_login =>
      'سجّل الدخول لاستخدام متجر الفعالية';

  @override
  String get event_message_redeem_current =>
      'لا توجد عناصر متاحة للاستبدال حاليًا';

  @override
  String event_shop_item_card_message_flowers(Object rewardAmount) {
    return 'احصل على $rewardAmount زهرة';
  }

  @override
  String get event_message_insufficient => 'غير كافٍ';

  @override
  String get notification_message_player => 'صورة مرفقة من اللاعب';

  @override
  String notification_message_qixi_letter(Object value1) {
    return 'رسالة Qixi من $value1';
  }

  @override
  String recommendation_remaining_label_days(Object value1) {
    return 'متبقي $value1 يوم';
  }

  @override
  String recommendation_remaining_label_hours(Object value1) {
    return 'متبقي $value1 ساعة';
  }

  @override
  String get settings_subtitle_character_days =>
      'دع شخصيتك المفضلة ترافقك كل يوم';

  @override
  String moment_notification_comment_on_character_post(
      Object authorName, Object commentText, Object senderNickname) {
    return 'ترك $senderNickname تعليقًا لـ $authorName: “$commentText”';
  }

  @override
  String get inbox_content_text_message_customer_service_message_send =>
      'رسائل خدمة العملاء المرسلة';

  @override
  String get character_edit_relationship_none_label => 'لا شيء';

  @override
  String get auth_cancel_account_deletion_failed =>
      'فشل إلغاء حذف الحساب. حاول مرة أخرى لاحقًا.';

  @override
  String get auth_delete_account_failed => 'فشل حذف الحساب';

  @override
  String get auth_request_account_deletion_failed =>
      'فشل طلب حذف الحساب. حاول مرة أخرى لاحقًا.';

  @override
  String get theme_font_shiguang_serif => 'Shiguang Serif';

  @override
  String get theme_font_clean_sans => 'Sans نظيف';

  @override
  String get theme_font_system => 'خط النظام';

  @override
  String get theme_font_shiguang_serif_description =>
      'ناعم وأدبي، مناسب للقراءة الغامرة';

  @override
  String get theme_font_clean_sans_description =>
      'واضح ونظيف، مريح للقراءة لفترات طويلة';

  @override
  String get theme_font_system_description =>
      'استخدم خط النظام الافتراضي للجهاز';

  @override
  String get font_selection_serif_name => 'خط نوتو سيريف الصيني التقليدي';

  @override
  String get font_selection_sans_name => 'خط نوتو سانس الصيني التقليدي';

  @override
  String get font_selection_system_name => 'خط النظام';

  @override
  String get font_selection_serif_description =>
      'خط أنيق بزوائد، مناسب للقراءة الغامرة.';

  @override
  String get font_selection_sans_description => 'خط واضح وناعم بلا زوائد.';

  @override
  String get font_selection_system_description =>
      'استخدام الخط الافتراضي للجهاز.';

  @override
  String get font_selection_preview_sentence =>
      'اكتب فصلًا جديدًا من قصتك مع من تحب.';

  @override
  String get avatar_frame_error_generic => 'خطأ';

  @override
  String get avatar_frame_sign_in_required => 'يُرجى تسجيل الدخول أولاً';

  @override
  String get avatar_frame_default_name => 'إطار صورة الملف الشخصي للحدث';

  @override
  String get background_exclusive_photos_tab => 'صور حصرية';

  @override
  String get background_world_sign_in_chat =>
      'يُرجى تسجيل الدخول والدخول إلى دردشة العالم';

  @override
  String get background_world_photo_load_error => 'خطأ';

  @override
  String get background_world_no_photos => 'لا توجد صور متاحة للعالم';

  @override
  String get background_world_cover => 'غلاف العالم';

  @override
  String get background_world_cover_confirm =>
      'هل تريد تعيين غلاف العالم خلفيةً لهذه الدردشة؟';

  @override
  String get background_world_default_limited => 'خلفية محدودة';

  @override
  String get background_world_default_character => 'شخصية';

  @override
  String get background_world_no_character_photos => 'لا تتوفر صور للشخصيات';

  @override
  String background_world_unlock_required(int count) {
    return 'يتطلب فتحها $count نقطة مودة';
  }

  @override
  String background_world_character_confirm(String name) {
    return 'هل تريد تعيين صورة «$name» خلفيةً لدردشة العالم؟';
  }

  @override
  String background_world_affection_count(int count) {
    return '$count نقطة مودة';
  }

  @override
  String get reply_selection => 'خيارات الرد';

  @override
  String get chat_home_character_tab => 'محادثات الشخصيات';

  @override
  String get chat_home_world_tab => 'عوالم مفتوحة';

  @override
  String get chat_home_world_error_generic => 'خطأ';

  @override
  String get chat_home_world_pinned => 'تم تثبيت دردشة العالم';

  @override
  String get chat_home_world_deleted => 'تم حذف دردشة العالم وسجل المحادثة';

  @override
  String get chat_home_world_action_done => 'تم';

  @override
  String get chat_home_world_rename_title => 'سمِّ هذه الذكرى';

  @override
  String chat_home_world_delete_confirm(String name) {
    return 'هل تريد حذف سجل محادثة «$name»؟\n\nسيؤدي هذا إلى حذف المحادثات وملخصات القصة والعلاقات والملاحظات نهائيًا، ولا يمكن التراجع عنه. سيظل العالم المنشور متاحًا.';
  }

  @override
  String get chat_home_world_empty_title =>
      'لا توجد محادثات في العوالم المفتوحة بعد';

  @override
  String get chat_home_world_empty_desc =>
      'ابدأ اللعب في عالم مفتوح لتظهر محادثاتك هنا.';

  @override
  String get chat_home_world_unnamed => 'عالم بلا اسم';

  @override
  String get chat_home_world_private_test => 'تجربة خاصة';

  @override
  String get chat_home_world_no_messages => 'لا توجد رسائل بعد';

  @override
  String get expand_features => 'توسيع الخيارات';

  @override
  String get chat_sticker_all => 'الكل';

  @override
  String get chat_mode_short_daily => 'يومي';

  @override
  String get chat_mode_short_story => 'قصة';

  @override
  String get chat_mode_short_immersive => 'اندماج';

  @override
  String get chat_mode_short_resonance => 'تناغم';

  @override
  String get chat_mode_short_gemini => 'دردشة';

  @override
  String get chat_theater_tool => 'المسرح';

  @override
  String chat_regenerate_insufficient_flowers(int cost) {
    return 'لا توجد زهور كافية. تتطلب إعادة الإنشاء $cost زهرة.';
  }

  @override
  String get chat_regenerate_paid_title => 'إعادة الإنشاء المدفوعة';

  @override
  String chat_regenerate_paid_confirm(int cost) {
    return 'لقد استنفدت محاولات إعادة الإنشاء المجانية اليوم. ستكلف هذه المحاولة $cost زهرة في الوضع الحالي. هل تريد المتابعة؟';
  }

  @override
  String get chat_generic_error => 'خطأ';

  @override
  String get chat_regenerate_confirm => 'تأكيد';

  @override
  String get comment_add_photo => 'إضافة صورة';

  @override
  String get comment_error_generic => 'خطأ';

  @override
  String creator_profile_report_reason_prompt(String creatorName) {
    return 'اختر سبب الإبلاغ عن «$creatorName»:';
  }

  @override
  String get creator_profile_open_worlds => 'العوالم المفتوحة';

  @override
  String get creator_profile_generic_error => 'خطأ';

  @override
  String get creator_profile_refresh => 'تحديث';

  @override
  String get creator_profile_no_open_worlds =>
      'لم ينشر هذا المبدع أي عوالم مفتوحة بعد.';

  @override
  String get creator_profile_unnamed_world => 'عالم بلا اسم';

  @override
  String get creator_program_required_fields =>
      'يرجى إدخال مجال الإبداع وسبب التقديم.';

  @override
  String get creator_program_submitted =>
      'تم إرسال الطلب. تستغرق المراجعة نحو 1–3 أيام.';

  @override
  String get creator_program_error => 'خطأ';

  @override
  String get creator_program_login_required =>
      'يرجى تسجيل الدخول قبل التقدم لبرنامج المبدعين.';

  @override
  String get creator_program_title => 'برنامج المبدعين';

  @override
  String get creator_program_headline => 'دع إبداعك يصل إلى المزيد من الناس';

  @override
  String get creator_program_intro =>
      'إذا كانت لديك أعمال منشورة للعامة، فنرحب بطلبك للانضمام إلى برنامج مبدعي «戀戀拾光». يراجع الفريق الطلبات خلال 1–3 أيام.';

  @override
  String get creator_program_benefits_title => 'مزايا البرنامج';

  @override
  String get creator_program_benefit_dashboard =>
      'لوحة المبدع: عرض عدد المعجبين والشخصيات العامة وإجمالي الإعجابات والمعجبين الجدد هذا الشهر.';

  @override
  String get creator_program_benefit_fans =>
      'إدارة المعجبين: أرسل رسائل، وأدر المعجبين، وقدّم لهم مكافآت باستخدام زهورك.';

  @override
  String get creator_program_benefit_exposure =>
      'الظهور الرسمي: قد تحظى الشخصيات الجديدة بالأولوية على إنستغرام وفي توصيات المبدعين داخل اللعبة.';

  @override
  String get creator_program_benefit_monthly =>
      'مكافأة إبداع شهرية: انشر 3 شخصيات جديدة على الأقل خلال الشهر لتحصل على 520 زهرة في الشهر التالي.';

  @override
  String get creator_program_benefit_merch =>
      'تعاون على منتجات ملموسة: قد تحصل على مكافأة نقدية للإبداع إذا شاركت شخصياتك في منتجات أو صناديق هدايا رسمية، وفقًا لشروط المشروع.';

  @override
  String creator_program_last_review_note(String reason) {
    return 'ملاحظات المراجعة السابقة: $reason';
  }

  @override
  String get creator_program_apply_heading => 'التقديم للانضمام';

  @override
  String get creator_program_direction_label => 'التوجه الإبداعي';

  @override
  String get creator_program_direction_hint =>
      'مثال: رومانسية معاصرة، تاريخي، فانتازيا، BL، GL…';

  @override
  String get creator_program_reason_label => 'سبب رغبتك في الانضمام';

  @override
  String get creator_program_reason_hint =>
      'أخبرنا كيف ترغب في تطوير شخصياتك والتفاعل مع المعجبين.';

  @override
  String get creator_program_social_label => 'رابط اجتماعي (اختياري)';

  @override
  String get creator_program_social_hint =>
      'إنستغرام، Threads، موقع شخصي، إلخ.';

  @override
  String get creator_program_submit => 'إرسال الطلب';

  @override
  String get creator_program_public_character_note =>
      'سيتحقق النظام من أن حسابك يملك شخصية عامة واحدة على الأقل قبل إرسال الطلب.';

  @override
  String get creator_program_status_pending => 'الطلب قيد المراجعة';

  @override
  String get creator_program_status_pending_desc =>
      'تم استلام طلبك. تستغرق المراجعة نحو 1–3 أيام. سنبلغك عبر صندوق بريد اللعبة.';

  @override
  String get creator_program_status_approved => 'تم اعتماد صفة المبدع 🎉';

  @override
  String get creator_program_status_approved_desc =>
      'تهانينا على الانضمام إلى برنامج مبدعي «戀戀拾光»! سترتبط لوحة المبدع وإدارة المعجبين ولافتات التوصية بهذه الصفة في الميزات القادمة.';

  @override
  String get creator_program_status_suspended => 'تم تعليق صفة المبدع';

  @override
  String get creator_program_status_suspended_desc =>
      'لا يمكنك حاليًا استخدام ميزات المبدعين الحصرية. يرجى مراجعة الإشعار الرسمي في بريد اللعبة.';

  @override
  String get creator_program_status_revoked => 'تم إلغاء صفة المبدع';

  @override
  String get creator_program_status_revoked_desc =>
      'لم تعد ميزات المبدعين الحصرية متاحة. إذا كانت لديك أسئلة، يرجى التواصل مع الدعم.';

  @override
  String get creator_program_status_title => 'حالة المبدع';

  @override
  String creator_program_current_status(String status) {
    return 'الحالة الحالية: $status';
  }

  @override
  String creator_program_official_note(String reason) {
    return 'ملاحظات رسمية: $reason';
  }

  @override
  String get creator_dashboard_error1 => 'خطأ';

  @override
  String get creator_dashboard_access_title1 => 'لوحة تحكم المبدعين';

  @override
  String get creator_dashboard_status_notice_title1 =>
      'Creator Dashboard Access Notice';

  @override
  String get creator_dashboard_apply_title1 =>
      'طلب الوصول إلى لوحة تحكم المبدعين';

  @override
  String get creator_dashboard_access_subtitle1 =>
      'إحصاءات لعب الشخصيات · المتابعون الجدد والمغادرون · إدارة المتابعين';

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
  String get creator_dashboard_my_characters1 => 'شخصياتي';

  @override
  String get creator_dashboard_my_worlds1 => 'عوالمِي المفتوحة';

  @override
  String get creator_dashboard_create_world1 => 'إنشاء عالم مفتوح';

  @override
  String get creator_dashboard_public_worlds1 => 'العوالم المنشورة';

  @override
  String get creator_dashboard_public_worlds_hint1 =>
      'Other players can explore';

  @override
  String get creator_dashboard_private_worlds1 => 'عوالم خاصة';

  @override
  String get creator_dashboard_private_worlds_hint1 =>
      'Only you can view and edit';

  @override
  String get creator_dashboard_world_drafts1 => 'مسودات العوالم';

  @override
  String get creator_dashboard_world_drafts_hint1 => 'Worlds not yet finished';

  @override
  String get creator_dashboard_no_drafts1 => 'No drafts yet';

  @override
  String get creator_dashboard_no_worlds1 => 'No worlds yet';

  @override
  String get creator_dashboard_unnamed_world1 => 'عالم بلا عنوان';

  @override
  String get creator_dashboard_delete_world_draft1 => 'Delete world draft';

  @override
  String get creator_dashboard_private_test1 => 'تجربة خاصة';

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
  String get creator_dashboard_confirm_send1 => 'تأكيد الإرسال';

  @override
  String get creator_dashboard_form_heading1 =>
      'Apply for the Lianlian Shiguang Creator Dashboard';

  @override
  String get creator_dashboard_form_description1 =>
      'Tell us about your creative direction and how you plan to use character analytics and follower management. This is not a partnership contract.';

  @override
  String get creator_dashboard_direction_label1 => 'اتجاه الإبداع';

  @override
  String get creator_dashboard_direction_hint1 =>
      'مثال: رومانسية معاصرة، تاريخي، فانتازيا، BL، GL…';

  @override
  String get creator_dashboard_reason_label1 => 'سبب طلب لوحة التحكم';

  @override
  String get creator_dashboard_reason_hint1 =>
      'Share your experience and which dashboard features you need';

  @override
  String get creator_dashboard_sending1 => 'جارٍ الإرسال…';

  @override
  String get creator_dashboard_submit1 => 'إرسال طلب الوصول';

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
  String get creator_support_page_title1 => 'مركز الدعم';

  @override
  String get creator_support_new_report1 => 'بلاغ جديد';

  @override
  String get creator_support_error1 => 'خطأ';

  @override
  String get creator_support_no_cases1 => 'لا توجد بلاغات حاليًا';

  @override
  String get creator_support_unread1 => 'غير مقروء';

  @override
  String get creator_support_load_more1 => 'تحميل المزيد';

  @override
  String get creator_support_category_label1 => 'فئة المشكلة';

  @override
  String get creator_support_character_optional1 =>
      'الشخصية ذات الصلة (اختياري)';

  @override
  String get creator_support_no_character1 => 'دون شخصية محددة';

  @override
  String get creator_support_report_title1 => 'عنوان المشكلة';

  @override
  String get creator_support_report_description1 => 'وصف المشكلة';

  @override
  String creator_support_select_images1(int count) {
    return 'اختر لقطات الشاشة ($count/3، أقل من 2 ميغابايت لكل صورة)';
  }

  @override
  String get creator_support_images_private1 =>
      'لا يمكن عرض اللقطات إلا لمنشئ البلاغ والفريق الرسمي.';

  @override
  String get creator_support_submitting1 => 'جارٍ الإرسال…';

  @override
  String get creator_support_submit1 => 'تأكيد الإرسال';

  @override
  String get creator_support_image_too_large1 =>
      'الصورة أكبر من 2 ميغابايت. اختر أخرى.';

  @override
  String get creator_support_fill_title_description1 =>
      'يرجى إدخال العنوان والوصف.';

  @override
  String get creator_support_case_sent1 => 'تم إرسال البلاغ';

  @override
  String creator_support_case_sent_partial1(int count) {
    return 'تم إرسال البلاغ، لكن تعذر رفع $count لقطات شاشة';
  }

  @override
  String get creator_support_detail_title1 => 'تفاصيل البلاغ';

  @override
  String get creator_support_image_max1 => 'يجب أن تقل كل لقطة عن 2 ميغابايت';

  @override
  String get creator_support_jpg_png_only1 => 'يدعم JPG / PNG فقط';

  @override
  String get creator_support_reply_sent1 => 'تم إرسال الرد';

  @override
  String creator_support_reply_sent_partial1(int count) {
    return 'تم إرسال النص، لكن تعذر رفع $count صور';
  }

  @override
  String get creator_support_empty_content1 => 'لا يمكن ترك المحتوى فارغًا';

  @override
  String get creator_support_recall_message1 => 'استرجاع الرسالة';

  @override
  String get creator_support_delete_message1 => 'حذف الرسالة';

  @override
  String get creator_support_recall_warning1 =>
      'سيظهر للطرفين «تم استرجاع هذه الرسالة»، ولن تكون المرفقات متاحة.';

  @override
  String get creator_support_delete_warning1 =>
      'إخفاء الرسالة من جهتك فقط؛ ستبقى لدى الطرف الآخر.';

  @override
  String get creator_support_cancel1 => 'إلغاء';

  @override
  String get creator_support_confirm1 => 'تأكيد';

  @override
  String get creator_support_operation_success1 => 'تمت العملية بنجاح';

  @override
  String get creator_support_edit_message1 => 'تعديل الرسالة';

  @override
  String creator_support_recall_remaining1(int seconds) {
    return 'استرجاع الرسالة (باقي $seconds ثانية)';
  }

  @override
  String get creator_support_recall_expired1 =>
      'استرجاع الرسالة (مرّ أكثر من 60 ثانية)';

  @override
  String get creator_support_case_updated1 => 'تم تحديث البلاغ';

  @override
  String get creator_support_loading1 => 'جارٍ التحميل…';

  @override
  String creator_support_creator_uid1(String uid) {
    return 'معرّف المنشئ: $uid';
  }

  @override
  String get creator_support_internal_note1 =>
      'ملاحظات داخلية (مخفية عن المنشئ)';

  @override
  String get creator_support_save_internal_note1 => 'حفظ الملاحظات الداخلية';

  @override
  String get creator_support_case_images1 => 'لقطات البلاغ';

  @override
  String get creator_support_official1 => 'فريق ليانليان شيغوانغ الرسمي';

  @override
  String get creator_support_creator1 => 'منشئ';

  @override
  String get creator_support_recalled1 => 'تم استرجاع هذه الرسالة';

  @override
  String get creator_support_edited1 => 'تم التعديل';

  @override
  String get creator_support_reply_hint1 => 'اكتب ردًا…';

  @override
  String get creator_support_attach_image1 => 'إرفاق لقطات شاشة (حتى 3)';

  @override
  String get creator_support_send1 => 'إرسال';

  @override
  String get creator_support_admin_title1 => 'إدارة بلاغات المنشئين';

  @override
  String get creator_support_new_reply1 => 'رد جديد';

  @override
  String get creator_support_load_more_cases1 => 'تحميل المزيد من البلاغات';

  @override
  String get creator_support_image_load_error1 => 'تعذر تحميل لقطة الشاشة';

  @override
  String get creator_support_edit_hint1 => 'تعديل محتوى الرسالة';

  @override
  String get creator_support_save1 => 'حفظ';

  @override
  String get creator_support_status_pending1 => 'قيد الانتظار';

  @override
  String get creator_support_status_progress1 => 'قيد المعالجة';

  @override
  String get creator_support_status_waiting1 => 'بانتظار معلومات إضافية';

  @override
  String get creator_support_status_resolved1 => 'تم الحل';

  @override
  String get creator_support_cat_character1 => 'إدارة الشخصيات';

  @override
  String get creator_support_cat_ai1 =>
      'مشكلة التفاعل مع شخصية الذكاء الاصطناعي';

  @override
  String get creator_support_cat_dashboard1 => 'لوحة تحكم المنشئ';

  @override
  String get creator_support_cat_cooperation1 => 'التعاون والمزايا';

  @override
  String get creator_support_cat_other1 => 'مشكلة أخرى';

  @override
  String get desktop_widget_size_small1 => 'صغير';

  @override
  String get desktop_widget_size_medium1 => 'متوسط';

  @override
  String get desktop_widget_size_large1 => 'كبير';

  @override
  String get desktop_widget_cancel1 => 'إلغاء';

  @override
  String get desktop_widget_delete1 => 'حذف';

  @override
  String desktop_widget_days_remaining1(int days) {
    return 'متبقٍ $days أيام';
  }

  @override
  String get desktop_widget_days_today1 => 'اليوم هو الموعد';

  @override
  String desktop_widget_days_elapsed1(int days) {
    return 'منذ $days أيام';
  }

  @override
  String get desktop_widget_daily_quote1 => 'اقتباس اليوم';

  @override
  String get desktop_widget_update_daily1 => 'التحديث مرة يوميًا';

  @override
  String get desktop_widget_character_birthday1 => 'عيد ميلاد الشخصية';

  @override
  String get desktop_widget_change1 => 'تغيير';

  @override
  String get desktop_widget_mood1 => 'المزاج';

  @override
  String get desktop_widget_current_state1 => 'الحالة الحالية';

  @override
  String get desktop_widget_location1 => 'الموقع';

  @override
  String get desktop_widget_relationship1 => 'العلاقة';

  @override
  String get desktop_widget_outfit1 => 'الملابس';

  @override
  String get desktop_widget_weather1 => 'الطقس';

  @override
  String get desktop_widget_thought1 => 'الأفكار';

  @override
  String get desktop_widget_action1 => 'الأفعال';

  @override
  String get desktop_widget_affinity1 => 'مستوى المودة';

  @override
  String get desktop_widget_character_status1 => 'حالة الشخصية';

  @override
  String get desktop_widget_no_posts1 => 'لا توجد منشورات للشخصية بعد';

  @override
  String get desktop_widget_crop_position1 => 'ضبط موضع الشخصية';

  @override
  String get desktop_widget_crop_action1 => 'كبّر / اسحب لضبط الإطار';

  @override
  String get desktop_widget_crop_hint1 =>
      'استخدم إصبعين للتكبير وإصبعًا واحدًا للسحب دون تحريك الصفحة.';

  @override
  String get desktop_widget_crop_title1 => 'ضبط إطار الشخصية';

  @override
  String get desktop_widget_reset1 => 'إعادة ضبط';

  @override
  String get desktop_widget_crop_instructions1 =>
      'اسحب بإصبع واحد لتغيير الموضع وبإصبعين للتكبير. ما داخل الإطار سيظهر في الأداة.';

  @override
  String desktop_widget_crop_position_scale1(int x, int y, String scale) {
    return 'الموضع: $x% / $y% · التكبير: $scale×';
  }

  @override
  String get desktop_widget_apply1 => 'تطبيق';

  @override
  String get desktop_widget_just_posted1 => 'نشر تحديثًا للتو';

  @override
  String get desktop_widget_important_day1 => 'يوم مميز';

  @override
  String get desktop_widget_no_date1 => 'لم يتم اختيار تاريخ';

  @override
  String get desktop_widget_first_met1 => 'يوم لقائنا';

  @override
  String get desktop_widget_error1 => 'خطأ';

  @override
  String get event_memory_select_character_title1 => 'اختيار شخصية';

  @override
  String get event_memory_my_characters1 => 'شخصياتي';

  @override
  String get event_memory_friend_characters1 => 'شخصيات الأصدقاء';

  @override
  String get event_memory_friend_badge1 => 'صديق';

  @override
  String get event_memory_unnamed_character1 => 'شخصية بلا اسم';

  @override
  String get event_memory_generic_error1 => 'خطأ';

  @override
  String get memory_collection_title1 => 'مجموعة الذكريات';

  @override
  String get memory_collection_avatar_frames1 => 'إطارات الصور الشخصية';

  @override
  String get memory_collection_stickers1 => 'ملصقات';

  @override
  String get memory_collection_memories1 => 'ذكريات';

  @override
  String get memory_collection_try_again1 => 'يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get memory_collection_error1 => 'خطأ';

  @override
  String get memory_collection_chat_background1 => 'خلفيات الدردشة';

  @override
  String get memory_collection_got_it1 => 'فهمت';

  @override
  String get memory_collection_not_now1 => 'ليس الآن';

  @override
  String get memory_collection_confirm_delete1 => 'تأكيد الحذف';

  @override
  String get memory_collection_close1 => 'إغلاق';

  @override
  String get memory_collection_delete1 => 'حذف';

  @override
  String get memory_collection_image_preparing1 => 'جارٍ تجهيز الصورة';

  @override
  String get memory_collection_remove_favorite1 => 'إزالة من المجموعة';

  @override
  String get memory_collection_removed1 => 'تمت الإزالة من المجموعة';

  @override
  String get event_memory_performance_opening1 =>
      'تبقى بعض اللحظات،\nحتى بعد انتهاء القصة.';

  @override
  String get event_memory_performance_generic_error1 => 'خطأ';

  @override
  String get event_memory_performance_collected1 => 'تم الحفظ';

  @override
  String get event_memory_performance_saving1 => 'جارٍ الحفظ…';

  @override
  String get event_memory_performance_save_gallery1 => 'حفظ في معرض الصور';

  @override
  String get event_memory_performance_done1 => 'تم';

  @override
  String get event_memory_performance_uncollect_title1 => 'إزالة من المجموعة؟';

  @override
  String get event_memory_performance_not_now1 => 'ليس الآن';

  @override
  String get event_memory_performance_uncollect1 => 'إزالة من المجموعة';

  @override
  String get event_memory_performance_uncollected1 => 'تمت الإزالة من المجموعة';

  @override
  String get event_memory_performance_login_to_collect1 =>
      'سجّل الدخول لحفظ هذه الذكرى';

  @override
  String get event_memory_performance_web_gallery_unsupported1 =>
      'لا يدعم إصدار الويب الحفظ المباشر في معرض الهاتف';

  @override
  String get event_memory_performance_gallery_permission1 =>
      'يلزم إذن الوصول إلى الصور لحفظ هذه الذكرى';

  @override
  String get event_memory_performance_image_not_ready1 =>
      'صورة الذكرى غير جاهزة بعد. حاول مرة أخرى';

  @override
  String get event_memory_performance_gallery_saved1 =>
      'تم الحفظ في معرض الصور';

  @override
  String get event_memory_performance_skip1 => 'تخطٍّ';

  @override
  String get event_memory_performance_memory_label1 => 'ذكرى';

  @override
  String get event_memory_performance_tap_continue1 => 'اضغط للمتابعة';

  @override
  String get event_memory_performance_tap_show_full1 =>
      'اضغط لإظهار النص كاملًا';

  @override
  String get event_memory_performance_brand_limited_memory1 =>
      'ليانليان شيغوانغ · ذكرى محدودة';

  @override
  String get event_ended1 => 'انتهى الحدث';

  @override
  String get event_default_name1 => 'حدث لفترة محدودة';

  @override
  String get event_default_subtitle1 => 'اصنعي ذكريات مميزة معه هذا الموسم.';

  @override
  String get event_currency_default1 => 'عملة الحدث';

  @override
  String get event_tasks_today1 => 'مهام اليوم';

  @override
  String event_tasks_subtitle1(String currency) {
    return 'أكملي المهام واجمعي $currency لفتح المزيد من المحتوى الحصري.';
  }

  @override
  String get event_milestones_title1 => 'التقدم التراكمي';

  @override
  String event_milestones_subtitle1(String currency) {
    return 'اجمعي $currency لتحصلي على مكافآت الحدث الحصرية.';
  }

  @override
  String get event_memory_title1 => 'ذكريات حصرية';

  @override
  String get event_memory_subtitle1 => 'احتفظي بذكرى خاصة من هذا الحدث.';

  @override
  String get event_shop_title1 => 'متجر الحدث';

  @override
  String event_shop_subtitle1(String currency) {
    return 'استبدلي $currency بمكافآت حصرية.';
  }

  @override
  String get event_info_title1 => 'تفاصيل الحدث';

  @override
  String get event_info_default1 =>
      'أكملي المهام المحددة لكسب عملة الحدث.\nستُضاف المكافآت المستبدلة إلى حسابك وفق القواعد.\nستُعالج العملة غير المستخدمة وفق القواعد بعد انتهاء الحدث.';

  @override
  String get event_generic_error1 => 'خطأ';

  @override
  String get event_task_default1 => 'مهمة الحدث';

  @override
  String get event_claimed1 => 'تم الاستلام';

  @override
  String get event_claim1 => 'استلام';

  @override
  String get event_in_progress1 => 'جارٍ';

  @override
  String get event_reward_default1 => 'مكافأة حصرية';

  @override
  String get event_product_default1 => 'عنصر الحدث';

  @override
  String get event_cancel1 => 'إلغاء';

  @override
  String get event_confirm_exchange1 => 'تأكيد الاستبدال';

  @override
  String get event_limited_product1 => 'عنصر حصري';

  @override
  String event_insufficient_currency1(String currency) {
    return 'لا توجد $currency كافية';
  }

  @override
  String get event_close1 => 'إغلاق';

  @override
  String event_redeemed_count_limit1(int count, int max) {
    return 'تم الاستبدال $count / $max مرة';
  }

  @override
  String event_redeemed_count1(int count) {
    return 'تم الاستبدال $count مرة';
  }

  @override
  String get event_redeemed1 => 'تم الاستبدال';

  @override
  String get event_exchange1 => 'استبدال';

  @override
  String get login_account_deletion_started1 => 'جارٍ حذف الحساب';

  @override
  String get login_account_deletion_expired_description1 =>
      'انتهت مهلة الأيام الثلاثة لإلغاء الحذف، ولم يعد بالإمكان استعادة هذا الحساب. يُرجى التواصل مع الدعم إذا كنت بحاجة إلى مساعدة.';

  @override
  String get login_account_deletion_confirm1 => 'حسنًا';

  @override
  String get event_memory_limited_title1 => 'ذكرى حصرية';

  @override
  String get moment_detail_add_photo1 => 'إضافة صورة';

  @override
  String get moment_detail_error1 => 'خطأ';

  @override
  String get notification_claim_before_delete1 =>
      'استلم الزهور قبل حذف رسالة الهدية';

  @override
  String get notification_error1 => 'خطأ';

  @override
  String get notification_creator_gift_already_claimed1 =>
      'لقد استلمت هذه الزهور بالفعل';

  @override
  String notification_creator_gift_claim_success1(Object amount) {
    return 'تم استلام $amount زهرة بنجاح!';
  }

  @override
  String get notification_creator_gift_title1 => 'هدية من المبدع';

  @override
  String notification_creator_gift_amount1(Object amount) {
    return '$amount زهرة';
  }

  @override
  String get notification_creator_gift_claimed1 => 'تم الاستلام';

  @override
  String get notification_creator_gift_claiming1 => 'جارٍ الاستلام…';

  @override
  String get notification_creator_gift_claim_button1 => 'استلام الزهور';

  @override
  String get notification_support_subject1 => 'العنوان الذي أرسله اللاعب';

  @override
  String get notification_support_content1 => 'المحتوى الذي أرسله اللاعب';

  @override
  String get notification_support_reported1 => 'المحتوى المبلّغ عنه';

  @override
  String get notification_support_reply1 => 'رد الدعم';

  @override
  String get notification_share_mail1 => 'مشاركة الرسالة';

  @override
  String get notification_original_question1 => 'سؤالك الأصلي';

  @override
  String get notification_preferences_chat_title1 => 'محادثات الشخصيات';

  @override
  String get notification_preferences_chat_subtitle1 =>
      'إشعارات فورية بردود الشخصيات';

  @override
  String get notification_preferences_moments_title1 => 'منشورات جديدة';

  @override
  String get notification_preferences_moments_subtitle1 =>
      'منشورات جديدة من المبدعين والشخصيات التي تتابعها';

  @override
  String get notification_preferences_social_title1 => 'إشعارات اجتماعية';

  @override
  String get notification_preferences_social_subtitle1 =>
      'الإعجابات والتعليقات والمتابعات والتفاعل مع الشخصيات';

  @override
  String get notification_preferences_announcements_title1 =>
      'الإعلانات الرسمية';

  @override
  String get notification_preferences_announcements_subtitle1 =>
      'إشعارات الإعلانات الرسمية العامة';

  @override
  String get notification_preferences_events_title1 => 'تذكيرات الفعاليات';

  @override
  String get notification_preferences_events_subtitle1 =>
      'إشعارات باقتراب انتهاء الفعاليات';

  @override
  String get notification_preferences_save_failed1 =>
      'تعذّر حفظ إعدادات الإشعارات. يُرجى المحاولة لاحقًا.';

  @override
  String get notification_preferences_page_title1 => 'تفضيلات الإشعارات';

  @override
  String get notification_preferences_login_required1 =>
      'يُرجى تسجيل الدخول إلى حسابك أولًا';

  @override
  String get notification_preferences_load_failed1 =>
      'تعذّر تحميل تفضيلات الإشعارات. يُرجى المحاولة لاحقًا.';

  @override
  String get notification_preferences_footer1 =>
      'تتم مزامنة هذه الإعدادات على جميع الأجهزة المسجّل دخولها إلى حساب اللاعب نفسه. يجب ضبط أذونات إشعارات النظام على كل جهاز على حدة. لن يؤدي إيقاف الإشعارات الفورية إلى حذف صندوق بريد اللعبة أو الإشعارات المستلمة مسبقًا.';

  @override
  String get official_studio_text_0011 =>
      'Guide completed, but the viewed status could not sync and may appear again.';

  @override
  String get official_studio_text_0021 => 'يرجى تسجيل الدخول';

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
  String get official_studio_text_0101 => 'إدارة المتابعين';

  @override
  String get official_studio_text_0111 => 'View and remove followers';

  @override
  String get official_studio_text_0121 => 'إحصاءات المبدعين';

  @override
  String get official_studio_text_0131 =>
      'Character popularity and total play count';

  @override
  String get official_studio_text_0141 => 'رسائل المعجبين';

  @override
  String get official_studio_text_0151 => 'Send messages to your followers';

  @override
  String get official_studio_text_0161 => 'Fan Benefits';

  @override
  String get official_studio_text_0171 => 'Gift your own flowers to followers';

  @override
  String get official_studio_text_0181 => 'مكافأة المبدع الشهرية';

  @override
  String get official_studio_text_0191 =>
      'Publish 3 new characters to claim 300 flowers';

  @override
  String get official_studio_text_0201 => 'لافتة المبدع';

  @override
  String get official_studio_text_0211 => 'Set your public creator-page banner';

  @override
  String get official_studio_text_0221 => 'معلومات الشراكة';

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
  String get official_studio_text_0431 => 'إلغاء';

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
  String get official_studio_text_1141 => 'اذهب إلى المتجر';

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
  String get official_studio_text_1281 => 'ابحث عن متابعين';

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
  String get official_studio_text_1731 => 'تخطي';

  @override
  String get official_studio_text_1741 => 'السابق';

  @override
  String get official_studio_text_1751 => 'تم';

  @override
  String get official_studio_text_1761 => 'التالي';

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
  String get preference_selection_title1 => 'اختر أنواع الشخصيات المفضلة لديك';

  @override
  String get preference_selection_description1 =>
      'اختر من 3 إلى 5 وسوم تعجبك لنقترح عليك شخصيات تناسب ذوقك.';

  @override
  String get preference_selection_recommendation_note1 =>
      'تُستخدم هذه التفضيلات لتحسين الاقتراحات فقط، ويمكنك استكشاف بقية أنواع الشخصيات أيضًا.';

  @override
  String get preference_selection_selected1 => 'تم الاختيار';

  @override
  String get preference_selection_start1 => 'ابدأ الاستكشاف';

  @override
  String preference_selection_max_error1(int count) {
    return 'يمكنك اختيار $count وسوم كحد أقصى.';
  }

  @override
  String get preference_selection_save_failed1 =>
      'تعذّر حفظ تفضيلاتك. يُرجى المحاولة لاحقًا.';

  @override
  String get preference_group_personality1 => 'الشخصية والطباع';

  @override
  String get preference_group_relationship_age1 => 'العلاقة والفارق العمري';

  @override
  String get preference_group_story1 => 'أجواء القصة';

  @override
  String get preference_tag_gentle1 => 'لطيف';

  @override
  String get preference_tag_cold1 => 'بارد ومتحفظ';

  @override
  String get preference_tag_scheming1 => 'ماكر';

  @override
  String get preference_tag_tsundere1 => 'تسونْديري';

  @override
  String get preference_tag_loyal1 => 'وفيّ';

  @override
  String get preference_tag_yandere1 => 'يانديري';

  @override
  String get preference_tag_mysterious1 => 'غامض';

  @override
  String get preference_tag_healing1 => 'مريح للنفس';

  @override
  String get preference_tag_gap_moe1 => 'شخصية ذات جانب مفاجئ';

  @override
  String get preference_tag_older1 => 'أكبر سنًا';

  @override
  String get preference_tag_younger1 => 'أصغر سنًا';

  @override
  String get preference_tag_ceo1 => 'مدير تنفيذي متسلط';

  @override
  String get preference_tag_school1 => 'مدرسي';

  @override
  String get preference_tag_workplace1 => 'بيئة العمل';

  @override
  String get preference_tag_ancient1 => 'تاريخي';

  @override
  String get preference_tag_nonhuman1 => 'غير بشري';

  @override
  String get private_label1 => 'خاص';

  @override
  String get profile_page_world_tab1 => 'عوالم مفتوحة';

  @override
  String get profile_page_login_required1 => 'يرجى تسجيل الدخول أولاً';

  @override
  String get profile_page_world_load_failed1 =>
      'تعذّر تحميل العوالم. يُرجى المحاولة لاحقًا.';

  @override
  String get profile_page_my_worlds1 => 'عوالمِي المفتوحة';

  @override
  String get profile_page_create_world1 => 'إنشاء عالم';

  @override
  String get profile_page_worlds_empty1 => 'لم تُنشئ أي عالم بعد';

  @override
  String get profile_page_worlds_empty_hint1 => 'أنشئ عالمك الأول';

  @override
  String get profile_page_world_untitled1 => 'عالم بلا اسم';

  @override
  String get profile_page_world_public1 => 'عام';

  @override
  String get profile_page_world_private1 => 'خاص';

  @override
  String profile_page_world_character_count1(int count) {
    return '$count شخصيات';
  }

  @override
  String get profile_page_world_enter_chat1 => 'الدخول إلى المحادثة';

  @override
  String get profile_page_world_edit1 => 'تعديل';

  @override
  String get profile_page_create_character1 => 'إنشاء شخصية';

  @override
  String get profile_page_event_frame_default1 => 'إطار صورة رمزية للفعالية';

  @override
  String get public_worlds_explore_title1 => 'استكشاف العوالم العامة';

  @override
  String get public_worlds_search_tooltip1 => 'البحث عن العوالم المفتوحة';

  @override
  String get public_worlds_load_failed1 => 'يتعذر تحميل العوالم العامة مؤقتًا';

  @override
  String get public_worlds_refresh1 => 'تحديث';

  @override
  String get public_worlds_empty1 =>
      'العوالم العامة قيد الإعداد. ترقّبوا الجديد!';

  @override
  String get public_worlds_unnamed1 => 'عالم بلا اسم';

  @override
  String get world_explore_subtitle1 => 'ادخل عوالم مختلفة واكتشف رحلات فريدة';

  @override
  String get settings_notification_preferences_title1 => 'تفضيلات الإشعارات';

  @override
  String get settings_notification_preferences_subtitle1 =>
      'اختر أنواع الإشعارات التي ترغب في تلقيها، مع مزامنة الإعدادات بين الأجهزة';

  @override
  String get settings_admin_section1 => 'الإدارة';

  @override
  String get settings_admin_dashboard1 => 'لوحة تحكم المشرف';

  @override
  String get settings_admin_tools_subtitle1 => 'أدوات الإدارة الداخلية';

  @override
  String get world_chat_back1 => 'رجوع';

  @override
  String get world_chat_mode_tooltip1 =>
      'وضع الرد (لم يتم ربط الذكاء الاصطناعي وخصم الزهور بعد)';

  @override
  String get world_chat_menu1 => 'قائمة العالم';

  @override
  String get world_chat_mode_story1 => 'القصة';

  @override
  String get world_chat_mode_immersive1 => 'الانغماس';

  @override
  String get world_chat_mode_resonance1 => 'التناغم';

  @override
  String get world_chat_mode_interaction1 => 'التفاعل';

  @override
  String world_chat_mode_cost1(String mode, int cost) {
    return '$mode · $cost زهور';
  }

  @override
  String world_memo_read_failed1(String error) {
    return 'تعذّر تحميل الملاحظات: $error';
  }

  @override
  String get world_memo_sync_failed1 =>
      'فشلت المزامنة مؤقتًا. يتم عرض الملاحظات المحمّلة سابقًا.';

  @override
  String get world_memo_server_no_id1 => 'لم يُرجع الخادم معرّف الملاحظة';

  @override
  String world_memo_save_failed1(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get world_memo_delete_title1 => 'هل تريد حذف الملاحظة؟';

  @override
  String get world_memo_delete_warning1 => 'لا يمكن التراجع عن الحذف.';

  @override
  String get world_memo_cancel1 => 'إلغاء';

  @override
  String get world_memo_delete1 => 'حذف';

  @override
  String world_memo_cancel_reminder_failed1(String error) {
    return 'حُذفت الملاحظة، لكن تعذّر إلغاء التذكير على الجهاز القديم: $error';
  }

  @override
  String world_memo_delete_failed1(String error) {
    return 'فشل الحذف: $error';
  }

  @override
  String get world_memo_title1 => 'الملاحظات';

  @override
  String world_memo_world_personal1(String worldName) {
    return '$worldName | ملاحظات شخصية';
  }

  @override
  String get world_memo_sync_notice1 =>
      'تتم مزامنة أوقات التذكير بين الأجهزة، وتُرسل إشعارات فورية إلى الأجهزة المسجّلة التي تسمح بالإشعارات.';

  @override
  String get world_memo_loading1 => 'جارٍ التحميل…';

  @override
  String get world_memo_empty1 => 'لا توجد ملاحظات بعد. اضغط + لإضافة ملاحظة.';

  @override
  String world_memo_reminder_date1(String date) {
    return 'التذكير: $date';
  }

  @override
  String get world_memo_reminder_future1 =>
      'يجب أن يكون وقت التذكير في المستقبل';

  @override
  String get world_memo_content_required1 => 'أدخل محتوى الملاحظة أولًا';

  @override
  String get world_memo_edit_title1 => 'تعديل الملاحظة';

  @override
  String get world_memo_add_title1 => 'ملاحظة جديدة';

  @override
  String get world_memo_content_label1 => 'محتوى الملاحظة';

  @override
  String get world_memo_content_hint1 => 'اكتب شيئًا تريد تذكّره…';

  @override
  String get world_memo_reminder_settings1 => 'إعدادات التذكير';

  @override
  String get world_memo_no_reminder1 => 'لم يتم تعيين تذكير';

  @override
  String get world_memo_reminder_choose1 =>
      'اختر التاريخ والوقت لتذكير تتم مزامنته عبر السحابة';

  @override
  String get world_memo_clear_reminder1 => 'مسح تاريخ التذكير';

  @override
  String get world_memo_save1 => 'حفظ الملاحظة';

  @override
  String get world_chat_open_world1 => 'عالم مفتوح';

  @override
  String get world_chat_flower_sync1 => 'تعذرت مزامنة رصيد الزهور حاليًا';

  @override
  String get world_chat_web_store_unavailable1 =>
      'شراء الزهور غير متاح على الويب حاليًا';

  @override
  String get world_chat_sync_unavailable1 =>
      'المزامنة الفورية غير متاحة. أعد فتح المحادثة لتحميل السجل.';

  @override
  String get world_chat_stopped1 => 'توقف الإنشاء. لن تُخصم زهور.';

  @override
  String get world_chat_cannot_stop1 =>
      'ربما اكتمل الرد بالفعل. تحقق من المحادثة ورصيد الزهور.';

  @override
  String get world_chat_stop_retry1 => 'تعذر الإيقاف حاليًا. حاول مرة أخرى.';

  @override
  String get world_chat_connection_failed1 => 'فشل الاتصال';

  @override
  String get world_chat_network_failed1 => 'الشبكة غير متاحة مؤقتًا';

  @override
  String get world_chat_no_regenerate1 => 'لا يوجد رد لإعادة إنشائه';

  @override
  String get world_chat_paid_regenerate1 => 'إعادة إنشاء مدفوعة';

  @override
  String get world_chat_cancel1 => 'إلغاء';

  @override
  String get world_chat_confirm1 => 'تأكيد';

  @override
  String get world_chat_no_continue1 => 'لا توجد قصة للمتابعة';

  @override
  String get world_chat_no_save1 => 'لا توجد محادثات لحفظها بعد';

  @override
  String get world_chat_loading1 => 'جارٍ تحميل المحادثة';

  @override
  String get world_chat_unnamed_character1 => 'شخصية بلا اسم';

  @override
  String get world_chat_bg_wait1 => 'يمكن تغيير الخلفية بعد تحميل المحادثة';

  @override
  String get world_chat_sign_in1 => 'يرجى تسجيل الدخول أولاً';

  @override
  String get world_chat_choose_mode1 => 'اختر نمط العالم';

  @override
  String get world_chat_mode_charge_expl1 =>
      'تُخصم الزهور لكل رد ناجح حسب النمط؛ الفشل مجاني.';

  @override
  String get world_chat_photo_selected1 => 'تم اختيار الصورة';

  @override
  String get world_chat_got_it1 => 'فهمت';

  @override
  String get world_chat_status_settings1 => 'إعدادات عرض حالة العالم';

  @override
  String get world_chat_save_settings1 => 'حفظ الإعدادات';

  @override
  String get world_chat_status_saved1 =>
      'تم حفظ تفضيلات عرض الحالة لهذا العالم';

  @override
  String get world_chat_not_ready1 => 'محادثة العالم ليست جاهزة بعد';

  @override
  String get world_chat_enter_first1 => 'ادخل محادثة العالم أولاً';

  @override
  String get world_chat_photo1 => 'صورة';

  @override
  String get world_chat_profile1 => 'الملف الشخصي';

  @override
  String get world_chat_interaction1 => 'التفاعلات';

  @override
  String get world_chat_theater1 => 'مسرح';

  @override
  String get world_chat_status1 => 'الحالة';

  @override
  String get world_chat_secret1 => 'فصول سرية';

  @override
  String get world_chat_mood1 => 'المزاج';

  @override
  String get world_chat_outfit1 => 'الملابس';

  @override
  String get world_chat_relationship1 => 'العلاقة';

  @override
  String get world_chat_thought1 => 'الأفكار';

  @override
  String get world_chat_weather1 => 'الطقس';

  @override
  String get world_chat_current_state1 => 'الحالة الحالية';

  @override
  String get world_chat_action1 => 'الحركة';

  @override
  String get world_chat_affinity1 => 'الألفة';

  @override
  String get world_chat_generating1 => 'العالم يمضي بهدوء…';

  @override
  String get world_chat_screenshot1 => 'مشاركة لقطة شاشة';

  @override
  String get world_chat_copy1 => 'نسخ المحتوى';

  @override
  String get world_chat_copied1 => 'تم النسخ';

  @override
  String get world_chat_edit1 => 'تعديل';

  @override
  String get world_chat_delete1 => 'حذف';

  @override
  String get world_chat_report1 => 'الإبلاغ عن المحادثة';

  @override
  String get world_chat_feedback1 => 'إرسال ملاحظات';

  @override
  String get world_chat_edit_segment1 => 'تعديل مقطع الشخصية';

  @override
  String get world_chat_save1 => 'حفظ';

  @override
  String get world_chat_updated1 => 'تم تحديث الرسالة';

  @override
  String get world_chat_delete_segment1 => 'حذف المقطع';

  @override
  String get world_chat_deleted_segment1 => 'تم حذف المقطع';

  @override
  String get world_chat_edit_message1 => 'تعديل الرسالة';

  @override
  String get world_chat_edit_hint1 => 'عدّل نصك';

  @override
  String get world_chat_delete_conversation1 => 'حذف المحادثة';

  @override
  String get world_chat_no_chat1 => 'لا توجد محادثات بعد';

  @override
  String get world_chat_cancel_select1 => 'إلغاء التحديد';

  @override
  String get world_chat_input_hint1 => 'اكتبوا قصتكم…';

  @override
  String get world_chat_screenshot_done1 => 'لحظتك الخاصة جاهزة';

  @override
  String get world_chat_screenshot_style1 => 'تغيير ألوان لقطة الشاشة';

  @override
  String get world_chat_reselect1 => 'اختيار مجددًا';

  @override
  String get world_chat_download_share1 => 'تنزيل ومشاركة';

  @override
  String get world_records_summary_title1 => 'ملخص القصة';

  @override
  String world_records_loaded_count1(int count) {
    return 'تم تحميل $count رسالة دردشة وترتيبها حسب تسلسل القصة.';
  }

  @override
  String get world_records_auto_summary_pending1 =>
      'تُعرض مراجعة للمحادثات المحمّلة فقط؛ الملخص التلقائي بالذكاء الاصطناعي غير متاح بعد.';

  @override
  String get world_records_empty_story1 => 'لا توجد أحداث لمراجعتها بعد';

  @override
  String get world_records_narrator_name1 => 'راوي العالم';

  @override
  String get world_records_relationships_title1 => 'علاقات الشخصيات';

  @override
  String get world_records_affinity_note1 =>
      'تُحسب المودة لكل شخصية رسمية على حدة؛ ولا تُحتسب نقاط للشخصيات المؤقتة.';

  @override
  String get world_records_empty_characters1 =>
      'لا توجد بيانات لشخصيات رسمية بعد';

  @override
  String world_records_affinity_score_with_next1(int score, int next) {
    return 'المودة $score / $next';
  }

  @override
  String world_records_affinity_score_only1(int score) {
    return 'المودة $score';
  }

  @override
  String world_records_relationship_stage1(int stage) {
    return 'مرحلة العلاقة $stage';
  }

  @override
  String get world_records_local_memo_read_failed1 =>
      'تعذّر تحميل المذكرة المحلية';

  @override
  String get world_records_memo_saved_local1 => 'تم حفظ المذكرة على هذا الجهاز';

  @override
  String get world_records_memo_save_failed1 => 'تعذّر حفظ المذكرة';

  @override
  String get world_records_memo_unsaved1 => 'مذكرة غير محفوظة';

  @override
  String get world_records_memo_save_before_exit1 =>
      'هل تريد الحفظ قبل المغادرة؟';

  @override
  String get world_records_continue_editing1 => 'متابعة التحرير';

  @override
  String get world_records_save_and_exit1 => 'حفظ ومغادرة';

  @override
  String get world_records_world_memo_title1 => 'مذكرة لهذا العالم';

  @override
  String get world_records_save1 => 'حفظ';

  @override
  String get world_records_memo_local_disclaimer1 =>
      'مذكرة خاصة | تُحفظ هذه النسخة على هذا الجهاز فقط، ولا تُرسل إلى الذكاء الاصطناعي أو تُزامن مع الأجهزة الأخرى.';

  @override
  String get world_records_memo_hint1 =>
      'دوّن الأدلة التي اكتشفتها أو خططك أو ما تود قوله للشخصيات…';

  @override
  String get world_records_narrator_short1 => 'الراوي';

  @override
  String get world_records_summary_service_missing1 =>
      'لم تُنشر خدمة ملخص القصة (worldStoryMemory) بعد. انشرها ثم افتح الصفحة مجددًا.';

  @override
  String get world_records_summary_load_failed1 =>
      'تعذّر تحميل ملخص القصة. حاول لاحقًا.';

  @override
  String get world_records_summary_intro1 =>
      'كل لقاء واختيار يصبح جزءًا من القصة. تُسجَّل هنا التجارب والعلاقات المهمة مع استمرار رحلتك.';

  @override
  String get world_records_summary_empty1 =>
      'تستمر قصتك، وستظهر فصولها المميزة هنا قريبًا.';

  @override
  String get world_search_title1 => 'البحث في المحادثات';

  @override
  String get world_search_hint1 => 'ابحث عن الشخصيات أو الحوارات أو السرد';

  @override
  String get world_search_clear1 => 'مسح البحث';

  @override
  String get world_search_start1 => 'أدخل كلمة مفتاحية لبدء البحث';

  @override
  String world_search_results1(int count) {
    return 'تم العثور على $count نتيجة';
  }

  @override
  String get world_search_empty_prompt1 => 'ابحث عن اللاعبين والشخصيات والسرد';

  @override
  String get world_search_no_results1 => 'لا توجد محادثات مطابقة';

  @override
  String get world_search_unknown_speaker1 => 'شخصية غير معروفة';

  @override
  String get world_search_collapse1 => 'طي';

  @override
  String get world_search_expand1 => 'توسيع';

  @override
  String get world_search_scope1 =>
      'نطاق البحث: آخر 200 رسالة تم تحميلها في المحادثة';

  @override
  String get world_menu_subtitle1 => 'عالم مفتوح · ستتوفر الميزات تدريجيًا';

  @override
  String get world_menu_chat_section1 => 'الدردشة';

  @override
  String get world_menu_search1 => 'البحث في المحادثات';

  @override
  String get world_menu_save_transcript1 => 'حفظ سجل المحادثات';

  @override
  String get world_menu_memories_background1 => 'الذكريات والخلفيات';

  @override
  String get world_menu_relations_section1 => 'علاقات العالم';

  @override
  String get world_menu_story_summary1 => 'ملخص القصة';

  @override
  String get world_menu_relationships1 => 'علاقات الشخصيات';

  @override
  String get world_menu_memos1 => 'ملاحظات';

  @override
  String get world_menu_memory_section1 => 'إدارة الذكريات';

  @override
  String get world_menu_reset_progress1 => 'إعادة ضبط تقدم العالم';

  @override
  String get world_chat_book_confirm1 => 'تأكيد';

  @override
  String get world_custom_scene_title_required1 => 'يرجى إدخال عنوان للمشهد.';

  @override
  String get world_custom_scene_description_required1 =>
      'يرجى إدخال وصف للمشهد.';

  @override
  String get world_custom_scene_save_failed1 =>
      'تعذّر الحفظ. يُرجى المحاولة مجددًا لاحقًا.';

  @override
  String get world_custom_scene_edit_title1 => 'تعديل المشهد';

  @override
  String get world_custom_scene_add_title1 => 'إضافة مشهد';

  @override
  String get world_discovery_share_desc1 =>
      'ادخل عالمًا مفتوحًا من إبداع أحد المبدعين وابدأ قصتك الخاصة.';

  @override
  String world_discovery_share_text1(
      String title, String description, String link) {
    return 'Lianlian Shiguang · دعوة إلى العالم المفتوح\n\n«$title»\n\n$description\n\nاستكشف الآن: $link';
  }

  @override
  String get world_discovery_brand1 => 'Lianlian Shiguang';

  @override
  String get world_discovery_invite1 => 'دعوة إلى العالم المفتوح';

  @override
  String get world_discovery_scan1 => 'امسح للتنزيل';

  @override
  String get world_discovery_cancel1 => 'إلغاء';

  @override
  String get world_discovery_share_button1 => 'مشاركة بطاقة الدعوة';

  @override
  String get world_discovery_share_missing_card1 =>
      'لم يتم العثور على بطاقة الدعوة';

  @override
  String get world_discovery_share_image_failed1 => 'تعذر إنشاء صورة للمشاركة';

  @override
  String get world_discovery_share_failed1 =>
      'تعذرت مشاركة بطاقة الدعوة. حاول مرة أخرى.';

  @override
  String get world_discovery_story_open1 => 'بداية القصة';

  @override
  String get world_discovery_story_unset1 => 'لم تُحدد بداية القصة بعد';

  @override
  String get world_discovery_first_unset1 => 'لم تُحدد الجملة الأولى بعد';

  @override
  String get world_discovery_background_title1 => 'خلفية العالم ووصفه';

  @override
  String world_discovery_era1(String era) {
    return 'الإطار الزمني: $era';
  }

  @override
  String get world_discovery_background_unset1 => 'لم تُحدد خلفية العالم بعد';

  @override
  String get world_discovery_background_full1 => 'التفاصيل الكاملة للعالم';

  @override
  String get world_discovery_people_unset1 => 'لا توجد شخصيات بعد';

  @override
  String get world_discovery_people_intro1 => 'التعريف بالشخصيات';

  @override
  String get world_discovery_appearance_unset1 => 'لم يُذكر المظهر';

  @override
  String get world_discovery_creator_unset1 => 'لا تتوفر معلومات عن المبدع';

  @override
  String get world_discovery_creator1 => 'المبدع';

  @override
  String get world_discovery_creator_load_failed1 =>
      'تعذر تحميل معلومات المبدع';

  @override
  String world_discovery_world_load_failed1(String error) {
    return 'فشل تحميل العالم المفتوح: $error';
  }

  @override
  String get world_discovery_unpublished1 => 'هذا العالم غير منشور';

  @override
  String get world_discovery_open_world1 => 'العالم المفتوح';

  @override
  String get world_discovery_share_tooltip1 => 'مشاركة العالم المفتوح';

  @override
  String get world_discovery_world_background1 => 'خلفية العالم';

  @override
  String get world_edit_custom_status_title1 => 'تنسيق رد مخصص / شريط الحالة';

  @override
  String get world_edit_custom_status_hint1 =>
      'اختياري. يمكنك إعداد قالب لشريط الحالة أثناء التفاعل داخل العالم، مثل الوقت والموقع وحالة الشخصيات. هذا المحتوى ليس جزءًا من الوصف العام.';

  @override
  String get world_edit_custom_status_field1 => 'محتوى شريط الحالة المخصص';

  @override
  String get world_discovery_not_playable1 =>
      'هذا العالم المفتوح غير متاح للعب بعد.';

  @override
  String get world_discovery_enter1 => 'دخول العالم';

  @override
  String get world_edit_login_required1 => 'يرجى تسجيل الدخول أولاً';

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
  String get world_edit_save_draft_question1 => 'حفظ المسودة؟';

  @override
  String get world_edit_save_draft_explain1 =>
      'هل تريد حفظ هذا العالم قبل المغادرة؟ ستُفقد التغييرات غير المحفوظة.';

  @override
  String get world_edit_discard1 => 'عدم الحفظ';

  @override
  String get world_edit_cancel1 => 'إلغاء';

  @override
  String get world_edit_save_draft1 => 'حفظ المسودة';

  @override
  String get world_edit_world_name1 => 'اسم العالم المفتوح *';

  @override
  String get world_edit_world_images1 =>
      'World images (up to 6; first image is the cover)';

  @override
  String get world_edit_cover1 => 'الغلاف';

  @override
  String get world_edit_set_cover1 => 'تعيين كغلاف';

  @override
  String get world_edit_short_pitch1 =>
      'One-line card description (optional, up to 60 characters)';

  @override
  String get world_edit_public_summary1 => 'Public world description ';

  @override
  String get world_edit_creator_message_optional1 =>
      'رسالة من منشئ العالم (اختياري)';

  @override
  String get world_discovery_creator_message1 => 'رسالة من منشئ العالم';

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
  String get world_edit_main_characters1 => 'الشخصيات الرئيسية';

  @override
  String get world_edit_main_subtitle1 =>
      'Important characters who appear frequently in this world';

  @override
  String get world_edit_npc_subtitle1 =>
      'Other characters who may become interaction partners as the story unfolds';

  @override
  String world_edit_people_count1(int count) {
    return '$count شخصية';
  }

  @override
  String get world_edit_role_unset1 => 'Role / occupation not set';

  @override
  String get world_edit_remove_person1 => 'Remove character';

  @override
  String world_edit_add_person1(String type) {
    return 'إضافة $type';
  }

  @override
  String get world_edit_add_secret1 => 'إضافة فصل سري';

  @override
  String get world_edit_edit_secret1 => 'تعديل الفصل السري';

  @override
  String get world_edit_chapter_title1 => 'عنوان الفصل *';

  @override
  String get world_edit_unlock_condition1 =>
      'Unlock condition (description for server evaluation) *';

  @override
  String get world_edit_secret_content1 => 'المحتوى السري *';

  @override
  String get world_edit_confirm1 => 'تأكيد';

  @override
  String get world_edit_story_opening1 => 'بداية القصة *';

  @override
  String get world_edit_first_line1 => 'أول جملة في القصة *';

  @override
  String get world_edit_secret_chapters1 => 'الفصول السرية';

  @override
  String get world_edit_secret_explain1 =>
      'Secret chapters are stored privately. Publishing the world does not reveal them; players must meet story conditions to unlock them.';

  @override
  String get world_edit_add_secret_max1 => 'Add secret chapter (up to 12)';

  @override
  String get world_edit_publish_settings1 => 'إعدادات النشر';

  @override
  String get world_edit_private_world1 => 'عالم خاص';

  @override
  String get world_edit_private_world_desc1 =>
      'يمكنك وحدك اللعب والاختبار، ولا يمكن للاعبين الآخرين الدخول';

  @override
  String get world_edit_public_world1 => 'عالم عام';

  @override
  String get world_edit_public_world_desc1 =>
      'يمكن للاعبين الآخرين الدخول ولكل منهم تقدم مستقل في القصة';

  @override
  String get world_edit_create_world1 => 'إنشاء عالم مفتوح';

  @override
  String get world_edit_basic_tab1 => 'الإعدادات الأساسية';

  @override
  String get world_edit_characters_tab1 => 'شخصيات العالم';

  @override
  String get world_edit_story_tab1 => 'إعدادات القصة';

  @override
  String get world_edit_publish_world1 => 'نشر العالم المفتوح';

  @override
  String get world_edit_name_required1 => 'أدخل اسم الشخصية أولاً';

  @override
  String world_edit_edit_person1(String type) {
    return 'تعديل $type';
  }

  @override
  String get world_edit_upload_photo1 => 'تحميل صورة الشخصية (اختياري)';

  @override
  String get world_edit_allow_photo1 =>
      'Allow generating other images from this character\'s photo';

  @override
  String get world_edit_allow_photo_explain1 =>
      'Use this character\'s photo as a reference only when appropriate for the story. Chatting and ordinary gifts still work if disabled. Set separately for each character.';

  @override
  String get world_edit_name1 => 'الاسم *';

  @override
  String get world_edit_gender1 => 'الجنس / الهوية الجندرية';

  @override
  String get world_edit_birthday1 => 'تاريخ الميلاد (مثال: 16 مايو)';

  @override
  String get world_edit_age1 => 'العمر';

  @override
  String get world_edit_role1 => 'الدور / المهنة';

  @override
  String get world_edit_appearance1 => 'المظهر';

  @override
  String get world_edit_personality1 => 'الشخصية والسمات';

  @override
  String get world_edit_background1 => 'الماضي';

  @override
  String get world_edit_relationships1 => 'العلاقات مع الشخصيات الأخرى';

  @override
  String get world_edit_speech_style1 => 'أسلوب الكلام / النبرة';

  @override
  String get world_edit_dialogue_examples1 =>
      'أمثلة حوار (لمساعدة الذكاء الاصطناعي)';

  @override
  String get world_edit_save_person1 => 'حفظ إعدادات الشخصية';

  @override
  String get world_edit_tag_mystery1 => 'تشويق';

  @override
  String get world_edit_tag_horror1 => 'رعب';

  @override
  String get world_edit_tag_romance1 => 'رومانسية';

  @override
  String get world_edit_tag_modern_fantasy1 => 'فانتازيا حضرية';

  @override
  String get world_edit_tag_school1 => 'مدرسة';

  @override
  String get world_edit_tag_ensemble1 => 'شخصيات متعددة';

  @override
  String get world_edit_tag_adventure1 => 'مغامرة';

  @override
  String get world_edit_tag_daily1 => 'حياة يومية';

  @override
  String get world_edit_tag_detective1 => 'غموض';

  @override
  String get world_edit_tag_otherworld1 => 'عالم آخر';

  @override
  String get chooseNpc1 => 'اختر شخصية NPC';

  @override
  String get chooseInteractionTarget1 => 'اختر شخصية للتفاعل';

  @override
  String get unnamedCharacter1 => 'شخصية بلا اسم';

  @override
  String get chooseTargetFirst1 => 'اختر شخصية للتفاعل أولاً';

  @override
  String get confirmGift1 => 'تأكيد الهدية';

  @override
  String giftConfirmDetail1(String target, String gift, int cost) {
    return 'إرسال $gift إلى $target يكلف $cost زهور. لا تُخصم النقاط إلا بعد نجاح رد الذكاء الاصطناعي.';
  }

  @override
  String get cancel1 => 'إلغاء';

  @override
  String get send1 => 'إرسال';

  @override
  String get sendLocationTitle1 => 'إرسال موقع (3 زهور)';

  @override
  String get customLocation1 => 'موقع مخصص';

  @override
  String get confirm1 => 'تأكيد';

  @override
  String get cafe1 => 'مقهى';

  @override
  String get park1 => 'حديقة';

  @override
  String get restaurant1 => 'مطعم';

  @override
  String get street1 => 'شارع';

  @override
  String get giftHeart1 => 'قلب';

  @override
  String get giftFlower1 => 'زهرة';

  @override
  String get giftSun1 => 'شمس';

  @override
  String get giftConfetti1 => 'قصاصات ملونة';

  @override
  String get giftCoffee1 => 'قهوة';

  @override
  String get giftCake1 => 'كعكة';

  @override
  String get interactionPlayTitle1 => 'التفاعلات';

  @override
  String interactionTargetLabel1(String target) {
    return 'الشخصية: $target';
  }

  @override
  String get intimateInteraction1 => 'تفاعلات ودية';

  @override
  String get poke1 => 'نقرة لطيفة';

  @override
  String get hug1 => 'عناق';

  @override
  String get holdHands1 => 'إمساك اليدين';

  @override
  String get gifts1 => 'هدايا';

  @override
  String get funActivities1 => 'أنشطة ممتعة';

  @override
  String get sendLocation1 => 'إرسال موقع';

  @override
  String get diceDuel1 => 'تحدي النرد';

  @override
  String get world_profile_name_too_long1 =>
      'يجب ألا يتجاوز اسم الشخصية في العالم 40 حرفًا. اختصره قبل الحفظ.';

  @override
  String get world_profile_identity_too_long1 =>
      'تتجاوز بيانات الشخصية في العالم 2000 حرف. اختصرها قبل الحفظ.';

  @override
  String get world_relationship_live_title1 => 'علاقات الشخصيات';

  @override
  String get world_relationship_live_load_failed1 =>
      'تعذّر تحميل بيانات العلاقات. تحقّق من أذونات Firestore.';

  @override
  String get world_relationship_live_no_people1 =>
      'لم تُنشأ أي شخصيات في هذا العالم بعد.';

  @override
  String get world_relationship_live_not_met1 =>
      'العلاقة الحالية: لم يلتقيا بعد';

  @override
  String get world_relationship_live_first_meeting1 => 'اللقاء الأول';

  @override
  String world_relationship_live_current_relation1(String relation) {
    return 'العلاقة الحالية: $relation';
  }

  @override
  String get world_relationship_live_thought_title1 =>
      'أفكاره الحالية تجاه اللاعب';

  @override
  String get world_relationship_live_thought_pending1 =>
      'ستتكوّن انطباعاته تدريجيًا من خلال التفاعلات القادمة.';

  @override
  String world_scene_full_load_error1(String error) {
    return 'تعذر تحميل المشاهد: $error';
  }

  @override
  String get world_scene_full_delete_title1 => 'حذف المشهد';

  @override
  String world_scene_full_delete_confirm1(String title) {
    return 'هل تريد حذف «$title»؟';
  }

  @override
  String get world_scene_full_cancel1 => 'إلغاء';

  @override
  String get world_scene_full_delete1 => 'حذف';

  @override
  String world_scene_full_delete_error1(String error) {
    return 'تعذر حذف المشهد: $error';
  }

  @override
  String get world_scene_full_missing_fields1 =>
      'يرجى إدخال عنوان المشهد ووصفه أولاً.';

  @override
  String world_scene_full_activate_error1(String error) {
    return 'تعذر بدء المشهد: $error';
  }

  @override
  String get world_scene_full_end_title1 => 'إنهاء المشهد';

  @override
  String get world_scene_full_end_confirm1 => 'هل تريد إنهاء المشهد الحالي؟';

  @override
  String world_scene_full_end_error1(String error) {
    return 'تعذر إنهاء المشهد: $error';
  }

  @override
  String get world_scene_full_unnamed1 => 'مشهد بلا عنوان';

  @override
  String world_scene_full_opening1(String opening) {
    return 'البداية: $opening';
  }

  @override
  String get world_scene_full_edit1 => 'تعديل';

  @override
  String get world_scene_full_start1 => 'بدء المشهد';

  @override
  String get world_scene_full_creator_empty1 => 'لا توجد مشاهد للمنشئ بعد';

  @override
  String get world_scene_full_custom_empty1 => 'لم تنشئ أي مشاهد بعد';

  @override
  String get world_scene_full_add1 => 'مشهد جديد';

  @override
  String get world_scene_full_page_title1 => 'المشاهد';

  @override
  String get world_scene_full_creator_tab1 => 'مشاهد المنشئ';

  @override
  String get world_scene_full_custom_tab1 => 'مشاهدي';

  @override
  String world_scene_full_active1(String title) {
    return 'المشهد الجاري: $title';
  }

  @override
  String get world_scene_required1 => 'يرجى إدخال عنوان المشهد ووصفه';

  @override
  String get world_scene_title1 => 'المشاهد';

  @override
  String get world_scene_beta_notice1 =>
      'نسخة تجريبية من مشاهد العالم: تبدأ المشاهد باستخدام ذكاء محادثة العالم. الحفظ الخاص بالمشاهد وواجهة البدء الرسمية غير متاحين بعد.';

  @override
  String get world_scene_creator_scenes1 => 'مشاهد المبدع';

  @override
  String get world_scene_no_creator_scenes1 =>
      'لا تتوفر حاليًا مشاهد أنشأها المبدع لهذا العالم';

  @override
  String get world_scene_custom_scenes1 => 'إنشاء مشهد خاص';

  @override
  String get world_scene_name1 => 'عنوان المشهد';

  @override
  String get world_scene_setup1 =>
      'الخلفية والموقع والشخصيات والموقف الافتتاحي';

  @override
  String get world_scene_start1 => 'بدء المشهد';

  @override
  String get worldSearchTitle1 => 'البحث عن العوالم المفتوحة';

  @override
  String get worldSearchHint1 => 'ابحث عن عالم أو منشئ أو وسم';

  @override
  String get worldSearchClear1 => 'مسح البحث';

  @override
  String get worldSearchEmpty1 => 'لم يتم العثور على عوالم مفتوحة مطابقة';

  @override
  String get worldSearchTrending1 => 'عوالم شائعة';

  @override
  String get worldSearchResults1 => 'نتائج البحث';

  @override
  String get worldSearchUnnamed1 => 'عالم بلا اسم';

  @override
  String worldSearchCreator1(String creator) {
    return 'المنشئ: $creator';
  }

  @override
  String get world_secret_chapters_title1 => 'الفصول السرية';

  @override
  String get world_secret_chapters_close1 => 'إغلاق';

  @override
  String get world_secret_chapters_read_failed1 =>
      'تعذّرت قراءة الفصل السري حاليًا';

  @override
  String get world_secret_chapters_retry1 =>
      'فشل التحميل. اضغط لإعادة المحاولة';

  @override
  String get world_secret_chapters_empty1 => 'لم يضف المنشئ أي فصول سرية بعد';

  @override
  String world_secret_chapters_locked_chapter1(String number) {
    return 'الفصل $number · ؟؟؟';
  }

  @override
  String get world_secret_chapters_unlocked1 => 'تم فتحه · اضغط للقراءة';

  @override
  String get world_secret_chapters_locked1 => 'مغلق · واصل استكشاف القصة';

  @override
  String world_timeline_load_failed1(String error) {
    return 'تعذّر تحميل ملخص القصة: $error';
  }

  @override
  String get world_timeline_edit_summary1 => 'تعديل ملخص القصة';

  @override
  String get world_timeline_cancel1 => 'إلغاء';

  @override
  String get world_timeline_save1 => 'حفظ';

  @override
  String world_timeline_save_failed1(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get world_timeline_delete_summary1 => 'حذف الملخص';

  @override
  String get world_timeline_delete_confirm1 =>
      'هل تريد حذف هذا السجل من القصة؟';

  @override
  String get world_timeline_delete1 => 'حذف';

  @override
  String world_timeline_delete_failed1(String error) {
    return 'فشل الحذف: $error';
  }

  @override
  String get world_timeline_our_story1 => 'قصتنا';

  @override
  String get world_timeline_retry1 => 'إعادة المحاولة';

  @override
  String get world_timeline_empty1 =>
      'ما زالت القصة تتكشف. ستظهر سجلات جديدة مع تقدّم الأحداث.';

  @override
  String get world_timeline_recent1 => 'سجل حديث';

  @override
  String get world_timeline_edit1 => 'تعديل';

  @override
  String get echo_login_to_post1 => 'سجّل الدخول لترك صدى زمني';

  @override
  String get echo_limit1 =>
      'يمكن لكل لاعب ترك 3 أصداء كحد أقصى في العالم المفتوح نفسه';

  @override
  String get echo_count_fail1 =>
      'تعذّر التحقق من عدد الأصداء. حاول مجددًا لاحقًا.';

  @override
  String get echo_compose_title1 => 'اترك صدى زمنيًا';

  @override
  String get echo_compose_desc1 =>
      'اختر البطاقة التي تعجبك واكتب ما تريد تركه.';

  @override
  String get echo_compose_hint1 => 'ماذا تريد أن تقول في هذا العالم؟';

  @override
  String get echo_send1 => 'نشر الصدى';

  @override
  String get echo_player1 => 'لاعب';

  @override
  String get echo_sent1 => 'تم نشر الصدى الزمني';

  @override
  String get echo_post_fail1 => 'تعذّر النشر. تحقق من الأذونات والاتصال.';

  @override
  String get echo_login1 => 'يرجى تسجيل الدخول';

  @override
  String get echo_like_fail1 => 'تعذّر تسجيل الإعجاب';

  @override
  String get echo_delete_title1 => 'هل تريد حذف هذا الصدى؟';

  @override
  String get echo_delete_warning1 => 'لا يمكن التراجع عن الحذف.';

  @override
  String get echo_cancel1 => 'إلغاء';

  @override
  String get echo_delete1 => 'حذف';

  @override
  String get echo_deleted1 => 'تم حذف الصدى';

  @override
  String get echo_delete_fail1 => 'فشل الحذف';

  @override
  String get echo_reason_inappropriate1 => 'محتوى غير لائق';

  @override
  String get echo_reason_harassment1 => 'مضايقة أو إساءة';

  @override
  String get echo_reason_spam1 => 'رسائل مزعجة';

  @override
  String get echo_reason_other1 => 'أخرى';

  @override
  String get echo_report_title1 => 'الإبلاغ عن صدى زمني';

  @override
  String get echo_already_reported1 => 'لقد أبلغت عن هذا الصدى مسبقًا';

  @override
  String get echo_report_received1 => 'تم استلام البلاغ';

  @override
  String get echo_report_fail1 => 'فشل الإبلاغ';

  @override
  String get echo_options1 => 'خيارات الصدى';

  @override
  String get echo_delete_option1 => 'حذف الصدى';

  @override
  String get echo_report_option1 => 'الإبلاغ عن الصدى';

  @override
  String get echo_wall_title1 => 'أصداء الزمن';

  @override
  String get echo_add1 => 'اترك صدى';

  @override
  String get echo_load_fail1 =>
      'تعذّر تحميل الأصداء. تحقق من أذونات Firestore.';

  @override
  String get echo_empty1 => 'لا توجد أصداء بعد. اترك أول قصة.';

  @override
  String get store_pack_30_name1 => 'حزمة اللقاء الأول';

  @override
  String get store_pack_70_name1 => 'حزمة بداية الإعجاب';

  @override
  String get store_pack_120_name1 => 'حزمة خفقان القلب';

  @override
  String get store_pack_190_name1 => 'حزمة الحب العاطفي';

  @override
  String get store_pack_250_name1 => 'حزمة توأم الروح';

  @override
  String get store_pack_330_name1 => 'حزمة الإخلاص';

  @override
  String get store_pack_450_name1 => 'حزمة الثقة';

  @override
  String get store_pack_520_name1 => 'حزمة أحبك';

  @override
  String get store_pack_690_name1 => 'حزمة شهر العسل';

  @override
  String get store_pack_720_name1 => 'حزمة الوعد';

  @override
  String get store_pack_750_name1 => 'حزمة معًا';

  @override
  String get store_pack_830_name1 => 'حزمة الحب العميق';

  @override
  String get store_pack_990_name1 => 'حزمة الحب الدائم';

  @override
  String get store_pack_1050_name1 => 'حزمة الحبيب الوحيد';

  @override
  String get store_pack_1290_name1 => 'حزمة الحب الحقيقي';

  @override
  String get store_pack_1314_name1 => 'حزمة مدى الحياة';

  @override
  String get store_pack_1930_name1 => 'حزمة العهد';

  @override
  String get store_pack_2990_name1 => 'حزمة العشاق الأبديين';
}
