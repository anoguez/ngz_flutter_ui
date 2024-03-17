// TODO
import 'package:ngz_flutter_ui/widgets/timeline/data/timeline_item_data.dart';

extension CollectionExtension on List<TimelineItemData> {
  (int, int) get findMinMax {
    if (isEmpty) {
      throw ArgumentError('List must not be empty');
    }

    int minYear = first.startYear;
    int maxYear = first.endYear;

    for (var item in this) {
      if (item.startYear < minYear) {
        minYear = item.startYear;
      }
      if (item.endYear > maxYear) {
        maxYear = item.endYear;
      }
    }

    return (minYear, maxYear);
  }

  int get minYear => reduce((currentMin, item) =>
      item.startYear < currentMin.startYear ? item : currentMin).startYear;

  int get maxYear => reduce((currentMax, item) =>
      item.endYear > currentMax.endYear ? item : currentMax).endYear;
}
