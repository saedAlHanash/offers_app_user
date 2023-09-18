class NotificationModel {
  final int id;
  final String body;
  final String type;
  final dynamic data;
  final String? image;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.body,
    required this.type,
    required this.data,
    this.image,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: int.parse(json['id'].toString()),
      body: json['body'].toString(),
      type: json['type'].toString(),
      data: json['data'],
      image: json['image'],
      date: DateTime.parse(json['date'].toString()),
    );
  }
}
