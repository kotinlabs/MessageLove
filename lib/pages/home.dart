import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
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
                //    controller.setDefaultSms();
                // NotificationService().showTestNotification();
                controller.test();
              },
              icon: Icon(Icons.telegram))
        ],
        backgroundColor: color,
        elevation: 0,
        title: Obx(() => Text('${controller.messages.value}')),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SmsMessage>>(
        stream: controller.smsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SmsMessage> messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                SmsMessage message = messages[index];
                return Container(
                  margin: EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 3,
                    child: ListTile(
                      onTap: () =>
                          Get.toNamed('/message', arguments: messages[index]),
                      leading: Material(
                          borderRadius: BorderRadius.circular(42),
                          elevation: 3,
                          color: color,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.message, color: Colors.white),
                          )),
                      title:
                          Text(message.address?.replaceFirst(r'+', '') ?? ""),
                      subtitle: Text(message.body ?? ""),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
