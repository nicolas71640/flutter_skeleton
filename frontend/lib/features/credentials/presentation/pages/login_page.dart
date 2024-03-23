import 'package:avecpaulette/features/credentials/presentation/bloc/login_bloc.dart';
import 'package:avecpaulette/features/credentials/presentation/pages/signup_page.dart';
import 'package:flutter/scheduler.dart';
import '../../../home/presentation/pages/home_page.dart';
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
      body: Container(child: buildBody(context)),
    );
  }

  BlocProvider<LoginBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: SizedBox(
        height: double.infinity,
        child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const FlutterLogo(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LoginControls(),
                      BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                        if (state is Empty) {
                          return Container();
                        } else if (state is SignInLoading) {
                          return Container();
                        } else if (state is Logged) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const HomePage()));
                          });
                        }
                        return Container();
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                            });
                          },
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Don't have an account? ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400)),
                                Text("Sign up now",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ]))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
