package com.senselab.data_collector_wearos
//
//import SampleGattAttributes
//import android.Manifest
//import android.app.Activity
//import android.app.Service
//import android.bluetooth.*
//import android.content.Context
//import android.content.Intent
//import android.content.pm.PackageManager
//import android.os.Binder
//import android.os.Build
//import android.os.IBinder
//import android.util.Log
//import android.widget.Toast
//import androidx.core.app.ActivityCompat
//import java.util.*
//
//
///**
// * Service for managing connection and data communication with a GATT server hosted on a
// * given Bluetooth LE device.
// */
//class BluetoothLeService : Service() {
//    private var mBluetoothManager: BluetoothManager? = null
//    private var mBluetoothAdapter: BluetoothAdapter? = null
//    private var mBluetoothDeviceAddress: String? = null
//    private var mBluetoothGatt: BluetoothGatt? = null
//    private var mBluetoothGattServer: BluetoothGattServer? = null
//    private var mConnectionState = STATE_DISCONNECTED
//
//
//    fun checkPermissions(activity: Activity?, context: Context?) {
//        Toast.makeText(context, "Checking for permissions", Toast.LENGTH_SHORT).show()
//        if (!hasPermissions(context, *PERMISSIONS)) {
//            Log.d(TAG, "ASKING FOR PERMISSION")
//            try {
//                ActivityCompat.requestPermissions(
//                    activity!!, PERMISSIONS, PERMISSION_ALL
//                )
//            } catch (e: Error) {
//                Log.d(TAG, "ASKING FOR PERMISSION : $e")
//            }
//        }
//    }
//
//    private fun hasPermissions(context: Context?, vararg permissions: String?): Boolean {
//        if (context != null) {
//            for (permission in permissions) {
//                if (ActivityCompat.checkSelfPermission(
//                        context,
//                        permission!!
//                    ) != PackageManager.PERMISSION_GRANTED
//                ) {
//                    return false
//                } else {
//                    Log.d(TAG, "Granted $permission")
//                }
//            }
//        }
//        return true
//    }
//
//    // Implements callback methods for GATT events that the app cares about.  For example,
//    // connection change and services discovered.
//    private val mGattCallback: BluetoothGattCallback = object : BluetoothGattCallback() {
//        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
//            val intentAction: String
//            if (newState == BluetoothProfile.STATE_CONNECTED) {
//                intentAction = ACTION_GATT_CONNECTED
//                mConnectionState = STATE_CONNECTED
//                broadcastUpdate(intentAction)
//                Log.i(TAG, "Connected to GATT server.")
//                // Attempts to discover services after successful connection.
//                Log.i(
//                    TAG, "Attempting to start service discovery:" +
//                            mBluetoothGatt!!.discoverServices()
//                )
//            } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
//                intentAction = ACTION_GATT_DISCONNECTED
//                mConnectionState = STATE_DISCONNECTED
//                Log.i(TAG, "Disconnected from GATT server.")
//                broadcastUpdate(intentAction)
//            }
//        }
//
//        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
//            if (status == BluetoothGatt.GATT_SUCCESS) {
//                broadcastUpdate(ACTION_GATT_SERVICES_DISCOVERED)
//            } else {
//                Log.w(
//                    TAG,
//                    "onServicesDiscovered received: $status"
//                )
//            }
//        }
//
//        override fun onCharacteristicRead(
//            gatt: BluetoothGatt,
//            characteristic: BluetoothGattCharacteristic,
//            status: Int
//        ) {
//            if (status == BluetoothGatt.GATT_SUCCESS) {
//                broadcastUpdate(ACTION_DATA_AVAILABLE, characteristic)
//            }
//        }
//
//        override fun onCharacteristicChanged(
//            gatt: BluetoothGatt,
//            characteristic: BluetoothGattCharacteristic
//        ) {
//            broadcastUpdate(ACTION_DATA_AVAILABLE, characteristic)
//        }
//    }
//
//
//    private fun broadcastUpdate(action: String) {
//        val intent = Intent(action)
//        sendBroadcast(intent)
//    }
//
//    private fun broadcastUpdate(
//        action: String,
//        characteristic: BluetoothGattCharacteristic
//    ) {
//        val intent = Intent(action)
//
//        // This is special handling for the Heart Rate Measurement profile.  Data parsing is
//        // carried out as per profile specifications:
//        // http://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.heart_rate_measurement.xml
//        if (UUID_HEART_RATE_MEASUREMENT == characteristic.uuid) {
//            val flag = characteristic.properties
//            var format = -1
//            if (flag and 0x01 != 0) {
//                format = BluetoothGattCharacteristic.FORMAT_UINT16
//                Log.d(TAG, "Heart rate format UINT16.")
//            } else {
//                format = BluetoothGattCharacteristic.FORMAT_UINT8
//                Log.d(TAG, "Heart rate format UINT8.")
//            }
//            val heartRate = characteristic.getIntValue(format, 1)
//            Log.d(TAG, String.format("Received heart rate: %d", heartRate))
//            intent.putExtra(EXTRA_DATA, heartRate.toString())
//        } else {
//            // For all other profiles, writes the data formatted in HEX.
//            val data = characteristic.value
//            if (data != null && data.size > 0) {
//                val stringBuilder = StringBuilder(data.size)
//                for (byteChar in data) stringBuilder.append(String.format("%02X ", byteChar))
//                intent.putExtra(
//                    EXTRA_DATA, """
//     ${String(data)}
//     $stringBuilder
//     """.trimIndent()
//                )
//            }
//        }
//        sendBroadcast(intent)
//    }
//
//    inner class LocalBinder : Binder() {
//        val service: BluetoothLeService
//            get() = this@BluetoothLeService
//    }
//
//    override fun onBind(intent: Intent): IBinder? {
//        return mBinder
//    }
//
//    override fun onUnbind(intent: Intent): Boolean {
//        // After using a given device, you should make sure that BluetoothGatt.close() is called
//        // such that resources are cleaned up properly.  In this particular example, close() is
//        // invoked when the UI is disconnected from the Service.
//        close()
//        return super.onUnbind(intent)
//    }
//
//    private val mBinder: IBinder = LocalBinder()
//
//    /**
//     * Initializes a reference to the local Bluetooth adapter.
//     *
//     * @return Return true if the initialization is successful.
//     */
//    fun initialize(): Boolean {
//        // For API level 18 and above, get a reference to BluetoothAdapter through
//        // BluetoothManager.
//        if (mBluetoothManager == null) {
//            mBluetoothManager = getSystemService(BLUETOOTH_SERVICE) as BluetoothManager
//            if (mBluetoothManager == null) {
//                Log.e(TAG, "Unable to initialize BluetoothManager.")
//                return false
//            }
//        }
//        mBluetoothAdapter = mBluetoothManager!!.adapter
//        if (mBluetoothAdapter == null) {
//            Log.e(TAG, "Unable to obtain a BluetoothAdapter.")
//            return false
//        }
//
//        //JDD - lets go ahead and start our GATT server now
//        addDefinedGattServerServices()
//        return true
//    }
//
//    /**
//     * Connects to the GATT server hosted on the Bluetooth LE device.
//     *
//     * @param address The device address of the destination device.
//     *
//     * @return Return true if the connection is initiated successfully. The connection result
//     * is reported asynchronously through the
//     * `BluetoothGattCallback#onConnectionStateChange(android.bluetooth.BluetoothGatt, int, int)`
//     * callback.
//     */
//    fun connect(address: String?): Boolean {
//        if (mBluetoothAdapter == null || address == null) {
//            Log.w(TAG, "BluetoothAdapter not initialized or unspecified address.")
//            return false
//        }
//
//        // Previously connected device.  Try to reconnect.
//        if (mBluetoothDeviceAddress != null && address == mBluetoothDeviceAddress && mBluetoothGatt != null) {
//            Log.d(TAG, "Trying to use an existing mBluetoothGatt for connection.")
//            return if (mBluetoothGatt!!.connect()) {
//                mConnectionState = STATE_CONNECTING
//                true
//            } else {
//                false
//            }
//        }
//        val device = mBluetoothAdapter!!.getRemoteDevice(address)
//        if (device == null) {
//            Log.w(TAG, "Device not found.  Unable to connect.")
//            return false
//        }
//        // We want to directly connect to the device, so we are setting the autoConnect
//        // parameter to false.
//        mBluetoothGatt = device.connectGatt(this, false, mGattCallback)
//        Log.d(TAG, "Trying to create a new connection.")
//        mBluetoothDeviceAddress = address
//        mConnectionState = STATE_CONNECTING
//        return true
//    }
//
//    /**
//     * Disconnects an existing connection or cancel a pending connection. The disconnection result
//     * is reported asynchronously through the
//     * `BluetoothGattCallback#onConnectionStateChange(android.bluetooth.BluetoothGatt, int, int)`
//     * callback.
//     */
//    fun disconnect() {
//        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
//            Log.w(TAG, "BluetoothAdapter not initialized")
//            return
//        }
//        mBluetoothGatt!!.disconnect()
//    }
//
//    /**
//     * After using a given BLE device, the app must call this method to ensure resources are
//     * released properly.
//     */
//    fun close() {
//        if (mBluetoothGatt == null) {
//            return
//        }
//        mBluetoothGatt!!.close()
//        mBluetoothGatt = null
//    }
//
//    /**
//     * Request a read on a given `BluetoothGattCharacteristic`. The read result is reported
//     * asynchronously through the `BluetoothGattCallback#onCharacteristicRead(android.bluetooth.BluetoothGatt, android.bluetooth.BluetoothGattCharacteristic, int)`
//     * callback.
//     *
//     * @param characteristic The characteristic to read from.
//     */
//    fun readCharacteristic(characteristic: BluetoothGattCharacteristic?) {
//        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
//            Log.w(TAG, "BluetoothAdapter not initialized")
//            return
//        }
//        mBluetoothGatt!!.readCharacteristic(characteristic)
//    }
//
//    fun writeRemoteCharacteristic(characteristic: BluetoothGattCharacteristic?) {
//        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
//            Log.w(TAG, "BluetoothAdapter not initialized")
//            return
//        }
//        mBluetoothGatt!!.writeCharacteristic(characteristic)
//    }
//
//    /**
//     * Enables or disables notification on a give characteristic.
//     *
//     * @param characteristic Characteristic to act on.
//     * @param enabled If true, enable notification.  False otherwise.
//     */
//    fun setCharacteristicNotification(
//        characteristic: BluetoothGattCharacteristic,
//        enabled: Boolean
//    ) {
//        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
//            Log.w(TAG, "BluetoothAdapter not initialized")
//            return
//        }
//        mBluetoothGatt!!.setCharacteristicNotification(characteristic, enabled)
//
//        // This is specific to Heart Rate Measurement.
//        if (UUID_HEART_RATE_MEASUREMENT == characteristic.uuid) {
//            val descriptor = characteristic.getDescriptor(
//                UUID.fromString(SampleGattAttributes.CLIENT_CHARACTERISTIC_CONFIG)
//            )
//            descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
//            mBluetoothGatt!!.writeDescriptor(descriptor)
//        }
//    }
//
//    /**
//     * Retrieves a list of supported GATT services on the connected device. This should be
//     * invoked only after `BluetoothGatt#discoverServices()` completes successfully.
//     *
//     * @return A `List` of supported services.
//     */
//    val supportedGattServices: List<BluetoothGattService>?
//        get() = if (mBluetoothGatt == null) null else mBluetoothGatt!!.services
//
//    fun addGattServerService(service: BluetoothGattService?) {
//        mBluetoothGattServer!!.addService(service)
//    }
//
//    fun addDefinedGattServerServices() {
//        mBluetoothGattServer = mBluetoothManager!!.openGattServer(this, mGattServerCallback)
//        val service = BluetoothGattService(
//            UUID.fromString(SampleGattAttributes.FAN_CONTROL_SERVICE_UUID),
//            BluetoothGattService.SERVICE_TYPE_PRIMARY
//        )
//        val characteristic = BluetoothGattCharacteristic(
//            UUID.fromString(SampleGattAttributes.FAN_OPERATING_STATE),
//            BluetoothGattCharacteristic.FORMAT_UINT8,
//            BluetoothGattCharacteristic.PERMISSION_WRITE
//        )
//        service.addCharacteristic(characteristic)
//        mBluetoothGattServer.addService(service)
//        Log.d("HELLO", "Created our own GATT server.\r\n")
//    }
//
//    companion object {
//        private val TAG = BluetoothLeService::class.java.simpleName
//        private const val STATE_DISCONNECTED = 0
//        private const val STATE_CONNECTING = 1
//        private const val STATE_CONNECTED = 2
//        const val ACTION_GATT_CONNECTED = "com.example.bluetooth.le.ACTION_GATT_CONNECTED"
//        const val ACTION_GATT_DISCONNECTED = "com.example.bluetooth.le.ACTION_GATT_DISCONNECTED"
//        const val ACTION_GATT_SERVICES_DISCOVERED =
//            "com.example.bluetooth.le.ACTION_GATT_SERVICES_DISCOVERED"
//        const val ACTION_DATA_AVAILABLE = "com.example.bluetooth.le.ACTION_DATA_AVAILABLE"
//        const val EXTRA_DATA = "com.example.bluetooth.le.EXTRA_DATA"
//        val UUID_HEART_RATE_MEASUREMENT: UUID =
//            UUID.fromString(SampleGattAttributes.HEART_RATE_MEASUREMENT)
//
//        private const val PERMISSION_ALL = 10
//
//        private val PERMISSIONS = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
//            arrayOf(
//                Manifest.permission.BLUETOOTH_CONNECT,
//                Manifest.permission.BLUETOOTH,
//                Manifest.permission.ACCESS_FINE_LOCATION,
//                Manifest.permission.BLUETOOTH_ADMIN,
//                Manifest.permission.BLUETOOTH_SCAN
//            )
//        } else {
//            arrayOf(
//                Manifest.permission.BLUETOOTH,
//                Manifest.permission.ACCESS_FINE_LOCATION,
//                Manifest.permission.BLUETOOTH_ADMIN,
//            )
//        }
//    }
//}