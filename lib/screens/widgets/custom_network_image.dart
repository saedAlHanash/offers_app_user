import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final bool logo1;

  const CustomNetworkImage({
    Key? key,
    required this.imageUrl,
    this.height,
    this.width,
    this.logo1 = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      height: height,
      width: width,
      placeholder: (context, url) => Shimmer.fromColors(
        highlightColor: Colors.grey,
        baseColor: AppUI.greyCardColor,
        child: Container(
          height: height,
          width: width,
          color: Colors.grey,
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: height,
        width: width,
        child: Image.asset(
          logo1 ? AppAssets.logo1 : AppAssets.logo2,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
