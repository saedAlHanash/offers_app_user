import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:offers_awards/models/category.dart';
import 'package:offers_awards/models/custom_slide.dart';
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
            if (snapshot.hasData && snapshot.requireData.isNotEmpty) {
              List<CustomSlide> slides = [];
              if (snapshot.requireData['custom_slides'].isNotEmpty) {
                slides = snapshot.requireData['custom_slides'];
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        if (snapshot.requireData['slider'].isNotEmpty)
                          MainSlider(
                            sliders: snapshot.requireData['slider'],
                          ),
                        //appbar
                        const HomeAppBar(
                          isDark:
                              true, //snapshot.requireData['slider'].isEmpty,
                        ),
                      ],
                    ),
                    //categories
                    FutureBuilder<List<Category>>(
                        future: categories,
                        builder: (context, category) {
                          if (category.hasData) {
                            return CategoriesList(
                              categories: category.requireData,
                            );
                          }
                          return const SpinKitThreeBounce(
                            color: AppUI.primaryColor,
                          );
                        }),

                    //first_banner
                    if (snapshot.requireData['first_banner'].isNotEmpty)
                      FixedBanner(
                        banners: snapshot.requireData['first_banner'],
                      ),

                    //custom offers title
                    if (slides.isNotEmpty)
                      for (final CustomSlide slide in slides)
                        if (slide.offers.isNotEmpty)
                          HomeOffers(
                            filter: slide.name,
                            offers: slide.offers,
                            customSliderID: slide.id,
                          ),
                    // new offers
                    if (snapshot.requireData['new'].isNotEmpty)
                      HomeOffers(
                        filter: 'new',
                        offers: snapshot.requireData['new'],
                      ),
                    //last banners
                    if (snapshot.requireData['last_banner'].isNotEmpty)
                      FixedBanner(
                        banners: snapshot.requireData['last_banner'],
                      ),
                    //hot offers
                    if (snapshot.requireData['hot'].isNotEmpty)
                      HomeOffers(
                        filter: 'hot',
                        offers: snapshot.requireData['hot'],
                      ),
                    //most sold
                    if (snapshot.requireData['most_sold'].isNotEmpty)
                      HomeOffers(
                        filter: 'most_sold',
                        offers: snapshot.requireData['most_sold'],
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
