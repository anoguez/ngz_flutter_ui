import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ngz_flutter_ui/core/styles/styles.dart';
import 'package:ngz_flutter_ui/widgets/slider_points.dart';
import 'package:ngz_flutter_ui/widgets/swipe_detector.dart';

class ImageCarousel extends HookWidget {
  final int initialIndex;
  final int? maxAllowedIndex;
  final List<Widget> pages;
  final Function(int index)? onPageChanged;

  const ImageCarousel({
    super.key,
    this.maxAllowedIndex,
    required this.pages,
    this.initialIndex = 0,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: initialIndex);
    final selectedIndex = useState(initialIndex);
    const animationDuration = Duration(milliseconds: 400);

    return SizedBox(
      width: double.maxFinite,
      height: 160,
      child: Stack(
        children: [
          SwipeDetector(
            onSwipeLeft: () {
              if (selectedIndex.value == maxAllowedIndex) return;
              pageController.animateToPage(
                selectedIndex.value + 1,
                duration: animationDuration,
                curve: Curves.easeIn,
              );
            },
            onSwipeRight: () {
              if (selectedIndex.value == 0) return;
              pageController.animateToPage(
                selectedIndex.value - 1,
                duration: animationDuration,
                curve: Curves.easeIn,
              );
            },
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
              onPageChanged: (value) {
                selectedIndex.value = value;

                if (onPageChanged != null) {
                  onPageChanged!(selectedIndex.value);
                }
              },
            ),
          ),
          Positioned(
            bottom: 10,
            right: 16,
            child: SliderPoints(
              selectedColor: $styles.colors.accent1,
              unselectedColor: Theme.of(context).colorScheme.secondary,
              itemCount: pages.length,
              maxAllowedIndex: maxAllowedIndex ?? pages.length,
              selectedIndex: selectedIndex.value,
              onTap: (index) {
                selectedIndex.value = index;
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
