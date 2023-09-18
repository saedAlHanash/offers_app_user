import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offers_awards/screens/navigator_screen.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:offers_awards/screens/widgets/custom_network_image.dart';
import 'package:offers_awards/screens/widgets/custom_slider_indicator.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class DetailSlider extends StatefulWidget {
  final List<String> images;
  final String title;
  final int id;
  const DetailSlider(
      {super.key, required this.images, required this.title, required this.id});

  @override
  State<DetailSlider> createState() => _DetailSliderState();
}

class _DetailSliderState extends State<DetailSlider> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 1.5,
            viewportFraction: 1,
            // autoPlay: true,
            onPageChanged: (index, reason) =>
                setState(() => activeIndex = index),
          ),
          items: widget.images.map((slide) {
            return Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  child: CustomNetworkImage(
                    imageUrl: slide,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: Dimensions.padding16,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: CustomSliderIndicator(
                      activeIndex: activeIndex,
                      count: widget.images.length,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        Positioned(
          child: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                if(Navigator.canPop(context)){
                  Get.back();
                }
                else{
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppUI.iconColor2,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  await Share.share('${APIList.appLink}?id=${widget.id}',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
                icon: SvgPicture.asset(AppAssets.share),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
