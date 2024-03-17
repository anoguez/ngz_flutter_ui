import 'package:ngz_flutter_ui/core/utils/string_utils.dart';
import 'package:ngz_flutter_ui/widgets/timeline/data/timeline_item_data.dart';

class TimelineEvent {
  TimelineEvent(this.year, this.description);
  final int year;
  final String description;
}

// TODO
class GlobalEventsData {
  final globalEvents = [
    // TimelineEvent(2013, "Test"),
    // TimelineEvent(2014, "Test"),
    TimelineEvent(2015, "Test"),
    // TimelineEvent(2017, "Test"),
    // TimelineEvent(2018, "Test"),
    // TimelineEvent(2019, "Test"),
    // TimelineEvent(2020, "Test"),
    // TimelineEvent(2022, "Test"),
  ];
}

class TimelineConstants {
  // static final int timelineStartYear = 2010; // TODO min from items
  // static final int timelineEndYear = 2025; // TODO max from items

  static List<TimelineEvent> getAllTimelineEvents(List<TimelineItemData> all) =>
      [
        ...GlobalEventsData().globalEvents,
        ...all.map(
          (w) => TimelineEvent(
            w.startYr,
            StringUtils.timelineLabelConstruction(w.title), // TODO
          ),
        )
      ];
}
