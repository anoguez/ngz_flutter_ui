import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ngz_flutter_ui/ngz_flutter_ui.dart';

class TimelineItemData extends Equatable {
  const TimelineItemData({
    required this.title,
    required this.type,
    this.startYr = 0,
    this.endYr = 0,
    this.fgColor = Colors.red,
    this.bgColor = Colors.green,
    this.assetName,
  });

  final String title;
  final ItemType type;
  final int startYr;
  final int endYr;
  final Color? fgColor;
  final Color? bgColor;
  final String? assetName;

  @override
  // TODO: implement props
  List<Object?> get props => [title, type];
}
