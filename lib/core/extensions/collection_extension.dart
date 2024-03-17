// TODO
import 'package:ngz_flutter_ui/widgets/timeline/data/timeline_item_data.dart';

extension CollectionExtension on List<TimelineItemData> {
  (int, int) get findMinMax {
    if (isEmpty) {
      throw ArgumentError('List must not be empty');
    }

    int minYear = first.startYr;
    int maxYear = first.endYr;

    for (var item in this) {
      if (item.startYr < minYear) {
        minYear = item.startYr;
      }
      if (item.endYr > maxYear) {
        maxYear = item.endYr;
      }
    }

    return (minYear, maxYear);
  }

  int get minYear => reduce((currentMin, item) =>
      item.startYr < currentMin.startYr ? item : currentMin).startYr;

  int get maxYear => reduce((currentMax, item) =>
      item.endYr > currentMax.endYr ? item : currentMax).endYr;
}
