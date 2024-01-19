import 'flyreel_sdk_flutter_platform_interface.dart';

class Flyreel {

  static Future initialize(FlyreelConfig config) async {
    return FlyreelSdkFlutterPlatform.instance.initialize(config);
  }

  static Future open() async {
    return FlyreelSdkFlutterPlatform.instance.open();
  }

  static Future enableDebugLogging() async {
    return FlyreelSdkFlutterPlatform.instance.enableDebugLogging();
  }
}
