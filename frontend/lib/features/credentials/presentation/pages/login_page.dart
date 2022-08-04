import 'package:avecpaulette/features/credentials/presentation/bloc/login_bloc.dart';
import 'package:avecpaulette/features/credentials/presentation/pages/signup_page.dart';
import 'package:flutter/scheduler.dart';
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
                const FlutterLogo(size: 300),
                const Spacer(),
                const Align(
                    alignment: Alignment.center, child: LoginControls()),
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  if (state is Empty) {
                    return Container();
                  } else if (state is SignInLoading) {
                    return Container();
                  } else if (state is Logged) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const StuffPage()));
                    });
                  }
                  return Container();
                }),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                    onPressed: () {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignupPage()));
                      });
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text("Don't have an accout? ",
                              style: TextStyle(fontWeight: FontWeight.w400)),
                          Text("Sign up now",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]))
              ],
            )),
      ),
    );
  }
}
