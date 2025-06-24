// flutter
import 'package:flutter/material.dart';

// external
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

Future<bool> showPasswordDialog(BuildContext context) async {
  return showReauthenticateDialog(
    context: context,
    providers: [
      if (fbAuthProviders.isEmpty ||
          fbAuthProviders.contains(FBAuthProvider.email.name))
        EmailAuthProvider(),
      if (fbAuthProviders.contains(FBAuthProvider.phone.name))
        PhoneAuthProvider(),
    ],
    onSignedIn: () => context.pop(true),
    // onPhoneVerfifed: () => context.pop(true),
    actionButtonLabelOverride: context.loc.deleteAccount,
  );
}
