import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/constants/app_terms.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppTermsScreen extends StatelessWidget {
  const AppTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.termsOfService),
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
      ),
      body: Markdown(
        data: appTerms,
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
