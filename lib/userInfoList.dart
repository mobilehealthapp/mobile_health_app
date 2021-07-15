import 'package:flutter/material.dart';
import 'package:mobile_health_app/User.dart';
import 'package:provider/provider.dart';

class InfoList extends StatefulWidget {
  const InfoList({Key? key}) : super(key: key);

  @override
  _InfoListState createState() => _InfoListState();
}

class _InfoListState extends State<InfoList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserAddress>?>(context);
    users!.forEach((users) {
      print(users.address);
    });
    return Container();
  }
}
