import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/utils/dimensions.dart';

class CustomizeLocation {
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<BitmapDescriptor> addCustomIcon(String iconSrc) async {
    final Uint8List mIcon =
        await getBytesFromAsset(iconSrc, Dimensions.locationSize);
    return BitmapDescriptor.fromBytes(mIcon);
  }


  static Future<bool> handleLocationPermission() async {
    // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    // CustomSnackBar.showRowSnackBarError( 'خدمات الموقع معطلة. يرجى تمكين الخدمات');
    //   await Geolocator.openAppSettings();
    //   return false;
    // }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackBar.showRowSnackBarError('تم رفض إذن الموقع');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      CustomSnackBar.showRowSnackBarError(
          'تم رفض إذن الموقع بشكل دائم، لا يمكننا طلب الإذن.');

      return false;
    }
    return true;
  }

  static Future<bool> changePermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    await Geolocator.openAppSettings();
    permission = await Geolocator.checkPermission();
    return permission == LocationPermission.denied
        ? false
        : permission == LocationPermission.deniedForever
            ? false
            : true;
  }
}
