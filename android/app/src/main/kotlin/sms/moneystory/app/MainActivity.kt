package sms.moneystory.app

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.provider.Telephony

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.chat/chat"
    private val REQUEST_CODE_SET_DEFAULT_SMS_APP = 1

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkDefaultSmsApp" -> {
                    val isDefaultSmsApp = Telephony.Sms.getDefaultSmsPackage(this) == packageName
                    result.success(isDefaultSmsApp)
                }
                "requestDefaultSmsApp" -> {
                    if (isDefaultSmsAppPermissionGranted()) {
                        setDefaultSmsApp()
                        result.success(null)
                    } else {
                        ActivityCompat.requestPermissions(
                            this,
                            arrayOf(Manifest.permission.READ_SMS),
                            REQUEST_CODE_SET_DEFAULT_SMS_APP
                        )
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isDefaultSmsAppPermissionGranted(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_SMS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun setDefaultSmsApp() {
        val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
        intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
        startActivityForResult(intent, REQUEST_CODE_SET_DEFAULT_SMS_APP)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE_SET_DEFAULT_SMS_APP) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                setDefaultSmsApp()
            } else {
                // Permissions not granted, handle accordingly
            }
        }
    }
}
