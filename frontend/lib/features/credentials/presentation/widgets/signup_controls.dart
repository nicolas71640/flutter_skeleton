import 'package:departments/features/credentials/presentation/bloc/bloc/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupControls extends StatefulWidget {
  const SignupControls({Key? key}) : super(key: key);

  @override
  State<SignupControls> createState() => SignupControlsState();
}

class SignupControlsState extends State<SignupControls> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: const Key("signup_email"),
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Email'),
          onChanged: (value) {
            email = value;
          },
        ),
        TextField(
          key: const Key("signup_password"),
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Password'),
          onChanged: (value) {
            password = value;
          },
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<SignupBloc>(context)
                .add(TrySignupEvent(email, password));
          },
          child: const Text('SignUp'),
        ),
      ],
    );
  }
}
