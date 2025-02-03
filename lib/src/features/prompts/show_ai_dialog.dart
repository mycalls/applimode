import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_screen_ai_controller.dart';
import 'package:applimode_app/src/features/prompts/data/user_prompts_repository.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

Future<String?> showAiDialog({
  required BuildContext context,
  List<String>? imagePaths,
  String? contentString,
}) async {
  debugPrint('imagePaths: $imagePaths');
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(context.loc.withAiTitle),
      contentPadding: const EdgeInsets.all(16),
      children: [
        AiDialog(
          context: context,
          imagePaths: imagePaths,
          contentString: contentString,
        ),
      ],
    ),
  );
}

class AiDialog extends ConsumerStatefulWidget {
  const AiDialog({
    super.key,
    required this.context,
    this.imagePaths,
    this.contentString,
  });

  final BuildContext context;
  final List<String>? imagePaths;
  final String? contentString;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AiDialogState();
}

class _AiDialogState extends ConsumerState<AiDialog> {
  final _newPromptController = TextEditingController();
  final _predefinedPromptController = TextEditingController();

  bool _isCancelled = false;

  @override
  void dispose() {
    _isCancelled = true;
    _newPromptController.dispose;
    _predefinedPromptController.dispose;
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
    final user = ref.watch(authStateChangesProvider).value;
    final userPromptStream = user != null
        ? ref.watch(userPromptStreamProvider(user.uid))
        : const AsyncValue.data(null);

    final isLoading = ref.watch(editorScreenAiControllerProvider).isLoading;

    return userPromptStream.when(
      data: (userPrompt) {
        if (userPrompt != null &&
            userPrompt.predefinedPrompt.trim().isNotEmpty) {
          _predefinedPromptController.text = userPrompt.predefinedPrompt;
        }
        return SizedBox(
          width: MediaQuery.sizeOf(context).width - 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: !isLoading
                ? [
                    TextField(
                      controller: _predefinedPromptController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: context.loc.predefinedPrompt,
                        hintText: context.loc.predefinedPromptHint,
                      ),
                    ),
                    // const SizedBox(height: 32),
                    if (userPrompt != null) ...[
                      const SizedBox(height: 16),
                      MenuAnchor(
                        builder: (context, controller, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: FilledButton.tonal(
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              child: Text(
                                context.loc.previousPrompts,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                        menuChildren: (userPrompt.prompts)
                            .indexed
                            .map((e) => SizedBox(
                                  width: MediaQuery.sizeOf(context).width - 96,
                                  child: MenuItemButton(
                                    onPressed: () {
                                      _safeSetState(() =>
                                          _newPromptController.text = e.$2);
                                    },
                                    trailingIcon: IconButton(
                                        onPressed: () async {
                                          final newPrompts = userPrompt.prompts;
                                          newPrompts.removeAt(e.$1);
                                          try {
                                            await ref
                                                .read(
                                                    userPromptsRepositoryProvider)
                                                .createUserPrompt(
                                                  id: user!.uid,
                                                  prompts: newPrompts,
                                                  predefinedPrompt:
                                                      _predefinedPromptController
                                                          .text,
                                                );
                                          } catch (e) {
                                            debugPrint(e.toString());
                                          }
                                        },
                                        icon: const Icon(Icons.close)),
                                    child: Text(
                                      e.$2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ))
                            .toList(),
                        /*
                  menuChildren: prompts
                      .map((prompt) => SizedBox(
                            width: MediaQuery.sizeOf(context).width - 96,
                            child: MenuItemButton(
                              onPressed: () {
                                _inputController.text = prompt;
                              },
                              trailingIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.close)),
                              child: Text(
                                prompt,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                      .toList(),
                  */
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextField(
                      controller: _newPromptController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: context.loc.prompt,
                        hintText: context.loc.promptHint,
                      ),
                      /*
                      onChanged: (_) {
                        _safeSetState();
                      },
                      */
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.pop(null);
                          },
                          child: Text(widget.context.loc.cancel),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () async {
                            final result = await ref
                                .read(editorScreenAiControllerProvider.notifier)
                                .generateContent(
                                  imagePaths: widget.imagePaths,
                                  contentString: widget.contentString,
                                  promptString: _newPromptController.text,
                                  prompts: userPrompt?.prompts ?? [],
                                  predefinedPrompt:
                                      _predefinedPromptController.text,
                                );
                            if (context.mounted &&
                                context.canPop() &&
                                result != null &&
                                result.isNotEmpty) {
                              context.pop(result);
                            }
                          },
                          child: Text(widget.context.loc.ok),
                        ),
                      ],
                    ),
                  ]
                : [
                    const SizedBox(height: 24),
                    const CircularProgressIndicator.adaptive(),
                    const SizedBox(height: 16),
                    Text(context.loc.generating),
                    const SizedBox(height: 24),
                  ],
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const Center(child: CupertinoActivityIndicator()),
    );
  }
}
