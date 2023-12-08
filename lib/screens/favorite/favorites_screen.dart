import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/favorite_controller.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/empty_screen.dart';
import 'package:offers_awards/screens/search/custom_search_delegate.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/offer/offer_item.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteController _favoriteController = Get.put(FavoriteController());
  bool isRetry = false;

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(title: 'المفضلة'),
      body: FutureBuilder<List<Offer>>(
          future: _favoriteController.fetchFavoriteOffers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                isRetry) {
              return const Center(
                child: SpinKitChasingDots(
                  color: AppUI.primaryColor,
                ),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.requireData.isNotEmpty) {
                return Obx(() {
                  return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.padding16,
                      vertical: Dimensions.padding4,
                    ),
                    itemCount: _favoriteController.favoriteOffers.length,
                    itemBuilder: (context, index) => SizedBox(
                      height: Dimensions.favOfferHeight,
                      child: OfferItem(
                        isFav: true,
                        offer: _favoriteController.favoriteOffers[index],
                      ),
                    ),
                  );
                });
              } else {
                return EmptyScreen(
                  svgPath: AppAssets.eFavorite,
                  title: 'عذرا لا يوجد أي مفضلة',
                  buttonText: 'ابحث عن العروض',
                  buttonFunction: () {
                    showSearch(
                        context: context, delegate: CustomSearchDelegate());
                  },
                );
              }
            } else if (snapshot.hasError) {
              return CustomFailed(
                onRetry: () {
                  setState(() {
                    isRetry = true;
                  });
                  _favoriteController.retry().then((value) {
                    setState(() {
                      isRetry = false;
                    });
                  });
                },
              );
            } else {
              return const Center(
                child: SpinKitChasingDots(
                  color: AppUI.primaryColor,
                ),
              );
            }
          }),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: Dimensions.padding8,
          left: Dimensions.padding16,
        ),
        child: FloatingActionButton(
          heroTag: "support_chat_favorites",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
