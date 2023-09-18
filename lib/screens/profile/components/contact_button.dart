import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactButton extends StatelessWidget {
  final String heroTag;
  final String icon;
  final String url;

  const ContactButton(
      {Key? key, required this.heroTag, required this.icon, required this.url})
      : super(key: key);

  void openSocialMedia() async {
    if (!await launchUrlString(url, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $heroTag url $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.padding8),
      child: FloatingActionButton(
        heroTag: heroTag,
        shape: RoundedRectangleBorder(
          borderRadius: Dimensions.borderRadius15,
        ),
        onPressed: () {
          openSocialMedia();
        },
        backgroundColor: AppUI.buttonColor2,
        child: SvgPicture.network(
          icon,
          height: Dimensions.icon26,
          width: Dimensions.icon26,
          fit: BoxFit.scaleDown,
        ),
        // SvgPicture.asset(
        //   icon,
        // ),
      ),
    );
  }
}
