import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/cottage.dart';
import '../bloc/home_bloc.dart';
import '../../../../core/util/asset_utils.dart';

typedef OnCottageSelected = void Function(Cottage cottage);

class MapWidget extends StatefulWidget {
  const MapWidget(
      {Key? key,
      required this.cottages,
      required this.target,
      this.onCottageSelected,
      required this.simpleMapController})
      : super(key: key);

  final Set<Cottage> cottages;
  final LatLng target;
  final OnCottageSelected? onCottageSelected;
  final SimpleMapController simpleMapController;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  var selectedkey = "";
  GoogleMapController? mapController;

  _MapWidgetState();

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
              onTap: () => setState(() {
                selectedkey = cottage.title;
                widget.onCottageSelected?.call(cottage);
              }),
              icon: selectedKey == cottage.title ? bigMarker : smallMarker,
            ))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: widget.target, zoom: 11)));

    widget.simpleMapController.addListener(() {
      setState(() {
        selectedkey = widget.simpleMapController.markerId;
      });
    });

    return FutureBuilder(
        future: _generateMarkerList(selectedkey),
        builder: (context, snapshot) {
          final markers = (snapshot.data as Set<Marker>?) ?? {};
          return GoogleMap(
              onTap: (argument) =>
                  FocusScope.of(context).requestFocus(FocusNode()),
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              mapType: MapType.normal,
              markers: markers,
              onMapCreated: (controller) {
                mapController = controller;
                if (mounted) {
                  BlocProvider.of<HomeBloc>(context).add(GetCottages());
                }
              },
              initialCameraPosition: CameraPosition(
                target: widget.target,
                zoom: 11.0,
              ));
        });
  }
}

class SimpleMapController extends ChangeNotifier {
  String markerId = "";

  void selectMarker(String markerId) {
    this.markerId = markerId;
    notifyListeners();
  }
}
