import 'package:avecpaulette/features/stuff/presentation/bloc/bloc/stuff_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../widgets/get_stuff_controls.dart';

class StuffPage extends StatelessWidget {
  const StuffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stuff Title', key: Key("stuff_title")),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<StuffBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StuffBloc>(),
      child: const Center(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [GetStuffControls()],
            )),
      ),
    );
  }
}
