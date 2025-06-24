import 'dart:async';

// flutter
import 'package:flutter/material.dart';

// utils
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:applimode_app/src/utils/string_converter.dart';

class MarkdownField extends StatefulWidget {
  const MarkdownField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<MarkdownField> createState() => _MarkdownFieldState();
}

class _MarkdownFieldState extends State<MarkdownField> {
  bool _isCancelled = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    widget.controller.addListener(_renderText);
    super.initState();
  }

  @override
  void dispose() {
    _isCancelled = true;
    _debounceTimer?.cancel();
    widget.controller.removeListener(_renderText);
    super.dispose();
  }

  void _renderText() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_isCancelled) return;
      if (mounted) {
        safeBuildCall(() => setState(() {}));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // dev.log('markdown filed build');
    final itemsList =
        StringConverter.stringToElements(content: widget.controller.text);
    return SafeArea(
      top: false,
      bottom: false,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          return itemsList[index];
        },
      ),
    );
  }
}
