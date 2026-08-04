import Cocoa
import FlutterMacOS
import UserNotifications

public class AppBadgerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "app_badger", binaryMessenger: registrar.messenger)
        let instance = AppBadgerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "updateBadgeCount":
            guard let args = call.arguments as? [String: Any], let count = args["count"] as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing count", details: nil))
                return
            }
            DispatchQueue.main.async {
                NSApplication.shared.dockTile.badgeLabel = count > 0 ? "\(count)" : nil
                result(true)
            }

        case "removeBadge":
            DispatchQueue.main.async {
                NSApplication.shared.dockTile.badgeLabel = nil
                result(true)
            }

        case "getBadgeCount":
            DispatchQueue.main.async {
                if let label = NSApplication.shared.dockTile.badgeLabel, let count = Int(label) {
                    result(count)
                } else {
                    result(0)
                }
            }

        case "isBadgeSupported":
            result(true)

        case "isNotificationEnabled":
            if #available(macOS 10.14, *) {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        result(settings.authorizationStatus == .authorized)
                    }
                }
            } else {
                result(true)
            }

        case "requestNotificationPermission":
            if #available(macOS 10.14, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
                    DispatchQueue.main.async {
                        result(granted)
                    }
                }
            } else {
                result(true)
            }

        case "getPermissionStatus":
            if #available(macOS 10.14, *) {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        switch settings.authorizationStatus {
                        case .authorized: result("granted")
                        case .denied: result("denied")
                        case .notDetermined: result("notDetermined")
                        case .provisional: result("provisional")
                        @unknown default: result("notDetermined")
                        }
                    }
                }
            } else {
                result("granted")
            }

        case "openNotificationSettings":
            if #available(macOS 14.0, *) {
                if let url = URL(string: "x-apple.systempreferences:com.apple.Notifications-Settings.extension") {
                    NSWorkspace.shared.open(url)
                }
            }
            result(true)

        case "getDeviceManufacturer":
            result("Apple")

        case "getDeviceBrand":
            result("Apple")

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
