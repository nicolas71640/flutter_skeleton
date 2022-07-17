import 'package:departments/features/credentials/presentation/widgets/credentials_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/login_bloc.dart';

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
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Column(
        children: [
          CredentialsTextField(
            hint: 'Email',
            prefixIcon: Icons.email,
            onChanged: (value) {
              email = value;
            },
            key: const Key("login_email"),
          ),
          const SizedBox(height: 10),
          CredentialsTextField(
            hint: 'Password',
            prefixIcon: Icons.lock,
            error: (state is Error) ? state.message : null,
            onChanged: (value) {
              password = value;
            },
            key: const Key("login_password"),
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
                      BlocProvider.of<LoginBloc>(context)
                          .add(TryLoginEvent(email, password));
                    },
                    child: const Text('Login'),
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
          ),
          const SizedBox(height: 20.0),
          Row(children: const [
            Expanded(
                child: Divider(
              color: Colors.grey,
              thickness: 1,
            )),
            Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text("OR")),
            Expanded(
                child: Divider(
              color: Colors.grey,
              thickness: 1,
            )),
          ]),
          const SizedBox(height: 20.0),
          TextButton.icon(
            icon: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: SizedBox(
                    height: 20, child: Image.asset("assets/google.png"))),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade300),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ))),
            onPressed: () {},
            label: const Padding(padding: EdgeInsets.only(right: 10), child: Text('Sign in with Google')),
          )
        ],
      );
    });
  }
}
