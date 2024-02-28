import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:ngz_flutter_ui/core/styles/styles.dart';
import 'package:ngz_flutter_ui/core/utils/utils.dart';

class KnobPainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final double step;
  final String unit;
  final double minAngle;
  final double maxAngle;
  final bool infiniteLoop;

  double thickness = 25;

  TextStyle labelTS = TextStyle(
    fontSize: 16.0,
    color: $styles.colors.markerColor,
  );

  Paint markerPaintStroke = Paint()
    ..color = $styles.colors.markerColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  Paint indicatorDotPaint = Paint()
    ..color = $styles.colors.indicatorDotColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 15.0;

  Paint indicatorArcPaintBlur = Paint()
    ..color = $styles.colors.indicatorArcColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5);

  final knobPaintFill = Paint()
    ..color = $styles.colors.knobColor
    ..style = PaintingStyle.fill;

  KnobPainter(
    this.value,
    this.min,
    this.max,
    this.step,
    this.unit,
    this.minAngle,
    this.maxAngle, {
    this.infiniteLoop = false,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is KnobPainter) {
      return value != oldDelegate.value ||
          min != oldDelegate.min ||
          max != oldDelegate.max ||
          step != oldDelegate.step ||
          unit != oldDelegate.unit ||
          minAngle != oldDelegate.minAngle ||
          maxAngle != oldDelegate.maxAngle;
    }
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2.0, size.height / 2.0);
    final rect =
        Rect.fromCenter(center: c, width: size.width, height: size.height);
    final r = size.width / 2.0; // dial radius

    drawDial(canvas, rect, r);
    drawMinMaxGuides(canvas, c, r);
    drawScale(canvas, c, r);

    final r1 = r - thickness / 2.0;
    drawKnob(canvas, rect, r1);
    final rect1 = rect.deflate(thickness * 0.75);
    drawKnobEffects(canvas, rect1);
    drawIndicators(canvas, rect1, r);
  }

  void drawDial(Canvas canvas, Rect rect, double r) {
    final dialPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          $styles.colors.dialColorLight,
          $styles.colors.dialColorDark,
        ],
      ).createShader(rect);

    canvas.drawCircle(rect.center, r, dialPaint);

    // draw border
    dialPaint.strokeWidth = 1.0;
    canvas.drawCircle(rect.center, r + thickness / 2.0 + 1.5, dialPaint);
  }

  void drawKnob(Canvas canvas, Rect rect, double r) {
    final knobPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          $styles.colors.knobColorLight,
          $styles.colors.knobColorDark,
        ],
      ).createShader(rect);

    canvas.drawCircle(rect.center, r, knobPaint);

    // draw border
    canvas.drawCircle(
      rect.center,
      r + 1.0,
      Paint()
        ..color = $styles.colors.knobColorDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );
  }

  void drawScale(Canvas canvas, Offset c, double r) {
    final minAngleR = minAngle * pi / 180.0;
    final maxAngleR = maxAngle * pi / 180.0 + kTwoPi;
    final angleRangeR = maxAngleR - minAngleR;
    final stepCount = (max - min) / step;
    final stepAngleR = angleRangeR / stepCount;

    int i = 0;
    for (var a = minAngleR; a <= maxAngleR; a += stepAngleR) {
      var d = r - 0;

      if (i % 10 == 0) {
        d = r - 1.0;
      } else if (i % 5 == 0) {
        d = r - 2.0;
      } else {
        d = r - 4.0;
      }

      final offset = Offset(d * cos(a), d * sin(a));
      canvas.drawLine(c, c + offset, markerPaintStroke);
      i++;
    }
  }

  void drawMinMaxGuides(Canvas canvas, Offset offset, double r) {
    final minAngleR = minAngle * pi / 180.0;
    final maxAngleR = maxAngle * pi / 180.0;
    final minOffset = Offset(r * cos(minAngleR), r * sin(minAngleR));
    final maxOffset = Offset(r * cos(maxAngleR), r * sin(maxAngleR));

    canvas.drawLine(offset, offset + minOffset, markerPaintStroke);
    canvas.drawLine(offset, offset + maxOffset, markerPaintStroke);

    final d1 = r + 30.0;
    final minLabelOffset = Offset(d1 * cos(minAngleR), d1 * sin(minAngleR));
    final maxLabelOffset = Offset(d1 * cos(maxAngleR), d1 * sin(maxAngleR));

    drawTextCentered(
      canvas,
      offset + minLabelOffset,
      min.toInt().toString(),
      labelTS,
      50.0,
    );
    drawTextCentered(
      canvas,
      offset + maxLabelOffset,
      max.toInt().toString(),
      labelTS,
      50.0,
    );
  }

  void drawKnobEffects(Canvas canvas, Rect rect) {
    final fg2Paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          $styles.colors.knobColorDark,
          $styles.colors.knobColorLight,
        ],
      ).createShader(rect);

    canvas.drawCircle(rect.center, rect.width / 2.0, fg2Paint);
  }

  void drawIndicators(Canvas canvas, Rect rect, double r) {
    final minAngleR = minAngle * pi / 180.0;
    final maxAngleR = maxAngle * pi / 180.0 + kTwoPi;

    final angleRangeR = maxAngleR - minAngleR;
    final anglesPerUnit = angleRangeR / (max - min);
    final angleR = minAngleR + anglesPerUnit * (value - min);

    // draw dot
    final r1 = r - 20.0;
    final d = Offset(r1 * cos(angleR), r1 * sin(angleR));
    canvas.drawCircle(
      rect.center + d,
      1.250,
      indicatorDotPaint,
    );

    // draw arc
    canvas.drawArc(
      rect,
      minAngleR,
      infiniteLoop ? maxAngleR : angleR - minAngleR,
      false,
      indicatorArcPaintBlur,
    );
  }
}
