import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:offers_awards/models/offer.dart';
import 'package:offers_awards/screens/chat/chat_screen.dart';
import 'package:offers_awards/screens/qr_code/components/qr_downlad.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_old_price.dart';
import 'package:offers_awards/screens/widgets/custom_scaffold.dart';
import 'package:offers_awards/screens/widgets/custom_title_text.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/constant.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrCodeScreen extends StatefulWidget {
  final Offer offer;

  const QrCodeScreen({Key? key, required this.offer}) : super(key: key);

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: CustomScaffold(
        appBar: CustomAppBar.appBar(title: 'يرجى المسح من قبل التاجر'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: QrImageView(
                data: widget.offer.id.toString(),
                version: QrVersions.auto,
                size: MediaQuery.of(context).size.height * 0.35,
              ),
            ),
            SizedBox(
              height: Dimensions.padding24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTitleText(
                  title: widget.offer.name,
                  fontSize: Dimensions.font18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${NumberFormat('#,###').format(widget.offer.offer)} ${AppConstant.currency[widget.offer.currency] ?? widget.offer.currency}',
                      style: const TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: Dimensions.padding4,
                    ),
                    CustomOldPrice(price: widget.offer.price,
                      currency: widget.offer.currency,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.padding24,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const CustomTitleText(
            //       title: "كود الخصم",
            //     ),
            //     GestureDetector(
            //       onLongPress: () {
            //         Clipboard.setData(
            //             const ClipboardData(text: 'Text to copy'));
            //         CustomSnackBar.showRowSnackBarSuccess(
            //             "تمت النسخ الى الحافظة");
            //       },
            //       child: const CustomTitleText(
            //         title: "Acl251cadf5",
            //       ),
            //     ),
            //   ],
            // ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.padding24,
              ),
              child: const CustomTitleText(
                title: "اجمالي المبلغ المطلوب",
                fontSize: Dimensions.font18,
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "اجمالي المبلغ المطلوب",
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                  ),
                ),
                Text(
                  '${NumberFormat('#,###').format(widget.offer.offer)} ${AppConstant.currency[widget.offer.currency] ?? widget.offer.currency}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16,
                  ),
                ),
              ],
            ),
            QrDownload(
              screenshotController: screenshotController,
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            bottom: Dimensions.padding8,
            left: Dimensions.padding16,
          ),
          child: FloatingActionButton(
            heroTag: "support_chat_qr",
            onPressed: () {
              Get.to(() => const ChatScreen());
            },
            child: SvgPicture.asset(AppAssets.supportChat),
          ),
        ),
      ),
    );
  }
}
