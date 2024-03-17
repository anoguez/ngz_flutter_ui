import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomExpansionPanel extends HookWidget {
  final String label;
  final Widget child;

  const CustomExpansionPanel({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = useState(false);
    final expandController =
        useAnimationController(duration: const Duration(milliseconds: 200));
    final rotateController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      initialValue: 0.0,
      lowerBound: 0.0,
      upperBound: 0.5,
    );

    useEffect(() {
      if (isOpen.value) {
        expandController.forward();
        rotateController.forward();
        return;
      }

      expandController.reverse();
      rotateController.reverse();

      return null;
    });

    return Column(
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label),
                    GestureDetector(
                      onTap: () => isOpen.value = !isOpen.value,
                      child: RotationTransition(
                        turns: rotateController,
                        child: const Icon(Icons.expand_more),
                      ),
                    ),
                  ],
                ),
              ),
              // CONTENT
              SizeTransition(
                sizeFactor: expandController,
                child: Container(
                  color: Colors.grey.withOpacity(0.2),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
