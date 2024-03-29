import 'package:collection/collection.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ngz_flutter_ui/core/extensions/collection_extension.dart';
import 'package:ngz_flutter_ui/core/styles/styles.dart';
import 'package:ngz_flutter_ui/widgets/timeline/data/timeline_item_data.dart';
import 'package:ngz_flutter_ui/widgets/timeline/timeline.dart';

/// Visualizes all of the items over time.
/// Distributes the items over multiple "tracks" so that they do not overlap.
/// Provides a builder, so the visual representation of each track entry can be customized
class ItemsTimelineBuilder extends StatelessWidget {
  const ItemsTimelineBuilder({
    super.key,
    this.selectedItems = const [],
    required this.items,
    this.timelineBuilder,
    this.axis = Axis.horizontal,
    this.crossAxisGap,
    this.minSize = 10,
    this.selectedItem,
  });

  final List<TimelineItemData> selectedItems; // TODO remove ?
  final List<TimelineItemData> items;
  final TimelineItemData? selectedItem;

  final Widget Function(BuildContext, TimelineItemData type, bool isSelected)?
      timelineBuilder;
  final Axis axis;
  final double? crossAxisGap;
  final double minSize;
  bool get isHz => axis == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final gap = crossAxisGap ?? $styles.insets.xs;
    // Depending on axis, we put all the items in a hz row, or vt column
    Widget wrapFlex(List<Widget> c) {
      c = c.map<Widget>((w) => Expanded(child: w)).toList();
      return isHz
          ? SeparatedColumn(
              verticalDirection: VerticalDirection.up,
              separatorBuilder: () => Gap(gap),
              children: c,
            )
          : SeparatedRow(separatorBuilder: () => Gap(gap), children: c);
    }

    return LayoutBuilder(builder: (_, constraints) {
      /// Builds one timeline track, may contain multiple items, but they should not overlap
      Widget buildSingleTimelineTrack(
        BuildContext context,
        // List<ItemLine> itemLines,
        List<TimelineItemData> itemLines,
      ) {
        return Stack(
          clipBehavior: Clip.none,
          children: itemLines.map(
            (t) {
              final data = items.firstWhereOrNull((item) => item == t);
              if (data == null) {
                return SizedBox();
              }

              var (minYear, maxYear) = items.findMinMax;

              int totalYrs = maxYear - minYear;

              double pxToYrRatio = totalYrs /
                  ((isHz ? constraints.maxWidth : constraints.maxHeight));
              // Now we just need to calculate year spans, and then convert them to pixels for the start/end position in the Stack
              int itemYrs = data.endYear - data.startYear;
              int yrsFromStart = data.startYear - items.minYear;
              double startPx = yrsFromStart / pxToYrRatio;
              double sizePx = itemYrs / pxToYrRatio;
              if (sizePx < minSize) {
                double yearDelta = ((minSize - sizePx) / 2);
                sizePx = minSize;
                startPx -= yearDelta;
              }
              final isSelected = selectedItems.contains(data);
              final child = timelineBuilder?.call(context, data, isSelected) ??
                  _DefaultTrackEntry(isSelected: isSelected);
              return isHz
                  ? Positioned(
                      left: startPx,
                      width: sizePx,
                      top: 0,
                      bottom: 0,
                      child: child)
                  : Positioned(
                      top: startPx,
                      height: sizePx,
                      left: 0,
                      right: 0,
                      child: child,
                    );
            },
          ).toList(),
        );
      }

      return wrapFlex([
        // Track 1
        buildSingleTimelineTrack(
          context,
          items.where((item) => item.line == ItemLine.first).toList(),
        ),
        // Track 2
        buildSingleTimelineTrack(
          context,
          items.where((item) => item.line == ItemLine.second).toList(),
        ),
        // Track 3
        buildSingleTimelineTrack(
          context,
          items.where((item) => item.line == ItemLine.third).toList(),
        ),
      ]);
    });
  }
}

class _DefaultTrackEntry extends StatelessWidget {
  const _DefaultTrackEntry({required this.isSelected});
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? $styles.colors.marker2 : Colors.transparent,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: $styles.colors.marker2),
      ),
    );
  }
}
