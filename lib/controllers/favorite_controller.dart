import 'package:get/get.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/services/offers_services.dart';

class FavoriteController extends GetxController {
  RxList<Offer> favoriteOffers = <Offer>[].obs;


  Future<List<Offer>> fetchFavoriteOffers() async {
    Future<List<Offer>> result = OfferServices.fetchFavorites();

    favoriteOffers.value = await result;
    return result;
  }

  Future<void> retry ()async{
    favoriteOffers.value = await OfferServices.fetchFavorites();
  }

  void removeFromFavorites(Offer offer) {
    favoriteOffers.removeWhere((item) => item.id == offer.id);
  }
}
