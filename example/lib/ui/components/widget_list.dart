import 'package:flutter/material.dart';
import 'package:ngz_flutter_ui/widgets/custom_expansion_panel.dart';

class WidgetList extends StatelessWidget {
  final List<Widget> children;

  const WidgetList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...List.generate(
          children.length,
          (index) => CustomExpansionPanel(
            label: children[index].runtimeType.toString(),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(child: children[index]),
            ),
          ),
        )
      ],
    );
  }
}
