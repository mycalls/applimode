// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:go_router/go_router.dart';

// core
import 'package:applimode_app/custom_settings.dart';

// utils
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/buttons/icon_back_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/web_back_button.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';

class FullImageScreen extends StatefulWidget {
  const FullImageScreen({
    super.key,
    required this.imageUrl,
    this.imageUrlsList,
    this.currentIndex,
  });

  final String imageUrl;
  final List<String>? imageUrlsList;
  final int? currentIndex;

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  PageController? controller;

  @override
  void initState() {
    super.initState();
    if (widget.currentIndex != null && widget.imageUrlsList != null) {
      controller = PageController(initialPage: widget.currentIndex!);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrlsList;
    final currentIndex = widget.currentIndex;
    return Scaffold(
      backgroundColor: Colors.black,
      body: urls != null && urls.isNotEmpty && currentIndex != null
          ? PageView.builder(
              // 많은 이미지를 위해 PageView.builder 사용 고려
              controller: controller,
              itemCount: urls.length,
              itemBuilder: (context, index) {
                return FullImageStack(
                  // PageView 내에서 각 FullImageStack이 고유한 상태를 갖도록 key를 제공
                  key: ValueKey(urls[index]),
                  url: urls[index],
                );
              },
            )
          : FullImageStack(url: widget.imageUrl),
    );
  }
}

class FullImageStack extends StatefulWidget {
  const FullImageStack({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<FullImageStack> createState() => _FullImageStackState();
}

class _FullImageStackState extends State<FullImageStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<Offset>? _animation; // Nullable로 변경하고 나중에 초기화
  Offset _dragOffset = Offset.zero;

  // InteractiveViewer의 스케일 및 변환을 제어하기 위한 컨트롤러
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;

  // Thresholds
  final double _dismissThresholdRatio = 0.25; // 화면 높이의 25%
  final double _flingVelocityThreshold = 1000.0; // 튕기기 감지 속도
  bool _isDismissing = false; // 팝 애니메이션이 진행 중인지 여부

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // 애니메이션 속도 조절
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_isDismissing) {
          // _isDismissing 플래그를 사용하여 팝 여부 결정
          if (kIsWeb) {
            WebBackStub().back();
          } else {
            if (context.canPop()) {
              context.pop();
            }
          }
        } else {
          // 애니메이션 완료 후 드래그 오프셋 초기화 (제자리로 돌아온 경우)
          if (mounted) {
            // 위젯이 아직 마운트된 상태인지 확인
            setState(() {
              _dragOffset = Offset.zero;
            });
          }
        }
      }
    });

    _transformationController.addListener(_onTransformChanged);
  }

  void _onTransformChanged() {
    // InteractiveViewer의 현재 스케일 값 가져오기
    final double scale = _transformationController.value.getMaxScaleOnAxis();
    if (mounted && scale != _currentScale) {
      setState(() {
        _currentScale = scale;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    // 이미지가 확대되어 있지 않을 때만 (또는 약간만 확대되었을 때) 드래그 시작 허용
    if (_currentScale > 1.05) return; // 확대 시 InteractiveViewer의 팬 제스처 우선
    _animationController.stop(); // 진행 중인 애니메이션 중지
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_currentScale > 1.05) return;
    if (mounted) {
      setState(() {
        _dragOffset += Offset(0, details.delta.dy);
      });
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // 이미지가 확대되어 있고 드래그 오프셋이 거의 없다면 (즉, InteractiveViewer 내부에서 패닝했을 가능성이 높음) 무시
    if (_currentScale > 1.05 && _dragOffset.dy.abs() < 10) {
      // 작은 임계값
      // 혹시 모를 _dragOffset 잔여값 초기화 (선택적)
      if (_dragOffset != Offset.zero && mounted) {
        setState(() {
          _dragOffset = Offset.zero;
        });
      }
      return;
    }

    final screenSize = MediaQuery.of(context).size;
    final dismissThreshold = screenSize.height * _dismissThresholdRatio;
    final primaryVelocity = details.primaryVelocity ?? 0.0;

    bool shouldDismiss = false;

    // 조건 1: 충분한 속도로 튕겼을 때 (Fling)
    if (primaryVelocity.abs() > _flingVelocityThreshold) {
      shouldDismiss = true;
    }
    // 조건 2: 충분한 거리만큼 드래그했을 때
    else if (_dragOffset.dy.abs() > dismissThreshold) {
      shouldDismiss = true;
    }

    if (mounted) {
      if (shouldDismiss) {
        _isDismissing = true; // 팝 애니메이션 시작 표시
        // 튕기거나 드래그한 방향으로 화면 밖으로 이동
        final double endY = (_dragOffset.dy > 0 || primaryVelocity > 0)
            ? screenSize.height // 아래로 스와이프
            : -screenSize.height; // 위로 스와이프

        _animation = Tween<Offset>(
          begin: _dragOffset,
          end: Offset(0, endY),
        ).animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOut));
        _animationController.forward(from: 0.0);
      } else {
        _isDismissing = false; // 팝하지 않음
        // 원래 위치(중앙)로 스냅백
        _animation = Tween<Offset>(
          begin: _dragOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOut));
        _animationController.forward(from: 0.0);
        // _dragOffset은 애니메이션 완료 리스너에서 Offset.zero로 설정됩니다.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 드래그 및 애니메이션 될 이미지 부분
    Widget imageContent = Positioned.fill(
      child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 1.0,
          // maxScale: 4.0, // 최대 확대 배율
          // onInteractionEnd: (details) { // 스케일 값을 여기서도 업데이트 할 수 있습니다.
          //   if (mounted) setState(() => _currentScale = details.scale);
          // },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              Offset currentOffset = _dragOffset;
              // 애니메이션이 진행 중이고 _animation이 null이 아닐 때만 _animation.value 사용
              if (_animationController.isAnimating && _animation != null) {
                currentOffset = _animation!.value;
              }
              return Transform.translate(
                offset: currentOffset,
                child: PlatformNetworkImage(
                  imageUrl: widget.url,
                  headers: useRTwoSecureGet ? rTwoSecureHeader : null,
                  errorWidget: Container(color: Colors.black),
                  fit: BoxFit.contain, // 이미지가 화면에 맞게 표시되도록
                ), // imageContent가 이 child로 전달됨
              );
            },
          )),
    );

    return GestureDetector(
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      // PageView의 수평 스크롤과 충돌을 피하기 위해,
      // Flutter의 제스처 disambiguation에 의존합니다.
      // 수직 제스처는 여기서, 수평 제스처는 PageView에서 처리됩니다.
      child: Stack(
        children: [
          imageContent, // 이 부분이 애니메이션됨
          // 뒤로가기 버튼 (드래그에 영향받지 않도록 Stack의 다른 레이어에 배치)
          const Positioned(
            top: 12,
            left: 12,
            child: SafeArea(
              child: kIsWeb
                  ? WebBackButton(color: Colors.white)
                  : IconBackButton(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

/*
class FullImageScreen extends StatefulWidget {
  const FullImageScreen({
    super.key,
    required this.imageUrl,
    this.imageUrlsList,
    this.currentIndex,
  });

  final String imageUrl;
  final List<String>? imageUrlsList;
  final int? currentIndex;

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  PageController? controller;

  @override
  void initState() {
    if (widget.currentIndex != null && widget.imageUrlsList != null) {
      controller = PageController(initialPage: widget.currentIndex!);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrlsList;
    final currentIndex = widget.currentIndex;
    return Scaffold(
      backgroundColor: Colors.black,
      body: urls != null && urls.isNotEmpty && currentIndex != null
          ? PageView(
              controller: controller,
              children: urls.map((url) => FullImageStack(url: url)).toList(),
            )
          : FullImageStack(url: widget.imageUrl),
    );
  }
}

class FullImageStack extends StatelessWidget {
  const FullImageStack({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: InteractiveViewer(
            child: PlatformNetworkImage(
              imageUrl: url,
              headers: useRTwoSecureGet ? rTwoSecureHeader : null,
              errorWidget: Container(color: Colors.black),
            ),
            /*
            child: CachedNetworkImage(
              imageUrl: url,
              httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : null,
            ),
            */
          ),
        ),
        const Positioned(
          top: 12,
          left: 12,
          child: SafeArea(
            child: kIsWeb
                ? WebBackButton(color: Colors.white)
                : IconBackButton(
                    color: Colors.white,
                  ),
          ),
        )
      ],
    );
  }
}
*/
