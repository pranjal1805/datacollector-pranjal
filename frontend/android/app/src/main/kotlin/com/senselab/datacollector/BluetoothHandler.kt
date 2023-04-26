package com.senselab.datacollector

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.bluetooth.*
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityCompat.startActivityForResult
import androidx.core.content.ContextCompat

class BluetoothHandler : Application() {

    private var bluetoothManager: BluetoothManager? = null
    private var bluetoothAdapter: BluetoothAdapter? = null
    var deviceList = mutableSetOf<BluetoothDevice>()
    var deviceIds = mutableListOf<String>()
    private var mBluetoothGatt: BluetoothGatt? = null
    private var connectionStatus = BluetoothProfile.STATE_DISCONNECTED
    private lateinit var context: Context


    companion object {
        private const val TAG = "DATA_COLLECTOR_BT"
        private const val SCAN_TAG = "DATA_COLLECTOR_SCAN"
        private const val PERMISSION_ALL = 1
        private const val SCAN_PERIOD: Long = 5000

        private val PERMISSIONS = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.BLUETOOTH_ADMIN,
                Manifest.permission.BLUETOOTH_SCAN
            )
        } else {
            arrayOf(
                Manifest.permission.BLUETOOTH,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.BLUETOOTH_ADMIN,
            )
        }
    }

    fun checkPermissions(activity: Activity?, context: Context?) {
        Toast.makeText(context, "Checking for permissions", Toast.LENGTH_SHORT).show()
        if (!hasPermissions(context, *PERMISSIONS)) {
            Log.d(TAG, "ASKING FOR PERMISSION")
            try {
                ActivityCompat.requestPermissions(
                    activity!!, PERMISSIONS, PERMISSION_ALL
                )
            } catch (e: Error) {
                Log.d(TAG, "ASKING FOR PERMISSION : $e")
            }
        }
    }

    private fun hasPermissions(context: Context?, vararg permissions: String?): Boolean {
        if (context != null) {
            for (permission in permissions) {
                if (ActivityCompat.checkSelfPermission(
                        context,
                        permission!!
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    return false
                } else {
                    Log.d(TAG, "Granted $permission")
                }
            }
        }
        return true
    }

    fun initHandler(context: Context) {
        try {
            bluetoothManager =
                ContextCompat.getSystemService(context, BluetoothManager::class.java)
            bluetoothAdapter = bluetoothManager?.adapter
        } catch (e: Error) {
            Log.d(TAG, "initBT: $e")
        }
    }

    fun initBT(context: Context) {
        if (bluetoothAdapter == null) {
            Log.d(TAG, "initBT: NO BLUETOOTH")
            return
        }
        this.context = context
        if (!bluetoothAdapter!!.isEnabled) {
            Log.d(TAG, "initBT: enable BT")
            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BLUETOOTH_CONNECT
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                checkPermissions(currentActivity, this)
            }
            startActivityForResult(currentActivity, enableBtIntent, 1, null)
        } else {
            Log.d(TAG, "initBT: start discovery")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                scanBLEdevices(context)
            }
        }
    }

    @SuppressLint("MissingPermission")
    fun scanBLEdevices(context: Context) {
        val bluetoothLeScanner = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            bluetoothAdapter?.bluetoothLeScanner
        } else {
            TODO("VERSION.SDK_INT < LOLLIPOP")
        }
        var scanning = false
        val handler = Handler(Looper.getMainLooper())

        Log.d(TAG, "SCANNING 1")

        if (!scanning) {
            handler.postDelayed({
                scanning = false
                if (ActivityCompat.checkSelfPermission(
                        context,
                        Manifest.permission.BLUETOOTH_SCAN
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    checkPermissions(currentActivity, context)
                }
                bluetoothLeScanner?.stopScan(
                    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
                    object : ScanCallback() {
                        override fun onScanResult(callbackType: Int, result: ScanResult) {
                            super.onScanResult(callbackType, result)
                            Log.d(SCAN_TAG, "onScanResult: $result")
                            if (!deviceList.contains(result.device)) {
                                deviceList.add(result.device)
                                deviceIds.add(result.device.address)
                            }
                        }
                    })

            }, SCAN_PERIOD)
            scanning = true

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                Log.d(SCAN_TAG, "SCANNING")
                Log.d(SCAN_TAG, bluetoothLeScanner.toString())
                bluetoothLeScanner?.startScan(object : ScanCallback() {
                    override fun onScanResult(callbackType: Int, result: ScanResult) {
                        super.onScanResult(callbackType, result)
                        Log.d(SCAN_TAG, "onScanResult: $result")
                        if (!deviceList.contains(result.device)) {
                            deviceList.add(result.device)
                            deviceIds.add(result.device.address)
                        }
                    }
                })
            }
        } else {
            scanning = false
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                bluetoothLeScanner?.stopScan(object : ScanCallback() {
                    override fun onScanResult(callbackType: Int, result: ScanResult) {
                        super.onScanResult(callbackType, result)
                        Log.d(SCAN_TAG, "onScanResult: $result")
                        if (!deviceList.contains(result.device)) {
                            deviceList.add(result.device)
                            deviceIds.add(result.device.address)
                        }
                    }
                })
            }
        }
    }

    fun showScannedDevices(context: Context) {
        if (deviceList.isEmpty()) {
            Toast.makeText(context, "Scan First", Toast.LENGTH_SHORT).show()
        } else {
            Toast.makeText(context, deviceList.toString(), Toast.LENGTH_SHORT).show()
        }
    }

    fun connectToDevice(context: Context) {
        if (deviceList.isEmpty()) {
            Log.d(SCAN_TAG, deviceList.toString())
            Toast.makeText(context, "Scanned list is empty", Toast.LENGTH_SHORT).show()
        } else {
            val builder = AlertDialog.Builder(context)

            builder.setCancelable(true)
            builder.setTitle("Choose a device to connect")
            builder.setItems(deviceIds.toTypedArray()) { _, which ->
                Log.d("DATA_COLLECTOR_BT", "ITEM CLICKED : $which")
                Toast.makeText(
                    context,
                    "Connecting to " + deviceIds[which],
                    Toast.LENGTH_SHORT
                ).show()
                connectDeviceToGattServer(which, context)
            }
            val dialog = builder.create()
            dialog.show()
        }
    }

    private fun connectDeviceToGattServer(which: Int, context: Context) {
        Toast.makeText(context, "Establishing GATT", Toast.LENGTH_SHORT).show()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ActivityCompat.checkSelfPermission(
                    context,
                    Manifest.permission.BLUETOOTH_CONNECT
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                checkPermissions(currentActivity, this)
            }
            try {
                Log.d("DATA_COLLECTOR_BT", "Trying ")
                deviceList.toMutableList()[which].connectGatt(
                    context,
                    false,
                    gattCallback,
                    BluetoothDevice.TRANSPORT_LE
                )
            } catch (e: Error) {
                Log.d("DATA_COLLECTOR_BT", "OOPS ERROR: $e ")
            }
        }
    }

    private val gattCallback = object : BluetoothGattCallback() {
        @RequiresApi(Build.VERSION_CODES.S)
        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            val deviceAddress = gatt.device.address
            mBluetoothGatt = gatt

            if (status == BluetoothGatt.GATT_SUCCESS) {
                if (newState == BluetoothProfile.STATE_CONNECTED) {
                    Log.w("BluetoothGattCallback", "Successfully connected to $deviceAddress")


                    Log.w("BluetoothGattCallback", gatt.services.toString())
                    mBluetoothGatt = gatt
                    Handler(Looper.getMainLooper()).post {
                        if (ActivityCompat.checkSelfPermission(
                                context,
                                Manifest.permission.BLUETOOTH_CONNECT
                            ) != PackageManager.PERMISSION_GRANTED
                        ) {
                            checkPermissions(currentActivity, applicationContext)
                        }
                        mBluetoothGatt?.discoverServices()
                    }

                    //saveDeviceDetails
                    saveData(deviceAddress)

                } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                    Log.w("BluetoothGattCallback", "Successfully disconnected from $deviceAddress")
                    Toast.makeText(
                        applicationContext,
                        "Successfully disconnected from $deviceAddress",
                        Toast.LENGTH_SHORT
                    ).show()
                    gatt.close()
                }
            } else {
                Log.w(
                    "BluetoothGattCallback",
                    "Error $status encountered for $deviceAddress! Disconnecting..."
                )
                Handler(Looper.getMainLooper()).post {
                    Toast.makeText(
                        applicationContext,
                        "Error $status encountered for $deviceAddress! Disconnecting...",
                        Toast.LENGTH_SHORT
                    ).show()
                    gatt.close()
                }
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {

            with(gatt) {
                Log.w(
                    "BluetoothGattCallback",
                    "Discovered ${services.size} services for ${device.address}"
                )
                printGattTable() // See implementation just above this section
                // Consider connection setup as complete here

            }
        }

        override fun onCharacteristicRead(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            status: Int
        ) {
            with(characteristic) {
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        Log.i(
                            "BluetoothGattCallback",
                            "Read characteristic $uuid:\n${value}"
                        )
                    }
                    BluetoothGatt.GATT_READ_NOT_PERMITTED -> {
                        Log.e("BluetoothGattCallback", "Read not permitted for $uuid!")
                    }
                    else -> {
                        Log.e(
                            "BluetoothGattCallback",
                            "Characteristic read failed for $uuid, error: $status"
                        )
                    }
                }
            }
        }

        override fun onCharacteristicWrite(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            status: Int
        ) {
            with(characteristic) {
                when (status) {
                    BluetoothGatt.GATT_SUCCESS -> {
                        Log.i(
                            "BluetoothGattCallback",
                            "Wrote to characteristic $uuid | value: $value"
                        )
                    }
                    BluetoothGatt.GATT_INVALID_ATTRIBUTE_LENGTH -> {
                        Log.e("BluetoothGattCallback", "Write exceeded connection ATT MTU!")
                    }
                    BluetoothGatt.GATT_WRITE_NOT_PERMITTED -> {
                        Log.e("BluetoothGattCallback", "Write not permitted for $uuid!")
                    }
                    else -> {
                        Log.e(
                            "BluetoothGattCallback",
                            "Characteristic write failed for $uuid, error: $status"
                        )
                    }
                }
            }
        }

        override fun onCharacteristicChanged(
            gatt: BluetoothGatt?,
            characteristic: BluetoothGattCharacteristic?
        ) {
            super.onCharacteristicChanged(gatt, characteristic)
            Log.d("BLE_CHARACTER_CHANGED", characteristic.toString())
        }
    }

    private fun BluetoothGatt.printGattTable() {
        if (services.isEmpty()) {
            Log.i(
                "printGattTable",
                "No service and characteristic available, call discoverServices() first?"
            )
            return
        }
        services.forEach { service ->
            val characteristicsTable = service.characteristics.joinToString(
                separator = "\n|--",
                prefix = "|--"
            ) { it.uuid.toString() }
            Log.i(
                "printGattTable",
                "\nService ${service.uuid}\nCharacteristics:\n$characteristicsTable"
            )
        }
    }

    @RequiresApi(Build.VERSION_CODES.S)
    fun disconnectDevice() {
        if (connectionStatus == BluetoothProfile.STATE_CONNECTED) {
            if (mBluetoothGatt == null) {
                return
            }
            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BLUETOOTH_CONNECT
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                checkPermissions(currentActivity, this)
                return
            }
            mBluetoothGatt!!.close()
            mBluetoothGatt = null
            connectionStatus = BluetoothProfile.STATE_DISCONNECTED
        } else {
            Toast.makeText(applicationContext, "Connect to a device first!", Toast.LENGTH_SHORT)
                .show()

        }
    }

    fun showPreviouslyConnectedDevices() {
        loadData()
    }


    private fun saveData(deviceAddress: String) {
        Log.d("BluetoothGattCallback", "SHARED_PREFS***********SAVING")
        val sharedPreferences = context.getSharedPreferences("sharedPrefs", Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.apply {
            putString("LAST_DEVICE", deviceAddress)
        }.apply()
    }

    private fun loadData() {
        val sharedPreferences = getSharedPreferences("sharedPrefs", Context.MODE_PRIVATE)
        val lastDeviceAddress = sharedPreferences.getString("LAST_DEVICE", null)

        if (lastDeviceAddress != null) {
            Toast.makeText(
                applicationContext,
                "$lastDeviceAddress was connected last",
                Toast.LENGTH_SHORT
            )
                .show()
        } else {
            Toast.makeText(applicationContext, "No device found", Toast.LENGTH_SHORT).show()
        }
    }
}