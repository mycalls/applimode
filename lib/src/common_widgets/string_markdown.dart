// flutter
import 'package:flutter/material.dart';

// external
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

// routing
import 'package:applimode_app/src/routing/app_router.dart';

class StringMarkdown extends StatelessWidget {
  const StringMarkdown({
    super.key,
    required this.data,
    this.shrinkWrap = false,
  });

  final String data;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return MarkdownBody(
      data: data,
      selectable: true,
      fitContent: false,
      extensionSet: md.ExtensionSet.gitHubFlavored,
      onTapLink: (text, href, title) {
        if (href != null && href.isNotEmpty) {
          final uri = Uri.tryParse(href);
          if (uri != null) {
            launchUrl(uri);
          }
        } else if ((href == null || href.isEmpty) && text.startsWith('#')) {
          context.push(ScreenPaths.search, extra: text);
        }
      },
      styleSheet: MarkdownStyleSheet(
        h1: textTheme.headlineMedium
            ?.copyWith(fontWeight: FontWeight.w500), // 28
        h2: textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.w500), // 24
        h3: textTheme.titleLarge?.copyWith(
            fontSize: (textTheme.titleLarge?.fontSize ?? 22) - 2,
            fontWeight: FontWeight.w500), // 20pt
        h4: textTheme.titleMedium, // 16
        h5: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
        h6: textTheme.bodyLarge,
        p: textTheme.bodyLarge, // 16
        h1Padding: const EdgeInsets.only(
          top: 24,
          bottom: 24,
          left: 48,
          right: 48,
        ),
        h2Padding: const EdgeInsets.only(top: 24),
        h3Padding: const EdgeInsets.only(top: 24),
        h4Padding: const EdgeInsets.only(top: 24),
        h5Padding: const EdgeInsets.only(top: 12, bottom: 12),
        h6Padding:
            const EdgeInsets.only(top: 24, bottom: 24, left: 48, right: 48),
        pPadding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        blockquotePadding: const EdgeInsets.all(16),
        blockquoteDecoration: BoxDecoration(
          color: colorScheme.onInverseSurface,
          // borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              width: 4.0,
              color: colorScheme.outline,
            ),
          ),
        ),
        // codeblockPadding: const EdgeInsets.all(12),
        codeblockDecoration: const BoxDecoration(
          color: Color(0xFF2B2930),
          // borderRadius: BorderRadius.circular(4),
        ),
        horizontalRuleDecoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 12.0,
              color: Colors.transparent,
            ),
            bottom: BorderSide(
              width: 12.0,
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      builders: {
        'h1': CenterHeaderBuilder(),
        'h2': BottomLineBuilder(),
        'h6': CenterHeaderBuilder(),
        'pre': CodeMarkdownElementBuilder(),
        // 'tr': CenterHeaderBuilder(),
      },
      softLineBreak: true,
    );
  }
}

/*
class CenterHeaderRowBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(text.text, style: preferredStyle),
      ],
    );
  }
}
*/

class CenterHeaderBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Center(
        child: Text(
      text.text,
      textAlign: TextAlign.center,
      style: preferredStyle,
    ));
  }
}

class BottomLineBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.text,
          // textAlign: TextAlign.center,
          style: preferredStyle,
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}

/*
class MiddlePaddingBuilder extends MarkdownPaddingBuilder {
  @override
  EdgeInsets getPadding() => const EdgeInsets.only(bottom: 24);
}
*/

class CodeMarkdownElementBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    // final preFontSize = preferredStyle?.fontSize;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectableText(
        text.text,
        style: const TextStyle(
          color: Color(0xFFD4D4D4),
          // fontFamily: 'monospace',
          // fontSize: (preFontSize != null ? preFontSize - 2 : 14) * 0.85,
        ),
      ),
    );
  }
}
