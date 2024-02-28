import 'package:flutter/material.dart';
import 'package:ngz_flutter_ui/core/styles/styles.dart';

class SliderPoints extends StatelessWidget {
  final int itemCount;
  final int selectedIndex;
  final int? maxAllowedIndex;
  final double? size;
  final void Function(int index) onTap;
  final Color selectedColor;
  final Color unselectedColor;

  const SliderPoints({
    super.key,
    required this.itemCount,
    required this.onTap,
    required this.selectedIndex,
    this.maxAllowedIndex,
    this.size = 30,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final maxIndex = maxAllowedIndex ?? itemCount;
    return Wrap(
      spacing: 4,
      children: List.generate(
        itemCount,
        (index) => InkWell(
          onTap: () => index < maxIndex ? onTap(index) : null,
          child: Opacity(
            opacity: index < maxIndex ? 1 : 0.5,
            child: Container(
              height: 8,
              width: selectedIndex == index ? 28 : 8,
              decoration: BoxDecoration(
                // color: selectedIndex == index ? selectedColor : unselectedColor,
                shape: selectedIndex == index
                    ? BoxShape.rectangle
                    : BoxShape.circle,
                gradient: $styles.gradients.linearGradient,
                borderRadius:
                    selectedIndex == index ? BorderRadius.circular(4) : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
