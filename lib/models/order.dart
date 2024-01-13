import 'package:offers_awards/models/provider.dart';

class Order {
  final int id;
  final DateTime date;
  final int orderNumber;
  final double total;
  final double totalBefore;
  final String currency;
  final String status;
  final String location;
  final String clientName;
  final String? cancelNote;
  final String? couponCode;
  final Provider provider;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.orderNumber,
    required this.total,
    required this.totalBefore,
    required this.currency,
    required this.status,
    required this.location,
    required this.clientName,
    this.cancelNote,
    this.couponCode,
    required this.date,
    required this.provider,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: int.parse(json['id'].toString()),
      orderNumber: int.parse(json['order_number'].toString()),
      date: DateTime.parse(json['date'].toString()),
      total: double.parse(json['total'].toString()),
      totalBefore: double.parse(json['total_before'].toString()),
      currency: json['provider']['currency'].toString(),
      status: json['status'].toString(),
      location: json['location'] ?? '',
      clientName: json['client_name'].toString(),
      cancelNote: json['cancelation_note'],
      couponCode: json['coupon_code'],
      provider: Provider.fromJson(json['provider']),
      orderItems: json['invoices']
          .map<OrderItem>((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}


class OrderItem {
  final int id;
  final String name;
  final double total;
  final String type;
  final double price;
  final double? offer;
  final int quantity;
  bool isFavorite;
  final bool isAvailable;
  final String cover;

  OrderItem({
    required this.id,
    required this.name,
    required this.total,
    required this.quantity,
    required this.cover,
    required this.isAvailable,
    required this.isFavorite,
    required this.type,
    required this.price,
     this.offer,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      cover: json['images'].first['image_url'].toString(),
      quantity: int.parse(json['quantity'].toString()),
      price: double.parse(json['price_before'].toString()),
      offer: json['price_after'] != null
          ? double.parse(json['price_after'].toString())
          : null,
      total: double.parse(json['total'].toString()),
      isAvailable: json['is_available'] ?? false,
      type: json['type'].toString(),
      isFavorite: json['is_favorated'] ?? false,
    );
  }
}
