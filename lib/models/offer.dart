import 'package:offers_awards/models/provider.dart';

class Offer {
  final int id;
  final String name;
  final String description;
  final String cover;
  final List<String> images;
  final double price;
  final double offer;
  final double percentage;
  final double stars;
  final bool isGeneral;
  final String type;
  final DateTime expiryDate;
  bool isFavorite;
  final Provider provider;

  Offer({
    required this.id,
    required this.name,
    required this.description,
    required this.cover,
    required this.images,
    required this.price,
    required this.offer,
    required this.percentage,
    required this.stars,
    required this.isGeneral,
    required this.type,
    required this.expiryDate,
    required this.isFavorite,
    required this.provider,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      description: json['description'].toString(),
      cover: json['images'].isNotEmpty
          ? json['images'][0]['image_url'].toString()
          : "",
      images: json['images'].isNotEmpty
          ? List<String>.from(json['images'].map((img) => img['image_url']))
          : [""],
      price: double.parse(json['price_before'].toString()),
      offer: double.parse(json['price_after'].toString()),
      percentage: double.parse(json['label'].toString()),
      stars: json.containsKey('stars')
          ? double.parse(json['stars'].toString())
          : 4.0,
      isGeneral: json['is_general'] ?? false,
      type: json['type'].toString(),
      expiryDate: DateTime.parse(json['expiry_date'].toString()),
      isFavorite: json['is_favorated'] ?? false,
      provider: Provider.fromJson(json['provider']),
    );
  }

  factory Offer.fromJsonCont(Map<String, dynamic> json) {
    return Offer(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      description: json['description'].toString(),
      cover: json['images'].first.toString(),
      images: List<String>.from(json['images'].map((img) => img)),
      price: double.parse(json['price_before'].toString()),
      offer: double.parse(json['price_after'].toString()),
      percentage: double.parse(json['label'].toString()),
      stars: json.containsKey('stars')
          ? double.parse(json['stars'].toString())
          : 4.0,
      isGeneral: json['is_general'] ?? false,
      type: json['type'].toString(),
      expiryDate: DateTime.parse(json['expiry_date'].toString()),
      isFavorite: json['is_favorated'] ?? false,
      provider: Provider.fromJson(json['provider']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "cover": cover,
      "images": List<dynamic>.from(images.map((image) => image)),
      "price_before": price,
      "price_after": offer,
      "label": percentage,
      "rating": stars,
      "delivery": isGeneral,
      "branch": type,
      "expiry_date": expiryDate.toIso8601String(),
      "isFavorite": isFavorite,
      "provider": provider.toJson(),
    };
  }

  Offer copyWith({
    int? id,
    String? name,
    String? description,
    String? cover,
    List<String>? images,
    double? price,
    double? offer,
    double? percentage,
    double? stars,
    bool? isGeneral,
    String? type,
    DateTime? expiryDate,
    bool? isFavorite,
    Provider? provider,
  }) {
    return Offer(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cover: cover ?? this.cover,
      images: images ?? this.images,
      price: price ?? this.price,
      offer: offer ?? this.offer,
      percentage: percentage ?? this.percentage,
      stars: stars ?? this.stars,
      isGeneral: isGeneral ?? this.isGeneral,
      type: type ?? this.type,
      expiryDate: expiryDate ?? this.expiryDate,
      isFavorite: isFavorite ?? this.isFavorite,
      provider: provider ?? this.provider,
    );
  }
}
