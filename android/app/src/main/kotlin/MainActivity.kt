package sms.moneystory.app

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "test"
    private val REQUEST_CODE_CHANGE_SMS_APP = 123

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openChangeDefaultSmsAppDialog") {
                openChangeDefaultSmsAppDialog()
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openChangeDefaultSmsAppDialog() {
        val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
        intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
        startActivityForResult(intent, REQUEST_CODE_CHANGE_SMS_APP)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_CHANGE_SMS_APP) {
            if (resultCode == Activity.RESULT_OK) {

            } else {
     
            }
        }
    }
}
