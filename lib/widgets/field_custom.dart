import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  
  final String? labelText;

  final TextEditingController controller;
  
  final String? Function(String?)? validator;

  final Widget? prefixIcon;

  const PasswordField({super.key, this.prefixIcon, this.labelText, required this.controller, this.validator});

  @override
  State<StatefulWidget> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: passwordVisible,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
        ),
        prefixIcon: widget.prefixIcon,
      ),
      validator: widget.validator,
    );
  }
}
