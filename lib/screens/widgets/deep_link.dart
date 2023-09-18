import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/navigator_screen.dart';
import 'package:offers_awards/screens/offer_details/offer_details_screen.dart';
import 'package:offers_awards/screens/onboarding/slplash_screen.dart';
import 'package:uni_links/uni_links.dart';

class DeepLink {
  static Uri? _initialUri;
  static StreamSubscription? _sub;
  static bool _initialUriIsHandled = false;

  static void start([bool isSplash = false]) {
    _handleIncomingLinks();
    _handleInitialUri(isSplash);
  }

  static void end() {
    _sub?.cancel();
  }

  static void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        debugPrint('got uri: $uri');
        _handleDeepLink();
      }, onError: (Object err) {
        debugPrint('got err: $err');
        if (err is FormatException) {
        } else {}
      });
    }
  }

  static Future<void> _handleInitialUri([bool isSplash = false]) async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        _initialUri = uri;
        if (uri == null) {
          debugPrint('no initial uri');
          if(isSplash){
            Get.off(()=>
            const MyHomePage(),
            );
          }
          else{
            Get.off(()=>
            const SplashScreen(),
            );
          }
        } else {
          debugPrint('got initial uri: $uri');
          _handleDeepLink();
        }
      } on PlatformException {
        debugPrint('failed to get initial uri');
      } on FormatException {
        debugPrint('malformed initial uri');
      }
    }
  }

  static _handleDeepLink() async {
    final initialUriQueryParams =
    _initialUri?.queryParametersAll.entries.toList();
    int id = 0;
    if (initialUriQueryParams != null) {
      for (final item in initialUriQueryParams) {
        final k = item.key;
        final v = item.value;
        if (k == "id") {
          id = int.parse(v[0]);
        }
      }
    }
    if (id > 0) {
      Get.offAll(
        OfferDetailsScreen(
          id: id,
        ),
      );
    } else {
      Get.offAll(
        const MyHomePage(),
      );
    }
  }
}
