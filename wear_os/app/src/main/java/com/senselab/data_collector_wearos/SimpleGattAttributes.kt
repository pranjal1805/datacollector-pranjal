/**
 * This class includes a small subset of standard GATT attributes for demonstration purposes.
 */
object SampleGattAttributes {
    private val attributes: HashMap<String?, String?> = HashMap()
    var HEART_RATE_MEASUREMENT = "00002a37-0000-1000-8000-00805f9b34fb"
    var CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
    var FAN_CONTROL_SERVICE_UUID = "86c86302-fc10-1399-df43-fceb24618252"
    var FAN_OPERATING_STATE = "705d627b-53e7-eda2-2649-5ecbd0bbfb85"

    init {
        // Sample Services.
        attributes["0000180d-0000-1000-8000-00805f9b34fb"] = "Heart Rate Service"
        attributes["0000180a-0000-1000-8000-00805f9b34fb"] = "Device Information Service"
        attributes["72f3d37d-c861-07ab-0341-f8cf302ca8b1"] = "DarkBlue Managed Service"
        attributes["f23844d8-1f57-448b-7f44-e64ae0fe15cf"] = "Line Cook Steps Service"
        //attributes.put("2cc0849e-5378-3abd-8e44-94d6fca2ed39", "Line Cook Steps Service");
        attributes["430f9940-1ff5-ca8e-d843-27c7153258a4"] = "Line Cook 2.0 Steps Service"
        attributes[FAN_CONTROL_SERVICE_UUID] = "Fan Control Service"


        // Sample Characteristics.
        attributes[HEART_RATE_MEASUREMENT] = "Heart Rate Measurement"
        attributes["00002a29-0000-1000-8000-00805f9b34fb"] = "Manufacturer Name String"
        attributes["abcbe138-a00c-6b8e-7d44-4b63a80170c3"] = "DarkBlue Company UUID Characteristic"
        attributes["26b8a2dc-544d-008e-c343-5d8fac910c6e"] = "DarkBlue Major ID Characteristic"
        attributes["0acea172-2a76-69a7-4e49-302ed371f6a8"] = "DarkBlue Minor ID Characteristic"
        attributes["e205929f-e016-ecbc-024b-62f0658fdacd"] =
            "DarkBlue Measured Power Characteristic"
        attributes["519fc39c-9a18-82b2-ea43-6a101ab1a8f9"] = "Cooking Step Characteristic"
        attributes["52812a3d-247d-77b9-6740-75748c4621c5"] = "Cooking Step Characteristic"
        attributes["f47e47ab-b25f-3a83-7b47-1f230b2b1a61"] = "Cooking Step Characteristic"
        attributes[FAN_OPERATING_STATE] = "Fan Operating State Characteristic"
    }

    fun lookup(uuid: String?, defaultName: String): String {
        val name = attributes[uuid]
        return name ?: defaultName
    }
}