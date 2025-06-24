import 'dart:math' as math;

// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// external
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

// utils
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

// common widgets
import 'package:applimode_app/src/common_widgets/video_player/post_video_player.dart';

class FullVideoScreen extends StatefulWidget {
  const FullVideoScreen({
    super.key,
    required this.videoUrl,
    this.videoController,
    this.position,
  });

  final String videoUrl;
  final VideoPlayerController? videoController;
  final Duration? position;

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

// Add SingleTickerProviderStateMixin for the AnimationController
class _FullVideoScreenState extends State<FullVideoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  double _dragOffsetY = 0.0;
  bool _isDragging = false;

  // Thresholds for dismissal
  final double _dismissThresholdVelocity = 700.0; // Speed of the flick
  final double _dismissThresholdDistanceFactor =
      0.3; // 30% of screen height dragged

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 200), // Animation duration for returning
    );

    // Animation from current drag position back to (0,0)
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    )..addListener(() {
        if (mounted) {
          setState(() {
            _dragOffsetY = _animation.value.dy;
          });
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    // Stop any ongoing return animation
    _animationController.stop();
    setState(() {
      _isDragging = true;
      // Start dragOffsetY from its current animated value if any
      // _dragOffsetY = _dragOffsetY; // No change needed actually
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    setState(() {
      // Only allow dragging downwards from the initial position (0.0)
      // Add the change in vertical position (delta.dy)
      _dragOffsetY = math.max(0.0, _dragOffsetY + details.delta.dy);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    setState(() {
      _isDragging = false;
    });

    final screenHeight = MediaQuery.sizeOf(context).height;
    final dismissThresholdDistance =
        screenHeight * _dismissThresholdDistanceFactor;

    // Check if dismiss conditions are met
    final bool shouldDismiss =
        // Flick down fast enough
        (details.primaryVelocity != null &&
                details.primaryVelocity! > _dismissThresholdVelocity) ||
            // Or dragged down far enough
            (_dragOffsetY > dismissThresholdDistance);

    if (shouldDismiss) {
      if (kIsWeb) {
        WebBackStub().back();
      } else {
        if (context.canPop()) {
          context.pop(widget.videoController);
        }
      }
      /*
      if (mounted && Navigator.canPop(context)) {
        // Before popping, maybe pause the video if it's playing?
        // widget.videoController?.pause(); // Optional: depends on desired UX
        Navigator.of(context).pop();
      }
      */
    } else {
      // Animate back to the original position (0.0)
      _animation = Tween<Offset>(
        begin: Offset(0, _dragOffsetY),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
      _animationController.forward(from: 0.0);
    }
  }

  // Calculate background opacity based on drag distance for a fade-out effect
  double _calculateBackgroundOpacity() {
    final screenHeight = MediaQuery.sizeOf(context).height;
    // Start fading after dragging 10% of the screen height, fully transparent at 50%
    const startFadeFraction = 0.1;
    const fullFadeFraction = 0.5;

    final startFadeOffset = screenHeight * startFadeFraction;
    final fullFadeOffset = screenHeight * fullFadeFraction;

    if (_dragOffsetY <= startFadeOffset) {
      return 1.0; // Fully opaque
    } else if (_dragOffsetY >= fullFadeOffset) {
      return 0.0; // Fully transparent
    } else {
      // Linear interpolation between start and full fade offsets
      final fadeRange = fullFadeOffset - startFadeOffset;
      final currentFadePos = _dragOffsetY - startFadeOffset;
      return (1.0 - (currentFadePos / fadeRange)).clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundOpacity = _calculateBackgroundOpacity();

    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      // Important: Set behavior to opaque (or translucent) so the GestureDetector
      // captures events even in empty areas of the Scaffold body.
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        // Make the background transparent dynamically based on drag
        backgroundColor: Colors.black.withValues(alpha: backgroundOpacity),
        body: Transform.translate(
          // Apply the vertical translation based on drag/animation
          offset: Offset(0, _dragOffsetY),
          child: Center(
            // Keep the player centered
            child: PostVideoPlayer(
              // Pass the original parameters through
              videoUrl: widget.videoUrl,
              videoController: widget.videoController,
              isFullScreen: true, // Assuming PostVideoPlayer uses this
              position: widget.position,
              disposeController: widget.videoController != null ? false : true,
            ),
          ),
        ),
      ),
    );
  }
}

/*
import 'package:applimode_app/src/features/video_player/post_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullVideoScreen extends StatelessWidget {
  const FullVideoScreen({
    super.key,
    required this.videoUrl,
    this.videoController,
    this.position,
  });

  final String videoUrl;
  final VideoPlayerController? videoController;
  final Duration? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: PostVideoPlayer(
          videoUrl: videoUrl,
          videoController: videoController,
          isFullScreen: true,
          position: position,
          disposeController: videoController != null ? false : true,
        ),
      ),
    );
  }
}
*/
