import 'package:flutter/material.dart';

class PassTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Icon prefixIcon;

  const PassTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.prefixIcon,
    required this.label,
  });

  @override
  State<PassTextField> createState() => _PassTextFieldState();
}

class _PassTextFieldState extends State<PassTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).secondaryHeaderColor),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).secondaryHeaderColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          fillColor: Theme.of(context).secondaryHeaderColor,
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          hintText: widget.label,
          prefixIcon: widget.prefixIcon,
          prefixIconColor: Colors.black,
          hintStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
