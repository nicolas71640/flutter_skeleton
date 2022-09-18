import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/cottage.dart';
import '../bloc/home_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/main_map_widget.dart';

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
    final Set<Cottage> cottages = {};

    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(GetLocation()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (state is LocationReceived) {
              target = LatLng(state.locationEntity.latitude,
                  state.locationEntity.longitude);
            } else if (state is CottagesUpdate) {
              cottages.addAll(state.cottages);
            }

            return Center(
              child: MainMap(cottages: cottages, target: target),
            );
          }
        },
      ),
    );
  }
}
