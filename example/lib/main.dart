import 'package:flutter/material.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Flyreel with organizationId and settingsVersion
  await Flyreel.initialize(FlyreelConfig(
    organizationId: "your_organization_id",
    settingsVersion: 1,
  ));

  // show Flyreel logs
  Flyreel.enableLogs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flyreel plugin example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Open Flyreel'),
                onPressed: () async {
                  await Flyreel.open();
                },
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                child: const Text('Open Flyreel with URL'),
                onPressed: () async {
                  // open with deeplink string
                  await Flyreel.open(
                      deeplinkUrl:
                          "https://your.custom.url/?flyreelAccessCode=6M4T0T&flyreelZipCode=80212");
                },
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                child: const Text('Open Flyreel with credentials'),
                onPressed: () async {
                  // open with zipcode and access code
                  await Flyreel.openWithCredentials(
                      zipCode: "80212",
                      accessCode: "6M4T0T",
                      shouldSkipLoginPage: false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
