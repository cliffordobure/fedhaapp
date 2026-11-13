import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.SmsMessage

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val bundle = intent.extras
        if (bundle != null) {
            val pdus = bundle["pdus"] as Array<*>?
            if (pdus != null) {
                for (pdu in pdus) {
                    val message = SmsMessage.createFromPdu(pdu as ByteArray)
                    val sender = message.displayOriginatingAddress
                    val body = message.messageBody

                    // Start your service to process the SMS
                    val serviceIntent = Intent(
                        context,
                        SmsProcessingService::class.java
                    )
                    serviceIntent.putExtra("sender", sender)
                    serviceIntent.putExtra("body", body)
                    context.startService(serviceIntent)
                }
            }
        }
    }
}