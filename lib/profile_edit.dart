import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'settings_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String? sexChoose = 'M';

  String first = 'First Name';
  String last = 'Last Name';
  String age = 'Age';
  String dob = 'Date of Birth (DD-MM-YYYY)';
  String meds = 'My Medications';
  String conds = 'My Medical Conditions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              hintLabel: first,
              onChanged: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: last,
              onChanged: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: age,
              onChanged: () {},
            ),
          ),
          DropdownButton<String>(
            value: sexChoose,
            items: [
              DropdownMenuItem(
                child: Text('--Sex--'),
                value: '--Sex--',
              ),
              DropdownMenuItem(
                child: Text('M'),
                value: 'M',
              ),
              DropdownMenuItem(
                child: Text('F'),
                value: 'F',
              ),
              DropdownMenuItem(
                child: Text('X'),
                value: 'X',
              ),
            ],
            onChanged: (value) {
              setState(
                () {
                  sexChoose = value;
                },
              );
            },
          ),
          Expanded(
            child: CustomField(
              hintLabel: dob,
              onChanged: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: conds,
              onChanged: () {},
            ),
          ),
          Expanded(
            child: CustomField(
              hintLabel: meds,
              onChanged: () {},
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
