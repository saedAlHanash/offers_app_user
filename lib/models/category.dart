import 'package:offers_awards/models/home_slider.dart';

class Category {
  final int id;
  final String title;
  final String icon;
  final String cover;

  Category(this.id, this.title, this.icon, this.cover);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      int.parse(json['id'].toString()),
      json['name'].toString(),
      json['icon'].toString(),
      json['image'].toString(),
    );
  }
}

class CategoryDetails {
  final int id;
  final List<HomeSlider> sliders;
  final List<Category> subCategories;
  final List<dynamic> items;
  final int totalOffsets;
  final int count;

  CategoryDetails(this.id,this.sliders, this.subCategories, this.items, this.totalOffsets,
      this.count);

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    return CategoryDetails(
      int.parse(json['category']['id'].toString()),
      List<HomeSlider>.from(
        json['slider'].map((item) => HomeSlider.fromJson(item)),
      ),
      List<Category>.from(
        json['category']['sections'].map((item) => Category.fromJson(item)),
      ),
      List<dynamic>.from(
        json['items'].map((item) => item),
      ),
      int.parse(json['number_of_pages'].toString()),
      int.parse(json['number_of_results'].toString()),
    );
  }
}
