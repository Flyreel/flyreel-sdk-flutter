import 'package:flyreel_sdk_flutter/flyreel_sdk_models.dart';
import 'flyreel_sdk_flutter_platform_interface.dart';

/// A class that provides methods to interact with the Flyreel SDK.
class Flyreel {
  /// Initializes the Flyreel SDK with the specified configuration.
  ///
  /// Returns a [Future] that completes when the initialization is complete.
  static Future initialize(FlyreelConfig config) async {
    return FlyreelSdkFlutterPlatform.instance.initialize(config);
  }

  /// Opens the Flyreel SDK.
  ///
  /// Optionally accepts a [deeplinkUrl] for deep linking and specifies
  /// whether to skip the login page ([shouldSkipLoginPage]).
  ///
  /// Returns a [Future] that completes when the operation is complete.
  static Future open(
      {String? deeplinkUrl, bool shouldSkipLoginPage = true}) async {
    return FlyreelSdkFlutterPlatform.instance.open(
        deeplinkUrl: deeplinkUrl, shouldSkipLoginPage: shouldSkipLoginPage);
  }

  /// Opens the Flyreel SDK with the specified credentials.
  ///
  /// Requires [zipCode], [accessCode], and specifies whether to skip
  /// the login page ([shouldSkipLoginPage]).
  ///
  /// Returns a [Future] that completes when the operation is complete.
  static Future openWithCredentials(
      {required String zipCode,
      required String accessCode,
      bool shouldSkipLoginPage = true}) async {
    return FlyreelSdkFlutterPlatform.instance.openWithCredentials(
        zipCode: zipCode,
        accessCode: accessCode,
        shouldSkipLoginPage: shouldSkipLoginPage);
  }

  /// Enables logging for the Flyreel SDK.
  ///
  /// Returns a [Future] that completes when logging is enabled.
  static Future enableLogs() async {
    return FlyreelSdkFlutterPlatform.instance.enableLogs();
  }

  /// Check status for zipcode/accessCode combination.
  ///
  /// Returns a [Future] that completes when logging is enabled.
  static Future<FlyreelCheckStatus> checkStatus({
    required String zipCode,
    required String accessCode,
  }) async {
    return FlyreelSdkFlutterPlatform.instance
        .checkStatus(zipCode: zipCode, accessCode: accessCode);
  }

  static Stream<FlyreelAnalyticEvent> observeAnalyticEvents() {
    return FlyreelSdkFlutterPlatform.instance.observeAnalyticStream();
  }
}
