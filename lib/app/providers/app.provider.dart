import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rpe_c/core/notifiers/authentication.notifier.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/notifiers/size.notifier.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ChangeNotifierProvider(create: (_) => AuthenticationNotifier()),
    ChangeNotifierProvider(create: (_) => MeshNotifier()),
    ChangeNotifierProvider(create: (_) => SizeNotifier()),
  ];
}
