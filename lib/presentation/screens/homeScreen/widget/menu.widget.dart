import 'package:flutter/material.dart';
import 'package:rpe_c/app/routes/app.routes.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [buildHeader(context), buildMenuItems(context)]),
        ),
      );
}

Widget buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    );
Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 3,
        children: [
          ListTile(
            leading: const Icon(Icons.qr_code_2),
            title: const Text("Add Device"),
            onTap: () => {
              Navigator.pop(context),
              Navigator.of(context).pushNamed(AppRouter.qrScanRoute)
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_to_photos_rounded),
            title: const Text("IP scanner"),
            onTap: () => {
              Navigator.pop(context),
              Navigator.of(context).pushNamed(AppRouter.ipScanRoute)
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => {},
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () => {
              Navigator.pop(context),
              Navigator.of(context).pushNamed(AppRouter.settingsRoute)
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("info"),
            onTap: () => {
              Navigator.pop(context),
              Navigator.of(context).pushNamed(AppRouter.meshCommandsRoute)
            },
          ),
        ],
      ),
    );
