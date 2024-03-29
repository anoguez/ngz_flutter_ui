import 'package:example/ui/components/widget_list.dart';
import 'package:flutter/material.dart';
import 'package:ngz_flutter_ui/core/styles/styles.dart';
import 'package:ngz_flutter_ui/ngz_flutter_ui.dart';
import 'package:ngz_flutter_ui/widgets/timeline/data/timeline_item_data.dart';

class StoryBook extends StatelessWidget {
  const StoryBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                const Text(
                  "NGZ Storybook",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                WidgetList(
                  children: [
                    KnobButton(
                      value: 40,
                      min: 00,
                      max: 100,
                      step: 1,
                      unit: "BPM",
                      size: 240,
                      onChanged: (value) {},
                    ),
                    SliderPoints(
                      itemCount: 4,
                      onTap: (index) {},
                      selectedIndex: 0,
                      selectedColor: Colors.amber,
                      unselectedColor: Colors.grey,
                    ),
                    ImageCarousel(
                      initialIndex: 0,
                      pages: [
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.amber,
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.green,
                        )
                      ],
                    ),
                    GradientEffect(
                      gradient: $styles.gradients.linearGradient,
                      child: const Text("Gradient Text"),
                    ),
                    Timeline(
                      width: double.maxFinite,
                      height: 400,
                      items: [
                        TimelineItemData(
                          title: "Test 1",
                          startDate: DateTime(2013, DateTime.december, 23),
                          endDate: DateTime(2017, DateTime.april, 4),
                          bgColor: Colors.white,
                          fgColor: Colors.cyan,
                          line: ItemLine.first,
                        ),
                        TimelineItemData(
                          title: "Test 2",
                          startDate: DateTime(2017, DateTime.december, 23),
                          endDate: DateTime(2019, DateTime.april, 4),
                          bgColor: Colors.blue,
                          fgColor: Colors.greenAccent,
                          line: ItemLine.second,
                        ),
                        TimelineItemData(
                          title: "Test 3",
                          startDate: DateTime(2021, DateTime.december, 23),
                          endDate: DateTime(2022, DateTime.april, 4),
                          bgColor: Colors.amber,
                          fgColor: Colors.indigo,
                          line: ItemLine.third,
                        ),
                        TimelineItemData(
                          title: "Test 4",
                          startDate: DateTime(2022, DateTime.december, 23),
                          endDate: DateTime(2023, DateTime.april, 4),
                          bgColor: Colors.indigo,
                          fgColor: Colors.purple,
                          line: ItemLine.first,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
