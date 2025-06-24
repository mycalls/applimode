// import 'dart:developer' as dev;

// flutter
import 'package:flutter/material.dart';

// external
import 'package:intl/intl.dart';

// core
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/core/constants/constants.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/regex.dart';

class Format {
  static String hours(double hours) {
    final hoursNotNegative = hours < 0.0 ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  static String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String toAgo(
    BuildContext context,
    DateTime date,
  ) {
    Duration diff = DateTime.now().difference(date);

    if (diff.inDays > 1) {
      return '${diff.inDays}${context.loc.daysAgo}';
    } else if (diff.inDays == 1) {
      return '${diff.inDays}${context.loc.dayAgo}';
    } else if (diff.inHours > 1) {
      return '${diff.inHours}${context.loc.hoursAgo}';
    } else if (diff.inHours == 1) {
      return '${diff.inHours}${context.loc.hourAgo}';
    } else if (diff.inMinutes > 1) {
      return '${diff.inMinutes}${context.loc.minutesAgo}';
    } else if (diff.inMinutes == 1) {
      return '${diff.inMinutes}${context.loc.minuteAgo}';
    } else {
      return context.loc.justNow;
    }
  }

  static String formatNumber(BuildContext context, int number) {
    final systemLanguageCode = Localizations.localeOf(context).languageCode;
    return NumberFormat.compact(locale: systemLanguageCode).format(number);
  }

  static String dateTime(DateTime date) {
    return DateFormat.yMMMEd().add_jm().format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  static String currency(double pay) {
    final payNotNegative = pay <= 0.0 ? 0.0 : pay;
    final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
    return formatter.format(payNotNegative);
  }

  static Color hexStringToColor(String hexString) {
    hexString = hexString.toUpperCase().replaceAll("#", "");
    if (hexString.length == 6 && Regex.hexColorRegex.hasMatch(hexString)) {
      hexString = 'FF$hexString';
    } else {
      hexString = 'FF$spareMainColor';
    }
    final hexInt = int.tryParse(hexString, radix: 16);
    return hexInt == null ? Colors.orange : Color(hexInt);
  }

  /*
  static String colorToHexString(Color color) {
    debugPrint('color: ${color.toString()}');
    return color.value.toRadixString(16).substring(2, 8);
  }
  */

  // flutter 3.27 color migration
  static String colorToHexString(Color color) {
    // sRGB to 0 ~ 255
    int red = (color.r * 255).round();
    int green = (color.g * 255).round();
    int blue = (color.b * 255).round();

    // to hex
    String hexRed = red.toRadixString(16).padLeft(2, '0');
    String hexGreen = green.toRadixString(16).padLeft(2, '0');
    String hexBlue = blue.toRadixString(16).padLeft(2, '0');
    // dev.log('color: ${color.toString()}');
    // dev.log('hexColor: $hexRed$hexGreen$hexBlue');

    return '$hexRed$hexGreen$hexBlue';
  }

  static int colorToIntHex(Color color) {
    int red = (color.r * 255).round();
    int green = (color.g * 255).round();
    int blue = (color.b * 255).round();

    return (0xFF << 24) | (red << 16) | (green << 8) | blue;
  }

  static String durationToString(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, '0');
  }

  /*
  static int yearMonthToInt(DateTime dateTime) {
    final now = DateTime.now();
    final yearMonthString =
        '${now.year.toString()}${now.month.toString().padLeft(2, '0')}';
    return int.tryParse(yearMonthString) ?? 202311;
  }

  static int yearMonthDayToInt(DateTime dateTime) {
    final now = DateTime.now();
    final yearMonthDayString =
        '${now.year.toString()}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return int.tryParse(yearMonthDayString) ?? 20231106;
  }
  */

  static int yearMonthToInt(DateTime dateTime) {
    final yearMonthString =
        '${dateTime.year.toString()}${dateTime.month.toString().padLeft(2, '0')}';
    return int.tryParse(yearMonthString) ?? 202311;
  }

  static int yearMonthDayToInt(DateTime dateTime) {
    final yearMonthDayString =
        '${dateTime.year.toString()}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}';
    return int.tryParse(yearMonthDayString) ?? 20231106;
  }

  static String getMonthLabel(BuildContext context, int? month) {
    final systemLanguageCode = Localizations.localeOf(context).languageCode;
    return DateFormat('MMM', systemLanguageCode)
        .format(DateTime(2023, month ?? 1));
  }

  static String getDayLabel(
      BuildContext context, int year, int month, int? day) {
    final systemLanguageCode = Localizations.localeOf(context).languageCode;
    return DateFormat('d', systemLanguageCode)
        .format(DateTime(year, month, day ?? 1));
  }

  static List<int> getDaysList(int year, int month) {
    const longMonths = [1, 3, 5, 7, 8, 10, 12];
    if (year % 4 == 0 && month == 2) {
      return List<int>.generate(29, (index) => index + 1);
    }
    if (month == 2) {
      return List<int>.generate(28, (index) => index + 1);
    }
    if (longMonths.contains(month)) {
      return List<int>.generate(31, (index) => index + 1);
    }
    return List<int>.generate(30, (index) => index + 1);
  }

  static String getShortName(String name) {
    if (name.length > usernameMaxLength) {
      return '${name.substring(0, usernameMaxLength)}...';
    }
    return name;
  }

  static String mimeTypeToExtWithDot(String mime) {
    switch (mime) {
      case contentTypeJpeg:
        return '.jpeg';
      case contentTypePng:
        return '.png';
      case contentTypeGif:
        return '.gif';
      case contentTypeWebp:
        return '.webp';
      case contentTypeMp4:
        return '.mp4';
      case contentTypeQv:
        return '.mov';
      case contentTypeWebm:
        return '.webm';
      default:
        return '.jpeg';
    }
  }

  static String mimeTypeToExt(String mime) {
    switch (mime) {
      case contentTypeJpeg:
        return 'jpeg';
      case contentTypePng:
        return 'png';
      case contentTypeGif:
        return 'gif';
      case contentTypeWebp:
        return 'webp';
      case contentTypeMp4:
        return 'mp4';
      case contentTypeQv:
        return 'mov';
      case contentTypeWebm:
        return 'webm';
      default:
        return 'jpeg';
    }
  }

  static String extToMimeType(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpeg' || 'jpg':
        return contentTypeJpeg;
      case 'png':
        return contentTypePng;
      case 'gif':
        return contentTypeGif;
      case 'webp':
        return contentTypeWebp;
      case 'mp4':
        return contentTypeMp4;
      case 'mov':
        return contentTypeQv;
      case 'webm':
        return contentTypeWebm;
      default:
        return 'jpeg';
    }
  }

  static String fixMediaWithExt(String path) {
    final mediaWithExtRegex = Regex.mediaWithExtRegex;
    return mediaWithExtRegex.hasMatch(path)
        ? mediaWithExtRegex.firstMatch(path)![1]!
        : path;
  }
}
