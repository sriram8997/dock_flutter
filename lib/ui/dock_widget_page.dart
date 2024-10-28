import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DockWidgetPage extends StatefulWidget {
  const DockWidgetPage({super.key});

  @override
  State<DockWidgetPage> createState() => _DockWidgetPageState();
}

class _DockWidgetPageState extends State<DockWidgetPage> {
  int? _hoveredIndex;
  int? _draggingIndex;
  final List<IconData> _icons = [
    Icons.home_sharp,
    Icons.search,
    Icons.camera_alt,
    Icons.settings_sharp
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_icons.length, (index) {
          return DragTarget<int>(
            onAccept: (draggedIndex) {
              setState(() {
                // Swap the icons when one is dropped on another
                final temp = _icons[draggedIndex];
                _icons[draggedIndex] = _icons[index];
                _icons[index] = temp;
              });
            },
            onWillAccept: (draggedIndex) {
              setState(() {
                _hoveredIndex = index;
              });
              return true;
            },
            onLeave: (data) {
              setState(() {
                _hoveredIndex = null;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Draggable<int>(
                data: index,
                onDragStarted: () {
                  setState(() {
                    _draggingIndex = index;
                  });
                },
                onDragEnd: (details) {
                  setState(() {
                    _draggingIndex = null;
                    _hoveredIndex = null;
                  });
                },
                feedback: Icon(
                  _icons[index],
                  color: Colors.white.withOpacity(0.7),
                  size: 50,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: _hoveredIndex == index || _draggingIndex == index
                      ? 60
                      : 40,
                  height: _hoveredIndex == index || _draggingIndex == index
                      ? 60
                      : 40,
                  child: Icon(
                    _icons[index],
                    color: Colors.white,
                    size: _hoveredIndex == index || _draggingIndex == index
                        ? 50
                        : 30,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
