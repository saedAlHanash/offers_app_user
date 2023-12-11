class CustomBanner{
  final int id;
  final String cover;
  final int? adID;
  final String adType;
  final String name;

  CustomBanner(this.id, this.cover, this.adID, this.adType,this.name);
  factory CustomBanner.fromJson(Map<String, dynamic> json) {
    return CustomBanner(
      int.parse(json['id'].toString()),
      json['image_url'].toString(),
      json['advertisable_id']??0,
      json['advertisable_type'].toString(),
      json['name'].toString(),
    );
  }
}