import 'package:departments/features/credentials/presentation/bloc/bloc/login_bloc.dart';
import 'package:flutter/scheduler.dart';
import '../../../departmentsViewer/presentation/widgets/widgets.dart';
import '../../../stuff/presentation/page/stuff_page.dart';
import "../widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Title'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<LoginBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const LoginControls(),
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  if (state is Empty) {
                    return const Placeholder();
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Error) {
                    return ErrorDisplay(message: state.message);
                  } else if (state is Logged) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const StuffPage()));
                    });
                  }
                  return const Placeholder();
                }),
              ],
            )),
      ),
    );
  }
}
