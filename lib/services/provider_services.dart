import 'dart:convert';

import 'package:offers_awards/models/provider.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class ProviderServices {
  static Future<List<Provider>> fetch(double latitude, double longitude) async {
    List<Provider> providers = [];
    final response = await Network.httpPostGetRequest(
        "${APIList.provider}/${APIList.search}",
        {'latitude': latitude.toString(), 'longitude': longitude.toString()});

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (final Map<String, dynamic> provider in body['data']) {
        providers.add(Provider.fromJson(provider));
      }
      return providers;
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }
}
