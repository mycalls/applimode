// flutter
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// external
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

// core
import 'package:applimode_app/custom_settings.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyMedium;
    final linkStyle = textTheme?.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 32,
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(height: 1.5),
                children: [
                  TextSpan(
                    text: context.loc.argeeStart,
                    style: textTheme,
                  ),
                  TextSpan(
                    text: shortAppName,
                    style: textTheme,
                  ),
                  TextSpan(
                    text: ' ${context.loc.termsOfService} ',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (termsUrl.trim().isNotEmpty) {
                          launchUrl(
                            Uri.parse(termsUrl),
                          );
                        } else {
                          context.push(ScreenPaths.appTerms);
                        }
                      },
                  ),
                  TextSpan(
                    text: context.loc.argeeMiddle,
                    style: textTheme,
                  ),
                  TextSpan(
                    text: ' ${context.loc.privacyPolicy} ',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (privacyUrl.trim().isNotEmpty) {
                          launchUrl(
                            Uri.parse(privacyUrl),
                          );
                        } else {
                          context.push(ScreenPaths.appPrivacy);
                        }
                      },
                  ),
                  TextSpan(
                    text: context.loc.argeeEnd,
                    style: textTheme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecaptchaFooter extends StatelessWidget {
  const RecaptchaFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyMedium;
    final linkStyle = textTheme?.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 32,
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(height: 1.5),
                children: [
                  TextSpan(
                    text: 'This site is protected by reCAPTCHA and the Google ',
                    style: textTheme,
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                          Uri.parse('https://policies.google.com/privacy'),
                        );
                      },
                  ),
                  TextSpan(
                    text: ' and ',
                    style: textTheme,
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                          Uri.parse('https://policies.google.com/terms'),
                        );
                      },
                  ),
                  TextSpan(
                    text: ' apply.',
                    style: textTheme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
