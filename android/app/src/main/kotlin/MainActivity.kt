package sms.moneystory.app

import android.app.role.RoleManager
import android.content.ContentValues
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.provider.Telephony
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun onStart() {
        super.onStart()
        getPermission()
    }

    private fun getPermission(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(RoleManager::class.java)
            if (roleManager.isRoleAvailable(RoleManager.ROLE_SMS)) {
                if (!roleManager.isRoleHeld(RoleManager.ROLE_SMS)) {
                    val i = roleManager
                            .createRequestRoleIntent(RoleManager.ROLE_SMS)

                    startActivityForResult(i, 5444)

                    return true
                }
                return true
            }
            return false
        }

        if (Telephony.Sms.getDefaultSmsPackage(this) != packageName) {
            val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
            intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)

            startActivityForResult(intent, 5444)
        }

        return true
    }

    fun saveSms(values: ContentValues) {
        contentResolver.insert(Telephony.Sms.CONTENT_URI, values)
    }
}
