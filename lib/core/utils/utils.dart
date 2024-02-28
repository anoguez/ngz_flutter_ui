import 'dart:math';

import 'package:flutter/rendering.dart';

double kTwoPi = 2 * pi;

TextPainter measureText(
  String s,
  TextStyle style,
  double maxWidth,
  TextAlign align,
) {
  final span = TextSpan(text: s, style: style);
  final tp = TextPainter(
      text: span, textAlign: align, textDirection: TextDirection.ltr);
  tp.layout(minWidth: 0, maxWidth: maxWidth);

  return tp;
}

void drawTextCentered(
  Canvas canvas,
  Offset c,
  String text,
  TextStyle style,
  double maxWidth,
) {
  final tp = measureText(text, style, maxWidth, TextAlign.center);

  final textWidth = tp.width;
  final textHeight = tp.height / maxWidth;
  final textOffset = Offset(c.dx - textWidth / 2, c.dy - textHeight / 2);
  tp.paint(canvas, textOffset);
}

Offset cartesianToPolar(Offset position, Size size) {
  double x = position.dx;
  double y = position.dy;

  // translate to our origin
  x -= size.width / 2.0;
  y -= size.height / 2.0;

  // convert to radius/theta
  final double radius = sqrt(x * x + y * y);
  final double theta = (atan2(x, -y) - pi / 2.0) % kTwoPi;

  return Offset(radius, theta);
}
