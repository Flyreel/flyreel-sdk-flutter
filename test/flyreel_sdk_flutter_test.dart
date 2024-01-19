import 'package:flutter_test/flutter_test.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter_platform_interface.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlyreelSdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements FlyreelSdkFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlyreelSdkFlutterPlatform initialPlatform = FlyreelSdkFlutterPlatform.instance;

  test('$MethodChannelFlyreelSdkFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlyreelSdkFlutter>());
  });

  test('getPlatformVersion', () async {
    FlyreelSdkFlutter flyreelSdkFlutterPlugin = FlyreelSdkFlutter();
    MockFlyreelSdkFlutterPlatform fakePlatform = MockFlyreelSdkFlutterPlatform();
    FlyreelSdkFlutterPlatform.instance = fakePlatform;

    expect(await flyreelSdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
