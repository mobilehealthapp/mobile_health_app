import 'package:flutter/material.dart';
import 'package:mobile_health_app/physHome.dart';

class InputFile extends StatefulWidget {
  @override
  _InputFileState createState() => _InputFileState();
}

class _InputFileState extends State<InputFile> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('INPUT'),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.only(top: 150.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Your Name",
                    labelText: "Name",
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Your Email",
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhysHome(
                                name: nameController.text,
                                email: emailController.text,
                              )));
                },
                child: Text('Submit'),
              )
            ],
          ),
        ));
  }
}
