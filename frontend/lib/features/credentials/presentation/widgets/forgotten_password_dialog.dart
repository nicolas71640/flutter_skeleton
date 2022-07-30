import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/forgotten_password_bloc.dart';

class ForgottenPasswordDialog extends StatefulWidget {
  const ForgottenPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ForgottenPasswordDialog> createState() =>
      _ForgottenPasswordDialogState();
}

class _ForgottenPasswordDialogState extends State<ForgottenPasswordDialog> {
  String email = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<ForgottenPasswordBloc>(),
        child: Dialog(
          child: BlocBuilder<ForgottenPasswordBloc, ForgottenPasswordState>(
              builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Forgotten password ? ",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(" ")
                        ],
                        key: const Key("mailForgottenPassword"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.mail),
                          contentPadding: const EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                        ),
                        onChanged: (email) => this.email = email),
                    Builder(builder: (context) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () {
                            BlocProvider.of<ForgottenPasswordBloc>(context).add(
                                TrySendForgottenPasswordEmail(
                                    email.toLowerCase()));
                          },
                          child: const Text('Send me an email'),
                        ),
                      );
                    })
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
