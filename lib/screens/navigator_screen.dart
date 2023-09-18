import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/profile_controller.dart';
import 'package:offers_awards/screens/cart/cart_screen.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/home/components/popup_offer.dart';
import 'package:offers_awards/screens/home/home_screen.dart';
import 'package:offers_awards/screens/location/location_screen.dart';
import 'package:offers_awards/screens/profile/profile_screen.dart';
import 'package:offers_awards/services/home_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

import 'widgets/custom_network_image.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin<MyHomePage> {
  @override
  bool get wantKeepAlive => true;
  final _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  bool _isDisposed = false;

  final List<Widget> bottomBarPages = [
    const HomeScreen(),
    const LocationScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showDialog();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _showDialog() async {
    await HomeServices.popup().then((value) {
      if (!_isDisposed && mounted) {
        PopUpOffer.showDialogAds(
          context,
          banner: value,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            bottomBarPages.length,
            (index) => bottomBarPages[index],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: kBottomNavigationBarHeight,
          index: _selectedIndex,
          backgroundColor: Colors.transparent,
          color: AppUI.greyCardColor,
          items: <Widget>[
            Padding(
              padding: EdgeInsets.all(Dimensions.padding8),
              child: SvgPicture.asset(
                _selectedIndex == 0 ? AppAssets.activeHome : AppAssets.home,
                height: Dimensions.icon21,
                width: Dimensions.icon21,
                fit: BoxFit.scaleDown,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.padding8),
              child: SvgPicture.asset(
                _selectedIndex == 1
                    ? AppAssets.activeLocation
                    : AppAssets.location,
                height: Dimensions.icon21,
                width: Dimensions.icon21,
                fit: BoxFit.scaleDown,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.padding8),
              child: SvgPicture.asset(
                _selectedIndex == 2 ? AppAssets.activeCart : AppAssets.cart,
                height: Dimensions.icon21,
                width: Dimensions.icon21,
                fit: BoxFit.scaleDown,
              ),
            ),
            GetBuilder<ProfileController>(
              init: ProfileController(),
              builder: (profileController) {
                if (profileController.userInfo.value != null &&
                    profileController.userInfo.value!.image != null &&
                    profileController.userInfo.value!.image!.isNotEmpty) {
                  return ClipRRect(
                    borderRadius: Dimensions.borderRadius50,
                    child: CustomNetworkImage(
                      imageUrl: profileController.userInfo.value!.image!,
                      width: Dimensions.logoSize,
                      height: Dimensions.logoSize,
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(Dimensions.padding8),
                    child: _selectedIndex == 3
                        ? SvgPicture.asset(
                            AppAssets.activeProfile,
                            height: Dimensions.icon21,
                            width: Dimensions.icon21,
                            fit: BoxFit.scaleDown,
                          )
                        : const Icon(
                            Icons.person,
                            color: AppUI.iconColor1,
                            size: Dimensions.icon21,
                          ),
                  );
                }
              },
            )
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
        extendBody: true,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            bottom: Dimensions.padding8,
            left: Dimensions.padding16,
          ),
          child: FloatingActionButton(
            heroTag: "support_chat",
            onPressed: () {
              Get.to(() => const ChatScreen());
            },
            child: SvgPicture.asset(AppAssets.supportChat),
          ),
        ),
      ),
    );
  }
}
