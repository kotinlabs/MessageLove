import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsms/controllers/sms_controller.dart';
import 'package:smartsms/main.dart';
import 'package:smartsms/other/notification.dart';
import 'package:telephony/telephony.dart';

class HomeController extends GetxController {
  final smsController = Get.put(SmsController());

  Future<void> getSMS() async {
    List<SmsMessage> messages = await telephony.getInboxSms();

    for (var message in messages) {
      smsController.smsList.add(SaveSmsMessage(
        address: message.address!,
        body: message.body!,
      ));
    }
  }

  Future<void> onSaveSMS(SmsMessage smsMessage) async {
    await smsController.saveSms(smsMessage);
  }

  RxString messages = "".obs;
  Telephony telephony = Telephony.instance;
  StreamController<List<SmsMessage>> smsStreamController =
      StreamController<List<SmsMessage>>();
  Stream<List<SmsMessage>> get smsStream => smsStreamController.stream;

  void onMessage(SmsMessage message) async {
    NotificationService().showTestNotification(
        message.address.toString(), message.body.toString());
    onSaveSMS(message);
    messages.value = message.body ?? "Error reading message body.";
  }

  void onSendStatus(SendStatus status) {
    print(status);
    messages.value = status == SendStatus.SENT ? "sent" : "delivered";
  }

  Future<void> initPlatformState() async {
    // final bool? result = await telephony.requestPhoneAndSmsPermissions;
    // print(result);
    // if (result != null && result) {
    telephony.listenIncomingSms(
      onNewMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
    );
    // }
  }

  @override
  void onInit() {
    super.onInit();
    smsController.loadSmsList();
    getSMS();
    initPlatformState();
  }
}

class SaveSmsMessage {
  String address;
  String body;

  SaveSmsMessage({
    required this.address,
    required this.body,
  });

  Map<String, dynamic> toJson() {
    return {'address': address, 'body': body};
  }

  factory SaveSmsMessage.fromJson(Map<String, dynamic> json) {
    return SaveSmsMessage(
      address: json['address'] as String,
      body: json['body'] as String,
    );
  }
}
