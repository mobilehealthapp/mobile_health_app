import 'package:flutter/material.dart';

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
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1B4DA8), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1B4DA8), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1B4DA8), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  hintText: "Your Email",
                  labelText: "Email",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF1B4DA8), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF1B4DA8), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF1B4DA8), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
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
