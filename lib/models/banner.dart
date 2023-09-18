class CustomBanner{
  final int id;
  final String cover;
  final int adID;
  final String adType;
  final String name;

  CustomBanner(this.id, this.cover, this.adID, this.adType,this.name);
  factory CustomBanner.fromJson(Map<String, dynamic> json) {
    return CustomBanner(
      int.parse(json['id'].toString()),
      json['image_url'].toString(),
      int.parse(json['advertisable_id'].toString()),
      json['advertisable_type'].toString(),
      json['name'].toString(),
    );
  }
}