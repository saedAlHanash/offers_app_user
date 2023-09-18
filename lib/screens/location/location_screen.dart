import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_awards/models/provider.dart';
import 'package:offers_awards/screens/location/components/customize_marker.dart';
import 'package:offers_awards/screens/location/components/location_suggestion.dart';
import 'package:offers_awards/screens/widgets/custom_input_decoration.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/services/provider_services.dart';
import 'package:offers_awards/utils/app_assets.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  Key _locationSuggestionKey = UniqueKey();
  late Future<List<Provider>> providers;

  List<Marker> _markers = [];
  LatLng? selectedPosition;
  bool _showLocationDetails = false;
  bool _isLoading = false;
  String _selectedMarkerAddress = '';
  Provider? _selectedProvider;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedMarkerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void getCurrentLocation() async {
    // try {
    await CustomizeLocation.handleLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    markerIcon = await CustomizeLocation.addCustomIcon(AppAssets.activeMarker);
    setState(() {
      selectedPosition = LatLng(position.latitude, position.longitude);
      providers = ProviderServices.fetch(position.latitude, position.longitude)
          .then((value) {
        loadMarkers(value);
        return value;
      });
    });
    // } catch (e) {
    //   CustomDialog.errorLocationDialog(context);
    // }
  }

  Future<void> loadMarkers(List<Provider> list) async {
    markerIcon = await CustomizeLocation.addCustomIcon(AppAssets.marker);
    selectedMarkerIcon =
        await CustomizeLocation.addCustomIcon(AppAssets.activeMarker);
    setState(() {});
    _markers = list.isNotEmpty
        ? list.map((provider) {
            return Marker(
              markerId: MarkerId(provider.id.toString()),
              position: LatLng(provider.latitude, provider.longitude),
              icon: markerIcon,
              onTap: () => onMarkerTapped(provider),
            );
          }).toList()
        : [];
    setState(() {
      _isLoading = false;
    });
  }

  void onMarkerTapped(Provider provider) async {
    try {
      final selectedMarker = _markers.firstWhere(
        (marker) => marker.markerId.value == provider.id.toString(),
      );
      final position = selectedMarker.position;

      final placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'ar',
      );
      if (placeMarks.isNotEmpty) {
        final placemark = placeMarks.first;

        final country = placemark.country ?? '';
        final locality =
            '${placemark.locality ?? placemark.administrativeArea ?? ''} ${placemark.subLocality ?? ''}'
                .trim();
        final thoroughfare =
            '${placemark.thoroughfare ?? ''} ${placemark.subThoroughfare ?? placemark.name ?? ''}'
                .trim();
        final address = '$country $locality $thoroughfare';
        // Move the map to the selected marker's position and zoom level
        final controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: await controller.getZoomLevel(),
          ),
        ));

        updateMarkers(provider.id.toString());
        showLocationDetails(address, provider);
      } else {
        updateMarkers(provider.id.toString());
        hideLocationDetails();
      }
    } catch (e) {
      updateMarkers(provider.id.toString());
      showLocationDetails(
          "${provider.government} ${provider.address}", provider);
    }
  }

  void updateMarkers(String selectedMarkerId) {
    setState(() {
      _markers = _markers.map((marker) {
        final markerId = marker.markerId.value;
        final icon =
            markerId == selectedMarkerId ? selectedMarkerIcon : markerIcon;
        return marker.copyWith(iconParam: icon);
      }).toList();
    });
  }

  void showLocationDetails(String address, Provider provider) {
    setState(() {
      _showLocationDetails = true;
      _selectedMarkerAddress = address;
      _selectedProvider = provider;
      _locationSuggestionKey = UniqueKey();
    });
  }

  void hideLocationDetails() async {
    setState(() {
      _markers = _markers.map((marker) {
        return marker.copyWith(
          iconParam: markerIcon,
        );
      }).toList();
      _selectedMarkerAddress = '';
      _showLocationDetails = false;
    });
  }

  void searchLocation() async {
    final query = _searchController.text;
    setState(() {
      _isLoading = true;
    });

    if (query.isNotEmpty) {
      try {
        // Use geocoding APIs or any location search service to get the search results
        // Search
        List<Location> locations = await locationFromAddress(query);
        if (locations.isNotEmpty) {
          // Move the map to the first location in the search results
          final firstLocation = locations.first;
          selectedPosition =
              LatLng(firstLocation.latitude, firstLocation.longitude);
          final controller = await _controller.future;

          controller.moveCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(firstLocation.latitude, firstLocation.longitude),
              14,
            ),
          );

          setState(() {
            providers = ProviderServices.fetch(
                    firstLocation.latitude, firstLocation.longitude)
                .then((value) {
              loadMarkers(value);
              return value;
            });
          });
        } else {
          // Show "Not Found" message
          CustomSnackBar.showSnackBarError(
              'موقع غير موجود', 'تعذر العثور على الموقع المحدد.');
          setState(() {
            _isLoading = false;
          });
        }
      } catch (exception) {
        // Handle exception
        CustomSnackBar.showSnackBarError(
            'خطأ', 'حدث خطأ أثناء البحث عن الموقع.');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            // bottom: kBottomNavigationBarHeight,
            height: _showLocationDetails
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height,
            child: _isLoading || selectedPosition == null
                ? const Center(
                    child: SpinKitChasingDots(
                      color: AppUI.primaryColor,
                    ),
                  )
                : GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: selectedPosition!,
                      zoom: 14,
                    ),
                    zoomControlsEnabled: false,
                    markers: Set.from(_markers),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
          ),
          Positioned(
            right: Dimensions.padding16,
            left: Dimensions.padding16,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: CustomInputDecoration.search(
                      "ابحث عن اقرب مكان لك", () {
                    searchLocation();
                  }),
                  textInputAction: TextInputAction.search,
                  onTap: () {
                    setState(() {
                      // selectedPosition = null;
                      _showLocationDetails = false;
                    });
                  },
                  onSubmitted: (value) {
                    searchLocation();
                  },
                ),
              ),
            ),
          ),
          if (_showLocationDetails && _selectedProvider != null)
            LocationSuggestion(
              key: _locationSuggestionKey,
              hideLocationDetails: hideLocationDetails,
              locationDetails: _selectedMarkerAddress,
              provider: _selectedProvider!,
            ),
        ],
      ),
    );
  }
}
