import 'dart:developer' as dev;

import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/prompts/data/user_prompts_repository.dart';
import 'package:applimode_app/src/features/prompts/vertex_ai_model.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'editor_screen_ai_controller.g.dart';

@riverpod
class EditorScreenAiController extends _$EditorScreenAiController {
  @override
  FutureOr<void> build() {}

  Future<String?> generateContent({
    required String promptString,
    String? contentString,
    List<String>? imagePaths,
    List<String> prompts = const [],
    String predefinedPrompt = '',
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state =
          AsyncError(Exception('Permission is required'), StackTrace.current);
      return contentString ?? '';
    }

    state = const AsyncLoading();
    final List<InlineDataPart> imageParts = [];
    String result = '';
    state = await AsyncValue.guard(() async {
      if (imagePaths != null && imagePaths.isNotEmpty) {
        Uint8List? file;
        for (final path in imagePaths) {
          final match = Regex.mediaWithExtRegex.firstMatch(path);
          if (match != null &&
              match[2] != null &&
              (match[2] == 'jpeg' || match[2] == 'png')) {
            final type = Format.extToMimeType(match[2]!);
            try {
              file = await XFile(Format.fixMediaWithExt(path)).readAsBytes();
            } catch (e) {
              continue;
            }
            imageParts.add(InlineDataPart(type, file));
          } else {
            continue;
          }
        }
      }

      final userPrompt = predefinedPrompt.trim().isEmpty &&
              promptString.trim().isEmpty
          ? ''
          : '$userPromptStartTag$predefinedPrompt $promptString$userPromptEndTag';
      final content = contentString == null || contentString.trim().isEmpty
          ? ''
          : '$contentStartTag$contentString$contentEndTag';
      final fullPrompt = '$userPrompt $content';
      dev.log('fullPrompt: $fullPrompt');
      final prompt = imageParts.isEmpty
          ? [Content.text(fullPrompt)]
          : [
              Content.multi([TextPart(fullPrompt), ...imageParts])
            ];
      final response =
          await ref.read(vertexAiModelProvider).generateContent(prompt);
      result = response.text ?? '';
    });

    if (state.hasError) {
      debugPrint('aiController: ${state.error.toString()}');
      return '';
    }

    /// sharedPreference 에 최대 20개까지 프롬프트 저장하기
    /// 추 후 서버에도 저장해서 동기화되도록 할 것

    if (promptString.trim().isNotEmpty) {
      try {
        final userPromptsRepository = ref.read(userPromptsRepositoryProvider);
        List<String> newPrompts = [];
        if (prompts.contains(promptString)) {
          newPrompts = prompts;
        } else if (prompts.length > 20) {
          newPrompts = [promptString, ...prompts.sublist(0, 19)];
        } else {
          newPrompts = [promptString, ...prompts];
        }
        await userPromptsRepository.createUserPrompt(
          id: user.uid,
          prompts: newPrompts,
          predefinedPrompt: predefinedPrompt,
        );
      } catch (e) {
        debugPrint('aiProptsSaveError: ${e.toString()}');
      }
    }

    /*
    try {
      final sharedPreferences = ref.read(prefsWithCacheProvider).requireValue;
      List<String> exist = sharedPreferences.getStringList('aiPrompts') ?? [];
      if (exist.length > 20) {
        exist = exist.sublist(0, 19);
      }
      sharedPreferences.setStringList('aiPrompts', [promptString, ...exist]);
      // sharedPreferences.setString('tempNewPost', onlyText);
    } catch (e) {
      debugPrint('aiProptsSaveError: ${e.toString()}');
    }
    */

    return result;
  }
}
