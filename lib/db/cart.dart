import 'dart:convert';

import 'package:offers_awards/models/cart.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart {
  final SharedPreferences sharedPreferences;

  Cart({required this.sharedPreferences});

  List<String> cart = [];

  void addToCartList(List<CartItem> cartList) {
    cart = cartList.map((e) => jsonEncode(e.toJson())).toList();
    sharedPreferences.setStringList(AppConstant.cartList, cart);
  }

  List<CartItem> getCartList() {
    List<String> carts = [];
    if (sharedPreferences.containsKey(AppConstant.cartList)) {
      carts = sharedPreferences.getStringList(AppConstant.cartList)!;
    }
    List<CartItem> cartList = [];
    for (var element in carts) {
      cartList.add(CartItem.fromJson(jsonDecode(element)));
    }

    return cartList;
  }

  void removeCart() {
    cart = [];
    sharedPreferences.setStringList(AppConstant.cartList, cart);
  }
}
