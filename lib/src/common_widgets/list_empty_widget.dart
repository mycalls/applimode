// flutter
import 'package:flutter/cupertino.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

class ListEmptyWidget extends StatelessWidget {
  const ListEmptyWidget({
    super.key,
    required this.isPermissionDenied,
    this.emptyBuilder,
  });

  final bool isPermissionDenied;
  final Widget Function(BuildContext)? emptyBuilder;
  // firestore security rule 에서 막혔을 경우

  @override
  Widget build(BuildContext context) {
    if (emptyBuilder != null) {
      if (isPermissionDenied) {
        return Center(child: Text(context.loc.needPermission));
      }
      return emptyBuilder!.call(context);
    }

    return Center(
        child: Text(isPermissionDenied
            ? context.loc.needPermission
            : context.loc.noContent));
  }
}
