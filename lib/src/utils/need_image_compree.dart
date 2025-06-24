// core
import 'package:applimode_app/src/core/constants/constants.dart';

bool needImageCompree(String mediaType) {
  if (mediaType == contentTypeJpeg || mediaType == contentTypePng) {
    return true;
  } else {
    return false;
  }
}
