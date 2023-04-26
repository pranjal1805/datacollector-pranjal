package com.senselab.datacollector

import android.os.Environment
import android.util.Log
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.*
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

class SensorFileManagement {
    companion object {
        fun uploadFile(files: MutableSet<String>) {
            if(files.size == 0) return
            val dir = Environment.getDataDirectory()
            Log.d("TAG", "uploadFile: $files")

            // making zip
            try {
                var origin: BufferedInputStream?
                val dest = FileOutputStream("$dir/data/com.senselab.datacollector/files/accelerometer.zip")
                val out = ZipOutputStream(
                    BufferedOutputStream(
                        dest
                    )
                )
                val data = ByteArray(1)
                for (file in files) {
                    Log.d("Compress", "Adding: $file")
                    val fi = FileInputStream("$dir/data/com.senselab.datacollector/files/$file")
                    origin = BufferedInputStream(fi)
                    val entry = ZipEntry(file)
                    out.putNextEntry(entry)
                    var count: Int
                    while (origin.read(data, 0, 1).also { count = it } != -1) {
                        out.write(data, 0, count)
                    }
                    origin.close()
                }
                out.close()
            } catch (e: Exception) {
                e.printStackTrace()
            }


            val service: UploadReceiptService = RetrofitInstance.getRetrofitInstance().create(
                UploadReceiptService::class.java
            )

            val file = File("$dir/data/com.senselab.datacollector/files/accelerometer.zip")

            Log.d("FILE_TAG", "uploadFile: FILE CHECK $dir")
            if(file.exists())
            {
                val str = file.readText()
                Log.d("FILE_TAG", "uploadFile: $str")
            } else {
                Log.d("FILE_TAG", "uploadFile: Cant find")
            }

            val mimeType = android.webkit.MimeTypeMap.getSingleton().getMimeTypeFromExtension("zip");
            if (mimeType != null) {
                Log.d("FILE_TAG:", mimeType)
            };

            val requestFile: RequestBody = file
                .asRequestBody("application/zip".toMediaTypeOrNull())

            val body = MultipartBody.Part.createFormData(
                "zip_file", file.name, requestFile)

            val call: Call<UploadResult?>? = service.uploadReceipt(body, 1)

            call?.enqueue(object : Callback<UploadResult?> {
                override fun onResponse(call: Call<UploadResult?>, response: Response<UploadResult?>) {
                    Log.d("FILE UPLOAD REQ", "onResponse: $response")
                }

                override fun onFailure(call: Call<UploadResult?>, t: Throwable) {
                    Log.e("FILE UPLOAD REQ", "onFailure: FAILED :( ${t.stackTrace}")
                }

            })
        }
    }
}