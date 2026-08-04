Pod::Spec.new do |s|
  s.name             = 'app_badger'
  s.version          = '3.0.0'
  s.summary          = 'A Flutter plugin to manage app badge counts on Android, iOS, and macOS.'
  s.description      = <<-DESC
A Flutter plugin to update app badge count on Android, iOS, and macOS.
Supports launcher-specific badges on Android, UNUserNotificationCenter on iOS,
and NSApplication.dockTile on macOS.
                       DESC
  s.homepage         = 'https://github.com/ajinkya446/app_badger'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ajinkya' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'app_badger/Sources/app_badger/**/*.swift'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.14'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
