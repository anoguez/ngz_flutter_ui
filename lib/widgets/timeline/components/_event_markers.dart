part of '../timeline.dart';

/// A vertically aligned stack of dots that represent global events
/// The event closest to the [selectedYr] param will be visible selected
class _EventMarkers extends StatefulWidget {
  const _EventMarkers(
    this.selectedYr, {
    super.key,
    required this.onEventChanged,
    required this.onMarkerPressed,
    required this.items,
  });

  final void Function(TimelineItemData? event) onEventChanged;
  final void Function(TimelineItemData event) onMarkerPressed;
  final int selectedYr;
  final List<TimelineItemData> items;

  @override
  State<_EventMarkers> createState() => _EventMarkersState();
}

class _EventMarkersState extends State<_EventMarkers> {
  bool get showReferenceMarkers => kDebugMode;
  int get startYr => widget.items.minYear;

  int get endYr => widget.items.maxYear;

  late final int _totalYrs = endYr - startYr;

  TimelineItemData? selectedEvent;

  /// Normalizes a given year to a value from 0 - 1, based on start and end yr.
  double _calculateOffsetY(int yr) => (yr - startYr) / _totalYrs;

  /// Loops through the global events, and does a px-based check to see whether
  /// one of them should be selected  (as oppose to year-based proximity).
  /// This ensures consistent UX at different zoom levels.
  void _updateSelectedEvent(double maxPxHeight) {
    final allEvents = widget.items; // TODO
    const double minDistance = 10;
    TimelineItemData? closestEvent;
    double closestDistance = double.infinity;
    // Convert current yr to a px position
    double currentYearPx = _calculateOffsetY(widget.selectedYr) * maxPxHeight;
    for (var e in allEvents) {
      // Convert both the event.yr to px, and compare with currentYearPx
      double eventPx = _calculateOffsetY(e.startYear) * maxPxHeight;
      double d = (eventPx - currentYearPx).abs();
      // Keep the closest event that is within minDistance
      if (d <= minDistance && d < closestDistance) {
        closestEvent = e;
        closestDistance = d;
      }
    }
    // Dispatch if event has actually changed since last time
    if (closestEvent != selectedEvent) {
      scheduleMicrotask(() => widget.onEventChanged(closestEvent));
    }
    selectedEvent = closestEvent;
  }

  @override
  Widget build(BuildContext context) {
    final allEvents = widget.items;
    return IgnorePointer(
      ignoringSemantics: false,
      child: LayoutBuilder(builder: (_, constraints) {
        /// Figure out which event is "selected"
        _updateSelectedEvent(constraints.maxHeight);

        /// Create a marker for each event
        List<Widget> markers = allEvents.map((event) {
          double offsetY = _calculateOffsetY(event.startYear);
          return _EventMarker(
            offsetY,
            event: event,
            isSelected: event == selectedEvent,
            onPressed: widget.onMarkerPressed,
          );
        }).toList();

        /// Stack of fractionally positioned markers
        return FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 75),
            child: SizedBox(
              width: 20,
              child: Stack(
                children: [
                  ...markers,
                  if (showReferenceMarkers) ..._buildReferenceMarkers(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _buildReferenceMarkers() {
    final marker =
        Container(color: Colors.red.withOpacity(.4), width: 10, height: 10);
    return [
      Align(
        alignment: Alignment.topCenter,
        child:
            FractionalTranslation(translation: Offset(0, -.5), child: marker),
      ),
      Align(alignment: Alignment.center, child: marker),
      Align(
        alignment: Alignment.bottomCenter,
        child: FractionalTranslation(translation: Offset(0, .5), child: marker),
      ),
    ];
  }
}

/// A dot that represents a single global event.
/// Animated to a selected state which is is larger in size.
class _EventMarker extends StatelessWidget {
  const _EventMarker(
    this.offset, {
    super.key,
    required this.isSelected,
    required this.event,
    required this.onPressed,
  });
  final double offset;
  final TimelineItemData event;
  final bool isSelected;
  final void Function(TimelineItemData event) onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, -1 + offset * 2),
      // Use an OverflowBox wrapped in a zero-height sized box so that al
      // This allows alignment-based positioning to be accurate even at the edges of the parent.
      child: SizedBox(
        height: 0,
        child: OverflowBox(
          maxHeight: 30,
          child: AppBtn.basic(
            semanticLabel: '${event.startYear}: ${event.title}',
            onPressed: () => onPressed(event),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              child: AnimatedContainer(
                width: isSelected ? 6 : 2,
                height: isSelected ? 6 : 2,
                curve: Curves.easeOutBack,
                duration: $styles.times.med,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: $styles.colors.marker,
                  boxShadow: [
                    BoxShadow(
                        color: $styles.colors.marker
                            .withOpacity(isSelected ? .5 : 0),
                        spreadRadius: 3,
                        blurRadius: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
