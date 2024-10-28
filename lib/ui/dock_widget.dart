import 'dart:ui';
import 'package:flutter/material.dart';

class DockWidget extends StatefulWidget {
  @override
  _DockWidgetState createState() => _DockWidgetState();
}

class _DockWidgetState extends State<DockWidget> {
  int? _hoveredIndex;
  int? _draggingIndex;
  IconData? _poppedIcon;

  // List of icons in the dock
  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.camera_alt,
    Icons.settings,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Blur container
        Positioned(
          bottom: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_icons.length, (index) {
                    return _buildDraggableIcon(index);
                  }),
                ),
              ),
            ),
          ),
        ),
        // Popped-out icon animation
        if (_poppedIcon != null)
          AnimatedAlign(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: _poppedIcon == null ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _poppedIcon,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDraggableIcon(int index) {
    return DragTarget<int>(
      onAccept: (draggedIndex) {
        setState(() {
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
              if (details.wasAccepted == false &&
                  (details.offset.dy <
                      MediaQuery.of(context).size.height - 100)) {
                _poppedIcon = _icons[index];
                Future.delayed(const Duration(milliseconds: 600), () {
                  setState(() {
                    _poppedIcon = null;
                  });
                });
              }
            });
          },
          feedback: Icon(
            _icons[index],
            color: Colors.white.withOpacity(0.7),
            size: 50,
          ),
          childWhenDragging: const SizedBox.shrink(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: _hoveredIndex == index || _draggingIndex == index ? 60 : 40,
            height: _hoveredIndex == index || _draggingIndex == index ? 60 : 40,
            child: Icon(
              _icons[index],
              color: Colors.white,
              size: _hoveredIndex == index || _draggingIndex == index ? 50 : 30,
            ),
          ),
        );
      },
    );
  }
}
