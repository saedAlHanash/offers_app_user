import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:offers_awards/models/provider.dart';
import 'package:offers_awards/screens/location/components/customize_marker.dart';
import 'package:offers_awards/screens/widgets/custom_app_bar.dart';
import 'package:offers_awards/utils/app_assets.dart';

class ProviderMapScreen extends StatefulWidget {
  final Provider provider;

  const ProviderMapScreen({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<ProviderMapScreen> createState() => _ProviderMapScreenState();
}

class _ProviderMapScreenState extends State<ProviderMapScreen> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    _loadMarker();
    super.initState();
  }

  void _loadMarker() async {
    markerIcon = await CustomizeLocation.addCustomIcon(
        AppAssets.activeMarker);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(title: "عنوان التاجر"),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.provider.latitude, widget.provider.longitude),
          zoom: 15.0,
        ),
        markers: <Marker>{
          Marker(
            markerId: const MarkerId('provider_location'),
            position:
                LatLng(widget.provider.latitude, widget.provider.longitude),
            icon: markerIcon,
            infoWindow: InfoWindow(title: widget.provider.name),
          ),
        },
      ),
    );
  }
}
