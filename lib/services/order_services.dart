import 'dart:convert';

import 'package:offers_awards/models/cart.dart';
import 'package:offers_awards/models/order.dart';
import 'package:offers_awards/models/place.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class OrderServices {
  static Future<bool> create(
      {required List<CartItem> carts,
      required String coupon,
      required Place place}) async {
    List<Map<String, dynamic>> elements = [];
    for (int i = 0; i < carts.length; i++) {
      elements.add({
        "voucher_id": carts[i].offer.id,
        "quantity": carts[i].quantity,
      });
    }
    Map<String, dynamic> sendingMap = {
      "elements": elements,
      "coupon_code": coupon.isNotEmpty ? coupon.toString() : null,
      "location": place.location,
      "latitude": place.latitude,
      "longitude": place.longitude,
    };
    final response = await Network.httpPostMapBody(
        '${APIList.order}/${APIList.create}', json.encode(sendingMap));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 422 || response.statusCode == 400) {
      var body = jsonDecode(response.body);
      CustomSnackBar.showRowSnackBarError(
        body['message'],
      );
      return false;
    } else {
      CustomSnackBar.showRowSnackBarError("حدث خطا يرجى المحاولة مرة اخرى");
      return false;
    }
  }

  static Future<Map?> checkCoupon(
      String coupon, int providerId, double price) async {
    final response = await Network.httpPostGetRequest(
        "${APIList.coupon}/${APIList.checkCoupon}", {
      'code': coupon.toString(),
      'provider_id': providerId.toString(),
      'price': price.toString(),
    });
    if (response.statusCode == 200) {
      var body=jsonDecode(response.body);
      return {
        'amount': double.parse(body['amount'].toString()),
        'price': double.parse(body['price'].toString()),
      };
    } else if (response.statusCode == 400) {
      CustomSnackBar.showRowSnackBarError("عذرا هذا الكوبون غير صالح");
      return null;
    }
    throw Exception('Failed to connect remote data source');
  }

  static Future<List<Order>> fetch() async {
    List<Order> orders = [];
    final response = await Network.httpGetRequest(APIList.order, {});
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> order
          in jsonDecode(response.body)['data']) {
        orders.add(Order.fromJson(order));
      }
      return orders;
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  static Future<Order> getById(int id) async {
    final response = await Network.httpGetRequest("${APIList.order}/$id", {});
    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }
}
