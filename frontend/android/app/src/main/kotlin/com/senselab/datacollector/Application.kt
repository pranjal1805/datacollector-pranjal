package com.senselab.datacollector

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin

open class Application: FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
//        FlutterFirebaseMessagingBackgroundService.
    }
    override fun registerWith(registry:PluginRegistry) {
//        FlutterFirebaseMessagingPlugin
//        registerWith(registry?.registrarFor(“io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin”))
    }
}