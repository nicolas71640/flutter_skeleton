import 'package:avecpaulette/features/credentials/presentation/widgets/rounded_buttond.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/forgotten_password_bloc.dart';
import 'credentials_text_field.dart';

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
            if (state is! Success) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Forgotten password ? ",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    CredentialsTextField(
                      hint: 'Email',
                      prefixIcon: Icons.email,
                      error: (state is Error) ? state.message : null,
                      onChanged: (value) {
                        email = value;
                      },
                      key: const Key("mailForgottenPassword"),
                      inputFormatters: [FilteringTextInputFormatter.deny(" ")],
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: RoundedButton(
                              text: "Send me an email",
                              onPressed: () {
                                BlocProvider.of<ForgottenPasswordBloc>(context)
                                    .add(TrySendForgottenPasswordEmail(
                                        email.toLowerCase()));
                              },
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
                    if (state is Success) ...{const Text("Email Sent")}
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "A new password has been send to your email address",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.center,
                        child: RoundedButton(
                          text: "Ok",
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        )),
                  ],
                ),
              );
            }
          }),
        ));
  }
}
