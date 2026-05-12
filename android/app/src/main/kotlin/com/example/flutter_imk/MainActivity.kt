package com.example.flutter_imk

import io.flutter.embedding.android.FlutterFragmentActivity // ubah import
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterFragmentActivity() { // ubah extends ke FlutterFragmentActivity
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}