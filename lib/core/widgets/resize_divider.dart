import 'package:flutter/material.dart';

class ResizeDivider extends StatelessWidget {
  const ResizeDivider({
    super.key,
    required this.isHovering,
    required this.onHoverChanged,
    required this.onDragUpdate,
  });

  final bool isHovering;
  final ValueChanged<bool> onHoverChanged;
  final ValueChanged<double> onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (d) => onDragUpdate(d.delta.dx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 12,
          alignment: Alignment.center,
          child: VerticalDivider(
            width: 2,
            thickness: isHovering ? 3 : 1,
            color: isHovering
                ? Theme.of(context).colorScheme.primary.withAlpha(150)
                : Theme.of(context).dividerColor,
          ),
        ),
      ),
    );
  }
}
