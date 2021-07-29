import 'package:flutter/material.dart';
import 'main.dart';

class InputFile extends StatefulWidget {
  @override
  _InputFileState createState() => _InputFileState();
}

class _InputFileState extends State<InputFile> {
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColour,
          title: Text('INPUT'),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.only(top: 150.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _name,
                decoration: InputDecoration(
                    hintText: "Your Name",
                    labelText: "Name",
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  hintText: "Your Email",
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: Text('Submit'),
              )
            ],
          ),
        ));
  }
}
