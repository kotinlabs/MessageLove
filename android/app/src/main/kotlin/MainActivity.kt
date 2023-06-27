package sms.moneystory.app

import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    private fun openChangeDefaultSmsAppDialog() {
        val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
        intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
        startActivity(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        openChangeDefaultSmsAppDialog()
    }
}
