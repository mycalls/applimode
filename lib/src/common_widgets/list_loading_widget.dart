// flutter
import 'package:flutter/cupertino.dart';

class ListLoadingWidget extends StatelessWidget {
  const ListLoadingWidget({
    super.key,
    this.loadingBuilder,
  });

  final Widget Function(BuildContext)? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    if (loadingBuilder != null) {
      return loadingBuilder!.call(context);
    }

    return const Center(child: CupertinoActivityIndicator());
  }
}
