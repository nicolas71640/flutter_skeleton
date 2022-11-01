import 'package:avecpaulette/features/home/presentation/widgets/main_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/cottage.dart';
import '../bloc/home_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(child: buildBody(context))),
    );
  }

  BlocProvider<HomeBloc> buildBody(BuildContext context) {
    var target = const LatLng(40.521563, -122.677433);
    final Set<Cottage> cottages = {};

    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(GetLocation()),
      child: Stack(
        children: [
          BlocBuilder<HomeBloc, HomeState>(
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

                return MainMap(
                    key: const Key("home_map"),
                    cottages: cottages,
                    target: target);
              }
            },
          ),
        ],
      ),
    );
  }
}
