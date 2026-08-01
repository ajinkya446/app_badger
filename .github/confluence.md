# App Badger Flutter Plugin: Confluence Article

## Overview

App Badger is a Flutter plugin that enables app badge count management for Android and iOS devices, including support for brands like Xiaomi, Samsung, HTC, Sony, Huawei, OPPO, and more. It leverages the ShortcutBadger library for Android and native APIs for iOS.

---

## Latest Version: 0.0.3

### Key Features
- **Glassmorphism Badge Widget**: `GlassMorphismBadge` for in-app overlays with frosted glass effect.
- **Glassmorphism Container Widget**: `GlassMorphismContainer` for glassmorphism UI backgrounds, cards, overlays.
- **Consistent MethodChannel**: Uses `app_badger` for plugin registration and communication.
- **Design System**: Unified badge and UI overlay design for modern Flutter apps.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  app_badger: ^0.0.3
```

For local development:

```yaml
dependencies:
  app_badger:
    path: ../
```

Run:

```bash
flutter pub get
```

---

## Android Setup

Add the required permissions to your `AndroidManifest.xml`:

```xml
<!-- Required on Android 13+ for notification-based badge updates -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<!-- Optional launcher permissions for device-specific badge support -->
<!-- Permissions for Xiaomi, Samsung, HTC, Sony, Huawei, OPPO, etc. -->
```

Badge updates should be triggered by notifications (local or push).

---

## iOS Setup

Add notification permissions to `Info.plist` and ensure plugin registration in `AppDelegate.swift`.

---

## Usage Examples

### Update Badge Count
```dart
AppBadger.updateBadgeCount(5); // Set badge count to 5
```

### Remove Badge
```dart
AppBadger.removeBadge(); // Remove badge
```

### Check Badge Support
```dart
bool isSupported = await AppBadger.isBadgeSupported();
```

### Glassmorphism Badge (In-App UI)
```dart
Stack(
  alignment: Alignment.topRight,
  children: [
    Icon(Icons.notifications, size: 48),
    GlassMorphismBadge(count: 7),
  ],
)
```

### Glassmorphism Container (UI Backgrounds)
```dart
GlassMorphismContainer(
  child: Column(
    children: [
      // ...your widgets...
    ],
  ),
)
```

---

## Troubleshooting

- **MissingPluginException**: Ensure MethodChannel name is `app_badger` in Dart and native code. Do a full restart after plugin changes.
- **Badge Not Showing on Xiaomi Devices**: Add the required launcher permissions in `AndroidManifest.xml` and verify that the launcher supports badge updates.
- **Badge Not Working**: Badge counts may not be supported on all devices; check permissions and settings.
- **Notification Badge Only Works After Notification**: Badge updates should be triggered by notifications.

---

## Contributing

Open issues or pull requests for features or bug fixes.

---

## References
- [README.md](../README.md)
- [ShortcutBadger Library](https://github.com/leolin310/ShortcutBadger)
- [Flutter Documentation](https://docs.flutter.dev/)

---

*Last updated: February 24, 2026*

