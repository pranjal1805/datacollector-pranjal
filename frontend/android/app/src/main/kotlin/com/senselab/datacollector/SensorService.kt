package com.senselab.datacollector

import android.annotation.SuppressLint
import android.app.*
import android.content.Context
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Binder
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.*


class SensorService : Service(), SensorEventListener {

    private lateinit var axisX: BigDecimal
    private lateinit var axisY: BigDecimal
    private lateinit var axisZ: BigDecimal
    private lateinit var gyroValues: ArrayList<String>
    private lateinit var accelValues: ArrayList<String>
    private lateinit var magnetoValues: ArrayList<String>
    private lateinit var ppgValues: ArrayList<String>
    private lateinit var ppgX: BigDecimal
    private lateinit var ppgT: BigDecimal
    private var ppgType: Int = 0
    private var time: Long = 0
    private val binder = SensorServiceBinder()
    private val files = mutableSetOf<String>()

    companion object {
        private const val TAG = "FOREGROUND_SERVICE"
        private const val CHANNEL_ID = "ForegroundServiceChannel"
        private lateinit var sensorManager: SensorManager
    }

    inner class SensorServiceBinder : Binder() {
        fun getSensorService(): SensorService = this@SensorService
    }

    @SuppressLint("UnspecifiedImmutableFlag", "SuspiciousIndentation")
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createNotificationChannel()
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        Log.d("MAIN_ACTIVITY", "onCreate: Start service working")
        val notifyIntent = Intent(this, MainActivity::class.java)
        val pendingIntent =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.getActivity(this, 0, notifyIntent, PendingIntent.FLAG_IMMUTABLE)
            } else {
                PendingIntent.getActivity(this, 0, notifyIntent, PendingIntent.FLAG_MUTABLE)
            }
        val notification: Notification = NotificationCompat.Builder(applicationContext, CHANNEL_ID)
            .setContentTitle("Foreground Service")
            .setContentText("Service is Running")
            .setSmallIcon(R.drawable.launch_background)
            .setContentIntent(pendingIntent)
            .build()
        startForeground(101, notification)

        time = System.currentTimeMillis()

        return START_REDELIVER_INTENT
    }

    fun switchGyro(action: Boolean) {
        gyroValues = ArrayList()
        val gyroSensor: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
        when (action) {
            true -> gyroSensor.also { gyro ->
                sensorManager.registerListener(this, gyro, SensorManager.SENSOR_DELAY_NORMAL)
            }
            false -> gyroSensor.also { gyro ->
                sensorManager.unregisterListener(this, gyro)
            }
        }
    }

    fun switchAccel(action: Boolean) {
        accelValues = ArrayList()
        val accelSensor: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        when (action) {
            true -> accelSensor.also { accel ->
                sensorManager.registerListener(this, accel, SensorManager.SENSOR_DELAY_NORMAL)
            }
            false -> accelSensor.also { accel ->
                sensorManager.unregisterListener(this, accel)
            }
        }
    }

    fun switchMagneto(action: Boolean) {
        magnetoValues = ArrayList()
        val magnetoSensor: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)
        when (action) {
            true -> magnetoSensor.also { magneto ->
                sensorManager.registerListener(this, magneto, SensorManager.SENSOR_DELAY_NORMAL)
            }
            false -> magnetoSensor.also { magneto ->
                sensorManager.unregisterListener(this, magneto)
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT_WATCH)
    fun switchPPG(action: Boolean) {
        ppgValues = ArrayList()
        findPPG()
        val ppgSensor: Sensor? = sensorManager.getDefaultSensor(ppgType)

        when (action) {
            true -> ppgSensor.also { ppg ->
                sensorManager.registerListener(this, ppg, SensorManager.SENSOR_DELAY_NORMAL)
            }
            false -> ppgSensor.also { ppg ->
                sensorManager.unregisterListener(this, ppg)
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT_WATCH)
    private fun findPPG() {
        val sensorList = sensorManager.getSensorList(Sensor.TYPE_ALL)
        for (sensor in sensorList) {
            val sensorName = sensor.stringType.toLowerCase(Locale.getDefault())
            if (sensorName.contains("ppg")) {
                ppgType = sensor.type
                break
            }
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Foreground Service Channel",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    override fun onBind(p0: Intent?): IBinder {
        return binder
    }

    override fun onSensorChanged(p0: SensorEvent?) {
        if (p0 != null) {
            axisX = BigDecimal(p0.values[0].toDouble()).setScale(6, RoundingMode.HALF_EVEN)
            axisY = BigDecimal(p0.values[1].toDouble()).setScale(6, RoundingMode.HALF_EVEN)
            axisZ = BigDecimal(p0.values[2].toDouble()).setScale(6, RoundingMode.HALF_EVEN)
            ppgX = BigDecimal(p0.values[0].toDouble()).setScale(6, RoundingMode.HALF_EVEN)
            ppgT = BigDecimal(p0.values[0].toDouble()).setScale(6, RoundingMode.HALF_EVEN)

            when (p0.sensor.type) {
                Sensor.TYPE_GYROSCOPE -> {
                    Log.d(TAG, "GYROSCOPE: $axisX, $axisY, $axisZ")
                    addGyroEntry()
                }
                Sensor.TYPE_ACCELEROMETER -> {
                    Log.d(TAG, "ACCELEROMETER: $axisX, $axisY, $axisZ")
                    addAccelEntry()
                }
                Sensor.TYPE_MAGNETIC_FIELD -> {
                    Log.d(TAG, "MAGNETOMETER: $axisX, $axisY, $axisZ")
                    addMagnetoEntry()
                }
                ppgType -> {
                    Log.d(TAG, "PPG: $ppgX, $ppgT")
                    addPPGEntry()
                }
            }
        }
    }

    private fun addPPGEntry() {
        ppgValues.add("$ppgX, $ppgT, ${System.currentTimeMillis()}")
        addFileEntry("ppg")
    }

    private fun addMagnetoEntry() {
        magnetoValues.add("$axisX, $axisY, $axisZ, ${System.currentTimeMillis()}")
        addFileEntry("magneto")
    }

    private fun addAccelEntry() {
        accelValues.add("$axisX, $axisY, $axisZ, ${System.currentTimeMillis()}")
        addFileEntry("accel")
    }

    private fun addGyroEntry() {
        gyroValues.add("$axisX, $axisY, $axisZ, ${System.currentTimeMillis()}")
        addFileEntry("gyro")
    }

    private fun addFileEntry(sensor: String) {
        if (System.currentTimeMillis() - time > 180000) {
            time = System.currentTimeMillis()
            SensorFileManagement.uploadFile(files)
        }

        when (sensor) {
            "gyro" -> {
                if (gyroValues.size >= 100) {
                    openFileOutput("gyroscope_$time.csv", Context.MODE_PRIVATE).use {
                        it?.write(gyroValues.toString().toByteArray())
                        Log.d(TAG, "addFileEntry: added entry in gyroscope")
                        files.add("gyroscope_$time.csv")
                    }
                    gyroValues.clear()
                }
            }
            "accel" -> {
                if (accelValues.size == 100) {
                    openFileOutput("accelerometer_$time.csv", Context.MODE_PRIVATE).use {
                        it?.write(accelValues.toString().toByteArray())
                        Log.d(TAG, "addFileEntry: added entry in accelerometer")
                        files.add("accelerometer_$time.csv")
                    }
                    accelValues.clear()
                }
            }
            "magneto" -> {
                if (magnetoValues.size == 100) {
                    openFileOutput("magnetometer_$time.csv", Context.MODE_PRIVATE).use {
                        it.write(magnetoValues.toString().toByteArray())
                        Log.d(TAG, "addFileEntry: added entry in magneto")
                        files.add("magnetometer_$time.csv")
                    }
                    magnetoValues.clear()
                }
            }
            "ppg" -> {
                if (ppgValues.size == 100) {
                    openFileOutput("ppg_$time.csv", Context.MODE_PRIVATE).use {
                        it.write(ppgValues.toString().toByteArray())
                        Log.d(TAG, "addFileEntry: added entry in ppg")
                        files.add("ppg_$time.csv")
                    }
                    ppgValues.clear()
                }
            }
        }
    }

    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {}
}