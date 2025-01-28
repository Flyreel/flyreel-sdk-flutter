import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_models.dart';
import 'flyreel_sdk_flutter_platform_interface.dart';

/// An implementation of [FlyreelSdkFlutterPlatform] that uses method channels.
class MethodChannelFlyreelSdkFlutter extends FlyreelSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flyreel_sdk_flutter');

  @visibleForTesting
  final eventChannel = const EventChannel('flyreel_sdk_stream');

  @override
  Future initialize(FlyreelConfig config) async {
    await methodChannel.invokeMethod('initialize', {
      'organizationId': config.organizationId,
      'environment': config.environment.name,
    });
  }

  @override
  Future openWithCredentials({
    required String zipCode,
    required String accessCode,
    bool shouldSkipLoginPage = true,
  }) async {
    await methodChannel.invokeMethod('openWithCredentials', {
      'zipCode': zipCode,
      'accessCode': accessCode,
      'shouldSkipLoginPage': shouldSkipLoginPage,
    });
  }

  @override
  Future open({
    String? deeplinkUrl,
    bool shouldSkipLoginPage = true,
  }) async {
    await methodChannel.invokeMethod('open', {
      'deeplinkUrl': deeplinkUrl,
      'shouldSkipLoginPage': shouldSkipLoginPage,
    });
  }

  @override
  Future enableLogs() async {
    await methodChannel.invokeMethod('enableLogs');
  }

  @override
  Future<FlyreelCheckStatus> checkStatus({
    required String zipCode,
    required String accessCode,
  }) async {
    final value = await methodChannel.invokeMethod('checkStatus', {
      'zipCode': zipCode,
      'accessCode': accessCode,
    });
    return FlyreelCheckStatus.fromMap(value.cast<String, dynamic>());
  }

  @override
  Stream<FlyreelAnalyticEvent> observeAnalyticStream() {
    return eventChannel
        .receiveBroadcastStream()
        .map((event) => FlyreelAnalyticEvent.fromJson(event));
  }
}
