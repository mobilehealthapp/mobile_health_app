import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'settings_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        title: Text(
          'Edit my Information',
          style: GoogleFonts.rubik(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
            ),
          ),
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
            child: CustomField(
              hintLabel: drFirst,
              onSubmitted: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: drLast,
              onSubmitted: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: quali,
              onSubmitted: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: drTele,
              onSubmitted: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: drEmail,
              onSubmitted: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: drFax,
              onSubmitted: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: clinicAdd,
              onSubmitted: () {},
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
