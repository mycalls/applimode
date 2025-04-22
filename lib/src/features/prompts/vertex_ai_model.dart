import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vertex_ai_model.g.dart';

@Riverpod(keepAlive: true)
GenerativeModel vertexAiModel(Ref ref) {
  return FirebaseVertexAI.instance.generativeModel(
    model: aiModelType,
    systemInstruction: Content.text(aiSystemInstruction),
  );
}
