import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voyzi/app/routes/app_routes.dart';
import 'package:voyzi/app/services/auth_services.dart';
import 'package:voyzi/app/utils/themes/app_theme.dart';

class AnonymousSignin extends StatefulWidget {
  const AnonymousSignin({super.key});

  @override
  State<AnonymousSignin> createState() => _AnonymousSigninState();
}

class _AnonymousSigninState extends State<AnonymousSignin> {
  bool isLoading = false;
  bool isLogin = false;
  String? result = '';
  String? error;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Future<void> signInAnonymously() async {
  //   final user = await AuthService.instance.signInAnonymously();
  //   log('..............:${user}');
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     Get.offAllNamed(AppRoutes.home);
  //   } else {
  //     Get.snackbar("Error", "Failed to sign in  anonymously: ");
  //   }
  // }

  void toggleForm() => setState(() => isLogin = !isLogin);

  Future<void> handleAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if(email.isEmpty || password.isEmpty){
      setState(() {
      result = 'Email & password required';
      });
      return;
    }
  
    if (!isLogin) {
      result = await AuthService.instance.signUp(email, password);
    } else {
      result = await AuthService.instance.login(email, password);
    }

    if (result == null) {
      print('loged in successfullt...........................................................................................');
     Get.offAllNamed(AppRoutes.home);
    }else{
      print('result ..........................................................$result');
      setState(() => error = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    final appStyles = AppStyles.of(context);
    return Scaffold(
      backgroundColor: appColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isLogin ? 'Login' : "Signup",
              style: TextStyle(
                  fontSize: 32,
                  color: appColors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Enter your email"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Enter your Password"),
            ),
            SizedBox(
              height:20,
            ),
             Text(
                  '$result',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.redAccent, fontSize: 16,),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${isLogin ? 'Dont' : 'Already'} have an account ',
                  style: TextStyle(color: appColors.textColor, fontSize: 16),
                ),
                InkWell(
                    onTap: () {
                      toggleForm();
                    },
                    child: Text(
                      '${isLogin ? "SignUp" : 'Login'}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appColors.textColor,
                          fontSize: 16),
                    )),
              ],
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                handleAuth();
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                    color: appColors.borderColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  isLogin ? "Login" : 'Signup',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
