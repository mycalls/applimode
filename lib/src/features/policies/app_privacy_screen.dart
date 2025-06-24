// lib/src/features/policies/app_privacy_screen.dart

// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// core
import 'package:applimode_app/src/core/constants/app_privacy.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/buttons/web_back_button.dart';

class AppPrivacyScreen extends StatelessWidget {
  const AppPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.privacyPolicy),
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
      ),
      body: Markdown(
        data: appPrivacy,
        selectable: true,
        onTapLink: (text, href, title) {
          if (href != null && href.isNotEmpty) {
            final uri = Uri.tryParse(href);
            if (uri != null) {
              launchUrl(uri);
            }
          }
        },
      ),
    );
  }
}
