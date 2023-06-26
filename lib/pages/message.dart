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
    final TextEditingController _textEditingController =
        TextEditingController();
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
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
          title: Text('${Get.arguments.address}'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("${Get.arguments.body}"),
                    )),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 32.0),
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Text message',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: color,
                        ),
                        onPressed: () {
                          Telephony.instance
                              .sendSms(
                                  to: '${Get.arguments.address}',
                                  message: _textEditingController.text
                                      .trim()
                                      .toString())
                              .then((value) =>
                                  print(_textEditingController.text.trim()))
                              .then((value) => Get.snackbar(
                                  "Message sent",
                                  _textEditingController.text
                                      .trim()
                                      .toString()))
                              .then((value) => _textEditingController.clear());
                        },
                      ),
                      SizedBox(width: 8.0),
                    ],
                  ),
                ),
              ]),
        )

        /*StreamBuilder<List<SmsMessage>>(
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
      ),*/
        );
  }
}
