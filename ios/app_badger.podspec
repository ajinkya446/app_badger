Pod::Spec.new do |s|
  s.name             = 'app_badger'
  s.version          = '2.0.0'
  s.summary          = 'A Flutter plugin to manage app badge counts on Android and iOS.'
  s.description      = <<-DESC
A Flutter plugin to update app badge count on Android (including Xiaomi devices) and iOS. 
This plugin allows you to set and remove app icon badges on supported platforms.
                       DESC
  s.homepage         = 'https://github.com/ajinkya446/app_badger'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ajinkya' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'app_badger/Sources/app_badger/**/*.swift'
  s.resource_bundles = {'app_badger_privacy' => ['app_badger/Sources/app_badger/PrivacyInfo.xcprivacy']}
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
