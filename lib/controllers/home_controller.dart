/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smartsms/main.dart';
import 'package:telephony/telephony.dart';

class HomeController extends GetxController {
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
    initPlatformState();
  }
}*/

import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsms/main.dart';
import 'package:smartsms/other/notification.dart';
import 'package:telephony/telephony.dart';

class HomeController extends GetxController {
  void saveSmsMessage(String message) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? smsMessages = preferences.getStringList('sms_messages');
    if (smsMessages == null) {
      smsMessages = [message];
    } else {
      smsMessages.add(message);
    }
    await preferences.setStringList('sms_messages', smsMessages);

    print('SMS message saved: $message');
  }

  Future<bool> checkDefaultSmsApp() async {
    const platform = MethodChannel('com.example.chat/chat');
    final bool isDefaultSmsApp =
        await platform.invokeMethod('checkDefaultSmsApp');
    return isDefaultSmsApp;
  }

  Future<void> requestDefaultSmsApp() async {
    const platform = MethodChannel('com.example.chat/chat');
    await platform.invokeMethod('requestDefaultSmsApp');
  }

/*  void setDefaultSms() async {
    AndroidIntent intent = const AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: 'com.example.nomad',
      componentName: 'com.example.nomad.DefaultSMSAppChooserActivity',
    );
    await intent.launch();
  }
*/
  /* Future<void> setDefaultSms() async {
    const platform = MethodChannel('com.example.chat2/chat2');
    try {
      await platform.invokeMethod('setDefaultSms');
      print('ovde');
    } catch (e) {
      print('Poziv metode setDefaultSms nije uspio: $e');
    }
  }*/

  /* static const MethodChannel _channel =
      const MethodChannel('com.example.chat/chat');
  static const platform = const MethodChannel("com.example.chat/chat");

  Future<void> setDefaultSms() async {
    try {
      final result = await platform.invokeMethod('setDefaultSms');
      print("Result: $result");
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }*/

  RxString messages = "".obs;
  Telephony telephony = Telephony.instance;
  StreamController<List<SmsMessage>> smsStreamController =
      StreamController<List<SmsMessage>>();
  Stream<List<SmsMessage>> get smsStream => smsStreamController.stream;

  void onMessage(SmsMessage message) async {
    NotificationService().showTestNotification(
        message.address.toString(), message.body.toString());
    messages.value = message.body ?? "Error reading message body.";
    print("stigla");
  }

  void onSendStatus(SendStatus status) {
    print("poslano");
    messages.value = status == SendStatus.SENT ? "sent" : "delivered";
  }

  Future<void> getSMS() async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    smsStreamController.add(messages);
  }

  Future<void> test() async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    print(messages.last.body);
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
    print(result);
    if (result != null && result) {
      print('pozvano');
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    requestDefaultSmsApp();
    getSMS();
    initPlatformState();
  }
}
