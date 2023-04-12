package com.senselab.data_collector_wearos

import SampleGattAttributes
import android.Manifest
import android.app.Activity
import android.bluetooth.*
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import com.senselab.data_collector_wearos.databinding.ActivityMainBinding
import java.util.*

class MainActivity : Activity() {

    private lateinit var binding: ActivityMainBinding
    private lateinit var sensorServiceIntent: Intent
    private lateinit var mService: SensorService
    private var mBound: Boolean = false


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.accelButton.setOnClickListener {
            sensorServiceIntent = Intent(this, SensorService::class.java).also { intent ->
                bindService(intent, accelDataConnection, BIND_AUTO_CREATE)
            }
            startForegroundService(sensorServiceIntent)

        }

        binding.heartRateButton.setOnClickListener {
            sensorServiceIntent = Intent(this, SensorService::class.java).also { intent ->
                bindService(intent, hearRateDataConnection, BIND_AUTO_CREATE)
            }
                startForegroundService(sensorServiceIntent)
        }

        FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
            if (!task.isSuccessful) {
                Log.w("WATCH_NOTIF", "Fetching FCM registration token failed", task.exception)
                return@OnCompleteListener
            }

            // Get new FCM registration token
            val token = task.result

            // Log and toast
//            val msg = getString(token)
            Log.d("WATCH_NOTIF", token)
            Toast.makeText(baseContext, token, Toast.LENGTH_SHORT).show()
        })

        binding.newGattServiceButton.setOnClickListener {
            val bleManager: BluetoothManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BLUETOOTH_CONNECT
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                Log.d("GATT SERVER SERVICES", "requesting permissions")
                ActivityCompat.requestPermissions(
                    this, arrayOf(Manifest.permission.BLUETOOTH_CONNECT), 1
                )
                return@setOnClickListener
            } else if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BLUETOOTH
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                Log.d("GATT SERVER SERVICES", "requesting permissions")
                ActivityCompat.requestPermissions(
                    this, arrayOf(Manifest.permission.BLUETOOTH), 1
                )
                return@setOnClickListener
            } else {
                bleManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
            }

            val gattServer = bleManager.openGattServer(this, mGattServerCallback)
            val service = BluetoothGattService(
                UUID.fromString(SampleGattAttributes.FAN_CONTROL_SERVICE_UUID),
                BluetoothGattService.SERVICE_TYPE_PRIMARY
            )
            val characteristic = BluetoothGattCharacteristic(
                UUID.fromString(SampleGattAttributes.FAN_OPERATING_STATE),
                BluetoothGattCharacteristic.FORMAT_UINT8,
                BluetoothGattCharacteristic.PERMISSION_WRITE
            )
            service.addCharacteristic(characteristic)
            gattServer.addService(service)
            Log.d(
                "GATT SERVER SERVICES",
                "${UUID.fromString(SampleGattAttributes.FAN_CONTROL_SERVICE_UUID)}"
            )
        }


    }

    private val accelDataConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName?, service: IBinder?) {
            val binder = service as SensorService.SensorServiceBinder
            mService = binder.getSensorService()
            mBound = true
            mService.switchAccel(true)
        }

        override fun onServiceDisconnected(className: ComponentName?) {
            mBound = false
        }
    }
    private val hearRateDataConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName?, service: IBinder?) {
            val binder = service as SensorService.SensorServiceBinder
            mService = binder.getSensorService()
            mBound = true
            mService.switchPPG(true)
        }

        override fun onServiceDisconnected(className: ComponentName?) {
            mBound = false
        }
    }


    private val mGattServerCallback: BluetoothGattServerCallback =
        object : BluetoothGattServerCallback() {
            override fun onConnectionStateChange(
                device: BluetoothDevice,
                status: Int,
                newState: Int
            ) {
                Log.d("HELLO", "Our gatt server connection state changed, new state ")
                Log.d("HELLO", Integer.toString(newState))
                super.onConnectionStateChange(device, status, newState)
            }

            override fun onServiceAdded(status: Int, service: BluetoothGattService) {
                Log.d("HELLO", "Our gatt server service was added.")
                super.onServiceAdded(status, service)
            }

            override fun onCharacteristicReadRequest(
                device: BluetoothDevice,
                requestId: Int,
                offset: Int,
                characteristic: BluetoothGattCharacteristic
            ) {
                Log.d("HELLO", "Our gatt characteristic was read.")
                super.onCharacteristicReadRequest(device, requestId, offset, characteristic)
            }

            override fun onCharacteristicWriteRequest(
                device: BluetoothDevice,
                requestId: Int,
                characteristic: BluetoothGattCharacteristic,
                preparedWrite: Boolean,
                responseNeeded: Boolean,
                offset: Int,
                value: ByteArray
            ) {
                Log.d(
                    "HELLO",
                    "We have received a write request for one of our hosted characteristics"
                )
                super.onCharacteristicWriteRequest(
                    device,
                    requestId,
                    characteristic,
                    preparedWrite,
                    responseNeeded,
                    offset,
                    value
                )
            }

            override fun onDescriptorReadRequest(
                device: BluetoothDevice,
                requestId: Int,
                offset: Int,
                descriptor: BluetoothGattDescriptor
            ) {
                Log.d("HELLO", "Our gatt server descriptor was read.")
                super.onDescriptorReadRequest(device, requestId, offset, descriptor)
            }

            override fun onDescriptorWriteRequest(
                device: BluetoothDevice,
                requestId: Int,
                descriptor: BluetoothGattDescriptor,
                preparedWrite: Boolean,
                responseNeeded: Boolean,
                offset: Int,
                value: ByteArray
            ) {
                Log.d("HELLO", "Our gatt server descriptor was written.")
                super.onDescriptorWriteRequest(
                    device,
                    requestId,
                    descriptor,
                    preparedWrite,
                    responseNeeded,
                    offset,
                    value
                )
            }

            override fun onExecuteWrite(device: BluetoothDevice, requestId: Int, execute: Boolean) {
                Log.d("HELLO", "Our gatt server on execute write.")
                super.onExecuteWrite(device, requestId, execute)
            }
        }

}