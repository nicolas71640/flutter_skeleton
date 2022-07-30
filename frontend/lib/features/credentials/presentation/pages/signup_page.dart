import 'package:avecpaulette/features/stuff/presentation/page/stuff_page.dart';
import 'package:flutter/scheduler.dart';
import '../bloc/signup_bloc.dart';
import "../widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Container(child: buildBody(context)),
    );
  }

  BlocProvider<SignupBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignupBloc>(),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SignupControls(),
                BlocBuilder<SignupBloc, SignupState>(
                    buildWhen: (prevState, currState) {
                  if (currState is Logged) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const StuffPage()));
                    });
                  }
                  return currState is! Logged;
                }, builder: (context, state) {
                  if (state is Empty) {
                    return Container();
                  }
                  return Container();
                }),
              ],
            )),
      ),
    );
  }
}
