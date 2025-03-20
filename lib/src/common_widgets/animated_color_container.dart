import 'dart:math';

import 'package:applimode_app/src/constants/color_palettes.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedColorContainer extends StatefulWidget {
  const AnimatedColorContainer({
    super.key,
    required this.child,
    this.millisecondes = colorAnimationDuration,
    this.isRepeat = true,
    this.storyImageUrl,
  });

  final Widget child;
  final int millisecondes;
  final bool isRepeat;
  final String? storyImageUrl;

  @override
  State<AnimatedColorContainer> createState() => _AnimatedColorContainerState();
}

class _AnimatedColorContainerState extends State<AnimatedColorContainer>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Color?>? _animationOne;
  Animation<Color?>? _animationTwo;

  final colorCount = Random().nextInt(gradientColorPalettes.length);

  @override
  void initState() {
    super.initState();

    if (widget.storyImageUrl == null) {
      final firstColor = gradientColorPalettes[colorCount][0];
      final secondColor = gradientColorPalettes[colorCount][1];

      _controller = AnimationController(
        duration: Duration(milliseconds: widget.millisecondes),
        vsync: this,
      );

      _animationOne = _controller != null
          ? ColorTween(begin: firstColor, end: secondColor).animate(
              CurvedAnimation(parent: _controller!, curve: Curves.easeOutSine))
          : null;
      _animationTwo = _controller != null
          ? ColorTween(begin: secondColor, end: firstColor).animate(
              CurvedAnimation(parent: _controller!, curve: Curves.easeOutSine))
          : null;

      widget.isRepeat
          ? _controller?.repeat(reverse: true)
          : _controller?.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null
        ? AnimatedBuilder(
            animation: _controller!,
            builder: (context, child) {
              return _buildProfilebox();
            },
          )
        : _buildProfilebox();
  }

  Widget _buildProfilebox() {
    final headers = useRTwoSecureGet ? rTwoSecureHeader : null;
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              gradient: widget.storyImageUrl != null
                  ? null
                  : LinearGradient(
                      // stops: const [0.2, 0.6],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _animationOne?.value ??
                            gradientColorPalettes[colorCount][0],
                        _animationTwo?.value ??
                            gradientColorPalettes[colorCount][1]
                      ],
                    ),
              image: widget.storyImageUrl == null
                  ? null
                  : DecorationImage(
                      image: kIsWeb
                          ? NetworkImage(
                              widget.storyImageUrl!,
                              headers: headers,
                            )
                          : CachedNetworkImageProvider(
                              widget.storyImageUrl!,
                              headers: headers,
                            ) as ImageProvider,
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) =>
                          debugPrint('imageError: ${exception.toString()}'),
                    ),
            ),
            child: widget.child,
          ),
        )
      ],
    );
  }
}

class AnimatedColorBox extends StatefulWidget {
  const AnimatedColorBox({
    super.key,
    this.millisecondes = colorAnimationDuration,
    this.isRepeat = true,
  });

  final int millisecondes;
  final bool isRepeat;

  @override
  State<AnimatedColorBox> createState() => _AnimatedColorBoxState();
}

class _AnimatedColorBoxState extends State<AnimatedColorBox>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Color?>? _animationOne;
  Animation<Color?>? _animationTwo;

  final colorCount = Random().nextInt(gradientColorPalettes.length);

  @override
  void initState() {
    super.initState();

    final firstColor = gradientColorPalettes[colorCount][0];
    final secondColor = gradientColorPalettes[colorCount][1];

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.millisecondes),
      vsync: this,
    );

    _animationOne = _controller != null
        ? ColorTween(begin: firstColor, end: secondColor).animate(
            CurvedAnimation(parent: _controller!, curve: Curves.easeOutSine))
        : null;
    _animationTwo = _controller != null
        ? ColorTween(begin: secondColor, end: firstColor).animate(
            CurvedAnimation(parent: _controller!, curve: Curves.easeOutSine))
        : null;

    widget.isRepeat
        ? _controller?.repeat(reverse: true)
        : _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null
        ? AnimatedBuilder(
            animation: _controller!,
            builder: (context, child) {
              return _buildProfilebox();
            },
          )
        : _buildProfilebox();
  }

  Widget _buildProfilebox() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        gradient: LinearGradient(
          // stops: const [0.2, 0.6],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _animationOne?.value ?? gradientColorPalettes[colorCount][0],
            _animationTwo?.value ?? gradientColorPalettes[colorCount][1]
          ],
        ),
      ),
    );
  }
}
