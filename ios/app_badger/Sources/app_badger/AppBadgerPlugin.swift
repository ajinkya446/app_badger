import Flutter
import UIKit
import UserNotifications

public class AppBadgerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "app_badger", binaryMessenger: registrar.messenger())
        let instance = AppBadgerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "updateBadgeCount":
            if let args = call.arguments as? [String: Any],
               let count = args["count"] as? Int {
                if #available(iOS 16.0, *) {
                    UNUserNotificationCenter.current().setBadgeCount(count) { error in
                        DispatchQueue.main.async {
                            if let error = error {
                                result(FlutterError(code: "BADGE_ERROR", message: "Failed to set badge", details: error.localizedDescription))
                            } else {
                                result(true)
                            }
                        }
                    }
                } else {
                    UIApplication.shared.applicationIconBadgeNumber = count
                    result(true)
                }
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing count", details: nil))
            }

        case "removeBadge":
            if #available(iOS 16.0, *) {
                UNUserNotificationCenter.current().setBadgeCount(0) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            result(FlutterError(code: "BADGE_ERROR", message: "Failed to remove badge", details: error.localizedDescription))
                        } else {
                            result(true)
                        }
                    }
                }
            } else {
                UIApplication.shared.applicationIconBadgeNumber = 0
                result(true)
            }

        case "getBadgeCount":
            DispatchQueue.main.async {
                result(UIApplication.shared.applicationIconBadgeNumber)
            }

        case "isNotificationEnabled":
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    result(settings.authorizationStatus == .authorized)
                }
            }

        case "openNotificationSettings":
            if let appSettings = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                result(true)
            } else {
                result(FlutterError(code: "SETTINGS_ERROR", message: "Unable to open settings", details: nil))
            }

        case "isBadgeSupported":
            DispatchQueue.main.async {
                if UIApplication.shared.isRegisteredForRemoteNotifications {
                   result(true)
                } else {
                   result(false)
                }
            }

        case "requestNotificationPermission":
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
                    DispatchQueue.main.async {
                        result(granted)
                    }
                }
            } else {
                let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                result(true)
            }

        case "getPermissionStatus":
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        switch settings.authorizationStatus {
                        case .authorized:
                            result("granted")
                        case .denied:
                            result("denied")
                        case .notDetermined:
                            result("notDetermined")
                        case .provisional:
                            result("provisional")
                        @unknown default:
                            result("notDetermined")
                        }
                    }
                }
            } else {
                result("notDetermined")
            }

        case "getDeviceManufacturer":
            result("Apple")

        case "getDeviceBrand":
            result("Apple")

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
