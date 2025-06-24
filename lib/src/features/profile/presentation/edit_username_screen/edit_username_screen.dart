// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/buttons/web_back_button.dart';
import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';

// features
import 'package:applimode_app/src/features/profile/presentation/edit_username_screen/edit_username_screen_controller.dart';

class EditUsernameScreen extends ConsumerStatefulWidget {
  const EditUsernameScreen({
    super.key,
    required this.username,
  });

  final String username;

  @override
  ConsumerState<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends ConsumerState<EditUsernameScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.username;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty) {
      showAdaptiveAlertDialog(
        context: context,
        title: context.loc.ooops,
        content: context.loc.emptyContent,
      );
      return;
    }
    final result = await ref
        .read(editUsernameScreenControllerProvider.notifier)
        .submit(_controller.text);
    if (mounted && result) {
      if (kIsWeb) {
        WebBackStub().back();
      } else {
        if (context.canPop()) {
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(editUsernameScreenControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    final isLoading = ref.watch(editUsernameScreenControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
        title: Text(context.loc.editUsername),
      ),
      body: SafeArea(
        child: ResponsiveScrollView(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: context.loc.username,
                ),
              ),
              const SizedBox(height: 32),
              isLoading
                  ? const SizedCircularProgressIndicator()
                  : FilledButton(
                      style: const ButtonStyle(
                        shape: WidgetStatePropertyAll(CircleBorder()),
                      ),
                      onPressed: _submit,
                      child: const Icon(Icons.done),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
