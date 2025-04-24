package com.ajinkya.app_badger

import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import me.leolin.shortcutbadger.ShortcutBadger

class AppBadgerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private var applicationContext: Context? = null
    private var channel: MethodChannel? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel?.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        applicationContext = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "updateBadgeCount" -> {
                try {
                    val count = call.argument<Int>("count") ?: 0
                    val success = ShortcutBadger.applyCount(applicationContext!!, count)
                    Log.d("ShortcutBadger", "Badge count applied: $success, Count: $count")
                    result.success(null)
                } catch (e: Exception) {
                    Log.e("ShortcutBadger", "Failed to apply badge count", e)
                    result.error("BADGE_ERROR", "Failed to update badge count", e.localizedMessage)
                }
            }

            "removeBadge" -> {
                try {
                    ShortcutBadger.removeCount(applicationContext!!)
                    Log.d("ShortcutBadger", "Badge count removed successfully")
                    result.success(null)
                } catch (e: Exception) {
                    Log.e("ShortcutBadger", "Failed to remove badge count", e)
                    result.error("BADGE_ERROR", "Failed to remove badge count", e.localizedMessage)
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

            else -> result.notImplemented()
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

    companion object {
        private const val CHANNEL_NAME = "app_badger"
    }
}
