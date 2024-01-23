import 'flyreel_sdk_flutter_platform_interface.dart';

class Flyreel {
  static Future initialize(FlyreelConfig config) async {
    return FlyreelSdkFlutterPlatform.instance.initialize(config);
  }

  static Future open(
      {String? deeplinkUrl, bool shouldSkipLoginPage = true}) async {
    return FlyreelSdkFlutterPlatform.instance.open(
        deeplinkUrl: deeplinkUrl, shouldSkipLoginPage: shouldSkipLoginPage);
  }

  static Future openWithCredentials(
      {required String zipCode,
      required String accessCode,
      bool shouldSkipLoginPage = true}) async {
    return FlyreelSdkFlutterPlatform.instance.openWithCredentials(
        zipCode: zipCode,
        accessCode: accessCode,
        shouldSkipLoginPage: shouldSkipLoginPage);
  }

  static Future enableDebugLogging() async {
    return FlyreelSdkFlutterPlatform.instance.enableDebugLogging();
  }
}
