import 'package:departments/features/credentials/presentation/bloc/bloc/login_bloc.dart';
import 'package:departments/features/credentials/presentation/pages/signup_page.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login Title'),
      ),
      body: Container(child: buildBody(context)),
    );
  }

  BlocProvider<LoginBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: Container(
        height: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const Align(
                    alignment: Alignment.center, child: LoginControls()),
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  if (state is Empty) {
                    return Container();
                  } else if (state is Loading) {
                    return Container();
                  } else if (state is Logged) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const StuffPage()));
                    });
                  }
                  return Container();
                }),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignupPage()));
                      });
                    },
                    child: const Text('SignUp'),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
