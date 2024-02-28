import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ngz_flutter_ui/core/utils/utils.dart';
import 'package:ngz_flutter_ui/widgets/knob_button/knob_painter.dart';

class KnobButton extends HookWidget {
  final Widget? child;

  const KnobButton({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.unit,
    required this.onChanged,
    this.child,
    this.size = 100,
  });

  final double value;
  final double min;
  final double max;
  final double step;
  final String unit;
  final ValueChanged<double> onChanged;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final value = useState(50.0);

    return SizedBox(
      width: size,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          double minAngle = 135;
          double maxAngle = 45;

          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              value.value = computeValueFromThumb(
                details.localPosition,
                Size(w, h),
                minAngle,
                maxAngle,
              );

              if (value.value < min) {
                value.value = min;
              }
              if (value.value > max) {
                value.value = max;
              }
              onChanged(value.value);
            },
            child: CustomPaint(
              painter: KnobPainter(
                value.value,
                min,
                max,
                step,
                unit,
                minAngle,
                maxAngle,
                infiniteLoop: false,
              ),
              child: Container(
                child: Center(
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double computeValueFromThumb(
      Offset thumb, Size size, double minAngle, double maxAngle) {
    final polar = cartesianToPolar(thumb, size);
    var thetaR = polar.dy;

    if (thetaR > 0 && thetaR < pi / 2.0) {
      thetaR += kTwoPi;
    }

    final minAngleR = minAngle * pi / 180.0;
    final maxAngleR = maxAngle * pi / 180.0 + kTwoPi;

    if (thetaR > maxAngleR) {
      thetaR = maxAngleR;
    }

    if (thetaR < minAngleR) {
      thetaR = minAngleR;
    }

    final angleRangeR = maxAngleR - minAngleR;
    final unitsPerAngle = (max - min) / angleRangeR;

    return min + unitsPerAngle * (thetaR - minAngleR);
  }
}
