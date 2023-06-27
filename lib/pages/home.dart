import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:smartsms/controllers/home_controller.dart';
import 'package:smartsms/other/color.dart';
import 'package:smartsms/other/notification.dart';
import 'package:telephony/telephony.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                final TextEditingController textController =
                    TextEditingController();
                Get.dialog(AlertDialog(
                  title: Text('Add number'),
                  content: TextFormField(
                    controller: textController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: '',
                      hintText: '',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }

                      return null;
                    },
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.toNamed(
                          '/message',
                          arguments: SaveSmsMessage(
                              address: '+${textController.text.trim()}',
                              body: ''),
                        );
                      },
                      child: Text('Add'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                      child: Text('Close'),
                    ),
                  ],
                ));
              },
              icon: Icon(Icons.telegram))
        ],
        backgroundColor: color,
        elevation: 0,
        title: const Text('Smart SMS'),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.smsController.smsList.length,
          itemBuilder: (context, index) {
            final sms = controller.smsController.smsList[index];
            return Container(
              margin: const EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 3,
                child: ListTile(
                  onTap: () => Get.toNamed('/message', arguments: sms),
                  leading: Material(
                      borderRadius: BorderRadius.circular(42),
                      elevation: 3,
                      color: color,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.message, color: Colors.white),
                      )),
                  title: Text(sms.address.replaceFirst(r'+', '')),
                  subtitle: Text(sms.body),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
