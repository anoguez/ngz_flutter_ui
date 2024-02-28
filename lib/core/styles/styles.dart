import 'package:flutter/material.dart';
import 'package:ngz_flutter_ui/core/styles/palette.dart';

final $styles = AppStyle();

@immutable
class AppStyle {
  final Palette colors = Palette();

  late final _Gradients gradients = _Gradients();
}

@immutable
class _Gradients {
  final linearGradient = const LinearGradient(
    colors: [Colors.amber, Colors.green, Colors.blue],
    stops: [0, 0.1, 1],
  );
}
