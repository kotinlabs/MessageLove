import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:smartsms/controllers/message_controller.dart';
import 'package:smartsms/other/color.dart';
import 'package:telephony/telephony.dart';

class Message extends GetView<MessageController> {
  const Message({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                controller.getSMS();
              },
              icon: Icon(Icons.telegram))
        ],
        backgroundColor: color,
        elevation: 0,
        title: Text('${Get.arguments}'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SmsMessage>>(
        stream: controller.smsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SmsMessage> messages = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                SmsMessage message = messages[index];
                return ListTile(
                  title: Text(message.address.toString()),
                  subtitle: Text(message.body.toString()),
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
