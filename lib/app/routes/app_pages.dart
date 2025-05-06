import 'package:get/get.dart';
import 'package:voyzi/app/routes/app_routes.dart';
import 'package:voyzi/app/ui/splash/splash.dart';

import '../ui/home/new_home_page.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.home, page: () => HomePage()),
    GetPage(name: AppRoutes.splash, page: () => Splash())
  ];
}
