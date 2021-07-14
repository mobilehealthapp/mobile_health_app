import 'package:flutter/material.dart';

class AuthenticationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final colour;
  AuthenticationButton(this.label, this.onPressed, this.colour);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 300,
      color: colour,
      height: 50.0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
