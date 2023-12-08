import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:offers_awards/models/notification.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/notification/components/image_notification.dart';
import 'package:offers_awards/screens/notification/components/offer_notification.dart';
import 'package:offers_awards/screens/notification/components/order_notification.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/services/notifications_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> notifications;
  bool isLoading = false;

  @override
  void initState() {
    notifications = NotificationsServices.fetch();
    super.initState();
  }

  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });
    notifications = NotificationsServices.fetch();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(
        title: 'الاشعارات',
      ),
      body: FutureBuilder<List<NotificationModel>>(
          future: notifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                isLoading) {
              return const Center(
                child: SpinKitChasingDots(
                  color: AppUI.primaryColor,
                ),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.requireData.isNotEmpty) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.padding16,
                      horizontal: Dimensions.padding24,
                    ),
                    itemCount: snapshot.requireData.length,
                    itemBuilder: (context, index) {
                      NotificationModel notificationModel =
                          snapshot.requireData[index];

                      if (notificationModel.type == 'order') {
                        return OrderNotification(
                            notification: notificationModel);
                      } else if (notificationModel.image != null) {
                        return ImageNotification(
                            notification: notificationModel);
                      } else {
                        return OfferNotification(
                            notification: notificationModel);
                      }
                    });
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: Lottie.asset(
                    AppAssets.emptyList,
                    fit: BoxFit.scaleDown,
                    repeat: false,
                  ),
                );
              }
            } else if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return CustomFailed(
                onRetry: retry,
              );
            }
            return const SizedBox.shrink();
          }),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: Dimensions.padding8,
          left: Dimensions.padding16,
        ),
        child: FloatingActionButton(
          heroTag: "support_chat_notifications",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
