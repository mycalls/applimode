// lib/src/features/admin_settings/domain/app_main_category.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:applimode_app/src/utils/format.dart';

// Represents a main category in the application.
// 애플리케이션의 주요 카테고리를 나타냅니다.
class MainCategory extends Equatable {
  // Constructs a [MainCategory] instance.
  // [MainCategory] 인스턴스를 생성합니다.
  const MainCategory({
    required this.index,
    required this.path,
    required this.title,
    required this.color,
  });

  // The unique index of the category.
  // 카테고리의 고유 인덱스입니다.
  final int index;
  // The navigation path for the category (e.g., "/news").
  // 카테고리의 네비게이션 경로입니다 (예: "/news").
  final String path;
  // The display title of the category.
  // 카테고리의 표시 제목입니다.
  final String title;
  // The color associated with the category, often used for UI theming.
  // 카테고리와 관련된 색상으로, 종종 UI 테마에 사용됩니다.
  final Color color;

  // Creates a [MainCategory] instance from a JSON map.
  // JSON 맵으로부터 [MainCategory] 인스턴스를 생성합니다.
  factory MainCategory.fromJson(Map<String, dynamic> json) {
    return MainCategory(
      index: json['index'] as int? ?? 0,
      path: json['path'] as String? ?? '/404',
      title: json['title'] as String? ?? 'Unsorted',
      // Parses the color from a hex string, defaulting if null or invalid.
      // hex 문자열로부터 색상을 파싱하며, null이거나 유효하지 않은 경우 기본값을 사용합니다.
      color: Format.hexStringToColor(json['color'] as String? ?? 'FCB126'),
    );
  }

  // Converts this [MainCategory] instance to a map for serialization (e.g., to Firestore).
  // 이 [MainCategory] 인스턴스를 직렬화(예: Firestore로 전송)를 위해 맵으로 변환합니다.
  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'path': path,
      'title': title,
      // Converts the color to a hex string for storage.
      // 저장을 위해 색상을 hex 문자열로 변환합니다.
      'color': Format.colorToHexString(color),
    };
  }

  // Enables string representation for debugging.
  // 디버깅을 위한 문자열 표현을 활성화합니다.
  @override
  bool? get stringify => true;

  // Properties used by Equatable for value comparison.
  // Equatable이 값 비교에 사용하는 속성들입니다.
  @override
  List<Object?> get props => [
        index,
        path,
        title,
        color,
      ];
}
