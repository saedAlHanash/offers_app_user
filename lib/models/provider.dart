class Provider {
  final int id;
  final String name;
  final String logo;
  final String government;
  final String address;
  final int offerNum;
  final double latitude;
  final double longitude;

  Provider({
    required this.id,
    required this.name,
    required this.logo,
    required this.government,
    required this.address,
    required this.offerNum,
    required this.latitude,
    required this.longitude,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: int.parse(json['id'].toString()),
      name: json['company_name'].toString(),
      logo: json['logo'].toString(),
      government: json['government'].toString(),
      address: json['address'].toString(),
      offerNum: json.containsKey('vouchers_count')
          ? int.parse(json['vouchers_count'].toString())
          : 0,
      latitude: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : 0.0,
      longitude: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "logo": logo,
      "government": government,
      "address": address,
      "offerNum": offerNum,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
