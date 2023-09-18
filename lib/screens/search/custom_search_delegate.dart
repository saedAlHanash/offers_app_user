import 'package:flutter/material.dart';
import 'package:offers_awards/screens/search/search_screen.dart';
import 'package:offers_awards/screens/search/search_suggestion_list.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => "بحث";

  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   final ThemeData theme = Theme.of(context);
  //   theme.appBarTheme.titleTextStyle?.copyWith(fontSize: Dimensions.font16);
  //   return theme;
  // }
  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        fontSize: Dimensions.font16,
      );

  @override
  InputDecorationTheme? get searchFieldDecorationTheme =>
      const InputDecorationTheme(
        border: InputBorder.none,
      );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      scaffoldBackgroundColor: AppUI.secondaryColor,
      appBarTheme: theme.appBarTheme.copyWith(
        elevation: 0,
        color: AppUI.secondaryColor,
        titleTextStyle: const TextStyle(
          color: AppUI.hintTextColor,
          fontSize: Dimensions.font16,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppUI.secondaryColor,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintStyle: TextStyle(
          color: AppUI.hintTextColor,
          fontSize: Dimensions.font16,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchScreen( query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return  SearchSuggestionsList(
      getFunction: (suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

// @override
// Widget buildSuggestions(BuildContext context) {
//   List<String> suggestions = query.isEmpty
//       // ? RecentSearch.getSearches()?.reversed.toList() ?? []
//       // :
//   [];
//   return Directionality(
//     textDirection: TextDirection.rtl,
//     child: BackgroundImage(
//       body: suggestions.isNotEmpty
//           ? ListView.builder(
//               itemCount: suggestions.length,
//               itemBuilder: (context, index) {
//                 final suggestion = suggestions[index];
//                 return ListTile(
//                   leading: const Icon(Icons.search),
//                   title: Text(suggestions[index],strutStyle: const StrutStyle(
//                     forceStrutHeight: true,
//                   ),),
//                   onTap: () {
//                     query = suggestion;
//                     showResults(context);
//                   },
//                 );
//               },
//             )
//           : const ListTile(
//               title: Text(
//                 'لا يوجد بحث مسبق',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//     ),
//   );
// }
}
