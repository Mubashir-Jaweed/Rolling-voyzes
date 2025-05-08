import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:voyzi/app/utils/helpers/extensions/extensions.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/utils/helpers/injectable/injectable.dart';
import 'app/utils/themes/app_theme.dart';

const _kAppName = 'Voyzi';
final GlobalKey<NavigatorState> navigationState = GlobalKey<NavigatorState>();

void main()async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
  configuration(myApp: MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: _kAppName,
      navigatorKey: navigationState,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(getIt<SharedPreferences>().getAppLocal ?? 'en'),
      themeMode: ThemeMode.light,
      builder: EasyLoading.init(),
      theme: AppTheme.darkTheme,
      getPages: AppPages.routes,
      initialRoute: AppRoutes.splash,
    );
  }
}
