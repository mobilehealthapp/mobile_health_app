import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  static void logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Icon(Icons.logout,),
        onTap: () => {logout(context)},
      ),
    );
  }
}

