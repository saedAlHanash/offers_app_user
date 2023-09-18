class HomeSlider{
  final int offerId;
  final String title;
  final String description;
  final String cover;
  final int adID;
  final String adType;  final String name;


  HomeSlider(this.offerId, this.title, this.description, this.cover, this.adID, this.adType, this.name);

  factory HomeSlider.fromJson(Map<String, dynamic> json) {
    return HomeSlider(
      int.parse(json['id'].toString()),
      json['lable'].toString(),
      json['description'].toString(),
      json['image_url'].toString(),
      int.parse(json['advertisable_id'].toString()),
      json['advertisable_type'].toString(),
      json['name'].toString(),
    );
  }
}