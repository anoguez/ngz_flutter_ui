import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ngz_flutter_ui/widgets/timeline/timeline.dart';

class TimelineItemData extends Equatable {
  const TimelineItemData({
    required this.title,
    required this.line,
    required this.startDate,
    this.endDate,
    this.fgColor = Colors.red,
    this.bgColor = Colors.green,
    this.assetName,
  });

  final String title;
  final ItemLine line;
  final DateTime startDate;
  final DateTime? endDate;
  final Color? fgColor;
  final Color? bgColor;
  final String? assetName;

  @override
  List<Object?> get props => [title, line];

  int get startYear => startDate.year;
  int get endYear => endDate?.year ?? DateTime.now().year;
}
