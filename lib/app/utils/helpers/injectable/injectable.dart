import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:voyzi/app/utils/helpers/injectable/injectable.config.dart';

final getIt = GetIt.instance;

@i.injectableInit
void configuration({required Widget myApp}) {
  runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await getIt.init();
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      if (kDebugMode) {
        getIt<Dio>().interceptors.add(
              PrettyDioLogger(
                requestBody: true,
              ),
            );
      }

      getIt<Dio>().interceptors.add(RetryInterceptor(dio: getIt<Dio>()));
      FlutterNativeSplash.remove();
      runApp(myApp);
    },
    (error, stackTrace) {
      log("Err ${error.toString()}");
    },
    zoneSpecification: ZoneSpecification(
      handleUncaughtError: (Zone zone, ZoneDelegate delegate, Zone parent,
          Object error, StackTrace stackTrace) {
        log("Err ${error.toString()}");
      },
    ),
  );
}
