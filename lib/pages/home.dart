import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:smartsms/controllers/home_controller.dart';
import 'package:smartsms/other/color.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
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
          title: const Text('Smart SMS'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<String>>(
          stream: controller.phoneNumberStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String> phoneNumbers = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: phoneNumbers.length,
                itemBuilder: (context, index) {
                  String phoneNumber = phoneNumbers[index];
                  return ListTile(
                    title: Text(phoneNumber),
                    onTap: () {
                      Get.toNamed('/message', arguments: phoneNumber);
                      // controller.openConversation(phoneNumber);
                    },
                  );
                },
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: color,
              ));
            }
          },
        ));
  }
}
