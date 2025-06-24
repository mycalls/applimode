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
import 'package:applimode_app/src/features/profile/presentation/change_email_screen/change_email_screen_controller.dart';

class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final result = await ref
          .read(changeEmailScreenControllerProvider.notifier)
          .changeEmail(
              newEmail: _emailController.text,
              password: _passwordController.text);
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
    ref.listen(changeEmailScreenControllerProvider, (_, next) {
      next.showAlertDialogOnError(context);
    });

    final isLoading = ref.watch(changeEmailScreenControllerProvider).isLoading;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: kIsWeb ? false : true,
          leading: kIsWeb ? const WebBackButton() : null,
          title: Text(context.loc.changeEmail),
        ),
        body: SafeArea(
          child: ResponsiveScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: context.loc.email,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w-]{2,6}$')
                              .hasMatch(value)) {
                        return context.loc.invalidEmail;
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: context.loc.password,
                      hintText: context.loc.enterPasswordForEmail,
                    ),
                    obscureText: true,
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
