import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class CredentialsTextField extends StatelessWidget {
  final String hint;
  final String? error;
  final IconData? prefixIcon;

  final ValueChanged<String>? onChanged;

  const CredentialsTextField({
    required this.hint,
    this.error,
    this.onChanged,
    Key? key,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: key,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            hintText: hint,
            prefixIcon: Icon(prefixIcon ?? Icons.done),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          ),
          onChanged: onChanged,
        ),
        if (error != null) ...{
          Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(error!,
                    style: TextStyle(
                      color: Colors.red[300],
                    )),
              )),
        }
      ],
    );
  }
}
