// flutter
import 'package:flutter/foundation.dart';

// utils
import 'package:applimode_app/src/utils/regex.dart';

List<String> buildRemoteMedia(String content) {
  List<String> remoteMedia = [];
  final imageMatches = Regex.remoteImageRegex.allMatches(content);
  final videoMatches = Regex.remoteVideoRegex.allMatches(content);

  try {
    final matches = [...imageMatches, ...videoMatches];
    if (matches.isEmpty) {
      return remoteMedia;
    }
    for (final match in matches) {
      if (match[1] != null && match[1]!.isNotEmpty) {
        remoteMedia.add(match[1]!);
      }
      if (match[2] != null && match[2]!.isNotEmpty) {
        remoteMedia.add(match[2]!);
      }
    }
  } catch (e) {
    debugPrint('failed buildRemoteMedia: ${e.toString()}');
  }

  return remoteMedia;
}
