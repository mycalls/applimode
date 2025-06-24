// lib/src/features/posts/presentation/search_bar.dart

// flutter
import 'package:flutter/material.dart';

// core
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

// English: A custom search bar widget that includes a text input field and a search icon button.
// Korean: 텍스트 입력 필드와 검색 아이콘 버튼을 포함하는 사용자 정의 검색 바 위젯입니다.
class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onComplete,
  });

  // English: Controller for the text input field.
  // Korean: 텍스트 입력 필드의 컨트롤러입니다.
  final TextEditingController controller;
  // English: Callback function invoked when editing is complete (e.g., user presses "done" or taps the search icon).
  // Korean: 편집이 완료될 때(예: 사용자가 "완료"를 누르거나 검색 아이콘을 탭할 때) 호출되는 콜백 함수입니다.
  final VoidCallback? onComplete;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  // English: Focus node to manage the focus state of the TextField.
  // Korean: TextField의 포커스 상태를 관리하는 포커스 노드입니다.
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // English: Dispose the focus node to prevent memory leaks.
    // Korean: 메모리 누수를 방지하기 위해 포커스 노드를 폐기합니다.
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // English: A Row widget to arrange the TextField and IconButton horizontally.
    // Korean: TextField와 IconButton을 가로로 배열하는 Row 위젯입니다.
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: TextField(
                // English: Assign the controller and focus node to the TextField.
                // Korean: 컨트롤러와 포커스 노드를 TextField에 할당합니다.
                controller: widget.controller,
                focusNode: _focusNode,
                // English: Set the text input action to "done".
                // Korean: 텍스트 입력 작업을 "완료"로 설정합니다.
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  // English: Remove the default border.
                  // Korean: 기본 테두리를 제거합니다.
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  // English: Localized hint text for the search bar.
                  // Korean: 검색 바에 대한 현지화된 힌트 텍스트입니다.
                  hintText: context.loc.tagSearch,
                  // hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
                // English: Call onComplete when the user finishes editing (e.g., presses "done" on the keyboard).
                // Korean: 사용자가 편집을 완료하면(예: 키보드에서 "완료"를 누르면) onComplete를 호출합니다.
                onEditingComplete: () {
                  widget.onComplete?.call();
                },
              ),
            ),
          ),
        ),
        // English: IconButton that also triggers the onComplete callback when pressed.
        // Korean: 눌렀을 때 onComplete 콜백도 트리거하는 IconButton입니다.
        IconButton(
          onPressed: () {
            widget.onComplete?.call();
          },
          icon: const Icon(Icons.search_outlined),
        )
      ],
    );
  }
}
