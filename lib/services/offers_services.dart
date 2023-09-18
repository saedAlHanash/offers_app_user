import 'dart:convert';

import 'package:offers_awards/models/api_response.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class OfferServices {
  static Future<bool> toggalFavorite(int id) async {
    final response = await Network.httpPutRequest(
        "${APIList.favorite}/${APIList.toggleFavorite}/$id", {});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Offer>> fetchFavorites() async {
    List<Offer> favorites = [];
    final response = await Network.httpGetRequest(
        "${APIList.favorite}/${APIList.getFavorited}", {});
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> offer
          in jsonDecode(response.body)['data']) {
        favorites.add(Offer.fromJson(offer));
      }
      return favorites;
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  static Future<Map> getById(int id) async {
    List<Offer> suggestions = [];
    final response = await Network.httpGetRequest("${APIList.voucher}/$id", {});
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> offer
          in jsonDecode(response.body)['related_vouchers']) {
        suggestions.add(Offer.fromJson(offer));
      }
      return {
        'offer': Offer.fromJson(jsonDecode(response.body)['data']),
        'suggestions': suggestions,
      };
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  static Future<ApiResponse<Offer>> getWithFilter(
      String filter, int page) async {
    List<Offer> offers = [];
    final response = await Network.httpPostGetRequest(
        "${APIList.voucher}/${APIList.getWithFilter}",
        {'sort': filter, 'page': page.toString()});
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (final Map<String, dynamic> offer in body['items']) {
        offers.add(Offer.fromJson(offer));
      }
      return ApiResponse<Offer>(
        items: offers,
        offsetCount: int.parse(body['number_of_pages'].toString()),
        count: int.parse(body['number_of_results'].toString()),
      );
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  static Future<ApiResponse<Offer>> getByProvider(int id, int page) async {
    List<Offer> offers = [];
    final response = await Network.httpGetRequest(
        "${APIList.voucher}/${APIList.getByProvider}/$id",
        {'page': page.toString()});
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (final Map<String, dynamic> offer in body['items']) {
        offers.add(Offer.fromJson(offer));
      }
      return ApiResponse<Offer>(
        items: offers,
        offsetCount: int.parse(body['number_of_pages'].toString()),
        count: int.parse(body['number_of_results'].toString()),
      );
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  static Future<ApiResponse<Offer>> search(String query, int page) async {
    List<Offer> offers = [];
    final response = await Network.httpPostGetRequest(
        "${APIList.voucher}/${APIList.search}",
        {'page': page.toString(), 'query': query.toString()});
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (final Map<String, dynamic> offer in body['items']) {
        offers.add(Offer.fromJson(offer));
      }
      return ApiResponse<Offer>(
        items: offers,
        offsetCount: int.parse(body['number_of_pages'].toString()),
        count: int.parse(body['number_of_results'].toString()),
      );
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }
}
