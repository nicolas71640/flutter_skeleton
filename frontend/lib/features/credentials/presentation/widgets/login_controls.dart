import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/login_bloc.dart';
import '../pages/signup_page.dart';

class LoginControls extends StatefulWidget {
  const LoginControls({Key? key}) : super(key: key);

  @override
  State<LoginControls> createState() => _LoginControlsState();
}

class _LoginControlsState extends State<LoginControls> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: const Key("login_email"),
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Email'),
          onChanged: (value) {
            email = value;
          },
        ),
        TextField(
          key: const Key("login_password"),
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Password'),
          onChanged: (value) {
            password = value;
          },
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                BlocProvider.of<LoginBloc>(context)
                    .add(TryLoginEvent(email, password));
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignupPage()));
                });
              },
              child: const Text('SignUp'),
            ),
          ],
        ),
      ],
    );
  }
}
