import 'package:flutter/material.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter_platform_interface.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Flyreel.initialize(FlyreelConfig(
      organizationId: "5d3633f9103a930011996475", settingsVersion: 4));
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
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text('Open Flyreel'),
            onPressed: () async {
              Flyreel.enableDebugLogging();
              Flyreel.open();

              // open with deeplink string
              // Flyreel.open(deeplinkUrl: "https://your.custom.url/?flyreelAccessCode=6M4T0T&flyreelZipCode=80212");

              // open with zipcode and access code
              // Flyreel.openWithCredentials(zipCode: "80212", accessCode: "6M4T0T", shouldSkipLoginPage: false);
            },
          ),
        ),
      ),
    );
  }
}
