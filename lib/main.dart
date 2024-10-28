import 'package:dock_flutter/ui/dock_widget.dart';
import 'package:dock_flutter/ui/dock_widget_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: DockWidget(),
        ),
      ),
    );
  }
}
