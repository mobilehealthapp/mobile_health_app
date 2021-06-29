import 'package:flutter/material.dart';
import 'package:mobile_health_app/drawers.dart';

// ignore: camel_case_types
class Profile_Page extends StatelessWidget {
  const Profile_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        title: Text(
          'Profile Page',
        ),
      ),
    );
  }
}
