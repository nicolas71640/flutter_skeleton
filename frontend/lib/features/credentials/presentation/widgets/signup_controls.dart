import 'package:avecpaulette/features/credentials/presentation/bloc/bloc/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'credentials_text_field.dart';

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
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CredentialsTextField(
            hint: 'Email',
            prefixIcon: Icons.email,
            onChanged: (value) {
              email = value;
            },
            key: const Key("signup_email"),
          ),
          const SizedBox(height: 10),
          CredentialsTextField(
            hint: 'Password',
            prefixIcon: Icons.lock,
            error: (state is Error) ? state.message : null,
            onChanged: (value) {
              password = value;
            },
            key: const Key("signup_password"),
          ),
          const SizedBox(height: 10.0),
          Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ))),
                    onPressed: () {
                      BlocProvider.of<SignupBloc>(context)
                          .add(TrySignupEvent(email, password));
                    },
                    child: const Text('SignUp'),
                  )),
              if (state is Loading) ...{
                const Positioned.fill(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: AspectRatio(
                                aspectRatio: 1.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                )))))
              }
            ],
          )
        ],
      );
    });
  }
}
