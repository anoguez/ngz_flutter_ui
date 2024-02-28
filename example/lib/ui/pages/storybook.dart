import 'package:flutter/material.dart';
import 'package:ngz_flutter_ui/core/styles/styles.dart';
import 'package:ngz_flutter_ui/ngz_flutter_ui.dart';

class StoryBook extends StatelessWidget {
  const StoryBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                height: 30,
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
                    child: Text("Gradient Text"),
                    gradient: $styles.gradients.linearGradient,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetList extends StatelessWidget {
  final List<Widget> children;

  const WidgetList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          ...List.generate(
            children.length,
            (index) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${children[index].runtimeType}"),
                    const SizedBox(
                      width: 20,
                    ),
                    children[index],
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
