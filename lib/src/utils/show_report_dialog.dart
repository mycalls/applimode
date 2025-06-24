// flutter
import 'package:flutter/material.dart';

// external
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';

class IssueReport extends Equatable {
  const IssueReport({
    required this.reportType,
    this.message,
  });

  final int reportType;
  final String? message;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        reportType,
        message,
      ];
}

Future<IssueReport?> showReportDialog({required BuildContext context}) async {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Center(child: Text(context.loc.reportIssue)),
      contentPadding: EdgeInsets.all(16),
      children: [ReportDialog()],
    ),
  );
}

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController _controller = TextEditingController();

  bool _isCancelled = false;

  @override
  void dispose() {
    _isCancelled = true;
    _controller.dispose();
    super.dispose();
  }

  void _safeSetState([VoidCallback? callback]) {
    if (_isCancelled) return;
    if (mounted) {
      safeBuildCall(() => setState(() {
            callback?.call();
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...ReportType.values
            .map(
              (type) => [
                ListTile(
                  onTap: () =>
                      context.pop(IssueReport(reportType: type.index + 1)),
                  title: Text(reportTypeToString(context, type.index + 1)),
                ),
                Divider(),
              ],
            )
            .expand((element) => element)
            .toList()
          ..removeLast(),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          maxLines: 2,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: context.loc.customReport,
          ),
          onChanged: (_) {
            _safeSetState();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                context.pop(null);
              },
              child: Text(context.loc.cancel),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: _controller.text.trim().length < 2
                  ? null
                  : () async {
                      context.pop(IssueReport(
                          reportType: 0, message: _controller.text));
                    },
              child: Text(context.loc.submitReport),
            ),
          ],
        ),
      ],
    );
  }
}

enum ReportType {
  illegal,
  obscene,
  spam,
  profanity,
  defamation,
  scam,
  suicide,
}

String reportTypeToString(BuildContext context, int type) {
  return switch (type) {
    1 => context.loc.illegalReport,
    2 => context.loc.obsceneReport,
    3 => context.loc.spamReport,
    4 => context.loc.profanityReport,
    5 => context.loc.defamationReport,
    6 => context.loc.scamReport,
    7 => context.loc.suicideReport,
    _ => context.loc.noContent,
  };
}
