part of '../timeline.dart';

class TimelineSection extends StatelessWidget {
  const TimelineSection(
    this.data,
    this.selectedYr, {
    super.key,
    required this.selectedItem,
  });

  final TimelineItemData data;
  final int selectedYr;
  final ItemType? selectedItem;

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedItem == data.type;
    // get a fraction from 0 - 1 based on selected yr and start/end yr of the item
    // 500, 250, 750
    int startYr = data.startYr, endYr = data.endYr;
    double fraction = (selectedYr - startYr) / (endYr - startYr);
    fraction = fraction.clamp(0, 1);

    return Semantics(
      label: '${data.title}, ${StringUtils.timelineSemanticDate(
        StringUtils.formatYr(data.startYr),
        StringUtils.formatYr(data.endYr),
      )}',
      child: IgnorePointer(
        ignoringSemantics: false,
        child: Container(
          alignment: Alignment(0, -1 + fraction * 2),
          padding: EdgeInsets.all($styles.insets.xs),
          decoration: BoxDecoration(color: data.fgColor),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: BlendMask(
              blendModes: isSelected ? [] : const [BlendMode.luminosity],
              opacity: .6,
              child: _buildItemImage(),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildItemImage() {
    return Container(
      height: 100, // TODO param
      decoration: BoxDecoration(
        color: data.bgColor,
        image: data.assetName != null
            ? DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment(0, -.5),
                image: AssetImage(data.assetName!),
              )
            : null,
      ),
    );
  }
}
