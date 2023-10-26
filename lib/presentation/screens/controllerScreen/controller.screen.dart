import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.keys.dart';
import 'package:rpe_c/core/notifiers/user.notifier.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({Key? key}) : super(key: key);

  @override
  _ControllerScreenState createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  Color caughtColor = Colors.grey;

  @override
  void initState() {
    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    ReadCache.getString(key: AppKeys.userData).then(
      (token) => {
        userNotifier.getUserData(context: context, token: token),
      },
    );
    super.initState();
  }

  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  double _scale = 1.0;
  double _initialScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: GestureDetector(
        onScaleStart: (details) {
          _initialFocalPoint = details.focalPoint;
          _initialScale = _scale;
        },
        onScaleUpdate: (details) {
          setState(() {
            _sessionOffset = details.focalPoint - _initialFocalPoint;
            _scale = _initialScale * details.scale;
          });
        },
        onScaleEnd: (details) {
          setState(() {
            _offset += _sessionOffset;
            _sessionOffset = Offset.zero;
          });
        },
        child: Transform.translate(
          offset: _offset + _sessionOffset,
          child: Transform.scale(
            scale: _scale,
            child: Container(
              color: Colors.white,
              child: const Stack(
                children: <Widget>[
                  DragBox(Offset(0.0, 0.0), 'Box One', Colors.blueAccent),
                  DragBox(Offset(200.0, 0.0), 'Box Two', Colors.orange),
                  DragBox(Offset(300.0, 0.0), 'Box Three', Colors.lightGreen),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
        child: Draggable(
          data: widget.itemColor,
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
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              position = offset;
            });
          },
          feedback: Container(
            width: 120.0,
            height: 120.0,
            color: widget.itemColor.withOpacity(0.5),
            child: Center(
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ));
  }
}
