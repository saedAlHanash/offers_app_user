import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:offers_awards/screens/auth/components/custom_auth_nav_bar.dart';
import 'package:offers_awards/screens/auth/forgot_password_screen.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/auth_services.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formPhoneKey = GlobalKey<FormFieldState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _login() {
    if (_isLoading) {
      CustomSnackBar.showRowSnackBarError("الرجاء الانتظار");
    } else {
      FocusScope.of(context).unfocus();
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        AuthServices.login(
                phone: _phoneController.text,
                password: _passwordController.text)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  void _forgotPassword() {
    FocusScope.of(context).unfocus();
    if (_isLoading) {
      CustomSnackBar.showRowSnackBarError("الرجاء الانتظار");
    } else {
      if (_formPhoneKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        AuthServices.getEmail(_phoneController.text).then((value) {
          if (value.isNotEmpty && value.containsKey('email')) {
            Get.to(
              () => ForgotPasswordScreen(
                email: value['email'],

                phone: _phoneController.text,
              ),
            );
          }
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    // initGetController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar.appBar(
        title: 'تسجيل الدخول',
        isBack: false,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            TextFormField(
              key: _formPhoneKey,
              controller: _phoneController,
              decoration: CustomInputDecoration.build('رقم الهاتف'),
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              cursorColor: AppUI.hintTextColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return FormValidator.phoneNullError;
                } else if (!FormValidator.phoneValidationRegExp
                    .hasMatch(value)) {
                  return FormValidator.invalidPhoneError;
                }
                return null;
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: CustomInputDecoration.buildPassword(
                showPassword: _showPassword,
                togglePasswordVisibility: _togglePasswordVisibility,
              ),
              obscureText: !_showPassword,
              obscuringCharacter: "*",
              cursorColor: AppUI.hintTextColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return FormValidator.passNullError;
                } else if (value.length != FormValidator.passwordLength) {
                  return FormValidator.shortPassError;
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.padding16,
                vertical: Dimensions.padding8,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _forgotPassword();
                  },
                  child: const Text(
                    "هل نسيت كلمة المرور؟",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: const Text(
                "تسجيل الدخول",
              ),
            ),
            if (_isLoading)
              const SpinKitThreeBounce(
                color: AppUI.primaryColor,
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomAuthNavBar(
        isLogin: true,
      ),
    );
  }
}
