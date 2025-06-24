// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/buttons/web_back_button.dart';
import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';

// features
import 'package:applimode_app/src/features/profile/presentation/change_password_screen/change_password_screen_controller.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final result = await ref
          .read(changePasswordScreenControllerProvider.notifier)
          .changePassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );
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
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(changePasswordScreenControllerProvider, (_, next) {
      next.showAlertDialogOnError(context);
    });

    final isLoading =
        ref.watch(changePasswordScreenControllerProvider).isLoading;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: kIsWeb ? false : true,
          leading: kIsWeb ? const WebBackButton() : null,
          title: Text(context.loc.changePassword),
        ),
        body: SafeArea(
          child: ResponsiveScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextField(
                    controller: _currentPasswordController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: context.loc.currentPassword,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: context.loc.newPassword,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return context.loc.shortPassword;
                      }
                      return null;
                    },
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordConfirmController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: context.loc.confirmPassword,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != _newPasswordController.text) {
                        return context.loc.passwordsNotMatch;
                      }
                      return null;
                    },
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
        ));
  }
}
