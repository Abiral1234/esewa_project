package com.example.addtoapp

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MyFlutterActivity : FlutterActivity() {

    private val CHANNEL = "app/payment" // MUST match Flutter side

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "goToNative" -> {
                        finish()
                        result.success(null)
                    }

                    "getLoginData" -> {
                        val prefs = getSharedPreferences("loginData", MODE_PRIVATE)

                        val uuid = prefs.getString("uuid", "")
                        val theme = prefs.getString("theme", "light")

                        val data = mapOf(
                            "uuid" to uuid,
                            "theme" to theme
                        )

                        result.success(data)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
