# Changelog

## [3.0.0] - 2026-08-04

### Major Release: Complete Flutter & Platform Modernization

**This is a major version bump reflecting:**
- Complete removal of CocoaPods integration on iOS and macOS in favor of Swift Package Manager (SPM)
- Enhanced Android badge reliability with dual ShortcutBadger + notification-based fallback system
- Comprehensive v2.0.5 feature stabilization and documentation improvements
- All documented limitations in v2.x have been resolved or significantly improved

### Added

#### New Platform Features
- **Full Swift Package Manager (SPM) integration** for iOS and macOS with automatic plugin discovery
- **macOS Dock tile badge support**: Full Dock tile badge support via `NSApplication.dockTile.badgeLabel` using Swift Package Manager layout (`macos/app_badger/`)

#### New APIs (v2.0.5 features promoted to v3.0.0)
- **`getBadgeCount()`**: Read the current badge count (persisted via `SharedPreferences` on Android; reads `applicationIconBadgeNumber` on iOS)
- **`incrementBadge()`**: Convenience method to increment the badge count by 1; returns the new count
- **`decrementBadge()`**: Convenience method to decrement the badge count by 1 (minimum 0); returns the new count
- **`getDeviceManufacturer()`**: Returns `Build.MANUFACTURER` on Android or `"Apple"` on iOS/macOS
- **`getDeviceBrand()`**: Returns `Build.BRAND` on Android or `"Apple"` on iOS/macOS
- **`getPermissionStatus()`**: Returns a `BadgePermissionStatus` enum value (`granted`, `denied`, `notDetermined`, `restricted`, `provisional`) with full iOS `UNAuthorizationStatus` mapping and Android 13+ `POST_NOTIFICATIONS` check
- **`BadgePermissionStatus` enum**: Fine-grained permission model covering all iOS states and Android notification states
- **`BadgeLifecycleObserver` mixin**: Add `with BadgeLifecycleObserver` to any `State` class, call `initBadgeLifecycle()` / `disposeBadgeLifecycle()`, and set `clearBadgeOnResume = true` (default) to automatically clear the badge when the app returns to the foreground

#### Enhanced Android Features
- **Badge persistence** (Android): Badge count is persisted in `SharedPreferences` (`app_badger_prefs`) on every `updateBadgeCount` / `removeBadge` call so `getBadgeCount()` survives process restarts
- **Dual badge delivery system** (ShortcutBadger + notification-based fallback)
- **Expanded Android manufacturer support** (Vivo, LG, Realme, Nova, OnePlus): Added manifest permission entries for Vivo, OnePlus, LG, Realme (ColorOS), and Nova Launcher

#### Documentation & Examples
- **Firebase push integration examples** in documentation
- **Comprehensive badge lifecycle management** with `BadgeLifecycleObserver` mixin

### Changed
- **`updateBadgeCount()` / `removeBadge()` now return `Future<bool>`** for success/failure signaling (returns `true` on success instead of `void`)
- **iOS `requestNotificationPermission`**: Is now a proper method-channel handler that awaits `requestAuthorization` and returns the actual granted value instead of a fire-and-forget call
- **CocoaPods removed completely** from iOS/macOS — SPM is now the only dependency manager
- **Android setup simplified** with comprehensive permission examples and `requestNotificationPermission()` helper
- **iOS minimum version** remains 10.0+ with full UIScene support for iOS 13+
- **macOS minimum version** remains 10.14+ with SPM-based package layout
- **pubspec description**: Updated to mention macOS support

### Fixed
- **iOS CocoaPods integration issues** completely resolved
- **Android background badge visibility** significantly improved with notification fallback
- **Android manufacturer compatibility** expanded with dual-path badge delivery
- **Badge state persistence** on Android via SharedPreferences
- **Auto-clear on app resume** now available via `BadgeLifecycleObserver` mixin

### Removed
- **CocoaPods dependency** on iOS and macOS (migration required; see Migration Guide)
- **Implicit badge clearing** on app resume (use `BadgeLifecycleObserver` for explicit control)

### Migration from v2.x
v3.0.0 builds on v2.0.5 with the following breaking changes:
- **CocoaPods removed**: Must use Swift Package Manager (SPM) for iOS and macOS — no more Podfiles
- **Requires Flutter 3.22+** for full SPM support
- **New return types**: `updateBadgeCount()` and `removeBadge()` now return `Future<bool>` — update callers to capture the result
- **macOS adoption**: If you were using v2.0.5 on macOS, all features carry forward with SPM-only packaging

## [2.0.4] - 2026-08-02

### Fixed
- **iOS SPM package identity**: Corrected `Package.swift` to use `app-badger`, matching Flutter's Swift Package Manager convention.
- **Flutter iOS integration warnings**: Resolves recent `Plugin does not support Swift Package Manager for ios` warnings.
- **Complete SPM support**: Confirms the plugin ships with the required `Package.swift` product declarations for Flutter 3.22+.

## [2.0.3] - 2026-08-02

### Fixed
- **iOS SPM follow-up**: Additional Swift Package Manager compatibility adjustments for the 2.0.x release line.


## [2.0.2] - 2026-08-02

### Fixed
- **Initial iOS SPM corrections**: Began aligning package identity and package manifest support for Flutter 3.22+.

## [2.0.1] - 2026-08-02

### Fixed
- **iOS SPM Support**: Removed unnecessary Package.swift that was causing conflicts. Flutter handles SPM plugin integration automatically.
- **Resolved package identity conflicts**: Fixes "unable to override package" errors when using app_badger with pub.dev
- **Improved build reliability**: Cleaner iOS build system leveraging Flutter's automatic SPM handling

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
