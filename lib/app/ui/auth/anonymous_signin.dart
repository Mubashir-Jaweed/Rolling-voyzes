import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voyzi/app/my_utils/images.dart';
import 'package:voyzi/app/routes/app_routes.dart';
import 'package:voyzi/app/services/auth_services.dart';
import 'package:voyzi/app/ui/widgets/custom_image_view.dart';
import 'package:voyzi/app/utils/themes/app_theme.dart';
import 'package:voyzi/gen/assets.gen.dart';

class AnonymousSignin extends StatefulWidget {
  const AnonymousSignin({super.key});

  @override
  State<AnonymousSignin> createState() => _AnonymousSigninState();
}

class _AnonymousSigninState extends State<AnonymousSignin> {
  bool isLoading = false;
  bool isLogin = true;
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

    if (email.isEmpty || password.isEmpty) {
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
      print(
          'loged in successfullt...........................................................................................');
      Get.offAllNamed(AppRoutes.home);
    } else {
      print(
          'result ..........................................................$result');
      setState(() => error = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: Get.height,
          decoration: isLogin ?  BoxDecoration(
            image: DecorationImage(image: AssetImage(Images.login_bg),fit: BoxFit.cover)
          ) :BoxDecoration(
            color: Color(0xff00113c)
          ),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
        
               isLogin ?  Image.asset(
                  Images.login_icon,
                  width: 280,
                )  :Image.asset(
                  Images.signup_icon,
                  width: 240,
                ),
                
              
              Text(
                textAlign: TextAlign.center,
                isLogin ? 'Login' : "Create \n Account",
                style: TextStyle(
                  fontSize: 42,
                  height: 1,
                  color: appColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "Enter your Email",
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xff011341),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xff0b1a48),
                        )),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xff0b1a48), width: 2),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "Enter your Password",
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xff011341),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xff0b1a48),
                        )),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xff0b1a48), width: 2),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15)),
              ),
              SizedBox(height: 10,),
              
              Text(
                '$result',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  handleAuth();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xff0061cc),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    isLogin ? "Login" : 'Sign up',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${isLogin ? "Don't" : 'Already'} have an account? ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  InkWell(
                      onTap: () {
                        toggleForm();
                      },
                      child: Text(
                        '${isLogin ? "Create one" : 'Login'}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2e90d0),
                            fontSize: 16),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
