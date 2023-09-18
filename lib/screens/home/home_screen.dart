import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:offers_awards/models/category.dart';
import 'package:offers_awards/screens/home/components/categories_list.dart';
import 'package:offers_awards/screens/home/components/fixed_banner.dart';
import 'package:offers_awards/screens/home/components/home_app_bar.dart';
import 'package:offers_awards/screens/home/components/home_offers.dart';
import 'package:offers_awards/screens/home/components/main_slider.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/services/category_services.dart';
import 'package:offers_awards/services/home_services.dart';
import 'package:offers_awards/utils/app_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // with AutomaticKeepAliveClientMixin<HomeScreen> {
  // @override
  // bool get wantKeepAlive => true;
  int currentIndex = 0;

  late Future<Map<String, List<dynamic>>> homeSectionsData;
  late Future<List<Category>> categories;
  bool isLoading = false;

  @override
  void initState() {
    homeSectionsData = HomeServices.fetch();
    categories = CategoryServices.fetch();
    super.initState();
  }

  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });
    homeSectionsData = HomeServices.fetch();
    categories = CategoryServices.fetch();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      body: FutureBuilder<Map>(
          future: homeSectionsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                isLoading) {
              return const Center(
                child: SpinKitChasingDots(
                  color: AppUI.primaryColor,
                ),
              );
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        if (snapshot.data!['slider'].isNotEmpty)
                          MainSlider(
                            sliders: snapshot.data!['slider'],
                          ),
                        //appbar
                        HomeAppBar(
                          isDark: snapshot.data!['slider'].isEmpty,
                        ),
                      ],
                    ),
                    //categories
                    FutureBuilder<List<Category>>(
                        future: categories,
                        builder: (context, category) {
                          if (category.hasData) {
                            return CategoriesList(
                              categories: category.data!,
                            );
                          }
                          return const SpinKitThreeBounce(
                            color: AppUI.primaryColor,
                          );
                        }),

                    //categories imgs
                    if (snapshot.data!['first_banner'].isNotEmpty)
                      FixedBanner(
                        banners: snapshot.data!['first_banner'],
                      ),

                    //hot offers title
                    if (snapshot.data!['hot'].isNotEmpty)
                      HomeOffers(
                        filter: 'hot',
                        offers: snapshot.data!['hot'],
                      ),

                    //hot offers  imgs
                    if (snapshot.data!['last_banner'].isNotEmpty)
                      FixedBanner(
                        banners: snapshot.data!['last_banner'],
                      ),

                    //most sold
                    if (snapshot.data!['most_sold'].isNotEmpty)
                      HomeOffers(
                        filter: 'most_sold',
                        offers: snapshot.data!['most_sold'],
                      ),

                    // new offers
                    if (snapshot.data!['new'].isNotEmpty)
                      HomeOffers(
                        filter: 'new',
                        offers: snapshot.data!['new'],
                      ),

                    const SizedBox(
                      height: kBottomNavigationBarHeight * 1.5,
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {

              debugPrint(snapshot.error.toString());
              return CustomFailed(
                onRetry: retry,
              );
            }

            return const SizedBox.shrink();
          }),
    );
  }
}
