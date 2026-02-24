# app_badger Flutter Plugin

A Flutter plugin to manage app badge counts on different Android devices (including Xiaomi, Samsung, HTC, Sony, Huawei, OPPO, and others) using the ShortcutBadger library.

## Version 0.0.3 Highlights
- Glassmorphism badge widget for in-app overlays (`GlassMorphismBadge`).
- Glassmorphism container widget for frosted glass UI backgrounds (`GlassMorphismContainer`).
- Consistent MethodChannel name (`app_badger`) for plugin registration.
- Improved design system for badges and UI overlays.

## Installation

To use the app_badger plugin in your Flutter project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  app_badger: ^0.0.3
```

Or for local development:

```yaml
dependencies:
  app_badger:
    path: ../
```

Then, run the following command in the terminal:

```bash
flutter pub get
```

## Required Setup for Android

The plugin requires specific configurations in the `AndroidManifest.xml` file to ensure compatibility with various device brands (Xiaomi, Samsung, HTC, Sony, Huawei, etc.).

### 1. Add Permissions and Receiver to `AndroidManifest.xml`

Add the required permissions and receiver entries inside the `<application>` tag in your `android/app/src/main/AndroidManifest.xml` file:

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

Badge count updates should be triggered by local or push notifications.

## Required Setup for iOS

Add notification permissions to your `Info.plist` and ensure plugin registration in `AppDelegate.swift`.

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

### Glassmorphism Badge (In-App UI)

For using the glassmorphism badge in your app's UI:

```dart
import 'package:app_badger/app_badger.dart';

Stack(
  alignment: Alignment.topRight,
  children: [
    Icon(Icons.notifications, size: 48),
    GlassMorphismBadge(count: 7),
  ],
)
```

### Glassmorphism Container (UI Backgrounds)

For using the glassmorphism container in your app's UI:

```dart
import 'package:app_badger/app_badger.dart';

GlassMorphismContainer(
  child: Column(
    children: [
      // ...your widgets...
    ],
  ),
)
```

## Troubleshooting

- **MissingPluginException:** Ensure the MethodChannel name is `app_badger` in both Dart and native code. Do a full restart after plugin changes.
- **Badge Not Showing on Xiaomi Devices:** Add Xiaomi receiver and permissions in `AndroidManifest.xml`.
- **Badge Not Working:** Badge counts may not be supported on all devices; check permissions and settings.
- **Notification Badge Only Works After Notification:** Badge updates should be triggered by notifications.

## Contributing

Feel free to open issues or pull requests for any features or bug fixes.
