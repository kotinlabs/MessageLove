import 'package:get/get.dart';
import 'package:smartsms/controllers/message_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(
      () => MessageController(),
    );
  }
}
