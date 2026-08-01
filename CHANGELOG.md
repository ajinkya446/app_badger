# Changelog

## [2.0.1] - 2026-08-02

### Fixed
- **iOS SPM package identity conflict**: Removed Package.swift from plugin directory that caused "unable to override package 'app_badger' because its identity 'app_badger-2.0.0' doesn't match override's identity" error
- **Local path dependency support**: Plugin now works correctly when used as `path:` dependency in local projects
- **Example app build**: Resolved SPM resolution errors when building example app locally

## [2.0.0] - 2026-08-01

### Added
- **Automatic permission request**: New `AppBadger.requestNotificationPermission()` method for requesting `POST_NOTIFICATIONS` (Android 13+) and notification permissions (iOS) on app startup
- **Notification-based badge fallback**: Dual-path badge delivery using ShortcutBadger (primary) + system notifications (fallback) for improved reliability on modern Android devices
- **ActivityAware interface**: Android plugin now implements ActivityAware for proper runtime permission handling
- **Comprehensive logging**: Added detailed AppBadger logs for debugging badge lifecycle (apply, clear, notification posts)
- **Enhanced documentation**: Complete README rewrite with platform requirements, migration guide, troubleshooting, and FAQ sections
- **Example app improvements**: Updated example to demonstrate permission request on startup and show real-time permission status

### Changed
- **iOS**: Migrated plugin to Swift Package Manager (SPM) layout for Flutter 3.22+ compatibility
- **iOS**: Removed all CocoaPods integration from plugin and example app
- **iOS**: Added UIScene lifecycle support for modern iOS app architecture
- **Android**: Migrated build to built-in Kotlin path for AGP 8.11+/9+ readiness
- **Android**: Removed plugin-side Kotlin Gradle Plugin application (only needed at app level)
- **Android**: Updated example to use AGP 8.11.1, Kotlin 2.2.20, Gradle 8.14.1
- **Android**: Added `POST_NOTIFICATIONS` permission to plugin and example manifests
- **iOS**: Updated example Info.plist with notification usage description
- **Documentation**: Rewrote README with version highlights, platform requirements, and complete API examples

### Fixed
- **Android runtime crash**: Removed invalid XiaomiHomeBadger broadcast receiver from example manifest (was causing ClassCastException)
- **iOS build errors**: Resolved CocoaPods conflicts by switching to Swift Package Manager
- **Badge permission handling**: Plugin now properly requests and handles notification permissions on both platforms
- **Background badge behavior**: Documented Android launcher limitation and provided workarounds

### Removed
- ❌ iOS CocoaPods integration (use SPM instead)
- ❌ XiaomiHomeBadger broadcast receiver from example (no longer needed)
- ❌ Plugin-side Kotlin Gradle Plugin (use AGP built-in support)

### Known Limitations
- Android background badge disappearance: Many launchers clear badge when app backgrounded (launcher-specific behavior)
- Device-specific badge support: Varies by manufacturer (Samsung, Xiaomi, etc. require specific permissions)

### Migration from 1.x
- **iOS**: Delete Podfile and Pods directory, run `flutter clean`
- **Android**: Update app build.gradle.kts to use AGP 8.11+ and built-in Kotlin
- **Both platforms**: Call `AppBadger.requestNotificationPermission()` on app startup
- **Android**: Ensure `POST_NOTIFICATIONS` permission in AndroidManifest.xml
- **iOS**: Ensure `NSUserNotificationUsageDescription` in Info.plist

## [0.0.3] - 2026-02-24
### Added
- Glassmorphism badge and container widgets for modern UI overlays.
- Consistent MethodChannel name for plugin registration.
- Improved documentation and design system.
- Bug fixes and compatibility improvements.

## [0.0.2] - 2025-04-28
### Added
- iOS device configuration and badge notification setup.

## [0.0.1] - 2025-04-20
### Added
- Android device badge notification support.
