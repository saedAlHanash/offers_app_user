import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/empty_screen.dart';
import 'package:offers_awards/screens/navigator_screen.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/profile_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfController = TextEditingController();

  bool _showPassword = false;
  bool _showOldPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  void _togglePasswordVisibility({bool isConf = false, bool isOld = false}) {
    if (isConf) {
      setState(() {
        _showConfirmPassword = !_showConfirmPassword;
      });
    } else if (isOld) {
      setState(() {
        _showOldPassword = !_showOldPassword;
      });
    } else {
      setState(() {
        _showPassword = !_showPassword;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar.appBar(
        title: 'تغير كلمة المرور',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                controller: _oldPasswordController,
                decoration: CustomInputDecoration.buildPassword(
                  showPassword: _showOldPassword,
                  togglePasswordVisibility: () {
                    _togglePasswordVisibility(isOld: true);
                  },
                  hintText: 'كلمة المرور القديمة',
                ),
                obscureText: !_showOldPassword,
                obscuringCharacter: "*",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.oldPassNullError;
                  } else if (value.length < FormValidator.passwordLength) {
                    return FormValidator.shortPassError;
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
                  hintText: 'كلمة المرور الجديدة',
                ),
                obscureText: !_showPassword,
                obscuringCharacter: "*",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.newPassNullError;
                  } else if (value.length != FormValidator.passwordLength) {
                    return FormValidator.shortPassError;
                  } else if (_oldPasswordController.text == value) {
                    return FormValidator.oldMatchNewError;
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
                  hintText: 'تاكيد كلمة المرور الجديدة',
                ),
                obscureText: !_showConfirmPassword,
                obscuringCharacter: "*",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.newCNewPassNullError;
                  } else if (_passwordController.text != value) {
                    return FormValidator.matchPassError;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding24),
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_isLoading) {
                    CustomSnackBar.showRowSnackBarError("الرجاء الانتظار");
                  } else {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      ProfileServices.resetPassword(
                              oldPassword: _oldPasswordController.text,
                              newPassword: _passwordController.text,
                              confirmNewPassword: _passwordConfController.text)
                          .then((value) {
                        if (value) {
                          Get.to(
                            () => EmptyScreen(
                              svgPath: AppAssets.done,
                              isDone: true,
                              title: 'تم تغيير كلمة المرور بنجاح',
                              buttonText: 'متابعة',
                              buttonFunction: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyHomePage(),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    }
                  }
                },
                child: const Text(
                  "حفظ كلمة المرور",
                ),
              ),
            ),
            if (_isLoading)
              const SpinKitThreeBounce(
                color: AppUI.primaryColor,
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: Dimensions.padding8,
          left: Dimensions.padding16,
        ),
        child: FloatingActionButton(
          heroTag: "support_chat_reset_password",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
