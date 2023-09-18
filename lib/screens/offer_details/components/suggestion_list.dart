import 'package:flutter/material.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/widgets/offer/offer_item.dart';
import 'package:offers_awards/utils/dimensions.dart';

class SuggestionList extends StatelessWidget {
  final List<Offer> offers;
  const SuggestionList({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.offerHeight,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (BuildContext context, int index) {
          return OfferItem(
            offer: offers[index],
            displayType: true,
            displayRate: false,
          );
        },
      ),
    );
  }
}
