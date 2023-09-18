import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class CustomImagePicker {
  Future<File?> pickImageByGallery({required BuildContext context}) async {
    try {
      if (await _requestPermission(Permission.storage)) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          int fileSizeInBytes = await imageFile.length();
          double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
          if (fileSizeInMB >= 2) {
            // ignore: use_build_context_synchronously
            ProgressDialog progressDialog = ProgressDialog(context: context);
            progressDialog.show(
              msg: "جاري الرفع",
              backgroundColor: AppUI.backgroundColor,
              progressValueColor: AppUI.primaryColor,
              borderRadius: 10.0,
              progressBgColor: AppUI.iconColor1,
              msgColor: AppUI.textColor,
            );
            final compressedFile =
                await compressImage(pickedFile.path, pickedFile.name);
            progressDialog.close();
            if (compressedFile != null) {
              return compressedFile;
            } else {
              return imageFile;
            }
          } else {
            return imageFile;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<File?> compressImage(String imagePath, String imageName) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/trans$imageName';

    final result = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      targetPath,
      quality: 20,
      minWidth: 800,
      minHeight: 800,
    );

    if (result != null) {
      return File(result.path);
    }

    return null;
  }

  Future<File?> pickImage() async {
    File? imageFile;
    try {
      if (await _requestPermission(Permission.storage)) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          imageFile = File(pickedFile.path);
          return imageFile;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
