package sms.moneystory.app
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.provider.Telephony.Sms.Intents

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.chat/chat"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setDefaultSms") {
                try {
                    val intent = Intent(Intents.ACTION_CHANGE_DEFAULT)
                    intent.putExtra(
                            Intents.EXTRA_PACKAGE_NAME,
                            "sms.moneystory.app" // Replace with your app package name
                    )
                    startActivity(intent)
                    result.success("Success")
                } catch (ex: Exception) {
                    result.error("UNAVAILABLE", "Setting default sms.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
