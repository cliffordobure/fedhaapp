package com.example.fedha

import android.widget.Toast
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupMethodChannel(flutterEngine)
    }

    private fun setupMethodChannel(flutterEngine: FlutterEngine) {
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.fedha/sms")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "readMessage" -> {
                    // Call your Dart readMessage() function
                    // You can pass any necessary data as arguments
                    Toast.makeText( this,  "Messages Read", Toast.LENGTH_LONG).show();
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}