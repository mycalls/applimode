import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
