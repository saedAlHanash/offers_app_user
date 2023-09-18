import 'package:offers_awards/models/offer.dart';

class CartItem {
  final int id;
  final int quantity;
  final double amount;
  final Offer offer;

  CartItem(this.id, this.quantity, this.amount, this.offer);

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      int.parse(json['id'].toString()),
      int.parse(json['quantity'].toString()),
      double.parse(json['amount'].toString()),
      Offer.fromJsonCont(json['offer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quantity": quantity,
      "amount": amount,
      "offer": offer.toJson(),
    };
  }

}