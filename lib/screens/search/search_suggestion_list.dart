import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/db/recent_search.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class SearchSuggestionsList extends StatefulWidget {
  final Function(String) getFunction;

  const SearchSuggestionsList({
    super.key,
    required this.getFunction,
  });

  @override
  State<SearchSuggestionsList> createState() => _SearchSuggestionsListState();
}

class _SearchSuggestionsListState extends State<SearchSuggestionsList> {
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    suggestions = RecentSearch.getSearches()?.reversed.toList() ?? [];
  }

  void removeSuggestionItem(int index) async {
    bool result = await RecentSearch.deleteSearchItem(index);
    if (result) {
      setState(() {
        suggestions.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.padding24,
            vertical: Dimensions.padding16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: Dimensions.padding16,
                ),
                child: const Text(
                  "سجل البحث",
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    color: AppUI.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (suggestions.isEmpty)
                const Text(
                  "لا يوجد بحث مسبق",
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: suggestions.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        widget.getFunction(suggestions[index]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            suggestions[index],
                            style: const TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            child: SvgPicture.asset(
                              AppAssets.close,
                            ),
                            onTap: () {
                              removeSuggestionItem(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: Dimensions.padding8,
          left: Dimensions.padding16,
        ),
        child: FloatingActionButton(
          heroTag: "support_chat_search_suggestion",
          onPressed: () {
            Get.to(() => const ChatScreen());
          },
          child: SvgPicture.asset(AppAssets.supportChat),
        ),
      ),
    );
  }
}
