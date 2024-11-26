import 'package:flutter_test/flutter_test.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter_method_channel.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter_platform_interface.dart';
import 'package:flyreel_sdk_flutter/flyreel_sdk_models.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlyreelSdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements FlyreelSdkFlutterPlatform {
  @override
  Future enableLogs() => Future.value();

  @override
  Future initialize(FlyreelConfig config) => Future.value();

  @override
  Future open({String? deeplinkUrl, bool shouldSkipLoginPage = true}) =>
      Future.value();

  @override
  Future openWithCredentials(
          {required String zipCode,
          required String accessCode,
          bool shouldSkipLoginPage = true}) =>
      Future.value();

  @override
  Future<FlyreelCheckStatus> checkStatus(
      {required String zipCode, required String accessCode}) {
    return Future.value(
        FlyreelCheckStatus(status: "status", expiration: "expiration"));
  }

  @override
  Stream<FlyreelAnalyticEvent> observeAnalyticStream() {
    return Stream.value(
      FlyreelAnalyticEvent(
          user: FlyreelAnalyticUser(
            id: '1',
            name: "name",
            email: 'flyreel@flyreel.com',
            botId: '1',
            botName: 'botName',
            organizationId: 'someId',
            status: '',
            loginType: null,
          ),
          name: 'name',
          timestamp: '0'),
    );
  }
}

void main() {
  final FlyreelSdkFlutterPlatform initialPlatform =
      FlyreelSdkFlutterPlatform.instance;

  test('$MethodChannelFlyreelSdkFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlyreelSdkFlutter>());
  });

  test('enableLogs', () async {
    MockFlyreelSdkFlutterPlatform fakePlatform =
        MockFlyreelSdkFlutterPlatform();
    FlyreelSdkFlutterPlatform.instance = fakePlatform;

    expect(await Flyreel.enableLogs(), null);
  });

  test('initialize', () async {
    MockFlyreelSdkFlutterPlatform fakePlatform =
        MockFlyreelSdkFlutterPlatform();
    FlyreelSdkFlutterPlatform.instance = fakePlatform;

    expect(
        await Flyreel.initialize(FlyreelConfig(
            organizationId: "organizationId", settingsVersion: 3)),
        null);
  });

  test('open', () async {
    MockFlyreelSdkFlutterPlatform fakePlatform =
        MockFlyreelSdkFlutterPlatform();
    FlyreelSdkFlutterPlatform.instance = fakePlatform;

    expect(await Flyreel.open(), null);
  });

  test('openWithCredentials', () async {
    MockFlyreelSdkFlutterPlatform fakePlatform =
        MockFlyreelSdkFlutterPlatform();
    FlyreelSdkFlutterPlatform.instance = fakePlatform;

    expect(
        await Flyreel.openWithCredentials(
            zipCode: "zipCode", accessCode: "accessCode"),
        null);
  });

  test('checkStatus', () async {
    MockFlyreelSdkFlutterPlatform fakePlatform =
        MockFlyreelSdkFlutterPlatform();
    FlyreelSdkFlutterPlatform.instance = fakePlatform;
    final status =
        await Flyreel.checkStatus(zipCode: "zipCode", accessCode: "accessCode");

    expect(status.status, "status");
    expect(status.expiration, "expiration");
  });

  test('observeAnalyticStream', () async {
    MockFlyreelSdkFlutterPlatform fakePlatform = MockFlyreelSdkFlutterPlatform();
    FlyreelSdkFlutterPlatform.instance = fakePlatform;
    final event = await Flyreel.observeAnalyticEvents().first;

    expect(event.name, "name");
    expect(event.user.id, "1");
  });
}
