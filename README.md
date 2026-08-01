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

The plugin now uses a notification-based fallback alongside ShortcutBadger so badges can be updated more reliably on modern Android devices.

### 1. Add Required Permissions to `AndroidManifest.xml`

Add the needed permissions inside the `<manifest>` tag in your `android/app/src/main/AndroidManifest.xml` file:

```xml
<!-- Required on Android 13+ for notification-based badge updates -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<!-- Optional launcher permissions for device-specific badge support -->
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

## Known Limitations

### Android Background Badge Disappearance
On Android, app icon badges may disappear when the app enters the background on certain devices/launchers. This is a known platform limitation:

- **Root Cause:** Many Android launchers only refresh badge visibility when the app process is active (in foreground). When your app backgrounded, the launcher may clear the badge display even though the badge count is internally stored.
- **Affected Devices:** This behavior is launcher-dependent (Stock Android, Samsung, MIUI, OnePlus, etc. all handle badges differently).
- **Workaround:** Ensure notifications are enabled:
  1. Check device notification settings for your app
  2. Verify `POST_NOTIFICATIONS` permission is granted (Android 13+)
  3. Consider using push notifications to "refresh" the badge when needed
  4. Some launchers have badge visibility settings in launcher preferences

### Device-Specific Support
Badge functionality varies significantly across Android devices:
- Stock Android Launcher: Full badge support via notification
- Samsung: Requires specific `com.sec.android.provider.badge` permissions
- Xiaomi MIUI: Requires broadcast integration
- Other devices (HTC, Sony, OPPO, etc.): Requires device-specific permissions and broadcast receivers

## Debugging Badge Issues

To debug badge issues, check the logcat output after running your app:

```bash
# View all app_badger logs
flutter logs | grep AppBadger

# Clear device logs and run
flutter logcat -c
flutter run
# Then in another terminal:
flutter logs | grep AppBadger
```

You'll see logs like:
```
AppBadger: applyBadgeCount called with count=5
AppBadger: Attempting ShortcutBadger.applyCount for count=5
AppBadger: ShortcutBadger.applyCount result: true
AppBadger: Notifications enabled: true
AppBadger: Posting badge notification with count=5
AppBadger: Badge notification posted successfully
```

If you see:
- `ShortcutBadger.applyCount result: false` - Device/launcher doesn't support badges
- `Notifications enabled: false` - Notifications are disabled, badge will only use ShortcutBadger broadcast
- `Failed to post badge notification` - Permission or system issue preventing notification posting

## Troubleshooting

- **MissingPluginException:** Ensure the MethodChannel name is `app_badger` in both Dart and native code. Do a full restart after plugin changes.
- **Badge Not Showing on Xiaomi Devices:** Add Xiaomi receiver and permissions in `AndroidManifest.xml`.
- **Badge Not Working:** Badge counts may not be supported on all devices; check permissions and settings. Use the debugging logs to verify which path is failing.
- **Badge Disappears in Background:** This is a known Android limitation (see "Known Limitations"). Check launcher badge settings and ensure notifications are enabled.
- **Notification Badge Only Works After Notification:** Badge updates should be triggered by notifications or app lifecycle events.

## Contributing

Feel free to open issues or pull requests for any features or bug fixes.
