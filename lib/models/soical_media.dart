class SocialMedia {
  final int id;
  final String name;
  final String icon;
  final String url;

  SocialMedia(
      {required this.id,
      required this.name,
      required this.icon,
      required this.url});

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      icon: json['icon'].toString(),
      url: json['url'].toString(),
    );
  }
}
