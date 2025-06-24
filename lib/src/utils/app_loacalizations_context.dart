// flutter
import 'package:flutter/widgets.dart';

// core
import 'package:applimode_app/l10n/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
