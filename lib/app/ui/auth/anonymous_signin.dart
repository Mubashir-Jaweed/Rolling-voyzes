import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voyzi/app/routes/app_routes.dart';
import 'package:voyzi/app/services/auth_services.dart';
import 'package:voyzi/app/ui/widgets/custom_image_view.dart';
import 'package:voyzi/gen/assets.gen.dart';

class AnonymousSignin extends StatefulWidget {
  const AnonymousSignin({super.key});
  

  @override
  State<AnonymousSignin> createState() => _AnonymousSigninState();
}

class _AnonymousSigninState extends State<AnonymousSignin> {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//  Future<void> signInAnonymously() async {
//   final user  = await AuthService.instance.signInAnonymously();
//   log("user: $user");
//   // setState(() => isLoading = true);
//   // try {
//   //   User? user = await AuthService.instance.signInAnonymously();
//   //   log('user : $user');
//   //   if (user != null) {
//   //     print('Signed in as: ${user.uid}');
//   //     Get.offAllNamed(AppRoutes.home); 
//   //   } else {
//   //     Get.snackbar("Error", "Failed to sign sdsd in: User is null");
//   //   }
//   // } catch (e) {
//   //   log('error :$e');
//   //   Get.snackbar(
//   //     "Error", 
//   //     "Failed to sign in nikal anonymously: ${e.toString()}",
//   //     snackPosition: SnackPosition.BOTTOM,
//   //   );
//   //   print('Sign-in error: $e');
//   // } finally {
//   //   if (mounted) {
//   //     setState(() => isLoading = false);
//   //   }
//   // }
// }


Future<void> signInAnonymously() async {
  final user = await AuthService.instance.signInAnonymously();
  log('..............:${user}');
  if(FirebaseAuth.instance.currentUser != null){
    Get.offAllNamed(AppRoutes.home);
  }else{
    Get.snackbar(
      "Error", 
      "Failed to sign in  anonymously: "
    );
  }
  
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo at the center
            ImageView(
              imagePath: Assets.png.appIconWave.path,
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 50),
            
            // Sign in button
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: ()async{
                      await signInAnonymously();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}