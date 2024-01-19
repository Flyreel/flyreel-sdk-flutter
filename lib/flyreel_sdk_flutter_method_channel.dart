import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flyreel_sdk_flutter_platform_interface.dart';

/// An implementation of [FlyreelSdkFlutterPlatform] that uses method channels.
class MethodChannelFlyreelSdkFlutter extends FlyreelSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flyreel_sdk_flutter');

  @override
  Future initialize(FlyreelConfig config) async {
    await methodChannel.invokeMethod('initialize', {
      'organizationId': config.organizationId,
      'settingsVersion': config.settingsVersion,
      'environment': config.environment.name,
    });
  }

  @override
  Future open() async {
    await methodChannel.invokeMethod('open');
  }

  @override
  Future enableDebugLogging() async {
    await methodChannel.invokeMethod('enableDebugLogging');
  }
}
