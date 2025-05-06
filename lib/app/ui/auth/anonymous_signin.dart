import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voyzi/app/routes/app_routes.dart';
import 'package:voyzi/app/services/auth_service.dart';
import 'package:voyzi/app/ui/widgets/custom_image_view.dart';
import 'package:voyzi/gen/assets.gen.dart';

class AnonymousSignin extends StatefulWidget {
  const AnonymousSignin({super.key});

  @override
  State<AnonymousSignin> createState() => _AnonymousSigninState();
}

class _AnonymousSigninState extends State<AnonymousSignin> {
  bool isLoading = false;

  Future<void> signInAnonymously() async {
    setState(() => isLoading = true);
    try {
      await AuthService().signInAnonymously();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar("Error", "Failed to sign in anonymously");
    } finally {
      setState(() => isLoading = false);
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
                    onPressed: signInAnonymously,
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