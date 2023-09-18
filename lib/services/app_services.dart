import 'dart:convert';

import 'package:offers_awards/models/soical_media.dart';
import 'package:offers_awards/models/term.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class AppServices {
  static Future<List<SocialMedia>> fetchSocialMedia() async {
    List<SocialMedia> socialMedia = [];
    final response = await Network.httpGetRequest(APIList.socialMedia, {});
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> category
          in jsonDecode(response.body)['data']) {
        socialMedia.add(SocialMedia.fromJson(category));
      }
      return socialMedia;
    }
    throw Exception('Failed to connect remote data source');
  }

  static Future<List<Term>> fetchAbout() async {
    List<Term> terms = [];
    final response = await Network.httpGetRequest(APIList.terms, {});
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> term in jsonDecode(response.body)) {
        terms.add(Term.fromJson(term));
      }
      return terms;
    }

    throw Exception('Failed to connect remote data source');
  }
}
