import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voyzi/app/routes/app_routes.dart';
import 'package:voyzi/app/ui/widgets/custom_image_view.dart';
import 'package:voyzi/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:voyzi/gen/assets.gen.dart';

class Splash extends GetItHook {
  const Splash({super.key});

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {

    if(FirebaseAuth.instance.currentUser == null){
      Get.offAllNamed(AppRoutes.login);
    }else{
      Get.offAllNamed(AppRoutes.home);
      
    }
    });
    super.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: ImageView(
          imagePath: Assets.png.appIconWave.path,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}