import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers_awards/models/provider.dart';
import 'package:offers_awards/screens/provider/provider_map_screen.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/dimensions.dart';

class ProviderAddress extends StatelessWidget {
  final Provider provider;
  const ProviderAddress({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ProviderMapScreen(provider: provider));
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          // margin: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.padding24,
            vertical: Dimensions.padding4,
          ),
          // padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: constraints.maxWidth -
                        (Dimensions.icon21 * 2 + Dimensions.padding24 * 2),
                    child: Text(
                      '${provider.government} ${provider.address}',
                      style: const TextStyle(
                        fontSize: Dimensions.font14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.padding8),
                    child: SvgPicture.asset(
                      AppAssets.activeLocation,
                      height: Dimensions.icon21,
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        );
      }),
    );
  }
}
