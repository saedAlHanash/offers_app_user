class CustomPosition {
  final double latitude;
  final double longitude;

  CustomPosition(this.latitude, this.longitude);

  factory CustomPosition.fromJson(Map<String, dynamic> json) {
    return CustomPosition(
      double.parse(json['latitude'].toString()),
      double.parse(json['longitude'].toString()),
    );
  }
}