import 'package:flutter/material.dart';
import 'package:ngz_flutter_ui/core/styles/palette.dart';
import 'package:ngz_flutter_ui/core/styles/typography.dart';

final $styles = AppStyle();

@immutable
class AppStyle {
  AppStyle({Size? screenSize}) {
    if (screenSize == null) {
      scale = 1;
      return;
    }
    final shortestSide = screenSize.shortestSide;
    const tabletXl = 1000;
    const tabletLg = 800;
    if (shortestSide > tabletXl) {
      scale = 1.2;
    } else if (shortestSide > tabletLg) {
      scale = 1.1;
    } else {
      scale = 1;
    }
  }

  late final double scale;

  final Palette colors = Palette();

  late final _Gradients gradients = _Gradients();

  /// Animation Durations
  final _Times times = _Times();

  /// Text styles
  late final CustomTypography text = CustomTypography();

  late final _Shadows shadows = _Shadows();

  /// Padding and margin values
  late final _Insets insets = _Insets(scale);

  /// Shared sizes
  late final _Sizes sizes = _Sizes();

  /// Rounded edge corner radii
  late final _Corners corners = _Corners();
}

@immutable
class _Times {
  final Duration fast = const Duration(milliseconds: 300);
  final Duration med = const Duration(milliseconds: 600);
  final Duration slow = const Duration(milliseconds: 900);
  final Duration pageTransition = const Duration(milliseconds: 200);
}

@immutable
class _Corners {
  late final double sm = 4;
  late final double md = 8;
  late final double lg = 32;
}

@immutable
class _Sizes {
  double get maxContentWidth1 => 800;
  double get maxContentWidth2 => 600;
  double get maxContentWidth3 => 500;
  final Size minAppSize = Size(380, 650);
}

@immutable
class _Gradients {
  final linearGradient = const LinearGradient(
    colors: [Colors.amber, Colors.green, Colors.blue],
    stops: [0, 0.1, 1],
  );
}

@immutable
class _Insets {
  _Insets(this._scale);
  final double _scale;

  late final double xxs = 4 * _scale;
  late final double xs = 8 * _scale;
  late final double sm = 16 * _scale;
  late final double md = 24 * _scale;
  late final double lg = 32 * _scale;
  late final double xl = 48 * _scale;
  late final double xxl = 56 * _scale;
  late final double offset = 80 * _scale;
}

@immutable
class _Shadows {
  final textSoft = [
    Shadow(
        color: Colors.black.withOpacity(.25),
        offset: Offset(0, 2),
        blurRadius: 4),
  ];
  final text = [
    Shadow(
        color: Colors.black.withOpacity(.6),
        offset: Offset(0, 2),
        blurRadius: 2),
  ];
  final textStrong = [
    Shadow(
        color: Colors.black.withOpacity(.6),
        offset: Offset(0, 4),
        blurRadius: 6),
  ];
}
