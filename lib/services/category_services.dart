import 'dart:convert';

import 'package:offers_awards/models/category.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class CategoryServices {
  static Future<List<Category>> fetch() async {
    List<Category> catList = [];
    final response = await Network.httpGetRequest(APIList.category, {});
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> category
          in jsonDecode(response.body)['data']) {
        catList.add(Category.fromJson(category));
      }
      return catList;
    }
    throw Exception('Failed to connect remote data source');
  }

  static Future<CategoryDetails> fetchById(int id) async {
    final response = await Network.httpGetRequest(
        "${APIList.category}/$id", {"query": "vouchers "});

    if (response.statusCode == 200) {
      return CategoryDetails.fromJson(jsonDecode(response.body)['data']);
    }
    throw Exception('Failed to connect remote data source');
  }

  static Future<CategoryDetails> fetchItems(
      {required int id,
      required int page,
      required String query,
      required int sectionId,
      String? sort}) async {
    final response = await Network.httpGetRequest("${APIList.category}/$id", {
      "query": query,
      "section_id": sectionId.toString(),
      "page": page.toString(),
      if (sort != null) "sort": sort,
    });

    if (response.statusCode == 200) {
      return CategoryDetails.fromJson(jsonDecode(response.body)['data']);
    }
    throw Exception('Failed to connect remote data source');
  }
}
