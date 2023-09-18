import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_awards/screens/location/components/customize_marker.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({Key? key}) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final Completer<GoogleMapController> mapController = Completer();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  LatLng? selectedPosition;
  String selectedAddress = "";
  String homeStreet = "";
  String country = "";
  bool selected = false;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    markerIcon = await CustomizeLocation.addCustomIcon(AppAssets.activeMarker);
    setState(() {
      selectedPosition = LatLng(position.latitude, position.longitude);
    });
    if (selectedPosition != null) {
      getAddressFromLatLng(selectedPosition!);
    } else {
      setState(() {
        selected = false;
      });
    }
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
        localeIdentifier: 'ar',
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          selected = true;
          country = placemark.administrativeArea ?? placemark.locality ?? '';
          // selectedAddress = '${placemark.locality ?? ''} ${placemark.subLocality ?? ''} '.trim();
          selectedAddress = placemark.subLocality ?? '';
          homeStreet =
              '${placemark.thoroughfare ?? ''} ${placemark.subThoroughfare ?? placemark.name ?? ''}'
                  .trim();
        });
      } else {
        setState(() {
          selected = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(title: "اختر موقعك"),
      body: selectedPosition == null
          ? const Center(
              child: SpinKitChasingDots(
                color: AppUI.primaryColor,
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: selectedPosition!,
                    zoom: 14.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController.complete(controller);
                  },
                  markers: <Marker>{
                    Marker(
                      markerId: const MarkerId('selectedPosition'),
                      position: selectedPosition!,
                      icon: markerIcon,
                      draggable: true,
                      onDragEnd: (newPosition) {
                        setState(() {
                          selectedPosition = newPosition;
                        });
                        getAddressFromLatLng(selectedPosition!);
                      },
                    ),
                  },
                  onTap: (LatLng newPosition) {
                    setState(() {
                      selectedPosition = newPosition;
                    });
                    getAddressFromLatLng(selectedPosition!);
                  },
                ),
                if (selected)
                  Positioned(
                    bottom: Dimensions.padding24,
                    right: Dimensions.padding24 * 2,
                    left: Dimensions.padding24,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.padding24),
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedPosition != null) {
                            final result = {
                              'latitude': selectedPosition!.latitude.toString(),
                              'longitude':
                                  selectedPosition!.longitude.toString(),
                              'address': selectedAddress,
                              'homeStreet': homeStreet,
                              'country': country,
                            };
                            Get.back(result: result);
                          } else {
                            CustomSnackBar.showRowSnackBarError(
                                'حدث خطأ يرجى إعادة المحاولة');
                          }
                        },
                        child: const Text(
                          "حفظ",
                        ),
                      ),
                    ),
                  ),
                if (!selected)
                  Positioned(
                    bottom: Dimensions.padding24,
                    right: Dimensions.padding24 * 2,
                    left: Dimensions.padding24,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.padding24),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppUI.gradient2Color.withOpacity(0.5)),
                        ),
                        onPressed: () {
                          CustomSnackBar.showRowSnackBarError(
                              "يرجى تحديد الموقع");
                        },
                        child: const Text(
                          "حفظ",
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
