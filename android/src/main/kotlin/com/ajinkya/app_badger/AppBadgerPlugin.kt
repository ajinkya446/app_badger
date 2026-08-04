package com.ajinkya.app_badger

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import me.leolin.shortcutbadger.ShortcutBadger

class AppBadgerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private var applicationContext: Context? = null
    private var channel: MethodChannel? = null
    private var activityBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel?.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        applicationContext = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "updateBadgeCount" -> {
                val context = applicationContext
                val count = call.argument<Int>("count") ?: 0

                if (context == null) {
                    result.error("BADGE_ERROR", "Application context is unavailable", null)
                    return
                }

                try {
                    applyBadgeCount(context, count)
                    persistBadgeCount(context, count)
                    result.success(true)
                } catch (e: Exception) {
                    Log.e("ShortcutBadger", "Failed to apply badge count", e)
                    result.error("BADGE_ERROR", "Failed to update badge count", e.localizedMessage)
                }
            }

            "removeBadge" -> {
                val context = applicationContext

                if (context == null) {
                    result.error("BADGE_ERROR", "Application context is unavailable", null)
                    return
                }

                try {
                    clearBadge(context)
                    persistBadgeCount(context, 0)
                    result.success(true)
                } catch (e: Exception) {
                    Log.e("ShortcutBadger", "Failed to remove badge count", e)
                    result.error("BADGE_ERROR", "Failed to remove badge count", e.localizedMessage)
                }
            }

            "getBadgeCount" -> {
                val context = applicationContext
                if (context == null) {
                    result.success(0)
                    return
                }
                val prefs = getPrefs(context)
                result.success(prefs.getInt(PREF_BADGE_COUNT, 0))
            }

            "getDeviceManufacturer" -> {
                result.success(Build.MANUFACTURER)
            }

            "getDeviceBrand" -> {
                result.success(Build.BRAND)
            }

            "getPermissionStatus" -> {
                val context = applicationContext
                if (context == null) {
                    result.success("notDetermined")
                    return
                }
                val notificationsEnabled = NotificationManagerCompat.from(context).areNotificationsEnabled()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    val hasPermission = ContextCompat.checkSelfPermission(
                        context,
                        android.Manifest.permission.POST_NOTIFICATIONS
                    ) == android.content.pm.PackageManager.PERMISSION_GRANTED
                    result.success(
                        if (notificationsEnabled && hasPermission) "granted"
                        else if (!hasPermission) "notDetermined"
                        else "denied"
                    )
                } else {
                    result.success(if (notificationsEnabled) "granted" else "denied")
                }
            }

            "isNotificationEnabled" -> {
                result.success(isNotificationEnabled())
            }

            "openNotificationSettings" -> {
                openAppNotificationSettings()
                result.success(true)
            }

            "isBadgeSupported" -> {
                checkIfBadgeSupported(applicationContext!!, result)
            }

            "requestNotificationPermission" -> {
                requestNotificationPermission(result)
            }

            else -> result.notImplemented()
        }
    }

    private fun persistBadgeCount(context: Context, count: Int) {
        getPrefs(context).edit().putInt(PREF_BADGE_COUNT, count).apply()
    }

    private fun getPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    private fun applyBadgeCount(context: Context, count: Int) {
        Log.d("AppBadger", "applyBadgeCount called with count=$count")
        
        if (count <= 0) {
            Log.d("AppBadger", "Count is 0 or negative, clearing badge")
            clearBadge(context)
            return
        }

        try {
            Log.d("AppBadger", "Attempting ShortcutBadger.applyCount for count=$count")
            val success = ShortcutBadger.applyCount(context, count)
            Log.d("AppBadger", "ShortcutBadger.applyCount result: $success")
        } catch (e: Exception) {
            Log.e("AppBadger", "ShortcutBadger.applyCount failed", e)
        }

        val notificationsEnabled = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            NotificationManagerCompat.from(context).areNotificationsEnabled()
        } else {
            true
        }

        Log.d("AppBadger", "Notifications enabled: $notificationsEnabled")

        if (notificationsEnabled) {
            try {
                val notification = buildBadgeNotification(context, count)
                Log.d("AppBadger", "Posting badge notification with count=$count")
                NotificationManagerCompat.from(context).notify(BADGE_NOTIFICATION_ID, notification.build())
                Log.d("AppBadger", "Badge notification posted successfully")
            } catch (e: Exception) {
                Log.w("AppBadger", "Failed to post badge notification", e)
            }
        } else {
            Log.w("AppBadger", "Notifications are disabled, badge update will rely only on ShortcutBadger")
        }
    }

    private fun clearBadge(context: Context) {
        Log.d("AppBadger", "clearBadge called")
        try {
            NotificationManagerCompat.from(context).cancel(BADGE_NOTIFICATION_ID)
            Log.d("AppBadger", "Badge notification cancelled")
        } catch (e: Exception) {
            Log.w("AppBadger", "Failed to cancel badge notification", e)
        }

        try {
            val success = ShortcutBadger.removeCount(context)
            Log.d("AppBadger", "ShortcutBadger.removeCount result: $success")
        } catch (e: Exception) {
            Log.e("AppBadger", "ShortcutBadger.removeCount failed", e)
        }
    }

    private fun buildBadgeNotification(context: Context, count: Int): NotificationCompat.Builder {
        ensureBadgeChannel(context)
        return NotificationCompat.Builder(context, BADGE_CHANNEL_ID)
            .setSmallIcon(context.applicationInfo.icon)
            .setContentTitle("App badge")
            .setContentText("Badge count: $count")
            .setNumber(count)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOnlyAlertOnce(true)
            .setAutoCancel(false)
            .setSilent(true)
            .setOngoing(true)
            .setCategory(NotificationCompat.CATEGORY_STATUS)
            .setVisibility(NotificationCompat.VISIBILITY_SECRET)
    }

    private fun ensureBadgeChannel(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channel = NotificationChannel(
                BADGE_CHANNEL_ID,
                "App badge updates",
                NotificationManager.IMPORTANCE_LOW,
            )
            channel.description = "Used to sync badge counts with the launcher"
            manager.createNotificationChannel(channel)
        }
    }

    private fun isNotificationEnabled(): Boolean {
        val context = applicationContext ?: return false
        return NotificationManagerCompat.from(context).areNotificationsEnabled()
    }

    private fun openAppNotificationSettings() {
        val context = applicationContext ?: return
        val intent = Intent()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            intent.action = Settings.ACTION_APP_NOTIFICATION_SETTINGS
            intent.putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
        } else {
            intent.action = "android.settings.APP_NOTIFICATION_SETTINGS"
            intent.putExtra("app_package", context.packageName)
            intent.putExtra("app_uid", context.applicationInfo.uid)
        }
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(intent)
    }

    fun checkIfBadgeSupported(context: Context, result: MethodChannel.Result) {
        val isSupported = ShortcutBadger.isBadgeCounterSupported(context)
        result.success(isSupported)
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        Log.d("AppBadger", "requestNotificationPermission called")
        
        val activity = activityBinding?.activity
        if (activity == null) {
            Log.w("AppBadger", "Activity is not available, assuming permission already granted")
            result.success(true)
            return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val permission = android.Manifest.permission.POST_NOTIFICATIONS
            val hasPermission = ContextCompat.checkSelfPermission(activity, permission) == android.content.pm.PackageManager.PERMISSION_GRANTED
            
            if (hasPermission) {
                Log.d("AppBadger", "POST_NOTIFICATIONS permission already granted")
                result.success(true)
            } else {
                Log.d("AppBadger", "Requesting POST_NOTIFICATIONS permission")
                ActivityCompat.requestPermissions(activity, arrayOf(permission), NOTIFICATION_PERMISSION_REQUEST_CODE)
                result.success(false)
            }
        } else {
            Log.d("AppBadger", "Android version < 13, POST_NOTIFICATIONS not required")
            result.success(true)
        }
    }

    companion object {
        private const val CHANNEL_NAME = "app_badger"
        private const val BADGE_NOTIFICATION_ID = 1001
        private const val BADGE_CHANNEL_ID = "app_badger_badges"
        private const val NOTIFICATION_PERMISSION_REQUEST_CODE = 1001
        private const val PREFS_NAME = "app_badger_prefs"
        private const val PREF_BADGE_COUNT = "badge_count"
    }
}
