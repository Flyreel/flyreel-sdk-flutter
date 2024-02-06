# Flyreel Flutter SDK

[![Platform](https://img.shields.io/badge/platform-Android-orange.svg)](https://github.com/Flyreel/flyreel-sdk-android)
[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://github.com/Flyreel/flyreel-sdk-ios)
[![Languages](https://img.shields.io/badge/language-Dart-orange.svg)](https://github.com/Flyreel/flyreel-sdk-android)
[![GitHub release](https://img.shields.io/badge/version-0.0.1-blue.svg)](https://github.com/Flyreel/flyreel-sdk-flutter)

## Requirements:

### Android
- Android 6+ (minSdk 23)

### iOS
- iOS 13+

## Installation

### With flutter

```bash
$ flutter pub add flyreel_sdk_flutter
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```yaml
dependencies:
  flyreel_sdk_flutter: ^0.0.1
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

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

### Initialization

To use the Flyreel SDK, you must provide a configuration with the following parameters:

`settingsVersion`: Identifier of your remote SDK settings.

`organizationId`: Identifier of your organization.

In your lib/main.dart file, initialize Flyreel using provided object:

```dart
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
  await Flyreel.open(deeplinkUrl:"https://your.custom.url/?flyreelAccessCode=6M4T0T&flyreelZipCode=80212");
}
```

## Debug Logs

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