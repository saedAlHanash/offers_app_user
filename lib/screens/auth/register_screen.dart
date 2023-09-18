import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/auth/address_screen.dart';
import 'package:offers_awards/screens/auth/components/custom_auth_nav_bar.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
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

  void _register() {
    // Close the keyboard
    FocusScope.of(context).unfocus();
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Simulate an asynchronous login request
      Get.to(
        () => AddressScreen(
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          password: _passwordController.text,
          passwordConf: _passwordConfController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar.appBar(
        title: 'انشاء حساب جديد',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                controller: _nameController,
                decoration: CustomInputDecoration.build('الاسم'),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.nameNullError;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                controller: _phoneController,
                decoration: CustomInputDecoration.build('رقم الهاتف'),
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.phoneNullError;
                  } else if (!FormValidator.phoneValidationRegExp.hasMatch(value)) {
                    return FormValidator.invalidPhoneError;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                controller: _emailController,
                decoration: CustomInputDecoration.build('البريد الالكتروني'),
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.emailNullError;
                  } else if (!FormValidator.emailValidationRegExp
                      .hasMatch(value)) {
                    return FormValidator.invalidEmailError;
                  }
                  return null;
                },
              ),
            ),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding24),
              child: ElevatedButton(
                onPressed: () {
                  _register();
                },
                child: const Text(
                  "متابعة",
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomAuthNavBar(),
    );
  }
}
