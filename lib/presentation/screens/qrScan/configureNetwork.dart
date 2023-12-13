//TODO fix responsively of page
//TODO add values to DB
//TODO read mDNS https://pub.dev/documentation/nsd/latest/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.colors.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/widgets/dimensions.widget.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:rpe_c/presentation/widgets/custom.text.field.dart';

class ConfigureNetworkScreen extends StatefulWidget {
  const ConfigureNetworkScreen(
      {super.key, required this.networkConfigArguments});

  final NetworkConfigArgs networkConfigArguments;

  @override
  State<ConfigureNetworkScreen> createState() => _ConfigureNetworkState();
}

class _ConfigureNetworkState extends State<ConfigureNetworkScreen> {
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPassController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = themeNotifier.darkTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
                          child: CustomTextField.customTextField(
                            textEditingController: userEmailController,
                            hintText: 'Enter SSID',
                          ),
                        ),
                        vSizedBox1,
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
                          child: CustomTextField.customTextField(
                            textEditingController: userPassController,
                            hintText: 'Enter a password',
                            validator: (val) =>
                                val!.isEmpty ? 'Enter a password' : null,
                          ),
                        )
                      ],
                    ),
                  ),
                  vSizedBox2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        height: MediaQuery.of(context).size.height * 0.05,
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () async {
                          _databaseService.insertNetwork(Network(
                              mac: widget.networkConfigArguments.mac,
                              ip: widget.networkConfigArguments.ip));

                          Navigator.of(context)
                              .pushReplacementNamed(AppRouter.HomeRoute);

                          //TODO write host to db
                          //TODO need to config ESP32
                        },
                        color: AppColors.rawSienna,
                        child: const Text(
                          'Use in standalone ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      MaterialButton(
                        height: MediaQuery.of(context).size.height * 0.05,
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () async {
                          _databaseService.insertNetwork(Network(
                              mac: widget.networkConfigArguments.mac,
                              ip: widget.networkConfigArguments.ip));
                        },
                        color: AppColors.rawSienna,
                        child: const Text(
                          'Connect to router',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkConfigArgs {
  final String mac;
  final String ip;

  const NetworkConfigArgs({required this.mac, required this.ip});
}
