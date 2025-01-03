import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditorField extends StatelessWidget {
  const EditorField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // https://github.com/flutter/flutter/issues/124483
        // cursor goes to wrong place after tap on text on web textfield
        // fix if it is improved
        child: kIsWeb
            ? NotificationListener(
                onNotification: (ScrollNotification notification) {
                  if (notification is UserScrollNotification) {
                    // when user scrolls the screen
                    focusNode.unfocus(); // dismiss keyboard
                  }
                  return true;
                },
                child: _buildTextField(),
              )
            : _buildTextField(),
      ),
    );
  }

  TextField _buildTextField() {
    // Error where autofocus does not work on iOS web
    // fix if it is improved
    // ios web 에서 autofocus가 작동하지 않는 오류
    // 개선될 경우 수정 바람
    final isIosWeb = kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: isIosWeb ? false : true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      onChanged: onChanged,
      autocorrect: false,
      enableSuggestions: false,
      expands: true,
    );
  }
}
