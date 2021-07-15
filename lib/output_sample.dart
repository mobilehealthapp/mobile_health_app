import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_health_app/drawers.dart';
import 'package:mobile_health_app/settings_pages/profile_edit.dart';
import 'package:mobile_health_app/welcome_authentication_pages/database.dart';
import 'package:provider/provider.dart';
import 'User.dart';

class OutputData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserAddress>?>.value(
      value: Database().users,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(title: Text('profile example')),
        drawer: Drawers(),
        body: Container(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UserTile(),
                  SizedBox(height: 20.0),
                  Text(
                    'hello',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final UserAddress? add;
  UserTile({this.add});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(add!.address),
    );
  }
}
