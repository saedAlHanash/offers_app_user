import 'package:flutter/material.dart';
import 'package:offers_awards/db/session.dart';
import 'package:offers_awards/models/chat.dart';
import 'package:offers_awards/screens/chat/components/message_bubble.dart';
import 'package:offers_awards/utils/dimensions.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<Chat> messages;

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  late Future<String> image;

  @override
  void initState() {
    image = SessionManager.getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: true,
        itemCount: widget.messages.length,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: FutureBuilder<String>(
                future: image,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MessageBubble(
                      message:
                          widget.messages[widget.messages.length - 1 - index],
                      image: snapshot.requireData,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
          );
        });
  }
}
