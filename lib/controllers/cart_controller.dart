import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/db/cart.dart';
import 'package:offers_awards/models/cart.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';

class CartController extends GetxController {
  final Cart cartRepo;

  CartController({required this.cartRepo});

  Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  List<CartItem> storageItems = [];

  int? _amount;

  int? get amount => _amount;

  String? _currency;

  String? get currency => _currency;

  double? _couponPrice;

  double? get couponPrice => _couponPrice;

  bool addItem(Offer offer, int quantity) {
    // Check if the cart is already filled
    if (_items.isNotEmpty) {
      int providerId = _items.values.first.offer.provider.id;

      if (offer.provider.id != providerId) {
        CustomSnackBar.showRowSnackBarError(
            "لا يمكنك اضافة للسلة من تاجرين مختلفين");
        return false;
      }
    }
    var totalQuantity = 0;
    if (_items.containsKey(offer.id)) {
      _items.update(offer.id, (value) {
        totalQuantity = value.quantity + quantity;
        return CartItem(
          value.id,
          totalQuantity,
          (totalQuantity * offer.offer).toDouble(),
          offer,
        );
      });
      if (totalQuantity <= 0) {
        _items.remove(offer.id);
      }
    } else {
      if (quantity > 0) {
        _items.putIfAbsent(
          offer.id,
          () => CartItem(
            offer.id,
            quantity,
            (quantity * offer.offer).toDouble(),
            offer,
          ),
        );
      } else {
        //Todo Show some thing
      }
    }
    couponPriceF(null);
    cartRepo.addToCartList(getItems);
    _currency = offer.currency;
    update();
    return true;
  }

  void removeItem(Offer offer) {
    _items.remove(offer.id);
    couponPriceF(null);

    cartRepo.addToCartList(getItems);
    update();
  }

  List<CartItem> get getItems {
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  bool existInCart(Offer offer) {
    if (_items.containsKey(offer.id)) {
      return true;
    } else {
      return false;
    }
  }

  set setCart(List<CartItem> items) {
    storageItems = items;
    for (int i = 0; i < storageItems.length; i++) {
      _items.putIfAbsent(storageItems[i].offer.id, () => storageItems[i]);
    }
  }

  List<CartItem> getCartData() {
    setCart = cartRepo.getCartList();
    return storageItems;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += (value.quantity * value.offer.offer);
    });
    return total;
  }

  void clear() {
    _items = {};
    _couponPrice = null;
    _amount = null;
    cartRepo.removeCart();
    update();
  }

  CartItem? getItem(int id) {
    if (_items.containsKey(id)) {
      return _items[id];
    }
    return null;
  }

  void couponPriceF(
    int? value,
  ) {
    _amount = value;
    if (value != null) {
      _couponPrice = totalAmount - value;
    } else {
      _couponPrice = null;
    }

    debugPrint("coupon: $couponPrice");
    update();
  }

  void updateFavoriteStatus(Offer offer, bool isFavorite) {
    if (_items.containsKey(offer.id)) {
      _items.update(offer.id, (value) {
        return CartItem(
          value.id,
          value.quantity,
          value.amount,
          offer.copyWith(isFavorite: isFavorite),
        );
      });
      cartRepo.addToCartList(getItems);
      update();
    }
  }
}
