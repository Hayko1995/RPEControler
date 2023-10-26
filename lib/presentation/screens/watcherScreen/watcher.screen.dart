import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.keys.dart';
import 'package:rpe_c/core/notifiers/user.notifier.dart';
import 'package:rpe_c/presentation/screens/controllerScreen/controller.screen.dart';
import 'package:rpe_c/presentation/widgets/temperature.widget.dart';

class WatcherScreen extends StatefulWidget {
  const WatcherScreen({Key? key}) : super(key: key);

  @override
  _WatcherScreenState createState() => _WatcherScreenState();
}

class _WatcherScreenState extends State<WatcherScreen> {
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
                  DragBox(Offset(0.0, 10.0), 'Box One', Colors.blueAccent),
                  DragBox(Offset(200.0, 30.0), 'Box Two', Colors.orange),
                  DragBox(Offset(300.0, 50.0), 'Box Three', Colors.lightGreen),
                  Temperature(
                      Offset(200.0, 200.0), 'Box Three', Colors.lightGreen),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
