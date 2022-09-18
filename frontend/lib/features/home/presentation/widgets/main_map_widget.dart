import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/cottage.dart';
import '../bloc/home_bloc.dart';
import '../../../../core/util/asset_utils.dart';

class MainMap extends StatefulWidget {
  const MainMap({
    Key? key,
    required this.cottages,
    required this.target,
  }) : super(key: key);

  final Set<Cottage> cottages;
  final LatLng target;

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  var selectedkey = "";

  Future<Set<Marker>> _generateMarkerList(String selectedKey) async {
    BitmapDescriptor smallMarker =
        await AssetUtils.getBitmapDescriptorFromAssetBytes(
            "assets/small_cottage_marker.png", 35);
    BitmapDescriptor bigMarker =
        await AssetUtils.getBitmapDescriptorFromAssetBytes(
            "assets/big_cottage_marker.png", 50);
    return widget.cottages
        .map((cottage) => Marker(
              position: LatLng(cottage.latitude, cottage.longitude),
              markerId: MarkerId(cottage.title.toString()),
              onTap: () => setState(() => selectedkey = cottage.title),
              icon: selectedKey == cottage.title ? bigMarker : smallMarker,
            ))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _generateMarkerList(selectedkey),
        builder: (context, snapshot) {
          final markers = (snapshot.data as Set<Marker>?) ?? {};
          return GoogleMap(
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              key: const Key("home_map"),
              mapType: MapType.normal,
              markers: markers,
              onMapCreated: (_) =>
                  BlocProvider.of<HomeBloc>(context).add(GetCottages()),
              initialCameraPosition: CameraPosition(
                target: widget.target,
                zoom: 11.0,
              ));
        });
  }
}
