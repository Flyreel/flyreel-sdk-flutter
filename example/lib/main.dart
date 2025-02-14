import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Flyreel with organizationId and settingsVersion
  await Flyreel.initialize(FlyreelConfig(
    organizationId: "your_organization_id",
  ));

  // show Flyreel logs
  Flyreel.enableLogs();

  // observe analytic events
  Flyreel.observeAnalyticEvents().listen((event) {
    debugPrint("event: ${event.toString()}");
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
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
                      accessCode: "779901",
                      shouldSkipLoginPage: false);
                },
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                child: const Text('Check status'),
                onPressed: () async {
                  // check status with zipcode and access code
                  try {
                    final result = await Flyreel.checkStatus(
                      zipCode: "80212",
                      accessCode: "779901",
                    );
                    _messengerKey.currentState?.showSnackBar(SnackBar(
                      content: Text("Status: ${result.status}, expires: ${result.expiration}"),
                    ));
                  } on PlatformException catch (e) {
                    _messengerKey.currentState?.showSnackBar(SnackBar(
                      content: Text("code: ${e.code}, message: ${e.message}"),
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
