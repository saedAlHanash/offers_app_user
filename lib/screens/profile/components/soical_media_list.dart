import 'package:flutter/material.dart';
import 'package:offers_awards/models/soical_media.dart';
import 'package:offers_awards/screens/profile/components/contact_button.dart';
import 'package:offers_awards/utils/dimensions.dart';

class SocialMediaList extends StatelessWidget {
  final List<SocialMedia> socialMedia;
  const SocialMediaList({Key? key, required this.socialMedia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kBottomNavigationBarHeight+Dimensions.padding8,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.padding16),
            scrollDirection: Axis.horizontal,
            itemCount: socialMedia.length,
            itemBuilder: (BuildContext context, int index) {
              return ContactButton(
                heroTag: socialMedia[index].name,
                icon: socialMedia[index].icon,
                url: socialMedia[index].url,
              );
            }),
      ),
    );
  }
}
