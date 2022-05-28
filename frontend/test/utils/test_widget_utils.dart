import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget createWidgetUnderTest(Widget widget) {
  return MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  );
}

Widget createWidgetUnderTestWithBloc<T extends Bloc>(Widget widget, T bloc) {
  return MaterialApp(
    home: BlocProvider<T>(
      create: (_) => bloc,
      child: Scaffold(body: widget),
    ),
  );
}
