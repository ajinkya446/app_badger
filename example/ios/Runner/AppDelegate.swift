import UIKit
import Flutter
import app_badger  // Import the plugin here

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self) // Register the Flutter plugins
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
