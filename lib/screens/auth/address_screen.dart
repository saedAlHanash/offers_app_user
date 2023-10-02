import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/auth/components/custom_auth_nav_bar.dart';
import 'package:offers_awards/screens/auth/select_location_screen.dart';
import 'package:offers_awards/screens/location/components/customize_marker.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_icon_text_button.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/auth_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';

class AddressScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String passwordConf;

  const AddressScreen({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.passwordConf,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  final _countryController = TextEditingController();
  final _homeController = TextEditingController();
  double? latitude;
  double? longitude;
  bool _isLoading = false;

  bool preventEdit = true;

  void _register() {
    if (_isLoading) {
      CustomSnackBar.showRowSnackBarError("الرجاء الانتظار"); 
    } else {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        if (latitude == null || longitude == null) {
          CustomSnackBar.showRowSnackBarError('عليك اختيار الموقع');
        } else {
          AuthServices.register(
                  name: widget.name,
                  phone: widget.phone,
                  email: widget.email,
                  address: _homeController.text,
                  country: _countryController.text,
                  area: _areaController.text,
                  password: widget.password,
                  passwordConf: widget.passwordConf,
                  latitude: latitude!,
                  longitude: longitude!)
              .then((value) {
            setState(() {
              _isLoading = false;
            });

          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar.appBar(
        title: 'العنوان',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomIconTextButton(
              text: ' التسجيل بواسطة GPS',
              iconPath: AppAssets.activeLocation,
              function: () async {
                final hasPermission =
                    await CustomizeLocation.handleLocationPermission();
                if (hasPermission) {
                  final result = await Get.to(()=>const SelectLocationScreen());
                  if (result != null && result is Map<String, String>) {
                    _areaController.text = result['address'] ?? '';
                    _countryController.text = result['country'] ?? '';
                    _homeController.text = result['homeStreet'] ?? '';
                    latitude = double.parse(result['latitude'] ?? '0.0');
                    longitude = double.parse(result['longitude'] ?? '0.0');
                    setState(() {
                      preventEdit = false;
                    });
                  }
                } else {
                  // Get.rawSnackbar(message: ,backgroundColor: AppUI.darkCardColor);
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                controller: _countryController,
                decoration: CustomInputDecoration.build('المحافظة'),
                // readOnly: preventEdit,
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.countryNullError;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                controller: _areaController,
                decoration: CustomInputDecoration.build('اسم المنطقة'),
                readOnly: preventEdit,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.areaNullError;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: TextFormField(
                controller: _homeController,
                decoration: CustomInputDecoration.build('عنوان المنزل'),
                readOnly: preventEdit,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FormValidator.homeNullError;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
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
            if (_isLoading)
              const SpinKitThreeBounce(
                color: AppUI.primaryColor,
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomAuthNavBar(),
    );
  }
}
