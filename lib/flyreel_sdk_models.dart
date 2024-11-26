import 'package:flutter/widgets.dart';

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

/// Annotation to indicate internal API usage.
@immutable
class FlyreelInternalApi {
  final String message;
  final Level level;

  const FlyreelInternalApi(
      {this.message = "Only for Flyreel internal use",
      this.level = Level.error});
}

/// Defines levels of API restriction.
enum Level {
  error,
  warning,
}

/// Enum representing different environments for the Flyreel SDK.
///
/// The Flyreel SDK can operate in two environments: production and sandbox.
/// Use this enum to specify the desired environment for the SDK.
enum FlyreelEnvironment {
  production,
  sandbox,

  /// Staging environment (internal use only!!!).
  @FlyreelInternalApi()
  staging
}

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

/// Represents an analytic event in the Flyreel system.
///
/// This class encapsulates the details of an analytic event, including the user,
/// event name, timestamp, active time, coordination, device data, and message details.
class FlyreelAnalyticEvent {
  final FlyreelAnalyticUser user;
  final String name;
  final String timestamp;
  final double? activeTime;
  final FlyreelCoordination? coordination;
  final FlyreelDeviceData? deviceData;
  final FlyreelMessageDetails? messageDetails;

  FlyreelAnalyticEvent({
    required this.user,
    required this.name,
    required this.timestamp,
    this.activeTime,
    this.coordination,
    this.deviceData,
    this.messageDetails,
  });

  factory FlyreelAnalyticEvent.fromJson(Map<Object?, Object?> json) {
    final Map<String, dynamic> castedJson = Map<String, dynamic>.from(json);
    final num? activeTime = castedJson['activeTime'];
    return FlyreelAnalyticEvent(
      user: FlyreelAnalyticUser._fromJson(
          castedJson['user'].cast<String, dynamic>()),
      name: castedJson['name'] as String,
      timestamp: castedJson['timestamp'] as String,
      activeTime: activeTime?.toDouble(),
      coordination: castedJson['coordination'] != null
          ? FlyreelCoordination._fromJson(
              castedJson['coordination'].cast<String, dynamic>())
          : null,
      deviceData: castedJson['deviceData'] != null
          ? FlyreelDeviceData._fromJson(
              castedJson['deviceData'].cast<String, dynamic>())
          : null,
      messageDetails: castedJson['messageDetails'] != null
          ? FlyreelMessageDetails._fromJson(
              castedJson['messageDetails'].cast<String, dynamic>())
          : null,
    );
  }

  @override
  String toString() {
    return 'FlyreelAnalyticEvent(user: $user, name: $name, timestamp: $timestamp, '
        'activeTime: $activeTime, coordination: $coordination, '
        'deviceData: $deviceData, messageDetails: $messageDetails)';
  }
}

/// Represents a user in the Flyreel.
///
/// This class encapsulates the details of a user, including their ID, name, email,
/// bot ID, bot name, organization ID, status, and login type.
class FlyreelAnalyticUser {
  final String id;
  final String name;
  final String email;
  final String botId;
  final String botName;
  final String organizationId;
  final String status;
  final FlyreelLoginType? loginType;

  FlyreelAnalyticUser({
    required this.id,
    required this.name,
    required this.email,
    required this.botId,
    required this.botName,
    required this.organizationId,
    required this.status,
    required this.loginType,
  });

  factory FlyreelAnalyticUser._fromJson(Map<String, dynamic> json) {
    return FlyreelAnalyticUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      botId: json['botId'] as String,
      botName: json['botName'] as String,
      organizationId: json['organizationId'] as String,
      status: json['status'] as String,
      loginType:
          FlyreelLoginTypeExtension._fromValue(json['loginType'] as String?),
    );
  }

  @override
  String toString() {
    return 'FlyreelAnalyticUser(id: $id, name: $name, email: $email, botId: $botId, '
        'botName: $botName, organizationId: $organizationId, status: $status, loginType: $loginType)';
  }
}

/// Represents device data in the Flyreel.
///
/// This class encapsulates the details of a device, including the phone manufacturer,
/// phone model, app version, and app name.
class FlyreelDeviceData {
  final String? phoneManufacturer;
  final String phoneModel;
  final String appVersion;
  final String appName;

  FlyreelDeviceData({
    required this.phoneManufacturer,
    required this.phoneModel,
    required this.appVersion,
    required this.appName,
  });

  factory FlyreelDeviceData._fromJson(Map<String, dynamic> json) {
    return FlyreelDeviceData(
      phoneManufacturer: json['phoneManufacturer'] as String?,
      phoneModel: json['phoneModel'] as String,
      appVersion: json['appVersion'] as String,
      appName: json['appName'] as String,
    );
  }

  @override
  String toString() {
    return 'FlyreelDeviceData(phoneManufacturer: $phoneManufacturer, phoneModel: $phoneModel, '
        'appVersion: $appVersion, appName: $appName)';
  }
}

/// Represents coordination data in the Flyreel.
///
/// This class encapsulates the details of coordination, including latitude and longitude.
class FlyreelCoordination {
  final double lat;
  final double lng;

  FlyreelCoordination({
    required this.lat,
    required this.lng,
  });

  factory FlyreelCoordination._fromJson(Map<String, dynamic> json) {
    return FlyreelCoordination(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }

  @override
  String toString() {
    return 'FlyreelCoordination(lat: $lat, lng: $lng)';
  }
}

/// Represents message details in the Flyreel.
///
/// This class encapsulates the details of a message, including the message content,
/// message type, module key, and message key.
class FlyreelMessageDetails {
  final String? message;
  final String? messageType;
  final String? moduleKey;
  final String? messageKey;

  FlyreelMessageDetails({
    this.message,
    this.messageType,
    this.moduleKey,
    this.messageKey,
  });

  factory FlyreelMessageDetails._fromJson(Map<String, dynamic> json) {
    return FlyreelMessageDetails(
      message: json['message'] as String?,
      messageType: json['messageType'] as String?,
      moduleKey: json['moduleKey'] as String?,
      messageKey: json['messageKey'] as String?,
    );
  }

  @override
  String toString() {
    return 'FlyreelMessageDetails(message: $message, messageType: $messageType, '
        'moduleKey: $moduleKey, messageKey: $messageKey)';
  }
}

/// Enum representing different login types for the Flyreel.
///
/// The Flyreel can have two login types: manual(with credentials) and deeplink.
enum FlyreelLoginType {
  manual,
  deeplink,
}

/// Extension on [FlyreelLoginType] to provide additional functionality.
extension FlyreelLoginTypeExtension on FlyreelLoginType {
  static FlyreelLoginType? _fromValue(String? value) {
    switch (value) {
      case 'manual_login':
        return FlyreelLoginType.manual;
      case 'deeplink_login':
        return FlyreelLoginType.deeplink;
      default:
        return null;
    }
  }
}
