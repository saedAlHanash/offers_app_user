import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/auth/login_screen.dart';
import 'package:offers_awards/screens/auth/register_screen.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomAuthNavBar extends StatelessWidget {
  final bool isLogin;

  const CustomAuthNavBar({
    Key? key,
    this.isLogin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.padding16,
        vertical: Dimensions.padding4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isLogin ? "انشاء حساب جديد؟" : "هل لديك حساب؟",
          ),
          TextButton(
            onPressed: () {
              if (isLogin) {
                Get.to(() => const RegisterScreen());
              } else {
                Get.offAll(const LoginScreen());
              }
            },
            child: Text(
              isLogin ? "قم بالتسجيل" : "تسجيل الدخول",
            ),
          ),
        ],
      ),
    );
  }
}
