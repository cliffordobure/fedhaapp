import android.app.Service
import android.content.Intent
import android.os.IBinder
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class SmsProcessingService : Service() {
    override fun onBind(intent: Intent): IBinder? {
        return null // Not used
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val sender = intent.getStringExtra("sender")
        val body = intent.getStringExtra("body")

        // Here you can use a MethodChannel to send data to your Flutter application
        val flutterEngine = FlutterEngine(this)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        // Call the method in Flutter to handle the message
        channel.invokeMethod("readMessage", object : HashMap<String?, Any?>() {
            init {
                put("sender", sender)
                put("body", body)
            }
        })

        return START_NOT_STICKY // Service will not be restarted if killed
    }

    companion object {
        private const val CHANNEL = "com.example.fedha/sms"
    }
}