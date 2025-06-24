// flutter
import 'package:flutter/material.dart';

// core
import 'package:applimode_app/custom_settings.dart';

class ResponsiveSizedBox extends StatelessWidget {
  const ResponsiveSizedBox({
    super.key,
    this.maxContentWidth = pcWidthBreakpoint,
    this.padding = const EdgeInsets.all(16),
    required this.child,
  });

  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxContentWidth,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class ResponsiveScrollView extends StatelessWidget {
  const ResponsiveScrollView({
    super.key,
    this.maxContentWidth = pcWidthBreakpoint,
    this.padding = const EdgeInsets.all(16),
    required this.child,
  });

  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        maxContentWidth: maxContentWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}

class ResponsiveCenterScrollView extends StatelessWidget {
  const ResponsiveCenterScrollView({
    super.key,
    this.maxContentWidth = pcWidthBreakpoint,
    this.padding = const EdgeInsets.all(16),
    required this.child,
  });

  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ResponsiveScrollView(
        maxContentWidth: maxContentWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}

class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    this.maxContentWidth = pcWidthBreakpoint,
    this.padding = const EdgeInsets.all(16),
    required this.child,
  });

  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ResponsiveSizedBox(
      maxContentWidth: maxContentWidth,
      padding: padding,
      child: child,
    ));
  }
}

class ResponsiveSliverCenter extends StatelessWidget {
  const ResponsiveSliverCenter({
    super.key,
    this.maxContentWidth = pcWidthBreakpoint,
    this.padding = const EdgeInsets.all(16),
    required this.child,
  });

  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ResponsiveCenter(
        maxContentWidth: maxContentWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}
