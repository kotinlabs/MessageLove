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
          backgroundColor: color,
          elevation: 0,
          title: Text('${Get.arguments.address.replaceFirst(r'+', '')}'),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Get.arguments.body == ''
                  ? const SizedBox()
                  : Material(
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 32.0),
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Text message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
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
                            .then((value) => Get.snackbar("Message sent",
                                _textEditingController.text.trim().toString()))
                            .then((value) => _textEditingController.clear());
                      },
                    ),
                    const SizedBox(width: 8.0),
                  ],
                ),
              ),
            ]));
  }
}
