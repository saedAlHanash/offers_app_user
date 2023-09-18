class Chat {
  final int id;
  final String message;
  final bool mine;

  // final DateTime time;

  Chat(
    this.id,
    this.message,
    this.mine,
    // this.time,
  );

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      int.parse(json['id'].toString()),
      json['message'].toString(),
      json['sender_type'].toString() == "user",
      // DateTime.parse(json['time'].toString()),
    );
  }
}
