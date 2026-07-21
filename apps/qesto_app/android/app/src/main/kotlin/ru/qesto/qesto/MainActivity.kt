package ru.qesto.qesto

import android.app.NotificationManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "ru.qesto.qesto/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasAccess" -> result.success(hasNotificationAccess())

                "openSettings" -> {
                    startActivity(
                        Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS),
                    )
                    result.success(null)
                }

                "readNotifications" -> {
                    result.success(
                        NotificationInbox.readAll(applicationContext),
                    )
                }

                "clearNotifications" -> {
                    NotificationInbox.clear(applicationContext)
                    result.success(null)
                }

                "removeNotification" -> {
                    val notificationKey = call.argument<String>("notificationKey")
                    if (notificationKey.isNullOrBlank()) {
                        result.error(
                            "invalid_notification_key",
                            "notificationKey is required",
                            null,
                        )
                    } else {
                        NotificationInbox.remove(
                            applicationContext,
                            notificationKey,
                        )
                        result.success(null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun hasNotificationAccess(): Boolean {
        val component = ComponentName(
            this,
            BankNotificationListener::class.java,
        )

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            val manager = getSystemService(
                Context.NOTIFICATION_SERVICE,
            ) as NotificationManager

            manager.isNotificationListenerAccessGranted(component)
        } else {
            val enabledListeners = Settings.Secure.getString(
                contentResolver,
                "enabled_notification_listeners",
            ).orEmpty()

            enabledListeners.contains(component.flattenToString())
        }
    }
}
