// flutter
import 'package:flutter/material.dart';

// external
import 'package:go_router/go_router.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

class FilledHomeButton extends StatelessWidget {
  const FilledHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      // onPressed: () => context.go('/'),
      // 이전의 네비게이션 히스토리 삭제
      onPressed: () => Router.neglect(context, () => context.go('/')),
      child: Text(context.loc.goHome),
    );
  }
}
