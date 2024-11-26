# Flyreel Flutter SDK

[![Platform](https://img.shields.io/badge/platform-Android-orange.svg)](https://github.com/Flyreel/flyreel-sdk-android)
[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://github.com/Flyreel/flyreel-sdk-ios)
[![Languages](https://img.shields.io/badge/language-Dart-orange.svg)](https://github.com/Flyreel/flyreel-sdk-android)
[![GitHub release](https://img.shields.io/pub/v/flyreel_sdk_flutter?color=blue)](https://pub.dev/packages/flyreel_sdk_flutter)

## Requirements:

### Android

- Android 6+ (minSdk 23)
- compileSdkVersion 34

### iOS

- iOS 13+

## Installation

### With flutter

```bash
$ flutter pub add flyreel_sdk_flutter
```

### Path dependency

via ssh:

```yaml
flyreel_sdk_flutter:
  git:
    url: git@github.com:Flyreel/flyreel-sdk-flutter.git
``` 

or

via https:

```yaml
flyreel_sdk_flutter:
  git:
    url: https://github.com/Flyreel/flyreel-sdk-flutter.git
```

## Usage

### Permissions on iOS

Since the SDK actively uses some functionalities of the iOS system you need to provide a few
permission settings in your Info.plist file.

```xml

<dict>
    // ...
    <key>NSCameraUsageDescription</key>
    <string>We need access to the camera.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>We need access to the camera.</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need access to your location data</string>
</dict>
```

### Initialization

To use the Flyreel SDK, you must provide a configuration with the following parameters:

`settingsVersion`: Identifier of your remote SDK settings.

`organizationId`: Identifier of your organization.

In your lib/main.dart file, initialize Flyreel using provided object:

```dart
import 'package:flyreel_sdk_flutter/flyreel_sdk_flutter.dart'; // import Flyreel SDK
import 'package:flyreel_sdk_flutter/flyreel_sdk_models.dart'; // import Flyreel SDK models

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Flyreel with organizationId and settingsVersion
  var config = FlyreelConfig(
    organizationId: "5d3633f9103a930011996475",
    settingsVersion: 1,
  );
  await Flyreel.initialize(config);

  runApp(const MyApp());
}
```

### How to open Flyreel chat

Invoke openFlyreel()

```dart
void openFlyreel() async {
  await Flyreel.open();
}
```

### Deep Linking

If you're launching the Flyreel flow from a deep link, push notification, or a custom solution where
user details can be provided automatically, use:

```dart
void openFlyreelWithCredentials() async {
  await Flyreel.openWithCredentials(
    zipCode: "80212",
    accessCode: "6M4T0T",
  );
}

void openFlyreelWithUrl() async {
  await Flyreel.open(
      deeplinkUrl: "https://your.custom.url/?flyreelAccessCode=6M4T0T&flyreelZipCode=80212");
}
```

### Custom fonts

If you want to use a custom font for Flyreel chat, you have to provide a ttf file to both iOS and
Android Platform.

- in the Android directory, you can put the ttf file in the main/assets folder or the main/res/font
  folder.
- for iOS, you have to go with
  the [Apple instruction](https://developer.apple.com/documentation/uikit/text_display_and_fonts/adding_a_custom_font_to_your_app)
  to add a custom font to your project.

Then, you can use the font's name in the Flyreel dashboard panel. For example, if you have added
font **my_font.ttf** to the assets folder, you can use **my_font** as a font name in the Flyreel
dashboard.

## Debug Logs

Enable debug logging for troubleshooting purposes:

```dart
void showLogs() async {
  await Flyreel.enableLogs();
}
```

## Check Flyreel status for given access and zip code

You can manually check Flyreel status. This function makes a network request to retrieve the status
of Flyreel for the specified zip code and access code.

```dart
void checkFlyreelStatus() async {
  try {
    final result = await Flyreel.checkStatus(
      zipCode: "80212",
      accessCode: "6M4T0T",
    );
    print("Status: ${result.status}, expires: ${result.expiration}");
  } on PlatformException catch (e) {
    print("code: ${e.code}, message: ${e.message}");
  }
}
```

Enable debug logging for troubleshooting purposes:

```dart
void showLogs() async {
  await Flyreel.enableLogs();
}
```

## Sandbox

Verify your implementation in the sandbox mode. Initialize Flyreel with an additional parameter:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ...
  var configuration = FlyreelConfiguration(
      organizationId = "7d3899f1421a7650241516475",
      settingsVersion = 1,
      environment = FlyreelEnvironment.Sandbox
  );

  await Flyreel.initialize(
      application = this,
      configuration = configuration
  );

  // ...
}
```

## Analytics

```dart
/// Subscribes to a stream of analytic events and handles each event with a provided closure.
///
/// This function observes a feed of analytic events from the SDK. When an event
/// is received, the provided handler closure is called with the event as its argument.
///
/// - Parameters:
///   - handler: A closure that is called with the analytic event emitted by the SDK.
///     The closure takes a single parameter:
///       - event: A `FlyreelAnalyticEvent` type that contains event's data.
///       
void observeFlyreelAnalytics() async {
  Flyreel.observeAnalyticEvents().listen((event) {
    debugPrint("event: ${event.toString()}");
  });
}
```

## Firewall whitelisting

Here is a list of Flyreel's hosts in case you need to whitelist URLs.

```
api3.flyreel.co
sandbox.api3.flyreel.co
```
