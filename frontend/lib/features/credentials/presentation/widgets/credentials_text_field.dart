import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CredentialsTextField extends StatefulWidget {
  final String hint;
  final String? error;
  final IconData? prefixIcon;
  final bool passwordType;

  final List<TextInputFormatter> inputFormatters;

  final ValueChanged<String>? onChanged;

  const CredentialsTextField({
    required this.hint,
    this.error,
    this.onChanged,
    Key? key,
    this.prefixIcon,
    this.inputFormatters = const [],
    this.passwordType = false,
  }) : super(key: key);

  @override
  State<CredentialsTextField> createState() => _CredentialsTextFieldState();
}

class _CredentialsTextFieldState extends State<CredentialsTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          obscureText: widget.passwordType ? _obscureText : false,
          inputFormatters: widget.inputFormatters,
          key: widget.key,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                    color: (widget.error != null) ? Colors.red : Colors.grey)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                    color: (widget.error != null) ? Colors.red : Colors.grey)),
            hintText: widget.hint,
            prefixIcon: Icon(widget.prefixIcon),
            suffixIcon: widget.passwordType
                ? IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    })
                : null,
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          ),
          onChanged: widget.onChanged,
        ),
        if (widget.error != null) ...{
          Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(widget.error!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[300],
                    )),
              )),
        } else ...{
          Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Text("",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[300],
                  )))
        }
      ],
    );
  }
}
