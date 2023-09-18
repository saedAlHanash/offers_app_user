import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/favorite/favorites_screen.dart';
import 'package:offers_awards/screens/notification/notifications_screen.dart';

import 'package:offers_awards/screens/widgets/custom_search_container.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class HomeAppBar extends StatelessWidget {
  final bool isDark;
  const HomeAppBar({Key? key, this.isDark = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.padding24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.only(
                top: isDark ? Dimensions.padding16 : 0,
                bottom: isDark ? Dimensions.padding4 : 0,
              ),
              child: CustomSearchContainer(
                isWhite: !isDark,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(
                top: Dimensions.padding8,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(() =>  const FavoritesScreen());
                },
                child: Icon(
                  Icons.favorite,
                  color: isDark ? AppUI.iconColor1 : AppUI.secondaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(
                top: Dimensions.padding8,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const NotificationsScreen());
                },
                child: Icon(
                  Icons.notifications,
                  color: isDark ? AppUI.iconColor1 : AppUI.secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
