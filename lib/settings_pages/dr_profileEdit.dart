import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings_constants.dart';

class DrProfileEdit extends StatefulWidget {
  @override
  _DrProfileEditState createState() => _DrProfileEditState();
}

class _DrProfileEditState extends State<DrProfileEdit> {
  String drFirst = 'First Name';
  String drLast = 'Last Name';
  String quali = 'My Qualifications';
  String drTele = 'Telephone Number';
  String drEmail = 'Email Address';
  String drFax = 'Fax';
  String clinicAdd = 'Clinic Address';

  static TextEditingController drFirstTEC = TextEditingController();
  static TextEditingController drLastTEC = TextEditingController();
  static TextEditingController qualiTEC = TextEditingController();
  static TextEditingController drTeleTEC = TextEditingController();
  static TextEditingController drEmailTEC = TextEditingController();
  static TextEditingController drFaxTEC = TextEditingController();
  static TextEditingController clinicAddTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        title: Text(
          'Edit my Information',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00BCD4),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
            ),
          ),
          Expanded(
            child: TextField(
              controller: drFirstTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: drFirst,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: drLastTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: drLast,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: qualiTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: quali,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: drTeleTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: drTele,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: drEmailTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: drEmail,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: drFaxTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: drFax,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: clinicAddTEC,
              decoration: kTextFieldDecoration.copyWith(
                hintText: clinicAdd,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red[900],
                    ),
                    height: 40.0,
                    child: Center(
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(
                      () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.green[300],
                    ),
                    height: 40.0,
                    child: Center(
                      child: Text(
                        'Confirm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(
                      () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
