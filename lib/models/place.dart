class Place {
  final int id;
  final String label;
  final String location;
  final double latitude;
  final double longitude;

  Place({
    required this.id,
    required this.label,
    required this.location,
    required this.latitude,
    required this.longitude,
  });
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: int.parse(json['id'].toString()),

      label: json['label'].toString(),
      location: json['location'].toString(),
      latitude: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : 0.0,
      longitude: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : 0.0,
    );
  }
}
