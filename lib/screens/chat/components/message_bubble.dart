import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:offers_awards/models/chat.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class MessageBubble extends StatelessWidget {
  final Chat message;
  final String image;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.mine ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (message.mine)
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
            child: ClipRRect(
              borderRadius: Dimensions.borderRadius50,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppUI.greyCardColor,
                ),
                width: Dimensions.logoSize,
                height: Dimensions.logoSize,
                child: image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Icon(
                          Icons.person_outline,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person_outline,
                        ),
                      )
                    : const Icon(
                        Icons.person_outline,
                      ),
              ),
            ),
          ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: AppUI.greyCardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius20),
              topRight: Radius.circular(Dimensions.radius20),
              bottomLeft: message.mine
                  ? Radius.circular(Dimensions.radius20)
                  : const Radius.circular(0),
              bottomRight: !message.mine
                  ? Radius.circular(Dimensions.radius20)
                  : const Radius.circular(0),
            ),
            // border: Border.all(color: AppUI.mainColor),
          ),
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.padding8, horizontal: Dimensions.padding16),
          margin: EdgeInsets.symmetric(
              vertical: Dimensions.padding16, horizontal: Dimensions.padding8),
          child: Text(
            message.message,
            textAlign: message.mine ? TextAlign.start : TextAlign.end,
          ),
        ),
        if (!message.mine)
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
            child: const CircleAvatar(
              backgroundImage: AssetImage(AppAssets.logo1,),
            ),
          ),
      ],
    );
  }
}