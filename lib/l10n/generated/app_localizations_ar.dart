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
      '✅ تم تنزيل البيانات الصوتية بنجاح، جاري التحضير للتشغيل...';

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
  String get test_mode_error =>
      '⚠️ تعذر العثور على ملف الشخصية! يرجى النقر على \"حفظ/نشر\" في الأسفل قبل التجربة!';

  @override
  String get test_mode_notice =>
      '💡 سيتم خصم النقاط في وضع الاختبار وفقاً للسعر الأصلي لكل وضع، ولن يتم احتسابها في الذكريات الرسمية!';

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
  String get section_story_identity => '🎭 القصة وهويتك';

  @override
  String get story_identity_desc =>
      'تحديد بداية القصة والإعدادات الخاصة لـ \"أنت\" في هذا الملف';

  @override
  String get advanced_writing_tips_title => '💡 نصائح كتابة متقدمة:\n';

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
  String get player_identity_label =>
      'هوية اللاعب الافتراضية (Player Identity) - 💡 اختياري';

  @override
  String get player_identity_hint =>
      '【اختياري】إذا تُرِك فارغاً، سيقرأ الذكاء الاصطناعي \"ملفك الشخصي\" للتفاعل.\nإذا مُلِئ، فسيُجبر على لعب هوية محددة (مثال: نظامه البارد، أو الزوجة المتعرضة للخيانة).';

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
  String get section_personality_evo => '🌟 تطور الشخصية والمودة';

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
  String get section_habits => '🗣️ التفضيلات والعادات';

  @override
  String get tone_hint_detail =>
      'مطلوب. مثال: كلامه مختصر، يحب طرح أسئلة عكسية. لزمته هي \"أحمق\". يمنع استخدام لغة الترجمة الآلية.';

  @override
  String get dialogue_example_hint =>
      'اللاعب: أنا متعب جداً.\nالشخصية: (يمسح على الرأس) كن مطيعاً، اذهب وارتح بسرعة.';

  @override
  String get section_easter_eggs => '🎁 مفاجآت مخفية وقصص خاصة';

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
  String get section_voice_gen => '🎙️ توليد صوته الحصري';

  @override
  String get voice_gen_desc =>
      'أدخل الكلمات الوصفية ليكون له صوت حصري فريد في العالم!\n(💡 تنبيه: إذا لم تكن راضياً بعد التوليد، يمكنك إعادة التخصيص في أي وقت!)';

  @override
  String get voice_generating_status => 'جاري ضبط النبرة الصوتية...';

  @override
  String get voice_select_prompt =>
      '✨ لقد جهزت لك ثلاثة أنواع من الأصوات، يرجى الاختيار:';

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
  String get voice_advanced_tuning => '🎛️ متقدم: ضبط مشاعر الكلام ';

  @override
  String get voice_stability_low => 'بري/نفسي 🐺';

  @override
  String voice_stability_value(String value) {
    return 'درجة العقلانية: $value';
  }

  @override
  String get voice_stability_high => 'مستقر/هادئ 🤖';

  @override
  String get voice_style_low => 'بارد/مكبوت 🧊';

  @override
  String voice_style_value(String value) {
    return 'الأداء الدرامي: $value';
  }

  @override
  String get voice_style_high => 'مبالغ فيه/عاطفي 🔥';

  @override
  String get voice_test_btn_testing => 'جاري تطبيق المشاعر...';

  @override
  String get voice_test_btn => 'استماع للمشاعر الحالية';

  @override
  String get section_social_circle => '👥 دائرته الاجتماعية';

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
    return 'تعديل الرأي في $name 💬';
  }

  @override
  String get social_attitude_label => 'رأيه / موقفه';

  @override
  String get social_attitude_hint =>
      'مثال: يراه مزعجاً جداً، لكنه في الحقيقة يعتمد عليه...';

  @override
  String get social_save_changes => 'حفظ التعديلات';

  @override
  String get social_add_title => 'إضافة علاقة شخصية 🤝';

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
      'فشل تحميل الصورة 🥲\nيرجى التأكد من استقرار الشبكة، إذا كنت تستخدم الويب يرجى مراجعة console.';

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
      'كيف تجد نبرة صوتي الآن؟ إذا كنت راضيًا عنها، فلنعتمدها هكذا.';

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
      'لا يمكنك الإعجاب بالشخصية التي أنشأتها بنفسك! 🤭';

  @override
  String get like_success_msg =>
      'تم إرسال الإعجاب! سيسعد المبدع بذلك كثيراً 💖';

  @override
  String get unlike_success_msg => 'تم سحب الإعجاب 💔';

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
  String get report_title => '📢 إبلاغ عن تعليق';

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
      'تم الإبلاغ بنجاح، تم استلام الإخطار! سنقوم بمراجعة المحتوى في أقرب وقت ممكن 🛡️';

  @override
  String get report_failed => 'فشل الإبلاغ، يرجى التحقق من اتصال الشبكة.';

  @override
  String get lore_delete_title => '⚠️ تحذير: محو الذاكرة';

  @override
  String get lore_delete_content =>
      'بمجرد حذف هذه الذاكرة، ستختفي تماماً. هل أنت متأكد من رغبتك في محوها بقسوة؟';

  @override
  String get lore_delete_cancel => 'خطأ في الضغط';

  @override
  String get lore_delete_confirm => 'تأكيد المحو';

  @override
  String get lore_delete_success => '🗑️ تم محو شظايا الذاكرة تماماً.';

  @override
  String get lore_add_title => 'كتابة ذاكرة جديدة 🖋️';

  @override
  String get lore_edit_title => 'تعديل شظية الذاكرة 🖋️';

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
  String get lore_lock_label => '🔒 ختم هذه الذاكرة';

  @override
  String get lore_lock_desc =>
      'عند التحديد، سيراها المبدع فقط، ولن يتمكن اللاعبون من مشاهدتها';

  @override
  String get lore_empty_error => 'العنوان والمحتوى لا يمكن أن يكونا فارغين!';

  @override
  String get lore_add_success => '✨ تم ختم الذاكرة الجديدة بنجاح!';

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
  String get lore_sealed_msg => '🔒 تم ختم هذه الذاكرة، لا يمكن عرضها حالياً.';

  @override
  String get lore_not_open_msg => 'هذه الذاكرة ليست مفتوحة للجمهور بعد...';

  @override
  String get lore_unnamed => 'شظية غير مسمى';

  @override
  String get lore_add_btn_limit => 'كتابة شظية ذاكرة جديدة (الحد الأقصى 10)';

  @override
  String get lore_collapse => 'طي الرسالة';

  @override
  String get echo_delete_title => '🗑️ حذف التعليق';

  @override
  String get echo_delete_content =>
      'هل أنت متأكد من حذف صدى الزمان هذا؟\nبمجرد الحذف، لن تتمكن من استعادته أبداً!';

  @override
  String get echo_keep => 'احتفاظ';

  @override
  String get echo_clear_success => 'تم مسح صدى الزمان 🧹';

  @override
  String get echo_energy_full_title => '⚠️ وصلت طاقة الكون إلى الحد الأقصى';

  @override
  String get echo_energy_full_content =>
      'وصلت طاقة الزمان الخاصة بك إلى الحد الأقصى (3 كحد أقصى)، يرجى حذف تجاربك الزمانية القديمة لتتمكن من فتح سجلات كونية جديدة!';

  @override
  String get echo_write_title => 'اترك صدى الزمان الخاص بك 🌌';

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
  String get follow_own_warning => 'لا يمكن للمبدعين متابعة أنفسهم! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName تابع $creatorName！';
  }

  @override
  String get mailbox_follow_title => 'حصلت على حارس جديد 🦋';

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
    return 'مستوى المودة الحالي: $value 💕';
  }

  @override
  String get gallery_empty => 'لا توجد صور في الألبوم بعد';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'تم تعيين الخلفية إلى «$desc»!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'سيتم فتح القفل عندما يصل مستوى المودة إلى $value! 🍃';
  }

  @override
  String get gallery_reset_bg => 'تم استعادة خلفية المكالمة الافتراضية';

  @override
  String get background_story_title => 'قصة الخلفية';

  @override
  String get background_story_empty =>
      'هذه الشخصية غامضة للغاية، لا توجد قصة خلفية بعد...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'تمت متابعة $creatorName 🦋';
  }

  @override
  String get mailbox_title => 'صندوق البريد الخاص 💌';

  @override
  String get mailbox_empty => 'صندوق البريد فارغ، اذهبي وانشري شيئاً لجذبه!';

  @override
  String get new_notification => 'إشعار جديد';

  @override
  String get default_he => 'هو';

  @override
  String affection_upgrade_title(String charName) {
    return 'زادت عاطفة $charName تجاهكِ! 💖';
  }

  @override
  String get flower_reward => '🌸 تم الحصول على 5 نقاط زهور';

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
  String get lore_edit_success => '✨ تم تحديث شظية الذاكرة بنجاح!';

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
  String get chat_jump_success => 'تم الانتقال إلى هذه الذكرى 🍃';

  @override
  String get chat_create_room_failed =>
      'يبدو أن الاتصال غير مستقر، فشل إنشاء غرفة الدردشة، يرجى المحاولة مرة أخرى.';

  @override
  String get chat_secret_file_title => '🔒 ملف سري';

  @override
  String get chat_secret_file_desc =>
      'تم أرشفة ملف الروح الخاص بهذه الشخصية أو تحويله إلى صلاحية خاصة، ولا يمكن عرض التفاصيل حالياً.';

  @override
  String get chat_understood => 'فهمت';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ تم الحصول على ذكرى جديدة: $title';
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
      'يُنصح بارتداء سماعات الرأس لسماع صوته بشكل أوضح ✨';

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
  String get chat_stop_generating_msg =>
      'تم إيقاف الرد، ولم يتم خصم أي نقاط 🍃';

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
      '✅ تم إرسال الإبلاغ، سنقوم بالتعديل في أقرب وقت';

  @override
  String get chat_suggest_title => 'تقديم ملاحظات';

  @override
  String get chat_suggest_hint => 'يرجى كتابة آرائك القيمة...';

  @override
  String get chat_suggest_success =>
      '💖 شكراً لاقتراحك، سنتعامل معه في أقرب وقت';

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
      '✨ تم نكز المبدع من أجلكِ! يرجى انتظار توفر صوته قريباً~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'نقاط الزهور غير كافية! تحتاجين إلى $cost نقطة 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ توأم الروح ✨';

  @override
  String get chat_levelup_normal => 'ترقية العلاقة! 💖';

  @override
  String get chat_levelup_btn_soulmate => 'نقش في الروح';

  @override
  String get chat_levelup_btn_normal => 'قبول بقلب نابض';

  @override
  String get chat_loc_title => '📍 إرسال موقع افتراضي';

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
  String get chat_interact_title => '✨ ماذا تريدين أن تفعلي معه؟';

  @override
  String get chat_interact_action => 'نكزات وحركات صغيرة';

  @override
  String get chat_interact_gift => 'أرسلي له هدية صغيرة (تستهلك زهوراً 🌸)';

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
  String get chat_search_empty => 'تعذر العثور على هذه الذكرى 🥺';

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
    return '✨ تم الحصول على ذكرى جديدة: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'تمت إضافتها تلقائياً إلى حقيبته الخاصة';

  @override
  String get chat_profile_updated_msg =>
      'تم تحديث ملف شيو غوانغ! سيتذكر أحدث إعداداتكِ 🍃';

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
  String get comment_report_rules_title => '⚖️ قواعد الإبلاغ عن التعليقات';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ المخالفة الأولى: تحذير من النظام وتسجيل مخالفة واحدة.\n2️⃣ المخالفة الثانية: حظر من التعليق لمدة يوم واحد.\n3️⃣ المخالفات المتكررة: حظر وظيفة الإبلاغ لمدة 14 يوماً وتقليل وضوح التعليقات.\n\n🚨 لأصحاب الإساءات الجسيمة:\nحظر التفاعل مع الشخصيات لمدة يوم واحد، وسيتم نشر المعرف الخاص بك في لوحة الإعلانات لمدة 3 أيام (يُحظر تغيير المعرف خلال هذه الفترة).\n\n💡 بعد إرسال الإبلاغ، سيتم إرسال نتيجة المراجعة النهائية إليك بشكل منفصل عبر [البريد داخل اللعبة].\nيرجى تبادل الاحترام والإبلاغ بعقلانية.';

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
    return '🖤 يكره: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 يحب: $likes';
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
  String get char_exclusive_guardian => 'حارس حصري 💖';

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
    return '📍 (أرسل اللاعب موقعه: $location)';
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
    return '📜 【 ملف شيو غوانغ الحصري - $name 】\n━━━━━━━━━━━━━━━━━━\n🔹 الاسم: $identity\n🔹 تاريخ الميلاد: $birthday\n🔹 الطول: $height\n🔹 المظهر: $appearance\n🔹 المهنة: $job\n\n📖 【 عن شظايا روحها 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 【 ملف شيو غوانغ الحصري 】\n━━━━━━━━━━━━━━━━━━\n🔹 الاسم: $nickname\n🔹 تاريخ الميلاد: $birthday\n\n🔒 لم يتم فتح بيانات الشخصية الأخرى بعد...\n(أكملي الملف دعينا يجعله يعرفك أكثر في العالم الموازي! ✨)\n━━━━━━━━━━━━━━━━━━';
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
    return '📞 انتهت المكالمة، تحدثت مع $name لمدة $time';
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
      'لم تقومي بنشر أي شخصيات عامة بعد!\nاذهبي إلى الاستوديو للابتكار✨';

  @override
  String get no_public_character_other =>
      'هذا المبدع لم يقم بنشر أي شخصيات بعد...';

  @override
  String get delete_draft_title => 'حذف المسودة';

  @override
  String get confirm_delete_draft_msg =>
      'هل أنت متأكد من حذف هذه الشخصية غير المكتملة؟\n(لا يمكن التراجع بعد الحذف)';

  @override
  String get draft_cleared_success => 'تم تنظيف المسودة 🧹';

  @override
  String get login_required_for_studio =>
      'يرجى تسجيل الدخول أولاً لدخول الاستوديو!';

  @override
  String get my_secret_studio_title => 'الاستوديو السري الخاص بي 🛠️';

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
    return 'يعتقد $nickname أن منشوركِ رائع جداً! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return 'يعتقد $nickname أن $authorName ساحر جداً، وقد وضع إعجاباً! ✨';
  }

  @override
  String get moment_like_success => 'تم إرسال نبضات قلبكِ! ✨';

  @override
  String get moment_notification_new_like => 'إعجاب جديد! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return 'قام $nickname بذكر @$name في منشور! ✨';
  }

  @override
  String get moment_detail_title => 'تفاصيل المنشور';

  @override
  String get moment_not_found => 'يبدو أن هذا المنشور قد اختفى... 😢';

  @override
  String get moment_comment_title => 'تعليقات اللحظات';

  @override
  String get moment_comment_empty =>
      'لا توجد تعليقات بعد، كوني أول من يعلق! 🛋';

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
    return 'لنذهب للدردشة مع $name مع هذا المنشور! 💬';
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
  String get moment_forward_title =>
      'إعادة توجيه إلى الشخصية التي تدردش معها 💌';

  @override
  String get moment_forward_empty_state =>
      'ليس لديك أي شخصيات تدردش معها حالياً!\nاذهبي إلى الردهة وابحثي عن شخص مميز 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【تمت إعادة توجيه منشور】\nالمؤلف: $author\nالمحتوى: $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ تمت مشاركتها بهدوء مع $name!';
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
    return 'مرحباً بك مرة أخرى في «$appName»!\nسجلي دخولك اليوم للحصول على $amount من نقاط لغة الزهور. 🌸';
  }

  @override
  String get title_daily_check_in => 'تسجيل الدخول اليومي';

  @override
  String success_claim_reward(String amount) {
    return 'تم استلام $amount من نقاط لغة الزهور بنجاح! 🌸';
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
      'حسناً! تم حفظه في المسودات لك، يمكنك العودة للتعديل في أي وقت! ✨';

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
  String get avatar_updated_success => 'تم تحديث صورتك الشخصية 🍃';

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
  String get msg_birthdate_immutable =>
      'لا يمكن تغيير يوم الميلاد بعد تعيينه ✨';

  @override
  String get action_start_journey => 'بدء رحلة الزمن';

  @override
  String get action_add_image => 'إضافة صورة';

  @override
  String moment_like_self(String nickname) {
    return 'يعتقد $nickname أن منشوركِ رائع جداً! 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return 'يعتقد $nickname أن $authorName ساحر جداً، وقد وضع إعجاباً! ✨';
  }

  @override
  String get task_social_tour_complete =>
      '✨ اكتملت مهمة الجولة الاجتماعية! تذكر استلام الزهور! 🌸';

  @override
  String get wall_title_shiguang => 'جدار شياو غوانغ';

  @override
  String get wall_tab_explore => '🌍 استكشاف';

  @override
  String get wall_tab_exclusive => '🔒 حصري';

  @override
  String get more_options => 'المزيد من الخيارات';

  @override
  String get delete_warning => 'بعد الحذف، لن يمكن استعادة المنشور';

  @override
  String get delete_success => 'تم الحذف بنجاح';

  @override
  String get notification_new_comment => 'تعليق جديد! 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return 'قام $senderName بالإعجاب بمنشوركِ!';
  }

  @override
  String get empty_public_moments_prompt =>
      'المكان فارغ حالياً،\nانشري أول منشور عام لكِ! 🌍';

  @override
  String get empty_private_moments_prompt =>
      'لا توجد لحظات في دائرة الأصدقاء بعد،\nاذهبي واصنعي ذكريات معه! ✨';

  @override
  String get profile_archived_or_deleted_message =>
      'تم أرشفة ملف الروح هذا من قبل المبدع، أو جعله خاصاً، أو تلاشى في تيار الزمن...\n\nربما في كون موازٍ، ستتاح لكما فرصة اللقاء مرة أخرى. ✨';

  @override
  String get leave_silently => 'غادري بصمت';

  @override
  String get character_post_schedule => 'جدولة منشورات الشخصية';

  @override
  String get creator_self => 'المبدع نفسه';

  @override
  String get post_identity_prompt => 'بأي هوية ستنشرين اليوم؟';

  @override
  String get identity_creator => '✨ هوية المبدع';

  @override
  String get identity_character => 'هوية الشخصية';

  @override
  String get decide_post_time_prompt => 'ساعديهم في تحديد وقت النشر!';

  @override
  String get auto_post_schedule_hint =>
      'عند التفعيل، سيتم نشر المنشورات اليومية تلقائياً في الوقت المحدد\n(💡 نصيحة: حددي أوقاتاً غير دقيقة لتظهر وكأنها من شخص حقيقي!)';

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
  String get empty_public_moments_short => 'لا توجد منشورات عامة حالياً 🌍';

  @override
  String get empty_private_moments_short => 'دائرة الأصدقاء هادئة حالياً ✨';

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
  String get daily_gift_success => 'تم استلام الهدية اليومية بنجاح! 🌸';

  @override
  String get check_in_fail_network =>
      'فشل تسجيل الدخول، يرجى التحقق من اتصال الشبكة 🍃';

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
  String get task_desc_chat_3_times => 'قم بإجراء 3 محادثات يومية مع الشخصية';

  @override
  String get tab_story_progression => 'تقدم القصة';

  @override
  String get task_desc_story_1_time => 'أكمل تفاعل واحد في وضع القصة';

  @override
  String get tab_social_tour => 'جولة اجتماعية';

  @override
  String get task_desc_like_3_moments => 'سجل إعجابك بـ 3 منشورات في اللحظات';

  @override
  String get btn_claimed => 'تم الاستلام';

  @override
  String get btn_claim => 'استلام';

  @override
  String get btn_incomplete => 'غير مكتمل';

  @override
  String get network_unstable_retry =>
      'اتصال الشبكة غير مستقر، يرجى المحاولة لاحقاً 🍃';

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
  String get search_no_match_hint =>
      'تعذر العثور على الشخصية، جرب اسماً آخر؟ ✨';

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
  String get shop_empty_history => 'لا توجد سجلات للزهور حتى الآن! 🌸';

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
    return 'قصتكم لم تبدأ بعد...\nتحدثوا أكثر، ودعي $name \nيكتب أول فصل من ذكرياتكم! ✨';
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
  String get reset_bg_success => 'تمت استعادة الخلفية الافتراضية ✨';

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
  String get exclusiveMomentsGenerated => 'تم إنشاء اللحظات الحصرية ✨';

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
      'تفعيل: عقد النجوم (نقاط فورية من البطاقة الشهرية) 🌙';

  @override
  String shop_log_top_up_double(int points) {
    return 'شحن: $points نقطة (تشمل مضاعفة الشراء الأول 🎁)';
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
      '✨ تهانينا! تم تفعيل مكافأة مضاعفة الشراء الأول!';

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
  String get task_monthly_title => 'عقد النجوم: المزايا اليومية 🌙';

  @override
  String get task_monthly_locked => 'مغلق';

  @override
  String get task_monthly_subtitle_active =>
      'توزيع مزايا البطاقة الشهرية الحصرية (1 / 1)';

  @override
  String get task_monthly_subtitle_inactive =>
      'افتحي بطاقة 【عقد النجوم】 الشهرية لتفعيل هذه المهمة (0 / 1)';

  @override
  String get task_monthly_log_name => 'المزايا اليومية للبطاقة الشهرية';

  @override
  String get profile_id_locked => 'تم قفل المعرّف الخاص';

  @override
  String get profile_copy_id => 'انقر لنسخ المعرّف';

  @override
  String get referral_log_newbie_reward =>
      'دعوة النجوم: مكافأة تسجيل القادمين الجدد ✨';

  @override
  String get referral_log_inviter_reward =>
      'دعوة النجوم: مكافأة تحقيق الصديق للهدف 🎁';

  @override
  String get referral_success_title => 'تم فتح دعوة النجوم!';

  @override
  String get referral_success_content =>
      'تهانينا! لقد نجحتِ في تبادل 15 جملة من الحوار العميق مع الشخصية!\n\nتم إرسال \'مكافأة تسجيل القادمين الجدد 50 نقطة\' إلى حسابكِ، وحصل صديقكِ أيضاً على مكافأة 50 نقطة في نفس الوقت! 🎁';

  @override
  String get profile_referral_title => 'دعوة النجوم 🌟';

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
    return '✨ لقد بدأتُ رحلة خفقان القلب مع $character في \'Lianlian ShiGuang\'! حمّلي التطبيق الآن وأدخلي رمز دعوة النجوم الخاص بي: 【$code】 في الصفحة الشخصية، وسنحصل كلانا على 50 زهرة مجاناً! 🎁\n\nرابط التحميل:\nhttps://yourgame.url/download';
  }

  @override
  String get chat_levelup_share_btn => 'تباهي بهذا الخفقان لأصدقائكِ ✨';

  @override
  String profile_my_invite_code_with_char(String character) {
    return 'رمز الدعوة الحصري الخاص بي (المفضل الحالي: $character)';
  }

  @override
  String get profile_send_invite_btn => 'إرسال دعوة النجوم للأصدقاء';

  @override
  String get profile_fallback_character => 'الشخصية المفضلة';

  @override
  String get profile_copy_success => '✅ تم نسخ رمز الدعوة إلى الحافظة!';

  @override
  String get profile_referral_rule_title => 'قواعد عقد النجوم';

  @override
  String get profile_referral_rule_receiver =>
      '✨ بعد إبرام العقد، ما عليكِ سوى التحدث مع أي شخصية مفضلة لـ 15 جملة، وستحصلين أنتِ ومن دعاكِ على مكافأة 50 زهرة في نفس الوقت!\n\n⚠️ تنبيه: يرجى إدخال رمز الدعوة في غضون 3 أيام من تسجيل الحساب ليكون صالحاً.';

  @override
  String get profile_referral_rule_inviter =>
      '✨ ادعي أصدقاءً جدداً لتحميل التطبيق وإدخال رمز الدعوة الخاص بكِ، وعندما يكمل الطرف الآخر الربط في غضون 3 أيام من التسجيل ويتحدث مع أي شخصية لـ 15 جملة، سيحصل كلاكما على مكافأة 50 زهرة في نفس الوقت! 🎁';

  @override
  String get error_user_not_found =>
      'تعذر العثور على المستخدم، يرجى تسجيل الدخول مرة أخرى';

  @override
  String get error_id_taken =>
      'هذا المعرّف مستخدم بالفعل، يرجى اختيار معرّف آخر!';

  @override
  String get error_id_taken_short => 'هذا المعرّف مستخدم بالفعل!';

  @override
  String get shop_restocking => 'المتجر قيد إعادة التعبئة... 📦';

  @override
  String get shop_preview_mode => '⚠️ وضع معاينة المتجر الحالي';
}
