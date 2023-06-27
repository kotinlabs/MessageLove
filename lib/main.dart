import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:smartsms/other/notification.dart';
import 'package:smartsms/routes/app_pages.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter/services.dart';

void onBackgroundMessage(SmsMessage message) {
  NotificationService().showTestNotification(
      message.address.toString(), message.body.toString());
  debugPrint("onBackgroundMessage called");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart SMS",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
