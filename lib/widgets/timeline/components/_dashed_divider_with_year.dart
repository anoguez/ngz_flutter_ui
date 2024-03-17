part of '../timeline.dart';

class _DashedDividerWithYear extends StatelessWidget {
  const _DashedDividerWithYear(this.year, {super.key, this.yearGap = 1});
  final int year;
  final int yearGap;

  @override
  Widget build(BuildContext context) {
    final roundedYr = (year / yearGap).round() * yearGap;
    return Stack(
      children: [
        const Center(child: DashedLine()),
        Align(
          alignment: Alignment.centerRight,
          child: FractionalTranslation(
            translation: const Offset(0, -.5),
            child: MergeSemantics(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${roundedYr.abs()}',
                    style: $styles.text.title2.copyWith(
                        color: $styles.colors.white,
                        shadows: $styles.shadows.text),
                  ),
                  Gap($styles.insets.xs),
                  // TODO
                  // Text(
                  //   StringUtils.getYrSuffix(roundedYr),
                  //   style: $styles.text.body.copyWith(
                  //     color: Colors.white,
                  //     shadows: $styles.shadows.textStrong,
                  //   ),
                  // ),
                  // Gap($styles.insets.xs),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
