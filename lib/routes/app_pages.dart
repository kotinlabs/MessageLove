import 'package:get/get.dart';
import 'package:smartsms/bindings/home_binding.dart';
import 'package:smartsms/bindings/message_binding.dart';
import 'package:smartsms/pages/home.dart';
import 'package:smartsms/pages/message.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE,
      page: () => const Message(),
      binding: MessageBinding(),
    ),
  ];
}
