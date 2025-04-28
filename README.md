
# app_badger Flutter Plugin

A Flutter plugin to manage app badge counts on different Android devices (including Xiaomi, Samsung, HTC, Sony, Huawei, OPPO, and others) using the ShortcutBadger library.

## Installation

To use the app_badger plugin in your Flutter project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  app_badger: ^0.0.1
```

Then, run the following command in the terminal:

```bash
flutter pub get
```

## Required Setup for Android

The plugin requires specific configurations in the `AndroidManifest.xml` file to ensure compatibility with various device brands (Xiaomi, Samsung, HTC, Sony, Huawei, etc.).

### 1. Add Permissions and Receiver to `AndroidManifest.xml`

To enable the badge feature on different Android devices, add the following entries inside the `<application>` tag in your `android/app/src/main/AndroidManifest.xml` file:

```xml
<receiver
    android:name="me.leolin.shortcutbadger.impl.XiaomiHomeBadger"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BADGE_COUNT_UPDATE" />
    </intent-filter>
</receiver>

<!-- Permissions for Xiaomi -->
<uses-permission android:name="com.android.launcher.permission.READ_SETTINGS" />
<uses-permission android:name="com.android.launcher.permission.WRITE_SETTINGS" />
<uses-permission android:name="com.android.launcher.permission.INSTALL_SHORTCUT" />
<uses-permission android:name="com.android.launcher.permission.UNINSTALL_SHORTCUT" />

<!-- Permissions for Samsung -->
<uses-permission android:name="com.sec.android.provider.badge.permission.READ" />
<uses-permission android:name="com.sec.android.provider.badge.permission.WRITE" />

<!-- Permissions for HTC -->
<uses-permission android:name="com.htc.launcher.permission.READ_SETTINGS" />
<uses-permission android:name="com.htc.launcher.permission.UPDATE_SHORTCUT" />

<!-- Permissions for Sony -->
<uses-permission android:name="com.sonyericsson.home.permission.BROADCAST_BADGE" />
<uses-permission android:name="com.sonymobile.home.permission.PROVIDER_INSERT_BADGE" />

<!-- Permissions for Apex -->
<uses-permission android:name="com.anddoes.launcher.permission.UPDATE_COUNT" />

<!-- Permissions for Solid -->
<uses-permission android:name="com.majeur.launcher.permission.UPDATE_BADGE" />

<!-- Permissions for Huawei -->
<uses-permission android:name="com.huawei.android.launcher.permission.CHANGE_BADGE" />
<uses-permission android:name="com.huawei.android.launcher.permission.READ_SETTINGS" />
<uses-permission android:name="com.huawei.android.launcher.permission.WRITE_SETTINGS" />

<!-- Permissions for ZUK -->
<uses-permission android:name="android.permission.READ_APP_BADGE" />

<!-- Permissions for OPPO -->
<uses-permission android:name="com.oppo.launcher.permission.READ_SETTINGS" />
<uses-permission android:name="com.oppo.launcher.permission.WRITE_SETTINGS" />

<!-- Permissions for EvMe -->
<uses-permission android:name="me.everything.badger.permission.BADGE_COUNT_READ" />
<uses-permission android:name="me.everything.badger.permission.BADGE_COUNT_WRITE" />
```

### 2. Additional Requirement: Notifications

The badge count update functionality will only work if triggered by local notifications or push notifications. Therefore, make sure to trigger the badge count update when a notification is received.

- For local notifications, you can use the `flutter_local_notifications` package or any other method to trigger local/push notifications.
- For push notifications, ensure that your Firebase or other push notification service triggers the badge update when a new push notification is received.

## Required Setup for iOS

In your iOS `Info.plist`, add the following to request permissions for notifications:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Your app needs access to location to show notifications</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Your app needs access to location to show notifications</string>
```

Additionally, make sure that your `AppDelegate.swift` is properly configured:

```swift
import UIKit
import Flutter
import app_badger  // Import the plugin here

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self) // Register the Flutter plugins
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

## Usage

### Update Badge Count

To update the badge count on supported devices:

```dart
import 'package:app_badger/app_badger.dart';

void _updateBadge() {
  AppBadger.updateBadgeCount(5); // Set badge count to 5
}
```

### Remove Badge

To remove the badge count:

```dart
import 'package:app_badger/app_badger.dart';

void _removeBadge() {
  AppBadger.removeBadge(); // Remove badge
}
```

### Check if Badge is Supported

To check if the badge functionality is supported on the device:

```dart
import 'package:app_badger/app_badger.dart';

void _checkBadgeSupport() async {
  bool isSupported = await AppBadger.isBadgeSupported();
  print("Badge supported: $isSupported");
}
```

## Troubleshooting

- **Badge Not Showing on Xiaomi Devices:** Make sure to add the Xiaomi receiver and permissions in the `AndroidManifest.xml` as mentioned above.
- **Badge Not Working:** Badge counts may not be supported on all devices, and some device manufacturers require specific permissions or settings.
- **Notification Badge Only Works After Notification:** Ensure that your badge count update is triggered by a notification, whether it’s a local notification or a push notification.

## Contributing

Feel free to open issues or pull requests for any features or bug fixes.
