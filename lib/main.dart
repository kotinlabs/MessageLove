import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:smartsms/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart SMS",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
