import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:ngz_flutter_ui/core/extensions/collection_extension.dart';
import 'package:ngz_flutter_ui/core/extensions/sized_context.dart';
import 'package:ngz_flutter_ui/core/styles/styles.dart';
import 'package:ngz_flutter_ui/core/utils/app_haptics.dart';
import 'package:ngz_flutter_ui/core/utils/blend_mask.dart';
import 'package:ngz_flutter_ui/core/utils/debouncer.dart';
import 'package:ngz_flutter_ui/core/utils/string_utils.dart';
import 'package:ngz_flutter_ui/widgets/buttons.dart';
import 'package:ngz_flutter_ui/widgets/centered_box.dart';
import 'package:ngz_flutter_ui/widgets/dashed_line.dart';
import 'package:ngz_flutter_ui/widgets/list_gradient.dart';
import 'package:ngz_flutter_ui/widgets/timeline/components/items_timeline_builder.dart';
import 'package:ngz_flutter_ui/widgets/timeline/data/timeline_item_data.dart';
import 'package:ngz_flutter_ui/widgets/timeline/timeline_event_card.dart';

part 'components/_scrolling_viewport_controller.dart';
part 'components/_dashed_divider_with_year.dart';
part 'components/_timeline_section.dart';
part 'components/_year_markers.dart';
part 'components/_event_markers.dart';
part 'components/_animated_text.dart';
part 'components/_event_popups.dart';

enum ItemLine {
  first,
  second,
  third,
}

class Timeline extends HookWidget {
  const Timeline({
    super.key,
    required this.items,
    this.width,
    this.height,
  });

  final List<TimelineItemData> items;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final scroller = useScrollController();
    final year = useState(0);
    final currentItem = useState<TimelineItemData?>(null);

    final handleViewportYearChanged = useCallback((int value) {
      year.value = value;
    }, []);

    final handleItemChanged = useCallback((TimelineItemData? value) {
      if (value == null) return;
      currentItem.value = value;
    }, []);

    /// Vertically scrolling timeline, manages a ScrollController.
    return SizedBox(
      width: width,
      height: height,
      child: LayoutBuilder(builder: (_, constraints) {
        // Determine min and max size of the timeline based on the size available to this widget
        const double minSize = 1200;
        const double maxSize = 5500;

        return Container(
          color: $styles.colors.backgroundMain,
          child: Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Column(
              children: [
                Expanded(
                  child: _ScrollingViewport(
                    items: items,
                    scroller: scroller,
                    minSize: minSize,
                    maxSize: maxSize,
                    selectedItem: currentItem.value,
                    onYearChanged: handleViewportYearChanged,
                    onItemChanged: handleItemChanged,
                  ),
                ),

                /// Era Text (classical, modern etc)
                ValueListenableBuilder<int>(
                  valueListenable: year,
                  builder: (_, value, __) =>
                      _AnimatedText(currentItem.value), // TODO
                ),
                Gap($styles.insets.xs),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ScrollingViewport extends StatefulWidget {
  const _ScrollingViewport({
    super.key,
    // ignore: unused_element
    this.onInit,
    required this.scroller,
    required this.minSize,
    required this.maxSize,
    required this.selectedItem,
    this.onYearChanged,
    required this.onItemChanged,
    required this.items,
  });
  final double minSize;
  final double maxSize;
  final ScrollController scroller;
  final TimelineItemData? selectedItem;
  final List<TimelineItemData> items;
  final void Function(int year)? onYearChanged;
  final void Function(TimelineItemData? timelineItem) onItemChanged;
  final void Function(_ScrollingViewportController controller)? onInit;

  @override
  State<_ScrollingViewport> createState() => _ScalingViewportState();
}

class _ScalingViewportState extends State<_ScrollingViewport> {
  late final _ScrollingViewportController controller =
      _ScrollingViewportController(
    state: this,
    items: widget.items,
  );
  static const double _minTimelineSize = 100;
  final _currentEventMarker = ValueNotifier<TimelineItemData?>(null);
  Size? _prevSize;

  @override
  void initState() {
    super.initState();
    controller.init();
    widget.onInit?.call(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleEventMarkerChanged(TimelineItemData? event) {
    _currentEventMarker.value = event; // TODO check later
    widget.onItemChanged(event);
    AppHaptics.selectionClick();
  }

  void _handleMarkerPressed(event) {
    final pos = controller.calculateScrollPosFromYear(event.year);
    controller.scroller.animateTo(
      pos,
      duration: $styles.times.med,
      curve: Curves.easeOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_prevSize != null && _prevSize != context.mq.size) {
      scheduleMicrotask(controller._handleResize);
    }
    _prevSize = context.mq.size;
    return GestureDetector(
      // Handle pinch to zoom
      onScaleUpdate: controller._handleScaleUpdate,
      onScaleStart: controller._handleScaleStart,
      behavior: HitTestBehavior.translucent,
      // Fade in entire view when first shown
      child: Stack(
        children: [
          // Main content area
          _buildScrollingArea(context).animate().fadeIn(),

          // Dashed line with a year that changes as we scroll
          IgnorePointer(
            ignoringSemantics: false,
            child: AnimatedBuilder(
              animation: controller.scroller,
              builder: (_, __) {
                return _DashedDividerWithYear(
                  controller.calculateYearFromScrollPos(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollingArea(BuildContext context) {
    // Builds a TimelineSection, and passes it the currently selected yr based on scroll position.
    // Rebuilds when timeline is scrolled.
    Widget buildTimelineSection(TimelineItemData data) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: AnimatedBuilder(
          animation: controller.scroller,
          builder: (_, __) => TimelineSection(
            data,
            controller.calculateYearFromScrollPos(),
            selectedItem: widget.selectedItem,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (_, constraints) {
        // cache constraints, so they can be used to maintain the selected year while zooming
        controller._constraints = constraints;
        double vtPadding = constraints.maxHeight / 2;
        double height = controller.calculateContentHeight();
        final width = min($styles.sizes.maxContentWidth2, constraints.maxWidth);
        return Stack(
          children: [
            SingleChildScrollView(
              controller: controller.scroller,
              padding: EdgeInsets.symmetric(vertical: vtPadding),
              // A stack inside a SizedBox which sets its overall height
              child: CenteredBox(
                height: height,
                width: width,
                child: Stack(
                  children: [
                    /// Year Markers
                    _YearMarkers(
                      timelineStartYear: widget.items.minYear,
                      timelineEndYear: widget.items.maxYear,
                    ),

                    /// individual timeline sections
                    Positioned.fill(
                      left: 100,
                      right: $styles.insets.sm,
                      child: FocusTraversalGroup(
                        //child: Placeholder(),
                        child: ItemsTimelineBuilder(
                          items: widget.items,
                          selectedItem: widget.selectedItem,
                          axis: Axis.vertical,
                          crossAxisGap: max(6, (width - (120 * 3)) / 2),
                          minSize: _minTimelineSize,
                          timelineBuilder: (_, data, __) =>
                              buildTimelineSection(data),
                        ),
                      ),
                    ),

                    /// Event Markers, rebuilds on scroll
                    AnimatedBuilder(
                      animation: controller.scroller,
                      builder: (_, __) => _EventMarkers(
                        items: widget.items,
                        controller.calculateYearFromScrollPos(),
                        onEventChanged: _handleEventMarkerChanged,
                        onMarkerPressed: _handleMarkerPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Top and bottom gradients for visual style
            ListOverscollGradient(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListOverscollGradient(bottomUp: true),
            ),

            /// Event Popups, rebuilds when [_currentEventMarker] changes
            ValueListenableBuilder<TimelineItemData?>(
              valueListenable: _currentEventMarker,
              builder: (_, data, __) {
                return _EventPopups(currentEvent: data);
              },
            )
          ],
        );
      },
    );
  }
}
