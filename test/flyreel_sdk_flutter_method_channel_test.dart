import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter_method_channel.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlyreelSdkFlutter platform = MethodChannelFlyreelSdkFlutter();
  const MethodChannel channel = MethodChannel('flyreel_sdk_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initialize', () async {
    expect(
        await platform.initialize(FlyreelConfig(
            organizationId: "organizationId", settingsVersion: 1)),
        null);
  });

  test('enableLogs', () async {
    expect(await platform.enableLogs(), null);
  });

  test('open', () async {
    expect(await platform.open(), null);
  });

  test('openWithCredentials', () async {
    expect(
        await platform.openWithCredentials(
            zipCode: "zipCode", accessCode: "accessCode"),
        null);
  });
}
