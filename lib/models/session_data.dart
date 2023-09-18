class SessionData {
  final String name;
  final String phone;
  final String email;
  final String country;
  final String area;
  final String address;
  final double latitude;
  final double longitude;
  final String? image;
  final DateTime? birthday;
  final String token;

  SessionData(
    this.name,
    this.phone,
    this.email,
    this.country,
    this.area,
    this.address,
    this.image,
    this.birthday,
    this.token, this.latitude, this.longitude,
  );
}
