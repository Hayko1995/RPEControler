import 'package:flutter/material.dart';

class DragBox extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color itemColor;

  const DragBox(this.initPos, this.label, this.itemColor, {super.key});

  @override
  DragBoxState createState() => DragBoxState();
}

class DragBoxState extends State<DragBox> {
  Offset position = const Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Container(
        width: 100.0,
        height: 100.0,
        color: widget.itemColor,
        child: Center(
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
