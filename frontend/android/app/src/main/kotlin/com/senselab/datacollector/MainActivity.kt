package com.senselab.datacollector

import android.Manifest
import android.bluetooth.*
import android.content.ComponentName
import android.content.Intent
import android.content.ServiceConnection
import android.os.*
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private lateinit var sensorServiceIntent: Intent
    private var mBound: Boolean = false
    private lateinit var mService: SensorService
    private var bluetoothHandler: BluetoothHandler = BluetoothHandler()

    companion object {
        private const val CHANNEL = "android/sensor/service"
        private const val BLUETOOTH_CHANNEL = "android/bluetooth"

        @RequiresApi(Build.VERSION_CODES.S)
        private val PERMISSIONS = arrayOf(
            Manifest.permission.BLUETOOTH_CONNECT,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.BLUETOOTH,
            Manifest.permission.BLUETOOTH_ADMIN,
            Manifest.permission.BLUETOOTH_SCAN
        )
    }

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName?, service: IBinder?) {
            val binder = service as SensorService.SensorServiceBinder
            mService = binder.getSensorService()
            mBound = true
        }

        override fun onServiceDisconnected(className: ComponentName?) {
            mBound = false
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sensorServiceIntent = Intent(this, SensorService::class.java).also { intent ->
            bindService(intent, serviceConnection, BIND_AUTO_CREATE)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(sensorServiceIntent)
        } else {
            startService(sensorServiceIntent)
        }
    }

    override fun onStop() {
        super.onStop()
        unbindService(serviceConnection)
        mBound = false
    }

    @RequiresApi(Build.VERSION_CODES.S)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, _ ->
            when (call.method) {
                "serviceOff" -> stopService(sensorServiceIntent)
                "startGyro" -> mService.switchGyro(true)
                "stopGyro" -> mService.switchGyro(false)
                "startMagneto" -> mService.switchMagneto(true)
                "stopMagneto" -> mService.switchMagneto(false)
                "startAccel" -> mService.switchAccel(true)
                "stopAccel" -> mService.switchAccel(false)
                "startPPG" -> mService.switchPPG(true)
                "stopPPG" -> mService.switchPPG(false)
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BLUETOOTH_CHANNEL
        ).setMethodCallHandler { call, _ ->
            if (call.method == "getBluetoothDevices") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    bluetoothHandler.checkPermissions(activity, applicationContext)
                    bluetoothHandler.initHandler(applicationContext)
                    bluetoothHandler.initBT(applicationContext)
                }
            }
            if (call.method == "showScannedDevices") {
                bluetoothHandler.showScannedDevices(applicationContext)
            }
            if (call.method == "connectToDevice") {
                Log.d("DATA_COLLECTOR_SCAN", "connectToDevice")
                bluetoothHandler.connectToDevice(applicationContext)
            }
            if (call.method == "disconnectDevice") {
                bluetoothHandler.disconnectDevice()
            }
            if (call.method == "previouslyConnectedDevices") {
                bluetoothHandler.showPreviouslyConnectedDevices()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.S)
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 1)
            bluetoothHandler.scanBLEdevices(this)
    }
}