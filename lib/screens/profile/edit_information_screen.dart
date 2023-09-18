import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/profile_controller.dart';
import 'package:offers_awards/models/session_data.dart';
import 'package:offers_awards/screens/auth/select_location_screen.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/location/components/customize_marker.dart';
import 'package:offers_awards/screens/profile/reset_password_screen.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_icon_text_button.dart';
import 'package:offers_awards/screens/widgets/custom_info_tile.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/screens/widgets/custom_text_icon_button.dart';
import 'package:offers_awards/services/auth_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class EditInformationScreen extends StatefulWidget {
  final SessionData userInfo;

  const EditInformationScreen({Key? key, required this.userInfo})
      : super(key: key);

  @override
  State<EditInformationScreen> createState() => _EditInformationScreenState();
}

class _EditInformationScreenState extends State<EditInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileController profileController = Get.find<ProfileController>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryController = TextEditingController();
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  double? latitude;
  double? longitude;

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _showAddress = false;

  @override
  void initState() {
    setState(() {
      _nameController.text = widget.userInfo.name;
      _phoneController.text = widget.userInfo.phone;
      _emailController.text = widget.userInfo.email;
      _countryController.text = widget.userInfo.country;
      _areaController.text = widget.userInfo.area;
      _addressController.text = widget.userInfo.address;
      _selectedDate = widget.userInfo.birthday ?? DateTime.now();
      String formattedDate =
          '${_selectedDate.year.toString()}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'; // manually format the date string
      _dateController.text = formattedDate;
    });

    super.initState();
  }

  //
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: _selectedDate,
  //       firstDate: DateTime(1800),
  //       lastDate: DateTime(2101),
  //       locale: const Locale("ar"));
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //       String formattedDate =
  //           '${picked.year.toString()}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}'; // manually format the date string
  //       _dateController.text = formattedDate;
  //     });
  //   }
  // }

  void _editInfo() {
    FocusScope.of(context).unfocus();
    if (_isLoading) {
      CustomSnackBar.showRowSnackBarError("الرجاء الانتظار");
    } else {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        profileController
            .editProfileInfo(
                name: _nameController.text,
                phone: _phoneController.text,
                // phone: _phoneController.text != widget.userInfo.phone
                //     ? _phoneController.text
                //     : null,
                email: _emailController.text,
                address: _addressController.text,
                country: _countryController.text,
                area: _areaController.text,
                birthdate: _dateController.text,
                latitude: latitude ?? widget.userInfo.latitude,
                longitude: longitude ?? widget.userInfo.longitude)
            .then((value) {
          if (value) {
            Navigator.pop(context);
          }
        });
      }
      // Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar.appBar(
        title: 'تعديل البيانات',
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
                  } else if (!FormValidator.phoneValidationRegExp
                      .hasMatch(value)) {
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
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
            //   child: TextFormField(
            //     controller: _dateController,
            //     onTap: () {
            //       _selectDate(context);
            //     },
            //     decoration: CustomInputDecoration.build('تاريخ الميلاد'),
            //     textDirection: TextDirection.rtl,
            //     readOnly: true,
            //   ),
            // ),
            CustomInfoTile(
              title: "تغير كلمة المرور",
              fieldIcon: AppAssets.lock,
              actionIcon: Icons.arrow_forward_ios,
              margining: false,
              onActionPressed: () {
                Get.to(() => const ResetPasswordScreen());
              },
            ),
            CustomIconTextButton(
              text: 'عنواني',
              icon: _showAddress
                  ? Transform.rotate(
                      angle: 0.5 * 3.14,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: Dimensions.icon16,
                      ),
                    )
                  : Transform.rotate(
                      angle: 1.5 * 3.14,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: Dimensions.icon16,
                      ),
                    ),
              function: () {
                setState(() {
                  _showAddress = !_showAddress;
                });
              },
            ),
            Visibility(
              visible: _showAddress,
              child: Column(
                children: [
                  CustomIconTextButton(
                    text: ' التعديل بواسطة GPS',
                    iconPath: AppAssets.activeLocation,
                    function: () async {
                      final hasPermission =
                          await CustomizeLocation.handleLocationPermission();
                      if (hasPermission) {
                        final result =
                            await Get.to(() => const SelectLocationScreen());

                        if (result != null && result is Map<String, String>) {
                          _areaController.text =
                              result['address'] ?? widget.userInfo.area;
                          _countryController.text =
                              result['country'] ?? widget.userInfo.country;
                          _addressController.text =
                              result['homeStreet'] ?? widget.userInfo.address;
                          latitude = double.parse(result['latitude'] ??
                              widget.userInfo.latitude.toString());
                          longitude = double.parse(result['longitude'] ??
                              widget.userInfo.latitude.toString());
                        }
                      }
                    },
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.padding16),
                    child: TextFormField(
                      controller: _countryController,
                      // readOnly: preventEdit,
                      readOnly: true,
                      decoration: CustomInputDecoration.build('المحافظة'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return FormValidator.countryNullError;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.padding16),
                    child: TextFormField(
                      controller: _areaController,
                      decoration: CustomInputDecoration.build('اسم المنطقة'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return FormValidator.areaNullError;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.padding16),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: CustomInputDecoration.build('عنوان المنزل'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return FormValidator.homeNullError;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            CustomTextIconButton(
              text: "حذف الحساب",
              icon: Icons.cancel,
              onTap: () {
                if (_isLoading) {
                  CustomSnackBar.showRowSnackBarError("الرجاء الانتظار");
                } else {
                  setState(() {
                    _isLoading = true;
                  });
                  AuthServices.destroyAccount().then((value) {
                    setState(() {
                      _isLoading = false;
                    });
                  });
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding24),
              child: ElevatedButton(
                onPressed: () {
                  _editInfo();
                },
                child: const Text(
                  "حفظ التغيرات",
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
          heroTag: "support_chat_edit_info",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
