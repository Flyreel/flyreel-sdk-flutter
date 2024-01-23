import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flyreel_sdk_flutter_method_channel.dart';

abstract class FlyreelSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a FlyreelSdkFlutterPlatform.
  FlyreelSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlyreelSdkFlutterPlatform _instance = MethodChannelFlyreelSdkFlutter();

  /// The default instance of [FlyreelSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlyreelSdkFlutter].
  static FlyreelSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlyreelSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(FlyreelSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future initialize(FlyreelConfig config) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future openWithCredentials({required String zipCode, required String accessCode, bool shouldSkipLoginPage = true}) {
    throw UnimplementedError('open() has not been implemented.');
  }

  Future open({String? deeplinkUrl, bool shouldSkipLoginPage = true}) {
    throw UnimplementedError('open() has not been implemented.');
  }

  Future enableDebugLogging() {
    throw UnimplementedError('enableDebugLogging() has not been implemented.');
  }
}

class FlyreelConfig {
  final String organizationId;
  final int settingsVersion;
  final FlyreelEnvironment environment;

  FlyreelConfig({
    required this.organizationId,
    required this.settingsVersion,
    this.environment = FlyreelEnvironment.production,
  });
}

enum FlyreelEnvironment { production, sandbox }
