import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/db/recent_search.dart';
import 'package:offers_awards/models/api_response.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/empty_screen.dart';
import 'package:offers_awards/screens/search/custom_search_delegate.dart';
import 'package:offers_awards/screens/widgets/custom_failed.dart';
import 'package:offers_awards/screens/widgets/custom_load_more.dart';
import 'package:offers_awards/screens/widgets/offer/offer_item.dart';
import 'package:offers_awards/services/offers_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  const SearchScreen({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<ApiResponse<Offer>> contentList;
  int offset = 1;
  late int totalOffset;
  late int count;
  bool isLoading = false;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<bool> getContentList() async {
    offset++;

    if (offset > totalOffset) {
      setState(() {
        refreshController.loadNoData();
        refreshController.footerMode!.value = LoadStatus.noMore;
      });
      return true;
    }
    ApiResponse<Offer> result =
        await OfferServices.search(widget.query, offset);
    setState(() {
      contentList.then((value) => value.items.addAll(result.items));
    });

    return result.items.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    RecentSearch.setSearch(widget.query);
    contentList = OfferServices.search(widget.query, offset);

    contentList.then((value) {
      totalOffset = value.offsetCount;
      count = value.count;
    });
  }

  Future<void> retry() async {
    setState(() {
      isLoading = true;
    });
    contentList = OfferServices.search(widget.query, offset);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.padding16,
          horizontal: Dimensions.padding16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<ApiResponse<Offer>>(
                  future: contentList,
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
                      if (snapshot.data!.items.isEmpty) {
                        return EmptyScreen(
                          svgPath: AppAssets.eSearch,
                          title:
                              'عذراً هذا العرض غير موجود\nيرجى البحث مرة اخرى',
                          buttonText: 'ابحث عن العروض',
                          buttonFunction: () {
                            showSearch(
                                context: context,
                                delegate: CustomSearchDelegate());
                          },
                        );
                      }
                      return CustomLoadMore(
                        refreshController: refreshController,
                        getData: getContentList,
                        length: snapshot.data!.items.length,
                        total: count,
                        body: ListView.builder(
                          itemCount: snapshot.data!.items.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: Dimensions.offerHeight,
                              child: OfferItem(
                                offer: snapshot.data!.items[index],
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return CustomFailed(
                        onRetry: retry,
                      );
                    }
                    return const Center(
                      child: SpinKitChasingDots(
                        color: AppUI.primaryColor,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: Dimensions.padding8,
          left: Dimensions.padding16,
        ),
        child: FloatingActionButton(
          heroTag: "support_chat_search_list",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
