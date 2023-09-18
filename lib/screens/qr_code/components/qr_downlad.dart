import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/screens/widgets/custom_text_icon_button.dart';
import 'package:offers_awards/utils/dimensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class QrDownload extends StatefulWidget {
  final ScreenshotController screenshotController;

  const QrDownload({super.key, required this.screenshotController});

  @override
  State<QrDownload> createState() => _QrDownloadState();
}

class _QrDownloadState extends State<QrDownload> {
  bool _isLoading = false;

  // saveNetworkImage(String url) async {
  //   try {
  //     var httpClient = http.Client();
  //     var request = http.Request('GET', Uri.parse(url));
  //     var response = await httpClient.send(request);

  //     final totalBytes = response.contentLength ?? 0;
  //     int bytesReceived = 0;
  //     final chunks = <List<int>>[];

  //     response.stream.listen((List<int> chunk) {
  //       bytesReceived += chunk.length;
  //       final progress = ((bytesReceived / totalBytes) * 100).toInt();
  // CustomSnackBar.showRowSnackBarSuccess( 'جاري التحميل... $progress%');
  //       chunks.add(chunk);
  //     }, onDone: () async {
  //       final bytes = chunks.expand((chunk) => chunk).toList();
  //       final result = await ImageGallerySaver.saveImage(
  //         Uint8List.fromList(bytes),
  //         quality: 60,
  //         name: 'qrCode',
  //       );
  //       if (result['isSuccess']) {
  //         CustomSnackBar.showRowSnackBarSuccess('تم حفظ الصورة بنجاح');
  //       } else {
  //        CustomSnackBar.showRowSnackBarError('حدث خطأ أثناء التحميل');
  //       }
  //       return;
  //     });
  //   } catch (e) {
  //    CustomSnackBar.showRowSnackBarError('حدث خطأ أثناء التحميل');
  //
  //   }
  // }

  saveImage(Uint8List image) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(
        image,
        name: 'qrCode',
      );
      if (result['isSuccess']) {
        CustomSnackBar.showRowSnackBarSuccess('تم حفظ الصورة بنجاح');
      } else {
        CustomSnackBar.showRowSnackBarError('فشل حفظ الصورة');
      }
    } else {
      CustomSnackBar.showRowSnackBarError('تم رفض الإذن');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.padding24,
      ),
      child: CustomTextIconButton(
        onTap: () async {
          // await saveNetworkImage(
          //     "https://upload.wikimedia.org/wikipedia/commons/3/31/MM_QRcode.png");
          if (_isLoading) {
            CustomSnackBar.showRowSnackBarError("الرجاء الانتظار");
          } else {
            setState(() {
              _isLoading = true;
            });
            final image = await widget.screenshotController.capture();
            if (image != null) {
              await saveImage(image);
            }
            setState(() {
              _isLoading = false;
            });
          }
        },
        text: "احفظ الصورة",
        icon: Icons.cloud_download,
      ),
    );
  }
}
