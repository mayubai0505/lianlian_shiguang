import 'generated/app_localizations.dart';
import '../services/locale_notifier.dart';

/// Localization access for code paths that do not have a BuildContext.
///
/// This follows the language selected in [LocaleNotifier].
AppLocalizations get appL10n =>
    lookupAppLocalizations(LocaleNotifier.currentLocale);
