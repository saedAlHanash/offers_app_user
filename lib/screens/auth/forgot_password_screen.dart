import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/auth/vcode_screen.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String email;
  final String phone;

  const ForgotPasswordScreen(
      {super.key,
      required this.email,
      required this.phone});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _passwordConfController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  void _togglePasswordVisibility({bool isConf = false}) {
    if (!isConf) {
      setState(() {
        _showPassword = !_showPassword;
      });
    } else {
      setState(() {
        _showConfirmPassword = !_showConfirmPassword;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar.appBar(
        title: 'إعادة تعين كلمة المرور',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                controller: _passwordController,
                decoration: CustomInputDecoration.buildPassword(
                  showPassword: _showPassword,
                  togglePasswordVisibility: _togglePasswordVisibility,
                ),
                obscureText: !_showPassword,
                obscuringCharacter: "*",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.passNullError;
                  } else if (value.length != FormValidator.passwordLength) {
                    return FormValidator.shortPassError;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                controller: _passwordConfController,
                decoration: CustomInputDecoration.buildPassword(
                  showPassword: _showConfirmPassword,
                  togglePasswordVisibility: () {
                    _togglePasswordVisibility(isConf: true);
                  },
                  hintText: 'تأكيد كلمة المرور',
                ),
                obscureText: !_showConfirmPassword,
                obscuringCharacter: "*",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.newCPassNullError;
                  } else if (_passwordController.text != value) {
                    return FormValidator.matchPassError;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding24),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(
                    () => VCodeScreen(
                      isForgotScreen: true,
                      email: widget.email,
                      phone: widget.phone,
                      password: _passwordController.text,
                      cPassword: _passwordConfController.text,
                    ),
                  );
                },
                child: const Text(
                  "حفظ كلمة المرور",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
