import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/category_controller.dart';
import 'package:offers_awards/models/category.dart';
import 'package:offers_awards/screens/category/components/category_slider.dart';
import 'package:offers_awards/screens/category/components/offers_merchants_tabs.dart';
import 'package:offers_awards/screens/category/components/sort_dialog.dart';
import 'package:offers_awards/screens/category/components/sub_categories_list.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/custom_search_container.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CategoryScreen extends StatefulWidget {
  final int id;
  const CategoryScreen({super.key, required this.id});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin<CategoryScreen> {
  @override
  bool get wantKeepAlive => true;
  late String sort;
  late CategoryController _categoryController;
  late Future<CategoryDetails> _categoryDetailsFuture;
  bool isRetry = false;

  @override
  void initState() {
    _categoryController = Get.put(CategoryController(categoryId: widget.id));
    _categoryDetailsFuture = _categoryController.fetchCategory();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CategoryController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          kBottomNavigationBarHeight,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.padding8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                const Expanded(
                  child: CustomSearchContainer(
                    isWhite: false,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    SortDialog.show(
                      context: context,
                    );
                  },
                  icon: SvgPicture.asset("assets/svg/buttons/sort.svg"),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<CategoryDetails>(
          future: _categoryDetailsFuture,
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.padding8),
                      child: CategorySlider(
                        sliders: snapshot.data!.sliders,
                      ),
                    ),
                    if(snapshot.data!.subCategories.isNotEmpty)
                    SubCategoriesList(
                      subCategoryList: snapshot.data!.subCategories,
                    ),
                    //tabs
                    const OffersProvidersTabs(),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return CustomFailed(
                onRetry: () {
                  setState(() {
                    isRetry = true;
                  });
                  _categoryController.fetchItems().then((value) {
                    setState(() {
                      isRetry = false;
                    });
                  });
                },
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
          heroTag: "support_chat_category",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
