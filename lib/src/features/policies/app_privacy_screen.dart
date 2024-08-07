import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/constants/app_privacy.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

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
