#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint app_badger.podspec` to validate before publishing.
#
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
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'app_badger_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
