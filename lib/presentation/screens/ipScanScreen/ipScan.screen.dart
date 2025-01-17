import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ipScanScreen extends StatefulWidget {
  const ipScanScreen({Key? key}) : super(key: key);

  @override
  State<ipScanScreen> createState() => _ipScanScreenState();
}

class _ipScanScreenState extends State<ipScanScreen> {
  final List<Host> _hosts = <Host>[];
  double? progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('lan Scanner'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton(
                      onPressed: () async {
                        setState(() {
                          progress = 0.0;
                          _hosts.clear();
                        });

                        final scanner = LanScanner(debugLogging: true);
                        final stream = scanner.icmpScan(
                          ipToCSubnet(await NetworkInfo().getWifiIP() ?? ''),
                          scanThreads: 20,
                          progressCallback: (newProgress) {
                            setState(() {
                              progress = newProgress;
                            });
                          },
                        );

                        stream.listen((Host host) {
                          setState(() {
                            _hosts.add(host);
                          });
                        });
                      },
                      child: const Text('Scan'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        setState(() {
                          progress = null;
                          _hosts.clear();
                        });

                        final scanner = LanScanner(debugLogging: true);
                        final hosts = await scanner.quickIcmpScanSync(
                          ipToCSubnet(await NetworkInfo().getWifiIP() ?? ''),
                        );

                        setState(() {
                          _hosts.addAll(hosts);
                          progress = 1.0;
                        });
                      },
                      child: const Text('Quick scan sync'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        setState(() {
                          progress = null;
                          _hosts.clear();
                        });

                        final scanner = LanScanner(debugLogging: true);
                        final hosts = await scanner.quickIcmpScanAsync(
                          ipToCSubnet(await NetworkInfo().getWifiIP() ?? ''),
                        );

                        setState(() {
                          _hosts.addAll(hosts);
                          progress = 1.0;
                        });
                      },
                      child: const Text('Quick scan async'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _hosts.length,
                  itemBuilder: (context, index) {
                    final host = _hosts[index];
                    final address = host.internetAddress.address;
                    final time = host.pingTime;

                    return Card(
                      child: ListTile(
                        title: Text(address),
                        trailing: Text(time != null ? time.toString() : 'N/A'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
