import 'package:departments/features/departmentsViewer/presentation/widgets/widgets.dart';
import 'package:departments/features/stuff/presentation/page/stuff_page.dart';
import 'package:flutter/scheduler.dart';
import '../../../departmentsViewer/presentation/pages/number_trivia_page.dart';
import '../bloc/bloc/signup_bloc.dart';
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
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<SignupBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignupBloc>(),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
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
                    return const Placeholder();
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Error) {
                    return ErrorDisplay(message: state.message);
                  }
                  return const Placeholder();
                }),
              ],
            )),
      ),
    );
  }
}
