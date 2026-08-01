# Changelog

## [2.0.0] - 2026-08-01
### Changed
- Migrated the Android build to the built-in Kotlin path for AGP 8.11+/9+ readiness.
- Removed the plugin-side Kotlin Gradle Plugin application so the plugin is no longer tied to a separate KGP setup.
- Updated the example Android project to use newer AGP/Kotlin Gradle settings and a newer Gradle wrapper.
- Added Swift Package Manager support for the iOS plugin and example app to align with modern Flutter/iOS packaging expectations.
- Added UIScene lifecycle support for the example iOS app to keep it compatible with current iOS app lifecycle requirements.
- Removed the incompatible example notification dependency and related CocoaPods integration so the iOS example builds cleanly again.

### Fixed
- Restored iOS example app builds by switching to Swift Package Manager-compatible plugin wiring and removing the blocking notification dependency.
- Updated app metadata and versioning guidance for App Store submission readiness.

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
