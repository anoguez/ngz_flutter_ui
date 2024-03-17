part of '../timeline.dart';

class _AnimatedText extends StatelessWidget {
  const _AnimatedText(this.item);
  final TimelineItemData? item;

  @override
  Widget build(BuildContext context) {
    String era = item != null ? StringUtils.getExtendedTitle(item!) : '';
    final style = $styles.text.body.copyWith(color: $styles.colors.offWhite);
    return Semantics(
      liveRegion: true,
      child: Text(era, style: style),
    ).animate(key: ValueKey(era)).fadeIn().slide(begin: Offset(0, .2));
  }
}
