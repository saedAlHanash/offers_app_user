import 'dart:convert';

import 'package:offers_awards/models/banner.dart';
import 'package:offers_awards/models/home_slider.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class HomeServices {
  static Future<Map<String, List<dynamic>>> fetch() async {
    List<HomeSlider> sliders = [];
    List<CustomBanner> firstBanner = [];
    List<CustomBanner> lastBanner = [];
    List<Offer> mostSoldOffers = [];
    List<Offer> newOffers = [];
    List<Offer> hotOffers = [];
    final response = await Network.httpGetRequest(APIList.home, {});
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> slider in body['slider']) {
        sliders.add(HomeSlider.fromJson(slider));
      }
      for (final Map<String, dynamic> banner in body['first_banner']) {
        firstBanner.add(CustomBanner.fromJson(banner));
      }
      for (final Map<String, dynamic> banner in body['last_banner']) {
        lastBanner.add(CustomBanner.fromJson(banner));
      }

      for (final Map<String, dynamic> offer in body['most_sold']) {
        mostSoldOffers.add(Offer.fromJson(offer));
      }
      for (final Map<String, dynamic> offer in body['new']) {
        newOffers.add(Offer.fromJson(offer));
      }
      for (final Map<String, dynamic> offer in body['hot']) {
        hotOffers.add(Offer.fromJson(offer));
      }
      return {
        "slider": sliders,
        "first_banner": firstBanner,
        "last_banner": lastBanner,
        "most_sold": mostSoldOffers,
        "new": newOffers,
        "hot": hotOffers,
      };
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  static Future<CustomBanner> popup() async {
    final response = await Network.httpGetRequest(APIList.popup, {});
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return CustomBanner.fromJson(body['data']);
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }
}
