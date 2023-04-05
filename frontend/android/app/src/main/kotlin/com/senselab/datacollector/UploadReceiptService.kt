package com.senselab.datacollector

import retrofit2.http.Multipart
import retrofit2.http.POST
import com.senselab.datacollector.UploadResult
import okhttp3.MultipartBody
import retrofit2.Call
import retrofit2.http.Part

interface UploadReceiptService {
    @Multipart
    @POST("api/upload_zip/")
    fun uploadReceipt(
        @Part file: MultipartBody.Part,
        @Part("sensor_id") sensor: Int
    ): Call<UploadResult?>?
}