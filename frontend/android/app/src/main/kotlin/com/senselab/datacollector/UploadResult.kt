package com.senselab.datacollector

import com.google.gson.annotations.SerializedName
import com.google.gson.annotations.Expose

class UploadResult {

    @SerializedName("zip_file")
    @Expose
    var dataFile: String? = null

    @SerializedName("sensor_id")
    @Expose
    var sensor = 0
}