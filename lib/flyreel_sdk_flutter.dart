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
    return FlyreelSdkFlutterPlatform.instance.checkStatus(zipCode: zipCode, accessCode: accessCode);
  }
}

/// Configuration for the Flyreel SDK.
///
/// This class contains parameters required to configure the Flyreel SDK,
/// including the organization ID, settings version, and environment.
class FlyreelConfig {
  /// The organization ID associated with the Flyreel configuration.
  final String organizationId;

  /// The version of the settings used by the Flyreel SDK.
  final int settingsVersion;

  /// The environment for the Flyreel SDK (production or sandbox).
  final FlyreelEnvironment environment;

  FlyreelConfig({
    required this.organizationId,
    required this.settingsVersion,
    this.environment = FlyreelEnvironment.production,
  });
}

/// Enum representing different environments for the Flyreel SDK.
///
/// The Flyreel SDK can operate in two environments: production and sandbox.
/// Use this enum to specify the desired environment for the SDK.
enum FlyreelEnvironment { production, sandbox }


/// Represents the status check for a Flyreel instance.
///
/// This class is used to encapsulate the status and expiration information
/// returned from a status check on a Flyreel instance. It includes two properties:
/// `status` and `expiration`.
class FlyreelCheckStatus {

  /// The status of the Flyreel.
  final String status;

  /// The expiration date for Flyreel.
  final String expiration;

  /// Creates a new instance of the [FlyreelCheckStatus] class.
  ///
  /// Requires [status] and [expiration] as parameters.
  FlyreelCheckStatus({
    required this.status,
    required this.expiration,
  });

  /// Creates a new instance of the [FlyreelCheckStatus] class from a map.
  ///
  /// This factory constructor allows for the creation of a [FlyreelCheckStatus] instance
  /// from a map. The map must contain 'status' and 'expiration' keys.
  factory FlyreelCheckStatus.fromMap(Map<String, dynamic> map) {
    return FlyreelCheckStatus(
      status: map['status'],
      expiration: map['expiration'],
    );
  }
}
