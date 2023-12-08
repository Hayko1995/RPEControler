import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rpe_c/core/notifiers/authentication.notifer.dart';
import 'package:rpe_c/core/notifiers/cart.notifier.dart';
import 'package:rpe_c/core/notifiers/product.notifier.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/notifiers/size.notifier.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:rpe_c/core/notifiers/user.notifier.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ChangeNotifierProvider(create: (_) => AuthenticationNotifier()),
    ChangeNotifierProvider(create: (_) => UserNotifier()),
    ChangeNotifierProvider(create: (_) => ProductNotifier()),
    ChangeNotifierProvider(create: (_) => MeshNotifier()),
    ChangeNotifierProvider(create: (_) => SizeNotifier()),
    ChangeNotifierProvider(create: (_) => CartNotifier()),
  ];
}
