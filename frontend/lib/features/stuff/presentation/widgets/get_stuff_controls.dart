import 'package:avecpaulette/features/stuff/presentation/bloc/bloc/stuff_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetStuffControls extends StatefulWidget {
  const GetStuffControls({Key? key}) : super(key: key);

  @override
  State<GetStuffControls> createState() => _GetStuffControlsState();
}

class _GetStuffControlsState extends State<GetStuffControls> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          BlocProvider.of<StuffBloc>(context).add(GetStuffEvent());
        },
        child: const Text("Get Stuff"));
  }
}
