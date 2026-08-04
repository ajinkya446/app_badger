# app_badger Flutter Plugin

A Flutter plugin to manage app badge counts on Android, iOS, and macOS. It supports launcher-specific badge APIs on Android devices such as Xiaomi, Samsung, HTC, Sony, Huawei, and OPPO, native badge handling on iOS, and Dock tile badges on macOS.

## Version 3.0.0 Highlights

### Latest Release
- ✅ **Current stable version**: `3.0.0`
- 🖥️ **macOS support added**: Dock tile badge management via `NSApplication.shared.dockTile`
- 🔢 **New APIs**: `getBadgeCount()`, `incrementBadge()`, `decrementBadge()`, `getDeviceManufacturer()`, `getDeviceBrand()`, `getPermissionStatus()`
- 🔄 **BadgeLifecycleObserver mixin**: Auto-clears badge on app foreground
- 📊 **BadgePermissionStatus enum**: Fine-grained permission introspection
- ✅ **updateBadgeCount / removeBadge now return `Future<bool>`** for success/failure signalling

### v2.x Platform Updates
- ✨ **Swift Package Manager (SPM)**: iOS and macOS plugins use SPM layout for modern Flutter compatibility
- 🚀 **AGP 9+ ready**: Android build uses the built-in Kotlin path
- 📢 **Notification-based badge fallback**: Improves badge reliability on newer Android devices
- 🔐 **Runtime permission handling**: `AppBadger.requestNotificationPermission()` supports Android 13+ and iOS

### Included Features
- 📱 **Badge update and removal API**
- 🐛 **Improved logging for troubleshooting**
- 📚 **Platform-specific setup and migration guidance**
- ✅ **Support for modern Flutter and native platform tooling**

## Installation

To use the app_badger plugin in your Flutter project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  app_badger: ^3.0.0
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

## Required Setup

### Android Setup

The plugin now uses a dual-path badge delivery system:
1. **ShortcutBadger**: Native launcher badge API (primary, fastest)
2. **Notification-Based Fallback**: System notification with badge count (reliable on modern devices)

#### 1. Add Required Permissions to `AndroidManifest.xml`

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

<!-- Permissions for Vivo -->
<uses-permission android:name="com.vivo.notification.permission.BADGE_ICON" />

<!-- Permissions for OnePlus -->
<uses-permission android:name="net.oneplus.launcher.permission.READ_SETTINGS" />
<uses-permission android:name="net.oneplus.launcher.permission.WRITE_SETTINGS" />

<!-- Permissions for LG -->
<uses-permission android:name="com.lge.launcher.permission.READ_SETTINGS" />
<uses-permission android:name="com.lge.launcher.permission.WRITE_SETTINGS" />

<!-- Permissions for Realme -->
<uses-permission android:name="com.coloros.launcher.permission.READ_SETTINGS" />
<uses-permission android:name="com.coloros.launcher.permission.WRITE_SETTINGS" />

<!-- Permissions for Nova Launcher -->
<uses-permission android:name="com.teslacoilsw.launcher.permission.READ_SETTINGS" />
<uses-permission android:name="com.teslacoilsw.launcher.permission.WRITE_SETTINGS" />
```

### 2. Request Notification Permission on Startup

Add this to your app's initialization code (e.g., `main()` or `MyApp.initState()`):

```dart
import 'package:app_badger/app_badger.dart';

@override
void initState() {
  super.initState();
  // Request permission when app launches
  AppBadger.requestNotificationPermission();
}
```

This ensures `POST_NOTIFICATIONS` permission is granted on Android 13+ before any badge updates.

### iOS Setup

The plugin uses Apple's `UNUserNotificationCenter` for badge management. No CocoaPods integration needed (uses Swift Package Manager).

#### 1. Add Notification Description to `Info.plist`

Add the following to your `ios/Runner/Info.plist`:

```xml
<key>NSUserNotificationUsageDescription</key>
<string>Notifications are required to display app badges</string>
```

#### 2. Request Permission on Startup

Same as Android - call `AppBadger.requestNotificationPermission()` on app startup:

```dart
@override
void initState() {
  super.initState();
  // Request permission when app launches
  AppBadger.requestNotificationPermission();
}
```

### macOS Setup

The plugin uses `NSApplication.shared.dockTile.badgeLabel` for Dock tile badge management. **No notification permission is required** — macOS Dock badges are a native OS-level UI feature that works without any entitlements or user permission dialogs.

#### No special setup required

macOS Dock badges work out of the box in any sandboxed Flutter app. You do **not** need to:
- Add `NSUserNotificationUsageDescription` to `Info.plist`
- Add any special entitlements (avoid `com.apple.developer.usernotifications.time-sensitive` — it requires a paid Apple Developer certificate and is not needed for badges)
- Call `requestNotificationPermission()` for Dock badge functionality

Simply call:

```dart
await AppBadger.updateBadgeCount(5); // Shows "5" on the Dock icon immediately
```

> **Note:** If you also want to send macOS notification banners (separate from Dock badges), you may optionally call `AppBadger.requestNotificationPermission()` to request `UNUserNotificationCenter` authorization.

## Additional Requirement: Notifications

Badge count updates should be triggered by local or push notifications. Call `AppBadger.requestNotificationPermission()` on app startup to ensure permissions are granted.

## Usage

### Complete Initialization Example

Here's how to initialize badges properly on app startup:

```dart
import 'package:app_badger/app_badger.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeBadges();
  }

  Future<void> _initializeBadges() async {
    // Request notification permission on app startup
    bool granted = await AppBadger.requestNotificationPermission();
    print("Notification permission granted: $granted");
    
    // Check if badge is supported
    bool isSupported = await AppBadger.isBadgeSupported();
    print("Badge supported: $isSupported");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('App Badger Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => AppBadger.updateBadgeCount(5),
                child: const Text('Set Badge to 5'),
              ),
              ElevatedButton(
                onPressed: () => AppBadger.removeBadge(),
                child: const Text('Remove Badge'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Update Badge Count

To update the badge count on supported devices:

```dart
import 'package:app_badger/app_badger.dart';

void _updateBadge() async {
  bool success = await AppBadger.updateBadgeCount(5); // Set badge count to 5
  print("Badge updated: $success");
}
```

### Remove Badge

To remove the badge count:

```dart
import 'package:app_badger/app_badger.dart';

void _removeBadge() async {
  bool success = await AppBadger.removeBadge(); // Remove badge
  print("Badge removed: $success");
}
```

### Get Current Badge Count

Retrieve the current persisted badge count (returns 0 if unknown):

```dart
import 'package:app_badger/app_badger.dart';

void _getBadgeCount() async {
  int count = await AppBadger.getBadgeCount();
  print("Current badge count: $count");
}
```

### Increment / Decrement Badge

Convenience helpers to increment or decrement the badge by one:

```dart
import 'package:app_badger/app_badger.dart';

void _handleNewNotification() async {
  int newCount = await AppBadger.incrementBadge();
  print("Badge incremented to: $newCount");
}

void _handleReadNotification() async {
  int newCount = await AppBadger.decrementBadge();
  print("Badge decremented to: $newCount");
}
```

### Get Device Manufacturer / Brand

```dart
import 'package:app_badger/app_badger.dart';

void _getDeviceInfo() async {
  String manufacturer = await AppBadger.getDeviceManufacturer();
  String brand = await AppBadger.getDeviceBrand();
  print("Device: $manufacturer / $brand");
  // Android example: "samsung" / "samsung"
  // iOS / macOS: "Apple" / "Apple"
}
```

### Get Detailed Permission Status

Query the fine-grained `BadgePermissionStatus` enum:

```dart
import 'package:app_badger/app_badger.dart';

void _checkPermissionStatus() async {
  final status = await AppBadger.getPermissionStatus();
  switch (status) {
    case BadgePermissionStatus.granted:
      print("Permission granted — badges will work.");
      break;
    case BadgePermissionStatus.denied:
      print("Permission denied — prompt user to open settings.");
      AppBadger.openNotificationSettings();
      break;
    case BadgePermissionStatus.notDetermined:
      print("Permission not yet requested — call requestNotificationPermission().");
      await AppBadger.requestNotificationPermission();
      break;
    case BadgePermissionStatus.restricted:
      print("Permission restricted by system (iOS).");
      break;
    case BadgePermissionStatus.provisional:
      print("Provisional permission (iOS) — limited delivery.");
      break;
  }
}
```

### Auto-Clear Badge on App Resume (BadgeLifecycleObserver)

Add the `BadgeLifecycleObserver` mixin to any `State` to automatically clear the badge when the app comes to the foreground:

```dart
import 'package:app_badger/app_badger.dart';
import 'package:flutter/material.dart';

class _HomePageState extends State<HomePage> with BadgeLifecycleObserver {
  @override
  void initState() {
    super.initState();
    initBadgeLifecycle(); // register lifecycle observer
  }

  @override
  void dispose() {
    disposeBadgeLifecycle(); // unregister lifecycle observer
    super.dispose();
  }

  // Set to false to disable auto-clear on resume
  // clearBadgeOnResume = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    body: const Center(child: Text('Badge clears when you return to this screen')),
  );
}
```

### Firebase Push Integration Example

Integrate with Firebase Cloud Messaging to update the badge from a push notification:

```dart
import 'package:app_badger/app_badger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Background message handler (top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final badgeData = message.data['badge'];
  if (badgeData != null) {
    final count = int.tryParse(badgeData.toString()) ?? 0;
    await AppBadger.updateBadgeCount(count);
  } else {
    await AppBadger.incrementBadge();
  }
}

// In your app initialization:
void _setupFirebaseMessaging() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // Foreground message: increment badge
    await AppBadger.incrementBadge();
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    // App opened from notification: clear badge
    await AppBadger.removeBadge();
  });
}
```

### Request Notification Permission

To request POST_NOTIFICATIONS permission (Android 13+) and notification permission (iOS):

```dart
import 'package:app_badger/app_badger.dart';

void _requestPermission() async {
  bool granted = await AppBadger.requestNotificationPermission();
  print("Permission granted: $granted");
}
```

This method:
- **Android 13+**: Requests the `POST_NOTIFICATIONS` permission at runtime
- **Android <13**: Returns true (permission not required)
- **iOS / macOS**: Requests notification permission with badge, sound, and alert options
- Returns `true` if permission was granted, `false` otherwise

**Recommended**: Call this method when your app first launches to ensure badge notifications work properly.

### Check Notification Status

To check if the badge functionality is supported on the device:

```dart
import 'package:app_badger/app_badger.dart';

void _checkBadgeSupport() async {
  bool isSupported = await AppBadger.isBadgeSupported();
  print("Badge supported: $isSupported");
}
```

### Check Notification Enabled Status

To check if notifications are currently enabled for your app:

```dart
import 'package:app_badger/app_badger.dart';

void _checkNotificationStatus() async {
  bool isEnabled = await AppBadger.isNotificationEnabled();
  print("Notifications enabled: $isEnabled");
}
```

### Open Notification Settings

To open the app's notification settings (useful if user denies permission):

```dart
import 'package:app_badger/app_badger.dart';

void _openSettings() {
  AppBadger.openNotificationSettings();
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

## Platform Requirements

### iOS
- **Minimum iOS Version**: 10.0+
- **Swift Package Manager**: Required (fully aligned in v3.0.0)
- **UIScene Lifecycle**: Required for iOS 13+

### macOS
- **Minimum macOS Version**: 10.14 (Mojave)+
- **Swift Package Manager**: Supported (CocoaPods also supported via `macos/app_badger.podspec`)
- **Badge delivery**: Via `NSApplication.shared.dockTile.badgeLabel` — no permission or entitlements required
- **No special entitlements needed**: Do not add `com.apple.developer.usernotifications.time-sensitive` — it requires a paid developer certificate and is not needed for Dock badges

### Android
- **Minimum Android API**: 21 (Android 5.0+)
- **Gradle Plugin**: AGP 8.11+ (no Kotlin Gradle Plugin needed)
- **Kotlin**: 2.0+
- **Runtime Permissions**: `POST_NOTIFICATIONS` (Android 13+)

## Migration Guide: v1.x → v2.x

If you're upgrading from v1.x, here are the key changes:

### iOS Changes
1. **CocoaPods removed** - Delete your `ios/Podfile` and `ios/Pods` directory if present
2. **Swift Package Manager** - Now required (automatically handled by Flutter)
3. **No manual plugin registration** - Plugin is auto-discovered via SPM

**Action Required:**
- Run `flutter clean` and `flutter pub get`
- Remove Podfile references from git history
- Run `flutter build ios --no-codesign` to rebuild

### Android Changes
1. **Plugin no longer applies Kotlin Gradle Plugin** - Only needed at app level
2. **Notification permission handling** - Now done via `AppBadger.requestNotificationPermission()`
3. **XiaomiHomeBadger receiver removed** - No longer needed from example

**Action Required:**
- Update your app's `build.gradle.kts` (example provided in plugin repo)
- Call `AppBadger.requestNotificationPermission()` on app startup
- Ensure `POST_NOTIFICATIONS` permission is in `AndroidManifest.xml`

### Flutter/Dart Changes (v3.0.x → v3.0.0)
1. **`updateBadgeCount` and `removeBadge` now return `Future<bool>`** — update any callers that used `await` without capturing the result
2. **New methods**: `getBadgeCount()`, `incrementBadge()`, `decrementBadge()`, `getDeviceManufacturer()`, `getDeviceBrand()`, `getPermissionStatus()`
3. **New mixin**: `BadgeLifecycleObserver` for automatic badge clearing on resume
4. **New enum**: `BadgePermissionStatus` for detailed permission introspection

### Flutter/Dart Changes (v1.x → v2.x)
1. **New method**: `AppBadger.requestNotificationPermission()` - Call on app startup
2. **Improved logging** - Use `flutter logs | grep AppBadger` for debugging
3. **Same API** - All existing methods (`updateBadgeCount`, `removeBadge`, etc.) remain unchanged

**Action Required:**
- Add permission request to your `initState()` or main app initialization
- No changes needed to badge update calls

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

### Badge State on App Open
`app_badger` does **not** automatically clear, decrease, or hide the badge when your app is opened or returns to the foreground.

- **Android:** The last badge count remains until your app explicitly calls `AppBadger.removeBadge()` or `AppBadger.updateBadgeCount(0)`.
- **iOS:** The badge count also remains unchanged until your app explicitly sets a new count or removes it.
- **macOS:** Same as iOS — explicitly call `removeBadge()` or use `BadgeLifecycleObserver`.
- **Important:** If you want badges cleared when users open the app, use `BadgeLifecycleObserver` or implement that behavior in your app lifecycle code.

### Limitations

These are the remaining limitations in `app_badger`. Items marked ✅ have been resolved in v3.0.0.

| Area | Status |
|---|---|
| **macOS support** | ✅ Resolved in v3.0.0 — full Dock tile badge support |
| **Read current badge count** | ✅ Resolved in v3.0.0 — `getBadgeCount()` API |
| **Increment / decrement helpers** | ✅ Resolved in v3.0.0 — `incrementBadge()` / `decrementBadge()` |
| **Manufacturer / device introspection** | ✅ Resolved in v3.0.0 — `getDeviceManufacturer()` / `getDeviceBrand()` |
| **Automatic lifecycle sync** | ✅ Resolved in v3.0.0 — `BadgeLifecycleObserver` mixin |
| **Fine-grained permission API** | ✅ Resolved in v3.0.0 — `getPermissionStatus()` + `BadgePermissionStatus` enum |
| **Return-value detail** | ✅ Resolved in v3.0.0 — `updateBadgeCount` / `removeBadge` return `Future<bool>` |
| **Vendor-specific breadth** | ✅ Improved in v3.0.0 — added Vivo, LG, Nova, OnePlus, Realme permissions |
| **Background push integration examples** | ✅ Improved in v3.0.0 — Firebase FCM integration example added |
| **Badge persistence API** | ✅ Improved in v3.0.0 — Android persists via SharedPreferences; iOS reads live icon badge number; `getBadgeCount()` API added |
| **No-setup Android story** | ✅ Improved in v3.0.0 — comprehensive AndroidManifest.xml permissions provided; `requestNotificationPermission()` simplifies setup |
| **Badge is not auto-cleared on app open** | ✅ Resolved in v3.0.0 — `BadgeLifecycleObserver` mixin automatically clears badge on resume |
| **Android background badge visibility is launcher-dependent** | ✅ Improved in v3.0.0 — notification-based fallback significantly improves badge reliability even when app backgrounds |
| **Badge support varies by Android manufacturer** | ✅ Improved in v3.0.0 — dual ShortcutBadger + notification approach ensures broader manufacturer and launcher support |

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

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| **MissingPluginException** | Plugin not properly registered | Run `flutter clean && flutter pub get && flutter run` |
| **Badge Not Showing** | Notifications disabled or permission not granted | Call `AppBadger.requestNotificationPermission()` on app startup |
| **Badge Stays After Opening App** | The plugin does not auto-clear badges on foreground/open | Use `BadgeLifecycleObserver` mixin or call `AppBadger.removeBadge()` when your app opens |
| **Badge Disappears in Background** | Android launcher limitation (common behavior) | Ensure notifications enabled; some launchers have badge visibility settings |
| **Badge Only Works with Notifications** | On some devices, badge needs active notification | Use notification-based badge delivery (automatic in v2.x) |
| **Xiaomi Badge Not Working** | Device-specific badge implementation | Ensure MIUI badge permissions are in `AndroidManifest.xml` |
| **iOS Badge Not Showing** | Notification permission not granted | Call `AppBadger.requestNotificationPermission()` in `initState()` |
| **macOS Badge Not Showing** | Dock tile update called off main thread | Ensure you're on a supported macOS version; try `flutter clean && flutter run -d macos` |
| **Android Permission Denied** | User rejected `POST_NOTIFICATIONS` request | Call `AppBadger.openNotificationSettings()` to guide user to enable |

### Debugging Checklist

1. **Verify permissions are granted:**
   ```dart
   bool isEnabled = await AppBadger.isNotificationEnabled();
   print("Notifications enabled: $isEnabled");
   ```

2. **Check if badges are supported:**
   ```dart
   bool supported = await AppBadger.isBadgeSupported();
   print("Badges supported: $supported");
   ```

3. **View logs for detailed information:**
   ```bash
   flutter logs | grep AppBadger
   ```

4. **Verify platform setup:**
   - Android: Check `AndroidManifest.xml` has `POST_NOTIFICATIONS` permission
   - iOS: Check `Info.plist` has `NSUserNotificationUsageDescription`
   - macOS: No setup required — Dock badges work without permissions or entitlements

5. **Test on physical device:**
   - Simulators/emulators may not fully support badge functionality
   - Test on real Android and iOS devices when possible

## Frequently Asked Questions

**Q: Do I need to migrate from v1.x?**
A: Yes. The current v3.0.0 release requires iOS 10+ and Android AGP 8.11+. CocoaPods is no longer supported on iOS. See Migration Guide above.

**Q: Why did the badge disappear when my app backgrounded?**
A: This is a known Android launcher limitation. Many launchers only show badges when the app is in foreground or actively receiving notifications. Ensure notifications are enabled in device settings.

**Q: Does the plugin clear the badge automatically when the app opens?**
A: Not by default. Use `BadgeLifecycleObserver` mixin in your State class to automatically clear the badge when the app resumes. Otherwise call `AppBadger.removeBadge()` manually.

**Q: Can I use the plugin without requesting permission?**
A: Permission is not strictly required to call badge methods, but badges work more reliably when permission is granted. Calling `requestNotificationPermission()` on startup is strongly recommended.

**Q: Which Android devices/launchers are supported?**
A: The plugin supports most Android launchers including Stock Android, Samsung, Xiaomi, HTC, Sony, Huawei, OPPO, Vivo, OnePlus, LG, Realme, Nova Launcher, and many others. Device-specific permissions are included in the example manifest.

**Q: What's the difference between ShortcutBadger and notification-based badges?**
A: v2.x uses both: ShortcutBadger for native launcher badges (fastest) + notification-based fallback (most reliable on modern Android). The plugin automatically uses both for maximum compatibility.

**Q: Do I need to use push notifications?**
A: Not required, but recommended for badges to persist. Use local notifications if needed to "refresh" the badge when your app backgrounds.

**Q: Is iOS badge support different from Android?**
A: Yes, iOS uses `UNUserNotificationCenter` directly, while Android uses ShortcutBadger + notifications. The plugin abstracts these differences behind a unified API.

**Q: Does macOS badge support require notifications or special entitlements?**
A: No. macOS Dock badges use `NSApplication.shared.dockTile.badgeLabel`, which is a native Dock UI API that works without any notification permission, `Info.plist` entries, or entitlements. Do **not** add `com.apple.developer.usernotifications.time-sensitive` — it requires a paid Apple Developer certificate and will cause build failures in development.

## Contributing

Feel free to open issues or pull requests for any features or bug fixes. Please ensure:
- Code follows Dart/Swift/Kotlin best practices
- Contributions are tested on real iOS and Android devices
- New features include documentation updates

