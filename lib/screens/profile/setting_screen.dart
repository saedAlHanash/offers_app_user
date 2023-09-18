import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/profile/reset_password_screen.dart';
import 'package:offers_awards/screens/location/components/customize_marker.dart';
import 'package:offers_awards/screens/profile/components/contact_button.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_info_tile.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/services/auth_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _havePermission;
  bool _isLoaded = true;
  bool _isProcess = false;
  bool _isProcessL = false;

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  getPermission() async {
    _isLoaded = true;
    setState(() {});
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _havePermission = false;
    } else {
      _havePermission = true;
    }
    _isLoaded = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      minPadding: true,
      appBar: CustomAppBar.appBar(
        title: 'الاعدادات',
      ),
      body: _isLoaded
          ? SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: const SpinKitChasingDots(
                color: AppUI.primaryColor,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomInfoTile(
                  title: "تغير كلمة المرور",
                  fieldIcon: AppAssets.lock,
                  actionIcon: Icons.arrow_forward_ios,
                  onActionPressed: () {
                    Get.to(() => const ResetPasswordScreen());
                  },
                ),
                CustomInfoTile(
                    title: "ضبط الوصول للموقع",
                    fieldIcon: AppAssets.address,
                    switchAction: _havePermission,
                    onActionPressed: (value) async {
                      _isProcess = true;
                      setState(() {});
                      _havePermission =
                          await CustomizeLocation.changePermissionStatus();
                      _isProcess = false;
                      setState(() {});
                    }),
                if (_isProcess)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.padding8),
                    child: const SpinKitThreeBounce(
                      color: AppUI.primaryColor,
                    ),
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  padding: EdgeInsets.only(top: Dimensions.padding24),
                  alignment: Alignment.center,
                  child: const Text(
                    "اتصل بنا",
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ContactButton(
                          heroTag: 'whats_app',
                          icon: 'assets/svg/social/whats_app.svg',
                          url: '',
                        ),
                        ContactButton(
                          heroTag: 'facebook',
                          icon: 'assets/svg/social/facebook.svg',
                          url: '',
                        ),
                        ContactButton(
                          heroTag: 'call',
                          icon: 'assets/svg/social/call.svg',
                          url: '',
                        ),
                      ]),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.padding16,
                      horizontal: Dimensions.padding8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isProcessL = true;
                      });
                      AuthServices.logout().then((value) {
                        setState(() {
                          _isProcessL = false;
                        });
                      });
                    },
                    child: const Text(
                      "تسجيل خروج",
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimensions.padding8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppUI.buttonColor2),
                    ),
                    onPressed: () { setState(() {
                      _isProcessL = true;
                    });
                      AuthServices.destroyAccount().then((value) {
                        setState(() {
                          _isProcessL = false;
                        });
                      });
                    },
                    child: const Text(
                      "حذف حسابي",
                      style: TextStyle(
                        color: AppUI.textColor,
                      ),
                    ),
                  ),
                ),
                if (_isProcessL)
                  const SpinKitThreeBounce(
                    color: AppUI.primaryColor,
                  ),
              ],
            ),
    );
  }
}
