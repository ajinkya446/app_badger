# app_badger Flutter Plugin

A Flutter plugin to manage app badge counts on different Android devices (including Xiaomi, Samsung, HTC, Sony, Huawei, OPPO, and others) using the ShortcutBadger library. Supports iOS 10+ and Android 5+ (AGP 9+ ready).

## Version 2.0.0 Highlights

### iOS Updates
- ✨ **Swift Package Manager (SPM) Migration**: Plugin now uses SPM for better compatibility with Flutter 3.22+
- 🗑️ **Removed CocoaPods Integration**: Cleaner build system, faster compilation
- 🎯 **UIScene Lifecycle Support**: Full support for modern iOS app lifecycle

### Android Updates
- 🚀 **AGP 9+ Ready**: Built-in Kotlin support (no longer applies Kotlin Gradle Plugin)
- 📢 **Notification-Based Badge Fallback**: Dual badge delivery paths for improved reliability on modern Android
- 🔧 **Fixed Android Runtime Issues**: Resolved `XiaomiHomeBadger` ClassCastException
- 🔐 **Runtime Permission Handling**: Automatic `POST_NOTIFICATIONS` permission request (Android 13+)

### Platform Features
- 📱 **Automatic Permission Request**: `AppBadger.requestNotificationPermission()` for app startup
- 🐛 **Comprehensive Debugging**: Enhanced logging for troubleshooting badge issues
- 📚 **Improved Documentation**: Known limitations, workarounds, and platform-specific guidance
- ✅ **Battery-Efficient**: Lightweight notification implementation with minimal system impact

## Installation

To use the app_badger plugin in your Flutter project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  app_badger: ^2.0.0
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
- **iOS**: Requests notification permission with badge, sound, and alert options
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
- **Swift Package Manager**: Required (CocoaPods support removed in v2.0.0)
- **UIScene Lifecycle**: Required for iOS 13+

### Android
- **Minimum Android API**: 21 (Android 5.0+)
- **Gradle Plugin**: AGP 8.11+ (no Kotlin Gradle Plugin needed)
- **Kotlin**: 2.0+
- **Runtime Permissions**: `POST_NOTIFICATIONS` (Android 13+)

## Migration Guide: v1.x → v2.0.0

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

### Flutter/Dart Changes
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
| **Badge Disappears in Background** | Android launcher limitation (common behavior) | Ensure notifications enabled; some launchers have badge visibility settings |
| **Badge Only Works with Notifications** | On some devices, badge needs active notification | Use notification-based badge delivery (automatic in v2.0.0+) |
| **Xiaomi Badge Not Working** | Device-specific badge implementation | Ensure MIUI badge permissions are in `AndroidManifest.xml` |
| **iOS Badge Not Showing** | Notification permission not granted | Call `AppBadger.requestNotificationPermission()` in `initState()` |
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

5. **Test on physical device:**
   - Simulators/emulators may not fully support badge functionality
   - Test on real Android and iOS devices when possible

## Frequently Asked Questions

**Q: Do I need to migrate from v1.x?**
A: Yes, v2.0.0 requires iOS 10+ and Android AGP 8.11+. CocoaPods is no longer supported on iOS. See Migration Guide above.

**Q: Why did the badge disappear when my app backgrounded?**
A: This is a known Android launcher limitation. Many launchers only show badges when the app is in foreground or actively receiving notifications. Ensure notifications are enabled in device settings.

**Q: Can I use the plugin without requesting permission?**
A: Permission is not strictly required to call badge methods, but badges work more reliably when permission is granted. Calling `requestNotificationPermission()` on startup is strongly recommended.

**Q: Which Android devices/launchers are supported?**
A: The plugin supports most Android launchers including Stock Android, Samsung, Xiaomi, HTC, Sony, Huawei, OPPO, and many others. Device-specific permissions are included in the example manifest.

**Q: What's the difference between ShortcutBadger and notification-based badges?**
A: v2.0.0 uses both: ShortcutBadger for native launcher badges (fastest) + notification-based fallback (most reliable on modern Android). The plugin automatically uses both for maximum compatibility.

**Q: Do I need to use push notifications?**
A: Not required, but recommended for badges to persist. Use local notifications if needed to "refresh" the badge when your app backgrounds.

**Q: Is iOS badge support different from Android?**
A: Yes, iOS uses `UNUserNotificationCenter` directly, while Android uses ShortcutBadger + notifications. The plugin abstracts these differences behind a unified API.

## Contributing

Feel free to open issues or pull requests for any features or bug fixes. Please ensure:
- Code follows Dart/Swift/Kotlin best practices
- Contributions are tested on real iOS and Android devices
- New features include documentation updates

