import 'package:get/get.dart';
import 'package:smartsms/bindings/home.binding.dart';
import 'package:smartsms/pages/home.dart';

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
  ];
}
