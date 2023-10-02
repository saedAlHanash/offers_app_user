import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/auth/login_screen.dart';
import 'package:offers_awards/screens/auth/components/custom_auth_nav_bar.dart';
import 'package:offers_awards/screens/auth/components/custom_pin_code.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/auth_services.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class VCodeScreen extends StatefulWidget {
  final bool isForgotScreen;
  final String email;
  final String phone;
  final String? password;
  final String? cPassword;
  final String? token;
  final int resendTimes;

  const VCodeScreen(
      {Key? key,
      this.isForgotScreen = false,
      required this.email,
      required this.phone,
      this.password,
      this.cPassword,
      this.resendTimes = 1,
      this.token})
      : super(key: key);

  @override
  State<VCodeScreen> createState() => _VCodeScreenState();
}

class _VCodeScreenState extends State<VCodeScreen> {
  String? currentVCode;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar.appBar(
        title: widget.isForgotScreen
            ? 'هل نسيت كلمة المرور؟'
            : 'التحقق من البريد الالكتروني',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.isForgotScreen
                ? 'تأكد من البريد الخاص بك'
                : "قم بإنشاء حسابك باستخدام البريد الالكتروني",
            style: const TextStyle(
              fontSize: Dimensions.font14,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: Dimensions.borderRadius15,
              border: Border.all(
                color: AppUI.greenBorderColor,
              ),
              color: AppUI.lightCardColor,
            ),
            margin: EdgeInsets.symmetric(vertical: Dimensions.padding16),
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.padding8,
              horizontal: Dimensions.padding16,
            ),
            child: Text(
              AppConstant.resendTimesMsg[widget.resendTimes] ??
                  "تم ارسال الكود! إذا لزم الأمر ، يمكننا إعادة إرسال رمز لمرتين إضافيتين.",
              style: const TextStyle(
                fontSize: Dimensions.font14,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.padding16,
            ),
            child: const Text(
              "أدخل رمز التحقق الخاص بك",
              style: TextStyle(
                fontSize: Dimensions.font14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.padding16,
            ),
            child: Text(
              "لقد أرسلنا رسالة نصية مع رمز التحقق الخاص بك إلى البريد الالكتروني${widget.email}",
              style: const TextStyle(
                fontSize: Dimensions.font14,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.padding4,
              vertical: Dimensions.padding16,
            ),
            child: CustomPinCode(onChanged: (value) {
              currentVCode = value;
            }, beforeTextPaste: (text) {
              currentVCode = text!;
              return true;
            }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
            child: ElevatedButton(
              onPressed: () {
                if (currentVCode == null ||
                    currentVCode?.length != FormValidator.pinLength) {
                  CustomSnackBar.showRowSnackBarError(
                      FormValidator.codeNullError);
                } else {
                  if (_isLoading) {
                    CustomSnackBar.showRowSnackBarError("الرجاء الانتظار");
                  } else {
                    setState(() {
                      _isLoading = true;
                    });
                    if (widget.isForgotScreen) {
                      AuthServices.forgotPassword(
                              phone: widget.phone,
                              token: currentVCode!,
                              newPassword: widget.password!,
                              confirmNewPassword: widget.cPassword!)
                          .then((value) {
                        if (value) {
                          Get.offAll(() => const LoginScreen());
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    } else {
                      AuthServices.verify(
                              widget.phone, currentVCode!, widget.token!)
                          .then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    }
                  }
                }
              },
              child: const Text(
                "تحقق",
              ),
            ),
          ),
          if (widget.resendTimes < AppConstant.resendCodeTimes)
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppUI.buttonColor2),
                ),
                onPressed: () {
                  if (_isLoading) {
                    CustomSnackBar.showRowSnackBarError("الرجاء الانتظار");
                  } else {
                    setState(() {
                      _isLoading = true;
                    });
                    if (widget.isForgotScreen) {
                      AuthServices.getEmail(widget.phone).then((value) {
                        if (value.isNotEmpty && value.containsKey('email')) {
                          Get.off(
                              () => VCodeScreen(
                                    email: widget.email,
                                    phone: widget.phone,
                                    resendTimes: widget.resendTimes + 1,
                                    password: widget.password,
                                    cPassword: widget.cPassword,
                                    isForgotScreen: widget.isForgotScreen,
                                    token: widget.token,
                                  ),
                              preventDuplicates: false);
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    } else {
                      AuthServices.resendVerification(phone: widget.phone)
                          .then((value) {
                        if (value) {
                          Get.off(
                              () => VCodeScreen(
                                    email: widget.email,
                                    phone: widget.phone,
                                    resendTimes: widget.resendTimes + 1,
                                    password: widget.password,
                                    cPassword: widget.cPassword,
                                    isForgotScreen: widget.isForgotScreen,
                                    token: widget.token,
                                  ),
                              preventDuplicates: false);
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    }
                  }
                },
                child: const Text(
                  "اعادة ارسال الرمز",
                  style: TextStyle(
                    color: AppUI.textColor,
                  ),
                ),
              ),
            ),
          if (_isLoading)
            const SpinKitThreeBounce(
              color: AppUI.primaryColor,
            ),
        ],
      ),
      bottomNavigationBar:
          widget.isForgotScreen ? null : const CustomAuthNavBar(),
    );
  }
}
