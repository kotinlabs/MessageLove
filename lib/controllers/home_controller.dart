import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:smartsms/main.dart';
import 'package:smartsms/other/notification.dart';
import 'package:telephony/telephony.dart';

class HomeController extends GetxController {
  Future<void> test() async {
    const platform = MethodChannel('test');
    try {
      await platform.invokeMethod('openChangeDefaultSmsAppDialog');
    } catch (e) {
      print('Error: $e');
    }
  }

  void openChangeDefaultSmsAppDialog() {
    AndroidIntent intent = AndroidIntent(
      action: 'android.provider.Telephony.ACTION_CHANGE_DEFAULT',
    );
    intent.launch();
  }

  RxString messages = "".obs;
  Telephony telephony = Telephony.instance;
  StreamController<List<SmsMessage>> smsStreamController =
      StreamController<List<SmsMessage>>();
  Stream<List<SmsMessage>> get smsStream => smsStreamController.stream;

  void onMessage(SmsMessage message) async {
    NotificationService().showTestNotification(
        message.address.toString(), message.body.toString());
    messages.value = message.body ?? "Error reading message body.";
  }

  void onSendStatus(SendStatus status) {
    print(status);
    messages.value = status == SendStatus.SENT ? "sent" : "delivered";
  }

  Future<void> getSMS() async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    smsStreamController.add(messages);
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    print(result);
    if (result != null && result) {
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
      );
    }
  }

  RxInt? addNumber;
  Future createSMS() async {}
  @override
  void onInit() {
    super.onInit();

    // getSMS();
    initPlatformState();
  }
}
