import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smartsms/main.dart';
import 'package:telephony/telephony.dart';

class MessageController extends GetxController {
  String _message = "";

  RxBool openSMS = false.obs;
  Telephony telephony = Telephony.instance;

  StreamController<List<SmsMessage>> smsStreamController =
      StreamController<List<SmsMessage>>();
  Stream<List<SmsMessage>> get smsStream => smsStreamController.stream;

  StreamController<List<String>> phoneNumberStreamController =
      StreamController<List<String>>();
  Stream<List<String>> get phoneNumberStream =>
      phoneNumberStreamController.stream;

  List<String> uniquePhoneNumbers = [];

  onMessage(SmsMessage message) async {
    _message = message.body ?? "Error reading message body.";
  }

  onSendStatus(SendStatus status) {
    _message = status == SendStatus.SENT ? "sent" : "delivered";
  }

  Future<void> getSMS() async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    smsStreamController.add(messages);

    uniquePhoneNumbers =
        messages.map((message) => message.address!).toSet().toList();
    phoneNumberStreamController.add(uniquePhoneNumbers);
  }

  Future<List<SmsMessage>> getMessagesByPhoneNumber(String phoneNumber) async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    List<SmsMessage> filteredMessages = messages.where((message) {
      return message.address == phoneNumber;
    }).toList();
    return filteredMessages;
  }

  Future<void> openConversation(String phoneNumber) async {
    List<SmsMessage> messages = await getMessagesByPhoneNumber(phoneNumber);
    smsStreamController.add(messages);
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    getSMS();
    openConversation(Get.arguments);
    initPlatformState();
  }
}



/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smartsms/main.dart';
import 'package:telephony/telephony.dart';

class HomeController extends GetxController {
  String _message = "";
  Telephony telephony = Telephony.instance;

  StreamController<List<SmsMessage>> smsStreamController =
      StreamController<List<SmsMessage>>();
  Stream<List<SmsMessage>> get smsStream => smsStreamController.stream;

  onMessage(SmsMessage message) async {
    _message = message.body ?? "Error reading message body.";
  }

  onSendStatus(SendStatus status) {
    _message = status == SendStatus.SENT ? "sent" : "delivered";
  }

  Future<void> getSMS() async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    smsStreamController.add(messages);
  }

  Future<List<SmsMessage>> getMessagesByPhoneNumber(String phoneNumber) async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    List<SmsMessage> filteredMessages = messages.where((message) {
      return message.address == phoneNumber;
    }).toList();
    return filteredMessages;
  }

  Future<void> openConversation(String phoneNumber) async {
    List<SmsMessage> messages = await getMessagesByPhoneNumber(phoneNumber);
    smsStreamController.add(messages);
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    getSMS();
    initPlatformState();
  }
}*/
