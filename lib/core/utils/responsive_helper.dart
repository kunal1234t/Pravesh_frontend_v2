import 'package:flutter/material.dart';

class ResponsiveHelper {
  // 📐 Centralized breakpoints
  static const double _smallBreakpoint = 600;
  static const double _tabletBreakpoint = 900;

  /// Cache MediaQuery size once
  static Size _size(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Use shortestSide for better orientation support
  static bool isSmallScreen(BuildContext context) {
    return _size(context).shortestSide < _smallBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final side = _size(context).shortestSide;
    return side >= _smallBreakpoint && side < _tabletBreakpoint;
  }

  static bool isLargeScreen(BuildContext context) {
    return _size(context).shortestSide >= _tabletBreakpoint;
  }

  static double getScreenWidth(BuildContext context) {
    return _size(context).width;
  }

  static double getScreenHeight(BuildContext context) {
    return _size(context).height;
  }

  /// Responsive padding (unchanged behavior)
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final side = _size(context).shortestSide;

    if (side < _smallBreakpoint) {
      return const EdgeInsets.all(16);
    } else if (side < _tabletBreakpoint) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  /// Font scaling with safety cap (prevents UI breakage)
  static double getResponsiveFontSize(
    BuildContext context, {
    double baseFontSize = 16,
  }) {
    final side = _size(context).shortestSide;

    double scale;
    if (side < _smallBreakpoint) {
      scale = 1.0;
    } else if (side < _tabletBreakpoint) {
      scale = 1.15;
    } else {
      scale = 1.3;
    }

    // 🛑 Prevent absurd scaling on very large screens
    return baseFontSize * scale.clamp(1.0, 1.4);
  }
}
