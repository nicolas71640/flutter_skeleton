import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/home_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(child: buildBody(context)),
    );
  }

  BlocProvider<HomeBloc> buildBody(BuildContext context) {
    var target = const LatLng(40.521563, -122.677433);
    final Set<Marker> mapMarkers = {};

    return BlocProvider(
      create: (_) => sl<HomeBloc>()
        ..add(GetLocation()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (state is LocationReceived) {
              target = LatLng(state.locationEntity.latitude,
                  state.locationEntity.longitude);
            } else if (state is CottagesUpdate) {
              for (var cottage in state.cottages) {
                mapMarkers.add(Marker(
                    markerId: MarkerId(cottage.title),
                    position: LatLng(cottage.latitude, cottage.longitude)));
              }
            }

            return Center(
              child: GoogleMap(
                  myLocationEnabled: true,
                  key: const Key("home_map"),
                  mapType: MapType.normal,
                  markers: mapMarkers,
                  onMapCreated: (_) =>
                      BlocProvider.of<HomeBloc>(context).add(GetCottages()),
                  initialCameraPosition: CameraPosition(
                    target: target,
                    zoom: 11.0,
                  )),
            );
          }
        },
      ),
    );
  }
}
