// external
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

part 'vertex_ai_model.g.dart';

@Riverpod(keepAlive: true)
GenerativeModel vertexAiModel(Ref ref) {
  return FirebaseAI.googleAI().generativeModel(
    model: aiModelType,
    systemInstruction: Content.text(aiSystemInstruction),
  );
}
