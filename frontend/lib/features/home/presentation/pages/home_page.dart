import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/home_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final LatLng _center = const LatLng(40.521563, -122.677433);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(child: buildBody(context)),
    );
  }

  BlocProvider<HomeBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(GetLocation()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is LocationReceived) {
            return Center(
              child: GoogleMap(
                  myLocationEnabled: true,
                  key: const Key("home_map"),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(state.locationEntity.latitude,
                        state.locationEntity.longitude),
                    zoom: 11.0,
                  )),
            );
          } else if (state is LocationError) {
            return Center(
              child: GoogleMap(
                  key: const Key("home_map"),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  )),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
