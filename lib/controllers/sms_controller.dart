import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsms/controllers/home_controller.dart';
import 'package:telephony/telephony.dart';

class SmsController extends GetxController {
  final RxList<SaveSmsMessage> smsList = <SaveSmsMessage>[].obs;

  Future<void> loadSmsList() async {
    final prefs = await SharedPreferences.getInstance();
    final smsJsonList = prefs.getStringList('sms');
    if (smsJsonList != null) {
      smsList.value = smsJsonList
          .map((json) => SaveSmsMessage.fromJson(jsonDecode(json)))
          .toList();
    } else {
      smsList.value = [];
    }
  }

  Future<void> saveSms(SmsMessage sms) async {
    final prefs = await SharedPreferences.getInstance();
    final smsList = prefs.getStringList('sms') ?? [];

    final smsData = {
      'address': sms.address,
      'body': sms.body,
    };

    smsList.add(json.encode(smsData));

    await prefs.setStringList('sms', smsList);

    loadSmsList();
  }
}
