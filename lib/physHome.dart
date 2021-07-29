import 'package:flutter/material.dart';
import 'package:mobile_health_app/PhysDrawer.dart';
import 'package:mobile_health_app/Constants.dart';
import 'settings_pages/settings_constants.dart';
import 'input_file.dart';

class PhysHome extends StatefulWidget {
  @override
  _PhysHomeState createState() => _PhysHomeState();
}

class _PhysHomeState extends State<PhysHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      drawer: PhysDrawers(),
      appBar: AppBar(
        backgroundColor: kPrimaryColour,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InputFile()));
            },
          )
        ],
        title: Text(
          'Physician Home Page',
          style: kAppBarLabelStyle,
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            PatientCard(
              name: 'Rahat',
              email: 'Email',
            ),
          ],
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  PatientCard({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      name,
                      style: kTextLabel1,
                    ),
                    Container(
                        child: ElevatedButton(
                      onPressed: () {},
                      child: Text(''),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ))
                  ]),
              SizedBox(
                height: 10.0,
              ),
              Text(
                email,
                style: kTextLabel2,
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Text("Average Blood Press : "),
                  Text(''),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
