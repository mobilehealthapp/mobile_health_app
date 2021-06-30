import 'package:flutter/material.dart';
import 'package:mobile_health_app/PhysDrawer.dart';
import 'package:mobile_health_app/Constants.dart';

class PhysHome extends StatelessWidget {
  const PhysHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PhysDrawers(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {},
          )
        ],
        title: Text(
          'Physician Home Page',
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(12.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Patient 1',
                    style: kTextLabel1,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Patient 2',
                    style: kTextLabel1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
