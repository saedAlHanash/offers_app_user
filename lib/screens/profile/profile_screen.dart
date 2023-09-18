import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/profile_controller.dart';
import 'package:offers_awards/db/settings.dart';
import 'package:offers_awards/models/session_data.dart';
import 'package:offers_awards/models/soical_media.dart';
import 'package:offers_awards/screens/order/orders_screen.dart';
import 'package:offers_awards/screens/profile/about_screen.dart';
import 'package:offers_awards/screens/profile/components/profile_header.dart';
import 'package:offers_awards/screens/profile/components/soical_media_list.dart';
import 'package:offers_awards/screens/profile/edit_information_screen.dart';
import 'package:offers_awards/screens/widgets/custom_info_tile.dart';
import 'package:offers_awards/services/auth_services.dart';
import 'package:offers_awards/services/notifications_services.dart';
import 'package:offers_awards/services/app_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool getNotifications;
  late Future<List<SocialMedia>> socialMedia;

  @override
  void initState() {
    getNotifications = Settings.gettingNotification();
    socialMedia = AppServices.fetchSocialMedia();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<ProfileController>(
            init: ProfileController(),
            builder: (profileController) {
              if (profileController.userInfo.value == null) {
                return const Center(
                  child: SpinKitChasingDots(
                    color: AppUI.primaryColor,
                  ),
                );
              } else {
                SessionData userInfo = profileController.userInfo.value!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileHeader(
                        profileImage: userInfo.image ?? "",
                        email: userInfo.email,
                        name: userInfo.name,
                      ),
                      SizedBox(
                        height: Dimensions.padding24,
                      ),
                      CustomInfoTile(
                        title: 'الاشعارات',
                        fieldIcon: AppAssets.coloredNotification,
                        switchAction: getNotifications,
                        onActionPressed: (value) {
                          NotificationsServices()
                              .enableNotification(value)
                              .then((data) {
                            if (data) {
                              Settings.setNotification(value);
                              setState(() {
                                getNotifications = value;
                              });
                            }
                          });
                        },
                      ),
                      CustomInfoTile(
                        title: 'تعديل البيانات',
                        fieldIcon: AppAssets.info,
                        actionIcon: Icons.arrow_forward_ios,
                        onActionPressed: () {
                          Get.to(
                            () => EditInformationScreen(
                              userInfo: userInfo,
                            ),
                          );
                        },
                      ),
                      CustomInfoTile(
                        title: 'طلباتي',
                        fieldIcon: AppAssets.order,
                        actionIcon: Icons.arrow_forward_ios,
                        onActionPressed: () {
                          Get.to(() => const OrdersScreen());
                        },
                      ),
                      CustomInfoTile(
                        title: 'اعرف اكتر',
                        fieldIcon: AppAssets.about,
                        actionIcon: Icons.arrow_forward_ios,
                        onActionPressed: () {
                          Get.to(() => const AboutScreen());
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.padding24,
                          vertical: Dimensions.padding16,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "تابعنا",
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FutureBuilder<List<SocialMedia>>(
                          future: socialMedia,
                          builder: (context, connection) {
                            if (connection.hasData) {
                              return SocialMediaList(socialMedia: connection.data!);
                            }
                            return const SpinKitThreeBounce(
                              color: AppUI.primaryColor,
                            );
                          }),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.padding24,
                          vertical: Dimensions.padding24,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            AuthServices.logout();
                          },
                          child: const Text(
                            "تسجيل خروج",
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.padding24,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Design By Bandtech",
                          style: TextStyle(
                            fontSize: Dimensions.font12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: kBottomNavigationBarHeight * 1.25,
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
