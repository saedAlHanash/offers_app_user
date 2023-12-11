import 'package:offers_awards/models/offer.dart';

class CustomSlide {
  final int id;
  final String name;
  final List<Offer> offers;

  CustomSlide({
    required this.id,
    required this.name,
    required this.offers,
  });

  factory CustomSlide.fromJson(Map<String, dynamic> json) {
    return CustomSlide(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      offers: List<Offer>.from(
        json['vouchers'].map((item) => Offer.fromJson(item)),
      ),
    );
  }
}
